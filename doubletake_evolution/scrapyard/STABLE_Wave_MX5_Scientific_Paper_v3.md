# STABLE-Wave MX5: Selection-Separated Structural Hypothesis Routing for Static Complex-Valued Nonlinear Operator Identification

**Manuscript status:** Revised full methods manuscript (v3; frozen-method analysis with post-freeze diagnostics)  
**Date:** August 15, 2026  
**Author(s):** *To be added*

## Abstract

Choosing a representation is a central problem in nonlinear input-output modeling: linear, structured nonlinear, latent, polynomial, kernel, and other model families can each be appropriate under different mechanisms. Routing among those families creates a second problem—selection optimism—when the same held-out data are reused for tuning, model-family nomination, acceptance, release decisions, and performance reporting. We introduce **STABLE-Wave MX5**, a structural-hypothesis routing framework for **static complex-valued nonlinear operator identification**. MX5 evaluates twelve mechanistically different candidate identifiers and assigns separate random datasets to parameter fitting, hyperparameter tuning, structural nomination, independent gate confirmation, empirical release screening, and final testing.

The primary frozen internal-validation benchmark comprised 24 fresh random tasks spanning eight transformation families, dimensions \(K\in\{16,24,32\}\), and QPSK, 16-QAM, and complex Gaussian inputs. MX5 released 22/24 tasks (91.67% coverage; exact binomial 95% interval, 73.0%–99.0%). None of the 22 released tasks exceeded the predeclared \(10^{-3}\) test-NMSE target; mean released NMSE was \(1.379\times10^{-4}\), and the worst released value was \(6.397\times10^{-4}\). A post-hoc forced-expert diagnostic evaluated all twelve frozen candidates on all 24 untouched test sets: the expert selected by MX5 before test-label access matched the retrospective test-best candidate on **24/24 tasks**, giving zero observed structural-selection regret in this benchmark. The retrospectively best single fixed candidate, `dense_latent`, had mean NMSE \(8.726\times10^{-4}\), versus \(2.810\times10^{-4}\) for MX5.

A second post-freeze cohort of 24 entirely new random tasks was run without changing MX5. It again released 22/24 tasks with 0/22 released-task threshold violations; mean released NMSE was 2.135e-04. Descriptively pooling the two frozen cohorts gives 44/48 releases (exact 95% coverage interval, 80.0%–97.7%) and 0/44 observed released-task violations; the corresponding simple one-sided zero-event 95% upper bound is 6.6%, which underscores that the release screen is empirical rather than a formal finite-sample risk guarantee. Twelve independently permuted negative controls were rejected.

These results support a deliberately narrow conclusion: **within the randomized static operator families studied here**, heterogeneous identifiers can be treated as competing structural hypotheses, and separating nomination, confirmation, release screening, and final evaluation can produce accurate selective routing. MX5 is not presented as a universal system identifier, a temporal dynamical-system method, or a distribution-free risk-control procedure.

**Keywords:** nonlinear operator identification; complex-valued regression; structural model selection; model routing; selective prediction; abstention; kernel ridge regression; Volterra models; simulation.

---


## Scope of Claims and Evidence Levels

This manuscript separates three evidence levels.

| Evidence level | Role | Can it support the paper's primary claim? |
|---|---|---|
| Developmental evolution | Architecture discovery, failure analysis, rejected branches, hard-family creation | No; used to design MX5 |
| Primary frozen internal validation | 24 fresh random tasks generated after MX5 and the \(10^{-3}\) release tolerance were frozen | **Yes; primary quantitative evidence within the internal generator program** |
| Post-freeze validation and challenges | A second 24-task cohort, new composed mechanisms, input-distribution shifts, expanded negative controls, and sample-efficiency probes | Supportive validation/stress evidence; not used to alter MX5 |

The primary 24-task benchmark is **frozen internal validation relative to the MX5 implementation**, but it was not prospectively registered with an external registry before the overall research program began. The paper therefore uses the terms *frozen internal validation* and *post-freeze validation* rather than *preregistered* or *external validation*. No architecture, candidate-pool, routing, gate, or release screening-threshold change was made in response to the final 24-task test labels.

The central claim is deliberately bounded:

> **Within the randomized static complex-valued transformation families studied here, selection-separated routing among heterogeneous structural hypotheses can outperform forcing a single tested model family globally, while an independent empirical release screen can abstain on unsupported tasks.**

The manuscript does **not** claim a universal system identifier, temporal dynamical-system identification, formal post-selection inference, distribution-free risk control, external validation, or demonstrated superiority on measured physical systems.

## 1. Introduction


The term *operator identification* is used throughout this manuscript to keep the empirical scope precise. The studied mappings are static across samples: they may contain dense, local, low-rank, bilinear, latent, and other nonlinear interactions within a complex-valued vector, but they do not contain hidden temporal state, feedback, or long-memory dynamics. The work is therefore related to nonlinear system identification, but it should not be read as an evaluation on general dynamical-system identification problems.

More broadly, system identification asks a basic but difficult question: given paired observations of a system input and output, what representation should be used to predict the system response on new inputs? Classical identification offers linear, polynomial, Volterra, kernel, state-space, nonlinear autoregressive, and many other representations. Modern machine learning adds deep networks and mixture-of-experts architectures. The practical difficulty is therefore no longer only parameter estimation. It is also **structural choice**: the correct inductive bias for one system may be actively unhelpful for another.

This issue is especially visible in complex-valued multicarrier transformations. A nearly diagonal system with smooth carrier response is well matched by a compact symbolic transfer function. A system with sparse cross-carrier quadratic interactions may favor a second-order polynomial or Volterra-like model. A transformation driven by a small number of unknown global carrier mixtures may instead favor a learned latent-projection model. A universal black-box model can, in principle, approximate many of these mechanisms, but doing so may require more data, more optimization, and less interpretability than choosing an appropriate structural hypothesis.

Mixture-of-experts methods address heterogeneity by combining specialized models [3,4]. However, standard expert gating is usually framed as a learned sample-level or context-level routing problem. STABLE-Wave takes a different approach. The object being routed is the **entire structural hypothesis for an unknown transformation**. For each identification task, multiple model families are fitted and compared. The system then selects one complete identifier for deployment on that transformation.

That formulation introduces a statistical danger. If the same held-out observations are repeatedly used to tune hyperparameters, choose the model family, decide whether the chosen family improves on a fallback, calibrate an acceptance rule, and report final performance, the resulting evaluation becomes progressively less independent. Recent work on routing diagnostics has highlighted the broader danger of reusing evaluation data after selecting the best candidate from a pool [9]. Similar concerns arise throughout empirical model selection.

We therefore ask the following research question:

> **Can heterogeneous nonlinear transformations be identified more robustly by treating model families as competing structural hypotheses, assigning distinct random datasets to tuning, ranking, confirmation, risk screening, and final evaluation, and abstaining when the evidence does not support a predeclared error target?**

### 1.1 Frozen Internal-Validation Hypotheses

Before interpreting the final 24-task benchmark, four internal-validation hypotheses define what would count as success.

**H1 — Routing utility.** The adaptive MX5 procedure should have lower paired test NMSE than each forced fixed baseline: dense complex linear regression, RBF kernel ridge regression, and polynomial kernel ridge regression.

**H2 — Empirical release behavior.** Among tasks released by the independent release-screen split, the observed test NMSE should remain below the predeclared \(10^{-3}\) operating threshold.

**H3 — Signal dependence.** When the input-output pairing is independently destroyed in every label-bearing pre-test split, MX5 should refuse release rather than manufacture a low-error mapping from marginal statistics alone.

**H4 — Structural specialization.** The router should select more than one expert family across heterogeneous tasks; a single candidate dominating every family would weaken the structural-routing interpretation.

These hypotheses separate performance, selective reliability, negative-control behavior, and structural diversity. H1 is evaluated with paired task-level tests and multiplicity correction. H2 is evaluated as an observed threshold-violation count together with exact binomial uncertainty; it is an empirical operating-behavior hypothesis, not a formal safety guarantee. H3 and H4 are descriptive stress hypotheses rather than claims of formal statistical power.

STABLE-Wave MX5 is an empirical answer to that question. It uses six disjoint random input-output splits for each task:

\[
D_{\mathrm{train}},\;
D_{\mathrm{tune}},\;
D_{\mathrm{rank}},\;
D_{\mathrm{gate}},\;
D_{\mathrm{cert}},\;
D_{\mathrm{test}}.
\]

The first two fit and tune the candidate models. The rank split nominates a structural hypothesis. The gate split independently tests whether the nominee improves on a simpler fallback. The release-screen split estimates whether the selected identifier is sufficiently accurate to release. The test split is never used until all decisions are frozen.

The main contributions of this work are:

1. **Structural hypothesis routing rather than sample-level expert mixing.** Twelve mechanistically different complex-valued identification models compete to represent a whole transformation.
2. **Strict data-role separation.** Training, tuning, structural nomination, confirmation, empirical risk screening, and final evaluation use disjoint random samples.
3. **Complexity-aware fallback.** A more elaborate model is accepted only when it independently improves on a simpler rank-selected baseline.
4. **Selective release.** The framework can refuse an unsupported transformation rather than conceal a poor prediction behind aggregate accuracy.
5. **A heterogeneous randomized benchmark.** The frozen evaluation spans smooth, stressed, contextual, nonstationary, bilinear, global-energy, regime-switching, and rational latent transformations, with negative controls and post-freeze challenge tests.
6. **Classical methods are allowed to win.** Polynomial and RBF kernel ridge models are not merely external baselines; they are available to the router as first-class experts when their inductive biases are appropriate.

The claims are deliberately narrower than “mixture-of-experts is new” or “selective prediction is new.” Both have extensive prior art [3–8]. The contribution evaluated here is the combination of heterogeneous **structural** hypotheses with a selection-separated evidence pipeline for whole-transformation routing.

---

## 2. Related Work

### 2.1 Nonlinear system identification

System identification has a long history of choosing model structure according to expected system dynamics [1]. Polynomial and Volterra representations remain important because they provide systematic expansions for nonlinear input-output relations. Recent work has connected Volterra representations with regularized Hilbert-space and kernel formulations, preserving classical structure while using modern statistical learning machinery [2].

The present work is related to that tradition but addresses a different decision layer. Rather than committing to one nonlinear representation, MX5 maintains a finite pool containing linear, structured residual, latent nonlinear, and kernel models. The routing decision is therefore itself part of the identification procedure.

Piga and Forgione's recent ASIA framework also emphasizes that practical identification involves iterative choices over model class, architecture, training strategy, and hyperparameters [10]. ASIA delegates much of that search to an autonomous coding agent. MX5 instead defines a fixed, reproducible candidate family and focuses on data-separated statistical selection among those structural hypotheses.

### 2.2 Mixture of experts and expert routing

Hierarchical mixtures of experts established the general principle that specialized models can be combined through learned gates [3]. More recently, Rajabi and Salehi applied context-aware gated mixtures of LSTM experts to nonlinear and nonstationary system identification, showing improved robustness under regime changes [4]. These works demonstrate that expert specialization and routing are established ideas.

MX5 differs in three practical respects. First, routing occurs once per identified transformation rather than at every sample. Second, the candidate experts need not share an architecture or even a learning paradigm: dense ridge models, topology-aware semi-parametric regressors, latent neural residual models, and kernel regressors can compete in the same pool. Third, the routing evidence is split across rank and gate datasets so that the model that looks best on the nomination set must still survive independent confirmation.

### 2.3 Selective prediction and risk control

Selective prediction permits a model to abstain when confidence is insufficient. Deep selective classifiers and SelectiveNet demonstrated risk-coverage trade-offs in modern neural prediction [5,6]. More recent selective conformal work provides explicit finite-sample or PAC-style risk-control mechanisms under stated assumptions [7,8].

MX5 adopts the operational idea of selective release but **does not claim conformal coverage**. Its release-screen stage uses a nonparametric bootstrap distribution of release screening-split mean normalized errors and compares an empirical upper percentile against a fixed tolerance. This provides a practical risk screen in the experiments reported here, but it is not a distribution-free guarantee. A conformal or e-value replacement for this stage is a natural theoretical extension.

### 2.4 Selection after choosing among candidates

Routing and model selection can create optimistic evaluation when the best model or policy is chosen on the same examples used for inference. Shihab et al. recently formalized this issue in multi-model routing and derived selection-valid diagnostics that separate oracle opportunity from deployable routing performance [9]. Although their domain is language-model routing rather than system identification, the statistical lesson is directly relevant: **candidate selection and router evaluation should not be silently conflated**.

MX5 addresses this procedurally through disjoint data roles. This study does not present a theorem equivalent to the guarantees in [9]; instead, it evaluates whether strict separation of nomination, confirmation, release screening, and test sets produces reliable empirical routing in randomized nonlinear identification.

---


### 2.5 Novelty Boundary

The individual ingredients of MX5 are not claimed as new in isolation. Mixtures of experts date back decades, nonlinear system identification has extensive linear, Volterra, kernel, neural, and grey-box traditions, and selective prediction/risk control is an established research area. Recent 2026 work specifically applies context-aware mixtures of LSTM experts to nonlinear system identification, while contemporary routing methodology emphasizes the distinction between oracle opportunity and selection-valid deployable routing.

Accordingly, the proposed contribution is **not** any of the following:

- the existence of multiple experts;
- polynomial or RBF kernel regression;
- latent nonlinear features;
- abstention;
- bootstrap resampling;
- or the general idea of model selection.

The contribution evaluated here is the **procedure-level composition**: complete structural model families are treated as competing hypotheses for an entire unknown transformation; internal tuning is separated from structural nomination; a nominated structure must survive independent paired gate evidence against a simpler rank-selected fallback; release is then screened on a separate release-screen sample; and final error is measured only after those decisions are frozen.

This distinction matters because a heterogeneous expert pool can show a large retrospective oracle gap even when no deployable router can realize it. MX5 therefore reports deployable frozen routing performance rather than only the performance of the best test-set expert.

## 3. Static Complex-Valued Operator Identification Problem

For a fixed task, let

\[
x_i \in \mathbb{C}^K,
\qquad
y_i = T(x_i) \in \mathbb{C}^K,
\]

where \(T\) is an unknown complex-valued transformation and \(K\) is the number of carriers or complex coordinates. The transformations studied here are **memoryless across samples** but can contain dense, local, low-rank, nonlinear, and cross-coordinate interactions within each \(K\)-dimensional sample. The present paper therefore does not claim to solve temporal dynamical-system identification.

Given disjoint random samples from the same task transformation, the objective is to learn a predictor

\[
\hat T: \mathbb{C}^K \rightarrow \mathbb{C}^K
\]

with low normalized mean-squared error (NMSE),

\[
\operatorname{NMSE}(\hat Y,Y)
=
\frac{\mathbb{E}\lVert \hat Y-Y\rVert_2^2}
{\mathbb{E}\lVert Y\rVert_2^2 + \epsilon}.
\]

The selective version of the problem also requires an acceptance decision

\[
A\in\{0,1\},
\]

where \(A=1\) means that the fitted transformation is considered supported for release. MX5 uses the operational tolerance

\[
\tau = 10^{-3}.
\]

The desired empirical behavior is therefore twofold:

1. achieve low NMSE across heterogeneous transformation mechanisms; and
2. when independent evidence suggests that the target error is not met, abstain rather than force a prediction.

---


### 3.1 Primary Estimands

The paper reports four primary quantities.

1. **Raw routing error:** mean task-level test NMSE over all 24 frozen tasks, regardless of whether the task is eventually released.
2. **Selective coverage:** the proportion of tasks that pass the independent release-screen rule.
3. **Selective risk:** test NMSE among released tasks, summarized by mean, median, maximum, and threshold-violation count.
4. **Routing gain:** paired task-level error difference between MX5 and each fixed external baseline.

This separation prevents a common ambiguity in selective systems. Low error can be obtained trivially by refusing almost everything, while high coverage can be obtained trivially by releasing everything. MX5 is therefore evaluated on **risk and coverage jointly**, with the \(10^{-3}\) target fixed before final evaluation.

## 4. STABLE-Wave MX5

