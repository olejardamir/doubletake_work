# Milestone 3 — 100% Integrity Closeout Until Terminal ACCEPT

**Repository:** `olejardamir/EA`  
**Scope:** Milestone 3 only. Repair the **current M3**; do not create M3b, a side experiment, or a substitute milestone.  
**Live baseline audited before this instruction:** `a2e092c1f842a6d11d63ab09340ff9b661093325` on 2026-08-22.  
**Objective:** close every remaining M3 implementation, measurement, governance, and evidence gap, then keep iterating until a fresh qualifying campaign produces a defensible machine `ACCEPT` under criteria frozen **before** that campaign.

> **First action:** live-sync `main`. If `main` has advanced beyond the SHA above, audit the new commits and remove only gaps that are genuinely closed. Never reopen completed work merely because this prompt was written against an earlier SHA.

---

## 1. Definition of 100% complete

M3 is 100% complete **only** when all of these are simultaneously true:

1. One internally consistent M3 contract is frozen before terminal qualification.
2. TypeScript, Go, Compose, launcher, schemas, tests, and classifiers implement that exact contract.
3. Every assignment-critical M3 criterion is machine-enforced, not merely documented.
4. The full measured viewer population contributes the correctness evidence claimed for it.
5. Generator/publisher health is measured and cannot hide DUT failure.
6. DUT resource evidence covers the actual workload and failover window.
7. A non-qualifying scale ladder reaches a clean 100k prequalification under final semantics.
8. The qualifying source is committed and the working tree is clean before qualification.
9. A fresh campaign runs **exactly 3 global runs**, seeds **42, 43, 44**, with no changes between runs.
10. All 3 global runs are `ACCEPT`.
11. Campaign cross-run stability uses **CV <= 0.15** and passes.
12. Campaign machine verdict is `ACCEPT`.
13. Evidence is immutable, campaign-isolated, checksummed, and source/contract bound.
14. An independent post-run audit recomputes the verdict and agrees with `ACCEPT`.
15. Only then is the milestone tracker changed to `M3: DONE — ACCEPT`; M4 becomes next.

Anything less is not 100%.

---

## 2. Integrity rules — never violate these to obtain ACCEPT

- Preserve all historical `INCONCLUSIVE`, `REJECT`, aborted, probe, and non-terminal campaigns.
- Never rewrite raw evidence to improve a verdict.
- Never delete an unfavorable run from a frozen campaign.
- Never append favorable reruns to a failed campaign.
- Never lower viewer targets, correctness requirements, or latency requirements after seeing results.
- Never raise the CV threshold after seeing results.
- Never change seeds after seeing results.
- Never reinterpret missing/null evidence as zero.
- Never treat an empty histogram as zero latency.
- Never claim full-population correctness when only a cohort was checked.
- Never claim source identity from `HEAD` if the Docker build includes uncommitted changes.
- A measurement defect may be fixed only with root-cause proof, a regression test, preserved failed evidence, a new source commit, and a new contract version when semantics changed.
- If the DUT genuinely fails with a healthy generator, repair the architecture. Do not repair the threshold.

---

## 3. Preserve the engineering that is already done

Keep these unless fresh measured evidence proves they must change:

- Nchan horizontal fan-out: `p0..p3` plus `nchan-spare`.
- Shared Redis canonical history/store.
- Independent publisher/control service.
- Four Go load-generator shards.
- 25k **full-target** viewer ownership per shard (new contract restores 15k/shard pre-surge baseline ->25k/shard after surge).
- Coordinated four-shard barriers/global aggregation.
- One publisher-owner, non-owner publication prohibition.
- Source-port preflight.
- Late-join required-range probe machinery.
- Reconnect required-range machinery.
- Partition-targeted restart/failover drill.
- Go Dockerization and evidence Compose topology.
- Generator benchmark framework.
- Shard -> global run -> campaign result hierarchy.
- q5 historical evidence and every later historical probe/campaign.

Do not restart M3 from scratch.

---

## 4. Historical v2.2.0 campaign disposition

The current v2.2.0 3-run result is useful **historical engineering evidence**, but it is **not terminal M3 evidence**.

Preserve its raw JSON exactly. Create a short historical disposition note explaining:

- the three runs are preserved unmodified;
- their technical performance remains useful;
- the post-hoc aggregate `ACCEPT` is not the final M3 claim;
- a new campaign will be run under a newly frozen contract.

Why it is non-terminal:

- v2.2.0 froze cross-run CV at `<= 0.15`;
- commit `0e40af613ba38888ce9434a88998311055c4e82e` later changed the executable threshold from `0.15` to `0.80` after results existed;
- the same code change allowed restart-pool duplicates up to one and dual late-join cardinalities;
- the active Go path does not currently enforce all frozen latency/surge/generator/resource gates;
- the majority lightweight viewer path does not currently execute true continuity checking;
- evidence preservation/source-binding still has terminal-governance gaps.

Do not relabel the raw historical files. The new terminal campaign must be fresh.

---

# 5. Complete M3 gap register

Every item G01-G25 must be `CLOSED` before terminal qualification.

## G01 — Restore precommitted CV integrity

Current active campaign code uses `DISPERSION_THRESHOLD_CV = 0.80`; the frozen v2.2.0 contract says `<= 0.15`.

**Required closure**

- Terminal M3 CV threshold = **0.15**.
- Formula = sample standard deviation (`n-1`) / absolute mean.
- Boundary tests: exactly `0.15` passes; anything greater fails stability.
- Preserve the historical 0.80 campaign; do not retroactively mutate it.
- No threshold change after terminal source freeze.

## G02 — Restart duplicate allowance must be zero

Some current global/campaign logic accepts a failover-pool duplicate count up to one.

**Required closure**

