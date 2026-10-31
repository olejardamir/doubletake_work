# Milestone 2 — Close Remaining Gap to 100% — Remaining Work Only v5

Repository:

https://github.com/olejardamir/EA

Repository state audited for this revision:

```text
main = 1fc2b57d4df59ad226ed3991459fe783decd8de0
```

This is the trimmed continuation of:

```text
MILESTONE_2_CLOSE_GAP_REMAINING_ONLY_v4.md
```

Requirements that are demonstrably complete in the current repository have been removed.

This file contains only Milestone 2 work that is still incomplete, falsely claimed complete, internally contradictory, or capable of producing materially incorrect evidence.

Do not redo completed work unless a regression proves it broken.

Work sequentially:

```text
inspect current code
-> reproduce/confirm the remaining defect
-> fix the highest-impact defect
-> add focused adversarial test
-> run regression tests/typecheck
-> validate actual runnable path
-> update governance/traceability only after executable proof
-> repeat until no material Milestone 2 defect remains
```

Do not execute the final Milestone 3 evidence campaign.

---

# 1. Objective

Milestone 2 must end as:

> A complete, correct, locally runnable, reproducible Nchan + Redis OSS + SSE experiment harness with no known material implementation, measurement, orchestration, classification, provenance, traceability, or governance defect remaining.

Target state:

```text
Milestone 1 = DONE
Milestone 2 = DONE — 100%
Milestone 3 = NEXT
```

A valid Milestone 2 harness does not need to force Nchan + Redis to produce an `ACCEPT`.

A real DUT failure may produce `REJECT`.

An invalid generator/environment/measurement must produce `INCONCLUSIVE`.

The final full-scale qualifying campaign belongs to Milestone 3, not this milestone.

---

# 2. Work confirmed complete — do not reimplement

The following broad v4 gaps are now materially closed in executable code and are removed from the remaining-work list.

Do not recreate them merely because older prompts or stale documentation still mention them.

## 2.1 Late join

Current machinery now has:

```text
correct application clock schema
full retained required range from independently reset run history
expected first/last/count frozen independently of receive data
missing-prefix detection
unique required-range counting
score/clock/head reconstruction as PASS gates
buffer proof covering the actual retained range + live margin + safety margin
atomic per-match canonical prefill
<=2s catch-up gate
scenario active-population output
```

Do not restore the old v4 late-join defects.

## 2.2 Coordinated 100k generator topology

Current machinery now has:

```text
4 distinct bridge-network generator shards
25,000 viewers per shard
100,000 exact global target
per-shard source-port/TIME_WAIT/safety headroom proof
one coordinator-issued experiment_run_id
ordered global phase start/end barriers
one authoritative publisher-owner shard
non-owner publishers disabled/invalid if they publish
time-aligned global active-population samples
time-aligned attempt/establishment/failure rates
lossless serialized-histogram merge
one simultaneous-global-run verdict
3–8 repeated simultaneous-global runs
separate campaign aggregate
campaign dispersion rule
```

Do not restore the old assertion that the four shards are independent experiments. That was true at the previous audit and is no longer true.

## 2.3 Evidence entrypoints

Current paths now distinguish:

```text
RUN_MODE=evidence
RUN_MODE=coordinated-shard
```

and the coordinated 100k launcher drives the coordinator/shards rather than four independent evidence suites.

Do not re-add the old `RUN_PROFILE=evidence without RUN_MODE=evidence` blocker as a broad defect.

## 2.4 Nginx/topology preflight

Current machinery now:

```text
reads actual Nginx master/worker RLIMIT_NOFILE from /proc/<pid>/limits
bounds usable per-worker capacity by worker_connections and worker RLIMIT
reserves per-worker FD headroom
checks aggregate 100k Nginx capacity
checks primary Nchan as the actual live-viewer DUT
checks the frozen 4-CPU primary Nchan requirement
uses actual source-port range
```

Do not restore the old helper-process RLIMIT or 2-CPU-rule defects.

## 2.5 Reconnect

Current reconnect machinery now:

```text
captures active population before cohort removal
freezes target after the disconnected publication window
tracks actual subscription re-establishment per intended client
counts unique required in-range sequences
requires all intended clients to re-establish
requires exact frozen replay count
requires target reached
requires no missing prefix
requires no gaps/duplicates/out-of-order
reports structured per-client evidence
keeps post-catch-up live frames out of required replay counts
```

Do not restore the broad v4 reconnect false-PASS section unless a new regression proves it broken.

