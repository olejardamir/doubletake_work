# Milestone 2 — Close Remaining Gap to 100% — Remaining Work Only v6

Repository:

https://github.com/olejardamir/EA

Audited state:

```text
main = 64d0661cb607067f2b1dd59b25229c58a646f549
```

This file is a strict trim of the remaining Milestone 2 work. Completed items from v4 are removed rather than restated.

Current audit estimate:

```text
original Milestone 2 gap closed: ~89%
remaining gap:                  ~11%
overall Milestone 2 complete:   ~96%
```

Do not execute the final Milestone 3 evidence campaign.

Target:

```text
Milestone 1 = DONE
Milestone 2 = DONE — 100%
Milestone 3 = NEXT
```

---

# Remaining gaps

## 1. Build one coordinated 100,000-viewer experiment

`poc/compose.evidence-100k.yaml` currently provides four distinct source-IP runner containers, but each still runs an independent experiment:

```text
RUN_MODE=single
global coordinator not yet implemented
```

This is the largest remaining blocker.

Implement one experiment coordinator with:

```text
experiment_run_id
global run/seed
global target
unique shard IDs
phase barriers
global abort semantics
global result collection
```

All shards must participate in one shared lifecycle:

```text
preflight
warmup
60% steady population
coordinated surge
100% aggregate target barrier
stabilization
late join
burst
post-burst
reconnect
slow consumer
restart/replacement
final metrics
global verdict
```

No shard may advance phases independently.

Use one authoritative logical publisher workload. Four shard-local `MatchEventPublisher` instances must not multiply the frozen event workload.

Global active concurrency must be time-aligned:

```text
A_global(t) = sum(shard active_current at aligned t)
global_peak = max(A_global(t))
```

Require:

```text
global_peak >= 100000
```

Do not sum unrelated historical shard peaks.

Aggregate connection attempt/establishment/failure rates using aligned time buckets.

Merge actual shard histograms and recompute global p50/p95/p99/max. Do not average/max percentile values.

Global result must contain:

```text
experiment_run_id
participating shard IDs
global target
global active peak
global phase timings
global workload rates
global histograms
global correctness counters
per-shard generator validity
Nchan resources
Redis resources
scenario results
source commit
one global verdict
```

A 28k shard-local verdict is not a 100k verdict.

---

## 2. Add real per-shard source-port headroom

Current configuration uses roughly:

```text
4 × 28,000
```

A common Linux ephemeral range is only about 28,232 ports.

Freeze a safer allocation, for example approximately:

```text
4 × 25,000
```

if the actual host range supports it, or use more shards/source IPs.

Preflight must account for:

```text
viewer sockets
non-viewer outbound sockets
reconnect/TIME_WAIT allowance
explicit safety margin
```

Insufficient source-port headroom must invalidate the run.

---

## 3. Prove actual Nginx worker FD limits

Current preflight reads `/proc/self/limits` from the runner and/or Node control helper. That does not directly prove the Nginx workers' `RLIMIT_NOFILE`.

Read the actual Nginx master/worker process limits, e.g.:

```text
/proc/<nginx-pid>/limits
```

Report:

```text
nginx_master_fd_soft/hard
nginx_worker_fd_soft/hard
worker_processes
worker_connections
usable_sse_capacity
```

Fail preflight if actual Nginx worker capacity lacks target headroom.

Also remove runner-CPU-vs-Nginx-worker coupling. Validate:

```text
runner CPU -> generator
Nchan CPU  -> DUT
Redis CPU  -> Redis
```

separately.

---

## 4. Fix late-join expected-range semantics

Current late join now correctly validates schema, prefix, count, score, clock and head.

Remaining issue: the `/history/<match>` endpoint may return valid same-run history that existed before the deterministic 500-event prefill.

Current expectation is still essentially:

```text
expected = prefill first..last
```

while endpoint behavior can be:

```text
older retained history + prefill history
```

Freeze one valid interpretation:

```text
full retained active-match history
```

or use a deliberately isolated test channel whose entire history is independently known.

Before connection freeze:

```text
oldest_required_seq
target_head
expected_history_count
target score
target clock
```

Buffer proof must cover the actual required history depth:

```text
target_head - oldest_required_seq + 1
+ live-arrival margin
+ safety margin
```

Add a test where valid earlier same-match history exists before prefill.

---

## 5. Fix reconnect all-client success accounting

Current reconnect target timing and replay-range handling are improved.

Remaining false-PASS edge:

```text
allReconnectedCount
```

is incremented while iterating expected clients, not only successful reconnects.

Require:

```text
newSubscriptions.length == cohortSize
```

or an explicit per-client `subscription_reestablished`.

A client with:

```text
expectedCount = 0
received = 0
```