### 4.1 Six disjoint data roles

Each randomized task produces six independently sampled input-output datasets from the same frozen transformation:

| Split | Size in final benchmark | Purpose |
|---|---:|---|
| Train | 512 | Estimate model parameters |
| Tune | 128 | Select internal hyperparameters |
| Rank | 128 | Nominate a structural candidate |
| Gate | 128 | Independently confirm nominee vs. fallback |
| Release screen | 256 | Apply the empirical release rule after routing is fixed |
| Test | 512 | Final untouched evaluation |

The task transformation itself is common across these splits, but the input samples are independently generated. No test target is used for fitting, tuning, routing, gating, or release screening.

### 4.2 Symbolic complex carrier response

Several MX5 candidates begin with an interpretable diagonal carrier transform. For carrier \(k\), an initial complex response estimate is

\[
r_k =
\frac{\sum_i \overline{x_{ik}}y_{ik}}
{\sum_i |x_{ik}|^2+\epsilon}.
\]

Its gain and unwrapped phase are modeled separately. The carrier coordinate is mapped to a compact basis containing a constant term, polynomial terms through degree three, four sine/cosine harmonics, and boundary indicators. Ridge regression fits gain in decibels and unwrapped phase:

\[
g_k = b_k^\top \beta_g,
\qquad
\phi_k = b_k^\top \beta_\phi.
\]

The resulting symbolic mask is

\[
m_k =
10^{g_k/20}e^{j\phi_k}.
\]

This stage captures smooth global carrier structure with a compact, inspectable representation.

### 4.3 Structured and dense complex linear bridges

After the symbolic mask,

\[
Z = X\operatorname{diag}(m),
\]

MX5 considers two linear backbones.

The **dense bridge** uses complex ridge regression,

\[
W_d =
(Z^H Z + \alpha I)^{-1}Z^H Y.
\]

The **structured bridge** first fits a dense solution, then decomposes the deviation from identity into a circular banded component and a low-rank long-range component:

\[
W_s
=
I + B_{\mathrm{band}} + U_r\Sigma_rV_r^H.
\]

The frozen configuration uses circular bandwidth two and rank two, followed by singular-value clipping for stability. The structured bridge therefore represents local cross-carrier coupling plus a small number of global linear modes, while the dense bridge makes fewer structural assumptions.

### 4.4 Topology-adaptive nonlinear residual expert

For a bridge output \(Z\), the residual target is

\[
R = Y-Z.
\]

MX5 scores circular carrier offsets according to the correlation of shifted input-derived features with the residual. It always includes a small local neighborhood and then adds the most informative discovered offsets.

For each selected offset, the feature bank includes real and imaginary parts, magnitude-squared terms, hyperbolic-tangent nonlinearities, and cross-products with the center carrier. Per-output ridge regressions map these features to complex residual corrections.

Two topology budgets are fitted: a compact discovered-offset model and a nearly global model. Tune-set error determines whether one or both are retained in an equal-weight ensemble. This produces the `structured_base` and `dense_base` candidates depending on the upstream bridge.

### 4.5 Shared-context and per-output context experts

Some transformations depend on a latent mixture shared across all outputs; others use output-specific mixtures.

The **shared-context expert** builds a circular shift design matrix from the bridge output, learns a regularized shared context signal, and expands that signal through nonlinear features including saturating functions and energy-sensitive modulation. Those context features are concatenated with the topology-adaptive feature tensor before the final residual ridge fit.

The **per-output expert** learns an output-specific latent context from the full real/imaginary bridge representation. Each output carrier receives its own complex context coordinates, which are expanded using a fixed nonlinear basis before ridge fitting.

These mechanisms yield four candidates:

- `structured_shared`,
- `structured_per_output`,
- `dense_shared`,
- `dense_per_output`.

### 4.6 Latent-projection nonlinear experts

Hard random transformations revealed a separate failure mode: nonlinear responses driven by a small number of unknown global complex mixtures. MX5 therefore includes a compact latent residual model.

For normalized complex input \(z\), the model learns \(q\) complex projections

\[
c = zW,
\qquad q\in\{10,14\}.
\]

A fixed nonlinear basis is then applied to each latent coordinate. It contains linear real/imaginary components, saturating hyperbolic tangents, rational terms of the form

\[
\frac{\Re c}{1+|c|^2},
\qquad
\frac{\Im c}{1+|c|^2},
\]

energy-centered saturation, and odd energy-weighted terms. A learned linear map converts those latent features into a complex residual.

The latent model is fitted at two different points in the pipeline:

- `masked_latent`: immediately after the symbolic diagonal mask;
- `dense_latent`: after the dense complex linear bridge.

The latent dimension \(q\in\{10,14\}\) is selected on the tune split only.

### 4.7 Polynomial and RBF kernel residual experts

The final two candidates are classical kernel ridge regressors. Both begin from the symbolic-plus-dense-linear baseline and model the remaining complex residual from standardized real/imaginary features.

The polynomial expert searches degree \(d\in\{2,3\}\), additive constant \(c\in\{0,1\}\), and ridge penalties \(\alpha\in\{0.01,0.1,1\}\).

The RBF expert uses a median-distance scale and searches three kernel-width multipliers and the same ridge-penalty grid.

These candidates are important methodologically. MX5 does not define success as “the new bespoke expert must beat classical methods.” If a polynomial model is best supported by the data, the router is expected to select it.


### 4.8 Frozen Routing Procedure

The complete deployment logic can be summarized as follows.

```text
Input:
    D_train, D_tune, D_rank, D_gate, D_screen
    candidate family F
    simple fallback family S
    release tolerance tau = 1e-3

1. Fit every candidate f in F using D_train.
2. Use D_tune only for candidate-internal hyperparameter selection.
3. Evaluate all frozen candidates on D_rank.
4. nominee <- lowest-error candidate on D_rank.
5. fallback <- lowest-error candidate in S on D_rank.
6. If nominee != fallback:
       compare paired per-sample errors on D_gate.
       accept nominee only if the predeclared gate criterion is met;
       otherwise select fallback.
7. Evaluate the selected identifier on D_screen.
8. Bootstrap the mean normalized release screening loss 600 times.
9. supported <- (95th percentile of bootstrap means <= tau).
10. If supported:
       release predictor.
    Else:
       abstain / mark transformation unsupported.
11. D_test is opened only for final scientific evaluation.
```

The rank split is allowed to search the candidate pool; the gate split is not. The gate answers only a binary post-nomination question: whether the nominated structure shows independent evidence of improvement over a simpler fallback. Release screening occurs after the routing choice is fixed.

### 4.9 Candidate pool

The frozen MX5 candidate pool contains 12 complete structural hypotheses:

| Candidate | Bridge / representation | Residual model |
|---|---|---|
| `structured_linear` | Symbolic + structured bridge | None |
| `structured_base` | Symbolic + structured bridge | Topology-adaptive ridge ensemble |
| `structured_shared` | Symbolic + structured bridge | Shared-context nonlinear ridge |
| `structured_per_output` | Symbolic + structured bridge | Per-output context nonlinear ridge |
| `dense_linear` | Symbolic + dense bridge | None |
| `dense_base` | Symbolic + dense bridge | Topology-adaptive ridge ensemble |
| `dense_shared` | Symbolic + dense bridge | Shared-context nonlinear ridge |
| `dense_per_output` | Symbolic + dense bridge | Per-output context nonlinear ridge |
| `masked_latent` | Symbolic mask | Latent-projection nonlinear residual |
| `dense_latent` | Symbolic + dense bridge | Latent-projection nonlinear residual |
| `kernel_poly` | Symbolic + dense linear | Polynomial KRR residual |
| `kernel_rbf` | Symbolic + dense linear | RBF KRR residual |

### 4.10 Rank nomination and independent gate

All 12 candidates are evaluated on the rank split. The lowest rank-set MSE becomes the **nominee**.

A simpler fallback is separately selected from

\[
\mathcal{S}=
\{
\texttt{structured\_base},
\texttt{dense\_base},
\texttt{kernel\_poly},
\texttt{kernel\_rbf}
\}
\]

using rank-set performance.

If nominee and fallback differ, the gate split compares their per-sample errors. Let

