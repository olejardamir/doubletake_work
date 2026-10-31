# EA Live Match Centre — Final 100% Submission-Readiness Execution Prompt

## Role and objective

You are the final submission engineer for the repository:

`https://github.com/olejardamir/EA`

Work on the current `main` branch checkout.

Your job is to make the **actual take-home submission ZIP** fully compliant, internally coherent, reviewer-friendly, reproducible, and technically defensible.

Do not stop at an audit. **Edit the repository, run the POC, build the final ZIP, extract it into a clean temporary directory, run it there, inspect the extracted contents, and loop until every gate in this prompt passes.**

Do not ask the user questions. Make the smallest defensible implementation choices needed to finish the assignment.

---

# 1. Absolute source of truth

The take-home assignment is the sole reviewer-facing acceptance authority.

The binding requirements are:

- Deliverable 1: one `proposal.md`, maximum **1,500 words**, diagrams excluded.
- Propose the complete production system from third-party feed ingest to the fan's screen.
- Public, anonymous, read-only product; no accounts.
- Lobby: all live matches, current score/minute, goals/cards as they happen, no refresh.
- Match page: immediate full history when arriving/reloading/waking, then continued live stream.
- Correctness: score agrees with events; no duplicate/disappearing/out-of-order display.
- Peak: 8 concurrent live matches.
- Provider pushes about 10 events/s total, bursting to about 50/s.
- Provider delivery is best-effort with no long retry window.
- Peak viewers: 100,000.
- Surge: +40,000 viewers within 2 minutes.
- Audience: about 60% Europe / 40% North America.
- Goal latency: p95 <= 2 s ingest-to-screen.
- All other event latency: p95 <= 5 s.
- Late join/reload: full match history visible within 2 s.
- Infrastructure budget: <= $3,000/month at peak.
- Weekly deploys, including during live matches, without visible interruption.
- Frontend: Next.js App Router with component-based architecture.
- AWS preferred, or justify another infrastructure choice.
- Deliverable 2: a small runnable POC measuring the riskiest locally testable design assumption.
- POC runs locally with **one command**, no cloud account, and nothing installed beyond a container runtime.
- POC produces a **measured result**, not merely a demonstration.
- POC README write-up is <= **300 words** and explicitly covers assumption -> method -> result -> what it changes in the proposal.
- Simulating the provider event stream is expected.
- Do not build the full production system.
- Delivery ZIP contains only:
  - `proposal.md`
  - `poc/`
  - `README.md`
  - agent instruction files actually used.
- `poc/` must not contain generated material such as `node_modules`, build artifacts, runtime logs, caches, generated evidence directories, or other debris.
- Include a few sentences in README describing how AI tools were directed.
- Every submitted number and decision must be explainable.

**Internal milestone contracts, M3 gates, amendments, re-baselines, candidate acceptance thresholds, and historical agent criteria are NOT assignment requirements. Never present them as if they came from the assignment.**

---

# 2. Non-negotiable truthfulness rules

1. Never change an acceptance threshold after seeing a measurement and then call the same experiment a success.
2. Never use phrases such as:
   - `assignment frozen gates` for internally invented 500 ms / 1000 ms thresholds;
   - `stakeholder-authorized amendment`;
   - `§AMENDMENT-2`;
   - `re-baselined gates`;
   - `B1 ACCEPTED under re-baselined gates`;
   - or equivalent reviewer-facing wording.
3. Preserve the measured failure honestly:
   - the best correctness-clean 100k run reached 100,000 viewers;
   - viewer-facing missing/duplicate/out-of-order/state-consistency violations were zero;
   - fan-out p95 was approximately 4.242 s;
   - burst p95 was approximately 11.006 s;
   - late-join p95 was approximately 0.906 s.
