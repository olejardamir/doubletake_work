# MILESTONE 3 — REPAIR CURRENT POC UNTIL QUALIFYING ACCEPT

**Purpose:** Continue and repair the **existing Milestone 3** until the current POC family produces a fresh, valid, reproducible, machine-owned `ACCEPT`.

**This is NOT M3b. This is NOT a side experiment. This is the continuation of Milestone 3.**

**Repository:** `https://github.com/olejardamir/EA`

**Repository HEAD observed when this prompt was written:**

```text
4cae3b0764c47a72519c36bb6efc262bfb28a11e
```

**Historical q5 result:**

```text
campaign: m3-c89159e88822-q5
contract: v2.0.5
machine verdict: INCONCLUSIVE
```

**Corrective contract currently present:**

```text
poc/internal_docs/EXPERIMENT_CONTRACT_v2_0_6.md
```

**Current engineering direction already established by the repository:**

```text
the old single-primary Nchan 100k shape is not defensible;
repair the current Nchan + Redis + SSE POC by introducing explicit
horizontal fan-out partitioning / capacity isolation rather than
trying to raise the same single-primary limits.
```

---

# 0. User objective — do not reinterpret it

The objective is:

```text
FIX THE CURRENT M3 IMPLEMENTATION
MAKE THE FULL TEST SUITE PASS
MAKE THE FULL 100,000-VIEWER QUALIFYING CAMPAIGN PASS
END M3 WITH MACHINE VERDICT ACCEPT
THEN MOVE ON
```

Do not create a separately named milestone such as:

```text
M3b
M3-v2 side project
experimental side branch milestone
```

This work remains:

```text
Milestone 3
```

Historical campaigns inside M3 may have different campaign IDs and contracts, but the milestone itself stays the same.

The q5 `INCONCLUSIVE` result stays preserved as historical evidence. It is not the terminal M3 result anymore.

---

# 1. Stop condition

Do not stop because a development run says:

```text
REJECT
INCONCLUSIVE
PARTIAL
NOT_APPLICABLE
FAIL
```

Those are debugging/engineering inputs while M3 is still open.

The only normal stopping condition is:

```text
1. corrected implementation is committed and frozen;
2. all required automated/static/reduced validations pass;
3. the final qualifying topology exercises the full assignment-mapped workload;
4. a fresh repeated 100,000-viewer campaign completes;
5. all mandatory evidence is valid;
6. machine campaign verdict = ACCEPT;
7. evidence is preserved and checksummed;
8. M3 tracker is updated to DONE — ACCEPT;
9. M4 is then NEXT.
```

Do not manufacture an ACCEPT.

Do not suppress, delete, reinterpret, or manually override a machine failure.

Instead:

```text
diagnose -> fix -> test -> freeze -> run again
```

until the actual implementation passes.

---

# 2. First action — synchronize with current GitHub

Before changing anything:

```bash
git fetch
git checkout main
git pull --ff-only
git rev-parse HEAD
git status --short
```

Read the current versions of at least:

```text
internal_docs/LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md
poc/internal_docs/MILESTONE_4_INCONCLUSIVE_RECONCILIATION.md
poc/internal_docs/MILESTONE_2_POST_Q5_REAUDIT.md
poc/internal_docs/EXPERIMENT_CONTRACT_v2_0_6.md
poc/compose.evidence-100k.yaml
poc/compose.smoke-portable.yaml
poc/run-evidence-100k.sh
poc/run-evidence-100k-detached.sh
poc/run-smoke.sh
poc/runner/src/domain/active-contract.ts
poc/runner/src/main.ts
poc/runner/src/global-coordinator.ts
poc/runner/src/global-campaign.ts
poc/runner/src/result-printer.ts
poc/runner/src/scenarios/
poc/nchan/
```

Do not rely on this prompt for facts that have changed in the repository.

If `main` has moved:

```text
use the actual current HEAD.
```

---

# 3. Reopen Milestone 3 explicitly

