# M365 Security KQL Hunting Pack — SMB MSP

**For:** Microsoft Sentinel and Microsoft Defender XDR Advanced Hunting.  
**Note:** Sentinel queries use Entra logs (`SigninLogs`, `AuditLogs`, `OfficeActivity`). Defender XDR queries use the unified hunting schema (`IdentityLogonEvents`, `EmailEvents`, `DeviceProcessEvents`, etc.). Each section flags which schema applies.

> **How to use:** copy a query into the Logs / Advanced Hunting blade, adjust the time window, tune thresholds for the tenant, then save as a hunting query or convert to an analytics/custom detection rule.

---

## 1. Identity & Sign-in

### 1.1 — Impossible travel (Sentinel)
Two successful sign-ins from countries impossible to traverse in the elapsed time.

```kql
SigninLogs
| where TimeGenerated > ago(7d)
| where ResultType == 0
| where isnotempty(LocationDetails.countryOrRegion)
| extend Country = tostring(LocationDetails.countryOrRegion)
| summarize Logins = make_list(pack("time", TimeGenerated, "country", Country, "ip", IPAddress, "app", AppDisplayName)) by UserPrincipalName
| mv-expand a = Logins, b = Logins
| where tostring(a.country) != tostring(b.country)
| where todatetime(b.time) - todatetime(a.time) between (1min .. 4h)
| project UserPrincipalName, From = a, To = b
```

### 1.2 — MFA fatigue / push-bombing (Sentinel)
≥5 MFA prompts to one user in 10 minutes.

```kql
SigninLogs
| where TimeGenerated > ago(1d)
| where ResultType in (50074, 50076, 50158, 500121, 50140)
| summarize Prompts = count(), IPs = make_set(IPAddress), Apps = make_set(AppDisplayName)
    by UserPrincipalName, bin(TimeGenerated, 10m)
| where Prompts >= 5
```

### 1.3 — Legacy authentication still in use (Sentinel)
Catches anything still hitting basic auth endpoints despite the global block.

```kql
SigninLogs
| where TimeGenerated > ago(30d)
| where ClientAppUsed in ("Other clients", "IMAP4", "POP3", "SMTP", "Authenticated SMTP", "Exchange ActiveSync", "Exchange Web Services", "AutoDiscover")
| summarize Count = count(), Apps = make_set(ClientAppUsed), Status = make_set(ResultType)
    by UserPrincipalName, IPAddress
| order by Count desc
```

### 1.4 — Password spray (Sentinel)
Same source IP, many usernames, mostly failed sign-ins.

```kql
SigninLogs
| where TimeGenerated > ago(1d)
| where ResultType !in (0, 50053, 50055, 50057)
| summarize FailedUsers = dcount(UserPrincipalName), Attempts = count(),
            Users = make_set(UserPrincipalName, 50)
    by IPAddress, bin(TimeGenerated, 1h)
| where FailedUsers >= 10
| order by FailedUsers desc
```

### 1.5 — Risky sign-in followed by success (Defender XDR)
Detected risk, then a successful sign-in from the same user within 1 hour.

```kql
AADSignInEventsBeta
| where Timestamp > ago(7d)
| where RiskLevelDuringSignIn in (50, 100)
| project RiskTime = Timestamp, AccountUpn, IPAddress, RiskLevelDuringSignIn
| join kind=inner (
    AADSignInEventsBeta
    | where Timestamp > ago(7d)
    | where ErrorCode == 0
    | project SuccessTime = Timestamp, AccountUpn, SuccessIP = IPAddress, AppDisplayName
) on AccountUpn
| where SuccessTime between (RiskTime .. RiskTime + 1h)
```

### 1.6 — Sign-in from anonymous / Tor IP (Sentinel)

```kql
SigninLogs
| where TimeGenerated > ago(7d)
| extend RiskEvents = tostring(RiskEventTypes_V2)
| where RiskEvents has_any ("anonymizedIPAddress", "tor")
| project TimeGenerated, UserPrincipalName, IPAddress, Location, AppDisplayName, RiskEvents
```

---

## 2. Privileged Actions & Admin Activity

### 2.1 — New Global Administrator (Sentinel)
Role assignment to a top-tier role.

```kql
AuditLogs
| where TimeGenerated > ago(30d)
| where OperationName == "Add member to role"
| extend RoleName = tostring(TargetResources[0].modifiedProperties[1].newValue)
| where RoleName has_any ("Global Administrator", "Privileged Role Administrator", "Privileged Authentication Administrator", "Application Administrator", "Cloud Application Administrator")
| project TimeGenerated, Initiator = InitiatedBy.user.userPrincipalName,
          Target = tostring(TargetResources[0].userPrincipalName), RoleName, CorrelationId
```

### 2.2 — Conditional Access policy changed (Sentinel)

```kql
AuditLogs
| where TimeGenerated > ago(30d)
| where Category == "Policy"
| where OperationName has_any ("Add conditional access policy", "Update conditional access policy", "Delete conditional access policy")
| project TimeGenerated, OperationName, Initiator = InitiatedBy.user.userPrincipalName,
          Policy = tostring(TargetResources[0].displayName), Result, AdditionalDetails
```

