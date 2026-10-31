# DoubleTake Impasse-Native Cognitive Control — Checkpoint v2

**Checkpoint date:** 2026-10-04  
**Observed authoritative `main` HEAD:** `9f99be3e5ddb80d2e77f13f19f04da11195239cb`  
**Current converged implementation prompt:** `DOUBLETAKE_IMPASSE_NATIVE_COGNITIVE_CONTROL_MISSION_v43_COMPACT_CONVERGED.md`

## Checkpoint purpose

This file freezes the cognitive-control design work completed so far so the next review can resume from a clean, standalone checkpoint instead of reconstructing the earlier iterations.

The implementation mission below is the current consolidated state. It incorporates the high-value cognitive-science mechanisms selected for DoubleTake together with the repository-specific corrections discovered during repeated architecture, concurrency, restart, governance, owner-integrity, and production-reachability passes.

## What is already incorporated

The checkpoint currently includes:

- typed autonomous impasses: `TIE`, `NO_CHANGE`, `REJECT`, `CONFLICT`;
- explicit separation of autonomous impasses from `WAITING_EXTERNAL` and `OWNER_TERMINAL`;
- hierarchical goal/subgoal state with serial child ownership;
- goal-scoped context visibility and explicit promotion;
- one-shot child-to-parent feedback and causal attribution;
- bounded semantic resolution-attempt claims and durable pre-owner start fence;
- crash/restart reconciliation for nonterminal attempts;
- safe same-lineage rebase and recursive-blocker protection;
- persistent verified prepared-resolution chunks;
- cross-run repository + security/data-scope partitioning;
- bounded signature-sharded chunk lookup;
- prepared-attempt idempotency and canonical executor preservation;
- project-evolution trial-isolation rules;
- capability-participation integration without duplicating the router;
- meta governance, duplicate-work, STOP, no-progress and user-input ownership;
- operator-control ownership;
- user-interaction owner hardening requirements;
- EffectJournal integrity hardening requirements;
- canonical audit outbox and RunArtifactStore sequence-crash handling;
- canonical source replay/high-water handling;
- crash-safe parent promotion/finalization;
- report/schema/governed-writer evidence integrity;
- default-test collection requirements;
- whole-system benchmark, sabotage/non-vacuity and convergence closure requirements.

## Current known repository condition

At the checkpoint HEAD, the schema-versioning work intentionally exposes one pre-existing governed-write mismatch finding involving workflow documents written under `governance_status` despite declaring other artifact types. The current mission treats this as a baseline finding unless the cognitive-control implementation actually depends on that path. Do not repair unrelated concurrent work merely to make this mission's suite green.

## How to resume from this checkpoint

When continuing:

1. Read live `AGENTS.md`.
2. Read current `main` HEAD.
3. Diff this checkpoint HEAD against current HEAD.
4. Reinspect only the owners/surfaces materially affected by that delta.
5. Update this mission only for real functional/correctness gaps; do not reopen settled design points for wording or cosmetic preferences.
6. Continue the convergence loop until no material defect remains.
7. Preserve shared-main behavior: never reset, rewrite history, or discard another agent's work.

---

# Frozen implementation mission

# DoubleTake Impasse-Native Cognitive Control Mission — Compact Converged Implementation Prompt v43

## 0. Mission

Upgrade **DoubleTake** so four high-value cognitive mechanisms become production behavior rather than prompt advice:

1. **Typed impasse control** — when an active governed task genuinely cannot progress, classify the autonomous blockage as exactly one of `TIE`, `NO_CHANGE`, `REJECT`, or `CONFLICT`, create one bounded resolution subgoal, resolve through existing governed mechanisms, and resume/block the parent only from authoritative evidence.
2. **Goal-context working state** — temporary reasoning and work-product visibility follow the active goal/subgoal hierarchy; abandoned or stale child context cannot leak into siblings/parents unless explicitly promoted.
3. **Verified resolution compilation** — a successful, causally attributable impasse resolution may become reusable prepared procedural knowledge only after independent verification; prepared knowledge accelerates future work but never becomes authority.
4. **Application evidence** — production-connected benchmarks must prove first-encounter deliberation, recurrence reuse with less work, context pruning, invalidation, governance preservation, restart correctness, and non-vacuity.

Do this **inside DoubleTake's current architecture**. Do not build a Soar clone, second planner, second capability router, second memory system, second governance layer, second effect journal, second run-control state machine, or disconnected demo loop.

The implementation must preserve this invariant:

> DoubleTake may open cognitive resolution work only for a real autonomous blockage in an otherwise active/resumable task. Existing owner-controlled waits and terminal states remain owned by their canonical subsystem. A resolution child may affect the parent only through explicit evidence and authoritative parent re-observation. Learned/prepared resolution knowledge may reduce future deliberation but may never bypass current security, governance, run control, budgets, isolation, canonical execution, receipts, postconditions, rollback, or fresh evidence.

---

# 1. Live repository is authoritative

Repository:

`https://github.com/olejardamir/DT.git`

Observed convergence reference when this compact prompt was generated:

`9f99be3e5ddb80d2e77f13f19f04da11195239cb`

This SHA is a **reference, not a pin**. Re-read live `main` before every implementation pass.

The repository is intentionally edited by multiple agents on the same `main`.

Required shared-main protocol:

- read live `AGENTS.md` before changing code;
- record `pass_start_head`;
- re-read every file immediately before editing it;
- never `git reset`, history-rewrite, broad-restore, or discard another worker's changes;
- if HEAD moves, diff `pass_start_head..current_head`;
- re-trace/retest every mission-owned surface touched by that delta;
- never force-apply a stale patch over concurrent work;
- record `pass_end_head`;
- a clean pass is valid only when the validated surface did not change afterward, or all affected validation was rerun.

### Known baseline-red rule

At the observed reference, current `main` contains an intentionally exposed **pre-existing schema-versioning finding**: some workflow governed writes use `governance_status` for payloads that self-declare other artifact types, and the corresponding explicit schema suite reports a known failure. Do not "fix" unrelated concurrent work merely to make this mission's test output green.

Before implementation:

1. run the relevant baseline suites on current HEAD;
2. record pre-existing failures;
3. mission closure requires:
   - every cognitive-control test/benchmark green;
   - no new failures versus baseline in touched suites;
   - no required production dependency left broken;
4. a pre-existing unrelated failure is reported, not silently adopted;
5. if this mission's actual integration depends on the failing owner/path, then repair it through that owner's architecture and prove the repair; otherwise do not touch it.

---

# 2. Canonical owners — reuse, do not duplicate

Reinspect live equivalents of all paths below. Paths are guideposts; current `main` wins.

## 2.1 Project/task identity and ingress

- `tools/doubletake_evolve/project_evolution/models.py`
- `tools/doubletake_evolve/project_evolution/boundary.py`
- `tools/doubletake_evolve/workflows/self_upgrade.py`
- `tools/doubletake_evolve/workflows/_workflow_mixins/core.py`

`ProjectTask` / the live canonical task object owns task identity, repository binding, task revision/objective identity, and production handles.

Do not create durable cognitive state before a stable canonical run/task identity exists.

If `ProjectTask.bind_repository(...)` or equivalent refines an immutable task object while preserving live handles, verify that an attached `cognitive_session` still matches the new `(run_id, task/subject id, run_state_root, knowledge scope)` identity. Never silently retarget an already-bound session.

## 2.2 Meta reasoning

- `tools/doubletake_evolve/meta_reasoning/production.py`
- `session.py`
- `dispatch.py`
- `governance.py`
- `state.py`
- `artifacts.py`
- `budget.py`
- `stop.py`
- `steering.py`
- `interaction.py`
- `evidence.py`

Meta reasoning is the existing governed deliberation engine. Reuse it. Do not add another generic reasoning loop.

Preserve the live production authority chain:
- `MetaControlBoundary` / production seam;
- canonical run artifact/state/budget stores;
- current worker executor;
- current action registry;
- current control probe;
- current enforcement bundle;
- `governance_authorizer(...)`;
- dispatch write-ahead/reconciliation;
- STOP selection;
- task steering;
- user interaction;
- report verification.

Do not instantiate a private `MetaSession`/`Dispatcher` that omits the parent's live governance/control context.

## 2.3 Automatic capability participation

- `collective_core/capability_router.py`
- `collective_core/capability_participation.py`
- `collective_core/capability_execution.py`
- relevant `test_capability_*`

The router owns semantic relevance, compatibility, conflict suppression, composition and final routing records.

Cognitive control consumes the **final authoritative router/participation result**. It never reads raw semantic scores, stemmer internals, shadow channels or experimental retrieval signals as authoritative cognitive facts.

Current retrieval internals are actively evolving. Keep cognitive integration above that boundary.

## 2.4 Project evolution

- `project_evolution/evolution.py`
- `evaluation.py`
- `trial.py`
- `apply.py`
- `boundary.py`
- `learning.py`

`evolve_project()` owns candidate generation/evaluation/selection/recovery. Candidate trial isolation and hard gates stay authoritative.

## 2.5 Operator/run control

- `operator_controls/controller.py`
- `operator_controls/models.py`

