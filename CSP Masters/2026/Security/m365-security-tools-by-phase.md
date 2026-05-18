# M365 Security Tools — Mapped to Lifecycle Phases

**For:** SMB MSP training day. Replaces the upfront tools list with a phase-anchored view.  
**Principle:** Tools without phases are a shopping list. Tools inside phases are a method. Teach the phase, then the tool — never the reverse.

---

## Cross-cutting tools (used in every phase — call out once, then move on)

These are the connective tissue. Mention them at the start of the day, then assume them.

| Tool | Role across phases |
|---|---|
| **PowerShell + Microsoft Graph PowerShell SDK** | The universal CLI — query, configure, export, automate |
| **VS Code + GitHub Copilot** | The IDE for writing/reading every script, KQL query, JSON template |
| **GitHub** | Config-as-code repo — CA exports, Intune profiles, KQL pack, runbooks, IR playbooks |
| **Frameworks (E8, ASD Blueprint, CIS, NIST CSF 2.0)** | The scoring grid — anchors every phase |
| **Benchmarks (CIS M365 Foundations, MS Security Baselines)** | The control library you map against |
| **Copilot (Researcher / Analyst / Notebooks / Studio)** | Knowledge worker layer — different surfaces for different phases (see below) |

---

## IDENTIFY

*Goal: know the surface area before you measure it.*

| Tool | Why here |
|---|---|
| **PowerShell + Graph** | Pull tenant inventory — users, licences, devices, guests, apps, mailbox rules |
| **Partner Center / Microsoft 365 Lighthouse** | Multi-tenant inventory for the MSP across all customers |
| **GDAP review tooling** | Confirm least-privilege partner access |
| **Maester** (open source) | Automated tenant assessment baseline |
| **Copilot Researcher** | Cross-tenant pattern discovery; "show me all tenants with X" |
| **Copilot Notebooks** | Consolidate inventory artefacts into a single living doc per customer |

---

## EVALUATE

*Goal: score the gap against frameworks and benchmarks.*

| Tool | Why here |
|---|---|
| **M365 Business Premium portal — Secure Score** | Headline score + per-control evidence |
| **Exposure Management** | Threat-led view of what an attacker would target |
| **Compliance Manager** | Framework-scored evidence (ISO, E8, NIST) |
| **PowerShell + Graph** | Custom evaluations the portals don't surface (e.g. CA coverage gaps, MFA registration delta) |
| **Frameworks (E8, ASD Blueprint, CIS)** | The scoring grid behind the numbers |
| **Copilot Analyst** | Crunch raw exports (sign-in logs, audit logs, licence usage) into findings |
| **Copilot Notebooks** | Author the findings report with evidence inline |
| **GitHub** | Version-control the evaluation outputs — diff month over month |
| **VS Code + GitHub Copilot** | Write/refine the eval scripts faster |

---

## UPLIFT

*Goal: deploy controls at scale, repeatably, with evidence.*

| Tool | Why here |
|---|---|
| **Entra admin centre** | CA policies, PIM, named locations, authentication methods |
| **Intune** | Device compliance, configuration profiles, ASR, BitLocker, app protection |
| **Defender XDR portal** | Defender for Endpoint / Office / Identity / Cloud Apps tuning |
| **Purview portal** | Sensitivity labels, DLP, retention, Insider Risk |
| **Exchange admin centre + PowerShell** | Anti-phish, Safe Links/Attachments, transport rules |
| **PowerShell + Graph** | Bulk deployment — apply CA templates to 50 tenants, not 1 |
| **Copilot Studio agents** | Custom agents for repeatable uplift workflows (e.g. "new customer onboarding" agent) |
| **ASD Blueprint agent / templates** | Reference architecture pre-packaged |
| **Copilot Prompt library** | Standardised prompts so techs get consistent uplift recommendations |
| **GitHub** | CA / Intune / Purview config-as-code, peer-reviewed PRs before production |
| **VS Code + GitHub Copilot** | Author deployment scripts, JSON policies, idempotent runbooks |

---

## TEST

