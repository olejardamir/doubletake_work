# Mission work order MEP-7.9.1-C

**Task:** DT-EVO-007 / 7.9.1 (OUTWARD→INWARD→GROUND: contain reserved mission proof artifacts.).
**Priority:** HIGH. **Class:** EVIDENCE_PATCH_OR_TEST. **Current readiness:** AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION.
**Atomic outcome:** Test reserved/intermediate symlink and validation→write swap negative fixtures in an isolated workspace with outside sentinel. Static path validation in private BPE-001 does not prove race-safe use-time containment; preserve the independent Ground requirement.
**Dependencies:** `MEP-7.9.1-B`.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/mission_intake/; tools/doubletake_evolve/claim_receipt/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-7-9-1-C.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** `{"id":"BPE-20261101-001","file":"BPE-20261101-001.sh","kind":"CODE_DIFF","state":"PREPARED_UNTESTED"}`.

## Acceptance contract
**Implementation present on feature branch:** BPE-001 covers refusal of reserved `plan.json`/`evidence.json` aliases, duplicated normalized output paths and symlink redirects before writing, with normal contained output preserved; 41 focused tests were **reported** passing. **Still open:** independently verify intermediate-component redirects and deterministic validation→write path swaps against a disposable outside sentinel, with use-time safety, unchanged sentinel, no unrelated effects, source-revision evidence and rollback. A static realpath check or a test count alone does not prove these race controls. **DoD:** source-bound positive and negative fixtures plus at least one independently checked unseen case demonstrate no outside write and truthful canonical proof. Reuse integrated code; do not reapply BPE-001.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. Produce a command-executable isolated negative/positive verification or an independently inspectable version-bound observation. Use actual receipt/result; no code diff if already correct.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
