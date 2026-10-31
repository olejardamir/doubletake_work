# DOUBLETAKE — AUTONOMY-FIRST BUREAUCRACY REDUCTION: REMAINING WORK v2

> **EXECUTION CONTINUATION — DELTA ONLY.** Resume the existing `DOUBLETAKE_AUTONOMY_BUREAUCRACY_REDUCTION_MASTER_v1` mission. Do not restart it, create new global managers, or regenerate already verified reports. Execute bounded outstanding work, prove actual operation, and stop with an accurate terminal state when the host or authority boundary prevents further action.

## 0. Source of truth and starting baseline

Repository: `olejardamir/DT`, `main`. Latest remote commit observed during offload: `be5961462da39e4b22d1cc4fd245b1d1fb01477a` (2026-10-29 18:45:19 UTC). **This is a historical observation, not a pinned execution HEAD.** At startup inspect actual `git status`, current local and remote HEAD, processes, deployments, work owners, repository policy, and newly landed changes. Skip any item already demonstrably done at current source.

Read before modifying anything:

- `AGENTS.md` (main-only/no-tags policy, shared-worker safety, mandatory host workload guard, applicable service controls).
- `reports/autonomy_bureaucracy/README.md` and `reports/autonomy_bureaucracy/audit_inventory.json`.
- `reports/autonomous_mission_manager/FINAL_CLOSURE.json` and its independent verifier, plus relevant focused tests.
- The existing live operating-loop owner, `operating_loop/adapt.py`, the Borg autonomic tick caller, runtime activation/release ownership, and `runtime_activation/autonomous_repair.py` (find their actual paths in the current checkout).
- Existing governed-ingestion evidence and closure status only if a changed dependency requires their verification.

**Last observed measured results (reuse, do not reimplement):** AMM closure `MANAGER_IMPLEMENTATION_COMPLETE` with 57/57 criteria; declared suite 763/763 passing; mission-manager decision benchmark `SUPERIOR` by 3.15 against declared baselines; synthetic end-to-end mission tests pass for read/report, delegated code promotion plus rollback, and local governed ingestion. Standing-grant authorization, scoped delegated promotion, bounded repair, anti-stall queue/checkpoint behavior and simplified status reporting are implemented and tested. These are committed report claims, not a fresh live verification of this checkout.

**Last observed residuals:** (2) `runtime_activation/autonomous_repair.py` had fault-injection coverage but no verified live caller; (3) three historical generated renders relied on source heads no longer retained under main-only policy, and the governed-ingestion matrix verifier reported an unretained source head; (4) actual before/after end-to-end latency improvement was not measured on matched fixtures; (5) declared path/resource budgets are not full filesystem sandboxing or actual provider-spend metering. T1 live-loop verification is now complete (bounded repair, paused-skip, real tick, no orphaned effects). **None may be silently treated as passed.**

## 1. Operating rules (all tasks)

1. Preserve L0 independence, current enforceable policies, permission scope, audit integrity, secret protection, safe rollback and bounded host resource controls. **Remove procedural duplication, not security invariants.**
2. No new kernel, manager, global dispatcher, approval authority, event store, cron service, or documentation campaign. Reuse the existing owner. Do not add human approval for operations already covered by a genuine existing delegated grant; do not fabricate grants or expand privilege.
3. Use `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` for experiment/test/build/proof runs. Respect one guarded experiment at a time and current `AGENTS.md` limits. Do not restart or kill the running service hosting the agent's own session without a safe externally controlled handoff. Do not bypass service ownership with another unguarded process.
4. One writer per affected file, no tag/branch creation, no forced ref restoration, no history rewrite, no deleting peer work. Keep unretained evidence truthful.
5. Reverify only the changed dependency cone. An unaffected passing test/evidence result may be reused with a checked source binding. No bulk evidence rebinding, checkpoint cascades, or repeated report-only commits.
6. On two identical no-progress attempts, stop retries, identify the exact root cause, and park only the affected work. Continue independent permitted work. Do not claim that retry exhaustion equals successful repair.
7. Every claimed completion must name live caller/command, observable effect, collected assertions, before/after relevant state, source digest, and durable result. Tests alone do not equal live activation.

## 2. T1 — Prove the currently deployed autonomic loop uses the new bounded repair code

