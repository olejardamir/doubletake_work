# Mission work order MEP-7.3.1-C

**Task:** DT-EVO-007 / 7.3.1 (Ground the full evidence-to-validated-knowledge path, not merely queue reachability.).
**Priority:** HIGH. **Class:** EVIDENCE_PATCH_OR_TEST. **Current readiness:** AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION.
**Atomic outcome:** Prove negative/replay/rollback, independent consumer behavior and cost.
**Dependencies:** `MEP-7.3.1-B`.
**Required decision / outside input:** None pre-granted by this work order; independently verify existing runtime and code authority before any mutation.
**Source search boundary:** `tools/doubletake_evolve/collective_assimilation/; tools/doubletake_evolve/governed_knowledge/`. These are search locations, not a claim about exact patch hunks. Pin actual files/blobs on current DT `main` before generating any implementation patch.
**Current unit gate:** `doubletake_evolution/patch_management/atomic_patches/MEP-7-3-1-C.sh`; the existing gate script is **not a code patch**.
**Related prepared/executed patch references:** `{"id":"BPE-20261101-022","file":"BPE-20261101-022.sh","kind":"DIAGNOSTIC","state":"DIAGNOSTIC_READY"}`.

## Acceptance contract
**VERIFY_FIRST:** The source/test chain already establishes demand-backed evidence → read-only discovery → governed decision → authenticated one-item queue → evaluated, durable and replayable rejected outcome. A matched control confirms the bridge causes the queue delta; rejection is truthful, **not** successful assimilation. Once 7.5 establishes a legitimate policy-compliant source-backed path, verify human-readable provenance → owner classification → independent knowledge validation → durable result and interface consumers. Existing rollback tests show that an immutable historical handoff receipt remains after queue withdrawal; do not mistake that receipt for current queue membership or alter its exactly-once semantics without a consumer-contract analysis. Compare baseline and changed outcomes; cover negative/stale/absent-session cases, unrelated queue preservation, replay, bounded cost and rollback. **Test/DoD:** Independently reproducible authorized positive path through knowledge and validation when evidence genuinely qualifies; truthful rejected/deferred paths without side effects; no fabricated capability authority; compatible consumers, regressions and bounded resources. If policy correctly rejects all available evidence, preserve the negative result and keep full Ground OPEN. No live natural autonomy claim from isolated tests.

## Patch-engineer execution steps
1. Compare current DT `main` HEAD and `COMPLETED.md` against this exact atomic outcome. Do not redo archived checks or reapply integrated patches. Pin the exact current source/test blob SHA and meaningful baseline control.
2. Produce a command-executable isolated negative/positive verification or an independently inspectable version-bound observation. Use actual receipt/result; no code diff if already correct.
3. For code changes, create *one* self-contained source-diff `BPE-<stable-id>.sh` inside `doubletake_evolution/patches/`, touching only the smallest canonical owner; include positive, forged/denied/stale or otherwise meaningful negative control, regression tests, no-loss/replay where relevant, and `git apply --check`. Guard focused execution with `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q <exact focused tests found by source inspection>` after replacing its placeholder with real existing test paths.
4. If authorization or natural host observation is absent, preserve `BLOCKED` / `EVIDENCE_UNAVAILABLE` with the missing decision and recheck trigger; do not write a fake diff, manipulate retained data, or claim completion from this work order.
5. Acceptance receipt must record checked DT revision and tested files, exact positive/negative assertions, invocation and PASS/FAIL/NOT_RUN, source changes or absence thereof, independent Ground versus fixture-only, rollback, affected and unaffected work, safety authority and next blocker. **Status VERIFIED only for this unit with that evidence.**

**Definition of Done for this work order:** the atomic outcome above is proved against the parent's full acceptance contract, or explicitly remains OPEN with a concrete external prerequisite. A created script or green component test alone is not mission closure.
