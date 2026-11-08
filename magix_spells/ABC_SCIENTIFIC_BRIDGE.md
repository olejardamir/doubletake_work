Author: Damir Olejar

All rights belong to Damir Olejar

# A–B–C Scientific Bridge: A General-Purpose Framework for Evidence-Constrained Translation Between Semantic Frames


> **Status:** Living research manuscript and experiment log (proposal stage; not a validated scientific discovery system)  
> **Canonical source:** `olejardamir/doubletake_work`, branch `main`, `magix_spells/ABC_SCIENTIFIC_BRIDGE.md`  
> **Established:** 2026-11-07  
> **Purpose:** Preserve a publication-ready record of hypotheses, methods, implementations, negative results, evidence and experiments. Update **this exact file** after every worker run. Do not create rotating run-specific Markdown files in this directory.

## Abstract (working)

We propose and study a general-purpose architecture for translating an input expressed in arbitrary semantic frame **A** into an output expressed in independently selected frame **C**, using a scientifically constrained intermediate frame **B**. The system represents source intent, causal roles, conditions, goals, and relations in a structured representation paired with embeddings, attempts alignment to scientific models, corrects scientifically unsupported causal claims, and constructs target-frame output. A dedicated quality-assurance loop then interprets the generated C output back into B for factual and mechanistic consistency checks. Failure can trigger local revision in C, further scientific correction in B, reanalysis of A, alternate scientifically evidenced mechanisms, or a documented abstention. Scientific validity is not inferred from vector similarity, and approximate back-translations must not be treated as mathematical inverses. The initial motivating domain is the transformation of magical spells into operationally meaningful, scientifically defensible rituals; the proposed architecture must generalize to other A and C frames. **No empirical effectiveness or system autonomy is claimed until independently reproducible evaluations are run.**

## 1. Research question and hypotheses

**Main question.** Can a system reliably preserve the purpose and relevant semantic relations of an arbitrarily framed input while replacing unsupported mechanisms with defensible scientific ones and expressing the result in an independently chosen target frame?

- **H1 — Frame generality:** A and C can differ, and a frame-independent core with modular adapters will outperform a spell-specific lookup-and-template pipeline on held-out frame combinations.
- **H2 — Science-grounded correction:** A structured evidence-backed B representation reduces unsupported causal mechanisms versus a geometry-only embedding alignment.
- **H3 — Bidirectional quality control:** Checking C by extracting and revalidating its claims in B reduces scientific drift and practical-instruction errors relative to a single-pass decoder.
- **H4 — Adaptive fallbacks:** Choosing repairs by error type improves acceptance rates per unit computation over unconditional repeated generation.
- **H5 — Calibrated abstention:** Rejecting unsupported or infeasible requests is preferable to inventing a scientifically justified result.

These are **hypotheses**, not experimental findings.

## 2. Formal problem definition

Input tuple `(x_A, F_A, F_C, constraints)`, where `x_A` is source text/artifact, `F_A` is its observed source frame, and `F_C` is the desired output frame. Both frames can be specified or inferred; when inference is uncertain, record alternatives.

1. `G_A = Parse(x_A; F_A)`: structured representation of agents, goals, events, objects, predicates, intentions, temporal relations, causal assertions, assumptions, and uncertainty.
2. `z_A = Encode(G_A, x_A; F_A)`: embedding(s), with explicit graph anchors so relational information is not assumed to survive pooling.
3. `(z_B, G_B) = Align_{A→B}(z_A, G_A)`: science-frame hypotheses. **No assumption of exact invertibility.**
4. `(z_B*, G_B*, P) = Correct_B(z_B, G_B, evidence, physical/logical constraints)`: best supported feasible mechanism, explicit provenance `P`, and uncertainty. Reject when defensible translation is absent.
5. `y_C = Decode_C(z_B*, G_B*; F_C, contract_C)`: independently selected target-frame artifact.
6. `(z'_B, G'_B) = Audit_{C→B}(y_C)`: independent extraction and verification of all operational and scientific claims from generated C.
7. `QC(y_C, G_B*, G'_B, G_A, contract_C, P)`: independent hard and soft gates; accept, repair C, revise B, reinterpret A or abstain.

**Warning:** If A and C are different frames, the B→C map is *not* an inverse of A→B. Even in same-frame tasks, scientific correction changes information; no general exact inverse exists. Geometry-preserving rotations can measure distances but do not establish truth.

## 3. Architecture

```text
A: arbitrary input frame
      │  recognize frame, infer goal, extract causal/relational graph
      ▼
Latent/structured A representation ── alignment/provenance ──▶ B candidate
                                                              │
                                     scientific evidence + hard constraints
                                                              ▼
                                                     B* corrected model
                                                              │
                                           independent C-frame decoding
                                                              ▼
C candidate ───────────────▶ independent C-contract QC + C→B re-interpretation
     ▲                                 │                 │
     │                                 │                 ├─ scientific drift: revise B*
     │                                 ├─ format defect: repair C
     │                                 └─ source misread: reinterpret A
     └───────────────────────────────────────── bounded retry with audit trail
```

## 4. Scientific frame B: truth, evidence and uncertainty

B must contain mathematically/logically explicit claims when possible; physical and empirical mechanisms must be tied to traceable, authoritative sources. Not all scientific claims are provable true; distinguish theorem, model prediction, well-supported empirical result, preliminary finding, hypothesis, contested claim, and unknown. Record assumption dependencies, contraindications/limitations and situations where no scientific counterpart exists.

**Prohibition:** A scientifically plausible *description* is not evidence that an actual ritual is efficacious. Decorative candles, incantations and symbols may be kept for C-frame fidelity but must not be misrepresented as operating mechanisms.

## 5. Target-frame C contract and quality-control loop

C is arbitrary and independent of A. Examples: magic spell → concrete spell; myth → technical field guide; fictional claim → scientific explanation; metaphor → engineering checklist; folklore → risk-reduction protocol.

The contract must validate syntax, genre conventions, audience, operational completeness and intended effect. For `C=magic spell`, require: (a) intended effect, (b) safe real materials with meaningful quantities/conditions where justified, (c) specific actions in coherent order, (d) incantation/ritual presentation, and (e) realistic constraints/disclaimer. Do not invent dosages, prescriptions or unsupported efficacy.

**Hard QC gates:** source-grounded scientific claims and actual evidence/limitations; safety; no coercion; no factual contradictions; operational accuracy when instructions are given; abstain on unfixable tasks.

**Soft QC metrics:** semantic-role/goal retention, output-frame fit, readability, minimal unnecessary deviation, specificity, elegance, concision.

**Initial bounded fallback policy (to be empirically optimized):**
- Output frame/style or missing ritual steps → revise C using unchanged verified B*.
- Claimed facts differ from B*; unsupported instruction; invented mechanism → audit C in B; update B and re-decode C.
- Wrong intended goal/ambiguous original → reinterpret A and recompute B; document uncertainty.
- Candidate science mechanism infeasible → search alternate scientifically supported candidates, otherwise abstain.
- Compare multiple candidates against a frozen independent rubric. Initial experimental budget: up to 3 candidates per stage, 4 C-only revisions, 2 B revisions. Limit recursion and report nonconvergence.

## 6. Benchmark and evaluation protocol (pre-registration draft)

Freeze and version benchmark sets **before** implementation changes. Hold out different frame pairs, unseen goals and new lexical styles. Negative controls must include scientifically impossible, hazardous and ambiguous inputs.

| Benchmark | Frame A | Frame C | Expected evaluation target |
|---|---|---|---|
| Pink candle to attract love | magical spell | magical spell | consensual relationship opportunities; no guaranteed attraction |
| Eye of newt for potency | magical spell | magical spell | do not prescribe medications; scientifically defensible explanation with medical constraints |
| Thistledown against bites | magical spell | field-guide procedure | real insect-bite prevention; verified label-compliant directions |
| Flight by incantation | magical spell | engineering specification | physical feasibility and energy/force constraints; abstain if goal cannot be met |
| Myth of a storm deity | mythology | science explainer | meteorology; no fabricated cause |
| Heat as an angry spirit | metaphor | safety checklist | thermodynamic hazard control without anthropomorphism |
| Newly constructed held-out example | novel source frame | independently chosen C | measure true generalization beyond spell mappings |

**Required baselines:** unchanged reproduction of the existing toy seeded system; direct LLM rewrite without a scientific intermediate; A→B→C without C→B QC; A→B→C with adaptive fallback. Reject self-scored success as sole evidence; use deterministic checks, trustworthy references and human/independent grading for scientifically consequential claims.

**Measure separately:** claim evidence support rate, false scientific claims, role-preservation consistency, C-format validity, actionable-instruction accuracy, safety violations, abstention precision, generalization across frame pairs, and candidate cost/run time. Report denominator, confidence/uncertainty and failure cases. Orthogonal projection/inverse numerical error is **only** an algebraic diagnostic, not a truth metric.

## 7. Prior state / baseline and limitations

Initial project materials are stored in ChatGPT Library `/SpellScienceLab/README.md` and `/SpellScienceLab/seed_v0.zip`. Prior interaction described prototypes relying on hand-built intent categories, synthetic alignments and curated scientific substitutions. Their numerical inverse precision and illustrative transformed spells are **not independently verified in this document** and must not be reported as evidence of automatic science discovery.

New scientific validity, new embeddings, trained alignment, independent evidence retrieval and robust cross-domain acceptance gates are **not yet demonstrated**.

## 8. Methods and reproducibility requirements

Every run should document:
1. Date/time and code/data version or SHA.
2. Precisely one development hypothesis and what was actually changed.
3. Source frame A, target frame C, input and frame contracts.
4. B candidates, supporting sources with access dates and contraindications/uncertainties.
5. Corrected B* (or documented abstention).
6. Output C; extraction back to B'; QC outcome, errors and fallback steps.
7. Commands/execution environment and exact test metrics with sample counts.
8. Comparison against unchanged baseline and frozen hold-out cases; failure analysis.
9. Acceptance/rejection decision, next hypothesis and limitations.

No run may be labeled a tested improvement unless code actually executed and results were checked. When a worker cannot write to GitHub, its report must explicitly say no canonical manuscript update occurred; never present a local or Library-only draft as a GitHub commit.

**v0.20 population-scope preflight (2026-11-08).** The accepted v0.19 temporal-numeric guard delegates to the existing population parser only for direction-reversal alerts. Consequently, unequal percentages across explicitly different populations can still be labeled `review`. This increment wraps v0.19 with a conservative preflight: only when v0.19 returns `review`, compare explicitly extracted `among ...` population spans; if only one is present, abstain (`population_scope_unknown`); if both differ, abstain (`population_mismatch`); otherwise retain the original result. This is a lexical scope safeguard, not a scientific entailment model. The five diagnostic tests were authored before the new module was written, but are developer-designed and not independent held-outs.

