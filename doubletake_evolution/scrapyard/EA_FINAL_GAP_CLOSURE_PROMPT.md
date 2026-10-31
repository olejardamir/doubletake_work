# EA Live Match Centre — Final Gap-Closure Prompt

## Objective

Work on the current `main` branch of:

`https://github.com/olejardamir/EA`

The submission is close, but it is **not yet 100% submission-ready**.

Your job is to close the **remaining concrete gaps only**, without reopening already-correct parts of the architecture or rewriting the submission unnecessarily.

Do not stop at analysis.

You must:

1. inspect the current implementation;
2. fix the remaining POC measurement defects;
3. simplify the final reviewer-facing POC;
4. update the hot-match cost sensitivity;
5. run the corrected POC;
6. update README measurements from the corrected run;
7. rebuild the final ZIP;
8. extract the ZIP into a clean directory;
9. run the exact reviewer command from the extracted ZIP;
10. verify every remaining gate;
11. loop until all gates pass.

Do not ask the user for clarification.

---

# 1. Source of truth

The take-home assignment remains the sole reviewer-facing acceptance authority.

Do **not** reintroduce internal M3 contracts, amendments, re-baselined thresholds, acceptance envelopes, or historical milestone criteria into `proposal.md`, `README.md`, or the staged `poc/`.

The final POC should measure what it claims to measure.

A number that appears in the reviewer-facing README must be supported by the actual code and the final clean-room run.

---

# 2. Remaining blockers to fix

The current submission has five remaining issues.

## BLOCKER A — `missing` is not viewer-level correctness

The current POC computes a union of sequences observed by subscribers and compares that union with published sequences.

That logic can report:

`missing = 0`

even when individual viewers missed events.

Example:

- subscriber A receives seq 1,2,3;
- subscriber B receives seq 1,3;
- the union is 1,2,3;
- global missing = 0;
- but subscriber B actually missed seq 2.

This must be fixed.

The final reported `missing` count must represent **viewer-facing delivery misses**, not channel-level union coverage.

---

## BLOCKER B — current late-join test is not a late-join test

The current implementation opens the subscriber before publishing the test history.

That measures a normal live subscriber, not a late joiner.

The Nchan configuration already distinguishes:

- `/sub/<match>` = live-only/newest;
- `/history/<match>` = history replay/oldest.

The final test must:

1. publish history first;
2. open a new subscriber only after the history already exists;
3. connect through the actual history endpoint;
4. measure how many historical events become visible;
5. measure time to complete history;
6. verify ordering;
7. verify duplicates;
8. verify missing historical events.

This must be a genuine late-join/reload test.

---

## BLOCKER C — current reconnect test does not test recovery

The current reconnect test disconnects the client, publishes no events while disconnected, reconnects, then publishes more events.

That only proves:

> a fresh connection can receive new live events.

It does **not** prove resume/recovery.

The corrected reconnect test must create an actual gap.

Required sequence:

1. subscriber connects;
2. subscriber receives live events through sequence `N`;
3. subscriber disconnects;
4. several events are published while subscriber is offline;
5. subscriber reconnects;
6. recovery/history mechanism supplies the missed events;
7. live delivery continues afterward;
8. final reconstructed sequence is complete, ordered, and duplicate-free.

The test must report:

- last sequence before disconnect;
- number of events published while offline;
- number of missed events recovered;
- number still missing after recovery;
- duplicates;
- out-of-order;
- final state/sequence agreement;
- recovery duration.

Do not merely report `ok: true` because some post-reconnect event arrived.

---

## BLOCKER D — final POC still contains diagnostic baggage

The staged POC currently carries old diagnostic machinery that is not needed by the reviewer experiment, including some combination of:

- Nginx debug build;
- `gdb`;
- livelock watcher;
- restart-control tooling;
- old fan-out configs;
- experimental variants;
- temporary diagnostics;
- architecture-probe-era files.

The assignment asks for the smallest experiment that meaningfully tests the risky assumption.

Remove or disable anything that can perturb the final measurements.

The final reviewer-facing POC must not run a `gdb` watcher or similar instrumentation during measurement.

