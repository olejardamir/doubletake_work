# IS-20261101-001 — Versioned event-history replay as a non-mutating compatibility gate

**Scout date:** 2026-11-01 UTC  
**Status:** UNTRIAGED EXTERNAL INTELLIGENCE — not a DT design decision, approved repair, or implementation task.  
**Requested research:** R-SCOUT-01 (bounded, resumable evidence-preserving workflow) and R-SCOUT-02 (authority-safe history diagnosis).  
**Origin:** Internet Scout; original synthesis; no third-party code or paper text reproduced.

## Original sources and what was actually inspected

1. **Temporal, “Event History” (official technical documentation):** https://docs.temporal.io/encyclopedia/event-history — directly read. The service durably records workflow command outcomes as events; replay uses the prior event sequence to recover workflow state after a crash.
2. **Temporal, “Event History walkthrough with the TypeScript SDK” (official):** https://docs.temporal.io/encyclopedia/event-history/event-history-typescript — directly read. It explains how completed activities are not re-executed on replay and shows a deliberately non-deterministic branch that causes command/history divergence.
3. **Temporal, “Safely deploying changes to Workflow code” (official source documentation):** https://github.com/temporalio/documentation/blob/main/docs/develop/safe-deployments.mdx — directly read. Recommends replay-testing representative historical executions before running changed workflow code, with versioning/patching for incompatible changes; explicitly warns about private payloads and deployment constraints.
4. **Temporal, “Python testing / Replay a Workflow Execution” (official source documentation):** https://github.com/temporalio/documentation/blob/main/docs/develop/python/best-practices/testing-suite.mdx — directly read. Provides an actual positive/negative replay-test interface, including a replay error when code is incompatible with recorded history.
5. **Independent curiosity frontier — Zhang et al., “Fault-tolerant and transactional stateful serverless workflows,” OSDI 2020 (Beldi), USENIX primary conference page:** https://www.usenix.org/conference/osdi20/presentation/zhang-haoran — **abstract and publication metadata read; full paper and replication not read.** It describes log-based fault tolerance, transactions, and sovereign state across federated functions, with an evaluation involving 1,000 AWS Lambda functions. This is a research lead, not independently reproduced proof or a reason to adopt its runtime.

Source claims above are descriptions of their own systems. **No independent DT experiment or implementation inspection was performed by this Scout.** Sources were checked on 2026-11-01 UTC; their current revisions should be pinned if promoted.

## Mechanism worth testing

**Separate durable event evidence from executable interpretation.** A workflow stores an ordered record of decisions and externally completed effects. A read-only replayer checks whether a *specific version* of interpretation logic produces a command sequence consistent with that record. External effects must not run again during replay. A candidate update can be evaluated on representative old histories before authorization to change live execution.

This is more precise than merely “save checkpoints”: it gives a falsifiable **compatibility gate** with a deliberately incompatible negative control. It is **not** a way to reinterpret a genuinely corrupted record as valid, skip a cryptographic signature failure, or repair production state without an owner decision.

## DT/Borg relevance and observed limitations

The Director's public 2026-11-01 ~00:28Z state reports a changed loaded generation, three incomplete natural ticks, zero complete, and the same fail-closed historical-integrity refusal; owner disposition remains pending. A DT status report acknowledged a planning mission revision, but a live local execution receipt and full research→DT assimilation→Ground remain unverified.

This candidate may help **R-004** distinguish a version/representation-compatibility hypothesis from truly invalid history in a *sandbox*, and **R-011/R-SCOUT-01** demonstrate a stable source-ID → triage → Director decision → governed receipt chain. The exact DT history verifier, existing replay/compatibility tests, mission consumer and capability propagation hooks must be inspected by the Director/DT before declaring a gap. Existing no-loss safeguards and authorization boundaries remain authoritative.

## Falsifiable capability-delta hypothesis

> If DT lacks a version-aware, non-mutating history-compatibility test at its existing integrity seam, then adding the *minimal native replay-compatibility check* (not a Temporal/Beldi dependency) to a permission-safe fixture harness will classify known compatible versus incompatible histories more reliably than the current baseline, while never accepting intentionally tampered evidence or repeating recorded side effects.

