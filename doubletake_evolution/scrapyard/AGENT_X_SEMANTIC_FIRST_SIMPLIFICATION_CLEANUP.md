# Agent_X — Semantic-First Simplification / Junk Removal

Current audited `main` when this cleanup prompt was written:

`b8221098156f0145f2319f38b2db82b63dd934d7`

Re-check the actual current `main` and working tree before editing.

This is a **deletion-first architectural simplification**, not another feature expansion.

The current semantic-first implementation has grown far beyond the original requirement. The goal is to remove the speculative specification-execution machinery, requirement ledgers, runtime packets, duplicate completion systems, and excessive synchronization bureaucracy while preserving the valuable semantic-first core.

Do not implement the previously proposed multi-transaction specification executor.

Do not add another framework to replace the framework being removed.

---

# 1. The original requirement

Agent_X semantic-first should do only this:

```text
USER REQUEST
    ↓
SEMANTIC PREFLIGHT
    - understand requested architectural change
    - inspect current semantic model
    - determine target semantic change
    - identify relevant existing implementation ownership
    ↓
CODING AGENT
    - reads the user's real request/specification
    - plans the work
    - edits code
    - owns task decomposition and iteration
    ↓
POST-CODE SEMANTIC RECONCILIATION
    - inspect actual changed code
    - regenerate affected current semantics from implementation
    - compare target semantics vs resulting semantics
    ↓
MATCH
    - update accepted semantic model from actual code
    - record synchronized revisions
    - done

MISMATCH
    - return concise discrepancy to coding agent
    - coding agent fixes code
    - reconcile again
```

That is the architecture.

Anything whose primary purpose is to turn semantic-first into a project manager, specification task engine, requirement tracker, or coding-runtime orchestrator is outside scope and should be removed.

---

# 2. Fundamental authority model

There are only four important authorities.

## A. User request

Defines what the user wants.

For example:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

The coding agent must receive this request unchanged and may read the referenced document itself.

The semantic layer does NOT need to convert the entire document into hundreds of requirements.

## B. Current semantic model

Describes the architecture of the actual repository:

```text
capabilities
components
responsibilities
interfaces
dependencies
invariants
implementation bindings
semantic identities
```

It helps answer:

```text
what currently owns this behavior?
where should this change belong?
what architectural relationship should change?
```

## C. Coding agent

Owns:

```text
task decomposition
reading large specifications
choosing the next implementation step
editing implementation
iterating until it believes the user's task is complete
```

Semantic-first does not duplicate those responsibilities.

## D. Actual implementation

The repository code is final implementation truth.

After coding:

```text
actual code
→ regenerated semantics
```

not:

```text
old semantic document
→ force code to pretend it matches
```

---

# 3. Keep these semantic-first responsibilities

Preserve or simplify the code that implements these responsibilities:

1. current semantic project model;
2. semantic interpretation/preflight;
3. target semantic delta;
4. semantic entity → implementation binding/path mapping;
5. deterministic mutation/write-path enforcement;
6. safe explicit external file reading where useful;
7. post-code semantic regeneration/reconciliation;
8. synchronization/conflict detection;
9. semantic provider error handling/failover where already working;
10. deterministic tool/effect authorization that protects writes.

Do not remove safety boundaries merely to reduce code.

Reduce architecture around them.

---

# 4. Remove these responsibilities from semantic-first

Semantic-first must NOT own:

- parsing an entire specification into hundreds of requirements;
- persistent requirement manifests;
- per-requirement state machines;
- requirement IDs for every sentence in a document;
- specification execution tasks;
- specification execution slices;
- cross-run requirement task orchestration;
- requirement progress counters;
- requirement dependency graphs;
- runtime implementation packets;
- duplicate coding-agent prompts generated from requirement ledgers;
- semantic-side project management;
- deciding every detail the coding model must do;
- a second autonomous task loop competing with the coding runtime;
- requirement-level evidence ledgers for arbitrary documents;
- frontend completion based on requirement counts;
- special Harvest rules inside generic semantic infrastructure.

The coding agent already does project/task planning.

Do not duplicate it.

---

# 5. Delete or collapse the specification-compliance subsystem

Current code contains a large `spec_compliance` subsystem added to solve the wrong problem.

Remove it from the production execution path.

If the module exists as:

```text
tools/agentx_evolve/semantic_first/spec_compliance.py
```

delete it unless a tiny generally useful helper remains after cleanup.

Remove:

- `SpecRequirement`;
- `RequirementAssessment`;
- `SpecComplianceResult`;
- request-mode `SPEC_COMPLIANCE` machinery;
- `MAX_SPEC_REQUIREMENTS`;
- Harvest-specific requirement extraction;
- Harvest-specific assessment logic;
- compliance ledger persistence;
- requirement extraction LLM prompts;
- requirement assessment LLM prompts;
- spec-completion evidence;
- "remaining mandatory requirements" production state.

Do not retain dead compatibility wrappers.

---

# 6. Delete the runtime implementation packet architecture

Current code contains:

```text
tools/agentx_evolve/semantic_first/runtime_handoff.py
```

whose purpose is to transform semantic compliance requirements into a second giant coding prompt.

Remove this architecture.

Delete, where no longer needed:

- `RuntimeImplementationPacket`;
- `RuntimeRequirement`;
- runtime packet persistence;
- runtime packet digest;
- runtime packet path;
- packet integrity state;
- packet formatting;
- `remaining_requirements` packet fields;
- `satisfied_requirement_ids`;
- spec requirement → component fallback mapping;
- runtime packet recovery code.

Do not replace it with another renamed packet framework.

---

# 7. Replace runtime handoff with one small semantic context

The coding runtime should receive:

```text
ORIGINAL USER REQUEST

SEMANTIC PREFLIGHT CONTEXT
- semantic intent
- affected semantic components
- target semantic change
- known current implementation bindings
- currently authorized paths, if any
- instruction that additional paths require semantic authorization
```

That is all.

Conceptually:

```python
RuntimeSemanticContext(
    run_id,
    target_digest,
    intent,
    target_summary,
    affected_components,
    implementation_bindings,
    currently_authorized_paths,
)
```

This may be a simple dict/dataclass.

Do not make it persistent task-management state.

The original user request remains the primary coding prompt.

---

# 8. Large external implementation documents

For a request such as:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

the architecture should be:

```text
semantic preflight:
    recognize this is a broad Harvest implementation request
    identify Harvest semantic ownership / likely architecture
    do NOT parse 2,000 lines into 124 requirements

coding agent:
    receives the original path
    reads the document directly
    plans and performs the work
```

The semantic layer may read enough of the document to understand high-level intent if necessary.

It does not need exhaustive document compliance analysis.

---

# 9. Simplify external file materialization

Keep safe explicit external-file reading because it is useful.

But reduce it to:

```text
explicit user path
→ validate
→ read-only access
→ digest
→ optional semantic-preflight context
```

Do not:

- build requirement manifests;
- persist giant augmented prompts;
- treat the external document as mutation authority;
- duplicate the full document into every LLM call.

The coding runtime should retain the original path and may read the file itself.

---

# 10. Semantic preflight output must be small

Replace the current oversized target/compliance contract with a bounded schema.

Example:

```json
{
  "intent": "Bring Harvest implementation into conformance with the supplied implementation specification.",
  "mutation_expected": true,
  "affected_components": [
    "harvest"
  ],
  "target_changes": [
    {
      "component": "harvest",
      "desired_state": "Harvest decides candidate value/disposition; semantic-first remains sole project mutation authority.",
      "authority": "prompt_driven"
    }
  ],
  "known_bindings": [
    "tools/agentx_evolve/collective_core/harvest_gate_b.py",
    "tools/agentx_evolve/collective_core/harvest_ui.py",
    "tools/agentx_evolve/collective_core/harvest_wiring.py"
  ]
}
```

The exact schema may differ.

Keep it small and architectural.

---

# 11. Do not require semantic preflight to enumerate the full final write set

This was a major source of complexity.

Preflight may identify:

```text
known/candidate implementation scope
```

but it does not need to know every file the coding agent will eventually touch.

The coding agent may discover implementation dependencies while working.

Therefore use two levels:

```text
semantic target
+
dynamically authorized exact write paths
```

---

# 12. Preserve deterministic exact write enforcement

Do NOT return to unrestricted repository writes.

Every actual mutation path still requires deterministic authorization.

Initial known paths may be authorized from semantic bindings.

When the coding agent needs another path:

```text
coding agent attempts/proposes path
↓
resolve path to semantic owner
↓
check whether owner is compatible with accepted semantic target
↓
if clearly compatible:
    extend run write authorization
↓
if architectural meaning is uncertain:
    one bounded semantic amendment decision
↓
authorize or deny
```

This is a **scope amendment**, not a project-management system.

---

# 13. Scope amendment must be cheap

A scope amendment should answer only:

```text
Does modifying this exact path/component belong to the already accepted semantic target?
```