\[
e_i^{(f)} =
\frac1K\lVert \hat y_i^{(f)}-y_i\rVert_2^2,
\qquad
e_i^{(n)} =
\frac1K\lVert \hat y_i^{(n)}-y_i\rVert_2^2
\]

and

\[
d_i=e_i^{(f)}-e_i^{(n)}.
\]

The nominee is accepted only when

\[
\bar d - 1.96\frac{s_d}{\sqrt n}>0
\]

and its relative mean-error gain exceeds \(5\times10^{-4}\). Otherwise the simpler fallback is retained.

This is a practical paired confirmation rule. It is not presented as a new multiple-testing theorem; its purpose is to prevent a rank-set winner from automatically becoming the deployed model.

### 4.11 Independent empirical release screen

After routing is complete, the chosen model is evaluated on the release-screen split. For each release-screen sample,

\[
\ell_i =
\frac{\lVert \hat y_i-y_i\rVert_2^2}
{\mathbb{E}_{\mathrm{screen}}\lVert y\rVert_2^2+\epsilon}.
\]

MX5 draws 600 nonparametric bootstrap resamples of the \(n=256\) sample losses and calculates the mean loss for each resample. Let \(U_{0.95}\) denote the 95th percentile of those bootstrap means. The transformation is released only if

\[
U_{0.95}\le \tau,
\qquad
\tau=10^{-3}.
\]

The software retains legacy names such as `certification`, `cert_nmse`, `cert_upper95`, and the prediction flag `require_certified=True`. In this manuscript these are described as **empirical release-screen** quantities to avoid implying a formal statistical certificate. When `require_certified=True`, the implementation refuses prediction if the empirical release rule is not met.

---

## 5. Randomized Experimental Design

### 5.1 Random inputs

All scientific evidence in this study uses randomly generated data. No real-world dataset or fixed hand-curated signal corpus is used.

Inputs are sampled from three complex distributions:

- QPSK;
- normalized 16-QAM;
- circular complex Gaussian.

Depending on the transformation family, inputs also receive independently generated amplitude and phase nuisance jitter.

### 5.2 Transformation families

Eight random mechanism families form the frozen benchmark.

**Original randomized.** Smooth gain/phase response, local circular mixing, low-rank long-range coupling, nonlinear even/odd carrier coupling, and one of several pointwise nonlinearities.

**Stress.** A stronger version of the original family with increased cross-carrier mixing, phase/gain variation, nonlinear coupling, and pointwise distortion.

**Shared latent context.** A common hidden circular mixture drives a nonlinear context applied across outputs.

**Nonstationary per-output context.** Different outputs depend on different random hidden carrier combinations.

**Bilinear / Volterra-like.** Sparse random quadratic interactions of the form

\[
z_a\overline{z_b}
\]

are injected into randomly chosen output carriers.

**Global latent energy.** Several unknown complex projections are transformed through nonlinear energy responses and remixed into the output.

**Soft regime switching.** Two different random linear systems are blended using a smooth sample-dependent gate.

**Rational latent mixture.** Unknown global projections are transformed through a saturating rational map

\[
h(c)=\frac{c}{1+0.6|c|^2}
\]

and linearly remixed into the output.

The router is not given the family label.


### 5.3 Development, Freeze, and Internal-Validation Boundary

The method was evolved through repeated random-data hypothesis tests. Developmental failures led to the introduction of harder random transformation families and to changes in the candidate pool. This adaptive development phase is reported in Section 7 but is **not counted as independent confirmation**.

The frozen internal-validation boundary was defined when MX5, its twelve-candidate pool, the six data roles, the gate rule, the bootstrap count, and the release threshold \(\tau=10^{-3}\) were frozen. A new 24-task seed manifest was then generated. Those task labels were not used to alter MX5.

After the 24-task benchmark, additional challenge families were generated for stress testing. Because those tests occurred after the method freeze, they provide useful robustness evidence. They are nevertheless reported separately from the primary 24-task internal-validation estimands to avoid silently expanding the primary internal-validation dataset after seeing results.

### 5.4 Frozen final benchmark

The final benchmark contains three independent random transformations per family, for a total of 24 tasks. Carrier dimension varies among

\[
K\in\{16,24,32\},
\]

and the input distribution is independently chosen from the QPSK, 16-QAM, and complex Gaussian families according to each generator.

The final seed manifest was frozen before the reported evaluation.

### 5.5 External baselines

Three fixed baselines are reported on all 24 test tasks:

1. **Dense complex linear:** symbolic mask followed by dense complex ridge regression.
2. **RBF-KRR:** dense-linear prediction plus an RBF-kernel residual model.
3. **Polynomial-KRR:** dense-linear prediction plus a degree-2/3 polynomial-kernel residual model.

The two kernel models are also members of the MX5 candidate pool. This is intentional: the comparison measures the value of adaptive structural routing relative to forcing one model family globally.

### 5.6 Statistical Analysis

The random **task**, not the individual complex carrier or sample, is the primary unit for across-method inference. This avoids treating hundreds of correlated within-task predictions as independent replications of the routing procedure.

For each fixed baseline, H1 is evaluated using a paired one-sided Wilcoxon signed-rank test on the 24 task-level NMSE differences. Because three baseline hypotheses are tested, the manuscript reports Holm-adjusted significance [13]. The raw \(p\)-values in the frozen artifact are \(5.96\times10^{-8}\) for dense linear, \(5.96\times10^{-8}\) for RBF-KRR, and \(3.27\times10^{-4}\) for polynomial-KRR; all remain significant after Holm correction.

Bootstrap intervals reported for aggregate NMSE resample the 24 tasks rather than individual rows within tasks. These intervals quantify variation across the frozen randomized task set; they should not be interpreted as guarantees over an undefined universe of all nonlinear systems.

Release-rate uncertainty is summarized with an exact Clopper-Pearson binomial interval. With 22 releases in 24 tasks, observed coverage is 91.67% and the two-sided 95% interval is approximately **73.0%–99.0%**.

For the release threshold, 0/22 released tasks exceeded \(10^{-3}\) on final test. This is an encouraging empirical result but not proof of zero population violation probability. Under a simple independent Bernoulli abstraction, the one-sided exact 95% upper bound corresponding to 0 violations in 22 trials is approximately **12.7%**. The heterogeneous task design makes this bound only a scale summary, not a deployment guarantee.

The empirical bootstrap release screen is not treated as a formal confidence bound. It is a fixed empirical decision statistic. Formal selective conformal or e-value risk control would be required for distribution-free finite-sample guarantees under the corresponding assumptions.


## 6. Results

### 6.1 Primary Frozen Internal-Validation Results

The family table reports **both all-task and released-only quantities**. Thus a family maximum can exceed the \(10^{-3}\) release target when the corresponding task was rejected; released-only columns show the operating behavior after screening.

| Family | Tasks | Released | All-task mean NMSE | All-task max NMSE | Released mean NMSE | Released max NMSE | Selected expert(s) |
|---|---:|---:|---:|---:|---:|---:|---|
| Original randomized | 3 | 3 | 1.269e-05 | 2.340e-05 | 1.269e-05 | 2.340e-05 | dense_base (2), structured_base (1) |
| Stress | 3 | 3 | 3.520e-06 | 6.802e-06 | 3.520e-06 | 6.802e-06 | structured_base (2), dense_base (1) |
| Shared latent context | 3 | 3 | 2.276e-04 | 2.444e-04 | 2.276e-04 | 2.444e-04 | dense_shared (3) |
| Nonstationary per-output context | 3 | 2 | 6.081e-04 | 1.032e-03 | 3.961e-04 | 4.125e-04 | kernel_poly (3) |
| Bilinear / Volterra-like | 3 | 3 | 3.873e-06 | 5.729e-06 | 3.873e-06 | 5.729e-06 | kernel_poly (3) |
| Global latent energy | 3 | 3 | 2.633e-04 | 5.292e-04 | 2.633e-04 | 5.292e-04 | dense_latent (3) |
| Soft regime switching | 3 | 3 | 4.816e-06 | 5.906e-06 | 4.816e-06 | 5.906e-06 | kernel_poly (3) |
| Rational latent mixture | 3 | 2 | 1.124e-03 | 2.678e-03 | 3.471e-04 | 6.397e-04 | dense_latent (2), masked_latent (1) |

