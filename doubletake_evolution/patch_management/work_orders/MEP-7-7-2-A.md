# Mission work order MEP-7.7.2-A

**Task:** DT-EVO-007 / 7.7.2 (INWARD: only if 7.7.1 proves a distinct, authority-safe gap, improve the existing owner in place.).
**Priority:** HIGH. **Class:** CONDITIONAL_PATCH_ON_REAL_AUTHORITY. **Current readiness:** NOT_AUTHORIZED_OR_PREREQUISITE_PENDING.
**Atomic outcome:** Only after confirmed gap, modify canonical verifier in-place.
**Dependencies:** `MEP-7.7.1-C`.
**Required decision / outside input:** 7.7.1 demonstrates a distinct actual gap with owner authority.
**Source search boundary:** `tools/doubletake_evolve/claim_receipt/; tools/doubletake_evolve/replay_evidence_closure/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-7-7-2-A.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** none confirmed for this unit.

## Acceptance contract
Reuse the current verification/knowledge/governance seams; no new Borg stack, parallel history owner, Temporal dependency or cryptographic exception. Require source/version/digest identity, fail-closed ambiguous provenance, stable negative evidence, explicit test-only execution isolation, compatibility with existing consumers, rollback and bounded costs. **Test/DoD:** The exact proven baseline deficiency is corrected on synthetic fixtures while 100% of intentionally tampered/unauthorized records remain rejected; no duplicate effects, no protected-state mutation, no new authority. If `ALREADY_PRESENT`, `NOT_APPLICABLE` or permission is missing, keep this conditional step open/blocked and do not write implementation.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. If a reproducible deficiency is proven, publish one source-bound `.sh` with a real unified diff, exact preflight and guarded tests; do not generate a pseudo-implementation.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
