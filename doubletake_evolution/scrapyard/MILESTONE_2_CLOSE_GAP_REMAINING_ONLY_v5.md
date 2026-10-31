# Milestone 2 — Close Remaining Gap to 100% — Remaining Work Only v5

Repository:

https://github.com/olejardamir/EA

Repository state audited for this revision:

```text
main = 64d0661cb607067f2b1dd59b25229c58a646f549
```

This is the trimmed continuation of:

```text
MILESTONE_2_CLOSE_GAP_REMAINING_ONLY_v4.md
```

Only work that is still incomplete, partially correct, structurally unproven, or inconsistent with the actual evidence path remains below.

Do not redo work already closed in the repository.

Current weighted estimate from this audit:

```text
original Milestone 2 gap closed: ~89%
remaining gap:                  ~11%
overall Milestone 2 complete:   ~96%
```

The remaining work is disproportionately concentrated in the hardest part: making the new multi-source topology operate as **one synchronized 100,000-viewer experiment**, not four independent smaller experiments.

Work sequentially:

```text
inspect
-> fix highest-impact remaining defect
-> focused tests
-> regression tests
-> validate actual runnable evidence path
-> recalculate gap
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

Milestone 2 proves that the experiment machinery is valid.

It does **not** require forcing the DUT to produce an `ACCEPT`.

Correct semantics remain:

```text
valid experiment + DUT satisfies frozen criteria      -> ACCEPT
valid experiment + DUT violates frozen criteria       -> REJECT
generator/environment/measurement invalid             -> INCONCLUSIVE
```

---

# 2. Work already closed since v4 — do not redo

The following v4 items are now materially implemented and must not be recreated merely because they appeared in an earlier prompt.

## Late join

```text
canonical atomic per-match prefill API exists
normal publisher cannot interleave inside the prefill range
actual event clock schema is used for reconstruction
score reconstruction is a PASS gate
clock reconstruction is a PASS gate
head reconstruction is a PASS gate
received first sequence is compared to expected first
expected-vs-received count is a PASS gate
catch-up remains <=2s gated
```

## Reconnect

```text
target head is frozen after the disconnected publication window
cohort is removed from active counts during disconnect
reconnected entries are re-added
transport ID is passed through
reconnected terminal errors are categorized
mode returns to steady after catch-up
replay counting stops at the frozen target
active-before-disconnect is captured
```

## Surge

```text
absolute monotonic scheduling exists
full 120-second timeline wait exists
exact requested additions are required for PASS
actual attempt/establishment/failure deltas are used
required ramp rate is derived from target
surge phase histogram is isolated
connections_dropped now has a terminal-path producer
```

## Evidence / aggregation

```text
normal compose.evidence.yaml now sets RUN_MODE=evidence
runEvidenceSuite() is reached by the normal single-runner evidence profile
PhaseSnapshot type mismatch is repaired
publisher scheduler lag is wired in evidence runs
phase histograms are wired
campaign histogram pooling clones the first run
Nchan/Redis CPU fields are wired
cross-run null CPU preservation exists
Nchan/Redis memory campaign maxima are explicit
Redis connected-client campaign max is explicit
campaign aggregate_type/run_count exists
campaign-only restart gating exists
```

## Resources

```text
resource monitor has initial ready() polling
evidence suite awaits ready() before capturing baseline
runner cpu.max quota and period are exposed
Nchan/Redis CPU normalization has separate quota fields
per-run cgroup deltas exist
Nchan/Redis CPU mandatory-null handling exists
```

## Restart / recovery

```text
literal restart and cross-node replacement both execute when configured
fallback expectedCount=1 was removed
literal and cross-node replay counters are separated
missing-prefix checks exist
target-reached checks exist
structured RestartPathResult exists internally
```

## Machine evidence / governance

```text
all eight match subscriber counts are emitted
clock output now uses metrics.clock_validity
direct_accept_eligible now includes actual per-process active target
milestone file now marks Milestone 2 IN PROGRESS
milestone file identifies v2.0.3 as active contract for M2
traceability matrix has been substantially expanded
```

Do not reopen these items unless a focused test proves a regression.

---

# 3. Remaining gaps

## 3.1 Highest-priority blocker: four shards are still four independent experiments

Current:

```text
poc/compose.evidence-100k.yaml
```

now creates four genuine runner containers with distinct bridge-network source IPs.

That infrastructure is useful and should be kept.

However the file itself explicitly documents:

```text
global coordinator not yet implemented
```

and configures every shard as:

```text
RUN_MODE=single
```

Each shard independently instantiates its own:

```text
ConnectionPool
MatchEventPublisher
scenario sequence
timers
metrics
verdict
```

Therefore the current implementation does **not** yet prove:

```text
100,000 viewers simultaneously active
inside one experiment
under one workload
under one phase timeline
with one global verdict
```

This is the single largest remaining Milestone 2 gap.

### Required architecture

Turn the existing shard containers into workers of one experiment.

Implement an explicit coordinator or equivalent deterministic synchronization layer.

Freeze one:

```text
experiment_run_id
global seed/run index
global target viewer count
shard count
target allocation per shard
phase sequence
phase start barriers
phase completion barriers
global abort semantics
global result collection
```

Required shared lifecycle:

```text
preflight
-> warmup target reached
-> steady at aggregate ~60%
-> coordinated surge
-> aggregate 100% target barrier
-> stabilization
-> late join
-> burst
-> post-burst
-> reconnect
-> slow consumer
-> restart/replacement where scheduled
-> final metrics barrier
-> global classification
```

No phase may begin merely because one shard's local timer says it is time.

### One authoritative workload publisher

Current shard-local runners each instantiate `MatchEventPublisher`.

If four workers all publish, the assignment workload is multiplied by approximately four.

The global 100k experiment must preserve the frozen workload:

```text
one logical match-event stream
~10 events/s steady
~50 events/s burst
one lobby stream
one hot-match concentration model
```

Preferred design:

```text
one coordinator/publisher process owns publication
viewer shards own subscriber load
```

A different design is acceptable only if the **aggregate** publication rate remains exactly the frozen workload and canonical state has one owner.

Do not have four independent canonical publishers for the same match IDs.

### Global active concurrency

Do not prove 100k by adding historical per-shard peaks.

Collect time-aligned current values:

```text
A_i(t) = active connections on shard i at time t

