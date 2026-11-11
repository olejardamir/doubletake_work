# ARADM-M v1.0 — Listing-Event Reality Formal Model

**Status:** Research specification plus limited historical replay; **not independently validated as a profitable predictor**.  
**Relationship:** Domain-specific realization of *Action–Reality Adaptive Decision Model (ARADM v3)*.  
**Corresponding executor:** [`ARADM_XM_listing_advantage_executor_v1.md`](ARADM_XM_listing_advantage_executor_v1.md).  
**Scope:** Publicly announced cryptocurrency exchange listings, initially Binance spot pairs. This model **observes and forecasts**; it does not submit orders.  
**Date of research:** November 10–11, 2026 (UTC).  
**Principle:** Markets are independent systems with liquidity, competing objectives, public information, discontinuous price reactions, and hidden state. A subsequent surge does not prove the listing caused it.

---

## 1. Purpose and falsifiable claims

Given an **information cut-off** \(t\) and only evidence actually available by \(t\), predict:

1. \(P(\text{surge of at least }q\text{ after }t\text{ during horizon }H)\);
2. \(P(\text{positive net continuation after a feasible entry})\);
3. the distribution of future returns and downside excursions;
4. the time to the first surge, time to peak, time above a defined threshold, and time to reversal;
5. whether early public signals improve prediction relative to a time-ordered baseline.

A price increase observed after an event is an **association**. A claim that the listing **caused** it requires a defensible counterfactual.

**Non-goals:** Guaranteeing profitable trades, finding insider information, assuming perfect first-print fills, or inferring that the market has a unified intention.

## 2. Event identity and four independent clocks

Each listing must have an immutable identifier `(asset, venue, market_type, quote_pair, initial_event_id)` and separate times:

- \(t_{mention}\): earliest verifiable prior public mention, with source and `first_seen_at`;
- \(t_{announce}\): official exchange announcement's **original** publication time;
- \(t_{revision,j}\): any postponement or material update, each version retained;
- \(t_{open}\): **actual** first trade on the particular exchange pair, not simply scheduled time.

An important fifth clock is \(t_{decision}\), the instant a prediction must have been formed. Information created or first discovered afterward is forbidden as a feature. If a publication time is date-only or a page has been silently edited, mark its intraday timing **unverified**.

Listings already circulating on other venues, pre-market or Binance Alpha are **not** equivalent to first-ever token launches. Stable/reference-value assets are a different product class. Missing or invalid symbols are **missing observations**, never zeros or unsuccessful launches.

## 3. General state-space model

For asset \(i\) at time \(t\), define:

\[
S_{i,t}=(P,V,L,Q,B,A,M,Z,C)_{i,t}
\]

where \(P\)=price; \(V\)=realized volatility; \(L\)=market depth/liquidity; \(Q\)=order-flow/imbalance; \(B\)=market/sector factors; \(A\)=timestamped announcements; \(M\)=public mentions and their credibility; \(Z\)=hidden regime; \(C\)=market eligibility, outages and other hard constraints.

Actions by market participants are included in the transition mechanism, but a *single* "Reality" decision-maker is not assumed:

\[
P_\theta(S_{t+\Delta},O_{t+\Delta}\mid S_t,A_t^{\rm participants},\mathcal H_t).
\]

An optional continuous-time interpretation uses a marked jump process:

\[
 d\log P_t=\mu_\theta(S_{t^-})dt+\sigma_\theta(S_{t^-})dW_t+
 \sum_{k\in\{\mathrm{mention,announce,revision,open}\}}J_{k,t}\,dN_{k,t}.
\]

This is a **candidate mathematical family**, not a claim that the sparse pilot identifies its parameters. Distinct latent regimes may include opening-price discovery, transient spike/reversal, sustained momentum, muted reaction, and illiquidity. Regime probabilities are updated as information arrives, rather than assigned retrospective labels at prediction time.

## 4. Observation and prediction modes

### Mode A — Before the announcement

Input: public cross-exchange prices, project activity, timestamped articles/posts, market regime, and a **complete monitored candidate universe** including coins that were *never* listed. Output: a calibrated listing-event hazard and possible conditional subsequent reaction. Without unlisted controls, this mode is not identified from a sample consisting only of announced listings.

### Mode B — Announcement to opening

Input: a verified official announcement, time to opening, subsequent revision records known so far, existing trading elsewhere, liquidity changes, broad market performance. Output: probability of opening delay, market-reaction distribution, and potential paths. Revisions published later cannot be inserted into earlier forecasts.

### Mode C — After the first complete trading hour

Observed feature set at \(t_{open}+60m\): initial return, five-minute volatility, initial turnover, observed high/low, order-book conditions if available, and previously confirmed public signals. The **pilot implementation** uses only first-hour log return because the other features are not yet assembled consistently across all cases.

