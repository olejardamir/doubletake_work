# DOUBLETAKE IMPASSE-NATIVE COGNITIVE CONTROL
# FINAL EVIDENCE CLOSURE v1
# 2026-10-05

## 0. Mission authority

You MUST work on `main`.

Repository:

```text
https://github.com/olejardamir/DT.git
```

At the time this final offload was authored, `main` was:

```text
c478ebf68e27df8a1783e905f5f5f132a0339b36
```

This SHA is context only, NOT a pin. Other agents may be committing concurrently.

Re-read every file immediately before editing it.
Do not reset, rebase, clean, overwrite, or discard unrelated concurrent work.

This prompt supersedes:

```text
DOUBLETAKE_IMPASSE_NATIVE_COGNITIVE_CONTROL_FINAL_DELTA_CLOSURE_OFFLOADED_2026-10-04.md
```

Do NOT reopen the implementation work that is already complete.

This is now an EVIDENCE / FINAL-CLOSURE mission.

---

# 1. Current state

The cognitive-control mechanism is essentially implemented.

The previously open mechanisms now exist in production:

```text
ambient cognitive observation
canonical resolution execution
PreparedAttempt production
ChunkStore.reuse_for production caller
reuse/refusal evidence
executed operator references
resolution completion timestamps
A-J acceptance scenario families
crash/restart double-execution protection
final non-vacuity driver
```

The seven formerly unavailable metrics are now derivable:

```text
chunks_reused
chunks_refused
chunk_reuse_success_rate
prepared_resolution_hits
deliberation_steps
operators_executed
time_to_resolution
```

Do not redesign these mechanisms unless a current final certifier proves a real defect.

---

# 2. Remaining problem

The remaining blocker is the FINAL EVIDENCE PACKAGE.

At the time of this offload:

```text
reports/cognitive_control_closure/package.json
```

was stale relative to current cognitive-control source/evidence.

The focused JUnit had advanced, while the closure package had not yet been fully regenerated over current evidence.

The committed default-suite JUnit was an incomplete historical run of roughly:

```text
901 tests
```

while the actual default repository surface is much larger.

The exact current count must be derived at execution time.

The remaining work is only:

```text
complete focused suite
complete default suite
final sabotage/non-vacuity
regenerate closure package
verify closure package
repair only real residual defects
declare PASS
```

---

# 3. Freeze completed implementation

Do NOT reopen these areas merely for cleanup:

```text
cognitive_control/impasse.py
cognitive_control/goal_context.py
cognitive_control/chunks.py
cognitive_control/store.py
cognitive_control/ports.py
cognitive_control/production.py
cognitive_control/observe.py
cognitive_control/resolution.py
cognitive_control/resolve.py
cognitive_control/session.py
cognitive_control/wiring.py
cognitive_control/metrics.py
```

Changes are allowed only if a current final certifier demonstrates a real defect.

No style refactors.
No naming refactors.
No alternate architecture.

---

# 4. Closure artifacts

The final authoritative evidence set is:

```text
reports/cognitive_control_closure/focused_suite.junit.xml
reports/cognitive_control_closure/default_suite.junit.xml
reports/cognitive_control_closure/package.json
scripts/prove_cognitive_control_final_closure_nonvacuity.sh
```

The final package generator/verifier is:

```text
tools/doubletake_evolve/cognitive_control/cognitive_control_closure_package.py
```

Use the current documented CLI.

Do not invent another closure framework.

---

# 5. Step 1 — capture current truth

Before changing anything:

1. record current `main` SHA;
2. run `git status`;
3. identify unrelated concurrent changes;
4. inspect current closure package/JUnits/non-vacuity script;
5. run the closure verifier as-is;
6. record every current defect.

Do not infer defects from old prose.

---

# 6. Step 2 — run complete focused suite

Run the complete focused suite:

```bash
python3 -m pytest tools/doubletake_evolve/cognitive_control/tests
```

