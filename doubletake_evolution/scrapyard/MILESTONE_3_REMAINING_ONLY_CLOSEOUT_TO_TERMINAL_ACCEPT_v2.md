# MILESTONE 3 — REMAINING-ONLY CLOSEOUT TO TERMINAL ACCEPT

**Repository:** `https://github.com/olejardamir/EA`  
**Milestone:** Milestone 3 only.  
**Do not create:** M3b, M3.5, a side experiment, a substitute milestone, or a new research branch.  
**Audited live `main` baseline when this instruction was written:** `9774c2c5ee94cda52fb259058ae37ed13431c74d`  
**Latest audited commit:** `fix(m3): stabilize reconnect cohort hold for 64 exactness at 100k`

**Objective:** close only the remaining Milestone 3 gaps, run the final non-qualifying scale/prequalification path, freeze the qualifying source, execute one fresh exact 3-run campaign under precommitted criteria, preserve immutable evidence, independently audit the verdict, and stop only when M3 is genuinely `DONE — ACCEPT`.

This prompt supersedes the earlier broad M3 closeout prompt for **future work only**. Historical prompts/evidence remain preserved.

---

# 0. FIRST ACTION — LIVE-SYNC AND REMOVE ONLY GENUINELY CLOSED WORK

Before changing code:

1. fetch current `main`;
2. record the actual HEAD;
3. compare it with `9774c2c5ee94cda52fb259058ae37ed13431c74d`;
4. inspect every newer commit;
5. if a remaining item in this prompt has already been fully fixed, tested, machine-gated, and committed, mark that item `CLOSED` and do not redo it;
6. if an item is only partially fixed, keep only its remaining sub-gap;
7. if a newer commit introduces a regression, add the regression to the active gap register.

Do **not** reset/revert legitimate progress simply to match this prompt.

Do **not** treat a commit message as proof. Inspect code/tests/evidence.

---

# 1. CURRENT M3 STATE — PRESERVE THESE COMPLETED ITEMS

At the audited baseline, the following are already substantially or fully closed and must **not** be reimplemented unless live code has regressed.

## C01 — v2.3.0 active contract exists

Current active contract:

```text
poc/internal_docs/EXPERIMENT_CONTRACT_v2_3_0.md
ACTIVE_CONTRACT_VERSION = v2.3.0
```

TypeScript and Go already use v2.3.0. Do not return to v2.2.0.

## C02 — historical v2.2.0 campaign is explicitly non-terminal

Current repository includes:

```text
poc/internal_docs/M3_HISTORICAL_V2_2_0_DISPOSITION.md
```

Keep it. Do not reinterpret or rewrite the old post-hoc-0.80 campaign.

## C03 — CV threshold restored to 0.15

Current campaign code uses:

```text
DISPERSION_THRESHOLD_CV = 0.15
```

Keep sample standard deviation (`n-1`) / absolute mean and threshold `<=0.15`. Never raise it after new evidence exists.

## C04 — campaign aggregation requires exactly 3 runs

Keep the exact-three aggregation rule. A remaining launcher/base-seed hardening gap is listed later.

## C05 — late-join run cardinality is 256

Current global-run logic requires:

```text
64 late-join samples/shard
256 samples/global run
```

Keep this. A remaining campaign exact-768 check is listed later.

## C06 — slow-consumer removed from active v2.3 qualifying phases

Current active sequence:

```text
preflight
warmup
steady
surge
target-barrier
stabilization
late-join
burst
post-burst
reconnect
restart-replacement
final-metrics
```

Keep it exact. Historical slow-consumer code may remain historical only.

## C07 — lightweight canonical continuity is implemented

Preserve:

```text
canonical_seq -> gap / duplicate / out-of-order correctness
raw SSE id    -> Last-Event-ID resume token
```

Do not revert to Nchan transport-id arithmetic for application correctness.

## C08 — expanded correctness counter family exists

Preserve explicit counters including:

```text
missing_transport_id
missing_canonical_seq
canonical_seq_parse_errors
schema_validation_errors
json_parse_errors
invalid_timestamp_count
state_violations
canonical_payload_state_violations
lobby_malformed
```

A remaining mandatory-field/missing-as-zero gap is listed later.

## C09 — p95 latency gates are wired in global classification

Keep:

```text
fan_out_p95 <= 500 ms
surge_p95 <= 500 ms
burst_p95 <= 1000 ms
late_join_p95 <= 2000 ms
```

Remaining histogram-presence/full-target-provenance gaps are listed later.

