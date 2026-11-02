# Mission work order MEP-6.5.2-B

**Task:** DT-EVO-006 / 6.5.2 (INWARD/GROUND, conditional on 6.5.1: test a reversible capacity extension.).
**Priority:** CRITICAL. **Class:** CONDITIONAL_PATCH_ON_REAL_AUTHORITY. **Current readiness:** NOT_AUTHORIZED_OR_PREREQUISITE_PENDING.
**Atomic outcome:** Implement isolated temporary-state capacity extension only after approval.
**Dependencies:** `MEP-6.5.2-A`.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/collective_autonomic/; tools/doubletake_evolve/runtime/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-6-5-2-B.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** none confirmed for this unit.

## Acceptance contract
Only if the existing owner and authority permit it, evolve the existing persistence contract in isolated temporary state; preserve immutable audit history, digest verification, durable counters, crash-safe atomicity, old-format reads and rollback to the prior reader. **Test/DoD:** More than the prior size ceiling of successive *accepted and reloadable* durable records in a representative bounded fixture; zero lost or rewritten historical records; restart, crash, concurrent-writer, tamper-negative, compatibility, replay and resource-budget tests; independent before/after comparison. Do not activate on the live host or modify retained history without separate existing authorization. If no permitted design exists, retain the measured capacity failure and move speculative options to R-008.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. If a reproducible deficiency is proven, publish one source-bound `.sh` with a real unified diff, exact preflight and guarded tests; do not generate a pseudo-implementation.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