- Restart/failover stream duplicates = **0 exactly**.
- Exact-range probe duplicates = **0 exactly**.
- Remove all active `<= 1` allowances.
- One duplicate must block `ACCEPT`.
- Add adversarial test: one duplicate -> `REJECT` under valid measurement.

Raw Nchan resume behavior is not permission for one duplicate application event.

## G03 — Fix late-join cardinality contradiction

Current v2.2.0 prose says 8 probes/shard = 32/run but elsewhere says merged count equals shard count; current code accepts either 4 or 32.

Use one exact active cardinality. Strengthen the measurement before the new campaign to stabilize p95 rather than relaxing CV:

```text
8 matches
x 8 deterministic rounds/match/shard
x 4 shards
= 256 late-join samples/global run
```

Therefore freeze:

```text
64 samples/shard
256 samples/global run
768 samples/3-run campaign
```

Rules:

- every match on every partition covered every round;
- every probe contributes to denominator;
- any failed/missing probe blocks pass;
- bounded deterministic concurrency so the probe itself is not an uncontrolled load spike;
- exact histogram cardinality only: 256/run, 768/campaign;
- no dual accepted shapes.

## G04 — Qualifying campaign must be exactly 3 runs

Current launcher/aggregator still permits 3..8.

**Required closure**

```text
GLOBAL_RUNS = 3 exactly
BASE_GLOBAL_SEED = 42 exactly
run0 seed = 42
run1 seed = 43
run2 seed = 44
```

- Qualifying launcher rejects any `GLOBAL_RUNS != 3`.
- Qualifying aggregator rejects 2 or 4 runs.
- Exact files: `global-result-0.json`, `global-result-1.json`, `global-result-2.json`.
- Reject duplicate, missing, or noncontiguous run indices.
- Development probes remain explicitly non-qualifying.

## G05 — Remove slow-consumer from active v2.3 qualification

v2.2.0 says slow-consumer was removed, but active coordinator phases and Go runtime still include a slow-consumer barrier and a dummy always-pass scenario.

**Required closure**

Remove it from the new active qualifying:

- `COORDINATED_PHASES`;
- Go barrier execution;
- scenario enumeration;
- active-population allowances;
- dummy always-pass result.

New exact qualifying phase order:

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

Historical slow-consumer files may remain historical only.

## G06 — Full-population continuity is currently not real

Critical defect: current Go `RoleLight` processing updates `LastSeq` and returns before `observe()`. The majority of the 100k population therefore does not actually detect gaps, duplicates, or out-of-order events.

**Required closure**

Every non-lobby match viewer must execute canonical sequence continuity:

```text
first seq        -> initialize
seq = last + 1   -> NEXT
seq = last       -> DUPLICATE
seq > last + 1   -> GAP; add exact missing count
seq < last       -> OUT_OF_ORDER
```

Applies to:

- `RoleLight`
- `RoleReconnect`
- `RoleDeep`

Lobby remains liveness-only.

Add tests for one-gap, multi-gap, duplicate, out-of-order, clean delivery, and independent match-channel continuity.

No terminal report may say “full-population correctness” until this is implemented and verified.

## G07 — Separate raw Nchan transport ID from canonical application sequence

Nchan SSE `id:` is a transport resume token. It is not the application `canonical_seq`.

Freeze two identities:

```text
raw_transport_id
  exact SSE id string
  required/preserved verbatim for Last-Event-ID
  never numerically interpreted as application sequence

canonical_seq
  application event sequence from payload
  drives gap/duplicate/out-of-order correctness
```

**Required closure**

- Implement a cheap canonical-sequence extractor for the lightweight path without full JSON unmarshal.
- `RoleLight` uses `canonical_seq` for continuity.
- Raw transport ID is stored separately for resume.
- Never compare numeric Nchan ID to canonical sequence.
- Missing raw transport ID is a correctness failure; do not fabricate one from canonical sequence.
- Reconnect required-range proof uses canonical sequence values but sends raw transport ID in `Last-Event-ID`.
- Rebenchmark the **final** light hot path after this change.

## G08 — Add explicit zero-gated correctness counters

A count named `transport_id_present` cannot prove none were missing.

Freeze explicit machine counters, at minimum:

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

Plus existing sequence/reconnect/restart counters.

Rules:

- mandatory counters always present and numeric;
- missing mandatory field -> invalid evidence;
- all applicable correctness counters = 0 for `ACCEPT`;
- if names are consolidated, define the exact mapping in the new contract and test it.

## G09 — Reconnect denominator must not shrink

Current scenario can pass when all returned results pass even if fewer results were evaluated than released.

Freeze per shard:

```text
selected = 64
released = 64
evaluated = 64
passed = 64
failed = 0
```

Global:

```text
selected = released = evaluated = passed = 256
```

Rules:

- every selected/released client produces a result;
- empty capture = failed result;
- missing result cannot vanish from denominator;
- every required range is frozen from publisher evidence;
- zero gaps/duplicates/order violations;
- test 64 released / 63 evaluated -> non-ACCEPT.

## G10 — Restart correctness counters must be measured, not literals

Current Go result assembly hard-codes restart failover counters to zero while the restart drill separately measures real pool deltas.

**Required closure**

- Capture before/after restart snapshots.
- Return typed measured restart deltas.
- Populate top-level counters from those deltas.
- Structured restart `pool.*` and top-level counters must agree exactly.
- Disagreement -> `INCONCLUSIVE`.
- Actual nonzero correctness delta -> `REJECT` with healthy measurement.
- Never emit a literal zero unless zero was measured.

## G11 — Enforce every frozen latency threshold in machine code

Global classifier must enforce:

```text
fan_out_p95_ms        <= 500
surge_fan_out_p95_ms  <= 500
burst_fan_out_p95_ms  <= 1000
late_join_p95_ms      <= 2000
```

