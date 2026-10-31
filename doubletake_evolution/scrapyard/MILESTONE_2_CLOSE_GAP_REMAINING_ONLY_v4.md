# Milestone 2 — Close Remaining Gap to 100% — Remaining Work Only v4

Repository:

https://github.com/olejardamir/EA

Repository state audited for this revision:

```text
main = 7dd768d90ce813e697bcc25ad447fc3cf5f5b159
```

This is the trimmed continuation of:

```text
MILESTONE_2_CLOSE_GAP_REMAINING_ONLY_v3.md
```

Requirements that are demonstrably complete in the current repository have been removed.

This file contains only Milestone 2 work that is still incomplete, partially correct, internally contradictory, incorrectly wired, or insufficiently evidenced.

Do not redo completed work unless a regression proves it broken.

Work sequentially:

```text
inspect
-> identify highest-impact remaining real gap
-> fix
-> focused tests
-> regression tests
-> validate the actual runnable evidence path
-> recalculate remaining gap
-> repeat
```

Stop only when Milestone 2 is genuinely complete.

Do not execute the final Milestone 3 evidence campaign.

---

# 1. Objective

Milestone 2 must end as:

> A complete, correct, locally runnable, reproducible Nchan + Redis OSS + SSE experiment harness with no known material implementation, measurement, orchestration, classification, reproducibility, traceability, or governance defect remaining.

Target state:

```text
Milestone 1 = DONE
Milestone 2 = DONE — 100%
Milestone 3 = NEXT
```

A valid Milestone 2 harness does not need to force Nchan + Redis to produce an `ACCEPT`.

A real DUT failure may produce `REJECT`.

An invalid generator/environment/measurement must produce `INCONCLUSIVE`.

---

# 2. Source-of-truth reconciliation is still incomplete

A legitimate successor contract now exists:

```text
internal_docs/LIVE_MATCH_CENTRE_POC_EXPERIMENT_CONTRACT_v2_0_3.md
```

and it correctly records itself as frozen and superseding v2.0.2.

Do not recreate that work.

However, the milestone source-of-truth file is stale.

Current:

```text
internal_docs/LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md
```

still:

```text
lists v2.0.2 as the Milestone 1 artifact
describes Milestone 2 as DONE
describes the old 10k result as the Milestone 2 completion basis
does not identify v2.0.3 as the active contract
```

This is inconsistent with the current repository and with v2.0.3 itself, which says:

```text
Milestone 2 status: IN PROGRESS
Contract version: v2.0.3 (active)
```

Repair the source-of-truth chain.

Until every completion gate in this file passes, the milestone plan must not claim Milestone 2 is DONE.

If another result-affecting contract correction is required by the remaining defects below:

```text
do not edit v2.0.3 in place
create the minimal successor
document OLD / NEW / WHY
freeze it before final evidence
update milestone references
```

---

# 3. Remaining gaps

## 3.1 Late-join correctness still has material false-PASS paths

The following v3 items are now substantially implemented and must not be redone:

```text
MatchEventPublisher.publishPrefill() exists
prefill uses the canonical publisher state objects
prefill uses the normal accepted-commit rule
prefill sequence values are generated canonically
expected_first_seq and expected_last_seq are frozen before connection
a frozen publisher state snapshot is captured
a buffer-capacity calculation exists
```

The scenario can still PASS without proving the required history/state result.

### A. Replay-state parsing uses the wrong clock schema

Normal match events use a clock shaped like:

```text
clock.period: string
clock.elapsed_seconds: number
```

but `late-join.ts` currently reconstructs only when it sees approximately:

```text
clock.period: number
clock.elapsed: number
```

Therefore the reconstructed state can remain null even when valid history was received.

Use the actual frozen application event schema.

### B. Reconstruction results are calculated but not gated

The scenario currently calculates:

```text
reconstructed_score_matches
reconstructed_clock_matches
reconstructed_head_matches
```

but PASS is based primarily on:

```text
caughtUp
missing == 0
duplicates == 0
outOfOrder == 0
duration <= 2s
```

A run can therefore PASS while state reconstruction failed.

PASS must require:

```text
reconstructed_score_matches == true
reconstructed_clock_matches == true
reconstructed_head_matches == true
```

### C. Missing replay prefix is not detected

The scenario independently freezes:

```text
expected_first_seq
expected_last_seq
```

but does not require:

```text
received_first_seq == expected_first_seq
```

`validateHistory()` only detects gaps between received events.

If the first expected events are missing, the received stream may still look internally contiguous and PASS.

Explicitly compare the complete expected range against received canonical sequences.

### D. Expected-vs-received count is not a PASS gate

Require:

```text
history_received == history_expected
```

for the frozen target range, after defining exactly which frames belong to that range.

Receiving extra older history must not hide missing required history.

### E. `/history/ oldest` can return history from before the 500-event prefill

Late join occurs after warmup, steady, surge, and stabilization.

The tested match can already have retained history before `publishPrefill()` begins.

The current expected range is based on the prefill's first/last seq, but the history endpoint starts from the oldest retained event.

Freeze what the test is actually proving:

```text
full retained match history so far
or
a deliberately isolated deterministic history range
```

Do not compare a 500-event expected range against a stream that intentionally contains older same-run match history without range-scoping the validation.

For the assignment requirement, full active-match history is the stronger/default interpretation.

### F. Buffer-capacity proof must cover the actual expected history

Current capacity arithmetic uses:

```text
PREFILL_DEPTH + estimated live arrivals
```

If full same-run history before prefill is part of the expected late-join history, it must also be included.

Required proof:

```text
oldest_required_seq
target_head_at_connection_start
required_history_depth
live_arrival_margin
buffer_capacity
capacity_margin
```

