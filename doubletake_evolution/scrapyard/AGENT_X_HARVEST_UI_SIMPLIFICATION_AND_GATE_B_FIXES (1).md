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

The primary interface should require only the controls needed to operate the overall system:

```text
[ Start Mining ]
[ Stop Mining ]
```

If there are unresolved exceptional decisions, one additional contextual control may appear:

```text
[ Review 1 Item ]
```

Do not expose separate controls for evaluation, Gate A, Gate B, preparation, routing, assimilation, verification, or queue management on the normal screen.

Automation policy may still be configurable, but it belongs under a compact Settings / Advanced area and must not turn the main screen back into a pipeline control panel.

The default policy should be the most automated safe mode:

```text
Start Mining
    ↓
Discover
    ↓
Evaluate
    ↓
Gate
    ↓
Assimilate when authorized
    ↓
Verify
    ↓
Continue
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

# 21. Establish One Canonical Gate B Authority

There must be exactly one canonical implementation-authorization decision.

No UI component, worker, database update, scheduler, replay tool, CLI command, API route, batch job, migration, or assimilation helper may independently infer that a candidate is authorized to modify the repository.

All implementation paths must obtain a canonical Gate B result from the same authority boundary.

Conceptually:

```text
Candidate
   ↓
Canonical Gate B evaluator
   ↓
Signed / immutable decision record
   ↓
AUTHORIZED or NOT AUTHORIZED
```

Downstream code may consume the decision.

Downstream code must not recreate it.

A good internal contract is conceptually similar to:

```python
GateBDecision(
    candidate_id=...,
    authorized=True | False,
    reasons=[...],
    evidence_refs=[...],
    repo_revision=...,
    policy_revision=...,
    decision_version=...,
)
```

The exact type and field names may differ, but the architectural property must remain: one authoritative decision, with evidence and version context.

---

# 22. Make Gate B Fail Closed

If Gate B cannot establish that implementation is justified, the candidate must not proceed to coding.

Examples that must fail closed:

- missing repository evidence,
- stale repository analysis,
- missing capability comparison,
- malformed candidate data,
- unavailable policy/governance data,
- ambiguous decision state,
- evaluator exception,
- missing verification plan,
- conflicting authoritative decisions,
- unknown decision version,
- missing required evidence.

The fallback must never be:

```text
uncertain
   ↓
probably upgrade
   ↓
implement anyway
```

The fallback should be:

```text
uncertain
   ↓
retain / defer / needs review
```

---

# 23. Prevent All Alternate Authority Bypasses

Removing `agentx_status` from one `if` statement is insufficient.

Audit every path capable of reaching:

- code generation,
- file writes,
- patch application,
- repository mutation,
- assimilation execution,
- automatic commit,
- implementation queue insertion.

No field such as the following may independently grant implementation authority:

```text
status
classification
priority
producer
source
score
confidence
worth
value
rank
recommendation
approved
selected
queued
upgrade
update
new_capability
implementation_candidate
```

Any of these may contribute evidence or workflow state.

None may substitute for the canonical Gate B decision.

Add tests that deliberately set each metadata field to its strongest possible "implement" value while Gate B is false and verify that no repository mutation occurs.

---

# 24. Separate Workflow State from Decision Authority

Internal state such as:

```text
queued
evaluating
ready
implementing
verified
failed
```

describes where an item is in the workflow.

It does not answer whether an item is permitted to be implemented.

Likewise:

```text
upgrade
update
new capability
```

describes classification.

The architecture must keep three concepts separate:

```text
Classification
    = what Agent_X thinks the item represents

Workflow state
    = where the item currently is

Authority
    = whether repository mutation is permitted
```

Do not store them in one overloaded status field.

---

# 25. Define Gate A and Gate B Boundaries Precisely

The two gates must have distinct responsibilities.

## Gate A — Information / Capability Worthiness

Gate A should answer questions such as:

- Is there a coherent idea or capability here?
- Is the evidence meaningful enough to analyze?
- Is this more than noise, duplication, or malformed material?
- Is it relevant to Agent_X?
- Is it worth repository-grounded evaluation?

Passing Gate A must not authorize coding.

## Gate B — Implementation Authorization

Gate B should answer:

- Does Agent_X actually lack or materially underperform this capability?
- Is implementation justified in the current repository revision?
- Is the proposed mechanism concrete and substantive?
- Is the expected benefit greater than cost/risk?
- Is it architecturally compatible?
- Is there a verifiable implementation plan?
- Does governance permit the change?
- Is this candidate still non-duplicate and non-superseded?

Only Gate B can authorize entry into the implementation path.

---

# 26. Bind Decisions to Repository and Policy Revisions

A Gate B decision can become stale when:

- the repository changes,
- another candidate implements the same capability,
- architecture changes,
- governance changes,
- dependencies change,
- a newer candidate supersedes it.

Therefore an authorization must be bound to the repository revision and relevant policy/governance revision used to make the decision.

Before implementation begins, verify that the decision is still current.

If not, re-evaluate rather than blindly using an old approval.

This prevents:

```text
Gate B approved yesterday
        ↓
repository changed today
        ↓
old plan implemented anyway
```

---

# 27. Treat Harvested Content as Untrusted Data

External material may contain instructions, code, prompts, malicious text, or accidental commands.

Patents, papers, web pages, repositories, documents, embeddings, generated summaries, and harvested text must be treated as evidence, not authority.

Harvested text must never be able to directly instruct Agent_X to:

- bypass Gate A or Gate B,
- alter governance,
- write files,
- run shell commands,
- change policy,
- disable verification,
- expose secrets,
- import arbitrary executable code,
- treat embedded instructions as system/user commands.

The boundary must be:

```text
External content
      ↓
Untrusted evidence
      ↓
Normalize / extract claims and mechanisms
      ↓
Agent_X reasoning and governance
```

Never:

```text
External content
      ↓
Instruction execution
```

---

# 28. Add Durable Idempotency and Duplicate Protection

Continuous autonomous mining must not repeatedly implement the same idea.

Every candidate needs stable identity sufficient to detect:

- exact duplicates,
- semantic duplicates,
- re-ingestion of the same source,
- renamed copies,
- previously rejected candidates,
- previously implemented capabilities,
- superseded variants.

Before Gate B and again before repository mutation, perform duplicate/supersession checks against current state.

Repeated ingestion must be idempotent:

```text
same evidence + same repository state
    ≠
another implementation
```

If two workers encounter equivalent candidates concurrently, only one should be allowed to proceed.

---

# 29. Define Concurrency, Queueing, and Backpressure

Continuous mining must remain bounded and controllable.

The orchestrator must define:

- maximum concurrent mining jobs,
- maximum concurrent evaluations,
- maximum concurrent assimilation jobs,
- queue limits,
- duplicate coalescing,
- priority policy,
- starvation prevention,
- retry limits,
- backoff behavior,
- resource limits.

Do not let an infinite mining loop create an infinite in-memory or database queue.

When downstream processing is saturated, upstream harvesting should slow, pause, or coalesce work.

---

# 30. Define Safe Stop Semantics

`Stop Mining` must have precise behavior.

It should:

1. stop scheduling new discovery/mining work,
2. stop creating new assimilation jobs,
3. preserve durable state,
4. safely finish or cancel work according to operation type,
5. never leave partially applied repository mutations,
6. leave the system restartable.

A repository write or patch application must be treated differently from a cancellable analysis job.

If implementation has entered a transactional mutation phase, Agent_X should either:

- complete the atomic unit and verify it, or
- roll it back.

`Stop` must not mean "kill everything immediately and hope the repository is consistent."

---

# 31. Make Crash / Restart Recovery First-Class

Autonomous mining must survive process crashes, UI reloads, machine restarts, and worker failures.

Persist enough state to recover:

- queued candidates,
- active stage,
- last completed stage,
- decision records,
- implementation plan,
- repository revision,
- verification state,
- retry count,
- final disposition.

On restart:

```text
recover durable state
      ↓
validate against current repository
      ↓
