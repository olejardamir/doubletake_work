# AGENT_X Collective Harvest UI — Capability Distillation & Anti-Slop Redesign Instructions

## Objective

Redesign the **Collective Harvest** UI so the interface no longer encourages raw Harvest discoveries to be treated as implementation-ready coding tickets.

The UI must reflect and enforce the new Agent_X pipeline:

```text
HARVEST
   ↓
CAPABILITY DISTILLATION
   ↓
GATE A
   ↓
ASSIMILATION
   ↓
GATE B
   ↓
IMPLEMENT / MERGE / EXPERIMENT / NO_CHANGE / DEFER / REJECT
```

The current UI allows high-ranked Harvest items to appear as `UPGRADE` items and exposes:

```text
Code All Selected Items
```

directly from the raw inventory.

That is too permissive and must be changed.

The redesign must make it visually and behaviorally clear that:

```text
Harvest score ≠ technical validity
Harvest score ≠ Agent_X capability gap
Harvest score ≠ permission to code
```

Do not redesign only the appearance. Change the interaction model and action availability so raw Harvest results cannot directly trigger implementation.

---

# 1. Existing UI Context

The current Collective Harvest modal contains approximately:

```text
Tabs:
- Inventory
- Harvest
```

The Inventory currently exposes columns similar to:

```text
Item
Worth
Value
Rank
Domain
Status
Benefit vs Agent_X
```

Rows can currently receive states such as:

```text
UPGRADE
```

and selected inventory records can be sent directly to:

```text
Code All Selected Items
```

The Harvest tab currently contains controls such as:

```text
New worthy discoveries
Harvest for:
- Update
- Upgrade

Producers:
- Balancer
- Gap-Filling
- Frontier

Focus

Thresholds:
- Worthiness
- Value to Agent_X

Actions:
- Gather
- Automate Harvesting
```

Preserve the useful parts of these workflows, but update them to reflect Capability Distillation.

---

# 2. Primary UX Principle

The interface must answer four separate questions:

```text
1. Did Harvest find something interesting?

2. Is there a coherent technical capability inside the discovery?

3. Does Agent_X actually need a change for that capability?

4. Has implementation been justified?
```

These must not be collapsed into one score or one status.

Only question 4 may expose production coding actions.

---

# 3. Remove Direct Coding From Raw Harvest Inventory

The current action:

```text
Code All Selected Items
```

must not be available for raw Harvest records.

Replace the action sequence with:

```text
RAW HARVEST
    ↓
Distill Selected
    ↓
GATE A PASS
    ↓
Assimilate Selected
    ↓
GATE B = IMPLEMENT or MERGE
    ↓
Implement Approved
```

The UI must enforce this sequence.

A raw Harvest record must never expose:

```text
Code
Implement
Generate module
Generate handler
Apply upgrade
```

unless it has passed the required downstream stages.

---

# 4. Required Primary Actions

Use context-sensitive actions based on lifecycle state.

## Raw Harvest records

Primary action:

```text
Distill Selected
```

Optional secondary actions:

```text
Reject
Archive
Inspect Source
```

Do not show implementation actions.

---

## Distilled records with Gate A PASS

Primary action:

```text
Assimilate Selected
```

Optional secondary actions:

```text
View Distillation
Defer
Reject
```

Do not show production implementation actions yet.

---

## Records with Gate B disposition IMPLEMENT or MERGE

Primary action:

```text
Implement Approved
```

Optional:

```text
View Architecture Decision
View Verification Plan
```

---

## EXPERIMENT disposition

Primary action:

```text
Run Experiment
```

Do not label experiments as implementation-ready.

---

## NO_CHANGE / DEFER / REJECT

Do not expose production coding actions.

---

# 5. Inventory Must Become a Capability Intelligence View

The inventory must stop behaving primarily like a list of generated coding proposals.

It should become a structured view of:

```text
source discovery
distillation result
technical substance
architectural comparison
disposition
verification state
```

The UI may remain table-based, but the displayed data must prioritize engineering validity over Harvest confidence.

---

# 6. Recommended Inventory Columns

The default useful columns should be:

```text
Capability
Type
Evidence
Substance
Gate A
Agent_X Gap
Disposition
Slop Risk
```

