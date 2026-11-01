# IS-20261101-002 — Provenance-bound mission-consumption receipts across the Borg Collective

**Scout date:** 2026-11-01 UTC  
**Stage:** UNTRIAGED EXTERNAL INTELLIGENCE. Not a DT implementation instruction, accepted research proposal, authorization grant, or proof that a mission was executed.  
**Original contribution:** A narrowly scoped, falsifiable transfer hypothesis and synthetic verification matrix; no external text or code copied.  
**Previous incoming item:** [IS-20261101-001](IS-20261101-001-versioned-history-replay-compatibility-gate.md), about executable workflow-history replay. This note addresses a **different** problem: evidence that a particular local consumer actually received and acted on an approved mission revision.

## Why investigate this now

The public Director state and mission (read 2026-11-01 UTC) verify the first Internet Scout → Scrapyard Scout → Director research handoff, but do **not** independently establish that a local DT executor consumed a particular GitHub mission revision, adopted a source, changed behavior, or passed held-out Ground. A planning-document acknowledgement is not an authenticated executor receipt. The earlier replay proposal was accepted only for bounded OUTWARD applicability research because executable command replay may not match DT's digest-verified historical record format. Do not use that mismatch as an excuse to weaken the integrity gate.

**Gap mapped:** `COLLECTIVE_HANDOFF_PARTIAL`, especially mission revision consumed → authorized action → observable output → independent verification → feedback. A bounded diagnostic can be tested separately from the unresolved retained-history owner decision. Existing DT receipts/owners may already cover all or part of this; **parity is unverified**.

## Primary sources directly inspected (source claims, not DT evidence)

1. **in-toto Attestation Framework, Statement v1**, official specification: https://github.com/in-toto/attestation/blob/main/spec/v1/statement.md . Directly read the schema and subject rules. A Statement binds a typed predicate to immutable subject artifacts identified by cryptographic digests. A bare Statement is a *claim*; it does not, by itself, establish who made the claim.
2. **SLSA v1.2, Build Provenance**, approved official specification: https://slsa.dev/spec/v1.2/build-provenance . Directly read the model and schema: `buildDefinition`, external inputs, resolved dependencies, `runDetails.builder`, and output subjects provide a structured way to bind an observed result to a specified input revision and claimed producer. This is a *build* model, not a ready-made agent-execution receipt protocol. The proposed DT adaptation is an inference, not a standards requirement.
3. **SLSA v1.2, Verifying artifacts**, approved official specification: https://slsa.dev/spec/v1.2/verifying-artifacts . Directly read verification guidance: independently compare expected inputs and trusted builder identity, verify the signature and output digest, and reject unexpected external parameters. Merely finding a signed or unsigned provenance document is not proof of acceptable execution.
4. **W3C PROV-O Recommendation (2013)**: https://www.w3.org/TR/prov-o/ . Directly read its Entity–Activity–Agent model and `used`, `wasGeneratedBy`, `wasAssociatedWith` relationships. This is a cross-disciplinary scientific-provenance lead for representing a trace from research artifact to decision and outcome, **not** a security/authentication protocol.

**Independent replication:** None performed. No local DT runtime, credentials, signer keys, production logs, or private source copied into this public artifact. These standards do not demonstrate DT already lacks a suitable receipt.

## Proposed mechanism — *only if the existing owner lacks equivalent proof*

Treat the shared GitHub mission as an immutable **input artifact** identified by repository path + exact Git commit/blob digest. Have the already-authorized local executor, if it has a permitted receipt surface, emit a minimal **consumer-side** record that binds:

- expected mission identity/digest and actual digest read by the consumer;
- existing executor identity/trust context (without publishing host identifiers or secrets);
- existing authorized task/decision ID, execution start/end status and outcome classification;
- output/test-evidence digest, independent evaluator ID or reference when available;
- current-stage distinction: `RECEIVED`, `STARTED`, `EXECUTED`, `GROUNDED`, `REUSED`, or `BLOCKED` — never collapse these into `DONE`.

**Critical trust distinction:** A GitHub commit made by the Director proves a mission was published, not that a local worker consumed it. An executor's self-authored file proves only that a file exists. Authenticity requires an existing trusted signing/identity boundary or independent observer; an unsigned synthetic receipt is useful only for diagnosing missing links. Do not add signing keys, network services, an extra controller, or privileged access just to satisfy this experiment. If no trusted receipt facility exists, classify `AUTHENTICITY_UNVERIFIED` and ask the Director to route through existing authorization.