At the start of this work, update the milestone tracker truthfully.

Milestone 3 must no longer be treated as terminal merely because q5 ran.

Use status equivalent to:

```text
Milestone 3 — IN PROGRESS
Reason:
q5 historical campaign is INCONCLUSIVE.
User explicitly requires the current POC to be repaired and
re-qualified to a machine ACCEPT before moving on.
```

Milestone 4 remains:

```text
NOT STARTED / BLOCKED ON TERMINAL M3 ACCEPT
```

Do not delete:

```text
poc/internal_docs/MILESTONE_4_INCONCLUSIVE_RECONCILIATION.md
```

It remains useful historical/root-cause analysis.

But its former `Terminal A — no rerun` choice is superseded as the project execution decision by the explicit instruction to continue repairing M3.

Document that supersession without rewriting history.

---

# 4. Preserve q5 permanently

Do not modify:

```text
internal_docs/m3_evidence/m3-c89159e88822-q5/
```

Do not change q5's:

```text
source SHA
contract
result files
manifest
checksums
machine verdict
```

q5 remains:

```text
historical M3 campaign
machine verdict = INCONCLUSIVE
```

The goal is for **a later campaign within the same M3 milestone** to become the terminal M3 evidence.

---

# 5. Assignment constraints remain fixed

The POC still needs to test the locally testable architecture risk under the assignment-mapped workload.

Do not weaken:

```text
8 concurrent live matches
~10 events/s steady total
~50 events/s burst total
100,000 concurrent viewers
+40,000 viewers within 120 seconds
full history <= 2 seconds
correct ordering
no duplicate events
no missing events
reconnect/resume correctness
restart/replacement correctness
```

The final POC still must:

```text
run locally
run with one command
require only a container runtime
require no cloud account
deploy no cloud infrastructure
use a simulated feed
produce measured evidence
remain experiment-grade code, not a full product
```

---

# 6. What must be repaired

The q5 root-cause analysis already established two categories.

## 6.1 Measurement/harness defects already corrected in v2.0.6

Preserve and regression-test all corrections for:

```text
coordinator barrier timeout
generator CPU normalization
generator event-loop peak preservation
Nchan-2 health endpoint
Nchan CPU usec conversion
Nchan OOM evidence
Redis memory bytes
burst histogram serialization/merge
late-join repeated-run population
restart role semantics and binding
campaign identity/freshness
detached exact exit status
```

Do not regress these.

## 6.2 Architecture/capacity defect still requiring repair

The old shape:

```text
one primary Nchan instance carrying the full viewer population
```

must not remain the 100k architecture under test.

q5 observed:

```text
~65k–66k global active peak
worker_connections exhaustion
8 GiB primary memory ceiling
Nchan OOM/OOM-kill
severe duplicates/reconnect gaps
fan-out latency degradation
restart failures
```

Therefore repair the **current POC topology** with explicit horizontal fan-out partitioning/capacity isolation.

---

# 7. Preferred repair — horizontal Nchan fan-out partitions

Keep the current technology family where practical:

```text
Nchan
Redis OSS
SSE
TypeScript generator/coordinator
Docker Compose
```

Repair the topology.

Start with the simplest defensible shape:

```text
4 independent fan-out partitions
approximately 25,000 viewer connections per fan-out node
100,000 total viewer connections
```

This is the first candidate because it maps naturally to the existing four 25k generator shards.

Do not assume it will pass.

Measure it.

If four nodes cannot pass honestly:

```text
diagnose the limiting resource
increase the number of fan-out partitions or change fan-out technology
only through a newly frozen development revision
```

Do not simply enlarge one Nchan primary.

---

# 8. Explicit connection ownership

Every viewer must be owned by exactly one fan-out partition.

Define a deterministic function, for example:

```text
partition = deterministic(match_id, viewer_id, shard_id)
```

or a simpler rule if equivalent.

Requirements:

```text
one viewer -> one fan-out node
same reconnecting viewer -> deterministic owner
no accidental load-balancer-only ownership assumption
no duplicate subscriptions across fan-out nodes
population accounting sums exactly to global population
partition assignment is machine-readable
```

Record:

```text
partition_id
target viewers
actual viewers
active peak
connection attempts
connection failures
```

for every node.

---

# 9. Match/channel routing

There are 8 live matches.

The architecture must define how match channels map across fan-out partitions.

Two acceptable basic models:

## Model A — replicated match channels

Every fan-out node can serve every match.

A canonical publisher sends each event to every fan-out node that owns viewers for that match.

Advantages:

```text
simple viewer balancing
simple reconnect routing
```

Required proof:

```text
each partition receives required event once
no partition receives event twice
```

## Model B — match/subpartition ownership

Each match is split into deterministic viewer subpartitions.

Events route only to the required subpartitions.

Required proof:

```text
deterministic event -> partition mapping
no lost partitions
no double publication
```

Prefer the simpler model unless measurement shows it is unsuitable.

---

# 10. Publication ownership

Do not recreate q5 duplicate behavior.

Define exact publication ownership.

Preferred default:

```text
one canonical publisher-owner generates the event sequence
the publisher explicitly publishes that event exactly once
to each required fan-out partition
```

For an event:

```text
canonical event ID / canonical sequence
required destination partition set
actual destination partition set
```

must be measurable.

Acceptance:

```text
missing partition publications = 0
duplicate partition publications = 0
unauthorized publishers = 0
```

Non-owner generators must never publish.

---

# 11. Shared Redis vs partitioned Redis

Evaluate the smallest correct Redis topology.

Preferred first attempt:

```text
shared Redis backing Nchan history/state
multiple Nchan fan-out nodes
```

Use this only if Nchan's Redis channel/history semantics support the partitioned fan-out design correctly.

Measure Redis:

```text
memory
CPU
latency if available
connection count
OOM
errors
```

If shared Redis itself becomes the bottleneck:

```text
partition Redis only if technically necessary
```

Do not add distributed complexity without evidence.

Regardless of topology:

```text
Redis is delivery/history support
DynamoDB remains production canonical truth in the proposal
```

The POC is not required to implement DynamoDB.

---

# 12. Nchan per-node configuration

For every fan-out node define and freeze:

```text
worker_processes
worker_connections
RLIMIT_NOFILE
container memory
container CPU
connection reserve
expected viewer population
publisher/control connections
Redis upstream connections
```

Do not use a theoretical aggregate as proof.

At runtime capture:

```text
per-node active connections
per-node process memory
per-node cgroup memory
per-node CPU
per-node throttling
per-node OOM / OOM kill
per-node worker connection warnings
per-node open FD evidence if practical
```

A final ACCEPT cannot coexist with:

```text
OOM kill > 0
fatal worker death
worker connection exhaustion that corrupts evidence
required node missing
mandatory resource evidence null
```

---

# 13. Generator repair and partitioning

The corrected generator-health semantics must remain.

If one generator process cannot create its assigned viewer load without invalidity:

```text
split generator responsibility
```

The existing four 25k runner shards are a natural baseline.

Do not allow generator topology to become coupled to one fan-out node accidentally unless that mapping is explicitly frozen.

For each generator record:

```text
assigned target
fan-out destinations
CPU raw
CPU normalized
event-loop p99
backlog
OOM
throttling
source-port headroom
connection failures
```

Generator validity thresholds remain frozen.

Do not raise them to pass.

---

# 14. Host-resource reality

The q5 host exposed fewer physical CPUs than the sum of all configured container CPU caps.

Do not treat Compose CPU limits as reservations.

Before a qualifying run record:

```text
host CPU count
host RAM
kernel
Docker version
Docker Compose version
background load
```

Then choose a topology the host can exercise validly.

If the same host cannot simultaneously drive:

```text
100k viewers
all fan-out nodes
Redis
publisher
measurement
```

without invalidating the generator:

first optimize/split the local generator and remove unnecessary measurement overhead.

If the host is fundamentally too small, the LLM must identify that before qualification instead of generating another INCONCLUSIVE run.

Do not reduce the 100k target.

---

# 15. Development probe ladder

Before spending time on another qualifying campaign, use explicitly non-qualifying development probes.

Suggested progression:

```text
10,000
25,000
50,000
75,000
100,000
```

At each level verify:

```text
all intended connections established
partition balance
zero missing
zero duplicates
zero ordering failures
acceptable fan-out latency
late join
reconnect
restart/replacement
no OOM
no connection-ceiling warnings
valid generator
valid resource metrics
```

A failure is a debugging input.

Fix it before going higher.

Do not mark development probes as the final POC result.

---

# 16. 100k prequalification gate

Do not freeze the final qualifying campaign until a non-qualifying 100k engineering validation has completed cleanly enough to show the machinery is capable of exercising the target.

Required prequalification observations:

```text
global active >= 100,000
+40k surge completed inside 120s
all fan-out nodes healthy
generator valid
Redis evidence numeric
Nchan evidence numeric
no OOM kill
no worker fatality
no worker_connections exhaustion
zero global missing
zero global duplicates
zero global out-of-order
late join populated
reconnect populated
restart/replacement populated
burst histogram populated
all required barriers complete
```

This is not the terminal evidence.

It is the engineering readiness gate.

---

# 17. New active M3 contract

Because the fan-out topology materially changes, create a new canonical experiment contract.

Use:

```text
v2.1.0
```

unless a newer correct version already exists.

Do not mutate v2.0.6 in place.

v2.0.6 remains historical corrective machinery.

The new contract must freeze:

```text
M3 is still the milestone
fan-out node count
fan-out partition IDs
viewer partitioning rule
match/channel partition rule
publisher ownership
event routing
Redis topology
history ownership
restart/replacement ownership
generator shard topology
per-node CPU/memory
per-node worker configuration
global 100k target
per-partition target
+40k/120s surge
steady rate
burst rate
slow-consumer cohort
late-join semantics
reconnect semantics
restart semantics
all correctness thresholds
all latency thresholds
all generator-validity thresholds
all DUT-resource validity rules
histogram rules
campaign identity/freshness
run count
seed policy
cross-run stability
machine verdict precedence
```

---

# 18. Do not tune the final qualification after seeing it

Engineering iterations are allowed before the qualifying freeze.

Once `v2.1.0` and the qualifying source SHA are frozen:

```text
do not change source
do not change topology
do not change limits
do not change thresholds
do not change seeds
do not change run count
do not delete a bad run
do not append a favorable replacement
```

If qualification returns REJECT or INCONCLUSIVE:

```text
preserve that campaign
reopen engineering
fix root cause
create a new source SHA
if semantics/topology changed, freeze v2.1.1 / v2.2.0 as appropriate
run an entirely new campaign
```

The milestone remains M3.

---

# 19. Seed policy

Use a deterministic seed policy chosen before the final campaign.

Preferred default if no stronger existing policy exists:

```text
GLOBAL_RUNS=3
BASE_GLOBAL_SEED=42
seeds=42,43,44
```

These seeds are already part of project history and therefore are not being selected because they looked favorable.

Do not inspect multiple candidate final seed sets and choose the best one.

---

# 20. Full test requirements before qualification

All must pass.

At minimum:

```text
npm run typecheck
full automated suite
all infrastructure-contract tests
all coordinator tests
all campaign tests
all classifier tests
all resource-monitor tests
all histogram tests
all late-join tests
all reconnect tests
all restart/replacement tests
all freshness/provenance tests
all partition-routing tests
all multi-Nchan integration tests
docker compose config --quiet
bash -n for every launcher
git diff --check
```

No skipped failures.

No assertion deletion.

No threshold weakening.

No fake fixture that bypasses real logic.

---

# 21. New partition-specific tests

