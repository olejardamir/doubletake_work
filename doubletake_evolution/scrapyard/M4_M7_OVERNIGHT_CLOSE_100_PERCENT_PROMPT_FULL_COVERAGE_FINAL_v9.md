# Milestones 4–7 — Close 100% End-to-End Overnight Execution Prompt

**Repository:** `https://github.com/olejardamir/EA`  
**Purpose:** Execute and close Milestones 4, 5, 6, and 7 completely, in dependency order, with repeated gap audits until all four milestones are genuinely 100% complete.

## Prompt-authoring repository baseline

At the time this instruction file was created:

```text
main = 4cae3b0764c47a72519c36bb6efc262bfb28a11e
```

Do **not** assume this remains current. Re-read `main` at execution time.

## Candidate-authorized starting assumption

The candidate explicitly instructs:

```text
Treat the Milestone 3 corrective gap as successfully closed.
Proceed to Milestones 4, 5, 6, and 7.
```

This does **not** authorize rewriting historical evidence.

The known current repository state at prompt creation is:

```text
historical qualifying M3 campaign:
    m3-c89159e88822-q5

historical source:
    c89159e8882206de9fffa2b170a38d76854288ce

historical contract:
    v2.0.5

historical machine verdict:
    INCONCLUSIVE

post-q5 correction contract:
    v2.0.6

post-q5 corrected-source re-audit:
    PASS

latest corrected source validated before prompt creation:
    b143e6679269b99cc04be20eee98c3ba96e8dd1b

M4 preliminary terminal decision already present:
    Terminal A

Meaning:
    do not fabricate a replacement M3 ACCEPT;
    preserve q5 as INCONCLUSIVE;
    withdraw the single-primary Nchan 100k assumption;
    complete M4 by selecting the replacement production architecture/topology.
```

If the repository has advanced since this prompt was written, use the newest truthful state.

---

# 0. Mission

Execute:

```text
M4 — finish architecture reconciliation and select the final production design
M5 — close current external evidence, cost, geography, and production-mapping gaps
M6 — write the actual final proposal.md
M7 — write the actual final README.md
```

This is **not** a planning-only exercise.

Actually:

- inspect the latest repository;
- use the final M3/M4 evidence;
- research current external facts;
- make architecture decisions;
- calculate costs;
- update internal architecture documentation;
- write `proposal.md`;
- write `README.md`;
- update milestone status;
- audit repeatedly.

Do not stop after a draft.

Stop only when:

```text
M4 = 100%
M5 = 100%
M6 = 100%
M7 = 100%
```

and a fresh adversarial pass finds no remaining M4–M7 gap.

---

# 1. Core truth rules

The following are absolute.

Never:

```text
turn q5 INCONCLUSIVE into ACCEPT
turn q5 INCONCLUSIVE into REJECT
delete or rewrite preserved q5 evidence
pretend the corrected v2.0.6 smoke is qualifying 100k evidence
claim the one-primary Nchan design passed 100k
run a new qualifying 100k M3 campaign merely to get a nicer story
change historical thresholds after observation
invent provider semantics
invent cloud measurements
invent browser latency
invent regional latency
invent AWS pricing
invent monthly traffic facts
omit known architecture problems
massage cost assumptions to get under $3,000
```

The correct final submission may say:

```text
the qualifying campaign was INCONCLUSIVE,
but direct observed DUT limitations invalidated the single-primary production assumption,
so the architecture was revised.
```

That is acceptable and truthful.

---

# 2. Explicit M3 closure boundary

Do not reopen M3 unless a **newly discovered fatal integrity contradiction** proves the current closure invalid.

The current intended interpretation is:

```text
q5 remains immutable historical INCONCLUSIVE evidence.

v2.0.6 corrected the harness/measurement defects.

the v2.0.6 post-q5 M2 re-audit passed.

M4 Terminal A says no new qualifying M3 run is required.

direct architecture observations from q5 are enough to withdraw the one-primary 100k assumption.
```

The existing M4 reconciliation already records architecture-significant observations including:

```text
primary Nchan reached exact 8 GiB cgroup memory ceiling
positive Nchan OOM / OOM kill
per-worker worker_connections ceiling warnings
global active population converged around 65–66k
millions of duplicates at degraded sub-target load
large reconnect-gap counts
failed restart replay
>1s observed fan-out p95 at degraded population
corrected runner CPU math does not support "generator saturation caused the ceiling"
```

Do not redo q5 merely because it did not produce ACCEPT.

---

# 3. Original assignment — hard constraints

The final M4–M7 work must satisfy the original take-home assignment.

## Product behavior

```text
public
anonymous
read-only
no accounts
```

## Lobby

```text
show all live matches
score
minute
goals/cards and routine run-of-play events live
no refresh
```

## Match page

```text
late join immediately sees everything so far
reload immediately restores everything so far
return after phone wake immediately restores everything so far
then live streaming continues
never blank
no manual refresh
```

## Correctness

```text
score agrees with visible events
no duplicate display
nothing disappears
no out-of-order display
```

## Scale/workload

```text
8 concurrent live matches
~10 events/s total steady
~50 events/s total burst
100,000 concurrent viewers
+40,000 viewers within 2 minutes
experience materially equivalent from 100 viewers to 100,000 viewers, including kickoff rush
~60% Europe
~40% North America
```

## Performance

```text
goal p95 <= 2 seconds ingest -> viewer screen
other-event p95 <= 5 seconds
full history <= 2 seconds
```

## Other

```text
score and clock derived from third-party event stream
third-party feed best-effort
no long retry window
<= $3,000/month peak
weekly deploys during live matches
viewers should not notice deploys
Next.js App Router
component-based frontend
AWS preferred, or justify alternative
```

---

# 4. Deliverables relevant to M4–M7

## Final proposal

Create at repository root:

```text
proposal.md
```

Hard rule:

```text
<= 1,500 words
diagrams excluded
Markdown
```

It must explain the production architecture and reasoning.

## Final README

Create at repository root:

```text
README.md
```

It must contain:

```text
POC run instructions
<=300-word POC write-up:
    assumption -> method -> result -> what changed in proposal
AI-process disclosure
```

## Cloud scope

The assignment does **not** ask for a cloud deployment.

Do not:

```text
create AWS resources
require AWS credentials
deploy production infrastructure
spend cloud money
build the full production app
```

AWS is for the **production design and cost proposal**.

The POC remains local.

---

# 5. AI instruction provenance

This prompt is being used to direct an LLM.

Therefore preserve it exactly as an AI instruction artifact.

Recommended path:

```text
internal_docs/MILESTONES_4_5_6_7_CLOSE_100_PERCENT_OVERNIGHT_PROMPT_ARTIFACT.md
```

Then:

1. compute SHA-256 of the exact file;
2. update:

```text
internal_docs/AI_INSTRUCTION_PROVENANCE.md
```

3. record:
   - filename;
   - hash;
   - purpose;
   - first-use source commit;
   - that it directed M4–M7 execution.

Do not edit the preserved artifact after hashing.

If other new instruction files are actually used, record them too.

---

# 6. Source-of-truth precedence

Use:

1. original assignment / `requirement.pdf`, if locally available;
2. preserved assignment requirements in repository;
3. immutable q5 M3 evidence;
4. current v2.0.6 correction/re-audit records;
5. current M4 reconciliation;
6. `internal_docs/AGENTS.md`;
7. final architecture chosen during M4;
8. current official external sources researched during M5;
9. current executable `poc/`;
10. historical documents as provenance only.

If an old architecture document conflicts with current q5/M4 evidence:

```text
update/supersede the architecture document.
```

If a current official AWS fact conflicts with an old internal note:

```text
current official AWS fact wins.
```

---

# 7. Execution preflight

At the beginning:

```bash
git status --short
git rev-parse HEAD
```

Record:

```text
current branch
current HEAD
working-tree state
active experiment contract
terminal q5 evidence identity
current M4 decision state
current architecture source-of-truth files
```

Inspect at least:

```text
internal_docs/AGENTS.md
internal_docs/AI_INSTRUCTION_PROVENANCE.md
internal_docs/LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md
internal_docs/LIVE_MATCH_CENTRE_MINIMUM_DEFENSIBLE_ARCHITECTURE.md
internal_docs/LIVE_MATCH_CENTRE_EQC_AC_ARCHITECTURE_CONTRACT_*.md
internal_docs/LIVE_MATCH_CENTRE_THIRD_PARTY_RESEARCH*.md
internal_docs/m3_evidence/m3-c89159e88822-q5/
poc/internal_docs/EXPERIMENT_CONTRACT_v2_0_6.md
poc/internal_docs/MILESTONE_2_POST_Q5_REAUDIT.md
poc/internal_docs/MILESTONE_4_INCONCLUSIVE_RECONCILIATION.md
poc/
```

Also inspect any M5/M6/M7 prep artifacts that may now exist.

Reuse correct work.

Do not duplicate internal docs unnecessarily.

---

# 7A. Repository work safety

Before modifying files:

```text
preserve unrelated user changes
do not reset or rewrite M3 history
do not force-push
do not delete evidence
```

If Git branch creation is available, prefer an isolated feature branch such as:

```text
m4-m7-closeout
```

unless the candidate's local workflow already explicitly requires another branch.

If committing:

```text
stage only files created/changed for this M4–M7 task
use milestone-scoped commits
do not use blanket staging over unrelated work
do not push unless the environment/user has already authorized publication
```

At the end, report:

```text
branch
HEAD
working-tree status
commits created
uncommitted files, if any
```

This is repository hygiene, not an additional assignment deliverable.

---

# 7B. Overnight autonomy and concurrent-work safety

This is intended to run without interactive supervision.

Do not pause for minor preferences or ask for confirmation when a defensible choice can be made from the assignment and evidence.

For any ambiguity:

```text
choose the smallest defensible assumption
label it explicitly
record why
continue
```

Stop only for a genuinely fatal contradiction that would make the deliverable knowingly false.

Because another process may update the repository while this task runs, before each milestone commit or major write:

```bash
git rev-parse HEAD
git status --short
```

If HEAD changed unexpectedly:

```text
inspect the new commits
preserve concurrent work
reconcile/rebase safely
never overwrite another agent/user's changes blindly
```

Do not force-push or rewrite M3 history.

---

# 8. Dependency order

Use:

```text
M4
↓
M5
↓
M6
↓
M7
```

You may research M5 facts while evaluating M4 alternatives.

However:

```text
M4 cannot close until one architecture is selected.

M5 cannot close until it prices/verifies that exact architecture.

M6 cannot close until M4 and M5 are stable.

M7 cannot close until M6 and the terminal POC story are stable.
```

If M5 discovers a capability or cost contradiction:

```text
return to M4,
change the architecture if needed,
then recompute M5.
```

---

# 9. Milestone 4 — actual remaining objective

The q5 root-cause reconciliation is largely already present.

The remaining M4 job is:

> Turn Terminal A into one final production architecture that addresses the failed single-primary assumption while satisfying the assignment's correctness, scale, latency, geography, cost, and deployability constraints.

Create/finalize:

```text
internal_docs/MILESTONE_4_FINAL_ARCHITECTURE_RECONCILIATION.md
```

Preserve:

```text
poc/internal_docs/MILESTONE_4_INCONCLUSIVE_RECONCILIATION.md
```

as historical causal analysis.

---

# 10. M4 — do not erase the current finding

The final M4 must preserve:

```text
q5 verdict = INCONCLUSIVE
```

and:

```text
one frozen primary Nchan node is no longer accepted as a credible 100k production shape.
```

Do not revert to the old diagram unchanged.

The replacement design must provide explicit:

```text
horizontal connection partitioning
capacity isolation
failure-domain ownership
routing
history/reconnect behavior
```

or select a different fan-out technology that solves the same problem.

---

# 11. M4 — evaluate replacement fan-out options

Evaluate a bounded set of serious candidates.

At minimum:

## Candidate A — horizontally partitioned Nchan fleet

Possible shape:

```text
CloudFront
-> internal NLB / routing layer
-> multiple independently bounded Nchan fan-out nodes or shards
-> shared or partitioned Redis-compatible state as appropriate
```

Investigate whether routing should be:

```text
match/channel affinity
consistent partition ownership
separate listener/fan-out groups
another deterministic routing model
```

Do not assume an NLB alone guarantees even per-worker/per-node distribution for the required semantics.

## Candidate B — different self-hosted SSE/WebSocket gateway

Only if it materially improves:

```text
capacity isolation
memory model
horizontal routing
operational simplicity
```

Do not create a custom gateway merely to avoid admitting Nchan limits.

## Candidate C — managed AWS fan-out

