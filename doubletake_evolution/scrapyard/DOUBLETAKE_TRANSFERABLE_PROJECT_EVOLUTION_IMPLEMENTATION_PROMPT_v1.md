# DoubleTake Transferable Project Evolution — End-to-End Implementation Prompt

**Repository:** `https://github.com/olejardamir/DT.git`  
**Authoritative branch:** current `main` at execution time  
**Primary objective:** make DoubleTake's strongest self-evolution, exploration, learning, candidate-selection, validation, rollback, and promotion capabilities usable for arbitrary user projects, with real production wiring from the user's prompt all the way to validated project changes.

---

## 0. Execution posture

You are implementing this directly in the current DoubleTake repository.

Before changing anything:

1. Pull/inspect the latest authoritative `main`.
2. Treat the repository as concurrently changing. Other agents may be working in parallel.
3. Never reset, overwrite, revert, or discard unrelated concurrent work.
4. Re-read touched files immediately before editing and reconcile against the current tree.
5. Do not assume an older DoubleTake architecture from prior prompts, cached context, or historical documents.
6. Prefer extending canonical owners that already exist over creating parallel replacements.
7. Do not create a second orchestration path, second governance path, second promotion system, or second project-mutation runtime when an existing canonical subsystem can be extended.
8. Preserve all current security, governance, evidence, rollback, semantic-first, operator-control, and promotion boundaries.
9. Do not modify L0 to implement this feature. This belongs in the external evolution/tooling layers.
10. Do not claim completion from documents, schemas, fixtures, mocks, or dead code. Completion requires executable production wiring and end-to-end proof.

This work must be **parallel-safe, additive where possible, and convergence-oriented**.

---

# 1. Problem to solve

DoubleTake now contains substantial capability that is useful beyond DoubleTake itself, but some of the strongest machinery is still siloed in DoubleTake-specific or benchmark-specific paths.

Current examples include:

- `tools/doubletake_evolve/enhanced_exploration/`
  - Thompson sampling
  - adaptive strategy
  - basin/jump concepts
  - experiment memory
  - text gradients
  - failure avoidance
  - trial orchestration
  - incumbent promotion
- `tools/doubletake_evolve/collective_core/`
  - Borg orchestration
  - shared memory
  - failure learning
  - candidate ranking/adaptation
- `tools/doubletake_evolve/transformation_engine/`
  - project inspection
  - transform planning
  - apply/test/validate lifecycle
- `tools/doubletake_evolve/patch_execution/`
  - governed mutation and rollback machinery
- `tools/doubletake_evolve/promotion/`
  - promotion/release gates
- `tools/doubletake_evolve/workflows/evolve_agent.py`
  - governed external-project evolution workflow
- `tools/doubletake_evolve/workflows/self_upgrade.py`
  - DoubleTake self-upgrade workflow
- `tools/doubletake_evolve/workflows/chat.py`
  - governed chat path
- `tools/doubletake_evolve/api/chat_sse/chat_route.py`
  - UI/API user prompt ingress through `/api/chat`
- `tools/doubletake_evolve/_cli/chat.py`
  - terminal interactive and `--once` prompt ingress

However, these capabilities are not yet represented as one project-independent evolution substrate that normal user coding/project prompts automatically benefit from.

Important current limitations to verify against current `main` before implementation:

1. `enhanced_exploration` still contains benchmark-specific assumptions such as RecHarness, Amazon Reviews, KuaiRec, `best.py`, `predict.py`, benchmark-specific scores, and GPU-slot assumptions.
2. The normal `evolve-agent` path is governed and Borg-backed, but it does not automatically obtain the full project-independent benefits of the enhanced exploration/trial machinery.
3. The transformation engine is still largely Python/agent-oriented and uses predefined transformation types rather than a universal project change representation.
4. Rich experiment/failure learning is partly siloed from the main user-project workflow.
5. Candidate retention, branch diversity, and restart-from-alternative behavior are not yet one general facility available to arbitrary project work.
6. User prompt paths can reach provider/OpenCode execution without first becoming a canonical project-evolution task that flows through reusable search/evaluation/learning machinery.

The result is that DoubleTake may become smarter internally without every external user project receiving the same improvement.

This implementation must fix that architectural gap.

---

# 2. Required end state

After this work, DoubleTake must have one reusable **project evolution substrate** that can be used by:

```text
DoubleTake self-upgrade
external Python repositories
external JavaScript/TypeScript repositories
agent repositories
ordinary non-agent software repositories
infrastructure/configuration repositories
future project types through adapters
```

The conceptual architecture must become:

```text
USER PROMPT
    |
    v
Prompt ingress
(UI / API / CLI / explicit evolve command)
    |
    v
Canonical ProjectTask / UserIntent
    |
    v
Governance + workspace + policy + scope + semantic-first checks
    |
    v
Project understanding / inventory / capability-gap analysis
    |
    v
Generic project-evolution decision
    |
    +--> simple deterministic change when one candidate is sufficient
    |
    +--> bounded multi-candidate exploration when uncertainty/value justifies it
              |
              v
       candidate generation
       edit-scope selection
       edit-operation selection
       isolated trial execution
       project-specific evaluation
       failure learning
       alternative retention
              |
              v
       candidate comparison
              |
              v
Existing governed patch / validation / evidence / rollback / promotion path
    |
    v
Authoritative user project change
    |
    v
Evidence + learned abstract lessons + retained alternatives
    |
    v
USER-FACING RESULT
```

The user should not need to know the names of the internal research mechanisms.

A user should be able to type something as ordinary as:

```text
Fix the duplicate-account race in OAuth login and add regression coverage.
```

and, when appropriate, DoubleTake should automatically be able to use the generalized exploration, learning, candidate, validation, rollback, and promotion machinery underneath that request.

---

# 3. Non-negotiable architectural rule

## Self-evolution must become a consumer of the generic engine, not the definition of the engine.

The target relationship is:

```text
                 Generic Project Evolution Core
                           |
          +----------------+----------------+
          |                                 |
          v                                 v
 DoubleTake self-upgrade              User repository
          |                                 |
          v                                 v
 DoubleTake-specific adapter          Project adapter(s)
```

Do **not** create this relationship:

```text
DoubleTake self-evolution implementation
              |
              v
special-case translation layer for external users
```

Generic concepts must live in generic ownership locations. DoubleTake-specific concepts must remain adapters/specializations.

---

# 4. First task: audit current production wiring

Before implementing, produce an internal implementation map from the current repository.

At minimum inspect:

```text
tools/doubletake_evolve/workflows/chat.py
tools/doubletake_evolve/workflows/evolve_agent.py
tools/doubletake_evolve/workflows/self_upgrade.py
tools/doubletake_evolve/_cli/chat.py
tools/doubletake_evolve/api/chat.py
tools/doubletake_evolve/api/chat_sse/chat_route.py
tools/doubletake_evolve/api/chat_sse/event_stream.py
tools/doubletake_evolve/collective_core/borg_collective_orchestrator.py
tools/doubletake_evolve/collective_core/learning.py
tools/doubletake_evolve/enhanced_exploration/
tools/doubletake_evolve/transformation_engine/
tools/doubletake_evolve/transformation_lifecycle.py
tools/doubletake_evolve/patch_execution/
tools/doubletake_evolve/promotion/
tools/doubletake_evolve/workspace_isolation/
tools/doubletake_evolve/worktrees/
tools/doubletake_evolve/semantic_first/
```

Also inspect any current canonical source that has superseded these paths.

The implementation map must answer:

```text
1. Where does a UI prompt enter?
2. Where does a CLI prompt enter?
3. Where does an explicit evolve-agent request enter?
4. How is workspace identity resolved?
5. Where is mutation intent distinguished from ordinary chat?
6. Where is repository context built?
7. Where is a plan generated?
8. Where is a candidate patch generated?
9. Where is it applied?
10. Where are tests/evaluations run?
11. Where is rollback state created?
12. Where is evidence persisted?
13. Where is promotion authorized?
14. Where is learning persisted?
15. Which of these paths currently use enhanced exploration?
16. Which do not?
```

Do not proceed on assumptions when production wiring can be inspected.

---

# 5. Build a canonical project-independent task model

Create or extend the canonical model representing a user's requested project change.

Do not make the raw prompt itself the runtime contract.

The normalized task should capture at least:

```text
ProjectTask
  task_id
  run_id
  source_prompt
  source_surface
  workspace_id / workspace_root
  repository_identity / commit identity when available
  task_kind
  mutation_intent
  objective
  explicit_constraints
  inferred_constraints
  acceptance_criteria
  forbidden_effects
  risk_level
  uncertainty
  expected_artifact/result
  budget
  user_approval_requirements
  provenance
```

