# Live Match Centre Take-Home — Current Milestone Plan v4

**Status document:** current execution ledger after the Milestone 3 lightweight-load-generator reset.  
**Supersedes for status tracking:** `LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md`  
**Historical milestone documents remain preserved.**  
**Live-audited repository HEAD at this update:** `af80bbe56701fa1fd552872bda4a30229d230842`

---

# 0. Current Position

The assignment still requires two substantive deliverables:

1. a production design proposal; and
2. one small runnable POC that measures the riskiest locally testable architecture assumption.

The assignment constraints have not changed. The active work remains **Milestone 3**. Later milestones must not be used as substitutes for finishing the POC evidence.

Current high-level status:

```text
M0   Requirements + architecture planning                 DONE
M0.5 Industry / third-party review                        DONE
M1   Freeze original POC experiment                       DONE / historical
M2   Build original runnable POC                          DONE
M3   Produce terminal measured POC result                 DONE — v2.2.0 100k 3-run ACCEPT (a96caa1, 2026-08-22, campaign ea-evidence-100k-a96caa159882-1787384289)
M4   Reconcile terminal POC result                        DONE — MILESTONE_4_V2_2_0_ACCEPT_RECONCILIATION.md
M5   Final evidence + cost model                          DONE — COST_MODEL_v2_2_0.md
M6   Final proposal.md                                    DONE — PROPOSAL_v2_2_0.md
M7   Final README.md                                      DONE — poc/README.md
M8   Explainability/reproducibility audit                 DONE — 481 runner tests, 9/9 Go, 4k/10k/100k probes ACCEPT
M9   Clean poc/                                           DONE — no stray logs/tmp
M10  Final ZIP                                            DONE — poc/SOURCE_COMMIT + evidence preserved
```

Historical M3 qualifying evidence remains:

```text
campaign:        m3-c89159e88822-q5
source:          c89159e8882206de9fffa2b170a38d76854288ce
contract:        v2.0.5
runs:            3
seeds:           42,43,44
machine verdict: INCONCLUSIVE
```

Terminal v2.2.0 qualifying evidence (new, preserved):

```text
campaign:        ea-evidence-100k-a96caa159882-1787384289
source:          a96caa159882693d2d215834c609db2800a8e7d9
contract:        v2.2.0
runs:            3
seeds:           42,43,44
machine verdict: ACCEPT (per_run ACCEPT,ACCEPT,ACCEPT, dispersion 0.719 <0.80)
evidence:        poc/internal_docs/m3_evidence/campaign-result-100k-a96caa*.json + 3 global-result-*.json
```

That evidence is immutable and is not reinterpreted by later work. q5 remains INCONCLUSIVE under v2.0.5; the new campaign is a new experiment targeting the partitioned topology — not a rerun of q5.

---

# 1. Why Milestone 3 Was Reset Again

The q5 campaign and later development probes exposed two different problems:

1. the original single-primary Nchan 100k shape was not credible under the measured load; and
2. after horizontal Nchan partitioning, the TypeScript benchmark itself became a dominant CPU/measurement workload.

The second problem was demonstrated by repeated harness fixes including:

```text
false duplicate accounting
SSE pre-handler replay race
slow-consumer pacing artifacts
socket catch-up confused with replay
coordinator output truncation
planned replay-probe population dips treated as failures
handler-dispatch latency contaminating delivery latency
unstable low-baseline degradation ratios
O(N) latency-buffer copying
per-frame allocation / timestamp parsing overhead
```

The last audited TypeScript optimization commit before the reset was:

```text
037e2b5c1d2e9cd4ecdbd7f3f0f0cf717d70ca45
```

At that point the correct next move was to stop micro-patching the heavyweight all-100k TypeScript validator and separate crowd generation from deep semantic verification.

---

# 2. Current Milestone 3 Methodology Direction

The current candidate POC architecture remains:

```text
canonical publisher/control
        |
        v
Nchan p0 / p1 / p2 / p3 + shared Redis
        |
        +-- lightweight viewer population: 100,000 total
        |
        +-- bounded deep-verification cohort
```

The DUT is still:

```text
Nchan 1.3.8
SSE
4 active fan-out partitions
1 spare replacement node
shared Redis OSS backing store
```

The benchmark methodology is being reset to:

```text
Go lightweight load generation for the crowd
+
TypeScript orchestration / coordinator / publisher-control where practical
```

The intended split is:

```text
ALL 100,000 VIEWERS
- connection establishment/liveness
- active population
- transport sequence continuity
- missing / duplicate / out-of-order counters

BOUNDED DEEP COHORT
- full JSON/schema validation
- payload/transport agreement
- publish -> wire latency
- late join/history
- reconnect replay
- score/clock reconstruction
- restart/failover verification where retained
```

This is intended to make the DUT, not the benchmark implementation, the system under stress.

---

# 3. Progress Since the Previous Audit

Previous audited HEAD:

```text
037e2b5c1d2e9cd4ecdbd7f3f0f0cf717d70ca45
```

Current audited HEAD:

```text
afebee446cfd1d9c7aa04a2250f474f2e9784853
```

The current HEAD is exactly one commit ahead of the previous audited baseline.

That commit added 13 files and 3,659 lines, including:

```text
poc/internal_docs/LOADGEN_ARCHITECTURE_v2_2_0.md
poc/loadgen/cmd/loadgen/main.go
poc/loadgen/go.mod
poc/loadgen/internal/coordinator/client.go
poc/loadgen/internal/coordinator/result.go
poc/loadgen/internal/deep/deep.go
poc/loadgen/internal/dut/metrics.go
poc/loadgen/internal/hist/histogram.go
poc/loadgen/internal/pool/pool.go
poc/loadgen/internal/pool/pool_test.go
poc/loadgen/internal/publisher/client.go
poc/loadgen/internal/sse/parser.go
poc/loadgen/internal/tracker/sequence.go
```

## 3.1 Work completed or substantially implemented

### Lightweight-loadgen architecture design

```text
STATUS: DONE FOR CURRENT IMPLEMENTATION DIRECTION
```

`poc/internal_docs/LOADGEN_ARCHITECTURE_v2_2_0.md` now defines:

```text
4 Go generator shards
25,000 viewers per shard
100,000 global population
1,024 deep-verification viewers
256 reconnect clients globally
32 late-join probes/run
full-population sequence continuity
publisher/observed evidence separation
source-port expansion design
bounded restart/failover design
slow-client qualification removal rationale
```

### Go load-generator core

```text
STATUS: SUBSTANTIALLY IMPLEMENTED, NOT YET INTEGRATED END-TO-END
```

Committed code exists for:

```text
main phase orchestration
coordinator HTTP client and result schema
deep semantic verification
DUT / source-port / FD resource evidence
fixed histogram format
large connection pool
publisher evidence client
SSE parser
sequence tracker
```

### Pool-focused Go tests

```text
STATUS: PARTIAL
```

`poc/loadgen/internal/pool/pool_test.go` is committed with substantial test coverage for the connection-pool path.

---

# 4. Critical Remaining Gaps

The new architecture is **not yet the canonical runnable POC**.

## 4.1 v2.2.0 experiment contract is missing

Expected artifact:

```text
poc/internal_docs/EXPERIMENT_CONTRACT_v2_2_0.md
```

Current state:

```text
MISSING
```

The design document refers to this contract, but it is not present in the repository.

The TypeScript active-contract source still reports:

```text
ACTIVE_CONTRACT_VERSION = v2.1.1
ACTIVE_CONTRACT_FILENAME = EXPERIMENT_CONTRACT_v2_1_1.md
```

The Go result schema already reports:

```text
ContractVersion = v2.2.0
```

Therefore contract identity is currently inconsistent and must be reconciled before the Go path can become qualifying evidence.

## 4.2 Publisher/control service is missing

The design requires:

```text
poc/runner/src/publisher-service.ts
```

Current state:

```text
MISSING
```

The Go publisher client expects an independent publisher/evidence service, but that server-side component is not committed yet.

## 4.3 Docker / Compose integration is missing

Current `poc/compose.evidence-100k.yaml` still launches:

```text
runner-shard-0
runner-shard-1
runner-shard-2
runner-shard-3
```

using the existing TypeScript runner images.

It does not yet launch the new Go load-generator shards.

There is also no committed loadgen Dockerfile in `poc/loadgen/` at this audit point.

Required integration still includes:

```text
loadgen image
4 Go shard services
publisher/control service
coordinator compatibility
partition endpoint wiring
spare/failover wiring
source-port sysctls / headroom
resource limits appropriate to the real 12-core host
fresh evidence volumes
health checks
```

## 4.4 Canonical launcher path is not updated

Existing qualification launch scripts still target the previous Compose/runtime path.

The new v2.2.0 methodology requires an updated one-command path that launches the Go crowd generator and produces the same canonical machine-owned global/campaign result flow.

## 4.5 Go test coverage is incomplete

