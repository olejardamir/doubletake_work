# DoubleTake Impasse-Native Cognitive Control Mission — Recovered Consolidated Prompt v19

## Mission

Implement the **four highest-value mechanisms** identified from *Unified Theories of Cognition* as native DoubleTake behavior:

1. **Typed impasse-driven control** — when a governed task cannot advance, represent the blockage explicitly as `TIE`, `NO_CHANGE`, `REJECT`, or `CONFLICT`, create one bounded resolution subgoal, and resume or block the parent only from evidence.
2. **Goal-context working memory** — make temporary reasoning visible according to the active goal/subgoal hierarchy so abandoned child context cannot contaminate later work, while explicitly promoted and persistent knowledge survives.
3. **Verified resolution compilation** — compile a successfully resolved impasse into reusable structured procedural knowledge only when the causal path is explicit and independently verified; reuse it as prepared knowledge without bypassing current governance or fresh evidence.
4. **Whole-system application benchmarks** — prove first-encounter deliberation, recurrence reuse, stale-resolution refusal, goal-context pruning, governance preservation, restart durability, and production reachability.

Do **not** implement Soar. Do **not** add a second master loop, second planner, second capability router, second generic memory system, second governance path, or second model-control stack.

Treat current GitHub `main` as authoritative at execution time. The verified reference point for this prompt is:

`0c22307cc00bcf7819aed5bf72b5e1fadac6a66e`

> **Recovery snapshot.** This file consolidates the full implementation prompt accumulated through the latest review/recovery pass. It preserves the current authoritative-repo findings, owner-boundary corrections, crash/restart semantics, idempotency rules, context-isolation requirements, verified-resolution rules, production-reachability constraints, benchmark suite, sabotage checks, and convergence/stopping conditions gathered so far.


This SHA is an **observed convergence reference, not a pin**. Reinspect `main` immediately before editing. If `main` has moved, diff the live head against this reference, re-trace every owner seam touched by that delta, and update the implementation plan before changing code. The live head remains authoritative. Never reset/revert concurrent work merely to restore this reference. If an API or path has changed, follow the live equivalent and preserve the ownership rules below.

---

# 1. Non-negotiable architectural rule

Make this invariant true in the **real governed runtime**:

> When a canonical DoubleTake task has a declared objective and a runtime owner reports that the task cannot make meaningful progress, DoubleTake must classify the blocking condition deterministically, open at most one resolution subgoal for the unchanged blocking state, scope temporary context to the active goal hierarchy, resolve the blockage only through existing governed execution/recovery mechanisms, close or abandon the child from authoritative evidence, and optionally compile the successful resolution into verified prepared knowledge. Prepared knowledge may reduce future deliberation but may never outrank current hard gates, current measurements, current authority, or current dependency state.

A feature that is only callable directly from a test, MCP tool, HTTP endpoint, or documentation page does not satisfy this mission.

---

# 2. Existing owners: reuse them, do not compete with them

Before implementation, trace these exact live owners and their tests.

## 2.1 Project/task ingress and canonical task identity

- `tools/doubletake_evolve/project_evolution/boundary.py`
- `tools/doubletake_evolve/project_evolution/models.py`

`submit_user_prompt()` is the shared project-task boundary. `ProjectTask` is the canonical task object. Preserve that authority.

The repository already attaches live, non-evidence handles such as `capability_session` to a frozen `ProjectTask` while excluding them from task digests. Use the same pattern if a live cognitive session is needed.

## 2.2 Existing meta-control / deliberation substrate

- `tools/doubletake_evolve/meta_reasoning/production.py`
- `tools/doubletake_evolve/meta_reasoning/activation.py`
- `tools/doubletake_evolve/meta_reasoning/session.py`
- `tools/doubletake_evolve/meta_reasoning/stages.py`
- `tools/doubletake_evolve/meta_reasoning/state.py`
- `tools/doubletake_evolve/meta_reasoning/artifacts.py`
- `tools/doubletake_evolve/meta_reasoning/stop.py`

This package already owns deterministic DIRECT/META activation, governed controller inference, assess/propose/evaluate/dispatch/stop, compact state, budgets, artifact lineage, direct-history measurement, escalation, and dispatch reconciliation.

**Do not create another deliberation loop.** Impasse resolution must use this substrate when additional deliberation is actually needed and available.

In particular, prefer the existing production seams:

- `MetaControlBoundary.decide(...)`
- `MetaControlBoundary.measure_direct_history(...)`
- `MetaControlBoundary.escalate(...)`
- `MetaControlBoundary.control_state(...)` / the live canonical cancellation+pause read
- the live meta concurrency-refusal path (`concurrency_refusal(...)`, `MetaSession.record_conflict(...)`, `StateConflictError`, `StaleDecisionError` at the observed reference)
- `drive_governed_meta_cycle(...)`

Cancellation and pause are already owned by the canonical run manager/meta-control seam. **Do not invent a cognitive cancel/pause mechanism.** Cancellation is terminal for new work; pause is resumable. Both are execution-control facts, not cognitive impasses. A paused/cancelled run must not start a new resolution attempt or prepared-resolution step merely because the cognitive controller still has an open goal.

Do not call internal meta stages directly from the new mechanism unless current `main` has changed and no canonical seam exists.

At the observed reference, `workflows/_workflow_mixins/core.py` drives `drive_governed_meta_cycle(...)` **after** `BorgCollectiveOrchestrator.run(...)` has produced the governed result, and then returns that original result without branching on the meta outcome. Therefore that existing call site proves meta-control reachability but **does not by itself prove an impasse was resolved for the already-finished parent**. If cognitive resolution uses meta work, implement the bounded evidence-feedback/continuation rule in §11.1 at a production owner that can still re-enter the parent lifecycle; do not point at the post-pipeline meta call and declare closure.

## 2.3 Automatic capability participation

- `tools/doubletake_evolve/collective_core/capability_router.py`
- `tools/doubletake_evolve/collective_core/capability_participation.py`
- the canonical governed capability execution helper used by that module
- all `test_capability_*` tests

The capability router remains authoritative for semantic relevance, composition, conflicts, required inputs, duplicate suppression, recursive discovery, and governed execution.

The cognitive mechanism consumes authoritative participation outcomes. It does not re-rank the capability registry.

Consume the **final router/participation record after the router's current retrieval, rollout/shadow, composition, suppression, and contract semantics have been applied**. Do not read raw embedding/provider similarity scores or reconstruct relevance from `CapabilitySemanticIndex` internals inside cognitive control. Current `main` may deliberately run a semantic channel in shadow/non-authoritative mode; cognitive control must not accidentally turn that shadow signal back into execution authority.

## 2.4 Project evolution

- `tools/doubletake_evolve/project_evolution/evolution.py`
- `tools/doubletake_evolve/project_evolution/evaluation.py`
- `tools/doubletake_evolve/project_evolution/trial.py`
- `tools/doubletake_evolve/project_evolution/apply.py`
- `tools/doubletake_evolve/project_evolution/learning.py`

`evolve_project()` already owns candidate generation, isolated trials, hard gates, measured selection, recovery observations, and transferable lessons. Preserve those semantics.

## 2.5 Memory

- `tools/doubletake_evolve/enhanced_memory/working_memory.py`
- `tools/doubletake_evolve/enhanced_memory/long_term_memory.py`
- `tools/doubletake_evolve/enhanced_memory/cognition.py`
- `tools/doubletake_evolve/collective_core/memory.py`

Extend visibility of existing working memory. Do not replace retrieval, BM25, recency, fatigue, quotas, consolidation, or durable memory.

## 2.6 Live governed workflow owner: BorgCollectiveOrchestrator

- `tools/doubletake_evolve/collective_core/borg_collective_orchestrator.py`
- `tools/doubletake_evolve/workflows/_workflow_mixins/core.py`
- the live governed checkpoint/context/dispatch-journal owners used by that workflow

At the observed reference, the normal governed evolve-agent path executes through `BorgCollectiveOrchestrator.run(...)`, not through `project_evolution.evolve_project(...)` and not through the separate `collective_integration/operating_loop` package. The orchestrator already owns checkpoint-DAG decomposition, parallel waves, adaptive failure handling (`retry -> redistribute -> degrade -> abort`), coherence gating, dispatch settlement/journaling and the final governed run verdict. **Do not duplicate or bypass that recovery ladder.**

Cognitive control may observe this path only from an owner that can identify the canonical project objective and a real blocked outcome **after the existing adaptive ladder has exhausted the legal alternatives for that blockage**. A transient checkpoint retry/degradation is not automatically an impasse. If the current workflow has no proven safe continuation/resume seam after a blocked verdict, record/return the impasse as blocked rather than re-running an effectful orchestrator from scratch and risking duplicate effects. A new cognitive mechanism does not authorize inventing replay semantics that the orchestrator does not have.

## 2.7 Separate Collective system-management operating loop

- `tools/doubletake_evolve/collective_integration/operating_loop/`
- `tools/doubletake_evolve/collective_integration/strategic_planner.py`

This Borg operating loop is a **different** system-management loop from `BorgCollectiveOrchestrator`. Do not conflate the two because both use Borg terminology. **Do not force every sensor-cycle failure into the new cognitive mechanism.** Integrate there only where a real active strategic campaign or other canonical owner exposes an explicit goal and measured progress condition. Blindly creating cognitive goals per tick is a defect.

---

# 3. Scope: only the four high-value mechanisms

Do not expand this mission into lower-value cognitive-science features.

Specifically, do not add:
- a general preference language;
- a new representation-switching engine;
- a generic production-rule engine;
- a second society-of-agents abstraction;
- a new global semantic memory system;
- a new planner because Soar has operators;
- a model prompt that imitates Soar terminology.

Any helper type introduced here must be necessary to make one of the four mechanisms executable, testable, persistent, or safe.

---

# 4. New module: deterministic cognitive state, not a new controller loop

Create only the smallest coherent package needed, for example:

```text
tools/doubletake_evolve/cognitive_control/
    __init__.py
    models.py
    impasse.py
    goal_context.py
    resolution.py
    chunks.py
    store.py
    ports.py
    session.py
    tests/
```

Names may be adjusted to current repository conventions, but preserve the separation of responsibilities.

The new package may own:
- goal/subgoal state;
- blocking-state identity;
- impasse classification;
- resolution-subgoal lifecycle;
- working-memory visibility metadata and filters;
- resolution trace records;
- verified resolution-chunk applicability and persistence;
- cognitive evidence summaries and metrics.

It must **not** own:
- model/provider inference;
- semantic capability ranking;
- source mutation;
- project candidate evaluation;
- governance/approval;
- security decisions;
- rollback;
- actual capability execution;
- a free-running scheduler.

Keep imports one-directional. The new package should depend on common utilities and small data contracts, not import whole project-evolution, capability-router, meta-reasoning, or operating-loop modules and then be imported back by them. Put adapters at the existing owner boundaries. If a protocol is needed, define a tiny structural interface in `ports.py` such as an evidence sink / prepared-resolution executor port.

**The cognitive package must not directly call `MetaSession`, `CapabilityRouter`, `evolve_project`, or `BorgOperatingLoop`.** Their owning modules adapt canonical records into cognitive observations and call cognitive state transitions. This is the import-cycle and duplicate-authority boundary.

## 4.1 Minimal injected ports

If execution/persistence seams are needed, define only small protocols, for example:

```text
EvidenceSink.record_control(kind, payload, *, event_id, input_refs, task_revision) -> evidence_ref
PreparedResolutionExecutor.execute(template, *, goal_id, parent_revision, impasse_key, attempt_id) -> canonical outcome/receipt refs
ContextVisibility.project(state_or_refs, *, active_goal_id) -> visible projection
RunControlGate.before_new_effect(*, run_id, goal_id, attempt_id) -> canonical allow/pause/cancel verdict
```

Implement these ports in the modules that already own the authority. `cognitive_control` may validate the returned evidence and transition its state; it may not acquire the underlying authority itself.

`PreparedResolutionExecutor` must route through the same canonical execution path the operation would have used without a chunk. It is not a generic callable escape hatch.

`RunControlGate` is an **adapter over the existing canonical control owner**, not a new cancellation subsystem. On current observed `main`, meta-controlled work already has a live per-dispatch control probe; reuse that path where it applies. Other prepared-resolution adapters must preserve the equivalent owner gate before every new effect rather than caching a start-of-resolution verdict.

`event_id` and `attempt_id` are deterministic idempotency identities, not random logging ids. An adapter must be able to retry publication/reconciliation after a crash without creating a second logical event or repeating an effect whose outcome is already known or ambiguous.

---

# 5. Canonical cognitive session ownership

## 5.1 ProjectTask integration

For governed project work, add a live `cognitive_session` handle to `ProjectTask` using the same rules already used for `capability_session`:

- default `None`;
- `compare=False`;
- `repr=False`;
- never included in `evolution_view()`;
- never included in `to_document()`;
- never included in the task digest.

Add a boundary helper analogous to `capability_session_for(task)`, for example `cognitive_session_for(task, *, run_id=None, state_root=None, evidence_sink=None, scope_port=None, run_control_gate=None)`, that:
- returns an existing session when attached;
- otherwise builds one lazily;
- memoizes it on the frozen task with the same sanctioned pattern already used for live handles;
- binds a durable `EvidenceSink` exactly once. Prefer a caller-supplied canonical sink. **Do not guess a durable state/evidence root merely because `run_id` or `task_id` exists.** If the current ingress does not yet know the run's authoritative state/evidence owner, leave cognitive construction deferred until the first governed stage that does know it. Never substitute an in-memory sink while claiming restart/audit guarantees;
- if a path has an explicit canonical run-scoped `RunArtifactStore` (or live equivalent), adapt that exact instance/root rather than constructing a second store from an assumed default path;
- if a later caller attempts to bind a materially different state root/evidence owner/scope to an already-active session, refuse rather than silently switching durable authorities mid-task;
- uses the canonical state root supplied/derived by the owning governed runtime. `meta_reasoning.production.state_root()` is acceptable only where that is demonstrably the same owner/root the live run uses;
- resolves the effective run identity from an explicit owner-supplied `run_id` first, then `task.run_id`; **do not use `task_id` as if it were a run id**. The state namespace must distinguish the run from the task within the run;
- requires a stable canonical task/subject identity. Prefer non-empty `task.task_id`. If a direct production constructor created a `ProjectTask` before ids were available, the owning workflow must bind a stable `task_id`/`run_id` through the live equivalent of `ProjectTask.bind_repository(...)` (or otherwise supply a persisted canonical subject id) before durable cognitive state is enabled. Do not derive a durable task identity from objective text alone;
- if the owner cannot yet supply both a trustworthy run namespace and stable task/subject identity, return/defer as `COGNITIVE_UNAVAILABLE` rather than creating state under an assumed/default identity;
- derives a separate filesystem-safe `session_id` from a canonical digest of `(effective_run_id, canonical_object_kind, canonical_task_or_subject_id)` so multiple tasks in one run cannot overwrite one cognitive state file; never use raw prompt/user text as a path component;
- derives the effective `task_revision` and `objective_digest` through the same canonical projection used by meta reasoning (at the reference commit, `MetaTaskView.from_canonical(...)`) rather than inventing a new revision formula.

This lazy path is mandatory because some governed paths construct `ProjectTask` directly and bypass prompt intake. At the observed reference, direct workflow construction paths can create a `ProjectTask` before `run_id`/`task_id` are populated; do not assume those fields are already usable. Where the workflow later obtains its canonical run id, bind/replace the live task with the existing `bind_repository(...)` refinement (preserving live non-evidence handles) or pass the explicit owner identity to the helper, and persist/propagate that bound identity before claiming restart-safe cognitive state. Prompt intake need not eagerly create the session before a durable sink/root is known; it is acceptable to attach it immediately after the `ProjectTask` exists or to let the first governed project stage call the helper. What is not acceptable is requiring every caller to remember a manual registration step for the feature to exist. During a live meta run, a steered `MetaTaskView.task_revision` is authoritative even if the original immutable `ProjectTask` object is unchanged; feed that revision change to the cognitive session and supersede the old root.

## 5.2 Ordinary chat

Do not create goal stacks or impasses merely because ordinary chat ran automatic capability participation.

A cognitive session is warranted only when there is a canonical goal owner with a declared objective and an authoritative adapter capable of reporting progress/blockage as `ControlObservation`, such as a `ProjectTask`, a governed meta run, or an explicitly modeled strategic campaign.

This keeps the non-impasse hot path cheap and avoids manufacturing fake goals.

## 5.3 Task revision / objective replacement

A canonical task-revision or objective-digest change supersedes the old root goal. Mark the old root and all of its active descendants `ABANDONED`, then create/reuse a new root for the new revision/objective. Do not silently mutate the objective under the same root identity.

`GoalFrame.revision` is for decision-relevant state changes *within one canonical task revision*. Task revision changes are a stronger boundary and receive a new root.

---

# 6. Required data contracts

Use frozen dataclasses / existing digest utilities where appropriate. Use explicit schema versions for persisted structures.

## 6.1 GoalFrame