Tests:

- 500 pass / 501 reject;
- 1000 pass / 1001 reject;
- 2000 pass / 2001 reject;
- empty required histogram -> `INCONCLUSIVE`, never zero latency.

**Full-target isolation:** `fan_out_p95_ms` must come from a dedicated post-surge 100k measurement window (for example the stabilization/full-target window), not from an aggregate that mixes 60k baseline samples with 100k samples. Keep all-run histograms only as diagnostics. Goal/other class splits must retain phase provenance so a lower-load sample population cannot dilute the full-target gate.

## G12 — Restore and prove the frozen 60k -> 100k surge mapping

The active v2.2.0 contract freezes the POC mapping as **+40,000 viewers within 120 seconds, ramping from 60% population to the 100,000 target**. The current Go v2.2.0 implementation instead builds 100k first and attempts to surge toward 140k. That is contract drift. Do not make M3 prove a different workload.

Restore/freeze terminal M3 as:

```text
pre-surge registered/active baseline = 60000 global = 15000/shard
surge attempted additions = 40000 global = 10000/shard
surge established additions = 40000
surge failed additions = 0
surge elapsed <= 120000 ms
surge final aligned active >= 100000
post-surge full-target phases sustain >= 100000
```

Add machine fields:

```text
surge_start_active
surge_attempted_additions
surge_established_additions
surge_failed_additions
surge_elapsed_ms
surge_final_active
surge_peak_active
```

Use four shards with 15k baseline viewers each, then add 10k/shard. Recommended deterministic schedule: 24 global batches every 5 seconds, first at t=0 and last begun no later than t=115s; all 40k must be established by t<=120s. Connections established after the deadline do not count.

Healthy generator + insufficient DUT surge = `REJECT`. Invalid generator/environment = `INCONCLUSIVE`.

## G13 — Add dedicated surge correctness and latency evidence

“Without materially degrading existing viewers” must be measured.

Add:

```text
histograms.surge_fan_out
surge_missing_sequences
surge_duplicates
surge_out_of_order
surge_unexpected_disconnects
```

Use pre-existing deep viewers as the existing-viewer latency observer.

Terminal gates:

```text
surge_fan_out_p95_ms <= 500
all surge correctness deltas = 0
```

Do not infer surge latency from steady/burst/all-run histograms.

## G14 — Require exact 60k pre-surge baseline and sustained 100k full-target evidence

A 98% helper is not an acceptance target.

Before surge begins:

- exactly 60,000 registered baseline viewers (15,000/shard);
- aligned active baseline reaches all 60,000;
- steady samples are complete/aligned;
- baseline correctness is clean.

After the +40k surge:

- aligned active reaches at least 100,000 by the deadline;
- each shard reaches its final 25,000 ownership target;
- `target-barrier`, `stabilization`, late-join, and burst operate at the full 100k target;
- connection failures/unexpected disconnects remain zero except explicitly planned reconnect/restart attribution.

The terminal `fan_out_p95_ms` must be computed from a dedicated **full-target post-surge measurement window**, not diluted by lower-load 60k samples.

## G15 — Measure Go generator health during the real run

The microbenchmark is necessary but insufficient.

Per shard record:

```text
cgroup CPU baseline/final/delta
normalized CPU against assigned 4-core capacity
cgroup cpu throttled count/usec baseline/final/delta
memory current/peak
OOM counters
scheduler/ticker-lag distribution
scheduler p99
goroutine count
GC count/pause evidence
source-port evidence
FD limits
```

Retain validity intent:

```text
normalized CPU < 90%
scheduler/ticker lag p99 < 100ms
CPU throttle delta = 0
no generator OOM
source-port/FD headroom valid
```

Failure of generator validity -> `INCONCLUSIVE`, never `ACCEPT`.

Define the normalization formula in contract/tests before terminal run.

## G16 — Compute timing validity; do not hard-code it

`TimingValid=true` must be replaced by evidence-based calculation.

Validate at least:

- monotonic phase start/end timestamps;
- positive/non-impossible durations;
- no future-clock anomaly;
- scheduler-lag p99;
- surge deadline;
- burst duration;
- late-join probe timing;
- restart timing;
- campaign/run ordering.

Hard-coded timing validity is forbidden.

## G17 — Wire publisher health into run validity

Publisher `/v1/evidence` already exposes useful evidence. Preserve and gate:

```text
attempts
successes/published
definite_failures
ambiguous_failures
pending_peak
started/stopped state
all 8 match heads
phase snapshots/rates
```

Terminal gates:

```text
definite_failures = 0
ambiguous_failures = 0
pending_peak <= 1000
all 8 match heads present and advanced
```

Publisher/control-plane invalidity -> `INCONCLUSIVE`.

## G18 — Separate event publication rate from connection rate

Current `phaseRates(samples)` derives connection attempted/established rates, not event publication rates.

Result schema must distinguish:

```text
connection_rates
publication_rates
```

Freeze event workload acceptance **before the terminal campaign**. Because the assignment/contract values are approximate (`~10/s`, `~50/s`), use the existing executable tolerance if one is already frozen elsewhere in the repository. If none exists, freeze and justify this deterministic tolerance before running evidence:

```text
steady accepted publication rate: 8.0 .. 12.0 events/s
burst accepted publication rate: 40.0 .. 60.0 events/s
```

The tolerance rationale must be documented as scheduler/measurement allowance, not chosen from observed terminal results.

Also require:

- all 8 matches receive measured events;
- no non-owner publishes;
- publication totals/rates agree with publisher evidence.

Never use viewer connection rate as proof of event rate.

## G19 — DUT resource evidence must cover workload-time peaks/deltas

Current preflight-only metrics are not sufficient.

For `p0..p3` and spare, capture at minimum:

1. baseline before measured load;
2. after steady;
3. after surge;
4. after burst;
5. after reconnect;
6. after restart/failover;
7. final.

Mandatory numeric fields:

```text
memory_current_bytes
memory_peak_bytes
cpu_usage_usec
cpu_throttled_count baseline/final/delta
cpu_throttled_usec baseline/final/delta
memory_oom_events baseline/final/delta
oom_kill_events baseline/final/delta
```

Nchan memory gate:

```text
memory_peak_bytes < 5,637,144,576
```

(87.5% of 6 GiB.)

Rules:

- required null/missing -> `INCONCLUSIVE`;
- positive DUT OOM-kill delta with valid generator -> `REJECT`;
- CPU throttling delta >0 -> `INCONCLUSIVE` under current retained methodology;
- fatal worker death, required-node loss, or worker connection exhaustion cannot `ACCEPT`.

Redis:

- numeric `memory_used_bytes` required;
- record peak/current and cgroup OOM/throttle evidence where available.

Spare:

- mandatory resource evidence across the actual failover window.

## G20 — Missing mandatory resources must not become zero

Current nil-to-zero conversion can fabricate clean evidence.

**Required closure**

- preserve missing/null as missing/null;
- add validity reason;
- block `ACCEPT`;
- remove helpers that silently convert absent mandatory metrics to `0`;
- adversarial test each required metric missing individually.

## G21 — Deep agreement denominator must be exact

Per shard terminal expectation:

```text
deep_expected = 256
deep_agreed = 256
deep_disagreed = 0
deep_unmatched = 0
```

Global:

```text
expected = 1024
agreed = 1024
disagreed = 0
unmatched = 0
```

Gate:

- schema validity;
- canonical-sequence validity;
- match ID;
- timestamp validity;
- score transitions;
- clock validity/monotonicity;
- canonical payload/state agreement (never raw Nchan-id equality);
- final publisher-head agreement.

No never-eligible/unmatched deep viewer may disappear from the denominator.

## G22 — Make evidence preservation campaign-isolated and immutable

Stop copying fresh `global-result-0/1/2.json` into flat names that can overwrite prior evidence.

Use:

```text
internal_docs/m3_evidence/<CAMPAIGN_ID>/
```

Refuse to run if that directory already exists.