`source_surface` must distinguish at least relevant production ingress types such as:

```text
api_chat
cli_chat
interactive_chat
evolve_agent
self_upgrade
other future callers
```

The model must be serializable, versioned, schema-validated if that matches current repository practice, and evidence-bindable.

Do not lose the original user prompt. Preserve it as immutable provenance.

---

# 6. Connect ALL meaningful user prompt ingress to the same project-task decision boundary

This is a central requirement.

The implementation is not complete if only `evolve-agent` uses the new substrate while ordinary UI/API chat bypasses it.

At minimum account for:

## 6.1 Browser/UI/API path

Current production ingress includes:

```text
POST /api/chat
  -> tools/doubletake_evolve/api/chat_sse/chat_route.py
  -> event stream / provider path
```

A coding/project-mutation prompt arriving here must be capable of reaching the generic project-evolution substrate.

Do not break ordinary conversational prompts.

Required behavior:

```text
non-mutating question
  -> normal chat/research/reasoning path

project inspection request
  -> read-only project path

project mutation/coding request
  -> governed ProjectTask
  -> generic project evolution substrate
```

The intent decision must be explicit and testable, not hidden in one prompt string.

## 6.2 CLI chat path

Current CLI supports interactive chat and one-shot messages through `tools/doubletake_evolve/_cli/chat.py` and workflow code.

A coding/project mutation instruction sent through CLI chat must reach the same normalized project-evolution decision boundary as the UI/API path.

## 6.3 Explicit evolve-agent path

`EvolveAgentWorkflow` remains a first-class direct entrypoint and must use the same generic substrate rather than maintaining a separate evolution logic stack.

## 6.4 Self-upgrade path

`SelfUpgradeWorkflow` must use the same generic concepts where applicable, through a DoubleTake-specific adapter/policy specialization.

## 6.5 Future ingress rule

There must be a reusable API/function such that new user surfaces can submit a `ProjectTask` without reimplementing project evolution.

---

# 7. Intent classification must not make every chat prompt expensive

Do not route every user message through multi-candidate experimentation.

Implement or extend a bounded decision layer that distinguishes at least:

```text
CONVERSATIONAL
READ_ONLY_PROJECT_ANALYSIS
SIMPLE_PROJECT_MUTATION
EXPLORATORY_PROJECT_MUTATION
HIGH_RISK_PROJECT_MUTATION
```

Suggested policy:

```text
CONVERSATIONAL
  -> no project mutation machinery

READ_ONLY_PROJECT_ANALYSIS
  -> inspect/evaluate but do not mutate

SIMPLE_PROJECT_MUTATION
  -> one candidate by default, standard validation

EXPLORATORY_PROJECT_MUTATION
  -> bounded candidate search when uncertainty or solution multiplicity warrants it

HIGH_RISK_PROJECT_MUTATION
  -> stronger isolation/evidence/approval and potentially multiple candidate evaluations
```

Use repository-native governance and policy as final authority.

Do not let an intent classifier bypass existing authorization.

---

# 8. Create/identify the generic project evolution core

Prefer an existing canonical owner if current `main` already has one. If no suitable owner exists, create a focused package such as:

```text
tools/doubletake_evolve/project_evolution/
```

Do not create this package if doing so would duplicate an already canonical current subsystem.

The generic core should expose concepts equivalent to:

```text
ProjectTask
ProjectContext
ProjectCandidate
CandidateSet
CandidateEvaluation
ProjectSnapshot
AlternativeArchive
ProjectLesson
EvolutionPolicy
ProjectAdapter
EvaluationAdapter
EvolutionResult
```

The exact names may follow current repository conventions, but the responsibilities must exist.

---

# 9. Universal candidate model

Generalize the useful concepts in `MutationSpec` and related candidate structures.

A project-independent candidate must support at least:

```text
candidate_id
parent_snapshot_id / source_state
project_task_id
hypothesis
strategy / search_arm
edit_scope
edit_targets
edit_operation
permission_level
proposed_changes / patch reference
changed_files
estimated_cost
actual_cost
risk
expected_effect
validation_plan
evaluation_result
provenance
status
rollback_reference
```

Do not make fields such as `best.py`, `predict.py`, HR@10, xAUC, Amazon Reviews, KuaiRec, GPU slot, or recommender-specific architecture part of the core model.