A_global(t) = sum_i A_i(t)
```

Then derive:

```text
global_active_connections_peak = max_t A_global(t)
```

The evidence machinery must be able to demonstrate:

```text
global_active_connections_peak >= 100000
```

during one shared run.

### Global connection-rate measurements

For the surge, aggregate aligned time buckets:

```text
attempts[t]
established[t]
failures[t]
```

across shards.

Do not calculate:

```text
sum(per-shard peak establishment rates)
```

when those peaks occurred at different times.

### Global correctness counters

Aggregate appropriately:

```text
missing
duplicates
out_of_order
unexpected disconnects
network failures
schema errors
parse errors
invalid latency
```

but preserve per-shard provenance so a failing shard is identifiable.

### Global histograms

Merge compatible streaming histograms across shards and recompute:

```text
p50
p95
p99
max
sample_count
overflow_count
```

Do not:

```text
average shard p95s
take max shard p95 and label it global p95
sum percentile values
```

### Global resource validity

Collect per-shard generator health independently:

```text
CPU
memory
event-loop delay
pending connection backlog
FD headroom
ephemeral-port headroom
```

Then require every participating shard to be valid.

DUT and Redis metrics are global service metrics and should not be multiplied by shard count.

### Global verdict

Produce exactly one authoritative experiment result containing:

```text
global target
global active peak
global phase timings
global workload rates
global histograms
global correctness
global generator validity
DUT resources
Redis resources
scenario outcomes
contract version
source commit
participating shard IDs
verdict
```

A local 28k shard verdict is not the 100k verdict.

---

## 3.2 The current per-shard allocation has insufficient source-port safety margin

Current 100k compose uses:

```text
4 shards × 28,000 connections
```

A common Linux ephemeral range such as:

```text
32768-60999
```

contains about:

```text
28,232 ports
```

That leaves only a few hundred ports of theoretical margin per shard.

The experiment also needs other outbound sockets.

Do not depend on effectively consuming the whole source-port range.

Freeze a safer allocation/topology.

For an exact 100,000 target, one obvious valid allocation is approximately:

```text
4 × 25,000
```

if the host's actual ephemeral range supports it.

Or use additional shards/source IPs.

Required per shard:

```text
actual ephemeral range
required viewer sockets
non-viewer outbound sockets
TIME_WAIT / reconnect allowance
explicit safety margin
capacity_sufficient
```

The coordinator must refuse evidence mode if the configured allocation lacks headroom.

---

## 3.3 Nginx/FD preflight still does not prove the Nginx worker process limit

Current preflight has improved:

```text
Nchan control server now requires 4 CPU
usable Nginx capacity subtracts an overhead allowance
aggregate Nginx capacity can be checked against the aggregate target
nchan-2 is no longer treated as primary fan-out capacity
```

Keep those changes.

Remaining defect:

The control server reads:

```text
/proc/self/limits
```

from the Node helper process.

`topology-preflight.ts` reads `/proc/self/limits` from the runner.

Neither directly proves the live Nginx worker processes' `RLIMIT_NOFILE`.

The current comments incorrectly imply a cgroup guarantees the same process RLIMIT.

File-descriptor RLIMIT is a process limit, not a cgroup-wide FD limit.

### Required repair

Inspect the actual Nginx master/worker process limit.

For example, resolve Nginx PIDs and read:

```text
/proc/<nginx-pid>/limits
```

or use another direct runtime mechanism.

Report:

```text
nginx_master_fd_soft
nginx_master_fd_hard
nginx_worker_fd_soft
nginx_worker_fd_hard
worker_processes
worker_connections
usable_sse_capacity
```

Global evidence must fail preflight if the actual worker limits cannot support the target with headroom.

### Remove irrelevant runner-vs-Nginx CPU coupling

`topology-preflight.ts` still compares the runner container CPU quota to:

```text
nginx worker_processes
```

even though Nginx is in another container.

Do not use runner CPU quota as proof of Nginx CPU capacity.

Use:

```text
runner quota -> generator validity
Nchan quota -> DUT validity
```

separately.

---

## 3.4 Late join still defines the expected history range incorrectly relative to prior same-run history

The false-PASS paths from v4 were mostly repaired.

A different remaining problem is now clearer.

Late join happens after:

```text
warmup
steady
surge
stabilization
```

The tested match can therefore already have retained history before the 500-event deterministic prefill begins.

Current code freezes:

```text
expected_first_seq = prefillResult.firstSeq
expected_last_seq  = prefillResult.lastSeq
history_expected   = 500
```

but connects to:

```text
/history/<match>
```

which can return the match's older retained history as well.

Then current strict checks:

```text
received_first_seq == prefill first
historyEvents.length == 500
```

can fail simply because valid earlier same-run history is present.

That is not a valid late-join experiment definition.

### Freeze exactly what late join means

The assignment requirement is best represented as:

> a new client can obtain the full retained active-match state/history and become current within the limit.

Prefer the full retained range.

Before connection, independently freeze:

```text
oldest_required_seq
target_head
expected_history_count
target committed score
target committed clock
```

If the Nchan history endpoint exposes a known retained oldest boundary, use it.

Otherwise create an isolated match/history channel for the deterministic late-join test so the entire expected retained range is independently known.

Do not compare:

```text
prefill-only expectation
```

against:

```text
full endpoint history response
```

### Buffer proof must cover the real expected range

Current proof uses roughly:

```text
500 prefill events + 2 seconds live-arrival estimate
```

If older retained history is expected, include it:

```text
required_history_depth =
  target_head - oldest_required_seq + 1
