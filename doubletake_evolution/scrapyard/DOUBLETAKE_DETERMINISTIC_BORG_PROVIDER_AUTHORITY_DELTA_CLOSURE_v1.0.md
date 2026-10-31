# DoubleTake Deterministic Borg Provider-Authority Delta Closure
## Residual execution prompt v1.0 — offloaded from `IMPLEMENT_DETERMINISTIC_BORG_COLLECTIVE_RUNTIME_IN_DOUBLETAKE_v4.7`

You are operating **inside the current local DoubleTake repository**.

The old v4.7 prompt has already driven substantial implementation. **Do not restart that work.**
This prompt contains only the remaining closure work that was still visible on current GitHub `main`
during the offload pass.

The objective is to finish this invariant:

> **Routine Borg/Collective control authority must be deterministic and provider-independent.**
> LLM/provider infrastructure remains available only for explicit, governed System-Two reasoning,
> generation, diagnosis, coding, research, or other genuinely open-ended work.

The target is **not** “remove LLMs from DoubleTake.”
The target is:

```text
routine machine-readable Borg state
+ deterministic facts/rules
+ existing governance
-> deterministic internal branch / route / verdict / automatic action

explicitly requested or explicitly escalated System-Two reasoning
-> provider/model allowed through the existing governed path
```

Do not build another controller, another policy engine, another Borg loop, or another provider layer.

---

# 1. Authority

The **current local checkout at execution time is authoritative**.

Expected repository:

```text
/home/glompy/Desktop/OTHER_PROJECTS/DT
```

At the beginning run:

```bash
cd /home/glompy/Desktop/OTHER_PROJECTS/DT
git rev-parse --show-toplevel
git branch --show-current
git rev-parse HEAD
git status --short
git log -1 --oneline
```

Inspect:

```text
ACTIVE_WORK
synthesis/ledger.json
recent commits touching every file you intend to modify
```

Do not reset, clean, force-checkout, revert, or overwrite unrelated concurrent work.

The GitHub offload inspection saw `main` at:

```text
b4c88f6244d2ebe23df137d4c07b3158dab14ec2
```

That SHA is **orientation only**. Local current `main` wins.

The repository history has been rewritten/squashed since the old v4.7 orientation snapshot.
Do not attempt to reason from the old v4.7 SHA range.

---

# 2. What Is Already Implemented — Preserve It

The following v4.7 work was observed as already implemented on current `main`.

Treat these as **regression constraints**, not as greenfield tasks:

```text
CognitionEngine routine candidate selection is deterministic.

Operating-loop evaluation is deterministic.

Operating-loop response decision is deterministic.

Canonical threat propagation is substantially repaired.

Decision-bearing records reach allocation.

allow_execute=False is enforced before real execution.

Deferred/held actions remain visible.

DroneState selection uses canonical serving semantics.

Response -> executable effect mapping is explicit/fail-closed.

Current-cycle sensor observations are separated from persisted history.

The master observer uses the real sensor.scan(...) channels rather than scan_generic.

Automatic repair is cycle-scoped instead of blindly retriggering old history.

Capability-gap synchronization is current-state aware.

Resource synchronization no longer treats lifetime execution count as utilization.

Automatic damage triage is provider-independent.

Autonomic catastrophe assessment/reconciliation is provider-independent.

Catastrophe reconciliation returns post-transition truth.

Consecutive tick failures now reset as a real consecutive streak.

Operating-loop learning reaches the shared exploration strategy.

CollectiveMemory propagation uses the real remember(...) contract.

Attention-budget work and priority-normalization work already exist in the live operating loop.

Focused tests already exist for these areas.
```

Relevant current tests observed include current equivalents of:

```text
test_catastrophe_is_deterministic.py
test_consecutive_tick_failures.py
test_damage_triage_is_provider_independent.py
test_master_observer_sensor_channels.py
test_operating_loop_attention_bound.py
test_operating_loop_priority_allocation.py
test_operating_loop_threat_vocabulary.py
test_phase_status_truth.py
test_repair_is_cycle_scoped.py
test_sync_is_deterministic.py
```

Do not rewrite these mechanisms unless current-main evidence proves a regression or incomplete contract.

