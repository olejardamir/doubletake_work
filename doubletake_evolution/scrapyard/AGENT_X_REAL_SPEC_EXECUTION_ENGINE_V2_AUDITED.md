# Agent_X — Real Spec Execution Engine: Bounded Slices, Persistent Loop, No Silent Truncation

Current audited `main` at prompt creation:

`b8221098156f0145f2319f38b2db82b63dd934d7`

Re-check actual current `main` and local working tree before editing.

This prompt replaces the current one-shot implementation model for commands such as:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

Do not reopen already-fixed semantic-provider/bootstrap/write-authority work unless a regression proves it is broken.

---

# Exact production symptom

The user runs a large specification-driven command.

Agent_X may now:

- materialize the specification;
- extract many requirements;
- detect that the task is incomplete;
- create a semantic target;
- create a runtime implementation packet;
- send the runtime packet to OpenCode/Codex/LLM7;
- reject zero-effects when mandatory requirements remain.

Yet the task still performs no meaningful implementation.

The reason is architectural:

```text
large multi-component specification
→ treated as one semantic transaction
→ all remaining requirements forcibly attached to one/few target components
→ all remaining requirements declared actionable
→ one bounded write set
→ one coding-runtime turn
```

That execution model is invalid for a large project-wide specification.

---

# Proven defects on current main

## 1. Requirement extraction silently truncates the specification

Current:

```python
MAX_SPEC_REQUIREMENTS = 128
```

and multiple paths do:

```python
requirements[:MAX_SPEC_REQUIREMENTS]
```

including deterministic extraction, provider extraction, merged extraction and assessment parsing.

A long specification can contain more than 128 mandatory obligations.

Silently discarding the remainder means Agent_X does not know whether it has captured the full specification.

This is incompatible with:

```text
complete everything according to <spec>
```

No completion claim is valid when the requirement manifest may have been truncated.

## 2. Every remaining requirement is forcibly assigned to an accepted component

Current pipeline behavior fills missing `requirement_ids` by assigning each remaining requirement to:

- an explicit matching component if one exists;
- otherwise a semantic-target matching component;
- otherwise the first affected component.

This destroys the distinction between:

```text
requirements selected for THIS semantic transaction
```

and:

```text
requirements still remaining in the WHOLE specification
```

The fallback must not exist.

Unselected requirements are deferred, not silently attached to the first component.

## 3. Runtime packet makes the same mistake again

Current `build_runtime_implementation_packet()` loads every mandatory requirement whose status is not satisfied/not-applicable.

It then forcibly maps any unmapped requirement to:

```text
first_component
```

and creates a `RuntimeRequirement` for every one of them.

Each requirement receives:

```python
authorized_paths = write_set
```

where `write_set` is the transaction-global sealed write set.

Therefore a transaction that authorizes only a few files can tell the coding runtime:

```text
all 123 remaining requirements are actionable
```

while forbidding writes to the files required for most of them.

That contract is impossible.

## 4. There is still no real "complete everything" execution loop

The current system performs one semantic target + one coding turn.

A large specification requires:

```text
full manifest
→ select coherent slice
→ semantic target
→ exact write scope
→ implement
→ verify
→ reconcile
→ reassess full manifest
→ select next slice
→ repeat
```

until:

```text
remaining mandatory requirements == 0
```

or a genuine blocker occurs.

This loop must be a first-class Agent_X execution mode.

It must not depend on the coding model voluntarily deciding to continue.

---

# Core architecture

Introduce a canonical:

```text
SpecExecutionPlan
```

and a persistent:

```text
SpecExecutionTask
```

The top-level user task survives across multiple semantic transactions and multiple coding-runtime turns.

Hierarchy:

```text
SpecExecutionTask
  ├── immutable source manifest
  ├── requirement assessments
  ├── completed requirements
  ├── remaining requirements
  ├── blocked requirements
  ├── current slice
  ├── prior slices
  └── completion evidence
```

Each slice owns exactly one normal semantic-first mutation transaction.

Do not weaken semantic-first.

---

# 1. Replace the global 128-requirement cap

Do not keep:

```python
MAX_SPEC_REQUIREMENTS = 128
```

as a silent global manifest cap.

You may retain bounded per-chunk limits for LLM calls.

For example:

```text
MAX_REQUIREMENTS_PER_EXTRACTION_CHUNK = 64
MAX_SPEC_CHUNKS = bounded safety limit
MAX_TOTAL_REQUIREMENTS = large hard fail-closed safety ceiling
```

A hard total ceiling is acceptable only if exceeding it produces:

```text
SPEC_REQUIREMENT_MANIFEST_TOO_LARGE
```

and completion is forbidden.

Never silently truncate.

---

# 2. Build the requirement manifest section-by-section

Parse the materialized specification into stable chunks using document structure where possible:

- Markdown headings;
- numbered sections;
- task headings;
- acceptance-criteria sections;
- fenced contracts where semantically relevant.

For each chunk:

1. compute chunk digest;
2. deterministic extraction;
3. governed semantic extraction;
4. merge/deduplicate;
5. persist extraction status;
6. record source line/range;
7. mark chunk COMPLETE only after extraction succeeds.

Aggregate all chunks into the full manifest.

---

# 3. Manifest completeness is an explicit invariant

Add:

```python
RequirementManifest(
    source_digest=...,
    chunks=(...),
    requirements=(...),
    extraction_complete=True/False,
    manifest_digest=...,
)
```

No spec completion/no-op may occur unless:

```text
extraction_complete == True
```

If any source region was skipped, truncated, failed or not parsed:

```text
manifest_complete = false
```

and task completion is forbidden.

---

# 4. Detect extraction coverage

Track exact source coverage.

For every materialized source record:

```text
source byte/line range
→ extraction chunk
→ extraction result
```

At the end prove:

```text
all semantically relevant source ranges examined
```

Do not require every blank/comment line to generate a requirement.

But every section must have an extraction disposition.

Examples:

```text
requirements_found
informational_only
examples_only
definitions_only
optional_guidance
```

No silent gaps.

---

# 5. Stable requirement identity independent of execution slice

Requirement ID derives from:

```text
source digest
+
source location / section identity
+
normalized semantic obligation
```

Do not derive IDs from slice number.

The same specification must produce stable IDs across retries/restarts.

---

# 6. Keep the full manifest separate from the current slice

These are different objects:

```text
full_manifest_requirements
current_slice_requirement_ids
```

Do not put all remaining IDs into every semantic target.

A target transaction only owns:

```text
current_slice_requirement_ids
```

All other unsatisfied requirements remain:

```text
DEFERRED
```

for future slices.

---

# 7. Remove forced requirement-to-first-component fallback

Delete behavior equivalent to:

```python
explicit = candidates[0] if candidates else affected_components[0]
```

when assigning specification requirements to target components.

Rules:

- explicitly selected requirement → bind to selected target component;
- deterministically exact mapping → may bind;
- ambiguous/unselected requirement → remains deferred;
- no target component → do not invent one just to avoid orphaning.

A requirement that is not part of the current slice must not appear in the transaction.

---

# 8. Introduce requirement execution states

Per mandatory requirement:

```text
DISCOVERED
ASSESSED
SATISFIED
UNSATISFIED
PARTIAL
UNKNOWN
READY
IN_SLICE
IMPLEMENTED_PENDING_VERIFICATION
VERIFIED
BLOCKED
NOT_APPLICABLE
```

State transition authority must be explicit.

Example:

```text
UNSATISFIED
→ READY
→ IN_SLICE
→ IMPLEMENTED_PENDING_VERIFICATION
→ VERIFIED
```

A provider cannot directly mint `VERIFIED`.

---

# 9. Build coherent slices

Create a deterministic + governed slice selector.

Inputs:

- unsatisfied/partial/unknown requirements;
- canonical semantic owners;
- implementation bindings;
- dependency graph;
- shared files;
- authority type;
- prerequisite relationships;
- risk;
- write-scope size.

Output:

```python
SpecExecutionSlice(
    slice_id=...,
    requirement_ids=(...),
    semantic_owners=(...),
    candidate_implementation_targets=(...),
    rationale=...,
)
```

---

# 10. Slice coherence rules

Prefer requirements in the same slice when they:

- modify the same module;
- modify the same capability;
- share the same authority boundary;
- form one replacement operation;
- require the same UI/API wiring;
- share a prerequisite.

Keep separate when they:

- touch unrelated subsystems;
- require conflicting authority types;
- require different migrations;
- are too broad for one verification transaction;
- exceed write-set or context limits.

---

# 11. Slice size must be bounded by implementation complexity, not arbitrary count alone

Use bounded dimensions such as:

```text
max target components
max write paths
max source files
max requirement text tokens
max estimated implementation complexity
```

Do not simply take:

```python
remaining[:20]
```

without architecture grouping.

---

# 12. Current Harvest regression: first slice must be concrete

For the current bad Harvest code, acceptable early slices include coherent groups such as:

### Gate-B authority slice

Requirements covering:

- Gate B is candidate admission/disposition authority only;
- semantic-first is sole project mutation authority;
- remove Gate-B "only implementation authorization mint" behavior/text;
- `agentx_status` cannot decide disposition.

Likely implementation target:

```text
tools/agentx_evolve/collective_core/harvest_gate_b.py
```

### UI implementation-gate slice

Requirements covering:

- `can_implement()` cannot be disposition-only;
- `EXPERIMENT_ONLY` cannot production-enable;
- governed prerequisites determine production eligibility.

Likely implementation targets:

```text
harvest_ui.py
plus exact existing server/API owner if required
```

### Wiring completion slice

Requirement:

```text
remove `(self.ui_api_wired or True)`
```

plus proper applicability semantics.

Likely target:

```text
harvest_wiring.py
```

These should not all be hidden inside one generic 123-requirement transaction.

---

# 13. Slice selection must produce exact current target IDs

Before semantic target design, map the slice to canonical model entities.

If a requirement explicitly identifies:

```text
harvest_gate_b.py
```

and current semantic model contains:

```text
harvest_gate_b_coordination
```

use that evidence.

Do not ask the LLM to rediscover obvious file ownership from scratch.

LLM judgment still decides architecture, replacement and authority where needed.

---

# 14. Semantic target only receives the slice

For each slice:

```text
interpretation context:
    full task summary
    full manifest summary
    current slice requirements
    already-verified requirements
    deferred remaining count

target design:
    ONLY current slice may become mutation intent
```

Do not dump all unsatisfied requirements into `affected_components`.

---

# 15. Preserve full-task context without making it actionable

Runtime/semantic prompts may state:

```text
Full task remaining: 117 requirements.
Current transaction owns: 4 requirements.
```

Deferred requirements are context only.

They cannot become mutation authority in this transaction.

---

# 16. Fix RuntimeImplementationPacket

Replace:

```text
remaining_requirements
```

as the main actionable collection with two explicit collections:

```python
actionable_requirements
deferred_requirement_ids
```

`actionable_requirements` must equal exactly the requirement IDs owned by the accepted target slice.

Do not copy the full remaining manifest into the actionable packet.

---

# 17. Never fallback an unmapped requirement to first_component

Delete runtime-handoff behavior equivalent to:

```python
component = ... first_component
```

for a requirement not selected by the slice.

If an actionable slice requirement cannot map to an accepted target component:

```text
RUNTIME_REQUIREMENT_TARGET_UNRESOLVED
```

Fail before coding runtime.

Deferred requirements do not need transaction target mappings yet.

---

# 18. Requirement authorized paths must be per target

Current:

```python
authorized_paths = write_set
```

for every requirement is too broad.

Derive:

```text
requirement
→ target component
→ implementation targets
→ resolved path subset
```

Each runtime requirement gets only its relevant authorized paths.

The packet also carries the full transaction write set for deterministic enforcement.

---

# 19. Preserve implementation action/targets in SemanticTargetState

Current `AffectedComponent` / serialization must retain:

```text
implementation_action
implementation_targets
proposed_new_paths
requirement_ids
```

Do not discard them after write-scope resolution.

Runtime packet and verification need the exact accepted target design.

Add these fields to:

- dataclass;
- digest;
- `to_dict`;
- persistence/reload paths;
- tests.

---

# 20. Do not substitute global write set for component target design

Runtime handoff must not reconstruct target ownership by saying:

```text
every component → full write_set
```

Preserve exact component-to-path provenance created by write-scope resolution.

---

# 21. Build a top-level SpecExecutionTask

Persist under run/task state, not ephemeral provider memory.

Conceptually:

```python
SpecExecutionTask(
    task_id,
    source_digest,
    manifest_digest,
    original_request,
    requirement_states,
    completed_slice_ids,
    current_slice_id,
    remaining_requirement_ids,
    blocked_requirement_ids,
    status,
)
```

Statuses:

```text
PLANNING
RUNNING
PARTIAL
BLOCKED
COMPLETE
FAILED
```

---

# 22. Task persists across multiple semantic run IDs

Each slice gets a fresh normal semantic-first run:

```text
task_id = stable top-level spec task
slice 1 → run A / change A
slice 2 → run B / change B
slice 3 → run C / change C
```

Do not reuse mutation authority across slices.

---

# 23. Implement the execution loop

Canonical loop:

```text
materialize source
↓
load/build full manifest
↓
assess current implementation
↓
while mandatory requirements remain:
    select coherent ready slice
    ↓
    create fresh semantic transaction
    ↓
    design target for slice
    ↓
    resolve exact write scope
    ↓
    create runtime packet for slice only
    ↓
    run coding runtime
    ↓
    verify actual effects
    ↓
    reassess affected + dependent requirements
    ↓
    reconcile semantic model
    ↓
    persist slice result
    ↓
    continue
↓
full final verification
↓
task COMPLETE
```

---

# 24. The loop must not depend on OpenCode deciding to continue

The orchestrator owns continuation.

After provider turn ends:

- inspect finalization result;
- inspect task remaining set;
- if valid progress and requirements remain:
  - select next slice;
  - start next semantic transaction.

Do not require user to submit the same prompt again for every slice.

---

# 25. Bounded anti-infinite-loop policy

Do not create an uncontrolled infinite loop.

Maintain:

```text
max consecutive no-progress attempts per slice
max retries for provider/transient failure
same-requirement failure counter
same-write-set failure counter
```

If no progress after bounded retries:

```text
BLOCKED
```

with concrete reason/evidence.

The overall number of slices is driven by remaining requirements, not an arbitrary tiny loop count.

---

# 26. Progress definition

A slice makes progress only when one or more of these occurs:

- previously unsatisfied requirement becomes satisfied;
- partial requirement gains verified acceptance condition;
- obsolete code is removed as required;
- explicit blocker is resolved;
- target is legitimately reclassified NOT_APPLICABLE with evidence.

Provider prose is not progress.

Creating evidence files alone is not implementation progress.

---

# 27. Zero-effects handling inside the loop

If a slice has actionable unsatisfied requirements and coding runtime changes nothing:

1. fresh compliance check;
2. if slice requirements are now satisfied due external/preexisting truth:
   - accept no-op with positive evidence;
3. otherwise:
   - no-progress attempt++;
   - provide exact discrepancy back to runtime for one bounded retry;
4. if still no progress:
   - mark slice BLOCKED;
   - task BLOCKED;
   - do not say task complete.

---

# 28. Runtime retry prompt must be discrepancy-based

Example:

```text
Previous implementation attempt made no verified progress.

Still unsatisfied:
- req-X: Gate B must not mint project mutation authorization.
Evidence:
- harvest_gate_b.py still contains "ONLY mint of implementation authorization".

Authorized paths:
- tools/agentx_evolve/collective_core/harvest_gate_b.py

Modify the implementation now.
```

This is much more useful than resending all 123 requirements.

---

# 29. Post-slice compliance re-evaluation

Reassess at least:

- slice requirement IDs;
- requirements sharing changed files;
- requirements depending on changed semantic owner;
- previously satisfied requirements at risk of regression.

Then update global manifest state.

---

# 30. Previously satisfied requirements may not regress

If a slice breaks a previously verified requirement:

```text
REGRESSION
```

The slice fails reconciliation.

Rollback/recovery follows existing semantic-first rules.

---

# 31. Full task completion requires manifest completeness

Final completion requires all:

```text
manifest.extraction_complete == true
all mandatory requirements ∈ {VERIFIED, NOT_APPLICABLE}
no blocked requirements
no unknown requirements
no partial requirements
no extraction gaps
canonical semantic reconciliation complete
SYNCED
```

---

# 32. Remove silent manifest truncation everywhere

Audit and eliminate silent `[:MAX_SPEC_REQUIREMENTS]` truncation from:

- deterministic extraction;
- LLM extraction parsing;
- merged manifest;
- assessment parsing;
- persistence/reload;
- completion summary.

Per-call/page limits may remain, but aggregation must preserve the complete manifest.

If safety ceiling reached:

```text
fail closed
```

instead of truncating.

---

# 33. Chunked governed extraction

For large documents, do not send the entire document to one requirement-extraction LLM call.

Use chunk-level calls with:

```text
source digest
section identity
line range
chunk text
```

Then merge deterministically.

Each chunk's provider response is independently schema-validated/repaired.

---

# 34. Requirement deduplication

Deduplicate only when semantic equivalence is well supported.

Do not merge distinct acceptance conditions simply because wording overlaps.

Preserve provenance from all source locations when merging genuine duplicates.

---

# 35. Requirement manifest diagnostics

Persist:

```text
total sections
sections processed
sections with requirements
requirements total
mandatory total
optional total
extraction failures
truncation = false
manifest_complete = true/false
```

---

# 36. Runtime packet size must remain bounded

Because each packet now carries only the current slice, it stays small.

Do not send all 100+ requirements to the runtime.

Target a coherent packet size suitable for coding:

```text
few requirements
few target components
bounded write paths
```

---

# 37. Current Harvest task must demonstrate real progress

Mandatory end-to-end test against current bad Harvest code:

Initial known defects include at least:

- Gate B claims project mutation authorization;
- `agentx_status` drives disposition;
- `can_implement()` is disposition-only;
- `EXPERIMENT_ONLY` production eligibility defect;
- `(ui_api_wired or True)` completion bypass.

After starting the Harvest spec task:

Expected first slices produce actual changes to Harvest files.

It is unacceptable if the system only changes:

```text
semantic_project/*
semantic_first/*
evidence/*
```

while leaving the Harvest defects untouched.

---

# 38. Add "implementation progress must touch target domain" check

For a slice targeting Harvest implementation:

At least one actual changed path must match the accepted slice write scope and semantic target.

Evidence-only/canonical baseline changes are not enough to count as implementation progress.

Example:

```text
slice target = harvest_gate_b.py
```

Progress requires actual target behavior change or positive proof it was already satisfied.