It must NOT:

- rebuild the user task;
- parse the external specification again;
- rebuild a requirement ledger;
- start another specification execution task.

Persist the amended target/write authorization atomically for the current run.

---

# 14. Read scope is broad, write scope is exact

Coding agents may need to inspect many files.

Permit broad governed read access inside the repository.

Only writes require exact path authorization.

This means semantic-first should stop trying to predict every file the coding agent may need to read.

---

# 15. Coding agent owns the implementation loop

Do not build a semantic-first loop that selects "requirement slices."

The coding runtime already has task planning and iteration.

Its loop is conceptually:

```text
read user request/spec
↓
inspect code
↓
choose next implementation step
↓
request/receive path authorization as needed
↓
modify code
↓
test/check
↓
continue
```

Semantic-first is present at architectural/write boundaries, not as a competing orchestrator.

---

# 16. Remove persistent specification-task infrastructure

Delete any code added for concepts such as:

```text
SpecExecutionTask
SpecExecutionPlan
SpecExecutionSlice
manifest_total
remaining_requirement_ids
verified_requirement_ids
current_slice
deferred_requirements
requirement execution state
```

if any have been implemented.

Do not implement them if they only exist in planning documents/tests.

---

# 17. Simplify `AffectedComponent`

Keep only fields genuinely needed for architecture and reconciliation.

A reasonable target component needs:

```text
component_id
component_type
authority_decision
target_state/change_description
known implementation targets/bindings
verification expectations
```

Do not put project-management state into the component.

If fields such as:

```text
requirement_ids
spec_task_id
slice_id
deferred_requirement_ids
```

exist only for the removed subsystem, delete them.

---

# 18. Simplify `pipeline.py`

Current:

```text
semantic_first/pipeline.py
```

has grown very large.

Reduce it toward these stages:

```text
1. load current semantic model
2. materialize explicit user source if needed
3. interpret request
4. design small target semantic delta
5. resolve known implementation bindings
6. return target
```

Move only reusable deterministic helpers to focused modules.

Delete specification-compliance orchestration from the pipeline.

Target substantially lower complexity and line count.

---

# 19. Simplify `semantic_gate.py`

The UI semantic gate should do:

```text
reserve/bind run
↓
check current sync/conflict state
↓
semantic preflight
↓
seal semantic target
↓
initialize exact write authorization
↓
allow coding runtime
```

Remove from the gate:

- spec requirement ledgers;
- runtime implementation packet;
- spec task completion;
- remaining requirement state;
- requirement counts;
- requirement-specific finalization.

---

# 20. Simplify the prepared runtime state

Current prepared state contains fields such as:

```text
runtime_packet
runtime_packet_path
runtime_packet_digest
spec_compliance
remaining_requirement_ids
```

Remove them.

Keep something small:

```python
prepared = {
    "run_id": ...,
    "run_state_dir": ...,
    "change_id": ...,
    "semantic_target": ...,
    "target_digest": ...,
    "authorized_write_paths": ...,
    "workspace_root": ...,
}
```

---

# 21. OpenCode/Codex/LLM7 receive the same simple context

For all coding runtimes:

```text
runtime prompt =
    concise semantic preflight context
    +
    original user request
```

Do not maintain separate semantic task systems for each provider.

The original user prompt must remain fully visible.

---

# 22. Remove provider-prose completion authority from backend architecture

The provider may decide its coding task is done.

But backend completion means:

```text
provider turn ended
+
semantic reconciliation succeeded
```

Provider prose alone does not set semantic synchronization state.

Do not parse phrases such as:

```text
Task complete
Done
Already implemented
```

as semantic authority.

---

# 23. Frontend completion logic

Current frontend has logic such as:

```text
loopDeclaredDone(assistantText)
```

that can stop the autonomous loop based on assistant prose.

Simplify:

For build/mutation mode:

```text
provider turn ends
↓
backend finalization/reconciliation result arrives
↓
if reconciliation says NEEDS_FIX:
    continue/fix
if reconciliation says SYNCED:
    allow UI loop to stop
```

The UI may display provider text.

It must not override backend semantic reconciliation.

---

# 24. Remove requirement-count UI

Remove or stop producing fields such as:

```text
mandatory requirements
remaining requirements
spec compliance complete
current requirement slice
```

unless they belong to an unrelated product feature.

They are not needed for semantic-first.

---

# 25. Post-code reconciliation is the key control

After every write-capable coding turn:

```text
collect actual changed production files
↓
re-scan affected semantic entities from actual code
↓
compare with accepted semantic target
```

