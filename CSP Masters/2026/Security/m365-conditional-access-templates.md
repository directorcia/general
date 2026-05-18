# Conditional Access Template Set — SMB MSP Baseline

**For:** Entra ID P1 (most templates) and Entra ID P2 (risk-based templates marked **P2**).  
**Naming convention:** `CA[NN] - [Persona] - [Action] - [Target]` — e.g. `CA01 - All - Block - Legacy auth`.  
**Deployment order:** create everything in **Report-only** first. Pilot on a single test user / group, then enable in waves over 2 weeks. Never deploy and forget — review monthly.

> **Exclusion group:** every policy that grants or blocks must exclude `BG-EmergencyAccess` (your two break-glass accounts). This is the single most common cause of tenant lockout. Build the group first.

---

## Persona / group model (build these first)

| Group | Purpose |
|---|---|
| `BG-EmergencyAccess` | 2x break-glass accounts. Excluded from **every** CA policy. |
| `CA-AllUsers` | Dynamic — all member users. |
| `CA-Admins` | Dynamic on assigned directory roles (or static for PIM-eligible). |
| `CA-Guests` | Dynamic — `user.userType -eq "Guest"`. |
| `CA-ServiceAccounts` | Static — accounts that genuinely cannot use MFA (rare; document each). |
| `CA-CAExcept-Temp` | Empty by default — temporary exclusions, reviewed weekly. |
| `CA-Pilot` | Pilot users for new policies. |

---

## CA01 — Block legacy authentication (all users)

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | All cloud apps |
| **Conditions** | Client apps → Exchange ActiveSync + Other clients |
| **Grant** | **Block access** |
| **State** | On |

**Why:** Basic auth bypasses MFA. Closes the single largest identity attack vector.  
**E8 / Blueprint:** E8 ML1 (multifactor), ASD Blueprint M.A.1.

---

## CA02 — Require MFA for all users

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess`, `CA-ServiceAccounts`, `CA-Guests` (covered by CA06) |
| **Cloud apps** | All cloud apps |
| **Conditions** | (none — applies everywhere) |
| **Grant** | Require multifactor authentication |
| **Session** | Sign-in frequency: 30 days (or per customer policy); Persistent browser: Never persistent (for shared/unmanaged) |
| **State** | On |

**Why:** Baseline identity assurance.  
**E8 / Blueprint:** E8 ML1, ASD Blueprint M.A.1.

---

## CA03 — Require phishing-resistant MFA for admins

| Field | Value |
|---|---|
| **Users** | Include: directory roles — Global Admin, Privileged Role Admin, Security Admin, Exchange Admin, SharePoint Admin, User Admin, Conditional Access Admin, Application Admin, Cloud App Admin, Authentication Admin, Helpdesk Admin, Billing Admin · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | All cloud apps |
| **Grant** | Require **authentication strength** → "Phishing-resistant MFA" |
| **Session** | Sign-in frequency: 4 hours |
| **State** | On |

**Why:** Admin accounts are crown jewels. Push MFA is phishable via real-time relay — FIDO2/Windows Hello/cert is not.  
**E8 / Blueprint:** E8 ML2 (phishing-resistant), ASD Blueprint M.A.5.

---

## CA04 — Require compliant or hybrid-joined device for admins

| Field | Value |
|---|---|
| **Users** | Same admin role set as CA03 · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | All cloud apps |
| **Grant** | Require device to be marked as compliant **OR** Hybrid Azure AD joined |
| **State** | On |

**Why:** Stops admin activity from an unmanaged personal device.  
**E8 / Blueprint:** E8 ML2 (restrict admin privileges).

---

## CA05 — Require MFA for risky sign-ins **(P2)**

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | All cloud apps |
| **Conditions** | Sign-in risk: Medium and High |
| **Grant** | Require multifactor authentication |
| **State** | On |

**Why:** Step up auth when Identity Protection sees something off.

---

## CA06 — Force secure password change on user risk **(P2)**

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess`, `CA-Guests` |
| **Cloud apps** | All cloud apps |
| **Conditions** | User risk: High |
| **Grant** | Require multifactor authentication **AND** require password change |
| **State** | On |

**Why:** Compromised credential signal → immediate rotation.

---

## CA07 — Require MFA + terms of use for guests / external users

| Field | Value |
|---|---|
| **Users** | Include: All guest and external users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | All cloud apps |
| **Grant** | Require multifactor authentication · Require terms of use (if published) |
| **Session** | Sign-in frequency: every time (or 1 day) |
| **State** | On |

**Why:** External identities are MFA-enforced on their home tenant in theory — but you cannot trust someone else's posture. Require it on yours.

---

## CA08 — Block sign-in from disallowed countries

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | All cloud apps |
| **Conditions** | Locations: include "Blocked countries" named location (DPRK, Russia, Iran, etc., plus any country the customer never operates in) |
| **Grant** | **Block access** |
| **State** | On |

**Why:** Cuts a large slice of opportunistic and state-sponsored noise. Combine with **CA09** to enforce travel exception workflow.  
**Caveat:** Customers with travelling staff need a named-location travel exception — document the process.

---

## CA09 — Require MFA for sign-in outside trusted locations

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | All cloud apps |
| **Conditions** | Locations: Include Any location, Exclude trusted named locations |
| **Grant** | Require multifactor authentication · Require authenticator app (number match) |
| **State** | On |

**Why:** Trusted IP gets a smoother experience; everywhere else gets challenged.

---