Across all 24 tasks, including predictions from the two tasks that were ultimately rejected,

\[
\overline{\operatorname{NMSE}} = 2.810e-04,
\]

with bootstrap 95% interval

\[
[1.042e-04,\;5.430e-04].
\]

The system released 22/24 tasks:

\[
\text{coverage} = 91.67\%.
\]

Among those 22 released transformations:

- mean test NMSE was **1.379e-04**;
- bootstrap 95% interval for mean released NMSE was **[6.479e-05, 2.221e-04]**;
- median test NMSE was **1.579e-05**;
- worst released test NMSE was **6.397e-04**.

The worst released value remained below the predeclared \(10^{-3}\) release threshold.

The two rejected tasks subsequently tested at approximately \(1.03\times10^{-3}\) and \(2.68\times10^{-3}\). Thus, in this frozen benchmark, abstention prevented both above-threshold cases from being represented as supported predictions.

The exact two-sided 95% binomial interval for the observed release rate of 22/24 is **73.0%–99.0%**. Thus the point estimate of 91.67% should not be read as a precisely known population coverage rate.

Likewise, zero observed violations among 22 releases is not equivalent to zero deployment risk. A simple one-sided exact 95% upper bound for a Bernoulli violation probability after 0/22 events is approximately **12.7%**. The value is reported to prevent overinterpretation of a small zero-event sample; MX5's bootstrap screen is an empirical filter, not a formal distribution-free certificate.


### 6.2 Router behavior reflects mechanism structure

MX5 selected six different candidate types in the frozen benchmark:

| Selected expert | Number of tasks |
|---|---:|
| `kernel_poly` | 9 |
| `dense_latent` | 5 |
| `structured_base` | 3 |
| `dense_base` | 3 |
| `dense_shared` | 3 |
| `masked_latent` | 1 |

The pattern is qualitatively meaningful despite the family label never being passed to the router. All three bilinear tasks selected polynomial KRR. All three regime-switching and all three nonstationary tasks also selected polynomial KRR in this particular frozen sample. All three global-energy tasks selected `dense_latent`, all three shared-context tasks selected `dense_shared`, and the rational family used latent models at both placements.

This result supports the central motivation of structural routing: different random mechanisms favor materially different inductive biases.


The table above alone does not distinguish the benefit of **routing** from the benefit of maintaining a larger candidate pool. Section 6.5 therefore evaluates every frozen candidate as a forced model on every untouched primary test task. This post-hoc diagnostic was not used to alter MX5.


### 6.3 External baseline comparison

Baseline comparisons use **raw MX5 predictions on all 24 tasks**, including the two tasks that the selective deployment rule would reject.

| Method | Mean NMSE | Error ratio to MX5 | MX5 wins | One-sided Wilcoxon \(p\) |
|---|---:|---:|---:|---:|
| Dense complex linear | 4.418e-03 | 15.72× | 24/24 | 5.96e-08 |
| RBF kernel ridge | 3.358e-03 | 11.95× | 24/24 | 5.96e-08 |
| Polynomial kernel ridge | 3.192e-03 | 11.36× | 15/24 | 0.000327 |
| **STABLE-Wave MX5** | **2.810e-04** | **1.00×** | — | — |

Holm-adjusted \(p\)-values for the three comparisons are approximately \(1.79\times10^{-7}\), \(1.79\times10^{-7}\), and \(3.27\times10^{-4}\), respectively.

The polynomial baseline deserves special interpretation. MX5 does not beat polynomial KRR because polynomial KRR is excluded; it often **uses polynomial KRR internally**. The improvement arises because polynomial KRR is retained when appropriate and replaced when a different structural hypothesis generalizes better.


### 6.4 Task-Level Effect Sizes and Outlier Robustness

Mean error ratios can be dominated by a small number of tasks on which one baseline fails severely. We therefore also report task-wise baseline/MX5 error ratios.

| Baseline | Median task-wise error ratio | Geometric-mean error ratio | Smallest ratio | Largest ratio |
|---|---:|---:|---:|---:|
| Dense complex linear | 2.17× | 11.74× | 1.00× | 353.42× |
| RBF kernel ridge | 2.16× | 7.68× | 1.02× | 262.99× |
| Polynomial kernel ridge | 1.87× | 6.43× | 1.00× | 248.90× |

All ratios are baseline NMSE divided by MX5 NMSE, so values above one favor MX5. The median improvements of approximately 1.87×–2.17× show that the aggregate advantage is not solely an artifact of a few catastrophic baseline failures. The larger geometric-mean ratios reflect genuine heavy-tailed baseline failures on some mechanism families.


### 6.5 Full Forced-Expert Matrix and Structural-Selection Regret

To address whether MX5 benefits merely from having a large expert pool, the frozen procedure was rerun on the same primary seed manifest solely so that predictions from **all twelve already-frozen candidates** could be retained and scored on the untouched test sets. No test result was used to alter model fitting, routing, gating, or release decisions. For each task, the retrospective *test oracle* is defined only for analysis as the candidate with the smallest test NMSE.

The expert selected by MX5 using train/tune/rank/gate/release-screen data matched the retrospective test-best candidate on

\[
\boxed{24/24}
\]

tasks. The observed mean structural-selection regret,

\[
\frac1{24}\sum_t
\left(
L_{\text{MX5},t} -
\min_j L_{j,t}
\right),
\]

was **0.000e+00**. In other words, no primary task showed positive test regret relative to the twelve-candidate oracle. This is a strong empirical routing result, but it is not a theorem that MX5 will recover the oracle on future tasks.

| Forced candidate | Mean test NMSE | Median test NMSE | Test-best tasks | MX5 strict wins | Ties with MX5 |
|---|---:|---:|---:|---:|---:|
| `dense_latent` | 8.726e-04 | 4.789e-04 | 5/24 | 19/24 | 5/24 |
| `masked_latent` | 2.814e-03 | 1.543e-03 | 1/24 | 23/24 | 1/24 |
| `kernel_poly` | 3.192e-03 | 3.531e-04 | 9/24 | 15/24 | 9/24 |
| `kernel_rbf` | 3.358e-03 | 3.705e-04 | 0/24 | 24/24 | 0/24 |
| `dense_base` | 3.663e-03 | 1.810e-04 | 3/24 | 21/24 | 3/24 |
| `dense_shared` | 3.689e-03 | 2.192e-04 | 3/24 | 21/24 | 3/24 |
| `structured_per_output` | 3.772e-03 | 2.059e-04 | 0/24 | 24/24 | 0/24 |
| `dense_per_output` | 3.800e-03 | 2.642e-04 | 0/24 | 24/24 | 0/24 |
| `structured_base` | 3.959e-03 | 2.095e-04 | 3/24 | 21/24 | 3/24 |
| `dense_linear` | 4.418e-03 | 6.391e-04 | 0/24 | 24/24 | 0/24 |
| `structured_shared` | 5.557e-03 | 4.577e-04 | 0/24 | 24/24 | 0/24 |
| `structured_linear` | 1.097e-02 | 8.505e-03 | 0/24 | 24/24 | 0/24 |

The retrospectively best *single fixed* candidate by mean test NMSE was `dense_latent` at **8.726e-04**, whereas adaptive MX5 achieved **2.810e-04**, a descriptive **3.11×** error reduction. Because the identity of this best fixed candidate is chosen after inspecting the 24 test tasks, that particular 3.11× comparison is treated as descriptive rather than as a prespecified inferential test.

As a post-hoc robustness check, paired one-sided Wilcoxon comparisons of frozen MX5 against each of the twelve forced candidates remain significant after Holm correction across all twelve comparisons (largest adjusted \(p\approx0.000109\)). These analyses strengthen the interpretation that routing contributes beyond the mere presence of a rich expert pool, but they are explicitly secondary to the three prespecified external-baseline comparisons.

The complete 24-by-12 forced-expert matrix is supplied as a machine-readable supplement.

### 6.6 Release-Screen/Test Agreement

Across the 24 primary frozen tasks, the descriptive Pearson correlation between release-screen NMSE and untouched test NMSE was