Additional optional/secondary columns:

```text
Worth
Value
Rank
Source Producer
Source Run
Domain
Architectural Owner
Behavioral Delta
Verification
```

`Worth`, `Value`, and `Rank` should remain available, but they should no longer dominate the meaning of the row.

---

# 7. Change "Item" to "Capability" After Distillation

Raw records may still display their Harvest item identity.

After distillation, rows should show the normalized capability name rather than opaque generated identifiers such as:

```text
cross_modal_Advanced_age_frontier_18_7cdb
```

Opaque source IDs should remain accessible as metadata/provenance, not as the primary human-readable label.

Example:

```text
Primary label:
Query-aware retrieval reranking

Metadata:
Source: frontier
Run: 05a8eac0
Harvest record: cross_modal_Advanced_age_frontier_18_7cdb
```

---

# 8. Do Not Treat "UPGRADE" as a Raw Harvest Status

The current raw inventory may label discoveries:

```text
UPGRADE
```

This is premature.

A Harvest discovery does not yet know whether Agent_X truly lacks the capability.

Replace raw-stage statuses with lifecycle states such as:

```text
RAW
DISTILLING
DISTILLED
GATE_A_PASS
GATE_A_REJECTED
NEEDS_EVIDENCE
READY_FOR_ASSIMILATION
ASSIMILATING
NO_CHANGE
DEFERRED
EXPERIMENT
MERGE
IMPLEMENT
IMPLEMENTED
VERIFIED
FAILED
```

Adapt exact names to existing Agent_X status conventions.

Do not create duplicate state systems if one already exists.

---

# 9. Rename "Benefit vs Agent_X" Before Assimilation

Before architectural comparison, Harvest can only describe a claimed or predicted benefit.

The current label:

```text
Benefit vs Agent_X
```

should be replaced before Gate B with:

```text
Claimed Benefit
```

or equivalent.

After Assimilation, expose a separate field:

```text
Verified Agent_X Delta
```

This distinction must be explicit.

Example:

```text
Claimed Benefit:
Improves query relevance.

Verified Agent_X Delta:
Existing ranking already includes objective similarity.

Disposition:
NO_CHANGE
```

Do not present speculative Harvest statements as verified repository facts.

---

# 10. Required Filter System

Add useful filters for Capability Distillation and Assimilation.

Minimum recommended filter dimensions:

## Lifecycle

```text
Raw
Distilled
Gate A Pass
Gate A Rejected
Needs Evidence
Ready for Assimilation
Assimilated
Experiment
Implement
Merge
No Change
Deferred
Rejected
Verified
```

## Capability Type

```text
Algorithm
Architecture
Policy
Heuristic
Data Transformation
Model/Prompt Behavior
UI/Workflow
Integration
Observability
Test/Benchmark
Non-actionable
```

## Evidence Strength

```text
Strong
Medium
Weak
Unsupported
```

## Technical Substance

```text
Complete Mechanism
Partial Mechanism
Description Only
No Mechanism
```

## Gate A

```text
Pass
Reject
Deferred for Evidence
```

## Agent_X Gap

```text
Confirmed Gap
Partial Overlap
Already Exists
Unknown
```

## Behavioral Delta

```text
Defined
Missing
```

## Architectural Owner

```text
Resolved
Unresolved
```

## Disposition

```text
Implement
Merge
Experiment
No Change
Defer
Reject
```

## Slop Risk

```text
Low
Medium
High
```

## Contamination Flags

```text
Unsupported Metric
Generated Terminology
Compound Idea
Marketing/Speculative Claim
No Consumer
No Measurable Outcome
No Inputs/Outputs
No Mechanism
No Architectural Owner
```

---

# 11. Add Saved / Quick Filters

Provide quick filter presets for common review workflows.

Useful presets include:

```text
Ready for Assimilation
```

Equivalent to:

```text
Gate A = PASS
```

---

```text
Implementation Candidates
```

Equivalent to:

```text
Disposition IN {IMPLEMENT, MERGE}
Behavioral Delta = DEFINED
Architectural Owner = RESOLVED
```

---

```text
Likely Slop
```

Equivalent to:

```text
Slop Risk = HIGH
```

---

