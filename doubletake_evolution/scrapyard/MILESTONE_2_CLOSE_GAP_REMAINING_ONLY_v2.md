# Milestone 2 — Close Remaining Gap to 100% — Remaining Work Only

Repository:

https://github.com/olejardamir/EA

Audited repository state:

```text
main = 4acac32b621c37cdf2e2a7e49b8af38460ebc95e
```

This is the updated continuation of:

```text
MILESTONE_2_CLOSE_GAP_100_PERCENT_PROMPT.md
```

All requirements that are demonstrably complete have been removed.

Only the remaining incomplete, partially implemented, contradictory, or insufficiently evidenced Milestone 2 work is listed below.

Do not redo completed work unless a regression proves it broken.

Work sequentially:

```text
inspect
-> identify highest-impact remaining gap
-> fix
-> focused tests
-> regression tests
-> recalculate completion
-> repeat
```

Stop only at genuine Milestone 2 completion.

Do not execute Milestone 3.

---

# 1. Objective

Milestone 2 must become:

> A complete, correct, locally runnable, reproducible Nchan + Redis OSS + SSE experiment harness with no known material implementation, measurement, orchestration, classification, reproducibility, traceability, or governance defect remaining.

Target state:

```text
Milestone 1 = DONE
Milestone 2 = DONE — 100%
Milestone 3 = NEXT
```

Milestone 2 validates the experiment harness. It does not require forcing a favorable final Nchan/Redis result.

---

# 2. Source-of-truth / frozen-contract integrity

Use this precedence:

1. assignment / `requirement.pdf`;
2. `internal_docs/AGENTS.md`;
3. `internal_docs/LIVE_MATCH_CENTRE_MINIMUM_DEFENSIBLE_ARCHITECTURE.md`;
4. active frozen POC experiment contract;
5. `internal_docs/LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md`;
6. current `poc/`.

A governance defect remains:

```text
LIVE_MATCH_CENTRE_POC_EXPERIMENT_CONTRACT_v2_0_2.md
```

was modified after being declared frozen.

If those changes are result-affecting, restore frozen-version discipline:

```text
preserve v2.0.2
create minimal successor, e.g. v2.0.3
document OLD / NEW / WHY
freeze successor
update milestone reference
```

Do not edit a frozen contract in place again.

The active contract must also be reconciled with current code for the remaining contradictions listed below.

---

# 3. Remaining implementation gaps

## 3.1 Late-join deterministic prefill is still invalid

A deterministic prefill implementation now exists, but it still bypasses the normal canonical publisher path.

Current defects to fix:

- prefill reaches into `ctx.publisher as any`;
- uses `@ts-ignore`;
- publishes directly through the underlying adapter;
- bypasses normal score/clock/head commit logic;
- can reuse the same `canonical_seq` across concurrent batch items;
- uses `event_type = "prefill"`, which is outside the frozen match-event schema;
- derives expected history partly from received history;
- does not compare reconstructed score/clock to the actual frozen committed publisher state.

Required end state:

```text
expected_first_seq frozen before connection
expected_last_seq frozen before connection
history_expected independently known
all prefill canonical sequences unique + contiguous
prefill uses valid publisher API/state machine
only frozen event schema used
score/clock/head snapshot frozen at target
replay reconstructed state == frozen committed state
missing/duplicate/out-of-order detected
catch_up_ms measured from before connection initiation
```

Also prove:

```text
buffer_capacity >= expected_history_depth + live_arrival_margin
```

so the test cannot evict its own required prefix during catch-up.

---

## 3.2 100k generator topology is still structurally incapable

A topology preflight now exists, but the evidence topology still effectively uses one source network namespace/address toward one subscriber destination tuple.

That does not provide enough TCP source-port tuples for 100,000 simultaneous connections.

Implement a real 100k-capable topology.

Freeze:

```text
viewer_count
connections_per_viewer
SSE_connection_count
generator_shard_count
source namespace/IP per shard
destination tuple(s)
target connections per shard
ephemeral-port capacity per shard
FD limit per shard
aggregate capacity
```

Prefer real generator containers/shards with distinct network namespaces/source IPs if needed.

The preflight itself also needs repair:

- parse Linux `/proc/sys/net/ipv4/ip_local_port_range` correctly;
- do not silently fall back after a parse defect;
- failed capacity preflight must invalidate evidence, not only log a warning.

If sharded:

```text
real barriers
per-shard CPU/memory/event-loop/backlog
per-shard active connections
per-shard socket/connect errors
time-aligned global concurrency
time-aligned connection-rate buckets
merged histograms, never averaged p95
```

---

## 3.3 Active-concurrency lifecycle is not fully wired in every path

The classifier now uses `active_connections_peak`; keep that.

Remaining work:

- ensure evidence-suite runs wire `active_connections_peak`, not a default zero;
- reconnected subscriptions must remove themselves from active/per-channel counts on terminal error/close;
- direct scenario disconnects must immediately remove live-delivery eligibility;
- audit all uses of `pool.size` and ensure it represents active streams only;
- emit `active_connections_current` plus per-scenario start/peak/end concurrency.

Cumulative reconnect establishments must never influence the 100k criterion.

---

## 3.4 Surge still has correctness gaps

The surge now uses absolute monotonic scheduling. Keep it.

Remaining problems:

- current pass rule still allows roughly 90% of requested additions;
- frozen target is 60% -> 100%, not 60% -> ~96%;
- batch peak rates use requested batch count rather than actual attempted/established deltas;
- generator saturation threshold is ad hoc rather than derived from +40% / 120s;
- surge p95 is still derived from a rolling recent-sample buffer slice.

Required:

```text
exact target population reached for PASS
environment/generator ceiling -> INCONCLUSIVE
actual attempts/establishments/failures per aligned bucket
derived required ramp rate
dedicated surge-phase histogram
unexpected disconnects during surge
```

---

## 3.5 Workload-rate and publisher scheduling measurements remain incomplete

The phase order has been repaired. Do not reorder again unless a new contradiction is proven.

Still required:

```text
match events attempted
match events accepted
lobby events attempted
lobby events accepted
total attempted
total accepted
match events/s
lobby events/s
total events/s
per-match accepted distribution
```

The evidence-suite path must record the same phase snapshots as the single-run path.

Also measure event-publisher scheduler lag.

Fix the current T0 bug:

`MatchEventPublisher` serializes the event body before POST completion, then mutates `event.publish_timestamp` after acceptance. That later mutation is not present in the already-sent JSON.

Freeze a timestamp boundary that can actually be transmitted and measure acceptance time separately.

Do not claim the subscriber received an acceptance-time timestamp if it did not.

---

## 3.6 Slow-consumer experiment remains invalid

Structured slow-consumer fields now exist, but the test still does not prove the frozen property.

Remaining defects:

- relies on `(subscription as any)._lastHandler`;
- fallback can be a no-op;
- offered/read counts are incremented at essentially the same callback boundary;
- achieved application read rate is not really 1 event / 2 seconds;
- no direct proof that server-side backpressure was reached;
- healthy p95 uses global latency data rather than an isolated healthy cohort;
- current boundedness logic does not measure Nchan memory before/during/after;
- finite client backlog is not proof of bounded Nchan memory.

Required:

```text
explicit supported transport throttling API
actual offered event/byte rate
actual application read event/byte rate
actual backlog growth
direct/rigorous server-side backpressure evidence
healthy-before dedicated histogram
healthy-during dedicated histogram
Nchan memory baseline
Nchan memory samples during slow phase
Nchan memory at slow end
Nchan memory after recovery
frozen boundedness rule
slow resume correctness if disconnected
```

Kernel-buffer-only absorption must be:

```text
INCONCLUSIVE
```

not PASS.

---

## 3.7 Slow-client contract/classifier contradiction remains

The active contract still simultaneously implies:

```text
slow_consumer_disconnects > 0 required for ACCEPT
slow_consumer_disconnects == 0 -> REJECT
slow_consumer_disconnects == 0 -> INCONCLUSIVE
```

The classifier also comments that no observed backpressure should be INCONCLUSIVE but currently allows the failed check to fall through to final REJECT.

Freeze one exact rule.

Recommended:

```text
server-side backpressure not reached
    -> INCONCLUSIVE

backpressure reached
+ bounded Nchan memory
+ healthy-client degradation within threshold
+ correctness intact
    -> PASS

backpressure reached
+ boundedness/healthy/correctness failure
    -> REJECT
```

If disconnect itself is intentionally mandatory, make that requirement consistent everywhere.

---

## 3.8 Resource evidence is still incomplete

Nchan cgroup metrics now exist. Keep them.

Still missing/incomplete:

```text
nchan_cpu_percent_peak
redis_cpu_percent_peak
redis_connected_clients_peak
quota-normalized loadgen CPU
per-run cgroup counter baselines/deltas
actual runtime resource-limit verification
```

Current cumulative values such as:

```text
cpu_usage_usec
nr_throttled
oom
oom_kill
memory.peak
```

must not be treated as run-specific without baselining.

Nchan control metrics are container-wide and include control-process overhead; report that correctly.

Mandatory unavailable evidence metrics must produce `INCONCLUSIVE`.

---

## 3.9 Classifier validity logic still needs closure

Keep the new active-concurrency, backlog, schema, resource-null, and disconnect checks.

Still fix:

- topology preflight failure must feed authoritative validity;
- negative latency / invalid timing must feed `INCONCLUSIVE`;
- latency overflow must not disappear;
- mandatory unavailable runtime signals may not be silently skipped;
- no-backpressure slow-client case must actually return `INCONCLUSIVE`;
- mandatory evidence scenario skip must return `INCONCLUSIVE`;
- distinguish generator/host/network ceiling from genuine Nchan capacity failure.

A generic connection-failure percentage is not enough to identify the responsible bottleneck.

---

## 3.10 Run isolation remains incomplete

Redis FLUSHALL now exists between evidence runs. Keep it.

Still required:

- reset before the first qualifying run too;
- flush failure must invalidate/abort rather than continue with stale-data risk;
- reset/rebaseline PRNG, publisher state, head state, metrics, subscriber counts, scheduler state, and resource counters;
- verify two sequential runs have no history/counter leakage.

---

## 3.11 Literal restart and cross-node replacement are still conflated by orchestration

Both implementations exist. Keep them.

Current evidence configuration includes `nchan-2`, and scenario selection chooses cross-node whenever `nchan-2` exists.

Therefore the literal restart path is not necessarily exercised despite the contract claiming process restart.

Freeze and implement explicit repetition policy:

```text
literal restart
cross-node replacement
per-run vs once-per-campaign
```

Also fix restart/replacement validation:

- expected replay range must be independently frozen;
- timeout after receiving "some events" cannot count as complete replay;
- restart expected count cannot be derived from received count;
- record publisher behavior and accepted canonical range during literal downtime.

---

## 3.12 Clock compatibility is still not measured correctly

Current code uses HTTP RTT / 2 as a "max skew estimate."

RTT is not wall-clock offset.

Replace this with valid clock compatibility evidence.

Record:

```text
method
samples
offset/uncertainty
threshold
pass/fail
```

If relying on same-host container shared-clock semantics, document and verify that fact correctly.

Clock invalidity must produce `INCONCLUSIVE`.

---

## 3.13 Live/replay accounting fields exist but producers remain wrong

Keep the new fields.

Fix their producers.

Current reconnect replay received uses global `events_received` while all other viewers remain active.

That is invalid.

Reconnect must derive per-client:

```text
expected first seq
expected last seq
expected count
received count
```

from each reconnecting client's saved canonical state and target match head.

Restart expected count must also be independent of received replay.

Ensure replay traffic cannot inflate live delivery accounting.

Required final separation:

```text
live_expected / live_received
late_join_expected / late_join_received
reconnect_expected / reconnect_received
restart_expected / restart_received
```

---

## 3.14 Disconnect attribution remains partial

New attribution counters exist.

Finish real production of each category:

```text
deliberate disconnect
unexpected client-side disconnect
server/Nchan initiated disconnect
network/connect failure
shutdown cleanup
```

Audit:

```text
end
close
aborted
error
connect failure
scenario deliberate close
final cleanup
```

Every terminal path must be attributed exactly once and must update active/per-channel eligibility immediately.

Do not keep attribution fields that are permanently zero because no path can produce them.