Define \(p_{i,0}\) as first five-minute opening price and \(p_{i,60}\) as the completed first-hour closing price:

\[
x_i=\log\left(\frac{p_{i,60}}{p_{i,0}}\right).
\]

To model attainable continuation, define the *research execution proxy* \(p_{i,65}\) as the five-minute candle opening at minute 65, not the original listing open. For a cost assumption \(c\), set:

\[
Y_{i,24}=\frac{p_{i,24h}}{p_{i,65}}-1-c.
\]

This is a **paper replay proxy**. A real order might have a different fill, spread, slippage, size constraint, or no fill.

Additional **ex-post labels**, never features before their time:

\[
G_{i,q,H}=\mathbf1\!\left(\max_{u\in[65m,H]}P_{i,u}\ge(1+q)p_{i,65}\right)
\]

\[
D_{i,q,H}=5\,\sum_{b\in\mathcal B_{65m:H}}\mathbf1(C_b\ge(1+q)p_{i,65})\quad\mathrm{minutes}
\]

and \(D^{\rm longest}\) is the longest **consecutive** above-threshold run. Distinguish candle high crossing (possible but not necessarily fillable) from sustained five-minute closing prices. A duration still active at the end of observation is right-censored.

## 5. Estimation: hierarchical, robust, uncertainty-aware

Let \(\mathcal D_{<t}\) contain only prior events whose labels had matured before \(t\). A practical initial estimator is an **event-cluster-weighted kernel posterior**:

\[
 w_{ij}=\frac{\exp(-|x_i-x_j|/h)}{n_{\mathrm{cohort}(j)}}.
\]

Events published together share a cohort. Dividing weight by cohort size stops a single joint announcement from masquerading as several independent experiments.

For binary target \(Z_j\), a smoothed estimate is

\[
 \widehat P(Z_i=1\mid x_i)=\frac{\alpha+\sum_{j\in\mathcal D_{<t}}w_{ij} Z_j}{\alpha+\beta+\sum_jw_{ij}}.
\]

For returns, use an explicitly clipped/robust predictive center, retaining **uncapped original outcomes for evaluation**:

\[
 \widehat\mu_i=\frac{\sum_jw_{ij}\operatorname{clip}(Y_j,-b,b)}{\kappa+\sum_jw_{ij}}.
\]

Predictive uncertainty requires a calibrated distribution or intervals—not an unjustified precision claim. The current pilot uses \(h=0.8\), \(\alpha=\beta=1\), \(\kappa=2\), and \(b=0.30\) as **illustrative fixed settings**; these are not validated optimal hyperparameters. If information is sparse, return `UNCERTAIN`, not an invented edge.

Future extensions may use hierarchical Student-t mixtures for return tails, hidden Markov regimes, competing-risks survival models for decay, and dynamic regression on market/sector returns. Added complexity must beat simpler out-of-sample baselines.

## 6. Isolating a listing's causal contribution

To claim *listing caused price change*, define an event-level causal estimand with a comparable price source available **before and after** the Binance event:

\[
\tau_i(H)=E[R_{i,H}(L=1)-R_{i,H}(L=0)\mid X_i].
\]

Only listed-token Binance-only histories do **not** identify \(R(L=0)\). A stronger design needs matched tokens not listed then, pre-announcement cross-exchange prices, pre-trends, BTC/sector exposure, placebo timestamps, token-supply/unlock controls, and sensitivity tests for anticipation and confounding.

An exploratory **abnormal return**, \(AR_{i,t}=r_{i,t}-(\hat\beta_i r_{BTC,t}+\hat\gamma_i r_{sector,t})\), is descriptive unless a credible counterfactual design supports identification. Do not label correlation as causal impact.

## 7. Historical evidence and correction of the earlier pilot

Read-only Binance spot candles were retrieved on November 10–11, 2026. We examined **19 speculative listing observations** (six from 2025; thirteen from 2026), with complete 48-hour five-minute price windows for these pairs. Three earlier 2026 hourly records understated first-hour moves because of half-hour starts:

| Token | Correct actual start | True first-hour move (5m-based) | Why the earlier figure was misleading |
|---|---|---:|---|
| PUMP (2025) | 12:30 UTC | +20.79% | First partial hour was missing in hourly-only query |
| ROBO (2026) | 16:30 UTC | +27.70% | First partial hour was missing; originally appeared negative |
| CHIP (2026) | 13:30 UTC | +395.83% | The hourly-only study had reported approximately +0.95% |

**Post-entry results for thirteen 2026 listings** (signal after 60m, entry proxy at 65m, exit at 24h, 0.4% fee proxy):