## C10 — dedicated surge latency histogram exists

Keep:

```text
surgeHist
BeginSurgeWindow()
EndSurgeWindow()
SurgeHistogram()
```

Remaining surge population/deadline/correctness machine proof is listed later.

## C11 — reconnect exactness target is 64/shard

Current implementation uses:

```text
reconnectPerShard = 64
```

Keep the latest readiness work. Remaining exact denominator/raw-token gaps are listed later.

## C12 — Nchan memory/OOM global gates have begun to be wired

Keep the current memory/OOM gate work. Remaining workload-time resource coverage, spare evidence, throttling deltas, and null handling are listed later.

---

# 2. ASSIGNMENT-MAPPED SURGE — DO NOT CHANGE IT

The assignment-synced POC mapping is:

```text
pre-surge population = 60,000
surge additions       = 40,000
surge duration        <= 120 seconds
post-surge population = 100,000
```

Per shard:

```text
pre-surge = 15,000
additions = 10,000
post-surge = 25,000
```

Do **not** change this to 100k -> 140k. Do not reduce it.

The final full-target scenarios run after the surge at 100k.

---

# 3. MINIMAL ACTIVE-CONTRACT CLEANUP BEFORE TERMINAL QUALIFICATION

The current v2.3.0 text contains imprecise/self-correcting surge-batch arithmetic. A terminal frozen contract must not contain unresolved arithmetic commentary.

Because no fresh terminal v2.3 campaign was preserved in GitHub at the audited baseline, correct this before terminal qualification.

Preferred governance:

```text
create minimal successor v2.3.1
preserve v2.3.0 unchanged as historical development contract
```

If live `main` already uses a newer contract, use the next unused version.

Do not change assignment targets or favorable/unfavorable thresholds. This successor only clarifies/finalizes executable measurement semantics.

## Exact deterministic surge schedule

24 launch deadlines:

```text
t = 0, 5, 10, ... 115 seconds
```

Each shard adds exactly 10,000 viewers total.

One exact integer schedule:

```text
first 16 batches/shard: 417 viewers
last 8 batches/shard:   416 viewers
```

Check:

```text
16*417 + 8*416 = 10,000/shard
4 shards = 40,000 global
```

All 40,000 must be **established**, not merely attempted, by elapsed `<=120000 ms`.

If current code already has an equivalent exact integer schedule, freeze/document that exact schedule instead of creating a second implementation.

---

# 4. R01 — REMOVE FABRICATED Last-Event-ID FALLBACK

Current Go reconnect hold still contains behavior equivalent to:

```go
if raw == "" {
    raw = strconv.FormatUint(canon, 10)
}
```

This is invalid. `canonical_seq` is not the Nchan transport resume token.

## Required closure

For each reconnect client:

```text
lastRawID = real nonempty SSE id observed on wire
lastCanon = real canonical_seq observed in data
```

If raw transport ID is unavailable:

```text
do not synthesize it
do not treat client as resume-ready
record explicit failure/incomplete evidence
prevent ACCEPT
```

Reconnect request sends exactly:

```text
Last-Event-ID: <raw observed transport token>
```

Required-range evaluation continues to use canonical application sequence numbers.

## Tests

```text
opaque raw id preserved byte-for-byte
canonical_seq differs from raw id -> reconnect still correct
missing raw id -> reconnect cannot pass
missing raw id never replaced by canonical sequence
```

---

# 5. R02 — RECONNECT DENOMINATOR MUST BE EXACT AND NON-SHRINKING

Current structured reconnect evidence contains `released/evaluated/passed`, but the shard scenario can still pass from the returned-result denominator.

## Required per-shard evidence

```text
selected = 64
ready_before_hold = 64
released = 64
evaluated = 64
passed = 64
failed = 0
missing_results = 0
missing_required = 0
duplicates = 0
out_of_order = 0
```

Global:

```text
selected = 256
ready_before_hold = 256
released = 256
evaluated = 256
passed = 256
failed = 0
missing_results = 0
```

## Rules

- every frozen reconnect client is selected before the phase;
- all 64/shard must have valid raw resume state before hold;
- readiness wait returns explicit success/failure;
- readiness timeout cannot silently continue;
- every released client produces one result;
- empty capture = failed result;
- missing result = explicit failure;
- no denominator shrink;
- missing structured reconnect fields -> `INCONCLUSIVE`;
- exact global 256/256/256/256 required.

## Tests

```text
selected64 ready63 -> non-ACCEPT
released64 evaluated63 -> non-ACCEPT
evaluated64 passed63 -> REJECT if measurement valid
missing structured selected -> INCONCLUSIVE
one missing result -> non-ACCEPT
```