resume safe work
or
re-evaluate stale work
```

Do not rely on UI memory or in-process state as the source of truth.

---

# 32. Require Transactional Implementation and Rollback

Assimilation must not leave the repository half-modified.

For each authorized implementation:

```text
prepare
  ↓
apply isolated change
  ↓
verify
  ↓
accept
```

If verification fails:

```text
verification failure
      ↓
rollback / discard isolated change
      ↓
record failure
      ↓
retain evidence and diagnostics
```

A failed implementation must never be reported as assimilated.

Where possible, changes should be prepared in an isolated worktree, temporary branch, patch set, or equivalent transaction boundary before acceptance into the active repository state.

---

# 33. Strengthen Verification Beyond "Code Exists"

Verification must prove that the intended capability was implemented rather than merely proving that files were generated.

Verification should include, as applicable:

- syntax / compile checks,
- unit tests,
- integration tests,
- regression tests,
- acceptance-criterion tests,
- deterministic behavior checks,
- import/no-side-effect checks where relevant,
- boundedness/resource checks,
- architecture invariants,
- governance invariants,
- tests proving Gate B cannot be bypassed,
- tests proving placeholder-only implementations fail the substance check.

For claims such as:

```text
improves hit-rate by ≥15%
cuts wasted evolutions by ~30%
```

verification must include an actual reproducible benchmark or simulation capable of evaluating the claim.

A prose claim in Harvest metadata is not verification.

---

# 34. Require Mechanism-Level Implementation Plans

Before coding, the implementation plan should describe the mechanism at a level that distinguishes real engineering from generated scaffolding.

At minimum, where applicable:

```text
Problem
Current repository behavior
Missing capability
Proposed mechanism / algorithm
Why this mechanism is appropriate
Affected modules
Inputs / outputs
State model
Data structures
Integration points
Complexity / bounds
Failure cases
Tests
Acceptance criteria
Rollback strategy
```

A plan that only says:

```text
add handler
add dispatch
add bucket
add record processor
```

without explaining the actual behavior being added should fail the substance check.

---

# 35. Avoid New Files When Existing Architecture Should Be Extended

Harvest-driven coding must not default to creating a new `.py` file for every candidate.

Before creating a module, Gate B / implementation planning must determine whether the correct change is:

- extend an existing implementation,
- modify an existing algorithm,
- wire an existing capability correctly,
- delete obsolete code,
- consolidate duplicated code,
- add a test,
- change configuration,
- change data flow,
- create a genuinely new module.

This is necessary to prevent Harvest from becoming a code-clutter generator.

New modules must have an architectural reason to exist.

---

# 36. Add Supersession and Cleanup Behavior

Mining will discover better versions of ideas already retained or implemented.

Agent_X must be able to mark candidates as:

```text
superseded
merged
obsolete
replaced
```

and avoid treating old candidates as active work.

When a new implementation replaces an older Harvest-generated implementation, the process should consider removal or consolidation of obsolete code rather than only adding more code.

The system should optimize for repository quality, not number of assimilated artifacts.

---

# 37. Make Human Review an Additional Constraint, Not an Authority Shortcut

For exceptional changes requiring user review:

```text
Gate B = authorized
        +
Human review required by policy
        ↓
User approves
        ↓
Implementation may proceed
```

Human approval must not mean:

```text
User clicked Approve
        ↓
bypass Gate B
```

Likewise, the UI must not expose a button capable of forcing an unauthorized candidate into implementation.

A user rejection may always stop a candidate.

A user approval may satisfy a required human-review condition, but it must not override governance or missing implementation evidence.

---

# 38. Simplify the Review Experience

When review really is required, show the minimum information needed for the decision:

```text
What Agent_X wants to change
Why
Expected benefit
Main risk
Scope of change
Recommendation
```

Then provide only the necessary actions, for example:

```text
[ Approve ]
[ Reject ]
[ Details ]
```

`Details` may expose evidence and diagnostics.

Do not make the user inspect raw database fields or manually edit classification/status values.

---

# 39. Define a Minimal Main-Screen Information Budget

The default screen should not gradually accumulate every new metric.

Keep only information with direct operator value.

Recommended main-screen information:

```text
Current state
Start / Stop
Useful discoveries
Implemented count
Needs Review count
Recent meaningful activity
Error / blocked state when present
```

Metrics such as raw source count may remain if useful, but they should not compete visually with outcomes.

Everything else belongs in History, Details, or Advanced.

This should be treated as an architectural constraint, not merely a visual preference.

---

# 40. Make Errors Actionable but Quiet

Normal transient failures should be retried automatically within bounded policy.

The user should only see an error prominently when:

- automation cannot continue,
- repository integrity is at risk,
- credentials/resources are required,
- retry limits are exhausted,
- human intervention is genuinely required.

The UI should present:

```text
What failed
What Agent_X already tried
Whether mining can continue
What requires attention
```

Avoid flooding the activity feed with low-level retry noise.

---

# 41. Add Durable Decision Provenance

For each important decision, retain enough provenance to explain later:

```text
Why was this implemented?
Why was this rejected?
What evidence was used?
What repository state was examined?
Which policy version applied?
Which tests passed?
What changed?
```

The audit record should be machine-readable as well as human-readable.

This supports later debugging, regression analysis, and governance review without forcing the normal UI to display the details.

---

# 42. Prevent UI State from Becoming Backend Truth

The browser/UI must be a view and control surface over backend state.

It must not be the authoritative source for:

- mining state,
- candidate disposition,
- Gate A,
- Gate B,
- authorization,
- implementation completion,
- verification status.

Reloading the page must not change system truth.

The backend/orchestrator must own durable workflow state.

---

# 43. Define the Automation Policy Explicitly

To keep the main UI simple, automation behavior should be controlled by a backend policy rather than many front-page checkboxes.

A recommended default policy is:

```text
discover automatically
evaluate automatically
deduplicate automatically
retain knowledge automatically
reject obvious noise automatically
assimilate Gate-B-authorized normal-risk changes automatically
request review only for policy-defined exceptional changes
verify automatically
rollback failed implementations automatically
continue mining
```

Advanced settings may allow less-autonomous operation for debugging or development, but the normal operator experience should follow this policy.

---

# 44. Add End-to-End Invariant Tests

The redesign is not complete until tests prove the architecture cannot regress.

Required invariant tests should include:

## Authority invariants

```text
agentx_status=upgrade + GateB=false → no repository mutation
agentx_status=update + GateB=false → no repository mutation
high score + GateB=false → no repository mutation
user UI approval + GateB=false → no repository mutation
queued=true + GateB=false → no repository mutation
```

## Automation invariants

```text
Start Mining → complete pipeline advances without manual stage clicks
Stop Mining → no new work scheduled and repository remains consistent
restart → durable work resumes or is safely re-evaluated
duplicate candidate → no duplicate implementation
```

## Substance invariants

```text
placeholder-only candidate → not assimilated
real mechanism + evidence + GateB=true → eligible for implementation
failed acceptance tests → not marked Implemented
```

## UI invariants

```text
normal view → no raw Gate controls
normal view → no agentx_status authority selector
normal view → no low-level dispatch controls
Advanced → detailed diagnostics remain available
```

---

# 45. Migration of Existing Harvest Records

Existing records may already contain overloaded `agentx_status` values or workflow states.

Migration must:

1. preserve old records for audit,
2. stop interpreting old statuses as authority,
3. map classification into a non-authoritative field,
4. derive workflow state separately,
5. require fresh Gate B evaluation before any pending item can implement,
6. mark stale prior approvals as needing re-evaluation when their decision provenance is insufficient.

Do not grandfather old `update` / `upgrade` values into the new authorization model.

---

# 46. Repository-Clutter Metrics

Because one of the explicit goals is to prevent low-value generated code, track internal quality metrics such as:

- candidate-to-implementation ratio,
- duplicate rejection rate,
- placeholder rejection rate,
- failed-verification rate,
- new-module creation rate,
- consolidation/deletion rate,
- reimplementation rate,
- superseded-code cleanup rate,
- accepted changes with measurable benefit.

These belong in diagnostics/analytics, not the normal UI.

They should help detect whether autonomous Harvest is becoming a code-volume generator rather than a capability-improvement system.

---

# 47. Final Target Runtime Architecture

```text
                            USER
                             │
                       Start / Stop
                             │
                             ▼
                ┌────────────────────────┐
                │ DURABLE ORCHESTRATOR   │
                └───────────┬────────────┘
                            │
           ┌────────────────┼────────────────┐
           ▼                ▼                ▼
       Frontier          Gap Fill          Balance
           └────────────────┼────────────────┘
                            ▼
                         Harvest
                            ▼
                 Normalize / Untrusted-Data
                         Boundary
                            ▼
                    Deduplicate / Merge
                            ▼
                         Gate A
                            ▼
                  Repository Comparison
                            ▼
                    Substance Check
                            ▼
                 Canonical Gate B Authority
                            ▼
                  Staleness / Revision Check
                            ▼
             ┌──────────────┼───────────────┐
             ▼              ▼               ▼
          Retain         Reject        Authorized
                                            │
                                      Human review?
                                      ┌─────┴─────┐
                                      │           │
                                     No          Yes
                                      │           │
                                      │       Review only if
                                      │       policy requires
                                      │           │
                                      └─────┬─────┘
                                            ▼
                                Transactional Assimilation
                                            ▼
                                        Verify
                                      ┌─────┴─────┐
                                      │           │
                                    Pass         Fail
                                      │           │
                                      ▼           ▼
                                   Accept      Rollback
                                      │           │
                                      └─────┬─────┘
                                            ▼
                                  Durable Audit Record
                                            ▼
                                         Repeat