\[
r=0.99987.
\]

This high value is expected to some extent because the release-screen and test sets are independent draws from the **same frozen transformation and input distribution**. It is therefore evidence of within-task replication, not evidence of robustness to distribution shift and not evidence of formal calibration.

### 6.7 Expanded Negative Controls

The original artifact contained four independently permuted controls. To strengthen this sanity check after MX5 was frozen, eight additional controls were generated—one from each transformation family. In every control, the input-output pairing was independently permuted in **each label-bearing pre-test split** before fitting, while the final test pairing remained unpermuted.

The result is now:

\[
\boxed{12/12\ \text{negative controls rejected}}
\]

The eight new release-screen upper values ranged from approximately 1.031 to 1.048 NMSE, and test NMSE against the true pairing remained approximately 1.009–1.032. In all eight new runs the router collapsed to the simple `structured_linear` model and the release screen refused deployment.

These controls show that MX5 does not obtain its reported low error from output marginals, routing mechanics, or the candidate pool alone when the task relationship is destroyed. They remain a sanity check rather than a formal hypothesis test about every possible null mechanism.



### 6.8 Secondary Post-Freeze Validation Cohort

A second validation cohort was generated **after MX5 was frozen and without any model, candidate-pool, threshold, gate, or generator-family changes**. It contains 24 new random tasks: three per family, with one task at each of \(K=16,24,32\). This cohort was not used to modify MX5 and is reported separately from the primary internal-validation set.

| Family | Tasks | Released | All-task mean NMSE | Released mean NMSE | Released max NMSE | Selected expert(s) |
|---|---:|---:|---:|---:|---:|---|
| Original randomized | 3 | 3 | 2.165e-05 | 2.165e-05 | 4.156e-05 | structured_base (2), dense_base (1) |
| Stress | 3 | 3 | 2.417e-05 | 2.417e-05 | 6.450e-05 | structured_base (2), dense_base (1) |
| Shared latent context | 3 | 3 | 5.233e-04 | 5.233e-04 | 7.145e-04 | dense_shared (3) |
| Nonstationary per-output context | 3 | 3 | 4.372e-04 | 4.372e-04 | 5.475e-04 | kernel_poly (3) |
| Bilinear / Volterra-like | 3 | 3 | 3.504e-06 | 3.504e-06 | 7.463e-06 | kernel_poly (3) |
| Global latent energy | 3 | 3 | 3.201e-04 | 3.201e-04 | 4.760e-04 | dense_latent (3) |
| Soft regime switching | 3 | 3 | 9.295e-06 | 9.295e-06 | 1.602e-05 | kernel_poly (2), dense_base (1) |
| Rational latent mixture | 3 | 1 | 1.564e-03 | 6.783e-04 | 6.783e-04 | masked_latent (3) |

Overall, the second cohort produced:

- **22/24 releases (91.67%)**;
- **0/22 released-task threshold violations**;
- raw mean NMSE **3.629e-04**;
- mean released NMSE **2.135e-04**;
- worst released NMSE **7.145e-04**.

The two rejected tasks were both rational-mixture cases. One was a genuine above-target failure with test NMSE \(3.102\times10^{-3}\). The other was a conservative false rejection: its release-screen upper value was \(1.061\times10^{-3}\), while its final test NMSE was \(9.108\times10^{-4}\). This is an important counterexample to any suggestion that the screen is perfectly calibrated: it can sacrifice coverage near the decision boundary.

MX5 again beat dense linear and RBF-KRR on **24/24** tasks and polynomial-KRR on **16/24**. Paired one-sided Wilcoxon \(p\)-values were 9.11e-06, 9.11e-06, and 5.85e-05, respectively.

If the two frozen cohorts are pooled **descriptively**, they contain 48 tasks with 44 releases. The resulting release-rate point estimate is 91.67% with exact 95% interval **80.0%–97.7%**. No released task in either cohort exceeded \(10^{-3}\), so 0/44 violations were observed. A simple one-sided zero-event 95% upper bound is still **6.6%**, which remains far too large to support a high-stakes safety claim. The pooled calculation is therefore a precision summary, not a formal deployment guarantee.

### 6.9 Post-Freeze Composed Transformations

After MX5 was frozen, a new random generator was constructed by composing several mechanisms rather than merely increasing parameter strength within an existing family. It combined linear mixing, rational latent response, latent-energy response, bilinear effects, and soft regime behavior.

MX5 released all three post-freeze tasks. Untouched test NMSE values were

\[
4.76\times10^{-6},
\quad
2.82\times10^{-6},
\quad
5.52\times10^{-6}.
\]

All three selected `dense_latent`.

These results provide evidence against the narrowest form of generator-specific overfitting, although three tasks are not sufficient to establish universal compositional generalization.

### 6.10 Input-Distribution Shift

Three additional post-freeze tests changed the input distribution between model development/release screening and final evaluation.

- global-energy: Gaussian \(\rightarrow\) QPSK;
- rational: Gaussian \(\rightarrow\) 16-QAM;
- bilinear: Gaussian \(\rightarrow\) QPSK.

All three remained accurate. The largest shifted test NMSE was \(1.90\times10^{-4}\), on the global-energy task.

This experiment is useful but limited. The release screen itself was computed in-distribution; therefore the result demonstrates empirical robustness to these shifts, not a formal guarantee under arbitrary distribution shift.

### 6.11 Sample Efficiency

Two fresh tasks were evaluated at increasing training-set sizes.

| Family | Train pairs | Selected expert | Released? | Release-screen upper value | Test NMSE |
|---|---:|---|---|---:|---:|
| Original | 128 | `structured_per_output` | Yes | 4.43e-5 | 4.52e-5 |
| Original | 256 | `dense_base` | Yes | 3.03e-6 | 2.88e-6 |
| Original | 512 | `dense_base` | Yes | 1.61e-6 | 1.56e-6 |
| Global energy | 128 | `kernel_poly` | No | 1.37e-2 | 1.32e-2 |
| Global energy | 256 | `kernel_poly` | No | 1.10e-2 | 1.06e-2 |
| Global energy | 512 | `dense_latent` | Yes | 2.13e-4 | 2.07e-4 |

The global-energy case illustrates a desirable selective behavior. At 128 and 256 training pairs, the evidence does not support the latent structure strongly enough and the system rejects the task. At 512 pairs, the router changes structural hypothesis, passes the release screen, and test error drops by roughly two orders of magnitude.

### 6.12 Computational Cost

The reference implementation required a mean of **9.44 s** and median of **9.87 s** per final benchmark task in the recorded development environment. Hardware was not standardized as part of the frozen artifact, so these numbers should be interpreted as reproducibility diagnostics rather than a platform-independent speed benchmark.

---


### 6.13 Evidence Summary

The evidence now separates the original primary benchmark from post-freeze diagnostics and validation.

| Question | Evidence | Interpretation |
|---|---|---|
| Does adaptive routing beat the three prespecified fixed baselines? | Primary 24 tasks: lower than dense linear on 24/24, RBF-KRR on 24/24, polynomial-KRR on 15/24; all three paired tests significant after Holm correction | **Supported within primary internal validation** |
| Does routing add value beyond owning twelve experts? | Forced-expert diagnostic: pre-test MX5 selection equals retrospective test-best expert on 24/24 primary tasks; best fixed expert mean NMSE 8.726e-04 vs MX5 2.810e-04 | **Strong post-hoc routing evidence** |
| Does the empirical release screen behave as intended? | Primary: 22/24 released, 0/22 violations. Secondary: 22/24 released, 0/22 violations. Pooled descriptively: 0/44 violations | **Empirically consistent; not a formal risk guarantee** |
| Does the method manufacture signal under broken pairing? | 12/12 permuted controls rejected | **Strong sanity-check evidence** |
| Does the router specialize structurally? | Six expert types selected in primary benchmark; classical polynomial models win appropriate families | **Supported descriptively** |
| Is there independent external validation? | No | **Not established** |
| Is there temporal dynamical-system validation? | No | **Out of scope** |
| Is release risk distribution-free or finite-sample guaranteed? | No; bootstrap screen only | **Not established** |

