# Milestone 3 — Terminal Closure Focus-Only Prompt

**Repository:** `https://github.com/olejardamir/EA`  
**Mission:** Finish **Milestone 3 only**, as quickly and truthfully as possible, by fixing only the remaining frozen-v2.3.0 acceptance blocker(s), then running the terminal qualifying campaign.

## Prompt-authoring baseline

At the time this prompt was written:

```text
main = 23d91d498a6851cb97d7ca7607b303a0c0bc2d98
date = 2026-08-23
```

Do **not** assume this remains current. Re-read `main` at execution time and continue from the newest truthful repository state. Never reset or discard newer M3 work.

---

# 0. Mission

You are now in **M3 closure mode**, not broad research mode.

Your job is:

```text
1. verify the current targeted Nchan/Nginx fix,
2. fix only the remaining frozen-v2.3.0 blocker if necessary,
3. obtain a clean, stable 100k pre-qualification result,
4. freeze one clean source/configuration,
5. run the terminal seeds 42/43/44 campaign,
6. preserve evidence,
7. mark M3 DONE only if the frozen machine verdict is ACCEPT.
```

Do **not** work on:

```text
M4
M5
M6
M7
proposal.md
README.md
cost research
AWS architecture research
packaging
cleanup unrelated to M3
```

Do not broaden the task.

---

# 1. Absolute truth rules

The active terminal contract is:

```text
poc/internal_docs/EXPERIMENT_CONTRACT_v2_3_0.md
```

It is:

```text
FROZEN — CANONICAL ACTIVE
```

Never change after observing results:

```text
100,000 target population
60,000 pre-surge baseline
+40,000 within 120 seconds
fan_out p95 <= 500 ms
surge p95 <= 500 ms
burst p95 <= 1000 ms
late_join p95 <= 2000 ms
zero required correctness violations
generator-validity gates
DUT-validity gates
GLOBAL_RUNS = 3
BASE_GLOBAL_SEED = 42
seeds = 42,43,44
CV <= 0.15
verdict precedence
required evidence
4 active Nchan partitions + 1 spare, shared Redis, 4 Go shards
Nchan/Nginx/Redis component versions and terminal topology selected by v2.3.0
one publisher-owner / non-owner publish = 0
all 8 matches exercised
raw transport ID vs canonical_seq semantics
deep/reconnect/late-join cohort cardinalities required by v2.3.0
restart-replacement phase and exact required-set proof
terminal phase durations/surge schedule/batching
```

The non-qualifying probe may use its existing shortened phase durations, but the terminal campaign may not. Do not speed up terminal qualification by shrinking cohorts, phases, event rates, surge schedule, topology, or required evidence.

Never:

```text
relax a threshold
change sample counts after observation
change the workload to get ACCEPT
remove a required validity metric
reinterpret a REJECT as ACCEPT
reinterpret an INCONCLUSIVE as ACCEPT
hide failed runs
overwrite historical evidence
cherry-pick one lucky qualifying run
call a probe a qualifying campaign
```

Historical evidence remains historical and immutable.

---

# 2. Current technical state to preserve

At prompt-authoring time, the broad problem had already been narrowed substantially.

Known observations include:

```text
- 100k population mechanics are no longer the broad unknown.
- pre/steady p95 was about 160 ms in diagnostic probes.
- 60k -> 100k surge-era p95 was about 150 ms.
- the pathological latency begins around the high-rate burst / post-burst period.
- burst-era p95 had been several seconds.
- post-burst target-era p95 had reached tens of seconds.
```

Already ruled out or materially weakened as root causes:

```text
loadgen scheduling
publisher scheduler lag
general kernel packet loss
generator CPU saturation as the current target-era explanation
cgroup CPU throttling
general memory pressure
a pure "100k capacity cliff" explanation
Docker log-pipe blocking as root cause
Redis CPU saturation
Redis command-timeout bounce as the root cause
kernel send-buffer accumulation as the primary explanation
```

Do not restart those investigations without new contradictory evidence.

---

# 3. Latest focused findings

The current repository has already discovered two highly relevant forms of self-inflicted / local amplification.

## 3.1 GDB watcher interference

The automatic livelock watcher used repeated:

```text
gdb -p
```

attachments.

A run contained dozens of attaches, and each attach stopped the worker being inspected while symbols/backtrace were collected.

