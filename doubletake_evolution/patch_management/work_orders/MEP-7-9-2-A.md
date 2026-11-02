# Mission work order MEP-7.9.2-A

**Task:** DT-EVO-007 / 7.9.2 (OUTWARD→INWARD→GROUND: reject invalid proof chains.).
**Priority:** HIGH. **Class:** SOURCE_DIFF_IF_VERIFIED_GAP. **Current readiness:** READY_FOR_SOURCE_GROUNDED_PROOF_OR_PATCH_DESIGN.
**Atomic outcome:** Confirm canonical receipt-chain contract and private patch compatibility.
**Dependencies:** none; may be independently investigated.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/claim_receipt/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-7-9-2-A.sh`; the existing gate script is **not a code patch**.
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

DT main `17c70b0e2b7fec53e46bdeaa35e9e25d76034bd2` and actual `receipts.py` blob `bc39080efa674bb41f1b8f738130ee90ada9db6a` inspected. Current code still permits a non-adjacent predecessor and also permits extra, correctly chained receipts outside the committed proof universe to coexist with aggregate success. BPE-010 rev5 and BPE-026 rev1 are independent source-grounded implementation candidates. Both have exact unique committed hunk contexts, but no local application/tests/host Ground; original BPE-002 is superseded and must not be selected. Source-owner proof and runtime scope remain separate from this work order.

**2026-11-02 additional inspected gap:** sealed ClaimReceiptSpec does not reject duplicate claim IDs or duplicate committed IDs; downstream coverage collapses IDs to sets. BPE-027 is a distinct source-bound uniqueness patch, not an alternative to BPE-010/026; no local tests or integration yet.