---

# 3. Why This Closure Prompt Still Exists

The live repository still contains **provider-backed selectors and stale model-first tests outside the already-repaired master operating loop**.

The remaining job is therefore:

```text
1. find every live provider/model-assisted selector that can still hold
   routine Borg/Collective control authority;

2. classify each one correctly;

3. make ROUTINE_CONTROL_FLOW deterministic/provider-independent;

4. preserve GENUINE_SYSTEM_TWO model use;

5. remove or retire DEAD/UNREACHABLE model-routing code only when proven safe;

6. delete/update tests that still assert the retired model-first architecture;

7. prove provider-on/provider-off equivalence for all routine control paths.
```

Do not “clean up every file containing the word provider.”
Reachability and authority matter.

---

# 4. Known Residual Findings From the Offload Pass

Reinspect each finding against current local `main` before changing it.

## 4.1 Stale contradictory provider-wiring tests

Current main still contained:

```text
tools/doubletake_evolve/tests/test_provider_wiring.py
```

Its module-level purpose still described LLM paths as the normal production path, and it contained
tests asserting provider use for routine operating-loop and cognition decisions.

Examples observed during offload:

```text
TestOperatingLoopTranslateProviderWiring
TestCognitionEngineProviderWiring
```

including assertions equivalent to:

```text
provider.call_count >= 1
LLM path used, not deterministic fallback
```

This now contradicts the deterministic runtime.

Do not preserve stale tests merely to keep the old architecture green.

Classify every test in this module:

```text
A. still-valid explicit System-Two/provider propagation test
B. obsolete routine-control model-first test
C. unrelated test that belongs elsewhere
```

For category B:

```text
remove it
OR
rewrite it into the inverse invariant:
provider must NOT be called for the routine control path
```

Do not weaken production determinism to satisfy stale tests.

---

## 4.2 Stale cognition prompt integration test

Current main still contained:

```text
tools/doubletake_evolve/collective_core/test_cognition_prompt.py
```

with tests for the old model-first cognition integration.

The live `CognitionEngine._select_and_gate(...)` observed during offload had already become
deterministic and did not accept a provider argument.

Yet the test file still contained a test equivalent to:

```text
test_select_and_gate_uses_llm_when_provider_available
```

and attempted:

```python
engine._select_and_gate(..., provider=provider, ...)
```

That is stale architecture.

Keep parser/helper unit tests only if the helper still has a legitimate explicit System-Two caller.
Do not preserve an integration assertion that routine candidate selection should use an LLM.

---

## 4.3 Dormant/dead cognition model-selection helper

Current main still contained:

```text
tools/doubletake_evolve/collective_core/cognition_prompt.py
```

with both:

```text
deterministic_select_candidate(...)
llm_select_candidate(...)
```

The live cognition engine observed during offload called only:

```text
deterministic_select_candidate(...)
```

Audit all imports/callers of:

```text
llm_select_candidate
build_select_prompt
parse_select_response
```

If no legitimate explicit System-Two caller remains:

```text
remove the dead model-selection helper surface
and remove/update its stale tests
```

If a real explicit System-Two consumer exists, retain it only behind that explicit boundary.
Do not let it become callable from normal `CognitionEngine` routing again.

---

## 4.4 Dormant/dead operating-loop LLM helper surface

Current main still contained many helpers in:

```text
tools/doubletake_evolve/collective_integration/operating_loop_prompt.py
```

including current equivalents of:

```text
llm_evaluate_observations
llm_decide_observations
llm_classify_observations
llm_strategic_match
llm_adapt_learnings
llm_task_kind_for
llm_select_drone
llm_assess_learning_outcome
llm_allocate_resources
llm_reach_consensus
llm_assess_gap_priorities
llm_assess_resources
```

The repaired split operating-loop modules no longer appeared to call the routine evaluator/decider
helpers during the offload inspection.

Do not delete this file blindly.

For **every helper**:

```text
trace imports
trace production callers
classify authority
```

Then:

```text
ROUTINE_CONTROL_FLOW -> remove/disconnect model authority
GENUINE_SYSTEM_TWO    -> keep behind explicit governed reasoning path
DEAD/UNREACHABLE      -> remove if imports/tests prove safe
UNKNOWN               -> trace further before changing
```