```

Then:

```text
required_capacity =
  required_history_depth
  + live_arrival_margin
  + explicit safety margin
```

PASS must require:

```text
all required history received
no required prefix missing
no required sequence missing
state reconstructs exactly at target
catch_up <= 2s
capacity margin >= 0
```

Add a focused test where valid prefill begins after earlier same-match history exists.

---

## 3.5 Reconnect has a remaining all-clients-reconnected false-PASS edge

Most reconnect mechanics are now correct.

One bug remains in the final gate.

Current logic effectively does:

```text
for each perClientExpected:
    allReconnectedCount++
```

regardless of whether a new subscription was actually created.

Then:

```text
allClientsReconnected =
    allReconnectedCount === cohortSize
```

is tautologically true.

Use the actual successful reconnect set:

```text
newSubscriptions.length === cohortSize
```

or a per-client boolean.

### Zero-expected-count failure edge

A client that fails to reconnect can still have:

```text
expectedCount == 0
replayReceived == 0
```

and therefore appear to have reached its replay target.

Require separately:

```text
subscription_reestablished == true
target_reached == true
```

for every intended reconnect client.

A zero-event replay range does not prove reconnection succeeded.

### Per-client authoritative record

For every reconnect client emit:

```text
connection_id
match_id
subscription_reestablished
saved_last_seq
expected_first_seq
expected_last_seq
expected_count
first_received_seq
received_required_count
missing_required
duplicates
out_of_order
target_reached
catch_up_ms
```

PASS requires all intended clients to succeed independently.

---

## 3.6 Surge generator-validity threshold is still post-contract and result-affecting

The 120-second scheduling mechanics are now materially repaired.

Current surge code contains a validity threshold approximately equivalent to:

```text
sustained establishment rate >= 80% of required ramp rate
```

The `80%` tolerance is result-affecting and is not frozen in the active v2.0.3 contract.

Do not carry an unfrozen numerical tolerance into Milestone 3.

Choose before evidence:

```text
OLD
NEW
WHY
```

and freeze the rule in a successor contract if necessary.

Prefer a rule derived directly from the assignment requirement:

```text
required additions completed by the frozen deadline
```

plus independent generator health signals.

If a tolerance is genuinely needed to distinguish generator invalidity from DUT failure, justify it in advance.

### Separate DUT capacity failure from generator/environment failure

Current classifier logic remains too coarse around failed connection establishment.

Required attribution:

```text
generator CPU/event-loop/backlog saturated -> INCONCLUSIVE
source port / FD / host network exhausted   -> INCONCLUSIVE
network path invalid                         -> INCONCLUSIVE
healthy generator + valid environment +
Nchan cannot sustain target                  -> REJECT
```

Do not automatically turn every connection-capacity failure into environment `INCONCLUSIVE`.

Record enough evidence to make that distinction objectively.

---

## 3.7 Slow-consumer test still does not independently measure offered vs consumed work

Current code explicitly documents:

```text
offered == consumed by construction
```

and increments both counters from the same callback.

Therefore these fields:

```text
slow_offered_event_count
slow_application_read_count
slow_backlog_growth
```

do not independently measure an application backlog.

Do not describe them as independent offered-vs-consumed evidence.

### Choose a real observable slow boundary

Implement one of:

```text
transport/socket bytes/events made available
vs
application processing after throttle
```

or another valid independent boundary.

If Node's SSE abstraction cannot expose the transport-side offered event count while paused, use:

```text
expected offered events from the independent accepted publisher sequence
```

for each slow client/channel.

The expected value must not be generated by the same consumed callback.

Then calculate:

```text
expected/offered
application consumed
backlog/missed during throttle
recovered replay
```

independently.

### Per-client throttle tolerance is still too weak

Current PASS gate is effectively:

```text
median interval >= 1000ms
```

for a target of:

```text
1 event / 2000ms
```

That proves only "slower than 1 second", not the intended 2-second consumer model.

Freeze a defensible tolerance around 2 seconds, e.g. an interval/rate band established **before** final evidence.

If the client does not achieve the intended slow-consumer rate:

```text
INCONCLUSIVE
```

### Healthy-before baseline is not isolated

Current `healthyBeforeHist` is populated from the existing bounded global fan-out sample buffer.

That buffer can contain earlier phases.

Create a dedicated immediately-before-slow baseline window using only healthy clients.

Then compare:

```text
healthy cohort immediately before slow phase
vs
same healthy cohort during slow phase
```

### Server-side backpressure evidence remains indirect

Current rule uses:

```text
slow disconnect
OR
Nchan current-memory increase >1MB AND >5%
```

Memory growth is suggestive, but it is not automatically attributable to slow-subscriber buffering.

Strengthen attribution.

If no direct Nchan slow-buffer signal exists, compare a controlled baseline:

```text
same workload without slow cohort
vs
slow-cohort phase
```

or otherwise isolate the incremental server-memory behavior.

Kernel/socket absorption without demonstrated server pressure remains:

```text
INCONCLUSIVE
```

### Slow memory thresholds are unfrozen

Current code contains acceptance-affecting numbers approximately:

```text
growth <10%
growth <50MB
recovery delta <50MB
backpressure growth >1MB AND >5%
```

These must be frozen with rationale before Milestone 3.

### Contract semantics still need one rule

Make the active contract, scenario, classifier, tests, and traceability agree on whether:

```text
server disconnect is mandatory
or
independently proven bounded server-side backpressure is sufficient
```

Do not leave inherited disconnect semantics conflicting with the broader implementation.

---

## 3.8 Nchan per-run memory peak is still container-lifetime, not run-local

The repository now explicitly comments that:

```text
memory.peak is container-lifetime
```

That acknowledgement is correct.

But the evidence suite still reuses the Nchan container across repeated qualifying runs.

Therefore:

```text
nchan_memory_peak_bytes
nchan_memory_mb_peak
```

can reflect a previous run's high-water mark.

Do not call a container-lifetime maximum a per-run peak.

Choose one valid approach:

```text
A. recreate/reset the Nchan container between qualifying runs
B. sample memory.current frequently and derive a per-run observed peak
C. use another resettable runtime metric
```

Then keep both if useful:

```text
nchan_memory_peak_run
nchan_memory_peak_container_lifetime
```

with explicit semantics.

The frozen classifier must use the appropriate run-level or campaign-level metric intentionally.

---

## 3.9 Service CPU normalization still assumes the runner's cpu.max period for other services

Separate Nchan and Redis quota values now exist.

That is progress.

However evidence normalization currently derives one:

```text
cpuPeriod = runner cpu.max period
```

and uses it for:

```text
runner
Nchan
Redis
```

The Nchan and Redis service cgroups have their own `cpu.max` values.

The default period is commonly the same, but evidence should not assume that.

Capture per service:

```text
cpu_max_quota
cpu_max_period
cpuset effective CPUs
```

and derive:

```text
effective_cores =
  min(quota / period, cpuset_cpu_count)