This table intentionally prevents the strongest empirical observations from being interpreted as stronger claims than the experiment supports.


## 7. Evolutionary Development and Ablative Evidence

MX5 was not designed as a single monolithic architecture. It emerged from repeated randomized hypothesis-test cycles. A component was retained only when it improved held-out random performance or repaired a reproducible failure mode.

The main accepted changes were:

| Evolution | Observed role |
|---|---|
| Random hard-family expansion | Revealed failures hidden by the original four-family benchmark |
| Symbolic + complex linear hierarchy | Removed smooth/global linear structure before nonlinear fitting |
| Structured banded + low-rank bridge | Efficiently modeled local and low-rank cross-carrier coupling |
| Topology-adaptive residual discovery | Reduced error when relevant carrier separations varied by task |
| Shared/per-output context experts | Addressed common vs. output-specific latent context |
| Latent projection expert | Reduced global-mixture failures from roughly 0.008–0.030 NMSE to the \(10^{-4}\) scale in successful cases |
| Dual latent placement | Allowed nonlinear structure to be modeled before or after dense linear correction |
| Polynomial/RBF experts inside router | Allowed classical nonlinear models to win when appropriate |
| Independent release-screen split | Converted the system from forced prediction to selective release |
| Post-freeze controls | Tested permutation failure, new compositions, sample efficiency, and input shift |

Several plausible extensions were rejected:

- a generic two-layer MLP residual fallback, which overfit relative to structured experts;
- a direct rational latent network, which became unstable at larger \(K\);
- a variable-projection rational model, which was more stable but not sufficiently accurate;
- a random nonlinear feature bank, which did not repair the hard latent failures;
- a spectral/cross-covariance latent discovery method, which was fast but inaccurate;
- increasing the number of training pairs without changing representation, which did not fix structural mismatch.

This developmental record matters because it shows that final complexity was not added indiscriminately. Neural components from earlier SAIR-Wave variants were removed when semi-parametric structural models generalized better. Conversely, a classical polynomial kernel expert was added when a deliberate bilinear challenge demonstrated that it was the correct inductive bias.

---

## 8. Discussion

### 8.1 Structural routing rather than universal approximation

The frozen results suggest that the principal advantage of MX5 is not one unusually powerful predictor. It is the refusal to assume that one representation is universally appropriate.

The expert selections align with the mechanisms that generated the data:

- polynomial kernels dominate sparse bilinear transformations;
- latent projection models dominate global-energy and rational mixture transformations;
- shared-context models dominate shared hidden circular mixtures;
- structured or dense topology models dominate the original and stress families.

Because the router does not observe family identity, those choices must be inferred from performance on independently sampled inputs from the same transformation.

This is the central empirical finding of the paper.


### 8.2 Routing Gain Versus Candidate-Pool Capacity

A fair criticism of an adaptive router is that it has access to more model capacity and more selection data than any single fixed baseline. The forced-expert matrix makes that issue measurable.

The strongest fixed member of the twelve-model pool is `dense_latent` by retrospective mean test NMSE, yet forcing it globally is still substantially worse than task-specific MX5 routing. More importantly, the selected MX5 expert coincides with the retrospective test-best candidate on every one of the 24 primary tasks. Thus the primary gain is not explained merely by adding one superior expert to the pool; it comes from choosing different structures on different tasks.

At the same time, MX5 should not be compared to a fixed model as though both procedures consume identical information. MX5 uses task-specific tune, rank, and gate sets explicitly for structural choice. The appropriate interpretation is therefore:

> **MX5 evaluates the value of spending additional random observations on structural adaptation, not a parameter-count-matched contest between one model and another.**

A future data-efficiency study should compare routing and fixed models under equal total observation budgets, including cross-fitting variants that reuse observations more efficiently.


### 8.3 Why separate rank and gate splits

The rank split searches over a finite candidate pool. That search itself creates selection pressure. A model that wins rank may have won partly because of finite-sample noise.

The independent gate asks a narrower question after nomination:

> Does this specific nominated model show a paired, positive improvement over a simpler fallback on new data?

The separation does not provide a complete post-selection theorem, but it reduces the direct reuse of evidence. This design is conceptually aligned with recent work emphasizing selection-valid routing evaluation [9].

### 8.4 Empirical Release Screening as an Operating Rule

MX5's selective operating contract is simple:

\[
\text{release only if empirical release screen}\le10^{-3}.
\]

In the primary frozen evaluation, 22 tasks passed this screen and all 22 subsequently remained below threshold on test. A second 24-task post-freeze cohort repeated the same 22/24 release count with 0/22 released-task threshold violations, while also showing one conservative false rejection near the threshold. The screen therefore behaved consistently in these cohorts but should not be described as perfectly calibrated.

That correspondence is encouraging, but the terminology must remain precise. The bootstrap percentile is an empirical screening statistic. It does not establish the finite-sample, distribution-free risk control supplied by modern conformal or e-value methods [7,8]. The present paper therefore reports an empirical release-screening experiment rather than a theorem.


### 8.5 Why the Release Screen Is Not Called a Certificate

Modern selective conformal and e-value methods can provide finite-sample risk guarantees under explicit assumptions [7,8,14]. MX5 does not implement those guarantees. Its screen bootstraps the mean normalized loss on an independent sample and compares an empirical upper percentile with a fixed engineering tolerance.

Retrofitting a conformal or e-value decision rule **after observing the MX5 results** and then presenting the old benchmark as validation of that new rule would be methodologically unsound. Such a change would define a new method. The present manuscript therefore keeps MX5 frozen, renames the mechanism *empirical release screening*, and makes formal risk control a separate prospective extension.

A future version could predeclare a bounded risk functional and replace the bootstrap rule with selective conformal risk control, an e-value procedure such as SCoRE, or a joint finite-sample selective certificate. That extension should then be evaluated on a new frozen seed manifest rather than retroactively on the current test results.

### 8.6 Relation to Broader System Identification

Recent work such as ASIA emphasizes that identifying a nonlinear system involves choices over representation, training, and validation rather than only fitting coefficients [10]. MX5 supports a complementary view:

> **model structure itself can be treated as a testable hypothesis, and the identification algorithm can allocate independent evidence to choosing, confirming, and accepting that hypothesis.**

This perspective is applicable beyond the exact candidate pool used here. A future implementation could replace the present experts with state-space, NARX, Gaussian-process, neural-operator, physics-informed, or application-specific grey-box models while preserving the same data-role architecture.

---


### 8.7 What the Results Establish—and What They Do Not

The strongest evidence concerns **procedure-level structural adaptation**. MX5 does not win because every internal expert is superior to classical alternatives. Indeed, polynomial KRR is selected on nine of the 24 final tasks. The advantage arises because the procedure can retain a classical model on mechanisms for which it is appropriate and choose a different structural hypothesis when another model generalizes better.

The study also demonstrates that using six disjoint data roles is operationally feasible in a synthetic setting where new random observations are inexpensive. It does not establish that six-way splitting is sample-optimal. In data-scarce applications, cross-fitting, reusable holdout methods, or formal selective-inference procedures may provide better efficiency.

Finally, the 24-task benchmark establishes performance on a *defined generator distribution*, not on “nonlinear systems in general.” This wording is intentional. The post-freeze composition and input-shift experiments widen the empirical support, but they remain simulation evidence.

## 9. Limitations


**First, the benchmark remains internal to the research program.** The second 24-task cohort improves precision, and the forced-expert matrix clarifies routing value, but the same eight generator families originate from the developmental program. These experiments therefore strengthen internal validity, not external validity. An independently authored random generator suite would materially strengthen the claim.

**Second, all data are synthetic and randomly generated.** This is an explicit design constraint and is useful for controlled mechanism testing, but it does not demonstrate performance on measured communication channels, biological systems, industrial processes, or other physical datasets.

**Third, the evaluated operators are static across samples.** They may be highly nonlinear across complex coordinates, but they do not contain temporal hidden state, feedback, or long memory. The broader nonlinear system-identification literature is relevant, yet the empirical object in this paper is a static input-output operator.

**Fourth, the sample size remains modest for rare release-screen failures.** The primary and secondary cohorts together contain 48 tasks and 44 releases. Observing 0/44 released-task violations reduces the simple one-sided zero-event 95% upper bound to approximately 6.6%, but that is still far too weak for a high-stakes safety claim.

