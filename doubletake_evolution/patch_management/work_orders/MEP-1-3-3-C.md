# Mission work order MEP-1.3.3-C

**Task:** DT-EVO-001 / 1.3.3 (Resolve or safely bound the remaining integrity refusal and prove natural liveness.).
**Priority:** CRITICAL. **Class:** CONDITIONAL_PATCH_ON_REAL_AUTHORITY. **Current readiness:** NOT_AUTHORIZED_OR_PREREQUISITE_PENDING.
**Atomic outcome:** After valid disposition, collect version-bound 60-minute multiple-natural-cycle Ground.
**Dependencies:** `MEP-1.3.3-B`.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/autonomous_loop/; tools/doubletake_evolve/runtime/; tools/doubletake_evolve/collective_autonomic/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-1-3-3-C.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** none confirmed for this unit.

## Acceptance contract
First verify whether a newer generation or already-authorized non-destructive path changes the result. Do not re-seal, quarantine, delete, ignore verification failures, or weaken integrity checks without the authority required by existing protections. If no permitted disposition exists, retain `BLOCKED_INTEGRITY_AUTHORIZATION` and the negative 60-minute result; do not spin on unchanged observations. After a valid disposition, observe a fresh **60-minute** naturally scheduled window with intended downstream phases and unaffected work. **Test/DoD:** Multiple fully completed natural cycles, no recurring starvation, version-scoped independent cycle evidence, safe error handling and no unauthorized state change. A 60-minute window with zero completions is an explicit failure, not an inconclusive pass.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. If a reproducible deficiency is proven, publish one source-bound `.sh` with a real unified diff, exact preflight and guarded tests; do not generate a pseudo-implementation.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