```

---

# 48. Make Gate B a Mechanically Enforceable Contract

Gate B must not be implemented as an unconstrained LLM opinion such as:

```text
"This looks useful. PASS."
```

The canonical evaluator may use LLM reasoning, but the final authorization must satisfy machine-checkable preconditions.

At minimum, an authorization record should prove that:

- the candidate has a stable identity,
- the candidate passed Gate A,
- the repository revision is known,
- relevant repository evidence is attached,
- duplicate/supersession checks passed,
- a concrete mechanism-level implementation plan exists,
- affected modules are identified,
- blast radius is bounded or explicitly reviewed,
- a verification plan exists,
- required governance/policy checks passed,
- required human review, if any, is satisfied,
- the decision has not expired or become stale.

A downstream mutation guard should reject any authorization object that is missing required fields, malformed, unverifiable, stale, or inconsistent.

Conceptually:

```text
LLM / analysis proposes decision
          ↓
Typed decision schema
          ↓
Mechanical precondition validator
          ↓
Canonical Gate B decision
          ↓
Repository mutation guard
```

This prevents replacing `agentx_status` authority with another soft LLM-generated boolean.

---

# 49. Use Typed Schemas at Every Pipeline Boundary

Every major stage should exchange validated structured records rather than loosely interpreted dictionaries or free-form text.

At minimum, define explicit schemas for:

- source record,
- normalized evidence record,
- candidate capability,
- Gate A decision,
- repository comparison,
- substance-check result,
- Gate B decision,
- human-review requirement,
- implementation plan,
- mutation transaction,
- verification result,
- final disposition.

Unknown enum values, missing required fields, schema-version mismatches, and malformed records must fail closed.

Do not allow code such as:

```python
if record.get("status"):
    ...
```

to infer semantics from generic truthiness.

Use explicit typed meanings.

---

# 50. Record Model, Prompt, Evaluator, and Schema Versions

LLM-assisted analysis is nondeterministic and may change when models, prompts, evaluators, or schemas change.

Decision provenance should therefore record, where applicable:

- model/provider identifier,
- evaluator version,
- prompt/template version,
- schema version,
- policy version,
- relevant configuration version,
- repository revision,
- deterministic inputs or evidence references.

Do not depend on hidden conversational state as part of an implementation-authority decision.

A decision should be reconstructable from durable inputs as far as practical.

If a material evaluator or policy version changes, pending authorizations should be eligible for re-evaluation rather than silently inheriting old semantics.

---

# 51. Build a Canonical Capability Ledger

Agent_X needs a durable repository-grounded representation of what capabilities already exist.

Without this, Harvest will repeatedly rediscover concepts and may generate redundant implementations because each candidate is evaluated in isolation.

Maintain a capability ledger/index derived from the repository and verified implementation history.

The ledger should capture, as practical:

- capability identity,
- implementation location,
- current mechanism,
- related tests,
- relevant interfaces,
- known limitations,
- provenance,
- implementation revision,
- supersession relationships.

The ledger is an analytical index, not an independent authority source.

Before Gate B, compare the candidate against both:

```text
current repository
+
capability ledger
```

The repository remains the final truth when the ledger and code disagree.

The ledger must be refreshed or invalidated when relevant repository state changes.

---

# 52. Aggregate Related Findings Before Coding

Multiple harvested items may describe parts of the same underlying capability.

Do not automatically turn each item into a separate implementation candidate or module.

Before Gate B, cluster/merge related findings where doing so produces a more coherent implementation.

Example:

```text
source A → adaptive threshold idea
source B → rank normalization idea
source C → scheduler priority idea

            ↓ aggregate

