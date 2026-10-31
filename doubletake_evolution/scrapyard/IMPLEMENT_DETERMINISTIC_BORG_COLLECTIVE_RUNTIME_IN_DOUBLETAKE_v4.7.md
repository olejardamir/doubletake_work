# Make DoubleTake's Existing Borg Decision Paths Deterministic
## Execution Prompt v4.7 — current-main aligned, deterministic bounded control authority, canonical loop contracts, no Von

You are operating **inside the current local DoubleTake repository**.

Your task is to make the **existing live Borg/Collective control paths deterministic** when deciding which Borg response, subsystem route, nanoprobe, recovery path, assimilation path, or explicit System-Two escalation should run.

This replaces the previously proposed Von-1.0/System-One integration.

**Do not integrate Von-1.0. Do not add a neural controller. Do not use an LLM as the normal path for Borg classification/evaluation/branch selection.**

This is primarily a **simplification and correction task**, not a greenfield architecture task.

The current repository already contains substantial Borg/Collective machinery. Reuse and simplify it. Do not create a third decision engine beside the two live decision seams that already exist.

System Two remains available for work that genuinely requires open-ended reasoning, coding, debugging, research, architecture, or synthesis. A deterministic rule may explicitly escalate to that existing governed path.

Do not stop at analysis, notes, TODOs, scaffolding, or mocks. Implement the smallest correct change through the real current runtime and prove it.

If this prompt is rerun against partial work, continue the existing implementation. Do not create duplicate policy engines, duplicate action registries, duplicate provenance stores, or alternate Borg loops.

---

# 1. Authority and Current Repository Baseline

The current local DoubleTake checkout is authoritative.

Expected repository:

```text
/home/glompy/Desktop/OTHER_PROJECTS/DT
```

At the beginning:

```bash
cd /home/glompy/Desktop/OTHER_PROJECTS/DT
git rev-parse --show-toplevel
git branch --show-current
git rev-parse HEAD
git status --short
git log -1 --oneline
```

Record the exact revision and working-tree state.

## 1.1 Current GitHub orientation snapshot

GitHub `main` was inspected while this prompt was revised at:

```text
f4c5a364530a9035494869715a2181a0939d77f8
```

That revision is **orientation only**. The local checkout at execution time wins.

At that GitHub revision, the following live mechanisms were confirmed:

> **Freshness note:** this prompt was originally deep-inspected against `c352cc50df02d38406cb2b6a469271fb052dd15d`. Before finalizing v4.4, GitHub `main` advanced by 77 commits to `f4c5a364530a9035494869715a2181a0939d77f8`. A commit-range comparison showed no changes to the Borg/Collective implementation files targeted by this prompt; within the filtered target/coordination area, the intervening changes were to `ACTIVE_WORK` and `synthesis/ledger.json`. Treat the local checkout at execution time as authoritative and re-check touched files before editing.


```text
tools/doubletake_evolve/collective_core/service.py
tools/doubletake_evolve/collective_core/cognition.py
tools/doubletake_evolve/collective_core/cognition_prompt.py
tools/doubletake_evolve/collective_core/_mixins/execution.py
tools/doubletake_evolve/collective_core/_mixins/borg_loop.py
tools/doubletake_evolve/collective_core/borg_operating_model.py
tools/doubletake_evolve/collective_core/borg_execution.py
tools/doubletake_evolve/collective_core/nanoprobes/
tools/doubletake_evolve/borg_capability_fabric/
tools/doubletake_evolve/collective_integration/operating_loop/
tools/doubletake_evolve/collective_integration/strategic_planner.py
tools/doubletake_evolve/session_runtime/
tools/doubletake_evolve/model_provider_routing/
tools/doubletake_evolve/frontier_discovery/
ACTIVE_WORK
synthesis/ledger.json
L0/
L1/
L2/
Makefile
docs/VALIDATION_MATRIX.md
```

Re-check these locally before editing.

## 1.2 Current architectural boundary

The root README currently defines the active layer architecture as:

```text
L0 = governed seed kernel
L1 = external evolution/controller governance
L2 = specialization profile/spec layer
```

and states that the current architecture should stop at:

```text
L0 + L1 + L2
```

Do not create L3/L4/L5 merely to house this change.

Do not weaken L0 independence or bypass L1 governance.

## 1.3 Concurrent-work discipline

This repository is actively worked by multiple agents on the same `main` branch.

Before claiming or editing a substantive area, inspect:

```text
ACTIVE_WORK
synthesis/ledger.json
current git diff/status
recent commits touching the same files
```

Do not:

```text
reset unrelated work
clean the repository
force-checkout
force-push
revert another worker's valid changes
rewrite another active delta
assume HEAD stayed fixed during a long run
```

Immediately before final validation, re-read:

```bash
git rev-parse HEAD
git status --short
```

Reconcile only your own delta with concurrent changes.

---

# 2. What the Current Runtime Actually Does

Do not begin from the old Von architecture. Begin from the live call paths.

Two current decision seams matter.

## 2.1 Collective cognition seam

The current path is conceptually:

```text
CollectiveService.run_cycle
-> CognitionEngine.run_cycle
-> CognitionEngine._select_and_gate
-> execution receipt
-> durable cognition cycle ledger
```

At the inspected GitHub revision:

```text
collective_core/cognition.py::_select_and_gate
```

calls:

```text
llm_select_candidate(...)
```

first, and only falls back to deterministic expected-utility ordering.

`collective_core/cognition_prompt.py` explicitly describes the LLM as the primary candidate-selection path.

That is contrary to the target architecture for this task.

## 2.2 Master Borg operating-loop seam

The current path is conceptually:

```text
BorgLoopMixin._run_borg_loop
-> BorgOperatingLoop.tick
-> observe
-> classify
-> evaluate
-> decide
-> allocate
-> execute
-> measure
-> learn
-> adapt/repair
-> synchronize
```

At the inspected GitHub revision:

```text
collective_integration/operating_loop/evaluator.py
```

uses LLM evaluation as the normal production path.

```text
collective_integration/operating_loop/decider.py
```

uses LLM decision routing as the normal production path.

Strategic matching and tactical translation also contain model-first paths.

`collective_core/_mixins/borg_loop.py` currently resolves an OpenCode/Ollama/mock provider and exposes it to the operating loop for those decisions.

The deterministic fallbacks already present in these modules show that the branch-selection problem is representable without a model, **but do not assume those fallbacks are already correct enough to promote unchanged**. Current-main inspection found concrete dataflow defects that must be repaired as part of this task:

```text
classifier.py emits the categorical threat as `threat_level`
operating_loop_prompt.py::deterministic_evaluate_observations reads `threat`
decider.py also reads `threat`
```

Therefore the current deterministic fallback can silently treat a real high/critical threat as `none`.

A second live wiring defect exists in `BorgOperatingLoop.tick`:

```text
decisions = _decide(evaluations)
...
_allocate(evaluations)
```

The computed decisions are recorded but are not the objects routed into allocation. The allocator expects fields such as `response`, `priority`, `relevance`, and `strategic_campaign`; passing the pre-decision evaluations can therefore default the executable action to `ignore` and make the DECIDE phase operationally decorative.

A third live contract defect exists in the execution boundary. `BorgLoopMixin.borg_operating_cycle()` calls the operating loop with:

```text
allow_execute=False
```

and documents this as holding execution during the autonomic cycle. But the inspected `operating_loop/executor.py::_execute(..., allow_execute=True)` accepts that flag without consulting it before invoking the real executor. Therefore an autonomic path that is documented as deferred can still execute if it reaches an actionable allocation.

Further current-main execution defects were also confirmed and are in scope because they prevent a deterministic decision from reaching a truthful effect:

```text
DroneState values are lowercase: idle / active / dormant / failed / ...
operating_loop/executor.py::_select_execution_drone checks uppercase IDLE / ACTIVE
```

With the live `DroneSupervisor` this can make every serving drone appear unavailable. Use the repository's canonical `DroneState` semantics (prefer `DroneState(...).is_serving()` or an existing equivalent) rather than duplicating case-sensitive literals.

The live operating-loop executor also calls:

```text
DroneExecutor.execute(..., input_data={...})
```

but the inspected `collective_core/executor.py::DroneExecutor.execute` contract accepts:

```text
drone_id, task_kind, root, roots, allowed_roots
```

and accepts only the task kinds:

```text
recon
assimilate
```

Do not paper over this by adding an unused catch-all `input_data` parameter. Repair the adapter/call boundary so the operating loop calls the real current executor contract or another already-existing handler that actually owns the selected effect.

The current `_task_kind_for()` is also semantically unsafe as a universal adapter: anything other than a few observation verbs defaults to `assimilate`, so actions such as `investigate`, `monitor`, `watch`, or `quarantine` can be misrepresented as assimilation. **Never convert an unknown or unsupported Borg response to assimilation by default.** Map a response to an executable effect only when current DoubleTake semantics prove the mapping. Otherwise defer/fail closed or route to the real existing owner (for example containment/quarantine machinery) rather than executing the wrong effect.

The current allocator has a separate strategic-binding defect: once any `strategic_campaign` is present, it iterates all active campaigns and may raise resources because of an unrelated campaign. Allocation must use the campaign actually selected/bound by the decision, not any active campaign that happens to exist.

Finally, current deferred branches are appended to a separate `deferred` list but not consistently to the returned `results` / `CycleReport.actions` stream consumed by measurement and summaries. A held, unavailable, or unsupported action must remain visible as a truthful deferred action; it must not disappear from downstream measurement/provenance.

Current-main inspection also found routine model calls later in the same live loop, outside evaluate/decide:

```text
operating_loop/synchronizer.py::_sync_capability_gaps
-> llm_assess_gap_priorities(...)

operating_loop/synchronizer.py::_sync_resources
-> llm_assess_resources(...)

operating_loop/adapt.py::_repair
-> BorgDamageTriage.triage(..., provider=loop._subsystems.get("provider"))
-> model-first drone/readings/learning triage in damage_triage.py
```

These are not explicit System-Two tasks. They update routine Collective control state and recovery routing during the normal operating tick. They must therefore be audited and made provider-independent too. A model must not invent capability-gap priority, resource capacity/headroom, or automatic recovery action merely because a provider happens to be configured.

Current-main inspection found one more **live autonomic safety/control seam** outside `collective_integration`:

```text
collective_core/_mixins/cycle_heartbeat.py
-> reconcile_catastrophe
-> assess_catastrophe
-> _get_loop_provider()
-> llm_assess_catastrophe(...) first
-> deterministic failure-rate / immune-quarantine threshold only as fallback
```

