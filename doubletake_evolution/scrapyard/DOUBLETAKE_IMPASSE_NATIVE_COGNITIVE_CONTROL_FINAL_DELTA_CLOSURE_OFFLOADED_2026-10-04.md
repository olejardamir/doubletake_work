# DOUBLETAKE IMPASSE-NATIVE COGNITIVE CONTROL
# OFFLOADED FINAL DELTA / CLOSURE MISSION
# 2026-10-04

## 0. Mission authority

You MUST work on `main`.

Repository:

```text
https://github.com/olejardamir/DT.git
```

At the time this offload was authored, current `main` was:

```text
b43c609dc46a261acf935cdb2fb0c6836579a969
```

That SHA is context only, NOT a pin. Other agents may be working on the same `main`.

Re-read the files you are about to change immediately before editing them.
Do not reset, rebase, clean, overwrite, revert, or discard unrelated concurrent work.

This mission supersedes the broad checkpoint:

```text
DOUBLETAKE_IMPASSE_NATIVE_COGNITIVE_CONTROL_CHECKPOINT_v2_2026-10-04.md
```

Do NOT rerun the original checkpoint from the beginning.

The majority of the cognitive-control substrate now exists and is covered by executable tests.
This mission is intentionally narrow:

> finish the remaining production wiring, make the remaining unavailable metrics derivable from real evidence, prove the entire impasse-resolution loop through real DoubleTake execution paths, and close the checkpoint without reopening already-solved work.

---

# 1. Current status

Treat these as findings to REVERIFY on current `main`, not assumptions to trust blindly.

Since the earlier checkpoint baseline around:

```text
9f99be3e5ddb80d2e77f13f19f04da11195239cb
```

the repository has added a substantial cognitive-control subsystem under:

```text
tools/doubletake_evolve/cognitive_control/
```

including:

```text
__init__.py
chunks.py
goal_context.py
identity.py
impasse.py
metrics.py
models.py
observe.py
ports.py
production.py
resolution.py
session.py
store.py
vocab.py
```

and a large focused test suite.

The package is now explicitly collected by `pytest.ini` under:

```text
tools/doubletake_evolve/cognitive_control/tests
```

Approximate status at this offload:

```text
mechanism/substrate implementation: ~85-90%
overall checkpoint closure: ~75%
```

The remaining work is concentrated in production consumption, evidence generation, and final end-to-end closure.

---

# 2. Completed areas to preserve, not reimplement

Reinspect these areas and treat them as FROZEN INVARIANTS unless an executable failing test proves a real defect.

Do not refactor them merely for style.

## 2.1 Typed impasse classification

Preserve:

```text
owner-terminal before impasse
external/resumable wait before impasse
insufficient evidence -> unclassifiable, not invented fifth impasse type
closed impasse vocabulary
classifier versioning
```

## 2.2 Goal/subgoal lineage

Preserve:

```text
root/child identity derivation
generation/lineage identity
recursive blocker protection
bounded depth
single active resolution child
```

## 2.3 Attempt control

Preserve:

```text
CAS-based claim
one non-terminal attempt per child
per-child attempt budget
root cumulative budget
start fence before owner call
no refund after start
restart reconciliation
safe pre-effect rebind only
unsafe rebind terminalization
separate re-observation budget
```

## 2.4 Goal-scoped context

Preserve:

```text
LOCAL context isolation
PARENT_VISIBLE promotion only
stale-revision refusal
terminal-goal invisibility
full control ledger visibility
bounded context
```

## 2.5 Feedback causality

Preserve:

```text
one-shot parent feedback
causal attribution
non-causal progress not credited
promotion intent != committed promotion
owner reference on settled promotion
```

## 2.6 Persistence and concurrency

Preserve:

```text
cross-process flock
no process-local lock fallback
CAS mutation
atomic write
schema fencing
unknown newer schema fail-closed
strict document parsing
run-scoped state
restart persistence
cursor/high-water mark
bounded audit outbox
```

## 2.7 Decision evidence

Preserve:

```text
every governed disposition recorded
external waits recorded
owner terminal recorded
ordinary non-impasse recorded
stale/refusal decisions recorded
duplicate suppression recorded
bounded decision ledger
bounded pending outbox
published event retirement
```

A non-vacuity driver already exists for this mechanism.