### G. Prevent ambiguous interleaving during deterministic prefill

`publishPrefill()` shares the per-match busy lock with ordinary publication, but releases it after each event.

The normal publisher can potentially acquire the same match between prefill events.

Either:

```text
make the whole prefill range an atomic per-match serialized operation
```

or prove that interleaving is intentional and fully included in the independently frozen expected range/state.

Do not call a range deterministic if ordinary publication can alter it unpredictably.

### Required late-join PASS

At minimum:

```text
received_first_required_seq == expected_first_seq
received_last_required_seq >= expected_last_seq
history_received_for_required_range == history_expected
missing_required_sequences == 0
duplicate_required_sequences == 0
out_of_order_required_sequences == 0
reconstructed_score_matches == true
reconstructed_clock_matches == true
reconstructed_head_matches == true
catch_up_ms <= 2000
buffer_capacity_margin >= 0
```

Add focused tests where:

```text
the expected prefix is missing
the final state is wrong
the clock schema is valid but reconstruction differs
older retained history exists before prefill
ordinary publication attempts to interleave with prefill
```

All must behave correctly.

---

## 3.2 The new four-shard file is not yet one valid 100,000-viewer experiment

A new file now exists:

```text
poc/compose.evidence-100k.yaml
```

with four real bridge-network runner containers.

This is useful infrastructure and must not be removed.

It does **not yet** close the 100k requirement.

Current topology is effectively:

```text
runner-shard-0 -> independent TARGET_CONNECTIONS=28000
runner-shard-1 -> independent TARGET_CONNECTIONS=28000
runner-shard-2 -> independent TARGET_CONNECTIONS=28000
runner-shard-3 -> independent TARGET_CONNECTIONS=28000
```

Each runner starts its own experiment process.

There is no global coordinator proving:

```text
100,000+ simultaneously active SSE connections
under one shared frozen phase schedule
with one controlled publisher workload
with one aggregate classification
```

### A. Build a coordinated multi-shard generator

The four shards must behave as workers of **one experiment**, not four unrelated experiments.

Provide an orchestration/control mechanism that freezes and coordinates at least:

```text
run ID
seed policy
warmup barrier
60% aggregate base population
surge start barrier
100% aggregate target barrier
late-join phase
burst phase
reconnect phase
slow-consumer phase
restart phase where applicable
measurement start/end
shutdown
```

### B. One workload publisher, not four independent workload generators

Each current runner creates its own `MatchEventPublisher`.

With four shards this can multiply the event workload by approximately four.

The frozen test is one simulated event stream, not one independent publisher per load-generator shard.

Use one authoritative publisher/scheduler for the experiment or another explicit design that preserves exactly the frozen aggregate event rates.

### C. Global active concurrency must be measured from time-aligned shard state

Do not prove 100k by adding unrelated per-process historical peaks.

Required:

```text
aggregate_active_connections_at_time_t =
  sum(active_connections_current for all shards at aligned time t)
```

Then:

```text
aggregate_active_connections_peak >= 100000
```

must occur during the actual shared experiment.

### D. Aggregate connection-rate metrics must be time-aligned

Compute:

```text
aggregate attempts/sec
aggregate establishments/sec
aggregate failures/sec
```

from aligned buckets.

Do not sum independent peak rates that occurred at different times.

### E. Aggregate histograms, not p95 values

Merge compatible per-shard histograms/sample distributions and recompute:

```text
global p50
global p95
global p99
global max
```

Do not average or maximize shard p95s and call that the global distribution.

### F. Per-shard capacity headroom

Four shards at 28,000 each leave very little headroom against a common Linux default ephemeral-port count of roughly 28,232.

Freeze a topology with defensible per-shard source-port headroom.

Do not rely on a near-exact source-port ceiling.

### G. Shard identity environment variable is inconsistent

The Compose file currently sets:

```text
SHARD_INDEX
```

while `evidence-suite.ts` reads:

```text
SHARD_ID
```

This can make every shard report the same ID.

Use one frozen variable name and validate:

```text
shard IDs are unique
shard_count is identical
target allocation is deterministic
sum(shard targets) matches aggregate target
```

### H. Preflight must validate the real multi-shard topology

Current `runTopologyPreflight()` reads:

```text
SHARD_COUNT
```

inside each shard and treats `source_ip_count = shard_count`.

That is a declared topology fact, not proof that the other source namespaces are alive and participating.

Global preflight must validate the configured participating shards and aggregate capacity before the run.

### I. Do not split the DUT accidentally

The 100k live subscriber load is directed to nchan-primary.

`nchan-2` is a replacement/recovery node, not a second capacity node unless the frozen experiment explicitly changes that.

Do not calculate primary fan-out capacity as if subscriber load were split 50/50 across two Nchan nodes when it is not.

### Required 100k machine evidence

At minimum:

```text
experiment_run_id
aggregate_target_viewers
aggregate_target_sse_connections
shard_count

for each shard:
  shard_id
  source_ip/namespace
  target_connections
  active_current time series or aligned snapshots
  active_peak
  fd limit
  ephemeral-port range
  failures by category
  CPU
  memory
  event-loop delay
  pending-connect backlog

aggregate:
  active_connections_peak
  active_at_60_percent_barrier
  active_at_100_percent_barrier
  connection attempt/establishment rates
  global fan-out histograms
  correctness counters
  generator validity
```

No individual 28k shard verdict may be presented as a measured 100k verdict.

---

## 3.3 The evidence Compose profiles do not currently invoke the evidence suite

`loadConfig()` selects repeated-run mode only when:

```text
RUN_MODE=evidence
```