```text
Needs Human Review
```

Equivalent to:

```text
Evidence = WEAK
OR
Owner = UNRESOLVED
OR
Gate A = DEFERRED_FOR_EVIDENCE
```

---

```text
No-Code Outcomes
```

Equivalent to:

```text
Disposition IN {NO_CHANGE, DEFER, REJECT}
```

---

# 12. Slop Risk Indicator

Add a `Slop Risk` field.

Do not implement it as a single opaque LLM confidence number.

It must be derived from explicit conditions.

Example:

```text
SLOP RISK: HIGH

Reasons:
- no concrete mechanism
- no defined inputs/outputs
- unsupported numerical acceptance criterion
- generated category has no repository owner
- combines unrelated capabilities
- no behavioral delta
```

Low-risk example:

```text
SLOP RISK: LOW

- problem defined
- mechanism defined
- inputs/outputs defined
- measurable effect defined
- source evidence retained
- architectural owner resolved
- Agent_X gap confirmed
```

Users must be able to inspect the reasons behind the risk level.

---

# 13. Row Expansion / Detail Drawer

Each inventory row should support an expanded detail view or side panel.

It must make the complete decision trail human-readable.

Recommended structure:

```text
CAPABILITY NAME

SOURCE
Producer
Run
Original Harvest Record
Original Focus
Source Evidence

RAW HARVEST MATERIAL
<original discovery text>

DISTILLATION

Extracted capability
Capability type
Problem
Mechanism
Inputs
Outputs
Dependencies
Expected behavioral effect
Evidence strength
Unknowns
Possible measurement

DISCARDED / DEMOTED MATERIAL

- generated category
- generated symbol
- unsupported metric
- speculative claim
- unrelated concept
...

GATE A

Decision
Reasons

ASSIMILATION

Existing architectural owner
Existing behavior
Capability overlap
Confirmed gap
Conflicts
Integration points

BEHAVIORAL DELTA

BEFORE
AFTER
EXPECTED OBSERVABLE CHANGE
MEASUREMENT

GATE B

Disposition
Reasons

VERIFICATION

Plan
Status
Result
```

Do not hide important rejection or discard reasoning.

---

# 14. Compound Harvest Records

The UI must represent that:

```text
1 Harvest record
```

may become:

```text
0..N distilled capabilities
```

Do not force one row to remain one implementation candidate.

Example:

```text
Source Harvest Record:
Query-aware re-rank × Undo/redo ledger

Distilled into:
- Query-aware retrieval reranking
- Reversible mutation journal
```

The UI should allow the source record to expand and show the derived capabilities.

If a Harvest record produces zero viable capabilities, show:

```text
No actionable capability extracted
```

with the rejection reason.

---

# 15. Show Discarded Material Explicitly

The UI should visibly show what Distillation discarded or demoted.

Example:

```text
Discarded from implementation authority:

- "alien technology" framing
- generated cross_modal domain
- generated handler name
- unsupported ≥0.8 threshold
- "novel domain leadership" claim
```

This is important because the user needs to know that the system actually removed contamination rather than merely hiding it.

---

# 16. Search Focus Must Be Visually Separated From Engineering Requirements

The current Harvest Focus field can contain speculative or exploratory prompts such as:

```text
Advanced agentic AI from the alien technology timetraveled from the distant future
```

This is acceptable as an exploration prompt.

However, the UI must clearly label it as:

```text
Exploration Focus
```

or:

```text
Search Focus
```

Do not allow the UI to imply that the focus string itself is an implementation requirement.

Add helper text such as:

```text
Used to guide discovery. This text does not become an implementation
requirement, architecture label, acceptance criterion, module name, or
coding instruction.
```

Keep the wording concise and professional.

---

# 17. Harvest Thresholds Need Better Semantics

The existing controls:

```text
Worthiness
Value to Agent_X
```

should remain discovery thresholds only.

Visually group them under:

```text
Discovery Thresholds
```

Do not present them as quality gates for implementation.

If useful, add text similar to:

```text
These thresholds rank discoveries only. Technical validity and Agent_X
fit are evaluated later by Distillation and Assimilation.
```

---

# 18. Add Distillation Controls to Harvest Workflow

After `Gather`, discovered records should enter a raw state.