## 9. Experimental results

**Latest engineering result (v0.8, 2026-11-07):** Evidence-provenance preflight added; 40/40 combined unit tests passed, unchanged known benchmark 40/40 and challenge 11/15. **Zero scientifically verified claims** because source authentication and passage entailment are not implemented. See the eighth experiment log entry for scope and limitations.


**Engineering result, 2026-11-07 (fourth increment):** A conservative, non-annotated surface-pattern claim extractor passed 6/6 new unit tests. On four separately inspected sentences it extracted 2 and rejected 2; these examples are not a held-out scientific benchmark. It detects simple grammatical assertions, not scientific truth or complete natural-language claims. Earlier suites were not rerun.

**Engineering result, 2026-11-07 (third increment):** Conservative explicit-annotation text parser passed 8/8 new tests. It abstains on missing or malformed claim annotations and returns matching claims for further evidence verification, but it cannot extract arbitrary natural-language scientific claims. Prior 16 tests were not rerun in this increment.

**Engineering result, 2026-11-07 (second increment):** A deterministic structured C→B claim-ledger checker passed 9/9 new tests (16/16 including prior tests). It detects unsupported or contradictory annotated claims but does not extract claims from language or validate scientific evidence. See the second experiment log.

**Engineering result, 2026-11-07:** A generic frame-contract and bounded fallback-routing prototype passed 7/7 unit tests. These are structural/control-flow checks, **not** independent scientific validation or proof of autonomous A→B→C translation. See the chronological log for test scope, mock-oracle limitations and reproducibility. This section will be filled with reproducible results, figures and negative findings as work proceeds. Earlier demonstration spells are illustrative, not proof of scientific effectiveness.

**v0.20 (2026-11-08):** `python -m unittest discover -p 'test*.py' -q` executed **49/49 tests passed**, versus 44/44 in the archived v0.19 run (five added tests). Before change, `Mosquito bites decreased 12% among children in 2022` versus `Mosquito bites decreased 20% among adults in 2022` yielded `review/numeric_disagreement_scoped`; after change it yields `abstain/population_mismatch`. Same-population numeric disagreement remains `review`; one-sided population mention abstains; same-population direction reversal and different-year cases retain previous behavior. No independent scientific claims verified (0→0), no genuine A→B→C translations or B↔C fallback executed. One inherited test emits an unclosed-file ResourceWarning; test pass is not evidence of production robustness.

## 10. Discussion and threats to validity (working)

- Mapping source-frame semantics to a scientific ontology can lose context and causal roles.
- Evidence retrieval can be wrong, incomplete, conflicting or outdated.
- Empirical science yields conditional evidence, not universally decidable truth.
- Translating B into C may introduce new claims, change the goal or lose limits.
- Self-evaluation is vulnerable to answer contamination and circular grading.
- Exact mathematical inversion may be impossible, particularly when A≠C or unsupported claims are intentionally removed.
- A harmless ritual aesthetic must not be confused with an efficacious procedure.
- Some target frames and goals are incompatible with safety or scientific feasibility; honest refusal/abstention is a necessary system output.

**v0.20 interpretation:** The change reduces one demonstrable scope-related false alarm on developer-authored examples. It cannot establish that a population parser recognizes arbitrary demographic expressions, that an abstention is calibrated, or that evidence supports either claim. Scope parsing remains brittle (e.g., syntactic variants, overlapping populations). Highest-priority gap: an independently annotated, immutable claim–evidence benchmark with population, measurement, time, causal scope and abstention labels, evaluated blind to implementation.

## 11. References and evidence ledger

**To be populated with verified bibliographic entries and source URLs when used in actual experiments.** Never fabricate references. Maintain a claim-to-source table in this section, including date retrieved, source type, and explicit limitations.

## 12. Chronological experiment and development log

### 2026-11-07 — Research architecture and canonical manuscript established

- Changed scope from `spell → scientificized spell` to arbitrary `A → scientific B → arbitrary C`.
- Specified independently selected C frame, scientific verification and C→B audit, bounded differentiated fallbacks, and abstention.
- Initial baseline remains unverified for autonomous generalization; no numerical or scientific performance claims made.
- **Development target:** implement A/C frame contracts and frozen cross-frame test cases first, then evidence-grounded B verification and back-translation quality control.
- **Manuscript policy:** Future hourly cycles must fetch and append/update **this exact Markdown file on `main`**, using GitHub's current blob SHA and sequential commits. Preserve this document as the single cumulative research paper and log; do not fragment into per-run `.md` files.

### 2026-11-07 — First executed implementation: configurable frame contracts and bounded fallback routing

**Development hypothesis (engineering only).** Frame-specific output requirements and scientific validation can be separated so that C-only formatting failures do not unnecessarily trigger a B revision, while scientifically unverified outputs cannot pass merely by satisfying C structure.

**Implementation.** A small standard-library Python prototype `frame_contracts.py` introduces immutable `FrameContract(name, required_fields)` and `audit(candidate, contract, science_checker)`. The scientific checker is an **injected external function**, not a scientific model. It returns whether a candidate was independently verified. The audit routes a missing C field to `repair_C`, a negative science-check result to `revise_B`, and only accepts a candidate when both gates pass. `bounded_fallback` invokes separate supplied C repair and B revision functions, with initial limits of four C repairs and two B revisions, then abstains. Contracts are provided for spells, field guides and science explainers; source-frame A is not used to select a target-frame contract. The initial `science_checker` in tests is a controlled boolean oracle, not evidence retrieval.

**Execution and result.** In a local Python standard-library environment, executed `python -m unittest -v test_frame_contracts.py`: **7/7 unit tests passed**, with no test failures. Tests exercised (i) three A/C pair configurations including spell→field guide and myth→science explainer, (ii) science failure overriding complete C format, (iii) missing C field routing, (iv) successful C-only repair, (v) successful B revision, (vi) bounded scientific abstention, and (vii) bounded structural abstention. These are **routing/contract tests only**, not seven valid scientific translations, and they do not measure accuracy of embeddings, actual scientific correction, or quality of generated prose.

**Observed fallback traces (deterministic mocked tests):**
- Spell A → field-guide C with a missing `steps` field and externally marked verified B: `repair_C → accept`. Repair fills the missing field with a generic label-directed placeholder; it is **not a complete evidence-reviewed field guide**.
- Myth A → science-explainer C with an initially false external verification flag: `revise_B → accept` after a mock revision flips the flag. **No real scientific correction occurred.**
- Unverifiable claim: `revise_B → revise_B → revise_B → abstain` (two actual revisions followed by final rejected check).

**Reproducibility.** Source/test/log archive: ChatGPT Library `/SpellScienceLab/abc_frame_contracts_v0_1.zip`; SHA-256 `c783916a6815cac19f0c3b434d7726fad4cb5504a7af30d5215a528a86cc4193`. Archive contains `frame_contracts.py`, `test_frame_contracts.py` and `test_log.txt`. The original `seed_v0.zip` remains unchanged. This accepted **engineering increment** does not imply that the scientific translation pipeline works end to end.

**Limitations and next experiment.** The prototype operates on structured dictionaries and boolean-oracle checks, not actual vector embeddings or an evidence-backed scientific model. It does not parse A, generate C, back-translate C to B, or independently validate claims. Next: implement independent C→B claim extraction and evidence-linked hard gates; freeze a genuine held-out A×C evaluation set before introducing learned embeddings.

### 2026-11-07 — Second executed increment: independent structured claim-ledger audit

**Engineering hypothesis.** Comparing independently supplied C-claim annotations with the B claim set and an evidence ledger can detect output claim drift without relying on the same boolean oracle used by the C generator. This is an intermediate quality-control layer, **not** autonomous scientific fact-checking.

**Implementation.** Added `claim_audit.py` with immutable `EvidenceRecord(claim_id, proposition, polarity, source, status)` and `audit_claims(b_claims, c_claims, ledger)`. Each C claim must be represented in B, agree on polarity, and have a `supported` evidence-ledger record with nonempty provenance. Unsupported C-only claims, contradictory polarities, missing source and unknown evidence route to `revise_B`; omitted B claims route to `repair_C`. An empty B claim set fails closed, avoiding vacuous acceptance. This audit works on structured annotations supplied by independent components; **it does not parse natural language, validate URLs or establish whether ledger evidence actually supports a proposition.** The previous frame-contract prototype remains unchanged.

**Execution.** In a Python standard-library environment, ran `python -m unittest -v test_frame_contracts.py test_claim_audit.py`. **16/16 unit tests passed**: seven prior routing/contract tests plus nine new claim-audit tests (supported claim, hallucinated claim, polarity conflict, omitted B claim, missing provenance, unknown evidence, different frame, C claim absent from B, and empty claims). Tests use a fixed illustrative ledger with example EPA/NOAA source URLs; those URLs were **not fetched or independently checked in this experiment**. Hence no empirical scientific accuracy rate is inferred. Test scope is deterministic engineering behavior only.

**Observed cross-frame mock traces.**
- A=magical protection, C=field guide; B says `bite_reduction=True`; C says `bite_reduction=True` plus `miracle=True`. Audit returns `revise_B` and identifies `miracle` as unsupported. This does **not** produce a finished field guide.
- A=storm mythology, C=science explainer; B and C both say `storm_caused_by_deity=False`, matching a preannotated ledger. Audit returns `accept` for structured consistency only, not independently verified meteorology.
- A=magical protection, C=field guide; B says `bite_reduction=True`, C omits it. Audit returns `repair_C`, preserving B for a target-frame repair.

**Reproducibility.** Source and test archive in ChatGPT Library: `/SpellScienceLab/abc_claim_audit_v0_2.zip`. SHA-256: `b901f628621f4ae41b4c2fc7b20aca659500d352e5ef52f2e11bcd29650378dc`. Archive contains `frame_contracts.py`, `test_frame_contracts.py`, `claim_audit.py`, `test_claim_audit.py`, `test_log_v0_2.txt`. The earlier `abc_frame_contracts_v0_1.zip` remains preserved.

**Limitations and decision.** Accepted as a strictly scoped **engineering increment**. No actual A→B learned vector transformation, natural-language C→B extraction, external source verification, autonomous C generation, or end-to-end scientific correction is demonstrated. Next experiment: independently extract atomic claims from C and B, then verify retrieved evidence with traceable passages rather than relying on prefilled ledger status flags. Freeze evaluation samples before building the extractor.

