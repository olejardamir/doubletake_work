# Milestone 2 — Close the Remaining Gap to 100% (Updated)

You are working directly on:

https://github.com/olejardamir/EA

This is a **continuation** of Milestone 2, not a restart.

This prompt was updated against repository `main` at:

```text
d19e664b4f3494f465b2836af0b90060193bfaa8
```

The purpose of this revision is to remove work that is already demonstrably implemented while retaining every material requirement that is still incomplete, contradictory, insufficiently measured, or insufficiently evidenced.

Your task is to **finish Milestone 2 completely**.

Do not merely review the repository, describe problems, propose changes, or stop after one implementation pass.

Work **sequentially in a loop**:

1. inspect the current repository state;
2. identify the highest-impact real remaining gap;
3. fix that gap and only its required dependencies;
4. run focused tests;
5. run affected regression tests;
6. measure/verify the repaired behavior;
7. compare against the Milestone 2 completion gate;
8. repeat until no material gap remains.

Do not manufacture cosmetic work simply to continue the loop.

Do not claim 100% because documents say Milestone 2 is DONE. Repository status prose is not evidence. The implementation, measurement machinery, tests, reproducibility, and authoritative classifier must all agree.

Keep assignment scope discipline binding: this is the **smallest useful measured POC**, not a production implementation or demonstration UI.

---

# 1. Governing objective

Milestone 2 must become:

> **A complete, correct, locally runnable, reproducible implementation of the frozen Nchan + Redis OSS + SSE POC experiment, with no known material implementation, measurement, orchestration, classification, reproducibility, traceability, or governance gap remaining.**

Expected end state:

```text
Milestone 1 = DONE
Milestone 2 = DONE — 100%
Milestone 3 = NEXT
```

Milestone 3 must **NOT** be executed in this task.

Milestone 2 is about the correctness of the experiment harness, not forcing Nchan + Redis to produce a favorable final benchmark result.

A truthful DUT failure may still be compatible with a complete harness. An ambiguous harness/environment failure is not.

---

# 2. Current source-of-truth order

Use this precedence:

0. the original take-home assignment and the embedded assignment constraints below;
1. `internal_docs/AGENTS.md`;
2. `internal_docs/LIVE_MATCH_CENTRE_MINIMUM_DEFENSIBLE_ARCHITECTURE.md`;
3. `internal_docs/LIVE_MATCH_CENTRE_FINAL_SIMPLIFICATION_AUDIT.md`;
4. the currently active frozen POC experiment contract:
   `internal_docs/LIVE_MATCH_CENTRE_POC_EXPERIMENT_CONTRACT_v2_0_2.md`;
5. `internal_docs/LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md`;
6. current `poc/`;
7. older documents only for historical context.

`v2.0.2` supersedes v2.0.1 and v2.0.0.

If a genuine contradiction in a frozen result-affecting variable remains and cannot be satisfied consistently, create the **minimal next contract version**, document `OLD / NEW / WHY`, freeze it, update the milestone reference, and continue.

Do not edit a superseded frozen contract in place.

Do not create another milestone copy such as `(4)`.

Update only:

```text
internal_docs/LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md
```

when milestone status genuinely changes.

---

# 2.1 Assignment hard constraints that remain binding

These production-scenario facts may shape the POC even when the local POC does not directly prove all of them:

```text
Product: public anonymous read-only Live Match Centre; no accounts.
Lobby: all live matches, current score and minute, goals/cards update live with no refresh.
Match page: late join, reload, or return after phone sleep shows everything so far immediately, then continues live.
Never a blank feed or manual refresh.
Trust invariant: score agrees with visible events; nothing duplicated, disappearing, or out of order.
Live feel: goals reach the viewer within a couple of seconds; routine events soon after.
Crowd invariance: materially identical experience at 100 vs 100,000 viewers, including kickoff rush.
Score and clock are derived from the third-party event stream.

Peak live matches: 8 concurrent.
Feed: ~10 events/s total, bursting to ~50/s.
Feed delivery: best-effort, no long retry window.
Peak concurrent viewers: 100,000.
Viewer surge: +40,000 viewers within 2 minutes.
Audience: ~60% Europe / ~40% North America.
Goal latency: p95 <= 2s from ingest to viewer screen.
All other event latency: p95 <= 5s.
Late join/reload: full match history visible within 2s.
Infrastructure budget: <= $3,000/month at peak.
Deploys: weekly, including during live matches; viewers must not notice.
Frontend: Next.js App Router with component-based architecture.
Infrastructure: AWS preferred, or justify an alternative.
```

The local POC constraints remain:

```text
Test the riskiest architecture-invalidating assumption that can be tested locally.
Use the smallest experiment that produces a measured result.
Run locally with one command.
Require only a container runtime on the normal reviewer path.
Use no cloud account.
Simulate the event stream.
Do not build the full product.
Do not add a UI.
Do not perform real AWS deployment or infrastructure spend.
Final poc/ must contain source/config only, not generated build/results/dependency artifacts.
```

Do not write the final proposal, final README, <=300-word report, cost conclusion, or final ZIP in Milestone 2.

---

# 3. Work already closed — do not redo without a regression failure

The following areas now have substantive implementation and should not be rebuilt from scratch:

- Compose build definitions for custom Nchan and runner images;
- evidence profile configured with `TARGET_CONNECTIONS=100000`;
- 60% warm-up base population machinery;
- warm-up publisher start and 5-second stabilization behavior;
- channel-aware subscriber-count lookup for publisher expected-delivery accounting;
- explicit lobby publisher buffer length 1;
- lobby subscriber `oldest` behavior for immediate retained-state delivery;
- separation of Nchan transport ID from application `canonical_seq`;
- basic Last-Event-ID reconnect machinery with canonical tracker preservation in the reconnect scenario;
- a second Nchan configuration sharing Redis;
- test-only Nchan restart control infrastructure without Docker socket mounting;
- per-message match EventSource override removed from the normal live match subscriber path;
- SSE handshake timeout cleared after the streaming response is established;
- incremental/bounded latency histogram machinery replacing final tail-only percentile storage;
- `perf_hooks.monitorEventLoopDelay()` instrumentation;
- publisher drain support at hard phase transitions;
- atomic synthetic state commit machinery already added for accepted publishes;
- repeated-run evidence-suite machinery with minimum 3 / maximum 8 run structure;
- explicit `worker_processes 4` in the primary Nchan configuration;
- `.dockerignore` files and runner lockfile-based dependency installation;
- parameter ledger, risk-alignment document, metric matrix, traceability matrix, audit report, and preserved AI instruction artifact;
- exact AI instruction artifact/hash preservation;
- smoke profile prevented from returning a final architecture `ACCEPT`.

These remain subject to regression verification, but do not spend time reimplementing them unless the current code proves them broken.

---

# 4. Remaining material gaps

The following are the current priority gaps. They are not optional.

## 4.1 Full-history correctness and deterministic late-join prefill

The current Nchan match buffer is still:

```text
nchan_message_buffer_length 5000
```

and the current configuration itself notes that this is only a finite POC constraint.

The assignment requires complete history-so-far behavior. The active contract, implementation, and POC claim must be logically consistent.

Resolve the remaining history contradiction without weakening the assignment.

Audit and repair all of these together:

```text
retained-history depth
live-arrival eviction margin
POC history claim
production full-active-match-history requirement
late-join test depth
```

The current late-join scenario waits for roughly 500 live-generated events to accumulate. That is not the deterministic explicit prefill required by the original Milestone 2 gate.

Implement a real deterministic prefill that:

1. selects a known match;
2. establishes an independently known canonical start sequence;
3. publishes the configured retained-history test depth deliberately;
4. verifies successful accepted publication of that complete range;
5. freezes the target head before late-join connection initiation;
6. starts late-join timing immediately before connection initiation;
7. receives and validates the history through the frozen target head;
8. continues ordinary live publishing while catch-up occurs;
9. detects missing, duplicate, and out-of-order canonical sequences;
10. reconstructs score/clock/period/head from replay and compares it with the committed publisher state at the frozen boundary.

Structured output must include at minimum:

```text
history_expected
history_received
first_seq_expected
first_seq_received
target_head_at_connection_start
last_seq_received
missing_history_sequences
duplicate_history_sequences
out_of_order_history_sequences
catch_up_ms
reconstructed_score_matches
reconstructed_clock_matches
reconstructed_head_matches
```

Never derive `history_expected` by copying `history_received`.

If the `/history/` subscriber's fixed:

```nginx
nchan_eventsource_event "update";
```

contradicts the active frozen per-message SSE `event:` framing, reconcile it. Either preserve per-message event types on history replay or minimally correct/refreeze the wire contract with a justified distinction.

---

## 4.2 100,000-viewer topology must be structurally capable of a legitimate attempt

The evidence topology currently has a single runner using host networking and one primary destination subscriber port.

That is not enough evidence of 100k TCP readiness.

A single source address to one destination address/port has a finite ephemeral-port/4-tuple space and may be structurally capped below 100,000 simultaneous connections.

Milestone 2 must provide a topology capable of making a legitimate 100,000-viewer attempt.

Implement or freeze a topology that proves, before Milestone 3:

```text
viewer_count = 100000
SSE_connection_count implied by viewer model
source address / namespace count
destination tuple count
available source-port space
per-shard connection target
per-shard FD headroom
aggregate connection capacity
```

Prefer real generator shards with distinct network namespaces/source IPs if needed.

If real shards are introduced:

- keep aggregate load-generator CPU/memory within the explicitly frozen envelope or correct/refreeze it;
- use deterministic distributed phase barriers;
- measure CPU, memory, event-loop delay, pending connects, failures, and connection-establishment rate per shard;
- merge compatible histograms rather than averaging p95/p99;
- compute global active concurrency from time-aligned snapshots, not by summing unrelated shard peaks;
- compute global connection-rate peaks from aligned time buckets.

Do not preserve a fake `WORKER_COUNT` that does not correspond to real workers.

The generator preflight must inspect/report:

```text
FD soft/hard limits
ephemeral port range
relevant TCP/socket limits
HTTP Agent/maxSockets behavior
pending connection attempts
socket/connect error categories
source IPs/namespaces
destination tuples
target per shard
```

The current runner evidence `nofile` limit must also have real headroom above the number of SSE sockets and other descriptors it needs.

---

## 4.3 Simultaneous active concurrency, not cumulative establishment

The final 100,000 criterion must use **simultaneous active viewer concurrency**.

The current classifier still checks:

```text
connections_established >= connections_target
```

which is cumulative and can be inflated by reconnects.

Change the authoritative criterion to a genuine active-concurrency metric such as:

```text
active_connections_peak >= connections_target
```

with the exact viewer-to-SSE model frozen.

Also fix lifecycle tracking so unexpected stream termination removes the connection from:

```text
active connection count
per-channel subscriber count
expected-delivery eligibility
```

A closed subscription must not remain active merely because it remains in an array.

Freeze an explicit subscriber eligibility boundary:

```text
eligible after successful SSE establishment + handler/baseline readiness
ineligible immediately on deliberate close, terminal stream error, server disconnect, or network termination
```

Report:

```text
viewer_count
SSE_connection_count
active_connections_current
active_connections_peak
lobby_viewers
per-match viewers
connections_per_viewer model
```

Reconnect attempts must never cause a cumulative counter to satisfy the assignment's concurrency criterion.

---

## 4.4 Correct scenario lifecycle and peak-concurrency ordering

The current orchestration still runs:

```text
warmup/base
steady
late join
burst
post-burst
reconnect
slow consumer
surge
restart
```

This is not coherent with claims that steady/burst/late-join/reconnect/slow/restart behavior was exercised at peak if the 60% -> 100% surge happens afterward.

Freeze and implement one executable schedule.

Unless a corrected frozen contract deliberately chooses a different justified sequence, use a lifecycle equivalent to:

```text
preflight
run isolation/reset
history prefill
connect/stabilize 60% base
start steady publication
surge 60% -> 100% over 120s while measuring existing-viewer health
stabilize at 100%
peak steady
late join under peak load
hot-match/burst at peak
post-burst steady
reconnect while publishing
literal restart and/or cross-node recovery according to the frozen claim
slow-client/backpressure at the frozen concurrency
post-run validation
resource finalization
classification
```

Every scenario must record the actual active viewer/SSE population at start and peak.

A scenario may only make a 100k claim if it actually ran at the required stabilized population.

---

## 4.5 The 120-second surge must use absolute deadlines

The current surge implementation does:

```text
connect batch
await connection work
sleep fixed interval
repeat
```

which can stretch the ramp beyond 120 seconds.

Replace it with absolute monotonic deadlines or an equivalently rigorous scheduler.

Record:

```text
surge_target_additions
surge_attempted
surge_established
surge_failures
surge_start_time
surge_end_time
surge_elapsed_ms
surge_timing_error_ms
attempt_rate_peak
establishment_rate_peak
scheduler_lag_p95/p99/max
active_population_start
active_population_end
active_population_peak
```

The completion criterion for the assignment-mapped ramp is not merely 90% of the requested additions.

If generator limitations prevent the frozen ramp before the DUT is falsified, classify the run as `INCONCLUSIVE`, not `REJECT`.

During the surge, existing viewers must continue to be measured for:

```text
latency
unexpected disconnects
missing sequences
duplicates
out-of-order
```

Use a true phase/cohort histogram, not a fragile slice of a rolling recent-sample buffer.

---

## 4.6 Publisher schedule, actual workload rate, and T0 validity

Measure actual generation rather than trusting timer configuration.

For each phase report separately:

```text
phase duration
match events attempted
match events accepted
lobby events attempted
lobby events accepted
total attempted
total accepted
match events/sec
lobby events/sec
total events/sec
per-match distribution
scheduler lag
```

Reconcile the assignment's approximately 10 events/s total and approximately 50/s burst with the active contract's interpretation.

Do not claim a 50/s total assignment workload if the POC intentionally generates 50 match events/s plus a separate lobby update and the governing documents still describe that as the same number.

Capture `publish_timestamp` at the exact frozen fan-out T0 boundary.

Measure scheduled time vs publish-attempt start vs accepted publication. If the simulator itself misses deadlines materially, the run is generator-invalid/`INCONCLUSIVE`.

---

## 4.7 Slow-consumer test is still materially incomplete

The slow-consumer path must be repaired, not merely documented.

The current implementation contains a hard-coded:

```text
boundedMemoryOk = true
```

That must disappear.

The current throttling wrapper must also be verified end to end: replacing a subscription object after the original event handler has already been registered is not evidence that the new wrapper is actually controlling reads.

Implement actual transport/read-side throttling with the frozen receive model, approximately:

```text
slow cohort = 5%
healthy cohort = 95%
slow application consumption ~= 1 event per 2 seconds
```

Measure the achieved behavior rather than assuming it.

Required metrics:

```text
slow_clients
healthy_clients
slow_offered_event_rate
slow_offered_byte_rate
slow_application_read_rate
slow_backlog_growth
backpressure_duration
evidence_server_side_backpressure_reached

healthy_p95_before
healthy_p95_during_slow
healthy_degradation_percent

slow_disconnects
slow_resume_expected
slow_resume_received
slow_resume_gaps
slow_resume_duplicates
slow_resume_out_of_order

Nchan_memory_baseline
Nchan_memory_samples_during
Nchan_memory_end_slow
Nchan_memory_after_recovery
memory_growth_slope_or_frozen_equivalent
retained_memory_delta
bounded_memory_rule_passed
```

Use separate healthy-client phase/cohort histograms. Do not compare two global cumulative latency distributions.

A slow-client test absorbed entirely by client/kernel socket buffers without reaching server-side pressure is `INCONCLUSIVE`, not PASS.

Freeze the bounded-memory trend/settling rule **before** Milestone 3.

---

## 4.8 Resolve the slow-client classifier contradiction

The slow-client scenario currently treats bounded memory + low healthy-client degradation as the core property, while the authoritative classifier still requires:

```text
slow_consumer_disconnects > 0
```

Those are different rules.

Resolve the active contract and classifier to one falsifiable rule based on the real architecture property being tested.

If server disconnect is mandatory, prove and measure it.

If safe bounded catch-up without disconnect is allowed, zero disconnects cannot automatically be `REJECT`.

Do not choose the more favorable interpretation after benchmark results are observed.

---

## 4.9 Real Nchan and Redis resource measurements are still missing