```

where both restrictions apply.

Then report separately:

```text
raw_percent_of_one_cpu
percent_of_assigned_capacity
```

for:

```text
runner shard
Nchan
Redis
```

This becomes especially important once the global 100k coordinator aggregates generator validity across shards.

---

## 3.10 Restart/replacement range validation is stricter now, but the expected range is often empty by construction

The old false-PASS behavior was improved.

Current literal path does approximately:

```text
receive 3 events
lastSeq = most recently received
headAtRestart = current head immediately afterward
expectedFirst = lastSeq + 1

if headAtRestart < expectedFirst:
    FAIL invalid frozen range
```

The cross-node path has the same pattern.

In a normal healthy stream, `lastSeq` is often already equal to the current head.

That makes:

```text
expected range = empty
```

and the scenario can fail before actually testing recovery.

This is not a valid final experiment construction.

### Create a known non-empty recovery range independently

For literal restart:

```text
1. connect and freeze resume cursor
2. intentionally publish/accept a known set of events after that cursor
3. freeze expected first/last/count
4. stop/restart Nchan
5. reconnect using the old transport cursor
6. require exact replay of the known range
```

The events forming the frozen recovery range must be accepted **before** the process is stopped if the property being tested is persistence across restart.

For cross-node replacement:

```text
1. freeze cursor on node 1
2. publish/accept known canonical events to shared Redis history
3. freeze expected range
4. connect to node 2 with old cursor
5. require complete exact range
```

Do not rely on a race in which the normal publisher happens to advance between reading the cursor and reading the head.

### Keep the new strict checks

Retain:

```text
missing prefix
duplicate
out-of-order
target reached
no fallback count
```

and add explicit:

```text
received_required_count == expected_count
missing_required == 0
```

to the authoritative PASS result even if currently implied by other checks.

### Emit full structured path results

Current machine output mostly emits separated counts.

Emit the complete internal `RestartPathResult` for both:

```text
literal_restart
cross_node_replacement
```

including expected/received sequence boundaries and recovery time.

---

## 3.11 Initial connection terminal attribution is not exact-once

`ConnectionPool.removeEntry()` now guards pool removal and `connections_dropped` correctly.

But the initial subscription error handler currently:

```text
increments network/server/unexpected attribution
then calls removeEntry()
```

If the same subscription emits more than one terminal error notification, the attribution counter can increment multiple times even though removal occurs only once.

Required:

```text
attribute only if active entry removal succeeds
```

or add a per-entry terminal/closed guard.

Every terminal connection must produce exactly one category:

```text
deliberate
unexpected
server_initiated
network
shutdown_cleanup semantics
```

and exactly one active-membership removal.

Add a focused duplicate-terminal-event test.

---

## 3.12 Build/source commit identity is still optional in practice

The runner now:

```text
accepts GIT_COMMIT_SHA
rejects "unknown" as invalid
falls back to git rev-parse
```

The Docker image does not contain `.git`.

Compose currently uses substitutions such as:

```text
${GIT_COMMIT_SHA:-unknown}
${GIT_COMMIT_SHA:-}
```

Therefore if the operator does not manually export `GIT_COMMIT_SHA`, machine evidence can still contain:

```text
git_commit_sha = null
```

Milestone 2 must provide a normal one-command path that automatically records the exact source commit.

For example, a wrapper can:

```text
export GIT_COMMIT_SHA="$(git rev-parse HEAD)"
docker compose ...
```

and validate the SHA before launch.

Required:

```text
non-null SHA
matches source checkout
same SHA on all shards
same SHA in global result
```

A final evidence run with unknown/null source identity is invalid.

---

## 3.13 Per-shard direct-accept provenance can still overstate 100k eligibility

Current `direct_accept_eligible` can calculate aggregate configured scale using:

```text
config.targetConnections * SHARD_TOTAL
```

while only checking:

```text
this shard's active_connections_peak >= this shard's local target
```

A single 28k shard can therefore appear "direct 100k eligible" because `SHARD_TOTAL=4`, even though the global coordinator does not exist and simultaneous global activity was not observed.

Remove 100k direct eligibility from shard-local outputs.

Shard-local result should say something like:

```text
scope = generator_shard
global_direct_accept_eligible = false
```

Only the global coordinator may set:

```text
direct_accept_eligible = true
```

after proving:

```text
time-aligned global active >= 100000
all shards valid
global workload valid
global timing valid
DUT/Redis metrics valid
required scenarios valid
```

---

## 3.14 Per-scenario active population output remains incomplete

Structured active population is now strong for:

```text
surge
reconnect
```

but peak-load claims are also made for:

```text
late join
burst
slow consumer
restart/replacement
```

For every scenario whose semantics depend on running at the peak population, record:

```text
active_global_at_start
active_global_min
active_global_peak
active_global_at_end
```

For multi-shard operation, these must come from globally aligned shard snapshots.

The scenario should not silently PASS a peak-load requirement when active population fell materially below target.

---

## 3.15 Normal evidence entrypoint is fixed, but the coordinated 100k campaign entrypoint does not exist

Do not redo:

```text
compose.evidence.yaml -> RUN_MODE=evidence
```

That path is fixed.

The remaining problem is specific to:

```text
compose.evidence-100k.yaml
```

It intentionally keeps each shard:

```text
RUN_MODE=single
```

because a global campaign coordinator has not been built.

After implementing §3.1, provide one unambiguous command for the 100k campaign machinery.

Milestone 2 validation should use a reduced target/synthetic duration through the **same coordinator path**.

Milestone 3 will use the final full target and repetition count.

Do not create two divergent orchestration implementations.

---

## 3.16 Cross-run aggregation exists; cross-shard aggregation still does not

`aggregateRuns()` now has substantially better semantics for repeated runs inside one runner process.

Keep it.

It is not a simultaneous-shard aggregator.

Implement a distinct layer with distinct provenance:

```text
within_run_shard_result
-> simultaneous_shard_aggregate
-> repeated_global_run
-> campaign_aggregate
```

Do not confuse:

```text
sum across simultaneous shards
```

with:

```text
sum across repeated experiments
```

Required metadata:

```text
aggregate_scope:
  shard
  global_run
  campaign

