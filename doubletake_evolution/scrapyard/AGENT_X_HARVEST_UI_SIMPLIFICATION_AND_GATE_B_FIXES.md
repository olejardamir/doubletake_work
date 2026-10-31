# Agent_X Harvest / Assimilation UI Simplification and Gate B Authority Fixes

## Objective

Simplify the Harvest / Assimilation experience so that the user operates the system at a high level while Agent_X performs the internal reasoning, classification, gating, routing, and assimilation automatically.

The normal user should:

- do less,
- see less,
- make fewer manual decisions,
- not be exposed to internal pipeline mechanics unless explicitly requested,
- only be interrupted when genuine human judgment is required.

The system should perform the complexity internally and present outcomes, not implementation machinery.

---

# 1. Remove `agentx_status` as Gate B Authority

## Problem

Fields such as:

```text
agentx_status = update
agentx_status = upgrade
```

must not authorize implementation.

A harvested item must not pass Gate B merely because an LLM, UI control, database field, or user-editable status labels it as an update or upgrade.

This creates an unsafe shortcut:

```text
agentx_status = update / upgrade
        ↓
Gate B passes
        ↓
Assimilation starts
        ↓
Code is generated
```

This is not acceptable.

## Required Fix

`agentx_status` must become descriptive metadata only.

It may be used for:

- display,
- filtering,
- reporting,
- history,
- inventory organization,
- diagnostics,
- non-authoritative classification.

It must not be used as part of the authorization predicate for Gate B.

## Correct Gate B Principle

Gate B must decide whether implementation is justified from actual evidence, including:

- repository state,
- existing capability overlap,
- identified capability gap,
- implementation value,
- architectural fit,
- expected benefit,
- implementation feasibility,
- duplication risk,
- compatibility,
- evidence quality,
- testability,
- maintenance burden,
- safety and governance constraints.

The implementation decision must emerge from the evidence.

Conceptually:

```text
Harvested information
        ↓
Normalize / interpret
        ↓
Gate A
        ↓
Repository + capability analysis
        ↓
Gate B
        ↓
Assimilation decision
```

Never:

```text
status label
    ↓
Gate B approval
```

## Code Audit Requirement

Search the entire Harvest / Assimilation / gating path for logic equivalent to:

```python
if agentx_status in {"update", "upgrade"}:
    approve()
```

or:

```python
should_implement = agentx_status == "upgrade"
```

or any indirect equivalent.

Remove all such authority paths.

---

# 2. Replace Manual Pipeline Operation with Automation

## Problem

The current UI exposes too many internal concepts and requires the user to understand and operate the Harvest pipeline manually.

This creates unnecessary cognitive load and makes the system feel like a database administration console instead of an autonomous intelligence system.

## Required Fix

The normal workflow should become:

```text
User
  ↓
Start Mining
  ↓
Automated continuous pipeline
  ↓
Only important outcomes are shown
```

The system should automatically run:

1. frontier discovery,
2. gap filling,
3. balancing,
4. harvesting,
5. normalization,
6. deduplication,
7. relevance analysis,
8. capability comparison,
9. implementation-worthiness analysis,
10. Gate A,
11. Gate B,
12. assimilation preparation,
13. assimilation where authorized,
14. implementation verification,
15. result recording.

The user should not manually route items through these stages.

---

# 3. Reduce the Main UI to High-Level Controls

## Main Operator Controls

The primary interface should require only a very small number of controls.

At minimum:

```text
[ Start Mining ]
[ Stop Mining ]
```

Optional automation preferences may include:

```text
☑ Automatically evaluate discoveries
☑ Automatically prepare worthy candidates
☑ Automatically assimilate approved candidates
```

If a fully autonomous mode is enabled, even these may be collapsed into one control:

```text
[ Start Autonomous Mining ]
```

## Main Principle

The main UI should answer:

- Is Agent_X running?
- What is it finding?
- What has it implemented?
- What needs my attention?

It should not expose the full internal decision system.

---

# 4. Remove Internal Metadata from the Primary UI

The following should not normally appear in the main Harvest / Assimilation interface:

- `agentx_status`,
- internal item IDs,
- digests,
- producer,
- raw domain identifiers,
- Gate A manual controls,
- Gate B manual controls,
- database keys,
- dispatch controls,
- internal routing fields,
- implementation bucket selectors,
- raw ranking coefficients,
- raw scoring dimensions,
- internal evidence flags,
- internal pipeline state names,
- low-level scheduler data,
- low-level assimilation state,
- manual update / upgrade selectors.

These may continue to exist internally.

They should be moved to an Advanced / Diagnostics interface.

---

# 5. Introduce an Advanced / Diagnostics View

The complexity should remain available for developers and debugging, but not in the normal workflow.

Suggested structure:

```text
Advanced
├── Decision evidence
├── Gate diagnostics
├── Harvest metadata
├── Scoring details
├── Database state
├── Pipeline trace
├── Assimilation trace
├── Scheduler state
└── Developer controls
```