4. Interpret that result correctly: **the fixed-capacity fan-out assumption failed on latency**, so the production proposal changes architecture.
5. The assignment does **not** require the POC hypothesis to succeed. A falsified risky assumption followed by an architecture change is a valid and strong result.
6. Do not claim the local POC measured full AWS-to-browser end-to-end latency.
7. Do not invent provider event IDs, sequence guarantees, replay APIs, snapshots, or reconciliation endpoints. If they are needed for a hard guarantee, state that they must be present in the real provider contract.
8. Do not hide the best-effort provider limitation: if an upstream event is never sent and no authoritative reconciliation mechanism exists, the application cannot reconstruct it from nothing.
9. Do not claim the replacement horizontal topology was benchmark-validated if it was not.
10. Do not use `NOT_APPLICABLE` as the primary reviewer-run result.

---

# 3. Required repository changes

## 3.1 Replace `proposal.md`

Replace reviewer-facing `proposal.md` with the following text **verbatim unless an implementation fact discovered during execution makes a specific sentence false**. If that happens, alter only the minimum necessary sentence and preserve all assignment coverage.

The text is intentionally below 1,500 words excluding the diagram.

~~~markdown
# Live Match Centre — Design Proposal

## Architecture

```text
Third-party feed (best-effort push)
        |
        v
API Gateway HTTP API
        |
        v
SQS FIFO, MessageGroupId = match_id
        |
        v
Lambda canonical processor
validate / normalize / dedupe / derive score + minute
        |
        v
DynamoDB
canonical ordered events + current match state
        |
        +--------------------> history/snapshot API
        |
        v
delivery publisher
        |
        v
fan-out shard groups
each group = shared Valkey + multiple Nchan replicas
        |
        v
CloudFront/static Next.js + regional SSE endpoints
        |
        v
Next.js App Router client
history first, then live EventSource stream
```

The system separates **canonical truth** from **delivery state**. DynamoDB stores the durable event history and derived score/minute. Valkey/Nchan is a rebuildable delivery layer used only for low-latency replay and fan-out.

The provider boundary is deliberately explicit. The assignment says delivery is best-effort and does not define stable event IDs, provider sequence numbers, or an authoritative reconciliation endpoint. Once an event reaches our ingress, SQS and idempotent canonical processing prevent us from losing it. If the production provider supplies event identity/order or a snapshot/reconciliation API, the adapter uses it to detect gaps, duplicates, and upstream reordering. If it does not, an event that the provider never sends cannot be reconstructed from nothing; that is the largest external dependency risk and must be resolved in the provider contract rather than hidden by the application design.

## Correctness, history and client behavior

Each accepted event is normalized into a versioned canonical model. The processor writes the event and updated match state idempotently in DynamoDB and only publishes after the canonical write succeeds. A stable `canonical_seq` is assigned in accepted canonical order. Provider IDs/order are used when the real feed supplies them; they are not invented as an assignment fact.

Late join is a snapshot-to-stream handoff. The client requests current state plus history through sequence `N`, renders it immediately, and then subscribes to live events after `N`. Every live event carries `canonical_seq`; the reducer ignores a sequence it has already applied and buffers a small gap rather than rendering newer state over missing earlier state. On reconnect or phone wake it resumes from the last applied cursor. Existing coherent state remains visible while reconnecting, so the user never sees a blank feed or needs a manual refresh.

The score and minute shown in both lobby and match views are derived from the same canonical events as the timeline. The browser never independently increments the official score or clock. This prevents the score panel and event list from disagreeing because of separate client-side state.

The public frontend has no accounts and no write path. With Next.js App Router, server-rendered page shells deliver fast first paint; client components handle live state. The main component boundaries are `LiveMatchList`, `MatchCard`, `ScoreHeader`, `EventTimeline`, and a shared `useMatchStream` hook/reducer. The lobby consumes the same canonical stream and shows every live match, score, minute, goals, and cards without refresh.

## Scale, hot matches and geography

Peak requirements are eight live matches, about 10 events/s total with bursts near 50/s, 100,000 concurrent viewers, and a +40,000-viewer surge in two minutes.

