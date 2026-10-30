# DoubleTake — Active Evolution Mission

**Mission:** Continuous, evidence-led DoubleTake improvement.
**Status:** ACTIVE — 3 tasks, 5 open top-level subtasks (diagnostic step 1.3.1 archived; activation and liveness remain open).
**Latest DT main inspected:** `0628504c03d0` (2026-10-30; repository evidence, not a live connection by this planner).
**Execution owner:** DoubleTake. The planning repository is public: never publish private source, logs, secrets, privileged runtime identifiers, or confidential evidence.

## Operating rules
- Work from the current `main`; read the repository's existing instructions and recheck concurrent changes before editing. Preserve the single-main/no-tags rule, host workload protections, current authority, rollback and existing state stores.
- **VERIFY_FIRST:** Each subtask below remains open for a specific reason. Compare any newer implementation or live evidence before changing code; if a criterion is already met, return a precise evidence pointer rather than rebuilding it.
- Use outward exploration → inward consolidation → stable verification when useful. Do not create new managers, approvals, redundant trackers, unbounded retry loops, or unrelated work.
- Never manufacture grants, bypass authentication, change safety-relevant phase permissions without existing authority, or delete retained runtime state to make a test pass.
- Report per-subtask source revision, focused tests or observation, remaining gap, and exact next action. The worker archives a subtask only after verifying **all** its acceptance criteria. Do not claim a healthy fleet based on a previously successful but now-ended process.
- **Already archived:** 1.1, 1.2, 1.3.1 (diagnosis only), 1.4, 2.1, 2.3, 3.1, 3.2. Do not re-add them unless new evidence establishes a regression.

## DT-EVO-001 — Restore complete live autonomous-cycle progress
**Priority:** CRITICAL. **Objective:** A currently running autonomous instance completes natural end-to-end cycles without upstream work exhausting the shared phase budget.
**Evidence:** Three distinct upstream inefficiencies have now been isolated with bounded measurements, source-level corrections and focused regression evidence. The current observed process has not loaded those corrections. A sustained natural observation window on that older process showed repeated starvation, not recovery. The diagnosis step (1.3.1) is archived; deployment and live acceptance are not.

### Subtask 1.3 — Activate verified fixes and prove sustained liveness
**Dependency:** Preserve historical restart/state safeguards. Do not mistake committed code or a frozen-snapshot benchmark for a loaded runtime.

1. **1.3.2 — Safely activate the three existing corrections and verify loaded source.** Do **not** reimplement the completed bounded-scan, source-scope or batched-persistence corrections. A recent process-lifecycle check established that restarting the active service during its current dependent session would terminate that session. Do not interrupt it, bypass the supported lifecycle, or use a fresh-state second instance as a substitute for the affected workload. Recheck whether that operational blocker still exists; when a supported, non-disruptive activation becomes possible within existing authority, load the corrections and verify the actual running revision. **Test/DoD:** Supported activation with recorded loaded-version evidence, passing focused host-guarded timeout, state, source-boundary and recovery regressions, and no unrelated-session disruption. A blocked restart, an unloaded fix or a test-only success is not a pass.
2. **1.3.3 — Prove sustained natural liveness on the corrected runtime.** After verified activation, observe naturally scheduled cycles with all intended downstream phases and unaffected work. Use a representative **60-minute post-activation window**; explicitly mark any shorter or interrupted window inconclusive. Preserve the prior negative observation as baseline evidence, not as proof of the fix. **Test/DoD:** Multiple complete naturally scheduled cycles, no recurring downstream starvation over the observation window, and version-scoped outcomes, timeout/parking behavior and residual risks. A single healthy cycle or direct phase invocation is insufficient.
- **Next action:** Recheck whether the dependent session has ended and a safe supported activation is possible. Until then preserve the existing measured diagnosis and focused tests; do not restart the active service or regenerate the same benchmarks. After activation, run the post-fix natural window.

## DT-EVO-002 — Finish authorized production repair integration
**Priority:** HIGH. **Objective:** Existing bounded repair machinery is reachable from real detected faults only through existing authority. The diagnostic and bounded component tests are already archived.

### Subtask 2.2 — Complete the missing authorized caller
**Dependency:** Preserve existing grants and request-evidence requirements.
1. **2.2.1 — Reconfirm the missing seam at current HEAD.** Trace detection → classification → evidence-backed request → authority decision → existing repair executor → verification and state. **Test/DoD:** Current source and focused integration tests identify a production caller or precisely locate the absent link; skip implementation if the caller already satisfies all criteria.
2. **2.2.2 — Wire only the missing integration within granted scope.** Reuse existing repair/scheduler/state components; preserve denial, rollback and no-effect behavior. If a required standing grant or owner-declared request is unavailable, record `BLOCKED_AUTHORIZATION`; never self-grant or bypass it. **Test/DoD:** Production-reachable invocation exists and rejects missing authority without side effects; absent authority keeps this step open.
3. **2.2.3 — Run focused integration tests.** Cover permitted invocation, absent/invalid grant, incomplete evidence, denied mutation, verification failure and unrelated-work continuation. **Test/DoD:** Host-guarded positive and negative cases pass with reproducible results and no unauthorized effects.
- **Done when:** A production-reachable caller passes required evidence, invokes the existing executor **only** with valid authority, refuses unauthorized work without side effects, and has recorded focused test outcomes. A control endpoint returning unauthenticated denial alone is **not** a repair caller.
- **Next action:** Recheck the caller and authority prerequisites at latest HEAD, then implement only what is permitted.