**Background:** `reports/autonomy_bureaucracy/README.md` records bounded repair-grouping and the paused-loop skip fix; the running UI/API process was restarted (via `POST /api/system/restart-backend?when=settled`) and now loads the current version with the bounded repair code. The restarted process (PID 1128690, started 19:03:17) loads the current version (`83b06b969`) with bounded repair parameters (`_REPAIR_MAX_ATTEMPTS=25`, `_REPAIR_WALL_BUDGET_S=30s`, `_REPAIR_PARK_AFTER=2`). The live autonomic loop accumulated 45 failed cycles with repair/synchronization timeouts and an orphaned in-flight thread earlier. Snapshot tests showed at most 25 replacement attempts per pass, class-level parking after repeated failure and restart persistence; those do not establish running-service correctness without the code fix. Following restart, paused-skip behavior was confirmed (loop returns `skipped="operating_loop_not_running"` not `TICK_PHASE_FAILED`), one bounded repair tick was observed (at most 25 attempts, 30s wall budget, parking after 2 no-progress attempts), and `outstanding_effects.count: 0`, `consecutive_tick_failures: 0` confirm no orphaned effects persist.

**Execute:**

1. Inspect the actual service owner, module loaded by running process, persistent loop state, orphaned thread/work state, and safe stop/restart mechanism. Capture a read-only pre-activation snapshot of live state and current active source version.
2. If the existing hot-activation mechanism can safely and verifiably load the current version without restarting the hosting session, use it and prove the loaded module/version. Otherwise produce a precise **operator-executable** restart/resume handoff and do **not** pretend to have restarted it. Reuse the documented `./run-ui.sh` and `borg_loop_resume` controls only after checking that they are still the correct current interfaces.
3. Following a verified restart/activation, check that a persisted `paused` state results in a **skip**, not `TICK_PHASE_FAILED`; check that resume is intentional, not implicit. Do not erase the 45 historical failed cycles.
4. Observe at least one real bounded repair tick under real service control. Verify actual attempts <= configured 25, bounded elapsed time, deferred count, parking after non-progress, absence of runaway post-deadline work, and continued independent task progress. Avoid inducing damage to real work: use approved synthetic/drill context where required.
5. If orphaned work remains, stop it only through the owning cancellation mechanism and demonstrate it stops producing effects; otherwise state the exact blocker.

**DoD:** live loaded-version proof, restart/resume/paused behavior, real tick telemetry, no orphaned effects after cancellation, bounded behavior and persistence across restart. If control of the hosting service is unavailable: `BLOCKED_LIVE_ACTIVATION` with exact safe commands and observations, **not** `DONE`.

## 3. T2 — Wire the already implemented autonomous repair cycle into one real existing caller

**Background:** The existing `runtime_activation/autonomous_repair.py` cycle has fault-injection evidence but no verified live runtime caller.

**Execute:**

1. Trace the current live failure-report -> repair decision -> owner execution -> adjudication -> activation/rollback path. Determine whether an existing scheduler/loop/manager callback already owns this seam. Reuse it; do not create an extra daemon/loop/queue.
2. Wire the narrowest authorized call to the existing repair function **only when** source, damage class, budget, scope and allowed mutation paths are valid; protect against duplicate execution, reentrancy, stopped/paused loop, expired grant, unauthorized paths, exhausted budgets and concurrent activations.
3. Preserve W19 adjudication and W21 budget/quarantine semantics. Never use worker self-reported success as evidence; refuse retries after host guard refusal. Roll back only through existing release ownership, then re-check the active pointer.
4. Test normal repair, no-change, repeated identical failure, exhaustion/parking, unauthorized mutation, protected path, service pause, crash/restart and rollback-failure `BLOCKED_UNSAFE` behavior.
5. Demonstrate at least one authorized end-to-end synthetic failure entering through the *real caller* and producing a measured repair or safe park. Prove unrelated work proceeds.

**DoD:** one production-owned caller, actual runtime dispatch trace, existing single durable state, runnable negative/positive integration tests, no duplicate scheduling authority, no unnecessary human interruption within granted scope, verifiable rollback or safe parking. If no authorized execution seam exists, specify only that seam as a bounded blocker.

## 4. T3 — Resolve provenance/retention residuals without falsifying evidence

**Background:** Three prior-mission renders and the governed-ingestion closure matrix reference unretained historical HEADs after legitimate repository squashes. `AGENTS.md` forbids restoring branches/tags merely to make a verifier green.

**Execute:**

1. Inventory the exact four affected artifacts, their generating owners, referenced commit hashes, input digests, semantics and current verification failures. Do not treat the list as exhaustive until current source confirms it.
2. Classify each as historical provenance only, reproducible from current retained source, or genuinely unverifiable. A legitimate new current-source assessment may be generated **only** by the original owner with contemporary fresh inputs and a correctly versioned new record; it must not overwrite, backdate or relabel historical evidence.
3. If the artifact is merely a derived human-readable render, annotate it `UNRETAINED` and ensure current active verifiers/consumers do not rely on it as proof. If a mission requires acceptance and the original evidence cannot be independently reconstructed, leave its acceptance `BLOCKED_EVIDENCE` instead of silently accepting it.
4. Measure whether history retention is a recurring technical failure due to unneeded whole-HEAD binding. Repair the narrow ownership/provenance contract only if semantically sound and permitted, never by stripping necessary integrity checks or recreating forbidden refs.