---

# 6. R03 — RESTART TOP-LEVEL COUNTERS MUST BE MEASURED

Current result assembly still emits literal restart correctness zeros.

## Required closure

Before restart/failover:

```text
restart_before = correctness snapshot
```

After recovery:

```text
restart_after = correctness snapshot
restart_delta = restart_after - restart_before
```

Populate top-level:

```text
restart_failover_gaps
restart_failover_duplicates
restart_failover_order_violations
restart_failover_connection_failures
restart_failover_unexpected_disconnects
```

Structured restart evidence carries the same measured pool deltas.

Global classifier cross-checks:

```text
top-level restart counters == structured restart pool counters
```

Mismatch -> `INCONCLUSIVE`.

Nonzero gap/duplicate/order with valid measurement -> `REJECT`.

No literal zero placeholders.

## Tests

Inject one gap/duplicate/order error and prove it reaches shard -> global -> verdict.

---

# 7. R04 — SURGE POPULATION/DEADLINE MUST BE MACHINE-PROVEN

Current implementation builds the 15k/shard baseline and adds 10k/shard, but global classification needs direct proof.

## Required fields

Per shard and global:

```text
surge_start_active
surge_attempted_additions
surge_established_additions
surge_failed_additions
surge_elapsed_ms
surge_final_active
surge_peak_active
```

## Exact global gates

```text
surge_start_active == 60000
surge_attempted_additions == 40000
surge_established_additions == 40000
surge_failed_additions == 0
surge_elapsed_ms <= 120000
surge_final_active >= 100000
```

Connections established after deadline do not count.

Each shard reaches 25,000 final ownership.

`global_active_peak >=100000` alone is not enough.

Healthy generator/environment + insufficient establishment -> `REJECT`.

Invalid generator/environment/measurement -> `INCONCLUSIVE`.

## Tests

```text
39999 established -> REJECT
40000 at 120000ms -> PASS
40000 at 120001ms -> REJECT
start59999 -> REJECT
final99999 -> REJECT
one shard<25000 -> REJECT
```

---

# 8. R05 — SURGE CORRECTNESS DELTAS MUST BE REAL

Use a true surge-window snapshot.

At start:

```text
surge_before = correctness + unexpected-disconnect snapshot
BeginSurgeWindow()
```

At end/deadline:

```text
EndSurgeWindow()
surge_after
surge_delta = surge_after - surge_before
```

Populate:

```text
surge_missing_sequences
surge_duplicates
surge_out_of_order
surge_unexpected_disconnects
```

Do not copy lifetime totals.

All must equal zero for `ACCEPT`.

Surge latency uses only the pre-existing deep cohort during the surge.

---

# 9. R06 — REQUIRED HISTOGRAMS MUST BE NONEMPTY AND PHASE-CORRECT

Terminal histogram set:

```text
full_target_fan_out
goal_fan_out
other_fan_out
surge_fan_out
burst
late_join
```

Every required distribution:

```text
count > 0
overflow_count valid
buckets valid
```

Empty required histogram -> `INCONCLUSIVE`.

`fan_out_p95 <=500ms` must represent **post-surge 100k full-target traffic**, not mixed 60k/surge/100k samples.

Preserve the recent full-target isolation work and add a regression proving lower-load samples cannot dilute the gate.

Surge remains separate. Burst remains separate.

---

# 10. R07 — QUALIFYING LAUNCHER MUST FREEZE BASE SEED 42

Campaign aggregation is exactly three runs, but the launcher still accepts arbitrary integer `BASE_GLOBAL_SEED`.

Terminal launcher requires:

```text
GLOBAL_RUNS = 3
BASE_GLOBAL_SEED = 42
```

Therefore:

```text
run0 seed42
run1 seed43
run2 seed44
```

Reject other base seeds in qualifying mode.

Development probes may have separate non-qualifying seed behavior only if incapable of producing terminal campaign evidence.

---

# 11. R08 — CAMPAIGN LATE-JOIN CARDINALITY MUST BE EXACTLY 768

Per-run global logic already requires 256.

Campaign independently requires:

```text
late_join count == 768 exactly
```

767 or 769 -> invalid campaign evidence.

Do not use a weak `>= runs*shardCount` check.

---

# 12. R09 — GENERATOR RUNTIME VALIDITY MUST BE REAL

Current generator validity is still too close to “preflight had no reasons”. The old microbenchmark is not terminal runtime evidence.

