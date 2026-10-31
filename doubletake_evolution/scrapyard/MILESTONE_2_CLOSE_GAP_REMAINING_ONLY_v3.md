# Milestone 2 — Close Remaining Gap to 100% — Remaining Work Only v3

Repository:

https://github.com/olejardamir/EA

Repository state audited for this revision:

```text
main = 0f25803666203c941e615b8c6e9ff7dceb4fc072
```

This is the next trimmed continuation of:

```text
MILESTONE_2_CLOSE_GAP_REMAINING_ONLY_v2.md
```

Everything demonstrably complete in the current repository has been removed.

This file contains **only the remaining Milestone 2 gaps** that are still incomplete, partially implemented, contradictory, incorrectly classified, or not wired into the actual evidence path.

Do not redo completed work unless a regression proves it broken.

Work sequentially:

```text
inspect
-> identify highest-impact remaining real gap
-> fix
-> focused tests
-> regression tests
-> verify actual evidence path
-> recalculate remaining gap
-> repeat
```

Stop only when Milestone 2 is genuinely complete.

Do not execute Milestone 3.

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

Milestone 2 validates the experiment implementation.

It does not require forcing a favorable Nchan/Redis result.

---

# 2. Frozen-contract integrity is still unresolved

The current repository still uses:

```text
internal_docs/LIVE_MATCH_CENTRE_POC_EXPERIMENT_CONTRACT_v2_0_2.md
```

but that file has been materially modified after being treated as frozen.

Do not continue to mutate a frozen version in place.

If any of the already-made or still-required corrections are result-affecting:

```text
preserve v2.0.2 as historical frozen state
create the minimal successor, e.g. v2.0.3
document OLD / NEW / WHY
freeze the successor
update milestone/source-of-truth references
```

The active contract must also be reconciled with the implementation for the remaining contradictions below.

---

# 3. Remaining gaps

## 3.1 Late-join prefill still bypasses the real canonical publisher state machine

The prefill implementation has improved:

```text
valid event type used
explicit deterministic numeric seq values generated
unsafe `as any` access removed
```

Do not undo those changes.

However, the current prefill still calls:

```text
MatchEventPublisher.publishRaw(...)
```

and then manually calls:

```text
headTracker.updateHead(...)
```

This bypasses the normal publisher path that owns:

```text
per-match serialization
candidate-state transition
score mutation
clock mutation
accepted-publish commit
publisher counters
head-state commit
expected-delivery accounting
```

It can therefore create a history stream whose canonical sequence/head no longer corresponds to the publisher's real committed match state.

It also runs while the ordinary publisher remains active, so the normal publisher can interleave events for the same match with the raw prefill sequence range.

### Required repair

Add an explicit canonical prefill API to `MatchEventPublisher` that uses the same per-match serialization and accepted-commit semantics as ordinary publishing.

Required invariant:

```text
for every successfully accepted prefill event:
  seq advances exactly once
  score/clock state is the committed state represented by that event
  headTracker state is the same committed state
  no normal event can interleave and reuse/overtake that canonical position
```

Do not use raw adapter publishing for canonical match history.

### Expected history must be independent of received history

Current late-join code still derives:

```text
historyExpected = frozenTargetHead - firstSeq + 1
```

where `firstSeq` came from the received replay.

That can hide a missing replay prefix.

Freeze before connection:

```text
expected_first_seq
expected_last_seq
history_expected
```

Then compare received data to that independent range.

### State comparison must use the exact frozen target state

The current comparison calls the current `headTracker.getHeadState(...)` after replay.

Because the ordinary publisher continues running, that state may have advanced beyond the frozen late-join target.

Freeze the committed state snapshot at:

```text
target_head_at_connection_start
```

and compare reconstructed replay state to that exact snapshot.

No fallback such as:

```text
score >= 0
clock >= 0
```

may count as successful state reconstruction.

### Buffer-capacity proof remains required

Explicitly prove:

```text
buffer_capacity
expected_history_depth
maximum live arrivals during catch-up
required_capacity
capacity_margin
```