**Outward (research / discrimination):**
- Inspect current DT main's existing verifier, history schema/version tags, replay or migration tests, and evidence-consistency owners. Check whether the capability already exists under another name. Compare with source mechanisms; do not assume missing functionality.
- Produce a synthetic, public-safe fixture set with recorded command/effect receipts. Include at least: 10 compatible old-version histories, 10 intentionally changed-but-legitimate representation histories, and 10 deliberately tampered/mismatched histories. Mark which representation variants are *actually* authorized as compatible; do not relabel arbitrary mismatches.
- Measure baseline classifications, false acceptance/rejection, side-effect replays, runtime and owner interventions.

**Inward (governed, only if an actual gap is verified):**
- Specify the smallest change to the existing verification/test owner. Bind interpreter version and input history digest to a read-only result; compare expected versus emitted decisions; preserve all original bytes. Never mutate/reseal, skip verification, disable safety stops, create a parallel integrity authority, or call a production side-effecting activity.
- Record the research artifact ID, exact source revision, Director disposition, mission SHA and any authorized code change SHA. Separate a documented mission-read from a real executor receipt.

**Ground (independent, held-out):**
- Require 100% rejection of the deliberately tampered histories; require no production-history writes, no duplicate external side effects, and fail-closed behavior on ambiguous provenance. For explicitly compatible histories, measure correct acceptance; for unauthorized representation changes, expect rejection. Compare with baseline rather than declaring success from passing tests.
- Repeat on at least five newly constructed, previously unseen fixtures; independently verify artifact ID → Scrapyard disposition → Director decision → DT receipt → changed behavior → downstream reuse, including a negative-control rejected candidate.
- If there is no verified improvement or the existing mechanism already passes, **reject or defer** rather than adding machinery. Do not advance the protected live-history refusal without owner authorization.

## Risks, limits and transfer conditions

- **Security:** Deterministic replay compatibility is not proof of cryptographic authenticity; a consistent but forged history must still fail integrity checks. A historical mismatch might reflect tampering rather than version drift. Owner disposition remains required.
- **Semantics:** Real LLM calls, clocks, random branches, network actions and external effects are non-deterministic unless their outcomes are recorded or explicitly isolated. Incorrect replay can duplicate work. Event histories have storage/retention limits and privacy implications.
- **Privacy:** Only synthetic/public-safe fixture histories in the public repository. No real user payloads, private DT logs, secrets, or live runtime identifiers.
- **Licensing:** Use original analysis and native DT code only after review; links to Temporal documentation and the Beldi paper are references, not permission to copy code or redistribute PDFs. Verify licenses of any separately considered code.
- **Cost:** This is a bounded compatibility test, not a proposal to deploy Temporal, Beldi or new infrastructure. Full replay may be expensive; compare resource costs.
- **Evidence scope:** Temporal documentation was read directly. The Beldi paper was not read beyond its official abstract and has no independent reproduction in this note.

## Handoff / duplication check

- **For Scrapyard Scout:** Evaluate this stable ID, compare against existing DT replay/integrity tests, and record ACCEPT FOR DEEP TRIAGE / DEFER / REJECT with reason in its owned inventory. If promising, submit an evidence-backed proposal to the Director; do not promote directly to implementation.
- **For Director:** Preserve pending historical-integrity owner decision; use a separate safe synthetic test to prove whether this mechanism adds value. Do not treat the Scout's publication as collective Ground.
- **Known related public work:** RESEARCH_OFFLOAD.md R-004, R-011, R-012, R-SCOUT-01/02; scrapyard/IMPLEMENT_DETERMINISTIC_BORG_COLLECTIVE_RUNTIME_IN_DOUBLETAKE_v4.7.md and DOUBLETAKE_MULTI_SOURCE_ASSIMILATION_FINAL_v3.md describe existing deterministic Borg and assimilation design intentions. Those files were inspected in part; **current private DT implementation overlap remains unverified**.
- **Further frontier:** If this is redundant, inspect Beldi's full OSDI paper and independently reproduced transaction/idempotency mechanisms before proposing any new durable cross-worker handoff protocol.
