# ARADM-XM v1.0 — Listing Advantage Executor Model

**Status:** Formal policy and limited **paper-only** pilot. No validated positive trading edge; no live trading capability.  
**Relationship:** Domain-specific extension of *ARADM-X v1.2*, compatible at the forecast/output boundary with *ARADM-M v1.0*.  
**Corresponding Reality Model:** [`ARADM_M_listing_reality_model_v1.md`](ARADM_M_listing_reality_model_v1.md).  
**Goal:** Convert a verified market-state forecast into the **best feasible intervention for the executor**, including observing, waiting or declining to trade. Maximize realized, *risk-adjusted* advantage—not an ex-post listing spike.  
**Date:** November 10–11, 2026 (UTC).

---

## 1. What it means to make the environment work in the executor's favor

The executor cannot instruct prices to rise or reorganize other participants' strategies. It **can** select venue, timing, information, order size/type, exits and abstention under real constraints. Its mathematical advantage is defined relative to a pre-registered baseline, not by an attractive anecdote.

Let \(\Pi_{\rm feasible}(h_t)\) be the set of policies legally and technically feasible at history \(h_t\), and let \(W_t\) denote simulated capital. Define the net value of policy \(\pi\):

\[
J(\pi\mid h_t)=E_\pi\!\left[\sum_{k=0}^{\infty}\gamma^k
 \Big(\log\frac{W_{t+k+1}}{W_{t+k}}-c^{\rm research}_{t+k}\Big)\right]
 -\lambda\,\mathrm{CVaR}_{\alpha}(\mathcal L^\pi)
 -\zeta\,P_\pi(\text{constraint breach}).
\]

\(\gamma\in(0,1)\) provides a mathematically well-defined **no-deadline** objective. For a finite holding opportunity, use a finite horizon or an absorbing exit instead. \(\mathcal L^\pi\) is a loss/drawdown variable; CVaR measures the loss in a specified worst-tail fraction. Hard legal/safety constraints **cannot** be overridden by a high predicted return or traded off with a finite penalty: violating actions are removed from \(\Pi_{\rm feasible}\).

\[
\boxed{\pi^*=\arg\max_{\pi\in\Pi_{\rm feasible}(h_t)}J(\pi\mid h_t)}
\]

If *no trade* has the highest credible value, the executor may choose it. It must also distinguish **useful research** from *endlessly waiting without collecting data*. An abstention is not evidence that the Reality Model predicted the market correctly.

## 2. Input contract: the corresponding Reality Model

The executor accepts a **versioned, as-of** ARADM-M forecast, not current/historical prices mixed together:

```text
ForecastPacket = {
  event_id, asof_utc, decision_stage,
  feature_timestamp_bounds, source_fingerprints,
  probabilities: {net_gain, surge, decay, liquidity_fail},
  distributions: {returns, max_adverse_move, surge_duration, delay},
  forecast_uncertainty, confidence/quality_flags,
  market_eligibility, quote_depth, spread, fees, minimum_order,
  policy_version, out_of_sample_validation_status
}
```

Unknowns are explicitly `null`. If a timestamp, listing identity, regional eligibility, executable price or permission cannot be verified, the executor may **research or skip**, not assume a favorable value.

## 3. Action space and its meaning

| Symbol | Executor action | Valid only when |
|---|---|---|
| `RESEARCH` | Capture missing public news, verified opening time, venue data, book depth | Costs/time are bounded and publicly accessible |
| `WATCH` | Observe the market without risk exposure | Forecast can still be evaluated prospectively |
| `WAIT(Δt)` | Defer a decision until a specified new observation | Information is expected to arrive and option remains feasible |
| `PAPER_BUY(q,type)` | Record hypothetical long position at a **conservatively modeled** fill | Data quality, legality and risk gates pass |
| `PAPER_EXIT(q,type)` | Model closing an existing paper position | Same fill and timing standards |
| `SKIP` | Decline the opportunity; preserve capital | Always permitted |