one coherent scheduling improvement candidate
```

This reduces micro-patches, duplicate handlers, artificial abstractions, and code clutter.

A source record is not necessarily a one-to-one implementation unit.

---

# 53. Define Evidence Quality, Conflict, and Uncertainty Handling

Harvested evidence can be incomplete, contradictory, speculative, outdated, or low quality.

The evaluation layer should explicitly distinguish:

- directly observed repository facts,
- verified external facts,
- inferred mechanisms,
- claims without validation,
- conflicting evidence,
- uncertainty.

Gate B should not convert uncertain claims into certain implementation requirements.

When material evidence conflicts, the system should:

1. record the conflict,
2. prefer stronger/direct evidence according to policy,
3. seek additional repository-grounded evidence where possible,
4. defer or request exceptional review if the conflict remains material.

Raw confidence scores must not become authority shortcuts.

---

# 54. Revalidate Human Review Decisions Before Mutation

A user may approve an exceptional change and then the repository may change before implementation begins.

Therefore human approval must be bound to the candidate and decision context.

Before mutation, verify that:

- the approved candidate is the same candidate,
- the implementation plan has not materially changed,
- Gate B remains valid,
- repository/policy revisions are still compatible,
- the approval has not expired under policy.

If material context changed, re-evaluate and, where necessary, request review again.

Never treat an old generic `approved=true` field as permanent authority.

---

# 55. Do Not Let Pending Reviews Block Unrelated Mining

`Needs Review` items should normally be isolated from the continuous mining loop.

If one candidate awaits review, Agent_X should continue discovering, evaluating, retaining, rejecting, and implementing unrelated authorized work.

Only block other work when there is a real dependency or conflict, for example:

- overlapping files/modules,
- architecture-wide migration dependency,
- shared schema transition,
- repository lock required for a critical mutation.

The UI should therefore show pending review without turning the entire system into a modal workflow.

---

# 56. Enforce Source Provenance, License, and Reuse Boundaries

Harvest may ingest source code, papers, patents, documentation, repositories, or other third-party material.

The system must retain source provenance and distinguish:

- learning a mechanism or idea,
- paraphrasing a design,
- copying implementation text/code,
- importing a dependency,
- reproducing licensed material.

Before reusing third-party code or adding dependencies, check applicable licensing/provenance policy.

If license/provenance is unknown or incompatible, the system may still reason from ideas where legally/policy-appropriate, but it must not blindly copy source material into Agent_X.

Audit records should retain enough provenance to explain where an assimilated idea originated without making source metadata execution authority.

---

# 57. Harden Source Ingestion

Autonomous ingestion must be bounded against malformed or adversarial files.

Where relevant, protect against:

- archive path traversal,
- decompression bombs,
- unexpectedly huge files,
- recursive archives,
- malformed encodings,
- binary files mislabeled as text,
- pathological line/record sizes,
- parser crashes,
- duplicate archive contents,
- symlink/path escape behavior.

Apply explicit size, recursion, record, and resource limits.

Source ingestion failures should quarantine or reject the affected source rather than destabilize the mining loop.

---

# 58. Protect Secrets and Sensitive Repository Material

Harvest/analysis workers and external model calls must not leak repository secrets or credentials.

The pipeline should define controls for:

- secret detection/redaction where needed,
- least-privilege tool access,
- environment-variable handling,
- credential isolation,
- preventing harvested content from requesting secrets,
- preventing logs/audit records from persisting credentials,
- preventing generated patches from embedding secrets.

A candidate that requires access beyond its authorized tool/resource scope should fail or escalate according to policy rather than silently broadening permissions.

---

# 59. Constrain Tool, Network, Shell, and Dependency Use

Code generation and verification may need tools, but harvested content must not determine tool authority.

Define explicit policy for:

- shell execution,
- network access,
- package installation,
- dependency additions,
- filesystem scope,
- repository scope,
- subprocess limits,
- timeouts.

New dependencies should require justification including:

- why existing dependencies/stdlib are insufficient,
- maintenance/security cost,
- license compatibility,
- version constraints,
- test coverage.

Do not let a harvested snippet execute commands or install packages simply because those commands appear in the source material.

---

# 60. Bound Change Scope and Blast Radius

Before implementation, estimate the intended change scope.

Examples:

- files/modules touched,
- interfaces changed,
- data migrations required,
- configuration changes,
- dependency changes,
- public API changes,
- expected test surface.

Normal-risk autonomous assimilation should operate within policy-defined scope limits.

Large blast-radius changes should trigger exceptional review or decomposition.

Unexpected scope growth during implementation must invalidate the original plan and force re-evaluation rather than silently expanding the patch.

---

# 61. Add Resource Budgets and Circuit Breakers

An infinite mining loop must be operationally bounded.

Define budgets for, as applicable:

- CPU,
- memory,
- disk,
- model/token usage,
- worker count,
- source-processing rate,
- candidate queue depth,
- patch attempts,
- test duration,
- retries.

If a subsystem repeatedly fails or consumes abnormal resources, trip a circuit breaker, quarantine the problematic work, and continue unrelated work where safe.

The user should see a concise blocked/degraded status only when intervention is actually required.

---

# 62. Handle No-Novelty and Exhausted-Frontier Conditions

Continuous mining should not busy-loop when there is nothing useful to discover.

When novelty drops below policy thresholds or sources/frontiers are temporarily exhausted, Agent_X should:

- back off,
- reduce scan frequency,
- rotate to other discovery strategies/sources,
- avoid repeatedly reprocessing unchanged material,
- wake when new evidence/repository changes make re-evaluation useful.

`Mining` should mean continuous autonomous operation, not wasteful constant recomputation.

---

# 63. Use Atomic Worker Claims and Exactly-Once Repository Effects

In multi-worker operation, workers must claim candidate work atomically.

Use leases/locks or an equivalent durable claim mechanism with recovery for abandoned work.

Exactly-once processing of every analytical step is not always necessary, but repository mutation effects must behave as exactly-once from the user's perspective.

A retry after timeout/crash must not apply the same patch twice.

Before mutation, verify:

```text
candidate identity
+
authorization identity
+
transaction identity
+
current repository revision
```

and reject duplicate effects.

---

# 64. Define Durable Data Retention and Compaction

Continuous mining can create unbounded history even if code generation is controlled.

Define retention/compaction rules for:

- raw harvested data,
- embeddings,
- duplicate records,
- temporary analysis artifacts,
- failed candidate traces,
- logs,
- verification output,
- obsolete queue records.

Preserve enough data for provenance, reproducibility, and governance while avoiding unlimited storage growth.

Compaction must not destroy the minimum evidence required to explain accepted repository changes.

---

# 65. Define Health, Observability, and Liveness Separately from UI Complexity

The simple UI must not imply poor observability.

Internally expose structured health/metrics for:

- orchestrator state,
- worker health,
- queue depth,
- stage latency,
- retry/failure rates,
- Gate A/B pass rates,
- verification failures,
- duplicate/supersession rates,
- resource pressure,
- circuit-breaker state,
- repository mutation success/rollback rate.

Advanced/Diagnostics can expose these details.

The main UI should summarize them into simple states such as:

```text
Running
Degraded
Blocked
Stopped
```

Do not derive `Running` merely from the browser having an open connection; it must reflect backend liveness.

---

# 66. Version and Validate Configuration

Automation behavior should come from explicit, versioned configuration rather than scattered constants and UI defaults.

Configuration should include, where relevant:

- concurrency limits,
- retry policy,
- Gate thresholds,
- review policy,
- resource budgets,
- source limits,
- scope limits,
- retention policy,
- allowed tools/dependencies.

Invalid configuration must fail clearly and safely.

Changing material policy/configuration while work is pending should invalidate or re-evaluate decisions affected by that change.

Do not permit front-end defaults to silently become governance policy.

---

# 67. Protect Benchmark and Acceptance-Test Integrity

A candidate must not define a self-serving benchmark that guarantees its own success.

For claimed improvements:

- establish the baseline before applying the patch,
- preserve the test/benchmark definition independently of the candidate where practical,
- use representative inputs,
- record seeds/configuration for deterministic simulations,
- compare before/after using the same protocol,
- reject unverifiable percentage claims,
- prevent implementation code from modifying the acceptance test merely to pass it unless the test change is independently justified.

If the candidate changes both implementation and acceptance criteria, that change requires explicit scrutiny.

---

# 68. Add Post-Assimilation Validation and Benefit Realization

Passing immediate tests does not prove that an implementation is useful over time.

For material changes, retain the expected benefit and, where measurable, compare it with observed behavior after assimilation.

Possible outcomes:

```text
verified and beneficial
verified but neutral
regressive
superseded
```

A repeatedly neutral or regressive Harvest source/type should reduce future implementation priority or trigger policy adjustment.

Post-assimilation evidence should feed back into mining/evaluation quality without becoming an authority shortcut.

---

# 69. Make Deletion and Consolidation First-Class Improvement Actions

Assimilation should not mean "add code."

A valid improvement may be:

- deleting redundant code,
- replacing a weak mechanism,
- consolidating duplicate implementations,
- removing obsolete adapters,
- simplifying control flow,
- eliminating dead configuration,
- strengthening tests without adding runtime code.

The planner should explicitly consider whether the best implementation is a smaller repository.

Track net repository quality, not raw additions.

---

# 70. Prevent Self-Modification of Governance and Mutation Guards Through Normal Harvest

The components that decide whether repository mutation is allowed are higher-trust than ordinary harvested capabilities.

Normal Harvest candidates must not autonomously weaken, disable, replace, or route around:

- Gate B mutation guards,
- governance enforcement,
- authorization validators,
- audit integrity,
- rollback guarantees,
- secret/tool permission boundaries.

Changes to these trust-boundary components require a stricter policy and explicit human review, even if Gate B otherwise sees potential value.

A harvested candidate must never be able to improve its own chance of acceptance by modifying the evaluator/guard that judges it in the same transaction.

---

# 71. Define Trust-Boundary Tests Against Self-Approval

Add adversarial tests proving that candidate-generated changes cannot:

- modify Gate B and then use the modified Gate B to approve themselves,
- remove a mutation guard in the same patch that depends on that guard,
- rewrite audit history to hide failed decisions,
- alter policy/configuration to lower their own threshold,
- change acceptance tests solely to manufacture success,
- convert review-required work into normal-risk work from inside the candidate patch.

Trust-boundary changes must be evaluated under the pre-change authority rules and isolated from ordinary autonomous assimilation.

---

# 72. Define an Explicit Candidate Lifecycle State Machine

Do not allow arbitrary status strings or ad-hoc transitions.

Define a durable state machine with legal transitions, for example:

```text
INGESTED
   ↓
NORMALIZED
   ↓
AGGREGATED / DEDUPLICATED
   ↓
GATE_A_PASSED
   ↓
REPOSITORY_ANALYZED
   ↓
SUBSTANCE_PASSED
   ↓
GATE_B_AUTHORIZED
   ↓