Add exhaustive tests for the new topology.

Required categories:

## Connection ownership

```text
viewer assigned to exactly one partition
partition assignment deterministic
invalid partition rejected
target sum exactly 100,000
duplicate viewer ownership rejected
missing viewer ownership rejected
```

## Event routing

```text
event required-destination set exact
each destination receives exactly one publication
missing destination fails
duplicate destination fails
unauthorized destination fails if topology forbids it
non-owner publisher fails
multiple publisher owners fail
```

## Aggregation

```text
global active = aligned sum across all fan-out partitions
no double counting
histograms merge losslessly
partition IDs exact
missing partition result invalid
extra partition result invalid
stale partition result invalid
```

## History

```text
late join on every relevant partition reconstructs exact history
score matches
clock/head matches
required sequence range exact
no missing prefix
no later-sequence substitution
```

## Reconnect

```text
viewer reconnects to valid owner
required sequence exact
zero gaps
zero duplicates
zero ordering failures
```

## Failure/replacement

```text
one fan-out partition restart/replacement
unaffected partitions remain correct
owner transfer explicit
history remains exact
stale former owner cannot publish
```

## Resources

```text
OOM on any required fan-out node blocks ACCEPT
mandatory CPU/memory missing blocks validity
per-node resource identity binding exact
```

---

# 22. Correctness gates

Do not relax.

Final qualifying campaign requires:

```text
missing_sequences = 0
duplicates = 0
out_of_order = 0

surge_missing_sequences = 0
surge_duplicates = 0
surge_out_of_order = 0

reconnect_gaps = 0
reconnect_duplicates = 0
reconnect_order_violations = 0

parse errors = 0
schema errors = 0
invalid timestamps = 0
missing transport IDs = 0

restart exact-range validation = PASS
late-join exact reconstruction = PASS
```

If any fail:

```text
fix implementation and rerun under a new campaign after a new freeze.
```

---

# 23. Latency gates

Keep the current experiment's legitimate delivery-layer gates unless a stricter current contract already exists.

At minimum preserve:

```text
fan_out_p95_ms <= 500
surge_fan_out_p95_ms <= 500 where currently frozen
burst_fan_out_p95_ms <= 1000
late_join_p95_ms <= 2000
```

Do not increase them to achieve ACCEPT.

If latency fails:

```text
profile -> locate bottleneck -> fix -> test again
```

---

# 24. Population gates

Final qualification requires:

```text
aligned global active peak >= 100,000
```

Required scenarios must execute with the required global population.

Retain current frozen reconnect minimum if applicable.

Do not use:

```text
65k
75k
90k
```

as a substitute for the 100k assignment target.

---

# 25. Surge gate

The campaign must establish the assignment surge:

```text
+40,000 viewers within 120 seconds
```

Measure globally and per partition:

```text
starting population
attempted additions
established additions
elapsed time
final population
existing-viewer correctness
surge latency
```

ACCEPT requires the frozen surge requirement to be met.

---

# 26. Late join

The current v2.0.6 correction intentionally uses one publisher-owner late-join measurement per valid global repetition.

If the new multi-fan-out topology makes one sample insufficient to verify all history ownership domains, improve the contract **before qualification**.

A sensible new rule may require:

```text
at least one late-join sample per independent history/fan-out ownership domain per run
```

Only adopt this if the topology requires it.

Do not design a late-join test that can miss a broken partition.

---

# 27. Restart/replacement

The old single replacement-node scenario must be reconciled with partitioned fan-out.

Define:

```text
which fan-out partition is restarted
which replacement assumes ownership
how routing changes
how publisher destination set changes
how Redis/history persists
what happens to unaffected partitions
```

Required proof:

```text
exact required sequence range
zero missing
zero duplicate
zero ordering violation
no out-of-range substitution
replacement reaches target
unaffected partitions remain correct
```

---

# 28. Slow clients

Retain the existing slow-client validation.

In a partitioned topology ensure the slow cohort is not accidentally concentrated on only one special node unless deliberately frozen.

