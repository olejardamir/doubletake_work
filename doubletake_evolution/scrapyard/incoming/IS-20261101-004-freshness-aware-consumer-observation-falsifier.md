# IS-20261101-004 — Freshness-aware consumer observation: distinguish a new execution from a recycled receipt

**Scout date:** 2026-11-01 UTC  
**Stage:** UNTRIAGED EXTERNAL INTELLIGENCE. Not a DT capability, implementation instruction, authorization grant, or proof of local execution.  
**Focus:** A *negative-control refinement* for the existing mission-consumer verification question, not a new attestation framework.

## Why this matters now

The public Evolution Director state reviewed for this scouting epoch says DT has **zero verified complete natural autonomous cycles** and no independently confirmed local consumption of the public mission. Its current critical-path-independent action is **7.8.1: identify the existing mission consumer and distinguish published revision, actually consumed revision, started/blocked/executed status and independent Ground**. The Director has explicitly rejected inventing a new signer, receipt service or authority. Historical integrity recovery separately remains owner-pending.

Earlier source note [IS-20261101-002](IS-20261101-002-provenance-bound-mission-execution-receipts.md) examines *which mission SHA* a receipt claims to cover and *who* claims it. This note asks an additional falsifiable question: **could a perfectly revision-bound receipt from an earlier run be replayed or mistakenly treated as fresh proof of the current local consumer?** A valid GitHub commit SHA proves a published artifact exists; it does not prove a local read. A signature or timestamp on an old receipt may still fail to establish current execution.

## Primary evidence actually examined

1. **IETF RFC 9334, _Remote ATtestation procedureS (RATS) Architecture_ (Birkholz et al., January 2023), sections 7, 10.1–10.4, 12.2 and Appendix A.2.** Directly read the official IETF HTML at https://datatracker.ietf.org/doc/html/rfc9334 . The architecture separates *Attester*, *Verifier* and *Relying Party*; it distinguishes authenticity from freshness. Section 10.2 describes verifier-issued unpredictable nonces signed with claims, while section 10.3 describes epochs. Section 10.4 and Appendix A.2 explicitly warn that fresh attestation *packaging* does not necessarily make the underlying claim newly collected. Section 12.2 calls for replay protection. **Important qualification:** RFC 9334 is an informational remote-attestation architecture, not a ready-made DT software-execution protocol, and its strongest claims assume a suitable root of trust. Merely echoing a nonce from an untrusted process proves neither trusted local consumption nor execution.
2. **Chandra & Toueg, _Unreliable Failure Detectors for Reliable Distributed Systems_, Journal of the ACM 43(2), 1996, DOI:10.1145/226643.226647.** Directly read the Cornell University author bibliography/abstract at https://www.cs.cornell.edu/info/people/sam/FDpapers.html and the Cornell repository abstract at https://ecommons.cornell.edu/entities/publication/7948ff49-7263-49f8-a29b-d062e7cbb240 . The authors formalize completeness versus accuracy for failure detectors in asynchronous systems. **Transfer inference, not a theorem about DT:** missing or late acknowledgement alone cannot distinguish a dead consumer from an unobserved/delayed one. The full paper was not reviewed in this epoch; do not transfer its consensus results as an execution-verification guarantee.

## Distinct DT/Borg capability-delta hypothesis

**Hypothesis H-004:** If existing DT receipts/status evidence do not bind *consumer identity + exact consumed mission blob + independently observed run instance/freshness + stage/outcome*, the 7.8.1 evaluator may falsely count a replayed/stale receipt as a new consumer acknowledgement. An **existing-owner, read-only negative-control matrix** will expose that gap without creating new infrastructure. If DT already rejects these false positives and preserves UNKNOWN on missing observations, mark this idea **ALREADY_PRESENT** and stop.

**Candidate integration locus (hypothesized, not audited):** the *existing* DT mission reader/dispatcher, existing receipt/status owner and separately authorized evaluator. First locate them in private DT; do not introduce a parallel receipt stack. No new signer, nonce service, privileged host access or public logging of private runtime IDs is authorized.

## Outward → Inward → Ground: one bounded experiment

**OUTWARD — freeze evidence and baseline:** Using only an already authorized read-only or isolated observer, identify current mission-consumer owner and current receipt/status surface. Pin two distinct public mission blob revisions **A** and **B** and record whether a run-local instance marker, trusted observation timestamp, and producer identity are *already* available. Avoid creating artificial changes to ACTIVE_MISSION solely for this test. Establish the pre-existing evaluator's verdict on synthetic fixture cases before proposing any change.

