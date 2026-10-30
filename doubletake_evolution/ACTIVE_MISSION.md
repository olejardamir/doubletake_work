# DoubleTake — Active Evolution Mission

**Mission:** Continuous, evidence-led DoubleTake improvement.
**Status:** ACTIVE — 3 tasks, 5 individually actionable open subtasks.
**Latest DT main inspected:** `5667b3980d1c` (2026-10-30; repository evidence, not a live connection by this planner).
**Execution owner:** DoubleTake. The planning repository is public: never publish private source, logs, secrets, privileged runtime identifiers, or confidential evidence.

## Operating rules
- Work from the current `main`; read the repository's existing instructions and recheck concurrent changes before editing. Preserve the single-main/no-tags rule, host workload protections, current authority, rollback and existing state stores.
- **VERIFY_FIRST:** Each subtask below remains open for a specific reason. Compare any newer implementation or live evidence before changing code; if a criterion is already met, return a precise evidence pointer rather than rebuilding it.
- Use outward exploration → inward consolidation → stable verification when useful. Do not create new managers, approvals, redundant trackers, unbounded retry loops, or unrelated work.
- Never manufacture grants, bypass authentication, change safety-relevant phase permissions without existing authority, or delete retained runtime state to make a test pass.
- Report per-subtask source revision, focused tests or observation, remaining gap, and exact next action. The worker archives a subtask only after verifying **all** its acceptance criteria. Do not claim a healthy fleet based on a previously successful but now-ended process.
- **Already archived:** 1.1, 1.2, 1.4, 2.1, 2.3, 3.1, 3.2. Do not re-add them unless new evidence establishes a regression.

## DT-EVO-001 — Restore complete live autonomous-cycle progress
**Priority:** CRITICAL. **Objective:** A currently running autonomous instance completes its natural end-to-end cycle without an upstream phase consuming the budget and starving downstream work.
**Evidence:** A prior process generation completed full cycles, but the surviving generation was re-observed after restart with upstream time-budget failures. Passing component tests and previously successful instances do not satisfy current liveness.

### Subtask 1.3 — Diagnose and close the live cycle starvation
**Dependency:** Existing activation and restart checks (1.1, 1.2, 1.4) are archived; revalidate only if new evidence shows regression.
1. **1.3.1 — Observe current behavior.** Obtain a new, bounded, timestamped natural-heartbeat observation from the current process. Distinguish the full operating-loop cycle from other independently advancing cycle counters. Identify which upstream phase, budget, and state-size factors prevent downstream completion.
2. **1.3.2 — Select a safe bounded remedy.** Measure the cause and choose the smallest non-destructive fix within existing authority: bounded work per phase, incremental processing, safe resumption, or a properly governed phase policy. Do **not** silently authorize skipping safety-relevant work, discard retained state, or increase budgets without a measurement. If an action requires authority not already granted, record that specific blocker and continue non-destructive diagnostics.
3. **1.3.3 — Stabilize and prove liveness.** Run focused host-guarded regression/negative tests for timeout, cancellation, retry/parking, persistence, and unaffected phases; then observe at least one **naturally scheduled** complete live cycle on the current generation.
- **Done when:** Timestamped evidence identifies the current loaded revision, proves all intended phases complete or are intentionally skipped by existing policy, shows no downstream starvation or budget breach during the observed full cycle, and documents test results and residual risks. A direct phase invocation, historical process, or isolated test is insufficient.
- **Next action:** Capture the current generation's next natural tick and isolate the first budget-exhausting phase before any code change.

## DT-EVO-002 — Finish authorized production repair integration
**Priority:** HIGH. **Objective:** Existing bounded repair machinery is reachable from real detected faults only through existing authority. The diagnostic and bounded component tests are already archived.