### Subtask 2.4 — Verify the real repair fault path
**Dependency:** 2.2 must expose a production-reachable fault-to-repair caller; a pre-existing authentication-boundary denial does not independently prove this path.
1. **2.4.1 — Choose a safe fault observation.** Prefer an existing harmless recoverable fault or an isolated controlled scenario; never inject hazardous faults into shared workloads. **Test/DoD:** Fault is demonstrably harmless, scoped and reproducible without disrupting shared work.
2. **2.4.2 — Exercise the production caller.** Demonstrate an authorized repair with verification/rollback **or** a measured safe refusal by the actual fault-to-repair caller when authorization is absent. **Test/DoD:** Actual production fault path, authority decision and effects/no-effects are observed; a separate control-route denial is insufficient.
3. **2.4.3 — Reconcile state.** Record outcome, effects/no-effects, bounded retries and unaffected work, clearly separating live observation from fixtures. **Test/DoD:** Durable outcome and retry limits are checked after the run, with no unauthorized or unrelated effects.
- **Done when:** The actual production fault-to-repair caller is observed returning a verified repair or a safe refusal, with durable state and no unauthorized effects. An unauthenticated request to a separate control route does not close this criterion.
- **Next action:** Wait for the 2.2 integration seam or new proof of an existing caller; retain the previously measured access-control refusal as a useful partial security check.

## DT-EVO-003 — Finish the remaining performance evidence and close accurately
**Priority:** MEDIUM. **Objective:** Make remaining autonomy claims reproducible without rebuilding already completed evidence. The stale-record classification and regeneration subtasks (3.1–3.2) are archived.

### Subtask 3.3 — Complete matched autonomy performance evidence
1. **3.3.1 — Preserve existing measurements accurately.** The current evidence includes a live **before-only** repeated-state-write sample, a matched frozen-snapshot phase-level write comparison, and separate phase-level latency and synthetic results; these are different scopes. Do not regenerate or conflate them. **Test/DoD:** Verify each measurement's scope, method, sample and revision; explicitly label the live write sample as a lower bound from a degraded interval and the matched write comparison as phase-only.
2. **3.3.2 — Collect a matched post-activation write sample.** Once all three relevant fixes are actually loaded, measure repeated-state writes, latency, interventions and timeouts over a comparable workload and interval. Reuse existing bounded instrumentation, matching the previous observation method and accounting for sampling coalescence; do not assume the fixes reduce writes. **Test/DoD:** Reproducible before/after data with comparable workload, duration, observation method, version and caveats, or a precise explanation of non-comparability.
3. **3.3.3 — Report outcomes without inflation.** Preserve measured regressions and separate live, synthetic, phase-only and end-to-end evidence. **Test/DoD:** The comparison states every measured dimension, limitations and any regressions; unmeasured gains are not claimed.
- **Done when:** Reproducible matched evidence covers all requested dimensions, including repeated-state writes, and honestly records any regression or non-comparability.
- **Next action:** Preserve both the degraded-state live write baseline and the already-measured phase-level comparison; obtain a matched live after-sample only after verified activation, avoiding another baseline-only run.

### Subtask 3.4 — Close or explicitly bound the remaining mission
**Dependency:** Reconcile 1.3, 2.2, 2.4 and 3.3 with evidence rather than relying on a status label.
1. **3.4.1 — Reconcile every remaining criterion.** List measured pass/fail/blocked outcomes, exact authority limitations and affected runtime generations. **Test/DoD:** Each active acceptance claim is checked against current, version-scoped evidence and conflicting historical claims are explicitly superseded.
2. **3.4.2 — Publish one concise final status.** Reuse the existing status/evidence owner; do not create duplicate trackers or claim full closure for qualified results. **Test/DoD:** One consistent status identifies passes, open defects, authorization blockers and evidence gaps without claiming unverified closure.
- **Done when:** Every acceptance claim has traceable evidence, every remaining blocker is accurately classified, and no duplicate reporting loop is introduced. If core work is still open, this subtask remains open rather than disguising partial completion as full closure.
- **Next action:** Reconcile after the next successful current-generation cycle or materially new authorization/performance evidence.

## Per-run output
Report the current DT HEAD, verified and removed subtasks, evidence and tests for changes, outstanding blockers, and the next runnable subtask. Do not regenerate this mission from scratch.