Do not reopen it unless that driver or focused tests fail.

## 2.8 Prepared chunk integrity

Preserve:

```text
candidate vs verified distinction
independent verification
negative applicability
hard preconditions
dependency drift
execution-scope mismatch
attestation integrity
version fences
quarantine
retention
verified knowledge not directly executing without authority
```

The remaining gap is productive use, not the chunk-store safety model itself.

---

# 3. Known remaining gaps

The current repository itself names these gaps in:

```text
tools/doubletake_evolve/cognitive_control/metrics.py
```

Reverify them before implementing.

At authoring time the remaining unavailable metrics were tied to four concrete missing production mechanisms.

---

# 4. GAP A — chunk reuse has no production caller

Current finding:

```text
ChunkStore.reuse_for has no production caller
```

Therefore these metrics remain unavailable:

```text
chunks_reused
chunks_refused
chunk_reuse_success_rate
```

This is not a metrics bug.

Do NOT patch the metrics layer to invent counts.

The missing mechanism is:

> real production resolution work must consult verified prepared knowledge through `ChunkStore.reuse_for(...)`, record the reuse/refusal outcome, and preserve all current applicability/governance gates.

---

# 5. GAP B — no production PreparedAttempt construction

Current finding:

```text
no production mechanism constructs PreparedAttempt
```

Therefore these metrics remain unavailable:

```text
prepared_resolution_hits
deliberation_steps
```

Do NOT fake these in metrics.

The missing mechanism is:

> the real resolution path must create and persist a bounded PreparedAttempt representation when deliberation/preparation actually occurs.

PreparedAttempt must reflect real work, not be populated solely to make metrics non-zero.

---

# 6. GAP C — no executed-operator evidence

Current finding:

```text
ResolutionTrace.operator_refs is initialized empty
and no production path appends the actually executed operator
```

Therefore:

```text
operators_executed
```

remains unavailable.

The fix is NOT:

```text
operator_refs=("some-placeholder",)
```

The fix is:

> record the authoritative identity/reference of the actual resolution operator/effect owner that ran.

The reference must come from the canonical execution owner.

Do not synthesize an operator identity inside cognitive control.

---

# 7. GAP D — no completion timing evidence

Current finding:

```text
ResolutionTrace.completed_at is not stamped by the production settlement path
```

Therefore:

```text
time_to_resolution
```

remains unavailable.

The fix is:

> stamp trace completion from the same authoritative transition that terminalizes the resolution attempt.

Do not add a metrics-side timestamp.

---

# 8. GAP E — prove ambient production use

The cognitive-control package now exposes production seams such as:

```text
bind_session
observe_owner_fact
observe_canonical_task
observe_project_evolution
observe_governed_meta_cycle
observe_capability_participation
```

but final closure requires evidence that relevant real DoubleTake production paths actually consume the subsystem.

Do not interpret the existence of `production.py` and `observe.py` as proof of ambient production use.

The closure target is:

> real canonical DoubleTake execution reaches cognitive observation/control automatically when governed conditions occur, without a test manually instantiating the subsystem.

---

# 9. GAP F — final end-to-end impasse resolution loop

The checkpoint is not closed until a production-like scenario proves:

```text
real task
-> owner facts observed
-> genuine impasse classified
-> one bounded resolution child opened
-> one attempt claimed
-> prepared/reused resolution selected where applicable
-> canonical owner executes actual resolution work
-> executed operator/reference recorded
-> feedback emitted
-> parent re-observed
-> causal resolution established or withheld
-> parent resumes or blocks correctly
-> trace terminalized with completion time
-> all evidence persists/reloads
```

Drive this through real owners/adapters, not disconnected unit fixtures.

---

# 10. Architectural rule — cognitive control coordinates; owners remain authoritative

Cognitive control MUST NOT take ownership of:

```text
capability relevance
capability execution
provider inference
project mutation
security policy
governance
operator run state
trial creation
user answers
effect execution
rollback
final output selection
```

Those remain canonical owner responsibilities.

Cognitive control owns only:

```text
goal/subgoal cognitive state
impasse identity/classification
resolution lineage
attempt claims
bounded resolution control
context visibility
feedback linkage
prepared/chunk reuse metadata
decision evidence
cognitive persistence
```

---

# 11. Do not create a second executor

The remaining production work must reuse:

```text
OwnerPorts.require_canonical_executor()
```

or the actual canonical owner abstraction on current `main`.

Do not add a cognitive-owned effect executor.

Every real side effect stays behind its existing owner.

---

# 12. Exact closure direction for prepared reuse

The production resolution path should conceptually follow:

```text
resolution child
    |
    v
derive applicability/signature
    |
    v
ChunkStore.reuse_for(...)
    |
    +-- VERIFIED reusable chunk
    |       |
    |       v
    |   prepare executable attempt from verified core
    |
    +-- refusal / no reusable chunk
            |
            v
       perform fresh bounded deliberation
            |
            v
       create PreparedAttempt
```

Then:

```text
governance/operator start fence
-> canonical execution
-> evidence
-> feedback
```

A chunk must never bypass:

```text
operator control
governance
execution scope
dependency validation
hard applicability
attempt budget
start fence
```

---

# 13. Reuse decisions must become real evidence

When production calls `ChunkStore.reuse_for(...)`, record a real decision outcome.

Do not infer later from success/failure support counters alone.

Evidence must distinguish:

```text
reuse accepted
reuse refused
no candidate
```

and preserve the existing named refusal reason where available.

Do not duplicate the chunk store's refusal vocabulary.

---

# 14. Metrics remain derived

`metrics.py` must remain a reader/deriver.

Do NOT add counters such as:

```python
chunks_reused += 1
operators_executed += 1
```

After production gaps close, metrics become derivable from real persisted records.

Success is:

```text
remove GAP_CAUSES entries only because the real evidence source now exists
```

not because tests were relaxed.

---

# 15. PreparedAttempt requirements

A production-created PreparedAttempt must be:

```text
bounded
digest-sealed
lineage-scoped
attempt-scoped
applicability-bound
replay-safe
persisted
restart-readable
```

It must identify enough real resolution preparation to derive:

```text
prepared_resolution_hits
deliberation_steps
```

Do not create dummy step records.

---

# 16. Fresh preparation vs prepared reuse

Distinguish:

```text
prepared reuse
fresh preparation
```

A prepared hit occurs only when previously verified knowledge materially reduces new resolution work.

Do not count lookup alone as a prepared hit.

---

# 17. Operator reference

`operator_refs` must contain the identity of actual executed canonical resolution work.

Derive it from the owner/executor result.

The identity must be:

```text
stable enough for audit
non-secret
specific enough to distinguish executed operators
bound to the trace/attempt
```

Do not use arbitrary placeholders.

---

# 18. Completion timestamp

Stamp `completed_at` when the trace becomes terminal through authoritative settlement.

Terminal resolution traces should have a completion timestamp unless a documented exceptional state makes timing unknowable.

Non-terminal traces must not carry fake completion timestamps.

---

# 19. Preserve restart semantics

When adding prepared/executed evidence:

- do not resurrect consumed attempts after crash;
- do not double-execute after restart;
- do not double-count reuse;
- do not overwrite an existing operator reference;
- do not stamp a second different completion time;
- preserve awaiting-parent-feedback restart behavior.

Add restart tests around each new production field.

---

# 20. Production wiring target

Identify the actual canonical production points that naturally emit owner facts.

Do NOT spray cognitive-control calls into dozens of modules.

Prefer a small number of shared boundaries.

Candidate families to inspect include current equivalents of:

```text
canonical task/run control
project evolution loop
meta-reasoning cycle
capability participation
provider/tool execution owner
```

Use existing observer functions where their contracts match.

---

# 21. Observation semantics

Preserve the existing distinction:

```text
cognitive substrate unavailable
```

versus:

```text
real cognitive refusal/disposition
```

If cognitive control cannot be reached because of substrate/integration failure, existing owner behavior must not be replaced with a fabricated impasse.

But once cognitive control derives a real refusal, do not silently drop it.

---

# 22. Canonical owner facts only

Do not classify impasses from prose emitted by an LLM when machine-readable owner facts exist.

Adapt authoritative owner state into the existing observation model.

Do not teach `classify()` to parse strings.

---

# 23. Required scenario families

Final integration evidence must drive at least:

## A. No impasse

```text
no child
no attempt
NOT_AN_IMPASSE decision recorded
```

## B. External wait

```text
WAITING_EXTERNAL
no child
no attempt
no attempt-budget charge
```