Prefer a minimal Nchan image/config containing only what the final POC needs.

Do not remove historical materials from the repository if they are useful internally.

Do remove them from the **staged ZIP POC** unless required by the final one-command experiment.

---

## BLOCKER E — hot-match cost sensitivity is incomplete

The current cost model uses approximately:

`10 events/s total ÷ 8 matches = 1.25 events/s per match`

for delivery bandwidth planning.

That is only an average.

A hot match can receive both:

- most of the viewers;
- more than the average share of events.

The final architecture/cost explanation must include a hot-match sensitivity case.

At minimum model:

- 100,000 viewers on one hot match;
- payload assumption = current approximately 250 B/event;
- 120 peak-equivalent hours/month;
- event rates:
  - 1.25 events/s;
  - 5 events/s;
  - 10 events/s.

Show the approximate monthly transfer volume for each.

Use the formula:

```text
DTO bytes =
viewers
× events_per_second
× payload_bytes
× 3600
× live_hours
```

Using 100,000 viewers, 250 B/event, 120 hours:

```text
1.25 events/s ≈ 13.5 TB
5 events/s    ≈ 54 TB
10 events/s   ≈ 108 TB
```

Do not pretend the 50 TB CloudFront Business allowance automatically covers all hot-match cases.

The final proposal should say clearly that the approximately `$2,318/month` base model is conditional on the assumed event distribution / traffic envelope.

If hot-match traffic exceeds the included transfer allowance, production must:

- upgrade the distribution pricing plan;
- use negotiated/PAYG pricing;
- reduce payload size;
- compress where applicable;
- or revise the cost model.

Do not fabricate new AWS prices if they are not verified.

The assignment requirement is a reasoned budget design, not false precision.

---

# 3. Correct viewer-level delivery accounting

Rewrite the final portable POC accounting so each subscriber is evaluated independently.

For each subscriber, track:

```text
expected sequence set
received sequence set
duplicates
out_of_order
missing
```

Because all subscribers for a match should receive every event published during the interval in which that subscriber is considered active, the expected sequences for each subscriber must reflect its actual measurement window.

Do not count warm-up events that occurred before the subscriber became eligible unless the subscriber is intentionally testing history replay.

Do not count post-close events.

A robust approach is:

- establish all subscribers;
- confirm all are connected;
- record `measurement_start_seq[match]`;
- run measurement;
- record `measurement_end_seq[match]`;
- for every subscriber assigned to that match:
  - expected sequences = `[start_seq, end_seq)`;
  - compare against that subscriber's received set.

Final step metrics should include at least:

```json
{
  "viewer_delivery": {
    "expected_deliveries": 0,
    "received_unique_deliveries": 0,
    "missing_deliveries": 0,
    "duplicate_deliveries": 0,
    "out_of_order_deliveries": 0,
    "viewers_with_missing": 0,
    "viewers_with_duplicates": 0,
    "viewers_with_out_of_order": 0
  }
}
```

The README phrase:

`0 missing`

must only be used if:

`missing_deliveries == 0`

across the final 1,000-viewer measurement window.

---

# 4. Correct fan-out latency measurement

Continue measuring real publish-to-SSE-frame latency.

For each received event:

```text
latency_ms = receive_timestamp - publish_timestamp
```

Use a monotonic clock where practical for process-local timing.

If using wall-clock timestamps because publisher and subscribers are in the same runner process/container, document that choice.

Do not count:

- malformed frames;
- keepalive frames;
- events outside the measurement interval;
- history replay events in the live fan-out histogram.

Report:

- p50;
- p95;
- p99;
- burst p95.

Do not invent a pass threshold.

The result is a measurement.

---

# 5. Implement a real late-join/history experiment

Create a dedicated match, e.g.:

`match-latejoin`

Required method:

### Phase 1 — pre-populate history

Publish 25 canonical events:

```text
seq = 0..24
```

before any late-join subscriber exists.

Wait long enough for the events to be buffered.

### Phase 2 — late join

Record:

`late_join_started_at`

Then connect a subscriber to:

`/history/match-latejoin`

The subscriber must start after all 25 events were already published.

Collect replayed events until:

- all 25 unique sequences arrive; or
- 2 seconds have elapsed.

Measure:

```json
{
  "published_history": 25,
  "received_unique": 25,
  "missing": 0,
  "duplicates": 0,
  "out_of_order": 0,
  "history_complete_ms": 0,
  "complete_within_2s": true
}
```

`history_complete_ms` must be measured from subscriber/history request start to receipt of the complete ordered history.

### Important

If Nchan's history endpoint remains open as SSE after replay, do not wait for connection close.

Terminate measurement when all expected history has been received or timeout occurs.

---

# 6. Implement a real reconnect/recovery experiment

Create a dedicated match, e.g.:

`match-reconnect`

The reconnect experiment must demonstrate missed-event recovery.

One acceptable implementation:

## Step A — initial live session

Connect to:

`/sub/match-reconnect`

Publish:

```text
seq 0..4
```

Verify subscriber receives them.

Close the subscriber.

Store:

`last_applied_seq = 4`

## Step B — publish while offline

While no subscriber is connected, publish:

```text
seq 5..9
```

These are the actual missed events.

## Step C — recover

Reconnect through history/replay.

If the Nchan history endpoint cannot request `after seq=4` directly, it is acceptable for this POC to replay buffered history and let the client-side reducer ignore already-applied sequences.

The recovery reducer should:

- begin with sequences `0..4` already applied;
- consume replay;
- ignore duplicate already-applied sequence IDs;
- recover `5..9`;
- end with a complete contiguous sequence `0..9`.

## Step D — continue live

Then return to the live endpoint and publish:

```text
seq 10..14
```

Verify the client reaches complete contiguous sequence:

`0..14`

Report:

```json
{
  "last_seq_before_disconnect": 4,
  "offline_events_published": 5,
  "offline_events_recovered": 5,
  "missing_after_recovery": 0,
  "duplicates_applied": 0,
  "out_of_order_applied": 0,
  "final_last_seq": 14,
  "state_complete": true,
  "recovery_ms": 0
}
```

A replay may physically redeliver seq `0..4`.

Those transport duplicates are acceptable only if the client reducer filters them.

Therefore distinguish:

```text
transport_duplicates_seen
```

from:

```text
duplicates_applied
```

The user-facing state must remain duplicate-free.

---

# 7. Simplify the final Nchan container

Create a submission-specific minimal Nchan configuration if that is easier than cleaning the old one.

The final POC needs only:

- publisher endpoint;
- live subscriber endpoint;
- history subscriber endpoint;
- Redis/Valkey-backed buffer;
- SSE keepalive;
- enough worker connections for 1,000 + surge subscribers;
- health endpoint.

It does not need:

- sixteen historical fan-out configs;
- partition debugging;
- gdb;
- livelock watcher;
- old architecture probes;
- restart control API unless reconnect testing truly requires it;
- Nginx debug instrumentation.

Prefer:

```text
poc/
  compose.yaml
  redis-cgroup-entrypoint.sh   # only if truly needed
  nchan/
    Dockerfile
    nginx.conf
    entrypoint.sh              # only if needed
  runner/
    Dockerfile
    package.json
    package-lock.json
    tsconfig.json
    src/
      submission-run.ts
```

The exact structure may differ, but keep it minimal.

---

# 8. Ensure the portable experiment's load semantics are clear

The reviewer command should continue to run:

- 100 real SSE subscribers;
- 500 real SSE subscribers;
- 1,000 real SSE subscribers.

For each step, confirm:

```text
achieved_subscribers == requested_subscribers
```

If not, report the discrepancy and fail the harness.

Do not call the experiment `COMPLETED` if the requested 1,000-subscriber step was never actually established.

Use:

```text
EXPERIMENT STATUS: COMPLETED
```

only when:

- all requested subscriber counts were reached;
- measurement phases executed;
- late-join test executed;
- reconnect/recovery test executed;
- final JSON was produced.

Poor latency or non-zero correctness errors should not crash the harness; they should appear honestly in the result.

Harness failure is different from an unfavorable measurement.

---

# 9. Correct steady and burst feed rates

The assignment describes:

- approximately 10 events/s total steady;
- burst approximately 50 events/s total.

The portable POC should approximate these actual total publish rates.

Do not accidentally implement a different rate.

For example:

### Steady

```text
one publish every ~100 ms
=> ~10 events/s total
```

### Burst

```text
one publish every ~20 ms
=> ~50 events/s total
```

If using concurrent publishes, calculate the effective aggregate rate correctly.

The current pattern of two parallel publishes every 20 ms can produce approximately 100 events/s, not 50 events/s.

Fix this if present.

The README must not say the POC simulates ~50/s burst if the code is actually producing ~100/s.

---

# 10. Fix surge interpretation

The assignment's production surge is:

`+40,000 viewers in 120 seconds`

The portable POC is not expected to reproduce 40,000 viewers.

The portable POC may include a smaller connection surge for measurement, but label it clearly as a scaled local stress behavior.

Do not imply that adding `targetN / 2` subscribers in 5 seconds is literally the assignment's +40k/120s workload.

The proposal can retain production planning math:

```text
40,000 / 120 ≈ 333 new viewers/s
```

The POC only needs to test whether fan-out measurements remain observable under connection churn/surge.

---

# 11. Update README only after corrected measurements exist

Do not keep the current portable numbers if the corrected POC produces different values.

After the corrected clean-room run, update the reviewer-facing README `Result` paragraph using the actual final values.

The result wording should retain the historical 100k result:

```text
100,000 viewers
fan-out p95 4.242 s
burst p95 11.006 s
late-join p95 0.906 s
viewer-facing correctness violations = 0
```

Then add the **new corrected portable result**, including:

- 1,000 achieved subscribers;
- fan-out p95;
- burst p95;
- viewer-level missing deliveries;
- viewer-level duplicates;
- viewer-level out-of-order;
- real history replay result;
- real reconnect recovery result.

Do not report approximate values copied from the previous incorrect harness.

Use values from the final corrected clean-room run.

---

# 12. Keep the POC write-up under 300 words

After inserting the new measurements:

Count only the required POC write-up:

- Assumption
- Method
- Result
- Proposal impact

It must remain:

`<= 300 words`

If it exceeds 300, shorten prose without removing the required information.

Do not rely on an old audit word count.

Count the current final text.

---

# 13. Hot-match cost sensitivity update

Update `proposal.md` in the cost section.

Do not make it much longer.

Add a concise sensitivity sentence or small compact paragraph such as:

> The $2,318 base case assumes roughly even event distribution. A 100,000-viewer hot match at 250 B/event and 120 live hours would transfer about 13.5 TB/month at 1.25 events/s, 54 TB at 5 events/s, and 108 TB at 10 events/s. The latter cases can exceed the modeled CloudFront plan allowance, so the budget is conditional on real match event distribution, payload size, and negotiated/selected transfer pricing.

Retain the statement that the base design is modeled below $3,000/month.

Do not claim every possible hot-match traffic distribution remains below $3,000.

The assignment asks for architectural reasoning, so a transparent conditional budget is stronger than an unjustified universal claim.

Re-count proposal words after this edit.

It must remain:

`<= 1,500 words excluding diagrams`.

---

# 14. Do not regress already-fixed architecture text

Preserve the current correct proposal behavior:

- provider best-effort limitation is explicit;
- provider features are not invented;
- canonical truth is DynamoDB;
- hot match can span multiple delivery replicas;
- public frontend has no accounts;
- Next.js App Router is explicit;
- component architecture is explicit;
- history-to-live cursor handoff is explicit;
- score and event timeline derive from same canonical state;
- 8 matches;
- 10/s steady;
- ~50/s burst;
- 100k viewers;
- +40k/2 min;
- 60% Europe / 40% North America;
- 2 s goal SLO;
- 5 s other-event SLO;
- 2 s history target;
- weekly invisible deployment;
- fixed-capacity 100k POC result is honestly described as a latency failure;
- replacement horizontal topology is not falsely claimed to be benchmark-validated.

Do not undo these improvements.

---

# 15. Final ZIP staging

Rebuild:

`live-match-centre-submission.zip`

The top-level archive contents must remain only:

```text
proposal.md
README.md
poc/
AGENTS.md
MILESTONE_2_CLOSE_GAP_PROMPT_ARTIFACT.md
MILESTONE_3_ASSIGNMENT_SYNCED_EXECUTION_PLAN_v2_FINAL.md
PARALLEL_M3_SAFE_WORK_100_PERCENT_PROMPT_ARTIFACT.md
MILESTONE_3_ACCEPTANCE_RECOVERY_PROMPT_ARTIFACT.md
MILESTONES_4_5_6_7_CLOSE_100_PERCENT_OVERNIGHT_PROMPT_ARTIFACT.md
M3_ACCEPT_PUSH_EXHAUST_REMAINING_NCHAN_CONFIG_SPACE.md
FINAL_TAKEHOME_NON_M3_REQUIREMENT_CLOSURE_PROMPT_ARTIFACT.md
EA_FINAL_100_PERCENT_SUBMISSION_READY_PROMPT.md
EA_FINAL_GAP_CLOSURE_PROMPT.md
```

Include `EA_FINAL_GAP_CLOSURE_PROMPT.md` because this instruction file is now part of the AI process actually used.

If the README enumerates instruction artifacts, update that list accordingly.

The ZIP must not include:

```text
internal_docs/
evidence-launches/
logs/
generated JSON evidence
node_modules/
.git/
.gitignore
LICENSE.md
old compose variants
old experimental configs
debug dumps
temporary files
another ZIP
```

---

# 16. Clean-room procedure

After changes:

## First clean-room run

1. create a fresh temporary directory;
2. extract `live-match-centre-submission.zip`;
3. inspect the entire archive tree;
4. run exactly:

```bash
cd poc && docker compose up --build --abort-on-container-exit --exit-code-from runner
```

5. capture final JSON;
6. verify actual measurement semantics manually;
7. update README with those values.

## Rebuild

Rebuild the ZIP with updated README.

## Second clean-room run

Extract the rebuilt ZIP into another fresh directory.

Run the same exact command again:

```bash
cd poc && docker compose up --build --abort-on-container-exit --exit-code-from runner
```

The final reported README values should be representative of this corrected harness.

Small timing variance is acceptable.

Correctness counts must be reported from an actual run.

---

# 17. Final semantic assertions

Before declaring completion, inspect the code and answer these as `TRUE` or `FALSE`.

All must be `TRUE`.

```text
1. "missing_deliveries" is computed per viewer, not by unioning viewers.
2. A single viewer missing one expected event increases missing_deliveries.
3. Late-join subscriber starts after history has been published.
4. Late-join uses the actual history/replay path.
5. Late-join measures completion time.
6. Late-join validates ordering.
7. Reconnect publishes events while the client is disconnected.
8. Reconnect actually recovers those offline events.
9. Client/reducer prevents replay duplicates from being applied twice.
10. Reconnect ends with a complete contiguous sequence.
11. Steady publish rate is approximately 10/s total.
12. Burst publish rate is approximately 50/s total.
13. 100 requested subscribers are actually established.
14. 500 requested subscribers are actually established.
15. 1,000 requested subscribers are actually established.
16. No gdb/livelock watcher runs during the final POC.
17. The staged POC contains no historical evidence/debug directories.
18. README portable numbers come from the corrected harness.
19. POC write-up is <=300 words.
20. proposal.md is <=1,500 words excluding diagram.
21. Cost section includes hot-match transfer sensitivity.
22. Final ZIP contains only allowed material.
```

If any assertion is false, continue working.

---

# 18. Final measurement JSON shape

The final result should be approximately structured as:

```json
{
  "status": "COMPLETED",
  "steps": [
    {
      "subscribers": 100,
      "achieved_subscribers": 100,
      "fan_out_p50_ms": 0,
      "fan_out_p95_ms": 0,
      "fan_out_p99_ms": 0,
      "burst_p95_ms": 0,
      "viewer_delivery": {
        "expected_deliveries": 0,
        "received_unique_deliveries": 0,
        "missing_deliveries": 0,
        "duplicate_deliveries": 0,
        "out_of_order_deliveries": 0,
        "viewers_with_missing": 0,
        "viewers_with_duplicates": 0,
        "viewers_with_out_of_order": 0
      }
    },
    {
      "subscribers": 500,
      "achieved_subscribers": 500
    },
    {
      "subscribers": 1000,
      "achieved_subscribers": 1000
    }
  ],
  "late_join": {
    "published_history": 25,
    "received_unique": 25,
    "missing": 0,
    "duplicates": 0,
    "out_of_order": 0,
    "history_complete_ms": 0,
    "complete_within_2s": true
  },
  "reconnect": {
    "last_seq_before_disconnect": 4,
    "offline_events_published": 5,
    "offline_events_recovered": 5,
    "missing_after_recovery": 0,
    "transport_duplicates_seen": 0,
    "duplicates_applied": 0,
    "out_of_order_applied": 0,
    "final_last_seq": 14,
    "state_complete": true,
    "recovery_ms": 0
  }
}
```

The exact field names may differ slightly.

The semantics must not.

---

# 19. Final reviewer-facing result standard

The final submission should make the following story obvious:

1. The production requirement is 100,000 viewers.
2. The risky local assumption was fixed-tier SSE fan-out.
3. A historical 100k experiment actually reached 100k correctly but latency was too high.
4. Therefore fixed-capacity fan-out was rejected.
5. The architecture changed to horizontally replicated hot-match fan-out.
6. The portable POC is not pretending to reproduce 100k.
7. The portable POC demonstrates and measures the same mechanics at reviewer-friendly scale.
8. The corrected portable POC genuinely measures per-viewer correctness, history replay, and reconnect recovery.
9. Production-scale validation of the replacement topology remains necessary.
10. The budget is below $3k under the stated base assumptions, with explicit sensitivity to hot-match event volume.

There must be no attempt to manufacture a green result.

---

# 20. Definition of done

Do not print `100% SUBMISSION READY` until:

- viewer-level missing accounting is fixed;
- late join is a genuine post-history replay test;
- reconnect genuinely recovers events published while offline;
- steady and burst rates match approximately 10/s and 50/s total;
- diagnostic tooling is removed/disabled from final measurement path;
- portable 100/500/1000 subscriber steps complete;
- final measurement is generated by corrected code;
- README is updated with corrected values;
- POC write-up <=300 words;
- proposal <=1,500 words excluding diagram;
- hot-match cost sensitivity is included;
- final ZIP is rebuilt;
- extracted ZIP contains only allowed files;
- exact one-command POC works from clean extraction;
- all 22 semantic assertions above are TRUE.

At the very end print:

```text
FINAL GAP-CLOSURE REPORT

HEAD COMMIT:
<sha>

ZIP SHA-256:
<sha256>

PROPOSAL WORD COUNT:
<number>

POC WRITE-UP WORD COUNT:
<number>

CLEAN-ROOM COMMAND:
cd poc && docker compose up --build --abort-on-container-exit --exit-code-from runner

EXIT CODE:
<code>

SUBSCRIBERS:
100  -> achieved <n>
500  -> achieved <n>
1000 -> achieved <n>

1000-VIEWER FAN-OUT P95:
<ms>

1000-VIEWER BURST P95:
<ms>

VIEWER-LEVEL CORRECTNESS:
missing deliveries: <n>
duplicate deliveries: <n>
out-of-order deliveries: <n>
viewers with missing: <n>

LATE JOIN:
published: <n>
received: <n>
missing: <n>
complete_ms: <n>
within_2s: <true/false>

RECONNECT RECOVERY:
offline published: <n>
offline recovered: <n>
missing after recovery: <n>
duplicates applied: <n>
out-of-order applied: <n>
state complete: <true/false>
recovery_ms: <n>

HOT-MATCH COST SENSITIVITY:
1.25 evt/s: ~13.5 TB/month
5 evt/s: ~54 TB/month
10 evt/s: ~108 TB/month

ZIP TOP-LEVEL CONTENTS:
<list>

SEMANTIC ASSERTIONS:
22 / 22 TRUE

FINAL STATUS: 100% SUBMISSION READY
```

If anything is not true, continue fixing it instead of printing that final status.