The test must not be able to evict its own expected prefix.

Required structured fields:

```text
expected_first_seq
received_first_seq
expected_last_seq
received_last_seq
history_expected
history_received
missing_history_sequences
duplicate_history_sequences
out_of_order_history_sequences
catch_up_ms
reconstructed_score_matches
reconstructed_clock_matches
reconstructed_head_matches
buffer_capacity
live_arrival_margin
```

---

## 3.2 100,000-viewer generator topology is still not capable of the target

The preflight now correctly recognizes a structural source-port limitation and parses Linux ephemeral-port ranges more defensibly.

Keep that work.

But the actual evidence topology still reports:

```text
source_ip_count = 1
```

and uses one runner network namespace/source address.

Therefore the topology itself still cannot legitimately establish 100,000 simultaneous TCP connections to one subscriber destination using a normal ephemeral-port range.

Implement a real 100k-capable generator topology.

Freeze:

```text
viewer_count
connections_per_viewer
SSE_connection_count
generator_shard_count
source namespace/IP per shard
destination tuple(s)
target per shard
ephemeral-port capacity per shard
FD capacity per shard
aggregate simultaneous tuple capacity
```

Prefer real generator containers/shards with distinct namespaces/source IPs.

A numeric shard count without real independent source tuples is not sufficient.

If sharded, implement:

```text
per-shard CPU
per-shard memory
per-shard event-loop p99
per-shard active connections
per-shard connection failures/categories
per-shard pending-connect backlog
coordinated phase barriers
time-aligned global active concurrency
time-aligned global connection-rate buckets
merged histograms rather than averaged p95/p99
```

The configured topology must have headroom above 100,000, not an exact theoretical ceiling.

---

## 3.3 Topology / Nginx preflight still has correctness defects

Topology failure is now fed into the classifier in the single/evidence run paths. Keep that.

Remaining defects:

### CPU quota parser in `topology-preflight.ts`

The helper attempts to find `cpu.max` information inside:

```text
/sys/fs/cgroup/cpu.stat
```

`cpu.max` is a separate cgroup file.

Read the correct file and correctly derive effective assigned CPUs.

Include cpuset constraints where relevant.

### Nchan control-server CPU sufficiency check is inconsistent

The runtime preflight currently has logic equivalent to:

```text
if cpu_quota < 2 -> failure
reason says need >= 4
```

The frozen primary Nchan CPU envelope must have one consistent rule.

### Nginx capacity must include real headroom

Do not treat:

```text
worker_processes * worker_connections
```

as usable SSE capacity without accounting for:

```text
listener sockets
Redis sockets
publisher/control connections
Nginx internal descriptors
non-viewer overhead
process RLIMIT_NOFILE
```

Verify the limit that actually applies to the Nginx worker processes.

A control-server process limit is useful only if it is proven to match the Nginx worker limit.

---

## 3.4 Active-connection lifecycle is still wrong during reconnect

The classifier now uses:

```text
active_connections_peak
```

and the evidence suite wires it.

Keep those fixes.

Remaining defect:

`ReconnectScenario` directly closes the reconnect cohort but does not remove those entries from the pool/per-channel active counts at the close boundary.

During the disconnection interval they can therefore remain:

```text
pool.size
subscriber count
expected-delivery eligibility
active current population
```

even though their SSE streams are closed.

Fix with an explicit pool lifecycle operation such as:

```text
markDeliberatelyDisconnected(entry)
removeActiveEntry(entry, reason)
```

that immediately:

```text
removes active entry
decrements per-channel subscribers
updates active current metric
records deliberate disconnect reason
preserves the saved reconnect state needed for resume
```

When the connection is re-established, re-add it once.

Also add terminal error/end handling to the newly reconnected subscription.

A reconnected stream that later ends must not remain active.

Report:

```text
active_connections_current
active_connections_peak
active_at_scenario_start
active_at_scenario_end
```

for every scenario making a peak-concurrency claim.

---