---

# 39. Separate infrastructure self-repair from requested-domain implementation

Once the spec executor itself is healthy:

```text
Harvest spec task
```

must target Harvest.

If semantic infrastructure breaks during the task:

- mark task BLOCKED;
- run a separate bootstrap maintenance repair;
- resume Harvest task afterward.

Do not silently substitute infrastructure repair for requested implementation work.

---

# 40. Exact Harvest first-slice regression

With current bad code, select a Gate-B slice.

Expected sealed mutation scope contains:

```text
tools/agentx_evolve/collective_core/harvest_gate_b.py
```

and any exact required tests.

Runtime packet actionable requirements must contain only the Gate-B-related requirement IDs.

Deferred count remains visible but not actionable.

OpenCode must receive this exact contract.

---

# 41. Exact wiring slice regression

For requirement:

```text
UI/API wiring must not be bypassed by `(ui_api_wired or True)`
```

Expected slice targets:

```text
harvest_wiring.py
```

After runtime:

```text
the literal bypass is absent
new applicability semantics tested
requirement becomes VERIFIED
```

Then loop continues to next slice.

---

# 42. Exact UI gate slice regression

For production eligibility:

Expected slice targets:

```text
harvest_ui.py
+
exact server/API eligibility owner if required
```

Verify:

- `EXPERIMENT_ONLY` not production eligible;
- disposition alone insufficient;
- governed prerequisite state required.

Then requirement(s) VERIFIED.

---

# 43. Completion must not be based on provider final answer

Even if runtime says:

```text
Done.
```

the orchestrator immediately:

- verifies changes;
- reassesses slice;
- updates task state;
- continues if requirements remain.

Provider final text is informational only.

---

# 44. UI task status

Expose the top-level spec task status distinctly from the current slice/run.

Useful fields:

```text
task_id
task_status
manifest_total
mandatory_total
verified_count
remaining_count
current_slice
current_run_id
blocked_reason
```

---

# 45. User-facing behavior

When the user submits:

```text
complete everything according to: <spec>
```

the UI should show something like:

```text
Specification task running
124 mandatory requirements
4 in current slice
120 deferred
```

After slice:

```text
4 verified
120 remaining
continuing...
```

Only at zero remaining:

```text
Task complete
```

---

# 46. Restart recovery

On backend restart:

1. reload `SpecExecutionTask`;
2. verify source digest;
3. verify manifest digest;
4. verify last slice terminal state;
5. recompute current implementation compliance;
6. resume from remaining requirements.

Do not restart from requirement extraction unless source changed or manifest invalid.

---

# 47. Source changes during long task

If the specification file changes while task is running:

```text
SOURCE_DIGEST_CHANGED
```

Pause old task.

Rebuild/reconcile manifest against new source.

Do not continue under stale obligations.

---

# 48. Current code changes outside task

If implementation changes externally between slices:

Use normal semantic synchronization/conflict logic.

Reassess affected requirements before selecting next slice.

Do not blindly continue based on stale compliance.

---

# 49. Requirement dependency support

Allow requirement relationships:

```text
requires
blocks
supersedes
same_owner
same_slice_preferred
```

Do not overengineer with a graph DB.

A small persisted adjacency representation is sufficient.

---

# 50. Selection order

Prefer slices in this order:

1. authority/security/governance blockers;
2. foundational data contracts;
3. core runtime behavior;
4. integration/wiring;
5. UI;
6. verification/cleanup.

Actual dependency evidence overrides this heuristic.

---

# 51. Do not make `agentx_status` or Harvest status authority in this executor

Spec execution selection is based on:

- requirement status;
- semantic ownership;
- dependencies;
- accepted target architecture.

Do not reintroduce Harvest's bad authority rules into the spec executor.

---

# 52. Final reconciliation

After every successful slice:

- normal semantic verification;
- normal semantic reconciliation;
- update canonical truth only after verification.

After full task completion:

- full manifest compliance verification;
- fresh target/verification evidence;
- accepted baseline update;
- independent `SYNCED`;
- immediate second no-change `SYNCED`.

---

# 53. Required tests — manifest completeness

### More than 128 requirements

Fixture specification contains 220 mandatory requirements.

Expected:

```text
manifest total = 220
manifest_complete = true
```

not 128.

If configured total hard ceiling is lower than 220:

Expected:

```text
SPEC_REQUIREMENT_MANIFEST_TOO_LARGE
```

Never silent 128.

---

# 54. Required tests — chunk extraction failure

One section extraction fails after bounded provider retries.

Expected:

```text
manifest_complete = false
task cannot complete
```

---

# 55. Required tests — slice isolation

Manifest has 20 remaining requirements across 4 modules.

Slice selects 4 requirements for one module.

Expected:

```text
actionable_requirements = 4
deferred_requirements = 16
write_set = only selected module/test paths
```

Runtime packet must not contain the other 16 as actionable.

---

# 56. Required tests — no first-component fallback

Requirement has no target mapping and is not selected for current slice.

Expected:

```text
deferred
```

not attached to first component.

If it is selected but cannot map:

```text
RUNTIME_REQUIREMENT_TARGET_UNRESOLVED
```

---

# 57. Required tests — per-requirement paths

Two requirements in same transaction map to different target files.

Expected each runtime requirement contains its own authorized path subset.

Neither gets the entire write set unless both genuinely need it.

---

# 58. Required tests — real loop

Fixture has 3 slices.

Expected:

```text
slice A verified
→ fresh transaction B
→ slice B verified
→ fresh transaction C
→ slice C verified
→ manifest remaining = 0
→ task complete
```

User submits prompt once.

---

# 59. Required tests — no progress

Slice runtime returns "done" and changes nothing.

Requirement remains unsatisfied.

Expected:

```text
bounded discrepancy retry
```

If second attempt also no progress:

```text
task BLOCKED
```

not complete.

---

# 60. Required tests — partial progress

Slice has 4 requirements.

Runtime satisfies 2.

Expected:

- 2 VERIFIED;
- 2 remain READY/PARTIAL;
- next slice/retry handles remaining;
- task not complete.

---

# 61. Required tests — Harvest integration

Against current bad Harvest fixture/main snapshot:

Initial task cannot complete.

At minimum:

```text
Gate-B slice
UI eligibility slice
wiring completion slice
```

must generate real target-domain implementation work.