The current evidence Compose files set:

```text
RUN_PROFILE=evidence
```

but do not set:

```text
RUN_MODE=evidence
```

Therefore `main.ts` defaults to:

```text
runMode = single
```

and bypasses `runEvidenceSuite()`.

This means the nominal evidence profiles do not execute the frozen 3–8-run campaign machinery.

Milestone 2 must wire the command/profile correctly without actually running the final Milestone 3 campaign now.

Required:

```text
normal evidence command unambiguously enters runEvidenceSuite()
reduced/synthetic evidence-suite validation can be run during Milestone 2
full final campaign remains Milestone 3
```

For multi-shard 100k, do not simply make each shard run its own independent 3–8-run suite.

The campaign must be coordinated globally as described in §3.2.

Add a test/config assertion that:

```text
evidence profile -> runMode == evidence
smoke profile -> intended smoke/single behavior
```

---

## 3.4 Runtime topology/Nginx preflight still overclaims capacity

The following v3 preflight work is complete:

```text
Linux ephemeral-port whitespace parsing
cpu.max primary-file parsing in topology-preflight.ts
failed topology preflight can invalidate classification
```

Keep it.

Remaining problems:

### A. Nchan control-server CPU rule is inconsistent

The control-server preflight contains a condition equivalent to:

```text
cpu_quota < 2 -> insufficient
```

while its reason says:

```text
need >= 4 for DUT
```

The frozen primary DUT is 4 CPUs.

Use one rule that matches the contract and actual container limit.

### B. Validate the Nginx workers' actual RLIMIT, not merely the helper process

The control server is a separate Node process inside the Nchan container.

Reading:

```text
/proc/self/limits
```

there proves the control server's limit.

Prove the Nginx master/workers have the effective required file-descriptor limit.

### C. Raw `workers * worker_connections` is not all usable SSE capacity

Account for:

```text
listener sockets
Redis connections
publisher/control traffic
Nginx internal FDs
other connection classes
operating headroom
```

Then compare usable Nginx capacity to the **aggregate** subscriber target, not a 28k per-shard target.

### D. Remove incorrect subscriber splitting assumptions

Current topology preflight accepts an `nchanNodes=2` default and computes a per-node subscriber value.

The live 100k load is not actually distributed across nchan-primary and nchan-2.

Capacity preflight must reflect the actual data path.

---

## 3.5 Reconnect active lifecycle is improved, but replay correctness can still false-PASS

The following is now implemented and should not be redone:

```text
reconnect cohort is removed from the active pool
per-channel counts are decremented
reconnected entries are re-added
reconnected terminal errors are categorized
transport ID is passed to handleMessage()
mode transitions back to steady
```

Remaining correctness defects:

### A. Target head is frozen too early

Current code freezes `targetHeadAtDisconnect` immediately after disconnecting the cohort, **before** the intentional 2-second disconnected period.

It then waits 2 seconds while the publisher continues.

The replay target therefore does not include the events that are the main point of the reconnect test.

Freeze the target at:

```text
immediately before reconnect initiation,
after the disconnected publication window
```

or freeze another clearly justified boundary that includes the required disconnected-window history.

For each client:

```text
saved_last_seq
expected_first_seq = saved_last_seq + 1
target_head_at_reconnect_start
expected_last_seq = target_head_at_reconnect_start
expected_count
```

### B. `received` currently includes post-catch-up live traffic

The scenario transitions entries to steady mode and then waits another second before computing:

```text
tracker.totalReceived - trackerReceivedBefore
```

That count includes frames received after the frozen replay target.

Replay accounting must stop exactly when each client reaches its frozen target.

### C. Catch-up success is not a PASS gate

The scenario computes `allCaughtUp`, but current PASS does not require it.

A timeout can be followed by mode transition and still potentially satisfy the current gap/duplicate/order checks.

Require:

```text
all intended clients reconnected
all intended clients reached frozen target
within frozen timeout
```

### D. Expected-vs-received is not a PASS gate

Require per client:

```text
received required replay range == independently expected replay range
```

Do not rely only on sequence tracker errors if the first expected replay frame is missing.

### E. Missing-prefix detection

As with late join, sequence validation beginning from the first actually received replay frame can miss a missing required prefix.

Explicitly compare:

```text
received_first_required_seq == expected_first_seq
```

and full expected range coverage.

### F. Scenario active-start metric is captured after cohort removal

Current:

```text
active_at_scenario_start
```

is recorded after the 10% cohort has already been removed.

For a "reconnect at peak" claim, capture:

```text
active_before_disconnect
active_min_during_disconnect
active_after_reconnect
active_peak
```

Required reconnect result:

```text
cohort_size
reconnected_count
saved_last_seq per client
expected_first_seq per client
expected_last_seq per client
expected_count
received_required_count
missing
duplicates
out_of_order
caught_up
catch_up_ms
active_before_disconnect
active_during_disconnect
active_after_reconnect
```

---

## 3.6 Surge timing/validity still has unresolved edge conditions

The following v3 surge items are now complete:

```text
absolute monotonic scheduling exists
exact requested additions are required for PASS
actual per-batch attempt/establishment/failure deltas are used
required ramp rate is derived from target / 120 seconds
surge latency now reads from phase histogram machinery
```

Keep them.

Remaining defects:

### A. The 24-batch schedule ends approximately one interval early

The first batch is launched immediately near `t=0`.

Subsequent batches are spaced at ~5-second boundaries.

The 24th batch can therefore begin around `t=115s`, after which the loop exits without waiting to the 120-second boundary.

The assignment mapping is:

```text
+40,000 viewers within 120 seconds
```

Freeze whether the intended model is:

```text
finish no later than 120s
or
a 120s distributed ramp ending at t=120s
```

and make scheduler timing/error semantics match it.

Do not call a ~115-second issuance schedule a precisely 120-second ramp unless that is the frozen interpretation.

### B. The 80% sustained-rate validity threshold is new and not frozen in v2.0.3

Current code introduces approximately:

```text
sustained_rate >= 0.8 * required_ramp_rate
```

as a generator-saturation validity threshold.

This is result-affecting.

Either:

```text
justify and freeze it in the active successor contract before Milestone 3
```

or replace it with a directly derived validity rule that requires no arbitrary post-hoc factor.

### C. `connections_dropped` is not a reliable disconnect producer

The surge scenario checks a delta of:

```text
connections_dropped
```

but current connection terminal paths primarily increment categorized counters and do not consistently increment `connections_dropped`.

Therefore surge-specific drop detection can remain zero even when a stream terminates.

Use the actual attributed disconnect metrics or fix the dropped counter producer.

### D. Environment failure vs DUT failure remains too coarse

The classifier currently tends to treat connection/surge failures as `INCONCLUSIVE`.

That is correct for generator/host/network saturation, but not necessarily for a proven Nchan capacity failure under a healthy generator/environment.

Preserve:

```text
generator/host/network bottleneck -> INCONCLUSIVE
valid generator + Nchan cannot accept/sustain target -> REJECT
```

with real attribution.

Do not use one generic failure percentage as the attribution mechanism.

---

## 3.7 Slow-consumer evidence remains materially incomplete

The following v3 work is now implemented:

```text
unsafe private handler access removed
per-client timestamp arrays exist
per-client median intervals are calculated
Nchan memory baseline/end/recovery samples exist
null memory boundedness can lead to INCONCLUSIVE
a dedicated healthy-during histogram exists
```

Do not redo those.

The experiment still has core measurement defects.

### A. Offered and consumed are still incremented at the same boundary

Inside `ThrottledSubscription`, current code increments both:

```text
_offeredCount
eventsReceived
```

on the same incoming message callback.

Therefore:

```text
slow_offered_event_count
slow_application_read_count
```

are not independent producer-vs-consumer measurements.

`slow_backlog_growth = offered - read` is correspondingly unable to represent a real application backlog.

Define separate observable boundaries.

For example:

```text
transport/socket arrival or available bytes
application delivery after throttling
```

The exact design can differ, but expected offered load must not be inferred from the same callback as consumed load.

### B. Per-client pacing is calculated but not enforced

The code computes per-client medians and an `all_above_1s` style check, but the final `passed` expression does not require the achieved throttle behavior to match the frozen slow-client model.

Freeze a tolerance around:

```text
~1 application event / 2 seconds per slow client
```

and gate validity on actually achieving it.

If the throttle mechanism does not create the intended consumer behavior:

```text
INCONCLUSIVE
```

### C. Healthy-before baseline is not a dedicated before-slow cohort window

`healthyBeforeHist` is populated from the general bounded fan-out snapshot accumulated before the slow phase.

That can contain samples from earlier phases.

Create a dedicated immediately-before-slow healthy baseline measurement window/cohort so the before-vs-during comparison is semantically valid.

### D. "Meaningful memory growth" is not definitive backpressure evidence

Current server-side backpressure is considered demonstrated when:

```text
slow disconnects > 0
OR
Nchan memory growth > 1 MB and > 5%
```

Memory growth alone can have causes other than slow-subscriber pressure.

If using memory growth as the evidence, establish that it is attributable to the slow cohort rather than ordinary Nchan variation.

Prefer a direct Nchan/server signal if available.

A test absorbed by client/kernel buffers remains:

```text
INCONCLUSIVE
```

### E. Bounded-memory thresholds are result-affecting and not frozen in v2.0.3

Current code uses approximately:

```text
growth < 10% of baseline
AND growth < 50 MB
recovery delta < 50 MB
```

Those are acceptance thresholds.

Freeze them before final evidence with rationale, or replace them with a justified trend rule.

### F. Contract/classifier disconnect semantics still disagree

The inherited contract requirement says approximately:

```text
slow_consumer_disconnects > 0
zero disconnects -> INCONCLUSIVE
```

Current classifier allows broader `evidence_server_side_backpressure_reached`, including memory growth.

Choose one rule and make:

```text
active contract
scenario
classifier
tests
traceability
```

agree before Milestone 3.

Required slow-client evidence:

```text
per-client intended rate
per-client achieved application rate
offered rate independent from consumed rate
backlog/event or byte growth
server-side pressure evidence
healthy baseline p95
healthy during p95
Nchan memory time series
boundedness result
disconnect count/reason
validity result
```

---

## 3.8 Resource measurement exists, but CPU normalization and run baselines are still wrong in places

The following v3 resource work is now implemented:

```text
Nchan CPU samples exist
Redis CPU samples exist
Redis connected-client peak exists
runner cgroup per-run deltas exist
evidence suite wires Nchan/Redis CPU
campaign null preservation for Nchan/Redis CPU exists
```

Do not remove that work.

Remaining defects:

### A. Nchan and Redis normalized CPU use the runner's CPU quota

Evidence-suite code derives one:

```text
cpuLimitCores
```

from the runner's `cpu.max`, then uses it to normalize:

```text
runner CPU
Nchan CPU
Redis CPU
```

But the frozen limits are different:

```text
runner: 8 CPUs
nchan-primary: 4 CPUs
Redis: 2 CPUs
```

Therefore Nchan and Redis normalized percentages can be materially understated.

Each service needs its own effective CPU limit/cpuset denominator.