Where a production path uses `OperatorController`, its:
- `RunControl`;
- pause/stop/block/resume/unblock;
- `check_before_effect(...)`;
- completed-effect guard;
- `check_promotion_allowed(...)`

remain authoritative.

Cognitive control never clears those states.

Important current-owner detail: `completed_effects` is presently coarse by **effect type**, even though `check_before_effect` accepts an effect digest. Treat it as a safety gate, **not** proof that one exact prepared attempt/effect completed.

## 2.6 Effect evidence / rollback

- `rollback_recovery/effect_journal.py`
- existing execution receipts / rollback records

Reuse canonical effect evidence. Do not create a second cognitive effect journal.

Important current-owner integrity finding: at the observed main, `_journal_from_dict(...)` computes stored/expected journal digests but does not compare them, and `ObservedEffect.from_dict(...)` can accept a stored `effect_digest` without recomputation.

Therefore **do not use EffectJournal as verified prepared-effect evidence until that owner is hardened** if this mission depends on it.

## 2.7 User interaction

- `meta_reasoning/interaction.py`
- `meta_reasoning/tests/test_meta_user_interaction_convergence.py`

Current owner behavior:
- `REQUIREMENT_USER_INPUT = "user_input"`;
- selected work declaring that requirement waits before reservation/dispatch;
- `UserInteractionJournal` permits at most one outstanding question in ordinary execution;
- blank, unknown, duplicate, authority-expanding, scope-expanding and governance-granting responses are refused;
- a real accepted response releases work on a later canonical cycle;
- waiting is not meta no-progress.

Cognitive control **observes** this owner. It does not answer questions.

## 2.8 Governed schema/writer ownership

- `schema_versioning/registry/`
- `_governed_writers.py`
- `_derived.py`
- governed API/tests

If a cognitive record is written through governed artifact I/O, register/derive/validate that document through the central schema/writer ownership rules. If it is private cognitive internal state, keep it private and version it there. Do not create duplicate schemas for one persisted shape.

## 2.9 Memory

- `enhanced_memory/working_memory.py`
- `enhanced_memory/long_term_memory.py`
- `enhanced_memory/cognition.py`
- `collective_core/memory.py`

At the latest inspected tree, `enhanced_memory.WorkingMemory` does not appear to be a load-bearing production context-delivery path. Re-check this.

Do not force it into production merely to say the mission changed memory. Production context isolation must be proven at actual delivered-context/artifact/state seams. Extend `enhanced_memory` compatibly only if it remains useful as an existing owner or current main has wired it.

## 2.10 Evaluation

Reuse:
- `evaluation_suite/`
- `behavioral_regression/`
- `benchmarks/benchcore/`
- `proofs/`
- default repository pytest collection policy from live `AGENTS.md`.

---

# 3. New package: a control spine, not a new executor

Create:

```text
tools/doubletake_evolve/cognitive_control/
    __init__.py
    models.py
    goal_context.py
    impasse.py
    resolution.py
    chunks.py
    session.py
    ports.py          # only if small typed ports improve ownership
    tests/
```

This package owns only:

- cognitive goal/subgoal state;
- exact impasse instances and resolution lineages;
- goal-context visibility metadata;
- bounded resolution-attempt claims;
- child→parent feedback;
- causal resolution traces;
- prepared-resolution/chunk metadata;
- small crash-reconciled state/outbox indexes.

It does **not** own:

- capability relevance/execution;
- generic planning;
- provider inference;
- project mutation/apply;
- security/governance;
- operator run state;
- budgets;
- trial creation;
- user answers;
- effect execution;
- rollback;
- final-output selection.

Those remain behind adapters/ports to current owners.

---

# 4. Closed vocabularies

## 4.1 ImpasseKind — exactly four

```text
TIE
NO_CHANGE
REJECT
CONFLICT
```

No `UNKNOWN`, `WAITING`, `CANCELLED`, `SUPERSEDED`, `PAUSED`, etc. as impasse types.

If classification evidence is insufficient, do not fabricate a type. Return unclassifiable/blocked/reobserve evidence outside `ImpasseKind`.

## 4.2 Goal status

```text
ACTIVE
RESOLVING
AWAITING_PARENT   # resolution child only
RESOLVED
BLOCKED
ABANDONED
```

Role semantics matter:

### ROOT
```text
ACTIVE -> RESOLVING
RESOLVING -> ACTIVE       authoritative progress, root not yet satisfied
ACTIVE/RESOLVING -> RESOLVED
                           only owner goal_satisfied=True
ACTIVE/RESOLVING -> BLOCKED
                           no legal continuation OR resumable external owner wait
BLOCKED -> ACTIVE/RESOLVING
                           only new authoritative resumable owner/state change
any nonterminal -> ABANDONED
                           canonical task/objective/run supersession/terminal cancellation
```

### RESOLUTION CHILD
```text
ACTIVE -> AWAITING_PARENT
                           candidate resolving evidence emitted
AWAITING_PARENT -> RESOLVED
                           causal parent ADVANCED consumed child feedback
AWAITING_PARENT -> ACTIVE
                           parent consumed feedback, did not advance,
                           another legal bounded attempt remains
ACTIVE/AWAITING_PARENT -> BLOCKED
                           child route exhausted/refused
ACTIVE/AWAITING_PARENT -> ABANDONED
                           parent superseded/advanced independently/owner terminal
```

For a child generation, `RESOLVED`, `BLOCKED`, `ABANDONED` are terminal.

A blocked child does not automatically block the parent. If the parent has another legal route, the parent returns `ACTIVE`.

## 4.3 TransitionOutcome.disposition

```text
NO_ACTION
RESOLUTION_REQUIRED
TRY_PREPARED
RESUME_PARENT
BLOCKED
STALE
STALE_REOBSERVE_REQUIRED
RECONCILIATION_REQUIRED
WAITING_EXTERNAL
OWNER_TERMINAL
```

`WAITING_EXTERNAL` and `OWNER_TERMINAL` are not impasses.

---

# 5. Core records

Use frozen/validated dataclasses or the repository's live equivalent. Persist only bounded machine-observable state, never hidden chain-of-thought.

## 5.1 GoalFrame

Required semantic fields:

```text
goal_id
role                    # ROOT | RESOLUTION
parent_goal_id
root_goal_id
problem_space_id
objective_digest
status
depth
revision
parent_revision_at_creation
parent_revision_bound
resolution_key
resolution_generation
current_impasse_id
resolution_target       # structured machine-readable target
created_at
updated_at
digest
```

Rules:
- parent/root graph acyclic;
- depth bounded;
- creation revision immutable;
- current parent binding may move only by legal rebase;
- root identity deterministic from canonical session/task/revision identity;
- resolution child identity deterministic from `(resolution_key, resolution_generation)`.

## 5.2 ControlObservation

```text
observation_id
source_fact_id
goal_id
task_revision
goal_revision_observed
source
source_stream_id
source_version_domain
source_state_version
source_event_ref
source_replay_token
state_key
outcome                 # ADVANCED | BLOCKED | NO_ADVANCE | FAILED | ...
goal_satisfied          # True | False | None
viable_option_ids
hard_rejected_option_ids
conflict_pairs
missing_requirements
evidence_refs
reason_codes
```

All lists bounded.

`goal_satisfied=True` is the **only** root-completion signal.

`source_fact_id` identifies the canonical owner fact.

`observation_id = digest(source_fact_id, goal/task/cognitive base revision)` identifies applying that fact against one cognitive base.

A stale-base observation is never applied directly. Return `STALE_REOBSERVE_REQUIRED`; the owner re-reads its current canonical state and emits a fresh observation.

High-water ordering is valid only within one stable `(source, source_stream_id, source_version_domain)`. Do not order hashes/timestamps as versions.

## 5.3 ImpasseRecord

```text
impasse_id
impasse_key
resolution_key
blocker_fingerprint
kind
goal_id
parent_goal_revision
state_key
normalized_blockers
operator_ids
source_observation_id
evidence_refs
reason_codes
status                  # OPEN | RESOLVED | BLOCKED | ABANDONED
created_at
closed_at
close_reason
digest
```

`ABANDONED` is the status for a superseded exact impasse. Do not invent `SUPERSEDED`.

## 5.4 ResolutionRequest

```text
request_id
goal_id
impasse_id
resolution_key
impasse_kind
structured_resolution_target
required_evidence
remaining_attempts          # snapshot only
remaining_reobservations    # snapshot only
execution_scope_ref
security_scope_digest
context_refs
```

The request is data, not execution authority.

The owner must still CAS-claim an attempt immediately before resolver work.

## 5.5 TransitionOutcome

```text
transition_id
goal_id
parent_revision
observation_id
disposition
impasse_id
resolution_request
prepared_chunk_id
evidence_refs
reason_codes
pending_reconciliation_kinds
resume_disposition
external_wait_kind
external_wait_ref
owner_terminal_kind
owner_terminal_ref
```

When `RECONCILIATION_REQUIRED`, withhold executable request/template data. Reconcile, then re-read state and derive a fresh outcome. Never execute old `resume_disposition`.

## 5.6 ResolutionTrace