Revisit:

```text
AppSync Events
API Gateway WebSocket
other relevant current AWS managed option
```

Use current pricing.

The historical conclusion that managed fan-out is too expensive may have changed.

## Candidate D — strongest non-AWS alternative

Revisit only the strongest candidate, such as:

```text
Cloudflare Durable Objects / current equivalent
```

AWS is preferred by assignment, so a non-AWS winner needs a concrete justification.

Do not create a giant comparison matrix of weak options.

---

# 12. M4 — architecture decision criteria

Rank candidates against:

```text
100k concurrent-viewer feasibility
+40k/120s connection surge
correctness
history/replay
reconnect/resume
late join <=2s design
goal/other latency budget
horizontal isolation
failure containment
weekly deploy continuity
60/40 geography
operational complexity
current technology maturity
current cost
<= $3,000/month feasibility
AWS preference
ability to explain in <=1500-word proposal
```

Do not weight "we already wrote code for it" as an architecture advantage.

The POC is experiment code, not sunk-cost justification.

---

# 12A. M4 — composition-aware selection and preference-reversal check

Do not choose a component because it wins one isolated comparison.

For each serious final architecture candidate:

1. apply all hard assignment gates;
2. evaluate the **composed** design across:
   - correctness;
   - 100k + surge;
   - hot-match concentration;
   - geography;
   - late join;
   - reconnect;
   - deploy/rollback;
   - failure domains;
   - cost;
   - operational complexity;
3. keep non-dominated candidates long enough to expose interactions;
4. explicitly ask whether the locally attractive option becomes worse after composition.

Record for the finalists:

```text
candidate
hard gates
main strengths
main weaknesses
interaction risks
cost effect
latency effect
consistency effect
deployment/recovery effect
unverified assumptions
final composed verdict
```

Do not preserve a large technology catalogue after the decision is clear.

---

# 13. M4 — canonical-state invariant

Whatever fan-out design wins:

```text
fan-out delivery state is not canonical truth.
```

Preserve a canonical application-state model that can enforce, after an event has been accepted:

```text
canonical sequence
idempotency
score consistency
clock consistency
history order
correction semantics where provider supports them
```

A likely production separation remains:

```text
durable ingest / ordering
canonical processor/state
fan-out/history delivery tier
```

but re-evaluate exact components if M5 evidence says otherwise.

---

# 13C. M4 — provider boundary

The original weakest assumption remains the unknown third-party feed semantics unless a stronger current reason exists.

The assignment does not provide:

```text
provider event ID
sequence model
replay endpoint
correction model
cancellation model
authentication model
redelivery guarantee
history API
```

Do not invent them.

The final proposal should state:

```text
downstream code can guarantee consistency only for accepted events;
events never delivered by the provider cannot be reconstructed without a provider recovery source.
```

State what must be validated before production launch.

---

# 13A. M4 — ingress validation, normalization, and schema evolution

The production path must have a provider-boundary normalization step.

Define:

```text
schema/version recognition
required-field validation
provider event -> canonical event normalization
unknown/unsupported event handling
malformed event handling
backward-compatible evolution strategy
observability for schema errors
```

Do not let a provider schema change silently corrupt score/history.

A concise production policy may be:

```text
version-aware adapter normalizes supported provider schemas into a stable canonical event model;
unknown incompatible versions are quarantined/alerted rather than silently interpreted.
```

This is separate from claiming the provider supplies perfect identity/order semantics.

---

# 13B. M4 — atomic canonical history/state boundary

The visible score/current state and visible event history must come from the same committed canonical boundary.

If DynamoDB remains selected, define an equivalent of:

```text
per-match expected version / sequence condition
+
append canonical event at canonical_seq
+
update current score/clock/state to the same canonical_seq
```

atomically/transactionally where needed.

A late-join snapshot/current-state record must identify the canonical sequence it represents.

Do not allow:

```text
score says 2-1 at seq 500
history only committed through seq 499
```

or the reverse.

If another canonical store wins, preserve the same invariant with that store's transaction/concurrency mechanism.

---

# 14A. M4 — provider transport must be an explicit assumption

The assignment says only:

```text
a third-party feed provider pushes an event stream
```

It does **not** state whether the transport is:

```text
HTTPS webhooks
persistent TCP/WebSocket
vendor SDK
Kafka-like stream
another protocol
```

Do not silently treat:

```text
Provider -> API Gateway HTTP API
```

as an assignment fact.

Choose one concrete planning assumption for the proposal and label it.

If the selected baseline assumes HTTPS push/webhooks, state:

```text
ASSUMPTION: provider can push HTTPS events to our ingress endpoint.
```

If the real provider instead requires a persistent connection, explain that only the provider-adapter boundary changes; the durable queue/canonical-processing/downstream design remains.

If a persistent provider adapter is part of the final baseline, cost and operate it.

Do not invent HMAC, mTLS, OAuth, API keys, or another provider-authentication scheme as fact.

---

# 14B. M4 — accepted-event retry / poison-event policy

The architecture promises that an event accepted durably by our system does not silently disappear.

Define what happens if canonical processing fails after durable acceptance.

At minimum:

```text
retry transient failures
preserve per-match ordering
make canonical writes idempotent
do not silently skip a poison event and advance visible canonical sequence
alert/quarantine with enough context to reconcile
make any dead-letter path explicit
```

If a malformed/provider-invalid event cannot be applied:

```text
do not manufacture a valid event
do not silently make score/history inconsistent
surface the provider/reconciliation limitation
```

The final proposal can express this concisely; the architecture decision itself must be explicit.

---

# 14C. M4 — canonical sequence semantics

Define the relationship between:

```text
provider identity/order, if any
durable acceptance order
per-match canonical_seq
transport Last-Event-ID / delivery IDs
```

A defensible model may:

```text
commit one monotonic canonical_seq per accepted canonical match event
use canonical_seq for browser idempotency/order
use transport IDs only as resume aids
never pretend canonical_seq repairs an upstream event that was never delivered
```

Provider corrections/reordering remain provider-semantic questions to validate before production.

---

# 15. M4 — routing and partition ownership

If a horizontally partitioned fan-out fleet wins, define exactly:

```text
what is partitioned
how a match maps to a partition
how lobby traffic is handled
who owns a channel
how a node failure changes ownership
how reconnect reaches the correct retained history
whether Redis is shared globally or partitioned
whether hot matches can be split further
```

Avoid a vague phrase such as:

```text
"just add more Nchan nodes"
```

That is not a production design.

---

# 16. M4 — hot-match behavior

The system has only 8 concurrent matches.

A single popular match may dominate viewers.

The final architecture must explicitly address:

```text
one hot match having tens of thousands of viewers
```

If partitioning only by match can still put 60k–80k viewers on one node, solve that.

Possible strategies may include:

```text
sub-sharding a match channel across delivery partitions
multiple identical fan-out replicas for the same match
edge connection distribution with shared retained state
another fan-out system with stronger horizontal behavior
```

Choose one.

Do not rely on an 8-match average.

---

# 17. M4 — lobby path

The lobby must update live.

Define whether it uses:

```text
a single lightweight lobby state channel
periodic complete current-state messages
delta updates
```

The simplest defensible model is preferred.

Lobby delivery must not create a second complex consistency system.

---

# 18. M4 — late join/reload/wake

Define the final normal path.

A viewer must:

```text
get all current match history/state
within <=2s design target
then join live tail
```

Choose one normal mechanism:

```text
fan-out retained history
canonical snapshot/history endpoint
hybrid snapshot + live tail
```

Do not keep multiple redundant replay systems unless necessary.

---

# 19. M4 — reconnect semantics

Define:

```text
transport cursor
canonical sequence
idempotent browser reducer
what happens on duplicate delivery
what happens on reconnect gap
when a client falls back to full reconstruction
```

If SSE remains selected, native:

```text
EventSource / Last-Event-ID
```

may be used for transport resume, but do not confuse transport IDs with provider semantic order.

---

# 19A. M4 — do not rely on reactive scale-up for the 2-minute kickoff rush

The assignment requires:

```text
+40,000 viewers within 120 seconds
```

A production design cannot assume new EC2/container capacity will necessarily boot, become healthy, and absorb the rush after the rush has already started.

Define one of:

```text
pre-provision peak + N+1 delivery capacity for known live fixtures
warm pool / pre-scaled capacity before kickoff
managed fan-out whose documented service capacity absorbs the surge
another explicitly justified mechanism
```

Reactive autoscaling may replenish longer-term headroom, but it must not be the only plan for the two-minute surge.

If fixture schedules are known, pre-scaling before popular kickoffs is a reasonable production inference.

M5 must price the peak capacity that must already exist.

---

# 19B. M4 — avoid reconnect thundering herd during deploy/failure

A delivery-node drain or failure can itself create a connection surge.

Define:

```text
staggered rolling replacement
one failure domain at a time where practical
load balancer draining
client retry jitter/backoff
sufficient spare capacity for reconnects
```

Do not coordinate every client to reconnect at the same instant.

Native EventSource retry behavior may be part of the strategy if verified; add jitter/control where the selected client path requires it.

---

# 20. M4 — deploy continuity

Explain production deployment:

```text
rolling instance replacement
minimum healthy capacity
connection draining
shared/canonical history
client reconnect
resume/reconstruction
```

Do not claim:

```text
zero downtime proven
```

unless actually measured in production.

Use:

```text
designed so viewers reconnect/resume without manual refresh
```

---

# 20A. M4 — delivery/history store loss and rebuild

The fan-out/history tier is not canonical truth.

Define recovery if:

```text
a delivery node is lost
Redis/Valkey retained history is lost or fails over
a whole delivery partition is replaced
```

A replacement delivery partition must be able to reconstruct the active match from canonical durable state without inventing or reordering events.

Define:

```text
canonical snapshot/history source
reseed/rebuild trigger
sequence boundary
when new viewers can be admitted
how existing clients reconnect/reconstruct
```

Do not make Redis/Nchan memory the only surviving copy of active-match history.

---

# 20B. M4 — frontend deployment continuity

Weekly live deploys apply to the frontend too.

Define a deployment strategy that does not break viewers who already have the previous application version open.

Prefer a pattern such as:

```text
content-hashed immutable JS/CSS assets
retain old asset versions during the deployment window
publish new HTML/manifest only after new assets exist
CloudFront serves old and new immutable assets during overlap
open clients keep their current code and reconnect/resume normally
```

Do not delete assets still referenced by open clients during a live deployment.

If the final Next.js hosting model differs, provide an equivalent atomic/versioned strategy.

---

# 20C. M4 — upstream-feed stall behavior

A best-effort provider can stall or omit events.

The viewer must not get a blank screen or fabricated state.

Define:

```text
retain last coherent canonical state
detect feed staleness
surface freshness/connection state where appropriate
do not invent missing score events
do not let local clock interpolation become authoritative when feed freshness is uncertain
```

This does not solve an event the provider never delivered; it makes the failure honest without clearing history.

---

# 20D. M4 — rollback, not only rollout

The assignment's weekly live-deploy requirement includes the practical need to recover from a bad release.

Define rollback for:

```text
canonical processor release
fan-out/delivery release
frontend asset release
```

Requirements:

```text
old and new versions must not reinterpret the same canonical event incompatibly
schema changes must be backward/forward safe over the rollout window
immutable frontend assets permit already-open old clients to keep running
rollback must not delete canonical history
clients reconnect/reconstruct instead of requiring manual refresh
```

Do not claim a database/schema migration is safely reversible unless the selected change strategy actually supports it.

---

# 20E. M4 — browser history/render scalability

The <=2s late-join requirement ends at a usable fan experience, not merely bytes arriving at JavaScript.

Define a frontend approach that avoids pathological DOM/render cost for a long event history.

Prefer a simple pattern such as:

```text
canonical reducer builds current state
event list uses efficient incremental rendering / virtualization if history is large
do not remount/clear the whole feed on every live event
batch non-critical React state work if necessary without violating live latency
```

Do not overengineer the UI, but do not assume a large event list can always be synchronously re-rendered within the history SLO.

This remains a production design inference because browser rendering was outside the local POC.

---

# 21. M4 — geography

Select a production origin strategy.

Evaluate:

```text
Europe-primary origin + global edge
North-America-primary origin + global edge
multi-region origin
```

Given the assignment's 60/40 EU/NA split, do not ignore geography.

But do not fabricate measured regional p95.

Prefer the simplest architecture that can plausibly meet latency and cost.

---

# 21A. M4 — do not size from the q5 collapse point

If Nchan remains in the final architecture, never reason:

```text
one node reached ~66k
therefore two nodes support ~132k
```

