# Mission work order MEP-7.7.1-B

**Task:** DT-EVO-007 / 7.7.1 (OUTWARD: test applicability and current parity before proposing code.).
**Priority:** HIGH. **Class:** EVIDENCE_PATCH_OR_TEST. **Current readiness:** AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION.
**Atomic outcome:** Compare actual record semantics against executable-history replay contract.
**Dependencies:** `MEP-7.7.1-A`.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/claim_receipt/; tools/doubletake_evolve/replay_evidence_closure/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-7-7-1-B.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** `{"id":"BPE-20261101-009","file":"BPE-20261101-009.sh","kind":"DIAGNOSTIC","state":"DIAGNOSTIC_READY"}`.

## Acceptance contract
DT's existing integrity/history and verification owners must trace the actual data contract, version interpretation, existing replay/migration/negative tests and whether any recorded *commands and effects* can be replayed deterministically. Pin current DT revision and source ID; use only synthetic immutable data in a temporary sandbox. Compare the existing verifier against a bounded matrix: compatible records, explicitly authorized version representations (only where an existing version contract permits them), tampered/forged records, incompatible interpreters and no-side-effect controls. A 10/10/10 fixture matrix plus up to five held-out controls is an upper bound, not a quota to manufacture irrelevant cases. **Test/DoD:** One reproducible baseline table identifies owner, relevant record type, current classifications, false accepts/rejects, side effects, resource cost, and a verdict `GAP_VERIFIED`, `ALREADY_PRESENT`, `NOT_APPLICABLE` or `AUTHORITY_BLOCKED` with a concrete falsifier. Verify zero live-state writes and zero external effects. If the records are merely integrity-bound placements rather than executable workflow histories, explicitly reject replay as a wrong abstraction; no new layer.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. Produce a command-executable isolated negative/positive verification or an independently inspectable version-bound observation. Use actual receipt/result; no code diff if already correct.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
