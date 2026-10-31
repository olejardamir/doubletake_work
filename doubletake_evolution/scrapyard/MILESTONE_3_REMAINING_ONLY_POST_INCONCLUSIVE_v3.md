# Milestone 3 — Remaining Work Only After INCONCLUSIVE Campaign

**Document status:** REMAINING WORK ONLY  
**Created:** 2026-08-20  
**Repository:** `olejardamir/EA`  
**Current repository state audited:** `7fe7bc063972625b4bd458e7fe447ef51c1edb7e`  
**Qualifying M3 source SHA:** `c89159e8882206de9fffa2b170a38d76854288ce`  
**Active contract used by q5:** `v2.0.5`  
**Completed campaign:** `m3-c89159e88822-q5`  
**Machine verdict:** `INCONCLUSIVE`  
**Original M3 execution status:** DONE  
**Purpose:** remove all completed M3 work and retain only unresolved work created by the INCONCLUSIVE result.

---

# 0. What has been removed from this plan

The following work is complete and is intentionally no longer part of this document:

- assignment/PDF synchronization;
- freezing the original v2.0.5 experiment;
- AI-instruction provenance;
- ZIP/no-`.git` compatibility repair and proof;
- fresh Compose/evidence-volume proof;
- original `GLOBAL_RUNS=3` policy;
- original seeds `42 / 43 / 44`;
- q5 qualifying launch;
- three q5 global results;
- q5 campaign aggregation;
- host/environment capture;
- command/start/end capture;
- raw evidence export;
- per-shard machine-output extraction;
- evidence identity validation;
- console/volume verification;
- checksums;
- evidence manifest;
- machine-owned `INCONCLUSIVE` classification;
- handoff of q5 to Milestone 4.

These are now historical evidence. Do not repeat them unchanged simply because the result was unfavorable.

The remaining task is narrower:

> Explain why q5 was INCONCLUSIVE, separate harness/environment failures from genuine DUT limitations, make only justified corrections, re-audit affected M2 behavior, and run a new qualifying campaign only if M4 concludes that a rerun is required.

---

# 1. Historical q5 result is immutable

```text
campaign: m3-c89159e88822-q5
source: c89159e8882206de9fffa2b170a38d76854288ce
contract: v2.0.5
runs: 3
seeds: 42, 43, 44
machine verdict: INCONCLUSIVE
```

Do not:

- delete q5;
- relabel it ACCEPT or REJECT;
- append extra runs to q5;
- replace one of its three runs;
- change thresholds or seeds after observation;
- overwrite its result JSON;
- use a later campaign as though it were part of q5.

Any future campaign must have a new campaign identity and fresh evidence storage. If executable behavior changes, it must also have a new frozen source SHA.

---

# 2. Immediate next action — M4 INCONCLUSIVE reconciliation

Do **not** immediately launch another 100,000-viewer campaign.

M4 must first classify every material q5 observation into one of these categories:

```text
A. harness defect
B. generator limitation
C. host/environment limitation
D. measurement/provenance limitation
E. genuine DUT/configuration limitation
F. architecture-significant result
```

At minimum classify:

| q5 observation | Required decision |
|---|---|
| run 0 shard fetch failure / 0 of 4 shard results | harness, control plane, transport, environment, or resource exhaustion |
| all generator shards invalid in runs 1–2 | generator/resource/host cause |
| global active peak only ~65k–66k | consequence vs independent DUT limit |
| surge established only ~30–41% | generator vs Nchan vs host vs combined |
| `32768 worker_connections are not enough` | configuration defect, frozen capacity limit, or architecture signal |
| fan-out p95 1135/1267 ms | valid DUT measurement or invalidated by generator saturation |
| very large duplicate counts | DUT behavior vs saturation/reconnect consequence |
| reconnect gaps | DUT behavior vs connection exhaustion/generator consequence |
| slow-consumer failure | independent result vs downstream effect of global collapse |
| CV 173.2% | root cause of instability |
| Redis memory metric `null` | measurement defect |
| merged burst p95 `null` | aggregation/measurement defect |
| late-join sample count 1 / 0 | scenario/aggregation defect |
| campaign restart-evidence complaint | aggregator logic defect |

For each row record:

```text
classification
evidence
cause confidence
whether it blocks ACCEPT/REJECT
whether code/config must change
whether architecture must change
```

---

# 3. R1 — Fix campaign restart aggregation semantics

The q5 manifest identifies a campaign aggregation defect:

- restart execution belongs to the publisher-owner shard;
- non-publisher shards legitimately report non-participation / empty restart paths;
- campaign aggregation currently interprets those non-owner records too strictly.

## Required correction

The campaign validator must distinguish:

```text
publisher-owner shard:
  exact structured restart evidence required

non-publisher shard:
  correct non-participation required
  fabricated restart evidence forbidden
```

Do **not** weaken publisher-owner restart correctness.

The owner must still prove:

```text
exact required sequence set
zero missing required sequences
zero duplicate substitution
zero out-of-range substitution
correct order
correct replay/recovery behavior
```

## Required adversarial tests

1. valid owner + three legitimate non-participants -> eligible to pass restart campaign check;
2. owner missing exact evidence -> fail/inconclusive;
3. owner substitutes out-of-range sequence -> fail;
4. non-owner falsely claims participation -> fail;
5. multiple publisher owners -> fail;
6. no publisher owner -> fail;
7. stale restart evidence cannot satisfy a new run.

This is a harness correction, not permission to relax the restart gate.

---

# 4. R2 — Diagnose run-0 shard fetch failure

Run 0 aborted before a complete shard result was collected.

Determine exactly:

```text
which request failed
which shard
which phase
HTTP/network error
container state
runner state
Nchan state
Redis state
host state
timeout/deadline state
Docker network state
```

Classify the cause as one of:

```text
deterministic harness race
control endpoint overload
shutdown ordering defect
inadequate timeout
Docker/network transient
resource exhaustion consequence
other reproducible defect
```

Do not add arbitrary retries that could erase a genuine measurement-plane failure.

Completion requires a focused test or reduced non-qualifying reproduction showing that the identified failure mode is fixed or explicitly handled without changing experiment semantics.

---

# 5. R3 — Restore generator validity/headroom

Runs 1–2 were invalid because all four generator shards saturated on the frozen generator-health criteria.

The corrected experiment must reach the intended workload **without weakening those health criteria**.

Do not loosen:

```text
generator CPU threshold
event-loop p99 threshold
timing-error limits
backlog limits
```

simply to produce a favorable verdict.

Investigate:

- synchronous work in hot paths;
- event parsing overhead;
- metrics/histogram overhead;
- per-connection allocation;
- reconnect bookkeeping;
- excessive logging;
- control-plane polling;
- timer scheduling;
- connection-establishment algorithm;
- Node event-loop contention;
- Docker CPU allocation;
- CPU oversubscription/pinning;
- host scheduling contention;
- whether a single-host generator+DUT topology prevents valid separation.

If generator validity requires changing topology or resource semantics, freeze a new experiment version rather than introducing a hidden runtime tweak.

Completion requires a non-qualifying validation showing enough generator headroom to attempt the full target without immediately invalidating the generator.

---

# 6. R4 — Separate Nchan capacity from generator saturation

q5 repeatedly logged:

```text
32768 worker_connections are not enough
```

and never reached 100,000 active viewers.

This may be architecture-significant, but q5 cannot cleanly call it REJECT because generator/environment validity failed first.

## Required analysis

Determine the exact tested connection-capacity model:

```text
worker_processes
worker_connections
reserved/non-viewer connections
Redis/control connections
actual open connections
per-worker distribution
FD limits
container limits
host limits
listen sockets
connection reuse behavior
```

Calculate the theoretical and practical connection ceiling for the q5 configuration and compare it with:

```text
observed active peak
warnings
surge establishment rate
connection failures
Nchan resource state
generator state
```

## Branches

### Accidental configuration ceiling

If `32768` is an accidental configuration ceiling, correct it only if consistent with the intended design/resource envelope. Then re-audit M2 and run a new M3 campaign.

### Intentional/frozen limit makes 100k impossible

Treat this as architecture-significant. M4 must decide whether the design needs:

```text
more Nchan workers
different instance/fleet shape
different connection distribution
different fan-out technology
different topology
```

### Secondary symptom

If the warning is only a downstream symptom, prove that causally rather than asserting it.

---

# 7. R5 — Restore Redis mandatory resource evidence

q5 had:

```text
Redis memory_used_bytes = null
```

Trace the complete metric path:

```text
Redis INFO collection
parser
resource monitor
per-shard result
global merge
campaign merge
container/cgroup source
field naming/schema
null propagation
```

A reduced non-qualifying run must prove the Redis memory value is:

```text
present
numeric
correctly scoped
merged correctly
carried into the global result
available to the classifier where required
```

Do not hard-code a value.

---