q5's ~65–66k point occurred with:

```text
worker connection exhaustion
exact 8 GiB memory ceiling
OOM/OOM-kill
correctness failures
reconnect failures
degraded latency
```

It is a **failure/collapse observation**, not a safe per-node capacity rating.

A final horizontally scaled Nchan design must use a conservative per-node planning envelope derived from:

```text
resource limits
connection-memory model
descriptor/worker model
operational headroom
N+1 requirement
hot-match distribution
```

and label that envelope:

```text
PLANNING_ASSUMPTION / PRODUCTION_INFERENCE
```

unless separately measured.

Do not claim the new multi-node fleet was validated by q5.

---

# 21B. M4 — prevent a new shared-store/routing bottleneck

If the replacement design uses multiple delivery nodes with shared Redis/Valkey or a routing tier, explicitly ask:

```text
Does every hot-match publication fan through one shared Redis bottleneck?
Does one routing process become the new connection bottleneck?
Does retained history reside in one memory failure domain?
Can the selected managed cache/store sustain the publication/history workload with HA?
What happens during failover?
```

At the assignment's event rate, publication throughput may be modest even when recipient fan-out is huge, but prove the architecture distinction rather than assuming it.

The final design must not replace:

```text
one overloaded Nchan primary
```

with:

```text
one overloaded custom router
```

or another unexplained singleton.

---

# 21C. M4 — production failure domains

For self-hosted AWS delivery infrastructure, prefer at least:

```text
two Availability Zones
```

or explain a managed-service equivalent.

The final architecture must identify:

```text
which state survives one delivery-node failure
which state survives one AZ failure
where clients reconnect
whether load-balancer/edge remains available
whether the retained-history store is HA
```

Do not claim regional disaster recovery unless designed and costed.

The assignment requires live deploy continuity, not necessarily multi-region disaster recovery.

---

# 22A. M4 — crowd-invariance requirement

The original assignment explicitly says the experience is identical whether approximately:

```text
100 viewers
or
100,000 viewers
```

including kickoff rush.

The production architecture must therefore preserve the **same correctness and UX semantics** across small and peak audiences.

Do not claim the POC performed a statistically controlled 100-vs-100k equality experiment; it did not.

Instead distinguish:

```text
required product invariant:
    same user-visible semantics at small and peak audiences

measured evidence:
    historical local experiment at assignment-mapped scale, with q5 INCONCLUSIVE

production design response:
    architecture removes audience-size-dependent correctness behavior
    and partitions capacity so scale changes do not change state semantics
```

The final proposal must address this requirement explicitly.

---

# 22B. M4 — N+1 capacity and live-deploy headroom

The assignment requires weekly deployments during live matches without viewers noticing.

Therefore a normal-load architecture that barely supports 100,000 viewers with every node healthy is insufficient.

For the final delivery tier, define:

```text
normal peak capacity
capacity during one-node/one-partition unavailability
capacity during rolling replacement
surge capacity during deployment
```

Require a defensible N+1 or equivalent availability model.

For a horizontally partitioned fleet, answer:

```text
Can 100,000 viewers remain served while one delivery node is draining/restarting?
Where do those connections reconnect?
Is retained/canonical state still available?
Can the +40,000/120s rush occur during degraded capacity?
```

If the final design cannot plausibly preserve service during one expected deployment/failure event:

```text
M4 is not complete.
```

M5 must include the cost of this deploy/failure headroom.

---

# 22C. M4 — history-to-live race must be formally closed

The final architecture must prevent a late join/reload/wake race such as:

```text
snapshot/history ends at canonical_seq = N
live subscription begins after N+K
events N+1..N+K disappear
```

or:

```text
history contains N
live tail replays N
event N is applied twice
```

Define one exact handoff rule.

Acceptable patterns include:

```text
subscribe/buffer live first, fetch snapshot/history at N, then apply only seq > N

or

retained ordered stream with a precise Last-Event-ID / canonical_seq boundary

or

another atomic cursor design with equivalent guarantees
```

The browser reducer must be idempotent by canonical sequence.

The proposal should explain this in one or two sentences, not with implementation code.

---

# 22D. M4 — never-blank viewer behavior

The assignment explicitly says:

```text
never a blank feed
never a manual refresh
```

Define user-visible failure behavior.

At minimum:

```text
keep last coherent rendered state while reconnecting
show connection/reconnecting status without clearing match history
resume from cursor when possible
fall back to canonical reconstruction if resume cannot close the gap
```

A reconnecting transport must not wipe the screen.

This belongs in the production design even though the POC did not implement the full UI.

---

# 22E. M4 — slow-client/backpressure production policy

The final delivery tier must not allow one slow/paused/mobile client to create unbounded per-client memory growth.

Define:

```text
bounded output buffering
disconnect/backpressure policy
client reconnect/resume path
server protection from slow consumers
```

The user experience remains recovery-oriented:

```text
disconnect slow client if necessary
preserve canonical/history state
reconnect and resume/reconstruct
```

Do not promise infinite buffering.

---

# 22F. M4 — score and clock ownership

The assignment requires both score and clock to be derived from the event stream.

The final canonical-state model must explicitly identify:

```text
score derivation
match-minute/clock derivation
provider event time / match-clock inputs
canonical sequence
```

Do not silently derive the official match clock from the browser's wall clock.

A client may locally interpolate display time only if anchored to canonical provider-derived state and periodically corrected.

---

# 22G. M4 — no second-POC loophole

Because the POC changed the production architecture, verify that the replacement architecture does not introduce a **new, custom, architecture-invalidating locally testable assumption** that is simply being ignored.

Ask:

```text
What assumption in the revised architecture would invalidate it if wrong?
Is that assumption already covered by q5's causal evidence?
Is it supported by mature documented service behavior?
Is it only production/cloud behavior that the assignment does not require us to deploy?
Or is it a genuinely new local uncertainty that should have been tested?
```

Preferred M4 closure:

```text
choose a final architecture whose remaining uncertainties are
documented managed/service behavior, production inference, or provider semantics,
not an untested custom local fan-out mechanism.
```

If the selected replacement creates a genuinely new locally testable critical risk:

```text
do not hide it merely to reach M6.
Surface it as an M4 blocker.
```

Under the candidate's stated assumption that M3 is closed, prefer an architecture that does not require a second artificial POC.

---

# 22H. M4 — POC causal-chain wording

The final design may differ from the design that entered M3.

That is valid.

The causal chain must be explicit:

```text
initial risky design assumption
-> POC
-> historical INCONCLUSIVE campaign plus direct DUT observations
-> architecture revision
-> final production design
```

Do not falsely say:

```text
the POC directly validated the final replacement topology
```

unless it actually did.

The assignment explicitly asks what the experiment changes in the proposal, so a design revision is a legitimate outcome.

---

# 22I. M4 — final architecture artifact

The final M4 artifact must include:

```text
historical q5 machine verdict
direct architecture evidence used
withdrawn old assumption
candidate comparison
final selected architecture
end-to-end data flow
partition/routing model
history/reconnect model
deploy/recovery model
provider boundary
geographic model
key rejected alternatives
what remains unmeasured
```

End with:

```text
M3 historical verdict: INCONCLUSIVE
M4 architecture decision: <one sentence>
single-primary Nchan 100k assumption retained: NO
final fan-out architecture: <one sentence>
M4 completion: 100%
```

---

# 23. M4 — update architecture source of truth

Update or supersede the architecture docs so there is one current design.

At minimum reconcile:

```text
internal_docs/LIVE_MATCH_CENTRE_MINIMUM_DEFENSIBLE_ARCHITECTURE.md
internal_docs/LIVE_MATCH_CENTRE_EQC_AC_ARCHITECTURE_CONTRACT_*.md
internal_docs/RISK_TARGET_ALIGNMENT.md
internal_docs/TRACEABILITY_MATRIX.md
```

If M4's fresh alternative comparison materially changes the previous third-party decision, update or supersede the relevant third-party research decision record too.

Do not leave an old one-primary architecture marked as current if M4 rejects that assumption.

Historical versions may remain, but they must be clearly superseded.

---

# 24. M4 completion gate

M4 is DONE only if:

```text
[ ] q5 remains INCONCLUSIVE
[ ] single-primary assumption remains withdrawn
[ ] one final production architecture is selected
[ ] hot-match partitioning is solved
[ ] q5 collapse point is NOT used as a safe per-node capacity rating
[ ] no shared Redis/routing singleton becomes an unexplained new bottleneck
[ ] failure domains / multi-AZ or managed equivalent are explicit
[ ] crowd invariance from ~100 to 100,000 is addressed without false benchmark claims
[ ] N+1 / rolling-deploy capacity is explicit
[ ] +40k/120s surge does not rely solely on reactive capacity boot
[ ] deploy/failure reconnect thundering-herd behavior is controlled
[ ] routing/ownership is explicit
[ ] canonical truth is explicit
[ ] current score/state and canonical history share one atomic/versioned commit boundary
[ ] provider schema validation/normalization/evolution policy is explicit
[ ] provider transport assumption/boundary is explicit
[ ] accepted-event retry/poison policy is explicit
[ ] canonical sequence vs provider/transport identity is explicit
[ ] delivery/history-store rebuild from canonical state is explicit
[ ] score and official clock ownership are explicit
[ ] history/late join is explicit
[ ] browser history/render path is bounded enough for the <=2s design
[ ] history-to-live handoff race is closed
[ ] reconnect is explicit
[ ] upstream-feed-stall behavior is explicit
[ ] never-blank client behavior is explicit
[ ] bounded slow-client/backpressure policy is explicit
[ ] deployment/recovery/rollback is explicit for backend AND frontend assets
[ ] geography is explicit
[ ] no new critical locally-testable custom risk is silently ignored
[ ] provider semantics remain honest
[ ] architecture source-of-truth updated
[ ] no contradiction with preserved M3 evidence
[ ] final M4 artifact exists
```

If any fail:

```text
continue M4
```

---

# 25. Milestone 5 — objective

Close all evidence needed to defend the final M4 architecture.

Create/finalize:

```text
internal_docs/M5_CURRENT_EXTERNAL_EVIDENCE_LEDGER.md
internal_docs/M5_PARAMETRIC_COST_MODEL.md
internal_docs/M5_FINAL_PROPOSAL_EVIDENCE_CLOSURE.md
```

If strong equivalent files already exist:

```text
update them instead of duplicating.
```

---

# 26. M5 — current web research is mandatory

Use the live web.

For mutable architecture facts:

```text
prefer primary official sources
record retrieval date
record URL
record exact supported claim
```

AWS:

```text
docs.aws.amazon.com
aws.amazon.com pricing/product pages
AWS What's New where feature recency matters
```

Next.js:

```text
nextjs.org
```

Nchan if retained:

```text
official Nchan docs/repository
```

Other vendor:

```text
official vendor docs
```

Do not rely on model memory for 2026 pricing.

---

# 27. M5 — only research the final architecture deeply

After M4:

```text
freeze SELECTED_COMPONENTS
```

Research those components thoroughly.

Do not spend most of M5 documenting services rejected by M4.

Keep rejected-alternative evidence only where needed to defend a major trade-off.

---

# 28. M5 — CloudFront verification

If selected, verify current:

```text
VPC/private origins
NLB compatibility
SSE/streaming behavior
chunked response behavior
origin response timeout semantics
long-lived response behavior
cache-disabled live paths
request forwarding
pricing
```

Also compare current CloudFront pricing models, including any 2026:

```text
pay-as-you-go
flat-rate plans
```

Verify exact current:

```text
plan names
monthly prices
data-transfer allowances
request allowances
private-origin eligibility
WAF/DDoS/DNS/logging inclusions
usage rules
```

Do not copy old pricing.

---

# 29. M5 — static Next.js path

Verify current official Next.js behavior for:

```text
App Router
static export
client components
native EventSource
route/query design used by final frontend
```

The assignment asks for Next.js App Router but does not require building the production frontend.

---

# 30. M5 — ingest stack verification

For each selected service verify current semantics/pricing.

If final design keeps the current family:

## API Gateway HTTP API

Verify:

```text
direct AWS service integration to SQS if used
request parameter mapping
payload limits
throttling
pricing
```

## SQS FIFO

Verify:

```text
ordering scope
message-group concurrency
deduplication
Lambda FIFO integration
throughput limits
pricing
```

Never imply:

```text
SQS FIFO manufactures correct provider semantic order.
```

## Lambda

Verify:

```text
SQS FIFO event-source behavior
retries/failure
VPC requirement
pricing
```

## DynamoDB

Verify:

```text
transactions
conditional writes
idempotency pattern
item/transaction limits
pricing
```