## Per-shard runtime evidence

```text
cgroup_cpu_usage_start/end/delta
assigned_cpu_cores
normalized_cpu_peak_or_windowed_max
cpu_throttled_count_start/end/delta
cpu_throttled_usec_delta
memory_current
memory_peak
oom_events_start/end/delta
oom_kill_start/end/delta
scheduler_lag_p50/p95/p99/max
goroutine_count_peak
gc_cycles
gc_pause_total
source_port_range
source_port_headroom
fd_soft
fd_hard
```

## Frozen validity gates

```text
normalized CPU < 90%
scheduler lag p99 < 100ms
cpu throttled delta = 0
generator OOM delta = 0
generator OOM-kill delta = 0
source-port headroom valid
FD headroom valid
```

Define normalized CPU explicitly, e.g.:

```text
CPU time during interval / (wall interval * assigned CPU cores)
```

Generator invalidity -> `INCONCLUSIVE`.

After final hot-path changes, rerun a generator benchmark for the actual active v2.3.x path.

---

# 13. R10 — TimingValid MUST BE COMPUTED

Current result assembly still sets:

```go
r.valid.TimingValid = true
```

Remove this placeholder.

Compute timing validity from evidence:

```text
phase starts/ends monotonic
required durations positive
no end<start
no implausible future timestamps
coordinated phase ordering valid
surge deadlines valid
burst duration valid
late-join durations valid
restart duration valid
scheduler-lag p99 valid
campaign/run timestamp ordering valid
```

Expose timing evidence, not only a boolean.

Missing mandatory timing evidence -> `INCONCLUSIVE`.

---

# 14. R11 — PUBLISHER HEALTH AND EVENT RATES MUST DRIVE VERDICT

Do not rely on `events_published >0` as workload proof.

Preserve per phase:

```text
attempts
successes
definite_failures
ambiguous_failures
pending_peak
all 8 match heads
phase start/end counters
```

Terminal publisher gates:

```text
definite_failures = 0
ambiguous_failures = 0
pending_peak <= 1000
all 8 heads present and advanced
non-owner publishes = 0
```

Separate:

```text
connection_rates
publication_rates
```

Freeze/gate actual accepted publication rates:

```text
steady: 8.0 .. 12.0 events/s
burst:  40.0 .. 60.0 events/s
```

Use accepted publisher events / measured phase duration.

All 8 matches receive measured events.

Publisher/generator failure to generate required workload -> `INCONCLUSIVE`.

---

# 15. R12 — DUT RESOURCE EVIDENCE MUST COVER THE WORKLOAD

Current resource evidence is not yet a complete phase-spanning terminal measurement.

For each:

```text
p0
p1
p2
p3
spare
```

capture at least:

```text
baseline/pre-load
post-steady
post-surge
post-burst
post-reconnect
post-restart
final
```

Mandatory fields:

```text
memory_current_bytes
memory_peak_bytes
cpu_usage_usec
cpu_throttled_count
cpu_throttled_usec
memory_oom_events
oom_kill_events
```

For cumulative metrics preserve baseline/final/delta.

Gates:

```text
memory_peak_bytes < 5,637,144,576
OOM-kill delta = 0
required throttle delta = 0
mandatory fields numeric/present
no worker death
no worker_connections exhaustion
```

With valid generator:

```text
OOM-kill>0 -> REJECT
memory>=limit -> REJECT
```

Measurement/resource invalidity -> `INCONCLUSIVE`.

Spare evidence is mandatory across failover.

Redis preserves:

```text
used_memory
used_memory_peak
connected_clients
cgroup memory/OOM/throttle evidence where available
```

Required Redis fields must be present/numeric.

---

# 16. R13 — NEVER CONVERT MISSING RESOURCE METRICS TO ZERO

Current helper still behaves like:

```go
func derefInt64(p *int64) int64 {
    if p == nil { return 0 }
    return *p
}
```

This can fabricate clean evidence.

Required closure:

```text
missing/null stays missing/null
mandatory missing metric adds validity reason
mandatory missing metric prevents ACCEPT
```

Use nullable result types or explicit presence fields.

Add adversarial tests for every mandatory metric missing.

---

# 17. R14 — DEEP-COHORT DENOMINATOR/HEAD AGREEMENT MUST BE EXPLICIT

Per shard:

```text
deep_expected = 256
deep_agreed = 256
deep_disagreed = 0
deep_unmatched = 0
```

Global:

```text
deep_expected = 1024
deep_agreed = 1024
deep_disagreed = 0
deep_unmatched = 0
```