`reconcile_catastrophe` is part of the normal autonomic heartbeat. Entering or exiting catastrophe mode changes Collective operating posture and can trigger regeneration. This is routine safety/control authority, not an explicit System-Two task. The same measured execution-failure rate, sample count, immune findings, configured thresholds, and current catastrophe state must produce the same catastrophe assessment whether OpenCode/Ollama/mock provider is configured or absent.

The repository also contains additional model-assisted **control selectors** outside the two primary seams, including current equivalents of decomposition-strategy selection, completion/consensus verdicts, capability re-ranking, assimilation-target worth evaluation, and write-code worthiness assessment. Some are currently reached with `provider=None`; others may be reachable from alternate runtime owners. Do not assume either. Trace their production callers and classify them by authority: if a model result can choose an internal Borg branch, route, verdict, mutation lane, or automatic safety action during ordinary operation, make that decision deterministic. If the helper is dead, test-only, or only used inside an explicit System-Two operation, preserve/remove it accordingly rather than broad-brush deleting provider infrastructure.

The cycle-summary contract is also stale against the live `CycleReport` schema. At the inspected revision, `summarize_cycle_report()` reads fields such as:

```text
actions_deferred
actions_executed
classifications
evaluations
phases_run
finished_at
```

while `CycleReport.to_dict()` emits current equivalents including:

```text
actions
phases
completed_at
```

and does not currently carry classifications/evaluations. This can produce zero/null summary values even when the loop actually classified, evaluated, decided, deferred, or executed work. Repair the report/summary contract or remove unsupported counters; never publish synthetic zeroes caused only by schema drift.

Fix these contracts. Do not merely make the existing fallback primary. Deterministic selection is only useful if the selected route is wired correctly, semantically correct, observable, and the execution authority boundary is real.

## 2.3 Existing deterministic substrate

The repository already contains useful deterministic mechanisms including current equivalents of:

```text
EventObservation
Estimate
CandidateResponse
expected_utility
closed action vocabularies
response maps
priority maps
CAMPAIGN_TO_TACTICS
capability registries
Borg operating-model route coverage
nanoprobe registries
hard governance gates
staleness/freshness mechanisms
rollback/commit receipts
failure counters
bounded retry/backoff
provenance/evidence stores
```

Use these before inventing new abstractions.

---

# 3. Scope: Remove Model-Backed Borg Routing, Not General LLM Capability

The target is:

```text
machine-readable state
+ deterministic facts
+ explicit priorities/rules
+ existing governance
-> deterministic Borg branch selection
```

Do **not** remove DoubleTake's ability to use LLMs/Codex/OpenCode/System Two for tasks that genuinely require reasoning.

Do **not** remove provider infrastructure globally.

Do **not** remove `session_runtime` or `model_provider_routing` merely because Borg branch selection no longer needs a model.

Do **not** remove Codex/OpenCode dependencies if they support legitimate System-Two execution elsewhere.

Remove or disconnect model calls only where the model is being used to decide routine Borg control flow that can be resolved deterministically.

Examples in scope:

```text
candidate selection among already-scored legal candidates
observation scoring from already-classified machine facts
threat/priority -> response routing
campaign priority -> tactical mapping
routine strategic matching where explicit tags/tokens/IDs are sufficient
routine action-kind routing
autonomic catastrophe/degraded-mode entry and exit
automatic repair/regeneration/decommission selection from measured state
decomposition-strategy choice when it only selects among existing bounded strategies
completion/consensus verdicts derived from measured execution/coherence facts
capability candidate ranking when all ranking signals are already machine-readable
assimilation/write-code go/no-go gates when based on existing measurable evidence
```

Examples out of scope for forced determinism:

```text
novel architecture
open-ended coding
unbounded debugging
research synthesis
new algorithm invention
complex root-cause reasoning after bounded diagnostics are exhausted
explicit autonomous-loop/model execution whose purpose is to perform System-Two work
embedding/semantic retrieval used only to retrieve evidence rather than to hold final control authority
```

Those may explicitly escalate to the existing governed System-Two path.

---

# 4. Non-Negotiable Integration Rule

**Do not build a new parallel Borg decision runtime by default.**

The current runtime already owns the relevant phases.

Prefer minimal changes inside or immediately beside:

```text
CognitionEngine._select_and_gate
BorgOperatingLoop evaluate/decide/allocate path
BorgStrategicPlanner tactical translation
existing capability/action routing
```

A shared deterministic helper/table is acceptable **only if it removes duplication between live seams and has a concrete caller immediately**.

Do not create an abstract policy framework, policy DSL, or generic `borg_decide()` service merely because the prompt previously suggested one.

Do not create:

```text
a second CognitionEngine
a second BorgOperatingLoop
a second CollectiveService
a second action registry
a second provenance database
a second System-Two launcher
```

The simplest correct result may be a small number of explicit tables/functions in the modules that already own the decisions.

---

# 5. Mandatory Preflight Audit

Before modifying code, trace the exact current production call graph and write an internal audit table:

```text
current decision
-> current owner/file/function
-> model call today?
-> deterministic facts already available
-> current deterministic fallback/table
-> governance boundary
-> existing tests
-> smallest required change
```

At minimum audit:

```text
collective candidate selection
operating-loop classification
classification -> evaluation field contract
operating-loop evaluation
evaluation -> decision field contract
operating-loop response decision
decision -> allocation field contract
strategic campaign matching
campaign-priority -> tactics translation
allocation/action routing
selected strategic campaign -> allocation binding
serving-drone selection and canonical DroneState vocabulary
response -> executable-effect/task-kind mapping
allocation -> execution call-signature contract
deferred/held action -> CycleReport/measurement provenance
CycleReport -> summarize_cycle_report schema contract
capability-gap priority synchronization
resource-capacity synchronization
damage triage / automatic recovery routing
autonomic catastrophe assessment / catastrophe-mode transition
execution authorization
System-Two escalation
nanoprobe dispatch
assimilation/discovery
repair/rollback
staleness/freshness
failure/retry control
```

For each phase boundary, identify the exact producer fields and consumer fields. A deterministic route is not correct merely because every individual function is deterministic; the selected result must survive the next boundary and actually control downstream execution.

Also search for current live calls to helpers named or equivalent to:

```text
llm_select_candidate
llm_evaluate_observations
llm_decide_observations
llm_strategic_match
llm_translate_to_tactics
llm_assess_gap_priorities
llm_assess_resources
llm_triage_drones
llm_triage_readings
llm_triage_learning
llm_assess_catastrophe
llm_select_strategy
llm_reach_consensus
_llm_rank_candidates
llm_evaluate_target
llm_assess_worthiness
_get_loop_provider
provider.complete
```

Do not limit this search to `collective_integration`. Audit current Borg/Collective control authority across at least:

```text
tools/doubletake_evolve/collective_core/
tools/doubletake_evolve/collective_core/_mixins/
tools/doubletake_evolve/collective_integration/
tools/doubletake_evolve/borg_capability_fabric/
```

Search for provider/model output that can select a branch, rank a route, issue a completion verdict, choose a recovery mode, or authorize a normal next step. Presence of `provider=None` defaults is not proof that a model path is unreachable; trace callers. Conversely, a prompt/helper file is not automatically in scope if it is only an explicit System-Two worker.

Also enumerate every `llm_*` helper in the current `collective_integration` / operating-loop prompt modules and determine whether it has a live caller. At the inspected revision `operating_loop_prompt.py` contains additional helpers such as `llm_classify_observations`, `llm_adapt_learnings`, `llm_task_kind_for`, `llm_select_drone`, `llm_assess_learning_outcome`, `llm_allocate_resources`, and `llm_reach_consensus`. Do not assume these are live or dead from their names; prove reachability. Remove dead routine-control helpers only after caller/import tests show they are unused.

At the inspected revision, additional model-assisted selectors exist in `collective_core` (`borg_decomposer`, `borg_completer`, `capability_router`, `assimilation_queue`, `write_code_e2e`) and a live catastrophe selector exists in `_mixins/predictive_learn.py`. Treat these as **audit candidates**, not automatic deletion targets. Determine whether each model result currently has production control authority. The final implementation must not leave a model-authoritative routine selector merely because its caller is not `BorgOperatingLoop`.

Classify each call as:

```text
ROUTINE_CONTROL_FLOW -> remove/model-free
GENUINE_SYSTEM_TWO -> preserve
DEAD/UNREACHABLE -> remove if safe
UNKNOWN -> trace before changing
```

Do not delete a provider path until you prove whether another legitimate feature uses it.

---

# 6. Baseline Before Editing

Before modification, run the smallest relevant tests/proofs that exercise the exact files you will touch.

Record:

```text
HEAD
working-tree state
commands run
passed/failed counts
pre-existing failures
```

Recent repository history has explicitly distinguished introduced failures from pre-existing SkillGym failures. Preserve that discipline.

Do not wait until after editing to discover the baseline.

---

# 7. Required Deterministic Behavior — Collective Cognition

The `CognitionEngine` selection path must become deterministic by construction.

The current candidate model already exposes:

```text
candidate_id
action
progress
cost
risk
expected_utility = progress - cost - risk
```

The current engine already has:

```text
closed ACTIONS vocabulary
deliberative-action gating
safe fallback
lexicographic tie-break
objective revision
cycle ledger
```

Preserve those semantics unless a current test/spec proves they need correction.

Target behavior:

```text
no candidates
-> existing safe fallback

legal candidates exist
-> deterministic ranking/selection
-> stable tie-break
-> existing deliberative authorization gate
-> execution
-> receipt validation
-> durable result
```

For identical candidate sets and objective/governance state:

```text
same input -> same selected candidate
```

No model/provider availability may alter the selected candidate.

### Required correction

At the current seam:

```text
CognitionEngine._select_and_gate
```

remove model-first candidate selection.

Use the existing deterministic selector or equivalent direct code.

If `cognition_prompt.py` becomes unused after this change:

```text
remove it if it is dead and tests/imports prove removal is safe
OR
retain only genuinely reusable deterministic helper code
```

Do not keep dead LLM-selection machinery merely for historical symmetry.

Do not broaden `ACTIONS` merely to mirror the old Von catalog.

---

# 8. Required Deterministic Behavior — Master Borg Operating Loop

The operating loop already has the right lifecycle. Keep it.

Do not rewrite:

```text
observe -> classify -> evaluate -> decide -> allocate -> execute -> measure -> learn -> adapt/repair -> synchronize
```

Make its routine branch selection deterministic.

## 8.1 Classification

Current classification is already machine-driven from sensor facts.

Preserve deterministic classification unless a real defect is proven. One such defect is already confirmed on current `main`: the authoritative sensor enum emits `AnomalyKind.DEGRADED_HEALTH.value == "degraded_health"`, while `classifier.py` checks the unreachable literal `"health_degradation"` when assigning degraded-health novelty. Repair that vocabulary drift so the classifier consumes the sensor's canonical enum value. Prefer importing/using the current enum value (or a single local constant derived from it) over duplicating a second raw spelling.

