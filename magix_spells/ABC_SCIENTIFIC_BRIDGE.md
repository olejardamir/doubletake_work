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

## 9. Experimental results

**Engineering result, 2026-11-07:** A generic frame-contract and bounded fallback-routing prototype passed 7/7 unit tests. These are structural/control-flow checks, **not** independent scientific validation or proof of autonomous A→B→C translation. See the chronological log for test scope, mock-oracle limitations and reproducibility. This section will be filled with reproducible results, figures and negative findings as work proceeds. Earlier demonstration spells are illustrative, not proof of scientific effectiveness.

## 10. Discussion and threats to validity (working)

- Mapping source-frame semantics to a scientific ontology can lose context and causal roles.
- Evidence retrieval can be wrong, incomplete, conflicting or outdated.
- Empirical science yields conditional evidence, not universally decidable truth.
- Translating B into C may introduce new claims, change the goal or lose limits.
- Self-evaluation is vulnerable to answer contamination and circular grading.
- Exact mathematical inversion may be impossible, particularly when A≠C or unsupported claims are intentionally removed.
- A harmless ritual aesthetic must not be confused with an efficacious procedure.
- Some target frames and goals are incompatible with safety or scientific feasibility; honest refusal/abstention is a necessary system output.

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

