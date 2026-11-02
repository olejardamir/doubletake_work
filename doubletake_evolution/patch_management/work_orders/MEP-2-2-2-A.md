# Mission work order MEP-2.2.2-A

**Task:** DT-EVO-002 / 2.2.2 (Wire only the missing integration within granted scope.).
**Priority:** HIGH. **Class:** EVIDENCE_PATCH_OR_TEST. **Current readiness:** READY_FOR_SOURCE_GROUNDED_PROOF_OR_PATCH_DESIGN.
**Atomic outcome:** Map actual fault-to-repair caller against existing grants.
**Dependencies:** none; may be independently investigated.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/rollback_recovery/; tools/doubletake_evolve/production_readiness_boundary/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-2-2-2-A.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** `{"id":"BPE-20261101-015","file":"BPE-20261101-015.sh","kind":"DIAGNOSTIC","state":"DIAGNOSTIC_READY"}`.

## Acceptance contract
Reuse existing repair/scheduler/state components; preserve denial, rollback and no-effect behavior. If a required standing grant or owner-declared request is unavailable, record `BLOCKED_AUTHORIZATION`; never self-grant or bypass it. **Test/DoD:** Production-reachable invocation exists and rejects missing authority without side effects; absent authority keeps this step open.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. Produce a command-executable isolated negative/positive verification or an independently inspectable version-bound observation. Use actual receipt/result; no code diff if already correct.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
