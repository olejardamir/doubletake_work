# DT-IP-0003 — Provenance-bound mission consumption and execution evidence

**Status:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW — NOT_EXECUTED. Deferred proposal for a future explicitly user-invoked, authorized DT coder; not implementation permission or evidence of runtime execution.

## Complete public source and provenance

Source: `doubletake_evolution/scrapyard/incoming/IS-20261101-002-provenance-bound-mission-execution-receipts.md`, full Git blob `20dc7c82b0d6fd45827c6d7b1cb1091ee875bc09`, Internet Scout synthesis dated 2026-11-01, stage UNTRIAGED EXTERNAL INTELLIGENCE, on public `olejardamir/doubletake_work/main`. Source: https://github.com/olejardamir/doubletake_work/blob/main/doubletake_evolution/scrapyard/incoming/IS-20261101-002-provenance-bound-mission-execution-receipts.md . Pin revision through Git history before use. Source author directly inspected in-toto Statement v1 (https://github.com/in-toto/attestation/blob/main/spec/v1/statement.md), SLSA v1.2 Build Provenance (https://slsa.dev/spec/v1.2/build-provenance), SLSA verification guidance (https://slsa.dev/spec/v1.2/verifying-artifacts), and W3C PROV-O (https://www.w3.org/TR/prov-o/). These are conceptual references, NOT DT implementations: in-toto statements alone do not authenticate their issuer; SLSA build provenance is not an agent receipt standard; PROV-O graphs are not cryptographic proof. Check live revisions, attribution and licenses; do not copy third-party code/text or publish private identifiers. The source briefly mentions state-based CRDT research (https://arxiv.org/abs/1905.08733) but does NOT justify a separate synchronization implementation.

## Problem, consumer hypothesis and strict preflight

Public mission publication and research handoff are not proof that an authorized DT executor **read** a particular mission revision, acted on it, produced a verifiable result, or reused that result. Hypothetical gap: `COLLECTIVE_HANDOFF_PARTIAL` between mission revision consumed, execution, independent Ground and feedback. Historical public observations are not proof of current private DT gaps. Before any change, future authorized coder MUST inspect CURRENT private DT `AGENTS.md`, source/tests, permissions, actual mission consumer, receipt/acknowledgement owner, identity/signing trust boundary, independent result verifier, rollback/history policy, and public R-001/R-010/R-011; record exact SHAs. Determine whether there is an existing genuine authorized consumer and demonstrable failing behavior. If `ALREADY_PRESENT`, `NO_CURRENT_CONSUMER`, `DELIVERY_UNVERIFIED`, or no permitted trusted receipt surface, STOP/DEFER. Do not create a second receipt authority or infer permission from this prompt.

## Conditional minimal behavior and evidence semantics

Only if a real, owner-approved defect exists, reuse existing receipt and verifier surfaces to bind: (1) expected mission repository/path and immutable Git commit/blob digest; (2) actual digest read by the consumer (not merely Director's published digest); (3) already-authorized task/decision ID and existing executor trust context without leaking host IDs/secrets; (4) start/end and outcome; (5) output/test-evidence digest and independent evaluator reference where available; (6) **separate** stages `RECEIVED`, `STARTED`, `EXECUTED`, `GROUNDED`, `REUSED`, `BLOCKED`. Do not collapse these into `DONE`. Bind research artifact → triage → Director/owner decision → mission revision → consumer activity → output → held-out evaluation → independently observed downstream reuse, distinguishing provenance bookkeeping from trustworthy authorization or execution. Existing interfaces and owners are hypotheses, not verified contracts.

A published commit proves publication only. A self-written receipt proves a file exists only; absent trusted existing signer/identity or independent observation, mark `AUTHENTICITY_UNVERIFIED`. Do not add signing keys, privileged access, new network services/controllers, extra local installations, new trust roots, or unsupported identity claims. Preserve single-main, no-loss, protected history/integrity, permission and rollback contracts; no production history writes or policy relaxation. A retained-history guard yields `BLOCKED`, never a bypass. Rejected research or failed held-out evaluation cannot be promoted as assimilated capability.

## Required reproducible positive and negative tests

With permission-safe isolated **synthetic** fixtures reusing the actual existing consumer/evidence owner, exercise two mission revisions A/B and verify against baseline:
1. Approved A actually consumed and executed: A-bound receipt and output/test digest, independently confirmed by held-out evaluator.
2. B published but not consumed: **no** B `EXECUTED`/`GROUNDED` claim.
3. B published, consumer reads stale A: record actual A; never misattribute to B.
4. Forged/edited receipt, spoofed executor or changed output digest: reject or explicitly `AUTHENTICITY_UNVERIFIED`; do not assert success.
5. Retry/restart/duplicate event: idempotent identity, preserved earlier evidence, no invented second success.
6. Authorized task blocked by permission/retained-history guard: `BLOCKED`, no output fabrication or protected-state mutation.
7. Triage rejection or failed held-out test: negative disposition, no capability promotion.
8. Legitimate second-task reuse: independently observed downstream use, not a self-declared `REUSED` field.

Pass only when at least one actually approved and consumed task is independently linked to exact revision, authorized action and measurable output/held-out behavior, all negative controls rejected, and traceability improves versus baseline without unacceptable privacy/cost/latency overhead. A synthetic-only pass is NOT proof of natural DT autonomy, full Borg assimilation, or end-to-end Ground. Record exact test commands, exit codes, fixtures, output hashes, trusted verifier evidence and permission/owner decisions. If no existing trust boundary, stop at `BLOCKED/UNVERIFIED`, not additional self-attestations.

## Future implementation decision

Future user-invoked coder checks current private source/tests and authorization first; documents `ALREADY_PRESENT` / `NO_CURRENT_CONSUMER` / `DEFER` / reproducible delta. Only then make the smallest permitted change, run real focused and existing tests, and record attributable commit, blob SHAs and independent acceptance. Never infer DT parity, private consumer, signer, execution, owner approval or test result from this public prompt. Original source remains for independent Scrapyard Scout coverage audit/deletion only.