Those belong in specialized adapters.

---

# 10. Generalize edit scope and edit operation

A key capability must be explicit control of **what DoubleTake may change** and **what type of change it is attempting**.

Represent edit scope independently from the patch itself.

Examples of scope dimensions:

```text
single symbol
single file
module/package
subsystem
test surface
configuration/dependency surface
multi-module architecture
whole repository only when explicitly justified
```

Examples of edit operations:

```text
fix
add
replace
refactor
connect
migrate
configure
remove
split
merge
optimize
harden
add-test
change-interface
change-dependency
other adapter-defined operation
```

Existing governance scopes remain authoritative. Search scope can only become narrower than authorization unless an explicit governed expansion is approved.

The search engine must never use “exploration” as permission to escape user/governance scope.

---

# 11. Extract the general parts of enhanced exploration

The following ideas are generally useful and should be reusable for arbitrary projects:

```text
candidate selection
Thompson/adaptive strategy where appropriate
exploration versus exploitation
failure avoidance
experiment memory
text gradients / concise learned lessons
candidate trial grouping
incumbent comparison
basin/local-optimum escape concepts
search budget
retry/avoid behavior
```

Separate them cleanly from benchmark-specific assumptions.

The generic layer must not import or depend on:

```text
Amazon Reviews
KuaiRec
RecHarness task semantics
best.py conventions
predict.py conventions
fixed 8x A800 assumptions
recommender-specific metrics
```

Existing recommender support should continue to work through an adapter or compatibility layer.

Do not destroy useful existing benchmark functionality just to generalize it.

---

# 12. Adaptive search budget

Multi-candidate search must be useful rather than gratuitous.

Create a deterministic/policy-governed decision for search depth.

Inputs can include:

```text
task uncertainty
risk level
estimated change breadth
number of plausible approaches
historical failure density
available compute/time budget
user constraints
test/evaluation availability
rollback quality
```

Example behavior:

```text
obvious one-line fix + strong tests
  -> 1 candidate

ambiguous bug with several plausible causes
  -> 2-4 candidates

architectural change with measurable acceptance criteria
  -> bounded multi-candidate exploration

no reliable evaluation function
  -> avoid pretending candidate ranking is objective; use governed conservative path
```

Do not optimize by arbitrary numeric score when the project does not have a meaningful scalar objective.

---

# 13. Project-independent evaluation contract

This is essential.

Replace benchmark-only assumptions with an evaluation interface capable of returning structured evidence such as:

```text
hard_gate_status
required_tests_passed
regressions
objective_metrics
secondary_metrics
static_analysis
security findings
behavioral checks
performance/resource changes
scope compliance
changed-file breadth
risk delta
cost
confidence
notes
```

A project adapter decides how evaluation is performed.

Examples:

```text
Python adapter
  -> pytest / project-native commands / type checks / lint if configured

JS/TS adapter
  -> package.json scripts / tests / typecheck / build

Rust adapter
  -> cargo test / cargo check when applicable

Go adapter
  -> go test ./... when applicable

Generic adapter
  -> repository-declared validation commands and explicit acceptance checks

DoubleTake adapter
  -> DoubleTake's own governed proofs/gates

ML benchmark adapter
  -> benchmark score and task-specific evaluation
```

Do not hardcode every ecosystem into the core. Use adapter discovery/contracts.

Do not manufacture tests that merely `assert True` and then treat them as evidence of correctness.

---

# 14. Reuse existing mutation, rollback, evidence, and promotion authority

The new project evolution layer is a decision/search layer, not a replacement for existing governed mutation machinery.

Where current canonical subsystems already provide functionality, integrate with them:

```text
semantic-first authorization
workspace isolation/worktrees
patch execution
transformation lifecycle
source change guards
operator controls
policy enforcement
validation
evidence generation
rollback snapshots
promotion/release authorization
Borg Collective orchestration
```

Do not create an ungoverned direct-write path from a candidate to project source.

The intended lifecycle is:

```text
candidate
  -> isolated/staged trial
  -> evaluation
  -> selected candidate
  -> canonical governed mutation path
  -> validation
  -> promotion authorization
  -> authoritative project state
```

Any existing production path that currently writes directly in a way inconsistent with canonical governance must be reconciled rather than multiplied.

---

# 15. General retained-alternative archive