```text
trace_id
resolution_attempt_id
attempt_ordinal
resolution_request_id
impasse_id
resolution_goal_id
child_goal_revision
parent_goal_revision
strategy_fingerprint
input_evidence_refs
operator_refs
intermediate_receipt_refs
feedback_id
progress_observation_ref
result_state_key
status
started_at
completed_at
digest
```

Status only:

```text
IN_PROGRESS
AWAITING_PARENT
CONFIRMED
FAILED
ABANDONED
STALE
```

Only `CONFIRMED` traces can seed executable prepared knowledge.

## 5.7 ResolutionFeedbackBundle

One-shot read-only handoff from child evidence to the parent evaluator.

```text
feedback_id
resolution_request_id
resolution_attempt_id
impasse_id
child_goal_id
parent_goal_id
parent_revision
child_revision
canonical_evidence_refs
execution_receipt_refs
consumed_by_observation_id
digest
```

It grants only one bounded parent re-observation.

It grants:
- no parent mutation authority;
- no generic context promotion;
- no submission eligibility;
- no worker-dispatch dependency before promotion.

A different later parent observation needs new feedback unless it is exact deterministic replay of the same observation.

## 5.8 ParentPromotionIntent

Crash-safe handoff between cognitive visibility and canonical artifact/final-output ownership.

```text
promotion_id
child_goal_id
parent_goal_id
parent_revision_before
parent_revision_after
source_artifact_refs
promoted_context_binding_ids
promotion_kind           # VISIBILITY_ONLY | PARENT_WORK_PRODUCT_ELIGIBILITY
canonical_promotion_ref
status                   # PREPARED | OWNER_COMMITTED | RECONCILED | REFUSED | STALE
digest
```

Cognitive binding alone never makes a child artifact STOP/final-output eligible.

For final eligibility, canonical owner creates a new parent-scoped promotion/work-product record. Do not mutate historical child provenance in place.

## 5.9 PreparedAttempt

Effect/idempotency state inside one semantic resolution attempt.

```text
attempt_id
resolution_attempt_id
chunk_id
core_digest
matcher_version
goal_id
resolution_generation
child_goal_revision
resolution_key
parent_revision
impasse_key
retry_context_digest
applicability_digest
execution_scope_ref
security_scope_digest
status
step_records
canonical_owner_refs
receipt_refs
digest
```

Status:

```text
PREPARED
INTENT_BOUND
EFFECT_POSSIBLE
COMPLETED
REFUSED
FAILED
AMBIGUOUS
STALE
```

`COMPLETED`, `REFUSED`, `FAILED`, `AMBIGUOUS`, `STALE` are terminal for that id.

A prepared attempt completing does **not** resolve the child. Parent acknowledgement is still required.

## 5.10 ResolutionChunk

Split immutable executable core from mutable evidence/history.

### Immutable core

```text
chunk_id
schema_version
matcher_version
scope_key
problem_signature
impasse_kind
preconditions
context_features
operator_sequence
argument_binding_schema
expected_effect
postconditions
dependency_digests
source_impasse_id
source_goal_id
trace_digest
core_digest
```

### Mutable record

```text
verification_refs
negative_applicability_refs
support_count
success_count
failure_count
status             # CANDIDATE | VERIFIED | INVALID | RETIRED
created_at
updated_at
last_verified_at
record_digest
```

Execution identity uses `core_digest`, not mutable counters/timestamps.

---

# 6. Identity model

## 6.1 Resolution lineage vs exact impasse

Use two ids:

```text
blocker_fingerprint
    stable adapter-owned normalized blocker identity excluding goal id

resolution_key
    digest(goal_id, resolution_key_version, blocker_fingerprint,
           stable target/authority/requirement identity)

impasse_key
    digest(resolution_key, parent_goal_revision, kind, state_key,
           normalized current blockers/options/requirements)
```

Rules:
- free-form model prose never defines these ids;
- same exact blocked observation -> same `impasse_key`;
- changed state/revision but same unresolved target -> new `impasse_key`, same `resolution_key`;
- same active lineage -> same child generation/budget;
- terminal child then recurrent same blocker -> same `resolution_key`, `resolution_generation + 1`, new child id;
- materially different blocker -> new `resolution_key`.

Persist last terminal generation so restart cannot reuse an old child id.

## 6.2 Recursive blocker guard

Before opening a nested child, compare `blocker_fingerprint` with active ancestor resolution lineages.

Same unresolved blocker + no decision-relevant new resolving path => `RECURSIVE_BLOCKER` evidence/no-progress against existing lineage, not a grandchild.

Nested goals are allowed only when the blocker is genuinely different and depth/budget remains.

## 6.3 Exactly one cognitive child / one semantic attempt

In this mission:

- exactly one active cognitive resolution child per parent;
- exactly one nonterminal semantic resolution attempt per child;
- no parallel sibling cognitive subgoals;
- no parallel semantic attempt claims.

Existing owners may parallelize safe sub-operations **inside one claimed attempt** under their own isolation/governance.

This deliberate serialization sharply reduces race/causality complexity.

## 6.4 Transition identity

`transition_id` must be deterministic from semantic transition identity:
- session id;
- transition kind;
- stable subject (`goal_id`, `impasse_id`, request id, resolution attempt id, feedback id, promotion id, prepared attempt id, etc.);
- owner `source_fact_id`/observation id when caused by an observation;
- semantic target state/reason where needed.

Never include:
- prior state digest;
- timestamp;
- process id;
- random publication id.

Prior state digest is a CAS precondition, not logical transition identity.

---

# 7. External waits and terminal owner states

Before impasse classification, adapters must check canonical owner state.

## 7.1 WAITING_EXTERNAL — resumable, no impasse

Examples:
- user input;
- paused run;
- operator-blocked run that can be unblocked;
- external approval wait where an existing owner/workflow exists.

Requirements:
- no `ImpasseRecord`;
- no `resolution_key`;
- no child;
- no resolution attempt;
- no prepared/chunk path;
- no attempt/reobserve budget charged merely because time passes;
- stable owner ref, not human wording.

Examples of stable refs:
- `UserRequest.request_digest`;
- RunControl state digest/version/decision id;
- approval request id/digest.

A later **owner event** may reactivate the root.

## 7.2 OWNER_TERMINAL — no autonomous continuation

Examples:
- terminal cancellation;
- STOPPED;
- SKIPPED;
- FAILED;
- non-extendable hard deadline/terminal owner stop.

Requirements:
- no cognitive impasse;
- no new child/attempt/prepared effect;
- reconcile already-issued/ambiguous effects;
- abandon/close active cognitive descendants;
- interrupted path does not compile into prepared knowledge;
- only a canonical new/resumed run/task/revision can make work runnable again.

## 7.3 Current user-input owner

When meta work declares `REQUIREMENT_USER_INPUT` and the journal has an unanswered request:

```text
TransitionOutcome.disposition = WAITING_EXTERNAL
external_wait_kind = USER_INPUT
external_wait_ref = request_digest
```

Never use `awaiting_subject` as identity.

Cognitive control never calls `respond(...)`.

A model/cognitive component passing `source="user"` is **not evidence that a person answered**. Only the existing trusted product/user ingress may author accepted responses.

### Owner hardening required if cognition relies on cross-process/crash correctness

At observed main:
- journal writes use a process-local `RLock` and direct `Path.write_text`;
- request/response readers accept stored digests without recomputation.

If the production cognitive path relies on those digests for durable cross-process wait identity, repair the **UserInteractionJournal owner**, minimally:

- verify request digest on read;
- verify response digest on read;
- verify run id;
- verify response references a real request;
- reject duplicate/conflicting response;
- atomic durable write using existing repository helper;
- real cross-process lock/CAS if multiple processes may touch one run;
- unreadable/torn/conflicting state => fail safe waiting/unavailable, never "answered".

Do not copy answers into cognitive state to hide an owner defect.

---

# 8. Typed impasse classification

Only classify after excluding `WAITING_EXTERNAL`/`OWNER_TERMINAL`.

Classification must be deterministic from owner/adapted machine-readable facts. An LLM may propose resolution work but does not decide the impasse type when runtime facts suffice.

## 8.1 TIE

Create only when:
- 2+ materially viable alternatives remain;
- authoritative ranking/preferences cannot distinguish them;
- arbitrary choice materially affects the goal.

Do not call composable capabilities a tie.

Resolve by acquiring a discriminator, bounded comparison/trial, or declared objective already supported by owner workflow.

## 8.2 NO_CHANGE

Create when:
- an attempted operator produced no required state advance;
- a required precondition/input is missing;
- repeated execution returns equivalent state with no new evidence;
- no legal operator can produce a specifically required parent effect.

Do not create from:
- ordinary capability `NO_MATCH` when no capability is needed;
- capability-level `repeat_suppressed` when parent work still advanced;
- user-input waiting;
- pause/operator wait;
- terminal stop/cancel.

## 8.3 REJECT

Create when:
- an otherwise required/viable operation is refused by a current decision authority such as security, approval, edit scope, rollback requirement or policy;
- the parent remains active/resumable;
- no other legal path advances it.

Do not create merely because:
- one optional candidate was rejected;
- the run is paused/cancelled/stopped;
- non-extendable resource/deadline owner semantics ended the run.

