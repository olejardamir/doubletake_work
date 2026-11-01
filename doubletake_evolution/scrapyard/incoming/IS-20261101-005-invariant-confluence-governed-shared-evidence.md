# IS-20261101-005 — Invariant-confluence boundary for shared evidence versus governed decisions

**Scout date:** 2026-11-01 UTC  
**Stage:** UNTRIAGED EXTERNAL INTELLIGENCE; not a DT implementation task or authorization.  
**Frontier:** Distributed databases, declarative logic, and invariant-preserving coordination.  
**Relevant Director gap:** B4 no-loss shared-state writer contract and collective shared epistemic state. Secondary relation: B7 provenance/reuse. **This does not resolve B1 history integrity or 7.8.1 local mission-consumer evidence.**

## Source provenance and what was actually examined

1. **Peter Bailis, Alan Fekete, Michael J. Franklin, Ali Ghodsi, Joseph M. Hellerstein, Ion Stoica, _Coordination Avoidance in Database Systems_, Proceedings of the VLDB Endowment 8(3), 185–196 (2014), DOI 10.14778/2735508.2735509.** Directly examined the primary publisher PDF (abstract, introduction, invariant examples and method overview): https://www.vldb.org/pvldb/vol8/p185-bailis.pdf . Extended author preprint: https://arxiv.org/abs/1402.2237 . The paper introduces **invariant confluence (I-confluence)**: for specified invariants and operations, separately valid states sharing an ancestor can merge without violating the invariant only for suitable transaction classes. Its experimental performance numbers are from a database prototype, **not** DT and not a forecast for DT.
2. **Peter Alvaro, Neil Conway, Joseph M. Hellerstein, William R. Marczak, _Consistency Analysis in Bloom: a CALM and Collected Approach_, CIDR 2011.** Directly examined the authors' primary PDF, including the description of monotonic versus non-monotonic computations and points requiring coordination: https://people.ucsc.edu/~palvaro/cidr11.pdf . The paper studies declarative Bloom programs; it is not a generic proof that arbitrary multiagent state updates are safe.
3. **Tom J. Ameloot, Bas Ketsman, Frank Neven, Daniel Zinn, _Weaker Forms of Monotonicity for Declarative Networking_, ACM TODS 40(4), 2015, DOI 10.1145/2809784.** Directly examined the institutional author/publication abstract, not the full paper: https://researchportal.vub.be/en/publications/weaker-forms-of-monotonicity-for-declarative-networking-a-more-fi/ . This is important counter-qualification: coordination-freeness characterizations depend on assumptions about data placement and available distribution knowledge. Avoid overselling a simple universal CALM slogan.

**Source-versus-transfer distinction:** The papers establish results for their explicitly defined formal models and benchmark systems. The mapping below to DT's shared research/evidence and authority gates is a Scout hypothesis. Current private DT writer ownership, operation algebra, deployment topology, and measured contention were **not** independently established in this run.

## Mechanism: separate monotone observations from non-monotone authority

A collective may safely accumulate **immutable, uniquely identified evidence observations** (e.g. source references, distinct worker research proposals, independent test receipts) without asserting that these observations grant authority or are true. If each observation is content-addressed, deduplicated, and merged by set union, then duplicate delivery, reordering and replay can be tested for idempotence and convergence. This is a *possible* coordination-avoiding representation, **not proof of durability, authenticity, or no-loss persistence**.

By contrast, **one active owner, approval, exclusive lease, retained-state mutation, budget allocation, revocation, or final capability promotion** may involve non-monotone invariants. Two independently valid local decisions can conflict after merging. Those transitions must preserve existing owner-governed coordination/authorization. A grow-only evidence set is not a replacement for a transactionally safe canonical writer, trusted source identity, or an owner decision.

**Distinctive question:** Could DT allow low-risk distributed *evidence intake* to converge while retaining strict coordination at *authorization/promotion/writer* boundaries, rather than either (a) blocking all observation intake or (b) allowing uncoordinated high-risk writes?

## Precise DT capability-delta hypothesis (falsifiable)

**H-005:** In a permission-safe synthetic two-worker model using DT's *existing* shared-state invariants, a classification of operations into (i) merge-safe evidence additions and (ii) authority-sensitive nonconfluent transitions will either (A) reveal a genuine avoidable coordination bottleneck or (B) demonstrate that existing DT ownership/serialization already handles these cases. The candidate has value **only if** an existing-owner baseline shows a distinct safety or throughput deficiency that the classification could improve without weakening the no-loss contract.