**Fifth, the empirical release screen is bootstrap-based and lacks a formal distribution-free finite-sample guarantee.** Selective conformal or e-value methods provide relevant formal alternatives [7,8,14], but adopting one would define a new prospective method rather than retroactively strengthen MX5.

**Sixth, the candidate pool and generator program co-evolved.** Harder families were introduced after developmental failures. This is preferable to hiding those failures, but it means the expert pool was not designed independently of the simulation program. The three composed post-freeze tasks and three input-shift tasks are useful stress checks, but they remain too small to establish broad compositional or shift robustness.

**Seventh, the full forced-expert matrix resolves one ambiguity but not external independence.** It shows that routing adds value beyond forcing any one of the twelve candidates on the primary frozen tasks, yet the twelve-candidate pool itself remains a product of the developmental program.

**Eighth, the \(10^{-3}\) release tolerance is an engineering operating point.** It was fixed before the primary frozen benchmark, but it is not a universally meaningful scientific constant. A future risk-coverage study should use a prespecified tolerance grid.

**Ninth, the gate rule is heuristic.** It uses a normal-approximation paired improvement criterion and a relative-gain floor. The separate gate sample reduces direct rank-set reuse, but the rule is not a theorem of post-selection validity.

**Tenth, six hard data partitions are statistically expensive.** This is feasible in synthetic simulation because fresh random observations are cheap. In scarce-data settings, cross-fitting, nested resampling, reusable holdouts, or formal post-selection methods may be more efficient.

**Eleventh, MX5 contains a small nonconvex latent-projection optimizer.** Although seeds are frozen, platform-level numerical variation is possible.

**Twelfth, runtime was not benchmarked on standardized hardware.** Kernel experts also scale poorly with sample count in the direct reference implementation because they solve dense kernel systems.

## 10. Reproducibility

The accompanying implementation contains:

- the frozen MX5 estimator;
- all random generator definitions;
- the final seed manifest;
- per-family result files;
- negative controls;
- post-freeze composed tests;
- distribution-shift tests;
- sample-efficiency tests;
- the evolutionary development log;
- source-lineage notes.

The principal software requirements are NumPy, SciPy, and PyTorch.

The packaged benchmark can be reproduced with:

```bash
pip install -r requirements.txt
python reproduce_mx5_final.py
```

A smaller fresh-random smoke test is available through:

```bash
python smoke_mx5.py
```

The final test split is not used by the MX5 fitting routine. Each benchmark task independently generates train, tune, rank, gate, release screening, and test samples from a frozen random transformation seed.

---


### 10.1 Reproducibility and Reporting Checklist

| Item | Status |
|---|---|
| Frozen implementation supplied | Yes |
| Random generator code supplied | Yes |
| Final seed manifest supplied | Yes |
| Six data roles explicitly separated | Yes |
| Release tolerance fixed in code | Yes, \(10^{-3}\) |
| Test labels excluded from fitting/routing/release screening | Yes |
| Negative controls supplied | Yes; original 4 plus 8 post-freeze family-wide controls |
| Secondary 24-task post-freeze cohort supplied | Yes |
| Full 24×12 forced-expert matrix supplied | Yes |
| Post-freeze challenge results supplied | Yes |
| Developmental rejected branches documented | Yes |
| Hardware standardized for runtime claims | No |
| Real-world measured dataset | No, by study design |
| Formal conformal/e-value release guarantee | No; explicitly out of current MX5 claim |
| External prospective preregistration | No |
| Independently authored external generator suite | No |

This checklist is included to make the evidentiary boundary auditable rather than implicit.

### 10.2 Data and Code Availability

The research artifact contains the frozen estimator, benchmark generators, final seeds, control experiments, result JSON files, and reproduction scripts. This revision additionally reports a machine-readable 24×12 forced-expert matrix, a 24-task secondary validation table, and eight new family-wide negative-control records. Because the paper uses synthetic random data, the dataset is generated from code rather than distributed as a fixed corpus. Reproducing the final benchmark therefore requires preserving both the generator implementation and the frozen seed manifest.

## 11. Conclusion

This paper presented STABLE-Wave MX5 as a framework for **static complex-valued nonlinear operator identification under structural uncertainty**. Rather than assuming a single model family, MX5 fits heterogeneous structural hypotheses, nominates a candidate on one random dataset, independently tests that nomination against a simpler fallback on another, applies an empirical release screen on a third, and opens the final test set only after those decisions are fixed.

The primary 24-task frozen internal-validation benchmark released 22 tasks with 0 observed released-task threshold violations. A full forced-expert diagnostic then showed that the expert selected before test-label access matched the retrospective best of all twelve frozen candidates on 24/24 tasks. A second post-freeze 24-task cohort again released 22/24 with no released-task threshold violation, while also exposing one conservative false rejection near the threshold. Twelve independently permuted negative controls were rejected. These findings substantially strengthen the claim that the procedure is doing meaningful structural routing rather than merely benefiting from a large candidate pool or marginal output regularities.

The paper's conclusion remains intentionally bounded. MX5 is **not** a general dynamical-system identifier, not externally validated, and not a formally risk-controlled selective predictor. Its strongest supported statement is narrower:

> **On controlled randomized static complex-valued operator families, spending separate evidence on structural nomination, independent confirmation, empirical release screening, and untouched final evaluation can produce accurate task-level routing among genuinely different model classes.**

The next scientifically consequential steps are not additional tuning on the present benchmark. They are (1) an independently authored random benchmark suite, and (2) a prospectively defined MX6-style release rule with formal selective risk control. Both should be evaluated on new frozen data rather than retrofitted to the current test results.

---

## References

[1] L. Ljung. *System Identification: Theory for the User*, 2nd ed. Prentice Hall, 1999.

[2] F. Cacace, V. De Iuliis, A. Germani, and M. Merone. “Learning Nonlinear Systems via Volterra Series and Hilbert-Schmidt Operators.” *IEEE Transactions on Automatic Control*, 69(6):3881–3895, 2024. doi:10.1109/TAC.2023.3338462.

[3] M. I. Jordan and R. A. Jacobs. “Hierarchical Mixtures of Experts and the EM Algorithm.” *Neural Computation*, 6(2):181–214, 1994.

[4] A. Rajabi and I. Salehi. “A Context-aware Gated Convex Mixtures of LSTM Experts for Nonlinear System Identification.” arXiv:2608.08980, 2026.

[5] Y. Geifman and R. El-Yaniv. “Selective Classification for Deep Neural Networks.” *Advances in Neural Information Processing Systems 30*, 2017.

[6] Y. Geifman and R. El-Yaniv. “SelectiveNet: A Deep Neural Network with an Integrated Reject Option.” *Proceedings of the 36th International Conference on Machine Learning*, PMLR 97:2151–2159, 2019.

[7] Y. Xu, W. Guo, and Z. Wei. “Selective Conformal Risk Control.” arXiv:2512.12844, 2025.

[8] T. Bai and Y. Jin. “Conformal Selective Prediction with General Risk Control.” arXiv:2603.24704, 2026.

[9] I. F. Shihab, A. S.-A. M. M.-I. Al Ahsan, and M. N. Swaqeeb. “Opportunity Is Not Realizability: Selection-Valid Diagnostics for Multi-LLM Routing.” arXiv:2608.08265, 2026.

[10] D. Piga and M. Forgione. “ASIA: an Autonomous System Identification Agent.” arXiv:2605.10480, 2026.

[11] B. Efron. “Bootstrap Methods: Another Look at the Jackknife.” *The Annals of Statistics*, 7(1):1–26, 1979.

[12] F. Wilcoxon. “Individual Comparisons by Ranking Methods.” *Biometrics Bulletin*, 1(6):80–83, 1945.

[13] S. Holm. “A Simple Sequentially Rejective Multiple Test Procedure.” *Scandinavian Journal of Statistics*, 6(2):65–70, 1979.

[14] X. Yu and J. Liu. “A Joint Finite-Sample Certificate for Adaptive Selective Conformal Risk Control.” arXiv:2606.08517, 2026.
