# Mission step → patch coverage

Mission: [ACTIVE_MISSION.md](../ACTIVE_MISSION.md); snapshot blob `32d5e090376cd4560ba4cd91bf4376e1a9aea13c`. This is an INITIAL triage inventory, not proof of implementation or authority. Borg Patch Engineer must refresh against current mission and DT executor branch EVERY run, inspect all unnumbered acceptance criteria, split every eligible step into source-grounded single-file patches, and record reasons for blocked/non-code work. Only `.sh` patch files go in `../patches/`.

| Task | Open step | Exact intended outcome | Initial status | Associated patch ID(s) |
|---|---|---|---|---|
| DT-EVO-001 | 1.3.3 | Resolve or safely bound the remaining integrity refusal and prove natural liveness | BLOCKED_AUTHORITY | — |
| DT-EVO-002 | 2.2.2 | Wire only the missing integration within granted scope | BLOCKED_AUTHORITY | — |
| DT-EVO-002 | 2.2.3 | Run focused integration tests | DEPENDENCY_PENDING | — |
| DT-EVO-002 | 2.4.2 | Exercise the production caller | DEPENDENCY_PENDING | — |
| DT-EVO-002 | 2.4.3 | Reconcile state | DEPENDENCY_PENDING | — |
| DT-EVO-003 | 3.3.4 | Verify post-recovery performance only after actual natural recovery | DEPENDENCY_PENDING | — |
| DT-EVO-003 | 3.4.2 | Publish one concise final status | VERIFICATION_ONLY | — |
| DT-EVO-003 | 3.5.2 | Establish a no-loss shared-state write contract, conditional on existing authority | BLOCKED_AUTHORITY | — |
| DT-EVO-004 | 4.2.2.2 | Verify an authorized production-served health indication | BLOCKED_DEPLOYMENT_AUTHORITY | — |
| DT-EVO-004 | 4.2.2.3 | Verify recovery clearing and stable health classification | DEPENDENCY_PENDING | — |
| DT-EVO-006 | 6.5.2 | INWARD/GROUND, conditional on 6.5.1: test a reversible capacity extension | BLOCKED_AUTHORITY | — |
| DT-EVO-007 | 7.3.1 | Ground the full evidence-to-validated-knowledge path, not merely queue reachability | DEPENDENCY_PENDING_NO_QUALIFIED_SOURCE | — |
| DT-EVO-007 | 7.5.2 | INWARD, conditional on 7.5.1: reuse the canonical knowledge intake | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.6.2 | INWARD/GROUND: measure independent transfer without selecting a favorable retry result | QUIESCENT_AWAITING_NATURAL_CASE | — |
| DT-EVO-007 | 7.7.1 | OUTWARD: test applicability and current parity before proposing code | DIAGNOSTIC_READY (not implementation) | BPE-20261101-009 |
| DT-EVO-007 | 7.7.2 | INWARD: only if 7.7.1 proves a distinct, authority-safe gap, improve the existing owner in place | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.7.3 | GROUND: independent behavior, propagation and receipt, not a green component test | DEPENDENCY_PENDING_7.7.1 | — |
| DT-EVO-007 | 7.8.1 | OUTWARD: map the actual existing consumer and test revision-bound acknowledgement | DIAGNOSTIC_READY (not implementation) | BPE-20261101-008 |
| DT-EVO-007 | 7.8.2 | INWARD, only if 7.8.1 proves an actionable owner gap | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.8.3 | GROUND: independently verify the full downstream effect and return feedback to the Scouts | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.9.1 | OUTWARD→INWARD→GROUND: contain reserved mission proof artifacts | PRIVATE_PREPARED_UNTESTED; PUBLICATION_TOOL_BLOCKED; RACE_GROUND_OPEN | BPE-20261101-001 (private rev2; source/test blobs match executor branch; 6/6 source hunks match; no public .sh published) |
| DT-EVO-007 | 7.9.2 | OUTWARD→INWARD→GROUND: prevent invalid proof chains from producing a successful verdict | IMPLEMENTATION_PARTIAL_FEATURE_BRANCH | BPE-20261101-002 (private); BPE-20261101-003–004 applied on feature branch; BPE-20261101-005–007 also integrated on the feature branch (source/test commits independently inspected; guarded test counts reported, logs not independently rerun) |

