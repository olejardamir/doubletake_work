# DoubleTake — Impasse-Native Cognitive Control Final Evidence Closure
## OFFLOADED TERMINAL DELTA — 2026-10-05

Repository:

`/home/glompy/Desktop/OTHER_PROJECTS/DT/`

Work directly on the authoritative `main` branch.

**Other agents may be working on the same `main` concurrently. Do not create a parallel implementation, do not reset or clean away other work, and do not assume that the HEAD named in this prompt is still current when you execute it. Reinspect current `main` before every material decision and again before final closure.**

---

# 1. Mission

This is the reduced terminal-delta prompt derived from:

`DOUBLETAKE_IMPASSE_NATIVE_COGNITIVE_CONTROL_FINAL_EVIDENCE_CLOSURE_v1.md`

The impasse-native cognitive-control implementation is already substantially complete. Do **not** restart the original mission, redesign the subsystem, or repeat work that current repository evidence already proves.

Your job is now narrower:

> **Close the remaining cognitive-control evidence freshness, suite-record, package-regeneration, and final-verification delta, and stop only when the committed evidence package truthfully describes current authoritative DoubleTake state.**

The current problem is not “build cognitive control again.”  
The current problem is “make the final closure evidence current, internally consistent, independently re-derivable, and non-vacuous.”

Repository reality overrides every starting observation below.

---

# 2. Audited starting state to recheck

At the time this prompt was offloaded, audited GitHub `main` was:

`e117f732b7a1b582c3ef746c1fee810d46d46d84`

Treat that SHA only as a historical starting observation. Resolve current HEAD yourself.

The following had already been implemented and should be treated as **closed unless current evidence proves otherwise**:

- production cognitive observation;
- impasse classification;
- canonical resolution driving;
- canonical resolver ownership;
- `PreparedAttempt` production;
- prepared-resolution lookup and reuse;
- persisted reuse decisions;
- operator-reference evidence;
- completion timing;
- restart/double-execution protection;
- causal confirmation;
- bounded attempts/re-observation;
- decision evidence;
- scenario families A–J;
- closure gates A–O;
- the seven required formerly-unavailable metrics;
- the final non-vacuity driver;
- measured-surface content binding;
- complete-suite coverage checks;
- suite-count/JUnit agreement checks;
- documented regeneration recipe.

The closure artifact currently lives at:

`reports/cognitive_control_closure/package.json`

The two committed suite records are:

`reports/cognitive_control_closure/focused_suite.junit.xml`

`reports/cognitive_control_closure/default_suite.junit.xml`

The authoritative generator/verifier is:

`tools/doubletake_evolve/cognitive_control/cognitive_control_closure_package.py`

The non-vacuity driver is:

`scripts/prove_cognitive_control_final_closure_nonvacuity.sh`

---

# 3. Known remaining delta to verify, not blindly assume

At offload time, the committed package still recorded a source binding around:

`273d999da846576c520b73b1d8763cb483e5512b`

and recorded approximately:

- focused suite: 523 tests, 2 failures;
- default suite: 10,588 tests, 408 failures, 18 skipped.

Subsequent verifier work proved that the package could be stale relative to its own committed JUnit evidence. In particular, the strengthened verifier found a state where the package still recorded:

- default failures: 408
- default skipped: 18

while the JUnit beside it re-derived:

- default failures: 393
- default skipped: 17.

The important commits to understand, if still relevant to current history, include:

- `5c712783a06c5ae62ba8709007ea6d875a3c6461`
  - complete focused/default suite records were produced;
- `b3f1f860d2485d740cc4a1750cae967e725d9fbc`
  - the closure verifier was strengthened to re-read and compare the JUnit counts it certifies;
- `7541930d61675e9cc9196497ba28e6661621d1db`
  - the suite-count non-vacuity guard was corrected so it tests its own mechanism rather than merely reporting a neighbouring stale-package defect.

No later cognitive-control commit had yet been observed regenerating the final package after those verifier changes.