REVIEW_PENDING     (only when required)
   ↓
IMPLEMENTING
   ↓
VERIFYING
   ↓
IMPLEMENTED
```

Terminal/non-implementation outcomes may include:

```text
KNOWLEDGE_RETAINED
REJECTED
DUPLICATE
SUPERSEDED
FAILED
QUARANTINED
```

The exact names may differ, but transitions must be explicit and validated.

Examples of illegal transitions that must be rejected:

```text
INGESTED → IMPLEMENTING
KNOWLEDGE_RETAINED → IMPLEMENTING without fresh evaluation
REJECTED → IMPLEMENTED
GATE_B_DENIED → IMPLEMENTING
VERIFYING → IMPLEMENTED after failed verification
```

Workflow state must remain separate from classification and authority.

---

# 73. Preserve User and External Repository Work

Autonomous assimilation must never overwrite or silently absorb unrelated human/agent work.

Before preparing or applying a change, inspect repository/worktree state and identify:

- uncommitted changes,
- untracked files,
- active merge/rebase/cherry-pick state,
- externally modified files,
- branch/head changes since analysis,
- protected/generated files according to project policy.

Normal autonomous implementation should occur in an isolated worktree/branch/transactional workspace derived from a known revision.

When accepting a verified patch into the target repository, re-check the target revision and conflicts.

If unrelated user changes overlap the intended mutation, do not overwrite them. Rebase/re-plan safely or defer/review according to policy.

Agent_X must preserve work it did not create.

---

# 74. Detect and Resolve Overlapping Autonomous Changes

Two individually valid candidates may conflict even when they are not semantic duplicates.

Before concurrent implementation, compute overlap/conflict risk from:

- affected files/modules,
- public interfaces,
- shared data schemas,
- dependencies,
- configuration,
- tests,
- architecture components.

Non-overlapping work may proceed concurrently within policy.

Overlapping mutations must be serialized, combined, or re-evaluated against the newer repository revision.

After one overlapping candidate is accepted, the second candidate's Gate B decision and plan must be considered stale unless explicitly proven otherwise.

Do not resolve semantic conflicts merely by allowing the version-control system to auto-merge text.

---

# 75. Establish a Pre-Change Verification Baseline

Before attributing test failures or improvements to a candidate, establish the relevant baseline on the pre-change repository revision.

Record, where applicable:

- existing failing tests,
- existing warnings,
- benchmark results,
- known flaky tests,
- current performance/resource measurements.

Then compare the candidate against the same baseline protocol.

This prevents Agent_X from:

- rejecting a good patch because the repository already had unrelated failures,
- accepting a bad patch because tests were already broken,
- claiming an improvement without a measured starting point.

A pre-existing failure must not automatically excuse a new regression in the same area.

---

# 76. Handle Flaky and Nondeterministic Verification Explicitly

Verification must distinguish deterministic failure from flaky infrastructure/tests.

For nondeterministic tests or simulations:

- use bounded reruns,
- record seeds where possible,
- compare with baseline flake behavior,
- do not rerun indefinitely until a desired result appears,
- quarantine persistently ambiguous verification rather than declaring success.

A candidate must never become `Implemented` merely because one attempt eventually passed after repeated failures.

Verification policy should define how much evidence is required for stable acceptance.

---

# 77. Make Persistent Data and Schema Migrations Safe

Candidates that alter databases, serialized records, caches, indexes, queues, or configuration schemas require migration-aware handling.

The plan must address, as applicable:

- forward migration,
- backward compatibility,
- restart during migration,
- partial migration recovery,
- rollback feasibility,
- old/new worker compatibility during transition,
- data validation after migration,
- migration idempotency.

Do not treat a code rollback as sufficient if the patch has already irreversibly transformed persistent data.

Irreversible or high-blast-radius migrations require stricter review.

---

# 78. Define Retained, Rejected, and Deferred Knowledge Lifecycles

`Knowledge Retained` must not become a permanent dump bucket that is rediscovered and reprocessed every loop.

For non-implemented material, record:

- disposition reason,
- evidence/source fingerprint,
- relevant capability mapping,
- repository revision/context,
- re-evaluation triggers where appropriate.

Possible triggers include:

```text
new repository capability gap appears
new evidence arrives
policy changes
architecture changes
related capability is modified
explicit user request
```

Rejected or duplicate material should remain suppressed unless a meaningful trigger changes the basis of the earlier decision.

Deferred/uncertain material should use bounded re-evaluation rather than constant polling.

---

# 79. Define Rollback-Failure and Integrity-Emergency Behavior

Rollback itself can fail.

If Agent_X cannot prove that the repository/persistent state is consistent after a failed mutation, it must enter a fail-safe blocked state for further repository mutation.

It may continue read-only analysis if safe, but must not keep applying patches to an uncertain base.

The system should preserve:

- transaction identifiers,
- before/after revisions,
- affected paths/data,
- rollback attempt results,
- recovery instructions/diagnostics.

The main UI should surface a concise integrity-blocked condition because this genuinely requires attention.

Never hide a rollback failure as an ordinary retryable error.

---

# 80. Protect Critical Paths and Ownership Boundaries

Define policy for critical/protected repository areas such as:

- governance,
- authorization/mutation guards,
- credential handling,
- persistence/migration code,
- release/deployment configuration,
- security-sensitive interfaces,
- generated or externally managed files.

Protected paths may require stricter Gate B criteria, mandatory human review, narrower tool permissions, or complete exclusion from normal autonomous modification.

A candidate must not evade protection by moving equivalent logic to an unprotected file.

Protection should be based on capability/authority impact as well as path names.

---

# 81. Bind Mining and Assimilation to Explicit Project Scope

Automation must not mean unconstrained repository self-modification.

The user/project should define durable high-level scope such as:

- project mission,
- allowed repositories/worktrees,
- permitted capability domains,
- excluded/protected areas,
- acceptable risk classes,
- strategic priorities.

Mining may explore broadly inside that scope, but a candidate must show relevance to the current project objectives before Gate B.

A harvested source cannot broaden the allowed scope by claiming that a new domain is important.

Scope changes are governance/user decisions, not normal Harvest outputs.

---

# 82. Require a Pre-Implementation Behavioral Delta Contract

Before coding, define what observable behavior is missing or inadequate in the current repository and what must become different after the patch.

Where practical, express this as a failing/unsatisfied acceptance condition against the pre-change revision.

Examples:

```text
BEFORE: fixed threshold does not adapt across generation statistics
AFTER: threshold deterministically adapts according to specified mechanism
```

or:

```text
BEFORE: scheduler processes FIFO despite differing computed worth/value
AFTER: scheduler ordering demonstrably follows the approved priority algorithm
```

For a new capability, prove that the runtime behavior did not already exist.

For an upgrade, prove both:

```text
old behavior / baseline
vs.
new behavior / expected improvement
```

A candidate should not be coded if the system cannot state what observable behavior should change.

---

# 83. Require Runtime Reachability and Wiring Proof

Generated code is not an assimilated capability merely because it exists and passes isolated unit tests.

The implementation must prove that the new mechanism is reachable from the real Agent_X runtime path that needs it.

Where applicable verify:

- actual entrypoint reaches the implementation,
- registry/plugin/tool registration is correct,
- dependency injection/wiring selects the new mechanism,
- configuration enables the intended production path,
- call sites use the new behavior,
- state/data flows into and out of it correctly,
- old bypass paths do not silently remain authoritative,
- integration tests exercise the production path rather than importing the module directly only for the test.

Conceptually:

```text
actual Agent_X entrypoint
        ↓
real orchestrator/runtime path
        ↓
new/updated mechanism
        ↓
observable behavior
```

If the only proof is:

```python
from new_module import new_function
assert new_function(...) == ...
```

while Agent_X never calls it, assimilation is incomplete.

---

# 84. Reject Name-Only and Proxy Implementations

The implementation must match the semantics of the approved capability.

Examples of invalid substitutions include:

```text
"adaptive scheduler"
→ merely store an `adaptive=True` flag

"priority scheduler"
→ rename a FIFO queue to PriorityQueue without priority behavior

