# IS-20261101-003 — Entity-bound evidence: a falsifier for false knowledge assimilation

**Scout date:** 2026-11-01 UTC  
**Status:** UNTRIAGED EXTERNAL INTELLIGENCE; not a Director decision, DT implementation, security claim or completed Ground.  
**Research frontier:** Cross-domain transfer from clinical retrieval-augmented generation (RAG) attribution failures to provenance-preserving knowledge assimilation.  
**Prior incoming items:** [IS-20261101-001](IS-20261101-001-versioned-history-replay-compatibility-gate.md) (historical replay) and [IS-20261101-002](IS-20261101-002-provenance-bound-mission-execution-receipts.md) (mission-consumer proof). This item addresses **correct source-to-target attribution of adopted knowledge**, not receipt authenticity or history replay.

## Current evidence and gap

The public Director STATE and ACTIVE_MISSION read at this epoch report **zero verified complete natural autonomous cycles**; the protected historical-integrity disposition remains owner-pending. Both earlier Scout findings have now been accepted for **OUTWARD planning only**. In particular, 7.8 requests proof of published mission revision -> actual authorized consumer -> independent Ground. No new runtime proof is available to this Scout.

The private DT Borg continuous discovery/assimilation architecture was directly read in its high-impact opening section (blob `4f72e4467c2d87fbe78a1239c59e32b39b182e14`). It explicitly requires human-readable evidence-backed knowledge artifacts and a single governed discovery -> knowledge -> assimilation -> implementation gateway. **The potential failure investigated here is a different gate:** the source is genuine and cited, but the *claim is assigned to the wrong target entity, capability, component or version*. This could yield a convincing yet invalid capability acquisition claim. No DT implementation audit has established whether current checks already prevent it.

## Primary sources actually examined

1. **Caruzzo, Yoo & Kim (2026), _Deceptive Grounding: Entity Attribution Failure in Clinical Retrieval-Augmented Generation_, arXiv:2607.09349 (preprint, 2026-07-10).** https://arxiv.org/abs/2607.09349 . Directly read the arXiv HTML paper's introduction, definition, methodology, results and judge-validation passages. Authors report that cited, otherwise factual evidence for entity Y can be mistakenly attributed to queried entity X. Their controlled study spans 13 models, with a reported deployed clinical RAG measurement and an entity-attribution verifier. **These are author-reported results, not independently replicated here.** The paper's human gold standard is small (88 adjudications with weighting) and inter-judge agreement is only moderate (reported Cohen's kappa 0.415), so claimed detector precision/recall and generality should not be transferred to DT as facts. Its claim that no other framework implements this check is not independently established.
2. **Lee, Lee & Kim (2025), _MAGIC: A Multi-Hop and Graph-Based Benchmark for Inter-Context Conflicts in Retrieval-Augmented Generation_, Findings of EMNLP 2025.** https://aclanthology.org/2025.findings-emnlp.466/ ; DOI: 10.18653/v1/2025.findings-emnlp.466 . Directly reviewed the primary publisher abstract: a knowledge-graph-based benchmark constructs interpretable conflicts across related contexts and reports difficulty locating their exact sources. **Adjacent independent research**, not replication of the clinical paper or evidence of a DT defect.
3. **W3C Trace Context, Recommendation (2021).** https://www.w3.org/TR/trace-context/ . Directly reviewed overview and security sections as mission-linked reconnaissance. It enables correlation of distributed requests, **not trusted proof of mission consumption or authenticity**; the specification warns of spoofed identifiers, privacy leakage and monitoring denial-of-service. Thus it is **not** promoted as a substitute for the Director's 7.8 consumer-side observer. This negative finding avoids a redundant receipt proposal.

## Distinctive transferable mechanism (hypothesis, not a verified DT deficiency)

A source-linked assertion must bind the **subject entity** and the **evidence entity** in addition to preserving the document URL/hash. A valid source about system Y does not substantiate that system X has Y's capability. Analogous confusion may arise with two repositories, two DT components, two versions of a module, or two scientific findings with similar descriptions.