Therefore:

```text
LIVELOCK_WATCHER=0
```

must remain on the probe/qualification path unless a future narrowly scoped diagnostic run explicitly requires otherwise.

Do not re-enable intrusive ptrace/GDB instrumentation during a latency qualification run.

**Critical current-path hazard:** at prompt-authoring time, `compose.probe.yaml` explicitly sets `LIVELOCK_WATCHER=0`, but the base qualifying file `compose.evidence-100k.yaml` does not, while `nchan/entrypoint.sh` defaults the watcher to enabled. Therefore a probe can be clean while `./run-evidence-100k.sh` silently re-enables the intrusive watcher. **Before terminal qualification, freeze `LIVELOCK_WATCHER=0` in the base qualifying path itself** (prefer the smallest persistent configuration change). Do not rely on the probe overlay. `SYS_PTRACE` capability may remain if inert; do not spend time removing it merely for cosmetic cleanup.

## 3.2 Worker connection imbalance

The latest baseline changed:

```text
multi_accept on
```

to:

```text
multi_accept off
```

because one worker was observed taking approximately:

```text
24.8k of 25k subscriber sockets
```

on a partition, effectively concentrating fan-out onto one worker/core.

Treat this as the **first current hypothesis to test**, not as proven final truth.

## 3.3 Debug-build A/B is already prepared

The current Docker build supports:

```text
NGINX_DEBUG=1
NGINX_DEBUG=0
```

The debug build itself is a remaining targeted suspect for IPC/interprocess-alert behavior.

Do not invent a different broad tuning campaign before completing this A/B. If `NGINX_DEBUG=0` wins, **persist that winning choice in the base qualifying configuration/default and commit it before qualification**. Do not qualify by relying only on an ad-hoc shell environment variable that could be absent on the next run. The rendered qualifying Compose config must prove the winning build arg is the one actually used.

Do not rebuild or refactor diagnostic code merely because it exists. Disabled inert diagnostic code is acceptable if it cannot perturb the run; unnecessary cleanup creates a new source SHA and wastes validation time.

---

# 4. Speed rule: no more instrumentation spiral

The dominant optimization objective is now:

```text
time-to-defensible-M3-ACCEPT
```

subject to the frozen truth rules.

Therefore:

```text
DO NOT add new diagnostic instrumentation merely because another metric might be interesting.
DO NOT add perf/gdb/strace sampling to normal probes.
DO NOT expand the evidence schema unless a frozen required field is actually missing.
DO NOT investigate unrelated Nchan internals.
DO NOT attempt to understand every implementation detail before qualification.
```

New instrumentation is allowed only if:

```text
A. the current targeted A/B fails materially,
B. existing non-intrusive telemetry cannot distinguish the next two plausible fixes,
C. the new instrumentation is the smallest possible discriminator,
D. it is disabled/removed from the clean qualification path.
```

One diagnostic question at a time.

Additional speed rules:

```text
Do not repeat an identical clearly failing probe unless the prior measurement was invalid.
Do not run a 10k/60k ladder before the current 100k targeted A/B; that scale question was already investigated.
Do not rerun the standalone microbenchmark unless new evidence specifically requires it.
Do not manually pre-build images before run-probe.sh or run-evidence-100k.sh; those launchers already build.
Do not repair stale comments/version labels merely for documentation cleanliness if executable contract selection is correct.
Do not manually re-audit every passing gate on every probe; inspect the machine summary and drill only into failing/invalid gates.
```

One passing probe may be confirmed once if margin is thin. One clearly failing configuration gets no automatic rerun.

---

# 5. Local-resource focus

M3 owns the machine while a probe or qualifying run is active.

During M3 load execution do not start:

```text
M4-M7 work
other Docker builds
other Docker Compose stacks
package installs
compression jobs
large repository scans
unrelated test suites
CPU-heavy analysis
RAM-heavy processes
additional load tests in parallel
```

Run only one heavy M3 experiment at a time.

Do not let your own diagnostics contaminate the latency measurement.

---

# 6. Execution preflight

At start:

```bash
git status --short
git rev-parse HEAD
git log -n 12 --oneline
```

Then inspect only the M3 files necessary to continue correctly, including at minimum:

```text
poc/internal_docs/EXPERIMENT_CONTRACT_v2_3_0.md
poc/runner/src/domain/active-contract.ts
poc/internal_docs/m3_evidence/M3_TARGET_ERA_STALL_DIAGNOSIS.md
poc/run-probe.sh
poc/run-evidence-100k.sh
poc/compose.probe.yaml
poc/compose.evidence-100k.yaml
poc/nchan/Dockerfile
poc/nchan/entrypoint.sh
poc/nchan/nchan.conf
poc/nchan/nchan-2.conf
poc/nchan/nchan-3.conf
poc/nchan/nchan-4.conf
poc/nchan/nchan-spare.conf
current run-probe / campaign scripts
latest M3 commits after this prompt's baseline
```

If `main` has advanced:

```text
continue from the newer work
do not revert it merely to match this prompt
```

Preserve unrelated user changes.

Verify that the **executable** active contract resolves to `v2.3.0`. Some comments/file headers may still mention v2.1.0/v2.2.0; treat those as stale commentary, not a reason to stop, unless runtime configuration or contract selection is actually wrong. Do not spend closure time on comment-only cleanup.

Before any heavy run, also verify there is no conflicting dev/probe stack already holding the required host ports and no unrelated Docker workload consuming the machine. Avoid launching a doomed campaign because stale containers were left behind.

If a legitimate M3 probe or terminal campaign from the current/newer source is **already running when this prompt starts**, do not kill, restart, duplicate, or invalidate it. Let that single heavy run finish, consume its machine result, and continue from that result. If a terminal 3-run campaign has already begun, do not modify source/configuration until it completes.

---

# 7. Closure sequence — Phase A

## A1. Test the current targeted configuration first

Run one clean **non-qualifying 100k probe** using the current targeted state. With the current launcher, the intended command is:

```bash
cd poc
./run-probe.sh 100000
```

Use:

```text
multi_accept = off
LIVELOCK_WATCHER = 0
no gdb attach
no intrusive ptrace watcher
existing lightweight required telemetry only
current default debug-build setting
same target/topology/rates, with the existing probe-shortened phase durations
```

Do not add another change before observing this result.

Capture at minimum:

```text
population gates
fan_out p95
surge p95
burst p95
late_join p95
correctness counters
generator validity
DUT validity
worker connection distribution
worker CPU distribution
existing lightweight IPC/stall indicators
```

The purpose of this probe is one question:

> Did correcting worker acceptance balance and removing intrusive GDB interference eliminate or materially collapse the burst/post-burst latency pathology?

---

# 8. Decision gate after Phase A

## If the current probe satisfies the frozen gates with useful headroom

Do **not** keep diagnosing.

Do not begin a new diagnostic branch. Proceed to the single **full-duration non-qualifying confirmation** in Section 13, then Phase C if it passes.

## If the current probe is very close

"Very close" does **not** mean changing thresholds.

It means:

```text
population/correctness/generator/DUT validity are clean
and
latency is close enough that the already-prepared debug-build A/B is the obvious next discriminator
```

Proceed to Phase B.

## If the current probe still has the same multi-second/tens-of-seconds pathology

Proceed immediately to Phase B.

Do not add another measurement layer first.

---

# 9. Closure sequence — Phase B

## B1. Run the prepared debug-build A/B

Change only:

```text
NGINX_DEBUG=1 -> NGINX_DEBUG=0
```

Keep constant:

```text
multi_accept off
LIVELOCK_WATCHER=0
workload
population
rates
limits
required telemetry
probe duration
all acceptance semantics
```

Run the same non-qualifying 100k probe. With the current launcher:

```bash
cd poc
NGINX_DEBUG=0 ./run-probe.sh 100000
```

Do not change anything else in that A/B.

The purpose is one question:

> Does removing the Nginx debug build eliminate or materially reduce the remaining latency pathology?

---

# 10. Decision gate after Phase B

## If debug-off satisfies the frozen gates with useful headroom

Stop diagnosis.

Use the debug-off configuration as the candidate clean qualification configuration. Persist `NGINX_DEBUG=0` in the base qualifying path/default, commit that exact choice, and verify the rendered qualifying Compose configuration shows it.

Proceed to the single full-duration non-qualifying confirmation in Section 13, then Phase C if it passes.

## If debug-off is clearly better but still fails