Every expected deep client lands in exactly one category.

Do not silently ignore a client that never established/validated/matched a publisher head.

Also machine-gate:

```text
schema errors = 0
state violations = 0
invalid timestamps = 0
canonical payload/state violations = 0
```

---

# 18. R15 — REQUIRED CORRECTNESS FIELDS MUST BE PRESENT, NOT `?? 0`

Current aggregation still has patterns equivalent to:

```ts
correctnessCounters[name] ?? 0
```

for terminal gating.

Define one exact mandatory field list.

Before checking zero:

```text
missing/null/nonnumeric/NaN/Infinity -> INCONCLUSIVE
```

Only then:

```text
value == 0
```

Applies to full-pop, transport/canonical, schema/state, surge, reconnect, and restart counters.

---

# 19. R16 — EVIDENCE PRESERVATION MUST BE CAMPAIGN-ISOLATED AND IMMUTABLE

Current launcher preserves flat files that can overwrite prior evidence.

Use one canonical directory:

```text
internal_docs/m3_evidence/<CAMPAIGN_ID>/
```

If repository convention requires a different root, choose one canonical root and use it consistently.

Refuse if campaign directory already exists.

Preserve:

```text
CAMPAIGN.md
command.txt
source-commit.txt
contract-version.txt
contract.sha256
git-status-before.txt
environment.txt
compose-config.txt
docker-images.txt
run-0.stdout.log
run-0.stderr.log
run-0.exit
global-result-0.json
run-1.stdout.log
run-1.stderr.log
run-1.exit
global-result-1.json
run-2.stdout.log
run-2.stderr.log
run-2.exit
global-result-2.json
campaign.stdout.log
campaign.stderr.log
campaign.exit
campaign-result.json
SHA256SUMS
M3_EVIDENCE_MANIFEST.md
M3_INDEPENDENT_VERDICT_AUDIT.md
```

Preserve shard files separately if not fully embedded.

Never overwrite q5/v2.2 evidence.

---

# 20. R17 — QUALIFYING LAUNCHER MUST REQUIRE CLEAN COMMITTED SOURCE

For live-repository qualifying mode, before Docker build require:

```text
git status --porcelain == empty
git diff --quiet
git diff --cached --quiet
valid 40-hex HEAD
```

Record:

```text
HEAD
contract SHA-256
rendered Compose config
Docker version
Compose version
built image IDs/digests
```

Terminal source SHA must identify the exact code built.

A `poc/SOURCE_COMMIT` fallback may remain for later packaged reviewer mode, but not as a substitute for live qualification provenance.

---

# 21. R18 — EXACT RUN EXIT CODES AND LOGS MUST BE PRESERVED

Continuing all three frozen runs is acceptable, but `|| true` may not erase the exit status.

For each run capture:

```text
stdout
stderr
exact numeric exit
```

Then continue to next frozen run.

Campaign aggregation gets its own stdout/stderr/exit.

Launcher final exit:

```text
0 only for campaign machine ACCEPT
nonzero otherwise
```

---

# 22. R19 — INDEPENDENT VERDICT AUDIT MUST EXIST

After campaign result, run a second audit that does not trust top-level verdict fields.

Independently recompute/verify:

```text
contract identity
source identity
exact 3 runs
seeds 42/43/44
4 shards
publisher owner
phase completeness
60k baseline
+40k established <=120s
100k full target
mandatory correctness fields present
correctness zero
surge correctness
reconnect exact denominator
restart measured deltas
latejoin 256/run
latejoin 768/campaign
deep 1024/1024
latency thresholds
publisher workload/rates
generator validity
Nchan p0..p3 validity
spare validity
Redis validity
CV formula
CV <=0.15
per-run verdict consistency
campaign verdict consistency
```

Write:

```text
M3_INDEPENDENT_VERDICT_AUDIT.md
```

If independent audit disagrees with machine `ACCEPT`, M3 remains open.

---

# 23. R20 — MILESTONE TRACKER IS STALE

Before terminal completion it must accurately say:

```text
M3 IN PROGRESS
active contract v2.3.x
historical q5 INCONCLUSIVE
historical v2.2 campaign non-terminal
current phase = v2.3.x integrity closure / prequalification
```

Only after terminal success:

```text
M3 DONE — ACCEPT
M4 NEXT
```

Final tracker records:

```text
contract
qualifying source SHA
campaign ID
seeds42/43/44
per-run verdicts
worst CV
campaign verdict
manifest path
independent audit PASS
```