run_index
shard_id
shard_count
experiment_run_id
```

### Cross-shard percentile merge

Export or transfer mergeable histogram state rather than only final percentile numbers.

The global coordinator must be able to reconstruct the global distribution.

### Cross-shard active time series

Transfer aligned active snapshots or another deterministic synchronization record sufficient to prove simultaneous global scale.

### Cross-shard resource semantics

Use:

```text
generator per-shard CPU/memory/event-loop -> must-all-valid / max where appropriate
Nchan resource -> one shared DUT measurement
Redis resource -> one shared service measurement
```

Do not sum shared service memory/CPU once per shard.

---

## 3.17 Active contract still does not freeze the final experiment that the code is trying to run

Active contract:

```text
LIVE_MATCH_CENTRE_POC_EXPERIMENT_CONTRACT_v2_0_3.md
```

must not be edited in place.

The remaining implementation introduces result-affecting behavior not fully frozen there.

Before Milestone 3, create the minimal successor if necessary.

Freeze at least:

### Multi-shard generator topology

```text
shard count
per-shard connection allocation
aggregate target
aggregate runner CPU
aggregate runner RAM
source IP/namespace model
source-port headroom
global synchronization method
publisher ownership
global aggregation method
host prerequisite
```

### Surge validity

```text
exact deadline semantics
generator-validity attribution rule
any numerical tolerance
```

### Slow consumer

```text
target achieved read interval/rate tolerance
server-side pressure proof
memory boundedness threshold/rationale
memory recovery rule
disconnect requirement or alternative
```

### Late join

```text
full-retained-history vs isolated deterministic range
oldest expected boundary
buffer-capacity semantics
```

### Restart/replacement

```text
how a non-empty independent expected replay range is created
literal restart property
cross-node replacement property
```

Use:

```text
OLD
NEW
WHY
```

for each result-affecting successor change.

Freeze the successor before Milestone 3.

---

## 3.18 Milestone source-of-truth still contains an internal contract-version inconsistency

The milestone file now correctly says in the Milestone 2 section:

```text
Active contract: v2.0.3
Status: IN PROGRESS
```

Keep that.

Earlier in Milestone 1 it still identifies:

```text
Artifact:
LIVE_MATCH_CENTRE_POC_EXPERIMENT_CONTRACT_v2_0_2.md
```

and describes v2.0.2 as the frozen completion artifact.

Once the final active successor contract is frozen, make the document unambiguous:

```text
historical M1 freeze: v2.0.2
current corrected active contract: v2.0.3 or successor
reason successor exists
which version Milestone 3 must execute
```

Do not erase historical provenance; clarify it.

---

## 3.19 Traceability still overstates the global 100k implementation

The current traceability matrix contains many real PASS rows.

Do not downgrade genuinely completed rows.

However rows describing the multi-shard 100k topology can still appear PASS based on:

```text
four containers exist
distinct bridge addresses exist
SHARD_TOTAL is declared
aggregate theoretical tuple capacity is calculated
```

That is not equivalent to:

```text
one synchronized 100k run implemented and validated
```

Re-audit all rows affected by §§3.1-3.18.

A PASS row requires the entire chain:

```text
normative requirement
-> real implementation
-> focused test
-> measurement producer
-> runnable evidence path
-> correct classification
-> machine-readable result
```

Before Milestone 2 is DONE:

```text
0 false PASS rows
0 BLOCKED rows
0 unmapped normative requirements
```

---

# 4. Required focused tests

Add only the tests needed for remaining work.

## Global 100k coordination

```text
all configured shard IDs are unique
all shards join the same experiment_run_id
all shards reach warmup barrier
surge cannot start early on one shard
100% phase cannot start until global target barrier
one logical publisher workload exists
aggregate event rate is not multiplied by shard count
global active current uses aligned snapshots
global active peak >= target in reduced deterministic test
global rate buckets merge correctly
global histograms merge correctly
shared Nchan metrics are not multiplied
shared Redis metrics are not multiplied
failed shard invalidates global run
```

Use a reduced connection target for Milestone 2 machinery validation.

Do not run final Milestone 3 scale yet.

## Source-port headroom

```text
configured per-shard target leaves frozen safety margin
non-viewer sockets included
insufficient port headroom -> preflight failure
```

## Nginx preflight

```text
actual Nginx worker RLIMIT read
runner RLIMIT cannot substitute for Nginx RLIMIT
Node control-helper RLIMIT cannot substitute for Nginx RLIMIT
actual Nchan CPU quota separate from runner CPU quota
```

## Late join

```text
earlier same-match history exists before deterministic prefill
full intended retained range succeeds
prefill-only expectation against older history is rejected as invalid configuration
buffer proof uses actual full required range
```

## Reconnect

```text
one client reconnect fails with expectedCount=0 -> scenario FAIL
newSubscriptions.length < cohortSize -> scenario FAIL
each intended client has explicit reestablished flag
```

## Surge

```text
frozen generator-validity rule has no hidden post-hoc threshold
healthy generator + DUT capacity failure -> REJECT
generator saturation -> INCONCLUSIVE
source-port/FD exhaustion -> INCONCLUSIVE
```

## Slow consumer

```text
offered/expected independent from consumed callback
achieved interval outside frozen 2s tolerance -> INCONCLUSIVE
dedicated immediately-before baseline used
kernel-only absorption -> INCONCLUSIVE
server-pressure signal attributable to slow cohort
bounded-memory rule frozen
```

## Resources

```text
runner quota/period independent
Nchan quota/period independent
Redis quota/period independent
cpuset narrower than quota is respected
Nchan run-peak does not inherit prior-run lifetime peak
```

## Restart

```text
known non-empty literal replay range created before restart
known non-empty cross-node range created before replacement
empty range -> scenario construction invalid
complete exact range required
structured literal result emitted
structured cross-node result emitted
```

## Disconnect attribution

```text
duplicate terminal event increments category once
duplicate terminal event increments connections_dropped once
active channel count decremented once
```

## Source identity

```text
normal one-command launch populates exact git SHA
invalid/unknown SHA -> evidence invalid
all shards report same SHA
global result reports same SHA
```

## Provenance

```text
28k shard cannot claim direct 100k eligibility
only global coordinator can produce direct 100k eligibility
global direct eligibility requires actual aligned active target
```

## Contract / traceability

```text
final active contract explicitly named
all result-affecting thresholds frozen
all global coordinator requirements mapped
no traceability PASS without executable global proof
```

---

# 5. Validation loop

Repeat until all passes are clean:

```text
PASS 1   clean-checkout typecheck
PASS 2   unit tests
PASS 3   clean Docker build
PASS 4   nginx -t
PASS 5   Redis/Nchan health