**INWARD — apply negative controls to the existing evaluator (synthetic/public-safe only):**

| Case | Input observation | Required verdict |
| --- | --- | --- |
| P1 | Trusted authorized consumer independently observed reading B in the relevant run, with correct existing identity/freshness binding | CONSUMER_READ_B, **not** EXECUTED or GROUND_VERIFIED |
| N1 | GitHub published B but no local consumer observation | PUBLISHED_ONLY / EVIDENCE_UNAVAILABLE |
| N2 | Genuine A receipt replayed after B becomes the target | STALE_OR_WRONG_REVISION; never credit B |
| N3 | Correct B digest copied into an untrusted/self-authored receipt | UNTRUSTED_CLAIM; never credit consumption |
| N4 | Old B receipt replayed as proof of a *new* B run | STALE_OR_UNPROVEN_NEW_RUN |
| N5 | Delayed but otherwise valid B acknowledgement; observer absent or clock skew unknown | UNKNOWN/PENDING rather than invented failure or success |
| N6 | B was read and then blocked by the existing integrity/authorization gate | CONSUMER_READ_B / BLOCKED, **not** EXECUTED |
| P2 | Separately verified B action with independent outcome and held-out test | May advance only the specific demonstrated stage, not general Borg autonomy |

**GROUND — acceptance/falsifier:** Report (i) existing-owner evidence and immutable input revisions, (ii) baseline verdict for every case, (iii) the first exact misclassification if any, (iv) before/after false-positive and false-negative counts with unchanged no-loss/authorization protections, (v) resource cost and rollback, and (vi) whether any real authorized local B read and independent outcome was observed. **Pass** only if all false-positive cases are rejected and valid-but-delayed evidence is not mislabeled as definitive failure. A synthetic pass is **TESTED ONLY**; real end-to-end completion requires a genuinely observed consumer and independent Ground. If the existing owner already passes, do not implement anything.

**Practical limit:** A trusted signed challenge/nonce could establish *response freshness* if DT already has an authorized trusted attester and verifier; it still does not prove the contents of a claim were newly collected or that useful code executed. Without such an existing trust boundary, use observational classification and report **EVIDENCE_UNAVAILABLE**; do not fabricate cryptographic certainty. A missing reply is a monitoring signal, not conclusive evidence of failure.

## Relevance, risks and disposition request

- **Direct gap:** `COLLECTIVE_HANDOFF_PARTIAL` and 7.8.1 mission-consumer proof. This supplements, rather than duplicates, [IS-20261101-002](IS-20261101-002-provenance-bound-mission-execution-receipts.md); [IS-20261101-001](IS-20261101-001-versioned-history-replay-compatibility-gate.md) concerns a separate history-compatibility question, and [IS-20261101-003](IS-20261101-003-entity-bound-evidence-assimilation-falsifier.md) is deferred pending a demonstrated attribution failure.
- **Safety:** Never bypass the owner-pending integrity decision, publish private DT identifiers, mutate protected history, add unauthorized telemetry or misrepresent a remote attestation standard as proof of a local DT run.
- **Costs:** Verifier-side freshness checks can require extra state/round trips. Prefer the cheapest already-present observation; if no observable trusted consumer exists, report the precise missing permission/owner and stop.
- **Licensing/provenance:** Original synthesis; links to primary publications, no copied code, PDFs or figures. Source claims are separated from the DT hypothesis.
- **Scrapyard Scout request:** Check the current DT consumer/status baseline before promotion. Classify `ALREADY_PRESENT`, `RETAIN_FOR_RESEARCH`, or `PROPOSED_FOR_DIRECTOR_REVIEW` based on a *specific misclassification*, not the appeal of cryptographic terminology. If novel, propose only the minimal existing-owner falsifier to the Director.

## Independent frontier sampled but not promoted

Also examined the USENIX TaPP 2020 primary proceedings abstract for Nakamura, Malik & Gehani, _Efficient Provenance Alignment in Reproduced Executions_: https://www.usenix.org/conference/tapp2020/presentation/nakamura . Their method compares reproduced execution provenance across program locations, control flow and inputs. This may eventually help **semantic** Ground beyond mere receipt matching, but current DT trace availability, incremental value and permissions are unknown. No separate artifact or implementation proposal is justified yet.

**Publication note:** This research text does not claim GitHub write success, runtime testing, actual DT mission receipt or implementation; those require separately verified evidence.