W3C PROV's graph suggests a compact queryable chain (research entity → triage activity → Director decision → mission entity → executor activity → output entity → held-out evaluation), but the graph is *evidence bookkeeping*, not an autonomous improvement by itself.

## Falsifiable OUTWARD → INWARD → GROUND experiment

**OUTWARD / verify first:** In existing DT source/tests, locate any canonical mission consumer, its revision pinning, receipt/acknowledgement owner, and independent result verifier. Compare with current receipt/rollback tests (notably public research offload R-001, R-010 and R-011). If a trustworthy consumed-revision + execution + Ground link already exists, report `ALREADY_PRESENT` and **do not** build a second system. If the mission is not consumed by any accessible local worker, report `DELIVERY_UNVERIFIED`, not a fake successful test.

**INWARD / conditional:** In a permission-safe, isolated synthetic harness reusing the *existing* consumer and evidence owner, submit two distinct mission revisions and bind each emitted receipt to the actual read revision and output digest. No production history mutation, policy relaxation, extra local install or new trust root. The Director must authorize any actual DT changes after research triage.

**GROUND / independent acceptance matrix:**

| Fixture | Required independently checked outcome |
|---|---|
| Approved mission revision A, consumed and successfully executed | A-linked receipt with output/test digest; separate held-out verifier confirms the actual result |
| Mission revision B published but never consumed | No `EXECUTED` or `GROUNDED` receipt for B |
| Consumer reads stale A after B published | Receipt explicitly identifies A; verifier does not misattribute it to B |
| Spoofed or edited receipt, changed output digest | Verification rejects or marks `AUTHENTICITY_UNVERIFIED`; cannot claim success |
| Retry/restart or duplicated event | Idempotent identity, no fabricated second successful execution, preserved previous evidence |
| Approved mission blocked by retained-history/permission guard | `BLOCKED` with no invented output or bypass; protected state unchanged |
| Source rejected during triage or task fails held-out test | Explicit negative disposition, no promoted knowledge/capability |
| Legitimate result reused in a second task | Separate independently observed downstream decision/reuse, not merely a new receipt field |

**Pass criterion:** For at least one actual approved and consumed task, an independent verifier links the exact mission revision to the authorized execution and measurable output/held-out behavior, with all negative controls correctly rejected. The result must beat the existing baseline on *truthfulness/traceability* without violating the same safety and cost constraints. An isolated synthetic pass alone is **not** proof of natural DT autonomy or full Borg assimilation.

**Failure criterion:** If existing DT evidence is equivalent, the proposed extra receipt layer has no justified delta. If the consumer or independent trust boundary is unavailable, mark `BLOCKED/UNVERIFIED`; do not generate more self-attestations and call that success.

## Risks, costs, licensing and research follow-up

- **Threats:** forged executor identity; circular self-attestation; stale SHA; receipts confused with queue membership; leaking private mission contents, local identifiers or secrets; conflating source credibility, authorization, execution, and downstream reuse.
- **Costs:** extra writes and verifier work; measure bounded overhead versus baseline. Preserve the existing single-main, no-loss and rollback contracts. Prefer reusing present evidence owners to inventing new infrastructure.
- **Authority:** No automatic grant to read private host data, change historical integrity policy, sign on behalf of a worker, or modify private DT. Only the Director may promote this into a governed mission.
- **Redistribution:** This is an original short synthesis linking official specifications; no external source texts, figures, binary artifacts or code redistributed.
- **Next Scrapyard Scout action:** Check whether the existing DT receipt owner already captures **consumed mission digest** rather than published planning digest; compare this candidate to R-001/R-010/R-011 and decide `DUPLICATE`, `NOT_APPLICABLE`, or `PROPOSED_FOR_DIRECTOR_REVIEW` with exact existing-code evidence. Director can then prioritize an authorized test, not an implementation commitment.

## Independent frontier examined but not promoted

State-based CRDT synchronization / distributed consistency was sampled from a primary research abstract (https://arxiv.org/abs/1905.08733). It may matter to cross-worker state exchange, but its consensus/consistency assumptions and DT novelty were not evaluated enough to justify a second upload this run. Revisit only if the Director documents an unmet synchronization requirement.