---

# 31. M5 — fan-out stack verification

For the final selected delivery technology verify:

```text
horizontal scaling model
connection limits
history/replay support
failure behavior
long-lived connection support
deploy behavior
pricing
```

If Nchan remains in a horizontally partitioned fleet:

verify:

```text
Redis compatibility
shared-state semantics
worker/process behavior relevant to design
whether proposed routing model is supported by surrounding AWS components
```

Do not claim that M3 validated the new horizontal topology.

It is a production architecture inference informed by q5.

---

# 32. M5 — AWS load-balancing/routing verification

If using NLB/ALB or another AWS router, verify:

```text
long-lived SSE support
routing capabilities
target-group behavior
connection draining/deregistration
stickiness/affinity if relied upon
cross-zone behavior
health checks
pricing
```

If deterministic match/channel partitioning requires application-aware routing that NLB cannot provide:

```text
do not pretend NLB does it.
```

Either:

```text
introduce the smallest justified routing layer
use separate endpoints/target groups
use a technology with suitable native routing
```

Then include the cost/complexity.

---

# 33. M5 — ElastiCache/Redis-compatible service

Verify the exact final engine:

```text
Redis OSS
Valkey
another compatible service
```

Check:

```text
Nchan compatibility if applicable
node availability
Multi-AZ
replication/failover
pricing
cross-AZ cost
memory sizing
```

Do not mix Redis OSS and Valkey names casually.

---

# 34. M5 — EC2/ASG

If selected:

verify:

```text
current instance price
instance availability
EBS
Auto Scaling Group
Instance Refresh
minimum healthy percentage
instance warm-up
NLB/ALB draining interaction
```

The final baseline fleet must be explicit.

Do not derive exact production capacity from q5 if q5 did not validly measure that topology.

Use conservative inference and clearly label it.

---

# 35. M5 — managed alternative repricing

Because the old architecture has been materially weakened, refresh pricing for the strongest managed alternative.

Do not assume the old result:

```text
"managed fan-out is too expensive"
```

is still true.

Calculate it under the current 100k workload model.

If a managed option now beats the self-hosted option on:

```text
cost
complexity
capacity confidence
```

loop back to M4.

---

# 36. M5 — security

Use only proportionate controls.

Verify selected:

```text
TLS
CloudFront protections
Shield Standard if relied upon
private origins
security groups
least privilege
ingress throttling
WAF only if genuinely selected
```

Do not add paid products just because they exist.

---

# 37. M5 — observability

Define minimum production observability:

```text
provider-ingest failures
SQS queue depth/age
processor errors
canonical-sequence violations
DynamoDB failures/throttling
delivery-node CPU/memory/connection count
delivery-node OOM
Redis health/memory
load-balancer target health
CloudFront errors
end-to-end timestamp metrics
```

Estimate material cost.

---

# 38. M5 — hidden infrastructure audit

Explicitly determine:

```text
VPC
subnets
NAT Gateway
Internet Gateway
VPC endpoints
public IPv4
cross-AZ transfer
Route 53
ACM
EBS
CloudWatch
backups
data transfer
```

For each:

```text
REQUIRED
NOT REQUIRED
OPTIONAL
```

Never omit NAT just because it is expensive.

If the architecture avoids NAT:

```text
explain technically why.
```

---

# 38A. M5 — end-to-end latency budget

The assignment's event latency SLO is:

```text
ingest -> viewer screen
```

Build an explicit planning latency budget for:

```text
durable ingress/enqueue
canonical processing/write
fan-out publication
origin/edge/network delivery
browser parse/reducer/render
```

For goals:

```text
total p95 budget <= 2s
```

For routine events:

```text
total p95 budget <= 5s
```

Do not fabricate measured AWS/browser latency.

Classify each stage as:

```text
POC measurement
current service fact
planning budget
production inference
not measured
```

The purpose is to show the design has plausible headroom, not to claim production proof.

Keep the separate:

```text
full-history visible <=2s
```

budget as well.

---

# 38B. M5 — service quotas and connection-scale feasibility

For every selected managed edge/load-balancing/fan-out component, verify current limits relevant to:

```text
100,000 concurrent long-lived viewer connections
+40,000 connection attempts in 120 seconds
8 matches plus any sub-shards
origin connections
requests/messages per second
connection duration
```

Record whether each relevant quota is:

```text
default
adjustable
hard
not applicable
```

If a quota increase is required before production:

```text
state it as a pre-launch requirement
do not imply the default quota already supports the workload
```

For self-hosted components, replace service quotas with explicit:

```text
OS/process/memory/file-descriptor/connection planning limits
```

---

# 38C. M5 — regional latency must not be hidden by a global claim

Evaluate Europe and North America separately at the design-inference level.

Do not write:

```text
global p95 should be fine
```

if one region has a systematically longer origin path.

For each audience region, reason about:

```text
viewer -> edge
edge/live-stream origin path
selected origin region
expected qualitative RTT contribution
remaining latency budget
```

Do not fabricate measured regional p95 values.

If one region appears unable to fit the 2s goal budget under the selected single-origin design:

```text
return to M4.
```

---

# 38D. M5 — conflicting authoritative sources

If two current primary sources appear inconsistent about:

```text
price
quota
regional availability
timeout
protocol behavior
feature eligibility
```

do not silently pick the convenient value.

Resolve the discrepancy using:

```text
newer official documentation
service-specific pricing page
AWS Price List/official calculator where appropriate
supporting official release notes
```

or record the uncertainty and use the conservative interpretation.

---

# 38E. M5 — verify live-stream connection semantics through the edge

If CloudFront or another edge proxy fronts SSE/WebSocket traffic, verify from current official documentation:

```text
whether viewer long-lived streams correspond to dedicated origin requests/connections
whether HTTP/2/3 viewer multiplexing changes origin connection count
whether edge nodes cache/coalesce any live-stream payload
origin connection limits/timeouts
connection reuse behavior
```

Size the origin/load-balancer/fan-out tier for the documented/worst defensible connection model.

Do not assume CDN presence turns 100,000 viewer streams into a small number of origin connections.

---

# 38F. M5 — connection-oriented billing math

For selected connection-oriented services, model their actual billing dimensions.

Examples may include:

```text
CloudFront:
    request/connection treatment + transferred bytes under the current pricing model

NLB:
    new connections/flows
    active connections/flows
    processed bytes
    NLCU dimensions

managed fan-out:
    connection minutes
    messages/events
    per-recipient deliveries
    transferred bytes
```

Use the exact current selected-service model.

For SSE specifically:

```text
do not count each event inside one open SSE response as a new HTTP request unless billing documentation actually does
```

Also avoid the opposite error:

```text
do not ignore new/reconnect request volume during kickoff, deploy, and failure recovery
```

---

# 39. M5 — cost model inputs

Assignment facts:

```text
100,000 peak viewers
8 matches
~10 events/s steady
~50 events/s burst
+40k in 120s
60% EU / 40% NA
$3,000/month peak budget
```

Not assignment facts:

```text
viewer-hours/month
average session duration
average payload size
monthly number of matches
lobby-viewer fraction
hot-match-viewer fraction
average concurrency
```

Unknowns must be:

```text
planning assumptions
or sensitivity variables.
```

---

# 39A. M5 — pricing metadata and billing basis

The cost model header must explicitly state:

```text
currency
pricing retrieval date
AWS region(s)
CloudFront pricing model/plan
on-demand vs reserved/commitment basis
hours-per-month convention
GB vs GiB billing-unit convention
tax excluded unless the pricing source states otherwise
```

If comparing non-AWS alternatives, state their billing currency/region assumptions too.

Never mix rates from different regions or pricing modes without labeling them.

---

# 39B. M5 — live-event-hours / ingest-volume sensitivity

Viewer-hours alone do not determine:

```text
ingress requests
SQS messages
processor/Lambda work
DynamoDB writes
canonical event storage
```

The assignment gives peak event rate, not monthly live-match duration.

Introduce an explicit variable such as:

```text
LIVE_MATCH_HOURS_PER_MONTH
```

or:

```text
ACTIVE_EVENT_STREAM_HOURS_PER_MONTH
```

Then derive:

```text
steady events/month
burst-event sensitivity
ingress/API/adapter requests
queue messages
processor invocations/duration
canonical writes
storage
```

Use a sensitivity range rather than inventing a monthly schedule.

If these costs are negligible versus viewer delivery, prove that with arithmetic.

---

# 39C. M5 — canonical-history retention/storage assumption

The live product needs active-match history, but the assignment does not specify how long completed-match history is retained.

Choose and label a planning assumption for:

```text
active-match canonical event retention
completed-match retention
durable storage lifecycle
delivery-cache TTL/history lifetime
```

Cost that policy.

Do not claim indefinite archival retention is an assignment requirement.

---

# 40. M5 — viewer-delivery math

Do not incorrectly compute:

```text
10 events/s * 100,000 viewers
```

unless all viewers receive all events.

Model:

```text
match viewer
lobby viewer
8-match distribution
hot-match case
```

Derive:

```text
events/viewer/sec
bytes/viewer-hour
edge transfer/month
```

Show formulas.

---

# 41. M5 — payload size

Derive a defensible range from:

```text
current POC event schema
JSON serialization
SSE framing
```

Use:

```text
small
base
large
```

or equivalent sensitivity.

State:

```text
synthetic POC payload != real provider payload fact.
```

---

# 42. M5 — monthly peak viewer-hours

The assignment does not define monthly peak duration.

Show sensitivity.

At minimum consider:

```text
30
60
120
240
720/730 peak viewer-hours/month
```

or a better justified range.

Calculate where possible:

```text
budget break-even viewer-hours.
```

---

# 43. M5 — fleet-size sensitivity

For the final fan-out architecture, model several plausible production fleet sizes/topologies.

For example:

```text
minimum HA baseline
base recommendation
higher-headroom case
```

Do not use a meaningless 2/3/4-node table if the actual design partitions differently.

For each:

```text
capacity assumption
fixed monthly cost
availability trade-off
hot-match behavior
```

Then choose one final proposal baseline.

---

# 43A. M5 — bound the full-history path

The assignment requires:

```text
full match history visible within 2 seconds
```

Make this design claim quantitatively defensible without pretending it was production-tested.

Estimate/bound:

```text
representative event bytes
SSE/JSON framing where relevant
events per match over a reasonable match-duration assumption
full-history bytes for one match
origin/server processing path
viewer transfer time sensitivity
browser reconstruction/rendering remains unmeasured
```

If match duration is assumed:

```text
label it PLANNING_ASSUMPTION.
```

If the final design sends a compact canonical snapshot plus event history, distinguish the sizes.

Do not use a single synthetic POC payload size as a real-provider fact.

---

# 43B. M5 — N+1/deployment cost must be included

Cost the architecture that actually satisfies live deployment/failure behavior.

Do not price:

```text
minimum nodes needed only when all nodes are healthy
```

while proposing:

```text
N+1 / rolling replacement
```

For the final baseline show:

```text
normal node count
minimum healthy count during deployment
spare/failover capacity
cost of that baseline
```

If autoscaling supplies temporary headroom, include the assumed duration/rate or explain why it is immaterial.

---

# 43C. M5 — long-lived SSE operational requirements

If SSE remains selected, verify current official behavior relevant to long-lived connections:

```text
CloudFront/origin timeout semantics
idle timeout behavior
keepalive/comment heartbeat need if any
load-balancer idle timeout if applicable
connection draining
retry/reconnect behavior
```

If a heartbeat is required to keep intermediaries healthy:

```text
include it in architecture reasoning and bandwidth sensitivity.
```

Do not assume WebSocket timeout documentation automatically applies to SSE.

---

# 43D. M5 — audience geography in transfer pricing

If edge/data-transfer price varies by geography or pricing model, reflect the assignment's:

```text
60% Europe
40% North America
```

in the cost model where material.

If a flat-rate plan eliminates the distinction for the modeled usage:

```text
state that from current official pricing.
```

Do not use a single cheapest-region egress rate for all viewers unless that is how the selected pricing model actually bills.

---

# 43E. M5 — price pre-provisioned kickoff capacity

The baseline cost must reflect the M4 surge strategy.

If the design uses self-hosted delivery nodes:

```text
price the peak capacity already warm before kickoff
include N+1/deploy/failure spare capacity
do not assume the +40k rush is served by nodes billed only after reactive scale-up
```

If scheduled pre-scaling means peak nodes are not needed 730 hours/month, model:

```text
base always-on HA fleet
scheduled peak-capacity hours/month
sensitivity for how often peak fixtures occur
```

Label fixture/peak hours as planning assumptions.