**Recheck all of this on current `main`. Do not preserve these numbers if current evidence differs.**

---

# 4. Authority order

Use this authority order:

1. current `main`;
2. current production cognitive-control code;
3. current tests and non-vacuity drivers;
4. current `AGENTS.md` regeneration procedure;
5. current committed JUnit artifacts;
6. current closure package;
7. this offloaded prompt.

The package is evidence, not authority over the code.

A stale package must be regenerated.  
Do not weaken current code to make an old package true.

---

# 5. Preserve already-closed architecture

Do not make speculative architecture changes merely because the closure artifact contains a `remaining_gaps` entry.

At offload time it contained one recorded limitation:

- six public transitions in `resolution.py` had no in-repository production caller:
  - `confirm_causal_resolution`
  - `consume_feedback`
  - `prepare_promotion`
  - `rebind_attempt`
  - `reconcile_nonterminal_attempts`
  - `settle_promotion`

The package explicitly explains these as the operator/engine-facing or owner-resumption half of the protocol, intentionally not automatically called inside cognitive control because the outer owner remains authoritative.

**Do not wire these functions merely to make `remaining_gaps` empty.**

Only change that architecture if current production evidence demonstrates that the mission actually requires an in-package caller and that the existing ownership explanation is false.

A truthful recorded limitation is preferable to duplicate authority.

---

# 6. Baseline and concurrency safety

Before changing anything:

```sh
cd /home/glompy/Desktop/OTHER_PROJECTS/DT

git branch --show-current
git rev-parse HEAD
git status --short
git log -1 --oneline
```

Require branch:

`main`

Record:

- baseline HEAD;
- initial working-tree state;
- pre-existing modifications;
- current package source binding;
- current JUnit counts;
- current verifier result.

Do not:

- `git reset --hard`;
- `git clean`;
- discard another worker's files;
- replace another worker's in-flight edits;
- create a competing branch as the authoritative result;
- treat an uncommitted shared-tree state as final evidence.

If `main` moves while you work:

1. inspect the incoming commits;
2. determine whether they touch the cognitive-control measured surface, the JUnits, the generator/verifier, or its tests;
3. re-run only the measurements invalidated by that movement;
4. never silently carry an evidence result across a changed measured surface.

---

# 7. First action: diagnose current truth

Run the authoritative verifier **before changing anything**:

```sh
PYTHONPATH=.:tools python3 \
  tools/doubletake_evolve/cognitive_control/cognitive_control_closure_package.py \
  --verify
```

Do not summarize the result as merely PASS/FAIL.

Classify each reported defect into one of these categories:

1. **package/JUnit disagreement**  
   The package records numbers different from its own JUnit.

2. **incomplete or stale JUnit**  
   The JUnit does not cover what its recorded pytest command currently collects.

3. **measured-surface drift**  
   Code/tests used by the package changed since the bound measurement.

4. **derived-gate drift**  
   Gate, caller, metric, family, transition, or non-vacuity derivation changed.

5. **real cognitive-control regression**  
   Current focused behavior is actually broken.

6. **unrelated default-suite failure**  
   The broad repository suite has failures outside the cognitive-control closure surface.

7. **concurrent-tree contamination**  
   The shared checkout changed during a measurement.

Do not fix category 6 merely to reduce the default-suite failure count.

Do fix category 5.

---

# 8. Authoritative regeneration chain

The current repository documents this chain:

```sh
PYTHONPATH=.:tools python3 -m pytest \
  tools/doubletake_evolve/cognitive_control/tests \
  --junit-xml=reports/cognitive_control_closure/focused_suite.junit.xml

PYTHONPATH=.:tools python3 -m pytest \
  --junit-xml=reports/cognitive_control_closure/default_suite.junit.xml

PYTHONPATH=.:tools python3 \
  tools/doubletake_evolve/cognitive_control/cognitive_control_closure_package.py

PYTHONPATH=.:tools python3 \
  tools/doubletake_evolve/cognitive_control/cognitive_control_closure_package.py \
  --verify
```

