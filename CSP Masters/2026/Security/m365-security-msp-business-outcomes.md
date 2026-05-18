# M365 Security as a Service — MSP Business Outcomes

**For:** SMB MSP owners, service managers, and senior account managers building or scaling a security practice on Microsoft 365.  
**Outcome:** A repeatable service offering with defendable pricing, measurable MRR uplift, and a clear ticket-reduction story.

> All AUD figures are **planning ballparks** based on the Australian SMB MSP market in 2025–2026. Calibrate against your own cost base, customer segment, and competitive set. Real prices live in your CRM, not in a slide.

---

## 1. The opportunity

The shift since 2023 is real and durable:

- **Cyber Insurance** now demands MFA, EDR, backup, IR plan as preconditions — your customers must comply to renew.
- **Essential 8 + SMB1001** are entering procurement language for any SMB selling into government, finance, or supply chain.
- **Privacy Act reforms** and mandatory breach notification raise the cost of inaction.
- **Microsoft licensing changes** (Business Premium, E5 Security add-on, Defender for Business) have put the *tooling* in reach — but most SMBs have no idea how to operationalise it.

The capability gap is the MSP's margin. You are selling **operational outcomes**, not licences.

---

## 2. Service tier model — three-tier baseline

Mapped to Essential 8 maturity. Most MSPs land on a three-tier shape: **Essentials → Standard → Premium**. Anything more granular is hard to sell; anything less leaves money on the table.

| Tier | E8 alignment | Target customer | Anchor licence | Indicative price (AUD / user / month) |
|---|---|---|---|---|
| **Essentials** | E8 ML1 (foundational) | 5–25 seat customer, low risk appetite, no compliance pressure | M365 Business Standard + add-ons | **$15 – $25** |
| **Standard** | E8 ML1.5 / aspiring ML2 | 25–100 seats, cyber insurance pressure, supply-chain expectations | M365 Business Premium | **$30 – $55** |
| **Premium** | E8 ML2+ with monitoring | 50+ seats, regulated, contractual security obligations, board-level risk owner | M365 BP + E5 Security or E5 | **$70 – $150** |

> **Pricing principle:** charge per **active managed user**, not per device or seat. Users drive the work; tools and devices are a function of user count.

### What each tier includes

**Essentials (the floor — everyone should be here)**
- MFA enforced via CA (template pack deployed)
- Block legacy auth
- Standard anti-phishing / Safe Links / Safe Attachments tuning
- Defender for Business onboarded on managed devices
- Intune compliance + baseline configuration profiles
- SharePoint / OneDrive external sharing controls
- Third-party M365 backup
- Quarterly Secure Score review
- Monthly customer report (Secure Score delta, incidents, actions)
- Tier-1 IR response (business hours, defined RTO)

**Standard (the sweet spot for most SMBs)**
- All Essentials, plus:
- Full Conditional Access pack (20+ policies, persona model)
- Risk-based CA (Identity Protection)
- ASR rules in block mode + Attack Surface Reduction tuning
- LAPS + local admin removal
- Sensitivity labels + DLP (tip mode → enforced)
- Quarterly phishing simulation + reporting
- Tenant configuration backup in MSP source control
- Privileged Identity Management (PIM) for admin roles
- Monthly tabletop / IR rehearsal (annual)
- Business-hours SOC triage with named SLA

**Premium (the SOC-grade offering)**
- All Standard, plus:
- Sentinel deployment + analytics rules + KQL detections (KQL pack as starting point)
- 24×7 monitoring (in-house or via white-labelled MDR partner)
- Defender for Identity + Defender for Cloud Apps configured
- Insider Risk Management, Communication Compliance
- Token Protection / phishing-resistant MFA mandatory
- DSPM (Data Security Posture Management)
- Annual red team / penetration test coordination
- Quarterly executive risk briefing
- Documented IR retainer with forensic partner
- Compliance Manager evidence collection (E8, ISO 27001, SMB1001)

---

## 3. MRR uplift modelling

### Worked example — a 50-customer MSP

Assume a typical Australian SMB MSP base:

| Metric | Value |
|---|---|
| Customers | 50 |
| Avg seats / customer | 18 |
| Total managed seats | 900 |
| Existing managed services MRR (excluding security uplift) | ~$22,500 (avg $25 / user) |

**Year 1 attach rate by tier:**

| Tier | Attach rate | Customers | Seats | Price (AUD / user / month) | Monthly uplift |
|---|---|---|---|---|---|
| Essentials | 30% | 15 | 270 | $20 | $5,400 |
| Standard | 40% | 20 | 360 | $40 | $14,400 |
| Premium | 10% | 5 | 90 | $90 | $8,100 |
| **Total uplift** | **80%** | **40** | **720** | — | **$27,900 / month** |