---

# 43F. M5 — full-history browser-work sensitivity

Extend the <=2s full-history bound beyond transfer bytes.

At minimum estimate or reason about:

```text
event count
JSON parse/reducer work
initial React render
event-list DOM size
virtualization/incremental rendering if needed
```

Do not invent a measured browser p95.

The goal is to show that the proposed frontend avoids an obviously unbounded render path.

---

# 44. M5 — complete cost ledger

Include all selected material costs.

Possible lines:

```text
CloudFront
S3
API Gateway
SQS FIFO
Lambda
DynamoDB
load balancer
routing tier if needed
EC2
EBS
ElastiCache
CloudWatch
Route 53
VPC endpoints
NAT
cross-AZ transfer
internet/data transfer
backup/storage
```

For each:

```text
unit price
unit
region
date
source
quantity
formula
monthly total
```

---

# 45. M5 — cost conclusion

Separate:

```text
fixed monthly infrastructure cost
variable viewer-delivery cost
variable ingest/state cost
dominant cost driver
sensitivity
budget break-even
```

Classify final architecture:

```text
WITHIN BUDGET
CONDITIONALLY WITHIN BUDGET
OUTSIDE BUDGET
```

If outside:

```text
return to M4.
```

Do not force the model under $3,000 through unrealistic assumptions.

---

# 46. M5 — geography

Make one final geographic decision.

State:

```text
selected AWS region/origin strategy
why
how CloudFront/edge is used
why multi-region is or is not justified
```

Do not invent measured EU/NA p95.

Use:

```text
production inference based on network topology
```

where appropriate.

---

# 47. M5 — POC-to-production mapping

Create a strict table:

```text
ASSIGNMENT_FACT
CURRENT_OFFICIAL_FACT
POC_MEASUREMENT
INVALID_HISTORICAL_POC_MEASUREMENT
DIRECT_ARCHITECTURE_OBSERVATION
CALCULATION
PLANNING_ASSUMPTION
PRODUCTION_INFERENCE
UNRESOLVED_EXTERNAL_ASSUMPTION
```

Use it to prevent q5 overclaim.

Explicitly mark:

```text
real provider behavior = not measured
browser rendering = not measured
real EU/NA Internet = not measured
actual AWS deployment = not measured
actual weekly deploy = not measured
actual production spend = not measured
```

---

# 47A. M5 — decision provenance, not only number provenance

The assignment says:

```text
Every number and every decision in the submission should be yours to stand behind and explain.
```

Before closing M5, create or extend an internal decision ledger covering every material final choice:

```text
decision
selected option
strongest rejected alternative
reason winner won
evidence/source
trade-off accepted
what would make the decision change
```

At minimum cover:

```text
SSE vs WebSocket
fan-out technology
fan-out partitioning/routing
history/replay model
canonical state store
queue/order model
load balancer/routing layer
Redis/Valkey/cache choice if any
origin region
single-region vs multi-region
CloudFront/edge choice
baseline fleet / HA level
security baseline
observability baseline
POC target
provider-boundary assumption
```

The final proposal can summarize these decisions concisely; the internal ledger exists so every submitted decision is explainable.

---

# 47B. M5 — anonymous public access must not expose private origins

Because viewers are public and anonymous:

```text
no viewer account/session state is required
```

but origin protection still matters.

Cover proportionately:

```text
TLS
private origins/security groups
public endpoint throttling/abuse protection
Shield/WAF only if selected
no auth-dependent routing
```

Do not introduce per-user authentication to solve an anonymous read-only product.

---

# 47C. M5 — do not over-credit CloudFront for live SSE geography

If CloudFront fronts a non-cacheable long-lived live stream, verify exactly what CloudFront does for that path.

Do not assume:

```text
"edge distribution" means live SSE payload is cached near the viewer.
```

Account for origin path/RTT and persistent-connection behavior when making the 60% Europe / 40% North America latency argument.

Static assets can benefit from normal CDN caching independently.

---

# 47D. M5 — observability must cover user-impact and data-health signals

The minimum observability plan must include, where applicable:

```text
provider/feed connection health and staleness
event ingest rate
schema/parse failures
queue depth/age or processing lag
canonical sequence anomalies
duplicates/gaps/order violations
fan-out delivery latency
connection establishment/failures
active viewer connections
delivery-node CPU/memory/OOM
cache/store memory/failover
load-balancer target health
regional/user-facing error rate
```

Avoid building a full observability platform in the POC.

This is production-design evidence only.

---

# 47E. M5 — reasonable operating margin

The <=$3,000/month cost conclusion must not use a baseline that consumes essentially the entire budget with no uncertainty margin.

Separate:

```text
modeled baseline
availability/N+1 headroom
usage sensitivity
reasonable operating/forecast uncertainty margin
budget ceiling
```

Do not invent a mandatory percentage from the assignment.

Choose a defensible margin or show sensitivity sufficient to demonstrate how close the design is to the ceiling.

If the architecture is only under $3,000 with zero margin and optimistic traffic assumptions:

```text
classify it CONDITIONALLY WITHIN BUDGET or return to M4.
```

---

# 47F. M5 — production measurement of ingest-to-screen SLO

The assignment's 2s/5s targets are viewer-screen SLOs.

The production design should include a lightweight way to observe them after launch rather than monitoring only server latency.

Define an approach such as:

```text
stamp each canonical event with server ingest/accept time
sample anonymous browser telemetry when an event is rendered/applied
aggregate goal vs routine-event end-to-end latency by geography
monitor p95 and data freshness
```

If browser/server clock skew affects the method:

```text
bound/correct it or state the measurement approximation.
```

Keep sampling low enough that telemetry does not become a material load/cost source.

No user account or identifying profile is required.

Include telemetry cost if material.

This is a production observability design, not additional POC code.

---

# 48. M5 final artifacts

The final evidence closure must include:

```text
selected M4 architecture
current-source ledger
cost model
cost conclusion
geographic decision
provider uncertainty
POC mapping
important alternative pricing comparison
```

End:

```text
M5 completion: 100%
```

---

# 49. M5 completion gate

M5 cannot close until:

```text
[ ] all selected mutable service facts have current sources
[ ] all selected prices have current source/date
[ ] old rejected architecture costs removed
[ ] hidden networking/support cost handled
[ ] pricing currency/date/region/billing basis explicit
[ ] viewer math correct
[ ] payload assumptions explicit
[ ] full-history <=2s path is quantitatively bounded
[ ] end-to-end goal/routine 2s/5s planning latency budget explicit
[ ] Europe and North America latency implications are considered separately
[ ] viewer-hours sensitivity explicit
[ ] live-event-hours/ingest-volume sensitivity explicit
[ ] canonical-history retention/storage assumption explicit
[ ] hot-match cost/capacity handled
[ ] baseline fleet explicit
[ ] 100k/+40k relevant service quotas or self-hosted scale limits verified
[ ] live-stream edge->origin connection semantics are verified
[ ] connection-oriented billing math matches the selected service
[ ] pre-provisioned kickoff/deploy capacity is priced
[ ] q5 ~66k collapse is not treated as safe per-node capacity
[ ] N+1/deployment headroom is included in baseline cost
[ ] shared cache/routing tier capacity and HA assumptions are explicit
[ ] SSE timeout/heartbeat operational facts are verified if SSE is selected
[ ] 60/40 audience pricing impact is reflected where material
[ ] geography explicit and CloudFront live-stream behavior is not overclaimed
[ ] production ingest-to-screen SLO has a credible browser-side/end-to-end measurement strategy
[ ] provider uncertainty explicit
[ ] POC mapping truthful
[ ] every material final architecture decision has an explainable provenance/trade-off record
[ ] every number and every decision expected in the submission is defendable
[ ] <=$3k conclusion includes availability headroom and reasonable uncertainty margin
[ ] no M5 finding invalidates M4 architecture
```

If M5 invalidates M4:

```text
loop M4 -> M5 again.
```

---

# 50. Milestone 6 — objective

Create the actual final:

```text
proposal.md
```

at repository root.

Do not submit an internal architecture contract.

Do not make reviewer read internal docs.

The proposal must stand alone.

---

# 51. M6 word limit

Hard maximum:

```text
1,500 words
```

Diagrams excluded.

Target:

```text
1,200–1,450 prose words
```

Record the final count internally.

If over:

```text
edit and recount.
```

---

# 51A. M6 word-count method

Use a deterministic word-count method and preserve the result internally.

For safety:

```text
count headings
count prose
count bullets
count table text
count non-diagram code/text
exclude only the actual architecture diagram block(s) that the assignment explicitly exempts
```

Do not exclude arbitrary fenced blocks merely because they are fenced.

Keep enough margin below 1,500 that minor counting differences do not create a violation.

---

# 52. M6 recommended structure

Keep compact.

For example:

```text
# Live Match Centre — Design Proposal

## Architecture
## Correctness, history and recovery
## Scale, latency and geography
## Deployment and operations
## Cost and trade-offs
## Riskiest assumption and POC
```

Do not create a 20-section proposal.

---

# 53. M6 architecture diagram

Include one concise:

```text
Mermaid
or ASCII
```

diagram.

It must reflect the final M4 architecture.

Show:

```text
provider
durable ingest
ordering/canonical processor
canonical state
fan-out/history partitions
edge
static Next.js
viewer
```

Distinguish:

```text
canonical truth
delivery/history state
```

---

# 54. M6 full path

A reviewer must understand:

```text
provider event
-> accepted durably
-> ordered/idempotent processing
-> canonical sequence/state
-> delivery/history publication
-> fan-out partition
-> CloudFront/edge
-> EventSource/client reducer
-> visible score/events
```

Explain lobby separately but briefly.

---

# 55. M6 correctness

Explain how, for accepted events:

```text
duplicate display is prevented
out-of-order display is prevented
score/history remain coherent
clock/state derive from canonical history
reconnect does not corrupt state
```

State provider limitation:

```text
an event never delivered upstream cannot be reconstructed without an upstream recovery source.
```

---

# 56. M6 history/reconnect

Explain:

```text
late join
reload
wake
reconnect
cursor
canonical sequence
fallback reconstruction
```

Do not include superseded replay architecture.

---

# 57. M6 performance

Use assignment targets exactly:

```text
goal p95 <=2s ingest->screen
other p95 <=5s
history <=2s
```

Then state which local values were actually observed and which parts remain production budget/inference.

Do not turn q5 fan-out values into success evidence.

---

# 58. M6 scale

Address:

```text
100k
+40k/120s
8 matches
hot match
10/s steady
50/s burst
```

The new horizontal architecture must explain why one popular match does not recreate the q5 single-primary bottleneck.

---

# 59. M6 geography

Address:

```text
60% EU / 40% NA
```

Use final M5 strategy.

No fabricated geographic measurement.

---

# 60. M6 deploys

Address weekly live deployment.

Explain:

```text
drain
replace
reconnect
resume
state survival
```

Use conservative wording.

---

# 61. M6 frontend

Explicitly satisfy:

```text
Next.js App Router
component-based
```

Describe:

```text
static/edge-served application as selected
small client live component
EventSource if SSE
idempotent sequence reducer
lobby component
match component
reconnect state
```

No need to build production UI.

---

# 61A. M6 — explicit crowd invariance

The proposal must explicitly address:

```text
experience materially equivalent at ~100 and 100,000 viewers
```

Do this without claiming a controlled equality benchmark.

Explain that:

```text
canonical correctness semantics do not change with audience size;
capacity is partitioned horizontally;
clients use the same snapshot/history/live protocol at small and peak load;
peak/surge scale changes resource consumption, not state semantics.
```

Also state the POC did not prove literal 100-vs-100k equality.

---

# 61B. M6 — never blank / snapshot-to-live handoff

The proposal must make two viewer-level guarantees understandable:

```text
last coherent state remains rendered while transport reconnects
history/snapshot-to-live handoff cannot create a sequence hole or double-apply an event
```

Use the exact final M4 cursor/handoff rule.

This closes:

```text
late join
reload
phone wake
never blank
no manual refresh
no duplicates
nothing disappears
out-of-order display
```

with one coherent frontend/state story.

---

# 61C. M6 — official score/minute wording

Make clear that:

```text
score and official match minute originate from canonical processing of provider events/state.
```

Do not imply the browser independently owns the official match clock.

---

# 61D. M6 — submission-language hygiene

`proposal.md` is a hiring deliverable, not an internal incident report.

Avoid unnecessary internal jargon such as:

```text
q5
Terminal A
R1/R2
v2.0.6
Milestone 2
campaign artifact paths
```

unless needed to identify evidence.

Prefer human-readable wording:

```text
the frozen three-run local campaign
the measured experiment
post-run measurement corrections
the original single-node fan-out assumption
```

The reviewer should understand the experiment without knowing the internal milestone system.

Do not hide the INCONCLUSIVE verdict; simply explain it cleanly.

---

# 61E. M6 — concise end-to-end latency budget

The final proposal should make the 2s/5s targets credible with a compact budget or explanation covering:

```text
ingest durability
canonical processing
fan-out
network/edge
browser
```

Clearly distinguish:

```text
measured local behavior
planning budget
unmeasured production/browser components
```

Do not claim production p95 was measured.

---

# 61F. M6 — provider transport assumption

State the concrete provider-ingress assumption in one concise sentence.

For example:

```text
I assume HTTPS push from the provider; a persistent vendor stream would replace only the ingress adapter, not the durable queue/canonical-processing/downstream design.
```

Use whatever final M4 assumption actually wins.

---

# 61G. M6 — frontend deployment versioning

The weekly-deploy paragraph must cover both:

```text
backend delivery nodes
frontend static/application assets
```

Mention immutable/versioned frontend assets or the equivalent selected mechanism so an already-open client is not broken when a new release is published.

---

# 61H. M6 — accepted-event processing failure

In the correctness/recovery explanation, state that an event durably accepted into the system is not silently skipped because one processing attempt fails.

A concise statement may cover:

```text
retry + idempotent canonical write + alert/quarantine/reconciliation
```

---

# 61I. M6 — delivery-cache rebuild

State that the delivery/history cache is rebuildable from canonical durable state.

Do not imply Redis/Nchan retained history is the only surviving copy of an active match.

---

# 61J. M6 — schema evolution

The end-to-end architecture explanation should mention that provider events are validated/normalized into a stable canonical model.

Keep it concise:

```text
version-aware validation/normalization prevents an upstream schema change from silently corrupting canonical state.
```

Do not invent the real provider schema.

---

# 61K. M6 — rollback

The deploy paragraph must include rollback, not only forward rollout.

State how:

```text
backend versions overlap safely
canonical state remains compatible
frontend immutable assets allow old open clients to continue
a bad release can be rolled back without blanking viewers or deleting history
```

---

# 61L. M6 — regional latency honesty

Do not use a single aggregate statement to hide geography.

The proposal should say why the selected origin/edge strategy is credible for both:

```text
Europe (~60%)
North America (~40%)
```

while clearly labeling regional performance as a production inference, not a measured POC result.

---

# 61M. M6 — make the viewer-facing SLO observable

In the compact operations/observability wording, mention that production monitoring includes sampled end-to-end event latency to the browser/render boundary, separated for:

```text
goals
routine events
Europe
North America
```

Do not imply backend publish latency alone measures the assignment SLO.

---

# 61N. M6 — kickoff capacity must already be available

In the scale/surge paragraph, say how the final architecture absorbs:

```text
+40,000 viewers in 120 seconds
```

without depending solely on infrastructure booting after the surge begins.

If self-hosted:

```text
pre-provision/pre-scale peak capacity before known kickoffs
```

or state the final equivalent.

---

# 61O. M6 — browser history rendering

The late-join/frontend paragraph should make clear that large histories do not require remounting an unbounded DOM.

Mention the selected efficient/virtualized event-list approach if the final history-size model makes it relevant.

Keep this to one sentence.

---

# 62. M6 cost

State:

```text
baseline monthly cost
main traffic assumption
dominant variable
budget result
```

Round reasonably.

Do not put the full cost ledger into the proposal.

---

# 63. M6 trade-offs

Show important decisions only.

At minimum:

```text
SSE vs WebSocket
final fan-out approach vs strongest alternative
horizontal partitioning model
single-region vs multi-region
self-hosted vs managed
```

Avoid catalog-style lists.

---

# 64. M6 POC section

This must be precise.

State:

```text
overall least-trusted design assumption:
    provider semantics

why not directly testable:
    no real provider/schema supplied

riskiest locally testable assumption:
    local fan-out/history/capacity layer

historical qualifying result:
    INCONCLUSIVE

direct architecture observations:
    enough to withdraw the one-primary 100k assumption

proposal change:
    final M4 fan-out topology replaces the one-primary shape
```

If repository truth has evolved by execution time:

```text
use actual final M4 wording.
```

Never say:

```text
"POC passed."
```

---

# 64A. M6 — POC chronology must be logically exact

Because the experiment changed the architecture, write the POC relationship chronologically rather than pretending the final topology existed before the experiment.

A defensible shape is:

```text
1. The overall weakest assumption was provider-feed semantics, but no real provider/schema was supplied, so it was not locally testable.
2. The next architecture-invalidating locally testable assumption was the original Nchan/Redis/SSE fan-out shape.
3. The frozen local campaign was INCONCLUSIVE overall, but direct DUT observations were sufficient to withdraw the one-primary 100k assumption.
4. The final proposal therefore uses <final replacement topology>.
5. The replacement topology is not claimed to have been benchmark-validated by q5; its remaining claims are supported by current service facts, conservative capacity design, cost analysis, and explicit production inferences.
```

This directly satisfies the assignment's requirement to explain:

```text
assumption -> method -> result -> what it changes in the proposal.
```

---

# 65. M6 claim-language audit

Search for:

```text
guarantee
proves
always
identical
zero downtime
exactly once
unlimited
global p95
```

Every usage must be justified.

Prefer:

```text
designed to
measured locally
observed
inferred
bounded by
requires provider validation
```

---

# 66. M6 number audit

Every number must be classified internally as:

```text
ASSIGNMENT_FACT
POC_OBSERVATION
CALCULATION
PLANNING_ASSUMPTION
CURRENT_OFFICIAL_FACT
PRODUCTION_INFERENCE
```

Remove unexplained precision.

---

# 67. M6 assignment coverage matrix

Before marking M6 DONE, prove the proposal covers:

```text
public anonymous read-only
lobby
match page
late join
reload
wake
score coherence
no duplicate display
no loss of accepted events
ordered display
2s goal
5s other
2s history
8 matches
10/s
50/s
100k
40k/120s
60/40 geography
$3k
weekly live deploys
Next.js App Router
AWS preference
least-trusted assumption
POC
important trade-offs
```

Every row:

```text
COVERED
```

---

# 68. M6 completion gate

M6 = DONE only if:

```text
[ ] proposal.md exists
[ ] <=1500 prose words
[ ] final architecture only
[ ] no old one-primary diagram
[ ] whole system understandable
[ ] assignment fully covered, including 100-vs-100k crowd invariance
[ ] provider-ingress transport assumption is explicit
[ ] provider schema validation/normalization/evolution is addressed
[ ] accepted-event failure handling does not silently lose accepted history
[ ] end-to-end 2s/5s latency budget is honest
[ ] production viewer-screen SLO observability is included
[ ] delivery-cache loss/rebuild path is coherent
[ ] frontend/backend live-deploy AND rollback are covered
[ ] lobby includes score/minute plus state-changing and routine live events as appropriate
[ ] never-blank / no-manual-refresh behavior is explicit
[ ] history-to-live sequence boundary is explicit
[ ] score/minute are provider-derived canonical state
[ ] N+1/live-deploy story is credible
[ ] +40k/120s surge capacity is already available/pre-scaled or managed equivalently
[ ] large-history browser rendering is addressed
[ ] cost matches M5
[ ] POC story matches M4
[ ] POC chronology satisfies assumption -> method -> result -> proposal change
[ ] causal chain makes clear the POC changed rather than validated the final topology
[ ] every material number and decision in proposal.md is traceable/defendable
[ ] reviewer-facing language avoids unnecessary internal milestone jargon
[ ] provider boundary honest
[ ] no unsupported certainty
[ ] one coherent architecture
```

---

# 69. Milestone 7 — objective

Replace the root placeholder README with the actual final:

```text
README.md
```

It must be reviewer-facing.

---

# 69A. M7 — mandatory POC source/result coherence decision

Before writing the README result section, explicitly reconcile this historical fact:

```text
qualifying q5 measurements were produced by v2.0.5 source

current poc/ contains post-q5 v2.0.6 measurement/harness corrections
```

The README and final submission must never imply that current v2.0.6 source produced the historical q5 numbers if it did not.

Create an internal decision record:

```text
internal_docs/M7_POC_SOURCE_RESULT_COHERENCE.md
```

It must state:

```text
which source produced the submitted measured campaign
which source is present in final poc/
what changed after the measured campaign
whether those changes affect DUT behavior, measurement validity, or only harness correctness
what command the reviewer runs
what result should or should not be expected from current source
why the reported historical result remains the correct evidence
```

Choose one truthful reviewer-facing strategy.

Examples:

### Strategy A — current corrected POC is shipped

Then README must say, concisely:

```text
the reported qualifying campaign was run on the frozen pre-correction source;
the submitted POC includes post-campaign measurement/harness corrections;
the historical verdict is not retroactively changed;
the current command reruns the experiment machinery and may produce a new environment-dependent classification.
```

### Strategy B — exact historical measured source is shipped

Only use this if deliberate and defensible.

Do not ship known broken measurement machinery merely for cosmetic reproducibility without explaining it.

### Strategy C — another coherent packaging approach

Allowed only if:

```text
one-command requirement still holds
nothing generated is shipped
historical result provenance is exact
reviewer is not misled
```

This coherence problem must be solved before M7 can be marked DONE.

---

# 70. M7 run instructions

The reviewer should need only:

```text
container runtime
```

No:

```text
host Node
host npm
AWS account
credentials
Redis install
Nginx install
```

Document the actual final runnable POC command.

---

# 71. M7 no-.git rule

The final ZIP will not contain `.git`.

The documented POC path must still work.

If final execution requires:

```text
poc/SOURCE_COMMIT
```

or another packaged identity file:

make sure later packaging can supply it automatically.

Do not tell the reviewer to reconstruct a Git commit manually unless the final POC truly requires it and the assignment permits that workflow.

---

# 71A. M7 — verify the documented reviewer command without manufacturing new M3 evidence

M7's milestone gate says the run instructions must be tested.

Do not satisfy this by silently creating a new favorable 100k campaign.

Verify the final documented run path at the appropriate level:

```text
shell/script syntax
Docker Compose config resolution
no host Node/npm dependency
no cloud credentials
no hidden local service
no .git dependency in ZIP-like mode
source-identity handling
container/image build path
portable non-qualifying smoke where appropriate
```

If the full qualifying command is documented, you may verify that it launches correctly and that its machine verdict is authoritative, but:

```text
do not overwrite historical q5 evidence
do not treat a new ad-hoc run as the submitted measured campaign
do not cherry-pick its result
```

Prefer a clean ZIP-like validation plus the already-passed non-qualifying corrected smoke for command-path confidence, then leave the exact historical qualifying result clearly identified.

---

# 71B. M7 — runtime and host-resource honesty

The assignment requires only a container runtime, but a 100k local load test can require substantial CPU/RAM/file-descriptor capacity.

If the final reviewer command has meaningful host requirements:

```text
state them briefly and honestly.
```

Do not claim:

```text
runs on any laptop
```

unless proven.

If an underpowered host can yield `INCONCLUSIVE`, say that the machine classification distinguishes environment invalidity from DUT evidence.

Expected runtime may be stated only from observed/frozen experiment duration, not guessed.

---

# 71C. M7 — README run-instruction minimum content

The README run section must explicitly state:

```text
prerequisite: container runtime only
working directory
the exact one command
what containers/services start
expected runtime or observed range
where/when the measured summary appears
how to interpret ACCEPT / REJECT / INCONCLUSIVE
cleanup command if useful
which command is qualifying vs smoke/reduced validation
```

Do not assume these facts are obvious from shell scripts.

---

# 71D. M7 — material version/pinning check

Before documenting the reviewer command, statically verify that material POC versions are pinned or deterministically constrained where practical:

```text
container images/base images
Nchan/Nginx version
Node/runtime
package lockfile/dependencies
Redis image
```

Do not introduce host package-manager requirements.

If a material dependency intentionally floats, document why it cannot invalidate reproducibility.

The final clean-room proof still belongs to M8, but M7 must not publish a run command that is obviously non-deterministic.

---

# 72. M7 smoke vs qualifying evidence

Be explicit:

```text
portable smoke / reduced validation
!=
historical qualifying q5 evidence
```

The current v2.0.6 smoke is:

```text
NOT_APPLICABLE
direct_accept_eligible=false
```

Do not call it the 100k result.

The historical q5 campaign is the qualifying measured experiment and remains INCONCLUSIVE.

---

# 73. M7 measured-output explanation

