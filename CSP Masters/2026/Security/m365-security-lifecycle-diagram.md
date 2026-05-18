# M365 Security Lifecycle — Diagram & Notes

---

## Diagram as Mermaid (editable, version-controlled)

```mermaid
flowchart TD
    ID["IDENTIFY — know the surface area"]:::entry
    EV["EVALUATE — score the gap"]:::phase
    UP["UPLIFT — deploy controls"]:::phase
    TE["TEST — prove they work"]:::phase
    MO["MONITOR — continuous watch"]:::phase
    RE["REMEDIATE — contain, eradicate, recover"]:::incident

    ID --> EV
    EV --> UP
    UP --> TE
    TE --> MO
    MO -- "continuous improvement" --> EV
    MO -. "incident detected" .-> RE
    RE -. "post-incident hardening" .-> UP

    classDef entry fill:#475569,stroke:#1F2937,color:#FFFFFF
    classDef phase fill:#1D4ED8,stroke:#1E3A8A,color:#FFFFFF
    classDef incident fill:#B91C1C,stroke:#7F1D1D,color:#FFFFFF

    linkStyle 4 stroke:#047857,stroke-width:2.5px
    linkStyle 5 stroke:#B91C1C,stroke-width:2.5px,stroke-dasharray:5 5
    linkStyle 6 stroke:#B91C1C,stroke-width:2.5px,stroke-dasharray:5 5
```

---

## Why this shape

### 1. The **continuous improvement loop** (Monitor → Evaluate)

Monitoring isn't an endpoint — it's the input to the next evaluation. Secure Score changes, new CVEs appear, the threat landscape shifts, customer scope evolves. The whole point of MONITOR is to feed observations *back* into EVALUATE so the cycle restarts with sharper inputs.

> Without this loop, you have a project. With it, you have a service.

### 2. The **incident/hardening loop** (Monitor → Remediate → Uplift)

REMEDIATE is not part of the steady-state cycle — it's an **exception path** triggered when MONITOR sees something real. After remediation, the lesson must feed back into UPLIFT (new control, tuned policy, additional detection) — otherwise the same incident repeats.

> Remediation without hardening is just clean-up. Remediation that feeds Uplift is improvement.

---

1. **Trace the forward path** — IDENTIFY (once per customer) then the four-phase loop.
2. **Then trace the green loop** — "this is what makes it a *service*, not a project."
3. **Then trace the red exception** — "this is what makes it *resilient*, not just reactive."

The forward arrows are the deal. The two feedback arrows are the difference between a junior MSP and a mature one.

---