Use existing telemetry to identify the **single smallest remaining bottleneck**.

Before changing code/configuration, write at most a tiny (roughly <=10-line) internal decision note, or place the same information in the M3-scoped commit message if repository practice permits:

```text
observed failing gate
current measured value
expected frozen gate
one most likely mechanism
evidence already supporting it
one smallest proposed fix
why this fix does not change the experiment's workload or acceptance semantics
```

Then make **one targeted fix**.

Run one matching 100k non-qualifying probe.

Repeat only this narrow:

```text
one evidence-backed fix
-> one probe
-> one decision
```

loop.

## If debug-off does not improve the pathology

Do not return to broad speculation.

Use existing evidence to select the next smallest discriminating fix.

Do not reopen already-ruled-out areas without contradictory measurements.

---

# 11. What counts as a legitimate remaining fix

A legitimate fix may change DUT implementation/configuration needed to make the intended architecture function correctly.

It must not change:

```text
the frozen workload
required population
event rates
latency thresholds
correctness thresholds
number of terminal runs
terminal seeds
CV threshold
verdict logic
required evidence
generator validity rules
DUT validity rules
```

Examples of legitimate categories:

```text
worker scheduling/accept distribution
Nginx/Nchan runtime configuration
a demonstrated pathological buffering behavior
a demonstrated IPC/output-path configuration defect
removal of intrusive debug-only behavior
a real implementation bug
```

Examples of illegitimate "fixes":

```text
raising 500 ms to 1000 ms
lowering 100k
shortening the burst
reducing event rate
dropping hard viewers from measurement
excluding slow samples
changing histogram attribution after seeing the result
changing CV
removing a failing correctness counter
```

---

# 12. Avoid overfitting the terminal seeds

Use the existing non-qualifying probe path for tuning.

Do not repeatedly run seeds:

```text
42
43
44
```

as tuning experiments if the tooling allows non-terminal probe seeds.

The terminal 42/43/44 campaign should begin only after the candidate configuration already demonstrates frozen-gate headroom in non-qualifying probes.

At prompt-authoring time `run-probe.sh` itself uses `GLOBAL_SEED=42`. Do **not** spend time modifying the probe harness merely to manufacture an untouched seed. The rule here is only: do not use repeated terminal *qualifying campaigns* as tuning runs.

Do not create a fake notion of an "untouched holdout" that conflicts with the repository's actual contract; simply avoid unnecessary terminal-seed tuning.

---

# 13. Pre-qualification gate

## 13.1 One full-duration bridge run — required once, not a ladder

The normal `run-probe.sh` overlay shortens the workload (at prompt-authoring time: warmup 15s, measure 30s, burst 10s, surge 60s, cooldown 5s), while the terminal base workload uses 30s/120s/30s/120s/10s. The historical pathology is specifically burst/post-burst backlog, so a 10-second burst can produce a false sense of readiness.

Once one candidate configuration passes the short 100k probe, run **exactly one** non-qualifying 100k confirmation with the probe durations overridden to match the terminal base durations:

```bash
cd poc
PROBE_WARMUP_SECONDS=30 \
PROBE_MEASURE_SECONDS=120 \
PROBE_BURST_SECONDS=30 \
PROBE_SURGE_SECONDS=120 \
PROBE_COOLDOWN_SECONDS=10 \
./run-probe.sh 100000
```

If the winning candidate is still being tested via a temporary debug A/B, include that same debug setting for this bridge run. After it passes, persist the winning setting in the base qualifying config before qualification.

Rules:

```text
Do this bridge run only once for the selected candidate.
Do not run it for configurations that already failed the short probe.
Do not turn it into another seed ladder.
If it fails clearly, return to the one-fix/one-short-probe loop before another bridge attempt.
If it passes, stop diagnosis and freeze for qualification.
```

## 13.2 Gate before terminal campaign

Do not launch the terminal campaign until all are true in the clean candidate configuration and the full-duration bridge run passes:

```text
[ ] 60k baseline reached exactly as required
[ ] +40k surge completes within 120s
[ ] >=100k post-surge target is sustained as required
[ ] fan_out p95 <=500 ms in the frozen measurement window
[ ] surge p95 <=500 ms
[ ] burst p95 <=1000 ms
[ ] late_join p95 <=2000 ms
[ ] required correctness counters = 0
[ ] generator validity passes
[ ] DUT validity passes
[ ] no GDB/ptrace watcher is contaminating latency
[ ] no diagnostic-only process is materially perturbing workers
[ ] no known probe-only relaxation exists
[ ] result has enough margin that a 3-run campaign is credible
```

Also require the machine/probe output to show no hidden v2.3.0 blocker outside those headline latencies. At minimum, do not proceed while any of these are failing/invalid:

```text
all 8 matches receive events
steady publication rate 8..12 events/s
burst publication rate 40..60 events/s
publisher definite_failures = 0
publisher ambiguous_failures = 0
publisher pending_peak <= 1000
reconnect required-set/counters pass
restart-replacement required-set/counters pass and structured/top-level counters agree
late-join required probes are present and pass
required canonical/schema/transport/correctness counters are numeric and zero
generator normalized CPU < 90%
generator scheduler/ticker lag p99 < 100 ms
generator throttle delta = 0 and OOM = 0
source-port/FD validity passes
DUT required resource samples are present
DUT memory peak < 5,637,144,576 bytes per frozen rule
DUT OOM delta = 0
DUT throttle delta = 0
no worker death / required ceiling loss
Redis required memory metric is present
spare node evidence is present
```

Use the machine result as the first filter; do not hand-recompute every passing item unless the machine output is missing or contradictory.

If a metric is only barely under a gate, prefer one additional identical confirmation probe rather than launching a likely unstable qualifying campaign.

Do not perform a long ladder if one clean confirming probe is enough.

---

# 14. Closure sequence — Phase C: clean qualification freeze

Once the pre-qualification gate passes:

1. **freeze `LIVELOCK_WATCHER=0` in the base qualifying path**, not only `compose.probe.yaml`;
2. if debug-off won, persist `NGINX_DEBUG=0` in the base qualifying path/default; if debug-on won, preserve debug-on deliberately;
3. disable intrusive diagnostic behavior but do not delete/refactor inert diagnostic code merely for cleanliness;
4. preserve all frozen required lightweight metrics;
5. ensure the exact final source/configuration is committed;
6. ensure working tree is clean;
7. record exact source SHA;
8. record exact contract SHA256;
9. render the qualifying Compose configuration and confirm the watcher is OFF and the winning debug build arg is resolved;
10. confirm required images/versions;
11. confirm no probe/dev containers or conflicting host-port users remain;
12. run one cheap host-side audit-toolchain sanity check before spending three heavy runs; for the current repo, verify `node` and `npm` exist and `cd poc/runner && npx --no-install tsx --version` succeeds. Do not run a broad typecheck/test suite merely for this preflight; the goal is only to prove the post-campaign audit launcher can start without downloading tools;
13. confirm the terminal campaign will use the exact same source/configuration for all three runs.

Do not change source after the first qualifying run begins.

Do not rebuild different source between seeds. Do not run the whole test suite here unless a changed code path specifically requires it; the cheap Node/npm/tsx sanity check exists only to prevent a post-campaign audit-launch failure.

---

# 15. Terminal qualifying campaign

Run exactly the frozen v2.3.0 campaign using the repository launcher. With the current executable path:

```bash
cd poc
./run-evidence-100k.sh
```

Do not rely on a transient `NGINX_DEBUG=0` or `LIVELOCK_WATCHER=0` shell prefix for terminal identity; the winning settings must already be frozen in the committed qualifying path/default.

The campaign remains:

```text
GLOBAL_RUNS = 3
BASE_GLOBAL_SEED = 42

run 0 = seed 42
run 1 = seed 43
run 2 = seed 44
```

All must use:

```text
same source SHA
same contract
same configuration
same topology
same thresholds
same measurement semantics
same campaign
```

Preserve the full required evidence.

The machine verdict is authoritative.

---

# 16. Qualification result handling

## ACCEPT

If:

```text
all runs are valid
all frozen gates pass
CV <= 0.15 for the frozen campaign metrics
campaign machine verdict = ACCEPT
```

then:

```text
freeze evidence
use the independent verdict audit produced automatically by `run-evidence-100k.sh`; do not rerun an equivalent audit unless that artifact is missing/fails
update M3 status to DONE
record exact campaign ID/source SHA/contract
stop M3 work
```