Minimum fields:

```text
schema_version
goal_id
run_id
session_id
task_revision
goal_kind            # ROOT | RESOLUTION
parent_goal_id
root_goal_id
depth
status
objective_digest
revision
parent_revision_at_creation
resolution_for_impasse_id
resolution_target
completion_evidence_requirements
resolution_attempt_budget
resolution_budget_total
resolution_attempts_consumed
origin
evidence_refs
created_at
updated_at
digest
```

Closed status vocabulary:

```text
ACTIVE
RESOLVING
RESOLVED
BLOCKED
ABANDONED
```

Rules:
- root has no parent;
- child must name an existing active parent;
- hierarchy must be acyclic;
- depth must be bounded by configuration;
- every meaningful parent-state replacement increments `revision`;
- root/parent resolution budget is cumulative across successor/reclassified impasses and may not reset merely because new evidence changes `state_key`; `resolution_attempts_consumed` is monotonic within the canonical task revision;
- a child created against revision N cannot resolve a parent currently at revision N+1;
- late results from a stale child are recorded as evidence but may not mutate/resolve the current parent;
- abandoning/replacing a parent abandons descendants created solely for the superseded state.
- `ROOT` must have empty `resolution_for_impasse_id`; `RESOLUTION` must name exactly one open impasse;
- every resolution child must state a machine-readable `resolution_target` and what evidence would count as completion;
- all persisted unordered collections are canonicalized deterministically before digesting; preserve order only where order is semantically meaningful (for example an operator sequence);
- root `goal_id` is deterministic from the cognitive `session_id` + canonical task revision/objective identity; `impasse_id` is deterministic from `impasse_key`; resolution-child `goal_id` is deterministic from `impasse_key`, so a crash/restart cannot mint a second logical goal for the same blockage;
- `GoalFrame.revision` is a cognitive mirror/version of decision-relevant state, not authority to change the canonical task. Increment it only when a new authoritative observation changes the decision-relevant state represented by the frame. It must never be used to claim that the underlying task progressed when the canonical owner did not report `ADVANCED`.

## 6.2 ControlObservation

Do not invent progress by comparing arbitrary whole-object hashes. The subsystem that owns a decision must report a small authoritative observation.

Minimum fields:

```text
schema_version
observation_id
goal_id
task_revision
goal_revision_observed
source_state_version
source
state_key
outcome
viable_option_ids
rejected_option_ids
hard_rejected_option_ids
rejection_authority_refs
conflict_pairs
missing_requirements
substantive_equivalence_groups
interchangeable_option_groups
material_choice
goal_satisfied
reason_codes
evidence_refs
governance_refs
created_at
digest
```

Closed `outcome` vocabulary:

```text
ADVANCED
NO_ADVANCE
BLOCKED
UNDECIDED
UNKNOWN
```

`state_key` is a digest of **decision-relevant stable facts only**. It must exclude timestamps, log ordering, random run-local IDs, and unrelated telemetry. Option/candidate identities included in the key must themselves be stable canonical identities/fingerprints; if an owning subsystem uses random/sequence ids for records, the adapter must hash the option's canonical decision-relevant content (strategy/effect/contract/change fingerprint) instead of putting the random id into `state_key`/`impasse_key`. Each adapter owns the projection from its canonical records.

Examples:
- capability participation: status, required inputs, selected/invoked/contributed capabilities, conflict refusals, relevant contract digests;
- project evolution: comparable measured candidate keys, failing hard gates, candidate statuses, selection state;
- strategic campaign: campaign id, objective state, measured progress/milestones.

The cognitive package must never infer `ADVANCED` from prose or model confidence. The adapter that owns the canonical measurement is responsible for saying whether progress occurred; the cognitive layer only checks consistency, staleness and lifecycle transitions.

`observation_id` must be deterministic for the same authoritative observation content. Prefer the owning subsystem's canonical event/state version plus `(goal_id, task_revision, goal_revision_observed, source, state_key, outcome)`; otherwise digest those normalized facts. Exclude publication artifact ids, timestamps, process ids, and other retry-generated wrappers from the logical observation id. `evidence_refs` remain citations in the record, not a reason to mint a new observation when the same source fact is republished. Re-delivery after restart must deduplicate rather than look like new evidence solely because time/process/publication identity changed.

`hard_rejected_option_ids` must be a subset of `rejected_option_ids`. `substantive_equivalence_groups` are groups the authoritative evaluator measured equal before reproducibility-only tiebreaks. `interchangeable_option_groups` are groups the canonical owner has evidence are semantically safe to treat as equivalent. `material_choice` must be explicitly measured/declared by the adapter; if it is unknown, do not fabricate a `TIE`.

`ADVANCED` means the canonical owner proved a decision-relevant state advance or that the parent can proceed; it does **not** by itself mean the whole task is complete. `goal_satisfied` is a separate authoritative boolean. A root/ordinary parent becomes `RESOLVED` only when the canonical owner reports `goal_satisfied=True`; otherwise an `ADVANCED` observation resumes it as `ACTIVE` at the next cognitive revision.

## 6.3 ImpasseKind

Exactly:

```text
TIE
NO_CHANGE
REJECT
CONFLICT
```

## 6.4 ImpasseRecord

Minimum fields:

```text
schema_version
impasse_id
impasse_key
kind
goal_id
parent_goal_revision
source_observation_id
state_key
reason_codes
viable_option_ids
rejected_option_ids
hard_rejected_option_ids
rejection_authority_refs
conflict_pairs
missing_requirements
substantive_equivalence_groups
interchangeable_option_groups
material_choice
evidence_refs
status
resolution_goal_id
created_at
resolved_at
digest
```

`impasse_key` must be deterministic for the unchanged blocking condition, e.g. a canonical digest over:

```text
goal_id
parent_goal_revision
kind
state_key
sorted blockers/options/requirements
```

This key is the idempotency boundary. The same unchanged blockage must return the same open impasse instead of spawning another resolution child.

Use a closed impasse status vocabulary such as:

```text
OPEN
RESOLVED
BLOCKED
ABANDONED
```

An impasse record must be self-auditing enough to recompute why its type was selected from the persisted observation facts; persist `source_observation_id` and enough normalized classification inputs to verify the choice. Do not persist only the final enum and discard the observation that caused it.

## 6.5 ResolutionTrace

Minimum fields:

```text
schema_version
trace_id
impasse_id
resolution_goal_id
parent_goal_revision
input_evidence_refs
operator_refs
execution_receipt_refs
intermediate_evidence_refs
result_evidence_refs
progress_observation_ref
result_state_key
status
created_at
completed_at
digest
```

This is explicit causal lineage, not hidden chain-of-thought. Use a closed status vocabulary such as `SUCCEEDED`, `FAILED`, `STALE`, `UNVERIFIABLE`. Only `SUCCEEDED` plus an authoritative parent `ADVANCED` observation is eligible for chunk candidacy.

## 6.6 ResolutionChunk

Minimum fields:

```text
chunk_id
schema_version
scope
scope_key
matcher_version
problem_signature
impasse_kind
hard_preconditions
operator_templates
contract_digests
dependency_digests
expected_effect
postconditions
source_impasse_id
source_trace_digest
verification_evidence_refs
negative_applicability_evidence_refs
support_count
success_count
failure_count
status
created_at
updated_at
last_verified_at
core_digest             # digest of immutable reusable core only
digest                  # digest of full mutable record
```

Closed status vocabulary:

```text
CANDIDATE
VERIFIED
INVALID
RETIRED
```

`chunk_id` must be deterministic from the immutable reusable core: repository `scope_key`, `matcher_version`, `problem_signature`, impasse kind, normalized hard preconditions, operator-template digest, contract/dependency digest schema (not mutable counters/status/timestamps). Recompiling the same resolution core after retry/restart must find the same chunk rather than minting duplicates. If the same `chunk_id` is encountered with different immutable core content, fail closed as corruption/collision.

Persist a separate `core_digest` over exactly that immutable reusable core. The ordinary record `digest` may cover mutable status, verification refs, counters and timestamps and therefore may change over the chunk's life. **Never use the mutable full-record digest as prepared-attempt identity.** A counter update must not make the same prepared resolution look like a new action.
Default `scope` must be repository-local. Do not implement automatic global/cross-project chunk reuse in this mission. `scope_key` should be derived only from a canonical **non-secret, stable repository identity**, then stored as a digest. Do not include the current commit or mutable dependency state in the repository scope key — those belong in `dependency_digests` / preimage checks so a valid chunk can survive ordinary repository evolution while still refusing stale applicability. Strip/refuse credentials, auth-bearing URL components and unnecessary absolute local paths before derivation. If no stable non-secret repository scope can be established, do not promote or reuse a persistent VERIFIED chunk for that task; remain unprepared/deliberative rather than inventing a global scope.

`matcher_version` is mandatory. A chunk created under an unknown/newer applicability matcher must fail closed until explicitly migrated/reverified; matcher semantics changing must not silently reinterpret old VERIFIED knowledge.

`operator_templates` must contain canonical operator/capability identities and structural argument bindings, not live Python callables, raw secrets, approval tokens, or arbitrary captured runtime payloads. For a multi-step template, each ordered step must declare its own stable operator identity, required input/binding schema, hard preconditions, expected postcondition/effect, and (for mutating steps) the existing rollback/recovery reference required by the canonical executor. Do not represent a multi-step prepared resolution as one opaque instruction string.

## 6.7 ContextBinding

Do not model context ownership as a one-to-one mutable map from artifact id to goal. The same immutable evidence artifact may legitimately be visible through a child binding and later through an explicitly promoted parent binding. Represent visibility with small immutable bindings:

```text
schema_version
binding_id
target_kind          # working_memory | artifact | compact_state_evidence | other-supported-ref
target_ref
goal_id
owner_goal_revision
lifetime
scope_key
promoted_from_binding_id
evidence_refs
created_at
digest
```

Rules:
- `binding_id` is deterministic from `(scope_key, target_kind, target_ref, goal_id, owner_goal_revision, lifetime, promoted_from_binding_id)`;
- an immutable target may have multiple bindings with different goal ownership; promotion therefore adds a parent binding instead of mutating the child's historical binding;
- `scope_key` is mandatory for every cognitive-managed binding, not only persistent ones, and must be a non-secret canonical scope identity/digest. Visibility requires scope equality before goal-ancestry rules are considered;
- a compact-state item may be bound only through a stable canonical ref. Prefer a unique evidence/artifact ref already carried by the item. Do **not** key compact-state ownership by claim text or list position. If a child-local state item has no stable evidence ref, create the evidence ref first through the crash-consistent evidence path below, then bind it;
- legacy unbound context keeps legacy visibility, but a new cognitive-managed child-local item must never be emitted without a binding that can later be filtered.

---

## 6.8 TransitionOutcome and ResolutionRequest

The cognitive state machine must return a **small deterministic transition result** to its owner. Without this contract the implementation is likely to either hide work inside `cognitive_control` or record an impasse that no production caller knows how to continue.

Use an immutable shape equivalent to:

```text
TransitionOutcome
  transition_id
  goal_id
  parent_revision
  observation_id
  disposition            # NO_ACTION | RESOLUTION_REQUIRED | TRY_PREPARED | RESUME_PARENT | BLOCKED | STALE
  impasse_id
  resolution_request
  prepared_chunk_id
  evidence_refs
  reason_codes
```

When `disposition == RESOLUTION_REQUIRED`, include a bounded `ResolutionRequest` containing only runtime-checkable control facts:

```text
request_id              # deterministic from impasse_key + parent revision
goal_id
impasse_id
impasse_kind
resolution_target
required_evidence
current_state_key
remaining_attempts
context_refs             # canonical refs only; no hidden reasoning; still subject to owner visibility/egress filtering
```

The result is **data, not execution authority**. The owning production module decides how to satisfy the request through its already-authoritative mechanisms. `cognitive_control` must never recursively call an owner from inside the state transition that produced the request.

A state transition and its returned `TransitionOutcome` must agree on the same deterministic `transition_id`; a crash/retry must reproduce the same logical outcome rather than minting a second request.

## 6.9 PreparedAttempt handoff record

Prepared reuse crosses two durable authorities: cognitive control decides that a verified resolution is eligible, while the canonical execution owner decides/records whether an effect is issued. A crash between those decisions must not duplicate an effect. Maintain a bounded durable prepared-attempt record (inside the cognitive state store or an equivalently integrity-protected specialized store) with fields equivalent to:

```text
schema_version
attempt_id
chunk_id
core_digest
goal_id
parent_revision
impasse_key
applicability_digest    # current hard-match inputs + resolved non-secret argument/dependency/contract bindings
status                  # PREPARED | INTENT_BOUND | EFFECT_POSSIBLE | COMPLETED | REFUSED | FAILED | AMBIGUOUS | STALE
current_step_index
step_attempt_ids
canonical_intent_refs
canonical_effect_keys
receipt_refs
created_at
updated_at
digest
```

Rules:
- create/CAS the `PREPARED` attempt record **before asking an executor to bind or issue the first effect**; `PREPARED` means only that cognitive control durably chose the prepared path — it says nothing about canonical execution state;
- the canonical owner must durably bind the same `attempt_id` / `step_attempt_id` (directly or through a crash-safe sidecar/effect-key mapping) before the effect can become possible. Once that pre-effect identity/intent is durably present, record `INTENT_BOUND`; this state means the canonical owner has an identity to reconcile, **not** that any effect ran;
- move to `EFFECT_POSSIBLE` only when the canonical owner's durable state has reached the point after which the effect may have crossed its issue boundary. `EFFECT_POSSIBLE` is deliberately weaker than "effect definitely happened": a restart with no definitive receipt must reconcile and may become `COMPLETED`, `REFUSED`/`FAILED`, or `AMBIGUOUS`;
- map owner states according to their real write ordering, not their names. At the observed reference, meta `persist_intent(... state=prepared)` is `INTENT_BOUND`, while `mark_dispatched(... state=dispatched)` happens immediately **before** `issue()` and therefore maps conservatively to `EFFECT_POSSIBLE`, not to proof of completion;
- `COMPLETED`/`FAILED`/`REFUSED` come only from canonical receipts/verdicts or a canonical reconciliation result that proves the corresponding outcome; `AMBIGUOUS` means the owner cannot prove whether an effect in the `EFFECT_POSSIBLE` region landed;
- on restart, reconcile every nonterminal attempt with the canonical execution owner **before** deciding whether anything may be issued again. This reconciliation includes pre-effect durable resources the owner may acquire before intent persistence — budget reservations, locks, leases, staged workspaces, or equivalent. "No canonical intent exists" is not proof that no resource is held; use the owner's existing reservation/lease reconciliation and settle or preserve those resources according to its own evidence before continuing;
- if cognitive `PREPARED` exists and the canonical owner proves there is no bound intent/effect identity **and has reconciled any pre-intent durable reservations/locks**, the same `attempt_id` may continue from binding; do not mint a new attempt;
- if `INTENT_BOUND` exists and the owner proves its write-ahead protocol has not crossed the effect-possible boundary, the same `attempt_id` may continue to that boundary. If the owner cannot prove that property, reconcile conservatively rather than assuming safety from the label;
- if the canonical owner proves completion but cognitive completion was not recorded, ingest the existing receipt and finish the same attempt without re-execution;
- if the owner cannot distinguish issued from not-issued for a side-effecting operation after the effect-possible boundary, mark `AMBIGUOUS` and do not replay;
- a transition among these statuses is monotone except for explicit reconciliation from a nonterminal state to a terminal one. Never move `EFFECT_POSSIBLE` or `AMBIGUOUS` backward to `PREPARED`/`INTENT_BOUND` merely because a process restarted;
- bound retained terminal attempt history using the exact idempotency/tombstone rules in §13.7; never evict an identity in a way that permits an old side effect to be counted or issued again.

For an owner whose execution API cannot carry an external `attempt_id`, adapt at the owner boundary using its existing deterministic effect/dispatch identity if that mapping is durable and one-to-one. If no such binding/reconciliation exists, automatic prepared reuse is allowed only for operations proven read-only/idempotent under the canonical contract. A side-effecting/non-idempotent operator with no durable idempotency/effect identity remains `CANDIDATE`/deliberative for reuse purposes rather than being executed from prepared knowledge.

---

---

# 7. Deterministic impasse classification

Implement in `cognitive_control/impasse.py` as a pure function over `ControlObservation` plus the current goal.

Classification must be deterministic and mutually understandable. Evaluate the following in order and return the **first** condition whose full blocking predicate is satisfied. A lower-priority type must not mask a stronger cause.

## 7.1 REJECT

Classify `REJECT` when:
- one or more otherwise required/viable operations appear in `hard_rejected_option_ids` and cite a current hard authority such as security, approval, scope, rollback, policy, **budget/deadline**, or another canonical hard gate;
- the rejecting authority is itself unambiguous for this decision; if two current authorities/requirements conflict about what is permitted, classify the blocking cause as `CONFLICT` instead of hiding the authority conflict behind one rejection;
- and after those refusals no legal path remains that can advance the goal.