Do not retain dead model-routing code merely because old unit tests exercise it directly.

---

## 4.5 Residual executor model helper

Current main still contained:

```text
tools/doubletake_evolve/collective_integration/operating_loop/executor.py
```

with a helper equivalent to:

```text
_task_kind_for_with_llm(...)
```

The live `_execute(...)` path observed during offload used the deterministic `_task_kind_for(...)`
mapping instead.

Prove whether `_task_kind_for_with_llm` has any live caller.

If none:

```text
remove it and any dead imports/tests
```

Do not reintroduce provider-selected action->task-kind mapping into routine execution.

---

# 5. Highest-Value Remaining Authority Audit

The largest remaining risk is no longer the repaired master loop.
It is **provider-backed control authority elsewhere in the live Borg/Collective execution stack**.

Audit these current files first.

---

## 5.1 `borg_decomposer.py`

Current main still had:

```text
WorkDecomposer._select_strategy(...)
```

with a provider-aware model path using current equivalent of:

```text
llm_select_strategy(...)
```

Determine whether decomposition-strategy selection is:

```text
ROUTINE_CONTROL_FLOW
or
GENUINE_SYSTEM_TWO
```

Do not decide from the word “decomposition.”

Ask:

```text
Does the model output select among a closed set of existing bounded strategies?

Does that selection directly determine the ordinary execution branch?

Can the same decision already be derived from task shape, explicit user choice,
available capabilities, constraints, dependency information, or current config?

Is the provider invoked merely because one is configured?

Is this reached by the normal Collective execution path without a prior explicit
System-Two escalation?
```

If yes to the routine-control shape:

```text
make strategy selection deterministic
```

Preserve provider/model reasoning only if this call is itself the explicit System-Two work,
not merely a selector deciding which bounded implementation path will run.

---

## 5.2 `borg_completer.py`

Current main still had:

```text
CollectiveCompleter.reach_consensus(..., provider=...)
```

with a model-first completion/consensus verdict path.

This is a high-priority audit target because a completion verdict can control:

```text
finish
continue
regenerate
partial/deferred
failure handling
```

If the verdict is derived from already-measured execution/coherence facts and a bounded threshold,
it is routine control and must be deterministic.

The model may be useful for a separate explanation/diagnostic, but it must not silently override
the measured completion state merely because a provider exists.

---

## 5.3 `borg_execution.py`

Current main still accepted:

```text
CollectiveExecutionEngine.execute(..., provider=None)
```

and forwarded `provider` into current equivalents of:

```text
decomposer.decompose(... provider=provider)
completer.reach_consensus(... provider=provider)
regeneration completion verdicts
```

This makes `borg_execution.py` the critical reachability bridge.

Trace every production caller of:

```text
CollectiveExecutionEngine.execute
```

Determine whether the provider argument is:

```text
never supplied in ordinary operation
explicitly supplied only by a governed System-Two route
or supplied by routine production execution
```

Do not infer safety from the default being `None`.

If routine production can supply a provider, close every routine selector it reaches.

---

## 5.4 `borg_collective_orchestrator.py`

Current main described this orchestrator as the active Collective workflow authority and still stored:

```text
self._provider
```

and called current equivalent of:

```text
self._completer.reach_consensus(..., provider=self._provider)
```

Trace all constructors of:

```text
BorgCollectiveOrchestrator
```

and all paths that set `provider`.

If this is the normal production workflow:

```text
routine completion/consensus must not vary with provider presence
```

A provider may remain attached for explicit reasoning work executed *inside* an explicit
System-Two task, but must not be the normal consensus authority.

---

## 5.5 `capability_router.py`

Current main still contained:

```text
rank_candidates(..., provider=None)
```

with `_llm_rank_candidates(...)` as a model-first ranking path when a provider is supplied.

This needs careful classification.

The repository now relies heavily on automatic capability participation, so a model ranking
candidate capabilities can hold real routing authority.

Determine:

```text
Does routine user intent -> capability participation pass a provider here?

Does provider output alter which capability executes?

Are all candidate ranking signals already machine-readable
(similarity, reliability, governance, failure avoidance, declared schemas, composition fit)?

Is semantic retrieval merely evidence retrieval, or does model output choose the final route?
```

Required boundary:

```text
retrieval/semantic similarity may help retrieve candidates

final routine candidate ordering/selection must be deterministic from recorded signals
unless an explicit System-Two routing task was intentionally invoked
```

Do not destroy semantic retrieval merely because deterministic final routing is required.

---

## 5.6 `assimilation_queue.py`

Current main still contained:

```text
evaluate_target(... provider=...)
```

and a model-backed target-worth result.

Audit whether the output can automatically decide:

```text
assimilate
skip
queue
promote
reject
```

during ordinary operation.

If yes, and measurable evidence already exists, make the authoritative go/no-go deterministic.

If deeper semantic analysis is genuinely required:

```text
record need for explicit System-Two evaluation
do not let a routine queue tick silently obtain model authority
```

---

## 5.7 `write_code_e2e.py`

Current main still contained:

```text
assess_worthiness(... provider=None)
```

with a model-first worthiness branch.

Trace current production callers.

If worthiness determines whether DoubleTake automatically writes code,
that is consequential control authority and must not silently change based on provider availability.

Use existing measurable evidence and governance for the gate.

If genuine semantic judgment is necessary, route it as explicit System-Two work whose result returns
through the normal governed code-generation/mutation boundary.

---

# 6. Routine Borg Provider Injection

Current main still contained current equivalent of:

```text
tools/doubletake_evolve/collective_core/_mixins/borg_loop.py::_get_loop_provider
```

and the routine Borg-loop handle registration still appeared capable of adding:

```text
handles["provider"] = _get_loop_provider()
```

The repaired master operating loop does not need a provider for normal:

```text
observe
classify
evaluate
decide
allocate
execute/defer
measure
learn
repair
synchronize
```

Audit all consumers of the registered `"provider"` handle.

If no legitimate routine consumer remains:

```text
remove routine provider injection from the Borg operating-loop handle set
```

Do **not** globally remove:

```text
OpenCodeProvider
APIProvider
Codex provider/runtime
model_provider_routing
session runtime
explicit System-Two infrastructure
```

The goal is a clean authority boundary, not provider deletion.

---

# 7. Sensor-Network Provider Paths

Current main still contained provider-assisted scanners in:

```text
collective_integration/sensor_network.py
collective_integration/sensor_network_prompt.py
```

for current equivalents of:

```text
executions
fleet
assimilation
regenerator
predictive
executor
```

The repaired master observer deliberately called:

```text
sensor.scan(...)
```

without a provider.

That is good but not sufficient proof.

Trace every production caller that supplies `provider=` to the sensor network.

Classify each:

```text
routine autonomic sensing
explicit diagnostic/System-Two sensing
dead/unreachable
```

If a live routine caller lets provider output alter:

```text
anomaly kind
threat level
actionable state
automatic safety/recovery state
```

make that path deterministic or separate the semantic interpretation as an explicit,
non-authoritative diagnostic.

Do not remove dormant prompt helpers solely because they exist.

---

# 8. Strategic Planner Prompt Surface

Current main still contained:

```text
collective_integration/strategic_planner_prompt.py
```

with current equivalent of:

```text
llm_translate_to_tactics(...)
```

The repaired operating-loop decision path was observed using deterministic strategic translation.

Trace every remaining caller.

If no explicit System-Two caller remains:

```text
remove/retire the model translation path and stale tests
```

If an explicit planning/reasoning feature uses it, retain it there but prove the routine tick
cannot invoke it.

---

# 9. Damage-Triage Semantic Review — Preserve the Correct Boundary

Current main already separated:

```text
BorgDamageTriage.triage(...)
```

from:

```text
BorgDamageTriage.semantic_review(... provider=...)
```

The automatic path is deterministic.

Preserve this pattern.

`semantic_review` is acceptable only if it remains:

```text
explicit
non-authoritative
non-mutating
not called by automatic repair
unable to fabricate DamageReports as authoritative automatic state
```

Use this as the model for other residual provider-assisted selectors:

```text
deterministic automatic authority
+
optional explicit semantic second opinion
```

