# Mission work order MEP-3.4.2-A

**Task:** DT-EVO-003 / 3.4.2 (Publish one concise final status.).
**Priority:** MEDIUM. **Class:** SOURCE_DIFF_PREPARED_BPE_025_PARTIAL. **Current readiness:** PREPARED_UNTESTED_VALIDATE_SOURCE_AND_EXECUTE.
**Atomic outcome:** Reconcile one status owner with verified and pending scope.
**Dependencies:** none; may be independently investigated.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/evolution_acceptance/; tools/doubletake_evolve/runtime/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-3-4-2-A.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** `{"id":"BPE-20261101-019","file":"BPE-20261101-019.sh","kind":"DIAGNOSTIC","state":"DIAGNOSTIC_READY"}`; `{"id":"BPE-20261101-025","file":"BPE-20261101-025.sh","kind":"CODE_DIFF","state":"PREPARED_UNTESTED"}`.

## Acceptance contract
Reuse the existing status/evidence owner; do not create duplicate trackers or claim full closure for qualified results. **Test/DoD:** One consistent status identifies passes, open defects, authorization blockers and evidence gaps without claiming unverified closure.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. If a reproducible deficiency is proven, publish one source-bound `.sh` with a real unified diff, exact preflight and guarded tests; do not generate a pseudo-implementation.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.

## 2026-11-02 source/evidence reconciliation (overrides stale earlier readiness)

DT main `db86a85f2ca204117bcd36e8e51a9d1df05d9bbf`: BPE-025 integrated on DT main; final mission status and live closure evidence still unverified. Prior implemented executables retired; exact commits and executor-reported tests in PATCH_INDEX/results. No independent GPT test rerun. This work order remains open until distinct acceptance evidence exists; do not reapply retired patches.