The critical production rule is that **a match is not limited to one fan-out node**. A match maps to a fan-out shard group, and each group can contain multiple Nchan replicas. All replicas assigned to that match receive the same canonical publication through the group's Valkey channel; the connection endpoint distributes new SSE viewers across those replicas. A very hot match is given its own group and can add replicas without moving existing sockets. New viewers are assigned to the least-loaded healthy replica; existing viewers stay connected until normal reconnect or draining. This means one match can consume many nodes rather than being capped by one node's connection limit.

The fleet is pre-scaled before known kickoffs, keeps N+1 spare capacity, and autoscales on concurrent connections, CPU, memory, and reconnect/admission pressure. A +40,000/120s surge is roughly 333 new viewers/s, so admission capacity is kept warm instead of depending on reactive instance launch time.

The origin is in `eu-west-1`, close to the 60% European audience. Static Next.js assets are edge-cached. North American viewers use the same correctness path with a longer network leg. The design stays single-region because active-active multi-region is difficult to justify inside the $3,000/month ceiling; production monitoring therefore reports latency separately for Europe and North America rather than assuming identical RTT.

## Latency, deployment and operations

The assignment targets p95 ingest-to-screen latency of at most 2 s for goals, 5 s for other events, and full history visible within 2 s. These are production SLOs, not claims that the local POC measured internet/browser end-to-end latency.

A 90-minute match at an even share of the stated 10 events/s total is about 6,750 events. At an assumed ~300 B/event that is about 2 MB of event data, so the network transfer is modest; browser parsing/rendering must still be measured before launch. Goals are prioritized through the same pipeline, with queue age, publish latency, SSE delivery latency, and sampled browser render telemetry tracked separately.

Weekly deploys use rolling replacement with connection draining and N+1 capacity. Existing SSE connections are allowed to drain; reconnects resume from `canonical_seq`. Schema changes are backward-compatible across one deployment window, and frontend assets are immutable/versioned so an already-open page keeps working during deployment.

Operational alarms cover ingest silence, malformed provider data, queue depth, canonical sequence anomalies, Lambda failures, DynamoDB throttling, Nchan/Valkey health, connection counts, CPU/memory, reconnect storms, history latency, and sampled end-to-end latency. Slow consumers have bounded buffers and reconnect from their cursor rather than consuming unbounded server memory.

## Cost and trade-offs

The modeled peak-month baseline is about **$2,318/month** under the stated workload assumptions: roughly $1,121 for 16 `c7g.xlarge` delivery instances, $504 for 16 `cache.t4g.medium` Valkey nodes, $200 for CloudFront Business, about $290 for API Gateway/SQS/Lambda/DynamoDB, and about $203 for NLB/NAT/CloudWatch/S3/Route53. The estimate assumes about 120 peak-equivalent match-hours/month and ~250 B live payloads. At those assumptions it is below the $3,000 ceiling with about 23% headroom. The cost claim is conditional on that traffic model and must be re-priced before launch.

The main trade-offs are SSE/Nchan over custom WebSockets for simpler one-way public streaming; DynamoDB over a relational database for idempotent event/state writes at low operational load; single-region over active-active multi-region for cost; and self-hosted fan-out over a managed pub/sub service for predictable control of 100,000 long-lived connections.

## Riskiest assumption and proof of concept

The largest overall risk is the third-party feed contract: best-effort push alone cannot guarantee detection of an event that is never sent, and the assignment does not provide the identity/order/reconciliation semantics needed to test that locally.

The riskiest **locally testable** assumption is fan-out capacity: whether a fixed Nchan/Redis/SSE tier can serve assignment-scale concurrency while preserving correctness and sufficiently low latency. The POC simulates the feed and measures real SSE delivery.

The best correctness-clean 100,000-viewer run reached 100,000 active viewers with zero viewer-facing missing, duplicate, out-of-order, or state-consistency violations, but measured fan-out p95 was about **4.242 s**, burst p95 about **11.006 s**, and late-join p95 about **0.906 s**. Those results disprove the fixed-capacity production assumption: fan-out latency alone is too high to confidently meet the assignment's 2 s/5 s ingest-to-screen targets.