Preserve at minimum:

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
run-1.stdout.log
run-1.stderr.log
run-1.exit
run-2.stdout.log
run-2.stderr.log
run-2.exit
global-result-0.json
global-result-1.json
global-result-2.json
campaign.stdout.log
campaign.stderr.log
campaign.exit
campaign-result.json
SHA256SUMS
M3_EVIDENCE_MANIFEST.md
M3_INDEPENDENT_VERDICT_AUDIT.md
```

Keep shard evidence embedded losslessly or preserve separate shard files too.

## G23 — Qualifying source must be a clean committed tree

Before Docker build in qualifying mode require:

```text
git status --porcelain == empty
git diff --quiet
git diff --cached --quiet
valid 40-hex HEAD
```

Then record:

- exact HEAD;
- contract SHA-256;
- Compose config;
- Docker/Compose versions;
- image IDs.

Do not use `poc/SOURCE_COMMIT` as the live-repository qualification identity. That is later packaging/reviewer support.

## G24 — Control host/VPN conditions for scale evidence

Known target host class: 12 logical CPUs, about 46 GiB RAM, Linux.

Rules:

```text
coding                 VPN may be ON
1k/10k/25k probes       VPN may be ON initially
50k/75k/100k probes     VPN OFF
terminal 3-run campaign VPN OFF
```

Record before final run:

- network interfaces/routes;
- MTU;
- VPN state;
- CPU/RAM/load;
- kernel;
- Docker/Compose;
- cgroup mode;
- swap;
- host and generator namespace port ranges.

Close CPU-heavy applications during final qualification.

Do not buy/assume new hardware unless the repaired final generator proves the host itself prevents a valid test.

## G25 — Reconcile tracker/downstream claims only after fresh terminal ACCEPT

Current downstream M4-M9 drafts must not be treated as proof M3 passed.

Before fresh ACCEPT:

```text
M3 = IN PROGRESS
M4+ = provisional/downstream drafts only
```

After fresh terminal ACCEPT update tracker with:

- active contract version;
- qualifying source SHA;
- campaign ID;
- seeds 42/43/44;
- per-run verdicts;
- campaign verdict;
- worst CV;
- manifest path;
- independent audit result.

Then set:

```text
M3: DONE — ACCEPT
M4: NEXT
```

Do not mark M4-M10 done as part of this task.

---

# 6. Freeze a new active M3 contract before new qualification

Because the repairs above materially change measurement semantics and schema, do not mutate v2.2.0 in place.

If no newer contract exists when execution begins, create:

```text
poc/internal_docs/EXPERIMENT_CONTRACT_v2_3_0.md
```

If `main` has advanced and v2.3.0 is already used, use the next unused version. Preserve all previous contracts.

The new contract must explicitly freeze:

## Topology

```text
Nchan 1.3.8 / nginx 1.27.4
4 active partitions + 1 spare
1 shared Redis
1 independent publisher/control service
4 Go load-generator shards
15,000 pre-surge viewers/shard; 25,000 full-target viewers/shard
```

## Population/workload

```text
pre-surge baseline =60,000 aligned active
surge +40,000 established <=120s
post-surge full target >=100,000 aligned active
8 matches
steady accepted publication 8..12 events/s
burst accepted publication 40..60 events/s
```

## Identity semantics

```text
raw Nchan SSE id = resume token only
canonical_seq = correctness sequence
```

## Cohorts

```text
deep 256/shard = 1024 global
reconnect 64/shard = 256 global
late join 64/shard = 256 samples/run = 768 campaign
```

## Campaign

```text
GLOBAL_RUNS = 3
BASE_GLOBAL_SEED = 42
seeds = 42,43,44
CV threshold = 0.15
```

## Latency

```text
fanout p95 <=500ms
surge fanout p95 <=500ms
burst p95 <=1000ms
late join p95 <=2000ms
```

## Generator validity

```text
normalized CPU <90%
scheduler lag p99 <100ms
throttle delta =0
no OOM
source-port/FD valid
```

## DUT validity

```text
Nchan peak <5,637,144,576 bytes/node
OOM delta 0 for ACCEPT
required throttle delta 0 for ACCEPT
Redis evidence numeric
spare evidence mandatory
```

## Verdict precedence

```text
invalid measurement/generator/environment -> INCONCLUSIVE
valid measurement + failed DUT/correctness/latency/population gate -> REJECT
all valid and all gates pass -> ACCEPT
INCONCLUSIVE > REJECT > ACCEPT at campaign precedence
```

---

# 7. Update contract producers atomically

Update the active version in both runtimes together:

```text
poc/runner/src/domain/active-contract.ts
poc/loadgen/internal/coordinator/result.go
```

Then update governance tests, fixtures, coordinator version validation, launcher output, and evidence manifest generation.

Mixed TS/Go contract version -> `INCONCLUSIVE`.

---

# 8. Repair the lightweight correctness hot path

Implement one allocation-conscious canonical-sequence extractor for the light path.

For every non-lobby frame:

1. require and store raw transport ID;
2. extract `canonical_seq` from `data:` bytes;
3. update viewer continuity state;
4. update aggregate counters;
5. preserve raw ID for reconnect;
6. avoid generic JSON decode for `RoleLight`.

Performance constraints:

- no per-frame maps;
- no generic JSON unmarshal for light viewers;
- bounded buffers;
- no global mutex per light frame;
- atomic aggregation only where required.

Required unit cases:

```text
1,2,3 -> clean
1,3 -> missing=1
1,4 -> missing=2
1,1 -> duplicate=1
2,1 -> out_of_order=1
changing raw Nchan IDs + canonical 1,2 -> clean
missing raw id -> missing_transport_id=1
bad canonical seq -> parse error=1
raw Last-Event-ID preserved exactly
```

---

# 9. Add explicit surge instrumentation

Add pool/coordinator operations equivalent to:

```text
BeginSurgeWindow()
EndSurgeWindow()
SurgeHistogram()
```

Capture a correctness snapshot at surge start/end.

Only viewers existing before surge begin are the latency observer for “existing viewers.”

Expose all surge population/deadline values directly in the machine result.

---

# 10. Repair reconnect proof end-to-end

Structured evidence must expose:

```text
selected
released
evaluated
passed
failed
missing_required
duplicates
out_of_order
```

Per-shard exact terminal values: 64/64/64/64 and all errors zero.

Global exact values: 256/256/256/256 and all errors zero.

No denominator shrink.

---

# 11. Repair restart/failover result wiring

Return measured restart pool deltas as typed data. Feed the same data to:

```text
restart_failover_gaps
restart_failover_duplicates
restart_failover_order_violations
restart_failover_failures
restart_failover_unexpected_disconnects
```

Cross-check top-level counters vs structured restart evidence.

Mismatch -> `INCONCLUSIVE`. Any actual correctness error -> `REJECT` with valid measurement.

---

# 12. Repair deep semantic proof

Machine result must include:

```text
deep_expected
deep_agreed
deep_disagreed
deep_unmatched
```

Require 256/256/0/0 per shard and 1024/1024/0/0 globally.

All schema/state/timestamp/payload/head checks must be explicit zero gates.

---

# 13. Build generator runtime monitoring

Implement a low-overhead monitor sampling about once per second.

Record:

- process/cgroup CPU;
- assigned CPU capacity;
- normalized CPU;
- cgroup throttling;
- memory/OOM;
- scheduler/ticker lag histogram/summary;
- goroutines;
- GC evidence;
- source-port/FD evidence.

Use baseline/final deltas for cumulative cgroup counters.

After the canonical-sequence parser repair, rerun the generator-only benchmark on the **actual final hot path** and preserve a new benchmark artifact.

---

# 14. Build workload-time DUT resource monitoring

Poll Nchan and Redis at phase boundaries. Capture trustworthy peak/delta values.

For restart target/spare, ensure evidence spans the literal restart/failover window.

Mandatory missing field must stay missing and invalidate evidence; never coerce nil to zero.

---

# 15. Wire publisher workload evidence into the result

Fetch `/v1/evidence` at relevant boundaries and preserve snapshots.

Derive publication rates from publisher counters and phase elapsed time, not viewer connection counters.

Validate:

```text
attempts >= successes
failures consistent with attempts
all 8 match heads advanced
non-owner published=0
owner publisher totals match canonical evidence
```

---

# 16. Repair simultaneous-global-run classifier

A global run can be `ACCEPT` only when all of these pass.

## Identity/provenance

- exactly 4 shards, ids 0..3;
- one publisher owner;
- same source SHA;
- same campaign ID;
- active contract exact;
- exact seed for run index;
- every required barrier exactly completed.

## Population

- pre-surge baseline =60k;
- +40k established by <=120s;
- post-surge aligned active >=100k;
- full-target phases sustain >=100k;
- required reconnect/restart population floors pass.

## Correctness

All mandatory sequence, surge, reconnect, restart, transport-ID, canonical parse, schema, state, agreement counters = 0.

## Latency

All four p95 gates pass.

## Scenarios

- late join exactly 256 samples and all exact;
- reconnect exactly 256 selected/released/evaluated/passed;
- burst populated;
- restart exact with measured zero deltas.

## Generator/publisher/resources

- all 4 generators valid;
- publisher valid;
- Nchan p0..p3 valid;
- spare valid;
- Redis valid.

Any mandatory metric missing -> not `ACCEPT`.

---

# 17. Repair campaign classifier

Campaign input set is exactly 3 fresh global results.

Verify:

```text
indices 0,1,2
seeds 42,43,44
same source SHA
same contract
same campaign
same target/topology
all validity.valid=true
all global verdicts ACCEPT
```

Cross-run CV uses `0.15` exactly over at least:

```text
global_active_peak
fan_out_p95_ms
late_join_p95_ms
burst_p95_ms
```

You may additionally report surge p95 CV, but do not remove existing frozen stability metrics.

Campaign verdict:

```text
missing/invalid/unstable -> INCONCLUSIVE
valid run REJECT -> REJECT
all valid/stable ACCEPT -> ACCEPT
```

---

# 18. Governance and executable tests

Update contract-governance tests so they reflect the actual active M3 contract rather than stale historical active pointers.

Prove in tests:

- one current TS contract producer;
- one matching Go producer;
- historical contracts preserved;
- v2.2.0 campaign preserved and marked non-terminal;
- CV=0.15;
- exactly 3 runs;
- seeds 42/43/44;
- exact late-join cardinality;
- slow-consumer absent from active qualification;
- 60k baseline +40k/120s ->100k target semantics;
- all latency/correctness/generator/resource gates;
- verdict precedence.

Do not rely only on regex tests of prose; add executable classifier tests.

---

# 19. Required adversarial boundary tests

## Campaign

- 2 runs -> invalid.
- 4 runs -> invalid.
- wrong seed -> invalid.
- source mismatch -> invalid.
- contract mismatch -> invalid.
- stale timestamp -> invalid.
- CV exactly .15 -> stable.
- CV > .15 -> unstable.
- one run `REJECT` -> campaign not `ACCEPT`.
- one run `INCONCLUSIVE` -> campaign `INCONCLUSIVE`.

## Late join

- 256 -> valid.
- 255 or 257 -> invalid.
- one failed probe -> non-ACCEPT.
- missing match/partition/round -> invalid.
- p95 2000 -> pass; 2001 -> reject.

## Fanout/surge/burst

- fanout 500 pass; 501 reject.
- surge p95 500 pass; 501 reject.
- burst 1000 pass; 1001 reject.
- empty required distribution -> `INCONCLUSIVE`.

## Surge population

- +39,999 established -> reject.
- +40,000 at 120000ms -> pass.
- +40,000 at 120001ms -> reject.
- start 99,999 -> reject.
- final 139,999 -> reject.
- one surge correctness error -> reject.

## Reconnect

- exact 64/shard -> pass.
- 64 released /63 evaluated -> fail.
- one gap/dup/order violation -> reject.

## Restart

- one pool duplicate -> reject.
- structured/top-level delta mismatch -> inconclusive.
- stale identity -> inconclusive.
- missing spare evidence -> inconclusive.

## Generator

- CPU >= frozen limit -> inconclusive.
- scheduler p99 >= frozen limit -> inconclusive.
- throttle delta >0 -> inconclusive.
- missing CPU metric -> inconclusive.
- invalid port/FD headroom -> inconclusive.

## DUT

- Nchan memory at/above strict threshold -> non-ACCEPT.
- OOM kill delta 1 -> reject with valid generator.
- throttle delta 1 -> inconclusive.
- missing OOM field -> inconclusive.
- missing spare metric -> inconclusive.
- Redis mandatory memory missing -> inconclusive.

## Deep semantics

- unmatched deep viewer -> reject.
- state/schema/payload agreement violation -> reject.
- missing transport ID -> reject.
- malformed canonical sequence -> reject.

---

# 20. Full regression gate before scale probes

Run all of this successfully:

```bash
cd poc/runner
npm ci
npm run typecheck
npm test
```

```bash
cd poc/loadgen
go test ./...
go test -race ./...
```

From `poc/`:

```bash
bash -n run-evidence-100k.sh
bash -n run-probe.sh
docker compose -f compose.evidence-100k.yaml config
```

Also run focused tests for:

- light canonical continuity;
- late join;
- reconnect;
- restart;
- global coordinator;
- campaign classifier;
- contract governance;
- resource monitor;
- generator monitor;
- publisher evidence.

Any failure blocks scale testing.

---

# 21. Non-qualifying scale loop

Run probes in order:

```text
1k -> 10k -> 25k -> 50k -> 75k -> 100k
```

For each probe:

1. use a unique non-qualifying ID;
2. preserve output;
3. classify failure as generator, host/kernel/network, DUT, or measurement;
4. fix the smallest causal defect;
5. commit if implementation changed;
6. rerun relevant regression tests;
7. resume from the smallest scale capable of reproducing the defect.

Never reinterpret a probe as qualifying evidence.

VPN OFF for 50k/75k/100k.

---

# 22. Final 100k prequalification gate

The final non-qualifying 100k run must use the **same active code path and thresholds** that terminal qualification will use.

It must pass all of:

```text
pre-surge baseline =60000
+40000 established <=120s
post-surge full target >=100000
zero full-population missing/dup/order
zero surge correctness deltas
zero reconnect correctness deltas
zero restart correctness deltas
all deep semantics exact
late join exact
fanout p95 <=500ms
surge p95 <=500ms
burst p95 <=1000ms
late join p95 <=2000ms
publisher workload valid
generator valid all 4 shards
p0..p3 resource evidence valid
spare evidence valid
Redis evidence valid
no OOM
no forbidden throttling
no worker ceiling/fatal death
no missing mandatory metric
```

If this fails, do not freeze terminal source. Continue the M3 engineering loop.

---

# 23. Freeze terminal source only after clean 100k prequalification

Then:

1. rerun full TS tests;
2. rerun full Go tests/race tests;
3. rerun shell/Compose validation;
4. ensure generated evidence is not accidentally part of source changes;
5. commit final M3 source + contract + tests;
6. verify clean git tree;
7. record the full SHA;
8. make no source/topology/threshold/sample-count change after this point.

Evidence can be committed later; qualifying source identity remains the frozen code SHA used to build/run.

---

# 24. Terminal qualifying campaign

Run exactly:

```text
3 global runs
seeds 42,43,44
fresh campaign ID
fresh Compose project
fresh volumes
same source SHA
same contract
same thresholds
same topology
same sample counts
```

No manual intervention between runs.

Do not retry one failed run inside the same campaign.

If a run fails:

- finish/preserve the frozen campaign;
- classify it;
- keep M3 open;
- repair under a new source commit if needed;
- use a new campaign ID next attempt.

---

# 25. Qualifying launcher hard requirements

`run-evidence-100k.sh` qualifying mode must:

- enforce exactly 3 runs;
- enforce base seed 42;
- require clean git tree;
- require valid 40-hex source SHA;
- require fresh campaign/project identity;
- require fresh evidence directory;
- refuse overwrite;
- record exact command;
- capture environment before launch;
- capture each run stdout/stderr separately;
- capture exact numeric run exit status;
- preserve each global JSON immediately;
- aggregate only after all three frozen result files exist;
- capture campaign stdout/stderr/exit;
- preserve evidence before teardown;
- compute SHA-256 checksums;
- clean Compose only after preservation;
- exit 0 only for campaign machine `ACCEPT`.

Continuing to later frozen runs after an earlier nonzero exit is allowed only if the earlier exit is preserved and campaign precedence remains intact. Do not hide it behind an unrecorded `|| true`.

---

# 26. Independent post-run verdict audit

After machine aggregation, run an independent audit that does **not** trust `campaign-result.verdict`.

It must independently recompute/check:

- source/contract/campaign identity;
- exact 3 runs and seeds;
- shard identities and publisher owner;
- phase completeness;
- exact 60k pre-surge baseline;
- +40k/120s surge to >=100k full target;
- all correctness counters;
- scenario cardinalities;
- all latency thresholds;
- generator validity;
- publisher validity;
- p0..p3/spare/Redis resource validity;
- missing/null mandatory metrics;
- per-run dispositions;
- campaign CV using 0.15;
- final campaign disposition.

Write:

```text
M3_INDEPENDENT_VERDICT_AUDIT.md
```

If it disagrees with machine `ACCEPT`, M3 is not done.

---

# 27. Evidence manifest requirements

`M3_EVIDENCE_MANIFEST.md` must include at minimum:

```text
campaign ID
source SHA
contract version
contract SHA-256
start/end UTC
host CPU/RAM/kernel
Docker/Compose versions
VPN state
exact command
run0 seed + exit + verdict
run1 seed + exit + verdict
run2 seed + exit + verdict
campaign exit + verdict
pre-surge active baseline (60k target)
surge start/additions/end/deadline
post-surge full-target active evidence
fanout p95
surge p95
burst p95
late-join p95
late-join sample count
reconnect selected/released/evaluated/passed
restart measured deltas
all correctness counters
generator health summaries
publisher health/workload
Nchan p0..p3/spare resource peaks/deltas
Redis evidence
CV per metric
worst CV
independent audit result
SHA256SUMS path
```

No prose may contradict preserved JSON.

---

# 28. Exact terminal ACCEPT checklist

Every row must be PASS.

| Gate | Terminal requirement |
|---|---|
| Active contract | new pre-frozen M3 contract; TS/Go identical |
| Source | one clean committed SHA |
| Runs | exactly 3 |
| Seeds | 42, 43, 44 |
| Shards | exactly 4, ids 0..3 |
| Publisher owner | exactly one |
| Pre-surge population | exactly 60,000 aligned |
| Surge | +40,000 established <=120s |
| Post-surge full target | >=100,000 aligned and sustained |
| Light continuity | all match viewers execute canonical continuity |
| Missing sequences | 0 |
| Duplicates | 0 |
| Out of order | 0 |
| Missing transport ID | 0 |
| Canonical parse errors | 0 |
| Surge correctness | all zero |
| Reconnect | exact 256/256/256/256; zero errors |
| Restart | exact replay + measured zero deltas |
| Deep expected/agreed | 1024/1024 |
| Deep disagreed/unmatched | 0/0 |
| Schema/state/agreement violations | 0 |
| Fanout p95 | <=500ms |
| Surge p95 | <=500ms |
| Burst p95 | <=1000ms |
| Late join p95 | <=2000ms |
| Late join count/run | exactly 256 |
| Late join count/campaign | exactly 768 |
| Steady publication rate | 8..12 accepted events/s |
| Burst publication rate | 40..60 accepted events/s |
| Publisher failures | definite=0, ambiguous=0 |
| Publisher backlog | <=1000 |
| Match heads | all 8 present/advanced |
| Generator CPU | <90% normalized |
| Generator scheduler p99 | <100ms |
| Generator throttle | delta=0 |
| Generator OOM | 0 |
| Source-port/FD | valid |
| Nchan p0..p3 | required numeric evidence valid |
| Nchan spare | required numeric evidence valid |
| Nchan memory | each peak <5,637,144,576 bytes |
| DUT OOM | delta=0 |
| Required throttling | delta=0 |
| Redis | required numeric evidence valid |
| Worker ceiling/fatal death | none |
| Global verdicts | ACCEPT / ACCEPT / ACCEPT |
| CV threshold | 0.15 |
| Worst CV | <=0.15 |
| Campaign validity | `true` |
| Campaign verdict | `ACCEPT` |
| Evidence | immutable campaign directory + checksums |
| Independent audit | PASS / agrees with ACCEPT |
| Tracker | M3 DONE only after all above |

---

# 29. Failure loop — continue automatically

Do not stop and ask whether to proceed after an intermediate failure.

```text
FAIL
 -> preserve evidence
 -> classify cause
 -> identify smallest causal defect
 -> repair current M3
 -> add regression test
 -> rerun tests
 -> rerun necessary scale ladder
 -> clean 100k prequalification
 -> freeze new source
 -> fresh 3-run campaign