Resolution may seek a legal alternative or invoke an **existing legal approval/prerequisite workflow**. It never weakens/self-grants authority.

## 8.4 CONFLICT

Create when mutually incompatible current requirements/operators/authorities prevent progress.

Use owner conflict/exclusive-resource metadata where available.

Resolution may establish existing precedence, obtain discriminating evidence, or legally serialize operations. Never "resolve" by silently running incompatible actions.

## 8.5 Unclassifiable

If required evidence is absent, return unclassifiable/reobserve/blocked evidence outside `ImpasseKind`.

No fifth generic type.

---

# 9. Resolution lifecycle

Canonical flow:

```text
parent ACTIVE
  -> authoritative autonomous blocking observation
  -> typed OPEN exact impasse
  -> parent RESOLVING
  -> one active resolution child
  -> one CAS-claimed semantic resolution attempt
  -> existing governed owner does resolution work
  -> child candidate evidence
  -> child AWAITING_PARENT
  -> one-shot ResolutionFeedbackBundle
  -> canonical parent re-observation
       causal ADVANCED + child feedback consumed
           -> trace CONFIRMED
           -> child RESOLVED
           -> current impasse RESOLVED
           -> parent ACTIVE or RESOLVED iff goal_satisfied=True
       ADVANCED without child causal linkage
           -> child/impasse ABANDONED
           -> no chunk credit
       NO_ADVANCE + another legal child attempt
           -> prior trace terminal FAILED/non-resolving
           -> child ACTIVE
           -> next attempt ordinal through CAS
       child route exhausted
           -> child + exact impasse BLOCKED
           -> parent ACTIVE if another legal parent route exists
           -> parent BLOCKED only if owner proves no legal route remains
       same blocker + newer parent state
           -> old exact impasse ABANDONED(STATE_SUPERSEDED)
           -> reconcile/rebase same active child generation if legal
       different blocker/task supersession
           -> abandon old lineage
           -> successor only within remaining root budget
```

`RESOLVING` never means canonical task progress.

---

# 10. Resolution-attempt claim and start fence

`ResolutionRequest.remaining_attempts` is a snapshot, not a lease.

Expose a small API equivalent to:

```text
claim_resolution_attempt(
    request_id,
    strategy_fingerprint,
    expected_parent_revision,
    expected_child_revision
)
-> CLAIMED | ATTACHED_TO_EXISTING | STALE_REOBSERVE_REQUIRED | BLOCKED

begin_resolution_attempt(
    resolution_attempt_id,
    expected_parent_revision,
    expected_child_revision
)
-> START_AUTHORIZED | EVIDENCE_PENDING | ALREADY_STARTED |
   STALE_REOBSERVE_REQUIRED | BLOCKED
```

## 10.1 Claim

Under one cognitive CAS:

- allocate monotonic `attempt_ordinal`;
- derive `resolution_attempt_id = digest(child_goal_id, generation, ordinal)`;
- reserve/check child attempt budget;
- reserve/check root cumulative resolution-work budget;
- persist immutable strategy fingerprint;
- ensure no other nonterminal attempt exists.

`ATTACHED_TO_EXISTING` does not authorize a second worker. It tells the caller to observe/reconcile the existing attempt.

## 10.2 Start fence

Ordering is strict:

```text
claim
-> cognitive CAS RESERVED -> IN_PROGRESS
-> consume semantic attempt exactly once
-> enqueue/publish required control audit event
-> only then return START_AUTHORIZED
-> release lock
-> external owner/model/tool/capability/dispatch call
```

Never:

```text
claim -> external call -> later mark started
```

Crash semantics:
- crash while `RESERVED`: reuse/cancel same unconsumed slot;
- crash after `IN_PROGRESS` before owner call: attempt is conservatively consumed;
- never refund/rewind `IN_PROGRESS -> RESERVED`.

After owner exposes a durable work/intent/result id, attach it idempotently for reconciliation.

## 10.3 Restart reconciliation

Before any new work for a child:

- `RESERVED`: reuse/cancel same slot;
- `IN_PROGRESS` with owner ref: query/reconcile owner outside cognitive lock;
- `IN_PROGRESS` without owner ref:
  - read-only/provider result lost -> terminal FAILED(lost_result), attempt remains consumed;
  - possibly side-effecting -> fail closed unless owner can recover exact attempt/effect identity;
- `AWAITING_PARENT`: redeliver/reconcile same feedback; no next attempt.

Side-effecting production adapters without durable owner identity/reconciliation are not eligible for autonomous prepared execution.

## 10.4 Re-observation budget

Peer/CAS/stale refreshes that prove no semantic work started do not consume a semantic attempt, but they consume a **separate durable control-reobserve budget**.

That budget:
- is cumulative for the active lineage;
- does not reset per request, impasse instance, process restart or peer race;
- is CAS-protected;
- yields/pends rather than busy-loops when exhausted.

---

# 11. Safe rebase

Same `resolution_key`, new parent state/revision does not reset budget.

Atomically:
1. close old exact impasse as `ABANDONED(STATE_SUPERSEDED)` unless truly resolved/blocked;
2. open new exact impasse instance;
3. update child `parent_revision_bound`;
4. increment child revision;
5. preserve generation and cumulative budgets;
6. reconcile nonterminal attempt state before any new effect.

## 11.1 Safe in-place attempt rebind

Allowed only when:
- same resolution lineage;
- same strategy;
- same hard applicability;
- no revision-sensitive resolver result must be carried forward;
- canonical owner proves pre-effect/no-effect state.

`RESERVED` may rebind.

An `IN_PROGRESS` attempt may rebind only after owner proves it stopped before revision-sensitive output/effect boundary.

Linked `PreparedAttempt` may update binding fields while still `PREPARED` or safely pre-effect `INTENT_BOUND`.

Preserve:
- semantic `resolution_attempt_id`;
- ordinal;
- prepared `attempt_id`;
- applicability digest.

Do **not** mark it `STALE`.

## 11.2 Non-rebindable old attempt

If it:
- produced revision-sensitive reasoning/result;
- changed hard applicability;
- crossed `EFFECT_POSSIBLE`;
- has unknown effect state;

then:
- reconcile canonical owner;
- terminalize old attempt/trace as STALE/FAILED/AMBIGUOUS as appropriate;
- never resurrect it;
- next work requires next semantic ordinal if budget remains.

Cognitive staleness is not physical cancellation.

---

# 12. Goal-context visibility

Context visibility is separate from relevance and separate from authority.

Use:

```text
LOCAL
PARENT_VISIBLE
PERSISTENT
```

And a canonical `ContextBinding` equivalent to:

```text
binding_id
item_ref
owner_goal_id
owner_goal_revision
memory_lifetime
scope_key
promoted_to_goal_id
created_at
digest
```

Rules:
- `LOCAL`: only active owner goal/revision;
- `PARENT_VISIBLE`: not visible to parent until explicit promotion;
- `PERSISTENT`: eligible for durable memory only after validation/governance;
- closed/abandoned child LOCAL context is inaccessible to sibling/parent;
- rebase does not automatically carry all old child scratch context;
- vanished non-durable scratch on restart is not reconstructed by guessing.

### Never context-filter deterministic safety/control state

Goal projection must **not** hide:
- governance/security/approval facts;
- operator pause/stop/block;
- budget/deadline state;
- dispatch/effect ids;
- receipts/quarantine;
- already-performed-work markers;
- rollback/recovery;
- task revision/CAS facts.

Filter model/worker reasoning context, not canonical deterministic ledgers.

### Production delivery points

Prove isolation at actual live seams:
- meta compact-state / delivered artifact context;
- project-evolution trial/evidence context;
- capability execution inputs/outputs;
- workflow artifact/finalization context.

Do not count an isolated `enhanced_memory` unit test as production proof.

---

# 13. Child→parent evidence and causal attribution

A child result cannot resolve a parent directly.

Use `ResolutionFeedbackBundle` for one parent re-observation.

The parent observation records:
- consumed feedback id;
- resolution request id;
- consumed evidence refs.

Causality rules:

1. Parent ADVANCED without consuming child feedback:
   - independent/concurrent progress;
   - child ABANDONED;
   - no chunk/support credit.

2. Parent ADVANCED after consuming child feedback plus unrelated concurrent inputs, but owner cannot identify which caused progress:
   - parent progress is real;
   - child may close;
   - **no executable chunk** from ambiguous causality.

3. Chunk candidacy requires:
   - owner proof child resolution satisfied blocker/postcondition; or
   - independent replay/ablation/equivalent verification of sufficiency.

Timing/co-consumption alone is not causal evidence.

---

# 14. Typed working output promotion

Parent visibility and final-output eligibility are different authorities.

When child evidence is causally accepted:

1. cognitive CAS advances parent/context visibility and writes `ParentPromotionIntent`;
2. release cognitive lock;
3. if `VISIBILITY_ONLY`, complete binding transition;
4. if final-output eligibility is needed, canonical artifact/workflow owner creates one new parent-scoped work-product/promotion record;
5. parent finalizer/STOP selects only records its existing policy considers current and eligible.

Never mutate child artifact history in place.

Where `OperatorController` applies, promotion also passes `check_promotion_allowed(...)`.