Verify:

```text
offered events measured independently
application reads measured
server-side backpressure observed
healthy clients remain within degradation threshold
Nchan memory bounded
recovery sufficient
```

---

# 29. Campaign freshness

Every final campaign must start clean.

Requirements:

```text
unique CAMPAIGN_ID
CAMPAIGN_ID = Compose project identity where current contract requires it
no existing labeled containers
no existing labeled networks
no existing campaign evidence volume
exact expected result file set
source SHA exact
contract exact
run indices exact
seeds exact
partition IDs exact
timestamps newer than campaign start
```

Do not reuse a prior campaign directory.

---

# 30. Exact launcher exit status

Use the corrected detached wrapper.

Capture:

```text
quoted exact command
campaign start
launcher PID
child PID
combined stdout/stderr
exact numeric exit
campaign end
```

The machine campaign verdict is authoritative.

The shell status is supporting evidence.

---

# 31. Qualifying campaign execution

Only after all readiness gates pass:

1. commit all implementation changes;
2. ensure working tree clean;
3. record source SHA;
4. freeze the new contract;
5. run full regression;
6. verify no source change after validation;
7. create fresh campaign identity;
8. record environment;
9. run the full repeated 100k campaign;
10. do not intervene because a run looks bad;
11. allow the frozen campaign aggregator to classify.

The one-command reviewer path must remain available.

---

# 32. If qualifying result is INCONCLUSIVE

Do **not** stop the task.

Preserve the campaign.

Then identify the exact validity cause.

Examples:

```text
generator invalid
host invalid
missing resource metric
coordinator failure
clock invalid
evidence freshness failure
cross-run instability
mandatory scenario population missing
```

Fix the actual cause.

Then:

```text
tests
commit
new source SHA
new campaign identity
new full campaign
```

If the change modifies frozen semantics:

```text
new contract version
```

Continue.

---

# 33. If qualifying result is REJECT

Do **not** stop the task.

Preserve the campaign.

A valid REJECT means the current architecture candidate genuinely failed.

Use it to fix the architecture.

Allowed next steps:

```text
increase horizontal partition count
rebalance viewer ownership
rebalance match/channel routing
remove a hot partition
separate Redis pressure if proven necessary
fix publication routing
fix reconnect ownership
fix restart replacement model
replace Nchan if repeated evidence shows Nchan is unsuitable
```

Do not:

```text
raise thresholds
lower 100k
hide the failing scenario
```

After architecture correction:

```text
new tests
new source
new contract version
new campaign
```

The milestone remains M3.

Continue until ACCEPT.

---

# 34. If Nchan cannot honestly pass

Do not spend endless iterations raising Nchan limits.

Use evidence.

If horizontally partitioned Nchan repeatedly fails for a fundamental reason under valid experiments:

```text
select the strongest locally runnable alternative fan-out technology
```

It must still satisfy:

```text
local Docker/container-runtime execution
100k testability
SSE/WebSocket or appropriate fan-out
history/replay requirements
correctness
latency
surge
```

Then integrate that replacement into the same current M3 POC and repeat the engineering/freeze/qualification loop.

This is still Milestone 3.

Do not create M3b.

---

# 35. Architecture-selection hierarchy

Prefer the smallest repair.

Order:

```text
1. multi-Nchan horizontal partitioning
2. improved Nchan partition/routing model
3. Redis topology correction if proven bottleneck
4. more fan-out partitions if proven necessary
5. alternative locally runnable fan-out server if Nchan fundamentally unsuitable
```

Do not jump to a more complicated technology without evidence.

---

# 36. No result-shopping

Although the target is ACCEPT, do not obtain it through statistical or procedural manipulation.

Forbidden:

```text
discarding failed qualifying runs
rerunning only a bad seed and replacing it
selecting the best 3 of 8
trying many final seeds and choosing winners
editing evidence JSON
editing result timestamps
editing verdicts
lowering target
raising thresholds
removing mandatory metrics
calling a non-qualifying smoke ACCEPT
```