### 2026-11-07 — Third executed increment: conservative text-to-claim annotation parser

**Engineering hypothesis.** A deliberately fail-closed extractor can detect explicitly annotated claims in generated C text and prevent unparsed or contradictory annotations from silently passing the existing structured claim audit. This is a step toward C→B extraction, **not** natural-language scientific claim understanding.

**Implementation.** Standard-library Python `claim_extraction.py` recognizes whole-line syntax `CLAIM[claim_id]: TRUE|FALSE | proposition`. It extracts claim identifiers, boolean polarities and exact proposition strings from C text, detects duplicate and malformed annotations, compares extracted claims to a supplied B claim dictionary, and routes extra or contradictory claims to `revise_B`, omissions to `repair_C`, and matching annotations to `needs_evidence_verification`. Free-form unannotated prose cannot be independently extracted; it is **not accepted** as verified science. Matching claim annotations do not establish truth, since provenance and evidence are still unverified.

**Execution and reproducibility.** Executed `cd /mnt/data/abc_v03 && python -m unittest -v test_claim_extraction.py`: **8/8 new tests passed**, including a different-frame field-guide example, duplicate/malformed annotations, unsupported additions, polarity disagreement, omitted B claims, unannotated prose and matching claims. This run did **not** rerun the prior 16 tests; therefore **24/24 cumulative tests is NOT claimed**. Code, tests and execution log: ChatGPT Library `/SpellScienceLab/abc_claim_extraction_v0_3.zip`, SHA-256 `d2a412be050e3a3f332eb35e6b205937781ce50e8a2584e8f91c4f233b1b3a72`.

**Observed cross-frame trace.** A=magical insect protection, C=field-guide text containing `CLAIM[bite_reduction]: TRUE | Repellents reduce bites`; when supplied B has the same annotation, output is `needs_evidence_verification` (NOT accepted). Adding `CLAIM[miracle]: TRUE | Guaranteed` without B support routes to `revise_B`. A=storm mythology, C=science explanation with `CLAIM[storm]: FALSE | Deity caused storm` likewise requires independent evidence verification before acceptance.

**Negative result / validity limitation.** This parser handles only intentionally machine-annotated lines, not ordinary language or latent vectors. Unannotated scientific assertions elsewhere in C can be missed, and exact proposition comparison can flag harmless paraphrases. The benchmark is a developer-authored structural test, not frozen unseen evaluation or independent scientific truth assessment. The safe outcome for a matching annotation is pending verification, never an automatic scientific acceptance. **Next experiment:** freeze independently authored natural-language C samples and assess claim-extraction recall and false negatives, then retrieve and check authoritative evidence passages for each atomic claim. No claim of autonomous A→B→C transformation is made.

### 2026-11-07 — Fourth executed increment: ordinary-text claim extraction feasibility probe

**Engineering hypothesis.** A fail-closed ordinary-text extractor can identify a narrow class of explicit causal and outcome assertions without requiring `CLAIM[...]` annotations, while flagging unrecognized syntax for review instead of silently accepting it.

**Implementation.** Standard-library `abc_claim_probe_v04.py` uses a deliberately constrained regular-expression grammar to identify short English subject–predicate–object assertions, including simple negative predicates. It returns `Claim(subject, predicate, object, polarity, sentence)` objects and a separate list of rejected sentences. It is a stand-alone experimental probe, **not integrated into the accepted C→B audit**. Rejected text must not pass the scientific hard gate; even extracted claims require external evidence checks. In particular, matching a surface pattern is not semantic parsing.

**Execution.** Ran `cd /mnt/data && python -m unittest -v test_abc_claim_probe_v04.py`: **6/6 new tests passed**. Tests cover simple reduction, guarantee, negation, unparsed metaphor, mixed parsed/unparsed input, and multiple sentences. A separate four-sentence manual inspection gave: `Repellents reduce mosquito bites.` → 1 extracted; `Candles guarantee love.` → 1 extracted; `When rain falls, the sky weeps.` → rejected; `The storm god sent thunder, which shook the village.` → rejected. **This is not an accuracy estimate:** the examples were developer-authored and inspected in the same run, with no independent annotation or frozen hold-out set.

**Failure modes and significance.** Negation handling is rudimentary; syntactic variants, embedded clauses, quantifiers, modality, coreference, hedging, temporal and conditional scope, passive voice and multiword predicates are not reliably parsed. A detected claim may still be scientifically false (e.g. `Candles guarantee love.`). The extraction probe deliberately fails closed on unknown syntax but is not a validated scientific checker. Previous 7+9+8 tests were **not rerun** and no combined suite result is claimed.

**Reproducibility.** Archive: ChatGPT Library `/SpellScienceLab/abc_claim_probe_v0_4.zip`, SHA-256 `0896e3dfda4627c5f82dd99fde0ceb88c11e534fdde07a460893f49a73bc75ca`. Includes `abc_claim_probe_v04.py`, `test_abc_claim_probe_v04.py`, `abc_probe_test_log_v04.txt`. Standard library only.

**Decision and next experiment.** Accept only as a separately versioned engineering feasibility probe, **not** as an end-to-end or scientifically validated pipeline improvement. Freeze independently annotated natural-language sentences with cross-domain linguistic variation and measure recall/precision and abstention before integrating; then add evidence retrieval and passage-level entailment checks.


### 2026-11-07 — Fifth executed increment: versioned ordinary-language extraction stress benchmark

**Question and frozen input.** How much ordinary-language scientific assertion coverage does the previously accepted v0.4 conservative parser achieve on broader syntax? Created a versioned **40-sentence developer-authored benchmark** before running evaluation: 25 positive assertive statements (including uncertainty, negation, relative clauses, passive voice, numbers and conditional statements) and 15 negative examples (questions, requests, imperatives, wishes and fragments). Gold labels distinguish *whether a statement asserts a claim*, not whether that claim is scientifically true. Benchmark source SHA-256: `4df953b2991159743d86e8538d9c25c21dc904a7773da4fb5fd43ab972e31774`. Labels were created by the developer, **not independently annotated**; benchmark is a reusable versioned diagnostic set, not an independent blinded holdout or publication-quality evaluation.

**Implementation and executed commands.** Kept `abc_claim_probe_v04.py` unchanged. Added `benchmark_v05.py` (40 fixed sentence/label pairs) and `evaluate_v05.py` (deterministic confusion matrix, case-level predictions and JSON output). Executed `python evaluate_v05.py` and `python -m unittest -v test_abc_claim_probe_v04.py` on the archived v0.4 source in a Python standard-library environment. All **6/6 existing v0.4 tests passed**. The 40-case evaluation completed; it was **not** 40 passed unit tests.

**Observed results, n=40.** True positives 17; false negatives 8; false positives 0; true negatives 15. Assertion extraction **recall = 17/25 = 68.0%**, **precision = 17/17 = 100%** and specificity = 15/15 = 100% **on this particular authored set**. Precision is not evidence of scientific truth, and the small hand-built sample does not justify generalization. The 8 misses include `Mosquitoes may transmit infections.` (modal), `Some insects carry viruses.` (unrecognized verb), `A storm was caused by rising air.` (passive), `The test reduced symptoms by 20%.` (numeral), `If the temperature rises, pressure may increase.` (conditional), `Repellents work only when applied correctly.` (adverbial condition), `The candle, which burned brightly, did not change feelings.` (relative clause), and `No study has demonstrated this effect.` (perfect tense). These are **documented false negatives** and must not be treated as safe evidence-based acceptance.

**A/B/C implication and failure route.** For A=magical insect protection and C=field-guide instructions, the ordinary C sentence `Mosquitoes may transmit infections.` is not extracted into B by v0.4. Correct behavior is **fail closed → request a stronger C→B parser or review**, not `accept` and not silently dropping the safety-relevant claim. For A=storm mythology and C=science explanation, `A storm was caused by rising air.` similarly remains unparsed; a B scientific check cannot be claimed. These are real parser outputs but **not end-to-end A→B→C experiments**.

**Decision.** Accept the **benchmark and measurement harness only** as a research/reproducibility increment; do not promote the v0.4 extractor to independently reliable scientific QC. No trained semantic alignment, external evidence entailment, autonomous source parsing, C generation, or validated scientific correction was added. The next engineering experiment should compare a new parser with this frozen benchmark **without editing its labels**, add genuinely independent annotations and held-out frame pairs, and measure both recall and harmful false acceptance. Re-run the full historical suites when integration becomes possible.

**Artifact.** ChatGPT Library `/SpellScienceLab/abc_claim_benchmark_v0_5.zip`, SHA-256 `1d447e721e78f2a86d36df48798f4a5f0eeef9636874682ad2b542ee510f7c27`; contains the unchanged v0.4 parser and six tests, fixed benchmark, evaluator, full case-level JSON and executed log. No other repository file was modified in this increment.


### 2026-11-07 — Sixth executed increment: broader assertion grammar and post-development challenge

**Question.** Can a bounded grammar extension improve detection of ordinary-English assertions in C without silently treating wishes, questions or instructions as factual claims? The previous v0.4 extractor had 17/25 true positives and 0/15 false positives on the versioned 40-case developer-authored benchmark. The benchmark file was retained byte-for-byte (SHA-256 `4df953b2991159743d86e8538d9c25c21dc904a7773da4fb5fd43ab972e31774`).

**Implementation.** Created `abc_claim_probe_v06.py` as a separate experimental parser, leaving the v0.4 baseline untouched. Added more modal, passive, perfect-tense and outcome predicates; preserved explicit `conditional` and `relative` scope tags; and introduced early rejection of questions, wishes and imperatives. Each extraction returns surface subject/predicate/object, polarity, original sentence and scope label. These are **syntactic approximations**, not semantically verified causal graphs. In particular, a predicate such as `may` or `has` can be mistakenly treated as the main causal predicate, and the `conditional` tag does not preserve the complete antecedent. Such outputs must **never** be promoted directly to scientific B claims.

**Execution and comparison.** Ran `python evaluate_v06.py`, `python eval_challenge_v06.py`, and `python -m unittest -v test_v06.py test_abc_claim_probe_v04.py` in a Python standard-library environment. **15/15 unit tests passed** (9 new tests plus 6 unchanged v0.4 tests). On the same **40 previously known, developer-authored cases**, baseline v0.4: TP=17, FN=8, FP=0, TN=15 (recall 68%, precision 100%). Candidate v0.6: TP=25, FN=0, FP=0, TN=15 (recall 100%, precision 100%). **The 100% result is in-sample engineering coverage, not independent validation**: all eight misses were already documented and visible before the parser revision. It is not a credible estimate of general-language performance or scientific truth.