A rejected optional alternative is not an impasse when another legal route remains.

Resolution may:
- find another legal route;
- wait for genuinely external evidence/approval if the existing system supports it;
- satisfy a permitted prerequisite.

Resolution may **not** weaken, remove, self-grant, or route around the rejecting authority. A canonical budget/deadline exhaustion may therefore end `BLOCKED` unless an external/canonical owner supplies a genuinely new allowance; cognitive control must never create a private budget extension as its “resolution.”

## 7.2 CONFLICT

Classify `CONFLICT` when:
- two or more currently material requirements/options/authorities are mutually incompatible;
- no existing precedence rule already resolves the conflict;
- and the conflict blocks progress.

If governance already establishes precedence, apply it and do not manufacture an impasse.

## 7.3 TIE

Classify `TIE` when:
- two or more mutually exclusive options remain viable;
- they appear together in a `substantive_equivalence_group`, meaning the authoritative comparison is equal before a purely reproducibility-only identifier tiebreak;
- they are **not** together in an `interchangeable_option_group`;
- `material_choice` is explicitly true because the choice changes the task outcome or future state.

For `project_evolution`, use the live equivalent of `_comparable_key` or another existing substantive rank projection; do not call a tie merely because `candidate_id` is the final deterministic sort key.

Do not classify a tie when multiple capabilities can simply compose or run together safely.

## 7.4 NO_CHANGE

Classify `NO_CHANGE` when:
- an attempted selected operation produced no authoritative progress;
- a required operation is blocked on missing inputs/preconditions;
- no viable next operation exists for a goal whose required effect remains unmet;
- or the same decision-relevant state recurs after a bounded attempt with no new evidence.

An ordinary capability `NO_MATCH` is **not** an impasse unless a canonical owner says that a capability/effect is actually required for the goal.

## 7.5 UNKNOWN

If the adapter cannot establish the facts required for one of the four types — including materiality for `TIE` — create **no impasse**. Record an unclassified observation if useful, but do not let uncertainty become a fake blockage.

---

# 8. Resolution-subgoal lifecycle

Implement in `resolution.py` / `session.py` as a bounded state machine, not a free-running loop.

```text
parent ACTIVE
    ↓ authoritative blocked observation
open typed impasse
    ↓
create/reuse exactly one resolution child for impasse_key
    ↓
try verified prepared resolution first if applicable
    ↓ otherwise
invoke existing deterministic recovery / capability reevaluation / meta escalation
    ↓
new authoritative observation
    ├─ ADVANCED → resolve child → resume parent
    ├─ parent revision changed → ABANDON child as stale
    ├─ legal resolution budget exhausted → BLOCK child and parent
    └─ still same blocked state → continue only within remaining bound
```

State transitions are explicit:

```text
parent ACTIVE + blocking observation -> parent RESOLVING
resolution child ACTIVE
child RESOLVED + authoritative parent ADVANCED + goal_satisfied=False -> parent ACTIVE at incremented cognitive revision
canonical parent ADVANCED + goal_satisfied=True -> parent RESOLVED
child BLOCKED with no legal/budgeted path -> parent BLOCKED
parent canonical revision/objective superseded -> parent/descendants ABANDONED
```

`RESOLVING` never means the canonical task has progressed; it only means the cognitive mirror is waiting on a child resolution. Reopening a previously resolved `impasse_key` is permitted only after a new authoritative observation proves the prior resolution is no longer applicable and therefore creates a different parent revision/state key.

**Satisfying a child-local target is not by itself impasse resolution.** If an attempt obtains the requested prerequisite/discriminator but the canonical parent re-observation still reports the same blockage/no advance, record that attempt/result and keep the impasse unresolved (or supersede it only if the canonical blocking cause actually changed). Do not mark the impasse `RESOLVED`, do not compile a chunk, and do not report prepared-resolution success until the parent decision condition changes and an authoritative parent observation reports `ADVANCED`.

Required bounds:
- max goal depth;
- max resolution attempts per impasse;
- max cumulative resolution attempts/work per parent/root task revision, charged across successor impasses so a changing `state_key` cannot reset the budget indefinitely; this is a small control-loop attempt/transition ceiling, **not a second resource budget**. Model calls, tokens, commands, time, file changes and external calls remain charged only to the existing ProjectBudget/meta/governance budget owners; derive/narrow the cognitive ceiling from those owners where practical and never use it to authorize work they refuse;
- max prepared-resolution sequence length;
- max meta cycles inherited from existing meta budget/config, never a fresh private budget;
- max concurrent active child resolutions per parent: **one by default**. A new blocked observation for the same parent must update/join the current resolution child when it serves the same unresolved target, or explicitly supersede/abandon that child before opening another. Parallel sibling resolution children are allowed only if the canonical owner proves the blockers are independent and the existing executor can isolate them safely; do not make concurrency the default.

A decision-relevant `state_key` change while the same resolution target remains unresolved does **not** grant a fresh attempt budget. Record the new observation under the existing child and continue with the inherited remaining budget. If the blocking cause/target truly changes, supersede the old impasse/child and open a successor using the parent's remaining cumulative budget.

Do not create a generic `while True` runtime loop. The user's requested infinite refinement applies to this implementation mission, not to production execution.

## 8.1 Stale completion rule

Every resolution attempt carries:
- `goal_id`;
- `parent_goal_revision`;
- `impasse_key`.

Before applying a result, compare those to current state. If the parent revision moved or the impasse closed, the result is stale:
- persist/report it;
- do not promote its memory;
- do not resolve the current parent;
- do not compile a chunk from it.

This rule is mandatory for multi-agent/asynchronous correctness.

A `BLOCKED` goal is not silently retried. It may become `ACTIVE` again only after a **new authoritative observation** changes the decision-relevant state (new evidence, approved external condition, new legal operator, canonical task steering, etc.). If the state key/parent revision is unchanged, reuse the blocked impasse/tombstone and do not reset its attempt budget just because a caller retried.

---

# 9. Goal-context working memory and delivered context

The mechanism is incomplete if it edits a donor `WorkingMemory` class that the production reasoning path never reads. First trace every **live context-delivery path** used by project/meta resolution. At the reference commit these include at least the meta-reasoning compact state + artifact/context delivery surfaces, and may include `enhanced_memory.WorkingMemory`.

The invariant is about what a later sibling can **see**, not where bytes are stored. Audit history remains durable; context delivery is filtered.

## 9.1 Context ownership registry

Maintain a small set/index of the `ContextBinding` records defined above, inside cognitive run state. Do **not** use a one-to-one mutable `object/ref -> goal` map: immutable evidence may have both a historical child binding and a later parent promotion binding.

Objects may be working-memory entries, run artifacts, compact-state claims with stable evidence refs, or other context items. Do not duplicate their body; store bindings and canonical refs only. Delivery computes visibility from bindings + the active goal ancestry.

Closed lifetime vocabulary:

```text
LOCAL
PARENT_VISIBLE
PERSISTENT
```

Visibility semantics:
- `LOCAL`: visible to its owner goal and active descendants while the owner remains active; invisible to unrelated siblings and after owner close/abandon.
- `PARENT_VISIBLE`: same as `LOCAL` until successful explicit promotion; promotion creates a new parent-owned context object/reference with provenance to the child rather than mutating the child's ownership in place. For an existing immutable run artifact, this may be a new parent-owned promotion/visibility reference to the same canonical artifact rather than copying artifact bytes; for `WorkingMemory`, create a new entry copy.
- `PERSISTENT`: context-independent **within the storage/privacy scope that already owns it**, still subject to ordinary retrieval/relevance rules. Persistence does not authorize cross-repository disclosure.
- legacy unowned context: preserves existing behavior for backward compatibility; do not retroactively guess its owner.

Lifetime is runtime-owned authority, not worker/model metadata. New context created inside a resolution child defaults to `LOCAL`. A worker/model may request or suggest promotion, but it may not self-declare `PERSISTENT`, and it may not turn `PARENT_VISIBLE` into parent-visible state by writing a metadata field. Only the cognitive owner may create the promoted parent copy/reference after a successful, non-stale resolution and any required verification. A stale/abandoned child therefore cannot leak by having labeled its own output persistent before it finished.

When more than one binding exists for the same immutable target, visibility is the union of bindings that are valid in the current scope/goal ancestry.

On successful child resolution + parent `ADVANCED`, the parent revision increment and any promoted `ContextBinding` creation must be one cognitive-state CAS transition. The promoted binding targets the **new parent revision**, not the revision that was just superseded. Never create a parent binding at revision N and then advance the parent to N+1 in a second write, because the new binding would become stale immediately and a crash between the writes would make visibility depend on timing. A `LOCAL`/unpromoted `PARENT_VISIBLE` binding is also bound to `owner_goal_revision`: once that owner advances to a new decision-relevant revision, the old-revision binding is no longer automatically visible. If specific context remains valid after the revision, carry it forward explicitly by creating a new binding with provenance; do not let a revision bump silently drag all old scratch hypotheses forward. `PERSISTENT` bindings follow their existing scope policy rather than goal-revision visibility. Historical child bindings are never rewritten. A parent promotion adds a new binding with `promoted_from_binding_id`, which makes provenance and rollback/audit unambiguous.

New resolution-child context defaults to `LOCAL`. A child/LLM/worker may not self-label arbitrary reasoning as `PERSISTENT` to escape pruning. `PERSISTENT` is accepted only for context that was already persistent under an existing canonical owner or was explicitly promoted/persisted through a governed policy after its evidence qualified. `PARENT_VISIBLE` likewise does not become parent-visible until the explicit promotion transition succeeds.

Goal visibility is **not an authorization filter**. Security policy, governance directives, approvals/refusals, hard constraints, budget/deadline state, and other authority facts must remain visible/enforced regardless of goal ownership. The projector may narrow task-working context; it must never hide an authority fact in a way that makes a child less constrained than its parent/canonical run.

## 9.2 `enhanced_memory.WorkingMemory` integration

If tracing proves `tools/doubletake_evolve/enhanced_memory/working_memory.py` is on a live target path, modify it minimally. If it is not live, do not claim completion by changing it alone; apply the same contract at the actual memory seam and keep any donor edit only if it is still useful.

Preserve the current `MemoryEntry` serialized shape. It already has `metadata`; use one namespaced versioned object, for example:

```python
metadata["doubletake_cognitive_context"] = {
    "schema_version": 1,
    "context_item_id": "ctx_...",
    "goal_id": "...",
    "owner_goal_revision": 3,
    "lifetime": "LOCAL",
    "scope_key": "...",
    "promoted_from_goal_id": "",
    "evidence_refs": [...],
}
```

Add an optional `visibility_context=None` (or equivalent) to recall. With no visibility context, existing behavior must remain equivalent. With one, visibility filtering occurs **before** BM25/relevance/recency/fatigue/quota ranking. Context is an eligibility gate, not another score.

`context_item_id` is allocated once when the cognitive metadata is created and never derived from mutable fields such as access-refreshed timestamps. The ownership registry must key working-memory items by this stable id, not Python object identity.

If live callers use `enhanced_memory.agent_loop.read_memories`, `write_memory`, or `memory_integrated_generate`, thread the optional visibility/ownership context through those live calls without changing legacy defaults. A context feature that the final prompt/context builder never receives is inert.

## 9.3 Prevent scope leakage through consolidation

Audit every working-memory -> long-term-memory bridge, including `LongTermMemory.consolidate_from_working(...)` and any caller of `WorkingMemory.consolidate()`.

Unpromoted `LOCAL` and `PARENT_VISIBLE` items must **not** become durable/global merely because capacity eviction/consolidation ran. Only:
- `PERSISTENT`; or
- an explicitly promoted parent-owned copy

may cross into durable long-term memory.

If the long-term store is shared across more than one repository/scope, preserve `scope_key` during consolidation and ensure identity/search cannot merge the same content from two scopes into one record. At the reference commit `consolidate_from_working()` keys by content hash; if that path is live and shared, a cognitive-managed entry needs a scope-aware key or equivalent partition. Do not change legacy keys for legacy unowned entries.

If the long-term store is already physically repository-local, prove that fact and avoid adding redundant filtering.

A context-local item may be evicted from working memory, but eviction is not promotion. Add a regression test that would fail if eviction leaks a child-local memory into long-term recall.

## 9.4 Meta-reasoning compact state and artifact context

At the reference commit, `MetaSession` reasons over `CompactState`, run artifacts and bounded artifact/context indexes. Those are working context in the functional sense and must obey goal visibility when an impasse resolution child is active.

Do **not** blindly add a second copy of every claim to cognitive state. Instead:
1. preserve canonical artifacts/state where they already live;
2. register their goal ownership/lifetime by canonical ref;
3. before `Assess`/proposal generation or any equivalent model context build, project a **goal-visible view** of compact state/artifact indexes;
4. exclude child-local items owned by closed/unrelated goals;
5. include parent ancestry, promoted evidence and persistent evidence;
6. keep excluded items in durable audit stores — only delivery changes.

If the current `DeliveredContextManifest` or equivalent context-manifest mechanism can enforce this, extend/reuse it instead of inventing a second manifest.

Prefer a generic optional visibility/scope port threaded through the existing production seam (`drive_governed_meta_cycle` -> `MetaControlBoundary.build_session` -> `MetaSession`/`Dispatcher`) rather than importing `cognitive_control` from meta-reasoning. `None` must preserve current behavior. `MetaSession` should apply the projection immediately before building Assess/propose context, after canonical state/artifacts are loaded and before they are delivered to inference.

**Defence in depth is mandatory at dispatch.** Filtering Assess/propose input is not sufficient because a proposal could carry a guessed/stale artifact id. Immediately before `Dispatcher.prepare(...)` builds the delivered-context manifest, the generic visibility port must re-check every requested artifact dependency. A hidden/closed-sibling artifact id must be refused and must never enter `DeliveredContextManifest`, `context_artifact_ids`, or the worker payload even if the model somehow names it.

Artifacts produced during a resolution cycle must be bound to the active cognitive owner **before the effect is issued / at durable dispatch intent time**, not registered only after commit. Use an opaque generic context-owner/scope token or a crash-safe sidecar binding owned by the production seam; the binding must include/commit to the canonical task revision and cognitive owner revision needed for stale checks. Meta-reasoning must not import cognitive types. `Dispatcher.commit_result(...)` (or the live equivalent) must derive the artifact's context ownership and submission-eligibility ceiling from that runtime-owned binding, never from the worker result. This closes the race in which a child artifact could become STOP-eligible between artifact commit and a later post-hoc registration step.

The same generic scope policy must be enforced by STOP/final-selection. A parent finalizer may only consider artifacts visible/eligible to the parent scope. A guessed artifact id, a stale `best_submission_candidate_artifact_id`, or a recent child-local work product must be rejected by the selector rather than slipping past the filtered planning context.

Do not infer ownership later from artifact text.

The context-pruning benchmark must inspect the actual delivered controller context/manifest — and, where practical, the final bounded payload handed to the governed provider/test-double — not only call a helper directly.

## 9.5 Closing a context

Closing/abandoning a child:
- makes unpromoted child-local context ineligible for future sibling reasoning;
- does not delete audit evidence;
- promotes only explicitly selected evidence after successful, non-stale resolution;
- never promotes from stale/abandoned child work;
- increments/revises the parent only when the canonical owner reports the resolving state change.

## 9.6 Child-local artifacts may not become final output accidentally

Goal visibility must also protect final artifact selection. A child-local control/work artifact must not become the parent run's submission merely because it has a normally submission-eligible role.

During resolution:
- prefer non-submission roles (`CONTROL_NOTE`, `SYSTEM_EVIDENCE`, or live equivalents) for pure resolution/control artifacts;
- bind the active child scope in the durable dispatch/effect intent before execution so eligibility is capped atomically with the work's authority; post-hoc tagging is not sufficient;
- if a child produces an object-level work product, keep it non-submission-eligible until the parent explicitly accepts/promotes it through the existing artifact/governance path;
- an abandoned/stale child's artifact must never be selectable by STOP/final-delivery logic;
- a mere parent `ContextBinding` is sufficient for *visibility* but is **not** sufficient for final submission eligibility. If the child artifact was committed with `submission_eligible=False`, parent promotion must create a new parent-scoped work-product/eligibility record through the existing runtime-owned artifact/governance path (or an equivalent runtime-owned promotion record explicitly understood by STOP). Never flip the historical child artifact's producer-owned fields in place;
- promotion should therefore create explicit parent-scoped eligibility/provenance, not mutate history invisibly.

Add an end-to-end test where an abandoned child produced a polished work artifact and prove the existing stop selector cannot return it; add a second case showing that a valid parent promotion becomes selectable only through the new parent-scoped record, not merely because a visibility binding exists.

# 10. Persistence and concurrency

Do not add another general evidence system.

## 10.1 Run evidence

Use the existing run-scoped artifact/evidence surface when available, especially the live equivalent of `meta_reasoning.artifacts.RunArtifactStore`, for durable cognitive events/control notes and evidence references. Inject that capability through the owner boundary / a tiny evidence-sink port; do not make `cognitive_control` import the whole `meta_reasoning` package.