---

## 3.15 Machine-readable output still lacks complete evidence semantics

The JSON output has been expanded. Keep it.

Still add/fix:

```text
per-scenario active start/peak/end
all per-match viewer counts, not only match-001
match/lobby/total attempted + accepted rates
publisher scheduler lag
nchan_cpu_percent_peak
redis_cpu_percent_peak
redis_connected_clients_peak
per-shard generator metrics if sharded
real clock offset evidence
late/reconnect/restart canonical expected/received ranges
resource counter baselines/deltas
```

Fix misleading provenance logic:

```text
targetConnections >= 100000
```

alone does not make a run directly ACCEPT-eligible.

Eligibility requires actual target reached + valid environment + valid measurements.

---

## 3.16 Real schema validation is still missing

Counters now exist for schema errors, but `ConnectionPool.handleMessage` still effectively accepts any JSON containing numeric `canonical_seq`.

Implement a concise runtime parser/type guard for the frozen event payload.

Validate required fields before they influence metrics:

```text
match_id
canonical_seq
event_type
publish_timestamp
score
clock
```

Malformed application frames must:

```text
increment schema_validation_errors
not affect correctness/latency/state metrics
affect final validity/correctness
```

Ensure `missing_transport_id` also has a real producer where ID is required.

---

## 3.17 Critical unsafe type erasure remains

Do not refactor for style.

Remove unsafe type erasure only where it can invalidate the experiment.

Current examples include:

```text
ctx.publisher as any
@ts-ignore
subscription as any
let data: any
```

Fix experiment-critical boundaries:

```text
prefill publisher API
slow-consumer transport API
SSE/application payload parser
metrics/scenario interfaces where required
```

---

## 3.18 Evidence-scale logging still needs bounding

Evidence Nginx config still performs per-request access logging.

Disable or bound access logging in evidence mode.

Smoke/development logging may remain separately.

Do not let Docker/Nginx log I/O become the artificial bottleneck.

---

## 3.19 Build inputs are not fully immutable

Still close:

```text
Ubuntu base image identity
Node base image identity
Redis image identity
Nginx source SHA-256
Nchan source SHA-256
resolved image IDs/digests in evidence
```

Use HTTPS.

Keep `package-lock.json` / `npm ci`.

Correct traceability rows that describe component images/versions different from actual Dockerfiles.

---

## 3.20 Portable service addressing still needs verification

Do not assume `host.docker.internal` works on every Linux Docker Engine reviewer path.

Use Compose service DNS where appropriate.

Normal smoke must remain:

```text
one command
container runtime only
no host Node/npm/Redis/Nginx
no manual privileged sysctl
```

High-scale evidence-specific host prerequisites may be separate.

---

## 3.21 Nginx capacity preflight still overstates raw worker capacity

`worker_processes = 4` is now explicit. Keep it.

Still validate:

```text
effective Nginx RLIMIT_NOFILE
worker_connections headroom
listener/backlog constraints
Redis/upstream/control descriptors
non-viewer FD overhead
effective 4-CPU quota/cpuset
```

Do not treat:

```text
4 * 32768
```

as usable SSE capacity without descriptor/headroom validation.

---

## 3.22 Phase/cohort percentile isolation remains incomplete

Streaming histograms already exist. Keep them.

Still replace rolling-buffer slice calculations for:

```text
surge
healthy-before-slow
healthy-during-slow
other phase/cohort p95s
```

with dedicated histograms.

Freeze/report actual late-join/reconnect sample populations.

Do not overstate one observation as a robust p95 without explicitly freezing that interpretation.

---

## 3.23 Evidence-suite wiring remains materially incomplete

Audit `runSingleExperiment` independently from `main.ts`.

Still fix:

- phase snapshots/rates must be populated;
- active peak and all new detailed metrics must be wired;
- slow-consumer structured metrics must be wired;
- detailed surge metrics must be wired;
- disconnect/replay/schema fields must be wired;
- reset must occur before every qualifying run;
- restart marked "once per campaign" must actually run once, not inside every run;
- histogram pooling must not mutate run 1's histogram;
- summed cross-run connection counts must not masquerade as one-run concurrency.