**Possible DT use:** At the existing knowledge reconciliation / Assimilation evidence-check seam, test whether an evidence-backed external note can be correctly rejected when its source pertains to a different target capability or revision, even though the citation exists and the quoted fact is accurate. Preserve useful source material as a separate hypothesis; do not silently adopt it into the wrong target. This is an **evidence validity** test, not an automatic authorization to alter DT.

**Novelty check:** Current public RESEARCH_OFFLOAD and scrapyard INVENTORY do not mention this entity-binding failure or the paper. The private DT code search returned an incomplete/empty result, which is **not proof of absence**. Existing knowledge-provenance/verification may already solve it. The Director/Scrapyard Scout must check the actual owner before considering implementation.

## Falsifiable OUTWARD -> INWARD -> GROUND experiment (permission-safe, synthetic)

**OUTWARD / baseline:** In a disposable, offline fixture, construct two fictional source records, `Component-A v1` and `Component-B v2`, with different capabilities but similar surrounding terminology. Give each an immutable synthetic source ID/digest and explicit subject entity/version. Build a fixed small test matrix:
- **Clean A:** true claim about A with A source -> accept attribution.
- **Clean B:** true claim about B with B source -> accept attribution.
- **Cross-entity swap:** real B claim and B citation presented as A capability -> reject *for A*, without claiming the citation is fake.
- **Cross-version swap:** capability from A v2 claimed for A v1 -> reject for v1 unless independent evidence supports it.
- **Ambiguous source:** source omits target identity -> abstain/require reconciliation, not invent an association.
- **Conflicting sources:** A and B evidence disagree -> preserve both and mark unresolved; do not auto-merge.
- **Missing source / forged digest:** reject on existing provenance rules.
- **No-source ablation:** remove the decisive source and ensure the system does not silently infer the target capability from prior assumptions.

**INWARD / only if a gap is demonstrated:** Compare the current DT knowledge reconciliation, evidence binding and existing verification owners against the same fixtures. First use current checks unchanged; propose the smallest additional subject/revision binding rule only if they fail. Keep source facts distinct from hypotheses and preserve the sole Assimilation gateway. No new parallel evaluator, database, network service or permission boundary.

**GROUND / independently discriminating:** An evaluator other than the proposing scout inspects the exact synthetic input revision, recorded current-check verdicts and post-change verdicts. Success means correct decisions for *each* predefined positive/negative case, including explicit abstention for ambiguity, no false adoption and no regression on clean cases. Compare matched cost and false-rejection behavior; if existing DT checks pass all cases, classify **ALREADY_PRESENT**, do not implement. If changes only alter a prompt or public documentation, classify **NOT GROUNDED**. Repeat on held-out fictional entities not used to develop the check to test transfer, then require actual authorized local DT receipt before claiming any real adoption.

**Independence from current production blocker:** Source review and isolated synthetic fixtures are permission-safe in principle, but local DT execution/assimilation and any private-code change require the existing authorized executor. This proposal cannot clear the owner-pending historical integrity gate or establish a completed natural cycle.

## Risk, licensing and follow-up

- Domain transfer from a clinical RAG preprint to software capability assimilation is speculative; the paper's exact reported rates are **not DT expected rates**. The 2025 benchmark addresses conflict rather than this precise misattribution.
- Subject identity may be composite, aliased or legitimately inherited; simplistic string matching can cause false rejections. Evaluate canonical identifiers, version scope and explicit inheritance, without assuming a universal ontology.
- Avoid sensitive clinical examples in fixtures; use entirely synthetic software components. Do not ingest copyrighted full papers, medical data or private DT logs into the public scrapyard. This file is an original synthesis with links only.
- **Scrapyard Scout request:** source-check, compare against current DT provenance/assimilation owners, mark as `RETAIN_FOR_RESEARCH` or `ALREADY_PRESENT` as evidence warrants. Offer to Director only if the synthetic false-attribution gate is genuinely absent and independently testable. This is **not** a third generic provenance receipt proposal.
- **Internet Scout feedback to seek next:** Director's exact 7.8 consumer-observer outcome and whether existing DT knowledge reconciliation already binds evidence to entity/version. Pivot if this lead is redundant.

**Publication proof:** This section intentionally makes no claim about GitHub commit, implementation, test execution or successful assimilation; those require separate observed evidence.