Every production path on which cognitive control is claimed to be enabled must supply a durable `EvidenceSink`: adapt `RunArtifactStore`, the workflow `ArtifactWriter`, `governed_write`, or the live path's existing canonical evidence owner. Do not leave direct `evolve_project()` paths with a `cognitive_session` that can transition state but has nowhere durable to publish/reconcile evidence. If a path genuinely has no canonical durable evidence owner, return `COGNITIVE_UNAVAILABLE` for that path until one is wired; do not silently use an in-memory sink and still claim restart/audit guarantees.

Persist enough structured evidence to reconstruct:
- goal opened/closed/revised;
- impasse opened/resolved/blocked;
- resolution child created/abandoned;
- prepared chunk considered/refused/reused;
- stale result rejected.

Do not persist hidden model reasoning.

## 10.2 Small cognitive state index

Implement a small specialized `CognitiveStateStore` under the canonical state root, e.g.:

```text
<state_root>/cognitive_control/<run_digest>/<session_id>/state.json
```

It may contain only current/reconstructable control state such as:
- active/current goal frames;
- active root id + canonical object id + task revision/objective digest;
- state revision / CAS digest;
- open impasse keys and their resolution-child ids;
- goal revisions;
- context-ownership metadata keyed by stable canonical refs/context item ids;
- references to canonical evidence artifacts.

Keep it bounded. When goals/impasses close, write their final durable evidence to the canonical artifact/evidence surface and remove bulky closed state/context ownership from the active index, retaining only the minimum tombstone/idempotency information required to reject duplicate/stale completion. Do not grow one run-state JSON forever.

All path components derived from run/task identities must be validated or digest-derived so a task id/repository string cannot traverse the state root.

Requirements:
- schema version;
- canonical digest;
- atomic durable replacement;
- compare-and-swap / expected-digest semantics;
- cross-thread and cross-process serialization following an existing DoubleTake store pattern;
- do not blindly copy a POSIX-only `fcntl` implementation into a new generally imported package. Use the repository's live cross-platform locking primitive if one exists; otherwise isolate platform-specific locking behind a tiny adapter and test the platforms DoubleTake claims to support. If current DoubleTake is intentionally POSIX-only, make that precondition explicit instead of failing at import time on unsupported platforms;
- fail closed if locking/serialization guarantees cannot be provided;
- no model output blobs or duplicate evidence bodies.

Model the concurrency discipline on the existing `meta_reasoning.state.CompactStateStore` / `meta_reasoning.artifacts.RunArtifactStore` implementation patterns rather than inventing weaker persistence. Reuse common helpers if doing so does not create a dependency cycle.

### 10.2.1 Crash consistency between cognitive state and canonical evidence

The cognitive state file and the canonical run-artifact/evidence store are separate durable owners. **Do not pretend they can be atomically committed together.** Use a recoverable outbox/reconciliation protocol:

1. derive a deterministic logical `transition_id` from stable transition identity — `session_id`, transition kind, canonical `observation_id`/source-event id, target goal/impasse key and expected parent revision. **Do not include the prior state digest in the logical id**; the prior digest is the CAS precondition, and including it would make a retry after an unrelated concurrent commit look like a different logical transition;
2. under the cognitive store lock/CAS, apply the control-state transition and append a small `pending_evidence` outbox entry in the **same state commit**, containing `transition_id`, event kind, compact payload/payload digest, input refs and task revision;
3. after that state commit succeeds, publish the audit/control event through `EvidenceSink.record_control(..., event_id=transition_id, ...)`;
4. publication must be idempotent: the adapter publishes the **exact payload/digest stored in the outbox** (do not regenerate timestamps or re-render the event on retry), and either returns the already-existing identical event or creates exactly one event, then verifies its payload digest;
5. CAS the cognitive state again to replace the pending outbox item with the canonical evidence ref / published marker;
6. on session construction/restart, reconcile every pending outbox entry before pruning it and before any later operation that requires the canonical audit ref.

The digest-bound `CognitiveStateStore` is authoritative for **current cognitive control state**; the run-artifact/event is its canonical audit mirror/reference. A crash may therefore leave `control state committed + audit publication pending`, which is recoverable and must be reported as pending, never falsely as published. Replay must not duplicate the logical transition.

Keep the outbox bounded and small, but **never drop an unpublished outbox entry to enforce the bound**. Once the configured pending-outbox ceiling is reached, refuse additional cognitive state transitions until reconciliation makes space. Once canonical publication is confirmed and closed-state tombstones no longer need the payload, retain only the evidence ref/transition id required for idempotency.

### 10.2.2 Cognitive-store/evidence failure behavior

A failure in the new cognitive substrate must fail **the cognitive transition**, not widen authority and not masquerade as success:

- if state locking/CAS is unavailable, do not perform the cognitive transition: do not open a child, resolve an impasse, promote context, or change chunk state;
- if the cognitive state commit succeeds but the canonical audit mirror cannot be published, keep the transition real in the digest-bound cognitive state, retain its outbox entry, report `EVIDENCE_PENDING`, and retry idempotent publication later. Do not falsely attach an evidence ref that does not exist;
- if the pending-evidence ceiling is reached, refuse further cognitive transitions until reconciliation succeeds; never discard pending evidence to regain liveness;
- chunk `VERIFIED` promotion and any claim that explicitly requires canonical verification/receipt refs must wait for those refs to exist and verify; a pending cognitive audit mirror cannot substitute for execution/verification evidence;
- return/record a bounded `COGNITIVE_UNAVAILABLE` / `COGNITIVE_FAULTED` adapter outcome when the cognitive state itself cannot be safely read/committed;
- the canonical owner may continue only along an action path it was already independently authorized and able to execute without relying on the failed cognitive feature. The cognitive layer must not claim its invariant held for that run;
- if a materially tied/blocked decision specifically requires cognitive resolution to avoid an arbitrary or unsafe choice, leave it blocked rather than silently falling through to the behavior the new gate exists to prevent;
- on recovery, reconcile pending audit publication before pruning events, verifying chunks, or completing any transition whose contract explicitly requires the canonical audit ref.

This preserves existing availability where the old canonical path is already safe while refusing every new authority or claim that depends on unavailable cognitive state.

At the reference commit, `RunArtifactStore.put(...)` allocates a commit sequence before it rejects an already-existing caller-supplied artifact id. Therefore an idempotent `EvidenceSink` must **not** implement retry as “call `put` and catch duplicate.” Map `transition_id` deterministically to a valid store-native artifact id (for example through the live equivalent of `new_artifact_id("cognitive-control:" + transition_id)`; do not pass an arbitrary transition string where the store expects `art_<hex>`), then use a **cross-process lock on that deterministic event/artifact identity** (or add an equivalent store-native idempotent put) around `exists/get -> verify exact payload digest -> put if absent`. Two concurrent publishers must converge on the same existing artifact and must not allocate duplicate sequences or create a watermark hole. Add a regression test against the real store behavior.

## 10.3 Concurrent duplicate suppression

Two agents observing the same `impasse_key` concurrently must not create two active resolution children.

The open-impasse + child creation transition must be atomic under the cognitive state store's CAS/lock. One writer wins; the other reloads and attaches to the existing open impasse.

Add a real concurrency test for this.

---

# 11. Existing meta-reasoning is the deliberation engine

When a resolution cannot be satisfied by an already available deterministic path or verified chunk, use existing meta-control instead of adding another reasoning loop.

For a real project task:

1. record the impasse and resolution request as canonical run evidence/control state;
2. project measured facts into existing activation/escalation measurements;
3. if a DIRECT attempt already occurred, use `measure_direct_history(...)` and `MetaControlBoundary.escalate(...)` rather than pretending the run is new;
4. drive work through `drive_governed_meta_cycle(...)` with the same run context, governance refs, provider/router, budget and deadline;
5. let the canonical worker/executor perform effects;
6. feed resulting canonical evidence back as a new `ControlObservation`;
7. close the impasse only if the authoritative owner now reports `ADVANCED`.

Useful measured mappings, subject to live APIs:

```text
TIE       -> competing_candidates / unresolved_items
NO_CHANGE -> stall_events and/or failure_events; recovery when entered
REJECT    -> failure_events / recovery_events plus hard-gate evidence
CONFLICT  -> competing_candidates / unresolved_items plus conflict evidence
```

Do not synthesize threshold-clearing counts merely to force META. Measurements must come from the actual run.

If meta prerequisites are unavailable, do not silently open a private LLM path. Continue deterministic recovery if available or leave the goal explicitly blocked.

**Activation identity must be current.** A `MetaControlBoundary` decision made at prompt intake is not automatically valid after the workflow later binds a canonical run id, task id, governance refs, or task revision. When a resolution request needs meta work, the production owner must use an activation/escalation decision bound to the **actual current run id + current task revision** and current measured signals. Recompute with the live `MetaControlBoundary.decide(...)` / `escalate(...)` seam as needed; never force META by editing reason codes or counts. Do not rely on a stale intake `meta_control` record merely because it says `is_meta=True`, and do not let a stale `DIRECT` record cause the outer production seam to return before the current blocked state is considered. This rule is especially important for direct entrypoints that construct `ProjectTask` before their canonical `run_id` exists and for mid-run steering that changes `task_revision`.

## 11.1 Production continuation ownership

Opening an impasse is not useful unless a real production owner can continue it. The continuation rule is:

```text
canonical owner emits ControlObservation
        -> cognitive_session.observe(...)
        -> TransitionOutcome
            NO_ACTION / STALE / BLOCKED
                -> owner records/returns normally
            TRY_PREPARED
                -> owner invokes PreparedResolutionExecutor through canonical gates
                -> owner measures result
                -> new ControlObservation
            RESOLUTION_REQUIRED
                -> owner first uses its normal deterministic recovery / capability alternatives
                -> if still blocked and a governed meta context exists, owner drives existing meta-control
                -> owner measures resulting canonical evidence
                -> new ControlObservation
            RESUME_PARENT
                -> owner continues/re-enters its normal bounded lifecycle
```

**Do not place a hidden recursive loop inside `cognitive_control`.** The package records state and requests; the production owner sequences work. A bounded owner-side continuation may re-enter the existing lifecycle, but every iteration must consume a new authoritative observation and charge the existing budgets.

For generic `evolve_project(...)`, do not import meta-reasoning merely to satisfy this requirement. `evolve_project` may detect/hold/record an impasse and return the cognitive transition/evidence to its caller. Only a higher production owner that actually holds the governed run context, provider/router, budgets and evidence owner may drive `drive_governed_meta_cycle(...)`. If no such owner is available on a path, use the existing local/capability recovery that path legitimately owns or leave the goal `BLOCKED`; do not fabricate automatic meta resolution.

A meta cycle that merely produces an artifact after the parent owner's verdict is already final **does not count as resolving the impasse**. Resolution is complete only when that artifact/evidence is fed back through the canonical parent owner and a later authoritative `ControlObservation` reports `ADVANCED` (or `goal_satisfied=True`). Add production wiring so resolution evidence has a bounded path back into the parent lifecycle; do not claim success from the meta artifact alone.

The workflow adapter that owns this continuation should be thin: no candidate ranking, no model planning, no mutation authority. It only translates `TransitionOutcome` into calls to existing owners and feeds their measured outcomes back.

## 11.2 Canonical pause/cancel gate

Before every **new** meta dispatch, capability effect, project-evolution effect, or prepared-resolution step, preserve the canonical run-control gate already used by the live runtime. On the current observed `main`, the meta production seam exposes `MetaControlBoundary.control_state(run_id)` and re-probes it per dispatch; use the live equivalent rather than caching a once-read boolean.

Rules:
- `paused` is **not** `NO_CHANGE` and does not open a resolution subgoal. Preserve the current goal/impasse state, consume no cognitive resolution attempt merely for being paused, issue no new effect, and resume the same state when the canonical owner resumes the run.
- `cancelled` is **not** an impasse. Issue no new effect. After canonical cancellation is observed, abandon/terminalize active cognitive children/root as appropriate using cancellation evidence; never compile a resolution chunk from work cut off by cancellation.
- an effect already issued when pause/cancel arrives is reconciled by the existing canonical execution/effect-journal semantics. Cognitive control must not claim it was cancelled, replay it, or discard its receipt by assumption.
- unmanaged runs for which no canonical pause/cancel channel exists keep the current runtime's documented behavior; cognitive control must not fabricate cancellation from absence of a manager.
- the cognitive package receives only an opaque owner-provided control verdict/port. It must not import `RunManager` directly and become a second control owner.

## 11.3 Peer-moved-first concurrency is re-observation, not an impasse

Current `main` distinguishes meta concurrency refusals such as compact-state CAS conflicts and stale allowance decisions from ordinary work failures. Preserve that distinction.

When an owner reports a **peer-moved-first / stale-decision** refusal before the intended effect was issued:
- do not classify the refusal itself as `NO_CHANGE`, `REJECT`, or chunk failure;
- do not consume a cognitive resolution attempt merely because another writer won the race;
- do not increment a `ResolutionChunk.failure_count` for work that was never issued;
- record/reuse the canonical concurrency-conflict evidence the owner already emits;
- reload/reconcile the canonical shared state, budget/allowance, cognitive CAS state and task revision as applicable;
- build a **fresh `ControlObservation`** from that reloaded truth; only that fresh observation may say whether the goal is still blocked and whether an impasse now exists.

If an effect may already have been issued, this is no longer a simple stale-decision rebase; use canonical effect reconciliation/quarantine (§13.7/Benchmark L) before any retry.

A peer-moved-first rebase need not consume the cognitive *resolution-attempt* count because no resolution operator ran, but it is not an unbounded free retry: the surrounding canonical cycle/time/retry budgets and the mission's cumulative continuation ceiling still bound repeated contention.

Do not add a second concurrency taxonomy. Adapt the live owner's typed refusal/evidence. At the observed reference those include `StateConflictError` and `StaleDecisionError`; follow the live equivalents if `main` moves.

---

---

# 12. Production wiring

## 12.1 Project evolution — first full resolution integration target

Modify `tools/doubletake_evolve/project_evolution/evolution.py` and the smallest adjacent boundary/model surfaces needed.

At the start of a bounded evolution run:
- obtain/reuse the task's `cognitive_session` through the boundary helper with a durable evidence adapter/root; direct `ProjectTask` construction must converge on the same helper rather than bypassing cognitive persistence;
- create/reuse one root goal for `task_id` + current task revision/objective digest;
- do not create a new root on every internal function call.

At prompt intake, capability participation currently runs before the `ProjectTask` exists. Do not reorder that hot path solely for this mission. After a project task + cognitive root are constructed, the boundary may attach the already-produced participation record as canonical evidence/observation **only when it is relevant to the project task and actually blocks a required effect**. Ordinary successful/no-match intake remains non-impasse.

Inside `evolve_project()`, the existing local `reevaluate_capabilities(...)` function is a precise production hook: after each real participation record is produced, adapt that record into cognitive evidence before continuing. Do not create a second trigger vocabulary.

The generic evolution core may surface the resulting `TransitionOutcome` in `EvolutionResult` (or a small adjacent evidence field) without gaining execution authority. If a material impasse remains open, the returned result must make that hold explicit so a production caller can drive the bounded continuation described in §11.1. Do not bury an unresolved cognitive hold only in free-form `notes`, and do not let a caller see an actionable selected candidate while the hold forbids promotion.

Use **existing measured lifecycle facts** rather than new heuristics:
- candidate set populated;
- plan changed;
- verification begins;
- candidate execution/evaluation failed;
- new evidence arrived;
- recovery begins;
- selection succeeded or all candidates were refused.

Adapters produce `ControlObservation` records from those canonical facts.

Required behavior:
- all legal candidates hard-rejected and no legal alternative → `REJECT`;
- failed attempt/recovery with unchanged relevant state and no already-available legal next step in the existing owner → `NO_CHANGE`; a failed candidate/capability is merely evidence, not an impasse, while the owner can already proceed to another viable alternative within its normal bounded flow;
- genuine mutually exclusive substantive equality with missing discriminator → `TIE`;
- incompatible requirements/options with no existing precedence → `CONFLICT`;
- selected candidate passes and the canonical stage proves the parent can proceed → `ADVANCED`, no impasse. Selection alone must not be mislabeled as final task completion; set `goal_satisfied=True` only when the canonical owner proves the task's declared desired effect/acceptance condition is satisfied.

For project evolution, a material `TIE` is detectable without an LLM when the top promotable candidates are equal on the canonical substantive comparison (the live equivalent of `_comparable_key`), are distinct mutation candidates, only one can be promoted, and **no existing legitimate tiebreak has already supplied a preference**. Existing measured rules and an already-authorized learned tiebreak may resolve equality; a TIE is for the residual case where the only remaining choice would be a reproducibility-only id/order fallback. Treat distinct candidate/change fingerprints as material unless the canonical owner explicitly proves them interchangeable.