Re-read `AGENTS.md` and the generator before executing this. If the repository has changed the authoritative procedure, use the current repository procedure rather than this copied version.

The two JUnits must remain repo-relative committed evidence.

Do not type counts into `package.json`.

Do not hand-edit a JUnit to match the package.

Do not hand-edit `package.json` to match a JUnit.

The generator must read the measurements and derive the package.

---

# 9. Required convergence loop

A single pass may be insufficient.

The focused suite contains closure-certifier tests that can correctly fail while the package is stale. Regenerating the package can therefore change the next focused-suite result. The default suite also includes those tests.

Use this convergence loop:

```text
A. Inspect current package + JUnits + HEAD.

B. Run/refresh any suite whose evidence is incomplete, stale, mismatched,
   or invalidated by measured-surface movement.

C. Regenerate package.json from the actual committed/current JUnits.

D. Run --verify.

E. Re-run the focused suite against the regenerated package.

F. If the focused result changed, refresh focused_suite.junit.xml,
   regenerate package.json, and verify again.

G. Re-run the default suite when its recorded result is no longer a faithful
   measurement of the current closure state or when package/certifier changes
   alter its cognitive-control result.

H. Regenerate package.json again after any JUnit changes.

I. Repeat until another complete cycle produces no material change in:
   - focused JUnit result;
   - default JUnit result relevant to this mission;
   - package-derived counts;
   - measured-surface digest;
   - gates/families/metrics/non-vacuity derivations;
   - verifier defect set.
```

Do not stop on an intermediate state where:

- package regeneration would make the suite green but the JUnit still records the pre-regeneration failures;
- the JUnit is current but package counts are from an older JUnit;
- `--verify` is green only because a check was weakened;
- the final package describes an earlier measured surface that has since changed.

---

# 10. Focused-suite requirement

The cognitive-control focused suite is the mission-owned behavioral suite.

Its final result must be explained from the final stable package state.

If it fails:

- diagnose every failure;
- repair genuine cognitive-control defects;
- repair stale evidence/certifier state through regeneration rather than weakening assertions;
- do not mark a legitimate test xfail/skip;
- do not delete a guard because it catches staleness;
- prove any test change non-vacuous.

The final closure state should have no unresolved mission-owned focused failure.

If a focused test is intentionally expected to remain failing by current mission semantics, that fact must already be an explicit authoritative rule in current repository code/docs and must be proven rather than invented here.

---

# 11. Default-suite requirement

The default suite is broader evidence, not permission to take ownership of every failure in DoubleTake.

A complete default-suite run must be recorded.

For its failures:

1. identify which failures are in or caused by the cognitive-control measured surface;
2. fix those attributable to this mission;
3. distinguish failures already present outside this mission;
4. do not modify unrelated subsystems merely to make the global count zero.

The final package must record the actual numbers from the actual JUnit.

Do not claim:

`all DoubleTake tests pass`

unless that is literally true of the complete recorded run.

A nonzero default-suite failure count can coexist with closure only when current mission semantics explicitly permit recording unrelated pre-existing failures and the evidence demonstrates that the cognitive-control work introduced no regression into those failures.

---

# 12. Re-run non-vacuity when the mechanism changed

The current final non-vacuity driver is:

```sh
./scripts/prove_cognitive_control_final_closure_nonvacuity.sh
```

At offload time it declared ten terminal mutations covering:

- observer reachability;
- reuse lookup;
- reuse-decision persistence;
- prepared-record persistence;
- real deliberation steps;
- operator-reference retention;
- completion stamp;
- canonical resolver ownership;
- restart replay refusal;
- causal-credit proof.

Run it when:

- any guarded mechanism changes;
- any certifying test changes materially;
- the driver or mutation anchors changed;
- closure depends on a new guard.

Require:

- no blind row;
- no no-op perturbation;
- no setup/collection failure masquerading as a firing guard.