### B. `cpu.max` period is discarded in `ResourceSnapshot`

The monitor stores the quota value but not the actual `cpu.max` period, then evidence code assumes a 100000µs period when deriving core count.

Read/store both:

```text
quota
period
effective cores = quota / period
```

and account for cpuset constraints.

### C. Nchan cgroup baseline may be null at run start

The resource monitor polls Nchan control metrics asynchronously.

The immediate `cgroupBaseline = resourceMonitor.snapshot()` can occur before the first Nchan `/metrics` poll, leaving Nchan cumulative baseline fields null.

Later code then falls back to raw cumulative values.

Ensure Nchan baseline is actually captured before measured run counters begin.

### D. Nchan `memory.peak` is container-lifetime, not automatically per run

Evidence-suite qualifying runs reuse containers.

A prior run's memory high-water mark can leak into a later run.

Either:

```text
measure current-memory time-series and derive per-run peak
reset/recreate relevant service between qualifying runs
or use another valid per-run method
```

Do not present a lifetime high-water mark as a per-run peak.

### E. Mandatory resource checks must operate at aggregate 100k scale

Current classifier's stricter mandatory CPU checks are conditional on approximately:

```text
connections_target >= 100000
```

In the new four-shard file, each process is configured for 28,000.

Therefore a multi-shard 100k campaign can bypass mandatory 100k resource validity if each shard is classified independently.

Move final resource validity to the globally coordinated 100k experiment.

### F. Distinguish units clearly

Machine output must state both, if both are useful:

```text
raw_percent_of_one_core
percent_of_assigned_service_capacity
```

Do not mix them under ambiguous field names.

---

## 3.9 Restart/replacement replay still has missing-prefix and target-boundary false-PASS paths

The following are now implemented and should remain:

```text
literal restart and cross-node replacement both run when configured
partial timeout no longer automatically passes
some expected-range values are frozen before reconnect
restart replay expected is no longer simply replayEvents.length
campaign-only repetition semantics are separated from per-run gating
```

Remaining defects:

### A. Literal restart does not require the complete frozen expected range

Current literal path freezes:

```text
frozenExpectedFirstSeq
headAtRestart
frozenExpectedCount
```

but completion succeeds on the first received sequence satisfying approximately:

```text
seq > lastSeq_before_restart
```

If the frozen head was several sequences ahead, receiving only the last one can pass.

Completion must require the complete frozen expected range.

### B. Literal missing prefix is not detected

If:

```text
expected_first_seq = N+1
```

but first received is:

```text
N+5
```

the local `prevSeq` gap detector starts at N+5 and may not report N+1..N+4 missing.

Explicitly compare the first received required sequence and full expected set/range.

### C. Cross-node path has the same prefix problem

Cross-node completion reaches:

```text
headAtReplacement
```

but a stream beginning at the final expected sequence can satisfy that target without proving earlier expected replay.

Require exact frozen range coverage.

### D. Fallback expected count of 1 is not acceptable

If the independently frozen range is empty or invalid, do not invent:

```text
expectedCount = 1
```

Resolve the state boundary correctly or classify the scenario invalid.

### E. Literal and cross-node accounting are combined

Both paths write to the same aggregate:

```text
restart_replay_expected
restart_replay_received
```

while they prove different recovery properties.

Emit separate machine-readable results:

```text
literal_restart
cross_node_replacement
```

with their own expected/received ranges.

### F. Required structured result

For each path:

```text
transport_resume_id
expected_first_seq
expected_last_seq
received_first_seq
received_last_seq
expected_count
received_required_count
missing_required
duplicates
out_of_order
target_reached
recovery_ms
passed
```

PASS requires complete independently expected range coverage.

---

## 3.10 Disconnect attribution still has exact-once and surge-counter gaps

The explicit attribution taxonomy and `removeActiveEntry()` guard are good improvements.

Remaining problems:

### A. Normal initial-stream error path can decrement more than once

`connectOne()` terminal error handling:

```text
increments attribution
calls private removeEntry()
```

`removeEntry()` decrements the channel count even when the entry is no longer present.

Repeated terminal error notifications can therefore:

```text
double-count attribution
decrement subscriber count multiple times
corrupt expected live-delivery eligibility
```

Use the same exact-once guard semantics as `removeActiveEntry()`.

### B. `connections_dropped` has no reliable terminal producer

The metric exists and surge logic reads it, but ordinary terminal-disconnect paths do not consistently increment it.

Either:

```text
make it a real exact-once aggregate of unexpected drops
```

or stop using it for claims and use the categorized counters directly.

### C. Freeze cleanup semantics

Current shutdown behavior records:

```text
one deliberate disconnect per remaining connection
one shutdown_cleanup counter per disconnectAll() operation
```

If this is the intended taxonomy, document and test it explicitly.

Do not mix per-connection and per-operation counts under names that imply the same unit.

---

## 3.11 Machine-readable output still has provenance and scale defects

All eight match subscriber fields are now emitted.

Keep that.

Remaining issues:

### A. Source commit SHA is still not actually supplied by Compose

`getGitCommitSha()` now checks:

```text
GIT_COMMIT_SHA
```

first.

But current runner Dockerfile/Compose evidence files do not pass the source SHA into the running container.

The image also does not contain `.git`.

Therefore:

```text
git_commit_sha
```

can still be null.

Wire the exact source commit at build/run time and make non-null commit identity part of evidence validity.

### B. Direct-accept eligibility does not require actual active target

Current `direct_accept_eligible` checks configured 100k target and several validity signals but does not require:

```text
active_connections_peak >= target
```

A configured 100k run that physically reached less can be marked direct-accept eligible.

Fix it.