**Additional challenge and negative findings.** A separate 15-case developer-authored challenge was assembled **after** implementing the candidate, so it is not a blinded or independently annotated held-out set. Candidate v0.6 correctly classified **11/15** (7/11 assertions detected, 0/4 nonassertions falsely accepted). Four false negatives were: `A trial showed a 12% reduction.`, `Birds fly south in winter.`, `Because the sun rose, temperatures increased.`, and `No study found a benefit.`. The first 40-case score therefore overstates linguistic generality. No claim-level scientific evidence was retrieved, no source entailment was tested, and no autonomous A→B→C translation was run.

**Cross-frame implications and fallback.** For A=magic mosquito protection and C=field guide, `Mosquitoes may transmit infections.` now produces a syntactic claim candidate, but its modality and scientific content still require external B verification; it is **not accepted**. For A=storm myth and C=science explanation, `A storm was caused by rising air.` likewise yields a candidate, not a scientifically verified explanation. When the parser rejects `Because the sun rose, temperatures increased.`, the C→B gate must **fail closed** and request a better parser or human verification, rather than silently accepting C. These are extraction examples, **not complete transformed C artifacts**.

**Decision.** Accept v0.6 **only as a versioned experimental grammar candidate** with measured coverage gains on known cases; retain the previous accepted QC boundary because the new parser is neither integrated nor scientifically validated. Next: independently label unseen cross-domain examples; compare structured semantic role/modality extraction with the grammar baseline, assess false acceptance and connect claims to actual evidence passages before integrating C→B hard gates.

**Reproducibility.** ChatGPT Library archive `/SpellScienceLab/abc_claim_probe_v0_6.zip`, SHA-256 `4cb53161bbf35b554b95fccc0f5c5782d81e34b65baa918fccabe12557a8e5af`. It includes both parsers, unchanged frozen 40-case benchmark, evaluation scripts, 15-case challenge, case-level JSON outputs, unit tests and executed log. Only this manuscript was changed in GitHub.


### 2026-11-07 — Seventh executed increment: fail-closed semantic-scope hazard audit

**Research question.** Does the existing v0.6 ordinary-text assertion extractor preserve enough truth-conditional information to permit downstream B verification? A previously documented limitation is that it treats modal auxiliaries such as `may` as main predicates, and does not preserve complete conditional antecedents. A candidate claim can therefore be syntactically detected but semantically incomplete. The new experiment adds a separate conservative **scope-risk audit**, rather than overfitting the 40 known benchmark sentences to improve detection counts.

**Implementation.** Created standard-library `abc_scope_guard_v07.py`, operating on the unchanged v0.6 `extract` output and original sentences. It tags negation, modality, conditionality, quantification, attribution, comparison, and auxiliary-as-predicate hazards. It also scans **rejected** sentences for hazards, to avoid treating missing parsing as evidence of absence. The audit returns `requires_review` whenever unparsed sentences or these scope risks are detected. Otherwise it returns `candidate_only`, **never `verified`**. This guard does not resolve the scopes; it flags when the current representation is inadequate. Its patterns are conservative heuristics, not a syntactic or semantic parser, and are vulnerable to both false alarms and missed constructions.

**Executed tests.** Ran `python -m unittest -v test_scope_guard_v07.py test_v06.py test_abc_claim_probe_v04.py`: **27/27 passed** (12 new guard tests, 9 v0.6 tests, 6 v0.4 regression tests). Re-ran unchanged `python evaluate_v06.py` (40 known authored sentences: v0.6 TP=25, FN=0, FP=0, TN=15) and `python eval_challenge_v06.py` (11/15 correct, 4 false negatives). The detection scores **did not improve**; this increment adds a conservative risk signal, not a better extractor. The tests are developer-authored and do not constitute independent evaluation. No new held-out sample was available. The guard's 12 passing unit tests do not estimate its sensitivity on arbitrary text.

**Concrete C→B examples and fallback.** For A=magic insect protection and C=field guide, `Mosquitoes may transmit infections.` is extracted by v0.6 but the guard reports `requires_review` with `scope_modality` and `auxiliary_as_predicate`; this should route to a better B claim reconstruction or human review, **not automatic scientific acceptance**. For A=weather myth and C=science explanation, `If the temperature rises, pressure may increase.` is flagged for conditionality, modality, and auxiliary predicate. `Birds fly south in winter.` is still unparsed and fails closed. By contrast, `Candles guarantee love.` returns `candidate_only` with no scope hazard, demonstrating that **scope auditing cannot establish scientific truth** and requires an independent evidence gate. These are individual C-sentence checks, **not generated A→B→C transformations**.

**Decision.** Accept the scope guard as a **separately versioned experimental safety diagnostic**, not as an integrated or independently validated scientific verification module. It preserves the existing QC hard boundary: even `candidate_only` claims require independently retrieved scientific evidence, applicability checks and entailment validation. There is no measured improvement in end-to-end translation, no proof of trained semantic alignment, no validated autonomous B correction, and no source-supported scientific acceptance.

**Reproducibility.** ChatGPT Library `/SpellScienceLab/abc_scope_guard_v0_7.zip`, SHA-256 `2d8b9a39429928700239e999e48bea1f2a815cee9a33a747df51245eb48ee090`; archive contains unchanged v0.4/v0.6 parsers, frozen benchmark and challenge, new scope guard, 12 new tests, historical tests, execution log and manifest. The initial test attempt failed because an attribution sentence was rejected before scope tags were attached; implementation was corrected to scan rejected text, and the full 27-test suite then passed. This development-time failure is retained here for transparency.

**Next experiment.** Independently annotated cross-domain claim spans and scope labels, with an evidence-retrieval/entailment verifier. Measure false scientific acceptance, not just assertion detection. Test whether scope guard blocks known semantic corruption without excessive abstention; no publication-level effectiveness claim until independent annotation and reproducible source-backed evaluation.


### 2026-11-07 — Eighth executed increment: evidence-provenance gate and external-verification boundary

**Research question.** Can the C→B audit distinguish syntactic claim detection from scientific acceptance, and reject fabricated-looking evidence records without granting truth merely because a citation field is populated? The prior v0.7 scope guard deliberately never marked any claim verified. This increment adds a strict **evidence record completeness and provenance preflight** but explicitly does not attempt autonomous scientific entailment or authenticate sources.

**Implementation.** Created `abc_evidence_gate_v08.py` (standard library) and `test_evidence_gate_v08.py`. Each extracted claim must have exactly one matching `EvidenceRecord` with the original claim sentence, HTTPS URL without embedded credentials, nontrivial quoted evidence passage, access-date field, reviewer identifier, explicit `independently_confirmed` status and scope-compatibility flag. The gate rejects missing, ambiguous or unmatched records, malformed URLs, missing passages, absent provenance, unreviewed evidence, and scope mismatch. It composes the v0.7 scope guard, so unparsed or scope-risk sentences remain review-required. **Critical trust boundary:** all of these fields are caller-supplied and unauthenticated. Therefore even a perfect-looking record is `requires_review` with `external_authentication_and_entailment_unverified`; no automatic `verified` or scientific acceptance path exists. This prevents metadata laundering, but it is not a scientific truth verifier. HTTPS is a syntax gate, not proof of credibility. Exact sentence matching is deliberately conservative and fails on paraphrases.

**Executed commands and results.** Ran `python -m unittest -v test_evidence_gate_v08.py test_scope_guard_v07.py test_v06.py test_abc_claim_probe_v04.py`: **40/40 passed** (13 new, 12 scope-guard, 9 v0.6, 6 v0.4 tests). Reran `python evaluate_v06.py`: unchanged authored 40-case benchmark, v0.6 TP=25, FN=0, FP=0, TN=15; baseline v0.4 TP=17, FN=8, FP=0, TN=15. Reran `python eval_challenge_v06.py`: unchanged **11/15** correct with four false negatives. These are developer-authored tests and known benchmark examples, **not blinded or independent scientific validation**. The 13 new tests check missing evidence, plausible-looking but unverified evidence, no verification state, false magical claim, unparsed input, modal risk, insecure URL, too-short passage, scope mismatch, extraneous record, duplicate record, empty input and unreviewed evidence.

**Cross-frame examples and fallback behavior (sentence-level only).** A=magical insect protection, C=field-guide text: `Repellents reduce mosquito bites.` is parsed, but with no evidence record it returns `requires_review` due to `missing_or_ambiguous_claim_evidence`. Supplying a fabricated example.org HTTPS passage and an `independently_confirmed` string still returns `requires_review` due to `external_authentication_and_entailment_unverified`. Correct route: return to B for authenticated source retrieval, independent passage-to-claim entailment and applicability checking, then regenerate C if B changes. A=storm mythology, C=scientific explanation: `Mosquitoes may transmit infections.` illustrates scope risk (not topical meteorology) and is rejected for review even if a passage is supplied; no semantic cross-domain generation was executed. A better meteorology case, `If the temperature rises, pressure may increase.`, is likewise marked scope-risk by the unchanged guard. These checks exercise C→B quality-control boundaries, **not a complete A→B→C system**.

**Limitations and decision.** Accept v0.8 as a versioned **experimental evidence-provenance preflight**. It intentionally accepts **zero** claims as scientifically verified because no independently authenticated evidence retriever, source validation, or entailment model exists. Passing unit tests means the gate rejects designed bad records; it does not measure evidence-verification precision or real-world false-acceptance rates. The component is not integrated into a full frame-transformer, and the author-provided reviewer flag is not proof of independent review. Next experiment: implement and evaluate actual passage retrieval with independently sourced evidence, claim-level contradiction/entailment labels and blinded held-out examples; maintain fail-closed behavior when evidence is missing.

**Reproducibility.** ChatGPT Library `/SpellScienceLab/abc_evidence_gate_v0_8.zip`, SHA-256 `66343e500e59e94c481787951e4058b7c664b163adc1308a550fdd95e1e30e34`. Contains the unchanged historical parsers, frozen benchmark and challenge, new gate, 13 new tests and full execution log. No GitHub code files or unrelated repository files changed.


### 2026-11-07 — v0.9: source-passage authentication preflight (ninth increment)

**Research objective.** Distinguish a source passage actually appearing in retrieved page text from a passage merely supplied in an unverified evidence record. This is a narrow *provenance/authentication* improvement, not a scientific entailment checker, trained embedding alignment, or full A→B→C pipeline.