| Metric | Result |
|---|---:|
| Positive net returns | **5 / 13** |
| Maximum high at least 5% above the delayed entry | **8 / 13** |
| At least 60 continuous minutes of five-minute closes 5% above entry | **5 / 13** |
| Buy-all mean net return | **+5.15%** |
| Buy-all median net return | **−4.97%** |
| Buy-all mean with single best event removed | **−1.38%** |
| Exploratory low-initial-momentum (<=30%) rule | **−6.20%** average across 5 trades |

The low-momentum rule's apparent earlier success disappeared after correcting CHIP. The 2026 buy-all mean is dominated by exceptional wins, not evidence of a robust mean advantage. The study is retrospectively assembled and **not an untouched prospective holdout**.

For a chronological replay beginning with 2025 history, the cohort-aware kernel predictor gave:

| Forecast target | ARADM-M Brier | Expanding cohort-frequency baseline Brier |
|---|---:|---:|
| Net positive return by 24h | **0.25264** | 0.26189 |
| Reach +5% peak after feasible entry | 0.27234 | **0.27215** |

This is mixed evidence: a tiny apparent improvement on one target and no improvement on the other. No statistically reliable predictive gain has been demonstrated.

A cohort bootstrap of the 13 events (12 announcement cohorts; 20,000 fixed-seed draws) gave an illustrative **95% interval of approximately −9.0% to +23.0%** for the buy-all *per-event* mean. It includes zero and does not correct sample-selection bias.

## 8. Standard output contract to executor

```json
{
  "model": "ARADM-M/1.0",
  "event_id": "exchange:spot:symbol:announcement-id",
  "asof_utc": "YYYY-MM-DDTHH:MM:SSZ",
  "decision_stage": "pre_announcement|announced|after_60m",
  "features_asof_verified": true,
  "information_sources": ["uri+published_at+first_seen_at+version"],
  "data_quality": "A|B|C|unavailable",
  "forecast": {
    "p_net_positive_24h": null,
    "p_surge_5pct_next_24h": null,
    "expected_return_gross": null,
    "return_distribution": null,
    "surge_duration_distribution": null,
    "uncertainty": "unvalidated"
  },
  "market_state": {"trading_status": "unknown", "eligible": "unknown"},
  "no_lookahead_verified": false
}
```

`null` means unavailable, **not** zero. A score alone is not an instruction to trade. Output carries enough provenance to reproduce exactly what was known when the forecast was formed.

## 9. Evaluation protocol that cannot retroactively award a win

1. Freeze source discovery criteria and the universe, including nonexistent/pending/failed listings.
2. Maintain immutable, versioned announcement and public-mention timelines.
3. Pre-register threshold \(q\), forecast horizons, labels, feature sets, hyperparameter search space, baselines, and rejection criteria.
4. Train and evaluate chronologically. Group simultaneous announcements; prevent leakage of late-arriving outcomes and web content.
5. Compare **Brier/log scores**, calibration plots, mean/median forecast error, survivor/time-to-decay predictions, and performance across regimes.
6. Use block/announcement-cluster uncertainty intervals, plus calendar-time and other-exchange tests.
7. Require incremental value over unconditional prevalence, momentum, BTC/sector-only and no-information baselines.
8. Keep an immutable negative register of model failures and unexpected outcomes. Any proposed fix after inspecting test outcomes needs a **new** evaluation period.

**Promotion gate:** The Reality Model is not `PREDICTIVELY_VALIDATED` until it improves appropriate baselines on independent future data, with reasonable confidence and calibration. It is currently `RESEARCH_ONLY`.

## 10. Future research-worker contract

A future read-only worker may:

- monitor official new spot-listing announcements and all revisions;
- capture public news and social mentions with published/first-seen timestamps, while including non-listed candidate tokens;
- collect Binance/other-venue 1m/5m OHLCV and, when possible, trade-level records, spreads, and depth snapshots;
- calculate *separate* announcement-to-open, opening-spike, post-entry continuation, time-to-surge and duration labels;
- produce an as-of forecast, later resolve it, and append an immutable scored outcome;
- pass a validated, timestamped forecast to ARADM-XM, never an unlabeled prediction or direct purchase instruction.

It must handle API symbol errors, missing historical bars, quote changes, token identity and contract ambiguity, regional product restrictions, and multiple tokens announced together. No worker was activated by this document.

## 11. Mapping to other domains

The abstract fields `(event timestamps, external system state, observable signals, hidden regime, outcome distribution, cost of observation, confounders)` can describe a retail launch, software deployment, job queue, or logistics disruption. Domain-specific market microstructure is a **plug-in**, not a general law of Reality.

## 12. Limitations and provenance