Recommended flow:

```text
Gather
   ↓
Raw Harvest Inventory
   ↓
Distill Selected
```

For automated mode:

```text
Automate Harvesting
```

may optionally support:

```text
Auto-distill new Harvest results
```

as a separate checkbox/toggle.

Do not automatically allow:

```text
Auto-implement
```

from raw Harvest.

If there is an existing fully automated workflow, it must still pass Distillation, Gate A, Assimilation, Gate B, behavioral-delta validation, and verification requirements.

---

# 19. Recommended Harvest Tab Layout

Conceptually:

```text
HARVEST

TARGET

New worthy discoveries
[ 5 ]

HARVEST FOR

[ Update ] [ Upgrade ]

PRODUCERS

[ Balancer ] [ Gap-Filling ] [ Frontier ]

SEARCH / EXPLORATION FOCUS

[................................................]
[................................................]

Helper:
Guides discovery only. Does not become an engineering requirement.

DISCOVERY THRESHOLDS

Worthiness        Value to Agent_X
[ 0.95 ]          [ 0.95 ]

Helper:
Ranks discoveries only. Distillation and Assimilation determine
technical validity and implementation need.

AUTOMATION

[ ] Auto-distill newly harvested records

ACTIVITY
...

[ Gather ] [ Automate Harvesting ]
```

Do not overfill the UI with explanatory prose. Use concise helper text and tooltips where appropriate.

---

# 20. Recommended Inventory Layout

Conceptually:

```text
INVENTORY

[ Raw 2 ]
[ Distilled 3 ]
[ Gate A Pass 2 ]
[ Rejected 1 ]
[ Ready for Assimilation 1 ]
[ Implement/Merge 1 ]

Search inventory...

Filters ▾

Capability             Type        Substance   Gate A   Gap       Decision
───────────────────────────────────────────────────────────────────────────

Query-aware reranking  Algorithm   High        PASS     Unknown   Assimilate

Mutation journal       Architecture High       PASS     None      Defer

Domain leadership      Non-action. None        REJECT   —         Reject
```

Secondary metadata can remain available through column customization or row expansion.

---

# 21. Selection Rules

Selection must be lifecycle-aware.

Do not permit mixed-stage actions that make no semantic sense.

Example:

If selection contains:

```text
1 Raw
1 Gate A Pass
1 Implement
```

do not present one ambiguous bulk action.

Either:

- disable incompatible bulk actions, or
- group selected records by valid next action.

Example:

```text
2 items can be distilled
1 item can be assimilated
1 item can be implemented
```

Prefer clear stage-specific behavior over a generic "process selected" button.

---

# 22. Bulk Actions

Recommended bulk actions by stage:

## Raw

```text
Distill Selected
Reject Selected
Archive Selected
```

## Gate A Pass

```text
Assimilate Selected
Defer Selected
Reject Selected
```

## Experiment

```text
Run Selected Experiments
```

## Implement / Merge

```text
Implement Approved
```

## Rejected / No Change / Deferred

```text
Archive
Re-open for Review
```

Do not make `Clear inventory` the primary mechanism for managing rejected/no-change results.

Preserve provenance and history.

---

# 23. Visual Hierarchy

The interface should visually distinguish:

```text
discovery confidence
```

from:

```text
engineering approval
```

For example:

- Worth/Value/Rank = secondary metadata
- Gate A / Agent_X Gap / Disposition = primary decision metadata

Do not make a high `Rank` visually stronger than a `REJECT` or `NO_CHANGE` disposition.

Final architectural decision should dominate.

---

# 24. Badge Semantics

Use consistent badges/tags.

Examples:

```text
RAW
DISTILLED
PASS
REJECT
NEEDS EVIDENCE
NO CHANGE
DEFER
EXPERIMENT
MERGE
IMPLEMENT
VERIFIED
```

Capability-type badges:

```text
ALGORITHM
ARCHITECTURE
POLICY
HEURISTIC
INTEGRATION
TEST/BENCHMARK
NON-ACTIONABLE
```

Avoid ambiguous or premature badges such as:

```text
UPGRADE
```

before Gate B.

---

# 25. Evidence Visibility

The UI must make evidence inspectable.

At minimum expose:

```text
Evidence Strength
Source Count
Source Type
Source Reference
Unknowns
```

If a metric or claim is unsupported, label it clearly:

```text
UNVERIFIED CLAIM
```

Do not silently display it as an acceptance criterion.

---

# 26. Behavioral Delta Visibility

For records approved for implementation or merge, make the behavioral delta easy to inspect.

Recommended compact preview:

```text
Before:
Current retrieval ordering uses base score only.

After:
Ordering combines normalized base score with objective similarity.

Measure:
NDCG@10 / MRR / Recall@K
```

If the behavioral delta is missing, the UI should show:

```text
BLOCKED — Behavioral delta missing
```

and implementation action must be disabled.

---

# 27. Architectural Owner Visibility

Before implementation, expose:

```text
Architectural Owner
```

Examples:

```text
Resolved:
existing retrieval/ranking component

Unresolved:
repository comparison incomplete
```

If unresolved, implementation must be blocked.

Do not infer ownership from the Harvest domain name.

---

# 28. Gate A UI

Gate A should communicate whether a technically coherent capability exists.

Display:

```text
GATE A: PASS
```

or:

```text
GATE A: REJECT
```

or:

```text
GATE A: NEEDS EVIDENCE
```

Include short reasons.

Example:

```text
PASS
- concrete mechanism
- defined inputs/outputs
- measurable effect
```

Example:

```text
REJECT
- no mechanism
- no consumer
- generated promotional language only
```

---

# 29. Gate B UI

Gate B should communicate the Agent_X architectural decision.

Allowed dispositions:

```text
IMPLEMENT
MERGE
EXPERIMENT
NO_CHANGE
DEFER
REJECT
```

Do not collapse these into a generic `UPGRADE`.

The user must be able to see why a valid capability may still result in `NO_CHANGE` or `DEFER`.

---

# 30. Verification State

Implementation is not the final state.

Expose verification lifecycle where applicable:

```text
NOT RUN
RUNNING
PASSED
FAILED
REGRESSION
```

For experimental candidates, show benchmark result before promotion.

Example:

```text
Experiment Result:
NDCG@10 +4.8%
MRR +2.1%
No regression detected

Recommended disposition:
PROMOTE TO IMPLEMENT
```

Use actual metrics available from the backend.

Do not fabricate benchmark numbers in the UI.

---

# 31. Automation Safety

If `Automate Harvesting` continuously runs Harvest, automation must not mean:

```text
discover → code forever
```

The automated pipeline may be:

```text
discover
↓
distill
↓
Gate A
↓
assimilate
↓
Gate B
↓
experiment or implementation approval
↓
verify
```

but each stage must preserve the same rules as manual mode.

If the user enables a fully automated mode, the UI must show what stages are automated.

Example:

```text
Automation:
✓ Harvest
✓ Distill
✓ Assimilate
□ Implement
✓ Verify
```

Do not expose unsafe shortcuts that bypass gates.

---

# 32. Do Not Overload the UI

The redesign must remain usable.

Use:

- compact badges,
- expandable rows,
- filter drawer/popover,
- tooltips,
- secondary metadata sections,
- progressive disclosure.

Do not put every field into the main table.

The default table should answer:

```text
What is it?
Is it technically substantive?
Did it pass Gate A?
Does Agent_X need it?
What happens next?
```

Everything else can be expanded.

---

# 33. Preserve Current Visual Design Language

The current dark Borg-like Agent_X visual language should remain intact unless existing theme architecture requires changes.

Preserve:

- dark theme compatibility,
- light theme compatibility,
- modal structure,
- existing typography conventions,
- existing spacing system,
- existing controls where still valid,
- accessibility expectations,
- keyboard navigation,
- focus states,
- hover states,
- disabled states.

This task is primarily an information architecture and workflow correction, not a total visual rebrand.

---

# 34. Light Theme

Any UI changes must work in both:

```text
Dark Theme
Light Theme
```

Do not hardcode colors that only work in one theme.

Use existing design tokens/theme variables.

Status badges, warnings, selected rows, disabled buttons, and filter controls must remain readable in both themes.

---

# 35. Backend Contract Awareness

The UI must use the real backend lifecycle and data produced by Capability Distillation and Assimilation.