The candidate-id reproducibility tiebreak may still produce a stable ordering for evidence, but **withhold downstream promotion/application of that reproducibility-only winner while the material TIE is open**. This is a hold, not a new ranking authority: hard gates and `select_candidate()` still decide eligibility and measured order; cognitive control refuses to mislabel an identifier tiebreak as substantive evidence.

Place the hold after canonical measurement/allowed learned-tiebreak processing but **before** a winner is exposed to governed apply and before retention/archive code records it as the incumbent. Preserve the canonical ranking/exclusion evidence, but expose no actionable selected candidate until the TIE is resolved. A cognitive check that runs only after `EvolutionResult.selected` has escaped or after incumbent retention is too late and does not satisfy this mission.

A TIE resolution must produce evidence that the existing evaluator can actually consume (for example a newly measured declared objective/acceptance discriminator followed by normal re-evaluation). If the resolution only produces prose that `select_candidate()` cannot consume, it has not resolved the tie; keep the parent blocked or await canonical task steering/human authority rather than inventing a score.

Do not alter the authority of `CandidateEvaluation.passes_hard_gates()` or `select_candidate()`.

A learned chunk or transferable lesson may never make a hard-gate failure promotable.

## 12.2 Capability participation

Do not insert a second router into `capability_participation.py`.

Instead, expose enough participation evidence for the project/cognitive adapter to classify:

- `MISSING_INPUT` for a materially required capability can support `NO_CHANGE`;
- a selected capability that ran but truthfully did not contribute can support `NO_CHANGE` if the parent is blocked;
- `conflict_refused` can support `CONFLICT` when it blocks the parent;
- ordinary `NO_RELEVANT_CAPABILITY` / `NO_MATCH` remains a correct non-impasse when no capability effect is required.

Preserve existing distrust, repeat suppression, output-chain recursion, max rounds and canonical governed execution. Treat the returned `ParticipationRecord` / live `RouteResult`-derived evidence as authoritative for cognitive adaptation; do not bypass the router's current shadow/rollout neutrality by consulting raw semantic-index/provider scores separately. Let the existing `ParticipationSession` consume its own bounded alternative/retry logic; do not run a duplicate cognitive retry in parallel. Adapt a final/intermediate record into an impasse only when the canonical task is genuinely blocked after accounting for legal alternatives already available to that session/owner.

If a minimal hook is needed, make it optional and passive: emit/return evidence to the cognitive session; do not let participation own the goal lifecycle.

## 12.3 Prompt boundary

Update `project_evolution/boundary.py` only enough to expose the lazy `cognitive_session_for(...)` bridge and, where the project path already has a canonical durable evidence owner, attach/bind it after the `ProjectTask` exists. If the intake layer does not yet know the correct sink, leave the handle `None` and let the first governed project stage construct it deterministically; do not create a half-bound session.

Do not tax ordinary chat with goal-state persistence.

For direct mutation entrypoints that bypass `submit_user_prompt`, inspect their `ProjectTask` identity timing. Do not create the cognitive session during task construction if the canonical run/state root is not known yet. Attach it at the first governed stage that holds the bound task + canonical state/evidence owner.

## 12.4 Meta reasoning

Modify meta-reasoning only where required to carry or expose impasse evidence through its **existing** artifact/compact-state inputs and reports.

For mid-run steering, cognitive supersession must happen only **after** the canonical steering transition is accepted and durably committed by the live equivalent of `MetaSession.revise_task(...)`. Wire an optional lifecycle callback/observer at the production owner boundary (or have the caller invoke the cognitive session immediately after the accepted `SteeringOutcome`); do not make cognitive state move first. A rejected/failed steering attempt must leave the cognitive root unchanged. A successful steering transition must supersede the old cognitive root before any subsequent dispatch can be accepted under the new revision. Because meta state and cognitive state are separate durable stores, enforce this with a **revision fence** rather than assuming two commits are atomic: when cognitive control is active, the generic scope/visibility port exposes the canonical task revision it has adopted, and `Dispatcher.prepare(...)` (or the live pre-effect seam) refuses context-sensitive dispatch if that revision disagrees with the live `MetaTaskView`/decision revision. On restart, reconcile/supersede the cognitive root first, then clear the fence. If cognitive supersession fails after canonical steering succeeded, the new objective remains canonical but cognitive-scoped dispatch is blocked until the mismatch is repaired; never dispatch under a new task revision while still assigning old-goal ownership.

Thread optional generic callables/ports from the governed production seam rather than importing cognitive-control types into meta internals. At minimum the live path needs equivalents of:

```text
project_controller_context(state, artifacts, artifact_index) -> filtered/projected views
artifact_visible_for_dispatch(artifact_id, *, task_revision) -> bool
current_result_scope(*, task_revision) -> opaque owner/scope binding + submission ceiling
artifact_eligible_for_stop(artifact_record, *, task_revision) -> bool
```

Names may differ, but `None` must preserve current behavior. Apply the first before Assess/propose, the second again inside `Dispatcher.prepare(...)` before manifest creation, bind the third durably before issue/commit, and apply the fourth inside STOP/final selection. Register/confirm committed artifacts back to the active cognitive child by canonical artifact ids/receipts only after the runtime-owned binding has already capped their scope.

Ensure STOP/final-selection sees only parent-eligible/promoted artifacts; child-local work must not become a deliverable by accident.

Do not fork `MetaSession` or duplicate its stages.

When meta work is invoked to satisfy a `ResolutionRequest`, persist the request/impasse identity in runtime-owned dispatch/control provenance so the resulting canonical artifact/receipt can be attributed back to that request without text matching. The parent continuation must then explicitly consume that evidence through its normal input/evaluation surface; a controller artifact that is never delivered back to the parent is not a resolution.

Preserve the live run-control gate. On current observed `main`, `drive_governed_meta_cycle(...)` reads canonical cancellation/pause state and supplies a per-dispatch control probe. Any cognitive context/filter/dispatch hook added here must execute **inside that existing guarded path**, never around it. A prepared-resolution adapter using meta dispatch inherits the same probe; it must not create a second, unguarded `Dispatcher`.

## 12.5 Evolve-agent / BorgCollectiveOrchestrator workflow owner

Audit `workflows/_workflow_mixins/core.py` and `collective_core/borg_collective_orchestrator.py` as a separate production path from `evolve_project()`. At the observed reference the workflow constructs/binds `self.project_task`, later generates the canonical `run_id`, builds `GovernedRunContext`, runs `BorgCollectiveOrchestrator`, and only **after that** drives a meta cycle.

Required integration discipline:
- once the workflow has the canonical `run_id`/state root, bind/refine the live `ProjectTask` identity before constructing durable cognitive state; preserve its live `capability_session` and other non-evidence handles;
- use the workflow's canonical run/evidence owner for the cognitive session, not a guessed meta default root;
- do not classify failures the Borg orchestrator is still legally handling through its own retry/redistribute/degrade ladder; adapt only an authoritative blocked/no-progress state after that owner says it cannot continue, or another explicit progress fact exposed by the owner;
- do not treat the existing post-orchestrator `drive_governed_meta_cycle(...)` call as parent resolution merely because it produced an artifact. A later canonical parent observation must still report `ADVANCED`;
- if the live workflow exposes a **documented crash-safe continuation/resume seam** that can consume resolution evidence without replaying completed effects, use it and test it. If it does not, do not call `BorgCollectiveOrchestrator.run(...)` again as an ad-hoc retry. Leave the parent `BLOCKED` and surface the resolution evidence/request to the next legitimate owner/operator boundary;
- if a safe continuation seam is added as part of this mission, it must reuse the orchestrator's existing checkpoint/dispatch journal and effect settlement identities. It may resume only unresolved work and must prove completed checkpoints/effects are not replayed. Do not create a second scheduler or checkpoint state machine.

This path must at least be **identity-correct and impasse-observable** even when it cannot yet auto-resume safely. Do not claim autonomous closure for evolve-agent unless the benchmark traverses a real safe continuation and later parent `ADVANCED` observation.

## 12.6 Separate Borg system-management operating loop

Do not wire cognitive control into every tick of `collective_integration/operating_loop`.

Only integrate if tracing proves a live path has:
- an explicit active campaign/goal id;
- an authoritative expected effect/progress signal;
- a meaningful blocked state.

If those conditions are absent, leave that operating loop unchanged. This is an explicit anti-scope-creep rule, not a missing feature.

---

# 13. Verified resolution compilation

Implement in `chunks.py` with a dedicated structured store only if no existing structured procedural store can satisfy the requirements.

## 13.1 Eligibility

Create a `CANDIDATE` chunk only when all are true:
- a real typed impasse was open;
- one resolution child resolved it;
- the parent subsequently advanced according to its authoritative owner;
- the successful path has explicit evidence/operator/receipt lineage;
- abandoned/dead-end branches are distinguishable;
- the resolution is potentially reusable rather than purely one-off external approval or one-time human choice.

Do not compile:
- ordinary success without an impasse;
- hidden chain-of-thought;
- a model suggestion with no execution;
- unverifiable work;
- a stale child completion;
- a resolution whose operative step has no stable canonical operator/action identity and can only be replayed as opaque free-form model text;
- one-time approval tokens;
- credentials/secrets;
- task-specific random identifiers as the sole applicability condition.

If a model-generated resolution was ultimately executed through a stable registered action/capability with explicit receipts, compile that stable action/template — not the model's private reasoning or free-form transcript.

## 13.2 Causal backtrace

Backtrace only through explicit lineage:

```text
pre-impasse evidence/context refs
    -> governed operator/action refs
    -> canonical execution receipts / intermediate artifacts
    -> resolving evidence
    -> authoritative parent ADVANCED observation
```

If the existing runtime did not record enough lineage to identify the contributing preconditions, do not guess. Keep the resolution uncompiled and record `insufficient_causal_lineage`.

## 13.3 Problem signature and applicability

Construct `problem_signature` deterministically from stable features such as:
- impasse kind;
- source subsystem/task kind;
- canonical reason codes;
- required capability/operator identities;
- contract/schema versions;
- stable requirement names;
- repository-local scope key.

Semantic similarity may shortlist chunks, but **hard applicability predicates decide eligibility**.

A chunk never becomes eligible solely because an embedding is close.

## 13.4 Repository-local scope

Default scope:

```text
scope = "repository"
scope_key = canonical repository identity
```

No automatic cross-project/general-global reuse in this mission.

For a task with no trustworthy repository identity, do not promote persistent repository-scoped prepared knowledge. A run/task-scoped `CANDIDATE` may be retained only as non-executable verification/evidence if useful, but persistent `VERIFIED` reuse must remain disabled until a stable non-secret repository scope exists.

## 13.5 What an operator template may store

Store:
- canonical capability/operator id/name;
- required contract digest/version;
- ordered dependency relation;
- structural binding names/paths;
- required input schema names;
- expected postcondition/effect identifiers.

Dynamic arguments are bindings, not captured authority. Prefer symbolic/current-input bindings (`from_current_task`, `from_current_evidence`, `constant_non_secret`) and validate them against the current input schema at reuse time. A value copied from the source trace may be stored as a constant only when it is demonstrably invariant, non-secret, scope-safe, and part of the chunk's hard applicability conditions.

Do not store:
- live function objects;
- opaque provider state;
- secrets;
- auth headers;
- approval tokens;
- arbitrary output blobs;
- raw source patch as generally reusable knowledge.

A raw patch may be reused only as an exact-preimage optimization when every affected preimage digest matches and the existing isolated trial + hard gates revalidate it. Otherwise compile the strategy/operator sequence, not the bytes.

## 13.6 Verification gate

A `CANDIDATE` becomes `VERIFIED` only when:

1. original resolution evidence is canonical and intact;
2. replay or equivalent independent reproduction succeeds in a disposable/governed environment where possible;
3. current contracts/dependencies match recorded digests;
4. the template is safe to store/consider and its verification replay ran through the ordinary governed/trial path under whatever authorization that replay legitimately had; **do not capture or persist that authorization as reusable state**;
5. affected regression/application tests pass;
6. at least one deterministic negative-applicability fixture/mutation proves the hard matcher refuses a structurally non-matching case; an LLM statement that “this should not match” is not negative evidence;
7. no raw secret/approval/runtime-only value is serialized into the chunk.

For source mutation, prefer existing `project_evolution.trial` and evaluation gates for replay. A multi-step candidate must be verified as the same ordered step contract that would be reused, including intermediate postconditions and rollback/recovery behavior; verifying only the final happy-path output is insufficient. For external/non-idempotent effects, verification must use an existing sandbox, dry-run, simulation, read-only check, or otherwise non-destructive equivalent. If no safe independent reproduction exists, leave the chunk `CANDIDATE`; never perform a second real-world side effect merely to earn `VERIFIED`.

A `CANDIDATE` may be exercised only by the explicit verification/trial harness as the subject under test; it must not participate in ordinary runtime prepared-resolution selection.

If independent verification is impossible, leave the chunk `CANDIDATE`; do not relabel “could not verify” as verified.

## 13.7 Reuse

When an impasse opens:

```text
query VERIFIED chunks in repository scope
    -> hard-filter by impasse kind + signature + preconditions + contract/dependency digests
    -> rank only among hard-applicable chunks using current evidence first and learned support only as a tiebreak
    -> if one best applicable chunk remains, offer its operator template as prepared resolution
    -> if materially different mutually exclusive chunks remain unresolved, do not select by file/order/id; keep the impasse and deliberate
    -> execute only through the existing canonical governed path
    -> observe actual result
```

A chunk is **prepared knowledge, not authority**.

Every prepared-resolution attempt gets a deterministic `applicability_digest` from the **current hard applicability facts** actually used to bind this reuse: normalized matcher inputs, resolved non-secret/current argument bindings (or canonical digests/refs for sensitive values), relevant dependency/preimage digests, contract digests, and other hard preconditions. Then derive `attempt_id` from `(chunk_id, core_digest, matcher_version, goal_id, parent_revision, impasse_key, applicability_digest)`. **Do not use the mutable full-record `digest`, counters, timestamps, verification-history length, or other changing fields.** Parent revision should already change when decision-relevant inputs change; `applicability_digest` is the defence that prevents a missed/reordered revision update or different dynamic binding from aliasing two materially different effects under one attempt id. Before issuing an effect, the adapter checks canonical receipts/dispatch/effect journals for that attempt/effect identity where the owner supports them.

For a multi-step template, derive a deterministic `step_attempt_id` / effect identity from `(attempt_id, step_index, immutable step-template digest)`. Reconcile and receipt each step independently while retaining the parent `attempt_id` for whole-resolution accounting. This is required so a crash after step 1 cannot cause the runtime either to rerun step 1 blindly or to skip directly to step 3 without proving step 2.

Use the `PreparedAttempt` write-ahead handoff in §6.9. The cognitive `PREPARED` record, canonical execution intent/effect identity, and later receipt are separate durable facts; never compress them into one in-memory call. The effect boundary may be crossed only after the owner-side durable identity binding exists.

On an unchanged parent revision/impasse/dependency set, the same VERIFIED chunk may **issue the same logical effect at most once** unless the canonical owner proves a retry is safe. A definitive post-issue failure or definitive governance/refusal records failure/refusal for that applicability context and falls back to other legal resolution/deliberation; it does not mint a fresh id and hammer the same prepared action. A pre-effect peer-moved-first/stale-allowance refusal that proves `NO_EFFECT_ISSUED` is different: after re-observation it may retry using the **same** `attempt_id`/step identity without incrementing failure or cognitive attempt counters. A genuinely new attempt identity is permitted only after authoritative applicability state changes or an existing canonical recovery mechanism explicitly establishes a new retry-safe context.

Chunk outcome accounting is idempotent by `attempt_id`. `support_count` / `success_count` / `failure_count` must not increment twice because a completion/outbox/result was replayed after restart. Keep a bounded exact dedup set/window of processed attempt ids per active chunk. When that bound is saturated, it is acceptable to freeze **positive/history tiebreak strength** rather than evict ids and allow old successes to be counted again, but never ignore a new safety-significant failure/refusal merely to preserve the bound. A definitive new failure must either be representable in a bounded exact applicability-failure/quarantine structure or conservatively demote/refuse prepared reuse for that chunk until compaction/reverification can restore safe bounded state. Do not let support-history saturation make a VERIFIED chunk immune to contradictory fresh evidence. Historical support is only a tiebreak; safety/invalidation evidence is not.

If a process crashes or times out after dispatch and the effect outcome is ambiguous, **do not blindly replay the operator**. Reconcile through the canonical execution owner's receipt/effect-journal/recovery semantics first. If the owner cannot prove whether the effect landed, keep the resolution `UNVERIFIABLE`/blocked and require an explicit safe recovery path. Prepared knowledge never turns an at-most-once ambiguity into “try again.”

Immediately before any prepared effect is issued, re-read the authoritative chunk record, verify its current full-record `digest`/status, and confirm its immutable `core_digest` still equals the one bound into `attempt_id`. If it became `INVALID`/`RETIRED`, changed immutable core, or no longer verifies, refuse the prepared path. Then re-check:
- known/current chunk schema + `matcher_version`;
- current hard gates;
- current contract digests;
- current preconditions;
- current dependency/preimage digests;
- current parent revision;
- current governance/approval.