Audit the other classifier branch literals against the authoritative `ThreatLevel` / `AnomalyKind` values while touching this seam. Do not invent aliases for misspellings unless an actual external compatibility contract requires one.

Do not add an LLM classifier.

## 8.2 Evaluation

At the inspected revision, `evaluator.py` uses model-generated scores first and deterministic scores only as fallback.

Invert this architecture:

```text
deterministic current facts/rules are authoritative
```

But first repair the current field contract. The classifier currently emits the categorical threat as:

```text
threat_level
```

while the deterministic evaluator currently looks for:

```text
threat
```

Choose one canonical categorical threat field based on the current repository contract and make all routine consumers use it consistently. Prefer preserving the producer's current `threat_level` vocabulary unless current tests/contracts establish another canonical field. If a compatibility alias is temporarily required, derive it deterministically from the canonical field and test it; do not maintain two independently writable threat values.

Use actual fields already emitted by sensors/classification wherever possible.

Prefer direct machine facts over generic formulas.

Where a current formula is merely a deterministic fallback but sufficient for routing, it may remain **only after tests prove that it consumes the real current field names and distinguishes low/medium/high/critical inputs correctly**.

Where a better direct fact already exists, use it instead of inventing a new score.

Do not add a new fuzzy scoring model just because the LLM is removed.

## 8.3 Decision routing

At the inspected revision, `decider.py` already contains a deterministic response map:

```text
critical -> quarantine
high -> investigate
medium -> monitor
low -> watch
none -> ignore
```

and then overlays executive/strategic priority.

Preserve or minimally refine current deterministic tables based on existing repository semantics/tests.

Do not ask a model which response to choose.

The decision record must carry forward the machine facts needed by allocation and provenance. Do not produce a lossy decision object that drops `relevance`, the canonical threat field, source/class identity, or strategic binding when downstream code needs them. Prefer extending/merging the current evaluation record with the deterministic decision fields rather than inventing another parallel state object.

### 8.3.1 Decision must actually control allocation

Current-main inspection found that `BorgOperatingLoop.tick()` computes the decision list but calls allocation with `evaluations` instead of the decision-bearing records. Repair this live dataflow.

The required path is:

```text
classification
-> deterministic evaluation
-> deterministic decision
-> allocation FROM THAT DECISION
-> execution/deferment
-> measurement
```

Do not satisfy this by blindly changing `_allocate(evaluations)` to `_allocate(decisions)` if the current decision schema lacks fields the allocator needs. First make the phase contract coherent, then wire the decision-bearing records forward.

Add a test in which the deterministic decision is intentionally non-`ignore` and prove that allocation receives that response and produces the corresponding non-default route when resources/governance permit it. This test must fail against the pre-fix wiring.

## 8.4 Strategic campaign matching

Routine strategic matching must not depend on an LLM merely to decide whether an observation belongs to a known active campaign.

Use explicit machine-readable relationships first, where available:

```text
campaign IDs
tags
component IDs
known capability IDs
objective IDs
source names
class names
registered ownership/provenance
```

If the current schema lacks explicit relationships, the existing bounded deterministic token matching may remain as a conservative fallback.

Do not turn semantic matching into a hidden neural router.

If no deterministic match is defensible:

```text
no match
```

is preferable to invented strategic relevance.

A separate, explicitly requested System-Two planning task may reason about strategy; routine tick routing may not.

## 8.5 Campaign priority -> tactical response

`CAMPAIGN_TO_TACTICS` is already a deterministic source of truth.

Use it directly for routine translation.

Do not call an LLM to translate a known priority enum into a known tactical mapping.

Audit the comparison between campaign priority rank and tactical/threat priority rank before relying on it. They are separate vocabularies and currently use separate rank tables. Prefer comparing the **translated tactical priority** against the current tactical priority using one common tactical ranking, rather than comparing raw numeric ranks from two different enums. Prove with table-driven tests that each campaign priority elevates, preserves, or leaves the tactical priority exactly as intended.

## 8.5.1 Strategic campaign binding must survive allocation

When a decision carries a `strategic_campaign` identifier, allocation may use only that bound campaign's priority/budget semantics.

Do not iterate all active campaigns and allow an unrelated high-priority campaign to elevate the current action.

Required behavior:

```text
matched campaign A
-> allocation may consult campaign A
-> campaign B/C must not affect that allocation merely because they are active
```

If the bound campaign no longer exists or is no longer active/current:

```text
record stale/missing strategic binding
-> recompute, ignore the stale elevation, or defer according to current governance
```

Do not silently substitute another active campaign.

## 8.6 Existing attention bounds must become real or be removed as dead configuration

`BorgOperatingLoop.__init__` currently accepts and stores:

```text
attention_budget
attention_flood_threshold
```

but current-main inspection found no later use of either value in the master operating loop. That means a large fresh sensor set can fan out through classification/evaluation/decision without the bounds the public constructor claims to provide.

Do not add a new scheduler. Reuse the current classification order (`attention` already exists and classifications are deterministically sorted) and make the existing bound semantics real with a small explicit rule. Preserve full observation provenance while bounding **actionable** downstream work.

The implementation must define and test, based on existing intent/tests/docs where available:

```text
which stage applies attention_budget
how deterministic tie-breaking works at the cutoff
how critical/high-safety observations are treated when the budget is saturated
what attention_flood_threshold records/changes
how over-budget items remain visible as deferred/not-selected rather than disappearing
```

If repository evidence proves these constructor options are obsolete and should not exist, remove them and their claims instead of leaving inert controls. Do not silently keep no-op safety knobs.

Do not allow a model to choose which observations fit inside the budget.

## 8.7 Existing learned failure-avoidance must steer deterministic routing

The service registers the shared exploration/strategy object under `"exploration"`, and the repository's current integration tests explicitly require the operating loop to learn into and route through its `failure_avoidance` state. At the inspected revision, the split `allocator.py` / `executor.py` no longer consult that handle.

Restore the existing deterministic behavior rather than inventing model routing:

```text
arm = action:target
known current avoidance rule -> allocation/execution is refused/deferred before touching executor
clean arm -> normal deterministic routing
actual failed execution -> may train/update avoidance through existing strategy
successful execution -> may train positive strategy evidence
held/unavailable/unsupported/not-attempted -> neutral; do not create fresh avoidance merely from non-execution
```

Preserve the existing rule identifier/reason in action provenance when an allocation is avoided. Avoidance is a deterministic learned fact, not a model confidence score.

Reuse the current strategy's own decay/recovery semantics. Do not create a second blacklist.

## 8.8 Executive-priority vocabulary must be normalized explicitly

The current executive controller and tactical allocator do not use the same priority vocabulary. `BorgExecutive.StrategicPriority` can emit:

```text
lowest
low
normal
high
critical
override
```

while the operating-loop allocator maps only:

```text
low
medium
high
critical
```

Unrecognized values currently fall through to low. Therefore an executive `override` — and also `normal` / `lowest` — can be silently misinterpreted at the allocation boundary.

Define one explicit deterministic normalization contract between executive priority and tactical/resource priority. Preserve the intended authority ordering; do not compare raw strings or let unknown enum values silently collapse to low. If `override` is semantically exceptional rather than merely a rank, preserve that exceptional meaning explicitly instead of pretending it is an ordinary tactical label.

Tests must cover every `StrategicPriority` value and prove its downstream allocation/governance effect is intentional and stable.

## 8.9 Execution hold / defer contract

Preserve the existing distinction between:

```text
human-initiated/full Borg loop -> execution may be allowed subject to governance
autonomic Borg operating cycle -> execution held/deferred
```

At the inspected revision, `BorgOperatingLoop.tick(... allow_execute=False)` passes the flag into `_execute`, but `_execute` does not actually enforce it before calling `executor.execute(...)`. Repair this.

Required semantics:

```text
allow_execute=False
-> no real executor invocation
-> actionable allocations recorded as deferred/held
-> reason records execution_hold or current equivalent
-> measurement/reporting reflects deferred, not executed

allow_execute=True
-> current governed execution path may run
-> existing executor/governance/receipt rules remain authoritative
```

Do not implement the hold by deleting allocations or decisions; preserve them as provenance so an operator can see what would have run.

Held/deferred actions must remain visible in the normal cycle action/result surface used by measurement and summaries. If the current API returns both `results` and `deferred`, ensure the same deferred fact is represented consistently enough that `CycleReport.actions`, `_measure`, and summary counters do not falsely report zero actions merely because execution was held. Avoid double-counting while preserving observability.

## 8.10 Execution adapter and semantic-effect correctness

Trace the exact live boundary:

```text
decision-bearing record
-> allocator
-> operating_loop.executor
-> serving drone / existing effect owner
-> DroneExecutor or other governed handler
-> receipt/result
```

Repair all current contract mismatches on this path.

### Canonical drone-state semantics

Do not compare live drone states to invented uppercase literals. Reuse `DroneState` and its current `is_serving()` semantics or an existing equivalent.

Prove at least:

```text
idle   -> selectable/serving
active -> selectable/serving under current semantics
dormant/failed/retired/regenestasis -> not selected for ordinary execution
```

### Executor call contract

Call the real current executor signature. Do not pass `input_data` to `DroneExecutor.execute` unless the authoritative local implementation actually supports it at execution time. Do not change the executor's public contract merely to absorb a mistaken caller unless a broader current caller audit proves that is the right repository-wide design.

A target string such as:

```text
source:class
```

is an identity/attention target, not automatically a filesystem `root`. Do not reinterpret it as a path. Only pass `root`/`roots` when a real authorized filesystem target exists.

### Response -> effect mapping

Build the smallest explicit mapping from operating-loop response to an **existing semantically correct effect**. Do not use a catch-all `else -> assimilate`.

Examples of the required reasoning discipline:

```text
ignore -> defer/no effect
watch/monitor/investigate -> reconnaissance/observation only if the current recon contract actually represents that intent
assimilation -> assimilate only when the selected action is genuinely assimilation and governance permits it
quarantine -> existing containment/quarantine owner, or defer/fail closed if no compatible executable route is wired
unsupported response -> defer/fail closed, never silently assimilate
```

These examples are not permission to invent handlers. Trace existing owners first.

### Capability-appropriate worker selection

`_select_execution_drone(loop, task_kind)` must not ignore `task_kind`/required capability and simply return the first serving drone if that would execute work against an unrelated drone capability. Reuse current capability ownership / `ConflictResolver` / registry information where applicable. If no serving drone is appropriate for the selected effect, return a truthful deferred/no-capable-worker result.

Do not retask a drone implicitly merely to make the test execute. Retasking must use the existing governed mechanism.

