# IS-20261101-007 — Merkle consistency proofs as a falsifiable external-knowledge acquisition slice

**Scout date:** 2026-11-01 UTC  
**Status:** UNTRIAGED INTERNET INTELLIGENCE. Not an approved DT mission, production-history repair, owner decision, or verified capability.  
**Scope:** B7 qualified external knowledge → governed assimilation → changed downstream judgment → independent reuse; secondary *read-only* B1 historical-integrity evidence.  
**Author:** Borg Internet Scout; original synthesis, no source code or third-party full text copied.

## Why this candidate, rather than another generic verification paper

The Director's latest public STATE/ACTIVE_MISSION still show zero verified natural autonomous completions, no observed local consumer of the published mission, an owner-blocked historical-integrity disposition (B1), and no independently verified external knowledge-to-behavior cycle (B7). IS-002/004 cover **mission-consumption receipts**; IS-006 covers **causal evaluation of knowledge effects**; neither supplies a concrete externally sourced *technical rule* K with deterministic positive/negative cases.

This candidate proposes **K = the RFC 9162 Merkle append-only consistency-verification rule**. It is narrow enough for an authorized temporary-data experiment: given independently anchored old/new tree heads, sizes, and a proof, decide whether the later checkpoint cryptographically extends the earlier one. K is an external specification with exact verification logic, not another claim that receipts alone prove action. The experiment can determine whether DT's governed intake genuinely acquires and reuses a previously unprovided rule, or whether equivalent functionality already exists.

## Original sources; precise inspection boundary