For an ordered multi-step chunk, execute **stepwise through the canonical owner**. Before each step, validate that step's current hard preconditions against the actual intermediate state; after each step, verify its declared postcondition/receipt before the next step becomes eligible. On refusal, ambiguity, missing postcondition, stale parent revision, or unexpected state, stop the sequence immediately and enter ordinary recovery/rollback semantics. Never continue later prepared steps on the assumption that an earlier step probably worked. If safe partial execution/rollback cannot be represented by the existing owner, do not compile that multi-step sequence as executable prepared knowledge.

A chunk verified under an approved trial does **not** carry that approval forward. A future reuse that requires approval must obtain current approval through the existing mechanism or be refused. A reusable template may at most re-enter the existing approval-request workflow; it can never encode “approval obtained” as a reusable precondition result.

## 13.8 Failure and invalidation

Refuse/invalidate when:
- capability/operator contract changed incompatibly;
- required dependency/preimage digest changed;
- hard precondition no longer holds;
- current governance rejects the action;
- replay/regression contradicts the chunk;
- postcondition fails;
- repeated runtime evidence demonstrates the resolution is no longer reliable.

One context-specific failure is evidence; do not globally delete a chunk unless the failure proves its applicability or resolution claim false.

Fresh current measurement always outranks support count/history.

---

# 14. ResolutionChunk persistence

Prefer per-chunk records, not one giant mutable JSON array:

```text
<state_root>/cognitive_control/chunks/<scope_digest>/<chunk_id>.json
```

Requirements:
- strict id/path validation;
- schema version;
- canonical digest verification on every read;
- atomic durable write;
- serialized update/CAS for counters/status changes;
- deterministic create-if-absent semantics for `chunk_id`: concurrent writers that present the same `core_digest` coalesce, while a different immutable core under the same id is a hard collision/refusal;
- monotone terminal/safety precedence for concurrent status updates. A stale writer may never resurrect `INVALID`/`RETIRED` as `VERIFIED`; reload current state and re-apply only transitions still legal from that state;
- idempotent merge of verification evidence and processed `attempt_id`s by stable identity. Never implement chunk updates as unqualified read-modify-write/last-write-wins;
- cross-process safe updates using an existing DoubleTake locking pattern;
- corruption fails closed;
- index may be derived by scanning verified records or maintained only with equivalent integrity guarantees.

Chunk lookup and retention must be bounded. Configure a maximum number of candidates inspected per signature/scope and a bounded number of active `VERIFIED`/`CANDIDATE` chunks per problem signature. Deterministic `chunk_id` dedup happens before consuming a new retention slot. Excess/obsolete entries are deterministically `RETIRED` or archived according to evidence/support/recency policy; never let ordinary impasse handling scan an unbounded repository history. Retirement affects runtime eligibility, not audit evidence.

Do not duplicate full chunk contents into `CollectiveMemory`.

If discoverability through existing memory is useful, store at most a compact pointer/summary with `kind="procedural"` and the chunk id, and only if doing so does not cross repository/privacy scope. The structured chunk store remains authoritative.

---

# 15. Preparation-versus-deliberation behavior

Do not create a separate “preparation governor” subsystem.

The behavior must emerge from the resolution path:

```text
impasse opens
    -> verified applicable prepared resolution?
        yes: try governed prepared resolution first
        no: use existing recovery/meta deliberation
```

Non-impasse tasks incur no chunk search beyond a negligible deterministic check, and no additional model call.

Measure structural work, not only wall clock:

```text
prepared_resolution_considered
prepared_resolution_hit
prepared_resolution_refused
resolution_attempts
resolution_meta_cycles
resolution_controller_model_calls
resolution_capability_rounds
operators_executed
parent_advanced
```

Wall-clock duration may be reported but may not be the sole proof of improvement.

---

# 16. Whole-system benchmark pack

Create a focused pack, reusing the existing evaluation/proof infrastructure:

```text
benchmarks/cognitive_control/
    README.md
    fixtures/
    manifests/
    expected/
    tests/
```

and a proof entry point consistent with existing `proofs/` conventions.

Every benchmark must hit at least one **production-connected path**. Direct unit calls alone are insufficient.


## Benchmark execution rule

Benchmarks must be deterministic and runnable offline. Test doubles are allowed only at true external seams such as model/provider response generation or worker side effects. They must be injected through the **real governed interfaces**. Do not replace the project boundary, meta activation/session, capability router, cognitive state machine, governance checks, or evidence persistence with mocks that bypass the production orchestration.

Fixture capabilities must be registered through the real capability authority/contract path, not inserted directly into router internals.

## A. First encounter -> resolution -> verified reuse

Run 1:
- canonical governed project task that traverses the real `evolve_project()` lifecycle (or its live authoritative replacement), not a direct cognitive-session call;
- induce a real `NO_CHANGE` caused by a missing prerequisite or failed/non-contributing required operation;
- resolve through existing capability/recovery/meta paths;
- if meta produces evidence/artifacts, feed them back through the canonical parent owner rather than treating their existence as progress;
- parent advances only on the resulting authoritative observation;
- candidate chunk created and independently verified.

Run 2:
- fresh task/run, same repository, structurally equivalent problem with changed incidental ids;
- verified chunk is selected by hard applicability;
- canonical governed execution succeeds;
- parent advances with equal-or-better correctness/evidence;
- run 2 uses strictly less structural deliberation than run 1 on at least one deterministic metric such as meta cycles, controller model calls, or resolution attempts.

Do not require noisy wall-clock speedup.

## A2. Chunk creation and outcome accounting are idempotent

Replay the same successful resolution/chunk-compilation event and the same prepared-attempt completion across restart. Prove:
- the same immutable resolution core yields one deterministic `chunk_id` and `core_digest`;
- mutating counters/status/timestamps changes the full record digest but **does not** change `chunk_id`, `core_digest`, or the same applicability's `attempt_id`;
- changing a current dynamic argument/hard-applicability binding changes `applicability_digest` and therefore cannot alias a materially different effect under the prior `attempt_id`, even if a buggy caller failed to advance an otherwise expected parent revision;
- no duplicate chunk file/active entry appears;
- two concurrent compilers that derive the same immutable chunk core converge on one record rather than consuming two retention slots; if their immutable core differs under the same `chunk_id`, the collision fails closed;
- concurrent status/counter writers use CAS/reload-and-reapply semantics: an older writer cannot overwrite a newer `INVALID`/`RETIRED` state with stale `VERIFIED`, and verification evidence/counters are merged idempotently by stable evidence/attempt identity rather than last-write-wins;
- `success_count`/`support_count` change at most once for one `attempt_id`;
- conflicting immutable content under an existing `chunk_id` fails closed.

## A3. Multi-step prepared resolution stops safely on intermediate failure

Use a VERIFIED two-or-more-step template in a disposable/governed fixture. Make step 1 succeed and step 2 fail/refuse its postcondition or governance check. Prove:
- deterministic per-step attempt/effect ids show step 1 is not blindly reissued after restart and step 3/later steps are never issued before step 2 is proven complete;
- the canonical rollback/recovery path is used when required/available;
- parent progress is not fabricated;
- the chunk records one idempotent failed/refused attempt for that applicability context and ordinary deliberation/recovery resumes.

## B. Dependency change -> stale prepared knowledge refused

After A, change one recorded relevant contract/dependency/preimage digest.

Prove:
- chunk is refused or invalidated before effect;
- refusal reason is explicit;
- system returns to ordinary governed resolution;
- correctness/governance preserved.

## C. Goal-context pruning

Create:

```text
root
  -> child A
  -> later sibling B
```

Under A create:
- LOCAL memory;
- PARENT_VISIBLE memory;
- PERSISTENT memory.

Resolve or abandon A and start B.

Prove:
- A-local memory is not eligible for B;
- explicitly promoted memory is visible through the **new parent revision** as intended, with parent revision advance + promotion committed atomically;
- persistent memory remains eligible;
- legacy entries without cognitive metadata retain old behavior;
- BM25/relevance/fatigue order is unchanged within the eligible set;
- the actual meta/controller delivered context for B contains no A-local artifact/state item;
- advancing the parent decision-relevant revision hides old-revision LOCAL scratch context unless it was explicitly carried forward/promoted;
- a proposal/fixture that explicitly names or guesses A's hidden artifact id is refused at the dispatch/context-manifest boundary, and that id/body never reaches the worker payload or lineage manifest;
- security/governance/hard-constraint/budget facts remain present/enforced even when they originated outside B's ordinary task-working context;
- eviction/consolidation of A-local memory cannot make it reappear from long-term memory.

## D. Four impasse types

One realistic fixture each for:
- `TIE`;
- `NO_CHANGE`;
- `REJECT`;
- `CONFLICT`.

For each prove:
- classification comes from canonical facts;
- exactly one child is opened for unchanged `impasse_key`;
- resolution target is explicit;
- parent resumes only after `ADVANCED` evidence;
- satisfying a child-local resolution target while the parent remains blocked does not mark the impasse resolved or create a successful chunk;
- unresolved cases end `BLOCKED`, not success.

## E. Governance cannot be bypassed by a VERIFIED chunk

Make an otherwise applicable verified chunk whose action is now denied by current governance/approval/security.

Prove:
- chunk may be considered applicable structurally;
- canonical governed execution refuses the effect;
- parent does not advance;
- `REJECT` is recorded if the refusal blocks all legal paths;
- no successful-reuse telemetry is emitted.

## F. Stale child result after parent revision

Start a resolution child, revise/replace the parent state, then let the old child finish.

Prove:
- late result is recorded;
- it cannot resolve current parent;
- its memory is not promoted;
- no chunk is compiled from it.

## F2. Steering revision fence

Start a governed meta/project run with an active cognitive child, then accept canonical task steering to a new task revision while delaying/faulting cognitive supersession. Prove:
- the canonical steering revision remains authoritative;
- the old cognitive child is not treated as current;
- no subsequent context-sensitive dispatch can issue while the cognitive scope revision disagrees with the canonical revision;
- after deterministic cognitive supersession/reconciliation, dispatch may resume under the new root only.

## G. Restart durability

Create an open impasse and/or verified chunk, reconstruct the cognitive session/store from disk, and prove:
- digests verify;
- open state reconstructs correctly;
- verified chunk remains usable only if dependencies still match;
- corrupted records fail closed.

## H. Concurrent duplicate suppression

Two real threads/processes observe the same blocking state concurrently.

Prove:
- one open `impasse_key`;
- one active resolution child;
- loser reloads/joins existing state rather than creating another;
- no lost state update.

## I. Correct NO_MATCH remains non-impasse

A task that needs no registered capability receives normal `NO_RELEVANT_CAPABILITY`.

Prove no cognitive blockage is fabricated and no meta escalation occurs solely because routing returned no match.

## J. Abandoned child cannot become final deliverable

Make child A produce a polished work-like artifact, then invalidate/abandon A before parent resolution.

Prove the ordinary STOP/final artifact selector cannot choose A's local artifact unless a later valid parent promotion explicitly made it eligible through a parent-scoped runtime-owned record. A visibility-only parent binding must not make a historically ineligible child artifact deliverable.

## K. Scope-safe durable memory

If the live long-term memory store is shared across scopes, write identical persistent content under two different `scope_key` values. Prove storage identity and retrieval do not merge/leak them. If the store is physically repository-local, prove that isolation instead and mark this case satisfied by construction.

## L. Ambiguous effect is reconciled, never replayed blindly

Use a real canonical execution seam/test double that records dispatch but simulates process interruption before a definitive result is committed. Resume the cognitive session and prove:
- the deterministic `attempt_id` is recognized;
- canonical receipt/effect reconciliation runs first;
- the effect is not issued a second time while its outcome is ambiguous;
- no impasse is marked resolved and no chunk success counter is incremented without a definitive authoritative result.

## M. Cognitive-state/evidence split-write recovery

Force a crash/fault after the cognitive state CAS commits a transition but before canonical control evidence publication completes. Reconstruct the session and prove:
- the pending outbox transition is found;
- publication happens exactly once using the same deterministic `transition_id`;
- state is reconciled to the canonical evidence ref;
- no duplicate child/impasse/event is created;
- a mismatched pre-existing event with the same id fails closed instead of being accepted;
- concurrent/idempotent publication against the real run-artifact store does not consume a second commit sequence or create a sequence hole.

## N. Pause/cancel cannot be bypassed by cognitive resolution

Use the real managed-run control surface or its production-connected test seam.

Pause case:
- open an impasse and begin a multi-step/Meta resolution;
- set canonical pause after one step/cycle but before the next effect;
- prove no subsequent effect is issued while paused;
- prove the pause itself does not create `NO_CHANGE`, consume a resolution attempt, or fabricate failure;
- resume canonically and prove the same goal/impasse may continue without a duplicate child/attempt.

Cancel case:
- open an impasse/resolution and then cancel the managed run before the next effect;
- prove no new effect is issued;
- prove already-issued ambiguous effects are reconciled through the canonical owner rather than replayed or declared cancelled by assumption;
- prove active cognitive work is terminalized/abandoned from cancellation evidence and cannot compile a reusable chunk from an incomplete resolution.

## O. Peer-moved-first conflict rebases instead of becoming false cognitive failure

Release two production-connected resolution/meta transitions concurrently against the same run so one writer changes shared compact state/allowance before the other commits. Prove:
- the canonical owner records the typed concurrency refusal/conflict;
- the losing cognitive path does not open a new `NO_CHANGE` solely from the refusal;
- it does not consume a resolution attempt or increment prepared-chunk failure counters when no effect issued;
- it reloads/reconciles and produces a fresh authoritative observation;
- any later impasse is derived from that fresh observation, not from the stale attempt;
- no duplicate external/mutating effect is issued.

---

## P. Direct ProjectTask identity binds before durable cognitive state

Exercise at least one production direct-entry path that constructs `ProjectTask` without going through ordinary prompt intake (use the live self-upgrade/evolve-agent direct fallback or equivalent on current `main`). Prove:
- no cognitive state directory/session is created while both canonical run namespace and stable task identity are unresolved;
- when the workflow obtains its canonical run/task identity, it binds or supplies that identity through the existing task-refinement/owner seam rather than deriving it from objective text;
- the cognitive `session_id` is stable across restart for that bound task;
- two distinct task ids inside the same run cannot collide even if their objective text is identical;
- the bound/refined task preserves existing live `capability_session` and other non-evidence handles as intended, while persisted task identity remains internally consistent;
- if identity cannot be established, the path reports `COGNITIVE_UNAVAILABLE` and continues only along independently safe canonical behavior rather than silently writing to a default guessed root.

---

## Q. Prepared-attempt crash-window matrix

Exercise one side-effecting prepared resolution through a production-connected canonical execution seam and inject crashes in **all four** handoff windows. The test must map the cognitive status to the owner's actual durable write order, not to suggestive state names:

1. **After cognitive `PREPARED`, before canonical intent/effect identity binding.** Restart proves no owner intent/effect identity exists and may continue only the same `attempt_id`.
2. **After canonical intent/effect identity is durably bound (`INTENT_BOUND`), before the owner's effect-possible boundary.** Restart proves the effect cannot yet have happened under that owner's protocol and may advance the same attempt; if the owner cannot prove this distinction, this case must be treated conservatively rather than guessed.
3. **After the owner's durable effect-possible boundary (`EFFECT_POSSIBLE`), before definitive receipt/reconciliation.** Restart reconciles the canonical owner. It may consume proof of completion or definitive non-issue/refusal, but if outcome remains ambiguous it records `AMBIGUOUS` and does not replay the side effect. At the observed meta dispatcher, the durable `dispatched` record belongs in this case because it is written immediately before `issue()`.
4. **After canonical completion/receipt, before cognitive completion/accounting.** Restart consumes the existing receipt, marks the same attempt complete exactly once, and does not reissue or double-count it.

For multi-step reuse, repeat every reachable handoff window at an intermediate step and prove completed earlier `step_attempt_id`s are not replayed, an effect-possible/ambiguous step is never blindly reissued, and later steps are not skipped.

Also include a crash after the canonical owner has acquired a durable pre-effect budget reservation/lease/lock but before a canonical intent is persisted. Restart must run the owner's existing reconciliation, release or preserve the resource according to canonical evidence, and continue the same cognitive attempt without leaking allowance, duplicating the reservation, or inventing an effect.

Also include a side-effecting operator whose owner cannot provide durable idempotency/effect identity or cannot distinguish pre-effect identity binding from the effect-possible boundary. Prove prepared automatic execution is refused/falls back rather than taking an unreconcilable risk.

## R. Evolve-agent/Borg owner integration is truthful

Exercise the live evolve-agent path that runs `BorgCollectiveOrchestrator` and prove:
- the cognitive session is not durably created until the workflow has a real canonical run namespace + stable task/subject identity;
- transient failures that the Borg adaptive ladder resolves do not open a false cognitive impasse;
- an authoritative final blocked condition can be represented as an impasse/resolution request without rewriting the orchestrator's verdict history;
- the existing post-orchestrator meta cycle alone does **not** mark that impasse resolved;
- if current `main` has no safe continuation seam, the benchmark expects honest `BLOCKED` rather than an unsafe second orchestrator execution;
- if implementation adds/uses a safe continuation seam, it reuses durable checkpoint/dispatch settlement identity, re-enters only unresolved work, and proves no completed effect/checkpoint is replayed before the later canonical parent reports `ADVANCED`.