Therefore the production proposal does not scale by making one fan-out node larger. It scales a hot match across multiple delivery replicas, keeps capacity warm, and preserves DynamoDB as canonical truth. The replacement topology is a design response to the measured failure and must itself pass production-scale load testing before launch.

~~~

After writing it:

- count the prose words excluding the diagram;
- fail the final audit if it exceeds 1,500;
- confirm every assignment constraint listed in section 1 has an explicit architectural answer;
- keep the hot-match multi-node language concrete;
- do not reintroduce any internal M3 acceptance-gate narrative.

---

## 3.2 Replace `README.md`

Replace reviewer-facing `README.md` with the following text, then fill the `{{...}}` measurement placeholders from the **final clean-room extracted-ZIP portable run**.

Do not fabricate the placeholder values.

The `## POC write-up` section must remain <=300 words after the values are inserted.

~~~markdown
# Live Match Centre — POC & Submission

The production design is in `proposal.md`. The proof of concept measures the fan-out assumption that most directly threatens that design.

## Run the POC

**Prerequisite:** Docker with Docker Compose. Nothing else is required: no AWS account, credentials, host Node/npm, Python, Go, Redis, Nginx, or Git.

From the extracted submission root, run:

```bash
cd poc && docker compose up --build --abort-on-container-exit --exit-code-from runner
```

The command must build the POC, simulate eight live matches, run a portable stepped load at **100, 500, and 1,000 real SSE subscribers**, and print a human-readable and machine-readable measurement summary. At minimum it must report fan-out p50/p95/p99, burst p95, delivery missing/duplicate/out-of-order counts, late-join/replay measurements, reconnect measurements, and the achieved subscriber count at each step.

The command is a portable re-execution of the same fan-out measurement path used for the historical 100,000-viewer experiment. It is not presented as a reproduction of 100,000 viewers on arbitrary reviewer hardware. It must finish with a measurement status such as `COMPLETED`; it must **not** report `NOT_APPLICABLE`, and it must not redefine performance gates to make a result pass.

## POC write-up

**Assumption.** The riskiest locally testable assumption was that a fixed Nchan/Redis/SSE fan-out tier could support the assignment-scale audience without violating delivery correctness or making live updates unacceptably slow. Provider feed semantics are also a major production risk, but no real provider or schema was supplied, so that risk cannot be meaningfully tested locally.

**Method.** The POC simulates eight live matches and publishes steady and burst traffic through Nchan over SSE. It measures publish-to-frame latency, delivery completeness, ordering, late-join/replay behavior, and reconnect behavior. The one-command reviewer run executes a portable stepped load at 100, 500, and 1,000 real SSE subscribers. Historical 100,000-viewer runs are retained as the assignment-scale measurement.

**Result.** The best correctness-clean 100,000-viewer run reached 100,000 active viewers with zero viewer-facing missing, duplicate, out-of-order, or state-consistency violations, but fan-out p95 was 4.242 s, burst p95 11.006 s, and late-join p95 0.906 s. This is too slow to trust a fixed-capacity tier against the assignment's 2 s/5 s end-to-end targets. On the final clean-room portable run, 1,000 viewers measured fan-out p95 **{{PORTABLE_P95_MS}} ms**, with **{{PORTABLE_MISSING}}** missing, **{{PORTABLE_DUPLICATES}}** duplicate, and **{{PORTABLE_OUT_OF_ORDER}}** out-of-order deliveries.

**Proposal impact.** Production therefore uses horizontally scalable delivery replicas, explicit hot-match replication across multiple fan-out nodes, pre-scaled kickoff capacity, and N+1 headroom. The replacement topology remains a production assumption that must be load-tested before launch.

## Material limitations

The local POC measures the fan-out path, not the complete AWS-to-browser internet path. It therefore does not claim to have measured the assignment's end-to-end 2 s/5 s production SLOs. Absolute local timings depend on reviewer hardware. Real third-party feed identity/order/reconciliation semantics, real Europe/North-America network latency, browser rendering at production history sizes, and actual AWS spend remain production validation items.