The 19-case convenience sample is too small, concentrated and selected retrospectively to establish an exploitable advantage. Extreme listing moves, incomplete cross-exchange controls, unverified intraday fills, fees, slippage, execution latency, trading eligibility, token supply changes and time-varying market behavior limit interpretation. Forecasts that are mathematically computable may still be wrong.

**Primary source and data definitions:** Binance Public Data project (`https://github.com/binance/binance-public-data`); Binance public market-data API (`https://github.com/binance/binance-spot-api-docs/blob/master/faqs/market_data_only.md`); official spot listing announcements per event. Ante (2019), *Market Reaction to Exchange Listings of Cryptocurrencies* (`https://www.blockchainresearchlab.org/de/portfolio/market-reaction-to-exchange-listings-of-cryptocurrencies-2/`) provides external event-study context, not validation of ARADM-M.

**Current verdict:** Mathematically specified and pilot-tested; **not a demonstrated reliable market predictor**.

---

## Appendix A. Reproducible aggregate snapshot (19 listings)

The following is an **aggregate transcription** of read-only Binance five-minute candle observations retrieved November 10–11, 2026. The full candle series, order book and actual fills are **not embedded**. It is sufficient to recalculate the delayed-entry 24h/48h proxy returns, first-hour momentum and whether a +5% post-entry high occurred. Percentages shown in other tables are calculated from unrounded price fields.

| Pair | First hour opening price | Hour-1 close | Minute-65 opening proxy | 24h close | 48h close | Post-entry peak (%) | Longest sustained +5% (min) |
|---|---:|---:|---:|---:|---:|---:|---:|
| ONDO/USDT | 0.7056 | 0.8798 | 0.89 | 0.9002 | 0.8709 | 4.35 | 0 |
| BIGTIME/USDT | 0.06362 | 0.07147 | 0.07216 | 0.07165 | 0.06676 | 7.8 | 120 |
| VIRTUAL/USDT | 0.4199 | 0.5307 | 0.5297 | 0.5636 | 0.5666 | 9.25 | 105 |
| WLFI/USDT | 0.2 | 0.2798 | 0.2818 | 0.2281 | 0.228 | 0.92 | 0 |
| PUMP/USDT | 0.004502 | 0.005438 | 0.005486 | 0.006112 | 0.006519 | 16.11 | 865 |
| AVNT/USDT | 0.81 | 1.3982 | 1.53 | 1.1158 | 0.9477 | 4.58 | 0 |
| ZAMA/USDT | 0.025 | 0.03198 | 0.03281 | 0.03131 | 0.0312 | 15.82 | 250 |
| ESP/USDT | 0.0278 | 0.07751 | 0.07948 | 0.05938 | 0.06107 | 11.8 | 40 |
| ROBO/USDT | 0.0348 | 0.04444 | 0.04348 | 0.04283 | 0.03871 | 6.55 | 20 |
| KAT/USDT | 0.005 | 0.01327 | 0.0136 | 0.01041 | 0.01099 | 3.53 | 0 |
| CHIP/USDT | 0.012 | 0.0595 | 0.05942 | 0.10922 | 0.10251 | 100.67 | 495 |
| MEGA/USDT | 0.053 | 0.17591 | 0.17826 | 0.15596 | 0.14923 | 4.06 | 0 |
| AIGENSYN/USDT | 0.02506 | 0.04549 | 0.04576 | 0.04087 | 0.0357 | 7.91 | 20 |
| GENIUS/USDT | 0.4329 | 0.5838 | 0.5694 | 0.6503 | 0.763 | 22.92 | 685 |
| OPG/USDT | 0.23 | 0.2588 | 0.2567 | 0.2103 | 0.2216 | 0.19 | 0 |
| RE/USDT | 0.05 | 0.5642 | 0.5801 | 0.7534 | 0.9533 | 51.4 | 195 |
| AERO/USDT | 0.4724 | 0.4888 | 0.4924 | 0.4516 | 0.4508 | 1.54 | 0 |
| MARSCOIN/USDT | 0.1095 | 0.1748 | 0.1709 | 0.2481 | 0.189 | 47.4 | 440 |
| HYPE/USDT | 92 | 91.02 | 90.9 | 94 | 92.07 | 4.38 | 0 |

The reference time is **actual scheduled/confirmed spot start**, not the first observed aligned hourly candle; PUMP, ROBO and CHIP were corrected from half-hour starts. The 2025 and 2026 histories were chosen during research rather than from a locked probability sample. Treat the table as a research snapshot, not evidence of trading eligibility or execution quality.

**Source-file checksum for the research snapshot CSV (SHA-256):** `5822a8bced5de51e36bd705f74e282e8412763ec33f81e54a5d4ac098f25f6d3`.