Crash windows must be idempotent:
- cognitive intent before owner promotion;
- owner promotion before cognitive acknowledgement;
- retry with both present;
- task revision moved before owner promotion.

---

# 15. Prepared resolution compilation

## 15.1 Candidate creation

Compile only when:
- a real typed impasse existed;
- one child resolution attempt produced concrete evidence/action;
- parent later ADVANCED causally from it;
- trace is `CONFIRMED`;
- required causal lineage is explicit.

Do not compile:
- ordinary success with no impasse;
- external wait/terminal owner event;
- one-time human approval/answer;
- hidden chain-of-thought;
- opaque unverifiable free-form reasoning;
- stale/independent child result;
- ambiguous mixed causality;
- unreconciled/unknown side effect.

## 15.2 Causal backtrace

Work backwards from confirmed parent progress.

Keep only:
- pre-impasse facts actually required;
- stable operator/action identities;
- verified intermediate effects;
- resolving evidence;
- postconditions.

Exclude:
- abandoned branches;
- unrelated contemporaneous memory;
- random task ids;
- transient local paths;
- irrelevant prompt text.

## 15.3 Non-sensitive structural signature

Persistent `problem_signature` / chunk core contains only structural non-sensitive facts:
- impasse kind;
- normalized requirement/authority/operator/schema ids;
- stable structural feature ids;
- canonical opaque refs/digests.

Never persist:
- raw prompts;
- raw evidence;
- credentials;
- protected values;
- free-form private reasoning.

A plain unsalted hash of a low-entropy secret is not safe. Use existing opaque/keyed scope-owned representation or keep that value runtime-only.

## 15.4 Scope

Default persistent prepared-knowledge scope:

```text
digest(
    canonical non-secret repository identity,
    canonical compatible security/data-domain identity
)
```

Same repository alone does not imply cross-run confidentiality compatibility.

Do not include:
- commit SHA;
- transient trial path;
- one-time approval;
- mutable budget.

Those are current applicability/governance checks.

If stable repository + security scope cannot be established, keep candidate run-scoped and disable cross-run VERIFIED reuse.

---

# 16. Chunk verification

`CANDIDATE -> VERIFIED` requires:

1. original confirmed causal resolution evidence;
2. stable executable operator sequence, not hidden prose;
3. independent replay/equivalent positive evidence where replay is possible;
4. at least one negative/non-applicability case;
5. current security/governance checks;
6. relevant regressions/benchmarks;
7. recorded dependency/preimage/contract digests;
8. durable verification evidence/attestation usable across runs.

If independent verification is impossible, remain `CANDIDATE`.

Persistent VERIFIED status cannot outlive its proof. On load/reuse:
- revalidate required attestation/evidence refs;
- missing/corrupt/expired proof -> refuse/demote/reverify;
- never trust status bit alone.

If safety-significant invalidation cannot be persisted:
- refuse chunk in current run;
- quarantine affected knowledge store/scope from automatic prepared reuse;
- do not let a later task reload stale on-disk VERIFIED and execute it;
- resume only after durable repair/reconciliation.

Fresh current evidence always outranks learned history/support count.

---

# 17. Prepared reuse and effect identity

Lookup before expensive resolution deliberation.

Use signature-sharded/bounded lookup:

```text
<knowledge_root>/cognitive_control/chunks/
    <scope_digest>/
        <problem_signature_digest>/
            <chunk_id>.json
```

or equivalent integrity-protected bounded index.

Ordinary lookup must be O(bounded candidates for one signature), not O(all history).

Before reuse:
- schema/matcher version current;
- scope compatible;
- hard preconditions true;
- dependency/preimage/contract digests current;
- execution/trial isolation current;
- security/data scope compatible;
- owner run control current;
- hard governance/approval passes;
- verification proof still valid.

## 17.1 Prepared attempt id

Compute `applicability_digest` from the actual current hard applicability facts.

Then:

```text
attempt_id = digest(
    chunk_id,
    core_digest,
    matcher_version,
    child_goal_id,
    resolution_key,
    applicability_digest,
    retry_context_digest,
)
```

Do not include:
- parent revision;
- child revision;
- exact impasse instance;
- mutable chunk counters/timestamps.

Those are binding fences, not effect identity.

A new id requires:
- changed hard applicability;
- new child generation;
- or canonical owner-supplied stable retry context after a legal recovery.

Cognitive control cannot mint arbitrary retry ids.

## 17.2 PreparedAttempt state

```text
PREPARED
  -> INTENT_BOUND
  -> EFFECT_POSSIBLE
       -> COMPLETED | REFUSED | FAILED | AMBIGUOUS

PREPARED -> REFUSED | FAILED | STALE
INTENT_BOUND -> REFUSED | FAILED | STALE
```

Terminal states never return to runnable states.

Safe pre-effect rebind updates binding fields while status remains pre-effect; it does not pass through STALE.

Multi-step resolution is complete only when all required steps and sequence postcondition verify.

## 17.3 Canonical executor remains mandatory

A chunk can suggest an operator sequence; it cannot execute it directly.

Every step still passes the same:
- schema/contract checks;
- run control;
- security/governance;
- approval;
- isolation;
- budget/deadline;
- canonical executor;
- effect receipts;
- postconditions;
- rollback/recovery.

---

# 18. Live effect-owner caveats

## 18.1 Meta dispatch

Do not treat:
- `dispatch_work_key` as exact cognitive effect-attempt identity;
- cycle/proposal-scoped `dispatch_effect_key` as automatically one-to-one with a prepared attempt across re-decision.

If side-effecting prepared reuse runs through meta dispatch, add/reuse an **owner-owned durable external-attempt binding** mapping cognitive `attempt_id`/step to canonical dispatch/effect records before effect-possible execution.

If no such binding exists, refuse side-effecting prepared meta reuse and fall back to ordinary deliberation.

If cognitive meta resolution introduces different trial/preimage/security contexts under one task revision, extend the **owner's** work identity with stable non-secret context/preimage digest if necessary. Do not defeat repeat suppression with cosmetic ids/prose.

## 18.2 OperatorController

Always obey `check_before_effect(...)`.

But current `completed_effects` type membership is only a coarse safety gate. It is not exact `PreparedAttempt.COMPLETED` evidence.

If distinct same-type effects must be supported and this gate otherwise over-blocks them, fix the owner with backward-compatible exact effect identity/migration. Never bypass the gate from cognitive code.

## 18.3 EffectJournal

Before cognition uses it as authoritative evidence, harden owner verification if live main still lacks it:

- verify journal schema;
- recompute/compare `journal_digest`;
- verify `effect_count`;
- recompute/compare every `ObservedEffect.effect_digest`;
- verify run/issue identity needed by caller.

Tampered/mismatched journal => fail closed.

Random journal id is never prepared attempt id.

---

# 19. Persistence model

## 19.1 Separate run state from cross-run knowledge

```text
run_state_root
    active GoalFrame / Impasse / ContextBinding / attempts / outbox

knowledge_root
    persistent ResolutionChunk records/index
```

Never infer `knowledge_root` by `run_state_root.parent`, cwd or home.

Use canonical persistent-state configuration/owner.

If stable knowledge root is unavailable, disable cross-run VERIFIED reuse.

## 19.2 CognitiveStateStore

Example:

```text
<run_state_root>/cognitive_control/<session_id>/state.json
```

Store only bounded active/reconstructable state:
- active goals;
- open impasse instances;
- lineage generation counters/tombstones;
- context bindings;
- attempt/feedback/promotion records;
- source ingestion high-water;
- small unpublished evidence outbox;
- canonical refs, not copied evidence bodies.

Closed bulky history belongs in canonical evidence/artifact stores. Retain minimal tombstones needed for generation/idempotency.

## 19.3 Atomicity

Use existing durable writer semantics.

Requirements:
- file flush/fsync + atomic replace + parent-dir fsync where supported;
- strict schema/version;
- canonical digest;
- cross-process lock/CAS;
- no external callback while state/chunk lock held;
- no process-local lock fallback while claiming multi-agent safety;
- unknown newer schema fails closed;
- migration deterministic/idempotent under version fence/lock.

If platform cannot supply required cross-process atomicity, disable mutating cognitive behavior; do not silently downgrade to last-write-wins.

---

# 20. Canonical evidence outbox

Cognitive state CAS and canonical audit publication are separate stores.

Protocol:

1. derive deterministic semantic `transition_id`;
2. cognitive CAS writes transition + bounded outbox entry atomically;
3. release lock;
4. publish canonical non-submission control event idempotently;
5. CAS evidence ref back into cognitive state;
6. retire payload when safe.

Cognitive control events are **never final deliverables**.

If required audit publication is pending:
- return `RECONCILIATION_REQUIRED`;
- do not expose executable resolution/prepared action;
- do not issue a new cognitive-generated effect.

Bound:
- pending outbox;
- total cognitive control-event production per run.

Reserve capacity for mandatory terminal/reconciliation/cancel/promotion truth before admitting new attempts.

---

# 21. RunArtifactStore sequence crash gap

At observed main, `RunArtifactStore.put(...)` allocates commit sequence before final artifact write. A crash can leave a sequence hole that correctly stalls safe cursor advancement.

