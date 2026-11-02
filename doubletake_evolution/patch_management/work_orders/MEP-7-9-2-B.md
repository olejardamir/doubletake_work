# Mission work order MEP-7.9.2-B

**Task:** DT-EVO-007 / 7.9.2 (OUTWARD→INWARD→GROUND: reject invalid proof chains.).
**Priority:** HIGH. **Class:** SOURCE_DIFF_PREPARED_BPE_010. **Current readiness:** PREPARED_UNTESTED_VALIDATE_SOURCE_AND_EXECUTE.
**Atomic outcome:** Prepare/apply current mainline BPE-010 only after compatibility check; BPE-002 superseded.
**Dependencies:** `MEP-7.9.2-A`.
**Required decision / outside input:** BPE-010 exact source-blob compatibility, clean overlap and approved local executor; BPE-002 remains retired.
**Source search boundary:** `tools/doubletake_evolve/claim_receipt/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-7-9-2-B.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** `{"id":"BPE-20261101-002","file":"BPE-20261101-002.sh","kind":"CODE_DIFF","state":"PREPARED_UNTESTED"}`; `{"id":"BPE-20261101-013","file":"BPE-20261101-013.sh","kind":"DIAGNOSTIC","state":"PREPARED_UNTESTED"}`; `{"id":"BPE-20261101-014","file":"BPE-20261101-014.sh","kind":"DIAGNOSTIC","state":"PREPARED_UNTESTED"}`.

## Acceptance contract
**Partially implemented on feature branch:** BPE-003–007 and BPE-011–014 provide evidence, claim and digest bindings and fail-closed aggregate/CLI handling. **Verified missing source invariant at inspected branch HEAD:** `verify_chain()` still accepts additional empty predecessor anchors and can accept a non-adjacent earlier predecessor (a skipped middle receipt). **BPE-002 and BPE-010 must not both execute:** 002 is a stale/overlapping combined proposal; the original 010 also contains a redundant `all_pass` hunk already implemented by 013. Rebase ONE precise strict-immediate-predecessor patch against current source, preserving existing changes and adding positive ordered-chain and negative two-anchor, unknown/distant-predecessor, forged/mismatched identity and skipped-link controls. Run host-guarded and independent unseen checks; record actual source, commit, test evidence and rollback. **DoD:** every receipt links to its immediately prior ordered receipt (except the single initial empty anchor); all matching individual claims with invalid chain cannot produce aggregate success; valid chains remain accepted. Until this is observed, keep 7.9.2 OPEN.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. If a reproducible deficiency is proven, publish one source-bound `.sh` with a real unified diff, exact preflight and guarded tests; do not generate a pseudo-implementation.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.

## 2026-11-02 source reconciliation

Use BPE-010 rev5 only for strict immediate predecessor; do not resurrect BPE-002 or repeat already integrated BPE-013 aggregate chain gating. BPE-026 separately rejects extra uncommitted receipts. Both scripts target DT main `17c70b0e2b7fec53e46bdeaa35e9e25d76034bd2`, `receipts.py` blob `bc39080efa674bb41f1b8f738130ee90ada9db6a`, with nonoverlapping hunks and mandatory local apply-check. No local tests or commits evidenced; remain PREPARED_UNTESTED.

**Additional independent patch:** BPE-027 (models.py unique sealed IDs) may be applied separately from BPE-010/026 (receipts.py) only after exact local apply-check and guarded tests. All remain PREPARED_UNTESTED; no new owner authority granted.