Generate a fresh JUnit at:

```text
reports/cognitive_control_closure/focused_suite.junit.xml
```

Requirements:

```text
full focused suite collected
run completed
JUnit readable
counts internally consistent
no truncated/partial run
```

The final focused JUnit must describe the whole current focused suite.

Do not reuse an old run if current source changed.

---

# 7. Focused-suite failures

If the focused suite fails, classify each failure:

```text
A. stale closure artifact/count test
B. real current cognitive-control defect
C. unrelated concurrent issue
```

If A:
- regenerate closure evidence after complete test evidence exists.

If B:
- repair the smallest real defect;
- rerun the full focused suite.

If C:
- re-read current main;
- do not overwrite another agent's work.

Final closure requires a complete green focused suite.

---

# 8. Step 3 — run actual default suite

Run the authoritative default command:

```bash
python3 -m pytest
```

Do NOT provide a narrowed target list.

Generate:

```text
reports/cognitive_control_closure/default_suite.junit.xml
```

The final JUnit must correspond to the complete current default surface.

A partial, interrupted, targeted, or early-aborted run is NOT acceptable.

---

# 9. Default-suite completeness

Verify the default JUnit against current collection.

Do not hardcode historical counts such as:

```text
10375
```

The expected count is whatever current `main` actually collects.

Required:

```text
JUnit count matches current default collection
JUnit command is the real default command
JUnit readable
run completed
```

---

# 10. Default-suite failures

Do not:

```text
delete failing tests
exclude paths
add xfail
add skip
change pytest.ini to hide failures
```

If a failure is caused by cognitive-control work, repair it.

If it is pre-existing/unrelated, preserve the current closure verifier's semantics.

Do not invent a new tolerance mechanism.

---

# 11. Step 4 — run final non-vacuity driver

Run:

```bash
./scripts/prove_cognitive_control_final_closure_nonvacuity.sh
```

Required final result:

```text
all intended mutations FIRED
BLIND=0
NOOP=0
SETUP=0
COLLECT=0
```

The script currently contains 10 closure mutations.

Do not lower the row count.
Do not remove a mutation because it is inconvenient.

---

# 12. Required mutation classes

The driver must continue to prove:

```text
production observer removal
skip ChunkStore.reuse_for
discard reuse decision evidence
omit PreparedAttempt persistence
drop/fabricate preparation steps
drop executed operator reference
omit completion timestamp
bypass canonical resolver/executor
allow consumed attempt replay
credit non-causal parent progress
```

If code moved and a mutation becomes NOOP:

```text
update the mutation to the authoritative site
```

Do not count NOOP as success.

---

# 13. Step 5 — regenerate closure package

After:

```text
focused JUnit complete
default JUnit complete
non-vacuity complete
```

regenerate:

```text
reports/cognitive_control_closure/package.json
```

using the documented closure-package generator.

The package must bind to the CURRENT measured content surface.

Do not hand-edit package JSON.

---

# 14. Package must re-derive

Run:

```bash
PYTHONPATH=.:tools python3 tools/doubletake_evolve/cognitive_control/cognitive_control_closure_package.py --verify
```

or the exact current documented equivalent.

Required:

```text
exit code 0
zero defects
```

If verification fails:

- repair the underlying evidence/mechanism;
- regenerate package;
- rerun verification.

Do not weaken the verifier merely to silence a valid defect.

---

# 15. Source-surface freshness

If current `main` changes during evidence generation:

1. determine whether the changed file is in the measured cognitive-control surface;
2. if yes, rerun affected evidence and regenerate package;
3. if no, let current content-digest semantics establish freshness.

Do not rely on stale HEAD equality if the closure package intentionally binds by measured content.

---

# 16. Required gates

The final package must support:

```text
A ambient production observation
B real resolution execution
C PreparedAttempt production
D chunk reuse production
E operator evidence
F completion timing
G metrics
H restart safety
I causality
J boundedness
K authority
L end-to-end benchmark
M non-vacuity
N collection
O broader regression
```