The result is one of:

```text
SYNCED
NEEDS_FIX
CONFLICT
NO_IMPLEMENTATION_EFFECT
```

Keep this very small.

---

# 26. `SYNCED`

Return `SYNCED` when:

- actual changed implementation is coherent;
- regenerated semantic meaning is compatible with target;
- no unauthorized semantic ownership changes appeared;
- current semantic model has been updated from actual code.

Do not require a multi-artifact ceremony merely to say semantics match implementation.

---

# 27. `NEEDS_FIX`

Return a concise structured discrepancy.

Example:

```json
{
  "status": "NEEDS_FIX",
  "issues": [
    {
      "component": "harvest_gate_b",
      "expected": "Gate B does not mint project mutation authority.",
      "actual": "Gate B still describes itself as the only implementation authorization mint."
    }
  ]
}
```

Send this back to the coding agent.

Do not create a requirement execution task.

---

# 28. `CONFLICT`

Use when the actual code and accepted semantic state have both changed independently or current baseline is genuinely stale.

Use existing conflict/synchronization protections where valuable.

Do not turn ordinary mismatches into elaborate conflict workflows.

---

# 29. `NO_IMPLEMENTATION_EFFECT`

For a request whose semantic preflight says:

```text
mutation_expected = true
```

and the coding turn changes no relevant implementation:

```text
NO_IMPLEMENTATION_EFFECT
```

must NOT be treated as successful implementation completion.

Return that to the coding runtime/UI.

This directly prevents the current:

```text
do nothing
→ Task complete
```

failure.

---

# 30. Genuine no-op

If preflight genuinely concludes:

```text
mutation_expected = false
```

a no-change result is valid.

Do not build a massive requirement compliance system just to prove generic no-op.

If the user specifically asks for an audit/proof of complete compliance, that is a separate explicit auditing task.

---

# 31. Actual code is the semantic-model source after implementation

After successful coding:

```text
changed implementation
→ scanner/reconciliation
→ accepted semantic model
```

Do not manually patch semantic state to say what the code should have become.

The semantic target is the intended direction.

The regenerated current model describes what actually exists.

---

# 32. Simplify synchronization state

The project needs one small accepted synchronization record.

Conceptually:

```json
{
  "implementation_revision": "...",
  "semantic_revision": "...",
  "status": "SYNCED",
  "accepted_at": "...",
  "accepted_run_id": "..."
}
```

Add repository identity if needed.

Do not require multiple overlapping evidence ledgers simply to compare two revisions.

---

# 33. Remove redundant evidence bureaucracy

Audit:

```text
semantic_first/evidence.py
semantic_code_sync evidence
target evidence
verification evidence
consumed-evidence ledgers
run-specific evidence pairs
```

Keep only evidence that enforces a real safety invariant.

If an evidence artifact exists solely because the previous architecture required:

```text
target evidence + verification evidence + consumption + baseline mint
```

and the same invariant can be enforced directly during atomic reconciliation, remove the extra layer.

Do not remove actual test results/logs needed for debugging.

---

# 34. Atomic reconciliation

The simplified reconciliation transaction should:

1. verify changed paths are authorized;
2. run focused behavioral verification;
3. regenerate affected semantic model;
4. compare actual semantics with target;
5. if success:
   - atomically persist current semantic model;
   - atomically persist sync revision;
6. if failure:
   - do not promote semantic model as accepted;
   - return discrepancy.

Never promote semantic truth before final success is known.

---

# 35. Fix the current promotion-before-final-check hazard

Audit current finalization carefully.

Do not:

```text
reconcile/promote semantic model
↓
later discover post-check failure
↓
rollback code only
```

If implementation is rolled back, accepted semantic model must not describe the rejected code.

Promotion occurs only after every required final check passes.

---

# 36. Simplify rollback

Do not preserve an incomplete rollback mechanism that snapshots only small files and silently skips others.

Choose one robust approach.

Preferred principles:

- do not modify unrelated pre-existing user changes;
- know exactly which authorized files the run changed;
- preserve their pre-run state sufficiently to restore them if the run is rejected;
- if a file cannot be safely rolled back, do not promise automatic rollback for it.

Fail before mutation when rollback guarantees required by policy cannot be met.

Do not silently skip an authorized file and later claim rollback succeeded.

---

# 37. Verification

Keep focused verification.

For each coding turn:

```text
changed code
+
target semantics
→ relevant existing tests/checks
```

The coding agent may run its own tests during work.