**DoD:** exact per-artifact verdict, no misleading green state, clean consumer behavior, no refs recreated, no broad regeneration, and any current replacement genuinely independently reproducible. `UNRETAINED` can be the correct terminal historical disposition; do not demand a fake repair.

## 5. T4 — Measure actual overhead reduction and final unattended behavior

**Background:** Existing tests show local end-to-end paths and AMM decision-quality improvement but do not establish a matched before/after latency or actual ongoing autonomous operation.

**Execute:**

1. Use matched synthetic fixtures and identical host guard settings for baseline and new runtime where a valid retained baseline can be executed. Measure end-to-end execution latency, approval interruptions, queue writes, state mutations, redundant evidence runs, promotion time, repair attempts, failed/unbounded loops and memory/CPU if instrumented.
2. If the baseline cannot be reproduced, report current-path metrics and explicitly mark comparative benefit `UNMEASURED`. Do not invent a before/after reduction.
3. Run three genuinely owned paths: (A) permitted read/report without approvals, plus unauthorized write refusal; (B) authorized code edit/promotion with failure rollback; (C) synthetic governed ingestion from real API/runner through authorized landing and filtered status. Preserve their existing negative cases.
4. Exercise an unattended restart/resume and at least one blocked-task continuation, showing no infinite approval/checkpoint/rebinding loop and no repeated side effects.
5. Re-run targeted L0, governance/standing-grant, promotion, repair, Borg loop, queue/restart and ingress tests under host guard for changed surfaces; retain previous passing suites if not affected and source bindings remain valid.
6. Produce a compact independent final assessment of functionality, security, runtime activation, provenance, autonomy and measured overhead. Keep a single authoritative report; do not start another global certification cascade.

**DoD:** all current runnable positive/negative paths pass, actual live operating boundary tested or explicitly blocked, no new unauthorized side effects, meaningful telemetry, honest baseline caveats, and independent runtime evidence. Do not count 57/57 AMM criteria as proof of these residuals unless those specific predicates are exercised.

## 6. T5 — Final closure, only after evidence

Update the existing `reports/autonomy_bureaucracy/README.md` / `audit_inventory.json` or their current canonical successor **once** with:

- exact source HEAD, runtime loaded version, affected files, ownership and authorization scope;
- task statuses `VERIFIED_DONE`, `REUSED_VERIFIED`, `BLOCKED_LIVE_ACTIVATION`, `BLOCKED_AUTHORIZATION`, `UNRETAINED`, or `FAILED`;
- real commands, assertions/test counts, outcomes and digests;
- live loop and repair-caller status; retention status and limits;
- matched baseline/overhead verdict with explicit `UNMEASURED` when relevant;
- absence or presence of human interruptions, repeated mutations and safety regressions;
- one exact next action only if not complete.

A valid final result may be `ENGINEERING_COMPLETE_WITH_LIVE_ACTIVATION_PENDING` or `COMPLETE_WITH_HISTORICAL_UNRETAINED_EVIDENCE`; these are truthful terminal summaries, not covert passes. Do not certify production deployment or arbitrary unrestricted privileges. Never delay closure indefinitely for irrecoverable historical records when they are correctly classified as unretained.

## 7. Mandatory response format

```text
MISSION: DT_AUTONOMY_FIRST_BUREAUCRACY_REDUCTION
SOURCE_HEAD_BEFORE / AFTER:
DEPLOYED_RUNTIME_VERSION:
T1_LIVE_LOOP: VERIFIED_DONE
T2_REPAIR_CALLER: BLOCKED_AUTHORIZATION
T3_PROVENANCE: UNRETAINED
T4_AUTONOMY_BENCHMARK: UNMEASURED
T5_FINAL_CLOSURE: QUALIFIED_COMPLETE
CHANGED_FILES:
ACTUAL_COMMANDS_AND_TEST_COUNTS:
OBSERVED_RUNTIME_EFFECTS:
SAVED_ARTIFACTS_AND_DIGESTS:
SECURITY_AND_L0_REGRESSIONS:
AUTHORIZED_SCOPE:
HUMAN_INTERRUPTIONS:
REMAINING_UNPROVEN: T2 authorized execution seam (CODE_MUTATION grant + W19 RepairRequest owner declaration, outside agent API scope); T4 matched baseline/after latency measurement on identical fixtures; T5 final closure pending inventory update.
NEXT_EXACT_ACTION: NONE
```

**Start now.** Inspect the actual HEAD, skip anything newer commits have already demonstrated, then execute the first independently runnable residual. Do not replace implementation with a plan, regenerate passing whole-mission evidence, invent authorization, or relabel blocked live work as completed.