**Year 1 MRR uplift: ~$28k / month → $335k ARR uplift**, on a base that was already paying for managed services.

### What drives the numbers

- **Attach rate** matters more than price. A 20% attach is a failed launch; 70%+ is realistic if you make the Essentials tier the default and bundle it into the standard MSP agreement.
- **Tier mix** shifts over time. Year 1 is heavy Essentials; by year 2–3 customers move up — typically because of an insurance event, a near-miss, or a procurement requirement.
- **Net Revenue Retention** is the real metric. Security tiers have NRR > 110% in well-run MSPs because customers move *up*, rarely down.

### Sensitivity table — what changes the answer

| Lever | Effect on Year 1 uplift |
|---|---|
| Bundling Essentials as mandatory in all new agreements | +30–50% attach rate |
| Annual security review built into renewal cycle | +1 tier upgrade per year for ~20% of customers |
| Insurance renewal as forcing function | Moves Essentials → Standard for 30–50% in a 12-month window |
| Single named "Security Lead" inside the MSP | 2× faster pipeline to close |

---

## 4. Ticket reduction modelling

Security work is often sold on the **upside** (insurance, compliance). The unspoken win is the **downside reduction** — fewer fires, fewer after-hours calls, better margin on the base MSP contract.

### Where the tickets go away

| Control | Tickets typically eliminated | Realistic reduction |
|---|---|---|
| MFA + SSO + SSPR | Password resets, account lockouts | **40 – 60%** of identity-related tickets |
| Intune Autopilot + standardised baseline | Device provisioning, "this app isn't installed" tickets | **50 – 70%** of new-device setup time |
| Conditional Access (location, device) | "Why am I getting MFA-prompted?" once trained | Initial spike then **30%** reduction in legitimacy-of-sign-in queries |
| Defender for Endpoint with auto-investigation | Malware triage, manual remediation | **30 – 50%** of malware tickets |
| Patch compliance via Intune | "My PC is being slow", unpatched-induced bugs | **15 – 25%** of general support |
| LAPS + local admin removal | Helpdesk-installed software, registry mess | **10 – 20%** of "I broke my laptop" |
| Sensitivity labels + DLP | Data oops ("I sent the wrong attachment") | Hard to quantify, but **most incidents prevented** |

**Order-of-magnitude:** a well-implemented Standard tier reduces unplanned support tickets by **25–40%** within 6 months. That is direct margin uplift on the base contract.

### How to measure it

Baseline at onboarding, then track monthly:

| KPI | Tooling | Target |
|---|---|---|
| Tickets / user / month | PSA (Autotask, ConnectWise, Halo) | ↓ 25% in 6m |
| Mean time to resolve (MTTR) – identity tickets | PSA | ↓ 40% in 6m |
| After-hours ticket count | PSA | ↓ 50% in 6m |
| Secure Score | M365 portal | ↑ 20 points in 6m |
| % managed devices compliant | Intune | > 95% sustained |
| MFA registration coverage | Entra | 100% within 30 days |

Bring these into a one-page monthly report. Customers love the trend lines; salespeople love the renewal conversation.

---

## 5. Sales motion

### The repeatable flow

```
Awareness → Assessment → Proposal → Onboard → Operate → Review → Expand
```

| Stage | Activity | Duration | Deliverable | Sells |
|---|---|---|---|---|
| **Awareness** | Webinar, customer event, threat briefing, insurance renewal trigger | — | Conversation | Nothing yet |
| **Assessment** | Paid Secure Score + Essential 8 gap assessment | 1–2 weeks | Findings report + risk register | $2.5k – $7.5k fixed-fee |
| **Proposal** | Tier recommendation with attached evidence | 1 week | Statement of Work | Tier subscription |
| **Onboard** | 30–90 day uplift project | 1–3 months | Configured tenant + signed runbook | Project fee + first month MRR |
| **Operate** | Monthly cadence — review, report, tune | Ongoing | Monthly report | MRR |
| **Review** | Quarterly business review (QBR) | Quarterly | Trend report + roadmap | Tier upgrades, add-ons |
| **Expand** | Annual maturity uplift | Yearly | New SOW | Tier upgrade or vertical add-on |

### Paid assessment is non-negotiable

Free assessments train customers to expect free work. A paid Essential 8 / Secure Score assessment:

- Filters tyre-kickers.
- Justifies the engagement effort.
- Anchors the customer on **value**, not hours.
- Gives you a contractual basis for the recommendations that follow.

Typical SMB assessment price: **$2,500 – $7,500 AUD fixed-fee**, scoped to under-100-seat tenants.

### The conversation that closes

Customers don't buy "Conditional Access policies". They buy:

- "Renew your cyber insurance without paying the loaded premium."
- "Sleep through the night knowing the BEC scenario won't bankrupt you."
- "Hit the Essential 8 ML1 audit your prime contractor will require by July."
- "Stop losing a day each time someone joins or leaves."

Translate every control to a customer outcome. Don't talk about CA02; talk about the wire-fraud case at the rival firm last quarter.

### Forcing functions you can use

- **Cyber insurance renewal** — 3 months before renewal, run a gap assessment against the policy's controls schedule.
- **New contract / tender requirement** — many primes now require ISO 27001 or Essential 8 self-attestation.
- **Privacy Act reforms / mandatory notification** — board-level interest spikes after publicised incidents.
- **Audit findings** — an external auditor or insurer flagging gaps is the strongest catalyst.

---

## 6. Packaging into the agreement

### SOW essentials (security tier specifically)

Include:

- Defined **scope of tenants, users, devices**.
- **Per-user pricing**, with explicit re-rate triggers (new tier, new module).
- **Inclusions** — list controls, monitoring, reporting cadence.
- **Exclusions** — incident response *beyond* tier-1 triage, forensics, third-party tooling, on-premises identity.
- **SLAs** — response time by severity, monitoring hours.
- **Customer responsibilities** — admin access, evidence approvals, named security contact.
- **Change control** — how customer-initiated changes are billed.
- **Exit clauses** — what tenant artefacts are handed back (CA export, Intune config, KQL pack).
- **IR retainer terms** — hourly rate, retainer balance, escalation pathway.

### Don't bury the price

A separate line for "Security Services — Standard tier" on every invoice is good for renewals. Customers who can see the line know what it covers. Bundled-into-everything pricing makes it invisible — and invisible is the easiest thing to cut.

---

## 7. Unit economics for the MSP

A Standard tier customer should look roughly like this monthly:

| Item | Cost / user | Notes |
|---|---|---|
| Microsoft licence (BP) | ~$33 AUD | Customer-paid via partner |
| Third-party backup | ~$3 AUD | MSP cost |
| Tooling (RMM, PSA, doc, MFA reporting, etc.) | ~$5 AUD | MSP fixed cost amortised |
| Tech labour (monitoring, triage, monthly report) | ~$10 AUD | At ~$120/hr loaded, ~5 min/user/month |
| **Total COGS** | **~$18 AUD** | |
| **Sell price** | **$40 AUD** | |
| **Gross margin** | **~$22 AUD (55%)** | Reasonable for managed security |

**Targets:**
- Gross margin per tier: ≥ 50% on Essentials, ≥ 55% on Standard, ≥ 60% on Premium.
- Labour-to-revenue ratio < 35% (otherwise you're a body shop, not a service).
- Tooling-to-revenue < 15%.

If your unit economics are upside-down, the answer is almost always **automation** (KQL pack, runbooks, scripts, templates) before it is price increase.

---

## 8. Common pitfalls

- **Selling tools instead of outcomes.** Customers don't want Defender; they want "you stop the attack".
- **Free assessments → unpaid scope creep.** Charge from day one.
- **Tier sprawl.** Three tiers is the limit. More confuses sales and ops alike.
- **No exit story.** Customers ask "what if we leave?" — have an answer (export pack, runbook, IP handover terms).
- **Forgetting the QBR.** Renewals die without one.
- **No named security lead inside the MSP.** Distributed responsibility = inconsistent delivery. Even at 10 staff, one person owns the practice.
- **Pricing per device.** Devices move; users persist. Price per user.
- **Confusing MDR with monitoring.** Be explicit about who watches what, when. Resell a white-label MDR if you don't have a 24×7 SOC — don't pretend.

---

## 9. The one-slide pitch (for the training)

> Three tiers. Per-user pricing. Paid assessment. Monthly cadence. Quarterly review. Annual uplift.
> 
> Each tier maps to an Essential 8 maturity level customers can defend to their insurer, their auditor, and their board.
> 
> The MSP wins: **30%+ MRR uplift on the existing base, 25–40% ticket reduction within 6 months, and a renewal story that doesn't depend on price.**

---

## 10. Suggested in-session exercise

**90-minute group activity** for the training day:

1. (15 min) Each attendee picks one real customer (anonymised) from their book.
2. (20 min) Map them to Essentials / Standard / Premium using the criteria above.
3. (20 min) Calculate uplift: current MRR vs target tier MRR.
4. (20 min) Identify the forcing function (insurance, contract, incident, audit).
5. (15 min) Draft the opening line of the conversation.

Run a debrief — most MSPs are stunned at the unmet revenue sitting in their existing base.

---

*Maintained by [your MSP / CIAOPS]. Calibrate quarterly. Version: 2026-05.*