Do not claim crash safety by adding only a wrapper lock.

If cognitive events rely on this store, extend/reuse the **store owner** with idempotent crash-reconciled event commit:

- deterministic artifact/event id;
- cross-process lock;
- durable reservation/transaction metadata;
- reservation before claimed sequence becomes authoritative;
- recover crash before body write;
- recover crash after body write before finalization;
- duplicate publisher coalesces without extra sequence;
- unresolved reservation stalls safely;
- no guessing/fabricating event body.

Do not manipulate private `_seq_path` from `cognitive_control`.

Legacy unexplained hole without durable reservation proof:
- report canonical repair required;
- do not synthesize tombstone/history;
- do not skip it.

The current store's process-local fallback after lock failure is **not** sufficient for cognitive multi-process event commit. Cognitive path fails closed if real lock/transaction cannot be obtained.

---

# 22. Canonical source ingestion

Every restart-safe state-changing observation must be recoverable from its owner:

- durable `source_event_ref`; or
- comparable owner version/replay token; or
- deterministic current-state re-observation.

Cognitive state must never be the only surviving evidence that the owner reported a fact.

Maintain bounded per-source high-water/cursor.

On session construction/resume:
1. reconcile owner events/current snapshot since cognitive high-water;
2. page/bound the work;
3. issue no cognitive resolution/prepared effect while backlog remains;
4. persist cursor only through successfully ingested facts.

If owner snapshot can safely collapse history, prove no idempotency/effect/control fact is lost.

Owner event committed then process crashes before cognitive CAS => restart must catch up before child work resumes.

---

# 23. Project-evolution integration

Integrate at the live `evolve_project()` lifecycle, not a shadow planner.

Use canonical observations for:
- new work;
- candidate set;
- plan change;
- verification;
- candidate failure;
- new evidence;
- recovery;
- all legal candidates refused;
- selection success.

Rules:
- one cognitive root per bounded evolution task;
- candidate evaluation remains authoritative;
- hard rejection of all legal required routes may create `REJECT`;
- materially equal candidates that truly need a discriminator may create `TIE`;
- failure/no progress may create `NO_CHANGE`;
- fresh measured candidate evidence outranks chunks/lessons;
- learned resolution cannot manufacture a promotable hard-gate failure.

### Trial isolation

A cognitive resolution opened inside candidate evaluation inherits the parent's canonical `execution_scope_ref`.

Resolution work:
- stays in same/fresh owner-created disposable trial;
- never mutates authoritative repo root directly;
- returns new code change as candidate through normal trial/gate/apply path;
- does not recreate trial workspaces itself;
- after restart, destroyed trial path is never blindly reused;
- changed preimage/isolation changes applicability.

Self-upgrade's real `evolve_project()` call is a production reachability target.

Bind canonical run/task identity before durable cognitive state.

---

# 24. Capability-participation integration

Do not rewrite routing.

Adapt only final participation facts.

Possible autonomous impasse evidence:

### Missing required input
If a materially selected capability reports missing input **and parent requires the effect**, `NO_CHANGE` may open.

### Executed but no contribution/failure
If selected capability actually ran but parent remains blocked, `NO_CHANGE` may open.

Do not mark successful merely because dispatch happened.

### Conflict
A router-declared materially blocking conflict may support `CONFLICT`.

### NO_MATCH
Ordinary NO_MATCH is non-impasse unless parent owner independently proves a required capability/effect is missing.

### Capability repeat suppression
Capability-level `repeat_suppressed` is not meta work no-progress by itself.

If a new parent work item/evidence was produced, cognitive control must not call the parent stalled merely because one capability was correctly suppressed as already used.

### Child execution ownership
If capability execution is used as child resolution work, bind active child/run/isolation/security ownership before output/effect commit through a runtime-owned opaque token/owner seam.

Do not put ownership in free-form capability arguments.

---

# 25. Meta-reasoning integration

Use only the canonical production seam.

## 25.1 Governance

At current main, `MetaControlBoundary.build_session(...)` accepts an enforcement bundle and constructs dispatch with `governance_authorizer(...)`.

Cognitive resolution:
- uses same enforcement bundle;
- same registry/effect derivation;
- same budget;
- same worker executor;
- same control probe;
- same artifact store.

Authorization refs are provenance, not a substitute for the authorizer.

Missing/unwired governance substrate is integration unavailability, not a fabricated policy REJECT.

## 25.2 Duplicate work

Preserve canonical:
- `dispatch_work_key`;
- performed-work scan/record;
- repeat suppression.

Do not evade by changing proposal id, rationale or cognitive id.

If same prior result remains valid/visible in current context, it may supply existing evidence without re-execution.

If prior result is stale/invisible/wrong security/isolation context, suppression itself is not progress.

## 25.3 No-progress

Current main's meta no-progress means work-level exhaustion/repetition.

Do not conflate with capability participation repeat suppression.

Cognitive continuation cannot reset unchanged no-progress by constructing a fresh empty meta session.

## 25.4 User waiting

Current owner blocks user-dependent proposal before reservation/intent.

Adapt unanswered journal request to `WAITING_EXTERNAL(USER_INPUT, request_digest)`.

Waiting:
- is not STOP;
- is not meta no-progress;
- is not NO_CHANGE;
- consumes no cognitive attempt merely for elapsed time.

Accepted response triggers later canonical re-evaluation. Response text does not itself prove parent progress.

## 25.5 STOP

STOP/forced stop belongs to meta owner.

A STOP-selected artifact or forced stop is not automatically parent `ADVANCED`/`goal_satisfied`.

Parent owner consumes/evaluates result and emits `ControlObservation`.

---

# 26. Operator-control integration

Where applicable:

- re-read run control before every new prepared/resolution effect;
- pause/resumable operator block -> `WAITING_EXTERNAL`;
- cancel/STOPPED/SKIPPED/FAILED -> `OWNER_TERMINAL`;
- never turn owner hold into cognitive REJECT;
- resume/unblock only through owner transition;
- parent promotion passes `check_promotion_allowed(...)`;
- effect passes `check_before_effect(...)`.

Do not let cognitive state clear operator control.

---

# 27. Report/schema evidence integrity

## 27.1 RunReport

At latest observed main, `RunReport.verify_report(...)` re-derives fields in `CYCLE_CLAIM_FIELDS`, currently including dispatch/quarantine/work-repeat/fault/stop/cancel/pause/decision-digest claims.

It does **not** presently re-derive `awaiting_user`, `awaiting_subject`, or `no_progress`.

Therefore:
- do not use those report fields as authoritative cognitive facts while unverified;
- either read canonical interaction/session/work owner directly;
- or extend report builder + verifier + tests in the same patch.

## 27.2 Governed writer registry

Any new cognitive artifact routed through governed write API must:
- have one owning schema/model;
- be registered/derived;
- satisfy live governed-writer discovery guard;
- survive schema shape/derivation sabotage test.

Private cognitive state records remain private; do not register them redundantly.

---

# 28. Prepared reuse metrics

Record from real evidence:

```text
impasses_total
impasses_by_kind
impasses_resolved
impasses_blocked
external_waits
owner_terminal_events
resolution_children_created
resolution_depth_max
resolution_attempts_started
resolution_attempts_failed
reobservations_used
duplicate_impasses_suppressed

chunks_candidate
chunks_verified
chunks_reused
chunks_refused
chunks_invalidated
chunk_reuse_success_rate

prepared_resolution_hits
deliberation_steps
resolution_attempts
operators_considered
operators_executed
time_to_resolution
```

No vanity metrics.

---

# 29. Required whole-system benchmark pack

Create:

```text
benchmarks/cognitive_control/
    README.md
    manifests/
    fixtures/
    evidence/
    tests/

proofs/cognitive_control_application_proof.py
```

Reuse existing harnesses.

All mutating benchmarks use disposable repository/trial/run/knowledge roots. Never contaminate authoritative repo state or real persistent knowledge.

## A — first encounter and cross-run recurrence

Run 1:
- real `NO_CHANGE`;
- normal resolution;
- confirmed parent progress;
- candidate chunk;
- independent verification -> VERIFIED.

Run 2:
- fresh process/session;
- structurally equivalent task, changed incidental ids;
- load chunk from persistent `knowledge_root`;
- current gates all rechecked;
- equal/better correctness/evidence;
- measurably fewer deliberation steps/attempts.

No in-memory Run-1 object may make Run 2 pass.

## B — stale dependency invalidation

Change required dependency/preimage/contract/security condition.

Prove prepared chunk refused/invalidated and ordinary deliberation resumes.

If invalidation persistence fails, store scope is quarantined from auto-reuse.

## C — context pruning

Child A:
- LOCAL scratch;
- PARENT_VISIBLE evidence;
- PERSISTENT verified evidence.

Close/abandon A, start sibling B.

Prove:
- LOCAL inaccessible;
- only explicit promotion visible;
- persistent valid evidence available;
- deterministic safety/receipt/control ledgers still visible.

## D — four impasse types

Real fixtures for:
- TIE;
- NO_CHANGE;
- REJECT;
- CONFLICT.

For each:
- detection before arbitrary/illegal effect;
- deterministic classification from persisted facts;
- one child;
- bounded resolution;
- parent resumes only from authoritative evidence;
- unresolved case blocks honestly.