**Snapshot coverage:** 22 numbered open steps across 6 task areas. `SOURCE_REVIEW_REQUIRED` means no valid patch or blocker has yet been established. A mapped patch is NOT a completed mission step. Conditional or owner-authority-blocked steps must not be implemented without legitimate authorization. A verification-only step needs real test/observation evidence, not a fabricated source diff.

**Each run:** reconcile mission/COMPLETED against this map; list every unrepresented new step; classify; add patch IDs and actual source refs/test proof; prioritize repair of existing stale patches; publish as many independent complete new patches as warranted; report uncovered, blocked and verified counts. Preserve stable patch identity and keep PATCH_INDEX.json as authoritative executable queue.


## 2026-11-01 patch publication and execution reconciliation

The owner has clarified in ACTIVE_MISSION.md that ordinary DT source-code patch diffs belong in public `doubletake_evolution/patches/` and are not blocked merely because the implementation repository is private. Do not publish credentials, protected runtime data, or confidential third-party content; maintain all authority and live-state integrity boundaries. The independent hourly Patch Engineer must stay enabled.

**Confirmed feature-branch progress:** BPE-20261101-003 has committed DT implementation evidence; BPE-20261101-004 also has a matching DT commit `6260daa5bfe56f0c73874d0f92ee624864b028c4` and a locally recorded 23-test pass. Test logs remain unverified by GPT. BPE-20261101-005–007 are already integrated in the current feature branch; they must not be replayed. Public sanitized results 004–007 reconcile their commit evidence and separately reported tests. The 22 open mission steps and 58 planning units still require actual source-grounded executable patch work, and authorization/runtime observation blocked units cannot be represented as completed code changes.

## Atomic mission decomposition — implementation candidates and proof slices

**Important:** The unit IDs below are planning units, NOT executable patch IDs. Only listed `BPE-*.sh` files in `../patches/` are executable. A planned unit becomes a real code-bearing patch only after source inspection, adequate authority, source-content safety screening and an exact source-bound diff. Read-only diagnostics 008/009 are NOT code modifications. Ordinary DT code-bearing patches are authorized for the dedicated public patches directory, excluding credentials, protected runtime data and confidential third-party material.

### 1.3.3
- **1.3.3-A** — Verify exact owner decision and permitted disposition (blocked). **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **1.3.3-B** — If authorized, isolate and preserve original retained-history evidence (blocked). **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **1.3.3-C** — After valid disposition, collect version-bound 60-minute multiple-natural-cycle Ground. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.

### 2.2.2
- **2.2.2-A** — Map actual fault-to-repair caller against existing grants. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **2.2.2-B** — Only with standing authority, implement minimal canonical caller wiring. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **2.2.2-C** — Negative test: denied caller creates no effects. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 2.2.3
- **2.2.3-A** — Authorized invocation and expected verified repair regression. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **2.2.3-B** — Absent/invalid grant and incomplete evidence negative suite. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **2.2.3-C** — Denied mutation, rollback and unrelated-work continuation suite. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 2.4.2
- **2.4.2-A** — Reproduce existing isolated fault under permitted caller. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **2.4.2-B** — Measure actual caller repair or refusal without unrelated effects. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 2.4.3
- **2.4.3-A** — Capture durable outcome, bounded retries and effects/no-effects. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **2.4.3-B** — Verify restart and unrelated work after actual caller invocation. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.