Backend finalization should at minimum:

- syntax/import validation where relevant;
- focused existing tests mapped to changed modules/capabilities;
- explicit acceptance checks known from target;
- semantic reconciliation.

Do not require a separate generic specification requirement verifier.

---

# 38. Test selection

Use current semantic bindings/model to find relevant tests.

Example:

```text
changed harvest_gate_b.py
→ Harvest/Gate-B tests
```

Do not run the entire repository test suite for every tiny change unless necessary.

Do not fail every run merely because an external `test_runner` argument was not injected.

Finalization owns its verification plan.

---

# 39. Semantic provider usage

Keep the provider resilience work already implemented:

- env-aware provider;
- bounded timeout;
- candidate failover;
- strict JSON/contract validation;
- one bounded repair;
- exact authority enum validation.

Do not reintroduce provider fragility.

But use the provider for **architecture decisions**, not project management.

---

# 40. Keep provider prompts small

Provider calls should operate on:

```text
user intent
relevant current semantic model slice
relevant bindings
small target description
```

not:

```text
entire repository
entire 2,000-line specification
124 requirements
all previous completion evidence
```

---

# 41. Current semantic model complexity audit

Audit `semantic_first/project_model.py`.

Keep information that materially helps:

```text
ownership
capabilities
interfaces
dependencies
invariants
implementation bindings
semantic identity
verification bindings
```

Remove fields/processes that exist only to serve the deleted spec executor.

Do not rewrite the whole semantic scanner unnecessarily.

---

# 42. Enrichment audit

Current `semantic_first/enrichment.py` is large.

Determine whether each enrichment pass is required for:

```text
preflight
binding resolution
reconciliation
```

Delete or merge enrichment machinery that serves speculative semantic completeness but does not improve those three operations.

Prefer deterministic AST/current-code facts where possible.

Use LLM enrichment only where architectural interpretation genuinely requires it.

---

# 43. Drift detector audit

If `drift_detector.py` duplicates reconciliation/synchronization logic, merge it.

There should be one canonical question:

```text
Does current actual semantic state match accepted implementation/target state?
```

Do not maintain several competing drift definitions.

---

# 44. Remove stale exports/imports/tests

After deletion:

- remove exports from `semantic_first/__init__.py`;
- remove imports from API modules;
- remove run-record fields used only by spec compliance/runtime packets;
- remove frontend fields used only by requirement counts;
- delete obsolete tests;
- delete obsolete fixtures;
- remove migration/compatibility branches unless real persisted user state requires them.

Run repository-wide search for removed names.

Zero dead references.

---

# 45. Run-record simplification

Remove semantic-spec fields such as:

```text
task_status
task_complete
remaining_requirement_ids
spec_compliance_complete
runtime_packet_digest
runtime_packet_path
```

when they exist only for the deleted subsystem.

Keep:

```text
run_id
status
semantic_target_digest
semantic_state_dir/change_id
sync/reconciliation result
```

and normal runtime diagnostics.

---

# 46. Lifecycle

Use one simple lifecycle:

```text
REQUESTED
↓
PREFLIGHTED
↓
CODING
↓
RECONCILING
├── SYNCED
├── NEEDS_FIX
├── CONFLICT
└── BLOCKED
```

No requirement/task/slice lifecycle.

---

# 47. Failure recovery

## Provider failure before preflight

```text
BLOCKED
```

No mutation.

## Unauthorized write path

```text
attempt narrow semantic scope amendment
```

If denied:

```text
block that write
```

Do not kill unrelated read-only planning.

## Coding process crashes

Keep semantic target/run identity.

Restart coding runtime against current worktree and reconcile actual current changes before resuming.

## Reconciliation failure

Do not promote semantic model.

Return discrepancy.

## Backend restart

Reload accepted project model + current sync state.

Active mutation authority from the old process does not resurrect automatically.

---

# 48. No Architectural MCP dependency

Do not assume Architectural MCP exists.

Use current repository model/bindings.

If future MCP architecture tooling appears, it can plug into the same simple preflight/reconciliation contract.

---

# 49. Harvest must become an ordinary test of the architecture

Do NOT add special semantic-first logic for Harvest.

The real acceptance command remains:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

Expected:

```text
semantic preflight identifies Harvest architectural target
↓
coding agent receives original prompt/path
↓
coding agent reads the Harvest document
↓
coding agent starts modifying actual Harvest code
↓
scope expands narrowly when needed
↓
coding agent continues its own task loop
↓
post-code semantic reconciliation checks actual result
```