The default user should never need to open this view.

---

# 6. Stop Asking the User to Classify Discoveries

## Problem

The user should not manually decide whether a discovery is:

- update,
- upgrade,
- new capability,
- knowledge,
- duplicate,
- discard,
- implementation candidate.

Those are internal analytical decisions.

## Required Fix

Agent_X should infer the correct treatment automatically.

Example:

```text
Discovery
    ↓
Already exists?
 ┌──┴──┐
Yes    No
 ↓      ↓
Would   Valuable?
improve?  ↓
 ↓      ├── Yes → candidate capability
 ↓      └── No  → reject / retain as knowledge
Yes
 ↓
candidate improvement
```

These classifications should not themselves grant authority.

They are outputs of analysis, not commands.

---

# 7. Convert Harvest Inventory into an Autonomous Inbox

## Problem

The Harvest Inventory currently behaves too much like a raw database or work queue.

## Required Fix

The inventory should behave like an inbox that mostly processes itself.

The primary user-facing result categories should be approximately:

```text
Implemented
Needs Review
Knowledge Retained
```

Everything else should normally be hidden in history:

- rejected,
- duplicate,
- obsolete,
- weak evidence,
- low value,
- already implemented,
- incompatible,
- failed validation,
- superseded.

These records must remain available for diagnostics and auditability, but they should not clutter the main view.

---

# 8. Make `Needs Review` Exceptional

The system should not routinely push decisions back to the user.

A discovery should enter `Needs Review` only when meaningful human judgment is required.

Examples:

- major architectural replacement,
- destructive migration,
- incompatible alternatives with similar merit,
- unclear product intent,
- significant repository-wide restructuring,
- high-risk behavioral changes,
- irreversible actions,
- unresolved governance conflict,
- ambiguous strategic choice.

Normal implementation-worthiness decisions should be automated.

---

# 9. Present Outcomes Instead of Internal Process

The activity feed should use human-readable results.

Good:

```text
Adaptive scheduler — implemented
Semantic cache proposal — retained as knowledge
Retry mechanism — verified and assimilated
Duplicate vector-ranking method — discarded
Repository-wide runtime replacement — needs review
```

Avoid exposing unnecessary internal data such as:

```text
producer=balancer
status=upgrade
gate_b=1
rank=0.8312
digest=160adedcf9e1
dispatch=assimilation_queue_4
```

unless the user opens diagnostics.

---

# 10. Simplify the Main Harvest Screen

A target normal interface should resemble:

```text
┌─────────────────────────────────────────────────────────┐
│ HARVEST                                                 │
│                                                         │
│ Status: Mining                                          │
│                                                         │
│ Sources analyzed:             3,482                     │
│ Useful discoveries:             127                     │
│ Implementation candidates:       18                     │
│ Implemented:                       4                     │
│ Needs review:                      1                     │
│                                                         │
│ [ Stop Mining ]                                         │
│                                                         │
│ Recent activity                                         │
│ • Adaptive scheduler — implemented                      │
│ • Semantic cache idea — retained as knowledge           │
│ • Retry mechanism — assimilated                         │
│ • Duplicate ranking idea — discarded                    │
│                                                         │
│ [ Review 1 Item ]        [ History ]        [ Advanced ]│
└─────────────────────────────────────────────────────────┘
```

The exact styling may differ, but the information architecture should remain this simple.

---

# 11. Automate Continuous Mining

Mining should operate continuously until the user stops it.

The pipeline should continuously cycle through:

```text
Frontier Discovery
        ↓
Gap Filling
        ↓
Balancing
        ↓
Harvest
        ↓
Normalize / Merge
        ↓
Evaluate
        ↓
Gate A
        ↓
Gate B
        ↓
Assimilate / Retain / Reject
        ↓
Verify
        ↓
Repeat
```

The user should not have to manually restart individual stages.

---

# 12. Unify Frontier Discovery, Gap Filling, and Balancing

These should appear as one user-level operation:

```text
Mining
```

Internally they can remain separate mechanisms.

The user should not need to decide:

- which one runs,
- in which order,
- how often,
- which database they populate,
- how discoveries move between them.

The orchestrator should manage that automatically.

---

# 13. Treat Harvested Material as Evidence, Not Ready-Made Code

Harvested material, embeddings, documents, patents, external code, research, and generated proposals should be treated as information sources.

They should not be assumed to be correct implementation instructions.

The required path is:

```text
Harvested source
      ↓
Human-readable interpretation
      ↓
Capability extraction
      ↓
Repository comparison
      ↓
Implementation design
      ↓
Assimilation
      ↓
Verified Agent_X-native code
```

This prevents Agent_X from creating placeholder code merely because a harvested item describes an attractive concept.

---

# 14. Require Real Implementation Substance

Before Gate B permits coding, Agent_X must identify a concrete implementation target.

A candidate should specify, where applicable:

- exact capability gap,
- affected subsystem,
- expected behavior,
- actual algorithm or mechanism,
- inputs,
- outputs,
- state changes,
- integration points,
- failure behavior,
- verification strategy,
- acceptance criteria.

Items that consist primarily of:

- labels,
- buckets,
- dispatch wrappers,
- placeholder handlers,
- generic record processors,
- metadata-only additions,
- superficial adapter functions,

must not be treated as meaningful implementation unless those structures are genuinely required by the architecture.

---

# 15. Add a "Substance Check" Before Assimilation

Before implementation is authorized, the system should explicitly determine:

```text
Does this candidate introduce real capability,
behavior, algorithmic logic, integration,
or measurable improvement?
```

If the answer is no, it should not produce code merely to satisfy a Harvest record.

Possible outcomes:

```text
REAL CAPABILITY
→ continue

KNOWLEDGE ONLY
→ retain as knowledge

DUPLICATE
→ discard / merge

PLACEHOLDER / BUCKET ONLY
→ reject implementation

INSUFFICIENT EVIDENCE
→ retain pending more evidence
```

---

# 16. Separate Classification from Authority

All internal classifications must obey this principle:

```text
Classification describes.
Evidence authorizes.
Governance permits.
Verification confirms.
```

For example:

```text
classification = "upgrade"
```

means:

> Agent_X believes this may represent an upgrade.

It must never mean:

> Agent_X is authorized to modify the repository.

This distinction should be enforced throughout the architecture.

---

# 17. Keep an Audit Trail Without Burdening the User

Automation must not eliminate traceability.

For every processed candidate, Agent_X should internally retain:

- source,
- normalized interpretation,
- deduplication result,
- capability comparison,
- decision evidence,
- Gate A result,
- Gate B result,
- implementation plan,
- changed files,
- verification results,
- final disposition.

The normal UI should summarize this.

The full trace should be available only through Advanced / Diagnostics.

---

# 18. Recommended User-Level State Model

The main UI should use only a few states.

Recommended:

```text
Mining
Evaluating
Implementing
Needs Review
Idle
Stopped
Error
```

Avoid exposing dozens of internal states.

Internally, Agent_X may have much more detailed state.

---

# 19. Recommended Candidate Result Model

For finished items, reduce user-facing outcomes to:

```text
Implemented
Knowledge Retained
Needs Review
```

Optional history-only states:

```text
Rejected
Duplicate
Superseded
Failed Verification
```

Avoid making the user operate these states manually.

---

# 20. Final Target Architecture

```text
                         USER
                          │
                    Start / Stop
                          │
                          ▼
               ┌────────────────────┐
               │ AUTONOMOUS MINER   │
               └─────────┬──────────┘
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
      Frontier         Gap Fill       Balance
          └──────────────┼──────────────┘
                         ▼
                      Harvest
                         ▼
                 Normalize / Merge
                         ▼
                  Evidence Analysis
                         ▼
                       Gate A
                         ▼
                Repository Comparison
                         ▼
                    Substance Check
                         ▼
                       Gate B
                         ▼
                Assimilation Decision
              ┌──────────┼──────────┐
              ▼          ▼          ▼
         Implement    Retain      Reject
              │
              ▼
           Verify
              │
              ▼
          Repository
              │
              ▼
        User Summary / History
```

---

# 21. Core Design Rules

The implementation should enforce the following rules:

1. The user controls goals, start/stop, and exceptional decisions.
2. Agent_X controls routine mining and evaluation.
3. Internal metadata must not become execution authority.
4. `agentx_status` must never authorize Gate B.
5. Classification and authorization must remain separate.
6. Harvested material is evidence, not ready-made implementation.
7. Gate B must require repository-grounded implementation justification.
8. Placeholder or bucket-only code must not count as capability.
9. The normal UI must expose outcomes, not machinery.
10. Advanced information remains available for debugging and audit.
11. Human review should be exceptional.
12. Continuous mining should require minimal user intervention.
13. Every implementation must be verified before being considered assimilated.
14. The system should default toward automation without sacrificing governance.
15. Maximum internal sophistication should produce minimum external complexity.

---

# 22. Definition of Done

This redesign is complete when:

- the user can start the full mining process with one primary action,
- mining continues automatically until stopped,
- frontier discovery, gap filling, balancing, Harvest, gating, and assimilation are automatically orchestrated,
- `agentx_status` cannot cause Gate B to pass,
- no alternative metadata field can serve as a hidden authority shortcut,
- the normal UI no longer exposes internal pipeline machinery,
- the Harvest Inventory behaves like a self-processing inbox,
- most discoveries require no user intervention,
- only meaningful exceptions appear under `Needs Review`,
- low-value / duplicate / rejected items do not clutter the primary interface,
- harvested concepts must pass a real substance check before coding,
- placeholder-only implementations are rejected,
- every accepted implementation is repository-grounded and verified,
- full audit information remains available in Advanced / Diagnostics,
- the user primarily sees what Agent_X found, what it did, and what genuinely requires attention.