## E — governance cannot be bypassed

Previously VERIFIED sequence now denied by current governance/operator control.

Prove:
- lookup may find it;
- canonical gate refuses it;
- no direct effect;
- no false success.

## F — project evolution

Real bounded `evolve_project()`:
- candidate failure/refusal;
- typed impasse;
- isolated recovery;
- new evidence/alternative;
- parent resumes;
- normal selection/hard gates/apply.

Authoritative root stays unchanged until existing apply authority acts.

## G — restart matrix

Cover:
- open impasse;
- rebased lineage;
- RESERVED attempt;
- IN_PROGRESS with owner ref;
- IN_PROGRESS lost read-only result;
- IN_PROGRESS side-effecting without recoverable owner identity;
- AWAITING_PARENT;
- feedback;
- promotion;
- source-ingestion backlog;
- VERIFIED chunk proof reload.

No duplicate effects/children/budget reset.

## H — concurrency

Cover:
- identical impasse observation race;
- different impasse instances, same `resolution_key`;
- recurrence generation allocation;
- attempt claim race;
- shared root budget race;
- stale source observation/CAS reobserve;
- exactly one sibling child.

## I — external waits and owner terminal states

Cover:
- user input;
- pause;
- operator block;
- cancellation;
- STOPPED;
- SKIPPED;
- FAILED;
- terminal deadline/resource owner state.

Prove only resumable waits use `WAITING_EXTERNAL`, terminal uses `OWNER_TERMINAL`, neither creates impasse/attempt/chunk.

## J — user interaction integrity

If production cognition depends on interaction journal cross-process durability:
- verify request/response digests;
- tamper digests/linkage;
- race ask/respond writers;
- crash during write;
- prove at most one canonical outstanding request/accepted response;
- prove cognitive/model code cannot synthesize accepted user response.

## K — effect-owner integrity

- tamper EffectJournal document digest;
- tamper one effect body but retain old effect digest;
- prove refusal;
- prove random journal id not attempt id;
- prove coarse OperatorController type gate is respected but not exact completion evidence.

## L — prepared-attempt crash windows

Inject crash:
- before claim;
- after claim before start;
- after IN_PROGRESS audit start fence;
- after owner intent bind;
- after effect-possible boundary;
- after receipt before cognitive update;
- after child feedback before parent observation.

Prove at-most-once effect semantics or safe ambiguity quarantine.

## M — evidence/outbox/store crash

Cover:
- cognitive state committed before audit;
- audit committed before cognitive acknowledgement;
- artifact sequence reservation crash;
- duplicate event publication;
- unexplained legacy hole;
- source owner commit before cognitive CAS;
- paged source backlog.

## N — parent promotion

Crash at every cross-store promotion boundary.

Prove no child artifact becomes final-eligible from cognitive binding alone and no duplicate promoted record appears.

## O — causal attribution

- another agent advances parent without child feedback -> no child credit;
- mixed child + concurrent evidence with ambiguous causality -> no executable chunk;
- replay/ablation later establishes sufficiency -> chunk candidacy may proceed.

## P — no-progress and duplicate-work truth

Prove:
- same meta work suppressed;
- valid prior result reusable only when current context permits;
- capability-level repeat suppression does not equal parent/meta no-progress;
- unchanged meta no-progress cannot be reset by fresh session.

## Q — collection/schema/report evidence

Prove:
- new tests appear in default `pytest --collect-only`;
- collection guard fails if removed;
- load-bearing report fields are re-derived;
- governed writers are registered/derived;
- private records do not bypass their own schema/version checks.

---

# 30. Required focused test families

Do not rely on the benchmark alone.

At minimum cover:

### Goal/lineage
- acyclic hierarchy;
- depth bound;
- one child per parent;
- generation recurrence;
- same blocker rebase no budget reset;
- recursive blocker guard;
- parent change abandons descendants.

### Classification
- each of four types;
- ordinary NO_MATCH non-impasse;
- capability repeat suppression non-impasse when parent advances;
- user wait non-impasse;
- owner terminal non-impasse;
- unclassifiable evidence does not invent type.

### Attempt control
- CAS claim;
- exactly one nonterminal attempt;
- root cumulative budget;
- start fence before owner call;
- restart reconciliation;
- reobserve bound;
- safe pre-effect same-id rebind;
- revision-sensitive output prevents rebind.

### Context
- LOCAL hidden after close;
- explicit promotion;
- stale revision context hidden;
- safety/receipt/control ledgers remain available;
- restart missing scratch forces re-observation.

### Feedback/causality
- one-shot feedback;
- child waits for parent;
- independent parent progress not credited;
- mixed causality withheld;
- no chunk before confirmed trace.

### Prepared/chunks
- deterministic immutable core;
- verification required;
- negative applicability;
- cross-run reload;
- stale dependency invalidation;
- proof retention;
- quarantine on invalidation-write failure;
- signature-bounded lookup;
- sensitive identity exclusion.

### Persistence/concurrency
- cross-process lock required;
- schema version fence;
- old->new migration;
- outbox idempotency;
- source high-water;
- artifact sequence crash;
- no callbacks while locks held.

### Owner integration
- canonical meta governance;
- duplicate-work preservation;
- user interaction integrity;
- operator-control gates;
- EffectJournal integrity if used;
- report verifier;
- governed-writer registry.

Do not weaken existing tests.

---

# 31. Non-vacuity requirements

Every major mechanism must be load-bearing.

Use throwaway worktrees/fixtures/monkeypatches to disable one mechanism at a time and require the relevant benchmark/test to fail.

At minimum sabotage:

1. typed classifier -> D fails;
2. collapse four types -> type-specific D fails;
3. make NO_MATCH an impasse -> classification test fails;
4. convert user wait into NO_CHANGE -> I/J fail;
5. convert owner terminal to WAITING_EXTERNAL -> I fails;
6. disable context pruning -> C fails;
7. hide safety/receipt ledger with context filter -> C/L fails;
8. allow second sibling child -> H fails;
9. allow second nonterminal attempt -> H fails;
10. reset attempt/root budget on state change -> H fails;
11. issue owner call before start fence -> L fails;
12. stale-base observation directly applied -> H/M fails;
13. disable feedback causality -> O fails;
14. compile on temporal correlation -> O fails;
15. candidate chunk executable before verification -> A/E fail;
16. remove negative applicability -> B fails;
17. remove dependency invalidation -> B fails;
18. trust stale VERIFIED after invalidation-write failure -> B fails;
19. bypass canonical governance/operator control -> E/I/K fail;
20. execute chunk directly instead of canonical executor -> E/L fail;
21. use random/new attempt id to evade ambiguity -> L fails;
22. treat coarse effect-type gate as exact completion -> K fails;
23. trust tampered EffectJournal -> K fails;
24. fabricate user response -> J fails;
25. shadow-copy user answer into cognitive store -> J fails;
26. drop audit outbox transition -> M fails;
27. allow effect while required audit publication pending -> M/L fails;
28. skip artifact sequence hole -> M fails;
29. use process-local lock as multi-process CAS -> H/M fails;
30. scan all chunk history on every lookup -> performance test fails;
31. mutate authoritative root from project trial resolution -> F fails;
32. make child artifact final-eligible by cognitive binding alone -> N fails;
33. omit new tests from default collection -> Q fails;
34. route governed cognitive artifact through unregistered schema/writer -> Q fails;
35. remove real production wiring but leave new package/unit tests -> end-to-end proof fails.

A guard that passes with its mechanism removed is not evidence; fix the test/design.

---

# 32. Performance / boundedness

The cognitive layer must not make ordinary work expensive.

Required bounds:
- max goal depth;
- one active child per parent;
- one nonterminal semantic attempt per child;
- per-child attempts;
- root cumulative attempts/work;
- control re-observations;
- source catch-up page;
- outbox;
- control events/run;
- context refs;
- classification option/conflict refs;
- chunk candidates/signature;
- retained active chunks/signature;
- prepared sequence length.

Fast path on an unblocked task:
- no model call added solely for impasse classification;
- no full chunk-store scan;
- no global memory scan;
- no project mutation;
- negligible deterministic overhead.

If an owner returns more decision-relevant facts than the bounded observation can represent, do not classify from a misleading truncated prefix. Use owner-bounded projection + complete-set digest/ref, bounded paging, or remain unclassifiable.

---

# 33. Evidence rules

Persist machine-observable facts sufficient to answer:

```text
What parent goal was blocked or waiting?
Who owns that state?
Was it external wait, owner terminal, or autonomous impasse?
What exact owner fact caused the classification?
Which operators/options existed?
Which were refused/suppressed and why?
What child/attempt was created?
What owner work actually started?
What evidence/result came back?
What feedback did the parent consume?
Did the parent advance?
Was child causally responsible?
Was a chunk created/verified/reused?
Did current governance/run control approve the actual effect?
What was reconciled after crash/restart?
```

Do not persist private chain-of-thought.

---

# 34. Implementation order

## Phase 0 — baseline and live map