After those fixes, compliance statuses must change based on current source evidence.

---

# 62. Required real-world acceptance test

Restart Agent_X.

Submit once:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

Expected:

1. full requirement manifest produced with no silent truncation;
2. task state created;
3. current requirements assessed;
4. coherent first slice selected;
5. first slice targets actual Harvest files;
6. coding runtime edits actual Harvest implementation;
7. slice verification runs;
8. requirement ledger updates;
9. next slice starts automatically;
10. process continues;
11. task never says complete while mandatory requirements remain.

The user should not have to rerun the same prompt after every slice.

---

# 63. Negative acceptance test

This is a failure:

```text
spec has 123 remaining
→ runtime packet contains all 123
→ write set contains 1-3 files
→ provider says done
→ task ends
```

This entire behavior must be impossible.

---

# Completion criteria

Do not stop until ALL are true:

1. global silent 128 requirement truncation is gone.
2. manifest completeness is explicit.
3. all document sections receive extraction disposition.
4. chunked extraction is supported.
5. full manifest and current slice are separate.
6. requirement IDs are stable.
7. per-requirement execution states exist.
8. unselected requirements remain deferred.
9. no forced first-component mapping exists.
10. current target owns only current-slice requirements.
11. RuntimeImplementationPacket has actionable vs deferred requirements.
12. packet actionable requirements equal current slice exactly.
13. runtime packet does not expose whole remaining manifest as actionable.
14. requirement→component mapping is exact.
15. requirement→authorized-path mapping is per target.
16. SemanticTargetState preserves implementation actions/targets.
17. spec task persists across slice runs.
18. every slice gets a fresh semantic transaction.
19. orchestrator automatically selects next slice after verified progress.
20. provider cannot decide whether the whole task is complete.
21. zero progress triggers discrepancy retry then BLOCKED.
22. partial progress persists and continues.
23. restart resumes the same task safely.
24. source digest changes invalidate/rescope task.
25. external implementation drift invokes synchronization logic.
26. full completion requires manifest completeness and zero mandatory remaining.
27. current Harvest task changes actual Harvest files.
28. semantic infrastructure/evidence-only changes do not count as Harvest progress.
29. Gate-B defect is actually repaired by the Harvest task.
30. `agentx_status` authority defect is actually repaired.
31. `can_implement()` production eligibility defect is actually repaired.
32. `EXPERIMENT_ONLY` production eligibility defect is actually repaired.
33. `(ui_api_wired or True)` is actually removed/replaced properly.
34. remaining Harvest requirements continue through subsequent slices.
35. final full compliance verification passes.
36. canonical reconciliation succeeds.
37. independent final assessment is `SYNCED`.
38. immediate second no-change assessment is `SYNCED`.

---

# Stop condition

Stop only when Agent_X has become a real specification executor:

```text
one user command
↓
complete full manifest
↓
select bounded coherent requirement slice
↓
fresh semantic target
↓
exact write scope
↓
runtime implements slice
↓
verify
↓
reassess
↓
next slice automatically
↓
repeat until zero mandatory requirements
↓
full verification
↓
SYNCED
↓
Task complete
```

Do not stop because:

- a runtime packet exists;
- a model received a large list of requirements;
- one semantic transaction finished;
- a provider said "done";
- evidence files were written;
- semantic-first infrastructure changed;
- the same Harvest implementation defects remain untouched.

The decisive proof is actual incremental modification and verification of the target Harvest implementation until the full materialized specification has no mandatory requirements remaining.


---

# AUDIT PASS 2 — MANDATORY ADDITIONAL CORRECTIONS

The following defects were found by a second direct audit of current `main`
`b8221098156f0145f2319f38b2db82b63dd934d7`.

These are not optional refinements. Several make the current system incapable
of reliably completing a large specification even if the slice engine above
is added.

Implement these requirements as part of the same repair.

---

# A. The current compliance engine is falsely generic

## A1. Remove Harvest-specific logic from the generic compliance core

Current `spec_compliance.py` hard-codes Harvest concepts directly into generic
specification infrastructure, including known targets such as:

```text
Gate B
agentx_status
semantic-first
EXPERIMENT_ONLY
can_implement
ui_api_wired
completion_ready
R0–R6
```

It also has Harvest-specific deterministic requirement rules and
Harvest-specific assessment branches.

This is unacceptable for a generic command:

```text
complete everything according to: <arbitrary spec>
```

Refactor:

```text
generic specification engine
    ↓
generic requirement extraction
generic evidence lookup
generic requirement verification
```

Domain-specific deterministic verifiers may exist, but only as registered
verification adapters/plugins.

Example:

```python
RequirementVerifierRegistry
    .register("harvest", HarvestRequirementVerifier)
```

The generic execution engine must not contain Harvest names.

---

# A2. Remove `_harvest_files()` as the generic evidence universe

Current governed assessment refinement supplies only a tiny hard-coded source
set:

```text
harvest_gate_b.py
harvest_ui.py
harvest_wiring.py
semantic_first/interceptor.py
semantic_first/pipeline.py
```

A 2,000+ line Harvest specification covers many more production files.

Evidence discovery must instead be driven by:

```text
requirement semantic targets
→ canonical semantic owners
→ implementation bindings
→ exact read scope
```

Only then provide relevant bounded source excerpts to governed assessment.

Do not scan an arbitrary first N modules.

---

# A3. Remove the generic `candidate_paths[:64]` evidence shortcut

Current fallback examines only the first 64 project modules.

This can omit the actual owner entirely.

Never use repository ordering as architecture.

Use semantic target/binding resolution to obtain candidate evidence paths.

If ownership cannot be resolved:

```text
UNKNOWN / BLOCKED
```

not "search first 64 files."

---

# B. Requirement extraction is currently unsound

## B1. Do not parse ordinary fenced code blocks as natural-language requirements

Current deterministic extraction is line-based and only skips the fence marker
line itself.

Therefore text inside:

````
```python
...
```
````

may be interpreted as specification obligations.

Build a Markdown-aware/source-structure-aware extractor.

Track whether a line belongs to:

```text
prose
heading
list item
table
blockquote
ordinary code example
explicit contract block
acceptance-test block
```

Ordinary examples are evidence/context, not requirements.

Only contract/test code explicitly identified by the specification structure may
generate obligations.

---

# B2. Do not infer obligation solely from words such as `only`