Current resource instrumentation primarily measures the runner process/cgroup and Redis memory.

It does **not** yet provide the complete required service-local evidence.

Implement real measurements for:

```text
runner/loadgen CPU
runner/loadgen memory
runner/loadgen event-loop delay
runner/loadgen backlog

Nchan CPU
Nchan memory

Redis CPU
Redis memory
Redis connected-client peak
```

For multiple Nchan/generator containers, report each instance/shard clearly.

Do not report runner metrics as Nchan metrics.

Do not leave `nchan_memory_mb_peak = null` while treating the evidence as valid.

Mandatory unavailable evidence signals must produce an explicit validity failure/`INCONCLUSIVE`.

Resource metrics must use correct runtime semantics:

```text
cgroup CPU usage deltas over the measured interval
effective cpu.max/cpuset denominator
memory.current / memory.peak where supported
memory.events OOM / OOM-kill deltas
cpu.stat nr_throttled / throttled_usec deltas
```

Do not use lifetime cumulative counters from before the run without baselining them.

Do not silently skip a mandatory CPU-throttling or OOM rule because the signal is null.

Read back actual container limits and verify them against the frozen expected CPU/memory envelope.

---

## 4.10 Resource-envelope contradiction must be resolved

The current evidence Compose topology allocates approximately:

```text
nchan-primary   4 CPU / 4 GB
nchan-2         4 CPU / 4 GB
Redis           2 CPU / 2 GB
runner          8 CPU / 8 GB
```

which is an 18 CPU / 18 GB aggregate auxiliary topology.

The active contract still contains topology/resource prose that can be read as a 14 CPU / 14 GB total.

Reconcile this explicitly.

Keep separate:

```text
primary DUT resource envelope
replacement/cross-node resources
Redis resources
aggregate load-generator resources
measurement/control overhead
host prerequisite
```

Never claim two 4-CPU Nchan nodes as proof of a single 4-CPU DUT capacity result.

If this changes a genuinely frozen experimental variable, create the minimal corrected contract version before evidence.

---

## 4.11 Authoritative classifier still needs complete validity logic

There must remain exactly one authoritative classifier.

Extend it so experiment-invalid conditions take precedence over architecture pass/fail.

At minimum encode structured `INCONCLUSIVE` handling for:

```text
timing/clock invalidity
negative cross-component latency
generator CPU saturation
generator event-loop saturation
generator backlog saturation
publisher scheduler saturation
host FD exhaustion
ephemeral-port exhaustion
client socket/Agent ceiling
Docker/network bottleneck
resource-envelope mismatch
required resource metric unavailable
mandatory scenario skipped
measurement/schema failure
run-isolation failure
persistent repeated-run instability
failure to physically reach the required 100k population because the environment/generator saturates first
```

Do not infer generator health only from:

```text
CPU < 90% && event_loop < threshold
```

while ignoring backlog, connection scheduler failure, or socket exhaustion.

After validity passes:

```text
all mandatory ACCEPT criteria pass -> ACCEPT
any mandatory valid architecture criterion fails -> REJECT
```

The result space must be mutually exclusive and exhaustive.

No undefined metric range and no post-run warning state.

---

## 4.12 Correct the 100k ACCEPT rule everywhere

The repository currently contains stale/inaccurate governance text that still describes a shortcut equivalent to:

```text
>= 10k or machine maximum -> ACCEPT
```

That must not survive as the authoritative interpretation of the assignment's 100,000-viewer target.

Use this distinction:

```text
valid experiment physically reaches frozen 100,000 simultaneous viewer target
    -> eligible for direct local ACCEPT at that target

host/generator/network ceiling prevents 100,000 before the DUT is falsified
    -> INCONCLUSIVE AT 100K SCALE

lower-scale results/extrapolation
    -> useful production inference only, not direct measured proof of 100k
```

Update the active contract if necessary, classifier, traceability matrix, milestone status, tests, and machine output so they all agree.

---

## 4.13 Run isolation is still incomplete

Repeated runs must not inherit stale state.

Implement deterministic run isolation using a safe POC-local mechanism, such as:

```text
dedicated Redis reset at run start
or
run-scoped channel namespace
```

Also reset/rebaseline:

```text
PRNG state
canonical match state
channel/history state
metrics/histograms
connection IDs
active subscriber maps
publisher scheduler state
resource-counter baselines
OOM/throttle deltas
memory-peak strategy
```

Tests must prove that two sequential runs cannot contaminate each other's history, sequence ranges, counters, or resource validity.

The evidence-suite machinery already exists; repair isolation rather than replacing the suite.

---

## 4.14 Literal restart vs cross-node replacement must both match the actual claim

The repository now has real restart control infrastructure and both literal-restart and cross-node code paths.

Do not rebuild that infrastructure.

However, evidence mode currently has `nchan-2` configured, and the restart scenario chooses the cross-node path when `nchan-2` is present. Therefore the existence of the literal restart implementation does not prove it is actually exercised in the evidence lifecycle.

Freeze the repetition policy:

```text
literal restart
cross-node replacement
per-run vs once-per-campaign
```

If the active contract requires literal Nchan process restart, the evidence suite must execute it as required rather than silently substituting cross-node replacement.

For each recovery test record:

```text
resume transport ID
canonical pre-outage sequence
canonical target after recovery
publisher path during outage
accepted events during outage
expected replay range
received replay range
missing
duplicates
out-of-order
recovery_ms
```

A timeout that merely received "some replay events" is not sufficient correctness proof.

