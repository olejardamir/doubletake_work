# DoubleTake — Active Evolution Mission

**Mission:** Continuous, evidence-led DoubleTake improvement.
**Status:** ACTIVE — earlier evidence confirms implementation progress but does not establish completion of the remaining live subtasks.
**Last observed DT main:** `49d0c5fd8e66` (repository inspection; not a live-runtime attestation).
**Execution owner:** DoubleTake. This public prompt contains no private source, logs, or secrets.

## General execution rules
- Work from current `main`; reread latest repository instructions and check for concurrent changes.
- These are **three separate tasks with individually actionable subtasks**. Historical evidence may be superseded; obtain current runtime/test evidence before marking a subtask complete. Verify each subtask against current source, runtime, and tests **before** modifying anything. If already done, report evidence and skip implementation.
- Retain existing minimal kernel, delegated permissions, meaningful verification, host protections and rollback. Never self-grant authorization or bypass existing permissions.
- Persist clear, bounded results in the implementation repository, using existing stores; do not create an approval layer or redundant planning machinery.
- Do not mark any live requirement complete based solely on a unit test, fixture, commit title, or old report.
- For every verified subtask, supply relevant commit, command/test result, and observed outcome. The scheduled worker will reconcile the public mission and remove verified subtasks.

## DT-EVO-001 — Verify the currently deployed autonomous runtime
**Priority:** HIGH. **Why:** Earlier committed fixes passed isolated tests but the running service had not loaded all of them.

### Subtasks
**1.1 — Inspect live/runtime drift.** Identify the loaded runtime version and compare it with the committed implementation. Determine which relevant autonomy, scanning, and repair fixes are actually in memory.
- **Done when:** A reproducible check demonstrates whether the live process uses current code; discrepancies are named without claiming a deployment.

**1.2 — Safely activate only outstanding runtime changes.** If restart or reloading is needed, use the existing supported service lifecycle with session/service ownership protections. Do not forcibly restart a process hosting another active session or interfere with peer workloads.
- **Done when:** A supported activation is observed and the newly loaded version is verified. Record any unresolved prerequisite as **BLOCKED**, not completed.

**1.3 — Measure one complete live autonomous cycle.** Observe scanning, planning, repair and downstream phase progression, including time budgets, failure handling and whether a paused state is treated as intentional rather than a fault.
- **Done when:** Timestamped live evidence demonstrates a complete successful cycle with no downstream phase skipped by timeout. If it fails, record the failure and keep this subtask open.

**1.4 — Regression and restart resilience.** Reuse existing focused restart-safety evidence before running tests; distinguish successful isolated restart-handoff checks from proof that paused state, bounded retries and recovery survive an actual or safely simulated full operating-loop restart. Run only missing focused host-guarded tests.
- **Done when:** Focused tests pass and an actual or safely simulated restart proves state integrity, with live versus simulation clearly labeled.

## DT-EVO-002 — Finish the existing autonomous repair execution path
**Priority:** HIGH. **Why:** Earlier evidence identified an implemented repair orchestrator without a fully demonstrated live caller.

### Subtasks
**2.2 — Connect only the missing seam.** The diagnostic subtask (2.1) has been verified and archived; do not repeat it without changed evidence. Verify the integration gap still exists at the working HEAD. If so, reuse existing repair, scheduler, permissions and state components. Prepare evidence-backed requests from detected failures and invoke the existing repair executor only within already granted authority.
- **Done when:** A production-reachable call site exists, carries required request evidence, and refuses attempts outside current authority. If required authority is absent, record that blocker and keep this subtask open; never manufacture a grant.

**2.3 — Verify bounded recovery.** Test repeat fault, unchanged-fingerprint parking, successful repair, failed verification, rollback, process restart, resource refusal, and unrelated-work continuation.
- **Done when:** Focused negative and positive cases pass and logs/state prove a bounded outcome without retry storms.

**2.4 — Verify an actual runtime fault path.** Use a controlled harmless fault or an already observed recoverable fault; do not inject dangerous failures into an active shared service.
- **Done when:** A live caller produces measurable repair or safe refusal, and its outcome is captured distinctly from fixture tests.

## DT-EVO-003 — Close evidence and performance uncertainty without bureaucracy
**Priority:** MEDIUM. **Why:** Prior reports distinguished implementation completion from real runtime performance and noted unretained historical evidence.

### Subtasks
**3.1 — Recheck historical evidence status.** Inspect current evidence dependencies and retained history. Identify which prior records are reproducible, which are historical only, and which verifiers already provide current proof.
- **Done when:** Every identified stale or unretained record is correctly classified, with no forged history, invented baseline, restored unauthorized refs, or arbitrary digest rebinding.

**3.2 — Replace only obsolete proof.** Reuse newly regenerated, retained-head evidence where it already satisfies a specific requirement. Where meaningful, generate other fresh evidence with the owning verifier using retained current inputs; otherwise retain a truthful `UNRETAINED`/historical designation. Do not rebuild unrelated completed evidence.
- **Done when:** Required present-day claims have current reproducible evidence. If a historical limitation is irreducible, document the attempted reproduction and classify the remaining risk explicitly; do not mislabel it as a passing result.

**3.3 — Measure matched before/after performance.** On equivalent safe autonomy workloads, measure execution latency, repeated-state writes, intervention count, and timeout/failure behavior. Reuse existing benchmark methodology where appropriate, but do not mistake a passing comparison in a different subsystem for this autonomy baseline. Separate synthetic from live observations and explicitly report regressions and their trade-offs.
- **Done when:** A repeatable apples-to-apples comparison exists with environment, samples, method, and measured outcomes; do not claim improvement without a real baseline.

**3.4 — Close or explicitly bound the mission.** Reconcile all subtasks, identify any remaining genuine operational blockers, and publish one compact status from authoritative evidence.
- **Done when:** Every acceptance statement has supporting measurement, unfinished work is explicitly identified, and there are no duplicated trackers or unnecessary report loops. A qualified/partial status is not full closure.

## Per-run output
Report: current DT SHA; subtasks verified and their evidence; subtasks changed and tests; remaining blockers; next runnable subtask. Do not write a new master prompt. Do not claim complete unless all subtask definitions of done hold.

## Latest worker reconciliation
- Inspected current DT `main` at `49d0c5fd8e66`. Recent commits include refreshed restart-focused evidence and an unrelated repository hygiene fix. Neither proves deployment of the remaining live runtime changes or closes the production repair integration.
- Fresh restart-focused evidence reports all declared checks passing **for that specific verifier**; it is not an observed complete live autonomous cycle or proof that every stateful recovery condition in 1.4 is covered.
- A refreshed comparison exists for a **different runtime subsystem** and explicitly records performance regressions. Do not use it as a substitute for the matched autonomy baseline required by 3.3.
- **Verified completed this iteration:** none. Preserve 11 open subtasks. Earlier verified diagnosis 2.1 remains archived.
- **Next executable sequence:** verify the loaded runtime and pending activation (1.1–1.2), observe a complete cycle (1.3), pursue the already-diagnosed authorized repair integration (2.2–2.4), and measure matched autonomy performance (3.3). Reuse existing proof; do not rebuild unrelated completed work.