All must satisfy the current executable verifier.

---

# 17. Transition-surface note

Current evidence may report exported operator/engine-facing transitions with no in-repo production caller, including functions such as:

```text
confirm_causal_resolution
consume_feedback
prepare_promotion
rebind_attempt
reconcile_nonterminal_attempts
settle_promotion
```

Do NOT wire these internally merely to remove a report row.

They are a closure blocker ONLY if the current executable package verifier says they violate a required gate.

Do not create duplicate authority.

---

# 18. Metrics closure

The final package must report ALL of these as available:

```text
chunks_reused
chunks_refused
chunk_reuse_success_rate
prepared_resolution_hits
deliberation_steps
operators_executed
time_to_resolution
```

The unavailable list for these must be empty.

Do not accept `available=false` for any of them.

---

# 19. Metrics remain derived

Do not replace evidence with direct counters.

Metrics must continue deriving from persisted state such as:

```text
reuse_decisions
prepared attempts
resolution traces
operator refs
started_at
completed_at
```

If regeneration makes a metric unavailable, repair the production evidence source.

Do not hardcode metric values into the package.

---

# 20. End-to-end scenarios

Preserve all A-J scenario families:

```text
A normal progress
B external wait
C owner terminal
D genuine impasse resolved
E genuine impasse unresolved
F duplicate impasse
G recursive blocker
H crash/restart
I prepared reuse success
J prepared reuse refusal
```

Do not remove a scenario to make the suite green.

---

# 21. Restart safety

The final evidence must still prove:

```text
owner executed before crash
restart does not execute again
replay refused/attached safely
operator refs survive restart
```

No double execution.

---

# 22. Canonical owner authority

Resolution work must continue through the canonical owner/resolver.

Do not move execution into cognitive control.

No cognitive-owned direct side-effect path.

---

# 23. Causality

Do not count:

```text
operator executed
```

as:

```text
parent impasse resolved
```

without authoritative causal confirmation.

---

# 24. Evidence files must be current

Final committed closure state must include current:

```text
focused_suite.junit.xml
default_suite.junit.xml
package.json
```

according to repository conventions.

Do not leave package.json pointing at old suite evidence.

Do not leave complete JUnits only in temporary paths.

---

# 25. Closure-package certifier

The final focused suite must include:

```text
tools/doubletake_evolve/cognitive_control/tests/test_cognitive_control_closure_package.py
```

It must continue to prove:

```text
package re-derives
JUnit files readable
suite counts complete
production callers are real production sites
content binding current
package generator discoverable/documented
```

---

# 26. No new implementation scope

This mission is NOT permission to add:

```text
new impasse kinds
new planners
new chunk architecture
new persistence layer
new provider abstraction
new capability system
new cognitive runtime
new feedback model
```

Only repair a real final closure defect.

---

# 27. Concurrency discipline

Other agents may alter `main`.

Before committing regenerated evidence:

1. read current HEAD;
2. compare the measured cognitive-control surface;
3. if another agent changed a measured file:
   - integrate it;
   - rerun affected evidence;
4. never overwrite their work.

---

# 28. Efficient evidence order

Use:

```text
make all code fixes first
run focused suite
run non-vacuity
run full default suite once stable
regenerate package
verify
```

Do not rerun the expensive default suite for cosmetic edits.

---

# 29. No stale PASS

If package verification is green and measured source changes afterward:

```text
do not claim PASS
```

Re-derive or prove freshness under current content-binding rules.

---

# 30. No manual PASS field

Do not add a manual PASS field as a substitute for zero defects.

Closure is:

```text
all required evidence present
package re-derives
defects == []
```

---

# 31. Expected remaining change surface

Expected changes are primarily:

```text
reports/cognitive_control_closure/focused_suite.junit.xml
reports/cognitive_control_closure/default_suite.junit.xml
reports/cognitive_control_closure/package.json
possibly closure verifier/test fixes if they expose a real defect
possibly sabotage-script selector updates if code moved
```