```

### Generator fails first

Optimize the generator, not the DUT target. Areas may include canonical-sequence extraction, allocation, goroutine overhead, histogram contention, sampling, HTTP transport, GC pressure.

### Host/kernel/network fails first

Fix VPN, source ports, FDs, Docker routing/MTU, background load, Compose settings. Do not call host-limited evidence an architecture pass.

### DUT fails with valid generator

Continue M3 architecture repair: partition capacity/configuration, partition count, isolation, Redis/Nchan topology, failover strategy. Do not weaken criteria.

### Measurement fails

Preserve evidence, prove root cause, add regression test, create a new source commit, and bump contract version if semantics changed.

---

# 30. Do not falsely close a gap

Examples:

```text
“threshold documented”                 != closed
classifier rejects value above limit    == closed

“light client stores last seq”          != closed
light client detects gap/dup/order       == closed

“resource endpoint exists”              != closed
workload-time peaks/deltas gated         == closed

“surge attempted 40k”                   != closed
40k established by <=120s                == closed

“reconnect results are clean”           != closed
selected=released=evaluated=passed       == closed

“campaign says ACCEPT”                  != closed
pre-frozen criteria + audit agree        == closed
```

---

# 31. M3-only scope boundary

Do not spend this task polishing:

- final AWS cost model;
- final proposal prose;
- final README;
- final ZIP;
- M8 packaging/repro audit;
- M9 cleanup;
- M10 delivery.

Only minimal downstream edits are allowed to prevent stale docs from being mistaken for terminal M3 evidence, and to update the tracker after terminal M3 passes.

---

# 32. Final repository audit before declaring M3 done

Re-open the final committed source and search active code for stale semantics such as:

```text
DISPERSION_THRESHOLD_CV = 0.80
restart duplicates <= 1
qualifying GLOBAL_RUNS 3..8
late_join accepts multiple cardinalities
slow-consumer in active qualifying phases
hard-coded restart_failover_* = 0
TimingValid = true without calculation
mandatory resource nil -> 0
flat evidence overwrite paths
RoleLight returning before continuity observe
canonical correctness derived from parsed Nchan transport id
fabricated Last-Event-ID from canonical sequence
```

Any active occurrence that changes terminal semantics blocks completion. Historical files may contain historical values only when clearly scoped as historical and unused by the active classifier.

---

# 33. Tracker update only after valid terminal ACCEPT

When every terminal gate passes, update the milestone file with wording equivalent to:

```text
Milestone 3 — DONE — ACCEPT

