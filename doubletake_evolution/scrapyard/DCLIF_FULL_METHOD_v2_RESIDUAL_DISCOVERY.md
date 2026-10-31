# DCLIF — Dose-Calibrated Latent Inverse Formulation Method

**Version:** 2.0 — Residual-Guided Discovery  
**Purpose:** Reconstruct or design multi-plant tea/herbal formulations from a desired effect by using plant/effect embeddings as an active part of both **plant selection** and **ratio/quantity inference**.

---

## 1. Operating Directive

When this file is supplied with a requested effect, execute the full method below from start to finish.

The user should only need to provide the desired effect, for example:

- common-cold symptom relief
- sleep onset and sleep maintenance
- vivid dream recall / lucid-dream support
- functional dyspepsia symptom relief
- calm alertness
- another clearly described target state

The workflow must:

1. define the target effect precisely;
2. research the relevant plants;
3. build a broad candidate universe;
4. remove unsafe, irrelevant, redundant, or unsupported candidates;
5. construct plant and target representations;
6. use the representation geometry to select plants **and** determine relative mixture weights;
7. calibrate those weights using known real formulations and dose-bearing evidence without simply copying a formula;
8. model complementary roles, redundancy, and interactions;
9. infer a total mixture amount and individual grams when defensible;
10. run the resulting formulation through a forward effect model and quantify target coverage;
11. calculate the remaining target residual and use that residual as a new vector-search query over the broader plant universe;
12. test whether excluded/new plants materially improve the target when added and whether retained plants are actually necessary when removed;
13. re-optimize plant membership, ratios, and total amount after every meaningful addition/removal;
14. repeat residual search → add/remove testing → re-optimization until no meaningful residual improvement remains;
15. validate the result against held-out known formulations or the closest available analogues;
16. return the final winners, ratios, grams where justified, target-coverage profile, residual/missing-ingredient analysis, confidence, evidence, and unresolved uncertainty.

**Central rule:** embeddings are not merely a retrieval tool. They must materially influence the final ingredient set and the final ratio.

**Residual rule:** after a provisional formulation exists, subsequent discovery must search against the **uncovered residual effect**, not merely re-run similarity against the original target. DCLIF is incomplete until it has attempted residual-guided missing-ingredient discovery and counterfactual add/remove/substitution testing.

---

# 2. Core Research Question

Given a desired effect vector \(t\), find a plant set \(H\), mixture proportions \(w\), and optionally a total mixture mass \(M\), such that the learned representation of the mixture approximates the desired effect as closely as possible:

\[
(H^*,w^*,M^*) = \arg\min_{H,w,M} D(F(H,w,M), t)
\]

subject to safety, evidence, preparation, and plausibility constraints.

The individual plant quantities are:

\[
d_i=Mw_i
\]

with:

\[
w_i \ge 0, \qquad \sum_i w_i = 1
\]

The method therefore solves five connected problems:

1. **Which plants?**
2. **In what relative proportions?**
3. **At what total amount / grams?**
4. **How closely does the resulting formulation reconstruct the requested effect profile?**
5. **What target components remain uncovered, and which additional plant or plant combination best fills that residual?**

---

# 3. What Counts as Success

A method is not considered successful merely because the predicted mixture sounds plausible or has high cosine similarity.

For known-formulation reconstruction, success requires the model to recover a held-out genuine formula from its effect/indication while the answer is hidden.

Measure at least:

### 3.1 Ingredient precision

\[
Precision = \frac{\text{correct predicted plants}}{\text{all predicted plants}}
\]

### 3.2 Ingredient recall

\[
Recall = \frac{\text{correct predicted plants}}{\text{plants in true formula}}
\]

### 3.3 Ratio error

Normalize all component quantities to proportions and calculate:

\[
E_{ratio}=\frac12\sum_i|\hat w_i-w_i|
\]

Lower is better.

### 3.4 Gram error

Where absolute doses are comparable:

\[
MAE_{grams}=\frac1N\sum_i|\hat d_i-d_i|
\]

### 3.5 Baseline improvement

The method must beat simple baselines such as:

- equal proportions;
- random realistic mixtures;
- target-similarity weighting alone;
- average historical dose for each plant;
- nearest known formula copied without optimization;
- simple regression without learned formulation geometry.

A high score that does not beat these baselines is not evidence that the method works.

---

# 4. Required Data Objects

Construct the following for each run.

## 4.1 Target object

Represent the requested effect as a structured target rather than a single short phrase.

Create:

```text
TARGET
- primary desired effect(s)
- secondary desired effect(s)
- unwanted effects to avoid
- desired onset characteristics
- desired duration characteristics
- relevant physiological / experiential mechanisms
- preparation route (tea/infusion/decoction unless otherwise stated)
- constraints supplied by the user
```