Earlier M4-M9 drafts are provisional, not proof M3 passed.

---

# 24. REQUIRED REGRESSION TESTS BEFORE NEXT LARGE PROBE

## Reconnect

```text
64 selected/64 ready/64 released/64 evaluated/64 passed
63 ready -> non-ACCEPT
63 evaluated -> non-ACCEPT
missing raw transport id -> fail
raw id never synthesized from canonical seq
opaque raw id survives round trip
```

## Restart

```text
measured delta zero -> pass
one gap -> reject
one duplicate -> reject
one out-of-order -> reject
structured/top-level mismatch -> inconclusive
```

## Surge

```text
60k exact start
40k exact attempt total
40k exact established total
120000ms passes
120001ms fails
final >=100k
per-shard final >=25k
window correctness deltas zero
surge histogram nonempty
```

## Generator validity

```text
CPU boundary
scheduler-lag boundary
throttle delta
OOM delta
missing metric
port headroom
FD headroom
```

## Timing

```text
hard-coded true removed
negative duration invalid
future timestamp invalid
surge deadline violation classified correctly
```

## Publisher

```text
definite failure -> inconclusive
ambiguous failure -> inconclusive
pending >1000 -> inconclusive
missing head -> inconclusive
steady rate outside 8..12 -> inconclusive
burst rate outside 40..60 -> inconclusive
```

## Resources

```text
nil metric remains null
nil never becomes zero
Nchan memory boundary
OOM delta
throttle delta
missing spare
missing Redis memory
```

## Deep denominator

```text
256 expected/256 agreed -> pass
255 agreed +1 unmatched -> reject
one disagreed -> reject
missing denominator -> inconclusive
```

## Campaign

```text
BASE_GLOBAL_SEED !=42 rejected in qualifying mode
latejoin campaign count768 exact
767 invalid
769 invalid
CV exactly0.15 stable
CV >0.15 unstable
```

## Evidence

```text
existing campaign directory -> refuse
dirty tree -> refuse
run exit captured
checksums verify
independent audit detects tampered verdict
```

---

# 25. FULL REGRESSION GATE

Before scale work:

```bash
cd poc/runner
npm ci
npm run typecheck
npm test
```

Then:

```bash
cd ../loadgen
go test ./...
go test -race ./...
```

Then from `poc/`:

```bash
bash -n run-evidence-100k.sh
bash -n run-probe.sh
docker compose -f compose.evidence-100k.yaml config
```

Run focused tests for:

```text
canonical light continuity
reconnect denominator/raw ID
latejoin
surge
restart measured counters
generator monitor
timing validity
publisher workload
DUT resources
global classifier
campaign classifier
contract governance
evidence preservation
independent audit
```

Any failure blocks scale testing.

---

# 26. RE-RUN GENERATOR BENCHMARK ON FINAL HOT PATH

Create a new non-qualifying benchmark artifact for final active v2.3.x source.

Record:

```text
frames/sec
ns/op
allocations/op
bytes/op
CPU
memory
GC
canonical_seq extraction included
continuity state machine included
```

The benchmark is diagnostic/headroom evidence only. It does not replace runtime validity.

---

# 27. RESUME NON-QUALIFYING SCALE LOOP

Required ladder before terminal qualification:

```text
10k -> 25k -> 50k -> 75k -> 100k
```

Use a 1k smoke for functional debugging if useful.

For each probe:

1. unique non-qualifying ID;
2. preserve output;
3. record source SHA;
4. never call it terminal evidence;
5. classify first failure as harness/measurement, generator, host/kernel, or DUT;
6. fix smallest causal defect;
7. add regression test;
8. commit;
9. rerun relevant tests;
10. resume from smallest useful scale.

Do not ask the user whether to continue after a failed probe.

---

# 28. 100K PREQUALIFICATION — NEXT MAJOR STOP GATE

Do not freeze terminal source until one clean, explicitly non-qualifying 100k run passes the final active semantics.

Required:

```text
60,000 pre-surge active exactly
+40,000 established <=120000ms
100,000 full-target active after surge
each shard final >=25,000
full-target fanout p95 <=500ms
surge fanout p95 <=500ms
burst p95 <=1000ms
latejoin p95 <=2000ms
latejoin count =256
reconnect selected/ready/released/evaluated/passed =256 each
restart measured deltas all zero
full-pop missing/duplicates/out-of-order =0
surge correctness deltas =0
missing transport id =0
missing canonical seq =0
canonical parse errors =0
schema/state/timestamp violations =0
deep expected/agreed =1024/1024
deep disagreed/unmatched =0/0
publisher workload valid
steady accepted events/s 8..12
burst accepted events/s 40..60
all 8 match heads advanced
all generators valid
Nchan p0..p3 valid
spare valid
Redis valid
no mandatory metric missing
timing valid from evidence
```