### C. Per-scenario active concurrency remains incomplete

Structured active start/peak/end currently exists mainly for:

```text
surge
reconnect
```

Emit the actual active population for every scenario whose result is interpreted as a peak-load property:

```text
late join
burst
reconnect
slow consumer
restart/replacement where scale is claimed
```

### D. Reconnect active-start field is currently semantically wrong

As described in §3.5, it is captured after removing the cohort.

Fix both producer and output.

### E. Restart canonical ranges are not structured

Do not leave literal/cross-node expected/received range proof only inside detail strings.

### F. Single-run clock output ignores the actual clock-validity object

`emitMachineReadableResult()` currently emits a hard-coded clock block with null reachability values instead of the actual:

```text
metrics.clock_validity
```

Use the authoritative measured/proven clock-validity object.

### G. Global 100k provenance must be campaign-level, not per 28k shard

For the coordinated 100k path, emit:

```text
aggregate active target reached
all participating shard IDs
global validity
global histogram provenance
global verdict
```

No shard-local `target_connections=28000` result can substitute for this.

---

## 3.12 Evidence-suite and aggregation machinery still has a few correctness gaps

Much of the v3 parity work is now complete:

```text
publisher scheduler lag is drained in evidence runs
phase snapshots exist
phase histograms are captured
Nchan/Redis CPU fields are wired
all eight channel counts are wired
clock validity is produced and propagated
campaign-only restart gate exists
histogram pooling clones source run
null CPU metrics are preserved
campaign aggregate_type/run_count exist
```

Do not redo these.

Remaining defects:

### A. Phase snapshot type contract is inconsistent

`ScenarioContext.PhaseSnapshot` includes:

```text
matchAttempts
lobbyAttempts
```

but the explicit `aggregateWorkerMetrics()` parameter type does not currently include those properties while the implementation reads them.

Make the type contract consistent and ensure:

```text
npm run typecheck
```

passes from a clean checkout.

### B. Evidence entrypoint is not wired by Compose

Fix §3.3.

### C. Campaign resource peaks are not all aggregated correctly

Audit `aggregateRuns()` for every resource/validity peak.

Fields such as Nchan/Redis memory can otherwise inherit the first run rather than represent the required campaign/per-run semantics.

For each field explicitly choose:

```text
per-run value
campaign max
campaign sum
campaign pooled distribution
campaign must-all-pass
```

and encode that choice.

### D. Multi-shard aggregation does not exist

`aggregateRuns()` aggregates repeated runs inside one process/shard.

It does not aggregate simultaneous shards.

Do not reuse repeated-run aggregation as if it were cross-shard aggregation.

Implement a separate, explicit cross-shard evidence aggregation layer.

### E. Campaign correctness must never use summed counters as one-run concurrency

Keep:

```text
aggregate_type = campaign
run_count
```

and extend equivalent provenance to the multi-shard aggregate.

---

## 3.13 Active contract still does not describe the current executable experiment

v2.0.3 correctly fixes:

```text
primary Nchan 8 GB memory envelope
7000 MB threshold
late-join connection-attempt timing boundary
```

Do not reopen those changes merely because the prompt was updated.

Remaining contract gaps are result-affecting.

### A. Phase schedule remains stale

The executable lifecycle is now approximately:

```text
warmup at 60%
steady
surge 60% -> 100%
stabilize
late join at peak
burst at peak
post-burst
reconnect
slow consumer
restart/replacement
```

The inherited v2.0.2 sections still contain older timing/scheduling prose.

Freeze one schedule and make contract/code/tests agree.

### B. Slow-consumer thresholds/semantics are not frozen consistently

Current code contains result-affecting rules such as:

```text
memory growth threshold
memory recovery threshold
backpressure memory-growth threshold
achieved pacing expectations
```

and broader backpressure semantics than the inherited disconnect rule.

Freeze them before Milestone 3.

### C. New multi-shard 100k topology is outside the frozen resource envelope

The v2.0.3 contract describes the original resource topology.

`compose.evidence-100k.yaml` now adds four runner containers, each configured for:

```text
8 CPUs
8 GB
```

That materially changes load-generator aggregate resources and host prerequisites.

Freeze:

```text
aggregate runner CPU/memory
number of runner shards
per-shard target
source-IP model
host CPU/RAM prerequisite
one-publisher design
global synchronization model
```

before final evidence.

### D. Surge 80% generator-validity tolerance is not frozen

Resolve §3.6 before final evidence.

If these changes are result-affecting, create the minimal successor to v2.0.3.

Do not edit v2.0.3 in place.

---

## 3.14 Traceability matrix still overstates completion

The current matrix has been expanded significantly and documents many genuinely completed areas.

Keep those rows.

It also currently marks unresolved areas as `PASS`, including the multi-shard 100k topology.

For example, file existence and declared `SHARD_COUNT` are not proof of one coordinated 100k experiment.

Re-audit every row affected by this v4 prompt.

A traceability row is PASS only when all required links are real:

```text
normative requirement
-> implementation
-> focused test
-> metric producer
-> actual evidence-path wiring
-> classifier/verdict semantics
```

Before Milestone 2 completion:

```text
0 false PASS rows
0 BLOCKED rows
0 unmapped normative requirements
```

Do not use the traceability matrix itself as evidence that its own PASS claims are true.

---

# 4. Required focused tests

Add or repair tests only for remaining work.

## Late join

```text
valid clock schema reconstructs correctly
wrong reconstructed score -> FAIL
wrong reconstructed clock -> FAIL
missing expected prefix -> FAIL
history_received != expected required range -> FAIL
older retained same-run history does not corrupt range accounting
prefill/live interleaving behavior is deterministic or explicitly validated
buffer proof covers the actual required history
```