where appropriate.

---

# 10. Required Repo-Wide Audit

Search the current repository, not only the files named above.

At minimum search for:

```text
provider.complete
_get_loop_provider
provider=
llm_
model-first
normal production decision path
fallback when provider unavailable
fallback without provider
reach_consensus
select_strategy
rank_candidates
evaluate_target
assess_worthiness
translate_to_tactics
semantic_review
```

Audit at least:

```text
tools/doubletake_evolve/collective_core/
tools/doubletake_evolve/collective_core/_mixins/
tools/doubletake_evolve/collective_integration/
tools/doubletake_evolve/borg_capability_fabric/
tools/doubletake_evolve/collective_governance/
production CLI/API workflow entrypoints that construct the Borg/Collective runtime
```

For every model/provider-assisted decision found, create an internal classification table:

```text
file/function
production callers
provider source
what output the model controls
closed bounded choice or open-ended reasoning?
can it authorize mutation?
can it alter automatic safety/recovery?
can it alter capability execution?
can it alter completion/consensus?
current deterministic facts already available
classification
required change
tests
```

Classification vocabulary:

```text
ROUTINE_CONTROL_FLOW
GENUINE_SYSTEM_TWO
DEAD_UNREACHABLE
DIAGNOSTIC_NON_AUTHORITATIVE
UNKNOWN
```

No `UNKNOWN` may remain at final acceptance.

---

# 11. Deterministic-Control Rule

A provider-backed function is **ROUTINE_CONTROL_FLOW** when its result can directly decide an
ordinary internal branch from already-bounded machine state, including current equivalents of:

```text
which existing strategy to use
which existing candidate wins
which existing capability executes
whether execution is complete
whether to regenerate
whether an assimilation target is automatically accepted/rejected
whether automatic code writing is allowed
which routine tactical response runs
whether automatic repair/safety state changes
```

For these:

```text
provider availability must not alter the result
```

A provider-backed function is **GENUINE_SYSTEM_TWO** when the requested work itself is open-ended,
for example:

```text
novel architecture
coding
unbounded debugging
research
semantic synthesis
new algorithm design
complex diagnosis after bounded deterministic diagnostics are exhausted
explicit user-requested reasoning
explicit governed escalation from deterministic control
```

Do not disguise routine selection as System Two merely because an LLM can perform it.

---

# 12. Stale Tests Must Be Reconciled

Do not carry contradictory test suites forever.

Audit at minimum:

```text
tools/doubletake_evolve/tests/test_provider_wiring.py
tools/doubletake_evolve/collective_core/test_cognition_prompt.py
tools/doubletake_evolve/collective_integration/test_strategic_planner_prompt.py
any tests that say:
    "LLM path used"
    "provider was called"
    "normal production decision path"
    "fallback when provider unavailable"
```

For each stale test:

```text
delete it if the behavior is retired
or
invert it into a provider-must-not-be-called guard
or
move/rewrite it around a genuine explicit System-Two feature
```

Never modify deterministic production code merely to satisfy a stale model-first test.

---

# 13. Required Negative Provider Guard

Create a reusable focused test pattern for routine control:

```python
class ProviderMustNotBeCalled:
    def complete(self, *args, **kwargs):
        raise AssertionError("routine Borg control attempted provider access")
```

Use it through real production paths, not only private helpers.

Prove current equivalents of:

```text
routine CognitionEngine selection
master operating-loop decision path
routine completion/consensus if live
routine decomposition-strategy selection if live
routine capability route selection if live
routine assimilation go/no-go if live
routine write-code worthiness gate if live
routine automatic sensor/repair/sync/catastrophe path
```

do not call the provider.

Do not add tests for a path that is proven dead; remove the dead path instead.

---

# 14. Provider-On / Provider-Off Equivalence

For every routine control surface that can still receive provider state, prove:

```text
same machine-readable state
same current repository/config/governance state
provider configured
vs
provider absent
-> same deterministic route/verdict/action
```

Compare meaningful outputs, not only function return types.

Examples:

```text
selected decomposition strategy
completion verdict
selected capability
assimilation accept/reject
worthiness gate
routine tactical route
automatic recovery route
```

