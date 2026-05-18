# M365 Security Baseline Checklist — SMB MSP

**Audience:** L1–L3 MSP technicians  
**Use:** Onboarding a new tenant, quarterly review, or post-incident hardening pass.  
**Alignment:** Essential 8 Maturity Level 1–2, ASD M365 Blueprint, CIS M365 Foundations Benchmark v3.

> **Legend:** ☐ Required (E8 ML1 / CIS L1) · ◻ Recommended (E8 ML2 / CIS L2) · ◇ Advanced (E5, mature MSP)  
> Tick the box, record the date and the tech, store with the customer's IT documentation.

---

## 0. Identify & Inventory (do this first)

☐ Tenant ID, default domain, custom domains recorded  
☐ Licence inventory (SKU + assigned count) exported via Graph or `Get-MgSubscribedSku`  
☐ Global Administrator list — should be 2–4, all named accounts, no shared mailboxes  
☐ Break-glass account created (×2), excluded from CA, FIDO2 key in safe, password offline, alert on use  
☐ GDAP relationship reviewed — granular roles only, no Global Admin partner access unless justified  
☐ Guest user inventory + last sign-in date  
☐ Third-party enterprise app inventory + consent grants  
☐ Mailbox forwarding rules audit (external SMTP forwarding)  
☐ Shared mailboxes — sign-in blocked, no licence assigned  
☐ Tenant configuration backup (CA policies, Intune configs, Entra settings) stored in source control or IT doc system  

---

## 1. Identity (Entra ID)

### Baseline (☐)
☐ Security defaults OFF (replaced by CA — see CA template pack)  
☐ MFA enforced for all users via CA  
☐ Legacy authentication blocked (CA policy)  
☐ Self-service password reset enabled with 2 methods registered  
☐ Combined registration enforced  
☐ Authenticator app — number matching enabled, location + app context shown  
☐ SMS and voice removed as MFA methods (phishing-resistant push or FIDO2 only where possible)  
☐ Password expiry set to "never" (NIST + ASD aligned)  
☐ Banned password list configured (tenant + custom)  
☐ User consent to apps — restricted to verified publishers, low-risk permissions only  
☐ Admin consent workflow enabled with reviewer assigned  
☐ Guest invite restricted to admins or specified roles  
☐ Guest user permissions limited (restricted directory access)  
☐ Cross-tenant access policies reviewed (B2B inbound/outbound)  

### Recommended (◻)
◻ Privileged Identity Management (PIM) — all admin roles JIT, max 8h activation  
◻ Access reviews — quarterly for admin roles, guests, privileged groups  
◻ Authentication strengths configured (phishing-resistant for admins)  
◻ Continuous Access Evaluation (CAE) enabled  
◻ Identity Protection — risk-based CA policies enabled (sign-in + user risk)  
◻ Named locations defined (trusted offices, blocked geographies)  
◻ Token Protection (session binding) enabled for Windows  

### Advanced (◇)
◇ Workload identities licensed and protected (service principals under CA)  
◇ Verified ID / Entra ID Governance for joiner-mover-leaver  
◇ Authentication context applied to sensitive apps  

---

## 2. Email & Collaboration (Exchange Online + Defender for Office 365)

### Baseline (☐)
☐ SPF, DKIM, DMARC published — DMARC at `p=quarantine` minimum, ideally `p=reject`  
☐ DMARC report mailbox monitored (or routed to a parsing service)  
☐ External sender tag enabled in Outlook  
☐ Auto-forwarding to external recipients blocked (transport rule + Remote Domain)  
☐ Anti-phishing policy — impersonation protection for execs + lookalike domains  
☐ Safe Links enabled for Email, Teams, Office apps  
☐ Safe Attachments — dynamic delivery mode  
☐ Anti-spam — high-confidence phish to Quarantine  
☐ Quarantine notifications enabled (every 1–3 days)  
☐ Tenant Allow/Block List reviewed (no permanent allows without justification)  
☐ Mailbox auditing enabled (default on, but verify)  
☐ Outbound spam policy — alert on suspicious outbound + auto-restrict on detection  
☐ Common attachment filter — `.exe`, `.js`, `.vbs`, `.ps1`, `.iso`, `.lnk`, `.htm`/`.html` blocked  
☐ Connection filter policy — no permanent IP allow-lists  

### Recommended (◻)
◻ Preset Security Policies — Strict for execs/IT, Standard for everyone else  
◻ Attack Simulation Training run quarterly  
◻ Zero-hour Auto Purge (ZAP) for phish, spam, malware enabled  
◻ Priority Account Protection enabled for VIPs  
◻ Anti-phish impersonation — protected domains include partner/customer domains  

---

## 3. Endpoint (Intune + Defender for Endpoint)

