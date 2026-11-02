# Mission work order MEP-3.5.2-B

**Task:** DT-EVO-003 / 3.5.2 (Establish a no-loss shared-state write contract, conditional on existing authority.).
**Priority:** MEDIUM. **Class:** CONDITIONAL_PATCH_ON_REAL_AUTHORITY. **Current readiness:** NOT_AUTHORIZED_OR_PREREQUISITE_PENDING.
**Atomic outcome:** Implement conditional serialized writer/merge through existing owner.
**Dependencies:** `MEP-3.5.2-A`.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/collective_autonomic/; tools/doubletake_evolve/concurrency_locks/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-3-5-2-B.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** none confirmed for this unit.

## Acceptance contract
**OUTWARD (verified at diagnostic scope, not a completed subtask):** production reachability, canonical-owner mismatch and absence of a demonstrated serialization/merge guarantee are now established; do not rerun these unchanged probes or touch live retained state. **INWARD:** only where existing authority covers the change, use the existing owner to serialize or reject conflicting updates safely; do not introduce a parallel store, naive batching, or an unapproved append/retention policy. If a new owner decision or persistence-contract authorization is required, record `BLOCKED_OWNER_AUTHORITY` with the exact decision needed, and leave implementation untouched. **GROUND/Test/DoD:** Under both sequential long-lived/short-lived-owner operations and deterministic concurrent interleavings, two writers either preserve both acknowledged records or reject one *before* acknowledgement; verify restart, crash, digest, concurrency, rollback, unchanged unrelated work, bounded resource cost and repeatable fresh-process tests. A green characterization test that expects lost records is NOT acceptance. Separately establish actual production reachability before asserting a live fix. No closure from an isolated guard alone.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. If a reproducible deficiency is proven, publish one source-bound `.sh` with a real unified diff, exact preflight and guarded tests; do not generate a pseudo-implementation.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