No Harvest-specific requirement parser.

---

# 50. Real Harvest acceptance evidence

Before cleanup is declared successful, run the command above.

It must cause real target-domain implementation work.

At minimum, current known defects should no longer survive untouched, including where still present on the current branch:

- Gate B claiming to mint implementation authorization;
- `agentx_status` deciding disposition;
- disposition-only `can_implement()`;
- `EXPERIMENT_ONLY` production eligibility;
- `(ui_api_wired or True)` completion bypass.

Semantic infrastructure changes alone do not count.

---

# 51. The coding agent may work through a large prompt in multiple turns

Do not force one giant coding turn.

Use the coding runtime's existing autonomous/iterative behavior.

If the provider/context limit requires continuation:

```text
preserve original task
preserve semantic target
preserve actual worktree
continue coding
```

Do not introduce a requirement manifest to accomplish continuation.

---

# 52. Semantic reconciliation may happen incrementally

For long work:

```text
coding batch
→ reconcile changed semantics
→ if coherent, continue coding under same high-level target
```

A new full semantic preflight is needed only when:

- user intent changes;
- target architecture changes materially;
- coding agent proposes a change outside the accepted semantic target.

This keeps semantic checks useful without making them obstructive.

---

# 53. Explicit decisions about current junk

Audit the current branch and produce a deletion/migration table before editing.

Use columns:

```text
module / subsystem
KEEP
SIMPLIFY
MERGE
DELETE
reason
replacement responsibility
```

At minimum review:

```text
semantic_first/spec_compliance.py
semantic_first/runtime_handoff.py
semantic_first/pipeline.py
semantic_first/interceptor.py
semantic_first/materialize.py
semantic_first/write_scope.py
semantic_first/synchronization.py
semantic_first/evidence.py
semantic_first/drift_detector.py
semantic_first/enrichment.py
api/semantic_gate.py
api/chat.py
api/codex_chat.py
api/llm7_chat.py
frontend useSendMessage completion logic
semantic_project persisted artifacts
related tests
```

Do not preserve a subsystem merely because many tests currently cover it.

Tests that enforce a bad architecture must be removed/replaced.

---

# 54. Deletion-first rule

For every old mechanism, ask:

```text
Can the simplified architecture work correctly without this?
```

If yes:

```text
delete it
```

Do not leave:

- compatibility wrappers;
- deprecated production branches;
- dormant task engines;
- unused dataclasses;
- obsolete state files;
- duplicate validators.

We want a smaller architecture, not old architecture hidden behind feature flags.

---

# 55. Do not replace deleted complexity with equivalent new complexity

Forbidden outcome:

```text
delete SpecComplianceEngine
→ create SemanticTaskComplianceOrchestrator
```

or:

```text
delete RuntimeImplementationPacket
→ create ExecutionSemanticEnvelope with the same fields
```

Measure conceptual complexity, not names.

---

# 56. Target code-reduction goal

Do not optimize for an arbitrary percentage at the expense of correctness.

But this cleanup should result in meaningful reduction.

At completion report:

```text
semantic-first production files before
semantic-first production files after
production LOC before
production LOC after
deleted LOC
new LOC
net reduction
number of state concepts before
number after
```

A cleanup that adds more code than it removes should be presumed failed unless there is a compelling safety reason.

---

# 57. Target conceptual model

After cleanup a new developer should be able to explain semantic-first in under one minute:

```text
Before coding, Agent_X decides what architectural change is intended.

The coding agent implements the user's request.

Writes are allowed only when they fit the accepted semantic target.

After coding, Agent_X regenerates the affected semantics from real code and verifies that implementation and target agree.

If they agree, the semantic model and code are synchronized.
If they do not, the coding agent fixes the mismatch.
```

If explaining it requires:

```text
requirement manifest
slice
compliance ledger
runtime packet
target evidence
verification evidence pair
consumption record
spec execution task
```

the cleanup failed.

---

# 58. Minimal persistent state

Aim for persistent semantic state roughly like:

```text
semantic_project/project_model.json
semantic_project/sync_state.json
```

plus bounded run-local target/reconciliation diagnostics if useful.

Do not accumulate hundreds of semantic transaction artifacts as current authority.

Git already provides historical archive.

---

# 59. Historical data

Do not delete Git history.

Old semantic files already committed remain recoverable from Git.

Production runtime does not need to keep duplicate historical state merely to serve as archive.

---

# 60. Reconciliation must be idempotent

If:

```text
code unchanged
semantic model already reflects code
```

reconciliation should produce:

```text
SYNCED
```

without creating new semantic churn.

Running it twice should leave the same accepted state.

---

# 61. Rename/move handling

Keep stable semantic identities where useful.

A code move/rename should update binding paths without inventing duplicate capabilities.

This belongs in reconciliation/project-model logic, not a specification task engine.

---

# 62. Replace/remove behavior

Semantic preflight may determine:

```text
replace old implementation
```

The coding agent then performs replacement.

Reconciliation verifies:

- new ownership exists;
- obsolete ownership is removed;
- no stale duplicate implementation remains.

No requirement ledger necessary.

---

# 63. Security/governance boundaries

Preserve deterministic code for:

- credentials;
- mutation authorization;
- path containment;
- transactions;
- locks;
- Git/workspace identity;
- effect contracts;
- rollback where guaranteed;
- synchronization state persistence.

Do not convert these into prompt-only logic.

---

# 64. Prompt-driven responsibilities

Use LLM semantic reasoning for:

- interpreting architectural intent;
- deciding replace/extend/create at architectural level;
- identifying likely ownership when deterministic model is ambiguous;
- deciding whether a proposed scope amendment fits the accepted target;
- interpreting semantic reconciliation mismatches.

Keep deterministic validation after LLM output.

---

# 65. Exact acceptance tests

## Test 1 — simple change

User:

```text
Change capability X behavior.
```

Expected:

```text
preflight
→ target X
→ coding runtime edits X
→ reconciliation
→ SYNCED
```

## Test 2 — extra file discovered

Initial target maps to `a.py`.

Coding agent discovers `b.py` must change.

Expected:

```text
write b.py attempted
→ semantic scope amendment
→ b.py belongs to target
→ authorize
→ continue
```

No full task rebuild.

## Test 3 — unrelated write

Coding agent tries unrelated `z.py`.

Expected:

```text
scope amendment denies
```

Other coding/read context remains intact.

## Test 4 — no implementation effect

Preflight says mutation expected.

Coding agent changes nothing.

Expected:

```text
NO_IMPLEMENTATION_EFFECT
```

not `Task complete`.

## Test 5 — semantic mismatch

Coding agent makes code change inconsistent with target.

Expected:

```text
NEEDS_FIX
```

with concise discrepancy.

No semantic promotion.

## Test 6 — successful reconciliation

Coding agent implements target.

Expected:

```text
regenerated current semantics match
→ accepted project model updated
→ sync state SYNCED
```

## Test 7 — repeated reconciliation

Run again with no changes.

Expected:

```text
SYNCED
```

and no new state churn.

## Test 8 — external document

User gives `/home/.../HARVEST.md`.

Expected:

```text
safe external read available
coding runtime receives original path
semantic preflight stays bounded
coding runtime reads the document itself
```

No requirement manifest.

## Test 9 — real Harvest

Current known Harvest defects must produce actual Harvest code changes.

## Test 10 — provider failure

Semantic provider unavailable.

Expected:

```text
mutation blocked
clear provider failure
no structural fallback authorization
```

---

# 66. Remove obsolete tests

Delete tests whose sole purpose is to prove:

- requirement manifests;
- 128-requirement handling;
- requirement extraction;
- compliance ledgers;
- runtime implementation packets;
- all remaining requirements injected into a coding prompt;
- requirement-count UI;
- spec task slicing;
- task persistence for requirement execution.

Replace with tests for the simplified flow above.

---

# 67. Migration strategy

Perform cleanup in safe phases.

## Phase A — freeze intended architecture

Write/update one concise architecture document describing the simplified flow.

No implementation yet.

## Phase B — introduce simplified interfaces

Create/normalize:

```text
semantic preflight result
semantic run target
dynamic write authorization
reconciliation result
sync state
```

Prefer adapting existing good types rather than adding parallel types.

## Phase C — switch runtime callers

Make OpenCode/Codex/LLM7 use the simple semantic context.

Remove runtime packet usage.

## Phase D — switch finalization

Use direct reconciliation.

Remove spec compliance from finalization.

## Phase E — delete dead subsystem

Delete spec compliance, runtime handoff, obsolete fields, tests and state.

## Phase F — shrink/merge remaining modules

Reduce pipeline/interceptor/gate duplication.

## Phase G — real end-to-end tests

Run Harvest and other representative tasks.

---

# 68. Never leave both old and new systems active

At each migration phase, ensure one production authority.

Do not keep:

```text
old spec-compliance completion
+
new reconciliation completion
```

running in parallel.