---

---

# 17. Non-vacuity / sabotage requirements

For each major guarantee, deliberately break one mechanism in a throwaway test/monkeypatch/worktree and require the relevant test to fail.

At minimum:

1. disable impasse classification -> D fails;
2. collapse all four kinds to `NO_CHANGE` -> D fails;
3. disable `impasse_key` dedup -> H or duplicate-subgoal test fails;
4. bypass goal-context visibility filter -> C fails;
5. mutate PARENT_VISIBLE entry in place instead of copying promotion -> sibling/provenance test fails;
6. allow LOCAL/PARENT_VISIBLE eviction to consolidate into durable memory -> context-leak test fails;
7. allow stale child completion to resolve parent -> F fails;
8. mark chunk verified without independent evidence -> verification test fails;
9. remove dependency digest check -> B fails;
10. execute chunk directly instead of canonical executor -> E fails;
11. allow learned history to beat a fresh hard failure -> safety test fails;
12. disconnect project-evolution production wiring while leaving new unit tests intact -> end-to-end benchmark fails;
13. disable prepared reuse -> A's structural-work reduction fails;
14. allow abandoned child artifacts into STOP eligibility -> J fails;
15. remove transition outbox reconciliation -> M fails;
16. make evidence publication non-idempotent -> M fails;
17. blindly retry an ambiguous prepared effect -> L fails;
18. let a reproducibility-only candidate-id tiebreak flow to promotion during a material TIE -> tie-hold test fails;
19. remove scope separation from a shared long-term store -> K fails;
20. remove the dispatch-time artifact visibility re-check while leaving Assess/propose filtering intact -> C fails;
21. make child artifact ownership/eligibility a post-hoc registration instead of a pre-effect durable binding -> J or crash-injection test fails;
22. reset cumulative parent resolution budget when `state_key` changes -> bounded-resolution test fails;
23. let a child/worker self-label arbitrary context `PERSISTENT` -> context-authority test fails;
24. treat a parent visibility binding alone as final submission eligibility -> J's valid-promotion/visibility-only case fails;
25. remove the steering/cognitive revision fence -> F2 fails;
26. allow the same failed VERIFIED chunk to reissue on unchanged applicability by minting a fresh attempt id -> prepared-attempt idempotency test fails;
27. derive `state_key`/`impasse_key` from random candidate ids -> stable-blockage restart test fails;
28. let old-revision LOCAL context remain visible automatically after parent revision advance -> C fails;
29. make chunk ids random or count one `attempt_id` outcome twice -> A2 fails;
30. continue a multi-step prepared sequence after an intermediate step/postcondition fails -> A3 fails;
31. select a VERIFIED chunk, then invalidate/retire it before issue without a final pre-effect re-read -> prepared-TOCTOU test fails;
32. bypass/remove the canonical per-effect pause/cancel control probe -> N fails;
33. classify canonical pause/cancel itself as `NO_CHANGE` and spend a resolution attempt -> N fails;
34. let cognitive control consume raw semantic-provider scores instead of the final authoritative participation/router outcome -> shadow-authority isolation test fails;
35. open a real impasse but drop/ignore `TransitionOutcome` at the production caller so no bounded continuation can occur -> A/production-reachability fails;
36. count a meta-created artifact as resolution without feeding it back through the parent owner and obtaining a later `ADVANCED` observation -> A fails;
37. map a typed peer-moved-first concurrency refusal to `NO_CHANGE`/chunk failure instead of re-observing canonical state -> O fails;
38. derive `attempt_id` from the mutable full chunk digest so a counter update mints a fresh attempt -> A2/prepared-idempotency fails;
39. give all steps of a multi-step prepared resolution one undifferentiated effect id or no per-step receipt identity -> A3/L fails;
40. create durable cognitive state for a direct `ProjectTask` with empty/unbound run/task identity by falling back to objective text or a default root -> P fails;
41. mark an impasse resolved/chunk successful merely because a child target was produced while the canonical parent still reports no advance -> D/A fails;
42. create parent-promoted context under the old parent revision and only then increment the parent revision in a separate write -> C/crash-consistency fails;
43. issue a prepared side effect without first durably binding its deterministic attempt/step identity to the canonical execution owner -> Q fails;
44. collapse `INTENT_BOUND` and `EFFECT_POSSIBLE` into one state so a crash after write-ahead intent but before/around issue cannot be reconciled according to the owner's real ordering -> Q fails;
45. assume `PREPARED` + no canonical intent means no canonical budget reservation/lease/lock exists, skipping the owner's resource reconciliation -> Q fails;
46. allow a side-effecting prepared operator whose owner has no durable idempotency/effect reconciliation identity -> Q/L fails;
47. derive prepared `attempt_id` without a current `applicability_digest`, allowing two different dynamic argument bindings/precondition instances to alias one effect identity -> A2/prepared-idempotency fails;
48. freeze/drop new definitive failure evidence when the processed-attempt dedup window is saturated, allowing stale VERIFIED reuse to continue because bounded positive history was treated as a safety authority -> failure/invalidation test fails;
49. implement chunk persistence as last-write-wins so a stale concurrent writer can resurrect an `INVALID`/`RETIRED` chunk or double-merge evidence/counters -> A2 fails;
50. reuse a prompt-intake meta activation after canonical run/revision binding without revalidating its run id/revision/current signals, allowing stale DIRECT/META gating to suppress or misroute resolution -> production-continuation/steering tests fail;
51. retry idempotent cognitive evidence publication with a random/invalid artifact id or by calling `RunArtifactStore.put` and catching duplicate, allowing duplicate publication or a commit-sequence hole -> evidence-outbox test fails;
52. conflate `BorgCollectiveOrchestrator` with `collective_integration/operating_loop` and wire only the latter while claiming evolve-agent production coverage -> R/reachability fails;
53. re-run `BorgCollectiveOrchestrator` from scratch after a blocked verdict without a canonical resume contract, allowing completed checkpoint/effect replay -> R fails.

A guard that still passes when its mechanism is removed is not proven load-bearing; fix the test or the design.

---

# 18. Required focused tests

At minimum add tests equivalent to:

```text
test_goal_hierarchy_is_acyclic
test_goal_depth_is_bounded
test_task_revision_supersedes_old_root
test_two_tasks_in_one_run_have_distinct_cognitive_session_state
test_control_observation_rejects_inconsistent_hard_rejection_subset
test_observation_id_ignores_retry_generated_publication_wrapper
test_state_key_uses_stable_option_fingerprint_not_random_candidate_id
test_parent_revision_abandons_stale_child
test_late_child_result_cannot_resolve_new_parent
test_stale_control_observation_cannot_open_or_resolve_impasse
test_parent_revision_increments_atomically_with_accepted_progress
test_state_key_changes_do_not_reset_parent_resolution_budget
test_meta_steering_revision_mismatch_blocks_cognitive_scoped_dispatch
test_meta_resolution_rebinds_activation_to_current_run_id_and_task_revision
test_stale_intake_direct_activation_cannot_suppress_current_resolution_escalation
test_evolve_agent_binds_cognitive_identity_after_canonical_run_id_exists
test_borg_transient_recovery_does_not_create_false_impasse
test_borg_final_block_can_surface_impasse_without_replaying_orchestrator
test_post_orchestrator_meta_artifact_alone_does_not_resolve_borg_parent

test_same_impasse_key_reuses_open_impasse
test_cognitive_state_cas_refuses_lost_update
test_pending_evidence_outbox_reconciles_after_restart
test_evidence_publication_is_idempotent_by_transition_id
test_evidence_sink_maps_transition_to_stable_valid_artifact_id
test_evidence_idempotent_retry_does_not_allocate_run_artifact_sequence_hole
test_advanced_does_not_imply_goal_satisfied
test_cognitive_store_failure_does_not_grant_or_claim_progress
test_concurrent_same_impasse_creates_one_child

test_tie_impasse_from_substantive_equal_exclusive_options
test_reproducibility_id_tiebreak_alone_does_not_force_false_tie
test_no_change_impasse_from_required_missing_input
test_reject_impasse_only_when_hard_refusal_blocks_all_legal_routes
test_conflict_impasse_only_when_unresolved_incompatibility_blocks_progress
test_router_no_match_is_not_automatically_an_impasse

test_working_memory_without_visibility_context_is_backward_compatible
test_legacy_memory_remains_eligible
test_local_memory_visible_to_descendant_then_hidden_after_close
test_old_revision_local_context_hidden_after_parent_progress
test_explicit_carry_forward_creates_new_revision_binding
test_parent_visible_promotion_copies_with_provenance
test_child_cannot_self_promote_arbitrary_context_to_persistent
test_context_visibility_never_hides_governance_or_hard_constraints
test_persistent_memory_survives_context_close
test_local_memory_eviction_does_not_consolidate_to_long_term
test_cognitive_memory_context_item_id_is_stable_across_access
test_meta_delivered_context_excludes_closed_sibling_local_evidence
test_dispatch_refuses_guessed_hidden_artifact_id
test_child_artifact_scope_is_bound_before_effect
test_abandoned_child_artifact_is_not_stop_eligible
test_visibility_binding_alone_does_not_make_child_artifact_submittable
test_parent_promotion_creates_separate_stop_eligible_record

test_chunk_requires_real_impasse_and_parent_progress
test_same_resolution_core_reuses_deterministic_chunk_id
test_concurrent_same_core_chunk_creation_coalesces
test_chunk_id_collision_with_different_core_fails_closed
test_stale_concurrent_writer_cannot_resurrect_invalid_or_retired_chunk
test_concurrent_chunk_evidence_merge_is_idempotent
test_chunk_attempt_outcome_is_counted_once_across_restart
test_processed_attempt_window_saturation_never_drops_fresh_failure_authority
test_chunk_refuses_insufficient_causal_lineage
test_chunk_does_not_serialize_secret_or_approval_token
test_chunk_not_active_before_verification
test_chunk_negative_applicability_guard
test_verified_chunk_reuses_canonical_executor
test_chunk_contract_digest_change_refuses_reuse
test_chunk_preimage_change_refuses_raw_patch_reuse
test_fresh_measurement_overrules_learned_chunk
test_ambiguous_prepared_effect_is_reconciled_not_replayed
test_same_failed_verified_chunk_is_not_retried_on_unchanged_state
test_chunk_is_reread_and_revalidated_immediately_before_prepared_effect
test_multistep_chunk_stops_before_later_steps_on_intermediate_failure
test_multistep_mutation_requires_existing_rollback_or_safe_partial_semantics
test_pause_blocks_next_resolution_effect_without_opening_impasse
test_resume_continues_same_resolution_without_duplicate_attempt
test_cancel_blocks_new_effect_and_abandons_incomplete_cognitive_work
test_cancel_does_not_compile_incomplete_resolution_chunk
test_ambiguous_inflight_effect_is_reconciled_after_cancel_not_replayed
test_cognitive_adapter_uses_authoritative_participation_outcome_not_shadow_semantic_score
test_transition_outcome_is_deterministic_and_matches_committed_transition
test_open_impasse_surfaces_resolution_request_to_production_owner
test_meta_resolution_artifact_does_not_resolve_parent_until_parent_consumes_it
test_bounded_owner_continuation_feeds_resolution_evidence_back_to_parent
test_peer_moved_first_refusal_does_not_open_no_change
test_stale_decision_before_effect_does_not_consume_resolution_attempt
test_peer_moved_first_reloads_and_reobserves_before_classification
test_attempt_id_uses_immutable_chunk_core_not_mutable_record_digest
test_attempt_id_includes_current_applicability_and_dynamic_binding_digest
test_different_dynamic_bindings_cannot_alias_one_prepared_effect_identity
test_multistep_prepared_resolution_has_deterministic_per_step_attempt_ids
test_pre_effect_no_effect_issued_rebase_reuses_same_attempt_id_without_failure_count
test_direct_project_task_defers_cognitive_state_until_identity_is_bound
test_bound_direct_task_cognitive_session_id_is_restart_stable
test_two_same_objective_tasks_in_one_run_do_not_collide
test_child_target_without_parent_advance_does_not_resolve_impasse_or_compile_chunk
test_parent_revision_advance_and_context_promotion_commit_atomically
test_promoted_binding_targets_new_parent_revision
test_prepared_attempt_is_durable_before_effect_issue
test_intent_bound_is_not_treated_as_effect_possible_or_completed
test_owner_effect_possible_boundary_is_mapped_from_real_durable_write_order
test_meta_dispatched_state_maps_to_effect_possible_not_completion
test_crash_after_prepared_before_intent_reuses_same_attempt_without_duplicate_effect
test_preintent_resource_reservation_is_reconciled_before_same_attempt_continues
test_crash_after_intent_bound_before_effect_possible_reuses_same_attempt_when_owner_proves_no_issue
test_crash_after_effect_possible_before_receipt_reconciles_without_blind_replay
test_crash_after_receipt_before_cognitive_completion_finishes_exactly_once
test_side_effecting_prepared_reuse_requires_durable_owner_effect_identity
test_external_effect_chunk_cannot_be_verified_by_repeating_live_side_effect
test_material_project_tie_holds_reproducibility_only_winner
test_legitimate_existing_tiebreak_prevents_false_tie
test_tie_hold_occurs_before_incumbent_retention_or_apply_exposure
test_tie_resolution_must_feed_existing_evaluator
test_corrupted_chunk_fails_closed
test_unknown_chunk_matcher_version_fails_closed
test_verified_chunk_survives_restart
test_cognitive_state_pending_evidence_reconciles_after_crash
test_existing_dispatch_record_schema_still_verifies_after_scope_integration
test_opaque_freeform_model_step_is_not_compiled_as_executable_chunk
```

Re-run all affected existing suites, especially:
- capability participation/router tests;
- project-evolution tests;
- meta-reasoning tests;
- working-memory tests;
- governance/execution tests touched by the integration;
- existing proof/behavioral-regression gates relevant to changed files.

Do not weaken an existing assertion to make the new mechanism pass.

---

# 19. Evidence and observability

For every impasse, the system must be able to answer from persisted machine-observable records:

```text
Which canonical goal was blocked?
Which parent revision was current?
What stable state_key defined the blockage?
Which impasse kind was selected and from which reason codes?
Which options were viable, rejected, missing, or conflicting?
Which evidence refs support those facts?
Was an existing impasse reused or a new one opened?
Which resolution child owns it?
What governed actions/receipts occurred?
What authoritative observation changed the state?
Did the parent actually advance?
Was the child stale/abandoned/blocked/resolved?
Was a chunk created?
Why did it pass or fail verification?
Was it reused later?
Did current governance still approve the actual effect?
```

Do not persist private chain-of-thought. Persist facts, decisions, receipts, lineage, compact rationales, and digests.

---

# 20. Metrics

Expose only metrics derived from real records:

```text
impasses_total
impasses_by_kind
impasses_resolved
impasses_blocked
impasse_duplicates_suppressed
resolution_children_created
resolution_depth_max
stale_resolution_results_refused

context_local_hidden
context_parent_promotions
context_persistent_visible

chunks_candidate
chunks_verified
chunks_reused
chunks_refused
chunks_invalidated
chunk_reuse_success_rate

prepared_resolution_hits
resolution_attempts
resolution_meta_cycles
resolution_controller_model_calls
resolution_capability_rounds
```

No vanity intelligence score.

---

# 21. Backward compatibility

Mandatory:

- existing `WorkingMemory.add/recall` callers work unchanged;
- old `MemoryEntry` serialized form loads unchanged;
- old ProjectTask persisted documents/digests remain valid because the live cognitive handle is excluded;
- capability participation behavior is unchanged when no cognitive goal owner consumes its records;
- project-evolution hard gates remain authoritative;
- meta-reasoning budgets/deadlines/dispatch reconciliation remain authoritative;
- new state/chunk schemas reject corruption rather than silently migrating unknown critical data;
- no new environment variable is required if the canonical DoubleTake state root already exists.

If current `main` requires a schema migration, implement it explicitly and test old -> new. Do not silently default away critical fields.

If cognitive scope/ownership requires adding digest-covered fields to an existing versioned record such as `DispatchIntent`, `ArtifactRecord`, or `DeliveredContextManifest`, do **not** append fields under the old schema and then default them on read: that changes the recomputed digest and makes old durable records unverifiable. Either use a crash-safe sidecar binding or bump the schema and preserve the old schema's exact digest algorithm in its reader/migration path. Add a fixture containing a pre-change durable record and prove it still verifies/reconciles correctly.

---

# 22. Performance rules

The new mechanism must not make ordinary successful work expensive.

On a task with no blocked observation:
- no resolution child;
- no chunk replay;
- no extra provider/model call;
- no meta escalation caused solely by the presence of the cognitive package;
- only bounded deterministic bookkeeping.