Do not rerun expensive unrelated proof surfaces merely for ritual completeness if their measured surface is unchanged and current binding proves that fact.

---

# 13. Evidence integrity requirements

Final closure requires all of the following to be true simultaneously.

## 13.1 Package/JUnit agreement

For both focused and default suites:

- JUnit is readable;
- count keys are complete;
- package counts exactly re-derive from the JUnit;
- the run covers the suite its command currently collects;
- no partial/aborted run is presented as a complete result.

## 13.2 Measured-surface binding

The final package must truthfully bind to the measured content it describes.

A different HEAD is acceptable only when the package's defined content-binding rule proves the measured surface is byte/content-identical.

Do not replace content binding with “HEAD strings are equal.”

Do not suppress real drift.

## 13.3 Derived closure state

`--verify` must re-derive without defect:

- gates;
- scenario families;
- production callers;
- metrics;
- measured surface;
- non-vacuity row declaration;
- JUnit agreement and coverage.

## 13.4 Metrics

All seven required metrics must remain available and sourced:

- `chunks_reused`
- `chunks_refused`
- `chunk_reuse_success_rate`
- `prepared_resolution_hits`
- `deliberation_steps`
- `operators_executed`
- `time_to_resolution`

Do not satisfy availability with a hand-written literal disconnected from the driven benchmark.

## 13.5 Operator evidence

Canonical execution must carry real persisted operator references.

A nonzero resolver call count plus empty/null operator identities is a defect.

## 13.6 Restart safety

The closure evidence must continue to prove:

- effect executed before crash;
- restart is a new binding over the same roots;
- replay is refused;
- total resolver execution remains one;
- operator evidence survives.

## 13.7 Causality

A resolution is credited only after current evidence proves the parent advanced for the causal reason represented by the resolution.

Do not weaken causal confirmation to close a stale test.

---

# 14. Do not reopen completed mission scope without evidence

Do not spend this terminal closure pass redesigning:

- the impasse model;
- goal lineage;
- bounded attempt control;
- chunk schema;
- canonical resolver architecture;
- persistence layout;
- decision-record model;
- unrelated capability routing;
- unrelated inference-control work;
- enterprise packaging;
- general provider routing.

Reopen a closed area only when the current verifier, current tests, or current production path reveals a concrete defect required for this closure.

This is an evidence-closure mission, not a fresh architecture mission.

---

# 15. Never use these as closure shortcuts

Do not:

- weaken `defects()`;
- skip JUnit agreement;
- lower collection coverage just to accept an old run;
- change `_STALE_JUNIT_TOLERANCE` merely to admit stale evidence;
- delete the failing certifier;
- mark a mission test xfail;
- replace a proof with a presence check;
- accept `counts: null`;
- treat a fixture crash as non-vacuity;
- call a no-op perturbation “fired”;
- hand-edit evidence JSON;
- hide a default-suite failure;
- claim the six owner-facing transitions are “fixed” by inventing an internal duplicate owner;
- use an old package because regenerating is expensive.

If a measurement is expensive, run it deliberately and record it. Cost is not evidence.

---

# 16. Closure criteria

Declare this offloaded mission complete only when current `main` supports all of the following:

```text
[ ] current branch is main
[ ] baseline/current repository state was recorded
[ ] pre-existing/concurrent changes were preserved
[ ] focused JUnit is a complete run of the current focused command
[ ] default JUnit is a complete run of the current default command
[ ] package suite counts exactly match the JUnits
[ ] package/JUnit collection coverage is acceptable under the current verifier
[ ] no mission-owned focused failure remains unresolved
[ ] any broad-suite failures attributable to cognitive control are resolved
[ ] unrelated broad-suite failures are explicitly distinguished rather than hidden
[ ] gates A-O re-derive
[ ] families A-J re-derive
[ ] all seven required metrics remain available and genuinely sourced
[ ] operator-reference evidence is real
[ ] restart/double-execution evidence remains valid
[ ] causal confirmation evidence remains valid
[ ] non-vacuity evidence remains valid
[ ] measured-surface binding is current
[ ] package.json was generated, not hand-edited
[ ] cognitive_control_closure_package.py --verify exits 0 with zero defects
[ ] a second convergence check finds no stale package/JUnit dependency left
[ ] no architecture was changed merely to erase a truthful recorded limitation
```