"learning mechanism"
→ persist a score without any learning/update rule

"semantic ranking"
→ sort by a placeholder constant or path-derived value

"mutation gate"
→ add a handler/bucket that never changes mutation acceptance behavior
```

Code symbols, comments, filenames, metadata, and terminology are not evidence of implementation.

Gate B planning and verification must compare the claimed mechanism with actual control/data-flow behavior.

---

# 85. Do Not Count Dormant or Disabled Code as Assimilated

A new capability that is permanently unreachable, disabled by default without an intentional rollout plan, hidden behind an unused feature flag, or registered nowhere must not be reported as implemented.

If staged rollout is intentional, distinguish states such as:

```text
IMPLEMENTED_NOT_ACTIVE
ROLLOUT_PENDING
ACTIVE_VERIFIED
```

and do not present `IMPLEMENTED_NOT_ACTIVE` to the user as if Agent_X is already benefiting from the capability.

The final success state should correspond to the intended operational behavior being active or to an explicitly approved staged-rollout state.

---

# 86. Enforce Canonical Runtime Paths After Replacement

When an improvement replaces an existing mechanism, ensure the old mechanism does not remain as an accidental competing path.

The implementation plan must identify whether old code should be:

- removed,
- migrated,
- retained only as deliberate fallback,
- kept temporarily behind a controlled rollout boundary.

There must not be two contradictory sources of truth simply because deleting or rewiring the old path was more difficult.

Tests should verify which runtime path is authoritative.

---

# 87. Add Maintainability and Complexity Acceptance Checks

A patch can be behaviorally correct and still make Agent_X worse through needless complexity.

Before acceptance, evaluate as applicable:

- unnecessary new abstractions,
- duplicate logic,
- dead/unreachable code,
- excessive file/module proliferation,
- unclear ownership boundaries,
- avoidable configuration knobs,
- hidden global state,
- unbounded data structures,
- unnecessary dependencies,
- cyclomatic/structural complexity growth,
- test maintainability.

Prefer the smallest coherent change that implements the required behavior.

A candidate should not receive extra credit for producing more code.

---

# 88. Verify the Accepted Repository State, Not Only the Isolated Patch

Verification in an isolated worktree is necessary but not always sufficient.

After the verified change is accepted into the target repository state, run an appropriate final smoke/integration verification against the resulting revision.

This catches:

- merge/rebase interactions,
- target-branch differences,
- configuration differences,
- registration/wiring omissions,
- interactions with other recently accepted changes.

Only then should the final durable disposition become `IMPLEMENTED` / `ACTIVE_VERIFIED` as appropriate.

---

# 89. Define User-Facing Metrics Semantically

Simple UI counters must have stable meanings so they do not become misleading.

For example, define whether:

```text
Useful discoveries
Implementation candidates
Implemented
Needs Review
```

count:

- raw sources,
- normalized ideas,
- aggregated candidates,
- unique capabilities,
- accepted transactions.

Recommended semantics:

```text
Useful discoveries        = unique normalized/aggregated findings worth retaining or evaluating
Implementation candidates = unique candidates that reached implementation-worthiness analysis
Implemented               = accepted, verified capability changes (not files/functions generated)
Needs Review              = currently unresolved exceptional decisions
```

Do not let `Implemented` increase once per generated file or per retry.

---

# 90. Make Gate B Authorization Non-Forgeable by Downstream Workers

A typed record is not sufficient if any worker can construct its own record containing:

```python
authorized = True
```

The repository mutation guard must verify authorization provenance from the canonical Gate B authority.

Use an architecture such as:

```text
Canonical Gate B evaluator
        ↓
persist authoritative decision
        ↓
issue decision ID / capability token
        ↓
implementation worker receives reference
        ↓
mutation guard resolves/verifies reference
        ↓
checks candidate + repo revision + policy context
        ↓
mutation allowed
```

The exact mechanism may be a protected decision store, signed token, opaque capability, or equivalent design.

The critical property is:

> A caller cannot obtain repository-mutation authority merely by constructing data that looks like an approved decision.

Never trust caller-supplied `authorized=True` as proof of authorization.

---

# 91. Separate Proposal, Authorization, Implementation, and Verification Roles

Do not allow one stage to silently collapse the entire pipeline into self-certification.

Conceptually separate:

```text
Producer / Interpreter
        ↓ proposes candidate
Evaluator
        ↓ produces evidence/plan
Gate B Authority
        ↓ authorizes or denies
Implementer
        ↓ creates patch
Verifier
        ↓ tests claimed behavior
Mutation Finalizer
        ↓ accepts verified result