Implement a project-independent way to retain a small number of useful alternatives rather than always preserving only the single incumbent.

This must be bounded and evidence-driven.

A retained snapshot/candidate record should include:

```text
snapshot_id
project/repository identity
parent snapshot
candidate id
commit/tree/diff identity
edit scope
edit operation
strategy/hypothesis
evaluation summary
why retained
applicability tags
created_at
expiry/GC policy
```

Retention must support at least:

```text
current incumbent
useful alternative(s)
negative/rejected knowledge
```

Do not retain unlimited worktrees or source copies.

Prefer content-addressed metadata plus VCS references/diffs where safe.

Garbage collection must be explicit and tested.

---

# 16. Restart exploration from alternatives

When the current solution appears to plateau, repeatedly fails, or becomes a poor starting point for a changed objective, the project evolution layer should be able to choose an eligible retained alternative as the source state for a new bounded exploration branch.

This must be policy-governed and reversible.

Never silently replace the authoritative user branch with an alternative snapshot.

Alternatives are exploration starting points, not automatic promotions.

---

# 17. Cross-project learning must be useful AND safe

Generalize learning so that lessons from project work can improve future project work.

Do not transfer raw proprietary source code, secrets, file contents, prompts containing secrets, or repository-specific identifiers into global cross-project learning.

Separate:

```text
repository-local memory
cross-project abstract lessons
```

A transferable lesson should look conceptually like:

```text
problem_signature
project_characteristics
language/framework tags
subsystem class
edit scope
edit operation
strategy
observed result
failure/success signature
applicability conditions
confidence
provenance category
```

Example safe transferable lesson:

```text
"When duplicate-creation bugs occur around concurrent identity callbacks,
transactional uniqueness enforcement plus a regression concurrency test
outperformed application-level existence checks in projects with a relational DB."
```

Not acceptable as global learning:

```text
raw source file from a user's repository
API keys
customer names
private URLs
verbatim proprietary prompts/code
```

Learning must influence future candidate ranking only when applicability matches.

Do not globally apply coarse rules just because a token or substring matches.

---

# 18. Connect Collective learning with detailed project-evolution learning

Current Collective learning includes useful cross-run AVOID/PREFER/REINFORCE behavior, but it can be coarse.

Do not delete it.

Instead, create a bridge or shared abstraction so detailed project lessons can safely inform candidate selection.

The system should be able to answer things like:

```text
Has this type of change failed before in a similar context?
Which edit scopes have been reliable for this project class?
Which strategies have produced regressions?
Which alternative starting points are worth revisiting?
```

while retaining current Borg learning semantics and governance.

---

# 19. Project adapters

Define a stable adapter boundary.

A project adapter should be responsible for project-specific facts, not the generic engine.

Expected adapter responsibilities may include:

```text
project detection
repository inventory
language/framework detection
build/test command discovery
candidate materialization rules
validation command discovery
objective/evaluation extraction
artifact boundaries
project-specific forbidden paths
project-specific risk signals
```

Implement enough real adapters/fixtures to prove generality.

At minimum prove:

```text
1. ordinary Python project not structured like DoubleTake
2. JavaScript/TypeScript project
3. DoubleTake self-upgrade or DoubleTake fixture through the same generic contract
```

A generic fallback adapter must fail honestly when it cannot determine how to validate a project.

It must not fabricate confidence.

---

# 20. User prompt → project task → execution wiring

This requirement is the heart of the implementation.

Create an explicit production-call graph and make it true in code.

Target logical flow:

```text
UI user types prompt
  -> POST /api/chat
  -> prompt normalization
  -> mutation/read-only/conversation intent decision
  -> ProjectTask if project work
  -> governance/context/scope
  -> project evolution dispatcher
  -> generic evolution core
  -> candidate generation/search if appropriate
  -> isolated execution
  -> project adapter evaluation
  -> candidate selection/retention/learning
  -> canonical patch/transformation lifecycle
  -> validation/evidence/rollback/promotion
  -> SSE/user-facing progress and final result
```

And:

```text
CLI user enters prompt
  -> CLI chat workflow
  -> same intent boundary
  -> same ProjectTask model
  -> same project evolution dispatcher/core
```

And:

```text
doubletake-evolve evolve-agent ...
  -> ProjectTask / equivalent normalized request
  -> same project evolution dispatcher/core
```

And:

```text
self-upgrade
  -> DoubleTake-specific ProjectTask/adaptor
  -> same generic evolution concepts
  -> stricter DoubleTake governance/proofs
```

Do not fake this by merely importing the new package from each file.

Tests must prove the call path actually executes.

---

# 21. UI/API progress reporting

If the API/UI path invokes project evolution, surface useful structured progress through the existing event mechanism rather than making the UI appear frozen.

Use current event conventions where possible.

Useful stages include:

```text
understanding_project
planning_change
generating_candidates
evaluating_candidate
retaining_alternative
selecting_candidate
applying_change
validating_change
promotion_check
completed
blocked
rolled_back
```

Do not expose internal chain-of-thought.

Progress should describe actions/evidence, not hidden reasoning.

---

# 22. Preserve ordinary chat behavior

A major regression would be making normal chat dependent on repository mutation infrastructure.

Required examples that must remain lightweight:

```text
"Explain this function."
"What does this error mean?"
"Summarize the repository architecture."
"What is a Python decorator?"
```

These may use read-only project context if relevant, but they must not create mutation candidates, write source, or invoke promotion.

---

# 23. Explicit selection rules for multiple candidates

Do not reduce arbitrary project quality to one universal float.

Candidate selection must distinguish:

```text
hard gates
objective improvement
regression avoidance
risk
scope compliance
cost
reversibility
confidence
```

Hard failures must not be outweighed by a high soft score.

A candidate that fails required tests, violates scope, breaks security policy, or cannot be rolled back must not win because another metric improved.

Tie-breaking must be deterministic where possible.

Persist the comparison evidence.

---

# 24. Compatibility strategy

Existing specialized functionality must remain available.

For `enhanced_exploration`:

```text
extract/reuse generic mechanisms
keep benchmark-specific behavior behind adapters/compatibility layers
avoid a flag-day rewrite
preserve current tests where still valid
```

For the transformation engine:

```text
reuse useful inventory/planning/apply/validation code
move project-specific assumptions behind adapters/contracts where practical
avoid keeping two unrelated candidate/transform abstractions forever
```

For `evolve-agent` / `self-upgrade` / chat:

```text
use the same generic project-evolution entrypoint
retain workflow-specific governance around it
```

---

# 25. No dead architecture

Every new public abstraction must have a production caller.

Every production caller must have tests.

Every claimed end-to-end stage must produce inspectable evidence.

Do not leave behind:

```text
unused ProjectTask models
unreferenced candidate stores
adapter interfaces with no real adapter
search engines only called by tests
UI event types never emitted
new workflow classes not reachable from user input
parallel "v2" systems while old production paths remain authoritative
```

If old code becomes obsolete, migrate callers and remove or clearly deprecate it only after proving replacement coverage.

---

# 26. Suggested implementation phases

Use repository reality to adjust exact files, but implement in roughly this order.

## Phase A — contracts and inventory

- map current user ingress and mutation paths
- define/extend `ProjectTask`
- define/extend `ProjectCandidate`
- define adapter/evaluation contracts
- define result/evidence contracts

## Phase B — genericize exploration

- isolate project-independent exploration algorithms
- remove benchmark assumptions from generic logic
- preserve RecHarness/KuaiRec behavior through adapters
- connect experiment/failure memory to generic candidate metadata

## Phase C — external-project adapter path

- project detection
- evaluation command discovery
- candidate isolated execution
- Python + JS/TS proof fixtures
- generic fallback behavior

## Phase D — archive and learning

- retained alternatives
- candidate/snapshot GC
- repository-local lessons
- privacy-safe abstract cross-project lessons
- bridge to Collective candidate modulation

## Phase E — production workflow wiring

- `evolve-agent`
- `self-upgrade`
- CLI chat
- API/UI `/api/chat`
- Codex/OpenCode runtime integration as current production design requires

## Phase F — user-facing progress and final response

- project-evolution progress events
- final evidence summary
- blocked/rollback reporting

## Phase G — end-to-end proofs

- real prompt ingress tests
- unrelated project fixtures
- negative tests
- concurrency tests
- regression suite

---

# 27. Required end-to-end acceptance scenarios

Implement automated tests/proofs for at least the following.

## Scenario 1 — UI/API coding prompt

Given a small external repository with a known bug:

```text
POST /api/chat
message = "Fix the bug and add regression coverage."
```

