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
| DT-EVO-007 | 7.3.1 | Ground the full evidence-to-validated-knowledge path, not merely queue reachability | SOURCE_REVIEW_REQUIRED | — |
| DT-EVO-007 | 7.5.2 | INWARD, conditional on 7.5.1: reuse the canonical knowledge intake | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.6.2 | INWARD/GROUND: measure independent transfer without selecting a favorable retry result | SOURCE_REVIEW_REQUIRED | — |
| DT-EVO-007 | 7.7.1 | OUTWARD: test applicability and current parity before proposing code | SOURCE_REVIEW_REQUIRED | — |
| DT-EVO-007 | 7.7.2 | INWARD: only if 7.7.1 proves a distinct, authority-safe gap, improve the existing owner in place | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.7.3 | GROUND: independent behavior, propagation and receipt, not a green component test | SOURCE_REVIEW_REQUIRED | — |
| DT-EVO-007 | 7.8.1 | OUTWARD: map the actual existing consumer and test revision-bound acknowledgement | SOURCE_REVIEW_REQUIRED | — |
| DT-EVO-007 | 7.8.2 | INWARD, only if 7.8.1 proves an actionable owner gap | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.8.3 | GROUND: independently verify the full downstream effect and return feedback to the Scouts | DEPENDENCY_PENDING | — |
| DT-EVO-007 | 7.9.1 | OUTWARD→INWARD→GROUND: contain reserved mission proof artifacts | PREPARED_PRIVATE | BPE-20261101-001 (private) |
| DT-EVO-007 | 7.9.2 | OUTWARD→INWARD→GROUND: prevent invalid proof chains from producing a successful verdict | PATCHES_IN_PROGRESS | BPE-20261101-002 (private); BPE-20261101-003–007 (related public hardening) |

**Snapshot coverage:** 22 numbered open steps across 6 task areas. `SOURCE_REVIEW_REQUIRED` means no valid patch or blocker has yet been established. A mapped patch is NOT a completed mission step. Conditional or owner-authority-blocked steps must not be implemented without legitimate authorization. A verification-only step needs real test/observation evidence, not a fabricated source diff.

**Each run:** reconcile mission/COMPLETED against this map; list every unrepresented new step; classify; add patch IDs and actual source refs/test proof; prioritize repair of existing stale patches; publish as many independent complete new patches as warranted; report uncovered, blocked and verified counts. Preserve stable patch identity and keep PATCH_INDEX.json as authoritative executable queue.