The target must include both positive and negative directions.

Example:

```text
PRIMARY
- increased dream awareness during dreams
- increased dream recall

SECONDARY
- preserve sleep continuity
- preserve REM sleep

AVOID
- severe next-day sedation
- repeated awakening
- substantial anticholinergic burden
```

This target description is then embedded or converted into the target latent representation \(t\).

---

## 4.2 Plant object

For every candidate plant, create a structured record:

```text
PLANT
- accepted botanical name
- common name
- plant part used
- traditional uses
- experimentally observed effects
- human clinical evidence
- active constituents / constituent families
- mechanism-related evidence
- pharmacodynamic direction
- onset/duration information if known
- tea/water extraction suitability
- known dose ranges
- known formulation partners
- known antagonistic/redundant combinations
- safety constraints
- medication interactions
- evidence quality
```

Do not embed only the plant name.

The representation should describe what the plant **does**, not merely what it is called.

---

# 5. Evidence Collection Phase

## 5.1 Search broadly

Search current literature and reliable references for:

- plants used for the target effect;
- plants used for its major sub-effects;
- human trials;
- systematic reviews and meta-analyses;
- established multi-plant formulas;
- pharmacology/mechanism literature;
- authoritative monographs;
- dose-bearing formulation data;
- adverse effects and interactions.

For historical/traditional use, traditional sources can be included but must be labelled separately from modern clinical evidence.

## 5.2 Evidence hierarchy

Prefer evidence approximately in this order:

1. systematic reviews/meta-analyses of human studies;
2. randomized controlled human trials;
3. controlled human observational evidence;
4. pharmacokinetic/pharmacodynamic human evidence;
5. established standardized formulations with documented composition;
6. animal/in-vitro mechanistic evidence;
7. authoritative traditional use;
8. weak anecdotal claims.

Weak evidence may contribute to candidate generation but should not dominate the final formulation.

---

# 6. Build the Candidate Universe

Create a broad initial list rather than selecting only the obvious plants.

Typical target size:

- minimum: ~15 plausible candidates;
- preferred: 25–60 candidates when literature permits;
- larger universes are acceptable if computationally manageable.

For each candidate, record why it entered the universe.

Do not yet choose the final winners.

---

# 7. Hard Safety and Feasibility Filter

Before optimization, exclude or constrain candidates that are unsuitable for the intended preparation or pose unacceptable risk.

At minimum check:

- known serious toxicity;
- narrow therapeutic index;
- hepatotoxicity or nephrotoxicity concerns;
- potentially dangerous cardiac effects;
- strong anticoagulant/antiplatelet effects when relevant;
- serotonergic, sedating, stimulant, cholinergic, anticholinergic, MAOI-like or other major pharmacological interactions;
- pregnancy/lactation restrictions where relevant;
- seizure risk;
- allergy concerns;
- interaction with major medication classes;
- unsuitable plant parts;
- non-water-extractable constituents when the requested route is tea;
- legal/regulatory restrictions.

A candidate can be:

- **allowed**;
- **allowed with upper-bound constraint**;
- **excluded**.

Never let vector similarity override a hard safety exclusion.

---

# 8. Representation Construction

## 8.1 Preferred representation

Use the strongest available embedding model to produce embeddings for:

- each structured plant representation \(e_i\);
- the structured target representation \(e_t\);
- known formula effects/indications;
- optional mechanism/effect subtargets.

If a dose-calibrated formulation encoder is available, transform ordinary embeddings through it:

\[
z_i=\phi_\theta(e_i)
\]

and:

\[
t=\psi_\theta(e_t)
\]

where \(z_i\) is a plant representation whose geometry has been trained from real formulas/doses.

## 8.2 If no trained formulation encoder exists

Use an ensemble representation rather than plain text cosine alone:

\[
z_i = [e_i, m_i, c_i, q_i, x_i]
\]

where:

- \(e_i\) = semantic embedding;
- \(m_i\) = mechanism/effect feature vector;
- \(c_i\) = constituent/chemical feature vector where available;
- \(q_i\) = evidence-strength features;
- \(x_i\) = extraction/preparation features.

This fallback must still use vector geometry in the final ratio optimization.

Label this as **proxy DCLIF**, not fully trained DCLIF.

---

# 9. Multi-Effect Target Construction

Do not represent complex effects with one undifferentiated target vector if several therapeutic dimensions are required.

Construct subtargets:

\[
t_1,t_2,...,t_k
\]

with desired target importance weights:

\[
\alpha_1,...,\alpha_k, \qquad \sum_j\alpha_j=1
\]

Examples for insomnia:

- sleep onset;
- sleep maintenance;
- hyperarousal reduction;
- next-day impairment avoidance.