The historical 100,000-viewer measurement is reported as a **failure of the fixed-capacity architecture assumption**, not as an acceptance obtained by changing thresholds after measurement.

## AI process

AI assistance was used for architecture exploration, code iteration, measurement analysis, cost calculations, drafting, and requirement auditing. The AI was directed to treat the take-home assignment as the sole reviewer-facing acceptance authority, preserve measured failures, distinguish facts from assumptions, avoid changing criteria after observing results, and keep every submitted number explainable.

The agent-instruction files actually used during this work are included at the archive root. They include `AGENTS.md`, `MILESTONE_2_CLOSE_GAP_PROMPT_ARTIFACT.md`, `MILESTONE_3_ASSIGNMENT_SYNCED_EXECUTION_PLAN_v2_FINAL.md`, `PARALLEL_M3_SAFE_WORK_100_PERCENT_PROMPT_ARTIFACT.md`, `MILESTONE_3_ACCEPTANCE_RECOVERY_PROMPT_ARTIFACT.md`, `MILESTONES_4_5_6_7_CLOSE_100_PERCENT_OVERNIGHT_PROMPT_ARTIFACT.md`, `M3_ACCEPT_PUSH_EXHAUST_REMAINING_NCHAN_CONFIG_SPACE.md`, `FINAL_TAKEHOME_NON_M3_REQUIREMENT_CLOSURE_PROMPT_ARTIFACT.md`, and `EA_FINAL_100_PERCENT_SUBMISSION_READY_PROMPT.md`.

~~~

After the clean-room run, replace:

- `{{PORTABLE_P95_MS}}`
- `{{PORTABLE_MISSING}}`
- `{{PORTABLE_DUPLICATES}}`
- `{{PORTABLE_OUT_OF_ORDER}}`

with the actual final portable 1,000-subscriber measurements.

If the experiment cannot validly reach 1,000 subscribers on the machine used to construct the submission, repair the POC rather than silently reducing the documented load. Only reduce the portable maximum if there is a genuine container-runtime portability reason, and if so change the README method/result wording consistently and explain why. Prefer keeping 1,000.

---

# 4. Rebuild the reviewer-facing POC around a real measured portable experiment

The existing default reviewer command currently behaves like a smoke/package check and can report `NOT_APPLICABLE`. That is not the final desired state.

Keep the proven Nchan/Redis/SSE measurement machinery where useful, but make the **submission POC** smaller, clearer, and aligned to the README.

## Required behavior

From extracted ZIP root, this exact command must work:

```bash
cd poc && docker compose up --build --abort-on-container-exit --exit-code-from runner
```

The only host prerequisite may be Docker/Docker Compose.

The command must:

1. build all needed code/images;
2. start Redis/Valkey-compatible storage and Nchan;
3. simulate eight matches;
4. generate steady traffic approximating 10 events/s total;
5. generate a burst approximating 50 events/s total;
6. create real SSE subscribers;
7. perform a stepped portable load at:
   - 100 subscribers,
   - 500 subscribers,
   - 1,000 subscribers;
8. measure at each level:
   - achieved active subscribers,
   - fan-out p50,
   - fan-out p95,
   - fan-out p99,
   - burst p95,
   - missing delivery count,
   - duplicate count,
   - out-of-order count;
9. exercise and report at least one late-join/history measurement;
10. exercise and report at least one reconnect/resume measurement;
11. print a clear human-readable summary;
12. print a machine-readable JSON summary;
13. finish with an experiment status such as `COMPLETED`;
14. exit nonzero only for experiment/harness failure, not merely because latency is poor.

The default portable run must **not**:

- call itself `NOT_APPLICABLE`;
- claim to reproduce 100,000 viewers;
- claim to measure internet/browser end-to-end latency;
- apply post-hoc internal M3 gates;
- label a result ACCEPT simply because it falls under a relaxed threshold.

## Measurement interpretation

The POC should expose measurements, not manufacture success.

The assignment's 2 s / 5 s numbers are end-to-end production requirements. Local publish-to-SSE-frame latency is only one component. Therefore:

- show the assignment SLOs in README/proposal as production targets;
- use the historical 100k fan-out result to show why the old fixed-capacity architecture is unsafe;
- do not pretend a 1,000-subscriber local run proves 100k production capacity;
- do not introduce a new arbitrary local "pass" threshold solely to obtain a green verdict.

## Simplify submission code

The staged `poc/` should contain only the source/configuration required to run this experiment.

Remove from the staged ZIP POC:

- `internal_docs/`
- historical evidence trees
- generated JSON result dumps
- compressed logs
- campaign logs
- `node_modules`
- build output
- caches
- temporary directories
- old compose variants not needed by the one-command reviewer run
- unrelated milestone tooling
- archived experimental contracts
- generated artifacts.

It is acceptable to retain those materials elsewhere in the Git repository for provenance, but they must not be inside the final submission ZIP.

If the existing source is too coupled to historical M3 contract machinery, create a small submission-specific runner under `poc/` rather than shipping the entire historical harness. Reuse proven SSE parser, publisher, sequence-tracker, and histogram logic where practical.

---

# 5. Correct the production hot-match topology

The final proposal's key architectural correction is mandatory:

**A popular match must be able to use multiple fan-out nodes simultaneously.**

Do not leave the architecture as:

`one match -> one node with ~8k connections`.

Implement/document the logical production topology as:

- canonical event stored once in DynamoDB;
- match assigned to a fan-out shard group;
- a shard group contains multiple Nchan replicas;
- the same canonical match publication is delivered to every replica serving that match;
- each replica fans the event to only its locally connected clients;
- the connection endpoint spreads new viewers across healthy replicas;
- a hot match may get a dedicated group containing many replicas;
- adding replicas affects new connections and does not require migrating existing SSE sockets;
- reconnect resumes from canonical cursor/history.

The proposal text supplied in section 3.1 already expresses this. Do not weaken it.

---

# 6. Correct the provider best-effort semantics

The assignment explicitly says the provider push is best-effort with no long retry window.

The final design must distinguish:

### Failures we can solve after ingress

Once an event reaches us:

- durable queueing;
- idempotent canonical writes;
- retry;
- dedupe;
- canonical sequencing;
- delivery replay;
- reconnect.

### Failures we cannot solve without provider contract support

If the provider never sends an event, or sends ambiguous ordering, then complete semantic recovery requires some provider-side mechanism such as:

- stable event identity/order,
- authoritative snapshot,
- replay,
- or reconciliation.

Do **not** assert that such a mechanism exists in the assignment.

State that production contracting/integration must establish it. This is not a design weakness to hide; it is the correct boundary of a best-effort upstream dependency.

---

# 7. Frontend requirement closure

The assignment explicitly requires Next.js App Router **with component-based architecture**.

The final proposal must retain explicit component boundaries:

- `LiveMatchList`
- `MatchCard`
- `ScoreHeader`
- `EventTimeline`
- shared `useMatchStream` hook/reducer

The frontend remains public, anonymous, read-only, with no accounts.

No production frontend implementation is required. Do not build the full product.

---

# 8. Cost sanity check

Keep the current approximately $2,318/month model only if its arithmetic and current assumptions remain internally coherent.

At minimum re-check:

- component subtotals sum to the total;
- total is <= $3,000;
- named workload assumptions are visible;
- sensitivity is not presented as unlimited;
- no cost item contradicts the final architecture.

If internet/current AWS pricing access is available, verify material price assumptions against primary AWS sources. If not, do not fabricate a fresh price. Preserve the modeled nature of the estimate and its date/assumptions.

If the final hot-match topology changes the required number of baseline delivery nodes from the 16-node model, either:
- show why 16 still provides the intended peak capacity, or
- update the cost model consistently while remaining <= $3,000.

Never leave cost arithmetic inconsistent with topology.

---

# 9. Historical result coherence

Reviewer-facing documents must use one coherent historical result.

Use the best correctness-clean B1 result:

- active viewers: 100,000
- fan-out p95: 4.242 s
- burst p95: 11.006 s
- late-join p95: 0.906 s
- viewer-facing missing: 0
- viewer-facing duplicates: 0
- viewer-facing out-of-order: 0
- viewer-facing state-consistency violations: 0

Do not mix this with older F1 latency values in the final submission documents.

Internal repository evidence can retain older runs, but the final submission needs one understandable experiment story.

---

# 10. Agent-instruction-file handling

Because this prompt is itself being used to direct AI work, preserve it as:

`EA_FINAL_100_PERCENT_SUBMISSION_READY_PROMPT.md`

Include it in the final ZIP root.

Also include every other agent instruction file that was actually used, including the files named in the exact README text.

Do not include internal audit reports, evidence logs, contract documents, or unrelated design notes merely because they exist. The assignment asks for instruction files used, not the entire working directory.

---

# 11. Final ZIP construction

Create/recreate:

`live-match-centre-submission.zip`

Its top-level contents must be only:

- `proposal.md`
- `README.md`
- `poc/`
- `AGENTS.md`
- `MILESTONE_2_CLOSE_GAP_PROMPT_ARTIFACT.md`
- `MILESTONE_3_ASSIGNMENT_SYNCED_EXECUTION_PLAN_v2_FINAL.md`
- `PARALLEL_M3_SAFE_WORK_100_PERCENT_PROMPT_ARTIFACT.md`
- `MILESTONE_3_ACCEPTANCE_RECOVERY_PROMPT_ARTIFACT.md`
- `MILESTONES_4_5_6_7_CLOSE_100_PERCENT_OVERNIGHT_PROMPT_ARTIFACT.md`
- `M3_ACCEPT_PUSH_EXHAUST_REMAINING_NCHAN_CONFIG_SPACE.md`
- `FINAL_TAKEHOME_NON_M3_REQUIREMENT_CLOSURE_PROMPT_ARTIFACT.md`
- `EA_FINAL_100_PERCENT_SUBMISSION_READY_PROMPT.md`

If an instruction file in that list was not actually used, do not falsely claim it was; reconcile README and ZIP accordingly.

Do not include at ZIP root:

- `LICENSE.md`
- repository `internal_docs/`
- `.git/`
- `.gitignore`
- audits
- evidence directories
- extra zips
- screenshots
- logs
- unrelated files.

Inside `poc/`, include only runnable source/configuration required by the reviewer experiment.

---

# 12. Clean-room verification — mandatory

After building the ZIP:

1. create a brand-new temporary directory;
2. extract the ZIP there;
3. inspect the complete file list;
4. verify no forbidden/generated material exists;
5. run exactly:

```bash
cd poc && docker compose up --build --abort-on-container-exit --exit-code-from runner
```

6. capture the actual final measurements;
7. confirm the run reaches all three portable load levels;
8. confirm the result says `COMPLETED` or equivalent, not `NOT_APPLICABLE`;
9. update the README portable placeholders with the actual 1,000-subscriber values;
10. rebuild the ZIP after that README update;
11. extract the rebuilt ZIP again;
12. rerun the exact command again;
13. verify the README numbers match the final run being reported.

The final ZIP is not done until the **post-placeholder-replacement archive** passes this second clean-room run.

---

# 13. Mechanical compliance checks

Before declaring completion, programmatically or manually verify all of the following.

## Proposal

- file exists exactly as `proposal.md`;
- Markdown;
- <=1,500 prose words excluding diagram;
- covers full stack;
- names riskiest overall risk;
- names riskiest locally testable assumption;
- explains what POC changed;
- explicit Next.js App Router;
- explicit component architecture;
- public/anonymous/read-only;
- lobby;
- match history/live handoff;
- score/events consistency;
- 8 matches;
- 10/s steady;
- 50/s burst;
- 100k viewers;
- +40k/2 minutes;
- 60/40 geography;
- 2 s goals;
- 5 s other;
- 2 s history;
- <=$3k;
- weekly invisible deploys;
- concrete hot-match multi-node scaling;
- best-effort provider limitation.

