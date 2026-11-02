# Mission work order MEP-7.8.3-B

**Task:** DT-EVO-007 / 7.8.3 (GROUND: independently verify the full downstream effect and return feedback to the Scouts.).
**Priority:** HIGH. **Class:** SOURCE_DIFF_IF_VERIFIED_GAP. **Current readiness:** AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION.
**Atomic outcome:** Independent unseen outcome, rejected-source negative and no-loss regression.
**Dependencies:** `MEP-7.8.3-A`.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/mission_intake/; tools/doubletake_evolve/collective_assimilation/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-7-8-3-B.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** none confirmed for this unit.

## Acceptance contract
After a genuinely authorized action, bind `IS-20261101-002` → inventory/proposal → Director decision → published mission SHA → actual DT consumer-read SHA → governed action/result → previously unseen independent evaluator → relevant downstream behavior/reuse. Compare against the frozen baseline; verify a negative rejected source cannot affect cognition/tool choice, no duplicate execution, no loss of accepted state and no unauthorized effect. **Test/DoD:** A separately checked real behavior improvement with exact revision/receipt lineage, compatible consumers, restart/rollback and measurable bounded resource use, plus durable public-safe Scout feedback; a synthetic-only pass remains `TESTED`, not `VERIFIED_END_TO_END`. If no independent host observer exists, preserve `EVIDENCE_UNAVAILABLE` and the unfinished step.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. If a reproducible deficiency is proven, publish one source-bound `.sh` with a real unified diff, exact preflight and guarded tests; do not generate a pseudo-implementation.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