*Goal: prove the controls work the way the customer thinks they do.*

| Tool | Why here |
|---|---|
| **Attack Simulator (Defender for Office)** | Phishing sims against real users |
| **Defender Evaluation Lab** | Detonate samples without risking production |
| **Sectest / breach & attack simulation tooling** | Validate detections fire across the kill chain |
| **PowerShell + Graph** | Config drift checks — does the tenant still match the baseline? |
| **KQL (Advanced Hunting)** | Verify detections trigger on simulated activity |
| **GitHub Actions** | Automated nightly drift tests against tenant config exports |
| **Copilot Analyst** | Interpret simulation results, surface anomalies |
| **Tabletop exercise templates** | Human-process testing (not a tool, but treat it as one) |

> Red teaming sits here for Premium-tier customers only — most SMB MSPs will resell rather than deliver in-house.

---

## REMEDIATE

*Goal: contain, eradicate, recover, learn.*

| Tool | Why here |
|---|---|
| **Defender XDR incident queue** | Single pane for incident triage and case management |
| **Sentinel automation rules + playbooks** | SOAR — auto-disable account on user-risk High, etc. |
| **Logic Apps / Power Automate** | Lightweight SOAR for MSPs not on Sentinel yet |
| **Microsoft Security Copilot** | Incident summarisation, KQL generation, IR co-pilot |
| **Copilot Studio agents** | Containment workflows — "isolate device + revoke sessions + notify on-call" |
| **PowerShell + Graph** | Emergency actions — bulk revoke tokens, disable accounts, reset passwords |
| **GitHub** | Post-incident — write up the runbook, version the playbook, lessons-learned tracked in issues |
| **IR retainer / forensic partner contact** | The escalation pathway (Premium tier) |

---

## MONITOR

*Goal: continuous detection, reporting, and customer-visible value.*

| Tool | Why here |
|---|---|
| **Microsoft Sentinel** | SIEM — long-term log retention, analytics rules, hunting queries |
| **KQL** | The query language for every monitoring task across Sentinel + Defender XDR |
| **Defender XDR Advanced Hunting** | Real-time hunting across endpoint, identity, email, cloud apps |
| **Defender EASM (DEASM)** | External attack surface — what does the internet see? |
| **M365 BP audit log streaming / Event Hub** | Ship raw events to Sentinel or third-party SIEM |
| **Microsoft Security Copilot** | Natural-language KQL, alert summarisation for L1 |
| **Copilot Analyst** | Build customer-facing monthly reports from raw telemetry |
| **Power BI on Sentinel** | Customer-visible dashboards (Secure Score trend, incident volume, MTTR) |
| **Copilot Studio agents** | Automated monthly report generation per customer |
| **GitHub** | KQL pack as a versioned repo — community-style contribution model |

---

## Skills — re-mapped per phase

Same skills as the original list, but anchored to where they're actually used:

| Phase | Required skills |
|---|---|
| **Identify** | Checklists, PowerShell, Graph API literacy |
| **Evaluate** | Framework literacy (E8/CIS/NIST), data analysis, AI prompting, checklists |
| **Uplift** | Code (PowerShell/JSON), change management, AI for acceleration, certifications signal competence |
| **Test** | Threat modelling, simulation discipline, KQL basics, problem-solving |
| **Remediate** | IR fundamentals, communication, KQL, decision-making under pressure |
| **Monitor** | KQL fluency, automation/scripting, customer reporting, AI for scale |

**Cross-cutting skills (everywhere):**

- **AI prompting** — the new baseline literacy; impacts every phase
- **Problem-solving** — the only skill that doesn't go obsolete
- **Certifications** — SC-200, MS-500/SC-400, AZ-500 as the staircase

---

## One slide for the training

> **Tools without phases are a shopping list. Tools inside phases are a method.**
>
> Each phase has 3–5 tools that *matter*. The rest are connective tissue you mention once.
>
> Teach the phase, then the tool — never the reverse.

---

*Maintained by [your MSP / CIAOPS]. Version: 2026-05.*