must not count as successfully reconnected unless the subscription was actually re-established.

Emit per client:

```text
connection_id
subscription_reestablished
saved_last_seq
expected_first_seq
expected_last_seq
expected_count
first_received_seq
received_required_count
missing
duplicates
out_of_order
target_reached
catch_up_ms
```

PASS requires every intended client to succeed.

---

## 6. Freeze surge validity and distinguish DUT failure from generator failure

The 120-second surge schedule itself is now implemented.

Remaining result-affecting rule:

```text
sustained establishment rate >= ~80% of required rate
```

is not frozen in v2.0.3.

Before Milestone 3, freeze the rule or remove the arbitrary tolerance.

Classification must distinguish:

```text
generator CPU/event-loop/backlog saturation -> INCONCLUSIVE
FD/source-port/host limit                   -> INCONCLUSIVE
network/environment invalid                 -> INCONCLUSIVE
healthy generator + valid environment +
Nchan cannot sustain target                 -> REJECT
```

Do not map all capacity failures to INCONCLUSIVE.

---

## 7. Repair slow-consumer evidence

Current code still explicitly has:

```text
offered == consumed by construction
```

because both counters come from the same callback.

Use an independent offered/expected source, such as accepted publisher events for the slow client's channel, or a true transport-side observable.

Measure independently:

```text
expected/offered
application consumed
missed/backlog during throttle
replayed/recovered
```

Current pacing gate of roughly:

```text
median interval >= 1000ms
```

is too weak for a target of:

```text
1 event / 2000ms
```

Freeze a real tolerance around the intended 2-second rate. If the throttle model is not achieved, return INCONCLUSIVE.

Create a dedicated immediately-before-slow healthy baseline. Do not reuse a global bounded latency buffer containing earlier phases.

Strengthen server-side backpressure attribution. Memory growth alone must not automatically prove slow-client backpressure unless isolated against a baseline or another direct server signal.

Freeze all result-affecting slow thresholds before Milestone 3, including current values around:

```text
memory growth %
memory growth MB
recovery delta
meaningful growth threshold
pacing tolerance
```

Make contract, scenario, classifier, tests and traceability agree on whether disconnects are mandatory or bounded server-side pressure is sufficient.

---

## 8. Make Nchan memory peak genuinely per-run

`memory.peak` is container-lifetime and the Nchan container is reused across qualifying runs.

Do not use a prior run's high-water mark as the current run peak.

Use one of:

```text
recreate/reset Nchan between qualifying runs
derive run peak from sampled memory.current
another resettable per-run metric
```

If useful, retain both fields with explicit names:

```text
nchan_memory_peak_run
nchan_memory_peak_container_lifetime
```

Classifier must use the intended run/campaign metric.

---

## 9. Finish service-specific CPU normalization

Separate Nchan/Redis quota fields exist, but normalization still uses the runner's `cpu.max` period as the common period.

Capture per service:

```text
cpu_max_quota
cpu_max_period
cpuset effective CPUs
```

Derive effective capacity independently for:

```text
runner shard
Nchan
Redis
```

and report both:

```text
raw % of one CPU
% of assigned service capacity
```

Respect cpuset when narrower than quota.

---

## 10. Construct deterministic non-empty restart/replacement replay ranges

Current restart/replacement checks are stricter, but expected ranges are often empty because the code effectively does:

```text
receive current head
expected first = last received + 1
read current head immediately
```

Create a deliberate non-empty range.

Literal restart:

```text
freeze resume cursor
publish/accept known events after cursor
freeze exact expected range
restart Nchan
resume from old cursor
require exact replay
```

Cross-node replacement:

```text
freeze cursor on node 1
publish/accept known events to shared Redis history
freeze exact range
connect node 2 with old cursor
require exact replay
```

PASS must explicitly require:

```text
received_required_count == expected_count
missing_required == 0
no missing prefix
no duplicates
no out-of-order
target reached
```

Emit full structured results for both literal restart and cross-node replacement, not only aggregate counts/detail strings.

---

## 11. Make terminal disconnect attribution exact-once

`removeEntry()` now guards actual pool removal, but the initial stream error handler increments the disconnect category before confirming first/only removal.

A repeated terminal event can still increment attribution more than once.

Add a terminal-state guard or make removal return whether it actually removed the entry.

Exactly one terminal connection must produce:

```text
one attribution category
one active removal
one dropped increment when applicable
```

Add a duplicate-terminal-event test.

---

## 12. Make source commit identity automatic and mandatory

Runner supports `GIT_COMMIT_SHA`, but Compose defaults can still produce null/unknown unless the operator exports it manually.

Provide a normal one-command launch that automatically injects:

```text
git rev-parse HEAD
```

Require:

```text
non-null valid SHA
matches checkout
same SHA on every shard
same SHA in global result
```