## README

- file exists exactly as `README.md`;
- one copy-paste run command;
- Docker/container runtime only;
- assumption -> method -> result -> proposal impact;
- POC write-up <=300 words;
- no unfilled `{...}` placeholders;
- AI process description;
- limitations honest;
- no post-hoc acceptance narrative.

## POC

- one command from clean extracted ZIP;
- no cloud;
- no host language runtimes;
- simulated events;
- measured output;
- stepped 100/500/1000 SSE load;
- real SSE subscribers;
- fan-out latency measured;
- burst measured;
- delivery correctness measured;
- late join measured;
- reconnect measured;
- machine-readable result;
- no `NOT_APPLICABLE`;
- no generated files packaged.

---

# 14. Forbidden reviewer-facing terms / stale narrative scan

Scan **only the final staged submission**, not historical repo docs, for these strings and investigate every hit:

- `§AMENDMENT`
- `re-baseline`
- `rebaseline`
- `stakeholder authorized`
- `assignment frozen gates`
- `fan_out<=500`
- `burst<=1000`
- `B1 is ACCEPTED`
- `ACCEPTED under`
- `NOT_APPLICABLE`
- `terminal three-run`
- `contract v2.3.0`
- `M3 accepted`
- `user-authorized`

The intended final submission should contain none of those narratives except where an instruction artifact necessarily preserves historical AI instructions. **Do not alter historical instruction artifacts to erase their provenance.** The scan exclusion is therefore:

- reviewer-facing `proposal.md`, `README.md`, and runnable `poc/` source/config must not contain the stale narrative;
- preserved agent instruction artifacts may contain historical language because they must remain authentic.

---

# 15. Explainability audit

Before finishing, assume the interviewer asks:

1. Why SSE rather than WebSockets?
2. Why DynamoDB?
3. Why SQS FIFO?
4. What exactly guarantees no duplicates?
5. What exactly happens on reload?
6. What happens if the provider never sends a goal?
7. How can one match have 80,000 viewers if a node handles far fewer?
8. Why single region?
9. Why does the system fit under $3k?
10. Why did the POC "fail" and why is that useful?
11. What did the POC actually measure versus not measure?
12. Why does the one-command run use 1,000 rather than 100,000?
13. What must be tested before production launch?

Every answer must be directly recoverable from the final proposal/README without relying on hidden internal milestone documents.

If not, improve the documents while remaining inside word limits.

---

# 16. Definition of done

Do not declare 100% ready until all of these are true:

- final proposal <=1,500 words excluding diagram;
- final POC write-up <=300 words;
- exact assignment requirements are all addressed;
- no assignment requirement has been replaced by an internal milestone criterion;
- fixed-capacity POC result is honestly described as a latency failure that changed the architecture;
- no threshold was changed post-measurement to manufacture success;
- reviewer POC produces a real portable measured result;
- reviewer POC does not return `NOT_APPLICABLE`;
- one command works from a freshly extracted ZIP;
- Docker is the only host prerequisite;
- 100/500/1000 subscriber measurements complete;
- README portable values exactly match the final clean-room run;
- hot-match scaling across multiple nodes is concrete;
- provider best-effort loss boundary is explicit;
- cost and topology are coherent;
- ZIP contains only allowed delivery material;
- no generated debris is packaged;
- every actually used AI instruction file is included;
- no unfilled placeholders remain;
- final extracted ZIP has been rerun successfully after the last document update.

At the end, produce a concise terminal report containing:

- final Git commit SHA;
- final ZIP SHA-256;
- proposal prose word count;
- POC write-up word count;
- final clean-room command;
- exit code;
- 100/500/1000 achieved subscriber counts;
- 1,000-subscriber fan-out p95;
- missing/duplicate/out-of-order counts;
- ZIP top-level file list;
- `FINAL STATUS: 100% SUBMISSION READY`.

If any gate still fails, do **not** print `100% SUBMISSION READY`; continue fixing it.