## 2.6 Surge

Current machinery now:

```text
uses the full resolved surge duration
removes the old unfrozen 80% sustained-rate tolerance
distinguishes invalid generator/environment -> INCONCLUSIVE
maps healthy-generator DUT surge failure -> REJECT
has a real connections_dropped producer
```

Do not re-add the old surge section.

## 2.7 Slow consumer

Current machinery now has:

```text
independent offered source from accepted publisher-head deltas
actual application-consumption count
dedicated immediate healthy baseline
per-client 1.6s–2.4s pacing validation
15-second slow phase
10-second recovery window
>=95% replay recovery
at least one client must miss live traffic
frozen memory boundedness thresholds
backpressure requires disconnect or independent backlog + meaningful Nchan memory growth
null/invalid measurement -> INCONCLUSIVE
```

Do not restore the old offered==consumed or ungated-pacing defects.

## 2.8 Resource measurement

Current machinery now has:

```text
service-local CPU quota + period
cpuset-aware effective CPU capacity
separate runner/Nchan/Redis normalization
Nchan initial polling/ready gate
run-scoped Nchan peak from max sampled memory.current
container-lifetime Nchan memory.peak retained separately
Redis cgroup quota/period/cpuset observation
campaign max/null-preserving resource aggregation
shared DUT resource evidence observed once in the global result
```

Do not restore the old runner-quota-used-for-all-services or Nchan-lifetime-peak-as-run-peak defects.

## 2.9 Disconnect lifecycle

Current terminal handling now uses active-pool removal as the exact-once guard.

Repeated terminal notifications do not decrement/attribute/drop the same active entry repeatedly.

Do not restore the old exact-once disconnect section.

## 2.10 Cross-shard/cross-run aggregation distinction

Current implementation now has separate dimensions:

```text
shard result
-> simultaneous global-run aggregate
-> repeated global runs
-> campaign aggregate
```

Do not send simultaneous shards through the old repeated-run `aggregateRuns()` path.

This broad v4 gap is closed.

---

# 3. Remaining gaps

## 3.1 The active experiment contract has two contradictory v2.0.4 sources of truth

This is now the largest governance defect.

Two different files both present themselves as the active/frozen v2.0.4 contract, but they do not describe the same experiment.

### A. Top-level active contract is stale relative to executable code

Current milestone source of truth points to:

```text
internal_docs/LIVE_MATCH_CENTRE_POC_EXPERIMENT_CONTRACT_v2_0_4.md
```

That file is marked:

```text
Status: FROZEN
Contract Version: v2.0.4
```

but its multi-shard correction still freezes approximately:

```text
4 shards
28,000 connections per shard
112,000 aggregate connections
~64k ephemeral ports per shard
RUN_MODE=single per shard
each shard classifies independently
all shards ACCEPT -> global ACCEPT
```

Those statements are no longer the executable experiment.

Current executable coordinated path is approximately:

```text
4 shards
25,000 connections per shard
100,000 exact global target
28,232-ish typical source-port range is explicitly budgeted
28,076 ports required per shard under the frozen headroom model
RUN_MODE=coordinated-shard
one experiment_run_id
one publisher-owner
all phase boundaries globally coordinated
one simultaneous-global-run aggregate/verdict
3–8 repeated global runs
separate campaign aggregate/verdict
```

The top-level v2.0.4 also describes the slow-client pacing gate in older terms such as:

```text
per_client_medians_all_above_1s
```

while current executable/internal contract requires the tighter frozen range:

```text
1600ms <= each intended client's median <= 2400ms
```

### B. A second v2.0.4 is materially more accurate

Current:

```text
poc/internal_docs/EXPERIMENT_CONTRACT_v2_0_4.md
```

also says:

```text
Status: FROZEN — active contract for Milestone 3
```

and correctly describes much of the current coordinated implementation:

```text
4 x 25,000
one coordinator
one publisher-owner
global barriers
aligned samples
histogram distribution merge
run isolation
late-join 1..target retained range
structured reconnect
slow-client 1.6–2.4s pacing
run-scoped Nchan memory
service-local CPU normalization
8-event non-empty restart ranges
simultaneous global result
repeated global campaign aggregation
```

The repository therefore has two different documents with the same active frozen version number.

That is not a valid frozen source-of-truth chain.

### C. Do not edit either frozen v2.0.4 in place

Because both documents already claim to be frozen, do not silently mutate their result-affecting semantics.

