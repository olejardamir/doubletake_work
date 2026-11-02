# Mission work order MEP-7.5.2-A

**Task:** DT-EVO-007 / 7.5.2 (INWARD, conditional on 7.5.1: reuse the canonical knowledge intake.).
**Priority:** HIGH. **Class:** EVIDENCE_PATCH_OR_TEST. **Current readiness:** NOT_AUTHORIZED_OR_PREREQUISITE_PENDING.
**Atomic outcome:** Verify source authenticity/relevance and actual missing capability.
**Dependencies:** none; may be independently investigated.
**Required decision / outside input:** A new independently source-backed candidate and current capability absence; NO_QUALIFIED_SOURCE is the present finding.
**Source search boundary:** `tools/doubletake_evolve/collective_assimilation/; tools/doubletake_evolve/governed_knowledge/; tools/doubletake_evolve/frontier_discovery/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-7-5-2-A.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** `{"id":"BPE-20261101-023","file":"BPE-20261101-023.sh","kind":"DIAGNOSTIC","state":"DIAGNOSTIC_READY"}`.

## Acceptance contract
If a genuinely sourced artifact qualifies, connect only the missing in-place seam between existing discovery, knowledge storage and the authorized assimilation owner. Preserve source citations, negative evidence, authenticated identity, immutable receipt plus a separate truthful current-state lookup where already supported, and replay/rollback behavior; do not create a parallel Borg stack or loosen the owner gate. **Test/DoD:** A single valid artifact reaches independent knowledge validation with durable, replayable outcome; forged, stale, insufficient, absent-session and duplicate inputs fail closed without extra queue items; existing clients and unrelated work remain correct; measured bounded resources and a reversible rollback. If the existing seam already works, record `VERIFY_FIRST` evidence and do not change code. If not authorized, stop at a truthful blocked finding.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. Produce a command-executable isolated negative/positive verification or an independently inspectable version-bound observation. Use actual receipt/result; no code diff if already correct.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