Current deterministic extraction treats any line containing terms such as:

```text
must
shall
required
forbidden
cannot
never
only
```

as a normative obligation.

This can reverse the intended meaning of descriptive text.

Example current-state description:

```text
Gate B is currently the only record that authorizes code changes.
```

must NOT become a target requirement saying Gate B should remain the only
authority.

Requirement extraction must distinguish:

```text
current-state description
problem statement
forbidden current behavior
target requirement
acceptance criterion
example
rationale
```

Use document structure + governed semantic classification.

---

# B3. Mandatory/optional status must be clause-aware

Current logic can mark a whole line optional merely because it contains:

```text
may
might
could
optional
should
```

even when the same line also contains a mandatory `must`.

Do not classify modality from a bag of keywords.

Extract individual obligations/clauses and classify each obligation separately.

---

# B4. Requirement IDs must include source identity/location

Current requirement IDs are derived mainly from:

```text
source digest
category
normalized statement
```

Two identical sentences in different sections can collapse into one ID even
when they carry different scope or acceptance conditions.

Requirement identity must include stable source provenance such as:

```text
source digest
section identity
source line/range
normalized obligation
```

Genuine semantic duplicate merging happens after extraction and preserves all
source locations.

---

# B5. Provider-extracted requirements must be source-grounded

Current provider extraction accepts a requirement when `source_location`
looks syntactically like:

```text
source-id:line N
```

It does not prove the cited source actually contains/supports the obligation.

Require:

```text
source_id
line_start
line_end
source_excerpt_hash
requirement statement
```

Deterministically validate:

- source exists in the materialized manifest;
- line range exists;
- excerpt hash matches;
- cited excerpt contains/supports the extracted obligation sufficiently for
  governed validation.

A provider may not invent requirements with a fabricated line number.

---

# B6. Invalid provider extraction must not silently become an empty success

Current extraction parser can return:

```python
[]
```

for malformed/invalid provider output.

If the semantic provider wrapper sees an empty list as a successful validator
result, repair/failover is bypassed.

For a stage where governed extraction is required:

```text
malformed output
missing requirements field
invalid source provenance
contract mismatch
```

must raise the typed semantic contract failure and receive the normal bounded
repair/failover policy.

Do the same for governed requirement-assessment output.

---

# C. Source coverage has additional silent truncation

## C1. Eliminate silent source-content truncation

Current paths include truncations such as:

```text
materialized compliance reader → first ~1.5M chars
provider extraction → first 120,000 chars/source
combined provider context → first 400,000 chars
```

Materialization itself also has a 1 MiB source limit.

A bound is legitimate.

Silent loss is not.

Any bound must produce explicit manifest coverage state.

For oversized specifications:

- chunk the source;
- process all chunks; or
- fail closed with a clear size/coverage error.

Never interpret:

```text
first portion processed
```

as:

```text
specification completely extracted.
```

---

# C2. Do not feed the entire raw specification into normal interpretation

Current `run_semantic_first()` uses:

```python
effective_request = materialized_request.augmented_text
```

so the ordinary architectural interpretation stage receives the entire
materialized document.

For large specs this is noisy, expensive and can exceed real model context.

For `SPEC_COMPLIANCE`:

```text
materialize full source
→ build complete requirement manifest
→ create bounded task summary/current slice
→ interpretation sees bounded task/slice context
```

Do not append the whole 2,000+ line document to every interpretation call.

---

# C3. Target design must not receive the entire remaining manifest

Current target-design prompt can include all remaining mandatory requirements.

With 100+ requirements this creates another giant one-shot prompt before the
runtime packet is even built.

The slice selector must run first.

Target design receives:

```text
current slice
+
small global task summary
+
deferred count
+
relevant accepted state
```

not all remaining requirement prose.

---

# C4. Semantic model selection must account for actual prompt size

Current semantic candidate context sufficiency uses a fixed approximate minimum
rather than the actual current prompt size.

For chunk/slice semantic calls:

- estimate actual input token budget conservatively;
- require candidate context >= input + output + safety margin;
- do not choose a model whose advertised context is insufficient.

---

# D. Compliance persistence is not a real cross-run task state

## D1. Run-local compliance storage cannot implement "continue"

UI semantic state is isolated under a fresh:

```text
<runs>/<run_id>/
```

for each request.

Current compliance persistence/load operates under that run-local state root.

Therefore a new run cannot reliably discover the prior run's compliance ledger.

The top-level `SpecExecutionTask` must live in a persistent workspace-scoped
task store, for example:

```text
semantic_project/spec_tasks/<task_id>/
```

or another canonical non-run-local task root.

Per-run transactions remain isolated.

---

# D2. Bind task identity independently from run identity

Use stable task identity from at least:

```text
repository identity
workspace identity
spec source digest
normalized user task intent
```

Each slice/run references the task ID.

Never use the run ID as the only task identity.

---

# D3. Version the manifest/extractor contract

A future improved extractor must not silently reuse an old truncated or
semantically weaker manifest solely because the source digest is unchanged.

Persist:

```text
manifest_schema_version
extractor_version
assessment_version
semantic_contract_version
```

On incompatible version change:

```text
rebuild manifest
reassess
```

Do not carry old completion forward automatically.

---

# D4. Validate the compliance digest when loading

Current `SpecComplianceResult.from_dict()` verifies the requirement-set digest
but does not provide equivalent full validation of the persisted assessment /
compliance digest before use.

Recompute and validate:

```text
requirement_set_digest
compliance_digest
source_digest
manifest_digest
```

before accepting persisted task state.

Tampered/stale assessment state must fail closed.

---

# D5. Corrupt newest task state must not silently fall back to an older success

When loading persistent task state:

- maintain an append-only/journaled task state or atomic current pointer;
- detect corrupt newest state;
- recover from a provably valid prior state only with explicit recovery status;
- never silently select an older "complete" ledger because the newest file
  failed parsing.

---

# E. Semantic target data currently loses critical implementation intent

## E1. Preserve implementation fields in `AffectedComponent`

Current LLM design contains:

```text
implementation_action
implementation_targets
proposed_new_paths
```

but `AffectedComponent` does not preserve these fields.

They are therefore lost from the semantic target object and later runtime
handoff must guess/reconstruct ownership.

Add canonical fields:

```python
implementation_action
implementation_targets
proposed_new_paths
requirement_ids
verification_requirements
```