## CA10 — Block device code flow

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess`, `CA-CAExcept-Temp` (for kiosk/headless edge cases) |
| **Cloud apps** | All cloud apps |
| **Conditions** | Authentication flows: Device code flow |
| **Grant** | **Block access** |
| **State** | On |

**Why:** Device code phishing has exploded in 2024–2026. Block unless you have a real use case.

---

## CA11 — Block authentication transfer (QR / cross-device)

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | All cloud apps |
| **Conditions** | Authentication flows: Authentication transfer |
| **Grant** | **Block access** |
| **State** | On |

**Why:** Similar phishing risk to device code. Disable unless explicitly required (e.g. Teams Rooms onboarding).

---

## CA12 — Require app protection policy on mobile (MAM)

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | Office 365, Exchange Online, SharePoint, Teams |
| **Conditions** | Device platforms: iOS, Android · Client apps: Mobile apps and desktop clients |
| **Grant** | Require approved client app · Require app protection policy |
| **State** | On |

**Why:** BYOD without enrolment — encrypt corporate data inside Office apps, block copy/paste to personal apps, allow remote wipe of corp data.

---

## CA13 — Block unmanaged Windows / macOS desktop access to data

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | Office 365, SharePoint, Exchange Online |
| **Conditions** | Device platforms: Windows, macOS · Client apps: Mobile apps and desktop clients |
| **Grant** | Require device to be marked as compliant OR Hybrid Azure AD joined |
| **State** | On |

**Why:** Allow browser (with restrictions — see CA14), block sync clients on personal kit.

---

## CA14 — Restrict browser session on unmanaged devices

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess`, `CA-Admins` |
| **Cloud apps** | Office 365, SharePoint, Exchange Online |
| **Conditions** | Device platforms: Windows, macOS · Client apps: Browser · Device filter: `device.trustType -ne "ServerAD"` and `device.isCompliant -ne True` |
| **Session** | Use Conditional Access App Control (Defender for Cloud Apps) → "Block downloads" · OR Application enforced restrictions for SharePoint/Exchange |
| **State** | On |

**Why:** Browser-only, no download, no print, no sync — safe BYOD pattern.

---

## CA15 — Require MFA for Azure / Microsoft admin portals

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | Microsoft Admin Portals (resource selector — includes Azure portal, Entra admin centre, M365 admin, Intune, Defender, Exchange admin) |
| **Grant** | Require multifactor authentication · Require authentication strength: Phishing-resistant |
| **Session** | Sign-in frequency: 1 hour |
| **State** | On |

**Why:** Belt-and-braces on admin surfaces, even for non-admin curious users.

---

## CA16 — Block access for unsupported device platforms

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | All cloud apps |
| **Conditions** | Device platforms: Include Any device, Exclude Windows, macOS, iOS, Android, Linux (platforms you support) |
| **Grant** | **Block access** |
| **State** | On |

**Why:** Stops sign-ins from platforms you have no compliance signal for (Chrome OS, Windows Phone, weird IoT user agents).

---

## CA17 — Session: persistent browser disabled

Apply as a **session control** on CA02 or as standalone — depends on customer culture. Recommended: persistent browser session = Never persistent. Forces re-auth after browser close on shared/unmanaged.

---

## CA18 — Require token protection for sign-in (Windows) **(preview/E5)**

| Field | Value |
|---|---|
| **Users** | Include: All users · Exclude: `BG-EmergencyAccess` |
| **Cloud apps** | Exchange Online, SharePoint Online |
| **Conditions** | Device platforms: Windows · Client apps: Mobile apps and desktop clients |
| **Session** | Require token protection for sign-in sessions |
| **State** | On |

**Why:** Binds the refresh token to the device. Stops token theft replay attacks (pass-the-cookie).

---

## CA19 — Workload identity Conditional Access **(Workload Identities Premium)**

| Field | Value |
|---|---|
| **Workload identities** | Selected service principals (third-party apps, MSP automation accounts) |
| **Cloud apps** | All cloud apps |
| **Conditions** | Locations: exclude trusted IPs |
| **Grant** | **Block access** |
| **State** | On |

**Why:** Pin service principal sign-ins to known infrastructure IPs. Stops stolen secrets being used from attacker IPs.

---

## CA20 — Report-only canary policy

Keep one policy permanently in **Report-only** that targets a "what-if" rule set. Useful for testing tighter controls (e.g. require Hybrid join for all) without enforcing.

---

## Deployment checklist

☐ Break-glass group created and excluded from every policy  
☐ Break-glass accounts: complex password offline, FIDO2 key in safe, alert on use  
☐ Named locations defined (trusted offices, blocked countries)  
☐ All policies created **Report-only**, run for ≥7 days  
☐ Sign-in logs reviewed: who would have been blocked?  
☐ Exceptions captured in `CA-CAExcept-Temp` with expiry dates  
☐ Pilot group enabled for 1 week  
☐ Full rollout over 2 weeks, one persona at a time  
☐ Policy export saved (Graph: `/identity/conditionalAccess/policies`) and committed to source control  
☐ Monthly review — drift, new policies needed, exception expiry  

---

## Export & backup

```powershell
Connect-MgGraph -Scopes "Policy.Read.All"
Get-MgIdentityConditionalAccessPolicy -All |
    ConvertTo-Json -Depth 20 |
    Out-File ".\CA-Policies-$(Get-Date -Format yyyyMMdd).json"
```

Store the export in the customer's IT documentation system **and** in your MSP source-controlled config repo.

---

## What this set does NOT cover (call out to customers)

- Service account hardening (managed identities where possible)
- Token theft beyond Token Protection (consider MDE + sign-in risk)
- Application-specific CA (Salesforce, ServiceNow, etc.) — separate policies
- Per-app authentication context (E5 / governance scenarios)
- Insider threat (Purview Insider Risk Management)

---

*Maintained by [your MSP]. Version: 2026-05.*