Create one unambiguous canonical successor, for example:

```text
LIVE_MATCH_CENTRE_POC_EXPERIMENT_CONTRACT_v2_0_5.md
```

The exact filename may follow the repository's established convention, but there must be only one canonical active successor.

The successor must:

```text
supersede the ambiguous/stale v2.0.4 active state
preserve both old v2.0.4 files as historical evidence
state which prior file contained the executable semantics
record OLD / NEW / WHY
freeze exact 4 x 25,000 topology
freeze exact source-port headroom model
freeze coordinated-shard lifecycle
freeze one-publisher ownership
freeze global barrier model
freeze global histogram aggregation
freeze simultaneous-global verdict semantics
freeze 3–8 global-run campaign semantics
freeze slow-client 1600–2400ms pacing
include the corrected restart exact-range semantics from §3.2 below
freeze machine/provenance semantics from §3.3 below
```

Do not change a threshold merely to fit observed evidence.

### D. Reconcile every active-contract reference

After the successor is frozen, update all governing references consistently, including at minimum:

```text
internal_docs/LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md
internal_docs/TRACEABILITY_MATRIX.md
poc/internal_docs/EXPERIMENT_CONTRACT_v2_0_4.md or its canonical-pointer replacement
poc/internal_docs/PARAMETER_LEDGER.md
poc/internal_docs/METRIC_COVERAGE_MATRIX.md
poc/internal_docs/MILESTONE_2_AUDIT_GAP_REPORT.md
machine-readable contract_version producers
```

Do not leave two different documents claiming to be the active contract.

### E. Milestone status must remain truthful while this gap is open

The milestone file currently still says:

```text
Milestone 2: IN PROGRESS
```

which is appropriate until all remaining defects in this file are closed.

However:

```text
poc/internal_docs/MILESTONE_2_AUDIT_GAP_REPORT.md
```

currently claims:

```text
16 PASS, 0 PARTIAL, 0 FAIL, 0 BLOCKED
false PASS: 0
Milestone 2: DONE — 100%
```

That is not supportable while the restart false-PASS in §3.2 and contract contradiction in this section still exist.

Do not solve this by merely changing the milestone file to DONE.

Fix executable correctness first, reconcile the contract second, then update audit/traceability claims last.

---

## 3.2 Restart/replacement still has an exact-range false-PASS path

The old v4 restart section was substantially improved and must be narrowed to this remaining defect.

Already complete:

```text
literal and cross-node paths are separate
each path deliberately creates a non-empty accepted 8-event range
expected first/last/count are independently frozen
fallback expectedCount=1 was removed
missing first-prefix comparison exists
literal/cross-node counters are separate
structured path result objects exist
```

Do not redo those pieces.

### A. Current replay count is still based on total event count, not exact required-range membership

Both literal restart and cross-node paths currently derive approximately:

```text
receivedRequired = min(replayEvents.length, frozenExpectedCount)
missingRequired = frozenExpectedCount - receivedRequired
```

The replay callback detects:

```text
strictly decreasing sequence -> failure
duplicate sequence -> failure
```

but it does not require every canonical sequence in the frozen interval to be present.

Completion is still triggered by approximately:

```text
seq >= expected_last_seq
```

rather than by proving the required set is complete.

### B. Concrete false PASS

For a frozen required range:

```text
expected_first_seq = 10
expected_last_seq  = 17
expected_count     = 8
```

this received stream can satisfy the current count logic:

```text
10, 11, 12, 13, 14, 15, 16, 18
```

Why it can falsely pass:

```text
first_received_seq == 10
no duplicate
monotonically increasing
18 >= 17 -> target considered reached
replayEvents.length == 8
receivedRequired == 8
missingRequired == 0
```

but canonical sequence `17` is missing and out-of-range `18` substituted for it.

The same class of defect exists in both:

```text
literalRestartTest()
crossNodeTest()
```

### C. Required exact-range implementation

For each path, independently build the frozen expected range:

```text
expected = { expected_first_seq ... expected_last_seq }
```

During replay maintain, at minimum:

```text
required_received_set
required_duplicates
required_out_of_order
out_of_range_before
out_of_range_after
first_required_received_seq
last_required_received_seq
```

Only a canonical sequence satisfying:

```text
expected_first_seq <= seq <= expected_last_seq
```

may satisfy `received_required_count`.

Then require:

```text
received_required_count == expected_count
missing_required == 0
required_received_set exactly equals frozen expected set
expected_first_seq is present
expected_last_seq is present
no duplicate required sequence
no out-of-order required sequence
```

A later live event:

```text
seq > expected_last_seq
```

must never substitute for a missing required sequence.

Do not use total replay-frame count as proof of exact replay completeness.

### D. Completion boundary

Prefer to complete when the required set is actually complete, not merely when a frame at or above the target appears.

If a frame arrives with:

```text
seq > expected_last_seq
```

while the required set is incomplete, the path must fail rather than call that target reached.

`target_reached` should mean:

```text
all required canonical sequences were received exactly as required
```

not merely:

```text
some canonical sequence >= expected_last_seq was observed
```

### E. Structured evidence must use exact-range values

For both path objects:

```text
literal_restart
cross_node
```

ensure:

```text
received_required_count = unique required in-range count
missing_required = exact count of missing required canonical sequences
duplicates = duplicates within/affecting required proof
out_of_order = required replay ordering violations
missing_prefix = expected_first_seq absent/wrong
received_first_seq = clearly defined
received_last_seq = clearly defined
target_reached = exact required set complete
passed = exact required set complete AND all other path gates
```

If useful, add explicit structured fields:

```text
missing_required_sequences
out_of_range_before_count
out_of_range_after_count
```

Do not rely only on a human detail string.

### F. Required adversarial tests

Add focused tests for both literal and cross-node paths.

Must fail:

```text
expected 10..17, received 10..16,18
expected 10..17, received 10,11,13,14,15,16,17,18
expected 10..17, received 11..18
expected 10..17, received 10..17 plus duplicate required seq if duplicates are forbidden
expected 10..17, received required events out of order
```

Must pass:

```text
expected 10..17, received exactly 10..17 in order
```

Also prove an event after the frozen target cannot repair a missing required event.

### G. Global/campaign propagation

The coordinated global result currently trusts scenario `passed` values from the participating publisher-owner shard.

After fixing the path predicate, verify the exact-range structured path result is what drives:

```text
restart-replacement scenario result
simultaneous-global-run verdict
campaign verdict
```

No stale aggregate boolean may bypass the exact-range proof.

---

## 3.3 Machine-readable contract/runtime provenance still contains stale hard-coded values

Most of the old v4 machine-output defects are closed.

Do not redo:

```text
automatic source SHA injection
40-hex SHA validation
coordinated shard identity
global scope/aggregate_scope
direct eligibility false on shard results
actual global active-target gate
actual clock-validity propagation
structured reconnect evidence
structured restart path container
all match/lobby subscriber fields
global/campaign provenance
```

The remaining issue is narrower.

### A. Runtime container limits are hard-coded and wrong for the coordinated 100k runner

`result-printer.ts` currently emits approximately:

```text
runtime_container_limits.runner.nofile_soft = 100000
runtime_container_limits.runner.nofile_hard = 100000
```

but the actual coordinated 100k Compose shards are configured with:

```text
nofile soft = 120000
nofile hard = 120000
```

Machine evidence must not claim a runtime limit different from the actual launched process/container.

Fix this by using actual runtime/preflight values or a single resolved configuration source that cannot drift from the launched topology.

Do not merely change one hard-coded number from 100000 to 120000 if another profile legitimately has a different value.

The field should represent the actual current run.

### B. Contract version must have one canonical producer

Current code still has multiple hard-coded contract-version paths, including approximately:

```text
single/evidence output -> v2.0.3
coordinated shard/global/campaign -> v2.0.4
```

After §3.1 establishes the canonical successor, machine outputs must unambiguously identify the contract that governs that evidence.

Prefer one canonical contract-version source rather than scattered string literals.

At minimum verify:

```text
single supporting run contract_version
evidence-suite result contract_version
coordinated shard contract_version
simultaneous global run contract_version
campaign contract_version
```

are intentional and documented.

If all are governed by the new successor, all should report that successor.

If supporting/smoke paths intentionally use another historical contract, make that explicit and prove why; do not let stale hard-coded strings decide it accidentally.

### C. Provenance output must agree with the actual coordinated topology

Verify the final machine JSON for the 100k machinery reports the resolved facts, not stale static assumptions:

```text
4 shards
25,000 local target each
100,000 global target
actual shard IDs
actual source SHA
actual Nginx worker RLIMIT evidence
actual runner FD limit for that profile
actual service CPU quota/period/cpuset evidence
one publisher-owner
scope=shard for shards
scope=global / aggregate_scope=simultaneous_global_run for each global run
scope=campaign / aggregate_scope=campaign for repeated campaign result
```