### Subtask 2.2 — Complete the missing authorized caller
**Dependency:** Preserve existing grants and request-evidence requirements.
1. **2.2.1 — Reconfirm the missing seam at current HEAD.** Trace detection → classification → evidence-backed request → authority decision → existing repair executor → verification and state. Skip implementation if a new caller already satisfies the criteria.
2. **2.2.2 — Wire only the missing integration within granted scope.** Reuse existing repair/scheduler/state components; preserve denial, rollback and no-effect behavior. If a required standing grant or owner-declared request is unavailable, record `BLOCKED_AUTHORIZATION`; never self-grant or bypass it.
3. **2.2.3 — Run focused integration tests.** Cover permitted invocation, absent/invalid grant, incomplete evidence, denied mutation, verification failure and unrelated-work continuation.
- **Done when:** A production-reachable caller passes required evidence, invokes the existing executor **only** with valid authority, refuses unauthorized work without side effects, and has recorded focused test outcomes. A control endpoint returning unauthenticated denial alone is **not** a repair caller.
- **Next action:** Recheck the caller and authority prerequisites at latest HEAD, then implement only what is permitted.

### Subtask 2.4 — Verify the real repair fault path
**Dependency:** 2.2 must expose a production-reachable fault-to-repair caller; a pre-existing authentication-boundary denial does not independently prove this path.
1. **2.4.1 — Choose a safe fault observation.** Prefer an existing harmless recoverable fault or an isolated controlled scenario; never inject hazardous faults into shared workloads.
2. **2.4.2 — Exercise the production caller.** Demonstrate an authorized repair with verification/rollback **or** a measured safe refusal by the actual fault-to-repair caller when authorization is absent.
3. **2.4.3 — Reconcile state.** Record outcome, effects/no-effects, bounded retries and unaffected work, clearly separating live observation from fixtures.
- **Done when:** The actual production fault-to-repair caller is observed returning a verified repair or a safe refusal, with durable state and no unauthorized effects. An unauthenticated request to a separate control route does not close this criterion.
- **Next action:** Wait for the 2.2 integration seam or new proof of an existing caller; retain the previously measured access-control refusal as a useful partial security check.

## DT-EVO-003 — Finish the remaining performance evidence and close accurately
**Priority:** MEDIUM. **Objective:** Make remaining autonomy claims reproducible without rebuilding already completed evidence. The stale-record classification and regeneration subtasks (3.1–3.2) are archived.

### Subtask 3.3 — Complete matched autonomy performance evidence
1. **3.3.1 — Reuse the existing matched measurements.** Preserve the recorded bounded-phase latency/timeout comparison and the separate synthetic benchmark without misrepresenting different workload scopes as equivalent.
2. **3.3.2 — Measure the missing repeated-state-write baseline.** On equivalent safe workloads, record before/after state-write counts alongside latency, interventions, timeouts and environment. Use existing instrumentation where possible; do not introduce a new monitoring system.
3. **3.3.3 — State regressions and limitations.** Distinguish live versus synthetic, sample sizes and any change of workload scope; do not claim unmeasured improvements.
- **Done when:** Reproducible matched evidence covers **all** requested dimensions, including repeated-state writes, and honestly records any regression or non-comparability.
- **Next action:** Identify the owning existing counter or verifier for state writes and collect a comparable baseline and candidate measurement.

### Subtask 3.4 — Close or explicitly bound the remaining mission
**Dependency:** Reconcile 1.3, 2.2, 2.4 and 3.3 with evidence rather than relying on a status label.
1. **3.4.1 — Reconcile every remaining criterion.** List measured pass/fail/blocked outcomes, exact authority limitations and affected runtime generations.
2. **3.4.2 — Publish one concise final status.** Reuse the existing status/evidence owner; do not create duplicate trackers or claim full closure for qualified results.
- **Done when:** Every acceptance claim has traceable evidence, every remaining blocker is accurately classified, and no duplicate reporting loop is introduced. If core work is still open, this subtask remains open rather than disguising partial completion as full closure.
- **Next action:** Reconcile after the next successful current-generation cycle or materially new authorization/performance evidence.

## Per-run output
Report the current DT HEAD, verified and removed subtasks, evidence and tests for changes, outstanding blockers, and the next runnable subtask. Do not regenerate this mission from scratch.