Freeze publisher behavior during literal downtime. A stopped single Nchan publisher endpoint cannot accept events. Do not advance canonical state through an unavailable publisher and later blame replay for unaccepted events.

---

## 4.15 Shared-Redis clock compatibility is not currently measured correctly

Current "clock offset" logging is based on HTTP RTT and an `RTT/2` estimate.

RTT is not the same thing as actual wall-clock offset between Nchan instances.

Before accepting shared-Redis restart/replacement evidence, establish the frozen clock-compatibility rule using a valid method.

Record the actual evidence used to establish:

```text
runner wall clock validity
nchan-1 wall clock compatibility
nchan-2 wall clock compatibility
cross-node maximum offset
threshold
pass/fail
```

If same-host container clock semantics are used as the basis, document and verify the exact runtime fact rather than pretending RTT is a clock measurement.

Timing invalidity must cause `INCONCLUSIVE`.

---

## 4.16 Live delivery and replay delivery accounting must be separated

Keep separate structured accounting for:

```text
live_expected_deliveries
live_received_deliveries

late_join_history_expected
late_join_history_received

reconnect_replay_expected
reconnect_replay_received

restart_replay_expected
restart_replay_received
```

Expected live deliveries must use currently eligible subscribers on the exact channel at accepted publish time.

Replay frames must never inflate the live delivery ratio.

Reconnect expected replay must be derived independently from the frozen canonical sequence range, not inferred from the number actually received.

---

## 4.17 Disconnect attribution is still too coarse

Differentiate at least:

```text
deliberate disconnect
unexpected client-side disconnect
Nchan/server-initiated disconnect
network/connect failure
shutdown cleanup
```

Do not use one generic `connections_dropped` counter for all claims.

Normal teardown, reconnect cohort closure, and final cleanup must not count as unexpected Nchan failure.

Unexpected disconnect must immediately affect active/per-channel eligibility.

---

## 4.18 Machine-readable evidence remains incomplete

The single-run and evidence-suite JSON schemas must make every important claim machine-checkable.

Add the missing structured areas rather than hiding them in human `detail` strings.

At minimum include:

```text
contract_version
run_profile
run_mode
seed
resolved_config

environment
preflight
host_limits
runtime_container_limits
generator_topology

scenario_results
scenario_active_concurrency

workload_rate_metrics
scheduler_lag_metrics

viewer_model
connection_metrics
connection_establishment_rate_metrics
disconnect_attribution

live_delivery_accounting
late_join_metrics
reconnect_metrics
restart_metrics
slow_client_metrics

resource_metrics by service/shard
clock_validity
measurement_validity
validity_reasons

parse/schema_error_metrics
claim_provenance

classification
```

Specifically close current omissions such as:

```text
connection_establishment_rate_peak
Redis connected-client peak
late-join expected/received/missing fields
reconnect expected/received fields
viewer_count
current SSE connection count
all per-match viewer counts
schema_validation_errors
missing required transport-ID errors
explicit validity reasons
environment/preflight
separate match/lobby/total rates
```

Do not leave required data only inside scenario log strings.

---

## 4.19 Malformed payload and schema accounting must be explicit

Current JSON parsing still allows broad `any` payload handling at important boundaries.

Add concise runtime validation/type guards for application frames before they influence correctness metrics.

Track at minimum:

```text
sse_parse_errors
json_parse_errors
schema_validation_errors
invalid_timestamp_count
missing_transport_id where required
```

A malformed terminal event must not disappear silently merely because no later sequence exposes a gap.

Mandatory parse/schema failures must affect validity/correctness according to the frozen rule.

---

## 4.20 Remove unsafe type erasure at experiment-critical seams

Keep the existing Ports-and-Adapters structure.

Do not rewrite the architecture.

But remove `any` / broad `as any` where it can hide a mismatch in:

```text
SSE/application payload parsing
ports
metrics interfaces
scenario context
resource evidence
classifier input
```

Use small explicit interfaces and narrow validators.

Experiment-grade code may be concise; type erasure must not hide measurement defects.

---

## 4.21 Evidence-scale logging must not become the bottleneck

Primary Nchan config still enables:

```nginx
access_log /dev/stderr main;
```

Disable or appropriately bound Nginx access logging in evidence mode.

Do not emit per-client/per-event logs at 100k scale.

Use bounded periodic progress and final summaries.

Keep useful diagnostics available for smoke/development if they do not contaminate evidence.

---

## 4.22 Reproducible build identity is not fully closed

Current images/source versions use named tags and source versions, but immutable identity/checksum coverage remains incomplete.

Audit:

```text
Ubuntu base image
Node base image
Redis image
Nginx source tarball
Nchan source tarball
npm dependency lock
```

Keep HTTPS downloads.

Where practical:

- pin image digests;
- verify downloaded source SHA-256 checksums;
- record exact resolved image IDs/digests and source versions in machine-readable output.

Do not allow a floating external build input to silently change the experiment.

Also ensure active contract build prose matches the actual Dockerfile: the Nchan image is built by compiling Nginx source with Nchan, not by magically inheriting an already-built Nchan image.

---

## 4.23 Portable one-command path and profile-correct service addressing

The normal reviewer smoke path must require only a container runtime.

Validate both normal smoke and portable smoke addressing under their actual network modes.

Do not assume `localhost`, `127.0.0.1`, or `host.docker.internal` works identically across Linux Docker Engine, Docker Desktop, and bridge/host networking.

Use service DNS where appropriate.

If high-scale evidence requires Linux host tuning or host networking, keep that as an explicit evidence-host prerequisite and preserve a portable smoke path.