Examples for lucid-dream support:

- dream recall;
- metacognitive awareness during dreaming;
- REM preservation;
- sleep continuity;
- low next-day sedation.

The formulation should cover the **target manifold**, not only the single nearest semantic direction.

---

# 10. Known-Formula Calibration Set

Find known formulas near the target domain.

For each formula collect:

```text
- indication/effect
- ingredient set
- ratio
- grams or extract quantities where available
- preparation type
- evidence level
```

Use them in two different ways.

## 10.1 Calibration mode

Known formulas can teach:

- realistic number of ingredients;
- typical dominant/supporting ratios;
- plausible total mass;
- recurring plant partnerships;
- substitution patterns;
- common ratio distributions.

## 10.2 Validation mode

When testing reconstruction, the target formula itself and close duplicates must be held out.

The model must not simply retrieve the answer.

---

# 11. Initial Plant Relevance Score

For each plant compute a relevance score combining target geometry, subtarget coverage, evidence, and feasibility.

One generic form is:

\[
R_i =
\beta_1\,Sim(z_i,t)
+\beta_2\sum_j\alpha_j Sim(z_i,t_j)
+\beta_3Q_i
+\beta_4P_i
-\beta_5Risk_i
\]

where:

- \(Q_i\) = evidence quality;
- \(P_i\) = preparation suitability;
- \(Risk_i\) = safety/interaction penalty.

This score is **not** the final ratio.

Use it to reduce a very large universe to a manageable optimization pool, usually ~8–20 strong candidates.

---

# 12. Complementarity and Redundancy Model

The final formulation should not be merely the top individually similar plants.

Construct pairwise or higher-order relations.

For candidates \(i,j\), estimate:

```text
COMPLEMENTARITY
- cover different required subtargets
- known compatible formulation pair
- plausible complementary mechanism

REDUNDANCY
- nearly identical effect representation
- duplicate mechanism without added target coverage

ANTAGONISM / RISK
- documented interaction
- opposing pharmacology
- compounded adverse-effect burden
```

Represent this as an interaction matrix \(I\).

A useful approximate mixture representation is:

\[
M(w)=\sum_i w_i z_i + \sum_{i<j} w_iw_j I_{ij}
\]

A learned interaction network is preferred when available.

---

# 13. Core Inverse Formulation Optimization

The final plant weights must be obtained by solving an optimization problem, not by manually assigning intuitive percentages.

A practical objective is:

\[
\max_w
\Bigg[
\sum_j \alpha_j Sim(M(w),t_j)
+\lambda_C C(w)
+\lambda_E E(w)
-\lambda_R R(w)
-\lambda_D D(w)
\Bigg]
\]

subject to:

\[
w_i \ge 0
\]

\[
\sum_iw_i=1
\]

and any plant-specific upper/lower bounds.

Where:

- \(C(w)\) = complementarity reward;
- \(E(w)\) = evidence-strength reward;
- \(R(w)\) = safety/interaction penalty;
- \(D(w)\) = redundancy/degeneracy penalty.

### 13.1 Avoid forced equalization

Do **not** use entropy regularization in a way that simply pushes mixtures toward equal proportions.

If non-degeneracy is needed, use only the minimum regularization required to prevent pathological collapse.

### 13.2 Sparse winner selection

The optimized solution should normally contain a modest number of active plants.

Use one of:

- entmax/sparsemax;
- L1/group sparsity;
- top-k constrained optimization;
- iterative elimination of negligible weights.

Do not keep a plant merely because it was researched.

---

# 14. Dose-Calibrated Ratio Inference

Plain semantic embeddings do not naturally mean “effect per gram.”

Therefore convert raw formulation weights into dose-calibrated weights using either a learned dose layer or empirical local calibration.

Preferred learned form:

\[
r_i=g_\theta(t,z_i,H)
\]

then:

\[
w_i=\frac{a_i\exp(r_i)}{\sum_j a_j\exp(r_j)}
\]

where \(a_i\) is the sparse selection activation.

This ensures that final proportions are target-dependent and formulation-dependent.

### 14.1 Local calibration fallback

If no learned dose model is available:

1. collect dose-bearing formulas containing the candidate plants in related indications;
2. normalize their doses to within-formula proportions;
3. estimate plant-specific dose scale factors and pairwise ratio priors;
4. adjust the raw embedding-derived weights by these scale factors;
5. re-optimize target fit after adjustment.

The calibration must **modify** vector-derived weights, not replace them with a copied recipe.

---

# 15. Total Mass / Gram Inference

Relative proportions and total mass are different quantities.

Infer total mass separately:

\[
M=h_\theta(t,H,w,route)
\]

Then:

\[
d_i=Mw_i
\]

For a tea/infusion, total-mass inference should consider:

- established infusion/decoction amounts for the same plant parts;
- water extraction efficiency;
- practical cup/pot volume;
- documented human-use ranges;
- whether the source values refer to crude herb, dry extract, tincture, essential oil, or standardized extract.

Never equate extract milligrams directly with crude-herb grams without a documented conversion.

If absolute grams cannot be defensibly calibrated, return the **ratio only** and state that gram scaling remains unresolved.

---

# 16. Tea-Specific Extraction Adjustment

For tea formulations, model the preparation route.

For each plant define an approximate extraction factor \(x_i\) based on the relevant constituents and preparation method.

A conceptual effective contribution is:

\[
Contribution_i \propto d_i \cdot x_i \cdot potency_i
\]

The ratio optimizer can therefore use an adjusted latent contribution:

\[
M_{tea}(w)=\sum_i w_i x_i z_i + interactions
\]

Do not pretend that equal dry grams imply equal extracted activity.

---

# 17. Forward Effect Model

A robust implementation must contain a forward model:

\[
F(H,w,M) \rightarrow \hat t
\]

which predicts the effect representation of the proposed mixture.

The model should be:

- permutation invariant to ingredient order;
- dose aware;
- interaction aware;
- capable of representing multiple effect dimensions.

Suitable architecture families include:

- Deep Sets;
- Set Transformer;
- graph neural network;
- hypergraph model;
- mixture/property neural model.

---

# 18. Inverse–Forward Closure and Target-Coverage Loop

A candidate formulation is not final merely because the inverse model produced it.

Run:

\[
T \rightarrow G(T)=F_0
\]

then:

\[
F(F_0)=\hat T
\]

Measure mismatch:

\[
D(T,\hat T)
\]

Also report a normalized target-coverage score whenever the representation supports one:

\[
Coverage = 1-D_{norm}(T,\hat T)
\]

The single scalar is not sufficient. Produce a **coverage profile** over all target subdimensions:

```text
TARGET COVERAGE
- target component
- desired strength
- predicted strength
- residual / deficit
- confidence
```

This profile must expose whether the formulation is strong overall but still misses a critical dimension.

Then refine \(w\), ingredient membership, and optionally \(M\) through the frozen forward model:

\[
(H,w,M) \leftarrow \arg\min D(F(H,w,M),T)
\]

The closure loop MUST feed directly into residual-guided ingredient discovery below.

---

# 18A. Residual Construction

After forward prediction, calculate what the current formulation still fails to reproduce.

### Calibrated latent-space mode

If \(T\) and \(\hat T\) inhabit the same trained, approximately linear formulation/effect latent space, compute:

\[
R=T-\hat T
\]

where \(R\) is the **missing-effect residual vector**.

### Proxy / non-linear mode

Do **not** blindly subtract arbitrary semantic embeddings when their axes are not known to support vector arithmetic. Instead:

1. compare desired and predicted values for each explicit subtarget;
2. retain positive deficits and clinically/experientially relevant over-expression penalties;
3. generate a structured residual description;
4. embed that residual description using the same representation pipeline.

Example:

```text
RESIDUAL TARGET
NEEDS MORE
- lucid awareness during dreams: large deficit
- dream recall: moderate deficit
- hypnagogic imagery: moderate deficit

ALREADY SUFFICIENT
- dream vividness
- sleep continuity

MUST NOT INCREASE
- next-day sedation
- REM suppression
```

This residual representation becomes \(R\).

Residual search must therefore target **what is missing**, not simply repeat the original broad plant search.

---

# 18B. Residual-Guided Vector Search for Missing Ingredients

Search the **full allowed plant universe again**, including plants removed from the first optimization for low global relevance, because a plant that is mediocre for the whole target may be excellent for the residual.

For every eligible plant \(p\) not currently active, calculate a residual-fit score. A general form is:

\[
S_{res}(p)=
\alpha Sim(z_p,R)
+\beta \Delta Coverage(p)
+\gamma Complementarity(p,H)
-\delta Redundancy(p,H)
-\eta Opposition(p,T)
-\rho Risk(p)
\]

where:

- \(Sim(z_p,R)\) = vector alignment with the missing effect;
- \(\Delta Coverage(p)\) = estimated improvement after insertion and re-optimization;
- \(Complementarity\) = coverage of dimensions the current winners do not cover;
- \(Redundancy\) = duplication of already-sufficient effects;
- \(Opposition\) = movement away from desired dimensions or toward explicitly avoided effects;
- \(Risk\) = safety/interaction penalty.

Retrieve at least the top residual-aligned candidates and test them rather than automatically accepting the nearest vector.

### Search expansion

If the residual cannot be adequately covered by the existing plant database:

1. convert the strongest residual dimensions into scientific/literature search terms;
2. search for additional legal/feasible plants specifically associated with those dimensions;
3. construct full plant objects for new candidates;
4. embed them;
5. add them to the residual candidate pool;
6. continue the same scoring and testing process.

Thus DCLIF can actively discover an ingredient that was absent from the original candidate list.

---

# 18C. Add-Test, Remove-Test, and Substitution-Test

Every promising residual candidate must undergo a counterfactual add test.

For candidate \(p\):

\[
F_p^*=Optimize(H\cup\{p\},w,M)
\]

Then compute its marginal improvement:

\[
\Delta_{add}(p)=D(T,\hat T_{old})-D(T,\hat T_p)
\]

Interpretation:

- \(\Delta_{add}>0\): candidate improves reconstruction;
- approximately zero: candidate adds little;
- \(\Delta_{add}<0\): candidate worsens the formulation.

Do not add a plant solely because it has high residual cosine similarity. It must improve the re-optimized formulation.

### Remove test

For every retained ingredient \(i\):

\[
F_{-i}^*=Optimize(H\setminus\{i\},w,M)
\]

Then:

\[
\Delta_{remove}(i)=D(T,\hat T_{-i})-D(T,\hat T)
\]

Large positive values indicate an important ingredient. Near-zero values indicate redundancy or dispensability.

### Substitution test

For each weak retained ingredient \(i\) and strong residual candidate \(p\), test:

\[
H'=(H\setminus\{i\})\cup\{p\}
\]

Re-optimize all ratios and total mass. Keep the substitution only if it improves overall target reconstruction and does not violate constraints.

---

# 18D. Residual Decomposition and Multi-Ingredient Completion

A residual may not correspond to any single plant.

If the best one-plant addition leaves a material residual, decompose \(R\) into its dominant effect components:

\[
R \rightarrow r_1,r_2,...,r_k
\]

Search for plants against each component separately, then evaluate small combinations:

\[
\{p_a,p_b\},\{p_a,p_c\},...
\]

The objective is not to maximize the number of plants. It is to find the **smallest additional set** that materially closes the residual.

Use beam search, sparse combinatorial search, or another tractable strategy rather than exhaustive enumeration when the candidate pool is large.

---

# 18E. Mandatory Residual Iteration

After every accepted addition, removal, or substitution:

1. re-optimize all plant weights;
2. re-estimate total mass if applicable;
3. run the forward model again;
4. calculate a new coverage profile;
5. calculate a new residual;
6. search the residual again.

The complete loop is:

\[
T
\rightarrow Initial\ Search
\rightarrow DCLIF\ Formula
\rightarrow \hat T
\rightarrow R
\rightarrow Residual\ Vector\ Search
\rightarrow Add/Remove/Substitute\ Tests
\rightarrow Reoptimization
\rightarrow \hat T_2
\rightarrow R_2
\rightarrow ...
\]

This process stops only when no eligible plant or small plant set yields a material improvement, or a hard safety/feasibility constraint prevents further closure.

The final method must distinguish explicitly between:

```text
A. ratio problem — the necessary plants are present but weights are wrong;
B. ingredient problem — an important plant/effect contributor is missing;
C. candidate-universe problem — the current researched plant universe cannot cover the residual;
D. model/evidence limit — available representations/evidence cannot resolve the remaining residual.
```

---

# 19. Multiple-Solution Search

A target may have more than one valid formulation.

Generate several candidate solutions rather than forcing a single mode:

\[
F_1,F_2,...,F_k
\]

Use:

- different latent initializations;
- different sparse subsets;
- mixture-density/generative sampling;
- nearest-formula priors from different neighborhoods.

Refine each through the forward model.

Then rank them by:

1. target fit;
2. evidence quality;
3. safety;
4. preparation feasibility;
5. robustness to small weight perturbations;
6. distance from trivial/copied historical formula solutions.

Return the strongest formulation as the primary result and keep alternatives only if meaningfully different.

---

# 20. Reconstruction Validation Protocol

Before trusting the method for a novel target, benchmark it on known formulas.

For each test formula:

1. remove the formula itself from retrieval/training access;
2. remove near-duplicates and trivial aliases;
3. give the method only the target indication/effect;
4. let it search the candidate plant universe;
5. generate plants and ratios;
6. compare against the hidden true formula;
7. record precision, recall, ratio error, and gram error;
8. compare against all trivial baselines.

Use multiple unrelated therapeutic domains.

Do not declare success from one favorable example.

---

# 21. Robustness Tests

For the final candidate formulation, perturb the inputs.

### 21.1 Target perturbation

Slightly rephrase the target.

A robust formulation should not change radically because of wording alone.

### 21.2 Candidate perturbation

Add/remove weak candidates.

Core winners should remain reasonably stable.