Unknown/null commit identity must make final evidence invalid.

---

## 13. Prevent shard-local 100k direct-accept claims

Current shard output can combine:

```text
local target × SHARD_TOTAL >= 100000
```

while checking only that shard's local active peak.

A single 28k shard must never claim global 100k direct eligibility.

Shard result:

```text
scope = shard
global_direct_accept_eligible = false
```

Only the global coordinator may set direct 100k eligibility after proving:

```text
aligned global active >= 100000
all shards valid
global workload valid
global timing valid
DUT/Redis evidence valid
required scenarios valid
```

---

## 14. Add active-population evidence for every peak-load scenario

Structured active population exists mainly for surge/reconnect.

Also record active population for:

```text
late join
burst
slow consumer
restart/replacement when peak-scale property is claimed
```

For coordinated multi-shard mode use:

```text
global active at start
global minimum
global peak
global active at end
```

A scenario must not silently pass a peak-load requirement if active population materially fell below the required level.

---

## 15. Add a real coordinated 100k entrypoint and cross-shard aggregation layer

Normal single-runner:

```text
compose.evidence.yaml -> RUN_MODE=evidence
```

is fixed.

`compose.evidence-100k.yaml` still has no global evidence-suite entrypoint.

After adding the coordinator, provide one command/path used by both:

```text
reduced Milestone 2 coordinator validation
final Milestone 3 100k campaign
```

with scale/duration/repetition controlled only by frozen configuration.

Keep cross-run aggregation and cross-shard aggregation separate:

```text
shard result
-> simultaneous global-run aggregate
-> repeated global runs
-> campaign aggregate
```

Required provenance:

```text
aggregate_scope
experiment_run_id
run_index
shard_id
shard_count
```

Do not reuse `aggregateRuns()` as if repeated runs and simultaneous shards were the same dimension.

---

## 16. Freeze the final contract and reconcile source-of-truth/traceability

Do not edit frozen v2.0.3 in place.

If remaining result-affecting changes are needed, create the minimal successor and freeze:

```text
multi-shard topology
per-shard target/headroom
global synchronization
publisher ownership
global aggregation
host resources
surge validity rule
slow-client pacing/backpressure/memory rules
late-join history semantics
restart/replacement deterministic range construction
```

Document:

```text
OLD
NEW
WHY
```

Then update the milestone source-of-truth so it clearly distinguishes:

```text
historical v2.0.2 freeze
v2.0.3 correction
final active contract for Milestone 3
```

Re-audit traceability.

PASS requires:

```text
requirement
-> implementation
-> focused test
-> metric producer
-> evidence-path wiring
-> classifier
-> machine-readable result
```

Before Milestone 2 completion:

```text
0 false PASS
0 BLOCKED
0 unmapped normative requirements
```

---

# Validation loop

Repeat until clean:

```text
1. typecheck
2. unit tests
3. clean Docker build
4. nginx -t
5. health checks

6. Nginx-worker RLIMIT test
7. per-shard port-headroom test
8. late-join full-range test
9. reconnect failed-client test
10. surge attribution tests
11. slow-client independent-measurement tests
12. per-run Nchan memory test
13. service CPU normalization tests
14. deterministic restart/replacement tests
15. disconnect exact-once test
16. source SHA test

17. reduced multi-shard coordinator test
18. global barrier test
19. one-publisher workload-rate test
20. aligned global concurrency test
21. cross-shard rate aggregation test
22. cross-shard histogram merge test
23. shared-resource aggregation test
24. global classifier test
25. coordinated evidence-entrypoint test

26. contract audit
27. traceability audit
28. clean-checkout smoke
29. adversarial audit
```

Do not run the final full-scale Milestone 3 campaign.

---

# Completion gate

Milestone 2 is 100% only when:

```text
one coordinated multi-shard experiment exists
one logical publisher workload exists
100k simultaneous active scale is measurable
global phase barriers work
per-shard source-port headroom is valid
actual Nginx worker FD limits are proven
late-join full-history semantics are valid
every reconnect client must truly reconnect
surge validity is frozen and attributed correctly
slow-consumer evidence is independent and frozen
Nchan peak memory is per-run
service CPU normalization is service-specific
restart/replacement ranges are deterministic and non-empty
disconnect attribution is exact-once
source SHA is automatic and mandatory
shard-local results cannot claim global success
peak-load scenarios report global active population
cross-shard and cross-run aggregation are distinct
final active contract matches executable machinery
traceability has no false PASS/BLOCKED/unmapped rows
```

Then and only then:

```text
Milestone 2 completion: 100%
Milestone 2 status: DONE
Milestone 3 status: NEXT
```

Do the work in the repository.
Do not stop below 100%.