## Multi-shard 100k

```text
all shard IDs unique
SHARD_ID/SHARD_INDEX naming consistent
one experiment run ID across shards
aggregate target allocation correct
aggregate active concurrency uses aligned snapshots
100k+ active simultaneously
publisher workload is not multiplied by shard count
per-shard ephemeral-port headroom valid
global histogram merge correct
global verdict cannot be produced from one 28k shard
```

## Evidence entrypoint

```text
evidence Compose config resolves RUN_MODE=evidence
runEvidenceSuite() selected in evidence mode
smoke remains smoke
multi-shard orchestration does not start independent final campaigns
```

## Topology/Nginx

```text
control preflight requires correct 4-CPU DUT quota
Nginx worker RLIMIT measured
usable worker_connections includes overhead/headroom
capacity compared against global active target
replacement node not counted as primary fan-out capacity
```

## Reconnect

```text
target head frozen after disconnected publish window
all reconnected clients must reach target
missing first expected replay frame -> FAIL
received replay excludes post-catch-up live traffic
expected/received exact range gate
active_before_disconnect is true pre-disconnect population
terminal reconnect error removes active entry exactly once
```

## Surge

```text
24-batch timeline matches frozen 120s interpretation
generator-validity tolerance frozen/tested
unexpected disconnect actually reaches surge drop metric
healthy generator + DUT connection capacity failure -> REJECT
generator/host/network ceiling -> INCONCLUSIVE
```

## Slow consumer

```text
offered and consumed measured independently
per-client achieved throttle is a validity gate
healthy-before is a dedicated baseline window
kernel-buffer-only case -> INCONCLUSIVE
memory-growth signal attributable to slow cohort
bounded-memory thresholds frozen
zero-disconnect semantics match contract
```

## Resources

```text
runner CPU normalized by runner limit
Nchan CPU normalized by Nchan limit
Redis CPU normalized by Redis limit
cpu.max quota/period both used
cpuset respected where applicable
Nchan cumulative counters have real run baseline
per-run Nchan memory peak not polluted by prior run
100k global campaign cannot bypass mandatory resource checks through 28k shard targets
```

## Restart

```text
literal missing expected prefix -> FAIL
literal received only first part of expected range -> FAIL
cross-node missing expected prefix -> FAIL
expected empty/invalid range does not become fallback 1
literal/cross-node machine fields separated
```

## Disconnects

```text
duplicate terminal error only decrements once
duplicate terminal error only attributes once
connections_dropped has a real producer or is removed from claims
cleanup counter unit is frozen
```

## Machine output

```text
git_commit_sha non-null
direct_accept_eligible requires actual active target
all scale-sensitive scenarios emit active start/peak/end
single-run clock block uses actual clock_validity
restart ranges structured
global multi-shard provenance structured
```

## Evidence suite

```text
typecheck covers matchAttempts/lobbyAttempts
resource campaign aggregation semantics explicit
cross-shard aggregation separate from cross-run aggregation
campaign totals cannot masquerade as one-run/shard concurrency
```

---

# 5. Validation loop

Repeat until clean:

```text
PASS 1   clean-checkout typecheck
PASS 2   unit tests
PASS 3   clean Docker build
PASS 4   nginx -t
PASS 5   Redis/Nchan health

PASS 6   canonical late-join prefill/range/state tests
PASS 7   reconnect exact-range tests
PASS 8   restart exact-range tests
PASS 9   slow-client measurement tests
PASS 10  disconnect exact-once tests

PASS 11  Nginx/runtime capacity preflight
PASS 12  per-shard source-port/FD preflight
PASS 13  reduced coordinated multi-shard integration test
PASS 14  global active-concurrency aggregation test
PASS 15  global histogram aggregation test

PASS 16  surge timeline/attribution tests
PASS 17  resource normalization/baseline tests
PASS 18  classifier INCONCLUSIVE-vs-REJECT matrix
PASS 19  evidence entrypoint/config test
PASS 20  reduced/synthetic repeated-run evidence-suite test

PASS 21  machine-readable schema/provenance validation
PASS 22  source commit identity validation
PASS 23  contract/source-of-truth reconciliation
PASS 24  traceability audit
PASS 25  fresh clean-checkout one-command smoke
PASS 26  adversarial final audit
```

If any pass fails:

```text
fix
rerun failed pass
rerun dependent passes
continue
```

Do not run the final Milestone 3 full-scale 100k × 3–8 qualifying campaign.

A reduced/synthetic integration run is allowed when needed to prove the machinery itself.

---

# 6. Milestone 2 completion gate

Milestone 2 is 100% only when all of the following are true.

## Governance

```text
active contract version is explicit
milestone file points to the active contract
milestone file does not falsely claim M2 DONE
current executable schedule/resource topology is frozen
no frozen contract is edited in place
```

## Late join

```text
full required range independently known
missing prefix detectable
expected/received exact range validated
valid application clock schema reconstructed
score/clock/head comparison is a PASS gate
buffer proof covers actual required history
```

## 100k topology

```text
real multi-source topology exists
shards are workers of one experiment
one authoritative workload publisher/rate model
global barriers exist
global active concurrency is time-aligned
>=100000 simultaneous connections genuinely observed by machinery
per-shard FD/port headroom valid
global histograms can be merged correctly
global classifier exists
```

## Reconnect

```text
active lifecycle correct
target includes disconnected-window events
all clients reach independently frozen target
replay received count excludes later live traffic
missing prefix detected
active population fields semantically correct
```

## Surge

```text
timeline matches frozen 120s interpretation
generator-validity rule frozen
drop attribution works
generator/environment failure distinguished from DUT failure
```