## 3.5 Reconnect replay accounting is still not canonical enough

The global-received-count bug was removed. Keep that.

Remaining defects:

### Expected replay boundary

The current expected count uses the match head observed **after the full reconnect/catch-up wait**.

That can include ordinary live events occurring after the client already caught up.

Freeze each reconnecting client's target head at the correct boundary.

For each client record:

```text
saved_last_canonical_seq
target_head_at_reconnect_start
expected_first_seq
expected_last_seq
expected_count
```

Then stop replay accounting when that frozen target is reached.

### Reconnect tracker remains in reconnect mode

After catch-up, the connection must transition back to live/steady mode.

Otherwise later ordinary live deliveries continue to be classified as reconnect traffic.

### Transport ID is currently dropped in the reconnect callback

`ReconnectScenario` calls:

```text
pool.handleMessage(entry, evt.event.data)
```

without passing:

```text
evt.event.id
```

The schema/transport metric logic now treats missing IDs as an error.

Pass the real transport ID through.

### Required result

```text
reconnect_expected
reconnect_received
reconnect_missing
reconnect_duplicates
reconnect_out_of_order
reconnect_target_head
reconnect_caught_up_at
```

All expected counts must be independent of received counts.

---

## 3.6 Surge phase still has two measurement defects

The following are now complete and must not be redone:

```text
absolute deadline scheduling
exact target required for PASS
actual per-batch attempt/establishment/failure deltas
required ramp rate derived from surgeCount / 120s
```

Remaining issues:

### Generator-saturation rule is still arbitrary

Current logic uses a peak-rate test equivalent to:

```text
establishmentRatePeak < requiredRampRate * 0.5
```

A 50% factor is not sufficient evidence that the generator can or cannot sustain the frozen ramp.

Freeze an explicit validity rule based on the actual requirement:

```text
sustained additions over 120 seconds
```

not merely one peak bucket.

Use a sustained/average/deadline metric with a justified tolerance.

### Surge histogram is still populated from a rolling raw-sample slice

The code creates a dedicated histogram, but fills it from:

```text
snap.fan_out_latencies_ms.slice(fanOutBefore)
```

If the bounded raw array wraps during a large phase, the phase distribution can still be truncated.

Use the already-added phase histogram machinery directly.

`surge_fan_out_p95_ms` must come from the dedicated `surge` phase histogram, not from a recent-sample slice.

Also ensure unexpected disconnects during surge use real attributed terminal events, not a counter that is never produced.

---

## 3.7 Workload-rate output still does not distinguish the required components

Publisher T0 serialization and scheduler-lag collection were added in the single-run path. Keep those changes.

Evidence phase snapshots are also now populated. Keep them.

Remaining work:

For every relevant phase report separately:

```text
match events attempted
match events accepted
lobby events attempted
lobby events accepted
total attempted
total accepted
match accepted events/s
lobby accepted events/s
total accepted events/s
per-match accepted distribution
```

Current phase output primarily exposes:

```text
eventsPerSec
hotMatchPct
```

That is not enough to prove the frozen approximately-10/s and approximately-50/s workload interpretation.

The publisher already knows enough to track this cleanly; add explicit counters rather than reconstructing ambiguous totals later.

### Evidence-suite scheduler lag

The single-run main loop drains publisher scheduler-lag samples into metrics.

Verify/fix the evidence-suite loop so it performs the same operation.

Do not allow evidence runs to report default scheduler-lag zero merely because the single-run path is wired.

---

## 3.8 Slow-consumer test still does not prove its claimed property

Unsafe mock-private `_lastHandler` access has been removed. Keep that.

Dedicated healthy-during measurement and Nchan memory sampling have been added. Keep them.

The core evidence is still invalid.

### Offered and consumed are still the same boundary

The throttled wrapper increments:

```text
_offeredCount
eventsReceived
```

for the same callback.

Therefore:

```text
slow_offered_event_count
slow_application_read_count
```

do not independently measure producer offer rate versus application consumption.

Define real boundaries.

At minimum distinguish:

```text
bytes/events offered by Nchan/socket
bytes/events actually consumed by the throttled application
```

### Aggregated timestamps across all slow clients do not prove per-client 2-second pacing

Current code merges event timestamps from all slow clients, sorts them globally, then calculates inter-event intervals.

With many slow clients, those timestamps naturally interleave.

Measure achieved rate and inter-event spacing **per slow client**, then aggregate correctly.

### Server-side backpressure evidence remains too weak

Current code calls backpressure proven when any of:

```text
slow disconnect
Nchan memory increased
healthy latency degraded
```

occurs.

A small Nchan memory increase or general latency change does not prove that the server's slow-subscriber buffering reached meaningful backpressure.

Define a falsifiable server-side pressure signal.

Do not confuse:

```text
client/app throttling
kernel socket buffering
normal Nchan memory variation
actual Nchan slow-subscriber backpressure
```

If the test is absorbed by socket/kernel buffers:

```text
INCONCLUSIVE
```

### Bounded-memory rule is not defensible yet

Current rule is approximately:

```text
Nchan memory growth < 100 MB
```

and if Nchan memory is unavailable it can treat boundedness as true.

Freeze a justified before/during/end/recovery trend rule.

Required:

```text
baseline
time-series samples
growth slope or equivalent
end-of-slow memory
post-recovery memory
retained delta
sample duration
boundedness threshold/rationale
```

Unavailable required Nchan memory evidence must not count as bounded.

### Slow-client ACCEPT semantics remain inconsistent

The active contract says:

```text
slow_consumer_disconnects > 0
0 -> INCONCLUSIVE
```

but the classifier currently treats broader `evidenceBackpressure` as the slow-client gate.

That can allow zero disconnects to pass if memory merely increased.

Choose one frozen rule and make contract, scenario, classifier, traceability, and tests agree.

---

## 3.9 Resource metrics exist, but evidence validity is still incomplete

The repository now collects:

```text
Nchan CPU estimate
Nchan memory
Redis CPU estimate
Redis memory
Redis connected-client peak
```

Keep that work.

Remaining issues:

### CPU normalization

Nchan and Redis CPU percentages are currently derived from CPU-time deltas divided by wall time.

Freeze and report the unit clearly.

If 4 CPUs are assigned to Nchan:

```text
100% = one CPU
or
100% = all four assigned CPUs
```

must be explicit.

The same must hold for the runner and Redis.

Use effective cgroup quota/cpuset when normalizing.

### Per-run cgroup baselines

Counters such as:

```text
nr_throttled
throttled_usec
oom
oom_kill
memory.peak
```

are cumulative over the container/cgroup lifetime.

The evidence suite reuses the same containers for multiple runs.

Capture per-run baselines and classify **deltas**, not lifetime values.

### Evidence-suite CPU wiring

Verify the evidence-suite run wires:

```text
nchan_cpu_percent_peak
redis_cpu_percent_peak
```

from `ResourceSnapshot` into each run's `AggregatedMetrics`.

Do not let null values become zero during cross-run aggregation.

### Mandatory metric availability

In evidence mode, all required resource signals must either be:

```text
present and valid
or
explicitly INCONCLUSIVE
```

Do not selectively require memory while silently accepting missing CPU/throttle/OOM evidence.

---

## 3.10 Once-per-campaign restart logic currently makes later runs invalid

The restart scenario itself now runs **both**:

```text
literal restart
cross-node replacement
```

when both paths are configured.

Keep that.

The evidence suite now executes restart only on run 0 and marks later runs:

```text
skipped (once-per-campaign, run 0 only)
```

However, the per-run classifier currently contains:

```text
if evidence && nchan_restart_skipped -> INCONCLUSIVE
```

Therefore runs 1+ become `INCONCLUSIVE`, which prevents the final suite from ever satisfying the rule that every per-run verdict is `ACCEPT`.

Fix campaign-level semantics.

One valid approach:

```text
per-run classifier excludes campaign-only restart gate on runs where it is intentionally not scheduled
campaign classifier separately requires the once-per-campaign restart result to PASS
```