Do not mutate privileged host sysctls automatically.

---

## 4.24 Runtime Nginx/server capacity preflight still needs objective proof

Before calling the evidence profile 100k-ready, verify:

```text
worker_processes
worker_connections
effective Nginx FD limit
listen/accept backlog
non-viewer FD headroom
Redis/upstream/control descriptors
assigned subscribers per Nchan node
effective CPU quota/cpuset
```

`worker_processes 4` is already configured; do not redo that.

Instead prove at runtime that it aligns with the frozen 4-CPU primary DUT envelope and has enough descriptor/connection headroom.

A theoretical exact target with zero descriptor headroom is not sufficient.

---

## 4.25 Percentile sample populations and phase histograms

The streaming histogram machinery already exists.

Do not replace it.

Finish the population semantics.

Required phase/cohort histograms must include, as applicable:

```text
steady live
surge existing-viewer live
burst/hot-match live
healthy-before-slow
healthy-during-slow
late join
reconnect
```

Do not derive a phase p95 from a rolling latest-N buffer slice that may wrap/truncate.

Freeze meaningful sample populations for late-join and reconnect.

A single observation may be reported as one observation, but do not overstate it as a statistically robust p95 unless that interpretation is explicitly frozen and justified.

Verify histogram overflow behavior:

```text
valid very-high latency cannot disappear
negative cross-component latency invalidates timing
overflow counts are structured and classified correctly
```

---

## 4.26 Existing traceability/metric documents must be corrected, not trusted blindly

The repository already has:

```text
internal_docs/TRACEABILITY_MATRIX.md
poc/internal_docs/METRIC_COVERAGE_MATRIX.md
poc/internal_docs/MILESTONE_2_AUDIT_GAP_REPORT.md
poc/internal_docs/PARAMETER_LEDGER.md
```

Do not create redundant replacements unless necessary.

Instead reconcile them with actual code.

The current traceability matrix contains claims that are not presently true, including stale 10k/machine-max ACCEPT semantics and conditional PASS treatment for unavailable resource metrics.

A matrix row is `PASS` only if implementation + test + metric + classifier behavior actually support the requirement.

Before 100%:

```text
zero BLOCKED rows
zero falsely marked PASS rows
zero unmapped normative active-contract requirements
zero required metrics represented by placeholders while treated as measured
```

Update the parameter ledger for any new/fixed result-affecting constant.

Maintain authoritative-source provenance for technical facts used to correct Nchan, Redis, Node, Docker, cgroup, or network behavior.

---

## 4.27 Milestone status must be reconciled with actual completion

The current milestone/documentation state contains prose saying Milestone 2 is DONE based on a lower-scale ACCEPT.

Do not trust or preserve that status merely because it exists.

Until this updated completion gate passes:

```text
Milestone 2 remains open for gap closure.
```

Only after the full gate passes may:

```text
internal_docs/LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md
```

be updated to:

```text
Milestone 1 — DONE
Milestone 2 — DONE — 100%
Milestone 3 — NEXT
```

Do not write Milestone 3 benchmark results into that update.

---

# 5. Focused tests required for the remaining gaps

Retain existing passing tests as regressions.

Add/fix tests for the unresolved areas below.

## Full history / late join

- deterministic explicit prefill;
- independently known history range;
- live-arrival margin cannot evict required history;
- missing/duplicate/out-of-order replay detection;
- late-join timer begins before connection;
- replay ends only after frozen-head parse + canonical validation;
- score/clock/head reconstruction matches committed state;
- history wire `event:` semantics match active contract.

## 100k topology / connection semantics

- topology arithmetic proves enough source tuples;
- per-shard target and aggregate target sum exactly;
- active connections exclude terminally closed streams;
- per-channel counts decrement on unexpected termination;
- cumulative reconnect establishments cannot satisfy active target;
- actual active peak is used by classifier;
- FD/socket/Agent preflight failures produce `INCONCLUSIVE`.

## Surge / schedule

- exact lifecycle order;
- peak-required scenarios cannot execute before stabilized 100%;
- absolute-deadline 120-second surge;
- scheduler-lag boundary cases;
- 60% -> 100%, never 100% -> 140%;
- success criterion requires the frozen final population;
- surge existing-viewer phase histogram/correctness is isolated.

## Slow consumer

- throttling actually controls transport reads;
- achieved receive rate is measured;
- exactly frozen slow fraction;
- healthy cohort metrics are separate;
- offered/read/backlog arithmetic proves backpressure;
- no hard-coded bounded-memory PASS;
- Nchan memory trend/settling rule;
- zero-disconnect classifier semantics match frozen contract;
- slow resume correctness.

## Resources / validity

- Nchan CPU/memory real producer;
- Redis CPU/memory/client peak real producer;
- per-shard loadgen resources;
- cgroup counter baseline/delta;
- CPU quota normalization;
- CPU throttling exact rule;
- OOM/OOM-kill exact rule;
- unavailable mandatory signal -> INCONCLUSIVE;
- actual resource-limit mismatch -> INCONCLUSIVE;
- host/port/network ceiling -> INCONCLUSIVE;
- generator backlog/scheduler saturation -> INCONCLUSIVE.

## Accounting / output

- live and replay accounting cannot mix;
- reconnect replay expected count independently derived;
- all per-match viewer counts emitted;
- connection-establishment peak rate emitted;
- disconnect attribution emitted;
- schema errors emitted and classified;
- machine-readable preflight/validity fields present;
- claim provenance cannot turn a production inference into a POC measurement.

## Restart / shared Redis