If prequalification fails:

```text
preserve it
fix cause
do not freeze source
continue M3
```

---

# 29. FREEZE QUALIFYING SOURCE ONLY AFTER CLEAN PREQUALIFICATION

After clean 100k prequalification:

1. rerun all full/focused tests;
2. commit all source/contract/test changes;
3. verify working tree clean;
4. record qualifying source SHA;
5. record active contract/hash;
6. do not change code after source freeze;
7. do not change thresholds/sample counts/topology after source freeze.

Any later code change requires a new source commit and fresh campaign.

---

# 30. TERMINAL CAMPAIGN — EXACTLY THREE FRESH RUNS

Use:

```text
GLOBAL_RUNS=3
BASE_GLOBAL_SEED=42
seeds42,43,44
```

One fresh campaign ID. Fresh Compose project. Fresh volumes. Fresh immutable evidence directory.

Same source, contract, topology, thresholds, cohorts.

No manual intervention between runs.

Do not retry an individual run inside the same campaign.

---

# 31. TERMINAL PER-RUN ACCEPT CONDITIONS

Each run independently:

```text
validity.valid = true
verdict = ACCEPT
```

One `REJECT`, `INCONCLUSIVE`, or missing run means terminal campaign is not complete.

Preserve it and continue M3 only after causal repair/new source as needed.

---

# 32. TERMINAL CAMPAIGN ACCEPT CONDITIONS

Campaign must have:

```text
run_count=3
indices=0,1,2
seeds=42,43,44
same source
same contract
same campaign
per_run_verdicts=ACCEPT,ACCEPT,ACCEPT
latejoin count=768
all required histograms nonempty
correctness aggregate zero
CV threshold=0.15
worst_cv<=0.15
dispersion stable=true
validity.valid=true
verdict=ACCEPT
```

Do not raise CV or remove an unstable metric after seeing results.

---

# 33. EVIDENCE MANIFEST

Generate `M3_EVIDENCE_MANIFEST.md` containing:

```text
campaign ID
qualifying source SHA
contract version/hash
campaign start/end UTC
host CPU/RAM/kernel
Docker/Compose versions
exact command
run0 seed/exit/verdict
run1 seed/exit/verdict
run2 seed/exit/verdict
campaign exit/verdict
surge start/attempted/established/failures/elapsed/final
full-target active
fanout/surge/burst/latejoin p95
latejoin count
reconnect selected/ready/released/evaluated/passed
restart measured deltas
all mandatory correctness counters
deep expected/agreed/disagreed/unmatched
publisher attempts/success/failures/pending
steady publication rate
burst publication rate
generator validity per shard
Nchan p0..p3 resources
spare resources
Redis resources
CV metrics
worst CV
machine campaign verdict
independent audit verdict
SHA256SUMS path
```

No prose number may disagree with raw JSON.

---

# 34. INDEPENDENT TERMINAL AUDIT

Run the independent audit after preservation.

It says `PASS` only if independently recomputed evidence supports `ACCEPT`.

If machine says ACCEPT but audit disagrees:

```text
M3 NOT DONE
```

Preserve, diagnose, fix, and continue.

---

# 35. UPDATE MILESTONE TRACKER ONLY AT END

Only after:

```text
run0 ACCEPT
run1 ACCEPT
run2 ACCEPT
campaign ACCEPT
worst CV<=0.15
independent audit PASS
checksums PASS
```

record:

```text
Milestone 3 — DONE — ACCEPT
Active contract: <v2.3.x>
Qualifying source: <40-hex>
Campaign: <id>
Runs: 3
Seeds: 42,43,44
Per-run: ACCEPT / ACCEPT / ACCEPT
Worst CV: <value> <=0.15
Campaign verdict: ACCEPT
Evidence manifest: <path>
Independent audit: PASS
```

Retain historical q5 and v2.2 notes.

Then:

```text
M4 = NEXT
```

Do not execute M4+ in this prompt.

---

# 36. ANTI-LOOP RULE

Do not return to:

```text
run -> fail -> change threshold -> run -> fail -> change classifier
```

Use:

```text
run
preserve evidence
identify causal defect
fix without weakening requirement
add regression test
commit
probe
prequalify
freeze
qualify
```