- read `AGENTS.md`;
- record current HEAD;
- baseline touched test suites and known pre-existing failures;
- trace production paths end-to-end;
- identify actual run/task/state/knowledge/evidence owners;
- confirm which memory path is production-connected;
- confirm which production paths use OperatorController/effect journal/user interaction/schema governed writers.

## Phase 1 — models and state store

Implement:
- records/vocabularies;
- deterministic identity;
- run-state store;
- cross-process CAS;
- schema/version migration;
- bounded outbox;
- owner ports.

No production behavior yet.

## Phase 2 — context + classification

Implement:
- goal context;
- visibility projection;
- external wait / owner terminal discrimination;
- four typed impasses;
- exact impasse/lineage identities;
- recursive blocker guard.

## Phase 3 — attempt lifecycle

Implement:
- claim;
- start fence;
- one attempt;
- root budget;
- restart reconciliation;
- safe rebase;
- feedback;
- parent acknowledgement.

## Phase 4 — crash-safe evidence/source reconciliation

Before any cognitive-generated effect:
- canonical event publication safe/idempotent;
- source catch-up safe;
- pending reconciliation yields `RECONCILIATION_REQUIRED`.

Repair owner artifact-store event commit if necessary; do not paper over its sequence crash window.

## Phase 5 — production wiring

Wire minimally into:
- capability participation;
- project evolution;
- meta production path;
- self-upgrade/live workflow path;
- applicable operator-control/effect owners.

Prove real reachability.

## Phase 6 — owner integrity repairs required by actual wiring

Only if the mission relies on them:
- harden UserInteractionJournal integrity/concurrency;
- harden EffectJournal digest verification;
- extend OperatorController exact effect identity if necessary;
- extend meta work context identity if necessary;
- extend report verifier if cognition/report relies on new fields;
- register new governed writer/schema if needed.

Repair the owner, not a cognitive shadow subsystem.

## Phase 7 — chunks

Implement:
- causal compile;
- verification;
- persistent proof;
- signature-sharded lookup;
- governed reuse;
- invalidation/quarantine.

## Phase 8 — benchmark/proof pack

Implement A-Q.

## Phase 9 — test collection

Prove default test collection sees all certifying tests.

## Phase 10 — adversarial closure

Run two different final passes:
1. architecture/reachability/authority pass;
2. restart/concurrency/governance/causality pass.

---

# 35. Convergence loop

Repeat until stopping condition is true:

1. read current HEAD and `AGENTS.md`;
2. diff since last pass;
3. re-trace affected ownership seams;
4. identify the single highest-value remaining material defect;
5. add/strengthen a test that fails for it;
6. implement the smallest owner-coherent repair;
7. run focused test;
8. run affected regressions;
9. run relevant whole-system benchmark;
10. sabotage the mechanism and prove the evidence fails;
11. re-check:
    - duplicate authority;
    - dead/inert code;
    - hidden execution bypass;
    - false impasse;
    - owner-wait misclassification;
    - stale result;
    - budget reset;
    - lock/CAS downgrade;
    - crash split-write;
    - context leak;
    - causal miscredit;
    - stale prepared knowledge;
    - governance/run-control bypass;
    - trial isolation escape;
    - schema/report evidence gap;
    - test not collected;
12. if a material defect remains, fix it and repeat.

Do not stop because:
- code compiles;
- new unit tests pass;
- documentation looks complete;
- a feature exists only behind manual registration;
- a model says it seems correct.

---

# 36. Stopping condition

Stop only when all are demonstrated on the **final live HEAD**:

## Production reachability
- [ ] Default production wiring creates/binds cognitive session automatically where supported.
- [ ] At least one real capability path, one real project-evolution path, and one real governed workflow/meta path exercise cognitive control.
- [ ] Removing production wiring makes an end-to-end proof fail.

## Owner correctness
- [ ] Existing routers, project evolution, governance, operator controls, user interaction, effect ownership and finalizers remain authoritative.
- [ ] No second generic planner/router/memory/governance/run-control/effect system exists.
- [ ] Canonical user/operator waits and terminal states are not autonomous impasses.

## Impasses
- [ ] Exactly four impasse kinds.
- [ ] All four arise from real runtime facts in tests.
- [ ] Correct NO_MATCH is non-impasse.
- [ ] Capability repeat suppression alone is non-impasse/no-progress when parent work advanced.
- [ ] Exact impasse vs stable resolution lineage identities are distinct.
- [ ] Same blocker rebase does not reset budget.
- [ ] Terminal recurrence increments generation.
- [ ] Recursive blocker cannot form a subgoal tower.

## Goal/context
- [ ] Exactly one active cognitive child per parent.
- [ ] Child-local context disappears after close/abandon.
- [ ] Explicit promotion works.
- [ ] Safety/control/effect ledgers are never hidden by context projection.
- [ ] Stale child cannot mutate/promote to current parent.

## Attempts
- [ ] Exactly one nonterminal semantic attempt per child.
- [ ] Attempt/root budgets CAS correctly under concurrency.
- [ ] `begin_resolution_attempt` consumes attempt before any external resolver call.
- [ ] Restart reconciles all nonterminal attempt states.
- [ ] Re-observation budget is separate, durable and bounded.
- [ ] Safe pre-effect rebase preserves identity only under proven safe conditions.
- [ ] STALE/AMBIGUOUS prepared records cannot be resurrected.

## Parent causality
- [ ] Child evidence goes through one-shot parent feedback.
- [ ] Parent alone determines progress/completion.
- [ ] Independent concurrent parent progress gives no child/chunk credit.
- [ ] Ambiguous mixed causality withholds executable chunk.
- [ ] Only confirmed causal trace seeds chunk candidacy.

## Prepared knowledge
- [ ] Candidate cannot execute as VERIFIED.
- [ ] Positive + negative verification evidence exists.
- [ ] Persistent VERIFIED proof survives fresh-process reload.
- [ ] Fresh evidence/hard gates override history.
- [ ] Failed invalidation persistence quarantines auto-reuse.
- [ ] Lookup bounded by problem signature.
- [ ] Cross-run reuse partitioned by repository + compatible security/data scope.
- [ ] Persistent signature/core contains no raw sensitive data or reversible low-entropy secret hash.

## Execution/governance
- [ ] Chunk execution uses canonical executor only.
- [ ] Current security/governance/operator control always rechecked.
- [ ] Project-evolution resolution cannot escape trial isolation.
- [ ] Side-effecting prepared path has durable exact owner attempt/effect binding or is refused.
- [ ] Coarse operator effect-type guard is never mistaken for exact attempt completion.
- [ ] EffectJournal evidence is authoritative only after real digest/count/effect verification if used.

## External waits
- [ ] User wait uses canonical request digest, not subject wording.
- [ ] Cognitive/model code cannot manufacture user response.
- [ ] User interaction owner is hardened for the production concurrency/crash guarantee if cognition relies on it.
- [ ] Pause/resumable block => WAITING_EXTERNAL.
- [ ] Cancel/stop/skip/fail terminal => OWNER_TERMINAL.
- [ ] Neither branch creates impasse/attempt/chunk.

## Persistence/restart
- [ ] `run_state_root` and `knowledge_root` are distinct.
- [ ] Cross-process atomicity fails closed if unavailable.
- [ ] Unknown newer schema fails closed.
- [ ] No callback into owner/other store while cognitive/chunk lock held.
- [ ] Cognitive audit outbox is idempotent/bounded/non-submission.
- [ ] Required audit pending prevents cognitive-generated effect.
- [ ] Artifact-store sequence reservation crash is reconciled or safely blocks.
- [ ] Legacy unexplained sequence holes are not fabricated away.
- [ ] Canonical source catch-up completes/bounds before new cognitive effect.

## Finalization
- [ ] Child work cannot become final-output eligible from cognitive binding alone.
- [ ] Parent promotion handoff is crash-idempotent.
- [ ] Finalization reconciles nonterminal/ambiguous resolver effects and required handoffs.
- [ ] Canonical goal satisfaction never erases unresolved side-effect truth.

## Evidence/testing
- [ ] Every required benchmark A-Q passes.
- [ ] Major mechanism sabotage makes corresponding benchmark/test fail.
- [ ] New certifying tests are present in default repository collection.
- [ ] Any load-bearing report field is actually re-derived or cognition reads the canonical source directly.
- [ ] Governed cognitive writers satisfy live schema/writer guards.
- [ ] No new failure versus recorded baseline in touched suites.
- [ ] Pre-existing unrelated failures are documented, not hidden or spuriously "fixed."
- [ ] No TODO/simulated success/fake evidence/manual-only integration remains in mission-owned/touched code.

## Final HEAD fence
- [ ] First final audit pass records start/end HEAD and is clean.
- [ ] Second final audit pass uses a different lens, records start/end HEAD and is clean.
- [ ] If HEAD moved during either pass, affected traces/tests were rerun against the end HEAD.
- [ ] Final report names the exact validated HEAD and touched/evaluated surface.

When every applicable item is true, produce the engineering report:

```text
final validated HEAD
baseline failures vs final failures
files created
files modified
owner integrations used
migrations
tests added
default collection evidence
benchmark results
sabotage/non-vacuity results
restart/concurrency results
remaining limitations
strongest evidence-supported claim
```

If any applicable item is false, continue the loop.