Engineering changes are allowed.

Result manipulation is not.

---

# 37. Keep development and qualification separate

Development loop:

```text
change code
run tests
run non-qualifying probes
profile
fix
repeat
```

Qualification loop:

```text
freeze
clean tree
fresh campaign
run exact policy
preserve result
```

If qualification fails:

```text
qualification ends
campaign preserved
return to development
```

Never modify code halfway through a campaign.

---

# 38. Evidence manifest for terminal ACCEPT

When the terminal ACCEPT occurs, preserve:

```text
campaign ID
source SHA
contract version
run count
seeds
host environment
Docker versions
exact command
start/end
exit status
global-result-N.json
campaign-result.json
console log
per-partition/per-shard machine evidence
checksums
```

Manifest must record at minimum:

```text
global active peak
surge established
fan-out p50/p95/p99
burst p95
late-join p95
correctness counters
reconnect counters
restart exact-range evidence
slow-client evidence
generator validity
per-fan-out-node resource peaks
Redis memory
cross-run stability
machine verdict
```

---

# 39. Terminal ACCEPT audit

Before marking M3 done, independently verify the campaign aggregator did not produce a false positive.

Check:

```text
campaign verdict == ACCEPT
every global run direct-eligible
all expected runs present
no extra/stale results
source/contract identical
all topology IDs exact
100k reached
surge passed
correctness zero violations
latency gates passed
late join passed
reconnect passed
restart passed
slow-client passed
resources valid
generator valid
no required OOM
no invalid timing
cross-run dispersion passed
```

If any inconsistency exists:

```text
do not mark M3 done
fix and rerun
```

---

# 40. Update M3 only after terminal ACCEPT

When valid ACCEPT is achieved:

update:

```text
internal_docs/LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md
```

to something equivalent to:

```text
Milestone 3 — DONE — ACCEPT

Historical campaign q5:
INCONCLUSIVE — preserved

Terminal campaign:
<campaign-id>

Terminal source:
<sha>

Contract:
<v2.1.x>

Runs:
<run count>

Seeds:
<seeds>

Machine verdict:
ACCEPT

Evidence:
<manifest path>
```

Then set:

```text
Milestone 4 — NEXT / NOT STARTED
```

M4 can now reconcile the accepted revised fan-out architecture.

---

# 41. Update architecture pointer only after ACCEPT

Do not finalize the production proposal during this task.

But once M3 ACCEPT is terminal, record the exact local architecture that passed so M4 knows what it is reconciling.

Record:

```text
fan-out technology
fan-out node count
partition rule
Redis topology
publisher routing
history ownership
failure/replacement model
resource envelopes
```

Do not claim the POC proved:

```text
real AWS regional latency
browser rendering latency
real provider semantics
monthly cost
production deployment behavior
```

Those remain later milestones.

---

# 42. AI instruction provenance

This prompt is an agent instruction file if it is actually used.

Preserve the exact used prompt under an appropriate internal path, for example:

```text
internal_docs/MILESTONE_3_ACCEPTANCE_RECOVERY_PROMPT_ARTIFACT.md
```

Update:

```text
internal_docs/AI_INSTRUCTION_PROVENANCE.md
```

with:

```text
filename
SHA-256
purpose
first-use source SHA
```

Do not forget it during final packaging.

---

# 43. Commit discipline

Make coherent commits.

Do not leave the terminal ACCEPT code uncommitted.

Before terminal qualification:

```text
git status --short
```

must be clean.

After each meaningful engineering revision:

```text
run relevant tests
commit
```

Do not commit generated evidence into `poc/`.

Terminal raw evidence remains outside final `poc/`.

---

# 44. Generated artifacts

Final `poc/` must still satisfy the assignment:

```text
no node_modules
no dist
no build output
no logs
no benchmark JSON
no generated evidence
no Docker state
```