A wrong informational field is still a reproducibility/provenance defect even if it does not currently alter the classifier.

### D. Focused tests

Add tests that make drift obvious.

At minimum:

```text
coordinated profile cannot emit runner nofile=100000 when launched/frozen at 120000
contract_version comes from canonical version source
shard output cannot claim global direct eligibility
simultaneous-global output identifies 100000 exact global target
campaign output preserves source commit and contract version
```

---

## 3.4 Traceability and audit documentation still overclaim completion

Do not treat documentation PASS labels as proof of executable correctness.

Current:

```text
poc/internal_docs/MILESTONE_2_AUDIT_GAP_REPORT.md
```

claims:

```text
16 PASS
0 PARTIAL
0 FAIL
0 BLOCKED
0 unmapped normative requirements
false PASS: 0
Milestone 2: DONE — 100%
```

while the governing milestone file still says Milestone 2 is IN PROGRESS.

More importantly, the current audit report marks restart exact range as PASS even though §3.2 above demonstrates a remaining false-PASS path.

Current traceability also marks the restart/history-replay requirement PASS based on the current predicate.

That status is premature.

### Required repair order

Do not merely rewrite the docs first.

Use this order:

```text
1. fix restart exact required-range semantics
2. fix canonical contract/provenance semantics
3. run focused tests
4. run complete typecheck/test suite
5. run reduced coordinated machinery validation
6. inspect actual machine JSON
7. adversarially re-audit
8. only then update traceability/audit/milestone status
```

### Traceability PASS rule

A requirement is PASS only if all are real:

```text
normative requirement
-> executable implementation
-> focused/adversarial test
-> metric producer
-> machine evidence path
-> classifier/verdict consequence
```

File existence or a matching comment is not enough.

For restart, require traceability to the exact in-range set predicate, not merely `replayEvents.length` or `seq >= target`.

### Final audit-report rule

Only after all remaining defects are closed may the audit report state:

```text
false PASS: 0
BLOCKED: 0
unmapped normative requirement: 0
Milestone 2: DONE — 100%
Milestone 3: NEXT
```

Until then it must not claim 100% closure.

---

# 4. Required focused tests

The old v4 test list is intentionally trimmed. Do not spend the closure cycle rewriting already-green tests for removed sections unless a regression is discovered.

## 4.1 Restart exact-range tests

For both literal and cross-node paths, cover:

```text
exact required range passes
missing middle required seq fails
missing final required seq + later live seq fails
missing first prefix fails
duplicate required seq fails
required-range out-of-order fails
out-of-range frames cannot increase received_required_count
target_reached requires required-set completeness
structured received_required_count is unique in-range count
structured missing_required is exact missing count
```

## 4.2 Contract/governance tests

Add static/contract tests proving:

```text
one canonical active contract exists
milestone points to that canonical contract
no current active document freezes 28k x 4 after executable topology is 25k x 4
no current active document says RUN_MODE=single for the coordinated 100k path
one-publisher/global-barrier/global-aggregate semantics are frozen
slow pacing is frozen as the actual executable tolerance
restart exact-range semantics are frozen
```

Historical frozen files may contain historical values, but they must be clearly superseded and must not be referenced as active.

## 4.3 Machine/provenance tests

Prove:

```text
runtime limits match the selected launch profile
coordinated 100k runner nofile evidence is not stale 100000
contract_version uses the canonical active version source
global target is exactly 100000
local target is 25000 per shard
source commit is non-null valid 40-hex SHA
shard/global/campaign scope fields cannot be confused
```

## 4.4 Regression suite

Run the full existing suite after focused tests.

Do not accept:

```text
focused tests pass
but full typecheck/test suite fails
```

as Milestone 2 closure.

---

# 5. Validation loop

After each material fix:

```text
npm run typecheck
npm test
```

using the repository's actual runner commands/location.

Then validate the reduced real coordinated path without executing the final Milestone 3 qualifying campaign.

Validate at minimum:

```text
coordinator starts
all 4 reduced shards register
source SHA matches
only one publisher owner
all phase start/end barriers release in order
aborted/missing shard cannot yield global ACCEPT
aligned active samples aggregate correctly
histogram distributions merge correctly
restart exact-range adversarial case fails
valid restart exact range passes
machine result scopes are correct
machine runtime limits are correct for selected profile
campaign aggregator rejects invalid/missing global-run input
```