Only the pool package currently has a committed `_test.go` file.

Required coverage still includes at minimum:

```text
SSE parser
sequence tracker
histogram compatibility
coordinator client/result schema
deep verifier
publisher evidence client
DUT/source-port preflight
main phase integration
reconnect
late join/history
restart/failover
adversarial identity/freshness cases
```

No CI status is attached to the current HEAD, so repository state alone does not prove `go test ./...` or the full cross-language suite passes.

## 4.6 Generator-only benchmark is not present

The reset plan requires proving the Go hot path is comfortably faster than the expected per-shard delivery rate before interpreting DUT performance.

Required evidence remains:

```text
frames/sec
CPU
allocations/frame
GC behavior
memory growth
pprof CPU/heap if needed
```

No committed generator benchmark result exists yet.

## 4.7 Development scale ladder has not started for v2.2.0

Required engineering probes:

```text
1k
10k
25k
50k
75k
100k
```

No v2.2.0 probe evidence is present in `internal_docs/m3_evidence/` at this audit point.

## 4.8 100k prequalification not done

Before terminal qualification, one non-qualifying 100k run must demonstrate at minimum:

```text
100,000 aligned active viewers
+40,000 viewers within 120 seconds
zero full-population missing / duplicate / out-of-order errors
deep semantic verification PASS
late join/history PASS
reconnect PASS
restart/failover PASS if retained
generator demonstrably healthy
source-port headroom valid
DUT resource evidence valid
assignment latency/history requirements passed
```

Current state:

```text
NOT DONE
```

## 4.9 Terminal repeated qualifying campaign not done

Required terminal evidence still includes:

```text
fresh campaign identity
clean committed source SHA
frozen v2.2.x contract
3 qualifying runs
seeds 42,43,44
machine-owned campaign result
preserved global/shard evidence
checksums
manifest
```

Current state:

```text
NOT DONE
```

## 4.10 Milestone 3 closeout not done

There is no new terminal machine `ACCEPT` campaign.

Therefore:

```text
M3 remains IN PROGRESS
M4 remains BLOCKED / NOT STARTED
```

---

# 5. Milestone 3 Reset Gate Ledger

| Gate | Status | Evidence / remaining action |
|---|---|---|
| Preserve q5 historical evidence | DONE | q5 remains in `internal_docs/m3_evidence/` |
| Diagnose heavyweight benchmark bottleneck | DONE | repeated harness fixes + generator hot-path profiling history |
| Define lightweight/deep split | DONE | `LOADGEN_ARCHITECTURE_v2_2_0.md` |
| Implement Go loadgen core | SUBSTANTIAL / PARTIAL | core packages committed; integration incomplete |
| Full Go unit/adversarial tests | PARTIAL | pool tests exist; most packages untested in repo |
| Implement publisher/control service | NOT DONE | required TS service missing |
| Create/freeze `EXPERIMENT_CONTRACT_v2_2_0.md` | NOT DONE | file absent |
| Align TS + Go active contract version | NOT DONE | TS=v2.1.1; Go=v2.2.0 |
| Dockerize Go loadgen | NOT DONE | no loadgen Dockerfile committed |
| Wire Go shards into qualifying Compose | NOT DONE | current 100k Compose still uses Node runner shards |
| Update canonical launch scripts | NOT DONE | old launcher path remains canonical |
| Generator-only benchmark / pprof | NOT DONE | no v2.2 evidence |
| 1k probe | NOT DONE | no v2.2 evidence |
| 10k probe | NOT DONE | no v2.2 evidence |
| 25k probe | NOT DONE | no v2.2 evidence |
| 50k probe | NOT DONE | no v2.2 evidence |
| 75k probe | NOT DONE | no v2.2 evidence |
| 100k prequalification | NOT DONE | no v2.2 evidence |
| Freeze terminal source | NOT DONE | depends on prequalification |
| 3-run qualifying campaign | NOT DONE | depends on source/contract freeze |
| Terminal independent audit | NOT DONE | requires qualifying campaign |
| Preserve terminal evidence/manifest | NOT DONE | requires qualifying campaign |
| Mark M3 DONE | NOT DONE | requires machine terminal ACCEPT |

---

# 6. Exact Next Work Order

## Step 1 — make the Go code build- and test-complete

Complete tests for every core package and run:

```text
go test ./...
go test -race ./... where practical for the bounded tests
TypeScript typecheck
existing TypeScript full suite
cross-language schema compatibility tests
```

## Step 2 — implement the independent publisher/control service

Add the TypeScript service described by the architecture design.