- literal restart is actually executed when required even if nchan-2 exists;
- cross-node replacement remains distinct;
- restart/replacement expected replay ranges are independently known;
- missing/duplicate/order checked;
- publisher behavior during literal downtime is canonical-safe;
- valid clock compatibility evidence is recorded.

## Reproducibility

- immutable build identity/checksum coverage;
- evidence access logging disabled/bounded;
- clean checkout builds custom images;
- one-command smoke requires no host Node/npm/Redis/Nginx;
- profile-correct service addressing;
- exact clean commit SHA recorded;
- clean source tree before and after validation.

---

# 6. Development validation loop

After each meaningful repair, run the relevant focused tests.

Then repeatedly execute the applicable validation sequence:

```text
PASS 1   inspect repository / recalculate remaining gap
PASS 2   typecheck
PASS 3   unit tests
PASS 4   clean Docker build
PASS 5   nginx -t
PASS 6   Redis health
PASS 7   Nchan primary health
PASS 8   Nchan replacement health where applicable
PASS 9   basic publish -> SSE receive
PASS 10  lobby retained-current-state regression
PASS 11  deterministic history prefill + replay
PASS 12  late join under live load
PASS 13  reconnect while publishing
PASS 14  literal restart
PASS 15  cross-node shared-Redis recovery where retained
PASS 16  slow-client/backpressure
PASS 17  60% -> 100% deadline-based surge
PASS 18  100k topology/capacity preflight
PASS 19  real resource measurements
PASS 20  classification invalidity matrix
PASS 21  machine-readable result schema
PASS 22  repeated-run isolation/aggregation logic
PASS 23  clean one-command smoke terminal result
PASS 24  traceability/metric matrix reconciliation
PASS 25  clean-tree / fresh-checkout reproducibility
PASS 26  adversarial completion audit
```

If any pass fails:

```text
fix
rerun failed pass
rerun dependent passes
continue
```

Do not skip failed checks.

Do **not** run the full final 3–8-run / 100k Milestone 3 evidence campaign.

---

# 7. Milestone 2 completion gate

Milestone 2 is 100% only when all of the following are true.

## Contract / governance

- active frozen contract has no unresolved contradiction;
- assignment 100k target is not weakened to a 10k measured ACCEPT shortcut;
- full-history claim and actual retained-history behavior are consistent;
- resource envelope matches actual topology;
- slow-client acceptance rule is internally consistent;
- literal restart vs cross-node replacement claims are distinct and executable;
- traceability matrix reflects actual code, not aspirational PASS labels.

## 100k readiness

- viewer-to-SSE model is frozen;
- evidence target is 100,000;
- topology can legitimately attempt 100,000 simultaneous viewers without a deterministic single-source ephemeral-port ceiling;
- real generator shards exist if required by the topology;
- Nginx/FD/socket capacity has headroom;
- active concurrency, not cumulative establishment, is authoritative;
- host/generator saturation before target produces `INCONCLUSIVE`.

## Workload / schedule

- one coherent phase schedule exists;
- surge occurs before peak-required scenarios;
- surge uses absolute deadlines and reaches the frozen target;
- actual rates and scheduler lag are measured;
- hot-match denominator remains unambiguous;
- every peak-required scenario reports actual active concurrency.

## History / resume

- explicit deterministic history prefill exists;
- history expected/received/missing are independently measurable;
- complete required history cannot be evicted by the test itself;
- late join reconstructs score/clock/head at frozen target;
- reconnect expected replay is independently known;
- transport cursor stays separate from canonical sequence;
- literal restart and cross-node behavior match active claims.

## Slow client

- only frozen slow cohort is throttled;
- achieved read rate is measured;
- genuine server-side backpressure is demonstrated;
- healthy cohort is measured separately;
- Nchan memory before/during/after is real;
- bounded-memory rule is frozen and measured;
- classifier agrees with frozen disconnect/catch-up semantics.

## Resource validity

- Nchan CPU/memory measured;
- Redis CPU/memory/client peak measured;
- load-generator resource health measured per real shard;
- CPU percentages use correct quota/cpuset denominator;
- throttling and OOM use run deltas/baselines;
- actual runtime resource limits match frozen declarations;
- mandatory unavailable metric cannot silently pass.

## Accounting / errors

- live and replay deliveries are separated;
- expected live deliveries use active eligible per-channel subscribers;
- terminal disconnect removes eligibility;
- disconnect reasons are attributed;
- parse, JSON, schema, timestamp, and required transport-ID errors are counted;
- high latency cannot disappear due to filtering/truncation.

## Classification

- one authoritative classifier;
- smoke cannot return architecture ACCEPT;
- invalid experiment -> INCONCLUSIVE;
- valid architecture criterion failure -> REJECT;
- valid all-pass evidence -> ACCEPT;
- 100k criterion uses simultaneous active concurrency;
- all mandatory invalidity reasons are evaluated;
- no valid result range is unclassified.

## Output

- human summary exists;
- machine JSON contains environment/preflight/topology/schedule/scenarios/metrics/validity/classification;
- viewer counts and per-channel distribution are explicit;
- late/reconnect/restart expected vs received ranges are explicit;
- workload rates and scheduler lag are explicit;
- resource fields are service/shard-specific;
- exit semantics are deterministic.

## Reproducibility / scope

- evidence-scale logs are bounded;
- build inputs are sufficiently immutable/verified;
- portable one-command smoke works with only container runtime;
- no hidden untracked build/dependency/result artifact is required;
- fresh-checkout proof records exact commit SHA;
- no demonstration UI or production-system scope is added;
- existing parameter/source/metric/traceability ledgers are reconciled;
- final deletion/scope audit finds no unnecessary POC component.