Do not mark a deliberately campaign-level omission as an invalid mandatory skip.

The distinction between:

```text
not scheduled by frozen repetition matrix
unexpectedly skipped
```

must be machine-readable.

---

## 3.11 Restart/replacement replay correctness is still incomplete

Timeout-with-partial-replay now returns failure. Keep that fix.

Remaining defects:

### Literal restart expected count is still derived from received data

The code creates:

```text
frozenExpectedFirstSeq
frozenExpectedCount
```

but does not actually use them as the authoritative expected range.

It later computes expected using replayed events.

That is still circular.

### Literal restart completion boundary is wrong

The reconnect completion condition can succeed when:

```text
received_seq >= lastSeq_before_restart
```

which may merely replay the pre-restart event itself.

If the test intends to prove events/history across the restart boundary, freeze the target range accordingly.

### Cross-node target is also too weak

The cross-node path can complete once it reaches the last sequence already seen on node 1.

Freeze what the cross-node property actually proves:

```text
history available on replacement node
resume cursor honored
required canonical range received
```

and independently define expected first/last.

### Publisher behavior during literal downtime

Explicitly freeze and record:

```text
whether ordinary publisher continues attempting
which endpoint receives those attempts
which attempts are accepted
canonical state commit behavior while Nchan is down
expected replay range after recovery
```

Do not advance canonical state for unaccepted publishes.

Required structured output for literal and cross-node separately:

```text
transport_resume_id
expected_first_seq
expected_last_seq
received_first_seq
received_last_seq
expected_count
received_count
missing
duplicates
out_of_order
recovery_ms
```

---

## 3.12 Clock validity is still not part of the real evidence path

The old RTT/2 estimate was removed from the single-run path. Keep that.

However:

- evidence mode delegates to `runEvidenceSuite` before the single-run clock evidence block;
- evidence-suite runs do not currently carry equivalent clock validation;
- single-run code assumes same-host shared-kernel clock offset is exactly zero rather than producing a measured/verified result;
- machine evidence still needs an authoritative clock-validity result for the actual evidence campaign.

Implement one consistent clock-validity mechanism used by both single and evidence paths.

If the experiment's claim is:

```text
all relevant processes use the same host kernel wall clock
```

prove the topology satisfies that condition and record it as a topology fact.

If any component is in a separate VM/host, use an actual offset measurement.

Required:

```text
clock_model
nodes covered
measurement/proof method
offset or guaranteed shared-clock property
uncertainty
threshold
validity result
```

Invalid timing -> `INCONCLUSIVE`.

---

## 3.13 Live/replay accounting is still not trustworthy

Metric fields and separation exist. Keep them.

Remaining problems:

### `ConnectionPool.handleMessage` increments live expected and received together

For every steady message it currently does effectively:

```text
live_expected += 1
live_received += 1
```

That makes the delivery ratio tautological at the receiver.

Expected live deliveries must come from the publisher at accepted publish time using currently eligible subscribers.

Received live deliveries must come from actual received frames.

Do not increment expected delivery on receive.

### Existing expected-fan accounting must become the authoritative live expected source

The publisher already calls subscriber-count logic when a publish is accepted.

Use that channel-aware producer as the independent expected value.

### Reconnect/restart expected values

Fix the remaining circular replay expected-range issues described above.

The final accounting must make it possible to observe:

```text
expected > received
```

when a delivery is actually lost.

---

## 3.14 Disconnect attribution / active eligibility still needs final closure

Attribution counters now exist and normal initial stream errors are categorized.

Keep that.

Still audit and test:

```text
normal EOF/end
aborted
error
ECONNRESET
server-initiated close
deliberate reconnect cohort close
slow-client close
literal restart-induced stream termination
final shutdown
```

Every terminal event must:

```text
be attributed exactly once
update active membership exactly once
update per-channel subscriber count exactly once
remove live expected-delivery eligibility immediately
```