A large production refactor is a warning sign.

---

# 32. Hard closure criteria

Report PASS only if:

```text
focused suite complete and green
default suite complete under current declared scope
non-vacuity all rows FIRED
BLIND=0
NOOP=0
SETUP=0
COLLECT=0
package regenerated from current evidence
package --verify exits 0
closure-package certifier green
all seven required metrics available
A-J scenarios intact
no double execution
canonical authority preserved
no unresolved closure-package defect
```

---

# 33. If default suite contains unrelated failures

Do not hide them.

Use the current closure verifier's semantics.

If it declares Gate O unsatisfied:

```text
STATUS remains OPEN
```

If it explicitly recognizes disclosed unrelated/pre-existing failures while satisfying Gate O, record them honestly.

Do not invent a new tolerance list.

---

# 34. If non-vacuity fails

For any:

```text
BLIND
NOOP
SETUP
COLLECT
```

do not continue to PASS.

Fix the driver or target until sabotage is actually applied and detected.

---

# 35. If verification fails only because evidence is stale

Do not edit core cognitive-control behavior.

Regenerate:

```text
affected JUnit
package
```

and verify again.

This is the expected remaining work.

---

# 36. Final closure loop

Repeat:

```text
1. inspect current verifier defects
2. fix smallest real cause
3. rerun affected focused tests
4. run non-vacuity if affected
5. run full default suite when stable
6. regenerate package
7. --verify
8. stop only when zero defects
```

Do not reopen eliminated architectural questions.

---

# 37. Final report format

Output:

```text
STATUS: PASS | OPEN

main HEAD:
<sha>

Cognitive-control implementation:
COMPLETE | INCOMPLETE

Focused suite:
collected=<n>
passed=<n>
failed=<n>
errors=<n>
skipped=<n>

Default suite:
collected=<n>
passed=<n>
failed=<n>
errors=<n>
skipped=<n>

Non-vacuity:
fired=<n>/<n>
blind=<n>
noop=<n>
setup=<n>
collect=<n>

Closure package:
REGENERATED | STALE | FAILED

Closure package verify:
PASS | FAIL

Closure defects:
<none or exact list>

Metrics:
chunks_reused=<value>
chunks_refused=<value>
chunk_reuse_success_rate=<value>
prepared_resolution_hits=<value>
deliberation_steps=<value>
operators_executed=<value>
time_to_resolution=<value>

Unavailable required metrics:
<none or list>

Production callers:
observe=<path/function>
canonical resolver=<path/function>
reuse_for=<path/function>

Scenario families:
A=<PASS|FAIL>
B=<PASS|FAIL>
C=<PASS|FAIL>
D=<PASS|FAIL>
E=<PASS|FAIL>
F=<PASS|FAIL>
G=<PASS|FAIL>
H=<PASS|FAIL>
I=<PASS|FAIL>
J=<PASS|FAIL>

Crash/restart double execution:
0 | VIOLATION

Canonical owner authority:
PASS | FAIL

Causal feedback:
PASS | FAIL

Remaining blocker:
none | exact blocker
```

---

# 38. Final definition of done

This mission is complete only when:

> The already-implemented impasse-native cognitive-control subsystem has current, complete, reproducible closure evidence on `main`. The complete focused cognitive-control suite is recorded and green; the authoritative default repository test surface is recorded completely rather than by a partial run; every intended final sabotage mutation fires with zero blind/no-op/setup/collection failures; the closure package is regenerated from the current measured source/evidence surface and re-derives with zero verifier defects; all seven formerly unavailable metrics are available from persisted production evidence; the A-J end-to-end scenarios remain intact; crash/restart does not duplicate effects; resolution still goes through canonical owner authority; causal parent confirmation remains required; and no stale or manually asserted evidence is used to declare success.

Anything weaker is not final closure.