## C. Owner terminal

```text
OWNER_TERMINAL
no child
no attempt
```

## D. Genuine impasse resolved

```text
one child
bounded attempt
canonical execution
feedback
parent progress
CAUSAL where owner evidence proves it
terminal trace
```

## E. Genuine impasse unresolved

```text
bounded attempts
no infinite loop
parent blocks/fails according to existing semantics
```

## F. Duplicate impasse

```text
suppressed
no duplicate child
decision evidence recorded
```

## G. Recursive blocker

```text
refused
no recursive explosion
```

## H. Crash/restart

```text
no duplicate side effect
correct reconciliation
```

## I. Prepared reuse success

```text
reuse decision recorded
verified prepared material actually used
canonical authority still executes
```

## J. Prepared reuse refusal

```text
refusal reason observable
rejected prepared core not executed
fresh preparation may proceed if allowed
```

---

# 24. Final acceptance/benchmark suite

Create a small final cognitive-control acceptance suite that exercises the complete mechanism through real integration boundaries.

Reuse real:

```text
CognitiveSession
OwnerPorts
ChunkStore
canonical executor
production observers
state store
```

Do not create a parallel fake implementation.

The benchmark must report derived evidence, not merely “scenario passed”.

---

# 25. Non-vacuity for remaining work only

Existing decision-evidence non-vacuity is already implemented.

Add sabotage only for the remaining closure mechanisms.

At minimum perturb:

```text
remove production observer call
skip ChunkStore.reuse_for
discard reuse decision evidence
do not construct PreparedAttempt
drop prepared step records
leave operator_refs empty after execution
omit completed_at on settlement
bypass canonical executor
double-execute after restart
ignore feedback causality
```

Classify each mutation:

```text
FIRED
BLIND
NOOP
```

A mutation that did not apply is not evidence.

---

# 26. Production-caller gap guards must turn over

Current tests deliberately prove some symbols have no production callers.

When the real production caller is added, those gap tests should fail until updated.

Correct transition:

```text
before:
gap detector proves missing caller

after implementation:
gap detector fails because caller exists

then:
remove corresponding GAP_CAUSES entry
replace absence proof with derivation proof
```

Do not preserve stale gap assertions.

---

# 27. Metrics that MUST become derivable

If this mission succeeds, these currently missing metrics must become derivable:

```text
chunks_reused
chunks_refused
chunk_reuse_success_rate
prepared_resolution_hits
deliberation_steps
operators_executed
time_to_resolution
```

Do not leave them unavailable and still call the broad checkpoint closed.

---

# 28. Non-zero metric proof

For every newly derivable metric:

- drive at least one real scenario where it becomes non-zero;
- prove it recomputes from persisted evidence;
- prove removing the evidence changes the metric;
- do not increment a direct counter.

---

# 29. Chunk reuse rate correctness

Define the denominator from real reuse decisions.

Do not substitute:

```text
verified chunks / candidate chunks
```

unless that is actually a reuse-attempt definition.

Derive:

```text
reuse attempts
reuse successes
reuse refusals
```

from real evidence.

---

# 30. Time-to-resolution correctness

Derive:

```text
completed_at - started_at
```

for completed resolution traces.

Do not use current wall time for a completed metric.

No completed traces means unavailable/unknown, not zero.

---

# 31. Cross-run knowledge scope

Prepared chunks are cross-run/scope knowledge.

Preserve:

```text
repository scope
security scope
execution scope
dependency digests
hard preconditions
verification evidence
```

Do not weaken these gates to increase reuse.

---

# 32. Knowledge never owns execution

A verified chunk is prepared knowledge.

Even reused knowledge must still pass:

```text
claim attempt
start fence
owner control
governance
canonical execution
```

---

# 33. One-child/one-attempt remains binding

Do not add speculative parallel attempts to speed closure.

The bounded discipline remains authoritative.

---

# 34. Causal feedback remains binding

Operator execution alone does NOT prove the parent impasse was resolved.

Causal success still requires authoritative parent re-observation/evidence.

---

# 35. File-by-file likely work map

Reconfirm each path on live `main`.

## `cognitive_control/metrics.py`

- remove GAP_CAUSES entries only after evidence exists;
- derive newly available metrics from real persisted evidence;
- no counters.