The reduced test may use a much smaller connection target and shorter durations.

Do not call that reduced run 100k evidence.

---

# 6. Milestone 2 completion gate

Every item below must be true before claiming 100%.

## Governance

```text
one canonical active successor contract exists
ambiguous v2.0.4 documents are historical/superseded, not simultaneously active
milestone points to the canonical active contract
current 25k x 4 coordinated topology is frozen
current one-publisher/barrier/global-aggregate model is frozen
current slow-client pacing rule is frozen
current restart exact-range rule is frozen
no frozen historical contract edited silently in place
```

## Restart/replacement

```text
literal required set independently frozen
cross-node required set independently frozen
only in-range unique canonical sequences count
missing middle sequence cannot pass
missing final sequence cannot be replaced by later live sequence
missing prefix cannot pass
duplicates cannot pass
out-of-order cannot pass
target_reached means exact required set complete
structured evidence reports exact required/missing values
literal and cross-node results remain separate
```

## Machine evidence

```text
source commit non-null and correct
contract version canonical and intentional
runtime limits match actual selected profile
coordinated runner nofile metadata matches actual 120000 profile value or measured runtime value
4 x 25000 topology explicit
100000 exact global target explicit
one publisher-owner explicit
shard/global/campaign scopes explicit
no shard can claim global direct eligibility
```

## Coordinated experiment machinery

Already implemented, but final regression must still prove no regression:

```text
ordered barriers
aligned global active concurrency
aligned rates
histogram distribution merge
shared resource evidence once
global classifier
3–8 global-run campaign aggregate
```

## Traceability

```text
restart row points to exact required-set implementation/test
contract row points to one canonical active contract
machine-provenance row uses actual runtime values
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

After normal checks are green, deliberately search for these remaining-risk patterns.

## Contract/governance

```text
two files still both say active/frozen v2.0.4
milestone points to stale 28k x 4 contract
active contract says 112000 while code runs exact 100000
active contract says RUN_MODE=single for coordinated path
active contract says independent shard verdicts
active contract says slow median merely >1s while code requires 1.6–2.4s
audit report says DONE before executable closure
```

## Restart

```text
receivedRequired = min(replayEvents.length, expectedCount)
seq >= expectedLast treated as complete without exact required set
forward gap not detected
later live event substitutes for missing frozen event
first required event exists but middle required event missing and path still passes
received_required_count counts out-of-range events
missing_required derived only from total frame count
```

## Machine provenance

```text
runtime_container_limits hard-coded differently from compose/runtime
coordinated shard reports nofile 100000 while actual profile is 120000
contract_version string duplicated across unrelated files
old v2.0.3 emitted for evidence governed by successor semantics
shard/global/campaign scope confused
source SHA omitted or placeholder
```

## Traceability

```text
restart marked PASS based on non-empty range rather than exact range
contract marked PASS while two active contracts disagree
machine output marked PASS while emitted runtime values are stale
100% audit declaration copied from docs rather than re-derived from executable path
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
run the final full-scale 100k qualifying evidence campaign
run the final 3–8 full-scale qualifying campaign for submission evidence
write proposal.md
write final submission README
create final submission ZIP
complete final cost conclusion
deploy AWS
declare the production architecture ACCEPT/REJECT result from a reduced run
```

Reduced integration validation of the machinery is allowed and required.

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

## Canonical contract

```text
active contract filename/version
superseded ambiguous v2.0.4 documents
OLD / NEW / WHY summary
```

## Restart exact-range proof

For literal and cross-node separately report:

```text
transport resume ID
expected first seq
expected last seq
expected count
unique required received count
missing required sequences
duplicate count
out-of-order count
out-of-range count if tracked
target reached
path PASS/FAIL
```

Include an adversarial test where a later sequence cannot substitute for the missing expected final sequence.

## Machine provenance proof

```text
source commit
contract version
local shard target
shard count
global target
publisher-owner shard
actual/resolved runner nofile
actual Nginx worker RLIMIT
scope
aggregate_scope
global_direct_accept_eligible semantics
```

## Validation

```text
typecheck command/result
full unit-test command/result
focused restart adversarial tests
contract/static tests
reduced coordinated HTTP/integration test
machine JSON validation
campaign-aggregator reduced validation
clean source commit SHA
```

## Remaining blockers

Must be:

```text
NONE
```

if claiming 100%.

Do the work in the repository.
Do not stop below 100%.