Do not fake states in frontend-only logic.

Do not create UI-only approximations such as:

```text
if rank > 0.9:
    status = "IMPLEMENT"
```

The UI must display decisions made by the actual backend gates.

Where backend fields do not yet exist, wire the UI only after the required backend contract is implemented or extend the backend contract correctly.

---

# 36. No Duplicate Decision Logic

Do not reimplement Gate A or Gate B reasoning independently in the frontend.

Frontend responsibilities:

```text
display
filter
sort
select
trigger allowed transitions
show reasons
show provenance
```

Backend responsibilities:

```text
distill
classify
evaluate
decide
validate
authorize implementation
```

Frontend may derive presentation-only indicators such as expanded/collapsed state.

It must not invent engineering approval.

---

# 37. Required Search Improvements

Inventory search should match normalized capability content, not only generated item IDs.

Search should cover at least:

```text
capability name
problem
mechanism
source ID
source producer
domain
architectural owner
disposition
discard reasons
```

If existing search infrastructure supports it, include evidence text.

Do not make raw opaque IDs the main discoverability mechanism.

---

# 38. Sorting

Recommended sortable columns:

```text
Capability
Evidence
Substance
Slop Risk
Gate A
Agent_X Gap
Disposition
Worth
Value
Rank
```

The default sort should not necessarily be raw Harvest rank.

Prefer a lifecycle-aware or review-priority order, for example:

```text
1. implementation candidates
2. ready for assimilation
3. needs evidence/review
4. raw
5. no-change/deferred
6. rejected
```

If existing UX conventions prefer rank ordering, keep rank as an optional sort.

---

# 39. Empty States

Provide useful empty states.

Examples:

## No raw items

```text
No raw Harvest discoveries.
Run Harvest to gather new candidates.
```

## No implementation candidates

```text
No capabilities currently qualify for implementation.
```

## Filtered to likely slop

```text
No high-risk items match the current filters.
```

Keep copy concise.

---

# 40. Error States

Failures must be visible.

Examples:

```text
Distillation failed
Assimilation failed
Repository comparison unavailable
Evidence incomplete
Verification failed
```

Do not silently revert items to `RAW` or `UPGRADE`.

Expose retry where appropriate.

---

# 41. Audit / Provenance UI

Users should be able to trace:

```text
Harvest source
↓
Distilled capability
↓
Gate A decision
↓
Assimilation result
↓
Gate B disposition
↓
Implementation
↓
Verification
```

A timeline or structured history section is acceptable.

Use existing audit/history components if available.

---

# 42. Example Desired Treatment of Current Noisy Item

For a current raw record similar to:

```text
cross_modal_Advanced_age_frontier_18_7cdb
```

with content combining:

```text
query-aware reranking
undo/redo ledger
alien-technology focus text
unsupported grounding threshold
```

the UI should eventually present:

```text
SOURCE RECORD
cross_modal_Advanced_age_frontier_18_7cdb

Distillation:
2 capabilities extracted
3+ contaminated claims discarded
```

Derived capability:

```text
Query-aware retrieval reranking
Type: ALGORITHM
Evidence: MEDIUM
Substance: HIGH
Gate A: PASS
Agent_X Gap: PENDING
Next Action: ASSIMILATE
```

Derived capability:

```text
Reversible mutation journal
Type: ARCHITECTURE
Evidence: MEDIUM
Substance: HIGH
Gate A: PASS
Agent_X Gap: NONE / NOT JUSTIFIED
Disposition: DEFER
```

Discarded:

```text
alien-technology framing
generated cross_modal label
generated handler name
unsupported numeric target
domain-leadership claim
```

There must be no `Code` button on the original source record.

---

# 43. Repository Reconnaissance Before UI Coding

Before modifying UI code:

1. inspect the actual Collective Harvest modal implementation;
2. find the current inventory component;
3. find the current Harvest configuration component;
4. find state/store ownership;
5. find API/backend calls;
6. find how `Code All Selected Items` is currently triggered;
7. find current item status schema;
8. find theme tokens;
9. find table/filter primitives;
10. find existing expandable/detail components;
11. find current automation controls;
12. identify tests.

Do not guess paths from this document.