Milestone 3 machinery is not ready until the evidence-suite path preserves all required single-run semantics.

---

## 3.24 Active contract still contains stale contradictions

Audit and correct the active contract for at least:

### Scenario schedule

Current contract still contains old fixed timing prose inconsistent with the repaired order:

```text
steady
surge
peak late join
peak burst
reconnect
slow
restart
```

Freeze one schedule.

### Slow-client semantics

Resolve Section 28/29/30 contradiction.

### Resource/host prerequisite

Contract contains a 14 CPU / 14 GB primary table plus auxiliary nchan-2 while actual evidence allocation is roughly 18 CPU / 18 GB; host prerequisite language must be unambiguous and sufficient.

### Late-join timing boundary

Use:

```text
immediately before connection initiation
```

not "after connection open."

If corrections are result-affecting, create a legitimate successor contract instead of editing frozen v2.0.2 again.

---

## 3.25 Traceability matrix currently overstates completion

`internal_docs/TRACEABILITY_MATRIX.md` now claims:

```text
0 BLOCKED
all PASS
```

while the executable gaps above still exist.

Correct existing rows rather than trusting the matrix.

A PASS row requires:

```text
working implementation
real test
real metric producer
correct classifier/output wiring
```

Before 100%:

```text
0 false PASS rows
0 BLOCKED rows
0 unmapped normative requirements
```

---

# 4. Required focused tests for the remaining work

Add/fix only these remaining tests.

## Late join

- no private publisher access;
- exact contiguous prefill seq range;
- frozen event schema only;
- expected range independent of received;
- real committed-state score/clock/head comparison;
- buffer + live margin proof.

## 100k topology

- Linux ephemeral-range parser;
- insufficient tuple capacity invalidates evidence;
- real shard topology >100k with headroom;
- FD/headroom validation.

## Active connections

- evidence-suite active peak wiring;
- reconnect terminal removal;
- direct disconnect eligibility boundary;
- current + peak metrics.

## Surge

- exact final target;
- actual batch deltas;
- derived required ramp rate;
- dedicated surge histogram;
- ceiling -> INCONCLUSIVE.

## Workload

- match/lobby/total attempted + accepted rates;
- phase snapshots in evidence suite;
- publisher scheduler lag;
- transmitted T0 boundary.

## Slow client

- explicit supported throttling;
- actual read rate;
- actual backlog;
- real server-side backpressure;
- kernel-buffer-only -> INCONCLUSIVE;
- dedicated healthy histograms;
- Nchan memory trend;
- slow resume correctness.

## Resources

- Nchan CPU percent;
- Redis CPU;
- Redis connected clients;
- loadgen quota normalization;
- run-delta cgroup counters;
- unavailable mandatory metric -> INCONCLUSIVE.

## Classifier

- failed topology preflight -> INCONCLUSIVE;
- negative timing -> INCONCLUSIVE;
- no slow backpressure -> INCONCLUSIVE;
- mandatory scenario skip -> INCONCLUSIVE;
- environment ceiling vs DUT failure distinction.

## Isolation

- reset run 1;
- reset failure invalidates;
- no cross-run Redis/counter state.

## Restart

- literal restart actually executed when required;
- cross-node separately identified;
- independently frozen replay range;
- timeout before target fails;
- outage publisher behavior valid.

## Accounting

- reconnect cohort-only received count;
- per-client expected replay;
- restart expected independent;
- replay cannot inflate live ratio.

## Schema / types

- malformed application payload;
- missing transport ID;
- no critical `as any`/`@ts-ignore` path.

## Evidence suite

- full metric parity with single-run path;
- once-per-campaign behavior;
- immutable pooled histograms;
- per-run concurrency not cross-run sum.

---

# 5. Validation loop

Run until clean:

```text
PASS 1   typecheck
PASS 2   unit tests
PASS 3   clean Docker build
PASS 4   nginx -t
PASS 5   Redis health
PASS 6   Nchan primary health
PASS 7   Nchan replacement health
PASS 8   publish -> SSE
PASS 9   deterministic valid prefill
PASS 10  late join
PASS 11  100k topology preflight
PASS 12  exact surge
PASS 13  reconnect accounting
PASS 14  literal restart
PASS 15  cross-node replacement
PASS 16  slow-client backpressure
PASS 17  resource evidence
PASS 18  classifier invalidity matrix
PASS 19  evidence-suite reduced/synthetic validation
PASS 20  machine JSON validation
PASS 21  one-command smoke
PASS 22  fresh clean-checkout validation
PASS 23  traceability audit
PASS 24  adversarial final audit
```