**Implementation.** Added `abc_source_auth_v09.py`, a fail-closed `authenticate(text, records, fetcher)` stage that calls the unchanged v0.8 evidence gate, uses an injected trusted source-fetch adapter, extracts visible HTML text (excluding scripts, styles and noscript), normalizes whitespace/case, checks exact normalized passage occurrence, records authentication count, and *always* returns `requires_review` with `scientific_entailment_not_verified`. Fetch errors, non-text responses, missing passages and absent fetch adapters fail closed. The direct `fetch_public_https` stub intentionally refuses live fetching without a proxy enforcing DNS/IP/redirect restrictions, to avoid SSRF and false source-authentication claims. The trusted fetcher is a test seam, not an authenticated external retrieval system. HTML parser is deliberately basic and not robust to all page formats or scripts.

**Executed evaluation.** `python -m unittest discover -p 'test_*.py' -v`: **49/49 passed**, nine new tests plus 40 prior regression tests (v0.8: 40/40). Tests include matching passage in visible HTML, absent passage, script-only passage, fetch timeout, absent fetcher, refusal of unprotected direct network fetch, HTTP rejection, non-text response, and empty evidence records. `python evaluate_v06.py`: known 40-case authored benchmark unchanged (v0.6 TP=25, FN=0, FP=0, TN=15); `python eval_challenge_v06.py`: **11/15** unchanged, with four known misses: “A trial showed a 12% reduction,” “Birds fly south in winter,” “Because the sun rose, temperatures increased,” and “No study found a benefit.” These are **not independent held-out scientific-validity results**. No external sources were retrieved or independently authenticated in this increment, and **0 scientific claims were verified**. The new tests used injected local HTML fixtures, not live HTTPS sources.

**Two-frame illustrative QC scenario, not an executed end-to-end translation.** A=magical mosquito-protection charm, C=field-guide instructions. C candidate `Repellents reduce mosquito bites.` plus a claimed source passage is checked for actual passage occurrence. If the passage appears in a trusted adapter's returned visible HTML, the passage-occurrence count increases, but the C→B evidence gate **still fails closed** because scientific entailment, applicability, source identity and independent reviewer verification are unresolved. If absent, route back to B for source correction. A=storm myth, C=science explanation is a distinct frame-pair candidate, but no complete A→B→C execution was performed. There is no empirical fallback improvement claim.

**Decision, limitations and next experiment.** Accept v0.9 only as an experimental source-passage preflight with a stronger provenance boundary; retain prior claim extraction and fail-closed evidence decisions. Production-grade source retrieval requires an SSRF-safe fetch proxy, trustworthy scientific-source identification, independent claim-to-passage support/contradiction labels and evaluation on held-out, externally annotated examples. Matching text on a page is not proof that the source supports a claim. No general-purpose embeddings, scientific correction or fully autonomous transformation have been demonstrated.

**Durable reproducibility artifact.** ChatGPT Library `/SpellScienceLab/abc_source_auth_v0_9.zip`, SHA-256 `c90178e80df17ed4807a7fabee44a6036646eb6aaabff73cf9f8b78cc8f190ee`; includes code, nine new tests, all historical regression scripts, benchmark outputs, full test log and machine-readable status. No unrelated repository paths or GitHub Actions were modified.


### 2026-11-07 — v0.10: entailment-baseline falsification audit (tenth increment; no model promotion)

**Question and hypothesis.** Could exact passage–claim matching serve as a conservative *acceptance* criterion for scientific entailment? The v0.9 source preflight establishes passage occurrence but not support; this audit explicitly separates lexical identity, proposition-level entailment and empirical truth. The null baseline accepts only a case/whitespace-normalized exact string match. This is an intentionally weak comparator, not a proposed scientific verifier.

**Executed local test.** A ten-pair developer-authored probe was evaluated with Python 3 using `' '.join(text.lower().split())` on each passage and claim and equality as the decision. Three identical positive pairs and seven nonidentical negative pairs yielded TP=3, TN=7, FP=0, FN=0 (10/10; 100% on this *constructed* probe). Negative examples deliberately varied modality (may versus unqualified), numerical quantity (12% versus 20%), negation, universal quantification, and domain scope. The score is **not** a held-out result, independent annotation, generalization, scientific truth, or evidence of an improved verifier: the labels were constructed to match lexical identity. The probe provides no support for accepting this baseline as an entailment gate.

**Falsification and decision.** The equality baseline has a structural false-negative problem: a passage such as “In the trial, bite counts were lower in the treated group” can support a cautiously phrased claim such as “The intervention reduced bites in that trial” without any string identity. Conversely, even an identical sentence on an untrustworthy webpage can be false. Therefore exact matching cannot substitute for independent source authentication, context-aware claim–passage inference, or scientific appraisal. **No production logic was changed or promoted; v0.9 remains the last accepted code checkpoint.** No prior 49-test suite or 40/15-case extractor benchmarks were rerun in this increment. Zero claims were independently verified.

**Illustrative two-frame workflow (not an executed end-to-end run).** A=mosquito-protection charm, C=field guide: a cited source sentence and a generated repellent claim may match verbatim, yet the scientific gate must still abstain until source authenticity, context, effect magnitude and applicability are checked. A=storm myth, C=scientific explanation: a quoted explanation of thunder could be text-identical to a claim yet still require credible meteorological sourcing. Neither example establishes a working A→B→C conversion or successful C→B fallback.

**Next discriminating experiment.** Freeze an independently labeled claim–passage dataset containing paraphrases, contradictions, scope qualifiers, numbers, negation, and deliberately false identical statements; compare exact-match baseline with a separate entailment evaluator and a source-trust gate. Record sensitivity, specificity, calibration and false-acceptance rate, with abstention on unresolved evidence. The first acceptance condition is no unsafe or unsupported claim passing the hard gate; do not optimize solely for high benchmark accuracy.

**Reproducibility note.** Local Python 3 expression: `cases=[(passage,claim,label),...]; pred=lambda p,c:' '.join(p.lower().split())==' '.join(c.lower().split())`. The ten developer-authored cases and labels are described by category and counts here; this is an exploratory audit without a versioned Library code artifact. No claim of durable Library persistence is made for this increment.


### 2026-11-07 — v0.11: conservative lexical contradiction alarm (eleventh increment)

**Hypothesis and implementation.** A small, explicitly non-entailing preflight can flag some numeric, negation and modality differences between a proposed C claim and a supplied B evidence passage without ever granting scientific acceptance. Added `abc_contradiction_alarm_v11.py` with `assess(passage, claim)`. It tokenizes text, compares numeric tokens when both sides contain numbers, compares explicit negation and modal-token sets when at least two lexical tokens overlap, and returns either `review` with a discrepancy reason or `abstain` with `no_independent_entailment`. **There is deliberately no verified/accepted output.** This is an alarm for further B examination, not semantic contradiction detection or scientific verification. The same wording can be false; different wording can be entailed. Numeric comparison is deliberately crude and cannot compare units, confidence intervals, negation scope or arithmetic. Token overlap is not a reliable semantic alignment method.

**Reproducible execution.** Materialized the prior accepted `abc_source_auth_v0_9.zip` and original `seed_v0.zip` from ChatGPT Library, and read `ABC_SCIENTIFIC_BRIDGE_SPEC_v1.md` and `README.md`. Ran `python -m unittest discover -p 'test_*.py' -v`: **57/57 passed**, eight new tests and 49 historical tests. An initial test run failed 1/57 because the new tokenizer's numeric regex was double-escaped; corrected the regex and reran successfully. New cases: differing 12%/20% claims (review), negation mismatch (review), may/unqualified modality mismatch (review), identical false magical assertion (abstain), paraphrase (abstain), empty input (abstain), unchanged numeric-free assertion (abstain), and identical modal assertion (abstain). `python evaluate_v06.py` returned exit 0 and reproduced known benchmark TP=25/FN=0/FP=0/TN=15 for v0.6, versus v0.4 TP=17/FN=8/FP=0/TN=15; `python eval_challenge_v06.py` returned exit 0 and reproduced 11/15. The environment emitted an unrelated spreadsheet-runtime warmup traceback on stderr during these evaluations, but both scripts printed the expected results and exited 0; logs preserve this warning. No new held-out corpus or independent annotation was introduced. No scientific claims were independently verified (0). Compared with v0.9, the new measurable engineering change is eight passing discrepancy-alarm tests, **not an increase in scientific acceptance or evidence accuracy**.

**Two distinct frame-pair illustrations (QC inputs, not end-to-end generated translations).** A=protective magic charm, C=field guide: evidence passage `The trial found 12% reduction` versus C claim `The trial found 20% reduction` yields `review:numeric_disagreement`; the proper fallback is C→B for the original trial's actual measure, scope and source authentication, not a guessed number. A=storm myth, C=scientific explanation: `Thunder may follow lightning` versus `Thunder follows lightning` yields `review:modality_disagreement`; it identifies a possible loss of qualification, not the actual meteorological truth. Identical text such as `Candles guarantee love` remains `abstain`, illustrating that lexical agreement never passes the science gate. No C→B revision was executed, so fallback effectiveness is unmeasured.

**Decision and limitations.** Accept only as an experimental **fail-closed preflight** accompanying v0.9; no change to production scientific acceptance logic. All newly authored tests were visible to development; generalization is untested. Missing claims, paraphrases, quantifier scope, causal direction and domain evidence remain unresolved. Next highest-priority measurable gap: independently annotated claim–passage support/contradiction dataset with source provenance and held-out false-acceptance rates, followed by source-grounded entailment evaluation and actual A×C translation tests.

**Durable supporting artifact.** ChatGPT Library `/SpellScienceLab/abc_contradiction_alarm_v0_11.zip` (SHA-256 `0191f82221b00e93423f5e720b9f783533d99ec8c1a1b9c27709dc894fc7fb35`), containing the versioned new source/test, historical v0.9 suite, logs, evaluation outputs and machine-readable status. No other GitHub path or worker was modified.

### 2026-11-07 — Twelfth executed increment: numeric-context preflight and negative controls

**Question.** Does the v0.11 lexical contradiction alarm over-flag unrelated numeric measurements, and can a conservative context preflight reduce these false alarms without accepting any claim as scientifically verified?

**Implementation.** Added separate experimental `abc_numeric_scope_v12.py`, wrapping the unchanged v0.11 alarm. A numeric disagreement is sent for contradiction review only when each statement contains exactly one numeric mention, units match, and at least two non-stopword lexical context terms overlap. Otherwise the outcome is **abstain** (not support, acceptance, or scientific contradiction). The change deliberately prioritizes avoiding misleading contradiction labels over recall. This lexical overlap is not semantic entailment and can still mis-handle paraphrases, percentages versus percent wording, scope, and multiple metrics.