Briefly explain:

```text
what starts
what is measured
where verdict/output appears
what ACCEPT/REJECT/INCONCLUSIVE means
```

Do not dump internal test details.

---

# 74. M7 POC write-up

Create one bounded section of:

```text
<=300 words
```

It must cover exactly:

```text
assumption
method
result
what changed in proposal
```

No placeholders.

---

# 75. M7 assumption wording

Include both:

```text
overall weakest assumption:
provider semantics

locally testable assumption:
Nchan/Redis/SSE delivery/history/capacity behavior at assignment scale
```

Explain why provider semantics were not locally testable.

---

# 76. M7 method wording

Keep concise.

Use actual q5 method facts such as:

```text
simulated stream
8 matches
100k target
+40k/120s surge
4 coordinated generator shards
correctness/reconnect/restart/late-join/slow-client scenarios
3 frozen runs
machine verdict
```

Do not reproduce the whole contract.

---

# 77. M7 result wording

State:

```text
q5 = INCONCLUSIVE
```

Then explain:

```text
why the overall classification was inconclusive
```

and the direct architecture evidence M4 used.

Do not list invalid generator CPU numbers as if valid.

Use the corrected M4 interpretation.

---

# 78. M7 proposal-impact wording

Match M4/M6 exactly.

Shape:

```text
The campaign did not validate the one-primary design. Direct Nchan memory/OOM and per-worker connection-limit evidence caused the proposal to replace the single-primary fan-out assumption with <final M4 architecture>.
```

Adapt to the actual selected architecture.

---

# 79. M7 300-word audit

Count only the POC write-up.

Record internally:

```text
POC write-up words = <n>
```

Target:

```text
~180–260
```

for margin.

---

# 79A. M7 POC write-up word-count method

Define a clear start/end boundary for the <=300-word POC write-up.

Count conservatively:

```text
section heading(s) inside the write-up
paragraphs
bullets
inline labels such as Assumption / Method / Result / Proposal impact
```

Do not exclude words merely because they appear in a table or code block.

Target well below 300.

Keep run instructions and AI-process text outside the bounded POC write-up section so the reviewer can see exactly what is subject to the limit.

---

# 79B. M7 — material limitations section

`AGENTS.md` requires material limitations to be stated.

Include a concise reviewer-facing limitations paragraph/section outside or inside the <=300-word POC write-up as appropriate without obscuring the word-limit boundary.

At minimum disclose the material facts that affect interpretation:

```text
historical qualifying campaign verdict was INCONCLUSIVE
current corrected POC source differs from the source that produced q5 measurements
the final replacement production topology was not itself benchmark-validated by q5
real provider semantics were unavailable
real AWS/geographic/browser end-to-end latency was not measured
production cost is modeled, not incurred
```

Do not turn the README into an audit report; include only limitations a reviewer needs to interpret the result honestly.

---

# 80. M7 AI process

Write a few factual sentences.

Say AI assisted with:

```text
architecture exploration
POC contract/code iteration
evidence analysis
current-source research
cost calculations
drafting
auditing
```

and was directed to:

```text
preserve requirements
separate fact/assumption/measurement/inference
not change criteria after measurement
surface INCONCLUSIVE/REJECT evidence
use current primary sources
keep candidate accountable for decisions
```

Do not minimize AI use falsely.

---

# 81. M7 instruction artifacts

Ensure provenance includes all actually used instruction files.

Likely candidates:

```text
AGENTS.md
MILESTONE_2_CLOSE_GAP_PROMPT_ARTIFACT.md
MILESTONE_3_ASSIGNMENT_SYNCED_EXECUTION_PLAN_v2_FINAL.md
PARALLEL_M3_SAFE_WORK_100_PERCENT_PROMPT_ARTIFACT.md
MILESTONES_4_5_6_7_CLOSE_100_PERCENT_OVERNIGHT_PROMPT_ARTIFACT.md
```

Only include those actually used.

---

# 82. M7 consistency audit

Compare:

```text
README.md
proposal.md
M4 final reconciliation
M5 cost model
q5 evidence
v2.0.6 correction record
actual launch scripts
AI provenance
```

No disagreement on:

```text
verdict
architecture
cost
region
run command
proposal impact
provider risk
```

---

# 82A. M7 — shipped POC must remain an experiment, not a hidden production implementation

Even though M4 changes the production architecture, do not rewrite `poc/` into a miniature version of the final production system during M7.

The final POC remains evidence of the risky assumption that was actually tested and of the design change it caused.

Any post-q5 v2.0.6 changes already present must remain clearly characterized as:

```text
measurement/harness correctness changes
```

unless the repository proves they materially changed the DUT itself.

Do not add a new horizontal production fan-out implementation just to make the final architecture and POC look identical.

The assignment explicitly allows the POC result to change the proposal.

---

# 83. M7 completion gate

M7 = DONE only if:

```text
[ ] root README.md is real, not placeholder
[ ] one-command run instructions are correct
[ ] documented command path is tested at an appropriate clean/non-qualifying level
[ ] container-runtime-only requirement preserved
[ ] no hidden host Git/Node/npm/cloud dependency exists in the packaged run path
[ ] no cloud account required
[ ] smoke vs qualifying distinction correct
[ ] v2.0.5 measured-source vs v2.0.6 shipped-source coherence is explicitly resolved
[ ] README never claims current corrected source produced historical q5 measurements
[ ] host resource/runtime expectations are honest where material
[ ] expected runtime is stated from observed/frozen evidence, not guessed
[ ] README states where/when the measured summary appears
[ ] README explains how to interpret ACCEPT / REJECT / INCONCLUSIVE
[ ] <=300-word POC write-up
[ ] assumption present
[ ] method present
[ ] result present
[ ] proposal impact present
[ ] material limitations are stated clearly
[ ] AI process present
[ ] values match evidence
[ ] architecture matches proposal
```

---

# 84. Milestone tracker updates

Update:

```text
internal_docs/LIVE_MATCH_CENTRE_ASSIGNMENT_MILESTONES (3).md
```

only when each completion gate actually passes.

End state of this task should be:

```text
M4 DONE
M5 DONE
M6 DONE
M7 DONE
M8 NEXT / NOT STARTED
```

Do not mark M8–M10 done.

---

# 84A. Reconcile stale milestone/contract references

The existing milestone tracker predates the final post-q5 closure and may still contain generic text such as:

```text
If M3 = INCONCLUSIVE:
    fix limitation
    rerun
```

and older references that call v2.0.5 the current active POC contract.

Do not leave those statements as the apparent current project state after M4 closes.

Update the tracker so it clearly distinguishes:

```text
historical qualifying campaign:
    q5
    contract v2.0.5
    verdict INCONCLUSIVE

post-q5 corrected POC/harness:
    contract v2.0.6
    M2 corrective re-audit PASS
    non-qualifying smoke NOT_APPLICABLE

M4 decision:
    Terminal A
    no artificial replacement M3 campaign
    one-primary 100k assumption withdrawn
    final production architecture revised
```

Preserve historical facts; do not rewrite q5 as v2.0.6 evidence.

Also reconcile any stale "active contract" references in current traceability/risk/status docs so a future reviewer does not see both v2.0.5 and v2.0.6 labelled current.

This consistency repair is part of M4/M7 documentation closure, not a new M3 experiment.

---

# 85. Internal traceability update

Update:

```text
internal_docs/TRACEABILITY_MATRIX.md
```

for final M4 architecture and M5/M6 evidence where it is currently authoritative.

Ensure no row still treats the old one-primary 100k architecture as final.

---

# 86. Historical preservation

Do not delete:

```text
q5 evidence
v2.0.5 contract
v2.0.6 correction contract
post-q5 M2 re-audit
M4 q5 causal reconciliation
```

They explain how the design changed.

Final packaging later may exclude them, but repository history remains.

---

# 87. Do not start M8–M10

M8–M10 are separate.

You may perform **only** lightweight checks needed to prove M4–M7 correctness.

Do not:

```text
destructively clean poc/
delete internal docs for packaging
build final ZIP
call final submission complete
```

The task ends with:

```text
M8 next
```

---

# 88. Autonomous loop — Pass 1: repository truth

Re-read:

```text
main
milestone tracker
M3 evidence
M4 q5 reconciliation
v2.0.6
architecture docs
existing M5/M6/M7 drafts
```

Resolve stale assumptions.

---

# 89. Autonomous loop — Pass 2: M4 architecture

Finish final M4 architecture.

Adversarial questions:

```text
Did I actually solve the one-primary problem?
Can a hot match still overload one node?
Is partition ownership deterministic?
Is history available after node loss?
Does reconnect know where to go?
Does the lobby stay simple?
Is canonical truth separate?
Can I explain deploy continuity?
Did I choose one architecture?
```

Fix every NO.

---

# 90. Autonomous loop — Pass 3: current external evidence

Research selected components.

Questions:

```text
Is the service still available?
Does it support the behavior we rely on?
Did pricing change?
Did CloudFront pricing change?
Did private-origin behavior change?
Did Redis/Valkey compatibility change?
Is load-balancer routing actually sufficient?
```

If architecture breaks:

```text
return M4.
```

---

# 91. Autonomous loop — Pass 4: cost model

Questions:

```text
Did I include every selected component?
Did I omit network cost?
Did I invent viewer-hours?
Did I confuse global event rate with per-viewer rate?
Did I model hot-match delivery?
Did I model payload bytes?
Did I include observability?
Does current pricing support <=$3k?
```

Fix or return M4.

---

# 92. Autonomous loop — Pass 5: proposal

Write `proposal.md`.

Audit:

```text
word count
assignment coverage
architecture consistency
claim language
number provenance
trade-off clarity
```

Keep editing.

---

# 93. Autonomous loop — Pass 6: README

Write `README.md`.

Audit:

```text
actual command
no-.git path
container-only
qualifying vs smoke
<=300 words
exact measured values
M4 impact
AI disclosure
```

Keep editing.

---

# 94. Autonomous loop — Pass 7: cross-document consistency

Compare all final/current docs.

Check exact agreement on:

```text
final fan-out technology
routing topology
history model
Redis/Valkey choice
region
fleet baseline
M3 verdict
architecture impact
cost baseline
CloudFront pricing model
provider assumption
run command
```

Repair contradictions.

---

# 95. Autonomous loop — Pass 8: hiring-reviewer audit

Act as the Senior Fullstack hiring reviewer.

Ask:

```text
Can I understand this in under 10 minutes?
Is the architecture credible?
Did the candidate respond intelligently to failed/inconclusive evidence?
Is cost credible?
Is complexity proportional?
Can I explain why this technology won?
Does the proposal address the actual scenario?
Can I run the POC?
Is anything being hidden?
```

Fix credible criticisms.

---

# 96. Autonomous loop — Pass 9: simplicity audit

Ask:

```text
Can a component be removed?
Is there duplicate truth?
Are there two replay paths for no reason?
Is routing too complex?
Is multi-region unnecessary?
Can managed service replace custom complexity within budget?
Is there a simpler hot-match partition?
```

If simplifying changes architecture:

```text
repeat M5, M6, M7.
```

---

# 97. Autonomous loop — Pass 10: zero-gap audit

## M4

Every answer must be YES:

```text
Historical q5 preserved?
One-primary assumption withdrawn?
Final architecture selected?
Hot-match solved?
Crowd invariance 100 -> 100k addressed without false measurement claim?
N+1/deployment headroom explicit?
Routing explicit?
History-to-live race closed?
Never-blank behavior explicit?
Slow-client/backpressure policy explicit?
Score/clock ownership explicit?
No new untested custom architecture-invalidating local risk ignored?
History explicit?
Reconnect explicit?
Canonical state explicit?
Deploy story explicit?
Geography explicit?
Provider risk explicit?
Architecture docs updated?
```

## M5

Every answer must be YES:

```text
Current official sources?
Current prices?
Selected components only?
CloudFront current model checked if used?
Hidden infrastructure included?
Traffic math correct?
Payload explicit?
Full-history <=2s path bounded?
Viewer-hours explicit?
Fleet baseline explicit?
N+1/deployment headroom priced?
SSE timeout/heartbeat behavior verified if selected?
60/40 transfer pricing reflected where material?
Geography costed?
Provider boundary honest?
$3k conclusion defensible?
```

## M6

Every answer must be YES:

```text
proposal.md exists?
<=1500 words?
Whole system clear?
Final architecture only?
All assignment constraints covered?
Trade-offs present?
Crowd invariance explicit?
Never-blank and atomic history/live handoff explicit?
Score/minute provider-derived?
Cost exact?
POC story exact?
Internal milestone jargon removed from reviewer-facing prose?
No unsupported certainty?
```

