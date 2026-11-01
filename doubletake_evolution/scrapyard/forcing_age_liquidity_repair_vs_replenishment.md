# Forcing-age liquidity: distinguishing durable opposition from replenishment
Historical mathematical *hypothesis*, not a validated trading signal or DT/Borg capability. Original source blob `002bf99336db736891d86970acd6c2ce86fb41ab`; original full derivation recoverable in Git history. Origin: prior L1 order-book falsification, including a reported "12:41" contradiction whose underlying market observations are **not attached/independently verified**. Previous spectrum/open-interest branches were rejected in the original analysis.

## Definitions and mechanism
Let aggressive direction be `s ∈ {-1,+1}`; cumulative same-direction executed volume after `t0` defines the forcing clock:
`A_s(t) = ∫[t0,t] 1_{trade direction=s} dV`.
A resting opposing-liquidity cohort `j`, posted at forcing clock `A_j`, has age `a_j=A-A_j` (volume exposure, **not** wall-clock time), surviving size `x_j(A)`. Age measure `μ_A(da)=Σ_j x_j(A) δ_{A-A_j}(da)`; visible opposing depth `Q(A)=∫ μ_A(da)`; first moment/endurance mass `M(A)=∫ a μ_A(da)`. Equal displayed depth does not imply equal cohort survival.

With replenishment rate `b(A)` injected at age 0 and cancellation/execution hazard `h(A,a)`, the idealized age equation is `∂_A μ + ∂_a μ = -h μ` (with boundary injection); hence `dQ/dA=b-∫h μ` and `dM/dA=Q-∫a h μ`. Newly posted depth contributes no *instantaneous* age mass. For a finite window with `∫[A1,A2] Q dA > 0`, define `R=(M(A2)-M(A1))/∫[A1,A2]Q dA`. Hypothesized interpretations: `R≈1` persistent opposing book, `R≈0` rapid replacement, `R<0` loss of older cohorts. These are idealized regimes, **not calibrated decision thresholds**.

## Non-identifiability construction
Both models can have constant displayed depth `Q0`: (i) durable book `b=h=0`, `M(A)=M(0)+Q0 A`, `R=1`; (ii) turnover with constant hazard `h=λ>0`, replenishment `b=λ Q0`, stationary age mass `M≈Q0/λ`, `R≈0` over a settled window. Thus terminal `Q0` alone cannot identify cohort persistence. This proves only the *toy-model distinction*, not real-market predictive utility.

## Essential caveats / falsifiers
Tracking true order-level cohorts may be impossible with aggregated L2 depth; order ID reuse, hidden liquidity, spoof/cancel/repost, cross-venue events, timestamp/trade-sign errors, partial executions, mixed-sign flow, and observation latency can confound `μ` and `R`. No source dataset, code, broker feed, license, held-out sample, costs or transaction-level ground truth was provided. Freeze historical windows including the alleged 12:41 counterexample; test whether cohort survival is actually reconstructible and whether `R` predicts *future* impact repair beyond visible depth with ablations, regime changes, null shuffles and out-of-sample validation. If unavailable, NEEDS_EMPIRICAL_VERIFICATION. No promotion to DT's current Borg assimilation mission without a demonstrated transferable state-estimation gap and lawful data.