If any pass fails:

```text
fix
rerun failed pass
rerun dependent passes
continue
```

Do not run the final Milestone 3 100k × 3–8 campaign.

---

# 6. Completion gate

Milestone 2 is 100% only when all remaining items below pass.

```text
frozen-contract version integrity restored
active contract contradictions resolved
late-join prefill canonical and independently verifiable
history capacity + live margin proven
100k generator topology structurally capable
topology failure authoritative
active concurrency correct in evidence suite
surge reaches exact target
surge metrics use actual deltas
publisher rates/scheduler/T0 valid
slow client reaches real server backpressure
slow Nchan memory boundedness measured
slow contract/classifier semantics consistent
Nchan CPU real
Redis CPU real
Redis connected-client peak real
loadgen CPU quota-normalized
resource counters run-baselined
topology/timing/resource invalidity -> INCONCLUSIVE
reset before every qualifying run
reset failure invalidates
literal restart actually executed when claimed
cross-node claim separate
restart/reconnect expected ranges independent
clock compatibility valid
live/replay accounting correct
disconnect attribution complete
schema validation real
critical unsafe type erasure removed
evidence logging bounded
build identity immutable enough
portable one-command smoke works
Nginx FD/headroom validated
phase histograms isolated
evidence-suite metric parity complete
once-per-campaign logic real
traceability has no false PASS
0 BLOCKED
0 unmapped normative requirements
```

Only then update milestone status to:

```text
Milestone 2 — DONE — 100%
Milestone 3 — NEXT
```

---

# 7. Adversarial final audit

Before stopping, try to falsify completion.

Search specifically for:

```text
frozen contract edited in place
expected count derived from received count
duplicate prefill seq
non-schema prefill event
fake score/clock comparison
single-source 100k ceiling
broken ephemeral-port parsing
preflight warning not affecting verdict
90% surge accepted as 100%
requested batch count used as established count
rolling buffer used for phase p95
timestamp mutated after serialization
mock/private slow handler capture
offered/read measured at same boundary
client backlog mistaken for server backpressure
finite backlog mistaken for bounded Nchan memory
global events_received used as reconnect replay count
restart expected derived from received
timeout with some replay treated as complete
RTT called clock offset
cgroup lifetime counters treated as run deltas
mandatory resource metric skipped
evidence-suite field left default zero
"once per campaign" scenario executed every run
histogram pooling mutates source run
cross-run connection totals presented as concurrency
traceability PASS unsupported by executable behavior
```

Any material finding returns completion below 100%.

Continue the loop.

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

Next task after true completion:

```text
Milestone 3 — Run the Frozen POC and Produce Evidence
```

---

# 9. Final response when complete

Report:

## Completion

```text
Milestone 2 completion: 100%
Milestone 2 status: DONE
Milestone 3 status: NEXT
```

## Repository changes

- created;
- modified;
- removed.

## Validation

- typecheck;
- tests;
- clean Docker build;
- nginx config;
- one-command smoke;
- HARNESS_VALID / HARNESS_INVALID;
- truthful DUT smoke result;
- machine JSON validation;
- exit code;
- clean-checkout commit SHA.

## Remaining-gap closure evidence

Include:

```text
active contract version
late-join expected/received range
history margin
state reconstruction comparison
100k topology
FD/Nginx headroom
active concurrency peak
surge exact target/timing/rates
match/lobby/total rates
publisher scheduler lag
transmitted T0 rule
slow offered/read/backlog
server-side backpressure proof
Nchan memory trend
Nchan CPU
Redis CPU/memory/client peak
loadgen quota-normalized health
OOM/throttle run deltas
literal restart
cross-node result
clock compatibility
reconnect/restart expected-vs-received
disconnect attribution
schema errors
evidence-suite isolation/aggregation
build identities
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