Prove:

```text
prompt accepted
-> classified as project mutation
-> ProjectTask created
-> correct workspace/repo identity bound
-> generic evolution dispatcher entered
-> candidate(s) generated
-> isolated candidate evaluated
-> candidate selected
-> canonical mutation path invoked
-> tests pass
-> promotion/authorization path reached
-> authoritative project source changed
-> evidence recorded
-> final SSE result reports completion
```

The test must fail if the generic project-evolution layer is bypassed.

## Scenario 2 — CLI one-shot coding prompt

Invoke the actual CLI surface or the closest production-equivalent integration test:

```text
doubletake-evolve chat --once "Implement X in the active project"
```

Prove the same normalized ProjectTask and evolution dispatcher are used.

## Scenario 3 — ordinary chat

```text
"Explain what this file does."
```

Prove no mutation candidate is created and no project source is changed.

## Scenario 4 — Python external project

Use an external fixture that is not DoubleTake and not an agent framework.

Prove detection, candidate generation, project-native evaluation, apply, rollback metadata, and final evidence.

## Scenario 5 — JS/TS external project

Use a small package.json-based project.

Prove adapter discovery and project-native test/build evaluation without Python-specific assumptions.

## Scenario 6 — candidate failure

Generate or inject one failing candidate and one valid candidate.

Prove the failing candidate cannot be promoted and failure learning is recorded.

## Scenario 7 — retained alternative

Produce two valid but meaningfully different candidates.

Prove:

```text
one becomes incumbent/selected
one is retained under bounded policy
retained alternative has evidence and source-state reference
```

## Scenario 8 — restart from retained alternative

Create conditions that justify revisiting a retained alternative.

Prove exploration can start from it without changing authoritative source until promotion.

## Scenario 9 — rollback

Force post-apply validation failure.

Prove authoritative state is restored through canonical rollback machinery and evidence records the rollback.

## Scenario 10 — DoubleTake self-upgrade reuse

Prove `self-upgrade` uses the shared generic contracts/core where appropriate rather than a completely unrelated evolution model.

---

# 28. Negative acceptance tests

Add explicit tests proving that DoubleTake refuses or avoids these failures:

```text
candidate escapes authorized file scope
candidate modifies governance/evaluator to make itself pass
candidate changes source before semantic-first authorization
failed required tests still selected due to a high soft score
unknown project type treated as validated without evidence
raw private project code stored in global cross-project learning
unbounded retained snapshot growth
stale snapshot promoted after source changed
concurrent run silently overwrites another run
UI coding prompt bypasses generic evolution core
CLI coding prompt uses a different evolution implementation
self-upgrade duplicates generic project core
benchmark-specific metric leaks into generic candidate contract
```

---

# 29. Concurrency requirements

The user may run multiple DoubleTake workers/agents in parallel.

The new system must handle:

```text
multiple independent candidate trials
multiple worktrees
simultaneous read-only runs
competing mutation runs on the same repository
stale candidate bases
promotion races
archive updates
learning-store updates
```

Use existing locking/worktree/session/transaction machinery wherever possible.

Required behavior:

- candidates are bound to exact source state
- stale candidates are revalidated or rejected before promotion
- candidate archive writes are atomic
- learning writes are atomic or transactionally safe
- no `git reset --hard` against unrelated work
- no silent overwrite of a changed authoritative branch

---

# 30. Evidence requirements

A successful project-evolution run must be able to reconstruct:

```text
what the user asked
what repository/state was inspected
what task interpretation was used
what scope was authorized
what candidates were considered
which candidates failed and why
which candidate was selected and why
what source changed
what validation ran
what passed/failed
what rollback state exists
what promotion decision occurred
what alternatives were retained
what abstract lessons were learned
what was returned to the user
```

Use existing DoubleTake evidence stores/schema/versioning conventions where possible.

Do not create a second incompatible evidence universe.

---

# 31. Performance requirements

Generalization must not make trivial tasks unusably expensive.

Required properties:

```text
simple task fast path
bounded candidate count
bounded archive size
bounded memory injection
bounded log/evidence size
no mandatory GPU
no mandatory external paid service
no mandatory benchmark dataset
```

The generic project evolution core must run on ordinary development hardware for ordinary coding tasks.

Specialized adapters may use additional resources when explicitly appropriate.

---

# 32. Security and trust requirements

Preserve or strengthen:

```text
path confinement
symlink/hardlink protections
workspace isolation
governed tool use
operator controls
approval requirements
secret handling
prompt-context governance
protected-core protections
dependency governance
semantic-first checks
promotion authorization
rollback integrity
```

Candidate experimentation must never become an ungoverned arbitrary-execution bypass.

High-risk effects still require existing policy/approval behavior.

---

# 33. Documentation requirements

Update the minimum authoritative documentation needed to explain the actual production architecture.

Do not write a large speculative document set.

At minimum document:

```text
user prompt -> ProjectTask -> project evolution core -> candidate/evaluation -> canonical mutation/promotion -> result
```

Document the adapter contract and the distinction between:

```text
generic project evolution
DoubleTake self-upgrade specialization
benchmark/ML specialization
```

Any architecture document must match executable reality.

---

# 34. Required repository cleanup during implementation

As you generalize, identify redundant or superseded code created by the old siloed architecture.

Do not delete aggressively merely for aesthetics.

Only remove or deprecate code when:

```text
all production callers are migrated
replacement tests exist
compatibility needs are understood
no concurrent current-main change depends on it
```

Prefer thin compatibility wrappers over duplicated implementations during migration.

---

# 35. Completion gate

Do not report this task complete until ALL of the following are true:

```text
[ ] current main was inspected and implementation matches current architecture
[ ] user prompt ingress is traced from UI/API to generic project evolution for mutation requests
[ ] CLI prompt ingress reaches the same generic project evolution path
[ ] evolve-agent reaches the same core
[ ] self-upgrade reuses the same generic contracts/core where applicable
[ ] ordinary non-mutating chat does not invoke mutation/search machinery
[ ] generic ProjectTask exists and preserves original prompt provenance
[ ] generic ProjectCandidate exists without benchmark-specific assumptions
[ ] edit scope and edit operation are explicit first-class concepts
[ ] exploration logic is project-independent
[ ] RecHarness/KuaiRec-specific behavior remains only in adapters/specialized code
[ ] project-independent evaluation contract exists
[ ] at least Python and JS/TS external-project paths are proven
[ ] generic fallback fails honestly when validation cannot be established
[ ] retained alternative archive exists and is bounded
[ ] restart-from-alternative behavior is proven
[ ] failure/success lessons affect future selection in applicable contexts
[ ] cross-project learning does not leak raw private source/secrets
[ ] existing governance/semantic-first/operator controls remain authoritative
[ ] candidate application uses canonical mutation/rollback machinery
[ ] stale candidates cannot silently promote
[ ] promotion evidence is persisted
[ ] rollback proof exists
[ ] concurrency/race behavior is tested
[ ] no second competing orchestration/promotion/evidence system was introduced
[ ] no dead or test-only core path is being claimed as production wiring
[ ] relevant unit/integration/e2e tests pass
[ ] repository-native proof commands pass
[ ] final implementation report lists exact production call graph and evidence
```

If any checkbox is false, the task is not complete.

---

# 36. Final proof artifact

At completion, write one concise implementation/evidence report under an appropriate current repository report/evidence location.

It must contain:

```text
commit / source-state identity
files changed
canonical owners used
old silo -> new generic mapping
production call graph from user prompt to source mutation
supported ingress surfaces
project adapters implemented
candidate/search behavior
archive/learning behavior
governance integration
validation commands run
end-to-end scenarios and outcomes
known limitations that are genuinely outside this implementation
```

Do not call a known missing production wire a “future enhancement.” If it is required by this prompt, implement it before completion.

---

# 37. Final architectural invariant

The implementation is successful only if this statement is materially true in executable code:

> When DoubleTake learns a generally useful way to plan, search, compare, validate, recover from, or learn from project changes, that capability can improve both DoubleTake's own evolution and the work DoubleTake performs on unrelated user projects, without duplicating the mechanism and without bypassing governance.

And this must be true end-to-end:

```text
USER TYPES PROMPT
    -> DoubleTake recognizes project work
    -> builds governed project task
    -> invokes generic evolution machinery
    -> explores only when useful
    -> evaluates using the project's own reality
    -> learns from success/failure
    -> retains useful alternatives
    -> applies through canonical governed mutation
    -> validates and can roll back
    -> promotes only supported changes
    -> returns the result to the same user surface
```

That full chain, not merely a new internal library, is the deliverable.