**Executed evaluation.** Extracted the last archived v0.11 source and ran `python -m unittest discover -p 'test*.py' -v`: **65/65 tests passed** (57 archived tests plus eight new). A four-pair, developer-authored diagnostic (not independent or held out) gave baseline v0.11 **1/4 correct** vs candidate **4/4 correct** for the narrow expected decision *numeric contradiction review versus abstention*. Three baseline false review alarms involved different outcome metrics, different units, and multiple numeric contexts; candidate abstained in all three. One shared-metric 12% versus 20% discrepancy still routed to review. These figures are not scientific accuracy or generalization measurements; zero claims were independently scientifically verified.

**Cross-frame implication (illustrative, not an executed end-to-end translation).** A=magical mosquito protection, C=field guide: B passage `Mosquito bites decreased 12%` versus C claim `Mosquito bites decreased 20%` routes to numeric contradiction **review**, requiring B reconsideration. A=storm mythology, C=science explainer: B passage `Rainfall increased 12%` versus C claim `Temperature increased 20%` lacks matched metric context and **abstains**, rather than asserting a contradiction. Neither example establishes a scientific mechanism or produces verified C output. No B↔C correction loop was executed.

**Decision and limitations.** Accept as an isolated fail-closed engineering preflight, not an evidence validator. No real embeddings, independent evidence retrieval, scientific entailment, operational decoder, or held-out A×C assessment. The unchanged v0.11 alarm remains available as baseline. Next measurable gap: obtain independently annotated claim–passage pairs with matched and mismatched quantities, paraphrases, negation and causal scope; compare review precision and missed contradictions, then integrate with source-authenticated evidence.

**Reproducibility.** Library `/SpellScienceLab/abc_numeric_scope_v0_12.zip` (SHA-256 `14f578f062e2cf987232b6cb534d0e8b12b93f376e1dbf6f4f80ad82e728c823`), including implementation, eight new tests, prior alarm source/tests, full 65-test log and status JSON. No unrelated repository paths were modified.


### Experimental method: directional consistency of quantitative claims (v0.13; 2026-11-08)

**Question.** Does a conservative lexical preflight detect an opposite trend when a generated C claim repeats the same numerical quantity and outcome as a B passage? Previous v0.12 numerical checking abstained on `Mosquito bites decreased 12%` versus `Mosquito bites increased 12%` because the numbers matched; this is a concrete missed contradiction alarm, not proof of scientific falsity.

**Implementation.** `abc_direction_guard_v13.py` wraps v0.12 and uses a restricted direction lexicon (increase/rise versus decrease/decline). It emits `review: direction_reversal_same_quantity` only when both sides contain exactly one identical numeric quantity, compatible units, at least two overlapping non-stopword metric tokens, unambiguous opposed direction, and the earlier check did not already require review. Otherwise it retains the previous decision; `review` means further scientific scrutiny, not a verified contradiction or source truth. This is a deliberately narrow, auditable safeguard, not learned semantic alignment.

**Executed evaluation.** From the durable v0.12 archive, extracted the four Python source/test files and executed `python -m unittest discover -p 'test*.py' -v` after adding v0.13 source and nine new developer-authored tests. **25/25 tests passed**, comprising 16 archived v0.11/v0.12 tests plus nine new tests. The historical **65-test** figure reported in v0.12 cannot be independently reproduced from that archive alone because it contains only 16 prior tests; therefore this run does **not** claim 74/74 or 65/65 regression coverage. Baseline on the specific same-quantity reversal: v0.12 **abstain**, v0.13 **review**. The nine new tests cover reversed direction, direction paraphrases within the small lexicon, unchanged direction, unrelated outcomes, unit mismatch, ambiguous mixed direction, differing numbers and multiple numeric contexts. No held-out or independently annotated accuracy estimate; **zero independently verified scientific claims**. No genuine A→B→C decoder or B↔C correction loop was executed.

**Illustrative cross-frame implications, not executed translations.** A=mosquito-protection charm, C=field guide: if a hypothetical B source says `Mosquito bites decreased 12%` but the field guide says `Mosquito bites increased 12%`, the numeric-direction preflight now requests B review. A=storm myth, C=science explanation: `Rainfall decreased 12%` versus `Temperature increased 12%` is not a matched outcome and the guard abstains. Neither example establishes source support or causal efficacy. Fallback is only a **routing signal**, not a successful correction.

**Limitations and decision.** Accept as an isolated, fail-closed experimental preflight, not a scientific evidence gate. Lexical overlap can conflate populations, periods or interventions; percentage points, negation scope, comparative baselines and paraphrases remain unresolved. The next measurable gap is an independently annotated claim–passage benchmark with genuine evidence provenance and matched outcome/time/population, measuring both missed contradictions and false review alarms. Supporting archive: Library `/SpellScienceLab/abc_direction_guard_v0_13.zip` (SHA-256 `8b0dab350c194ae842610303f1ae054c8488cfb8bca68387b8a143dd54809dc0`), containing source, nine new tests, prior archived code/tests, actual test log, status JSON and source hashes. No unrelated GitHub paths changed.


### Experimental method: population-context mismatch guard (v0.14; 2026-11-08)

**Question and prior failure.** Does the v0.13 numeric-direction preflight falsely request scientific contradiction review when source and generated claim refer to different populations? Example: source `Mosquito bites decreased 12% among children`, output `Mosquito bites increased 12% among adults`. The original v0.13 alarm emits `review: direction_reversal_same_quantity` despite differing populations. Review is not an assertion of falsity, but this is an avoidable false review alarm.

**Method.** A developer-authored seven-case diagnostic set was written before candidate implementation and stored as `frozen_context_cases_v14.json`. The new `abc_context_guard_v14.py` wraps the unchanged v0.13 implementation and checks explicit mismatched population descriptors in two limited groups (children/adults, urban/rural). If the underlying direction alarm requests review and the descriptors disagree, it downgrades to `abstain: population_mismatch`. It also labels differing explicit years `abstain: time_mismatch` when the earlier guard already abstains. It never promotes an abstention into verified scientific support, and it leaves other prior decisions unchanged. This is hand-authored context syntax, **not** a trained mapping, an evidence verifier or a scientifically grounded A→B→C conversion.

**Executed evaluation.** Ran `python -m unittest discover -p 'test*.py' -v` on the extracted v0.13 archive plus new code and tests: **28/28 tests passed**, consisting of 25 archived tests and three new test methods (one parameterized over seven diagnostic cases). On the seven developer-authored diagnostic cases, baseline v0.13 status classification was **5/7** correct and v0.14 was **7/7** correct; this is a **+2/7** within-set improvement, not a held-out accuracy estimate. Two original false review alarms involving explicit population mismatches became abstentions. Cases with differing years were already abstentions, with improved diagnostic labeling in one case. An explicit negative test confirms that unseen descriptors (`seniors` versus `toddlers`) still cause a false review alarm; thus no generalization is established. No independent scientific claims were verified (0); no genuine embeddings, evidence retrieval, frame decoder or B↔C repair was executed.

**Illustrative A→B→C implications (not executed).** A=protective charm and C=field guide: a hypothetical B observation `Mosquito bites decreased 12% among children` must not be judged contradictory to a C sentence about adults solely on direction; v0.14 abstains. A=storm myth and C=science explanation: a rainfall claim in 2022 cannot be equated with a 2023 observation; the existing multi-number preflight abstains, and v0.14 labels the year mismatch. These are structural consistency examples only, not scientific causal evidence. No C→B correction occurred; the fallback outcome was **abstention**, not repair.

**Decision and limitations.** Accept as a narrow fail-closed engineering diagnostic, not as an independent scientific quality gate. The lexicon omits many populations, synonyms, age brackets and intersectional contexts; unmentioned population or time remains unknown. The diagnostic set was developer-authored and seen during implementation. Future work requires independently annotated evidence/claim pairs with population, time, intervention, outcome and uncertainty scope, and measured false-review versus missed-contradiction rates. Supporting archive: Library `/SpellScienceLab/abc_context_guard_v0_14.zip` (SHA-256 `4353b14656fc42290b442fd86609c14021086c5211e5caf97e2f6a105648a47a`), containing implementation, archived regression sources, frozen diagnostics, actual test log, hashes and machine-readable status. No unrelated GitHub files modified.


### Increment v0.15 — explicit population-scope abstention (2026-11-08)

**Research question.** Can a fail-closed, non-scientific contradiction preflight avoid false alarms when two numerically identical, direction-opposed observations refer to different explicitly named populations, without inventing scientific support? This is an engineering diagnostic, not an independently verified A→B→C transformation.

**Pre-implementation frozen diagnostic.** Six developer-authored cases were saved in `frozen_population_cases_v15.json` before implementation. They include seniors versus toddlers, patients versus volunteers, women versus men, identical seniors, an explicit population versus an unspecified population, and no population in either statement. The v0.14 baseline returned the expected status *and reason* for **2/6** cases. These are visible development examples, not independent held-out evidence.

**Change.** Added `abc_population_scope_v15.py`, a wrapper around unchanged v0.14 `context_guard`. Only when the prior detector reports `review: direction_reversal_same_quantity`, it parses an explicit phrase following `among` (up to three words). If both claims have explicit but unequal phrases, it returns `abstain: population_mismatch`; if only one specifies a population, it returns `abstain: population_scope_unknown`; otherwise it preserves the earlier result. It never upgrades a claim to scientifically supported, and does not infer whether two population descriptions overlap. In particular, this literal phrase comparison can incorrectly abstain on synonyms or overlapping populations. This is a narrow conservative scope filter, **not** semantic understanding, trained alignment, or scientific entailment.

**Executed tests and quantitative result.** Command: `python -m unittest discover -p 'test*.py' -v` from the extracted v0.14 archive plus the new files. **29/29 unittest methods passed** (28 archived plus one parameterized test covering all six frozen cases). Frozen diagnostic exact status/reason agreement: **v0.14 2/6 → v0.15 6/6 (+4/6)**. No independent scientific claims were verified (**0**); no real scientific retrieval, embeddings, C decoder, or B↔C correction was executed. The previously reported historical 65-test suite was not available in this archived checkpoint; 29/29 must not be represented as a complete historical regression.