## Testing

- typecheck passes;
- implementation/unit/measurement-oracle tests pass;
- Nginx config tests pass;
- focused integration paths pass as harness tests;
- one-command smoke reaches a deterministic structured terminal result;
- genuine DUT smoke outcome remains truthful rather than being forced favorable;
- tree is clean after validation.

Only then may Milestone 2 be marked:

```text
DONE — 100%
```

---

# 8. Adversarial final audit

After the completion gate appears to pass, perform a separate adversarial pass whose only purpose is to falsify the completion claim.

Search specifically for:

```text
contradictory contract statements
stale 10k/machine-max ACCEPT language
cumulative counters used as concurrency
placeholder null/0 metrics treated as measured
dead connections still counted as active
single-source TCP ceiling
FD headroom mistakes
phase order that makes a 100k claim at 60%
sequential timer drift
mixed live/replay accounting
rolling-buffer phase percentile bias
slow-client test that never reaches server pressure
hard-coded PASS values
cgroup lifetime counters mistaken for run deltas
RTT mistaken for clock offset
literal restart implemented but not actually executed
cross-node replay that only checks "some event arrived"
build inputs that can change without source change
profile-specific addressing that fails on a clean reviewer machine
traceability rows marked PASS without executable support
unnecessary product scope
```

If anything material is found, completion drops below 100% and the loop resumes.

Do not stop until this adversarial pass finds no material Milestone 2 gap.

---

# 9. Contract correction rule

Create a new frozen contract version only for a genuine result-affecting contradiction.

If required:

1. identify exact conflicting statements;
2. define the minimum correction;
3. document `OLD / NEW / WHY`;
4. do not use benchmark results to choose the correction;
5. freeze the new version;
6. update milestone/source-of-truth references;
7. continue implementation against the new version immediately.

Do not create contract versions for ordinary code bugs or cosmetic wording cleanup.

---

# 10. External execution blockers

If execution fails:

1. diagnose;
2. fix every repository-local cause;
3. try a repository-local alternative;
4. rerun;
5. continue.

Examples:

```text
Docker build failure -> fix Dockerfile/Compose
portable-addressing failure -> fix network/profile addressing
Nchan config failure -> fix config
resource metric unavailable -> implement safe service-local measurement
100k source-port ceiling -> fix generator topology
scenario timeout -> determine whether scheduler/harness/DUT is responsible
```

Only a genuine external impossibility outside repository control may stop the loop below 100%.

If that happens:

- do not claim completion;
- leave Milestone 2 open;
- identify the exact blocker;
- identify every completion-gate item still unverified.

---

# 11. Do not start Milestone 3

Do NOT:

- run the full final 3–8 qualifying evidence repetitions;
- perform the final full-scale 100k evidence campaign;
- declare the final production architecture ACCEPT/REJECT from Milestone 3 evidence;
- write `proposal.md`;
- complete the final cost model;
- create the final submission README;
- package the final ZIP;
- deploy AWS resources.

The exact next task after successful Milestone 2 completion is:

```text
Milestone 3 — Run the Frozen POC and Produce Evidence
```

---

# 12. Final response format

When and only when the gap is genuinely 100% closed, report:

## Completion

```text
Milestone 2 completion: 100%
Milestone 2 status: DONE
Milestone 3 status: NEXT
```

## Repository changes

- files created;
- files modified;
- files removed.

## Final validation

- typecheck command + result;
- unit-test command + result;
- Docker clean-build command + result;
- `nginx -t` result;
- one-command smoke run + structured result;
- explicit `HARNESS_VALID` / `HARNESS_INVALID`;
- truthful DUT smoke observation;
- machine-readable JSON validation;
- documented exit-code behavior + observed smoke exit code;
- exact clean-checkout commit SHA.

## Remaining-gap proof

Report the final values/evidence for the items that were open in this updated prompt, including:

- retained history depth + eviction margin;
- late-join expected/received/missing + reconstructed state;
- viewer/SSE model;
- 100k generator source/destination tuple capacity;
- active concurrency peak;
- per-channel viewer counts;
- FD/socket/Nginx capacity preflight;
- exact scenario order;
- actual 120-second surge timing error;
- scheduler lag;
- match/lobby/total publish rates;
- slow offered/read/backlog rates;
- proof server-side backpressure was reached;
- healthy-before/during-slow p95;
- Nchan memory trend/settling;
- Nchan CPU/memory;
- Redis CPU/memory/client peak;
- per-shard generator health;
- resource-limit readback;
- OOM/throttle deltas;
- validity-reason matrix;
- live vs replay delivery accounting;
- reconnect expected/received;
- literal restart result;
- cross-node result if retained;
- actual shared-Redis clock compatibility result;
- disconnect attribution;
- parse/schema error counts;
- immutable build identities/checksums;
- clean-checkout reproducibility;
- traceability matrix closure;
- scope-minimization audit.

## Evidence readiness

- evidence target = 100,000 viewers;
- exact viewer-to-SSE model;
- exact generator shard/source-IP/destination topology;
- exact Nginx capacity preflight;
- frozen resource envelopes;
- frozen scenario schedule;
- frozen validity thresholds;
- evidence-suite min/max run count and variance rule;
- exact one-command evidence command;
- confirmation that Milestone 3 final evidence campaign was **NOT** run.

## Remaining blockers

Must be:

```text
NONE
```

if claiming 100%.

Do not paste the full source code into the response.

Do the work in the repository.
Do not stop at a percentage below 100%.