### Baseline (☐)
☐ All Windows devices enrolled in Intune (Autopilot for new builds)  
☐ Compliance policies — encryption, AV active, firewall on, min OS version  
☐ Configuration profile — BitLocker (XTS-AES 256, key escrow to Entra)  
☐ Configuration profile — Microsoft Defender Antivirus (cloud-delivered protection, PUA, tamper)  
☐ ASR rules — at least the "block" set deployed (E8: macro hardening)  
☐ Office macro hardening — block macros from internet, signed only where required  
☐ Application Control / WDAC or AppLocker baseline (E8 ML2)  
☐ Local admin removed from standard users (LAPS deployed)  
☐ Windows Hello for Business or FIDO2 for sign-in  
☐ Patching — Update rings configured, quality updates ≤48h, feature ≤30d  
☐ Defender for Endpoint onboarded, automated investigation in Full mode  
☐ Web content filtering enabled  
☐ macOS / iOS / Android — equivalent compliance + Defender for Endpoint MDE  
☐ Personal devices — App Protection Policies (MAM) for Office + Teams  

### Recommended (◻)
◻ Tamper Protection enforced via Intune  
◻ Network Protection on (block mode)  
◻ Controlled Folder Access enabled  
◻ Attack Surface Reduction — full rule set audited then enforced  
◻ USB / removable media policy (block or require encryption)  

### Advanced (◇)
◇ Endpoint Privilege Management (EPM) for elevation workflows  
◇ Defender for Endpoint Plan 2 — Advanced Hunting, custom detections  
◇ Defender Vulnerability Management with remediation SLAs  

---

## 4. Data (Purview)

### Baseline (☐)
☐ Sensitivity labels published — minimum 3 tiers (Public, Internal, Confidential)  
☐ Default label applied to new documents/emails  
☐ Mandatory labelling enabled  
☐ Auto-labelling for obvious patterns (TFN, credit card, passport) — simulation → enforce  
☐ DLP policies — credit card, PII, financial in Exchange/SharePoint/OneDrive/Teams/Devices  
☐ DLP — tip mode first, then block with override + justification  
☐ Retention policy — at least one tenant-wide policy covering Exchange/SP/OD/Teams  
☐ Recoverable items retention extended where needed for litigation hold  
☐ SharePoint external sharing — set to "Existing guests" or "New and existing guests" with link expiry  
☐ Anonymous link expiry ≤30 days, view-only by default  
☐ OneDrive sharing aligned to SharePoint settings  
☐ Teams — guest access governed, channel sharing reviewed  

### Recommended (◻)
◻ Insider Risk Management baseline policies  
◻ Communication Compliance policies for regulated workloads  
◻ Customer Lockbox enabled  
◻ Audit (Premium) enabled — high-value events captured  

### Advanced (◇)
◇ Data Security Posture Management (DSPM) onboarded  
◇ Adaptive Protection wired into Insider Risk  

---

## 5. Apps & Workload Identities

☐ Enterprise app review — disable unused, restrict assignment, audit OAuth scopes  
☐ App registrations — owners current, secrets rotated, certificates preferred over secrets  
☐ App governance (Defender for Cloud Apps) enabled  
☐ Defender for Cloud Apps connectors enabled (Microsoft 365, Entra ID, Defender for Endpoint)  
☐ OAuth app policy — alert on high-privilege consent grants  
☐ Workload identity Conditional Access where licensed (Workload Identities Premium)  

---

## 6. Backup & Recovery

☐ Third-party M365 backup for Exchange, SharePoint, OneDrive, Teams  
☐ Restore test executed within last 90 days (document evidence)  
☐ Entra configuration export scheduled (CA, named locations, app registrations)  
☐ Intune configuration export scheduled  
☐ Recovery runbook documented with RTO/RPO  
☐ Immutable / air-gapped copy of backups  

---

## 7. Monitoring & Response

☐ Microsoft Defender XDR portal — alerts triaged within agreed SLA  
☐ Audit log retention — minimum 180 days (Audit Premium = 1 year+)  
☐ Sign-in and audit logs exported to Sentinel or long-term storage  
☐ Sentinel workspace deployed (or alternative SIEM connected via Graph)  
☐ Connectors: Entra ID, M365, Defender XDR, Defender for Cloud Apps  
☐ Analytics rules — baseline templates enabled and tuned  
☐ Incident playbooks documented (BEC, ransomware, account takeover, data exfiltration)  
☐ Customer notification template approved by customer + DR plan rehearsed  
☐ Monthly customer report — Secure Score delta, exposure trend, incidents, actions  

---

## 8. Tenant Governance

☐ Secure Score baseline captured at onboarding + tracked monthly  
☐ Exposure Management initiatives reviewed quarterly  
☐ Compliance Manager assessments selected for customer's regulated frameworks  
☐ Microsoft Entra Permissions Management or equivalent privilege audit  
☐ Change control — admin changes ticketed, approved, evidenced  
☐ Customer Information Security Policy reviewed annually  

---

## Sign-off

| Field | Value |
|---|---|
| Tenant | |
| Customer | |
| Date completed | |
| Technician | |
| Reviewer | |
| Next review due | |

**Notes & exceptions:**

---

*Maintained by [your MSP]. Review quarterly. Version: 2026-05.*