The current `remaining_gaps` record about owner-facing transitions does **not** by itself block closure if current mission semantics continue to classify it as a truthful external-owner boundary rather than a missing gate.

---

# 17. Final verification

At the stable final state, run at minimum the current authoritative equivalents of:

```sh
PYTHONPATH=.:tools python3 -m pytest \
  tools/doubletake_evolve/cognitive_control/tests \
  --junit-xml=reports/cognitive_control_closure/focused_suite.junit.xml

PYTHONPATH=.:tools python3 -m pytest \
  --junit-xml=reports/cognitive_control_closure/default_suite.junit.xml

PYTHONPATH=.:tools python3 \
  tools/doubletake_evolve/cognitive_control/cognitive_control_closure_package.py

PYTHONPATH=.:tools python3 \
  tools/doubletake_evolve/cognitive_control/cognitive_control_closure_package.py \
  --verify
```

If regenerating the package changes the focused/default result, repeat the convergence loop.

Also run the final non-vacuity driver if its measured surface or guarded mechanism changed:

```sh
./scripts/prove_cognitive_control_final_closure_nonvacuity.sh
```

Before final declaration, re-read:

```sh
git rev-parse HEAD
git status --short
git diff --stat
git diff --name-only
```

If another worker changed the measured surface after the final measurement, the result is stale. Re-measure the affected evidence rather than claiming closure.

---

# 18. Commit discipline

Work on `main`.

Commit coherent changes when necessary.

Do not commit unrelated changes.

Evidence regeneration is a legitimate commit when it is the remaining delta.

If current code needs no repair and only the evidence artifacts are stale, the correct task output may be a commit containing only the regenerated evidence artifacts.

Do not introduce a new explanatory Markdown file into the repository merely to narrate completion. Existing authoritative code, tests, `AGENTS.md`, JUnits and `package.json` are the closure surface.

---

# 19. Final report

Return a concise factual report containing:

## Repository

- baseline HEAD;
- final HEAD;
- branch;
- final working-tree state.

## What changed

List only task-created changes.

Separate:

- runtime changes;
- test/proof changes;
- evidence-only regeneration.

If there were no runtime changes, say so.

## Focused suite

- exact command;
- collected/tests;
- passed;
- failed;
- skipped/errors.

## Default suite

- exact command;
- tests;
- failures;
- errors;
- skipped;
- which failures, if any, are attributable to this mission.

## Closure package

- bound source commit;
- measured-surface digest;
- gates;
- families;
- non-vacuity rows;
- unavailable metrics;
- remaining gaps;
- JUnit agreement result;
- `--verify` exit/result.

## Non-vacuity

- command;
- fired;
- blind;
- no-op/broken.

## Remaining limitations

List only truthful remaining limitations.

Do not relabel the six owner-facing transitions as a defect unless current evidence proves they are one.

---

# 20. Terminal status

Use exactly one terminal status.

When every closure criterion above is satisfied:

`IMPASSE_NATIVE_COGNITIVE_CONTROL_FINAL_EVIDENCE_CLOSED`

If a genuine external or repository-wide blocker prevents final closure after all safe in-scope work has been completed:

`IMPASSE_NATIVE_COGNITIVE_CONTROL_FINAL_EVIDENCE_BLOCKED`

Do **not** use `BLOCKED` merely because the first pass fails. Diagnose, repair/regenerate, and continue the convergence loop.

Do not stop at “almost complete.”

Do not stop at “package regenerated.”

Do not stop at “tests passed once.”

Stop only when the **final committed package, its committed JUnits, current measured surface, and verifier all agree on the same current reality**.