PASS 6   Nginx worker RLIMIT preflight
PASS 7   per-shard source-port headroom preflight
PASS 8   late-join full-range test
PASS 9   reconnect all-client edge tests
PASS 10  restart non-empty-range tests
PASS 11  disconnect exact-once tests
PASS 12  slow-client independent-measurement tests
PASS 13  service-specific resource normalization tests

PASS 14  reduced multi-shard coordinator startup
PASS 15  reduced global phase-barrier test
PASS 16  reduced one-publisher workload-rate test
PASS 17  reduced global active-concurrency test
PASS 18  reduced cross-shard rate aggregation test
PASS 19  reduced cross-shard histogram merge test
PASS 20  reduced shared-resource aggregation test
PASS 21  reduced global classifier test

PASS 22  normal single-runner evidence-suite regression
PASS 23  source SHA provenance validation
PASS 24  machine-readable global-result validation
PASS 25  contract/source-of-truth audit
PASS 26  traceability audit
PASS 27  fresh clean-checkout one-command smoke
PASS 28  adversarial final audit
```

If any pass fails:

```text
fix
rerun failed pass
rerun dependent passes
continue
```

Do **not** run the final full 100k × 3–8 qualifying Milestone 3 campaign.

---

# 6. Milestone 2 completion gate

Milestone 2 is 100% only when all of these are true.

## Global scale machinery

```text
real multi-source topology exists
per-shard port headroom is defensible
one experiment coordinator exists
one logical workload publisher exists
global phase barriers exist
global active concurrency is time-aligned
global 100k target can be proven by the machinery
cross-shard connection rates are aligned
cross-shard histograms are mergeable
one global run verdict exists
```

## Nginx / generator validity

```text
actual Nginx worker RLIMIT proven
Nginx capacity includes overhead/headroom
runner CPU validation is separate from Nchan CPU validation
generator failure vs DUT failure is classifiable
```

## Late join

```text
expected retained range matches actual endpoint semantics
older same-run history cannot invalidate a correct test
buffer proof covers actual full required history
state reconstruction exact
```

## Reconnect

```text
every intended client must actually reconnect
zero-expected replay cannot hide reconnect failure
per-client expected/received result authoritative
```

## Surge

```text
generator-validity rule frozen
no result-affecting unfrozen tolerance
DUT capacity failure can be REJECT rather than automatically INCONCLUSIVE
```

## Slow consumer

```text
offered/expected work is independent from consumed callback
target slow rate is genuinely achieved within frozen tolerance
healthy-before baseline isolated
server-side pressure is defensibly attributed
bounded-memory rule frozen
contract semantics agree
```

## Resources

```text
runner/Nchan/Redis quota + period/cpuset are service-specific
per-run Nchan memory peak is genuinely per-run
shared service metrics not multiplied across shards
global generator validity requires every shard valid
```

## Restart / replacement

```text
literal expected range deliberately non-empty
cross-node expected range deliberately non-empty
exact range coverage required
structured result for each path emitted
```

## Disconnects

```text
one terminal event -> one attribution
one terminal event -> one active removal
one unexpected drop -> one dropped count
```

## Provenance

```text
normal command automatically records exact commit SHA
all shards use same SHA
shard-local output cannot claim global 100k success
only global result can mark direct 100k eligibility
```

## Contract / documentation

```text
active frozen contract matches executable final machinery
milestone source of truth identifies the active version unambiguously
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