**Live orders are deliberately outside this version.** In particular, Binance's official announcements for many of the sampled pairs explicitly exclude Canadian residents. The research model must not turn a prohibited venue into a recommendation or suggest bypassing restrictions. A future execution-capable version would require verified access through a legally permitted venue and explicit authorization. Even then, testing must precede any orders.

## 4. Executable-price model; no first-print fantasy

At prediction time \(t_d=t_{open}+60m\), the first full trading hour is observed. The historical pilot uses \(t_e=t_{open}+65m\) as a **five-minute delayed entry proxy** and a 24h closing-price exit proxy. This is better aligned with executable chronology than purchasing at the first listed trade, but still **does not simulate real fills**.

For a market order of quantity \(q\), a future realistic model would require:

\[
P_{\rm buy}=P_{\rm executable\ ask}(t_e,q)\,(1+\epsilon_{latency}+\epsilon_{impact}),
\]

\[
P_{\rm sell}=P_{\rm executable\ bid}(t_x,q)\,(1-\epsilon_{latency}'-\epsilon_{impact}').
\]

Transaction costs must incorporate exchange fees, spread, slippage, impact, network/transfer costs if relevant, and failed/partial fills. Trade-level and contemporaneous order-book snapshots are required to validate these estimates. Five-minute OHLC bars can only provide **optimistic or sensitivity-tested bounds**, not exact fills.

Paper realized return for the pilot:

\[
R^{paper}_{i,24}=\frac{C_i(t_{open}+24h)}{O_i(t_{open}+65m)}-1-c_{roundtrip}.
\]

The initial source study used 0.4% round-trip assumed friction. Sensitivity was also evaluated at 1% and 2%, but these are **scenarios, not verified costs**. If a venue imposes minimum orders, circuit breaks, no liquidity, or account restrictions, set `unexecutable`.

## 5. Value of an action versus the value of information

Do not conflate a correct surge forecast with a profitable purchase. Distinguish:

\[
V_{enter}=E[U(R^{net})\mid h_t,\mathrm{enter}]-\lambda\mathrm{CVaR}(\mathcal L_{enter})
\]

\[
V_{wait}=E_{o_{t+\Delta}\mid h_t}\left[\max_{a\in A_f(h_t,o)}V(a\mid h_t,o)\right]-C_{wait}
\]

\[
V_{skip}=0\quad\text{(by convention for incremental trading P&L)}.
\]

A news search or liquidity check can have positive expected value only when its expected decision improvement exceeds its acquisition cost and arrives **before the decision becomes obsolete**. The more spectacular the early spike, the less safe it is to assume that waiting retains a tradable opportunity.

For a **no-deadline** task such as continuing research, the executor optimizes discounted expected information-adjusted progress; it does not create an artificial target date. For a time-limited listing reaction, urgency is **endogenous**: the opportunity may decay even if the executor has no personal deadline.

## 6. Robust decision selection and abstention

The executor must choose from forecasts that include model uncertainty. A basic screening rule is:

\[
B(a)=E[R^{net}_a\mid \mathcal H_t]-\lambda\sigma_a-\eta\,\mathrm{CVaR}_{\alpha}(L_a)-C_{info}(a).
\]

A trade is eligible for further evaluation only if:

1. venue, market, time and **regional trading permission** are positively verified;
2. the market quote/depth and order size are sufficient for conservative execution;
3. the forecast was produced without future information and the Reality Model's predictive score meets promotion criteria;
4. expected benefits remain positive under stated latency, fee and slippage stresses;
5. concentration, drawdown, worst-loss and available-capital constraints pass;
6. the action improves a pre-specified comparator beyond credible uncertainty.

When any critical gate fails, choose `WATCH`, `RESEARCH` or `SKIP`. **An expected return above zero is necessary but not sufficient**. No-trade should be interpreted as a valid defensive result, not a proof of profitable market prediction.

## 7. Learning without an exploration trap

The executor may learn in two different ways:

- **Free or low-cost observational exploration:** historical data, public announcements, read-only market feeds, and paper decisions; preferred when causal effects of trading are uncertain.
- **Risk-taking exploration:** would incur actual capital loss and market impact; **not authorized** in this version.

The allocation of observation time should maximize expected *reduction in future decision regret*, not merely maximize the volume of collected information. A conservative policy should not become permanently frozen: it can continue **paper-trading** and scoring signals without using real money. Conversely, forcing a real purchase just to generate a label is not permissible.

## 8. Replay protocol and what has actually been demonstrated

The ARADM-M study supplies a corrected 19-case sample. Six historical 2025 listings provide initial training; 13 2026 listings are replayed chronologically, excluding same-time sibling announcements from one another's training history. **This is an exploratory retrospective study, not a fresh untouched independent test**: earlier analysis had already inspected some 2026 outcomes.

Under the defined kernel posterior and conservative executor rule (minimum estimated positive-net probability 0.53, mean-net minus 0.15 standard deviations positive, model data-quality gate), the executor selected **no buys** in the 13 cases.

| Paper strategy | 2026 result after 65m entry proxy and 24h exit |
|---|---|
| `BUY_ALL` | +5.15% **mean per trade**; −4.97% **median**; only 5/13 wins |
| `BUY_ALL`, remove one highest winner | −1.38% mean |
| Exploratory rule: first-hour gain ≤30% | −6.20% mean across five trades |
| Conservative ARADM-XM kernel policy | Zero buys, **0% trading return** |
| `SKIP_ALL` | Zero buys, **0% trading return** |

The leading winner, CHIP, was previously misclassified by an hourly-only study as having a roughly flat first hour. Complete five-minute records show a **+395.83% first-hour increase**. Correcting it invalidated the purported low-momentum opportunity. The average return of a buy-all strategy does not prove an advantage because of concentration, extreme variability, unknown real fills and selection bias.

The corresponding Reality Model's 2026 Brier score for predicting a positive net return was **0.25264**, versus **0.26189** for an expanding historical-frequency benchmark. Its Brier score for a +5% post-entry surge was **0.27234**, slightly worse than the **0.27215** benchmark. This is **not strong predictive evidence**.

**Verdict:** The models are properly separated and their event chronology has been corrected. **No profitable, robust, executable policy has been established.** Selecting zero trades preserves modeled capital but does not outperform `SKIP_ALL`.

## 9. Failure-driven fixes required before claiming an advantage

| Failure found | Correction to this executor | Evidence still needed |
|---|---|---|
| Misleading listing-open return | Make entry timestamp a function of decision and execution latency | Trade-level fills and latency measurements |
| Partial first-hour candle | Align bars to **actual listing minute** | Exchange first-trade verification |
| A few huge winners dominate mean | Use medians, trimmed means, lower-tail losses, concentration and cluster bootstrap | Larger, independent sample |
| Overconservative model never trades | Continue **paper** exploration and market-state learning without forced positions | Future prospective events |
| False opportunities from bad data | Verify symbols, source freshness, regional permission, liquidity and minimum size first | Live read-only order-book history |
| News posted after event appears predictive | Enforce `published_at`, `first_seen_at`, version history and `asof` gating | Verifiable pre-event archives |
| New listing labeled as causal surge | Require external-market controls and causal sensitivity analysis | Untreated assets and pre-announcement prices |
| Parameter choices retrofitted to winners | Freeze thresholds; treat all revisions as new hypotheses requiring future tests | Locked prospective dataset |

## 10. Exact executor algorithm (reference pseudocode)