Targets and thresholds are not debugging variables.

---

# 37. FAILURE LOOP

If any development/prequalification/qualification step fails:

```text
1 preserve evidence
2 determine first causal failure
3 classify: harness/measurement, generator, environment, DUT
4 fix smallest causal issue
5 add regression test
6 commit
7 rerun full relevant gate
8 rerun required scale/prequalification
9 fresh terminal campaign if source changed
```

Do not stop after one failed attempt. Do not ask whether to continue.

---

# 38. DO NOT REOPEN CLOSED WORK

Unless live code proves regression, do not redo:

```text
Go loadgen architecture reset
4-partition topology
publisher/control separation
CV restoration to0.15
slow-consumer removal
latejoin256/run
basic canonical continuity
basic surge histogram
basic p95 gates
```

Focus on R01-R20 and execution/evidence closure.

---

# 39. FINAL REPOSITORY AUDIT BEFORE M3 DONE

Search active code for remaining forbidden shortcuts:

```text
FormatUint(canon
restart_failover_gaps": 0
restart_failover_duplicates": 0
restart_failover_order_violations": 0
TimingValid = true
derefInt64
DISPERSION_THRESHOLD_CV = 0.80
duplicates <= 1
GLOBAL_RUNS must be in
late-join dual cardinality
slow-consumer in COORDINATED_PHASES
correctnessCounters[name] ?? 0
flat global-result-0.json preservation
|| true without recorded exit
```

Historical files may contain historical values only if not active.

Also verify:

```text
TS/Go contract identical
exact3 runs
base seed42
surge exact60k->100k
latejoin256/run
latejoin768/campaign
resource null stays null
generator validity measured
timing validity measured
restart counters measured
clean-source gate present
immutable evidence directory present
independent audit present
```

---

# 40. 100% STOPPING CONDITION

Do not declare completion because tests pass, one 100k probe passes, one run accepts, or an old campaign says ACCEPT.

Stop only when:

```text
ALL REMAINING CODE GAPS CLOSED
+
ALL TESTS GREEN
+
FINAL HOT-PATH GENERATOR BENCHMARK PRESERVED
+
CLEAN 100K PREQUALIFICATION PASS
+
QUALIFYING SOURCE FROZEN
+
FRESH RUN0 ACCEPT seed42
+
FRESH RUN1 ACCEPT seed43
+
FRESH RUN2 ACCEPT seed44
+
CAMPAIGN VALID
+
WORST CV <=0.15
+
CAMPAIGN ACCEPT
+
IMMUTABLE EVIDENCE COMPLETE
+
SHA256SUMS PASS
+
INDEPENDENT AUDIT PASS
+
MILESTONE TRACKER UPDATED
=
MILESTONE 3 100% DONE
```

---

# 41. REQUIRED FINAL RESPONSE FROM CODING AGENT

Before the stopping condition is met, never print:

```text
MILESTONE 3: DONE — ACCEPT
```

When and only when genuinely complete:

```text
MILESTONE 3: DONE — ACCEPT

Contract: <v2.3.x>
Source SHA: <sha>
Campaign: <campaign-id>
Runs: ACCEPT / ACCEPT / ACCEPT
Seeds: 42 / 43 / 44
Worst CV: <value> <= 0.15
Evidence manifest: <path>
Independent audit: PASS
M4: NEXT
```

If a genuinely external/local-environment blocker remains after all repository-fixable work is complete, leave M3 open and report the exact blocker/evidence. Do not fake ACCEPT.

---

# 42. EXECUTION PRIORITY FROM CURRENT BASELINE

Use this order unless live-sync proves an item closed:

```text
1 minimal v2.3.x contract correction if needed
2 remove canonical->raw resume fallback
3 reconnect selected/ready/released/evaluated/passed exact
4 wire measured restart deltas
5 machine-prove60k->100k surge + surge correctness
6 finish histogram presence/full-target provenance
7 force qualifying base seed42 + campaign latejoin768
8 implement runtime generator health
9 compute timing validity
10 wire publisher workload/rates
11 workload-time Nchan/spare/Redis resources
12 remove nil->zero coercion
13 enforce deep denominator
14 enforce mandatory counter presence
15 campaign-isolated evidence + clean-source gate
16 exact run exit/log preservation
17 independent verdict audit
18 full regression gate
19 final-hot-path generator benchmark
20 scale probes
21 clean100k prequalification
22 source freeze
23 fresh3-run qualification
24 independent terminal audit
25 milestone tracker DONE
```

Do not skip directly to terminal qualification.