If a model is intentionally used only for explanation:

```text
authoritative result must remain identical
only optional explanation/suggestion may differ
```

---

# 15. Preserve Explicit System Two

Do not break legitimate model use.

When a residual model path is classified `GENUINE_SYSTEM_TWO`, prove:

```text
it has an explicit caller boundary
the caller knows it is requesting reasoning/generation
it is not silently invoked merely because provider exists
its output cannot bypass governance
mutating results still pass through existing validation/authorization/evidence
provider failure has an honest governed outcome
```

Reuse current:

```text
session runtime
provider routing
OpenCode/Codex infrastructure
worktree-backed implementation paths
governed execution/mutation boundaries
```

Do not add another launcher.

---

# 16. Dead-Code Removal Rules

Remove a model helper only after proving:

```text
no production caller
no explicit System-Two caller
no supported external API contract requires it
no live import depends on it
```

When removing:

```text
remove stale tests
remove stale imports
remove stale comments/docstrings claiming model-first production behavior
remove dead prompt builders/parsers if nothing else uses them
```

Do not leave a comment saying “normal production path uses LLM” after the runtime no longer does.

Do not retain historical dead code merely for symmetry.

Version control already preserves history.

---

# 17. Scope Control

Do not use this closure pass to redesign:

```text
Borg/Collective architecture
capability fabric
nanoprobes
assimilation architecture
project evolution
provider infrastructure
session runtime
OpenCode/Codex integration
semantic retrieval
governance framework
```

unless a minimal change is required to close a verified provider-authority defect.

Do not refactor already-fixed operating-loop code for style.

Do not port Von.

Do not add neural routing.

Do not add another scoring framework.

Do not add a policy DSL.

---

# 18. Required Tests

Add/update the smallest tests that prove the residual closure.

At minimum:

```text
[ ] stale routine model-first provider-wiring tests are removed or inverted

[ ] CognitionEngine routine selection cannot call provider

[ ] no live routine operating-loop evaluator/decider/tactical/executor path
    depends on operating_loop_prompt LLM helpers

[ ] dead routine cognition/operating-loop LLM helpers are removed where proven unused

[ ] all live callers of WorkDecomposer provider-backed strategy selection are classified

[ ] routine decomposition strategy, if applicable, is provider-independent

[ ] all live callers of CollectiveCompleter provider-backed consensus are classified

[ ] routine completion/consensus, if applicable, is provider-independent

[ ] BorgCollectiveOrchestrator cannot obtain a different routine completion verdict
    merely because a provider is configured

[ ] CollectiveExecutionEngine routine behavior is provider-independent for bounded control choices

[ ] capability-router final routine route is provider-independent
    OR its model path is proven explicit System Two/non-authoritative

[ ] automatic assimilation target gating is provider-independent
    OR semantic judgment is explicit System Two and cannot silently authorize assimilation

[ ] automatic write-code worthiness is provider-independent
    OR semantic judgment is explicit System Two and cannot silently authorize mutation

[ ] routine Borg-loop provider handle injection is removed if no legitimate routine consumer remains

[ ] sensor-network model-assisted paths have complete production-caller classification

[ ] no live routine sensor caller lets model output alter actionable anomaly/threat state

[ ] strategic planner LLM tactical translation has no routine authority

[ ] damage-triage semantic review remains explicit and non-authoritative

[ ] provider-on/provider-off equivalence is proven for every surviving routine provider-aware API

[ ] explicit System-Two model paths still work

[ ] repo-wide audit leaves zero UNKNOWN provider-authority classifications
```

---

# 19. Baseline and Validation

Before editing, run focused tests around the exact residual surfaces.

Record:

```text
HEAD
status
baseline pass/fail
which failures are stale architecture tests
which failures are unrelated/pre-existing
```

After each small change, run the corresponding focused tests.

Then run the repository's current standard validation, including current equivalents of:

```bash
make validate
```

and, when practical:

```bash
make prove-product-readiness
```

Do not fabricate green status.

Classify failures as:

```text
introduced by this delta
pre-existing
stale test/spec contradiction
concurrent change
environmental/external
```