**Illustrative cross-frame implications, not executed end-to-end.** A=protective spell, C=field guide: B passage `Mosquito bites decreased 12% among seniors` versus C claim `Mosquito bites increased 12% among toddlers` now yields `abstain: population_mismatch`, not a direct contradiction finding. A=storm myth, C=science explanation: claims about rainfall among different explicitly described groups would similarly require applicability review; this was not tested with a full A→B→C transformation. **Fallback:** abstention at the scope guard, no C→B repair performed.

**Limitations and next experiment.** Exact surface `among` extraction misses `in children`, `for older adults`, relative clauses and more complex scope; literal mismatch does not imply disjoint populations. These are developer-labeled cases and do not measure independently annotated scientific accuracy. Next priority is an externally annotated claim–passage corpus with intervention, outcome, population, time, uncertainty and contradiction labels; measure false alarms and missed contradictions against the unchanged baseline before replacing the rule with a grounded model.

**Reproducibility.** Library archive `/SpellScienceLab/abc_population_scope_v0_15.zip`, SHA-256 `358a9b6457e1492a57bafdff66434d4aeb0ec229647bba4e2c5d610405a81ee7`, contains source, frozen diagnostics, inherited regression files, test output and `status_v15.json`. The manuscript remains the sole canonical research Markdown document in `magix_spells/`; no other repository path changed. The original author and rights header was checked byte-for-byte before this edit.


### Research increment v0.16 — archived regression provenance and test-count audit (2026-11-08)

**Question and motivation.** Earlier reports cited a 65-test regression suite, whereas the v0.15 accepted archive includes only 29 discoverable unittest methods. This increment tests whether the actual archived tests can be enumerated reproducibly without equating developer-authored subtest examples to independent scientific evidence. This is a reproducibility/integrity improvement, not a new scientific entailment or frame-translation mechanism.

**Method and implementation.** Added `abc_archive_audit_v16.py`, which parses archived `test*.py` files using Python's AST, records each unittest method ID and reports a separate limitation about subtests. It never uses claimed totals as input to the measured count. Added two tests: one confirms that four subtest iterations inside a single unittest method count as one method, and the other checks an empty directory. The previous v0.15 source and tests remain unchanged. No hard-coded scientific claim or output intervention was added.

**Execution.** In the extracted v0.15 archive plus the new auditor and tests, ran `python -m unittest discover -p 'test*.py' -q` (exit 0; **31 tests passed**, 29 inherited + 2 new). Ran `python abc_archive_audit_v16.py > archive_audit_v16.json`: **31 test method IDs** enumerated. The historical 65-test suite is **not reproduced**. This count is a source-level inventory, not a measure of independent test examples, scientific correctness, or semantic generalization. A ResourceWarning occurred in the test log; no test failed. Previous v0.15: 29/29 archived tests; current v0.16: 31/31 archived tests; **delta +2 tests, zero measured scientific accuracy change**. Independent source-verified scientific claims: **0 before, 0 after**.

**A→B→C illustrations (not end-to-end tests).** A=protective spell, C=field guide: a purported mosquito-protection effect would need an evidence-constrained B mechanism before any field-guide action can pass; this increment does not perform that conversion. A=storm myth, C=science explanation: causal claims would likewise need scientific checking, not a test-count audit. **Fallback:** no C→B fallback was executed; this audit cannot determine whether one is warranted. No C output was accepted or rejected by a scientific gate.

**Interpretation and limitation.** The archived test count can now be independently inspected and distinguished from historical assertions. This does not restore missing regression files, provide held-out external annotations, validate source entailment, or establish the A→B→C system. The next priority remains a frozen, externally annotated claim–evidence dataset, including scope, time, population and causal contradictions, followed by a reproducible evidence-based evaluation and no-fallback comparison.

**Durable artifact and reproducibility.** `/SpellScienceLab/abc_archive_audit_v0_16.zip` (SHA-256 `d577482e2ae942d617c9a688b096eba470489bd19a87475a25281df95c7a0636`) includes inherited and new source/tests, `archive_audit_v16.json`, `run_v16.log`, and `status_v16.json`. Uploaded to Library successfully. No other GitHub path or automation was modified.


### Research increment v0.17 — conservative year-scope preflight (2026-11-08)

**Motivation and hypothesis.** Numeric and direction alarms can compare claims from different years as though they referred to one observation. A narrow temporal-scope preflight was evaluated to abstain when explicit years differ, are missing on one side, or are ambiguous. This does not infer scientific truth or support from text.

**Implementation.** Added `abc_temporal_scope_v17.py`, which delegates to the accepted v0.15 population-scope guard when no years appear or when one explicit year appears in both passages and matches. For differing years it returns `abstain/time_mismatch`; for a year missing from one side `abstain/time_scope_missing`; for multiple years `abstain/time_scope_ambiguous`. This conservative rule can over-abstain on longitudinal studies, and only handles four-digit years (1900–2099), not date ranges, durations or temporal paraphrases. It is a **preflight**, not a scientific evidence verifier.

**Actual execution and results.** Ran `python -m unittest discover -p 'test*.py' -q`: **33/33 unittest methods passed**, compared with 31/31 archived in v0.16 (+2 methods). The inherited tests remained unchanged. On six developer-authored temporal diagnostic cases, v0.15 baseline matched **3/6**, v0.17 matched **6/6**. **Critical methodological qualification:** the initial expected label for the same-year direction-reversal case was revised after the first test failed, from `review/direction_reversal_same_quantity` to `abstain/no_independent_entailment`, reflecting the inherited extractor's inability to distinguish the year from the outcome percentage. Thus these cases are **not a strictly frozen held-out evaluation**, and the apparent 3/6 improvement must not be interpreted as unbiased generalization. The initial run had one failed new subtest; the revised run passed. The existing inherited ResourceWarning about an unclosed test fixture remains. No independent scientific claims were verified (0→0), no A→B→C end-to-end transformation was executed, and no C→B fallback was tested.

**Illustrative frames (not executed conversions).** A protective spell→C field guide: a reported 12% change in mosquito bites in 2022 cannot justify an unqualified claim about 2023; the preflight abstains on mismatched years, but does not generate a guide. A storm myth→C science explanation: causal weather claims need independent evidence; the year-scope preflight cannot establish a meteorological mechanism. No claims of operational translation are made.

**Interpretation and next gap.** The added engineering guard reduces selected year-scope comparison errors on developer-authored cases, but it cannot solve numeric parsing with mixed years and outcome percentages. The next measurable task is a pre-registered, independently annotated evidence set with explicit outcome, unit, population and time-span fields, comparing error rates and abstention calibration with and without temporal preflight. The missing historical 65-test suite is still not reproduced.

**Reproducibility.** The accepted secondary artifact `/SpellScienceLab/abc_temporal_scope_v0_17.zip` (SHA-256 `127a2fb0c4cafbe7bab2f729cad20a628ac9d1592f6377bee0a9ea7c46b8faa3`) contains inherited source/tests, the new implementation and two tests, six-case diagnostic JSON, run log and machine-readable status. Library upload succeeded. This update changes only the canonical manuscript; author and rights header preserved byte-for-byte.


### Increment v0.18 — Multi-year temporal scope preflight (2026-11-08)

**Research question.** Can the narrow temporal preflight avoid treating multi-year evidence and claims as directly comparable, without presenting matching year sets as scientific entailment? The v0.17 guard abstained on all multi-year inputs, giving no diagnostic distinction between matching and nonidentical year sets.

**Implementation.** Added `abc_temporal_scope_v18.py` with `temporal_scope_guard_v18(passage, claim)`. Single-year and year-free inputs delegate unchanged to v0.17. When either input contains multiple four-digit years, the new guard returns `time_scope_missing` if the other lacks a year, `time_scope_ambiguous` if either repeats a year, `time_scope_nonidentical` when year sets differ, and `multi_year_scope_requires_review` when year sets match. Even equal year sets are **not** treated as equal observation windows or proof of claim support: aggregations, sequence, and causal scope are not represented. This is an abstention classifier, not scientific verification or learned vector alignment.

**Reproducible execution.** From the extracted accepted v0.17 archive plus the two new source/test files, ran `python -m unittest discover -p 'test*.py' -q`: **38/38 tests passed**, versus **33/33** archived tests before the change; five new test methods exercise single-year compatibility, nonidentical year sets, identical year sets, missing scope, and duplicate-year ambiguity. Existing `ResourceWarning` from `test_context_guard_v14.py` (unclosed JSON fixture) remains. New cases were developer-authored, not an independent held-out scientific benchmark. No actual evidence source retrieval or end-to-end A→B→C run occurred. Independently verified claims: **0→0**. No B↔C fallback was executed.

**Illustrative frame pairs (not executed translations).** A protective charm → C field guide: a claim about mosquito bites during 2022–2023 cannot be inferred directly from an observation covering 2021–2022; the preflight abstains with `time_scope_nonidentical`. A storm myth → C science explanation: matching year sets for weather observations do not demonstrate the myth's causal mechanism; the preflight returns `multi_year_scope_requires_review`. These are scope-check illustrations, not validated scientific conversions.

**Limitations and next measurable gap.** Year-set comparison is lexical and cannot determine period semantics, seasonality, chronological order, date intervals, population matching, or causal entailment. It intentionally fails closed on multi-year comparisons, which can increase unnecessary abstentions. The highest-priority gap is an independently labeled, pre-registered claim–evidence benchmark with typed outcome, time interval, population, measurement, and relation fields, plus false-alarm, missed-contradiction, and abstention metrics against v0.17. The historical 65-test suite remains unrecovered.

**Durable reproducibility archive.** `/SpellScienceLab/abc_temporal_multiyear_v0_18.zip` (SHA-256 `69800a4f1bb0766440783034ec53579ab00d4c5cd66e783d8ff9cf6839dec3a0`), uploaded successfully; contains inherited code/tests, the new source and tests, execution log and machine-readable status. This manuscript is the sole publication Markdown in `magix_spells/`.


### Increment v0.19 — Single-year numeric metadata isolation (2026-11-08)

**Research question.** Can a temporal guard avoid accidentally treating an observation year as an outcome quantity, thereby recovering a previously missed direction-reversal alarm without accepting a claim as scientifically true? In v0.18, the pair “Mosquito bites decreased 12% among children in 2022” versus “Mosquito bites increased 12% among children in 2022” returned `abstain/no_independent_entailment` because the numeric preflight counted both 12% and 2022.