Development evidence can live under internal evidence paths temporarily.

Do not clean historical q5 evidence until later packaging rules decide what is excluded from the final ZIP.

---

# 45. Required loop

Repeat:

```text
A. inspect current failure
B. identify root cause
C. implement smallest real fix
D. add regression/adversarial tests
E. typecheck
F. full tests
G. focused tests
H. static config/shell checks
I. reduced probe
J. scale-up development probe
K. 100k prequalification
L. freeze source/contract
M. fresh qualifying campaign
N. inspect machine verdict
```

Decision:

```text
if ACCEPT:
    terminal audit
    complete M3
    stop

if INCONCLUSIVE:
    preserve campaign
    fix validity cause
    loop

if REJECT:
    preserve campaign
    fix architecture cause
    loop
```

Do not ask the user whether to continue after a failed iteration.

Continue.

---

# 46. Zero-gap test audit

Before terminal qualification all answers must be YES:

```text
current source committed? YES
working tree clean? YES
active contract frozen? YES
single-primary 100k shape removed? YES
explicit horizontal fan-out ownership? YES
exact publication routing? YES
exact history ownership? YES
generator valid? YES
resource evidence complete? YES
Redis evidence numeric? YES
burst histogram complete? YES
late-join coverage meaningful? YES
reconnect exact? YES
restart/replacement exact? YES
freshness rules exact? YES
exit status exact? YES
100k development probe reached? YES
+40k/120s development surge reached? YES
zero correctness violations in readiness probe? YES
no OOM/worker death? YES
all automated tests pass? YES
```

If any is NO:

```text
continue engineering
```

---

# 47. Terminal campaign zero-gap audit

For the terminal campaign all answers must be YES:

```text
fresh campaign? YES
correct source SHA? YES
correct contract? YES
correct runs? YES
correct seeds? YES
correct topology? YES
all global results present? YES
no stale results? YES
generator valid every run? YES
environment valid every run? YES
100k reached every required run? YES
surge requirement passed? YES
missing = 0? YES
duplicates = 0? YES
out-of-order = 0? YES
reconnect gaps = 0? YES
restart exact = PASS? YES
late join = PASS? YES
latency gates = PASS? YES
resource gates = PASS? YES
cross-run stability = PASS? YES
machine campaign verdict = ACCEPT? YES
```

Only then:

```text
M3 = DONE — ACCEPT
```

---

# 48. What this task must NOT do

Do not move on to:

```text
final M4 architecture write-up
M5 final cost conclusion
proposal.md finalization
README finalization
M8 final audit
M9 cleanup
M10 ZIP
```

until terminal M3 ACCEPT is achieved.

This prompt is specifically for closing the M3 gap.

---

# 49. Required final response from the executing LLM

Do not respond with progress-only language if the loop is still actionable.

Continue working.

When the stopping condition is genuinely reached, report:

```text
MILESTONE 3: DONE — ACCEPT

Historical q5:
INCONCLUSIVE — preserved, not rewritten

Terminal qualifying campaign:
<id>

Source SHA:
<sha>

Contract:
<version>

Topology:
<fan-out topology>

Runs / seeds:
<values>

Global viewer target:
100,000 — PASS

+40,000 / 120s surge:
PASS

Correctness:
PASS

Latency:
PASS

Late join:
PASS

Reconnect:
PASS

Restart/replacement:
PASS

Generator validity:
PASS

DUT resource validity:
PASS

Cross-run stability:
PASS

Machine campaign verdict:
ACCEPT

Full automated tests:
<passed>/<total>

Evidence manifest:
<path>

NEXT:
Milestone 4
```

---

# 50. Final instruction

Do not create M3b.

Do not declare the old q5 campaign successful.

Do not stop at another avoidable INCONCLUSIVE or REJECT.

Repair the **current Milestone 3** implementation and topology, preserve every failed campaign honestly, and keep iterating until the revised current POC earns a real machine `ACCEPT` under the frozen assignment-aligned criteria.