## Slow consumer

```text
offered and consumed are independent measurements
achieved per-client throttling validated
healthy-before cohort isolated
server-side pressure evidence defensible
bounded-memory rule frozen
contract/classifier semantics agree
```

## Resources

```text
runner/Nchan/Redis CPU denominators are service-correct
quota + period/cpuset handled
cumulative counters are per-run deltas
Nchan per-run memory peak semantics valid
mandatory resource evidence enforced at global 100k scale
```

## Restart

```text
literal complete expected range verified
cross-node complete expected range verified
missing prefix cannot pass
no circular expected counts
literal/cross-node results separated
```

## Delivery/disconnect accounting

```text
live expected remains independent from live received
reconnect/restart expected independent from received
terminal events attributed exactly once
active/per-channel eligibility updated exactly once
surge disconnect metric has a real producer
```

## Machine evidence

```text
all match/lobby counts correct
actual active target required for direct 100k eligibility
source commit SHA non-null
per-scenario active concurrency present
actual clock-validity object emitted
global shard/run provenance explicit
```

## Evidence machinery

```text
evidence Compose command actually invokes evidence machinery
cross-run aggregation semantics correct
cross-shard aggregation semantics correct
typecheck passes
reduced/synthetic evidence-suite validation passes
```

## Traceability

```text
0 false PASS rows
0 BLOCKED rows
0 unmapped normative requirements
```

Only then may the repository state say:

```text
Milestone 2 completion: 100%
Milestone 2 status: DONE
Milestone 3 status: NEXT
```

---

# 7. Adversarial final audit

After all normal checks appear green, deliberately search for:

```text
milestone file still points to v2.0.2
milestone file says DONE before completion

late join ignores reconstruction booleans
late join clock parser uses wrong field names
missing replay prefix can pass
history count mismatch can pass
old retained history contaminates expected range

four 28k processes presented as one 100k experiment
SHARD_INDEX vs SHARD_ID mismatch
four publishers multiply event rate
no global phase barrier
sum of unrelated shard peaks called concurrent 100k
p95s averaged/maxed instead of histograms merged
replacement Nchan counted as fan-out capacity

RUN_PROFILE=evidence without RUN_MODE=evidence

control-server CPU rule says 2 while contract says 4
Nginx FD check measures helper process rather than workers
worker_connections raw maximum treated as usable capacity

reconnect target frozen before disconnected interval
reconnect received includes later live traffic
reconnect timeout does not gate PASS
reconnect missing prefix can pass

surge finishes one interval early
80% validity tolerance not frozen
connections_dropped always zero
DUT capacity failure always mapped INCONCLUSIVE

slow offered == slow consumed by construction
per-client pacing computed but not gated
healthy-before histogram contains earlier phases
ordinary memory fluctuation called server backpressure
slow thresholds not frozen
slow disconnect semantics contradict contract

Nchan CPU divided by runner CPU count
Redis CPU divided by runner CPU count
cpu.max period assumed
Nchan baseline null -> lifetime counter used
memory.peak from previous run reused
28k shard bypasses global 100k mandatory-resource rules

restart first received frame skips expected prefix
restart target reached without complete expected range
fallback expectedCount=1
literal and cross-node metrics collapsed

duplicate terminal error decrements subscriber count twice
connections_dropped has no producer

GIT_COMMIT_SHA code exists but Compose never supplies it
direct_accept_eligible ignores active_connections_peak
hard-coded clock block ignores actual clock evidence
only surge/reconnect have scenario concurrency

phase snapshot type omits fields implementation reads
campaign resource max inherits first run
cross-run aggregation mistaken for cross-shard aggregation

traceability PASS based on file existence rather than executable proof
```

Any material finding means:

```text
Milestone 2 < 100%
continue
```

---

# 8. Do not start Milestone 3

Do not:

```text
run the final full-scale 100k evidence campaign
run the final 3–8 qualifying campaign to obtain submission evidence
write proposal.md
write final submission README
create final ZIP
complete final cost conclusion
deploy AWS
declare the final production architecture result
```

The exact next task after genuine Milestone 2 completion is:

```text
Milestone 3 — Run the Frozen POC and Produce Evidence
```

---

# 9. Final response when genuinely complete

Report:

## Completion

```text
Milestone 2 completion: 100%
Milestone 2 status: DONE
Milestone 3 status: NEXT
```

## Repository changes

```text
files created
files modified
files removed
```

## Validation

```text
typecheck command/result
unit-test command/result
clean Docker build result
nginx -t result
one-command smoke result
reduced coordinated multi-shard machinery validation
reduced evidence-suite validation
machine JSON validation
exact clean source commit SHA
clean worktree result
```

## Remaining-gap closure proof

Include at minimum:

```text
active contract version
source-of-truth milestone reference

late-join expected/received exact range
late-join state reconstruction result
late-join buffer capacity margin

100k shard topology
per-shard source/port/FD headroom
global synchronization method
one-publisher workload model
global active-concurrency aggregation method
global histogram merge method

reconnect exact expected/received range
reconnect active populations

surge frozen timeline and validity rule

slow offered/consumed independent rates
per-client achieved rate
server-side pressure proof
Nchan memory trend

runner/Nchan/Redis CPU normalization
per-run resource deltas

literal restart exact range
cross-node exact range

disconnect exact-once proof

source commit identity
direct-accept eligibility rule
machine provenance

evidence entrypoint proof
cross-run vs cross-shard aggregation proof
traceability closure
```

## Remaining blockers

Must be:

```text
NONE
```

if claiming 100%.

Do the work in the repository.
Do not stop below 100%.