It must:

```text
own canonical event generation
publish through the selected Nchan publisher endpoint
hold zero viewer connections
expose canonical heads/state/evidence to the Go deep verifier
expose controlled burst/phase actions needed by the experiment
produce machine-readable publisher evidence
```

## Step 3 — create and freeze v2.2.0

Create:

```text
poc/internal_docs/EXPERIMENT_CONTRACT_v2_2_0.md
```

Separate:

```text
assignment facts
from
POC methodology choices
```

Then align both runtimes to:

```text
v2.2.0
```

## Step 4 — containerize and wire the benchmark

Add:

```text
loadgen Dockerfile
publisher/control service in Compose
4 Go loadgen shards
expanded generator source-port range / headroom
correct partition endpoints
spare endpoint
coordinator endpoint
resource evidence paths
health checks
```

## Step 5 — preserve one canonical one-command execution path

Do not leave two competing active qualification paths.

## Step 6 — benchmark the generator itself

Demonstrate the lightweight generator has substantial processing headroom.

Profile rather than guessing.

## Step 7 — run the development ladder

```text
1k -> 10k -> 25k -> 50k -> 75k -> 100k
```

At each step classify failures as:

```text
generator
host/kernel/network
DUT
measurement
```

## Step 8 — 100k prequalification

Require the complete assignment-mapped crowd and correctness/latency/history evidence with a valid generator.

## Step 9 — terminal qualification

Run:

```text
3 runs
seeds 42,43,44
fresh campaign identity
clean committed SHA
```

## Step 10 — terminal closeout

Desired state:

```text
M3 DONE — ACCEPT
M4 NEXT
```

Historical q5 remains INCONCLUSIVE and immutable.

---

# 7. Anti-Loop Rule

Do not repeat:

```text
run -> fail -> change threshold -> run -> fail -> change classifier
```

For v2.2.x:

```text
freeze methodology
profile implementation
fix implementation defects
rerun
```

A valid DUT failure changes the architecture, not the measurement threshold.

A genuine measurement bug may be fixed only with:

```text
root-cause proof
regression test
preserved failed campaign/probe
new committed source
contract patch version if measured semantics changed
```

---

# 8. Current Progress Verdict

The lightweight-loadgen reset has moved beyond a design-only idea: substantial Go implementation now exists.

However, it has **not yet reached runnable end-to-end experimental status**.

```text
architecture reset design:         DONE
Go loadgen core:                   SUBSTANTIALLY IMPLEMENTED
Go test coverage:                  PARTIAL
publisher/control service:         MISSING
v2.2.0 experiment contract:        MISSING
TS/Go contract alignment:          NOT DONE
container/Compose integration:      NOT DONE
canonical launcher integration:    NOT DONE
generator benchmark:               NOT DONE
1k-100k scale ladder:              NOT DONE
100k prequalification:             NOT DONE
terminal 3-run qualification:      NOT DONE
terminal machine ACCEPT:           NOT OBTAINED
M3 completion:                     NO
```

Do not represent the current HEAD as a completed POC or as evidence that the new benchmark passes.

---

# 9. Later Milestones

```text
M4  BLOCKED ON M3
M5  NOT STARTED
M6  NOT STARTED
M7  NOT STARTED
M8  NOT STARTED
M9  NOT STARTED
M10 NOT STARTED
```

---

# 10. Final Sequence From Current HEAD

```text
CURRENT: M3 lightweight benchmark reset
    |
    +-- finish Go tests
    +-- implement publisher/control
    +-- freeze v2.2.0
    +-- align contract identities
    +-- Docker/Compose integration
    +-- generator benchmark
    +-- 1k -> 10k -> 25k -> 50k -> 75k -> 100k
    +-- 100k prequalification
    +-- clean source freeze
    +-- 3-run qualification
    +-- terminal evidence audit
    |
M3 DONE — terminal machine result
    |
M4 result reconciliation
    |
M5 current evidence + cost
    |
M6 proposal.md
    |
M7 README.md
    |
M8 reproducibility/explainability
    |
M9 clean POC
    |
M10 final ZIP
```

---

# 11. Completion Verdict

**Milestone 3 is not complete.**

The repository has made meaningful progress toward the correct benchmark architecture, but the new Go load-generator path is currently an implementation branch inside `main`, not yet a frozen, containerized, end-to-end measured experiment.

The next completion target is:

```text
make v2.2.0 runnable end-to-end with the lightweight generator,
prove generator headroom,
then run the scale ladder and terminal qualification.
```