### Reconcile allocation/action schema drift once, at one boundary

Current-main code and current integration tests disagree on private loop record shapes. Examples include:

```text
allocation drone count: `drones_assigned` in current allocator/executor code vs `drones` in existing integration expectations
action execution return: current executor returns `{results, executed, deferred}` while existing direct-loop tests consume a flat action list
measurement: current `_measure` expects the dict envelope while existing tests pass the action list
```

Do not paper over this by emitting every historical alias forever. Trace all live callers, `CycleReport`, autonomic summary consumers, and current tests. Select **one canonical internal allocation schema and one canonical action-result stream**, then update every live producer/consumer boundary and only the tests that are genuinely stale.

The canonical record must carry, where applicable: action/response, target, priority/relevance, bound campaign, resources, task/effect kind, requested/selected worker information, outcome, reason/mode, attempted/not-attempted semantics, and receipt/result reference.

Private-helper compatibility aliases are not a goal. End-to-end truth is.

### Strategic resource budget uses the persisted dict contract

`Campaign.resource_budget` is persisted as a plain dictionary. Current integration tests use shapes such as `{"tier": "strategic"}`. The inspected allocator instead probes `hasattr(budget, "tier")`, which cannot read that persisted shape.

When the **bound/matched** campaign may influence allocation, validate and read its actual dict fields deliberately (for example `budget.get("tier")`). Do not let unrelated campaigns donate budget, and do not let unknown budget fields silently grant authority.

## 8.11 Deferred/held is not failure: preserve attempt/outcome semantics through measure -> learn -> adapt

Once held/deferred actions are made visible, do not collapse them into execution failure.

At the inspected revision:

```text
_measure(): success = (status == "executed")
_learn(): every success=False is recorded as a failed strategy result
_adapt(): every success=False produces an `avoid` adaptation
```

That means an action which was **never attempted** because of `allow_execute=False`, no executor, no capable drone, insufficient relevance, unsupported effect, or governance deferment can poison learning as though the action itself failed. In the autonomic loop, this can systematically train avoidance from administrative/safety holds.

Define one small explicit outcome contract that distinguishes at least:

```text
executed_success
executed_failure
held/deferred_not_attempted
unavailable_not_attempted
unsupported_not_attempted
```

Use existing vocabulary where possible; the exact strings are less important than preserving the semantics end to end.

Required behavior:

```text
not attempted -> not counted as successful, but also not trained as action failure
actual attempted failure -> eligible for negative learning/adaptation
actual successful execution -> eligible for positive learning/adaptation
governance/execution hold -> neutral learning outcome with reason preserved
no capable worker/resource -> availability/gap signal, not automatic action-quality penalty
unsupported action/effect -> routing/configuration defect or deferment, not fabricated action failure
```

If the exploration strategy API requires a boolean result, **do not call it** for non-attempted/unevaluable outcomes unless the current strategy explicitly supports censored/neutral observations. Do not encode neutral as false merely to satisfy the API.

Tests must prove that repeated `allow_execute=False` cycles do not create AVOID learning or negative arm rewards for actions that were never attempted.

## 8.12 Synchronization/self-model updates must also be deterministic

The normal operating-loop synchronization phase is part of routine Borg control state. It must not depend on provider availability.

### Capability-gap priority

At the inspected revision `_sync_capability_gaps()` calls `llm_assess_gap_priorities()` when a provider is present and otherwise uses fixed priorities. Make the authoritative path deterministic. Prefer direct current facts such as anomaly kind, blocked/core dependency status, affected capabilities, explicit objective/criticality metadata, and current governance state. If the current schema does not expose enough information for a richer distinction, use the existing conservative deterministic mapping rather than inventing semantic certainty.

Required invariant:

```text
same sensor/self-model state
+ provider configured or absent
-> same recorded gap priority
```

Do not silently escalate an ambiguous gap via a model. If deeper reasoning is genuinely required, record that as a separate explicit System-Two work item; do not let the synchronization tick block on or hide such a call.

### Resource capacity/headroom

At the inspected revision `_sync_resources()` can ask an LLM to invent `capacity` and `available` values from execution/fleet counts. Remove model authority from this path. Capacity is an operational quantity and should come from measured/configured limits or a documented deterministic policy.

Prefer, in order:

```text
1. existing configured/hardware/runtime limits already authoritative in DoubleTake
2. actual bounded subsystem capacity if exposed by the live owner
3. a small explicit deterministic fallback policy already present in current code
```

The existing fallback is **not automatically safe to preserve**. Current-main inspection shows it uses the cumulative execution-ledger `total` as if it were current utilization, then computes roughly:

```text
capacity = max(total, 100)
available = capacity - total
```

Once lifetime executions reach the baseline, this can report zero headroom indefinitely even when no work is currently active. A lifetime counter is not current resource pressure. Use current/active work, bounded recent concurrency, configured limits, live serving capacity, or another authoritative current signal. If no real capacity measurement exists, record the quantity as unknown/unmeasured or use a clearly documented conservative configured bound; do not manufacture dynamic capacity from lifetime counts.

Do not replace the model with a new opaque heuristic if current configured facts exist. If a fallback constant remains, name/document/test its source and semantics. Provider presence must not change the capacity record.

### Capability-gap reconciliation must use current truth, not stale sensor history

At the inspected revision `_sync_capability_gaps()` reads `sensor.recent_readings(limit=50)` and treats historical `missing_capability` / assimilation-backlog readings in that retained window as currently active. A restored capability does not emit a compensating record that erases the old reading, so the old anomaly can keep the gap alive until it merely ages out of history.

Do not use sensor-history retention as the gap lifecycle. Reconcile gaps against current-cycle actionable evidence and/or the current authoritative capability/queue state. Historical readings may explain why a gap was opened, but they must not be the sole reason it stays open after the underlying condition disappears.

Required proof:

```text
current missing capability -> gap recorded
capability restored/current state healthy -> gap resolves deterministically
old persisted missing-capability reading remains auditable but does not re-open/keep-open the gap by itself
restart -> current authoritative state, not accidental history-window membership, determines whether the gap remains active
```

Gap priority must also remain current. `BorgSelfModel.record_gap()` currently does nothing when the same `gap_id` already exists, so a gap first recorded at one priority cannot change priority while it remains active. Reconcile/upsert the existing gap's current priority (and other mutable current fields if required) while preserving stable identity and original `recorded_at` provenance. Prove escalation and de-escalation from changed current evidence.

## 8.13 Automatic damage triage / repair routing must be provider-independent

`operating_loop/adapt.py::_repair()` currently passes the loop provider into `BorgDamageTriage.triage()`, whose drone, sensor-reading, and learning-rule paths are model-first when a provider exists. This means automatic repair/regeneration/decommission decisions can change merely because OpenCode/Ollama is configured. That violates this task's deterministic-control boundary.

For the normal autonomic/operating-loop repair path:

```text
provider must not choose severity/recoverability/recovery action
```

Use current deterministic machine facts and existing `Severity` / `RecoveryAction` rules. Preserve fail-closed behavior. Do not make a more destructive automatic action merely to mimic model nuance.

If a case cannot be safely resolved from bounded facts:

```text
record ambiguous/needs-review state
-> explicit governed System-Two escalation may be created separately
-> no automatic destructive action from model output
```

Audit all live callers of `BorgDamageTriage.triage` before changing its public API. A narrow safe result may be to make triage deterministic by default and expose any future semantic review as a separate explicit method/path, rather than a `provider=` switch on normal triage.

## 8.14 Autonomic catastrophe assessment must be deterministic

At the inspected revision, `collective_core/_mixins/predictive_learn.py::assess_catastrophe()` obtains `_get_loop_provider()` and asks `llm_assess_catastrophe(...)` before applying the existing deterministic failure-rate / immune-quarantine rule. `cycle_heartbeat.py` calls `reconcile_catastrophe`, so this is live routine control.

Make catastrophe assessment deterministic from authoritative machine facts such as:

```text
recent execution count
recent execution failures
failure rate
minimum sample threshold
configured failure threshold
immune QUARANTINE findings
current catastrophe-mode state
```

The model/provider must not decide `degraded`, catastrophe entry, catastrophe exit, or whether regeneration is triggered. Preserve the existing bounded threshold/governance semantics unless current tests/contracts prove a defect. Do not replace them with a new scoring framework.

If semantic diagnosis of an unusual systemic failure is useful, expose it only as a separate explicit System-Two diagnostic that cannot silently override the deterministic catastrophe state machine.

Add a test that installs a provider fake which raises if called, invokes the live catastrophe reconciliation path with both degraded and healthy measured states, and proves the correct deterministic transition occurs without provider access.

### Catastrophe reconciliation must return post-transition truth

At the inspected revision, `reconcile_catastrophe()` obtains an assessment, may call `enter_catastrophe_mode()` or `exit_catastrophe_mode()`, and then returns the **pre-transition assessment unchanged**. That can return `active=False` immediately after entering catastrophe mode or `active=True` immediately after exiting it.

Repair this contract. The returned reconciliation result must describe the state that is true **after** any transition performed by that call. Preserve the measured assessment inputs, but refresh the authoritative catastrophe-state fields after entry/exit. If useful, add a small explicit transition field such as `entered`, `exited`, or `none`; do not invent a second catastrophe state store.

Required proof:

```text
degraded + inactive -> enter -> returned active == true
healthy + active -> exit -> returned active == false
no transition -> returned active matches persisted state
restart/reload -> persisted catastrophe state agrees with last reconciliation result
```

## 8.15 Cycle report and summary schema must agree

The autonomic summary is part of the evidence surface. It must report what the cycle actually did.

At the inspected revision `CycleReport.to_dict()` and `summarize_cycle_report()` disagree on several field names/shapes. Reconcile them at one clear schema boundary. Do not maintain two partially overlapping truth models.

Required properties:

```text
phases reported == phases actually recorded
completion timestamp reported == actual CycleReport completion timestamp
executed/deferred counts derive from the real action stream
held actions are visible
classification/evaluation counts are either carried truthfully or omitted — never fabricated as zero because fields are absent
summary actions_by_status derives from the same authoritative action records used by measurement
```

Prefer adapting `summarize_cycle_report()` to the authoritative current `CycleReport` shape unless current consumers/tests establish that `CycleReport` itself is missing required durable evidence. If classifications/evaluations are needed for provenance, add them deliberately to the report and its digest rather than only to a summary side channel.

## 8.16 The master observer must use the real sensor channels, not a phantom generic scanner

Current-main inspection found that `_borg_loop_handles()` registers many live handles:

```text
memory
caps
drones
fleet
learning
immune
adaptive
regenerator
executions
predictive
executor
assim
config_paths
world_model (when present)
...plus enhanced/non-sensor handles
```