Before declaring 100%, deliberately search for:

```text
four 28k runners still operating independently
each shard still creates its own canonical publisher
no experiment_run_id
no global phase barrier
sum of unrelated shard peaks called 100k concurrency
sum/max/average of p95s called a merged histogram
shared Nchan metrics counted four times
shared Redis metrics counted four times

28k shard too close to ephemeral-port ceiling
TIME_WAIT/non-viewer sockets ignored

runner /proc/self/limits called Nginx worker limit
Node control helper /proc/self/limits called Nginx worker limit
runner CPU quota compared to Nginx workers

late join expects only prefill while endpoint returns older history
late-join capacity ignores older retained history

reconnect success count increments without actual reconnect
expectedCount=0 hides failed reconnect

80% surge tolerance still unfrozen
healthy generator DUT failure still forced to INCONCLUSIVE

slow offered == consumed from same callback
2-second throttle passes at only >=1 second
healthy-before sample includes earlier phases
memory growth called backpressure without attribution
slow thresholds absent from active contract

Nchan memory.peak from prior run used as current-run peak
runner cpu.max period used for Nchan/Redis without proof
cpuset ignored

literal restart expected range commonly empty
cross-node expected range commonly empty
restart success depends on timing race

duplicate terminal error increments attribution twice

GIT_COMMIT_SHA null unless manually exported
one shard uses SHARD_TOTAL to claim 100k direct eligibility
only surge/reconnect expose active population

cross-run aggregator mistaken for cross-shard aggregator
multi-shard RUN_MODE=single has no coordinator replacement

v2.0.3 edited in place after freeze
active thresholds not frozen
traceability multi-shard row PASS based only on Compose file existence
```

