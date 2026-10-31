# MISP v2.2 — April Tuning and May Holdout

## Purpose

This report answers one narrow question:

> Did the multi-vector / multi-channel construction recover the April winner that earlier MISP versions missed, and did that improvement survive the next month?

The answer is:

```text
April tuning case: YES
May holdout:       NO
```

Therefore v2.2 improves the retrospective fit but does **not yet demonstrate generalizable predictive power**.

---

# 1. Structural changes tested

The v2.2 pilot introduced:

```text
multi-vector project representations
source-chunk baseline correction
four-window semantic leadership memory
direct semantic propagation
emerging semantic propagation
balanced propagation
recombination novelty
```

Production v2.2 calls for a pinned pretrained dense embedding model over actual pre-cutoff documents.

For this mechanics pilot, a controlled concept-normalized multi-vector representation was used because a production dense embedding endpoint/model was not available in the execution environment.

This distinction is important.

---

# 2. Why SPK was previously missed

Earlier versions compressed a project too aggressively.

SPK spans several semantic components:

```text
stablecoin lending
savings / yield
liquidity routing
capital allocation
governance / staking
```

A single project centroid diluted the strong local match between SparkLend / Spark Liquidity Layer and previously rewarded lending/liquidity infrastructure.

v2.2 preserves those components separately.

---

# 3. March → April tuning result

The v2.2 blend was tuned retrospectively on the March→April 2026 case.

Frozen blend after tuning:

```yaml
direct_weight: 0.45
balanced_weight: 0.20
recombination_weight: 0.35
leadership_decay: 0.80
multi_vector_top_k: 2
```

With the richer construction, the retrospective April ranking moved SPK to:

```text
#1 SPK
```

April outcome:

```text
SPK +70.88%
```

This was the largest Binance-measurable April gain in the tested discovery universe.

So, for the specific failure we were trying to diagnose:

> **v2.2 recovered the missed April maximum.**

However, April is now training data and cannot be used as evidence that v2.2 predicts future months.

---

# 4. Immediate holdout test

After the April tuning pass, the v2.2 settings were frozen.

No May returns were used to change:

```text
semantic representation
history decay
multi-vector similarity
channel definitions
channel weights
candidate universe
ranking rule
```

The next test used:

```text
history:
Mar 1–15
Mar 16–31
Apr 1–15
Apr 16–30

forecast cutoff:
Apr 30

outcome:
May 2026
```

---

# 5. Frozen May ranking

Before May returns were inspected, the top five measurable candidates were:

```text
1. OP
2. ARB
3. ICP
4. SPK
5. SEI
```

---

# 6. May outcomes

Binance May open→close returns:

| Forecast rank | Project | May return |
|---:|---|---:|
| 1 | OP | -1.41% |
| 2 | ARB | -16.17% |
| 3 | ICP | +14.68% |
| 4 | SPK | -33.32% |
| 5 | SEI | +18.93% |

Top-5 equal-weight return:

\[
\boxed{-3.46\%}
\]

Across the 18 candidates with Binance-measurable May returns:

```text
discovery-pool average ≈ +0.12%
discovery-pool median  ≈ -6.89%
```

The May maximum was:

```text
INJ +91.20%
```

v2.2 ranked INJ approximately:

```text
#16
```

So it missed the May maximum badly.

---

# 7. Cross-sectional May check

For the 18 measurable discovery candidates:

```text
Spearman(v2.2 score, May return)
rho ≈ -0.055
p   ≈ 0.83
```

There was no meaningful monotonic predictive relationship.

---

# 8. What worked

The construction improvement did solve the narrow April representation problem:

```text
single-vector / one-target approach
    ↓
missed SPK

multi-vector + semantic memory + propagation channels
    ↓
SPK recovered as #1 in the tuning month
```

That supports the diagnosis that aggregation was throwing away useful semantic structure.

---

# 9. What did not work

The next untouched month did not validate the tuned construction.

This means at least one of the following is still true:

```text
semantic propagation is weak or unstable
the source universe is too small
the project documents do not contain enough causal information
price moves are dominated by non-semantic catalysts
the representation is still too crude
the tuning weights overfit April
the discovery universe is too small / selective
the relevant lag varies by theme and period
```

The May result prevents us from claiming that v2.2 has solved prediction.

---

# 10. Interpretation

There are two separate conclusions.

## Representation conclusion

**Positive.**

Multi-vector representation is a real improvement over collapsing every project into one centroid.

It can recover meaningful local relationships that were previously diluted.

## Predictive-power conclusion

**Not yet positive.**

Recovering SPK retrospectively did not generalize to the next month.

Therefore:

> better semantic representation is necessary, but it is not sufficient.

---

# 11. What should happen next

Do not keep retuning on each failed month.

The next engineering step should be larger and more disciplined:

```text
1. replace pilot concept/TF-IDF representations with a real pinned dense encoder;
2. ingest actual pre-cutoff official documents;
3. expand the source and discovery universes mechanically;
4. keep multi-vector chunk representations;
5. freeze v2.2-style channel definitions;
6. train/tune on a block of historical months;
7. reserve a completely untouched block of later months for validation.
```

A reasonable design is:

```text
training/tuning: 12–24 months
validation:       6–12 later months
```

Do not alter the model during the validation block.

---

# 12. Bottom line

```text
Did the construction change recover SPK in April?
YES.

SPK retrospective rank:
#1

SPK April return:
+70.88%

Was SPK the tested April maximum?
YES.

Did the same frozen v2.2 construction work in May?
NO.

May Top-5:
-3.46%

May pool average:
+0.12%

May maximum:
INJ +91.20%

INJ v2.2 rank:
~#16
```

So the honest verdict is:

> **v2.2 fixed the specific April miss, but it did not fix the general prediction problem.**