# 8. R6 — Restore burst metric aggregation

q5 did not produce a valid merged:

```text
burst_fan_out_p95_ms
```

Trace:

```text
burst scenario
per-shard histogram
per-shard machine result
global histogram merge
global p95 calculation
campaign summary
```

Focused tests must prove:

- non-empty participating histograms merge correctly;
- global p95 comes from the merged distribution;
- empty/non-participating shards cannot fabricate zero latency;
- overflow/error conditions remain visible;
- missing burst evidence cannot be interpreted as PASS.

---

# 9. R7 — Restore meaningful late-join evidence population

q5 produced effectively unusable late-join populations:

```text
run 1: 1 histogram sample
run 2: 0 histogram samples
```

Determine why:

```text
scenario eligibility
population state before late join
connection collapse
sample recording
histogram merge
publisher ownership
phase timing
failed-connection filtering
global alignment
```

A reduced non-qualifying run must show that the late-join scenario produces a non-trivial intended cohort while preserving frozen late-join semantics.

If the current contract never froze a minimum sample count, M4/M1 must explicitly decide whether one is required before the next qualifying campaign.

---

# 10. R8 — Capture exact launcher exit status next time

q5 preserved only:

```text
process exit status = non-zero
```

The exact numeric code was not captured because the launcher was detached with `setsid`.

The machine verdict remains authoritative, so this does not rewrite q5. For the next campaign, use a detached wrapper that records:

```text
start timestamp
launcher PID
exact command
stdout/stderr
exact numeric exit code
end timestamp
```

without allowing a supervising tool timeout to kill the campaign.

Non-qualifying tests should prove capture for:

```text
exit 0
known non-zero
signal/interruption
```

---

# 11. R9 — Re-check stale-evidence safeguards after corrections

Any corrected launcher/aggregator must still guarantee:

```text
new campaign identity
fresh result storage
no prior global-result-N.json accepted
no prior campaign-result.json accepted
source SHA matches frozen source
campaign identity matches current campaign
run indexes are exact
seeds are exact
all expected result files are freshly generated
```

Do not rely only on human cleanup.

---

# 12. M2 re-audit trigger

Any correction to these paths requires M2 regression re-audit before the next qualifying M3 run:

```text
runner behavior
scenario logic
generator logic
Nchan config
Redis instrumentation
coordinator
campaign aggregator
launcher
Compose topology
resource envelopes
classification logic
metric schema
restart semantics
source/provenance handling
```

Minimum re-audit:

```text
typecheck
full automated test suite
focused adversarial tests for changed paths
portable smoke
relevant reduced coordinated probe
contract/code traceability review
```

If a correction changes a frozen experiment decision instead of merely fixing implementation to match it:

```text
freeze a new canonical contract version
update traceability
update parameter/evidence ledger
then re-audit M2
```

Do not materially change v2.0.5 semantics while keeping the v2.0.5 label.

---

# 13. New experiment freeze — only if M4 requires a rerun

Before a corrected qualifying campaign:

1. freeze corrected source SHA;
2. freeze contract version;
3. freeze run count before observation;
4. freeze seed policy before observation;
5. freeze topology;
6. freeze resource envelopes;
7. freeze any new sample-validity rule;
8. choose a new campaign identity;
9. prove fresh evidence storage;
10. record exact qualifying command.

Do not reuse:

```text
m3-c89159e88822-q5
```

Preferred default if M4/contract does not require a policy change:

```text
GLOBAL_RUNS=3
BASE_GLOBAL_SEED=42
seeds=42,43,44
```

Reusing the same predetermined seeds in a **new corrected campaign** is acceptable because q5 remains preserved and the implementation/source has changed.

Do not choose a different seed set because the original seeds produced an unfavorable outcome.

---

# 14. New qualifying campaign gate

A new campaign is qualifying only if:

```text
corrected source frozen
contract frozen
M2 re-audit passed
fresh campaign identity
fresh evidence storage
exact command captured
exact start/end captured
exact exit code captured
all frozen runs execute
all expected global results are current
campaign result is current
all identities match
generator validity is defensible
mandatory Redis evidence present
restart aggregation semantics correct
burst evidence present
late-join evidence population defensible
no hidden runtime override changes the experiment
```

---

# 15. Corrected campaign verdict handling

The machine verdict remains authoritative.

## ACCEPT

Only if the experiment is valid, every frozen ACCEPT gate passes, mandatory evidence exists, and cross-run stability passes.

Do not translate ACCEPT into proof of the full production system.