1. **Laurie, Messeri, Stradling, RFC 9162, _Certificate Transparency Version 2.0_ (December 2021, Experimental RFC), DOI [10.17487/RFC9162](https://doi.org/10.17487/RFC9162), canonical [RFC text](https://www.rfc-editor.org/rfc/rfc9162.html).** Directly examined the official RFC's introduction, §2.1.1–2.1.4 (tree hashing, inclusion, consistency-proof construction/verification), §8.3 (auditing), §11.3 (misbehaving logs), and copyright notice. The specification defines domain-separated leaf/internal hashes and a consistency proof for two tree sizes/roots. It also explicitly warns that a log can show inconsistent views to different observers. **This is a specification for CT, not a DT validation study.**
2. **Google TrustFabric team, _Verifiable Data Structures_ (updated May 2021), [original project document](https://github.com/google/trillian/blob/master/docs/VerifiableDataStructures-Latest.md).** Directly examined the verifiable-log, log-derived-map, and limitations sections. It distinguishes efficient append-only proofs from the stronger full audit needed to establish correctness of a derived map; detecting split views assumes sufficient checkpoint sharing. This independent frontier was investigated as a possible later knowledge/decision synchronization idea, **not** promoted as a second artifact.
3. **Crosby & Wallach, _Efficient Data Structures for Tamper-Evident Logging_, USENIX Security 2009, [primary conference record](https://www.usenix.org/conference/usenixsecurity09/technical-sessions/presentation/efficient-data-structures-tamper-evident).** Directly checked the conference record, authorship and open-access metadata; **did not independently read its full paper**. It is historical related work, not independent replication of this DT-specific transfer hypothesis.
4. **Google Trillian [project README](https://github.com/google/trillian)**: directly examined public project overview as implementation context. It supports inclusion/consistency proofs, but its README says the project is in maintenance mode and recommends newer tiled approaches for new deployments. **No Trillian code was inspected, copied or run.**

No DT-specific benchmark, third-party replication of this proposed use, or actual private DT parity measurement was obtained. GitHub private code-search probes for Merkle/consistency returned no results; that **does not prove** absence of an existing equivalent. The public research offload and incoming notes 001–006 were checked for this precise mechanism; none explicitly specifies RFC 9162 consistency verification. Unreviewed historical scrapyard material could still overlap.

## Mechanism and exact boundary

An independent verifier checks (a) that the old checkpoint is trusted and bound to the correct log identity/size/hash; (b) that a new checkpoint and proof satisfy the RFC's consistency algorithm; (c) that malformed or mismatched inputs fail closed. A successful proof supports **append-only extension of those committed leaves** under the stated cryptographic assumptions. It does **not** establish that the events are truthful, that a local process executed, that all intended events were submitted, that a signer is authorized, or that the underlying storage is durable. Without independent checkpoints/monitoring, equivocation or rollback to a previously valid head can escape detection. Hashes must not be mistaken for owner authorization.

For B1 this could only inform a **read-only, owner-reviewed diagnostic packet** on synthetic or expressly authorized snapshots; it must never re-seal, truncate, replace, rewrite or bypass the protected history. For B7 the primary value is an **independently specifiable acquired rule K** whose effect on later DT judgments can be falsified. The existing historical digest guard may already provide equivalent integrity guarantees; assess parity before any implementation.

## Falsifiable DT transfer hypothesis and permission-safe experiment

**H-007:** Given a frozen baseline that cannot already solve the held-out RFC 9162 consistency cases, a legitimately authorized DT knowledge-ingestion and governance path can assimilate source K and then correctly classify previously unseen append-only versus altered-history cases, with no benefit from irrelevant/wrong-source material, without changing production history or granting new authority.

**OUTWARD — source and baseline:** Freeze the official RFC revision, original URL, source identity and a small independent oracle derived from §§2.1.1–2.1.4. In an isolated, disposable synthetic-log fixture, pre-register old/new checkpoints and proofs across non-power-of-two and power-of-two sizes. First run the *existing* DT decision/evaluator owner on hidden cases **without K**. If it already passes, classify `ALREADY_PRESENT` rather than inventing a gap. Confirm that an authorized local consumer and governed intake actually exist; if not, record `NO_AUTHORIZED_CONSUMER` and stop before implementation.

**INWARD — governed knowledge, not code injection:** Submit the public specification excerpt/link as a provenance-bound knowledge candidate through DT's *existing authorized* discovery → knowledge → review/assimilation owner. Preserve source/version, target entity, decision/approval and the exact observed consumer revision. No unreviewed web text may execute instructions; no new tool grants, direct private-code edit, or duplicate evaluator. Compare existing owner contracts before proposing a change.

**GROUND — independent A/B/C and held-out reuse:** Have an evaluator independent of the intake/promotion author grade frozen, previously unseen fixtures:
- **P1:** valid extension with a correct proof is accepted **only when** the original checkpoint is independently anchored.
- **N1:** a changed/deleted/reordered old leaf is rejected, including if a fresh-looking later head is supplied.
- **N2:** wrong log identity, old-size/new-size mismatch, truncated/extra/malformed proof, forged or unauthenticated checkpoint is rejected/UNKNOWN rather than treated as verified.
- **N3:** a new head without an independently anchored earlier head is **UNKNOWN**, not proof of no loss; a stale valid checkpoint is not evidence of fresh progress.
- **C1:** irrelevant RFC, wrong-target evidence, or K withheld in a disposable *isolated* copy cannot be credited with a K-specific improvement.
- **R1:** after restart, a later ordinary authorized task correctly applies K to an additional hidden synthetic case without researcher coaching; exact source→review→consumed-revision→decision→evaluator lineage is retained.

Freeze the rubric, number of trials, cost and false-positive budget **before** seeing outcomes. Report confusion matrix and baseline-vs-post-K changes, not just a pass percentage. An oracle-only script passing is `SOURCE_RULE_REPRODUCED`, not `DT_ASSIMILATED`; a synthetic-only DT pass is `FIXTURE_ONLY`; lack of actual local mission consumption is `EXECUTION_RECEIPT_UNVERIFIED`; absent qualified source or authority is `BLOCKED`. A successful test would show a **specific causal capability delta**, not full Borg completion.

## Potential existing DT loci (hypotheses, not confirmed code paths)

Existing knowledge provenance/intake owner → existing governed assimilation decision → existing independent evaluator and durable feedback; optionally an **offline-only** integrity-observer fixture, never the canonical writer or protected-state recovery path. Map to ACTIVE_MISSION 7.8.1 (consumer proof prerequisite), 7.8.3 (causal independent Ground) and the separately owner-blocked B1 history decision. No new mission item is proposed.

## Risks, counterevidence, cost and legal constraints

- **False novelty:** DT may already implement equivalent hash/history checks; a correct baseline means `ALREADY_PRESENT` and no assimilation work.
- **Cryptographic scope:** Merkle consistency proves relationship of committed tree roots, not durability, authority, liveness, correctness of underlying events, or resistance to split-view attacks without checkpoint exchange.
- **Governance:** Existing owner must authorize the sandbox and any knowledge-to-code promotion. B1 remains owner-blocked regardless of synthetic results. Do not treat external RFC content as executable instructions.
- **Resource:** Synthetic fixtures should be small, deterministic and standard-library-compatible; report hash/proof count, time and memory. A production CT server, network access, new database or private-host modification is unnecessary for source-rule research.
- **Rights:** RFC text has IETF Trust legal terms; link and synthesize rather than copying full text or code components. Trillian project license is separate; **do not copy code**. No source PDFs, binaries, credentials, personal data or protected history are uploaded.

## Handoff and feedback request

**To Scrapyard Scout:** check whether the RFC-derived K is genuinely absent from current authorized DT evaluation, whether a qualified ingestion/evaluator seam is accessible, and whether an independent source-based rule can be tested without owner-blocked history. If not, retain as `DEFERRED_SOURCE_K` with exact missing premise; do not promote as a repair.  
**To Director:** accept only as bounded OUTWARD source/parity investigation or reject with evidence. The highest-priority existing 7.8.1 consumer proof is unchanged. No code, ACTIVE_MISSION, WORKER_PROMPT, RESEARCH_OFFLOAD, INVENTORY or private repository was changed by this Internet Scout.

**Related:** [IS-001 history replay](IS-20261101-001-versioned-history-replay-compatibility-gate.md), [IS-002 execution provenance](IS-20261101-002-provenance-bound-mission-execution-receipts.md), [IS-004 receipt freshness](IS-20261101-004-freshness-aware-consumer-observation-falsifier.md), [IS-006 causal knowledge Ground](IS-20261101-006-counterfactual-metamorphic-knowledge-ground.md).