`disconnectAll()` currently increments deliberate disconnects for all shutdown connections and then increments one cleanup counter for the entire teardown.

Freeze whether shutdown cleanup is:

```text
per connection
or
one cleanup operation
```

and name/count it consistently.

---

## 3.15 Machine-readable output still has misleading concurrency/provenance fields

The JSON has been expanded substantially. Keep it.

Remaining defects:

### Scenario active concurrency is not all channels

Current machine output can compute:

```text
total_active_subscribers =
  lobby_subscribers + match_001_subscribers
```

which excludes match-002 through match-008.

Emit all channel counts and the true total.

### Per-scenario concurrency

Emit:

```text
active_at_start
active_peak
active_at_end
```

for each scenario that makes a scale claim.

### Workload breakdown

Emit match/lobby/total attempted + accepted rates as described above.

### Restart canonical ranges

Emit independently frozen literal/cross-node expected/received ranges.

### Build commit identity in the container

`getGitCommitSha()` runs:

```text
git rev-parse HEAD
```

inside the runner container, but the runner image does not copy `.git`.

Therefore `git_commit_sha` can be null.

Pass the exact source commit SHA into the image/run explicitly, for example via build ARG/ENV or Compose, and emit it.

The pinned image/source checksums already present are good; do not redo them.

### Direct-accept eligibility

Do not make direct 100k eligibility depend only on configured target.

It must require:

```text
actual active target reached
topology valid
generator valid
timing valid
required measurements present
```

---

## 3.16 Evidence-suite metric parity is still incomplete

Several important single-run fixes have now been copied into evidence-suite runs:

```text
phaseSnapshots
active_connections_peak
surge detail fields
slow_consumer_metrics
topology preflight
Redis reset before every run
histogram clone before pooling
```

Keep them.

Still verify/fix parity for:

```text
publisher scheduler-lag sampling
phase histograms
build identity
clock validity
Nchan CPU percent
Redis CPU percent
all channel viewer counts
current active connections
canonical late/reconnect/restart range fields
resource baseline/delta fields
```

A field must not silently remain its `aggregateWorkerMetrics` default in evidence mode.

### Cross-run null handling

Do not do:

```text
Math.max(0, ...(nullableMetric ?? 0))
```

for mandatory evidence metrics.

That converts "unavailable" into a real-looking zero.

If any mandatory run lacks the metric, campaign validity must be `INCONCLUSIVE`.

### Aggregate semantics

Keep per-run scale metrics distinct from campaign totals.

Counters such as:

```text
connections_attempted
connections_established
surge_established
```

may be summed for campaign totals, but must never be interpreted as simultaneous one-run capacity.

Machine output should label them accordingly.

---

## 3.17 Contract resource-envelope contradictions remain

The contract now says the primary Nchan DUT has:

```text
4 CPU / 8 GB
```

and Compose matches 8 GB.

But other contract text still says things such as:

```text
ACCEPT nchan_memory_mb_peak < 3.5 GB
(below 4 GB limit)
```

and also says cross-node ACCEPT criteria apply to each Nchan node under:

```text
4 CPU / 4 GB
```

even though primary is now 8 GB.

Resolve exactly one frozen resource envelope for:

```text
primary DUT
replacement node
Redis
load generator
```

Then make:

```text
Compose
contract
parameter ledger
traceability matrix
classifier thresholds
host prerequisites
```

agree.

Do not change memory thresholds after observing final benchmark results.

If this is result-affecting, use a successor contract version rather than editing v2.0.2 again.

---

## 3.18 Contract timing text still does not match the implementation

The active contract still contains older timing prose for late join/reconnect inside steady measurement while the code now runs the repaired lifecycle:

```text
warmup 60%
steady
surge to 100%
stabilize
late join at peak
burst at peak
post-burst
reconnect
slow consumer
restart
```

Freeze one exact schedule and update the active successor contract accordingly.

Also reconcile the late-join timing definition.

The implementation starts timing before the connection attempt.

The contract still contains wording equivalent to:

```text
client connection open timestamp
```