Chunk lookup occurs only after a real impasse opens or when an existing open impasse resumes.

---

# 23. Implementation order

Execute in this order.

## Phase 1 — authoritative trace

Trace current `main` end to end and record the exact live seams for:
- prompt/direct entrypoint -> ProjectTask -> bound run/task identity (including direct constructors that initially lack ids);
- ProjectTask -> capability session;
- project evolution failure/recovery;
- meta activation/escalation/drive;
- governed worker execution;
- working-memory recall;
- evidence/artifact persistence.

If this prompt names a stale function/path, update the implementation plan to the live equivalent before editing code.

## Phase 2 — models + durable state + concurrency

Implement:
- GoalFrame;
- ControlObservation;
- ImpasseRecord;
- ResolutionTrace;
- ContextBinding;
- TransitionOutcome + ResolutionRequest;
- PreparedAttempt write-ahead/reconciliation records;
- cognitive state store with CAS/locking;
- deterministic transition ids + pending-evidence outbox/reconciliation;
- task/session attachment;
- dedup/concurrency tests.

Do not wire automatic resolution yet.

## Phase 3 — context visibility

Implement the namespaced working-memory metadata + optional visibility filter + promotion-copy semantics.

Prove zero-context backward compatibility first.

## Phase 4 — deterministic impasse lifecycle

Implement classification, open/reuse/resolve/block/abandon transitions, revision staleness, bounds, and all four type tests.

## Phase 5 — project-evolution + capability evidence integration

Wire real measured project/capability records into `ControlObservation`, return deterministic `TransitionOutcome`, and make the production caller consume unresolved `ResolutionRequest`/holds. Prove end-to-end reachability before adding chunking.

## Phase 6 — existing meta-control resolution path + bounded continuation

Wire blocked work to the canonical meta escalation/drive seams using measured signals and shared budgets/deadlines **through the production continuation owner in §11.1**. Preserve canonical pause/cancel and peer-moved-first concurrency semantics. Feed resulting canonical evidence back into the parent lifecycle and require a later authoritative observation for progress.

Prove there is no private controller loop/provider path and no detached meta artifact being counted as resolution.

## Phase 7 — verified chunks

Implement candidate creation, causal lineage, repository scope, safe serialization, independent verification, reuse, invalidation, restart and corruption handling.

## Phase 8 — whole-system benchmarks + sabotage

Implement every benchmark section (A, A2, A3, B-F, F2, G-R), run affected regressions, crash-injection tests, then perform non-vacuity removals.

## Phase 9 — architecture audit

Search for:
- duplicate routers/planners/control loops;
- model calls outside governed inference;
- direct chunk execution;
- stale child effects;
- mutable live handles leaking into task digests;
- raw secrets in chunk files;
- unbounded loops/depth;
- false impasses on `NO_MATCH`;
- evidence claims unsupported by production paths;
- cross-store state/evidence transitions with no crash recovery;
- post-hoc artifact ownership/eligibility races;
- context filtering that exists only before planning but not at dispatch/finalization;
- typed canonical concurrency refusals incorrectly converted into cognitive failures/impasses;
- unused/dead cognitive abstractions.

Delete or repair anything found.

---

# 24. Convergence loop

Repeat this loop until **two consecutive clean passes** find no material functional, safety, persistence, concurrency, or production-integration defect and every required gate remains green. Cosmetic/style-only nitpicks are out of scope unless they make the implementation ambiguous enough to cause incorrect code:

1. Re-read authoritative current `main` for files touched since the prior pass.
2. Re-run focused tests and affected regression suites.
3. Run whole-system cognitive-control benchmarks.
4. Inspect every failing or ambiguous case.
5. Identify the single highest-impact functional/safety/integration flaw.
6. Add or strengthen a test that reproduces it through the real path.
7. Implement the smallest architecture-coherent repair.
8. Re-run focused tests.
9. Re-run affected regressions.
10. Re-run the relevant end-to-end benchmark.
11. Run one non-vacuity removal for the repaired mechanism.
12. Audit for new duplicate authority, import cycles, state races, stale-result hazards, governance bypass, false progress, or dead code.
13. If any material flaw remains, repeat.

Do not stop because:
- code compiles;
- new-package unit tests pass;
- one happy-path benchmark passes;
- the feature exists behind a manual call;
- comments say the invariant is true;
- an LLM judges the design “good enough.”

A “no material defect” pass means: no failing required test, no unsupported runtime claim, no known production bypass, no unresolved race that can violate the invariant, no stale-result path, no governance bypass, no false impasse, no unbounded resolution path, no cross-store crash-consistency gap, no hidden-context dispatch/finalization bypass, and no duplicate control authority found by the audit.

---

# 25. Final stopping condition

Stop only when all are demonstrated on current `main`:

- [ ] Project tasks have one durable/reconstructable cognitive root per current canonical meta/task revision/objective, namespaced by a real run namespace + stable task/subject identity so multiple tasks in one run cannot collide.
- [ ] Direct `ProjectTask` constructors with initially empty ids defer cognitive persistence until canonical identity is bound/supplied; no objective-text/default-root fallback invents durable identity.
- [ ] Task steering/revision supersedes the old cognitive root and abandons its active descendants.
- [ ] A canonical/cognitive revision mismatch acts as a dispatch fence; no new-revision work is issued while ownership still points at the old root.
- [ ] Live cognitive handles do not change ProjectTask persisted identity/digest.
- [ ] `ControlObservation` comes from canonical subsystem facts, not model guesses.
- [ ] Every state-changing observation returns a deterministic `TransitionOutcome`; an open impasse that needs work returns a bounded `ResolutionRequest` that a production owner can actually consume.
- [ ] `state_key` excludes volatile/unrelated fields and random/sequence option ids; unchanged blocking state retains stable canonical fingerprints across retry/restart.
- [ ] `TIE`, `NO_CHANGE`, `REJECT`, and `CONFLICT` each have a real production-connected fixture.
- [ ] Correct capability `NO_MATCH` does not create a false impasse.
- [ ] Same unchanged `impasse_key` cannot create duplicate active resolution children.
- [ ] Concurrent observers cannot create duplicate children or lose state updates.
- [ ] Canonical peer-moved-first/stale-decision refusals are rebased/re-observed rather than classified as `NO_CHANGE` or counted as prepared-resolution failures when no effect was issued.
- [ ] Goal depth, per-impasse attempts, and cumulative parent/root resolution work are bounded; changing `state_key` cannot reset the cumulative budget indefinitely.
- [ ] At most one active resolution child exists per parent by default; any parallel exception is explicitly proven independent/isolated.
- [ ] Parent revision change makes old child completion stale and non-operative.
- [ ] A child-local target result cannot resolve an impasse or count as prepared success unless the canonical parent subsequently reports `ADVANCED`.
- [ ] Stale `ControlObservation` records cannot open/resolve the current impasse, and accepted progress increments the parent revision atomically with child/impasse closure.
- [ ] Stale child memory is not promoted and stale child work cannot create a chunk.
- [ ] Working memory with no visibility context preserves prior behavior.
- [ ] Legacy memory entries remain compatible.
- [ ] LOCAL / PARENT_VISIBLE / PERSISTENT visibility semantics pass, including revision scoping: old-revision LOCAL scratch context is hidden unless explicitly carried forward.
- [ ] Unpromoted local memory cannot leak through working->long-term consolidation.
- [ ] Actual meta/controller context delivery excludes closed/unrelated child-local state/artifacts, and the proof traverses the real context assembly path.
- [ ] Dispatch/context-manifest construction independently rejects hidden artifact ids even if a proposal names one explicitly.
- [ ] Child artifacts are bound to runtime-owned goal scope before effect/commit; there is no post-hoc eligibility race.
- [ ] Abandoned/stale child artifacts cannot become final STOP/submission outputs without explicit parent promotion.
- [ ] A parent visibility binding alone cannot make a historically ineligible child artifact submittable; valid promotion creates a distinct parent-scoped runtime-owned eligible record/provenance transition.
- [ ] Workers/children cannot self-grant `PERSISTENT` context lifetime.
- [ ] Promotion creates a provenance-preserving parent copy/reference, not an in-place scope mutation.
- [ ] Successful parent revision advance and child->parent context promotion are one cognitive CAS transition, and promoted bindings target the new parent revision.
- [ ] Resolution children cannot self-mark arbitrary context persistent, and goal filtering never hides governance/security/hard-constraint/budget authority facts.
- [ ] Existing meta reasoning remains the only model-based deliberation/control loop used for resolution.
- [ ] A real production owner consumes `TransitionOutcome` and provides bounded continuation/re-entry; the cognitive package contains no hidden recursive executor/loop.
- [ ] Meta-produced resolution evidence is explicitly fed back through the canonical parent owner, and parent progress is claimed only after a later authoritative `ADVANCED`/`goal_satisfied` observation.
- [ ] Meta resolution inherits existing budgets, deadlines, governance, dispatch reconciliation, and canonical pause/cancel control-state gating.
- [ ] Meta activation/escalation used for resolution is bound to the actual current run id and task revision; stale prompt-intake activation records cannot suppress or authorize current resolution after identity binding or steering.
- [ ] Pause/cancel are not misclassified as cognitive impasses: pause preserves resumable state without spending attempts; cancel prevents new work and terminalizes incomplete cognitive work without compiling it.
- [ ] Every prepared-resolution step reuses the live owner's current run-control gate; cognitive control cannot dispatch around a pause/cancel probe.
- [ ] Capability router remains the only capability relevance/composition authority, including current shadow/rollout semantics; cognitive control does not re-authorize raw semantic-provider scores.
- [ ] Project-evolution hard gates/selection remain authoritative.
- [ ] Candidate chunks require a real impasse, causal lineage and parent progress.
- [ ] The reusable chunk core has deterministic `chunk_id` + immutable `core_digest`; prepared `attempt_id` also binds a current `applicability_digest` so materially different dynamic argument/precondition instances cannot alias one effect identity; mutable counters/status/timestamps cannot mint a new attempt, and replay/restart cannot duplicate a chunk or double-count the same logical attempt.
- [ ] Concurrent chunk create/update paths are CAS-safe: same-core creation coalesces, immutable-core collisions fail closed, and stale writers cannot resurrect `INVALID`/`RETIRED` chunks or double-merge evidence/counters.
- [ ] Multi-step prepared reuse has deterministic per-step effect/attempt identities and receipts so partial completion is reconciled step-by-step.
- [ ] Every side-effecting prepared attempt has a durable cognitive PREPARED record and a durable canonical owner attempt/effect binding before issue; restart reconciles the handoff instead of guessing.
- [ ] Pre-intent canonical budget reservations/leases/locks are reconciled through their existing owner on restart; cognitive retry never assumes "no intent" means "no durable resource held".
- [ ] Side-effecting prepared reuse is refused when the canonical owner cannot provide a durable idempotency/effect identity and reconciliation path.
- [ ] Chunks default to repository-local scope.
- [ ] Chunk files contain no credentials, approval tokens, hidden reasoning or unsafe captured payloads.
- [ ] Opaque free-form model steps without stable canonical operator identities are not compiled as executable chunks.
- [ ] `CANDIDATE` chunks cannot execute as prepared knowledge.
- [ ] `VERIFIED` promotion requires independent/equivalent verification and negative applicability coverage.
- [ ] Every reuse re-reads the current chunk record immediately before effect and rechecks current contracts, dependencies, preconditions and governance.
- [ ] Multi-step chunks verify each intermediate postcondition before issuing the next step and require existing safe rollback/recovery semantics for partial mutation.
- [ ] Raw patch reuse requires exact preimage match plus ordinary isolated validation.
- [ ] Fresh evidence/hard gates outrank chunk history/support; saturation/compaction of positive attempt-history dedup can never discard or mask a new safety-significant failure/refusal, and inability to represent that evidence safely demotes/refuses reuse rather than preserving confidence.
- [ ] Corrupted/stale/unknown-matcher-version chunks fail closed.
- [ ] Verified chunks survive restart without bypassing revalidation.
- [ ] Every production path claiming cognitive control has a durable canonical EvidenceSink adapter; no in-memory-only path claims restart/audit guarantees.
- [ ] Cognitive state/evidence crash recovery reconciles pending transitions without duplicate effects or fabricated history.
- [ ] Existing durable record schemas still verify after any context-scope integration, or have an explicit backward-compatible schema migration.
- [ ] Chunk lookup/retention is bounded and cannot turn long-running use into an unbounded scan.
- [ ] Benchmark A proves a complete production continuation (impasse -> resolution work -> evidence fed back to parent -> authoritative progress) and less structural deliberation on recurrence with equal-or-better correctness/evidence.
- [ ] Benchmark A2 proves deterministic chunk creation and idempotent outcome accounting.
- [ ] Benchmark A3 proves multi-step prepared execution halts safely on an intermediate failure/refusal and never blindly issues later steps.
- [ ] Benchmark B proves dependency change refuses stale preparation.
- [ ] Benchmark C proves context pruning.
- [ ] Benchmark D proves all four impasse classes are reached from canonical facts and unresolved cases block honestly.
- [ ] Benchmark E proves governance cannot be bypassed by prepared knowledge.
- [ ] Benchmark F proves stale child results cannot land after parent revision.
- [ ] Benchmark F2 proves canonical/cognitive task-revision mismatch fences dispatch until reconciled.
- [ ] Benchmark G proves cognitive/chunk restart durability and corruption refusal.
- [ ] Benchmark H proves concurrent duplicate suppression.
- [ ] Benchmark I proves correct capability `NO_MATCH` remains a non-impasse.
- [ ] Benchmark J proves abandoned/local child output cannot become a final deliverable without valid parent promotion.
- [ ] Benchmark K proves durable memory scope isolation or proves it satisfied by physical repository isolation.
- [ ] Benchmark L proves an ambiguous prepared effect is reconciled and never blindly replayed.
- [ ] Benchmark M proves cognitive-state/evidence split-write recovery and idempotent publication.
- [ ] Benchmark N proves canonical pause/cancel cannot be bypassed by impasse resolution or prepared knowledge.
- [ ] Benchmark O proves peer-moved-first concurrency causes bounded re-observation, not a false cognitive failure/impasse or duplicate effect.
- [ ] Benchmark P proves direct-entry task identity is bound before durable cognitive state and remains collision-free/restart-stable.
- [ ] Benchmark Q proves all four prepared-attempt handoff windows (`PREPARED` → `INTENT_BOUND` → `EFFECT_POSSIBLE` → terminal reconciliation) reconcile according to the canonical owner's real durable write ordering, without duplicate side effects, skipped steps, or double-counted outcomes.
- [ ] Benchmark R proves the live evolve-agent `BorgCollectiveOrchestrator` path is identity-correct and impasse-observable, does not mistake transient adaptive recovery for an impasse, and never claims/attempts autonomous continuation by replaying the orchestrator without a proven safe resume contract.
- [ ] Production reachability test fails if cognitive wiring is removed while unit classes remain.
- [ ] Sabotage checks prove every major mechanism is load-bearing.
- [ ] Existing affected suites remain green without weakened assertions.
- [ ] No duplicate planner/router/meta loop/generic memory/governance/execution framework was introduced.
- [ ] No TODO, simulated success, fake evidence, manual-only integration, or documentation-only substitute remains.
- [ ] Two consecutive final audit passes, using different lenses (architecture/production reachability, then adversarial restart/concurrency/governance), discover no additional material functional defect.
- [ ] Cognitive state/evidence split-write recovery is crash-consistent and idempotent, and pending evidence is never dropped to regain liveness.
- [ ] Idempotent cognitive audit publication maps each `transition_id` to one stable valid store-native artifact id and cannot create a `RunArtifactStore` commit-sequence hole under retry/concurrency.
- [ ] `ADVANCED` and `goal_satisfied` are distinct; intermediate progress cannot prematurely resolve the root goal.
- [ ] Persistent chunk scope is derived from a stable non-secret repository identity; absence of such identity disables persistent VERIFIED reuse rather than widening scope.
- [ ] Ambiguous prepared effects are reconciled through canonical execution evidence and are not blindly replayed.
- [ ] The same failed/refused VERIFIED chunk is not reissued on unchanged applicability merely by minting another attempt id.
- [ ] Non-idempotent/external effects cannot become VERIFIED by repeating the live side effect when no safe independent replay/simulation exists.
- [ ] A material project-evolution TIE cannot leak a reproducibility-only identifier winner into downstream application or incumbent retention while unresolved, while legitimate existing measured/learned tiebreaks do not create false ties.
- [ ] Repeating an unchanged BLOCKED state does not reset attempt budgets or create a fresh resolution merely because a caller retried.

When the stopping condition is satisfied, produce a concise engineering report with:
- files created/modified;
- exact production integration points;
- state/schema additions;
- tests and benchmark results;
- sabotage/non-vacuity results;
- backward-compatibility results;
- concurrency/restart results;
- any limitation the evidence still requires you to state;
- the strongest capability claim the evidence actually supports.

If any checkbox is false, continue the convergence loop.