But `operating_loop/observer.py::_observe()` explicitly handles only `drones`, `caps/capabilities`, `learning`, and `memory`. Every other handle is sent to `sensor.scan_generic(...)` **only if that method exists**. At the inspected revision `BorgSensorNetwork` has no `scan_generic` method; instead its real `scan(...)` already accepts dedicated arguments for:

```text
memory
capabilities
drones
learning
world_model
config_paths
executions
immune
adaptive
fleet
assim
regenerator
predictive
executor
provider
```

Therefore several real sensor channels can be silently absent from the master operating loop even though the sensor network already implements them.

Simplify this. Prefer a single bounded current-cycle call that maps the registered live handles into the existing aggregate `BorgSensorNetwork.scan(...)` contract, with **no routine provider argument**, for example conceptually:

```text
sensor.scan(
  memory=...,
  capabilities=...,
  drones=...,
  learning=...,
  world_model=...,
  config_paths=...,
  executions=...,
  immune=...,
  adaptive=...,
  fleet=...,
  assim=...,
  regenerator=...,
  predictive=...,
  executor=...,
)
```

Do not copy this blindly if local signatures changed; trace the current owner at execution time. Do not pass enhanced cognition/memory/exploration handles into invented generic sensor logic merely because they are registered. Use only existing dedicated channels, and preserve separate real observers/probes for anything outside `BorgSensorNetwork`.

This one aggregate scan should be the canonical source of **fresh sensor observations for that tick**. It also avoids incrementing/persisting the sensor scan separately once per registered subsystem.

Required proof:

```text
executions channel is actually scanned when registered
fleet receives the corresponding drones handle when required
immune/adaptive can be scanned together
assim/regenerator/predictive/executor channels are reachable
world_model/config_paths are scanned when present
provider is not required for the normal sensor scan
unsupported enhanced handles are not silently treated as successfully scanned
no nonexistent scan_generic contract remains on the live observation path
```

If a sensor-channel exception occurs, represent it as a **current-cycle sensor failure observation** through a real supported mechanism or explicit observer record. Do not rely on calling a nonexistent `record_anomaly` method and swallowing the resulting exception.

## 8.17 Current-cycle observations must not be polluted by persisted history

Current-main inspection found a live observation-boundary defect in `collective_integration/operating_loop/observer.py` + `sensor_network.py`:

```text
_observe()
  -> calls sensor.scan(...) for registered subsystems
  -> each scan persists the newly emitted SensorReading objects
  -> _observe() then calls sensor.recent_readings(limit=50)
  -> appends those persisted readings to the same current-cycle observation list
```

Therefore a freshly emitted reading can appear once from `scan()` and again from `recent_readings()` in the **same tick**. Older persisted anomalies are also reintroduced as if they were current observations on later ticks. Because `SensorReading.reading_id` is timestamp-derived, repeated observations of the same underlying condition do not share a stable reading ID that automatically solves this.

This is unacceptable for deterministic control: the number of actions chosen in a cycle must not depend on accidental replay of the sensor history buffer.

Repair the boundary with the smallest current-architecture change. For the normal operating tick:

```text
new scan results = current-cycle actionable observations
persisted recent_readings = historical/context evidence only
historical records must not silently re-enter the actionable stream as new observations
```

If historical evidence is needed for trend detection, failure-rate calculation, learning, or explicit diagnostics, use it deliberately through a separate context/trend read. Do not concatenate it into the current-cycle observation list without freshness semantics.

Required properties:

```text
a reading returned by scan() appears at most once in one cycle's actionable observations
an old persisted reading does not automatically trigger a new decision on every later tick
healthy current state can be observed even when historical anomaly records still exist
cycle observation count reflects current-cycle facts, not the size of the history buffer
restarts preserve history without replaying history as fresh action authority
```

Do not solve this by deleting sensor history or by making `recent_readings()` globally destructive. Preserve durable history; fix the **actionability/freshness boundary**.

## 8.18 Automatic repair must not retrigger indefinitely from the same historical reading

At the inspected revision, `operating_loop/adapt.py::_repair()` calls:

```text
loop.damage_triage.triage(
    ...
    sensor_readings=loop.sensor.recent_readings(),
    ...
)
```

That feeds historical sensor records back into automatic repair every tick. `DamageReport.report_id` is time-derived, so retriaging the same source reading can create another fresh damage report and repeat regeneration/decommission/repair attempts without new evidence.

Make the automatic repair path cycle-scoped and/or idempotent. Prefer the smallest design consistent with the live call graph, for example:

```text
current-cycle actionable readings -> repair/triage
```

with explicit reading/digest provenance on the resulting damage report, or an equivalent mechanism that proves a historical reading is not repeatedly treated as a new trigger.

Requirements:

```text
manual/history diagnostics may still inspect recent_readings intentionally
automatic repair consumes fresh/current actionable evidence or an explicit unresolved-work queue
the same historical reading cannot cause unlimited repeated automatic recovery actions
new evidence or changed measured state can legitimately cause another recovery decision
repair/defer outcome records the source reading/evidence identity needed for audit
```

Do not add a generic event-sourcing framework. Reuse current sensor/damage-triage provenance and add only the minimum identity/freshness link required.

## 8.19 Phase timeout/cancellation truth must survive the tick

Current-main inspection found a separate evidence/control defect in `collective_integration/operating_loop/loop.py`:

```text
classification = self.phase(...) or []
evaluations   = self.phase(...) or []
allocated     = self.phase(...) or []
exec_result   = self.phase(...) or {}
measure_result= self.phase(...) or []
learn_result  = self.phase(...) or []
adapt_result  = self.phase(...) or []
repair_result = self.phase(...) or []
```

After the `or []/{}` coercion, the subsequent `is not None` checks can no longer distinguish a timeout/cancellation/exception from a legitimate empty result. In addition, `_record_phase(name, at, ok=...)` currently accepts an `ok` argument but ignores it and writes `ok=True` whenever no explicit `error` string is supplied. `propagate` and `synchronize` are therefore recorded successful unconditionally even if `phase()` returned because of cancellation/timeout/failure.

Repair this **without building a generic workflow framework**. Use the smallest explicit mechanism that distinguishes:

```text
completed successfully (including a legitimate None/empty payload)
timeout
exception
cooperative/global cancellation
skipped because an upstream required phase failed
```

A small private sentinel/result wrapper inside the operating loop is acceptable if necessary. Do not use `None` simultaneously as both a valid phase return and a failure marker.

Required behavior:

```text
phase status is recorded before any fallback payload coercion
_record_phase honors the status/ok value it is given
timeout/exception cannot be rewritten as ok=true
if tick cancellation is set, later phases are recorded cancelled/skipped rather than fabricated successful
downstream side effects do not run on fabricated empty defaults when their required upstream input never completed
CycleReport and summary preserve the truthful phase status
consecutive failure accounting remains bounded and meaningful
```

Do not turn a transient empty-but-successful result into a failure merely because its payload is empty. The distinction is execution outcome, not payload truthiness.

### A timed-out mutating phase must not keep running effects after the tick moves on

Current `phase()` executes work in a `ThreadPoolExecutor`. On timeout it calls `future.cancel()` and, when cancellation fails because the worker is already running, rotates the pool with `shutdown(wait=False)`. **That does not terminate the running Python thread.** The timed-out function can continue after the loop has declared a timeout/cancellation and can mutate state later.

Do not describe such work as “force-aborted.” For effectful phases (`execute`, `repair`, `synchronize`, propagation or any current equivalent), establish a real bounded-effect contract. Use the smallest mechanism compatible with current owners, such as cooperative cancellation/deadline checks at effect boundaries, existing bounded/deadline primitives, or another current mechanism that proves an acknowledged timeout cannot later commit an unauthorized side effect.

Requirements:

```text
timeout acknowledgement -> no later untracked effect from that timed-out phase
cancelled phase cannot race a replacement phase and double-commit
receipt/provenance distinguishes timeout before effect vs partial/committed effect
if an effect may have committed before timeout, report UNKNOWN/PARTIAL current equivalent and reconcile from authoritative state; never claim clean cancellation
no orphan phase thread is treated as safely aborted merely because its executor pool was rotated
```

Add an adversarial test whose phase blocks past the timeout and then attempts a visible mutation. After timeout/tick completion, the mutation must either be prevented or truthfully represented/reconciled according to the explicit effect contract. A late invisible mutation is a failure.

### `consecutive_tick_failures` must mean consecutive

The master `BorgOperatingLoop` persists `consecutive_tick_failures` and increments it on phase timeout/exception, but current-main inspection found no reset on a later successful master-loop tick. Do not let a historical cumulative failure count masquerade as a consecutive streak.

Define success/degraded-tick semantics once and reset/advance the counter deterministically. Persist the corrected value. Test at least:

```text
failed tick -> 1
successful tick -> 0
failed, failed -> 2
failed, successful, failed -> 1
restart -> persisted streak resumes truthfully
```

Do not confuse this with the separate heartbeat-loop backpressure counter unless current architecture intentionally unifies them; avoid creating two owners for one state variable.


## 8.20 Learning must actually reach the registered strategy and durable memory

A stopping-pass inspection found two live wiring failures after `MEASURE`:

1. `operating_loop/learner.py::_learn()` calls `loop._exploration_strategy()`, but the current `BorgOperatingLoop` class does not define that method. The exception is swallowed, so the shared strategy registered under `"exploration"` is never trained by normal loop outcomes even though the service deliberately registers that shared strategy.
2. `_propagate()` calls the real `CollectiveMemory.remember()` without its required `kind` argument. The resulting `TypeError` is swallowed, so normal operating-loop learnings are not durably propagated into the real Collective memory.
3. The same `_propagate()` body calls `_share_loop_cognition(...)`, but `learner.py` does not currently import or define that symbol. Once the memory call is repaired, this becomes a swallowed `NameError` that can still make propagation reporting lie about what completed. Bind/import the existing helper from the current operating-loop shared module; do not duplicate it.

Repair the existing seams rather than adding another learning subsystem.

Required shape:

```text
MEASURE
  -> only genuine attempted outcomes become outcome learnings
  -> registered shared exploration strategy is updated through its current API
  -> failure-avoidance / Thompson state sees the same canonical action:target arm
  -> durable CollectiveMemory receives a valid typed memory entry through its real remember(kind, content, source, provenance, tags) contract
  -> propagation failures are visible; they are not silently converted into success
```

For the exploration strategy, prefer the already-registered live handle:

```python
strategy = loop._subsystems.get("exploration")
```

or a **minimal existing-loop accessor** if one is useful in more than one call site. Do not create a second strategy object, a second failure-avoidance store, or a second learner.

For durable memory, honor the current production signature. Use an existing suitable memory kind if one already exists; otherwise use the smallest stable kind needed for operating-loop outcomes. Preserve `source="operating_loop"` and provenance/tags sufficient to distinguish actual execution outcomes from advisory/deferred state.