Use one precise boundary everywhere.

---

## 3.19 Traceability still cannot be trusted as completion evidence

The repository traceability matrix is much more complete than before.

However it still claims all PASS while material executable gaps above remain.

Do not declare completion from the matrix.

Re-audit every affected row after fixing the code.

A row is PASS only when:

```text
implementation is real
focused test validates the actual behavior
metric producer is independent where required
evidence-suite path wires it
classifier/output interprets it correctly
```

Before 100%:

```text
0 false PASS rows
0 BLOCKED rows
0 unmapped normative requirements
```

---

# 4. Focused tests still required

Add/fix tests only for the remaining defects.

## Late join

```text
prefill uses canonical publisher state machine
normal publisher cannot interleave duplicate/overtaking seq
expected first/last independent of replay
frozen state snapshot comparison
missing prefix is detected
buffer + live margin sufficient
```

## 100k topology

```text
real multi-source/shard topology has >100k tuple capacity
cpu.max/cpuset parser correct
failed topology invalidates
Nginx FD headroom validated
```

## Reconnect

```text
cohort immediately removed from active counts on close
re-added exactly once
terminal reconnected stream removed
target head frozen at reconnect boundary
mode transitions back to live after catch-up
transport ID passed through
expected replay independent
```

## Surge

```text
sustained 120s ramp validity rule
dedicated phase histogram used directly
unexpected disconnect producer verified
```

## Workload

```text
match/lobby/total attempted+accepted counters
evidence-suite scheduler lag wiring
```

## Slow consumer

```text
offered and consumed are independently measured
per-client throttle interval/rate
real server-side backpressure proof
kernel-buffer-only -> INCONCLUSIVE
Nchan memory trend/recovery rule
unavailable memory -> INCONCLUSIVE
contract/classifier disconnect rule consistent
```

## Resources

```text
CPU normalization semantics
runner/Nchan/Redis effective quota
per-run cgroup deltas
evidence-suite Nchan/Redis CPU wiring
null mandatory metric remains null -> INCONCLUSIVE
```

## Restart

```text
campaign-only run does not invalidate normal repeated runs
campaign classifier requires restart PASS
literal expected range independent of replay
cross-node expected range independent
timeout before target fails
publisher outage canonical behavior
```

## Accounting

```text
live expected comes from accepted publish + eligible subscriber count
live received comes from frames
lost frame can produce expected > received
reconnect/restart expected independent
```

## Clock

```text
evidence-suite clock validity
shared-host topology proof or actual offset measurement
invalid clock -> INCONCLUSIVE
```

## Machine output

```text
all 8 match viewer counts
true total active
per-scenario active start/peak/end
exact source commit SHA non-null
campaign vs per-run counters labelled
```

## Evidence suite

```text
full parity with single-run metrics
phase histograms wired
mandatory null does not become 0
campaign-only restart semantics
```

---

# 5. Validation loop

Repeat until clean:

```text
PASS 1   typecheck
PASS 2   unit tests
PASS 3   clean Docker build
PASS 4   nginx -t
PASS 5   Redis/Nchan health
PASS 6   canonical deterministic prefill
PASS 7   late join
PASS 8   100k topology preflight
PASS 9   active reconnect lifecycle
PASS 10  exact surge + sustained-rate validation
PASS 11  live/replay accounting
PASS 12  literal restart
PASS 13  cross-node replacement
PASS 14  slow-client backpressure
PASS 15  resource evidence + run deltas
PASS 16  clock validity
PASS 17  classifier invalidity matrix
PASS 18  reduced/synthetic evidence-suite campaign
PASS 19  machine JSON validation
PASS 20  one-command smoke
PASS 21  fresh clean-checkout validation
PASS 22  traceability audit
PASS 23  adversarial final audit
```

If any pass fails:

```text
fix
rerun failed pass
rerun dependent passes
continue
```

Do not run the final Milestone 3 full 100k × 3–8 evidence campaign.

---

# 6. Completion gate

Milestone 2 is 100% only when all of the following are true:

```text
frozen contract integrity restored
active contract schedule/resource/timing semantics match implementation

late-join prefill uses real canonical publisher state
late-join expected range independent
late-join state comparison frozen at target
history capacity margin proven

real generator topology can attempt 100k simultaneously
topology CPU/FD/Nginx preflight correct

reconnect active lifecycle correct
reconnect expected range frozen
reconnect returns to live mode

surge sustained ramp validity defensible
surge phase histogram independent of rolling raw buffer

match/lobby/total workload rates explicit
evidence scheduler lag real

slow offered/read independently measured
slow pacing verified per client
server-side backpressure actually demonstrated
Nchan bounded-memory trend measured
slow semantics contract/classifier consistent

resource CPU normalization explicit
resource cgroup counters per-run deltas
mandatory resource null cannot become pass/zero

campaign-only restart semantics valid
literal/cross-node replay expected ranges independent
publisher outage behavior canonical-safe

clock validity applies to evidence suite

live expected independent from live received
replay expected independent from replay received

all terminal disconnects update active eligibility exactly once

all eight match viewer counts emitted
true active totals emitted
per-scenario active concurrency emitted
source commit identity non-null

evidence-suite metric parity complete
campaign totals cannot masquerade as per-run scale

traceability has no false PASS
0 BLOCKED
0 unmapped normative requirements
```

Only then:

```text
Milestone 2 completion: 100%
Milestone 2 status: DONE
Milestone 3 status: NEXT
```

---

# 7. Adversarial final audit

Before stopping, deliberately search for:

```text
frozen file edited in place
raw prefill bypassing match state
expected history derived from received first seq
state compared after target moved
single-source 100k topology
cpu.max read from cpu.stat
Nginx capacity without FD overhead
reconnect clients counted active while closed
reconnect mode never returning to live
missing transport ID on reconnect
peak-rate-only generator validity
surge histogram rebuilt from rolling raw slice
evidence scheduler lag left at zero
slow offered == slow read by construction
global slow-client timestamp spacing
normal memory increase called backpressure
arbitrary 100MB boundedness threshold
missing slow memory treated as bounded
zero slow disconnect accepted against contract
lifetime cgroup counter treated as run delta
Nchan/Redis CPU null converted to 0
campaign-only restart causing later runs INCONCLUSIVE
restart expected derived from received replay
restart target equal to pre-restart last seq
clock check missing from evidence mode
live expected incremented on receive
total_active_subscribers excluding 7 matches
git commit SHA null inside container
campaign totals presented as one-run concurrency
traceability PASS unsupported by actual evidence path
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
run final full-scale evidence campaign
run final 3–8 qualifying 100k repetitions
write proposal.md
write final README
create final ZIP
complete final cost model
deploy AWS
declare final production architecture conclusion
```

Next task after genuine completion:

```text
Milestone 3 — Run the Frozen POC and Produce Evidence
```

---

# 9. Final response when truly complete

Report:

## Completion

```text
Milestone 2 completion: 100%
Milestone 2 status: DONE
Milestone 3 status: NEXT
```

## Validation

Include:

```text
typecheck
unit tests
Docker clean build
nginx -t
one-command smoke
HARNESS_VALID / HARNESS_INVALID
truthful DUT smoke observation
machine-readable JSON validation
exit code
exact clean-checkout commit SHA
```

## Remaining-gap closure evidence

Include:

```text
active contract version
late-join independent expected/received range
late-join frozen-state comparison
history capacity margin
100k multi-source topology
Nginx/FD/cpu preflight
reconnect active lifecycle
surge sustained ramp evidence
workload match/lobby/total rates
publisher scheduler lag
slow per-client achieved rate
server-side backpressure proof
Nchan memory trend/recovery
Nchan/Redis/loadgen normalized CPU
per-run throttle/OOM deltas
campaign restart result
literal/cross-node expected-vs-received ranges
clock validity
live/replay independent accounting
disconnect attribution
all-channel viewer counts
source commit identity
evidence-suite parity
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