Do not continue tuning after ACCEPT.

## INCONCLUSIVE

If the terminal campaign is INCONCLUSIVE:

```text
preserve it
identify the exact validity blocker
fix only that blocker if it is genuinely environmental/harness-related
do not weaken the DUT acceptance criteria
do not overwrite the campaign
```

A new campaign, if justified, must have new immutable provenance and must not erase the inconclusive one. Do not rerun three heavy 100k runs merely because a cheap post-processing/audit tool failed to launch: first determine whether the preserved raw campaign evidence itself is complete and valid. Never mutate a sealed evidence directory; if the contract requires a new canonical campaign because the required audit artifact could not be produced, fix that tooling blocker first and only then launch the new campaign.

## REJECT

If the terminal campaign is a valid REJECT:

```text
preserve it
do not reinterpret it
```

Only continue M3 repair if there is a specific evidence-backed implementation defect that can be corrected without altering the frozen acceptance semantics.

Do not launch repeated qualifying campaigns as tuning attempts.

Return to non-qualifying probes before any later campaign.

If the evidence shows the selected local architecture cannot plausibly satisfy the frozen gates without a material architecture change, stop and report that exact blocker rather than manufacturing ACCEPT.

---

# 17. Minimal documentation policy

Do not spend closure time writing large retrospective documents.

Update only what is needed to preserve truth:

```text
one compact current focused diagnosis/decision record only when a new fix beyond the prepared A/B is actually needed
terminal candidate source/configuration decision
terminal evidence manifest
independent verdict audit
milestone tracker
instruction provenance if this prompt is actually used
```

Do not start M4 documentation.

---

# 18. AI instruction provenance

If this prompt is actually used to direct execution, preserve an exact copy in the repository, for example:

```text
internal_docs/M3_TERMINAL_CLOSURE_FOCUS_ONLY_PROMPT_ARTIFACT.md
```

Compute its SHA-256 and update:

```text
internal_docs/AI_INSTRUCTION_PROVENANCE.md
```

Record:

```text
filename
hash
purpose
first-use source commit
that it directed focused M3 terminal closure
```

Do not edit the preserved artifact after hashing. If this provenance artifact is added during M3, commit it **before the final qualification source freeze**; never insert a provenance-only commit between terminal run 0, 1, and 2.

---

# 19. Commit discipline

Use small M3-scoped commits.

Good examples:

```text
fix(m3): balance nginx worker accepts for 100k probe
fix(m3): remove debug build from terminal candidate
fix(m3): <single remaining evidenced fix>
docs(m3): record clean prequalification result
evidence(m3): freeze terminal v2.3.0 campaign
docs(m3): close milestone 3 after ACCEPT
```

Do not use meaningless commit messages for final closure work.

Do not stage unrelated changes.

Do not force-push.

---

# 20. Autonomous focus loop

Repeat only:

```text
OBSERVE CURRENT FROZEN-GATE FAILURE
        ↓
SELECT ONE EVIDENCE-BACKED SMALLEST FIX
        ↓
RUN ONE NON-QUALIFYING 100k PROBE
        ↓
COMPARE AGAINST FROZEN GATES
        ↓
PASS WITH HEADROOM?
    YES -> FREEZE -> QUALIFY
    NO  -> ONE NEXT FIX
```

Do not branch into five theories at once.

Do not run multiple heavy experiments concurrently.

Do not optimize non-failing metrics.

If a probe clearly fails, do not rerun it unchanged. If a probe passes narrowly, allow at most one identical confirmation before freeze. This prevents the loop from becoming a run-count exercise.

---

# 21. Priority order

Always prioritize in this order:

```text
1. measurement validity
2. population validity
3. correctness
4. fan-out / surge / burst latency
5. late join
6. repeatability / CV
7. evidence closure
```

Do not spend time improving a metric already comfortably inside its frozen gate while another gate still fails.

---

# 22. Current first actions

Unless newer commits already completed them, begin with exactly:

```text
1. Re-read current HEAD and v2.3.0.
2. Confirm current configs have multi_accept off.
3. Confirm probe path has LIVELOCK_WATCHER=0.
4. Record that the current base qualifying path would re-enable the watcher unless newer commits already fixed it; do not launch qualification until this is persistently fixed.
5. Run one clean 100k non-qualifying probe with current debug setting.
6. Inspect only machine frozen-gate outcomes + existing lightweight telemetry; drill into failing gates only.
7. If still failing materially, run exactly one same-workload A/B with NGINX_DEBUG=0 and no other change.
8. Choose the winner.
9. Once a candidate passes the short probe, run exactly one full-duration non-qualifying bridge confirmation using the terminal phase durations from Section 13.
10. Persist the winning debug setting and LIVELOCK_WATCHER=0 in the base qualifying path, commit, render Compose, and verify.
11. If the full-duration bridge passes, stop diagnosis and enter qualification immediately.
```

This is the default path.

Deviate only if newer repository evidence has already superseded one of these steps.

---

# 23. M3 completion gate

M3 is DONE only when repository evidence supports:

```text
[ ] active contract = frozen v2.3.0
[ ] terminal source SHA is immutable and recorded
[ ] terminal campaign has exactly 3 runs
[ ] terminal seeds are 42/43/44
[ ] same source/configuration used for all 3
[ ] qualification path has LIVELOCK_WATCHER=0 without relying on probe overlay
[ ] winning NGINX_DEBUG setting is persisted/resolved in qualifying config
[ ] no intrusive diagnostic process perturbs terminal runs
[ ] 100k population requirement passes
[ ] +40k/120s passes
[ ] correctness gates pass
[ ] generator validity passes
[ ] DUT validity passes, including frozen memory/OOM/throttle/resource-sample rules
[ ] publisher/rate/8-match gates pass
[ ] reconnect and restart-replacement gates pass
[ ] fan_out p95 <=500ms
[ ] surge p95 <=500ms
[ ] burst p95 <=1000ms
[ ] late_join p95 <=2000ms
[ ] CV <=0.15 for `global_active_peak`, `fan_out p95`, `late_join p95`, and `burst p95` using the frozen sample-stdev rule
[ ] machine campaign verdict = ACCEPT
[ ] required evidence exists
[ ] independent verdict audit agrees
[ ] historical failed/inconclusive evidence remains preserved
[ ] milestone tracker says M3 DONE
[ ] no M4-M7 work was substituted for unfinished M3 work
```

If any row is false:

```text
M3 is not DONE.
```

---

# 24. Stop condition

Stop immediately when:

```text
M3 = DONE
terminal v2.3.0 campaign verdict = ACCEPT
evidence is frozen
tracker is updated
```

Do not continue into M4.

If a real blocker makes ACCEPT unattainable without changing the frozen semantics or performing a material architecture redesign, stop with an exact blocker report.

---

# 25. Final response format

When M3 genuinely closes:

```text
M3 COMPLETION: 100%

TERMINAL CONTRACT:
v2.3.0

TERMINAL CAMPAIGN:
<campaign id>

TERMINAL SOURCE:
<sha>

SEEDS:
42, 43, 44

MACHINE VERDICT:
ACCEPT

FAN_OUT P95:
<run values + campaign summary>

SURGE P95:
<run values + campaign summary>

BURST P95:
<run values + campaign summary>

LATE_JOIN P95:
<run values + campaign summary>

CV:
<required metric CVs>

CORRECTNESS:
PASS

GENERATOR VALIDITY:
PASS

DUT VALIDITY:
PASS

FILES/COMMITS CREATED:
<list>

M3 REMAINING GAPS:
NONE

NEXT MILESTONE:
M4
```

If not closed:

```text
M3 COMPLETION: <truthful percentage>

CURRENT SINGLE BLOCKER:
<exact frozen gate / validity issue>

LATEST MEASUREMENT:
<value>

FROZEN REQUIREMENT:
<value>

CAUSE STATUS:
<proven / strongly supported / unresolved>

NEXT SINGLE ACTION:
<one action only>

NO ACCEPTANCE CRITERIA CHANGED:
YES
```

---

# 26. Final instruction

This is a **terminal closure prompt**.

Do not confuse:

```text
more diagnosis
more documentation
more instrumentation
more architectural discussion
```

with progress.

Progress now means:

```text
remove the remaining measured blocker
-> demonstrate frozen-gate headroom
-> freeze clean source
-> run seeds 42/43/44
-> obtain truthful machine ACCEPT
-> preserve evidence
-> stop
```
