# Mission work order MEP-7.7.3-B

**Task:** DT-EVO-007 / 7.7.3 (GROUND: independent behavior, propagation and receipt, not a green component test.).
**Priority:** HIGH. **Class:** EVIDENCE_PATCH_OR_TEST. **Current readiness:** AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION.
**Atomic outcome:** Independently validate downstream behavior against held-out test and rollback.
**Dependencies:** `MEP-7.7.3-A`.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/claim_receipt/; tools/doubletake_evolve/mission_management/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-7-7-3-B.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** none confirmed for this unit.

## Acceptance contract
Bind `IS-20261101-001` → Scout inventory/proposal → Director decision → actual DT mission revision consumed by its executor → any governed source intake → implementation/test result → a previously unseen negative/positive challenge → relevant downstream consumer/reuse. Measure baseline versus changed classification, replay safety, no-loss/restart/rollback and comparable cost; include a rejected-source negative control. **Test/DoD:** Independently repeatable, provenance-bound, genuinely useful cross-component behavior change with zero unauthorized accepts/writes/effects, truthful durable status and a verifiable mission-execution receipt. If no implementation was justified, close only the bounded OUTWARD diagnostic after independent verification, not full assimilation. A source citation, test-only candidate, Director commit or status report alone cannot close this Ground criterion.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. Produce a command-executable isolated negative/positive verification or an independently inspectable version-bound observation. Use actual receipt/result; no code diff if already correct.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