If the broad suite still contains stale model-first tests, fix/remove those tests rather than
counting them forever as an accepted baseline.

---

# 20. Work Loop

Repeat until closure:

```text
1. read current HEAD/status/ACTIVE_WORK
2. choose one remaining provider-assisted decision surface
3. trace every production caller
4. classify its authority
5. if ROUTINE_CONTROL_FLOW:
       make deterministic/provider-independent
   elif GENUINE_SYSTEM_TWO:
       make the explicit boundary unmistakable
   elif DEAD_UNREACHABLE:
       remove if safe
   elif DIAGNOSTIC_NON_AUTHORITATIVE:
       prove it cannot control automatic behavior
   else:
       continue tracing
6. reconcile stale tests/docstrings/imports
7. run focused tests
8. prove provider-on/provider-off equivalence when applicable
9. inspect current main for concurrent edits
10. move to the next surface
```

Stop only when the repo-wide audit has **zero unresolved routine provider-authority paths**.

---

# 21. Acceptance Criteria

Do not claim completion until all applicable items are true:

```text
[ ] current local HEAD/status/ACTIVE_WORK recorded
[ ] old v4.7 orientation SHA is not treated as authoritative

[ ] already-fixed deterministic operating-loop behavior remains intact

[ ] stale test_provider_wiring model-first assertions are reconciled
[ ] stale CognitionEngine provider-selection integration tests are reconciled

[ ] every llm_* / provider.complete routine-control helper in the Borg/Collective area
    has a proven classification

[ ] no UNKNOWN classification remains

[ ] CognitionEngine routine candidate selection remains deterministic

[ ] WorkDecomposer strategy selection cannot silently become model-authoritative
    during ordinary execution

[ ] CollectiveCompleter completion/consensus cannot silently become model-authoritative
    during ordinary execution

[ ] BorgCollectiveOrchestrator routine completion behavior is provider-independent

[ ] CollectiveExecutionEngine routine bounded control choices are provider-independent

[ ] capability-router final routine capability choice is deterministic from recorded signals
    or its model-assisted path is explicitly non-authoritative/System-Two

[ ] automatic assimilation go/no-go is deterministic
    or semantic review is explicitly escalated and governed

[ ] automatic write-code go/no-go is deterministic
    or semantic review is explicitly escalated and governed

[ ] routine Borg operating-loop subsystem registration does not inject a provider
    without a proven legitimate consumer

[ ] routine sensor state/action authority does not depend on provider output

[ ] strategic tactical translation has no hidden routine model authority

[ ] dead model-first prompt/helper code is removed only where safe

[ ] comments/docstrings/tests no longer describe retired LLM routing as
    "the normal production path"

[ ] provider presence/absence produces identical routine decisions from identical state

[ ] explicit System-Two provider use remains available and governed

[ ] no unrelated provider infrastructure is deleted

[ ] no duplicate controller/router/policy engine is introduced

[ ] focused tests pass or every failure is truthfully classified

[ ] current repository validation is run and reported honestly

[ ] final diff contains only intended closure changes plus identified concurrent work
```

---

# 22. Final Report

When complete, report concisely:

```text
1. final HEAD
2. baseline and final status
3. files changed/removed
4. stale tests removed/rewritten
5. complete provider-authority classification table
6. routine selectors made deterministic
7. dead model-routing helpers removed
8. explicit System-Two model paths preserved
9. Borg-loop provider registration before/after
10. capability-router authority result
11. decomposer authority result
12. completer/consensus authority result
13. assimilation gate authority result
14. write-code gate authority result
15. sensor-network provider-call classification
16. provider-on/provider-off equivalence proofs
17. focused test results
18. broad validation results
19. pre-existing/concurrent/environment failures
20. remaining limitations
```

---

# Final Rule

Do not rerun the whole v4.7 implementation.

Close the remaining authority leaks.

The task is complete when:

```text
routine Borg/Collective routing, ranking, completion, gating, safety,
recovery, and automatic mutation decisions are deterministic from
machine-readable state and existing governance;

provider presence cannot change those routine decisions;

dead model-first control code and stale contradictory tests are gone;

and explicit System-Two reasoning still works through the existing
governed provider infrastructure.
```
