# Mission step → patch coverage

Mission: [ACTIVE_MISSION.md](../ACTIVE_MISSION.md); snapshot blob `aaafac5be79b7ea46fdea19c1be762e14d22b66e`. This is an INITIAL triage inventory, not proof of implementation or authority. Borg Patch Engineer must refresh against current mission and DT executor branch EVERY run, inspect all unnumbered acceptance criteria, split every eligible step into source-grounded single-file patches, and record reasons for blocked/non-code work. Only `.sh` patch files go in `../patches/`.

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
| DT-EVO-007 | 7.7.1 | OUTWARD: test applicability and current parity before proposing code | OUTWARD_DIAGNOSTIC_NO_CODE_PATCH | — |
| DT-EVO-007 | 7.7.2 | INWARD: only if 7.7.1 proves a distinct, authority-safe gap, improve the existing owner in place | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.7.3 | GROUND: independent behavior, propagation and receipt, not a green component test | DEPENDENCY_PENDING_7.7.1 | — |
| DT-EVO-007 | 7.8.1 | OUTWARD: map the actual existing consumer and test revision-bound acknowledgement | OUTWARD_DIAGNOSTIC_NO_CODE_PATCH | — |
| DT-EVO-007 | 7.8.2 | INWARD, only if 7.8.1 proves an actionable owner gap | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.8.3 | GROUND: independently verify the full downstream effect and return feedback to the Scouts | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.9.1 | OUTWARD→INWARD→GROUND: contain reserved mission proof artifacts | PREPARED_PRIVATE_PUBLICATION_BLOCKED | BPE-20261101-001 (private) |
| DT-EVO-007 | 7.9.2 | OUTWARD→INWARD→GROUND: prevent invalid proof chains from producing a successful verdict | PREPARED_PRIVATE_PUBLICATION_BLOCKED | BPE-20261101-002 (private); BPE-20261101-003 applied unverified; BPE-20261101-004–007 public scripts on publication hold |

**Snapshot coverage:** 22 numbered open steps across 6 task areas. `SOURCE_REVIEW_REQUIRED` means no valid patch or blocker has yet been established. A mapped patch is NOT a completed mission step. Conditional or owner-authority-blocked steps must not be implemented without legitimate authorization. A verification-only step needs real test/observation evidence, not a fabricated source diff.

**Each run:** reconcile mission/COMPLETED against this map; list every unrepresented new step; classify; add patch IDs and actual source refs/test proof; prioritize repair of existing stale patches; publish as many independent complete new patches as warranted; report uncovered, blocked and verified counts. Preserve stable patch identity and keep PATCH_INDEX.json as authoritative executable queue.


## 2026-11-01 public-patch safety reconciliation

The authoritative current mission (blob `aaafac5be79b7ea46fdea19c1be762e14d22b66e`, step 7.9 next-action) explicitly imposes **SAFETY_STOP on future public source-bearing patch publication** because the implementation source is private. This overrides the earlier public-patch authoring assumption. No new or revised source-bearing shell scripts may be published until the authorized owner changes the disclosure policy. Previously published BPE-20261101-004–007 are **NOT ELIGIBLE** for automatic selection, application or new publication; existing public artifacts remain historically visible and should not be mistaken for authorization. Do not reproduce their private diffs in metadata. BPE-20261101-003 has a separately confirmed feature-branch implementation commit, but tests remain independently unverified. The two prepared private packages (001–002) remain private and cannot be copied into this public repository.

**Current coverage:** 22 numbered active steps represented, 0 newly executable public patches authorized, 4 existing pending public scripts on disclosure hold, 2 prepared private packages withheld, 1 previously integrated public patch not independently Ground-verified. Non-code OUTWARD discriminators 7.7.1 and 7.8.1 can be examined only through already-authorized private/isolated evidence; 7.6.2 awaits a genuinely new natural case. Authority/integrity and deployment blockers remain unchanged. Recheck only on explicit owner authorization to disclose sanitized patches, an authorized private-executor result, or a changed mission/source condition; do not reinterpret an existing public copy as approval.