### 2.3 — Break-glass account used (Sentinel)
Replace the UPN list with your tenant's emergency accounts.

```kql
let BreakGlass = dynamic(["bg1@yourtenant.onmicrosoft.com","bg2@yourtenant.onmicrosoft.com"]);
SigninLogs
| where TimeGenerated > ago(7d)
| where tolower(UserPrincipalName) in (BreakGlass)
| project TimeGenerated, UserPrincipalName, IPAddress, Location, AppDisplayName, ResultType
```

### 2.4 — Service principal credential added (Sentinel)
A common persistence technique post-compromise.

```kql
AuditLogs
| where TimeGenerated > ago(30d)
| where OperationName in ("Add service principal credentials", "Update application – Certificates and secrets management")
| project TimeGenerated, Initiator = InitiatedBy.user.userPrincipalName,
          App = tostring(TargetResources[0].displayName), AdditionalDetails
```

### 2.5 — High-privilege OAuth consent grant (Sentinel)

```kql
AuditLogs
| where TimeGenerated > ago(30d)
| where OperationName == "Consent to application"
| extend Props = parse_json(tostring(TargetResources[0].modifiedProperties))
| mv-expand Props
| extend Scope = tostring(Props.newValue)
| where Scope has_any ("Mail.ReadWrite", "Mail.Send", "Files.ReadWrite.All", "Sites.FullControl.All",
                      "Directory.ReadWrite.All", "User.ReadWrite.All", "full_access_as_app")
| project TimeGenerated, Initiator = InitiatedBy.user.userPrincipalName,
          App = tostring(TargetResources[0].displayName), Scope
```

---

## 3. Email & BEC

### 3.1 — New inbox forwarding rule (Defender XDR)

```kql
CloudAppEvents
| where Timestamp > ago(30d)
| where ActionType in ("New-InboxRule", "Set-InboxRule", "Set-Mailbox")
| extend RawProps = tostring(RawEventData)
| where RawProps has_any ("ForwardTo", "ForwardAsAttachmentTo", "RedirectTo", "ForwardingSmtpAddress", "DeleteMessage")
| project Timestamp, AccountId, AccountDisplayName, ActionType, RawProps
```

### 3.2 — Suspicious mailbox rule keywords (Sentinel)
Attackers commonly create rules that move replies from "bank", "invoice", "password" into Deleted/RSS.

```kql
OfficeActivity
| where TimeGenerated > ago(30d)
| where Operation in ("New-InboxRule", "Set-InboxRule")
| extend Params = tostring(Parameters)
| where Params has_any ("invoice","bank","password","payment","wire","ACH","credentials","admin","helpdesk","payroll")
       or Params has_any ("MoveToFolder", "DeleteMessage", "MarkAsRead")
| project TimeGenerated, UserId, Operation, ClientIP, Params
```

### 3.3 — Mass external email send (Defender XDR)
Possible compromised mailbox sending phishing outbound.

```kql
EmailEvents
| where Timestamp > ago(1d)
| where EmailDirection == "Outbound"
| summarize Recipients = dcount(RecipientEmailAddress), Subjects = make_set(Subject, 10)
    by SenderFromAddress, bin(Timestamp, 1h)
| where Recipients >= 50
| order by Recipients desc
```

### 3.4 — Email containing malicious URL clicked (Defender XDR)

```kql
UrlClickEvents
| where Timestamp > ago(7d)
| where ThreatTypes != ""
| where ActionType == "ClickAllowed"
| project Timestamp, AccountUpn, Url, ThreatTypes, NetworkMessageId
| join kind=leftouter (EmailEvents | project NetworkMessageId, Subject, SenderFromAddress)
    on NetworkMessageId
```

### 3.5 — Recently registered lookalike domain sender (Defender XDR)
Surface inbound from suspicious newly-seen sender domains.

```kql
EmailEvents
| where Timestamp > ago(7d)
| where EmailDirection == "Inbound"
| where DeliveryAction == "Delivered"
| extend SenderDomain = tolower(tostring(split(SenderFromAddress, "@")[1]))
| summarize FirstSeen = min(Timestamp), Volume = count() by SenderDomain
| where FirstSeen > ago(7d)
| where Volume < 20  // new + low-volume = suspicious
| order by FirstSeen desc
```

---

## 4. Endpoint & Defender for Endpoint

### 4.1 — LOLBins spawned by Office (Defender XDR)

```kql
DeviceProcessEvents
| where Timestamp > ago(7d)
| where InitiatingProcessFileName in~ ("winword.exe","excel.exe","powerpnt.exe","outlook.exe")
| where FileName in~ ("powershell.exe","cmd.exe","wscript.exe","cscript.exe","mshta.exe","regsvr32.exe","rundll32.exe","bitsadmin.exe","certutil.exe")
| project Timestamp, DeviceName, AccountName, InitiatingProcessFileName, FileName, ProcessCommandLine
```

### 4.2 — Encoded PowerShell (Defender XDR)