```

These roles may run in the same process or even use the same underlying model/provider, but their authority boundaries and durable artifacts must remain separate.

In particular:

- implementers cannot mint Gate B authority,
- candidate producers cannot mark themselves implemented,
- verifiers cannot silently rewrite the approved plan,
- finalizers cannot convert failed verification into success,
- generated patch content cannot edit its own durable decision record.

For high-risk/trust-boundary changes, use stronger independence between implementation and verification according to policy.

---

# 92. Protect Decision and Audit Records from Mutation by Candidate Code

Decision provenance loses value if the code being evaluated can rewrite its own history.

Gate A/B decisions, review records, mutation authorization, verification results, and final disposition should live behind a storage/permission boundary that normal candidate code cannot modify directly.

Updates should occur through controlled orchestrator APIs with validated state transitions.

Where practical, retain append-only/tamper-evident history for authority-critical transitions.

A candidate must not be able to:

- turn a deny into allow,
- delete a failed verification,
- change the repository revision attached to an approval,
- rewrite who/what authorized the change,
- erase rollback evidence.

---

# 93. Finalize Mutation, Verification, and Disposition Coherently

Avoid states where the repository changed successfully but durable workflow state says it did not, or vice versa.

The finalization protocol should correlate:

```text
transaction ID
candidate ID
Gate B authorization ID
accepted repository revision
verification result ID
final disposition
```

If the process crashes between repository acceptance and state-record update, restart recovery must reconcile the actual repository revision with the transaction record rather than applying the change again.

`IMPLEMENTED` should be emitted only after this reconciliation/finalization boundary is satisfied.

---

# 94. Isolate Verification from Production Side Effects

Generated code and tests must not prove themselves by mutating real production/external state.

Verification should use an isolated/sandboxed environment appropriate to the capability and explicitly control:

- network access,
- external APIs,
- production databases,
- credentials,
- filesystem scope,
- subprocesses,
- message queues,
- email/notification sends,
- cloud resources,
- destructive commands.

Use fixtures, fakes, test services, temporary directories, disposable worktrees, or equivalent mechanisms where appropriate.

If a capability genuinely requires a live integration test, that test must use explicitly authorized non-destructive resources and policy-defined safeguards.

`Stop Mining`, retries, or test reruns must never duplicate external side effects.

---

# 95. Verify Runtime and Compatibility Requirements

Assimilation must preserve the project's supported runtime contract unless a deliberate migration is approved.

Verification should account for applicable:

- supported Python/runtime versions,
- operating systems/environments,
- public APIs,
- serialized formats,
- configuration contracts,
- plugin/tool interfaces,
- database compatibility,
- dependency constraints,
- startup/import behavior.

A locally passing patch is not acceptable if it silently breaks a supported execution environment or compatibility contract.

Breaking changes require explicit identification, migration planning, and appropriate review.

---

# 96. Include Security and Supply-Chain Acceptance Checks

Before accepting generated code, run security checks appropriate to the change class.

Examples include:

- unsafe command construction,
- path traversal,
- arbitrary code execution surfaces,
- insecure deserialization,
- secret exposure,
- permission escalation,
- unsafe temporary-file handling,
- network trust assumptions,
- newly introduced dependency risk,
- dependency source/version integrity.

New dependencies should be pinned/constrained according to project policy and must not be fetched/executed merely because harvested material suggests them.

Security findings that affect trust boundaries must fail closed or trigger required review.

---

# 97. Keep Code, Contracts, Tests, and Documentation Synchronized

When an accepted change alters a public or durable contract, update all required representations in the same coherent change.

This may include:

- type/schema definitions,
- API/tool contracts,
- configuration schema/defaults,
- migrations,
- tests,
- developer/operator documentation,
- capability ledger entries,
- deprecation/removal notes.

Do not accept a runtime change that leaves authoritative schemas/tests/docs describing contradictory behavior.

Documentation alone never proves capability, but stale contracts are still a correctness defect.

---

# 98. Require Repository-First Implementation Instead of Parallel Reimplementation

This specification must be applied to the existing Agent_X architecture, not implemented as a second competing Harvest/Assimilation stack.

Before coding, trace the current repository end to end and identify the actual production paths for:

- UI start/stop actions,
- mining orchestration,
- frontier discovery,
- gap filling,
- balancing,
- Harvest ingestion,
- inventory persistence,
- candidate evaluation,
- Gate A,
- Gate B,
- assimilation dispatch,
- code/repository mutation,
- verification,
- status/history reporting.

Then map every requirement in this document onto the existing authoritative modules and call paths.

The implementation must prefer:

```text
repair existing canonical path
→ remove bypasses
→ consolidate duplicates
→ migrate state
→ delete obsolete machinery
```

rather than:

```text
leave old behavior intact
+
add a new "v2" path beside it
```

unless a deliberate staged migration requires temporary coexistence.

During staged migration, define exactly:

- which path is authoritative,
- how traffic/work is routed,
- how state is migrated,
- when the old path is removed,
- tests proving there is no silent fallback to the obsolete authority model.

A coding LLM must not assume filenames or invent architecture from this document. It must inspect the repository, identify the real implementation points, and change the underlying behavior.

The completion review should include a search for obsolete/bypass code so that the repository does not retain two contradictory implementations after the redesign.

---

# 99. Core Design Rules

The implementation must enforce all of the following:

1. The user controls goals, start/stop, and exceptional decisions.
2. Agent_X controls routine mining, evaluation, routing, assimilation, verification, and repetition.
3. The normal UI exposes outcomes, not internal machinery.
4. `agentx_status` is descriptive metadata only.
5. No metadata, score, classification, queue state, UI state, or recommendation may independently authorize repository mutation.
6. Gate B is the single canonical implementation-authority boundary.
7. Gate B authorization is a typed, mechanically validated contract, not a free-form LLM boolean.
8. Every repository-mutation path must consume and validate the canonical Gate B decision.
9. Gate B fails closed.
10. Gate A never authorizes coding.
11. Classification, workflow state, human review, and authority remain separate concepts.
12. Gate B decisions are bound to repository, policy, evaluator, and relevant configuration context and may become stale.
13. Human approval cannot revive a stale or invalid Gate B decision.
14. Harvested material is untrusted evidence, not executable instruction.
15. Harvested material is not assumed to be ready-made code.
16. External code/research provenance and reuse/licensing boundaries are retained.
17. Source ingestion is bounded and resilient to malformed/adversarial input.
18. Secret/tool/network/filesystem access follows explicit least-privilege policy.
19. Every coding candidate must describe a real mechanism or substantive integration.
20. Placeholder/bucket/handler-only output is rejected unless architecturally justified.
21. Related findings should be aggregated before coding where appropriate.
22. Existing architecture should be extended, simplified, deleted, or consolidated before creating new modules unnecessarily.
23. The capability ledger assists comparison but never overrides repository truth.
24. Evidence conflicts and uncertainty must remain explicit.
25. Continuous processing must be idempotent and duplicate-safe.
26. Concurrent equivalent candidates must not produce duplicate repository effects.
27. Repository mutations must have exactly-once observable effects.
28. Mining queues, concurrency, source ingestion, retries, tests, and resource consumption must be bounded.
29. Backpressure and circuit breakers must prevent runaway work.
30. No-novelty conditions must back off rather than busy-loop.
31. `Stop Mining` must preserve repository and durable-state consistency.
32. Crash/restart recovery must be supported.
33. Repository mutation must be transactional or rollback-capable.
34. Failed verification must never become `Implemented`.
35. Acceptance tests and benchmarks must not be self-serving or silently rewritten to manufacture success.
36. Material accepted changes should retain expected-benefit evidence for later evaluation where measurable.
37. Human review is an additional requirement when policy demands it, never a Gate B bypass.
38. Pending review should not block unrelated safe work.
39. Review should be exceptional and minimal.
40. UI state must not be backend authority.
41. The backend/orchestrator owns durable workflow state.
42. Low-level errors should be retried quietly and boundedly.
43. Full decision provenance and auditability must remain available.
44. Raw history/storage must be bounded by retention and compaction policy.
45. Obsolete/superseded generated code should be consolidatable or removable.
46. Deletion and simplification are first-class assimilation outcomes.
47. Normal Harvest cannot autonomously weaken its own governance, Gate B, mutation guards, audit integrity, or permission boundaries.
48. Trust-boundary changes are evaluated using pre-change authority and stricter review.
49. The system optimizes for repository capability, correctness, maintainability, and measurable benefit—not code volume.
50. End-to-end invariant and adversarial tests must prove the authority, automation, recovery, and trust-boundary model.
51. Existing legacy records must not retain status-based implementation authority.
52. Candidate lifecycle transitions must be explicit and validated.
53. Autonomous changes must preserve unrelated user/external work and use isolated repository state.
54. Overlapping autonomous changes must be serialized, combined, or re-evaluated rather than text-merged blindly.
55. Verification must compare against a pre-change baseline and account for pre-existing failures.
56. Flaky/nondeterministic verification must use bounded evidence rules and may not pass by repeated luck.
57. Persistent-data/schema changes require migration, rollback, compatibility, and recovery plans.
58. Retained/rejected/deferred knowledge must have suppression and meaningful re-evaluation semantics.
59. Rollback failure or uncertain repository integrity must block further mutation.
60. Critical capability/authority boundaries may require stricter protection regardless of file path.
61. Mining and assimilation remain inside explicit project scope; harvested content cannot broaden that scope.
62. Every implementation has a pre-defined observable behavioral delta.
63. Assimilated capability must be wired into and reachable from the real runtime path.
64. Names, flags, handlers, buckets, and comments are not substitutes for the claimed mechanism.
65. Dormant/disabled/unregistered code is not counted as active assimilation.
66. Replaced mechanisms must have one deliberate canonical runtime path.
67. Maintainability and complexity are acceptance criteria, not optional cleanup.
68. Final verification runs against the accepted target repository state as appropriate.
69. User-facing metrics count meaningful unique outcomes rather than generated artifacts.
70. Downstream workers cannot forge Gate B authorization by constructing approval-shaped data.
71. Proposal, authorization, implementation, verification, and finalization remain distinct authority roles.
72. Authority-critical decision/audit records are protected from direct mutation by candidate code.
73. Repository acceptance, verification, and final disposition have a crash-recoverable coherent finalization protocol.
74. Verification is isolated from unauthorized production/external side effects.
75. Accepted changes preserve supported runtime/compatibility contracts unless an explicit migration is approved.
76. Security and dependency/supply-chain checks are part of acceptance according to change risk.
77. Code, schemas, tests, configuration contracts, and required documentation remain synchronized.
78. Implementation begins by tracing and repairing existing canonical repository paths rather than creating a parallel replacement stack.
79. Temporary staged coexistence must name one authority path and include removal criteria for obsolete machinery.
80. Completion includes a repository-wide search for surviving bypass/obsolete paths.
81. Maximum internal sophistication should produce minimum external complexity.

---

# 100. Definition of Done

This redesign is complete only when all of the following are true.

## Operator experience

- the user can start the complete mining system with one primary action,
- the user can stop it with one primary action,
- the normal UI does not require manual operation of pipeline stages,
- the normal UI does not expose raw Gate A/Gate B controls,
- the normal UI does not expose `agentx_status` as an action or authority selector,
- the normal UI primarily shows state, outcomes, meaningful activity, and exceptional review,
- detailed metadata remains available through History / Details / Advanced,
- `Needs Review` is uncommon and restricted to genuine exceptional decisions,
- pending review does not unnecessarily block unrelated autonomous work,
- front-end reload/disconnect does not alter backend truth,
- user-facing counters have explicit stable semantics and do not count generated files/retries as implementations.

## Automation

- frontier discovery, gap filling, balancing, Harvest, normalization, aggregation, deduplication, evaluation, gating, assimilation, verification, recording, and repetition are automatically orchestrated,
- mining continues until stopped or blocked by a genuine unrecoverable condition,
- no-novelty/exhausted-frontier conditions back off instead of busy-looping,
- queues and concurrency are bounded,
- retry behavior is bounded,
- backpressure prevents runaway accumulation,
- resource budgets and circuit breakers are enforced,
- stop behavior is safe and deterministic,
- crash/restart recovery is durable,
- abandoned worker claims recover safely,
- legal candidate-state transitions are enforced and illegal transition shortcuts fail closed,
- retained/rejected items are not continuously reprocessed without meaningful triggers.

## Authority

- `agentx_status` cannot cause Gate B to pass,
- no replacement metadata/status/score/classification field can cause Gate B to pass,
- there is one canonical Gate B authority,
- Gate B emits a typed, mechanically validated authorization contract,
- every repository-mutation path checks that canonical authorization,
- malformed/incomplete authorization fails closed,
- Gate B authorization is bound to relevant repository, policy, evaluator, schema, and configuration context,
- stale authorizations are re-evaluated,
- UI approval cannot bypass Gate B,
- old human approvals are revalidated before mutation,
- batch/replay/API/worker paths cannot bypass Gate B,
- normal Harvest cannot weaken Gate B/governance/mutation guards to approve itself,
- downstream workers cannot fabricate approval-shaped Gate B records,
- mutation guards resolve/verify authority from the canonical protected authority source.

## Substance and evidence

- harvested concepts are treated as evidence,
- external harvested content is treated as untrusted data,
- external instructions cannot bypass governance or trigger direct execution,
- evidence quality/conflicts/uncertainty remain explicit,
- related findings may be aggregated into one coherent candidate,
- every implementation candidate identifies a concrete capability gap,
- every implementation candidate describes a substantive mechanism,
- placeholder/bucket/dispatch-only implementations fail unless genuinely necessary,
- creating a new file/module requires architectural justification,
- existing code is extended/consolidated/deleted where appropriate,
- duplicate and superseded candidates do not create duplicate code,
- the capability ledger is repository-derived and invalidated/refreshed when stale,
- source provenance is retained,
- third-party code/dependency reuse obeys licensing/provenance policy,
- every implementation has an explicit before/after behavioral delta,
- runtime reachability/wiring is proven through the real Agent_X path,
- name-only/proxy implementations are rejected,
- dormant/disabled code is not misreported as active capability.

## Repository and execution integrity

- source ingestion is bounded against malformed/adversarial inputs,
- tool/network/shell/filesystem/dependency access follows explicit policy,
- secrets are not exposed through Harvest, logs, model calls, or generated patches beyond authorized handling,
- autonomous normal-risk changes stay inside policy-defined blast-radius limits,
- unexpected implementation scope expansion forces re-evaluation,
- implementation occurs inside a transaction/isolation boundary or has reliable rollback,
- duplicate retries cannot apply the same repository effect twice,
- failed implementation is rolled back or isolated,
- failed verification is never reported as assimilated,
- accepted code passes required syntax, test, integration, regression, governance, security, and acceptance checks,
- claimed quantitative improvements require reproducible baseline-vs-after measurement,
- implementation code cannot silently alter acceptance criteria merely to pass,
- obsolete generated code can be superseded, consolidated, or removed,
- unrelated uncommitted/user work is preserved,
- autonomous changes use isolated known repository state,
- overlapping autonomous changes are serialized/combined/re-evaluated,
- pre-existing failures are baselined before candidate attribution,
- flaky verification cannot pass through unbounded reruns,
- persistent-data migrations have explicit compatibility/recovery/rollback handling,
- uncertain state after rollback failure blocks further mutation,
- replaced capabilities have one deliberate canonical runtime path,
- maintainability/complexity checks prevent needless architecture growth,
- the accepted target repository revision receives final smoke/integration verification,
- verification is sandboxed/isolated from unauthorized production side effects,
- supported runtime/platform/interface compatibility is verified,
- security and dependency/supply-chain checks run according to policy,
- changed public/durable contracts have synchronized schemas/tests/configuration/documentation,
- implementation maps requirements onto existing production modules/call paths rather than inventing a parallel stack,
- obsolete/bypass Harvest/Gate/Assimilation paths are removed or explicitly bounded by a staged migration.

## State, provenance, and operations

- backend durable state, not UI state, is authoritative,
- every major stage uses validated structured records,
- every candidate has durable lifecycle state,
- every important decision has provenance,
- authority-critical decision/audit history cannot be directly rewritten by candidate code,
- proposal/authorization/implementation/verification/finalization roles remain authority-separated,
- model/evaluator/prompt/schema/policy/configuration versions are recorded where material,
- every implementation records changed files and verification results,
- restart can safely resume or re-evaluate unfinished work,
- repeat ingestion is idempotent,
- equivalent concurrent candidates cannot both implement,
- atomic claims/leases prevent concurrent duplicate mutation,
- raw/log/history data is bounded by retention/compaction policy without losing required audit evidence,
- backend liveness/health is observable independently of browser state,
- configuration is explicit, versioned, validated, and cannot silently change decision semantics,
- protected/critical capabilities cannot be modified through a path-name workaround.

## Quality feedback

- repository-clutter metrics exist in diagnostics,
- implementation value is measured where practical,
- repeated neutral/regressive sources or candidate classes can reduce future priority,
- deletion/consolidation counts as successful improvement where appropriate,
- success is evaluated by capability/correctness/maintainability/benefit rather than number of generated files or lines,
- `Implemented` counts verified capability changes rather than artifacts produced.

## Regression and adversarial protection

Tests prove at minimum that:

```text
agentx_status=upgrade + GateB=false → no repository mutation
agentx_status=update + GateB=false → no repository mutation
high score + GateB=false → no repository mutation
queued=true + GateB=false → no repository mutation
UI approval + GateB=false → no repository mutation
malformed GateB authorization → no repository mutation
stale GateB authorization → no repository mutation
candidate modifies GateB to self-approve → rejected/isolated
candidate lowers policy threshold to self-approve → rejected/isolated
candidate rewrites its acceptance test to manufacture success → rejected/re-reviewed
```

Tests also prove:

- `Start Mining` advances the full automated pipeline without manual stage clicks,
- `Stop Mining` leaves durable state and repository consistent,
- crash/restart recovery works,
- duplicate/replayed candidates do not create duplicate repository effects,
- crash between repository acceptance and workflow finalization is reconciled rather than re-applied,
- concurrent equivalent candidates cannot both mutate the repository,
- placeholder-only candidates do not generate meaningless code,
- failed verification cannot produce an `Implemented` outcome,
- no-novelty operation backs off rather than spins,
- queue/resource limits and circuit breakers work,
- pending human review does not block unrelated safe candidates,
- trust-boundary changes cannot use their own modified rules for authorization,
- autonomous patches cannot overwrite unrelated uncommitted changes,
- overlapping patches are revalidated after earlier overlapping changes land,
- baseline failures and candidate-introduced regressions are distinguished,
- flaky tests cannot be rerun until a lucky pass is obtained,
- rollback failure produces an integrity-blocked state,
- illegal lifecycle transitions are rejected,
- an isolated unit test cannot prove assimilation when the real runtime never reaches the code,
- disabled/unregistered implementations cannot be reported as active,
- forged caller-supplied `authorized=True` records cannot pass the mutation guard,
- candidate code cannot rewrite its Gate B/audit record,
- verification retries cannot duplicate production/external side effects,
- unsupported breaking runtime/API/schema changes cannot silently pass,
- a repository-wide bypass search confirms old authority paths cannot still mutate the repository,
- replacement tests prove the intended canonical runtime path is actually selected.

Only when these conditions are satisfied should the Harvest / Assimilation redesign be considered complete.