## `cognitive_control/resolution.py`

- integrate actual operator reference into trace settlement;
- stamp terminal completion time;
- preserve restart/rebind/feedback semantics.

## `cognitive_control/models.py`

Change only if new persisted evidence genuinely needs schema support.

Any new digest-carrying record must be:

```text
sealed
strictly parsed
tamper-tested
migration-aware
```

## `cognitive_control/chunks.py`

Use current reuse semantics from production.
Do not weaken verified/reuse gates.

## `cognitive_control/session.py`

Coordinate new production evidence while preserving bounded lineage/attempt semantics.

## `cognitive_control/observe.py`

Wire existing observer seams from real production callers.

## `cognitive_control/production.py`

Keep shared ambient binding.
Do not duplicate runtime authority.

## `cognitive_control/ports.py`

Extend only if a canonical owner fact/executor reference is genuinely unavailable through current ports.

---

# 36. External production integration

Discover the smallest number of canonical production locations where cognitive observation belongs.

Likely families:

```text
project evolution
meta reasoning
capability participation
run/operator control
workflow execution
```

Do not edit external owners until their actual call graph is mapped.

---

# 37. No broad refactor

Reject work whose main purpose is:

```text
renaming modules
rewriting dataclasses
replacing persistence
replacing test framework
style cleanup
unrelated enterprise changes
unrelated capability-routing work
```

unless required by a failing closure invariant.

---

# 38. Baseline before editing

Before implementation:

1. record current HEAD;
2. run cognitive-control focused tests;
3. run existing non-vacuity driver(s);
4. derive current metrics report;
5. record unavailable metrics;
6. prove current production-caller gaps;
7. identify actual production integration points.

Do not use old counts from this prompt as assertions.

---

# 39. Required implementation order

## Phase 1 — production observation wiring

Make real canonical runtime paths call existing cognitive observers.

Prove:

```text
ambient
fail-soft on unavailable substrate
no fabricated impasse
real refusal not dropped
```

## Phase 2 — canonical resolution execution wiring

Ensure actual resolution attempts use the canonical owner/executor and return a stable operator reference.

## Phase 3 — PreparedAttempt production

Create/persist real PreparedAttempt from actual resolution preparation.

## Phase 4 — ChunkStore reuse production path

Call `reuse_for` before fresh preparation where applicability permits.

Record accepted/refused outcomes.

## Phase 5 — trace evidence

Record:

```text
operator refs
completion timestamps
prepared/reuse linkage
```

## Phase 6 — metrics turnover

Remove now-closed GAP_CAUSES.
Derive metrics from evidence.
Drive non-zero proofs.

## Phase 7 — end-to-end scenarios

Run complete real integration loops.

## Phase 8 — sabotage/non-vacuity

Add targeted mutation driver for new mechanisms.

## Phase 9 — final closure

Run focused + default tests and produce closure evidence.

---

# 40. Production observation proof

For each real production path wired, drive the real entrypoint and prove:

```text
observer reached
canonical owner facts supplied
decision persisted
owner authority preserved
```

Do not prove integration by manually calling the observer.

---

# 41. Canonical executor proof

Final integration tests must fail if the resolution path bypasses:

```text
OwnerPorts.require_canonical_executor()
```

or the current equivalent.

Add a sabotage case replacing canonical execution with a direct call.

---

# 42. PreparedAttempt proof

A real resolution scenario must produce a PreparedAttempt whose:

```text
goal
attempt
applicability
step records
```

correspond to actual preparation.

Restart/reload and prove the same record survives intact.

---

# 43. Reuse success proof

Drive:

1. an initial run that produces independently verified prepared knowledge;
2. a later compatible run;
3. production lookup through `reuse_for`;
4. accepted reuse;
5. real reduction in fresh preparation work;
6. canonical execution still occurs.

Do not manually call `reuse_for` as the only use.

---

# 44. Reuse refusal proof

Drive at least one verified chunk refusal caused by a real changed preimage such as:

```text
dependency drift
execution-scope change
hard precondition failure
negative applicability
version mismatch
```

Require:

```text
refusal reason observable
rejected core not executed
fresh bounded preparation allowed where appropriate
```

---

# 45. Completion-time proof

Drive:

```text
attempt start
actual execution
settlement
```

Assert a real completion timestamp.

On restart, it remains unchanged.