```kql
DeviceProcessEvents
| where Timestamp > ago(7d)
| where FileName =~ "powershell.exe"
| where ProcessCommandLine has_any ("-enc","-EncodedCommand","FromBase64String","IEX","Invoke-Expression","DownloadString","-w hidden","-nop")
| project Timestamp, DeviceName, AccountName, ProcessCommandLine, InitiatingProcessFileName
```

### 4.3 — New persistence — scheduled task / run key (Defender XDR)

```kql
DeviceRegistryEvents
| where Timestamp > ago(7d)
| where RegistryKey has_any (@"\Run", @"\RunOnce", @"\Image File Execution Options")
| project Timestamp, DeviceName, RegistryKey, RegistryValueName, RegistryValueData, InitiatingProcessFileName, InitiatingProcessCommandLine
```

### 4.4 — RDP brute force on managed endpoints (Defender XDR)

```kql
DeviceLogonEvents
| where Timestamp > ago(7d)
| where LogonType == "RemoteInteractive"
| where ActionType == "LogonFailed"
| summarize Failures = count(), Accounts = make_set(AccountName)
    by DeviceName, RemoteIP, bin(Timestamp, 1h)
| where Failures >= 10
```

### 4.5 — Disabled / tampered Defender (Defender XDR)

```kql
DeviceEvents
| where Timestamp > ago(7d)
| where ActionType in ("AntivirusDisabled","TamperingAttempt","DefenderTamperProtectionAlert","AntivirusDefinitionsUpdated")
| project Timestamp, DeviceName, ActionType, AdditionalFields
```

---

## 5. Data & Sharing

### 5.1 — Mass file download from SharePoint/OneDrive (Sentinel)

```kql
OfficeActivity
| where TimeGenerated > ago(1d)
| where Operation in ("FileDownloaded","FileSyncDownloadedFull")
| summarize Files = count(), Sites = dcount(Site_Url), Sizes = sum(toint(Size))
    by UserId, ClientIP, bin(TimeGenerated, 1h)
| where Files >= 200
```

### 5.2 — Anonymous link created on sensitive content (Sentinel)

```kql
OfficeActivity
| where TimeGenerated > ago(7d)
| where Operation in ("SharingSet","AnonymousLinkCreated","SecureLinkCreated")
| where EventData has "Anonymous" or EventData has "ShareLink"
| project TimeGenerated, UserId, Operation, OfficeObjectId, Site_Url, ClientIP
```

### 5.3 — External user added to many sites (Sentinel)

```kql
OfficeActivity
| where TimeGenerated > ago(7d)
| where Operation == "SharingInvitationCreated"
| extend TargetUser = tostring(TargetUserOrGroupName)
| where TargetUser has "#EXT#" or TargetUser has "@"
| summarize Invites = count(), Sites = dcount(Site_Url) by UserId, TargetUser
| where Invites >= 10
```

---

## 6. Cloud Apps & Workload Identities

### 6.1 — App granted admin consent for high-privilege scope (Sentinel)

```kql
AuditLogs
| where TimeGenerated > ago(30d)
| where OperationName has "consent" and Result == "success"
| extend Permissions = tostring(parse_json(tostring(TargetResources[0].modifiedProperties))[0].newValue)
| where Permissions has_any (".ReadWrite.All", "FullControl", "AccessAsUser.All", "Mail.Send")
| project TimeGenerated, InitiatedBy, App = tostring(TargetResources[0].displayName), Permissions
```

### 6.2 — Service principal sign-in from new IP (Sentinel)

```kql
AADServicePrincipalSignInLogs
| where TimeGenerated > ago(14d)
| summarize FirstSeen = min(TimeGenerated), Count = count() by ServicePrincipalName, IPAddress
| where FirstSeen > ago(1d) and Count < 10
| order by FirstSeen desc
```

---

## 7. Useful "first day" hunts for a new tenant

Run these on day one of onboarding to find inherited risk:

| # | What | Where |
|---|---|---|
| 1 | All accounts with admin role but no MFA registered | Entra ID > Authentication methods activity |
| 2 | Mailboxes with external forwarding configured | `Get-Mailbox -ResultSize Unlimited \| ? {$_.ForwardingSmtpAddress -or $_.ForwardingAddress}` |
| 3 | Enterprise apps with admin consent older than 12 months | AuditLogs query 2.5 with 365d window |
| 4 | Stale guests (last sign-in >90d) | SigninLogs by guest UPN |
| 5 | Sign-ins from countries the customer does not operate in | SigninLogs grouped by country |
| 6 | Devices with no MDE onboarding | `DeviceInfo \| where OnboardingStatus != "Onboarded"` |
| 7 | Mailbox rules created by non-owner | OfficeActivity Operation == "New-InboxRule" with UserType != "Regular" |

---

## Maintenance

- Re-tune thresholds monthly — every tenant differs.
- Convert frequently-firing hunts into **Analytics rules** (Sentinel) or **Custom detections** (Defender XDR).
- Document false-positive suppressions in your runbook.
- Pair every detection with an **incident response playbook** — the alert is only useful if the response is rehearsed.

*Maintained by [your MSP]. Version: 2026-05.*