**Implementation and hypothesis.** Added `abc_temporal_numeric_v19.py` with `temporal_numeric_guard_v19(passage, claim)`. Only when each statement has exactly one identical four-digit year (1900–2099), strip that year as temporal metadata and delegate to the inherited population/numeric/direction guard. Otherwise delegate unchanged to v0.18. This is a narrow lexical preflight; no embeddings, causal inference, scientific source verification, or independently learned conversion was introduced. Removing year tokens can erase semantically relevant year references in other constructions, so the function is **not** a general temporal parser.

**Reproducible tests and observed delta.** Extracted the accepted `abc_temporal_multiyear_v0_18.zip` and added one module and six new test methods. Executed `python -m unittest discover -p 'test*.py' -q`: **44/44 passed**, versus **38/38** previously archived. Existing `ResourceWarning` about an unclosed fixture in `test_context_guard_v14.py` persists. The target diagnostic pair changed from `{'status':'abstain','reason':'no_independent_entailment'}` (v0.18) to `{'status':'review','reason':'direction_reversal_same_quantity'}` (v0.19). A same-year different-population case abstains (`population_mismatch`); different years abstain (`time_mismatch`); multiple years still abstain. Six tests were developer-authored and not a held-out benchmark; the diagnostic change must not be interpreted as improved independent scientific accuracy. Independently verified claims: **0→0**. No end-to-end A→B→C or B↔C fallback executed. The historical 65-test suite remains unrecovered.

**Illustrative frame pairs, not executed translations.** A protective charm → C field guide: a 2022 decrease in mosquito bites cannot be rewritten as a 2022 increase without triggering review when other scope matches. A storm myth → C scientific explanation: a numerical weather trend in one year cannot be reversed in the explanation without a scope-aware warning, but the mechanism and evidence still require independent scientific verification. These are illustrations of a preflight on statements, not demonstrations of learned translation.

**Interpretation, limitations, and next measurable gap.** Separating numeric measurements from year metadata prevents one specific missed-alarm pathway, but the guard still relies on brittle lexical patterns and developer-written tests. Priority remains independently annotated claim–evidence data with explicit typed outcomes, populations, time windows, and causal relations; measure false alarms, missed contradictions, abstention calibration and fallback benefit against a frozen baseline. No evidence-based scientific claim support or cross-frame generalization was established.

**Durable archive.** `/SpellScienceLab/abc_temporal_numeric_v0_19.zip`, SHA-256 `1e075696e9371ed1e512f194d21807c6980f7acd4369b2348fcf5665a39ac110`, uploaded successfully. Contains inherited source/tests, the new module and tests, run log, and machine-readable status. This manuscript remains the sole publication Markdown in `magix_spells/`.

### Increment v0.20 — population preflight for numeric disagreements (2026-11-08)

**Source and baseline:** Accepted `/SpellScienceLab/abc_temporal_numeric_v0_19.zip` (44 passing tests). Source manuscript was fetched from `main` with blob SHA `0c2253f13b742bc182100087fd0414c283d33c07` at the beginning of this run. Test definitions for five cases were written before implementation. The initial `python -m unittest discover -p 'test*.py' -q` run failed with `ModuleNotFoundError: No module named 'abc_population_preflight_v20'` (expected before implementation). The module `abc_population_preflight_v20.py` then added a conservative population preflight for **all** numeric `review` outcomes, rather than only direction reversals. Final command `python -m unittest discover -p 'test*.py' -q`: **49 tests, OK**, including five new cases. A ResourceWarning from an inherited test remains. No independent scientific validation, learned embeddings, complete A→B→C example, or B↔C repair occurred.

**Example (two frame pairs, illustrations only):** A=protective charm, C=field guide: a 12% child-specific mosquito-bite observation cannot directly contradict a 20% adult-specific observation; the preflight abstains. A=storm myth, C=scientific explanation: the same population distinction would apply to numerical claims about storm-related outcomes, but the experiment did **not** execute this transformation or verify meteorological evidence. No scientifically defensible mechanism was inferred from either frame. **Fallback:** C→B was not invoked; the only implemented action was an abstention preflight on already provided text statements.

**Artifact:** `/SpellScienceLab/abc_population_preflight_v0_20.zip` uploaded successfully; SHA-256 `39a4cc7f509c39822f364f442abcf6f582483faf42e698de3aa587daa536d189`. Includes inherited modules/tests, new source and tests, command log, and `status_v20.json`. **Next:** independently annotated claim–passage evidence benchmark; quantify false positives, missed contradictions and abstention, not merely developer-authored pass rates.


### Increment v0.21 — compound population-scope abstention (2026-11-08)

**Research question.** Does the accepted population preflight incorrectly treat compound population references as a single homogeneous population? The inherited regex captures a phrase following “among,” including “children and adults,” as though it were a single scope. This can lead to misleading direct contradiction reviews. The hypothesis is that conservative abstention on explicitly compound or repeated population scopes prevents that class of unsupported review without changing simple-population decisions.

**Implementation.** Added `abc_population_ambiguity_v21.py` with `population_ambiguity_guard_v21(passage, claim)`. Before delegating to accepted v0.20, it detects repeated “among” population scopes or connectors “and,” “or,” “versus,” “vs,” and “compared with” within a captured population phrase. It returns `abstain/multiple_population_scopes` or `abstain/compound_population_scope`. This is a lexical guard, **not** a general population parser, evidence entailment model, or learned embedding. A compound phrase outside the narrow regex may be missed, and abstention can be overly conservative.

**Execution and metrics.** Using the archived accepted v0.20 source and inherited tests, added five developer-authored unittest methods. Actual command: `python -m unittest discover -p 'test*.py' -q`. Result **54/54 tests passed**, versus **49/49** in v0.20 (+5 methods). The inherited nonfatal `ResourceWarning` from an unclosed JSON fixture persists. Two compound-population examples and one repeated-population example now abstain; simple same-population direction reversal remains a review and different simple populations remain an abstention. These are developer-authored regression examples, **not independently annotated or held-out scientific evidence**. Independently verified scientific claims remain **0→0**. End-to-end A→B→C and C→B fallback were **not executed**; no scientific translation accuracy delta can be inferred.

**Two distinct frame illustrations, not tested transformations.** A=protective charm, C=field guide: “mosquito bites decreased 12% among children and adults” compared to “increased 12% among children and adults” is too ambiguously aggregated for a direct contradiction alarm, so the preflight abstains. A=storm myth, C=science explanation: a reported trend “among coastal and inland communities” cannot automatically be treated as one population; this guard is not evidence that any meteorological claim is correct. Neither example is a verified translation or intervention.

**Fallback and limitations.** The only fallback is a fail-closed `abstain` at the preflight; no B↔C revision loop exists in this increment. The guard does not identify population strata, sampling design, mixed cohorts, causal relationships or actual evidence support. It may over-abstain on genuinely combined cohorts. The next priority is independently labeled claim–evidence pairs and population-scope annotations, with frozen evaluation of false alarms, missed contradictions, and abstention against the v0.20 baseline. The historical 65-test suite remains unrecovered.

**Durable artifact.** `/SpellScienceLab/abc_population_ambiguity_v0_21.zip` uploaded successfully (SHA-256 `0c56f23d2fff6c7d4ada7e31f36faf0336f44b3899d7a52d313aa96f21b81fef`), containing inherited source/tests, the new module and tests, actual execution log and `status_v21.json`. No other GitHub paths were changed. Authorship and rights header preserved byte-for-byte.


### v0.22 — Explicit intervention-condition mismatch preflight (2026-11-08)

**Research question and hypothesis.** Previous numeric contradiction checks could compare statements describing different explicitly stated intervention conditions as if they were observations under the same conditions. Hypothesis: a conservative lexical preflight for explicitly written sentence-final `with X` versus `without X` or `with Y` reduces unjustified direct contradiction reviews without suppressing a same-condition direction-reversal review. This is a scope check, not causal inference or evidence verification.

**Method and implementation.** Starting from accepted v0.21 archive, froze six developer-authored unit-test methods in `test_intervention_scope_v22.py` (SHA-256 recorded in `frozen_v22.sha256`) before implementing `abc_intervention_scope_v22.py`. The new `intervention_scope_guard_v22(passage, claim)` parses explicit sentence-final `with/without` conditions. If exactly one statement specifies a condition, it returns `abstain/intervention_condition_unknown`; if both specify unequal condition tuples, it returns `abstain/intervention_condition_mismatch`; otherwise it delegates to the inherited v0.21 guard. This is a conservative lexical comparison; it cannot tell whether two intervention names are synonyms, whether an intervention works, or whether a comparison is statistically valid. The guard is not yet a universal frame translator.

**Actual execution and measured results.** Before implementation, `python -m unittest test_intervention_scope_v22 -q` failed with `ModuleNotFoundError`, as expected for a not-yet-implemented module. After implementation, `python -m unittest discover -p 'test*.py' -q` reported **60/60 passed**, compared with **54/54** in the inherited v0.21 suite (+6 methods). The inherited nonfatal unclosed-fixture `ResourceWarning` remains. The added tests cover `with bed nets` versus `without bed nets`, distinct named interventions, matching intervention, missing intervention context, and unqualified claims. These tests were **developer-authored, not independently adjudicated held-out scientific cases**. Independently verified scientific claims remain **0→0**; no complete A→B→C execution or C→B fallback occurred; no measured scientific accuracy improvement is claimed.

**Two distinct frame illustrations (not executed transformations).** A=protective charm, C=field guide: if one account says “Mosquito bites decreased 12% among children with bed nets” and another says “increased 12% among children without bed nets,” the preflight abstains on intervention mismatch instead of declaring a direct contradiction. A=folklore of protective barriers, C=scientific explanation: a claimed observation with window screens is not automatically contradictory to a differently conditioned observation with bed nets. Neither example proves that an intervention is effective or constitutes a generated field guide/science explanation.

**Fallback, threats to validity and next experiment.** Only a fail-closed lexical abstention was tested, not a genuine B↔C correction loop. The parser captures narrow sentence-final `with/without` constructions and can over-abstain for irrelevant qualifiers; it can miss intervention conditions elsewhere in a sentence. The next measurable priority is an independently annotated claim–evidence corpus with intervention/population/time labels and frozen false-alarm/missed-contradiction evaluation, including ablation against v0.21. The historical 65-test suite remains unrecovered.

**Durable reproducibility artifact.** `/SpellScienceLab/abc_intervention_scope_v0_22.zip` uploaded successfully, SHA-256 `5d0d901407e10eca6b0da2fce27205063d06ce7de02c6aa91cacc0561452f83c`, containing inherited source/tests, the v0.22 module, six new tests, frozen test hash, execution log and machine-readable status. Only this canonical GitHub manuscript was modified. The original author and rights header was preserved exactly.