Modify the actual owners.

---

# 44. Remove Old Bypass Paths

After implementing the new UI flow, search for old frontend paths that can trigger coding from raw Harvest inventory.

Examples:

```text
Code All Selected Items
codeSelectedItems(...)
implementHarvestItem(...)
direct code-generation buttons
context-menu code action
keyboard shortcuts
automation paths
```

Remove or gate every bypass.

Do not leave hidden or alternate routes to the old behavior.

---

# 45. Tests

Add/update UI tests covering at least:

## Raw item behavior

Raw Harvest rows show:

```text
Distill
```

and do not show:

```text
Implement
Code
```

## Gate A pass

Gate A PASS rows may expose Assimilation but not production implementation.

## Gate A reject

Rejected rows do not expose implementation actions.

## Gate B implement

Only IMPLEMENT/MERGE rows with required backend approval expose `Implement Approved`.

## Behavioral delta missing

Implementation action is disabled/hidden.

## Owner unresolved

Implementation action is disabled/hidden.

## Mixed selection

Invalid bulk actions are not exposed.

## Slop risk

Risk level and reasons render correctly.

## Filters

Capability type, evidence, Gate A, gap, disposition, and slop risk filters work.

## Search

Normalized capability names are searchable.

## Compound source records

One raw record can display multiple distilled capabilities.

## Zero-capability result

A record with no viable capability displays a proper rejection/no-action result.

## Theme compatibility

New UI works in both dark and light themes.

## Automation

Automated Harvest does not bypass Distillation and Gate A/Gate B states.

---

# 46. Acceptance Criteria

The UI work is complete only when:

- [ ] Raw Harvest items cannot directly trigger coding.
- [ ] `Code All Selected Items` is removed from raw inventory behavior.
- [ ] `Distill Selected` exists for raw records.
- [ ] `Assimilate Selected` exists only for appropriate distilled/Gate A-approved records.
- [ ] `Implement Approved` exists only for backend-approved IMPLEMENT/MERGE records.
- [ ] Raw `UPGRADE` status is no longer treated as architectural truth.
- [ ] Claimed benefit is visually distinct from verified Agent_X delta.
- [ ] Capability type is visible.
- [ ] Evidence strength is visible.
- [ ] Technical substance is visible.
- [ ] Gate A result is visible.
- [ ] Agent_X gap result is visible after Assimilation.
- [ ] Gate B disposition is visible.
- [ ] Slop risk is visible with inspectable reasons.
- [ ] Contaminated/discarded content can be inspected.
- [ ] Compound Harvest records can produce multiple derived capability views.
- [ ] Zero-capability outcomes are supported.
- [ ] Behavioral delta is visible for implementation candidates.
- [ ] Architectural owner is visible/resolved before implementation.
- [ ] Verification state is represented.
- [ ] Filtering supports lifecycle, type, evidence, substance, Gate A, gap, disposition, owner, behavioral delta, and slop risk.
- [ ] Search works on human-readable capability data.
- [ ] Bulk actions are lifecycle-aware.
- [ ] Automated flows do not bypass gates.
- [ ] Dark and light themes both work.
- [ ] Existing Borg/Agent_X visual language is preserved.
- [ ] No duplicate frontend-only Gate A/Gate B decision engine is created.
- [ ] All old direct-code UI bypasses are removed or correctly gated.
- [ ] Tests prove raw Harvest cannot trigger implementation.

---

# 47. Final Implementation Rule

The final UI must make this flow obvious:

```text
HARVEST FOUND SOMETHING
        ↓
DISTILL WHAT IS ACTUALLY USEFUL
        ↓
REJECT OR PASS GATE A
        ↓
COMPARE AGAINST REAL AGENT_X
        ↓
DECIDE IMPLEMENT / MERGE / EXPERIMENT / NO_CHANGE / DEFER / REJECT
        ↓
ONLY APPROVED ITEMS MAY BE CODED
```

The interface must stop communicating:

```text
High Harvest score → Upgrade → Code
```

and instead communicate:

```text
Interesting discovery
    ≠
Valid capability
    ≠
Missing capability
    ≠
Approved implementation
```

This distinction must be enforced by actual UI behavior, not merely by labels or explanatory text.