### 21.3 Weight perturbation

Change each major ratio slightly and evaluate the forward model.

Prefer broad optima over extremely fragile solutions.

### 21.4 Evidence perturbation

Down-weight uncertain evidence and verify whether the same winners remain.

---

# 22. Winner Selection Rule

After optimization, classify plants as:

- **CORE WINNER** — high target contribution, stable across runs, meaningful weight;
- **SUPPORTING WINNER** — adds complementary coverage or improves forward target fit;
- **OPTIONAL** — small or unstable contribution;
- **REJECTED** — redundant, weak, unsafe, or degrades objective.

The final mixture should contain only core and genuinely useful supporting winners.

Do not preserve ingredients for cosmetic complexity.

---

# 23. Stopping Criteria

Stop iterative refinement only when all are true:

1. no residual-guided new ingredient materially improves target fit after full re-optimization;
2. no tested small combination of residual candidates materially improves target fit;
3. no candidate substitution materially improves target fit;
4. no retained ingredient can be removed without meaningful loss unless kept for a justified secondary constraint;
5. no ratio adjustment materially improves target fit;
6. the remaining residual is below the chosen materiality threshold **or** is explicitly classified as a candidate-universe/model/evidence limit;
7. no major safety or interaction issue is unresolved;
8. the solution is stable to modest target/candidate perturbation;
9. trivial baselines are beaten when a benchmark is available;
10. the number of ingredients is justified;
11. the final ratio is not an artefact of equal-weight regularization;
12. gram scaling is either evidence-calibrated or explicitly withheld.

---

# 24. Practical Execution Workflow for ChatGPT

When the user uploads this file and specifies an effect, follow this exact sequence.

## Phase A — Define the target

1. Translate the user's requested effect into primary, secondary, and avoid dimensions.
2. Preserve the user's wording and intent.
3. Use sensible defaults if the request is sufficiently clear rather than forcing unnecessary clarification.

## Phase B — Research

4. Search current scientific literature and authoritative sources.
5. Build a broad candidate plant table.
6. Find dose-bearing known formulas in the same or adjacent effect domain.
7. Gather safety and preparation information.

## Phase C — Filter

8. Remove clearly unsafe/inappropriate plants.
9. Remove plants irrelevant to the intended preparation route.
10. Retain a broad enough set to permit discovery rather than merely confirming obvious ingredients.

## Phase D — Represent

11. Build standardized effect-rich text/feature representations for every plant.
12. Build the multi-effect target representation.
13. Produce embeddings with the best available embedding model.
14. If a trained formulation encoder exists, transform into dose-calibrated latent embeddings.
15. Otherwise use proxy DCLIF with explicit evidence/mechanism/extraction features.

## Phase E — Initial ranking

16. Score each plant against the target and subtargets.
17. Reduce the universe to the strongest ~8–20 optimization candidates.
18. Do not yet finalize winners.

## Phase F — Optimize plant set and ratios

19. Build complementarity/redundancy/interaction relations.
20. Optimize the weighted mixture against the multi-effect target.
21. Enforce nonnegative normalized proportions.
22. Apply sparse winner selection.
23. Re-run after removing negligible/redundant candidates.

## Phase G — Calibrate quantities

24. Use dose-bearing analogue formulas and/or a learned dose layer to calibrate the embedding-derived proportions.
25. Re-optimize after calibration.
26. Infer total mass only when the preparation and source units allow a defensible conversion.
27. Convert proportions to grams.

## Phase H — Forward validation and residual discovery

28. Predict the effect of the resulting mixture using the forward model/proxy.
29. Compare that predicted effect with the requested target dimension by dimension.
30. Produce the target-coverage profile.
31. Construct the calibrated latent residual or structured proxy residual.
32. Search the full eligible plant universe against the residual vector.
33. If the residual remains poorly covered, expand the literature search specifically around the missing dimensions and embed newly discovered plants.
34. Run counterfactual add tests for the strongest residual candidates.
35. Run remove tests on all retained ingredients.
36. Run substitution tests where a new candidate can replace a weak/redundant winner.
37. If no single plant closes the residual, decompose the residual and test small complementary candidate sets.
38. Re-optimize all ratios and total mass after every accepted structural change.
39. Re-run the forward model and recompute the residual.
40. Repeat until the residual stopping criteria are met.

## Phase I — Stress test

41. Test target wording perturbations.
42. Test small ratio perturbations.
43. Test removal of each major ingredient again on the converged formulation.
44. Confirm that every retained plant adds measurable value.
45. Confirm that the final winner set is stable to plausible residual-search perturbations.

## Phase J — Report