```text
function choose_action(forecast_packet, execution_state):
    assert forecast_packet.asof <= execution_state.now
    if missing_critical_provenance(forecast_packet):
        return RESEARCH_WITH_BOUNDED_BUDGET or SKIP
    if not verified_venue_access(execution_state):
        return RESEARCH_ONLY  # never route an order
    if not independently_validated(forecast_packet.model_version):
        return WATCH_WITH_PAPER_LOG

    actions = {SKIP, WATCH, WAIT_FOR_VERIFIED_SIGNAL}
    actions += paper_execution_options_with_confirmed_depth_and_costs()
    actions = filter_hard_constraints(actions, execution_state)
    for action in actions:
        dist = simulate_action_and_future_observations(
                   forecast_packet, action, execution_state)
        score[action] = risk_adjusted_expected_utility(dist)
        score[action] -= information_cost(action)

    winner = argmax(score)
    if score[winner] <= score[SKIP]:
        return SKIP  # or WATCH if expected information value is positive
    return winner

function audit(outcome):
    append_immutable_prediction_and_actual_fill_proxies()
    update_ARADM_M_only_after_outcome_is_observable()
    score_against_BUY_ALL, SKIP_ALL, prior_rule, and simple momentum
    record_misses_and_tail_losses_without_relabeling()
```

**Note:** In this version `paper_execution_options...` are not live orders. A model achieving high retrospective P&L under a fictional perfect fill is **not** authorized to trade.

## 11. Promotion standards: working versus merely plausible

Three claims require separate evidence:

- **Numerical correctness:** Tests pass for feasibility, duration accounting, no lookahead, fallback, 5m timestamps, and cost calculations.
- **Forecast advantage:** Out-of-time Reality Model calibration and predictive scores beat simple controls under a frozen protocol.
- **Execution advantage:** Paper returns after **realistic executable quote-based fills**, fees, missed trades and downside limits beat `SKIP_ALL`, `BUY_ALL` and cost/risk-matched alternatives across independent market regimes.

A successful paper result must not depend on one or two outliers, surprise ex-post thresholds, an omitted group of failed listings, a lookahead field, or unrealistically cheap fills. Confidence intervals and limits of generalizability must be reported. A new policy after seeing the test outcomes needs **new prospective tests** before promotion.

**Current status:** `RESEARCH_ONLY / NO_CONFIRMED_ALPHA`. The model can select a conservative research action but has **not** been demonstrated to make markets cooperate or to generate reliable profit.

## 12. Future worker interface and cross-domain portability

A future **read-only** worker can run the cycle:

1. Gather candidate listings and pre-announcement mentions, including controls.
2. Capture the exact **as-of** state and write an ARADM-M forecast.
3. Ask ARADM-XM for a risk/feasibility-gated *paper* action.
4. Log the decision immediately with its reasons and data version.
5. Resolve outcomes at declared horizons; measure missed fills and tail risk.
6. Update the Reality Model only after labels mature; produce a new immutable audit.

The same abstraction works outside cryptocurrency. Replace market price/depth with queue length, inventory, resource availability or physical state; replace `PAPER_BUY` with an authorized domain action. The mathematical relationship remains: **Reality Model estimates outcome distributions; Advantage Executor chooses feasible actions using those distributions.**

**No scheduled worker or automatic trading system was created by this specification.**

## 13. Evidence, assumptions and references

- Binance's public historical-data schema and archive: `https://github.com/binance/binance-public-data` (five-minute klines; spot data timestamps from 2025 use microseconds in downloadable archives; API responses have their own timestamp conventions).
- Binance public market-data API: `https://github.com/binance/binance-spot-api-docs/blob/master/faqs/market_data_only.md`.
- Official Binance listing notices, including regional restrictions and event revisions, must be preserved per event; current and previous versions of a notice can differ.
- Ante (2019), *Market Reaction to Exchange Listings of Cryptocurrencies*: `https://www.blockchainresearchlab.org/de/portfolio/market-reaction-to-exchange-listings-of-cryptocurrencies-2/` (background study, not proof of this executor's performance).
- Internal provenance: ARADM/ARADM-X reference models, cryptocurrency pilot v0.2, and the fresh 19-event five-minute replay with **21 passing local consistency/integration tests**. These tests check implementation invariants; they do not validate profitable trading.

**Bottom line:** The executor's job is **not to make every listing profitable**. It is to transform forecasts into better constrained decisions and reject false opportunities. Profitable advantage remains a hypothesis to be tested, not a result to manufacture.