to the persisted target component contract.

Include them in:

- digest;
- `to_dict`;
- overlay target document;
- verification reload;
- runtime packet;
- evidence.

---

# E2. Do not rebuild runtime target ownership from the global write set

The runtime packet currently projects components with:

```text
authorized_paths = full transaction write_set
```

This destroys exact component ownership.

Preserve the resolver's exact provenance:

```text
component
→ implementation target
→ exact resolved paths
```

Runtime requirement authorized paths derive from that relation.

---

# E3. Scope-resolution repair currently ignores returned binding IDs

Current `_scope_resolution_repair_pass()` asks the model for:

```json
{
  "resolved_bindings": [...],
  "resolved_modules": [...],
  "resolved_capabilities": [...]
}
```

It collects `resolved_bindings` but does not actually use those bindings when
rerunning resolution.

Fix this directly.

Every returned canonical binding ID must be validated and incorporated into the
target/scope resolution contract.

---

# E4. Do not truncate scope-repair candidates to the first 30 entries

Current repair context includes only roughly the first 30 known bindings and
capabilities.

That can omit the real target.

Retrieve candidate bindings based on:

```text
unresolved entity
semantic similarity/relevance
current slice requirement targets
current semantic owners
```

Use bounded relevant retrieval, not first-N ordering.

---

# E5. Strictly validate scope-repair output

Require a schema.

Reject:

- unknown binding IDs;
- wrong types;
- arbitrary paths;
- ambiguous IDs;
- redesign attempts.

The repair stage identifies canonical targets only.

---

# E6. Mutation intent cannot be derived only from affected capabilities/modules

Current scope-repair trigger uses a `has_affected` concept primarily based on
affected capabilities/modules.

A valid target can involve:

- invariant;
- interface;
- responsibility;
- semantic identity;
- explicit create/remove action;

without those two interpretation lists being populated.

Define:

```text
mutation_intended
```

from accepted target component actions.

Scope repair should operate from target mutation intent, not an incomplete
interpretation shortcut.

---

# F. Compliance verification currently cannot reliably converge

## F1. Post-execution compliance MUST use governed refinement

Current finalization re-runs compliance with:

```python
provider=None
```

This is fatal for generic requirements.

The generic deterministic fallback often yields only:

```text
PARTIAL
UNKNOWN
```

and cannot promote them to `SATISFIED`.

Post-slice verification must use the same governed compliance verifier contract,
with implementation evidence restricted to the relevant changed/read scope.

No self-certification.

---

# F2. Remove Harvest-hardcoded verification from generic completion authority

Harvest-specific deterministic checks may remain as a registered verifier for
Harvest.

But generic task completion must support arbitrary specification requirements.

Build:

```text
requirement
→ acceptance conditions
→ evidence plan
→ deterministic checks where possible
→ governed evidence interpretation where necessary
→ VERIFIED / not verified
```

---

# F3. A valid `path:line` citation alone is NOT proof

Current governed assessment refinement can accept a `SATISFIED` result when the
provider gives any valid repository `path:line N`.

The validator checks path existence and line range, but not whether the cited
content proves the requirement.

Require evidence records containing:

```text
path
line range
source hash
excerpt hash
verification method
```

Then validate the evidence relationship.

For high-authority requirements, use deterministic tests/invariants where
possible.

---

# F4. Generic vocabulary presence must never become completion evidence

Current fallback may find tokens in source and return `PARTIAL`.

That is acceptable for discovery only.

It must never, directly or indirectly, become verified completion.

---

# G. Changed-code verification is currently impossible by default

## G1. `verify_implementation()` requires a test runner

Current verification adds:

```text
MISSING_BEHAVIORAL_EVIDENCE
```

when `test_runner is None`.

This is blocking.

## G2. Normal UI finalization does not supply a test runner

Normal OpenCode/Codex/LLM7 chat finalization calls:

```python
finalize_ui_run(run_id, ...)
```

without a test runner.

Therefore a run that genuinely changes source may fail verification by design.

Fix this before relying on the spec loop.

---

# G3. Build a canonical per-slice VerificationPlan

For every accepted slice derive:

```python
VerificationPlan(
    requirement_ids,
    changed_target_paths,
    relevant_tests,
    deterministic_checks,
    canary_checks,
    acceptance_conditions,
)
```

The finalizer executes this plan automatically.

Do not require an external caller to inject a `test_runner`.

---

# G4. Verification scope must select real tests

Use:

- capability test bindings;
- semantic verification requirements;
- tests referencing changed symbols/modules;
- explicit tests named by the specification;
- focused test generation only when truly required and authorized.

Avoid running the entire suite unless necessary.

If no behavioral test exists, use explicit deterministic proof appropriate to
the requirement or mark verification insufficient.

---

# G5. Per-slice success requires slice-specific requirement advancement

Do not define progress as merely:

```text
some requirement anywhere became satisfied
```

Require advancement of at least one requirement owned by the current slice,
unless the slice is independently proven no-op/satisfied.

Unrelated requirement movement must not validate the slice.

---

# H. Frontend still allows provider prose to stop work

## H1. Remove `loopDeclaredDone(assistantText)` as completion authority

Current frontend logic explicitly does:

```text
if loopDeclaredDone(assistantText)
    stop loop
    "AI declared done"
```

This contradicts the entire semantic task model.

Provider text is advisory.

For specification execution, only backend task state may stop the task:

```text
task_status == COMPLETE
remaining_count == 0
manifest_complete == true
```

---

# H2. Do not squash/advance the task merely because AI prose says done

Current loop-done branch can trigger completion behavior and git squash after
the assistant declares done.

For spec tasks:

- ignore prose completion;
- wait for canonical task state;
- only squash/finalize after verified COMPLETE.

---

# H3. Distinguish `run completed` from `spec task complete` in frontend state

A slice run may legitimately be:

```text
run.status = completed
task.status = running/partial
```

The UI must continue the spec executor.

Do not reinterpret a terminal child run as terminal parent task.

---

# I. Existing tests currently assert the bug

## I1. Replace `test_runtime_packet_contains_all_remaining_requirements...`

Current test explicitly asserts:

```text
packet contains every remaining requirement
every requirement.authorized_paths == entire packet.write_set
first component gets both/all requirements
```

Those assertions encode the architecture that is breaking execution.

Delete/replace them.