Do **not** revive stale/test-only interfaces merely to satisfy old tests. In particular, current `collective_core/worldmodel.py` does not expose `WorldModel.observe()`. Do not invent such a method just because an older integration test fake expected it. Update tests to the live production contract where necessary.

Required tests:

```text
actual failed attempted action -> strategy learns the canonical action:target failure
actual successful attempted action -> strategy records success
held/deferred/unattempted action -> no positive or negative strategy result
missing/empty action or target -> no invalid ':' arm is created
real CollectiveMemory receives a persisted learning entry through the correct remember() signature
existing `_share_loop_cognition` is actually bound/imported and exercised rather than failing with a swallowed `NameError`
memory/shared-cognition propagation failure is represented in phase/result evidence rather than swallowed as success
restart/reload proves the durable memory entry exists when the current memory store promises persistence
second cycle consults the same shared failure-avoidance state learned in the first cycle
```

This section and §8.11/§8.17 are one dataflow contract: **only fresh, actually attempted outcomes may train future deterministic routing**.

---

# 9. Provider Handling After the Change

Do not globally delete provider support.

Instead establish a clean boundary:

```text
routine Borg control flow -> no provider
normal synchronization/self-model updates -> no provider
automatic damage triage/recovery routing -> no provider
autonomic catastrophe assessment/mode transition -> no provider
routine sensor observation/control classification -> no provider-derived branch authority
explicit System-Two work -> provider allowed through existing governed path
```

Inspect `collective_core/_mixins/borg_loop.py::_get_loop_provider` and all consumers.

If the provider handle exists only to power routine evaluate/decide/strategic-routing calls after this change, remove it from the routine operating-loop registration path.

If other legitimate System-Two consumers still need it, keep it but make those calls explicit and separately governed.

Do not silently call `MockProvider` in production merely to preserve a model-shaped decision path.

Offline and online routine Borg routing should produce the same decision from the same state.

Also audit `collective_integration/sensor_network.py` and `sensor_network_prompt.py`. They contain model-assisted scan helpers, but the inspected master operating-loop observer calls `sensor.scan(...)` without a provider. Do **not** remove those helpers merely because they exist. Trace every live caller first. If no production routine caller supplies a provider, classify them as non-authoritative/dormant for this task. If a live routine caller does supply a provider and model output can alter anomaly kind/threat/control facts, make that caller deterministic or move the semantic interpretation behind an explicit System-Two diagnostic boundary.

---

# 10. Deterministic Rules: Keep Them Small

Do not implement hundreds of bespoke rules unless the live runtime proves they are necessary.

Prefer existing explicit tables and small predicates.

Conceptually:

```text
if governance_denied:
    deny/observe
elif state_stale:
    reconcile/reevaluate
elif failed_mutation and rollback_available:
    rollback
elif required_evidence_missing:
    collect evidence
elif known_repairable_failure:
    repair
elif capability_unknown:
    discover
elif confirmed_gap and assimilation_allowed:
    assimilate
elif reasoning_required:
    escalate System Two
else:
    current deterministic normal route
```

The real rule names/actions must come from current DoubleTake mechanisms.

Do not import an 85-decision Von catalog into runtime merely because it exists.

Do not create a policy DSL if Python tables/predicates are enough.

If two deterministic rules genuinely conflict at the same effective priority and current semantics provide no tie-break:

```text
fail closed
record ambiguity
```

Do not randomize.

---

# 11. Legacy Borg/Von Package — Reference Only

The old package may still exist at:

```text
MAIN_DOCS/WISHLIST/Von1/BORG_VON1_PRECODING_PACKAGE_v1.4
```

It is **not a runtime contract for this task**.

Do not:

```text
load it at runtime
implement Von schemas
port all decision IDs
preserve confidence/probability logic
create model reliability promotion
create Von modes
create Von HTTP clients
force the old eval corpus onto current semantics
```

You may consult it only when it clarifies durable Borg terminology already present in current code, such as:

```text
semantic intent
invariants
nanoprobe taxonomy
fallback concepts
authority boundaries
```

The current repository's live code, current tests, current governance, current operating model, and current capability routes are authoritative.

`borg_operating_model.py` already maps the current Collective to 53 Borg operating sections. Use that current self-model before resurrecting old decision-catalog terminology.

---

# 12. Action and Capability Routing

Do not invent a second action vocabulary merely to make deterministic routing look cleaner.

Current owners already include:

```text
collective_core ACTIONS
operating-loop response vocabulary
borg_capability_fabric
CollectiveService methods
nanoprobe registry
assimilation queue
repair/regeneration mechanisms
CollectiveExecutionEngine
```

Preserve their distinct roles.

Do not naively merge:

```text
CognitionEngine.ACTIONS
operating-loop responses
53 Borg operating sections
capability-fabric capabilities
nanoprobe types
```

They represent different abstraction levels.

When a deterministic decision needs concrete execution, resolve it through the existing capability/handler that already owns that behavior.

Unknown or unavailable actions fail closed.

Never execute arbitrary command text from a rule payload.

---

# 13. System-Two Escalation

System Two is an explicit exception path, not a routine selector.

Use existing governed mechanisms such as the current equivalents of:

```text
session_runtime
model_provider_routing
OpenCodeProvider / Codex integration
worktree-backed implementation sessions
governed coding-agent handoff
```

Trace the current canonical route before changing anything.

Do not add a raw subprocess wrapper when a governed path already exists.

Escalate only for a concrete reason such as:

```text
novel architecture required
open-ended coding required
root cause remains unknown after bounded diagnostics
research/synthesis required
conflicting evidence requires reasoning
new algorithm/design work is actually necessary
```

A System-Two handoff should contain current equivalents of:

```text
goal
why deterministic routing stopped
relevant evidence
relevant files/components
scope/authority
required output
validation obligations
state/revision binding
```

System-Two output returns through normal governance, validation, evidence, and mutation boundaries.

A System-Two model must not become the hidden default implementation of `evaluate`, `decide`, or candidate selection.

---

# 14. Nanoprobe Integration

Current DoubleTake already contains a substantial nanoprobe package:

```text
tools/doubletake_evolve/collective_core/nanoprobes/
```

Its current package documentation describes:

```text
read-only sensing
controlled adapters
repair diagnosis
assimilation assembly
adaptive learning
freshness/invalidation
staged rollout
rollback thresholds
containment/emergency controls
regeneration
registry health
```

Inventory and reuse it.

Do not add a new nanoprobe layer for deterministic routing.

Preserve existing typed/bounded authority and current probe taxonomy.

A read-only probe may discover a mutation opportunity.

It may not self-promote into mutation authority.

Default progression:

```text
direct deterministic fact
-> deterministic/algorithmic check
-> bounded nanoprobe if more evidence is needed
-> explicit System Two only when genuine reasoning remains
```

There is no Von tier.

---

# 15. Staleness, Failure, and Anti-Oscillation

Reuse current freshness, revision, failure, retry, rollback, and containment mechanisms.

Do not create duplicate counters if current owners already track them.

A consequential action must not execute against incompatible stale state.

Repeated identical failures must not loop forever.

Detect current equivalents of:

```text
same route/action
same target
same relevant state/revision
same failure signature
same evidence
repeated attempts
```

Then use an existing legal next route:

```text
different evidence
repair
rollback
quarantine
defer
System Two
stop
```

Never hide repeated failure by resetting counters or mutating unrelated state.

---

# 16. Provenance

Reuse current durable evidence/ledger mechanisms.

Current relevant stores include or may include:

```text
CognitionEngine cycle ledger
operating-loop cycle records
autonomic action log
nanoprobe commit/evidence ledgers
collective provenance
synthesis/ledger.json
existing execution receipts
```

Do not create a disconnected new policy database.

For each changed deterministic decision path, preserve enough provenance to answer:

```text
what facts were evaluated?
what candidate/response set existed?
what deterministic rule/table selected the result?
what tie-break applied?
what governance gate applied?
what action actually executed or was deferred?
what receipt/outcome followed?
was state stale?
was System Two used, and exactly why?
```

Where current records cannot distinguish a deterministic choice from a provider/model choice, extend them minimally.

Do not add model confidence/probability fields.

---

# 17. Policy Evolution

Ordinary runtime must not silently rewrite its own deterministic rules.

If DoubleTake already has governed self-evolution, rule changes may flow through it only as normal code/configuration changes with current required evidence, tests, rollback, and promotion gates.

Do not build online self-modifying policy for this task.

---

# 18. Operator / Debug Surface

Do not build a new admin application.

Use existing status/debug surfaces.

Add only what is genuinely missing to inspect:

```text
which deterministic route fired
why it fired
what candidate/response was selected
whether governance blocked it
whether execution was deferred
whether explicit System Two was requested
```

If current cycle/loop reports already expose this sufficiently, add nothing.

---

# 19. Required Tests

Update/add focused tests for the actual live seams.

At minimum prove:

```text
CognitionEngine selection does not call a provider
same candidate set -> same selection
lexicographic tie-break remains stable
no-candidate safe fallback remains intact
deliberative governance remains intact
provider presence/absence does not change routine cognition decision

operating-loop evaluation does not call an LLM
operating-loop decision routing does not call an LLM
classifier categorical threat survives into evaluation/decision unchanged
low/medium/high/critical threat cases do not collapse to `none`
decision response survives into allocation
allocation consumes decision-bearing records, not stale pre-decision evaluations
a non-ignore decision can produce a non-default allocation when permitted
allow_execute=False prevents every real executor invocation while retaining deferred action provenance
allow_execute=True preserves the governed execution path
live lowercase DroneState values select serving drones correctly
non-serving drone states are not selected
operating-loop executor calls the authoritative DroneExecutor/effect-owner signature
no unsupported `input_data` argument is sent to DroneExecutor
unsupported Borg responses do not fall through to assimilation
response -> effect mapping is explicit and semantically valid
selected strategic campaign alone controls any strategic allocation elevation
unrelated active campaigns cannot elevate the allocation
attention_budget/attention_flood_threshold are enforced deterministically or removed as proven dead configuration
budget cutoff has deterministic tie-breaking and preserves over-budget provenance
existing exploration/failure_avoidance vetoes known-bad action:target arms before executor invocation
clean action:target arms remain routable
canonical allocation/action schema is consistent across allocate -> execute -> measure -> report
matched campaign resource_budget dict is consumed from the bound campaign only
every BorgExecutive StrategicPriority value has an explicit downstream normalization; `override` cannot silently become low
capability-gap reconciliation closes restored gaps despite retained historical anomaly evidence
existing active gap priority updates when current deterministic evidence changes
resource synchronization does not treat lifetime execution count as current utilization
deferred/held/unavailable actions remain visible to CycleReport/measurement/summary provenance
deferred/held/unavailable/unsupported actions are not learned as attempted execution failures
actual execution failures still produce negative learning where current strategy semantics permit
allow_execute=False does not create AVOID adaptations or negative arm rewards for unattempted actions
CycleReport and summarize_cycle_report agree on phases/timestamps/action status and do not publish schema-drift zeroes/nulls
strategic priority -> tactics is deterministic
campaign-rank/tactical-rank cross-domain comparisons are explicitly tested
routine strategic matching is deterministic/conservative
gap-priority synchronization is deterministic/provider-independent
resource-capacity synchronization is deterministic/provider-independent
automatic damage triage/recovery routing is deterministic/provider-independent
autonomic catastrophe assessment/reconciliation is deterministic/provider-independent
catastrophe reconciliation returns post-transition active state truthfully
master observer reaches every supported registered sensor channel through the real BorgSensorNetwork.scan contract
no live observation path depends on nonexistent scan_generic/record_anomaly methods
normal sensor scan does not use provider output as control authority
current-cycle observation stream does not duplicate freshly scanned readings through recent_readings replay
historical sensor readings do not automatically retrigger decisions on later ticks
automatic repair does not repeatedly retriage the same historical reading as new evidence
phase timeout/exception/cancellation cannot be reported as successful
legitimate empty/None phase payload can still be reported as successful
downstream effect phases do not execute from fabricated defaults after required upstream failure
timed-out mutating phase cannot commit an untracked late side effect after tick cancellation
phase timeout with possible prior commit is represented/reconciled truthfully rather than claimed cancelled
master-loop consecutive_tick_failures resets after a successful tick and survives restart correctly
_record_phase honors its explicit status/ok input
repo-wide audit proves no other live routine Borg control selector remains model-authoritative
online/offline routine loop produces same route from same state

routine Borg flow does not require OpenCode/Ollama/mock provider
explicit System-Two path can still use provider infrastructure

unknown/unavailable execution route fails closed
read-only nanoprobe cannot mutate
stale/freshness gates still hold
repeated failure remains bounded
provenance/receipts remain valid
```

Also add regression tests for any dead-code cleanup, including imports.

If LLM prompt modules are removed or partially retired, prove no live routine-control caller remains.

A useful negative test is:

```text
install a provider fake that raises if called
run routine cognition + operating-loop decisions
assert no provider call occurs
```

A useful equivalence test is:

```text
same state with provider configured
same state without provider configured
-> identical deterministic routing result
```

---

# 20. Deterministic Scenario Coverage

Do not evaluate this controller with model accuracy metrics.

Use table-driven deterministic scenarios derived from current runtime semantics.

Cover at least:

```text
healthy/no-action state
low/medium/high/critical threat routing using the real canonical threat field
classification -> evaluation threat propagation
evaluation -> decision field propagation
decision -> allocation response propagation
non-ignore decision reaching allocation/execution or governed deferment
serving idle/active drone selection using the real lowercase DroneState vocabulary
no-serving-drone deferment
executor signature compatibility with the live DroneExecutor/effect owner
unsupported response cannot become assimilation
quarantine/investigate mapping cannot silently invoke the wrong effect
autonomic allow_execute=False with an otherwise executable allocation
human/full allow_execute=True with the same allocation
held/deferred action remains present in cycle actions + measurement/summary
executive priority override
active strategic campaign priority
matched campaign A plus unrelated higher-priority campaign B -> only A may affect allocation
cross-domain campaign/tactical rank boundaries
no strategic match
capability-gap priority with provider configured vs absent
resource synchronization with provider configured vs absent
resource synchronization after a large lifetime ledger count but zero current active work
capability gap appears, capability is restored, historical anomaly remains stored, gap closes
same active gap changes medium -> high -> medium and persisted priority follows current evidence
attention flood above budget with deterministic selected/deferred set
stable cutoff tie between equal-attention observations
known-failed action:target is avoided before executor; clean target still routes
allocation schema round-trips through execute -> measure -> CycleReport without aliases changing meaning
matched campaign resource_budget tier is applied from persisted dict
executive priority normalization across lowest/low/normal/high/critical/override
failed/degraded drone automatic damage triage with provider configured vs absent
catastrophe entry/exit assessment with provider configured vs absent
catastrophe enter/exit return value agrees with post-transition persisted state
registered executions/fleet/immune+adaptive/assim/regenerator/predictive/executor sensor channels each produce a bounded current-cycle observation when their condition is triggered
fresh sensor anomaly appears once in current-cycle actionable observations
historical anomaly remains durable but is not replayed as fresh action authority
same historical reading cannot trigger unbounded repeated repair actions
held action survives measurement as not-attempted and produces no negative learning
no-capable-worker deferment produces availability/gap evidence but no action-quality penalty
real attempted execution failure still produces a negative learning signal
phase timeout followed by cancellation/skips with no false ok=true records
timed-out worker tries late mutation and cannot create an invisible post-timeout effect
failed-successful-failed tick sequence yields consecutive failure streak 1
legitimate successful empty phase distinct from timed-out empty fallback
CycleReport summary with real phases + deferred/executed action statuses
candidate expected-utility tie
no candidates
deliberative action authorized
deliberative action denied
missing evidence
known repairable failure
rollback-required condition
capability discovery/gap condition
no available worker/executor
stale state
repeated failure
explicit System-Two escalation
```

Report:

```text
scenario count
pass/fail
branch/rule coverage
unreachable deterministic branches
ambiguous/conflicting cases
System-Two escalation cases
```

Do not reuse old Von evaluation cases unless they map exactly and usefully to current deterministic semantics.

---

# 21. Required End-to-End Demonstrations

Demonstrate the current runtime, not a synthetic side system.

## A. Cognition candidate selection

```text
CollectiveService.run_cycle
-> candidates
-> deterministic CognitionEngine selection
-> governance gate
-> receipt
-> durable cycle result
```

Provider configured or not configured must not alter the result.

## B. Operating-loop route

```text
real/synthetic bounded sensor observation
-> classify with canonical categorical threat
-> deterministic evaluate using that same threat contract
-> deterministic decide while preserving allocator-required facts
-> allocate FROM THE DECISION-BEARING RECORD
-> preserve the exact matched strategic campaign binding
-> select a serving/capability-appropriate worker using canonical DroneState semantics
-> map the response only to a semantically valid existing effect
-> call the real current executor/effect-owner signature
-> governed/deferred execute
-> measure/provenance including deferred/held outcomes
```

Use at least one case whose correct response is not `ignore`; prove the chosen response reaches allocation rather than merely appearing in the cycle report.

Run that actionable case twice at the execution boundary:

```text
allow_execute=False -> no executor call, action retained as deferred/held
allow_execute=True  -> normal governed execution path is reachable
```

No routine model call.

## C. Governance denial

```text
deliberative/consequential candidate
-> insufficient authority
-> safe governed fallback/denial
-> no uncontrolled mutation
```

## D. Strategic priority

```text
known active campaign
-> deterministic relevance/match
-> deterministic priority comparison
-> CAMPAIGN_TO_TACTICS or current equivalent
```

No LLM translation.

## E. Provider independence

```text
same state + provider available
same state + provider unavailable
-> identical routine Borg decision
```

## F. Explicit System Two

```text
bounded deterministic control determines reasoning is genuinely required
-> existing governed System-Two path
-> provider/model allowed there
-> result returns through normal validation/evidence
```

## G. Synchronization and automatic recovery provider independence

```text
same capability-gap/resource state with provider configured or absent
-> identical synchronized priorities/capacity facts

same failed/degraded drone or high-threat reading with provider configured or absent
-> identical automatic damage-triage/recovery route

same execution-failure/immune state with provider configured or absent
-> identical catastrophe assessment and enter/exit decision
```

No routine model call.

## H. Stale/repeated failure

```text
stale state -> reject/recompute/defer
repeated identical failure -> bounded alternate/defer/escalation
```

## I. Nanoprobe authority

```text
read-only probe finds mutation opportunity
-> no direct mutation
-> separate governed path required
```

---

# 22. Regression and Repository Proof

Inspect current:

```text
Makefile
pyproject.toml
docs/VALIDATION_MATRIX.md
relevant module tests
ACTIVE_WORK
recent commits touching modified files
```

Use the repository's current validation commands, not stale assumptions from old prompts.

At minimum run:

```bash
make validate
```

if it exists in the local checkout.

Run focused tests for every touched current module, especially current equivalents of:

```text
collective_core cognition/service
collective_integration operating loop
strategic planner
nanoprobes if touched
borg capability fabric if touched
session/model provider routing only if System Two boundary changed
```

If practical for the environment, also run the canonical current product-readiness gate documented by the repository:

```bash
make prove-product-readiness
```

or the current equivalent.

Do not assume `make validate-full` is required if it is impractical or currently contains unrelated known failures; classify honestly.

For every failure:

```text
introduced by this delta
pre-existing and reproduced at baseline
concurrent/stale-evidence issue
external/environmental blocker
```

Do not hide failures.

---

# 23. Repository Hygiene

After the change, there must be no model-backed routine Borg branch-selection path left accidentally reachable.

Remove dead code only when safe and proven unused.

Potential cleanup candidates include current equivalents of:

```text
LLM candidate-selection prompt/helper code
LLM observation-evaluation prompt/helper code
LLM routine response-selection helper code
LLM campaign-matching helper code
LLM priority-to-tactics helper code
LLM catastrophe-assessment helper code if no explicit System-Two caller remains
model-first decomposition/consensus/capability-ranking/gating helpers proven to be routine-control only
routine operating-loop provider injection used only by the above
```

But preserve:

```text
provider abstractions used by explicit System Two
session runtime
model provider routing
OpenCode/Codex integrations used for real reasoning/coding
```

Do not delete the legacy Borg/Von design package merely because runtime no longer uses it.

Do not introduce:

```text
Von client/runtime code
new neural routers
new embeddings router for branch selection
new model confidence/reliability database
duplicate Borg loop
duplicate controller
duplicate action registry
duplicate evidence store
```

---

# 24. Work Loop

Repeat until the current live paths satisfy acceptance:

```text
1. re-read current HEAD/status/ACTIVE_WORK
2. trace one live model-backed routing seam
3. identify the existing deterministic fallback/table/facts
4. make the smallest change that makes deterministic behavior authoritative
5. run focused tests
6. prove provider-independent result
7. inspect provenance/execution behavior
8. run affected regressions
9. reconcile concurrent main changes if necessary
10. remove dead routing/model code only if proven unused
11. move to the next live seam
```

Do not refactor unrelated Borg architecture.

Do not port the old Von decision catalog.

Do not build abstractions before a current caller needs them.