### 3.3.4
- **3.3.4-A** — Freeze comparable pre/post measurement and attribution (after 1.3.3). **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **3.3.4-B** — Measure completed natural cycles with same workload/sampling. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **3.3.4-C** — Document uncertainty, effect size and regression checks. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 3.4.2
- **3.4.2-A** — Reconcile one status owner with verified and pending scope. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **3.4.2-B** — Publish one truthful final scope report without duplicate tracker. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 3.5.2
- **3.5.2-A** — Establish owner-approved conflict and acknowledgement contract (blocked). **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **3.5.2-B** — Implement conditional serialized writer/merge through existing owner. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **3.5.2-C** — Test two writers, restart/crash, rejection-before-ACK, no lost records. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 4.2.2.2
- **4.2.2.2-A** — Compare staged revision to actual served asset and authority (blocked). **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **4.2.2.2-B** — Deploy only through approved existing release mechanism with rollback. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **4.2.2.2-C** — Validate served warning and healthy/idle/failed-poll negative controls. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 4.2.2.3
- **4.2.2.3-A** — Wait for independent full natural-cycle recovery proof. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **4.2.2.3-B** — Test warning clearance and clock/heartbeat negative controls on served surface. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 6.5.2
- **6.5.2-A** — Obtain owner-approved reversible capacity policy (blocked). **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **6.5.2-B** — Implement isolated temporary-state capacity extension only after approval. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **6.5.2-C** — Test accepted reloadable records over ceiling, crash/digest/rollback/compatibility. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 7.3.1
- **7.3.1-A** — Acquire independently qualified source-backed artifact (dependency). **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **7.3.1-B** — Verify governed classification, knowledge validation and durable result. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.3.1-C** — Prove negative/replay/rollback, independent consumer behavior and cost. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 7.5.2
- **7.5.2-A** — Verify source authenticity/relevance and actual missing capability. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.5.2-B** — Connect missing canonical knowledge intake seam only if verified. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **7.5.2-C** — Test forged/stale/absent-session/duplicate and rollback failures. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 7.6.2
- **7.6.2-A** — Await genuinely new independent natural integration challenge. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **7.6.2-B** — Freeze answer-free first-pass reachability/negative rubric. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.6.2-C** — Compare observed controls, intervention, retries and cost without cherry-picking. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 7.7.1
- **7.7.1-A** — Run BPE-20261101-009 temporary-fixture baseline diagnostic. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.7.1-B** — Compare actual record semantics against executable-history replay contract. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.7.1-C** — Classify verified gap vs already-present/not-applicable/authority-blocked. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.

### 7.7.2
- **7.7.2-A** — Only after confirmed gap, modify canonical verifier in-place. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **7.7.2-B** — Prove exact corrected deficiency plus unauthorized/tamper rejection. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 7.7.3
- **7.7.3-A** — Trace Scout source-to-Director provenance and real mission receipt. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.7.3-B** — Independently validate downstream behavior against held-out test and rollback. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 7.8.1
- **7.8.1-A** — Run BPE-20261101-008 local source-owner census. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.8.1-B** — Freeze A/B published-versus-consumed SHA and stable run identity. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.8.1-C** — Test stale/forged/denied/same-B replay and delayed observation ambiguity. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 7.8.2
- **7.8.2-A** — Only after 7.8.1 demonstrates missing owner seam, bind consumed SHA to authorized action. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **7.8.2-B** — Run A/B/stale/forged/replay/delayed/rollback contract tests. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 7.8.3
- **7.8.3-A** — Link accepted Scout source to actually consumed mission and governed action. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.8.3-B** — Independent unseen outcome, rejected-source negative and no-loss regression. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 7.9.1
- **7.9.1-A** — Verify current private proof-artifact write behavior and safe patch applicability. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.9.1-B** — Private BPE-001 rev2 remains PREPARED_UNTESTED and source-compatible on confirmed feature branch; public .sh packaging was rejected by tool safety checks this run. No public executable patch is available for this ID. Do not count it as applied or silently bypass the publication blocker.
- **7.9.1-C** — Test reserved/intermediate symlink and validation→write swap negative fixtures in an isolated workspace with outside sentinel. Static path validation in private BPE-001 does not prove race-safe use-time containment; preserve the independent Ground requirement.

### 7.9.2
- **7.9.2-A** — Confirm canonical receipt-chain contract and private patch compatibility. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.9.2-B** — Apply private BPE-002 only if contract matches; otherwise stop. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **7.9.2-C** — Test valid ordered chain, forged/disconnected/skipped cases and overall false success. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

## Feature-branch reconciliation — 2026-11-01

At DT `feature/alphacode-provider` HEAD `9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb`, implementation commits for BPE-20261101-003–007 are present. This does not close 7.9.2's distinct prepared proof-chain fix, nor provide independently rerun host/production tests. Four executor staging reports (004–007) were read, their implementation source/test files inspected, and sanitized into `results/`. No old code patch is eligible for reapplication. 7.8.1 and 7.7.1 diagnostics remain separate, pending actual execution.

## Additional source-specific implementation packages — 2026-11-01

- `BPE-20261101-010` (`PREPARED_UNTESTED`): DT-EVO-007 / 7.9 evidence-trust extension. The current claim-receipt verifier accepts a second root or disconnected predecessor and does not include `chain.chain_valid` in aggregate `all_pass`. The one-file patch makes chain links contiguous in deterministic claim order and gates overall success; positive/negative tests and the existing claim receipt suite are specified. Source `9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb`, `receipts.py` blob `5d2e9ce04089f14d1b7b2b02615cca7d1a1649f0`. This is **not** the distinct private 7.9.2 proof-chain patch.
- `BPE-20261101-011` (`PREPARED_UNTESTED`): same trust-extension area. The current `TerminalReceipt` accepts an arbitrary nonempty `receipt_sha256`; this patch recomputes and checks it, with forged/mutated digest negatives. Source `9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb`, `models.py` blob `51bb900549ee4ca9ddc6d236e7afbf090a72b6f0`. Independent of 010 because source files do not overlap.