46. Return the final formulation and the reasoning evidence that led to it.
47. Report target coverage for every important subdimension.
48. Report the final residual and whether it reflects a ratio problem, missing-ingredient problem, candidate-universe problem, or evidence/model limit.
49. Report which residual-search candidates were tested and their marginal add/remove/substitution value.
50. Clearly distinguish model-inferred proportions from historically established doses.
51. Report uncertainty rather than fabricating precision.

---

# 25. Required Final Output Format

Use a compact but complete report.

## Target

State the desired effect and subtargets.

## Candidate universe

Provide the researched candidate list with short reasons for inclusion.

## Final winners

| Plant | Role | Relative % | Grams* | Why retained | Evidence confidence |
|---|---|---:|---:|---|---|
| ... | ... | ... | ... | ... | ... |

`*` Grams only if dose scaling is defensible.

## Final ratio

Example:

```text
Plant A : Plant B : Plant C : Plant D
4.8 : 2.7 : 1.8 : 0.7
```

or normalized:

```text
48% : 27% : 18% : 7%
```

## Rejected high-ranking candidates

List important plants considered but rejected and why.

## Formulation logic

Explain:

- which target dimensions each winner covers;
- what complementary interactions matter;
- what redundancy was removed;
- how vector/latent geometry affected the ratio;
- how known-formula calibration modified the raw weights.

## Target coverage

Report each major target dimension with desired strength, predicted coverage, residual deficit/excess, and confidence.

## Residual / missing-ingredient analysis

Report:

- the final residual representation;
- which target dimensions remain under-covered or over-expressed;
- top plants returned by residual-vector search;
- marginal improvement from each serious add candidate;
- remove-test importance for retained ingredients;
- substitutions tested;
- whether the residual indicates a ratio problem, ingredient problem, candidate-universe problem, or model/evidence limit.

## Validation

Report:

- closest known analogue formulas;
- whether the result resembles or diverges from them;
- reconstruction/baseline results when available;
- robustness/stability result.

## Confidence

Provide separate confidence for:

```text
plant selection: X/10
relative ratio: X/10
absolute grams: X/10
overall model confidence: X/10
```

Do not collapse all uncertainty into one number.

---

# 26. Critical Anti-Cheating Rules

When validating against a known formula:

- do not expose the true ingredient list to the optimizer;
- do not put the formula name in plant descriptions;
- do not include text saying that specific plants are ingredients of that formula;
- do not use the true ratio during optimization;
- do not use a near-identical duplicate formula as an analogue;
- do not judge success by raw cosine alone;
- compare against uniform and other trivial baselines.

The goal is genuine reconstruction.

---

# 27. What the Method Must Never Do

Do not:

- convert cosine similarity directly into grams;
- equate semantic similarity with potency;
- assume more plants are automatically better;
- force equal proportions through excessive entropy regularization;
- copy the nearest existing recipe and call it optimization;
- treat crude herb grams, extract milligrams, tincture millilitres, and essential-oil drops as interchangeable;
- ignore plant part or preparation method;
- let unsafe candidates survive because they improve vector fit;
- claim clinical efficacy merely because the reconstruction model fits historical formulas;
- fabricate exact gram precision when only ratios are supportable;
- search only against the original target after a partial formulation exists; residual search must target the missing effect;
- add a residual-nearest plant without testing whether it improves the re-optimized full formulation;
- treat arbitrary semantic-vector subtraction as meaningful when target and predicted effects are not in the same calibrated latent space.

---

# 28. Preferred Future Model Architecture

For a fully trained implementation, use the following architecture.

### Encoders

\[
z_i=\phi_\theta(Plant_i)
\]

\[
t=\psi_\theta(Target)
\]

### Sparse plant activation

\[
a=SparseSelect(t,Z)
\]

### Dose/ratio head

\[
r_i=g_\theta(t,z_i,Z_{selected})
\]

\[
w_i=\frac{a_i\exp(r_i)}{\sum_j a_j\exp(r_j)}
\]

### Total mass head

\[
M=h_\theta(t,Z,w,route)
\]

### Interaction-aware forward model

\[
\hat t=F_\theta(\{z_i,w_i\},M)
\]

### Training objective

\[
L=
\lambda_1L_{ingredients}
+\lambda_2L_{ratio}
+\lambda_3L_{dose}
+\lambda_4L_{effect}
+\lambda_5L_{contrastive}
+\lambda_6L_{interaction}
\]

Use a composition-aware ratio loss such as log-ratio/Aitchison-space error where appropriate.

---

# 29. Minimal Pseudocode