Correct assertions:

```text
packet.actionable_requirements == current slice only
packet.deferred_requirement_ids == other remaining requirements
each actionable requirement receives only its component-resolved path subset
```

---

# I2. Replace the current "real Harvest packet" test

Current Harvest regression builds a synthetic accepted target whose write set is:

```text
tools/agentx_evolve/api/semantic_gate.py
```

while claiming to test Harvest requirements.

That test proves only that Harvest text can be stuffed into a packet.

It does NOT prove Harvest implementation executes.

Replace it with a test that selects a real Harvest slice and requires actual
target paths such as:

```text
collective_core/harvest_gate_b.py
collective_core/harvest_ui.py
collective_core/harvest_wiring.py
```

according to the slice.

---

# I3. Add a real target-domain progress assertion

A Harvest spec integration test fails if the only changed files are under:

```text
semantic_first/
semantic_project/
evidence/
tests of the executor itself
```

when the active slice targets Harvest.

At least one accepted target-domain implementation path must change, or the
requirement must be independently proven already satisfied.

---

# J. Materialization has additional correctness defects

## J1. Do not silently downgrade failed explicit spec materialization

If the user explicitly requests:

```text
complete everything according to: /path/spec.md
```

and that path:

- does not exist;
- exceeds materialization limits;
- cannot be decoded;
- fails read policy;

return a clear specification-source error.

Do not silently produce zero materialized files and downgrade the request to
`STANDARD`.

---

# J2. Fix source ID semantics

Current documentation says in-workspace files receive a `repo:` identity, but
the implementation currently computes the same `external-file:` style source ID
unconditionally.

Make source identity explicit:

```text
repo:<canonical-relative-path>:<digest-fragment>
external-file:<canonical-path-identity>:<digest-fragment>
```

The read/write authority still comes from `is_external` and policy, not the
string prefix alone.

---

# J3. Do not use raw augmented source content as the durable task prompt

Keep:

```text
original user request
source manifest/digest
full source stored/read-only
requirement manifest
current slice
```

separate.

Do not persist one giant augmented prompt as the primary task identity.

---

# K. Additional persistence and concurrency requirements

## K1. One active spec task per exact task identity

Prevent two concurrent executions of the same specification task from selecting
and implementing the same requirements simultaneously.

Use a task-level lease/lock.

Separate spec tasks may run concurrently only if normal semantic conflict logic
allows their slice write scopes.

---

# K2. Slice claims must be transactional

Transition:

```text
READY → IN_SLICE
```

atomically with the new slice/run identity.

If the process crashes:

- recover or release stale claim safely;
- never leave requirements permanently invisible.

---

# K3. Reassessment after external repository change

Between slices, compare accepted implementation revision.

If repository changed:

- normal synchronization/conflict assessment;
- reassess impacted requirements;
- invalidate stale READY slice if necessary.

---

# L. Additional end-to-end acceptance gates

Before declaring this repair complete, prove ALL of the following on current
Harvest:

1. The specification manifest is complete and not truncated.
2. Ordinary code examples/descriptions are not turned into false target requirements.
3. Requirement IDs preserve source provenance.
4. The task persists outside an individual run directory.
5. Restart resumes the same task.
6. The first actionable slice contains only a coherent subset.
7. The first Gate-B slice write set includes actual `harvest_gate_b.py`.
8. Scope repair can actually consume canonical binding IDs.
9. A changed slice automatically has a real verification plan/test runner.
10. Post-execution compliance can promote a generic requirement using governed,
    source-grounded evidence.
11. Arbitrary `path:line` is insufficient to prove satisfaction.
12. The frontend ignores "Done" prose while task remaining > 0.
13. Existing flawed runtime-packet tests have been replaced.
14. Actual Harvest source changes occur.
15. After each verified slice, the next slice starts automatically.
16. Zero progress triggers bounded discrepancy retry, then BLOCKED.
17. Full task completion requires zero mandatory remaining and complete manifest.
18. Final synchronization is `SYNCED`.
19. Immediate no-change synchronization is still `SYNCED`.

---

# M. PRIORITY ORDER — fix the blockers in this order

To avoid another long repair chain, implement in this sequence:

## Phase 1 — make execution possible

1. persistent top-level `SpecExecutionTask`;
2. full non-truncated manifest;
3. bounded current-slice selection;
4. preserve implementation action/targets;
5. slice-only runtime packet;
6. exact per-requirement authorized paths;
7. automatic next-slice orchestration.

## Phase 2 — make verification possible

8. canonical automatic `VerificationPlan`;
9. eliminate missing-test-runner deadlock;
10. governed post-execution compliance;
11. source-grounded evidence validation;
12. slice-specific progress verification.

## Phase 3 — remove false completion/stall paths

13. remove frontend AI-text completion authority;
14. separate run terminal status from task terminal status;
15. cross-run/restart recovery;
16. fail explicit source materialization loudly;
17. remove old tests that assert whole-manifest/one-write-set behavior.

## Phase 4 — prove Harvest actually works

18. Gate-B slice;
19. UI implementation eligibility slice;
20. wiring-completion slice;
21. continue remaining Harvest slices automatically;
22. full manifest verification;
23. canonical reconcile + double `SYNCED`.

---

# FINAL AUDITED STOP CONDITION

Do not declare this infrastructure fixed until the following real command is run
once:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

and the observed behavior is:

```text
full spec manifest built with proven coverage
↓
persistent task created
↓
small coherent Harvest slice selected
↓
actual Harvest write set sealed
↓
OpenCode/Codex receives ONLY that slice
↓
actual Harvest code changes
↓
automatic behavioral verification runs
↓
slice requirements become VERIFIED
↓
task remains RUNNING/PARTIAL
↓
next Harvest slice starts automatically
↓
...
↓
all mandatory requirements VERIFIED/NOT_APPLICABLE
↓
full final validation
↓
canonical reconciliation
↓
SYNCED
↓
second no-change SYNCED
↓
Task complete
```

Any of the following means the repair is NOT complete:

```text
provider says done but task still has requirements
one giant packet contains the whole spec
all requirements share one write set
only semantic infrastructure changes
missing test runner prevents verification
post-verification requirements remain permanently UNKNOWN because provider=None
frontend stops because assistant text says "done"
manifest is silently capped/truncated
new run forgets the prior task
current Harvest defects remain untouched
```