These two code patches are preparation, not execution or Ground. No authority-blocked mission steps were reclassified as completed. Existing 22 open numbered steps remain represented above; next verification-only discriminator remains 7.8.1.

- `BPE-20261101-012` (`PREPARED_UNTESTED`): current claim-receipt CLI returns process success even when its JSON verdict reports `all_pass=false`. Source `9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb`, `cli.py` blob `56d52e2f724042567d11d1f1635601bcc413d9fe`. The patch preserves JSON output but exits nonzero for failed verification, with success and negative tests. No production consumer integration is claimed.

## Patch Engineer source reconciliation — 2026-11-01 latest run

- The six active mission tasks and all **22** open numbered steps, including 4-part 4.2.2.2 and 4.2.2.3, were rechecked against current ACTIVE_MISSION.md and COMPLETED.md. Existing classifications remain; no new owner authorization, loaded recovery or external Ground evidence was observed.
- DT executor `feature/alphacode-provider` HEAD `9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb` is unchanged. BPE-003–007 implementation commits remain on that branch, not DT main; test counts are reported rather than independently rerun.
- BPE-010/011/012 source SHA bindings remain current and exact old diff hunks match (2/2, 1/1, 1/1 respectively). Git apply, shell syntax and host tests were not executed. They remain PREPARED_UNTESTED.
- Private BPE-001 rev2 source/test blobs match and six old hunks match; proposed public single-file patch publication was blocked by tool safety checks. No BPE-001 public patch was created and no source tests ran. 7.9.1 race negative remains unresolved. Private BPE-002 remains untested pending canonical chain-contract review.
- Existing diagnostics BPE-008/009 are verification-only. Other authority, deployment and natural-case blockers retain their previously recorded triggers. This update records inspection, not additional implementation or Ground.

## Patch Engineer reconciliation — 2026-11-01 (source-bound extensions)

- Full latest mission re-enumerated: **22/22 numbered open steps mapped**, including four-level `4.2.2.2` and `4.2.2.3`; 0 new/unmapped. The 6 task areas and all existing authority, production deployment, natural-case, and independent Ground prerequisites remain unchanged. COMPL​ETED.md was read; no completed item was reopened or newly declared verified.
- Confirmed local executor branch `feature/alphacode-provider` remains at `9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb`; BPE-003–007 are feature-branch implementations with reported, not independently rerun, guarded tests. No fresh result JSON for 010–014; no DT main or runtime integration claimed.
- **BPE-010 rev2:** Added a skipped-middle-predecessor negative that old chain logic incorrectly accepts, plus reverse-insertion-order positive. Original implementation hunk and exact `receipts.py` source blob unchanged. New test file now has 93 lines. Status `PREPARED_UNTESTED`.
- **BPE-013** (`PREPARED_UNTESTED`, depends on 011): Bind aggregate verdict fingerprint to `chain.chain_digest`; two distinct invalid chains with identical per-claim verdicts must have distinct verdict digests. Source target `models.py` blob `0f903b08461edce217c83a1feb324958affb159f` is a **predicted post-011** blob, not yet observed in DT. Exact dependency diff and patch hunks were checked in memory; actual Git apply/tests remain unrun.
- **BPE-014** (`PREPARED_UNTESTED`, depends on 012): Include `chain_digest` and `verdict_digest` in CLI JSON for both valid and failed verification, preserving BPE-012 nonzero failure exit. Source target `cli.py` blob `903445b151774881d36eebe2651549759403cc81` is a **predicted post-012** blob, not yet observed in DT. Actual Git apply/tests remain unrun.
- 013/014 are **supporting 7.9.2 evidence-trust packages**, not replacements for private BPE-002's distinct canonical proof-chain contract. 7.9.1 BPE-001 publication/tool block and race-safe containment Ground remain unresolved. Read-only BPE-008/009 remain diagnostic only. No authority-dependent or verification-only step is reclassified as code-complete.
- Ready for local source-check sequence (not tested): **011 → 013** on `models.py`; **012 → 014** on `cli.py`; **010 rev2** on `receipts.py`. Any branch drift requires fresh source SHA and exact apply validation before selection.