---

# 25. Acceptance Criteria

Do not claim completion until all applicable items are true:

```text
[ ] exact local HEAD and baseline worktree state recorded
[ ] ACTIVE_WORK and concurrent same-main work inspected before editing
[ ] relevant pre-change failures recorded

[ ] current CollectiveService -> CognitionEngine path traced
[ ] current BorgOperatingLoop path traced
[ ] no third decision engine/runtime was created

[ ] CognitionEngine routine candidate selection is deterministic
[ ] routine candidate selection does not call an LLM/provider
[ ] provider presence/absence cannot change routine candidate selection
[ ] existing safe fallback remains intact
[ ] existing deliberative/Queen governance remains intact

[ ] operating-loop classification remains deterministic
[ ] one canonical categorical threat field is used consistently across classification/evaluation/decision
[ ] classifier anomaly literals match authoritative `AnomalyKind` values, including `degraded_health`; no unreachable spelling silently changes attention
[ ] low/medium/high/critical signals do not collapse because of a `threat`/`threat_level` mismatch
[ ] operating-loop evaluation is deterministic
[ ] operating-loop response selection is deterministic
[ ] decision-bearing records preserve fields required by allocation/provenance
[ ] allocation consumes the actual decision result rather than stale pre-decision evaluations
[ ] at least one non-ignore decision is proven to reach allocation/execution or a governed deferment
[ ] `allow_execute=False` provably prevents real executor invocation and records the held/deferred action
[ ] `allow_execute=True` preserves the current governed execution path
[ ] serving drone selection uses the repository's canonical DroneState semantics rather than incompatible uppercase literals
[ ] the operating-loop adapter calls the authoritative current executor/effect-owner signature
[ ] no bogus `input_data` argument is used against DroneExecutor unless the authoritative contract actually changed
[ ] response -> effect/task-kind routing is explicit; unsupported responses fail/defer closed
[ ] no generic fallback converts quarantine/investigate/other unsupported responses into assimilation
[ ] worker selection is capability-appropriate or truthfully deferred
[ ] the decision's selected strategic campaign, not any unrelated active campaign, controls strategic allocation elevation
[ ] deferred/held/unavailable actions remain observable in cycle action/measurement/summary provenance
[ ] measure -> learn -> adapt distinguishes attempted success/failure from neutral non-attempted deferment
[ ] execution holds, no-worker, no-executor, unsupported-route and below-threshold deferments do not poison strategy learning as failures
[ ] repeated `allow_execute=False` cycles do not create negative arm rewards / AVOID rules solely because execution was held
[ ] CycleReport and summarize_cycle_report consume one coherent schema; phases/timestamps/action statuses are truthful
[ ] absent classifications/evaluations do not appear as fake zero-count evidence
[ ] routine strategic matching is deterministic/conservative
[ ] capability-gap synchronization no longer calls a provider or changes with provider availability
[ ] resource-capacity synchronization no longer calls a provider or changes with provider availability
[ ] resource-capacity state is based on current measured/configured capacity, not cumulative lifetime execution count masquerading as utilization
[ ] capability gaps reconcile against current authoritative state/current-cycle evidence rather than sensor-history retention
[ ] restored capabilities can close gaps even while old anomaly records remain in durable history
[ ] an existing active gap's priority updates when current deterministic evidence changes; gap priority is not write-once
[ ] existing attention_budget / attention_flood_threshold are real deterministic bounds or are removed with evidence that they are obsolete
[ ] over-budget observations remain auditable/deferred rather than disappearing
[ ] registered exploration/failure_avoidance is consulted as a deterministic pre-execution veto for known-bad action:target arms
[ ] actual attempted outcomes train that same registered exploration strategy; the current nonexistent `_exploration_strategy()` call is repaired rather than silently swallowed
[ ] real CollectiveMemory propagation uses its current `remember(kind, content, source, provenance, tags)` contract and propagation failures remain visible
[ ] `_share_loop_cognition` is bound from the existing shared helper and no swallowed NameError can make propagation look successful
[ ] avoided actions are visible but do not touch the executor or train a duplicate negative outcome
[ ] one canonical allocation/action/measure schema is used by all live loop boundaries; stale aliases are not retained without a real external contract
[ ] matched campaign resource_budget is read from its persisted dict shape and only the bound campaign can affect the action
[ ] BorgExecutive priority vocabulary is explicitly normalized into tactical/allocation semantics; unknown/override values do not silently collapse to low
[ ] automatic BorgDamageTriage / repair routing no longer uses provider output as the normal control path
[ ] autonomic catastrophe assessment / catastrophe-mode transitions no longer use provider output as the normal control path
[ ] same measured catastrophe state yields the same result with provider configured or absent
[ ] catastrophe reconciliation returns authoritative post-transition active state and agrees with persisted state
[ ] master observer maps live registered handles into the existing supported BorgSensorNetwork.scan channels rather than phantom generic methods
[ ] executions/fleet/immune+adaptive/assim/regenerator/predictive/executor/world-model/config sensor channels are either genuinely observed or explicitly classified out of scope with evidence
[ ] normal current-cycle sensor scan is provider-independent
[ ] sensor-channel failures are visible in current-cycle evidence instead of swallowed through nonexistent helper calls
[ ] current-cycle observation stream contains fresh actionable readings once, without blind `recent_readings()` replay
[ ] persisted sensor history remains available without automatically becoming fresh action authority
[ ] automatic repair/triage does not retrigger indefinitely from the same historical sensor reading
[ ] repair provenance identifies the fresh evidence/current-cycle input that caused the recovery decision
[ ] phase status distinguishes success / timeout / exception / cancellation / upstream-skip independently of payload emptiness
[ ] `_record_phase` no longer ignores its explicit status/ok input
[ ] no `or []` / `or {}` coercion can erase timeout/failure evidence before phase status is recorded
[ ] later phases after tick cancellation are reported cancelled/skipped and do not run side effects on fabricated defaults
[ ] a timed-out already-running phase cannot later commit an invisible/untracked mutation merely because its ThreadPoolExecutor was rotated
[ ] possible partial effects at timeout are represented and reconciled truthfully
[ ] master-loop `consecutive_tick_failures` is a real consecutive streak and resets on successful ticks
[ ] live sensor-network provider callers, if any, were classified by authority rather than deleted by filename
[ ] all other live Borg/Collective provider-backed control selectors were classified as ROUTINE_CONTROL_FLOW / GENUINE_SYSTEM_TWO / DEAD-UNREACHABLE and handled accordingly
[ ] campaign-priority -> tactics translation is deterministic
[ ] campaign/tactical priority rank interaction is explicitly proven
[ ] routine online/offline routing is equivalent for the same state

[ ] current action vocabularies were not needlessly merged or expanded
[ ] old Von catalog was not imported as a runtime dependency
[ ] current Borg operating-model/capability routes are reused

[ ] provider infrastructure remains available for explicit System Two where needed
[ ] explicit System-Two escalation is distinguishable from routine control flow
[ ] no raw duplicate OpenCode/Codex launcher was added

[ ] existing nanoprobe authority remains bounded
[ ] read-only probes cannot self-promote to mutation authority
[ ] existing staleness/freshness protections remain effective
[ ] repeated identical failures remain bounded

[ ] provenance explains deterministic choice and execution/defer outcome
[ ] no model confidence/probability machinery was added

[ ] focused tests prove no routine provider call
[ ] deterministic scenarios pass exactly
[ ] same-state provider-on/provider-off equivalence is proven
[ ] relevant regressions pass or failures are explicitly classified
[ ] repository's current standard validation passes or genuine blocker is evidenced

[ ] dead model-routing code was removed only where proven unused
[ ] no unrelated provider/System-Two capability was broken
[ ] no duplicate controller/runtime/registry/database remains
[ ] final worktree contains only intended changes plus clearly identified concurrent work
```

---

# 26. Final Implementation Report

When complete, report concisely:

```text
1. final repository HEAD
2. baseline working-tree state and baseline failures
3. concurrent ACTIVE_WORK entries relevant to touched files
4. exact live decision seams changed
5. files modified/removed/added
6. CognitionEngine behavior before vs after
7. operating-loop behavior before vs after
8. repaired phase/data contracts, including canonical threat propagation and decision -> allocation wiring
9. canonical allocation/action/measure schema selected and all live consumers updated
10. execution adapter repairs: DroneState semantics, worker selection, response -> effect mapping, and executor call signature
11. execution-hold/deferred-provenance behavior before vs after (`allow_execute=False` / `True`)
12. exploration/failure-avoidance steering behavior before vs after
13. strategic matching, exact campaign binding, tactical translation, and resource-budget behavior before vs after
14. executive-priority normalization matrix
15. synchronization changes: gap priority/current-truth + resource capacity before vs after
16. automatic damage-triage/recovery routing before vs after
17. CycleReport/summary schema and truthful reporting before vs after
18. provider handling after the change
19. explicit System-Two path preserved
20. governance/authorization behavior
21. nanoprobe/freshness/failure behavior
22. provenance path
23. focused deterministic tests
24. provider-on/provider-off equivalence across cognition, operating loop, sync, repair, and catastrophe reconciliation
25. phase-outcome truth proof, including timeout/cancellation vs legitimate empty payloads
26. catastrophe post-transition state consistency proof
27. current-cycle sensor freshness/deduplication proof
28. historical-reading repair idempotence proof
29. capability-gap current-truth + priority-update proof
30. resource-capacity current-utilization proof
31. master-observer sensor-channel coverage matrix
32. attention-budget/flood-bound proof
33. timeout late-effect adversarial proof
34. consecutive-tick-failure state-machine proof
35. outcome-semantics proof across execute -> measure -> learn -> adapt
36. exploration/failure-avoidance steering proof across two cycles
37. learning propagation proof: registered strategy update + real CollectiveMemory persistence + shared-cognition write-through
38. classifier enum-vocabulary proof, including degraded-health attention
39. strategic resource-budget dict binding proof
40. end-to-end demonstrations
41. regression/validation commands and results
42. pre-existing/concurrent/environment failures
43. remaining limitations
```

---

# Final Rule

Do not replace a simple deterministic control problem with a model call.

Do not replace the current live Borg runtime with a new policy framework merely to remove those model calls.

The target is simpler:

```text
existing DoubleTake state
+ existing deterministic facts
+ small explicit rules/tables
+ existing governance
-> existing Borg route
```

Use LLMs only when DoubleTake has explicitly decided that genuine System-Two reasoning is required.

The task is complete when the existing `CognitionEngine` and master Borg operating loop make routine routing decisions deterministically, provider availability no longer changes those decisions, cycle-scoped evidence plus phase/catastrophe state are reported truthfully end to end, governance/provenance remain intact, and explicit System-Two reasoning still works through the current governed path.