**Hypothesized component mapping (not a code audit):** existing research-intake/evidence index; existing shared-state writer contract; existing Director acceptance and capability-promotion gate; existing independent Ground evaluator. Keep these as separate responsibilities. No new collective controller, alternate ledger, signer, writer, or private host permission is proposed.

**Relation to previous incoming:** IS-20261101-001 is about replay/version applicability for protected history; IS-20261101-002 and -004 about *observing actual local mission consumption* and receipt freshness; IS-20261101-003 about correct target attribution. None evaluates **whether a pair of individually legal concurrent state transitions remains legal when merged**. This is the specific incremental hypothesis, not a rebranding of CRDTs or a claim that DT needs them.

## OUTWARD → INWARD → GROUND: bounded no-production experiment

**OUTWARD — establish current owner and invariant baseline.** In an already authorized isolated/test setting, identify the *existing* canonical shared-state writer and its real invariants, if accessible: no accepted event lost; duplicate IDs not double-counted; no promotion without owner approval; no two conflicting exclusive owners; no mutation of protected history; no stale/forged approval. Record current serialization and error semantics. If the writer contract or permission is unavailable, classify **CONTRACT_UNAVAILABLE** and stop at a paper analysis; do not infer a defect.

**INWARD — classify and test synthetic operations only.** Start with a fixed valid ancestor S. Apply two independently valid operations A and B in isolated replicas, then merge in both orders and with duplicate delivery. Test:

| Synthetic case | Required invariant |
| --- | --- |
| P1: two distinct signed-*as-data*, non-authoritative research observations | Both retained, no implicit approval, convergence under reordering |
| P2: duplicate delivery of the same observation ID | Exactly one logical observation, no duplicate downstream action |
| N1: two incompatible exclusive-owner/lease claims | No silent merged double ownership; existing coordination/denial preserved |
| N2: observation claims approval without the authorized owner | No promotion or execution; evidence-only |
| N3: concurrent budget reservations exceeding a shared cap | No oversubscription; existing coordinated authority needed |
| N4: delayed or missing evidence and an attempted “no contrary evidence exists” decision | UNKNOWN/PENDING, not false finality |
| N5: tampered provenance, stale revision, or changed protected history | Reject or fail closed; no automatic repair or re-seal |

Use deterministic event schedules and crash/restart fixtures if already available. Compare **existing DT baseline** with a *paper/synthetic* classification, not a new production merge algorithm. A synthetic pass alone does not establish actual crash durability, no-loss behavior, or DT capability assimilation.

**GROUND — decision criterion.** Report (1) source/test revision, existing owner, permissions, (2) invariant table and each baseline verdict, (3) any reproducible two-replica counterexample with minimal schedule, (4) loss/duplicate/unauthorized-promotion counts, (5) coordination and memory/latency cost if measured, (6) independent replay/held-out schedule and rollback plan. **Promote for Director consideration only if** there is a real distinct baseline failure or measured avoidable bottleneck and an existing-owner safe improvement; otherwise classify **ALREADY_PRESENT / NO_CHANGE**. Never claim full-Borg Ground without a natural authorized run and independent reuse evidence.

## Risks, limits, licensing, and handoff request

- **Critical safety boundary:** owner authorization, durable no-loss writer, history integrity, and exclusive decisions cannot be inferred from convergent evidence sets. An append-only set can still lose data on crash; immutable evidence can still be false or misattributed. Never bypass B1 or B4 safety stops.
- **Applicability limit:** the formal results require correct specification of invariants, merge operation and transaction set; CALM results depend on formal network/distribution assumptions. Real DT concurrency topology and actual overhead remain unverified. If only a single canonical writer exists, a new replicated state layer would be needless and dangerous.
- **Research cost:** small synthetic fixtures and an owner-source read, not a deployment. No access escalation or live state mutation.
- **Rights:** this is original synthesis with source links only; no full paper, figure, code, or private DT text is redistributed. Publisher VLDB PDF identifies a CC BY-NC-ND license; do not copy it into the public repo.
- **Scrapyard Scout:** compare with existing B4 writer-contract research and current private implementation *if authorized*. Triage as **KEEP_FOR_LATER**, **ALREADY_PRESENT**, or **PROPOSED_FOR_DIRECTOR_REVIEW** only with a specific invariant/counterexample. Director owns any mission change. If current B4 owner contract is unavailable, record the exact missing contract and leave the item unassimilated.
- **Internet Scout follow-up:** seek evidence on whether DT's existing writer is single-owner, event-sourced or replicated; if no independently observable integration point, pivot away from generic distributed-state literature to the exact missing B7 consumer observer. No volume-driven follow-up.

**Status:** Untriaged research lead; no DT code execution, acceptance, approval, or verified capability gain.