Any material finding means:

```text
Milestone 2 < 100%
continue
```

---

# 8. Do not start Milestone 3

Do not yet:

```text
run final full-scale 100,000-viewer evidence campaign
run final 3–8 qualifying global repetitions
use resulting measurements as submission evidence
write final production conclusion
write proposal.md
write final README.md
create final submission ZIP
complete final cost conclusion
deploy AWS
```

Reduced/synthetic coordinator validation is part of Milestone 2 and is allowed.

The next milestone after genuine completion is:

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

## Exact repository state

```text
commit SHA
clean worktree
active frozen contract version
```

## Validation

```text
typecheck
unit tests
Docker build
nginx -t
health checks
Nginx worker RLIMIT preflight
source-port headroom preflight

late-join full-range reduced test
reconnect all-client reduced test
restart/replacement reduced test
slow-consumer reduced test
resource normalization tests

reduced coordinated multi-shard test
global barrier test
global publisher-rate test
global active concurrency test
global histogram merge test
global classifier test

single-runner evidence-suite regression
machine JSON validation
source SHA validation
traceability audit
fresh-checkout smoke
```

## Global coordinator proof

Include:

```text
experiment_run_id
shard IDs
source IPs
target per shard
aggregate target
phase synchronization
publisher ownership
aggregate active calculation
aggregate rate calculation
histogram merge method
shared-resource collection method
global classification method
```

## Remaining blockers

Must be:

```text
NONE
```

if claiming 100%.

Do the work in the repository.
Do not stop below 100%.