## M7

Every answer must be YES:

```text
README.md exists?
Run command real and tested at the appropriate non-qualifying/clean-path level?
Container-only?
No host Git/Node/npm hidden dependency in final ZIP path?
No cloud?
POC source/result coherence explicitly resolved?
POC section <=300 words?
Assumption/method/result/impact present?
q5 INCONCLUSIVE preserved?
M4 architecture change reflected?
AI process present?
```

If any answer is NO:

```text
continue the loop.
```

---

# 98. Stop condition

Stop only when:

```text
M4 = 100%
M5 = 100%
M6 = 100%
M7 = 100%
```

and:

```text
proposal.md <=1500 words
README POC write-up <=300 words
current architecture is one coherent design
q5 remains truthfully INCONCLUSIVE
single-primary Nchan 100k assumption is not silently restored
cost conclusion is current and explainable
all numbers are traceable
every material submitted decision is traceable and defendable
provider transport is an explicit assumption, not an invented fact
accepted-event retry/poison semantics are defined
delivery/history cache can rebuild from canonical truth
frontend and backend live-deploy continuity are both addressed
end-to-end latency budgets exist for 2s/5s
cost includes viewer-hours AND live-event-hours/ingest sensitivity
cost metadata fixes currency/date/region/pricing basis
100k/+40k relevant quotas/capacity limits are verified
kickoff surge capacity does not depend solely on reactive boot
deploy/failure reconnect surge is controlled
edge-to-origin live connection semantics are verified
connection-oriented cost math is correct
browser history rendering is bounded in the <=2s design
provider schema evolution/normalization is addressed
backend and frontend rollback are addressed
regional latency implications are not hidden by one aggregate claim
canonical score/state and history share one committed sequence boundary
production monitoring can observe ingest-to-screen viewer latency
cost has a reasonable operating/uncertainty margin
README states material limitations
all used AI instructions are recorded
100-vs-100k crowd-invariance requirement is addressed
N+1 live-deploy capacity and cost are addressed
history-to-live race and never-blank UX are addressed
full-history <=2s path has a defensible bound
final POC source/result provenance is not misleading
milestone tracker shows M4–M7 DONE
tracker/traceability distinguish historical v2.0.5 q5 from current corrected v2.0.6
no stale source calls both v2.0.5 and v2.0.6 current
full-coverage certificate reports zero uncovered/contradictory rows
no unrelated repository changes were overwritten
working tree / commits created by this task are reported
M8 is next
```

---

# 99. Final response format

When genuinely done, respond:

```text
M4 COMPLETION: 100%
M5 COMPLETION: 100%
M6 COMPLETION: 100%
M7 COMPLETION: 100%

HISTORICAL M3 VERDICT USED:
INCONCLUSIVE

FINAL PRODUCTION ARCHITECTURE:
<one-line architecture summary>

M4 CHANGE:
<one-line explanation of how the one-primary assumption was replaced>

FINAL COST:
<baseline and sensitivity/budget conclusion>

PROPOSAL WORD COUNT:
<number>

README POC WRITE-UP WORD COUNT:
<number>

CURRENT HEAD:
<sha>

FILES CREATED/UPDATED:
<list>

ROADMAP:
M4 DONE
M5 DONE
M6 DONE
M7 DONE
M8 NEXT

REMAINING M4–M7 GAPS:
NONE
```

If a genuine unresolved contradiction prevents 100% closure:

```text
do not fake DONE.
```

Report the exact blocker.

---

# 98A. Final execution-semantics audit

Before the line-by-line assignment audit, test whether an agent could satisfy the words of this prompt while still creating a weak or misleading solution.

Answer:

```text
Could the final architecture still have an unexamined singleton bottleneck?
Could one hot match still overload one delivery partition?
Could delivery-cache loss erase the only active history?
Could accepted poison events be silently skipped?
Could frontend deployment delete assets needed by open clients?
Could the provider transport assumption be incompatible with a persistent feed?
Could a default service quota block 100k/+40k behavior?
Could the 2s/5s claim lack an end-to-end latency budget?
Could cost omit ingest because only viewer-hours were modeled?
Could cost mix currencies/regions/pricing plans?
Could README omit expected runtime or result location?
Could current v2.0.6 POC be presented as the producer of v2.0.5 q5 measurements?
Could an upstream schema change silently corrupt canonical state?
Could a bad backend/frontend release lack a rollback path?
Could one region violate the latency experience while a global statement hides it?
Could the cost model fit under $3k only because it has no operating/uncertainty margin?
Could README omit material limitations required to interpret the POC honestly?
Could current score/state commit at a different canonical boundary from visible history?
Could production monitoring report healthy backend latency while actual browser-screen p95 violates the assignment?
Could the +40k/120s surge arrive before reactive self-hosted capacity becomes healthy?
Could draining one node trigger a reconnect thundering herd that overwhelms spare capacity?
Could cost incorrectly count each SSE event as an HTTP request, or ignore reconnect request volume?
Could the edge be assumed to collapse 100k live viewer streams into far fewer origin connections without documentation?
Could full-history bytes arrive within 2s while browser parsing/rendering still misses the user-visible target?
```

Every answer must be:

```text
NO
```

or the relevant section must be repaired.

---

# 98B. `AGENTS.md` final-gate audit

Re-open the current `internal_docs/AGENTS.md` before stopping.

Map its final-gate items to the actual M4–M7 artifacts.

At minimum verify:

```text
provider best-effort honesty
ordering/dedup/idempotency/state coherence
safe history -> live handoff
reconnect
surge/backpressure
failure
deploy AND rollback
geography
cost
schema evolution
feed interruption/staleness
failure domains
public-endpoint protection
observability
current prices/limits/quotas
end-to-end viewer-facing latency budget
Europe and North America considered separately
important alternatives compared compositionally
POC result not overstated
README material limitations
README AI process
```

No applicable `AGENTS.md` final-gate item may remain uncovered by M4–M7.

Do not mark M8 work done here; this pass is only to prevent an unfinished design/draft requirement from being falsely deferred.

---

# 99A. Final line-by-line assignment audit

Before declaring 100%, re-open the original assignment and map every sentence that creates an obligation.

The matrix must contain at least:

```text
public / anonymous / read-only / no accounts
lobby all matches
score + minute
goals + cards live
no refresh
late join
reload
phone wake
immediate history
then live
never blank
never manual refresh
score agrees with events
no duplicate display
nothing disappears
ordered display
genuinely live
100-viewer experience
100,000-viewer experience
kickoff rush
score derived from feed
clock derived from feed
8 matches
10/s steady
50/s burst
best-effort provider
no long retry window
+40k / 2 min
60% EU / 40% NA
goal p95 <=2s ingest-to-screen
other p95 <=5s
history <=2s
$3k/month
weekly live deploys unnoticed
Next.js App Router
component-based
AWS preferred / alternative justified
proposal <=1500 words excluding diagrams
whole stack feed-to-screen
decisions/options/winners explained
least-trusted assumption named
POC follows architecture risk
local one command
container runtime only
no cloud account
measured result
<=300-word POC write-up
assumption -> method -> result -> proposal impact
rough experiment only
simulated feed
no full product
no cloud deployment/spend
AI instructions included if used
AI direction explained
every number/decision defendable
final ZIP-only constraints acknowledged for M8–M10
```

For each row classify:

```text
COVERED_IN_M4
COVERED_IN_M5
COVERED_IN_M6
COVERED_IN_M7
DEFERRED_CORRECTLY_TO_M8
DEFERRED_CORRECTLY_TO_M9
DEFERRED_CORRECTLY_TO_M10
```

No row may be:

```text
MISSING
UNKNOWN
HANDWAVED
```

If a row belongs to M4–M7 and is not covered:

```text
fix it now and repeat the audit.
```

---

# 99B. Final POC/evidence coherence audit

Before stopping, answer all of these with exact artifact paths:

```text
What exact source produced the qualifying measured result?
What exact machine verdict did it produce?
What exact POC source will be shipped later?
If those sources differ, is the difference disclosed?
Does README avoid claiming current source produced historical measurements?
Does proposal describe the causal design change rather than claiming final architecture was benchmarked?
Does the reviewer command exercise the shipped POC?
Can a reviewer understand why a new run may differ from the preserved historical campaign?
```

Any NO blocks M7.

---

# 99C. Final no-wrong-deferral audit

For every unresolved item ask:

```text
Is this genuinely an M8 explainability/reproducibility audit?
Is this genuinely M9 cleanup?
Is this genuinely M10 packaging?
Or am I deferring an unfinished M4–M7 design/evidence/drafting task?
```

If it belongs to M4–M7:

```text
complete it now.
```

Only then report 100%.

A task may be deferred to M8–M10 only when it is truly:
- final explainability/clean-room audit,
- destructive POC cleanup,
- or final ZIP construction/inspection.

Do not defer unresolved architecture, current-source research, pricing, proposal, README, run-instruction, or source/result-coherence work.

---

# 99D. Full-coverage certificate — mandatory before stopping

Before declaring completion, produce an internal coverage certificate with four sections.

## A. Original assignment scenario

Every row must be `PASS` with an artifact/section reference:

```text
public / anonymous / read-only / no accounts
lobby: all live matches
lobby: score and minute
lobby: goals/cards live, no refresh
match: run of play
late join
reload
phone wake
immediate full history
then live streaming
never blank
no manual refresh
score/history coherence
no duplicate display
nothing disappears
ordered display
goal p95 <=2s ingest->screen
routine-event p95 <=5s
same experience ~100 ->100,000
8 matches
~10/s steady
~50/s burst
best-effort/no-long-retry provider
+40k/120s
60% EU / 40% NA
history <=2s
<= $3,000/month
weekly live deploys unnoticed
Next.js App Router
component-based frontend
AWS preferred / alternative justified
score and clock derived from feed
```

## B. Deliverable requirements

Every row must be `PASS`:

```text
proposal.md exists
proposal <=1500 words excluding actual diagram block(s)
full stack feed -> fan
important decisions/options/winners explained
least-trusted assumption named
POC relationship/causal change explained

POC remains small experiment code
one-command local path
container runtime only
no cloud account
measured result
simulated feed
no full production implementation

README.md exists
actual run instructions
expected runtime
result location/interpretation
<=300-word POC write-up
assumption -> method -> result -> proposal impact
material limitations
AI-process explanation

all actually-used AI instruction artifacts recorded for later packaging
every submitted number defendable
every submitted decision defendable
```

## C. M4–M7 milestone gates

Every row must be `PASS`:

```text
M4 architecture/evidence no longer contradict
M4 one final selected architecture
M4 old one-primary assumption not restored
M4 architecture/risk/traceability sources updated

M5 current authoritative facts
M5 current prices/quotas
M5 complete cost model
M5 POC-to-production mapping
M5 geography/provider boundary
M5 <=$3k conclusion defensible

M6 final proposal
M6 word count
M6 assignment coverage
M6 no unsupported performance/cost certainty
M6 no conflict with README/POC

M7 run instructions tested appropriately
M7 POC source/result coherence
M7 <=300-word write-up
M7 measured values/evidence truthful
M7 proposal impact matches proposal
M7 AI process + limitations
```

## D. `AGENTS.md` production-design gates

Every applicable row must be `PASS`:

```text
validation/normalization
schema evolution
canonical ordering
dedup/idempotency
atomic score/clock/history state boundary
safe history -> live handoff
reconnect/reload/wake
surge/backpressure
slow-client protection
feed interruption/staleness
failure domains
delivery-store rebuild
deploy
rollback
frontend asset version overlap
geography
regional latency honesty
public-endpoint protection
observability
viewer-screen SLO measurement
current prices/quotas
operating-cost margin
composition-aware alternatives
provider-boundary honesty
```

The certificate must end:

```text
uncovered original-assignment rows: 0
uncovered M4-M7 rows: 0
uncovered applicable AGENTS.md rows: 0
contradictory current-source-of-truth rows: 0

FULL M4-M7 COVERAGE: 100%
```

If any count is non-zero:

```text
DO NOT STOP.
Repair the gap and rerun the certificate.
```

---

# 100. Final instruction

This prompt is an **execution and closure prompt**.

Do not stop because:

```text
a draft exists
a document says PASS
a commit message says DONE
one cost scenario is under budget
one architecture diagram looks plausible
```

Stop only when the repository itself supports:

```text
M4 DONE
M5 DONE
M6 DONE
M7 DONE
```

end to end, with the assignment, q5 evidence, v2.0.6 closure, final architecture, current external facts, cost model, `proposal.md`, and `README.md` all telling the same truthful story.
