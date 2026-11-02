# End-to-end mission patch work-order index

Source: [ACTIVE_MISSION.md](../ACTIVE_MISSION.md). Each row represents **one distinct atomic patch work order**. The work order is the exact scope and acceptance definition; the historical MEP `.sh` is merely a gate and not a source diff.

**Coverage:** 22 open mission steps, 58 atomic work orders; 4 explicitly linked to prepared source patches; 19 with currently missing owner/prerequisite; 5 immediately independent source/verification investigations; all other items depend on prior results. **Implementation coverage is not 58/58.**

Code diff queue: [BPE-010, BPE-024, BPE-025, BPE-026](../patches/). Applied old diffs are retired, and BPE-002 is superseded.

| Work order | Priority | Unit class | Depends on | Current status |
|---|---|---|---|---|
| [MEP-1.3.3-A](work_orders/MEP-1-3-3-A.md) | CRITICAL | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | — | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-1.3.3-B](work_orders/MEP-1-3-3-B.md) | CRITICAL | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 1.3.3-A | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-1.3.3-C](work_orders/MEP-1-3-3-C.md) | CRITICAL | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 1.3.3-B | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-2.2.2-A](work_orders/MEP-2-2-2-A.md) | HIGH | EVIDENCE_PATCH_OR_TEST | — | READY_FOR_SOURCE_GROUNDED_PROOF_OR_PATCH_DESIGN |
| [MEP-2.2.2-B](work_orders/MEP-2-2-2-B.md) | HIGH | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 2.2.2-A | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-2.2.2-C](work_orders/MEP-2-2-2-C.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 2.2.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-2.2.3-A](work_orders/MEP-2-2-3-A.md) | HIGH | SOURCE_DIFF_IF_VERIFIED_GAP | 2.2.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-2.2.3-B](work_orders/MEP-2-2-3-B.md) | HIGH | SOURCE_DIFF_IF_VERIFIED_GAP | 2.2.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-2.2.3-C](work_orders/MEP-2-2-3-C.md) | HIGH | SOURCE_DIFF_IF_VERIFIED_GAP | 2.2.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-2.4.2-A](work_orders/MEP-2-4-2-A.md) | HIGH | SOURCE_DIFF_IF_VERIFIED_GAP | 2.2.2-B, 2.2.3-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-2.4.2-B](work_orders/MEP-2-4-2-B.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 2.4.2-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-2.4.3-A](work_orders/MEP-2-4-3-A.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 2.4.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-2.4.3-B](work_orders/MEP-2-4-3-B.md) | HIGH | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 2.4.3-A | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-3.3.4-A](work_orders/MEP-3-3-4-A.md) | MEDIUM | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 1.3.3-C | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-3.3.4-B](work_orders/MEP-3-3-4-B.md) | MEDIUM | EVIDENCE_PATCH_OR_TEST | 3.3.4-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-3.3.4-C](work_orders/MEP-3-3-4-C.md) | MEDIUM | EVIDENCE_PATCH_OR_TEST | 3.3.4-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-3.4.2-A](work_orders/MEP-3-4-2-A.md) | MEDIUM | SOURCE_DIFF_PREPARED_BPE_025_PARTIAL | — | PREPARED_UNTESTED_VALIDATE_SOURCE_AND_EXECUTE |
| [MEP-3.4.2-B](work_orders/MEP-3-4-2-B.md) | MEDIUM | SOURCE_DIFF_PREPARED_BPE_025_PARTIAL | 3.4.2-A | PREPARED_UNTESTED_VALIDATE_SOURCE_AND_EXECUTE |
| [MEP-3.5.2-A](work_orders/MEP-3-5-2-A.md) | MEDIUM | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | — | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-3.5.2-B](work_orders/MEP-3-5-2-B.md) | MEDIUM | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 3.5.2-A | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-3.5.2-C](work_orders/MEP-3-5-2-C.md) | MEDIUM | EVIDENCE_PATCH_OR_TEST | 3.5.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-4.2.2.2-A](work_orders/MEP-4-2-2-2-A.md) | HIGH | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | — | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-4.2.2.2-B](work_orders/MEP-4-2-2-2-B.md) | HIGH | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 4.2.2.2-A | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-4.2.2.2-C](work_orders/MEP-4-2-2-2-C.md) | HIGH | SOURCE_DIFF_PREPARED_BPE_024_PARTIAL | 4.2.2.2-B | PREPARED_UNTESTED_VALIDATE_SOURCE_AND_EXECUTE |
| [MEP-4.2.2.3-A](work_orders/MEP-4-2-2-3-A.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 1.3.3-C | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-4.2.2.3-B](work_orders/MEP-4-2-2-3-B.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 4.2.2.3-A, 4.2.2.2-C | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-6.5.2-A](work_orders/MEP-6-5-2-A.md) | CRITICAL | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | — | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-6.5.2-B](work_orders/MEP-6-5-2-B.md) | CRITICAL | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 6.5.2-A | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-6.5.2-C](work_orders/MEP-6-5-2-C.md) | CRITICAL | EVIDENCE_PATCH_OR_TEST | 6.5.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.3.1-A](work_orders/MEP-7-3-1-A.md) | HIGH | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 7.5.2-A | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-7.3.1-B](work_orders/MEP-7-3-1-B.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.5.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.3.1-C](work_orders/MEP-7-3-1-C.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.3.1-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.5.2-A](work_orders/MEP-7-5-2-A.md) | HIGH | EVIDENCE_PATCH_OR_TEST | — | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-7.5.2-B](work_orders/MEP-7-5-2-B.md) | HIGH | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 7.5.2-A | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-7.5.2-C](work_orders/MEP-7-5-2-C.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.5.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.6.2-A](work_orders/MEP-7-6-2-A.md) | HIGH | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | — | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-7.6.2-B](work_orders/MEP-7-6-2-B.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.6.2-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.6.2-C](work_orders/MEP-7-6-2-C.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.6.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.7.1-A](work_orders/MEP-7-7-1-A.md) | HIGH | EVIDENCE_PATCH_OR_TEST | — | READY_FOR_SOURCE_GROUNDED_PROOF_OR_PATCH_DESIGN |
| [MEP-7.7.1-B](work_orders/MEP-7-7-1-B.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.7.1-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.7.1-C](work_orders/MEP-7-7-1-C.md) | HIGH | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 7.7.1-B | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-7.7.2-A](work_orders/MEP-7-7-2-A.md) | HIGH | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 7.7.1-C | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-7.7.2-B](work_orders/MEP-7-7-2-B.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.7.2-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.7.3-A](work_orders/MEP-7-7-3-A.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.7.1-C | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.7.3-B](work_orders/MEP-7-7-3-B.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.7.3-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.8.1-A](work_orders/MEP-7-8-1-A.md) | HIGH | EVIDENCE_PATCH_OR_TEST | — | READY_FOR_SOURCE_GROUNDED_PROOF_OR_PATCH_DESIGN |
| [MEP-7.8.1-B](work_orders/MEP-7-8-1-B.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.8.1-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.8.1-C](work_orders/MEP-7-8-1-C.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.8.1-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.8.2-A](work_orders/MEP-7-8-2-A.md) | HIGH | CONDITIONAL_PATCH_ON_REAL_AUTHORITY | 7.8.1-C | NOT_AUTHORIZED_OR_PREREQUISITE_PENDING |
| [MEP-7.8.2-B](work_orders/MEP-7-8-2-B.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.8.2-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.8.3-A](work_orders/MEP-7-8-3-A.md) | HIGH | SOURCE_DIFF_IF_VERIFIED_GAP | 7.8.1-C | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.8.3-B](work_orders/MEP-7-8-3-B.md) | HIGH | SOURCE_DIFF_IF_VERIFIED_GAP | 7.8.3-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.9.1-A](work_orders/MEP-7-9-1-A.md) | HIGH | EVIDENCE_PATCH_OR_TEST | — | READY_FOR_SOURCE_GROUNDED_PROOF_OR_PATCH_DESIGN |
| [MEP-7.9.1-B](work_orders/MEP-7-9-1-B.md) | HIGH | IMPLEMENTED_BPE_001_REQUIRES_VERIFICATION | 7.9.1-A | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.9.1-C](work_orders/MEP-7-9-1-C.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.9.1-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |
| [MEP-7.9.2-A](work_orders/MEP-7-9-2-A.md) | HIGH | SOURCE_DIFF_IF_VERIFIED_GAP | — | READY_FOR_SOURCE_GROUNDED_PROOF_OR_PATCH_DESIGN |
| [MEP-7.9.2-B](work_orders/MEP-7-9-2-B.md) | HIGH | SOURCE_DIFF_PREPARED_BPE_010 | 7.9.2-A | PREPARED_UNTESTED_VALIDATE_SOURCE_AND_EXECUTE |
| [MEP-7.9.2-C](work_orders/MEP-7-9-2-C.md) | HIGH | EVIDENCE_PATCH_OR_TEST | 7.9.2-B | AWAITING_DEPENDENCY_AND_SOURCE_INSPECTION |

## Sequencing and truthful status

1. Independently runnable investigation/discriminator work (not presumed implementable): 7.8.1, 7.7.1, 7.9.1 and 7.9.2 source-compatibility; isolate genuine gaps, and repair only where a source diff is needed.
2. Three existing prepared diffs: BPE-010 strict chain link, BPE-024 served-build identity (not deployment authorization), BPE-025 report priority; validate against current DT/main and existing work before local apply.
3. Any other implementation work order becomes a real BPE diff only after an exact owner/source gap, valid authority, nonoverlapping patch base, and positive/negative DoD are established.
4. Integrity disposition (1.3.3), repair-caller authority (2.x), persistence/retention authority (3.5.2, 6.5.2), and production deployment (4.2.2.2) remain hard owner gates, never implicitly delegated to a shell patch.
5. Continuous chain: each recorded result updates its work order, patch index, mission mapping and prerequisites; independently validate full-system Ground before archiving mission step.

**Exit criterion:** No remaining OPEN item lacks a work order, a real BPE patch or explicit gate, downstream dependency and evidence contract. This is complete *planning decomposition*, not completion of implementation.

## 2026-11-02 — current mainline implementation queue

All 58 individual work orders were re-read. BPE-010 rev5 (strict predecessor), BPE-024 (served UI truth), BPE-025 (failed objective status) and new BPE-026 (reject extra uncommitted receipt records) are the **four** prepared source-code scripts; none has local `git apply --check`, shell syntax, host-guarded tests or Ground evidenced. The 58 MEP scripts remain conditional gates, not implementations. DT main HEAD `17c70b0e2b7fec53e46bdeaa35e9e25d76034bd2`, ACTIVE_MISSION blob `c61b9be0780222d13dd2420b44f2fd68422c33e3`. BPE-002 remains superseded.
