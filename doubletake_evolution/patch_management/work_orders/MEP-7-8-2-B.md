# Mission work order MEP-7.8.2-B

**Task:** DT-EVO-007 / 7.8.2 (INWARD, only if 7.8.1 proves an actionable owner gap:).
**Priority:** HIGH. **Class:** EVIDENCE_PATCH_OR_TEST. **Current readiness:** AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION.
**Atomic outcome:** Run A/B/stale/forged/replay/delayed/rollback contract tests.
**Dependencies:** `MEP-7.8.2-A`.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/mission_intake/; tools/doubletake_evolve/mission_management/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-7-8-2-B.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** none confirmed for this unit.

## Acceptance contract
Reuse the canonical mission reader/receipt and result-verification seams *in place*, with existing identity, permissions and storage. Bind actual consumed blob digest to action ID, permitted start/stop/refusal and output evidence; do not add cryptographic keys, a controller, new network channel or bypass. Work in isolated fixtures if actual host access is unavailable. **Test/DoD:** Same A/B/stale/forged/denied/same-revision-replay/delayed-evidence matrix now classifies every actual consumption correctly, fails closed on forged or mismatched evidence, retains original work and history across restart/rollback, has bounded cost, and does not grant execution authority. If already present or not authorized, mark `ALREADY_PRESENT` / `AUTHORITY_BLOCKED`, do not implement and leave conditional Ground unclaimed.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. Produce a command-executable isolated negative/positive verification or an independently inspectable version-bound observation. Use actual receipt/result; no code diff if already correct.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