---

# 46. Operators-executed proof

Drive at least two distinct real operator/executor references.

Metric must derive executed count from trace evidence.

Keep:

```text
operators_considered
```

distinct from:

```text
operators_executed
```

---

# 47. Deliberation proof

Fresh preparation must create real bounded step records.

Prepared reuse should reduce or skip fresh preparation where appropriate.

Use this to prove:

```text
deliberation_steps
prepared_resolution_hits
```

have meaningful semantics.

---

# 48. Bounded unresolved resolution proof

Drive a resolver that cannot fix the parent.

Expected:

```text
bounded attempts
bounded re-observation
eventual block/failure
no runaway subgoal recursion
```

---

# 49. Concurrency and crash proof

Preserve/extend coverage for:

```text
two workers claim same attempt
two processes write state
restart races
duplicate reuse decision
duplicate feedback consumption
```

No double effect.

Also exercise crash cut points around:

```text
before claim
after claim before start
after start before owner call
after owner effect before settlement
after settlement before feedback
after feedback before parent consumption
after parent consumption before terminal persistence
```

Reuse existing reconciliation semantics.

---

# 50. Evidence sealing

Any new persisted closure evidence must:

```text
carry schema version
carry digest
fail on tamper
reject unknown newer schema
round-trip exactly
```

Extend derived coverage guards so new digest-carrying records cannot be forgotten.

---

# 51. No raw sensitive content

Preserve current prepared-knowledge privacy/scope rules.

Do not persist raw secrets merely to make reuse easier.

---

# 52. Provider/model role

Impasse classification remains deterministic from owner facts.

A model may participate in resolution only through the canonical existing provider/executor owner.

A model must not decide:

```text
whether a state is an impasse
whether governance is allowed
whether an effect occurred
whether the parent was causally resolved
```

---

# 53. Final benchmark metric surface

The final driven report should cover the repository's authoritative Section-28 list, including at least:

```text
impasses_opened
impasses_resolved
impasses_blocked
external_waits
owner_terminal_events
resolution_children_created
resolution_depth_max
resolution_attempts
resolution_attempts_started
resolution_attempts_failed
reobservations_used
duplicate_impasses_suppressed
chunks_candidate
chunks_verified
chunks_invalidated
chunks_reused
chunks_refused
chunk_reuse_success_rate
operators_considered
operators_executed
prepared_resolution_hits
deliberation_steps
time_to_resolution
```

If current-main list differs, current code is authoritative.

---

# 54. Final metric availability target

The seven currently missing metrics must no longer be excused by missing production mechanisms.

If one remains unavailable:

```text
checkpoint remains OPEN
```

unless the original broad mission explicitly permits it and the external reason is independently proven.

---

# 55. Final non-vacuity driver

Create one focused final driver, e.g.:

```text
scripts/prove_cognitive_control_final_closure_nonvacuity.sh
```

or equivalent convention.

It should target only the remaining closure mechanisms.

Final expected result:

```text
all intended mutations FIRED
BLIND=0
NOOP=0
```

Do not rerun every historical cognitive-control mutation unless needed.

---

# 56. Required focused tests

Run:

```text
tools/doubletake_evolve/cognitive_control/tests
```

plus all new production integration/closure tests and collection/evidence guards.

Do not cherry-pick happy-path tests.

---

# 57. Required broader tests

After focused green, run the authoritative default repository test command.

Record:

```text
passed
failed
skipped
```

Distinguish pre-existing unrelated failures.

Do not hide them.

---

# 58. Closure evidence artifact

If repository conventions support it, create a machine-readable final cognitive-control closure report containing:

```text
source HEAD
focused test result
default test result
benchmark scenarios
metric availability
non-vacuity result
production caller map
operator evidence
prepared/reuse evidence
crash/restart result
remaining gaps
```

The artifact is not sufficient alone; tests must verify the critical claims.

---

# 59. No stale checkpoint prose as authority

The original checkpoint is now historical context.

Current executable evidence wins.

Do not preserve statements that a mechanism is missing after it is proven present.

Do not declare a mechanism done merely because an old section says so.

---

# 60. Closure gates

PASS requires ALL:

## Gate A — ambient production observation

Real canonical production paths reach cognitive observation automatically.

## Gate B — real resolution execution

Resolution attempts reach the canonical executor/owner.