## REJECT

Use REJECT when the experiment is valid and an architecture-critical frozen reject gate fails.

Do not rerun merely because the result is unfavorable.

## INCONCLUSIVE

If the corrected campaign is again INCONCLUSIVE:

- preserve it;
- identify the new blocker;
- do not append favorable runs;
- return to M4/M2 only for a genuinely correctable cause.

Repeated INCONCLUSIVE campaigns are evidence that the experiment may be too ambitious for the available local environment. M4 may then need to choose a smaller locally defensible experiment that still tests the architecture-invalidating risk, consistent with the assignment.

---

# 16. Assignment-scope guardrail

Do not turn this corrective loop into a production implementation.

Still out of scope:

```text
Next.js product UI
AWS deployment
real provider integration
real multi-region traffic
production CloudFront deployment
real monthly infrastructure spend
full production observability stack
authentication/accounts
```

The assignment asks for the smallest local measured experiment that tests the riskiest locally testable architecture assumption.

---

# 17. Remaining-work execution order

```text
1. M4 classify q5 root causes.
2. Separate harness/environment effects from architecture evidence.
3. Fix restart campaign aggregation.
4. Diagnose/fix run-0 shard fetch failure.
5. Restore generator validity/headroom.
6. Analyze Nchan worker_connections ceiling.
7. Restore Redis mandatory resource evidence.
8. Restore burst merged metric.
9. Restore meaningful late-join population.
10. Add exact detached-launch exit-status capture.
11. Re-check stale-evidence safeguards.
12. Decide whether contract semantics changed.
13. If changed, freeze a new canonical contract version.
14. Re-run M2 regression/traceability audit.
15. Freeze corrected source/config/policy.
16. Run reduced non-qualifying validation.
17. Launch a new qualifying campaign only after all gates pass.
18. Preserve machine verdict without override.
19. Hand corrected result back to M4.
```

---

# 18. Do not do these things

```text
do not rerun q5 unchanged
do not add a fourth q5 run
do not discard run 0
do not keep only runs 1 and 2
do not change seeds because 42/43/44 were bad
do not raise acceptance thresholds
do not weaken generator-validity thresholds
do not ignore missing Redis evidence
do not treat one late-join sample as adequate
do not treat null burst p95 as zero
do not manually convert INCONCLUSIVE to REJECT
do not manually convert INCONCLUSIVE to ACCEPT
do not raise Nchan limits without documenting why
do not call worker_connections exhaustion a proven architecture failure before validity is separated
do not call generator saturation proof that Nchan is fine
do not change frozen semantics under the old version label
do not delete q5 evidence
```

---

# 19. Remaining-work completion gate

This corrective document reaches a terminal state in one of two ways.

## Terminal A — M4 determines no M3 rerun is needed

M4 concludes q5 already provides enough evidence to revise/reject/reframe the architecture or to choose a different locally testable assumption.

Then q5 remains historical INCONCLUSIVE evidence and no artificial rerun is performed.

## Terminal B — corrected qualifying campaign completes

A new campaign:

```text
uses corrected audited code
has a new campaign identity
has valid generator/environment evidence
produces complete mandatory metrics
produces machine ACCEPT / REJECT / INCONCLUSIVE
preserves complete evidence
is handed back to M4
```

If it is again INCONCLUSIVE, continue only for a clearly identified correctable cause.

---

# 20. Current status

```text
Original M3 planning:                   DONE
Original M3 qualifying execution:       DONE
Original M3 evidence preservation:      DONE
Original q5 verdict:                    INCONCLUSIVE
Architecture validated by q5:           NO
Architecture rejected by q5:            NO

Remaining corrective work:
R1  M4 root-cause classification        OPEN
R2  restart aggregation defect          OPEN
R3  run-0 shard fetch failure           OPEN
R4  generator validity/headroom         OPEN
R5  Nchan capacity separation           OPEN
R6  Redis memory evidence               OPEN
R7  burst metric aggregation            OPEN
R8  late-join sample population         OPEN
R9  exact process exit capture          OPEN
R10 stale-evidence safeguards recheck    OPEN

Immediate next action:
MILESTONE 4 INCONCLUSIVE RECONCILIATION
```

---

# 21. Stop condition

Do not begin Milestone 5, final proposal writing, final README writing, or final ZIP packaging on the assumption that Nchan + Redis + SSE passed.

The immediate next step is:

```text
M4: explain q5
```

Only after M4 chooses the corrective branch should the experiment be changed or rerun.