That recreates the exact problem being fixed.

---

# 69. Canonical completion authority after cleanup

For a coding turn:

```text
coding runtime terminates
↓
backend detects actual changes
↓
focused verification
↓
semantic reconciliation
↓
result
```

Backend statuses:

```text
SYNCED
NEEDS_FIX
CONFLICT
NO_IMPLEMENTATION_EFFECT
BLOCKED
```

The frontend derives completion from this result.

---

# 70. Acceptance criterion for "complete everything according to..."

We deliberately do NOT guarantee exhaustive requirement auditing in semantic-first.

Instead:

- coding agent owns exhaustive execution of the document;
- semantic-first guarantees architectural correctness and synchronization of every implementation change it makes.

If the user needs a formal requirement-by-requirement audit, that should be an explicit separate audit feature/workflow, not the mutation foundation.

---

# 71. Current-main audit requirement

Before editing, confirm actual current main.

Do not assume the SHA in this document is still current.

Search for every current production reference to:

```text
SpecCompliance
spec_compliance
remaining_requirement
runtime_packet
RuntimeImplementationPacket
task_complete
loopDeclaredDone
completion_evidence
```

Classify each:

```text
keep for unrelated reason
replace
delete
```

Then execute cleanup.

---

# 72. Completion criteria

Do not stop until ALL are true:

1. Semantic-first can be described as preflight → code → reconcile.
2. Coding agent owns task decomposition.
3. Large specs are not converted into semantic requirement manifests.
4. `spec_compliance.py` is removed from production architecture.
5. Runtime implementation packet architecture is removed.
6. No requirement ledger controls mutation/completion.
7. No spec execution task/slice engine exists.
8. Original user request is delivered to coding runtime unchanged.
9. Semantic context added to runtime is small and architectural.
10. External explicit source documents remain safely readable.
11. Preflight output is bounded.
12. Reads may be broad.
13. Writes remain exact and deterministic.
14. Additional write paths use narrow semantic scope amendment.
15. Scope amendment does not rebuild the task.
16. Provider prose cannot set synchronization state.
17. Frontend completion follows backend reconciliation.
18. Mutation-expected zero-effect run returns `NO_IMPLEMENTATION_EFFECT`.
19. Post-code reconciliation rescans actual changed implementation.
20. Accepted semantic model is generated from actual code.
21. Semantic target is never promoted as current truth before code proves it.
22. Reconciliation mismatch returns `NEEDS_FIX`.
23. Failed reconciliation does not leave promoted stale semantics.
24. Successful reconciliation produces `SYNCED`.
25. Re-running reconciliation unchanged remains `SYNCED`.
26. Sync persistence is minimal and atomic.
27. Old target/verification/compliance evidence bureaucracy is removed where redundant.
28. No old and new completion authorities operate in parallel.
29. Run-record spec-task fields are removed where no longer needed.
30. Frontend requirement-count/task-slice state is removed.
31. Obsolete tests are removed/replaced.
32. Repository-wide search shows no dead removed-system imports.
33. Provider failover/contract validation still works.
34. Deterministic write/effect safety still works.
35. Current semantic model still maps ownership/bindings correctly.
36. Real Harvest command begins editing actual Harvest implementation.
37. Current known Harvest defects are no longer ignored as "task complete."
38. Final Harvest coding batch reconciles semantically.
39. Current code and accepted semantic model end `SYNCED`.
40. A second no-change reconciliation remains `SYNCED`.
41. Production semantic-first LOC is materially reduced.
42. Final report lists deleted files/LOC and simplified architecture.

---

# 73. Final stop condition

Stop when the production architecture is genuinely this simple:

```text
                 USER REQUEST
                      │
                      ▼
             ┌─────────────────┐
             │ Semantic        │
             │ Preflight       │
             └────────┬────────┘
                      │
              target + bindings
                      │
                      ▼
             ┌─────────────────┐
             │ Coding Agent    │
             │ owns task loop  │
             └────────┬────────┘
                      │
               actual code changes
                      │
                      ▼
             ┌─────────────────┐
             │ Semantic        │
             │ Reconciliation  │
             └────────┬────────┘
                      │
              ┌───────┴────────┐
              │                │
          MATCH/SYNCED      NEEDS_FIX
              │                │
              ▼                └──→ coding agent
      accepted semantic
       model from code
```

Anything that does not materially support those boxes or their deterministic safety boundaries should be presumed removable.

The goal is not to preserve the machinery we built.

The goal is to restore the original Agent_X semantic-first idea in the smallest robust form.