## Gate C — PreparedAttempt production

Real preparation creates persisted PreparedAttempt records.

## Gate D — chunk reuse production

`ChunkStore.reuse_for` has a real production caller and accepted/refused outcomes are evidenced.

## Gate E — operator evidence

Actual executed operator references are persisted.

## Gate F — completion timing

Terminal traces record real completion timestamps.

## Gate G — metrics

The seven formerly unavailable metrics are derivable from real evidence.

## Gate H — restart safety

No new double-execution/resurrection defect.

## Gate I — causality

Resolution success is credited only when parent evidence proves it.

## Gate J — boundedness

Depth, attempts, re-observation, outbox, context, and knowledge remain bounded.

## Gate K — authority

No duplicate executor/planner/governance authority introduced.

## Gate L — end-to-end benchmark

Real production-like scenario proves full loop.

## Gate M — non-vacuity

Final closure mutation driver fires for every intended mechanism.

## Gate N — collection

All closure tests are collected/certified.

## Gate O — broader regression

No unresolved new regression attributable to this mission.

---

# 61. Do not offload further before these gates

This file is already the offloaded closure mission.

Do not reduce it again merely because unit tests are green.

A further offload is only appropriate when:

```text
all mechanism work is complete
and only final evidence/report cleanup remains
```

---

# 62. Hard stop conditions

Stop only at:

## SUCCESS

```text
STATUS: PASS
remaining blocker: none
```

or:

## HONEST BLOCKER

```text
STATUS: OPEN
exact failing test/mechanism
```

Do not paper over a blocker by leaving its metric unavailable.

---

# 63. Required final report

Output:

```text
STATUS: PASS | OPEN

main HEAD:
<sha>

Original broad checkpoint:
OFFLOADED

Cognitive-control focused tests:
<exact result>

Default pytest:
<exact result>

Production observation sites:
<exact paths/functions>

Canonical resolution executor:
<exact owner/path>

PreparedAttempt production:
PASS | FAIL

ChunkStore.reuse_for production caller:
<path/function or NONE>

Chunk reuse evidence:
PASS | FAIL

Chunk refusal evidence:
PASS | FAIL

Executed operator refs:
PASS | FAIL
source=<exact owner/result>

Resolution completed_at:
PASS | FAIL

Previously unavailable metrics:
chunks_reused=<derived|unavailable>
chunks_refused=<derived|unavailable>
chunk_reuse_success_rate=<derived|unavailable>
prepared_resolution_hits=<derived|unavailable>
deliberation_steps=<derived|unavailable>
operators_executed=<derived|unavailable>
time_to_resolution=<derived|unavailable>

End-to-end resolved impasse:
PASS | FAIL

End-to-end unresolved impasse:
PASS | FAIL

External wait:
PASS | FAIL

Owner terminal:
PASS | FAIL

Crash/restart:
PASS | FAIL

Causal feedback:
PASS | FAIL

Final non-vacuity:
<fired>/<attempted>
blind=<n>
noop=<n>

Remaining blocker:
none | exact blocker
```

---

# 64. Final definition of done

This mission is complete only when executable evidence supports the entire statement below:

> DoubleTake's impasse-native cognitive-control subsystem is not merely a tested internal library but an ambient, bounded production control spine. Real governed runtime paths automatically provide canonical owner facts to cognitive observation. Genuine autonomous blockages create exactly one bounded resolution lineage while external waits, terminal owner states, and ordinary progress do not. Resolution attempts reuse independently verified prepared knowledge when applicability permits, otherwise construct real bounded PreparedAttempt evidence, and always execute through the existing canonical owner rather than a cognitive-owned executor. Actual executed operator references and terminal completion times are persisted. Feedback is consumed exactly once, causal credit is awarded only when parent evidence warrants it, crash/restart does not duplicate effects, and context/persistence/concurrency bounds remain intact. `ChunkStore.reuse_for` is reached from production, accepted and refused reuse decisions are observable, all formerly unavailable Section-28 metrics are derivable from real evidence, the complete impasse-to-resolution-to-parent-resume/block loop passes through real integration boundaries, and the new remaining mechanisms are protected by a non-vacuous sabotage suite. No duplicate planner, provider, capability, governance, execution, or security authority has been introduced.

Anything weaker is not final closure.
