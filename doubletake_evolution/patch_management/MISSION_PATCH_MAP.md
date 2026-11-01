# Mission step → patch coverage

Mission: [ACTIVE_MISSION.md](../ACTIVE_MISSION.md); snapshot blob `8c8e5bae2a6d9660b544d595064cd107f4d213d4`. This is an INITIAL triage inventory, not proof of implementation or authority. Borg Patch Engineer must refresh against current mission and DT executor branch EVERY run, inspect all unnumbered acceptance criteria, split every eligible step into source-grounded single-file patches, and record reasons for blocked/non-code work. Only `.sh` patch files go in `../patches/`.

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
| DT-EVO-007 | 7.9.1 | OUTWARD→INWARD→GROUND: contain reserved mission proof artifacts | PREPARED_PRIVATE_PUBLICATION_BLOCKED | BPE-20261101-001 (private) |
| DT-EVO-007 | 7.9.2 | OUTWARD→INWARD→GROUND: prevent invalid proof chains from producing a successful verdict | PREPARED_PRIVATE_PUBLICATION_BLOCKED | BPE-20261101-002 (private); BPE-20261101-003 applied unverified; BPE-20261101-004–007 public scripts on publication hold |

**Snapshot coverage:** 22 numbered open steps across 6 task areas. `SOURCE_REVIEW_REQUIRED` means no valid patch or blocker has yet been established. A mapped patch is NOT a completed mission step. Conditional or owner-authority-blocked steps must not be implemented without legitimate authorization. A verification-only step needs real test/observation evidence, not a fabricated source diff.

**Each run:** reconcile mission/COMPLETED against this map; list every unrepresented new step; classify; add patch IDs and actual source refs/test proof; prioritize repair of existing stale patches; publish as many independent complete new patches as warranted; report uncovered, blocked and verified counts. Preserve stable patch identity and keep PATCH_INDEX.json as authoritative executable queue.


## 2026-11-01 public-patch safety reconciliation

The authoritative current mission (blob `aaafac5be79b7ea46fdea19c1be762e14d22b66e`, step 7.9 next-action) explicitly imposes **SAFETY_STOP on future public source-bearing patch publication** because the implementation source is private. This overrides the earlier public-patch authoring assumption. No new or revised source-bearing shell scripts may be published until the authorized owner changes the disclosure policy. Previously published BPE-20261101-004–007 are **NOT ELIGIBLE** for automatic selection, application or new publication; existing public artifacts remain historically visible and should not be mistaken for authorization. Do not reproduce their private diffs in metadata. BPE-20261101-003 has a separately confirmed feature-branch implementation commit, but tests remain independently unverified. The two prepared private packages (001–002) remain private and cannot be copied into this public repository.

**Current coverage:** 22 numbered active steps represented, 0 newly executable public patches authorized, 4 existing pending public scripts on disclosure hold, 2 prepared private packages withheld, 1 previously integrated public patch not independently Ground-verified. Non-code OUTWARD discriminators 7.7.1 and 7.8.1 can be examined only through already-authorized private/isolated evidence; 7.6.2 awaits a genuinely new natural case. Authority/integrity and deployment blockers remain unchanged. Recheck only on explicit owner authorization to disclose sanitized patches, an authorized private-executor result, or a changed mission/source condition; do not reinterpret an existing public copy as approval.

## Atomic mission decomposition — implementation candidates and proof slices

**Important:** The unit IDs below are planning units, NOT executable patch IDs. Only listed `BPE-*.sh` files in `../patches/` are executable. A planned unit becomes a real code-bearing patch only after source inspection, adequate authority, public-disclosure clearance and an exact source-bound diff. Read-only diagnostics 008/009 are NOT code modifications. The current mission explicitly prohibits new public private-source-bearing diffs pending owner authorization.

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
- **7.9.1-B** — Apply private BPE-001 only if still necessary and authorized. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **7.9.1-C** — Test reserved/intermediate symlink and validation-write swap negative fixtures. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.

### 7.9.2
- **7.9.2-A** — Confirm canonical receipt-chain contract and private patch compatibility. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
- **7.9.2-B** — Apply private BPE-002 only if contract matches; otherwise stop. **Gate:** prerequisite/authorization must be independently satisfied; not a ready code patch.
- **7.9.2-C** — Test valid ordered chain, forged/disconnected/skipped cases and overall false success. **DoD:** evidence or focused positive/negative result required; not satisfied by planning alone.