```python
TARGET = structure_target(user_request)

CANDIDATES = research_plants(TARGET)
CANDIDATES = safety_and_route_filter(CANDIDATES)

KNOWN_FORMULAS = research_nearby_formulas(TARGET)

plant_repr = embed_and_structure(CANDIDATES)
target_repr = embed_target(TARGET)

plant_latent = dose_calibrate_if_available(plant_repr, KNOWN_FORMULAS)
target_latent = target_transform(target_repr)

pool = initial_target_ranking(plant_latent, target_latent)
interaction_model = build_interaction_model(pool, evidence=KNOWN_FORMULAS)

solutions = []
for seed in multiple_initializations:
    H, w = optimize_inverse_mixture(
        pool,
        target_latent,
        interaction_model,
        safety_constraints=True,
        sparse=True,
    )

    w = calibrate_ratio_with_real_formula_doses(w, H, KNOWN_FORMULAS)
    M = infer_total_mass(TARGET, H, w, KNOWN_FORMULAS)

    # Mandatory inverse -> forward -> residual loop
    while True:
        predicted = forward_effect(H, w, M)
        coverage = target_coverage(TARGET, predicted)
        residual = construct_residual(TARGET, predicted)

        # Search against what is missing, not against the original target again
        residual_candidates = vector_search_full_plant_universe(
            residual,
            exclude=H,
            safety_constraints=True,
        )

        if residual_is_poorly_covered(residual_candidates):
            new_plants = research_plants_for_residual(residual)
            new_plants = safety_and_route_filter(new_plants)
            residual_candidates += embed_and_structure(new_plants)

        add_results = counterfactual_add_tests(
            H, w, M, residual_candidates, TARGET
        )
        remove_results = counterfactual_remove_tests(H, w, M, TARGET)
        substitution_results = substitution_tests(
            H, w, M, residual_candidates, TARGET
        )

        if no_single_addition_closes_residual(add_results, residual):
            combo_results = residual_component_and_small_set_search(
                residual, residual_candidates, H, w, M, TARGET
            )
        else:
            combo_results = []

        change = choose_best_structural_change(
            add_results,
            remove_results,
            substitution_results,
            combo_results,
        )

        if not materially_improves(change):
            break

        H = apply_structural_change(H, change)
        H, w = optimize_inverse_mixture(
            H,
            target_latent,
            interaction_model,
            safety_constraints=True,
            sparse=True,
        )
        w = calibrate_ratio_with_real_formula_doses(w, H, KNOWN_FORMULAS)
        M = infer_total_mass(TARGET, H, w, KNOWN_FORMULAS)

    solutions.append((H, w, M, coverage, residual))

solutions = robustness_test(solutions)
best = rank_solutions(solutions)

return full_report(
    best,
    include_target_coverage=True,
    include_residual_analysis=True,
    include_add_remove_substitution_tests=True,
)
```

---

# 30. Interpretation of the Result

The final output is a **model-derived formulation hypothesis**.

Its strength is determined by:

- how well the method reconstructs held-out genuine formulations;
- how strong the evidence is for the candidate plants;
- how stable the optimized mixture is;
- how well the forward model closes the effect → formulation → effect loop;
- how defensible the dose calibration is.

A formulation can be computationally strong even when clinical validation for that exact novel combination does not exist. The report must distinguish those two facts.

---

# 31. Current Method Status

The research leading to this method established the following:

1. **Naive raw embedding arithmetic is insufficient.**
2. High cosine similarity of ratio vectors can be misleading because trivial equal-weight mixtures can score highly.
3. Embeddings remain valuable when they are calibrated using known formulations, mechanisms, interactions, and actual dose information.
4. Published herbal-prescription models demonstrate that joint ingredient and dosage prediction is learnable.
5. The strongest formulation architecture is therefore an **inverse, dose-calibrated latent model with a forward closure loop** rather than simple semantic nearest-neighbour retrieval.
6. The practical standard of success is reconstruction of held-out genuine plant sets and ratios/grams, not clinical proof of a newly generated formula.
7. A final formulation must now pass **residual closure**: DCLIF must explicitly search embedding space for missing effect components, test new ingredients counterfactually, and stop only when no meaningful addition/removal/substitution improves the reconstruction.

---

# 32. Short Name

Use the name:

**DCLIF — Dose-Calibrated Latent Inverse Formulation**

The complete intended pipeline is:

\[
\boxed{
\text{Desired effect}
\rightarrow
\text{broad plant research}
\rightarrow
\text{structured embeddings}
\rightarrow
\text{dose-calibrated latent space}
\rightarrow
\text{sparse winner selection}
\rightarrow
\text{ratio optimization}
\rightarrow
\text{gram calibration}
\rightarrow
\text{forward-effect validation}
\rightarrow
\text{target residual}
\rightarrow
\text{residual-vector missing-ingredient search}
\rightarrow
\text{add/remove/substitution tests}
\rightarrow
\text{re-optimization}
\rightarrow
\text{residual closure}
}
\]

This is the method to apply whenever this file is uploaded with a new requested effect.