Active M3 contract: <version>
Qualifying source SHA: <40-hex>
Campaign: <campaign-id>
Runs: 3
Seeds: 42,43,44
Per-run verdicts: ACCEPT / ACCEPT / ACCEPT
Campaign verdict: ACCEPT
Worst cross-run CV: <value> <= 0.15
Evidence manifest: <path>
Independent verdict audit: PASS
```

Keep historical notes:

```text
q5 v2.0.5 = INCONCLUSIVE
v2.2.0 post-hoc-threshold campaign = historical/non-terminal
```

Then set `M4 = NEXT`.

---

# 34. Audit loop for this execution

After each material implementation pass, re-audit the gap register G01-G25 and the terminal checklist in Section 28.

For each gap maintain machine-verifiable state:

```text
OPEN
PARTIAL
CLOSED
```

A gap becomes `CLOSED` only when:

1. code implements it;
2. tests prove both pass and adversarial fail behavior;
3. active contract matches implementation;
4. no contradictory active path remains;
5. relevant scale evidence confirms it where runtime proof is required.

Loop until:

```text
open_gaps = 0
partial_gaps = 0
terminal_checklist_failures = 0
```

Then and only then run/finalize the terminal campaign.

---

# 35. Stopping condition — 100% only

The stop condition is **not**:

- tests pass;
- 100k connects once;
- one global run accepts;
- a prose document says ACCEPT;
- the old campaign becomes green after threshold changes.

The only valid stop condition is:

```text
CURRENT M3
+ PRE-FROZEN CONSISTENT CONTRACT
+ FULL-POPULATION CANONICAL CORRECTNESS
+ VALID GENERATOR
+ VALID PUBLISHER
+ VALID WORKLOAD-TIME DUT EVIDENCE
+ CLEAN 100K PREQUALIFICATION
+ FROZEN CLEAN SOURCE SHA
+ FRESH EXACT 3-RUN CAMPAIGN
+ ACCEPT / ACCEPT / ACCEPT
+ CV <= 0.15
+ CAMPAIGN ACCEPT
+ IMMUTABLE CHECKSUMMED EVIDENCE
+ INDEPENDENT AUDIT PASS
= M3 100% COMPLETE
```

If an intermediate campaign fails, preserve it and continue the loop.

If a genuinely external hard blocker cannot be solved in the repository/local environment, return exact evidence for that blocker and leave M3 open. Never call it done.

---

# 36. Required final response from the executing coding agent

Only after Section 35 is satisfied, return:

```text
MILESTONE 3: DONE — ACCEPT
Contract: <version>
Source: <sha>
Campaign: <campaign-id>
Runs: ACCEPT / ACCEPT / ACCEPT
Worst CV: <value> <= 0.15
Evidence: <manifest-path>
Independent audit: PASS
```

Before that point, never output `MILESTONE 3: DONE — ACCEPT`.
