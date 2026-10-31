# Forcing-Age Liquidity Mathematics (FALM) — v6 Final Theoretical Core

## Status

**Domain:** electronic limit-order markets, initially cryptocurrency spot and perpetual-futures markets.

**Purpose:** develop a standalone mathematical framework for representing how displayed liquidity survives, disappears, and replenishes under continuing same-direction aggressive order flow, and expose mathematically structured state variables to trading and machine-learning systems.

**Current claim level:** FALM is a coherent candidate mathematical framework whose current single-venue theoretical core is closed under the stated assumptions. Its global novelty and its real-market trading advantage remain empirical/literature claims that cannot be proved from definitions alone.

**Non-claim:** no mathematics can truthfully guarantee that one trading bot will beat every possible competing bot in every future regime. The relevant target is robust out-of-sample improvement over strong baselines after realistic costs.

This version supersedes v2 where the two conflict.

---

# 1. Foundational distinction

A terminal opposing order book can look identical in two states:

1. **durable repair:** opposing liquidity appears and survives substantial further same-sign aggression;
2. **replenishment treadmill:** opposing liquidity is repeatedly consumed or cancelled and rapidly replaced while the aggressive program remains active.

Conventional displayed depth can satisfy

\[
Q_{\mathrm{repair}}=Q_{\mathrm{treadmill}}
\]

while the two states have different resistance to continued forcing.

FALM therefore adds a coordinate that ordinary L2 discards:

\[
\boxed{\text{same-direction aggressive volume survived}}
\]

rather than merely elapsed wall-clock time.

---

# 2. Directional forcing measure and canonical clock

Let each aggressive trade event \(n\) have

- timestamp \(t_n\),
- aggressor sign \(\epsilon_n\in\{-1,+1\}\),
- executed quantity \(q_n>0\),
- price \(p_n>0\).

For a selected additive forcing weight \(w(p_n,q_n)>0\), define the directional forcing measure

\[
\Lambda_s((u,v])
=
\sum_{n:u<t_n\le v}
\mathbf 1_{\{\epsilon_n=s\}}w(p_n,q_n),
\qquad
s\in\{-1,+1\}.
\]

The directional forcing clock is

\[
\boxed{
A_s(t)=\Lambda_s((-\infty,t]).
}
\]

Canonical practical choices are

\[
w(p,q)=q
\]

for base-quantity forcing, or

\[
w(p,q)=pq
\]

for quote-notional forcing.

The mathematical theory requires additivity and non-negativity. Choice of forcing units is part of the model specification and must be frozen before evaluation.

---

# 3. Forcing age

If a unit of liquidity opposing direction \(s\) is born at time \(b\), define its forcing age at time \(t\ge b\) by

\[
\boxed{
a_s(t;b)=A_s(t)-A_s(b).
}
\]

This equals the cumulative same-direction aggressive forcing that occurred after the liquidity appeared.

It is not calendar age.

It does not advance when irrelevant opposite-direction aggressive flow occurs.

---

# 3A. Global program forcing versus local challenge forcing

The canonical forcing age in Section 3 uses all same-direction aggressive
flow after cohort birth.

That age means:

> the liquidity remained displayed while this much same-direction aggression
> occurred in the market.

It does **not** necessarily mean every unit of that aggression directly
reached or challenged the cohort.

This distinction matters for deeper book levels.

Let

\[
x_p(u)=s(p-P_u)\ge0
\]

be the distance of an opposing resting price \(p\) from the contemporaneous
execution front.

Choose a frozen exposure kernel

\[
\kappa:\mathbb R_+\to[0,1].
\]

Examples include

\[
\kappa(x)\equiv1
\]

for canonical global program forcing, and

\[
\kappa_{r_c}(x)
=
\mathbf 1_{\{x\le r_c\}}
\]

for a hard local challenge radius.

Define cohort-local challenge age

\[
\boxed{
a_s^\kappa(t;b,p)
=
\int_{(b,t]}
\mathbf 1_{\{\epsilon(u)=s\}}
\kappa(x_p(u^-))
\,dV(u).
}
\]

Thus FALM has a hierarchy:

\[
\boxed{
\text{global program age}
\quad\text{and}\quad
\text{local challenge age}.
}
\]

The global clock captures persistence of the aggressive program while the
cohort remains present.

The local clock measures aggression occurring while the cohort is in a
specified zone of potential near-term challenge.

The kernel must be fixed before evaluation; choosing it after observing
future returns is prohibited.

---

# 3B. Generalized challenge-age transport

Use global forcing amount \(A\) as the evolution variable, but let the
cohort challenge age \(a\) advance at rate

\[
\frac{da}{dA}
=
\kappa(x).
\]

Then the front-centered density satisfies

\[
\boxed{
\partial_A g
+
\partial_a(\kappa(x)g)
+
\partial_x(v_xg)
=
-hg.
}
\]

When \(\kappa\equiv1\), this reduces exactly to canonical FALM:

\[
\partial_Ag+\partial_ag+\partial_x(v_xg)=-hg.
\]

Therefore local challenge-age FALM is a strict generalization rather than a
separate theory.

---

# 4. Primary exact state

For a fixed aggressive direction \(s\), let \(p\) be absolute price.

The exact FALM state is a finite positive Borel measure

\[
\boxed{
\mu_A(dp,da)
}
\]

on

\[
\mathbb R\times\mathbb R_+.
\]

For measurable sets \(P\subseteq\mathbb R\) and \(B\subseteq\mathbb R_+\),

\[
\mu_A(P\times B)
\]

is the currently displayed opposing liquidity at prices in \(P\) whose forcing ages lie in \(B\).

The ordinary displayed L2 book is the age projection

\[
\boxed{
q_A(dp)
=
\mathcal P\mu_A(dp)
=
\int_0^\infty\mu_A(dp,da).
}
\]

Thus

\[
\boxed{
\mathcal P:\mu_A\mapsto q_A
}
\]

is the FALM-to-L2 observation projection.

---

# 5. Front-centered state

For direction \(s\), let \(P_A\) denote the opposing execution front.

Define distance from the front by

\[
\boxed{
x=s(p-P_A)\ge0.
}
\]

For buy aggression \(s=+1\), opposing asks have \(x=p-P_A\).

For sell aggression \(s=-1\), opposing bids have \(x=P_A-p\).

The front-centered state is the pushforward

\[
\boxed{
\nu_A
=
(\mathcal D_{s,P_A})_\#\mu_A.
}
\]

Absolute-price coordinates are the primary coordinates for hidden-cohort bookkeeping.

Front coordinates are derived coordinates for geometry, prediction, and trading.

---

# 6. Axioms

## Axiom 1 — additive directional forcing

For \(t_1\le t_2\le t_3\),

\[
A_s(t_3)-A_s(t_1)
=
[A_s(t_2)-A_s(t_1)]
+
[A_s(t_3)-A_s(t_2)].
\]

## Axiom 2 — zero-age birth

New opposing displayed liquidity enters at

\[
a=0.
\]

## Axiom 3 — unit aging in forcing time

If liquidity survives while the forcing clock advances by \(dA\),

\[
da=dA.
\]

## Axiom 4 — destruction does not create aged mass

Execution and cancellation remove existing mass. They cannot directly create mass at \(a>0\).

## Axiom 5 — L2 projection may be non-injective

Distinct forcing-age states may have the same ordinary displayed-depth projection.

## Axiom 6 — observation uncertainty is explicit

If public data do not reveal hidden cohort identities, the mathematical state is a feasible set of exact states rather than a silently guessed single state.

---

# 6A. Canonical discrete-event survivor semantics

The continuous transport equations are infinitesimal idealizations.

For event-level implementation, the word **survived** requires a precise
ordering convention.

For a fully resolved aggressive execution event with forcing increment
\(\Delta A>0\), use:

1. **remove liquidity executed by the event from the pre-event cohorts;**
2. **advance the forcing age of the remaining cohorts by \(\Delta A\)**
   (or by \(\kappa(x)\Delta A\) in challenge-age FALM);
3. **insert liquidity born after the event at forcing age zero.**

Symbolically, if

- \(\mathcal E_{\Delta A}\) is the execution/removal operator,
- \(\mathcal T_{\Delta A}^{\kappa}\) is survivor aging,
- \(B^+\) is post-event birth mass,

then

\[
\boxed{
\mu^+
=
\mathcal T_{\Delta A}^{\kappa}
\big(
\mathcal E_{\Delta A}\mu^-
\big)
+
B^+\otimes\delta_0.
}
\]

This convention guarantees that liquidity consumed by an aggressive event is
not credited as having survived that event.

For canonical global forcing,

\[
\kappa\equiv1.
\]

For an aggregate trade that combines multiple fills/taker events while book
updates can interleave, the internal order is not observable. In that case
the certified FALM transition must include every admissible internal
sequencing consistent with timestamps/update IDs and cannot apply the
single-event convention to the aggregate as if it were atomically resolved.

---

# 6B. Cancellation/birth ordering uncertainty

Cancellation and replenishment messages can occur before or after an
aggressive event inside a coarse observation interval.

If their cross-stream ordering is not known, then each admissible ordering
defines a candidate cohort transition.

The exact hidden-state filter therefore expands over sequencing branches and
then contracts through the next observation constraint.

This is another reason the public-data state is naturally

\[
\boxed{
\mathfrak F_k
}
\]

rather than one guessed cohort book.

---

# 7. Deterministic density dynamics in absolute-price coordinates

Suppose \(\mu_A\) admits density \(f(A,p,a)\).

Let

- \(b(A,p)\ge0\) be boundary birth intensity;
- \(h(A,p,a)\ge0\) be destruction hazard per unit forcing age.

For \(a>0\),

\[
\boxed{
\partial_A f
+
\partial_a f
=
-hf.
}
\]

Boundary inflow is

\[
\boxed{
f(A,p,0)=b(A,p)
}
\]

because forcing-age velocity is one.

This is the basic age-transport equation.

---

# 8. Corrected moving-front equation

Version 2 omitted the transport generated by movement of the front.

Let

\[
g(A,x,a)=f(A,P_A+s x,a).
\]

When \(P_A\) is differentiable, a resting absolute price has front-coordinate velocity

\[
v_x(A)=-s\dot P_A.
\]

Therefore the correct front-centered transport law is

\[
\boxed{
\partial_A g
+
\partial_a g
+
\partial_x(v_x g)
=
-hg.
}
\]

When \(v_x\) is independent of \(x\),

\[
\partial_A g+\partial_a g-s\dot P_A\partial_xg=-hg.
\]

At discontinuous price-front jumps, the rigorous operation is a pushforward/translation of surviving mass plus explicit removal of crossed liquidity.

This correction is required whenever local near-touch windows are used.

---

# 9. Measure-valued event formulation

The density PDE is not the most general FALM object.

For a smooth compactly supported test function \(\phi(p,a)\),

\[
\langle\phi,\mu_A\rangle
=
\int\phi(p,a)\mu_A(dp,da).
\]

An event-level FALM process satisfies schematically

\[
d\langle\phi,\mu_A\rangle
=
\langle\partial_a\phi,\mu_A\rangle\,dA
+
\int\phi(p,0)\,B(dA,dp)
-
\int\phi(p,a)\,D(dA,dp,da),
\]

where

- \(B\) is the random birth measure;
- \(D\) is the execution/cancellation destruction measure.

If \(B\) and \(D\) have compensators \(b\,dA\,dp\) and \(h\mu_A\,dA\), then the drift recovers the deterministic transport equation and the residual is a martingale term.

Thus the natural stochastic FALM state is a measure-valued piecewise-deterministic/random-measure process.

---

# 9A. Cause-specific destruction: execution versus cancellation

The total destruction measure can be decomposed as

\[
\boxed{
D
=
D^{E}
+
D^{C},
}
\]

where

- \(D^{E}\) is destruction by execution against aggressive flow;
- \(D^{C}\) is cancellation/withdrawal of displayed opposing liquidity.

In a density model, write

\[
\boxed{
h
=
h_E+h_C,
}
\]

with

\[
h_E,h_C\ge0.
\]

The transport law becomes

\[
\partial_A f+\partial_af
=
-(h_E+h_C)f.
\]

This is a competing-risks decomposition in forcing time.

Execution and cancellation have the same effect on visible cohort survival
but different market interpretations:

\[
\boxed{
\text{execution}
=
\text{aggressor consumes resistance},
}
\]

\[
\boxed{
\text{cancellation}
=
\text{resistance retreats before consumption}.
}
\]

FALM must preserve this distinction whenever the feed can identify it.

In an exact event-level order book, execution destruction is often singular
in price/time (for example, a sweep removes mass at specific levels) rather
than a smooth interior hazard.

Therefore

\[
h_E
\]

is a density idealization only when the execution destruction measure is
absolutely continuous with respect to the chosen forcing-state measure.

The rigorous object is the cause-specific destruction measure

\[
D^E,
\qquad
D^C.
\]

Finite-window cause-specific hazard summaries can be defined from those
measures even when no pointwise \(h_E\) exists.

---

# 9B. Public-L2 identification of destruction causes

Aggressive trade prints identify at least part of \(D^E\).

Aggregate L2 reductions not explained by observed executions can contain

- cancellations;
- event-ordering ambiguity;
- hidden within-bucket cancellation/rebirth;
- feed-resolution effects.

Therefore exact \(D^C\) is generally only partially identified from public
aggregate L2.

The feasible-state relation \(\mathfrak F_k\) must include admissible
cause-specific decompositions rather than assigning every unexplained
reduction to cancellation without qualification.

---

# 10. Forcing-survival surface

For front distance \(r\ge0\) and forcing threshold \(v\ge0\), define

\[
\boxed{
S_A(r,v)
=
\nu_A([0,r]\times[v,\infty)).
}
\]

Interpretation:

\[
S_A(r,v)
=
\text{displayed opposing depth within }r
\text{ that has survived at least }v
\text{ units of same-sign forcing}.
\]

At \(v=0\),

\[
\boxed{
S_A(r,0)=D_A(r),
}
\]

the conventional cumulative depth within radius \(r\).

Hence ordinary depth is the zero-age boundary of the FALM survival surface.

---

# 11. Normalized survival surface

For \(S_A(r,0)>0\),

\[
\boxed{
\widehat S_A(r,v)
=
\frac{S_A(r,v)}{S_A(r,0)}.
}
\]

For fixed \(r\),

\[
v_2\ge v_1
\implies
\widehat S_A(r,v_2)
\le
\widehat S_A(r,v_1).
\]

For fixed \(v\),

\[
r_2\ge r_1
\implies
S_A(r_2,v)
\ge
S_A(r_1,v).
\]

These monotonicities are structural constraints that an ML representation need not relearn.

---

# 12. Endurance moments

For \(k>0\),

\[
\boxed{
M_k(A,r)
=
\int_{[0,r]\times\mathbb R_+}
a^k\,\nu_A(dx,da).
}
\]

The first moment is

\[
M_1(A,r)=\int a\,d\nu_A.
\]

The tail identity gives

\[
\boxed{
M_1(A,r)
=
\int_0^\infty S_A(r,v)\,dv.
}
\]

Thus endurance mass is the area under the forcing-survival curve, not the primitive state.

---

# 13. Theorem 1 — terminal-depth non-identifiability

There exist

\[
\mu\ne\eta
\]

such that

\[
\mathcal P\mu=\mathcal P\eta.
\]

### Proof

At one price level let \(Q>0\) and \(L>0\).

Set

\[
\mu=Q\delta_L,
\qquad
\eta=Q\delta_0.
\]

Both have displayed depth \(Q\).

For \(0<v\le L\),

\[
S_\mu(v)=Q,
\qquad
S_\eta(v)=0.
\]

Therefore terminal displayed depth does not determine forcing durability.

\[
\boxed{\square}
\]

---

# 14. Theorem 2 — one-radius tail completeness

For fixed \(A,r\), the tail function

\[
v\mapsto S_A(r,v)
\]

uniquely determines the finite forcing-age measure aggregated within \([0,r]\).

This follows because half-lines \([v,\infty)\) form a measure-determining class on \(\mathbb R_+\).

\[
\boxed{\square}
\]

---

# 15. Theorem 3 — joint survival-surface completeness

Let \(\mu,\eta\) be finite Borel measures on

\[
\mathbb R_+^2
\]

in front-distance/forcing-age coordinates.

If

\[
S_\mu(r,v)=S_\eta(r,v)
\]

for every \(r,v\ge0\), then

\[
\boxed{
\mu=\eta.
}
\]

### Proof

Differences of tail rectangles recover finite rectangles:

\[
\mu([0,r]\times[v_1,v_2))
=
S_\mu(r,v_1)-S_\mu(r,v_2).
\]

The collection of such rectangles generates the Borel sigma-algebra of \(\mathbb R_+^2\).

Equality on this generating class implies equality of the finite measures.

\[
\boxed{\square}
\]

### Consequence

The complete FALM survival surface is an injective representation of the exact front-centered FALM measure.

---

# 16. Mild solution and well-posedness

Set initial forcing time \(A=0\).

Assume

\[
f_0\in L^1_+,
\qquad
b\in L^1_{\mathrm{loc}}(\mathbb R_+;L^1_+),
\qquad
h\in L^\infty_{\mathrm{loc}},\ h\ge0.
\]

The characteristic formula is

\[
f(A,p,a)
=
\begin{cases}
f_0(p,a-A)
\exp\left(
-\displaystyle\int_0^A
h(u,p,a-A+u)\,du
\right),
&
a>A,
\\[12pt]
b(A-a,p)
\exp\left(
-\displaystyle\int_0^a
h(A-a+u,p,u)\,du
\right),
&
0\le a\le A.
\end{cases}
\]

---

# 17. Theorem 4 — existence and uniqueness of the basic FALM transport

Under the assumptions above, the characteristic formula defines the unique nonnegative mild \(L^1\) solution of

\[
\partial_A f+\partial_af=-hf
\]

with initial density \(f_0\) and boundary birth \(b\).

Moreover,

\[
\boxed{
\|f(A)\|_1
\le
\|f_0\|_1
+
\int_0^A\|b(u)\|_1\,du.
}
\]

### Proof sketch

Characteristics in \((A,a)\) are straight lines \(a-A=\text{constant}\).

Each characteristic either originates from the initial condition or from the boundary \(a=0\).

The exponential factor is the unique survival solution along the characteristic.

Non-negativity follows from non-negative data.

Because \(h\ge0\), survival multipliers are at most one, giving the mass bound.

Any mild solution must agree on almost every characteristic, proving uniqueness.

\[
\boxed{\square}
\]

---

# 18. Theorem 5 — stability under initial/birth perturbations

Let \(f,g\) solve the same transport equation with the same destruction hazard \(h\), but initial data \(f_0,g_0\) and birth processes \(b,c\).

Then

\[
\boxed{
\|f(A)-g(A)\|_1
\le
\|f_0-g_0\|_1
+
\int_0^A\|b(u)-c(u)\|_1\,du.
}
\]

Thus the basic FALM transport is non-expansive with respect to initial/boundary mass perturbations.

For different hazards, a Duhamel bound adds a term controlled by

\[
\int_0^A
\|h(u)-\tilde h(u)\|_\infty
\,M(u)\,du
\]

for a suitable total-mass bound \(M(u)\).

---

# 19. Global endurance identity

For the whole opposing side define

\[
Q(A)=\int f(A,p,a)\,dp\,da
\]

and

\[
M(A)=\int a f(A,p,a)\,dp\,da.
\]

Then

\[
\boxed{
\frac{dM}{dA}
=
Q(A)-D_1(A),
}
\]

where

\[
\boxed{
D_1(A)
=
\int a\,h(A,p,a)f(A,p,a)\,dp\,da
\ge0.
}
\]

Birth at age zero contributes no direct first-age moment.

---

# 20. Corrected repair coefficient

On a whole-side or fixed absolute-price domain define

\[
\boxed{
\mathcal R(A_1,A_2)
=
\frac{
M(A_2)-M(A_1)
}{
\displaystyle\int_{A_1}^{A_2}Q(A)\,dA
}
}
\]

when the denominator is positive.

Using the endurance identity,

\[
\boxed{
\mathcal R
=
1
-
\frac{
\displaystyle\int_{A_1}^{A_2}D_1(A)\,dA
}{
\displaystyle\int_{A_1}^{A_2}Q(A)\,dA
}.
}
\]

Therefore

\[
\boxed{
\mathcal R\le1.
}
\]

Equality means no positive-age destruction contributes over the window.

---

# 21. Moving-window endurance-flux correction

For a moving front-centered window \(0\le x\le r\), define

\[
M_r(A)=\int_0^r\int_0^\infty a g(A,x,a)\,da\,dx.
\]

The correct balance has an additional spatial endurance flux:

\[
\boxed{
\frac{dM_r}{dA}
=
Q_r(A)
-
D_{1,r}(A)
+
\Phi_0(A)-\Phi_r(A),
}
\]

where

\[
\Phi_x(A)
=
\int_0^\infty a\,v_x(A)g(A,x,a)\,da.
\]

Thus the locally corrected repair coefficient is

\[
\boxed{
\mathcal R_r^{\mathrm{corr}}
=
\frac{
\Delta M_r
-
\displaystyle\int_{A_1}^{A_2}
[\Phi_0(A)-\Phi_r(A)]\,dA
}{
\displaystyle\int_{A_1}^{A_2}Q_r(A)\,dA
}.
}
\]

Then

\[
\boxed{
\mathcal R_r^{\mathrm{corr}}\le1
}
\]

under the same regularity assumptions.

This repairs the v2 error in which ordinary front translation could be mistaken for durability change.

---

# 22. Forcing-survival partial order

For normalized states define

\[
\boxed{
\mu\succeq_F\eta
}
\]

when

\[
\widehat S_\mu(r,v)
\ge
\widehat S_\eta(r,v)
\]

for every relevant \(r,v\).

The order is generally partial rather than total.

It permits states to be incomparable when one has greater durability near the touch but less durability deeper in the book.

---

# 23. Exact topology from survival tails

Choose an enumeration

\[
\{(r_n,v_n)\}_{n\ge1}
\]

of the non-negative rational grid.

Define

\[
\boxed{
d_{\mathrm{tail}}(\mu,\eta)
=
\sum_{n=1}^{\infty}
2^{-n}
\frac{
|S_\mu(r_n,v_n)-S_\eta(r_n,v_n)|
}{
1+|S_\mu(r_n,v_n)-S_\eta(r_n,v_n)|
}.
}
\]

By joint survival-surface completeness and density/right-continuity of cumulative measures,

\[
d_{\mathrm{tail}}(\mu,\eta)=0
\iff
\mu=\eta.
\]

Symmetry and the triangle inequality follow termwise.

Therefore \(d_{\mathrm{tail}}\) is a metric on finite FALM measures.

---

# 24. Practical FALM transport geometry

For finite positive states with total depth \(Q_\mu,Q_\eta>0\), normalize

\[
\bar\mu=\frac{\mu}{Q_\mu},
\qquad
\bar\eta=\frac{\eta}{Q_\eta}.
\]

Using cost

\[
c((x,a),(x',a'))
=
w_x|x-x'|+w_a|a-a'|,
\]

define

\[
\boxed{
d_W(\mu,\eta)
=
\lambda_Q
\left|
\log\frac{Q_\mu}{Q_\eta}
\right|
+
W_1^c(\bar\mu,\bar\eta).
}
\]

This gives a practical geometry for clustering, nearest-neighbour state retrieval, manifold construction, and unsupervised learning.

It is not claimed as a new form of optimal transport; its FALM role is to compare states in the new price/forcing-age state space.

---

# 25. Aggregate L2 identity problem

At one absolute price level, let displayed quantity change from

\[
q_k
\]

to

\[
q_{k+1}.
\]

If individual resting-order identities are unavailable, the update does not reveal which forcing-age cohorts disappeared.

Therefore aggregate L2 generally produces a **set-valued FALM state**.

---

# 26. Trade-informed mass balance

Let

\[
E_k(p)\ge0
\]

be known aggressive execution volume against price \(p\) during the observation interval.

Let

- \(B_k(p)\) = newly displayed birth mass;
- \(C_k(p)\) = cancelled/otherwise withdrawn mass.

Then

\[
\boxed{
q_{k+1}(p)
=
q_k(p)+B_k(p)-C_k(p)-E_k(p).
}
\]

Define

\[
d_k(p)
=
q_{k+1}(p)-q_k(p)+E_k(p).
\]

Then

\[
B_k-C_k=d_k.
\]

Every nonnegative solution has representation

\[
\boxed{
B_k=[d_k]_+ + c_k,
\qquad
C_k=[-d_k]_+ + c_k,
}
\]

for some hidden matched churn

\[
c_k(p)\ge0.
\]

Thus observed trades sharpen the birth/cancel decomposition, while \(c_k\) isolates the remaining unobserved churn.

---

# 27. Theorem 6 — coarse-snapshot impossibility

Suppose displayed quantity is \(Q>0\) at two observation times separated by positive forcing increment \(\Delta A>0\).

If hidden matched churn is unconstrained, then the terminal forcing-age survival curve is non-identifiable.

### Proof

History 1: no destruction/rebirth occurs. Existing mass survives and ages by \(\Delta A\).

History 2: all mass is cancelled immediately before the second observation and \(Q\) new mass is inserted at age zero.

Both produce the same terminal displayed quantity \(Q\).

For any \(0<v\le\Delta A\), the terminal survival mass can therefore range from

\[
0
\]

to

\[
Q.
\]

\[
\boxed{\square}
\]

### Consequence

No method can reconstruct nontrivial FALM age information from sufficiently coarse snapshots without additional event information or explicit churn assumptions.

This is an information limit, not a machine-learning failure.

---

# 28. Feasible hidden-state set

Let

\[
\boxed{
\mathfrak F_k
}
\]

be the set of all exact forcing-age measures consistent with

- the reconstructed L2 book through observation \(k\);
- observed aggressive trades;
- forcing-clock increments;
- admissible event orderings;
- churn constraints;
- any stated exchange-feed assumptions.

Define a transition relation

\[
\mathcal T_k(\mu,\mu')
\]

that means \(\mu'\) can be obtained from \(\mu\) by

1. forcing-age transport;
2. admissible execution/cancellation removal;
3. zero-age birth;
4. observation projection matching;
5. all frozen churn/timestamp/order constraints.

Then

\[
\boxed{
\mathfrak F_{k+1}
=
\{
\mu':
\exists \mu\in\mathfrak F_k
\text{ such that }
\mathcal T_k(\mu,\mu')
\}.
}
\]

---

# 29. Theorem 7 — robust-filter containment

If the true initial hidden state satisfies

\[
\mu_0^{\mathrm{true}}\in\mathfrak F_0
\]

and every true transition is included in the admissible transition relation \(\mathcal T_k\), then for all \(k\),

\[
\boxed{
\mu_k^{\mathrm{true}}\in\mathfrak F_k.
}
\]

### Proof

Induction on \(k\).

The initial claim is assumed.

If \(\mu_k^{\mathrm{true}}\in\mathfrak F_k\) and the true transition is admissible, its successor is included by the definition of \(\mathfrak F_{k+1}\).

\[
\boxed{\square}
\]

---

# 30. Robust survival envelopes

Define

\[
\boxed{
S_k^-(r,v)
=
\inf_{\mu\in\mathfrak F_k}S_\mu(r,v)
}
\]

and

\[
\boxed{
S_k^+(r,v)
=
\sup_{\mu\in\mathfrak F_k}S_\mu(r,v).
}
\]

Then

\[
\boxed{
S_k^-(r,v)
\le
S_k^{\mathrm{true}}(r,v)
\le
S_k^+(r,v).
}
\]

Identification width is

\[
\boxed{
\Omega_k(r,v)
=
S_k^+(r,v)-S_k^-(r,v).
}
\]

Important correction to v2:

the pointwise lower envelope \(S^-\) and upper envelope \(S^+\) need not each correspond to one single physical hidden state simultaneously.

They are robust functional bounds over the feasible set.

---

# 31. Extremal cohort removal at one level

Let \(\lambda(da)\) be an age distribution and suppose exactly \(r\) mass must be removed.

Removing oldest mass first minimizes all increasing age functionals.

Removing youngest mass first maximizes them.

For any feasible remaining measure \(\rho\) and any increasing measurable \(\phi\),

\[
\boxed{
\int\phi\,d(\mathcal R_r^-\lambda)
\le
\int\phi\,d\rho
\le
\int\phi\,d(\mathcal R_r^+\lambda).
}
\]

This remains a useful local extremal theorem, but global observation uncertainty is represented by \(\mathfrak F_k\), not by assuming one global FIFO/LIFO book.

---

# 32. Discrete FALM polytope

Discretize price and forcing age into cells.

Let

\[
m_{kij}\ge0
\]

be hidden mass at time/update \(k\), price cell \(i\), forcing-age bin \(j\).

Introduce nonnegative variables for

- births \(b_{kij}\), restricted to zero-age bins;
- executions/removals \(e_{kij}\);
- cancellations \(c_{kij}\);
- optional hidden churn.

The constraints

- non-negativity;
- age-bin transport;
- mass conservation;
- observed price-level totals;
- observed aggressive executions;
- churn upper bounds;
- admissible sequencing constraints

are linear.

Therefore the discretized feasible hidden-state set is a convex polyhedron/polytope.

If a forcing increment \(\Delta A_k\) is not an integer multiple of the
forcing-age bin width, use a **frozen linear conservative transport
operator**

\[
\boxed{
m_{k+1}^{\mathrm{aged}}
=
T(\Delta A_k)m_k
}
\]

whose nonnegative columns preserve mass and interpolate only between the
adjacent age bins implied by the chosen grid. Once the grid and transport
rule are frozen, all reconstruction constraints remain linear.

A nonlinear, adaptively retuned interpolation rule is not part of the
certified LP layer.

---

# 33. Theorem 8 — certified FALM envelopes are linear programs

On a fixed discrete age/price grid with linear observation/churn constraints, any linear FALM functional

\[
L(m)=\sum_{ij}\alpha_{ij}m_{ij}
\]

has exact lower and upper certified values given by

\[
\boxed{
L^-=\min_{m\in\mathfrak F_k}L(m),
\qquad
L^+=\max_{m\in\mathfrak F_k}L(m),
}
\]

which are linear programs.

The survival surface is linear:

\[
S(r,v)
=
\sum_{i:x_i\le r}
\sum_{j:a_j\ge v}
m_{ij}.
\]

Therefore

\[
S^-(r,v),\quad S^+(r,v)
\]

can be computed without guessing hidden cohort identity.

\[
\boxed{\square}
\]

---

# 34. FALM certification logic

For a durability requirement \(\kappa\),

### Certified durable

\[
S^-(r,v)\ge\kappa.
\]

Every admissible hidden history contains at least \(\kappa\) surviving depth.

### Certified fragile

\[
S^+(r,v)<\kappa.
\]

No admissible hidden history contains \(\kappa\) surviving depth.

### Unresolved

\[
S^-(r,v)<\kappa\le S^+(r,v).
\]

The public data and assumptions do not identify the conclusion.

This three-way logic prevents uncertainty from being silently converted into a directional signal.

---

# 35. Forcing-hazard surface

## Canonical global-age case

For canonical FALM with \(\kappa\equiv1\), define the moving-window spatial
tail flux

\[
J_x(A,r,v)
=
\int_v^\infty
v_xg(A,r,a)\,da
-
\int_v^\infty
v_xg(A,0,a)\,da.
\]

Then

\[
(\partial_A+\partial_v)S
=
-J_x
-
\int_0^r\int_v^\infty hg\,da\,dx.
\]

Hence

\[
\boxed{
H_F^{\mathrm{corr}}
=
-
\frac{
(\partial_A+\partial_v)S+J_x
}{
S
}
=
\frac{
\int_0^r\int_v^\infty hg\,da\,dx
}{
S
}.
}
\]

## General challenge-age case

For

\[
\partial_A g
+
\partial_a(\kappa g)
+
\partial_x(v_xg)
=
-hg,
\]

define the challenge-age boundary flux

\[
\boxed{
J_a^\kappa(A,r,v)
=
\int_0^r
\kappa(x)g(A,x,v)\,dx.
}
\]

Then

\[
\boxed{
\partial_A S
=
J_a^\kappa
-
J_x
-
\int_0^r\int_v^\infty hg\,da\,dx.
}
\]

Therefore the generalized corrected forcing hazard is

\[
\boxed{
H_F^\kappa(A,r,v)
=
\frac{
J_a^\kappa-J_x-\partial_A S
}{
S
}
=
\frac{
\int_0^r\int_v^\infty hg\,da\,dx
}{
S
}.
}
\]

This formulation remains valid when local forcing age advances more slowly
than the global program clock.

---

# 35A. Cause-specific forcing hazards

With

\[
h=h_E+h_C,
\]

define

\[
\boxed{
H_E
=
\frac{
\int\!\!\int h_Eg
}{
S
},
\qquad
H_C
=
\frac{
\int\!\!\int h_Cg
}{
S
}.
}
\]

Then

\[
\boxed{
H_F=H_E+H_C.
}
\]

Whenever \(H_F>0\), define the dimensionless execution share of destruction

\[
\boxed{
\psi_E
=
\frac{H_E}{H_F},
\qquad
\psi_C
=
1-\psi_E.
}
\]

Interpretation:

- high \(\psi_E\): aged visible resistance is disappearing mainly through
  aggressive consumption;
- high \(\psi_C\): aged visible resistance is disappearing mainly through
  withdrawal/cancellation.

Under partial public-L2 identification, use certified intervals

\[
[\psi_E^-,\psi_E^+]
\]

rather than an invented exact value.

---

# 35B. Finite-window cause-specific destruction rates

When execution/cancellation destruction is event-like rather than smooth,
define for a region \(\mathcal R\) and forcing interval
\([A_1,A_2]\) the exposure mass

\[
\mathcal X(\mathcal R)
=
\int_{A_1}^{A_2}
S_A(\mathcal R)\,dA.
\]

Let

\[
D^E(\mathcal R;[A_1,A_2]),
\qquad
D^C(\mathcal R;[A_1,A_2])
\]

be cause-specific destroyed mass (or an age-weighted analogue if required).

Whenever \(\mathcal X>0\), define

\[
\boxed{
\overline H_E
=
\frac{D^E}{\mathcal X},
\qquad
\overline H_C
=
\frac{D^C}{\mathcal X}.
}
\]

These finite-window quantities remain meaningful for atomic event measures
and converge to smooth hazard quantities under suitable refinement.

---

# 36. Hardening field


Define

\[
\boxed{
K_F(A,r,v)
=
-\partial_v H_F(A,r,v).
}
\]

Interpretation:

- \(K_F>0\): the **tail-average** destruction hazard decreases as the minimum
  forcing age threshold rises;
- \(K_F=0\): no threshold dependence of the tail-average hazard in the local benchmark;
- \(K_F<0\): the tail-average hazard rises with the forcing-age threshold.

This is deliberately weaker than claiming that every individual old order is
intrinsically harder to remove. \(K_F\) is a population/tail-selection object.

---

# 37. Dimensionless hardening curvature

For \(H_F>0\), define

\[
\boxed{
\chi_F
=
\frac{K_F}{H_F^2}.
}
\]

Under multiplicative forcing-unit changes, \(H_F\) and \(K_F\) rescale, but

\[
\boxed{
\chi_F
\text{ is invariant}.
}
\]

This makes \(\chi_F\) useful for cross-symbol and cross-unit comparisons.

---

# 38. Mean residual forcing age

Define

\[
\boxed{
E_F(A,r,v)
=
\frac{
\int_v^\infty S_A(r,u)\,du
}{
S_A(r,v)
}.
}
\]

The product

\[
\boxed{
\rho_F=H_FE_F
}
\]

is another dimensionless maturity/resistance statistic.

It should be treated as a derived summary, not as a primitive.

---

# 39. Affine forcing-clock covariance

Suppose forcing units change by

\[
\widetilde A=cA+d,
\qquad c>0.
\]

Then forcing ages scale as

\[
\widetilde a=ca.
\]

The survival surface transforms as

\[
\boxed{
\widetilde S(r,\widetilde v)
=
S\left(r,\frac{\widetilde v}{c}\right).
}
\]

Hazard transforms as

\[
\boxed{
\widetilde H_F
=
\frac{1}{c}H_F.
}
\]

Hardening transforms as

\[
\boxed{
\widetilde K_F
=
\frac{1}{c^2}K_F.
}
\]

A collapse forcing threshold scales as

\[
\boxed{
\widetilde\tau_\theta=c\tau_\theta.
}
\]

Therefore

\[
\chi_F=\frac{K_F}{H_F^2}
\]

is invariant.

This establishes unit covariance of the theory.

---

# 40. Analytic benchmark I — exponential replenishment treadmill

Suppose forcing-stationary birth is \(b>0\) and destruction hazard is constant

\[
h(a)=\lambda>0.
\]

The stationary forcing-age density is

\[
\boxed{
f_*(a)=b e^{-\lambda a}.
}
\]

Total displayed depth is

\[
\boxed{
Q_*=\frac{b}{\lambda}.
}
\]

The current-age survival curve is

\[
\boxed{
S_*(v)=Q_*e^{-\lambda v}.
}
\]

Therefore

\[
H_F(v)=\lambda,
\qquad
K_F(v)=0,
\qquad
\chi_F(v)=0.
\]

This is the canonical memoryless replenishment treadmill.

---

# 41. Analytic benchmark II — hardening power-law state

Let destruction hazard decrease with forcing age:

\[
\boxed{
h(a)
=
\frac{\lambda}{1+\gamma a},
\qquad
\lambda>\gamma>0.
}
\]

The individual survival law is

\[
\exp\left(
-\int_0^a h(u)\,du
\right)
=
(1+\gamma a)^{-\lambda/\gamma}.
\]

Under stationary birth \(b\),

\[
f_*(a)
=
b(1+\gamma a)^{-\lambda/\gamma}.
\]

The current-age survival tail is

\[
\boxed{
S_*(v)
=
\frac{b}{\lambda-\gamma}
(1+\gamma v)^{1-\lambda/\gamma}.
}
\]

The FALM tail hazard is

\[
\boxed{
H_F(v)
=
\frac{\lambda-\gamma}{1+\gamma v}.
}
\]

Thus

\[
\boxed{
K_F(v)
=
\frac{\gamma(\lambda-\gamma)}
{(1+\gamma v)^2}
>0.
}
\]

And the dimensionless hardening curvature is constant:

\[
\boxed{
\chi_F
=
\frac{\gamma}{\lambda-\gamma}.
}
\]

This supplies an analytic hardening benchmark distinct from the exponential treadmill.

---

# 41A. Competing-risk treadmill benchmark

Let execution and cancellation hazards be constant:

\[
h_E=\lambda_E,
\qquad
h_C=\lambda_C.
\]

Then total hazard is

\[
\lambda=\lambda_E+\lambda_C.
\]

The stationary age tail is

\[
S(v)=Qe^{-\lambda v}.
\]

Cause-specific FALM hazards are

\[
\boxed{
H_E=\lambda_E,
\qquad
H_C=\lambda_C,
}
\]

and the destruction composition is

\[
\boxed{
\psi_E
=
\frac{\lambda_E}
{\lambda_E+\lambda_C}.
}
\]

This benchmark separates a book that disappears mainly by being consumed
from one that disappears mainly because makers withdraw, even when their
total forcing-age survival curves are identical.

---

# 42. General stationary solution

With forcing-stationary birth \(b(p)\) and age-dependent destruction hazard \(h(p,a)\), define cumulative hazard

\[
H(p,a)
=
\int_0^a h(p,u)\,du.
\]

If

\[
\int_0^\infty e^{-H(p,a)}\,da<\infty,
\]

then the stationary density is

\[
\boxed{
f_*(p,a)
=
b(p)e^{-H(p,a)}.
}
\]

Total depth at price \(p\) is

\[
\boxed{
Q_*(p)
=
b(p)
\int_0^\infty e^{-H(p,a)}\,da.
}
\]

This is a forcing-time birth-survival balance.

---

# 43. Counterfactual survival of present liquidity

Given a destruction hazard model, define for currently present mass at \((x,a)\)

\[
\boxed{
\Pi_A(x,a;z)
=
\exp\left(
-\int_0^z
h_{A+u}(x,a+u)\,du
\right).
}
\]

Expected surviving pre-existing depth after another forcing amount \(z\) is

\[
\boxed{
C_A(r,z)
=
\int_{[0,r]\times\mathbb R_+}
\Pi_A(x,a;z)\,\nu_A(dx,da).
}
\]

This asks how much of the **present** resistance is expected to remain if aggression continues.

It deliberately excludes future births unless a replenishment model is added.

---

# 44. Resistance-collapse forcing

For \(0<\theta<1\),

\[
\boxed{
\tau_\theta(A,r)
=
\inf
\{
z\ge0:
C_A(r,z)
\le
\theta C_A(r,0)
\}.
}
\]

Small \(\tau_\theta\) means fragile present resistance.

Large \(\tau_\theta\) means the current displayed resistance is expected to survive more same-direction forcing.

---

# 44A. Total future resistance: inheritance plus replenishment

The counterfactual curve \(C_A(r,z)\) in Section 43 deliberately measures
only survival of liquidity already present at forcing time \(A\).

The original repair-versus-treadmill problem also requires a second channel:
liquidity that is born **after** the present time while aggression continues.

On a fixed absolute-price domain, or under a specified spatial propagator,
define the expected resistance contributed by present liquidity:

\[
\boxed{
C_A^{\mathrm{pre}}(r,z)
=
\int
\Pi_A(x,a;z)\,\nu_A(dx,da).
}
\]

Let \(b_{A+u}(dx)\) denote the expected birth measure of new opposing
displayed liquidity after an additional forcing amount \(u\).

A cohort born at future forcing time \(A+u\) has zero forcing age at birth.
Its expected survival until \(A+z\) is

\[
\Pi_{A+u}(x,0;z-u).
\]

Define future-born resistance

\[
\boxed{
C_A^{\mathrm{new}}(r,z)
=
\int_0^z
\int_{[0,r]}
\Pi_{A+u}(x,0;z-u)
\,b_{A+u}(dx)\,du.
}
\]

The expected total opposing resistance at forcing horizon \(z\) is

\[
\boxed{
R_A(r,z)
=
C_A^{\mathrm{pre}}(r,z)
+
C_A^{\mathrm{new}}(r,z).
}
\]

This is the FALM renewal/Duhamel decomposition.

It separates two mechanisms that ordinary terminal depth merges:

\[
\boxed{
\text{survival of inherited liquidity}
}
\]

and

\[
\boxed{
\text{replacement by future liquidity}.
}
\]

---

# 44A.1 Exact ancestry tagging under state-dependent hazards

The inheritance/replenishment split does not require the destruction hazard
to be exogenous.

At a reference forcing time \(A_0\), label all currently displayed mass
**inherited** and all later births **new**.

Write

\[
f=f^{I}+f^{N}.
\]

Allow the common hazard and birth law to depend on the total state \(f\).

The tagged system is

\[
\boxed{
\partial_A f^{I}
+
\partial_a f^{I}
=
-h[f]f^{I},
\qquad
f^{I}(A,0)=0,
}
\]

with initial condition

\[
f^{I}(A_0)=f(A_0),
\]

and

\[
\boxed{
\partial_A f^{N}
+
\partial_a f^{N}
=
-h[f]f^{N},
\qquad
f^{N}(A,0)=b[f](A),
}
\]

with

\[
f^{N}(A_0)=0.
\]

Adding the equations gives the total FALM dynamics.

Therefore the ancestry split remains exact even when makers react to the
current total book, provided destruction acts multiplicatively on tagged
mass and the same state-dependent hazard applies to both ancestry labels.

The same construction extends to front transport and challenge-age
transport by adding the corresponding spatial/age flux operators to both
tagged equations.

---

# 44A.2 Theorem — ancestry decomposition by uniqueness

Suppose the total tagged FALM evolution is well posed and unique.

Then

\[
\boxed{
f=f^{I}+f^{N}
}
\]

is the unique total solution generated by inherited initial mass and
post-reference births.

Consequently every linear future-resistance functional \(L\) decomposes as

\[
\boxed{
L(f)
=
L(f^{I})
+
L(f^{N}).
}
\]

Thus resistance ancestry is not merely a heuristic label. It is an exact
mass decomposition under the stated evolution rules.

\[
\boxed{\square}
\]

---

# 44B. Resistance ancestry and replacement dependence

Whenever \(R_A(r,z)>0\), define the **resistance ancestry fraction**

\[
\boxed{
\alpha_A(r,z)
=
\frac{
C_A^{\mathrm{pre}}(r,z)
}{
R_A(r,z)
}.
}
\]

Define the complementary **replacement dependence**

\[
\boxed{
\eta_A(r,z)
=
1-\alpha_A(r,z)
=
\frac{
C_A^{\mathrm{new}}(r,z)
}{
R_A(r,z)
}.
}
\]

Then

\[
0\le\alpha_A,\eta_A\le1,
\qquad
\alpha_A+\eta_A=1.
\]

Interpretation:

- large \(\alpha_A\): future resistance is mainly inherited from liquidity
  already present now;
- large \(\eta_A\): future resistance depends mainly on replenishment arriving
  after the present state.

This is closer to the original 12:41 distinction than terminal book
alignment: a book can remain visually deep while its resistance ancestry
collapses.

---

# 44B.1 Positive-propagator form

For a linear conditional evolution, let

\[
U(A_2,A_1)
\]

be the positive sub-Markov propagator that transports existing liquidity
from forcing time \(A_1\) to \(A_2\), including

- forcing-age advancement;
- front-coordinate transport;
- destruction.

Then the exact variation-of-constants formula is

\[
\boxed{
\mu_{A+z}
=
U(A+z,A)\mu_A
+
\int_A^{A+z}
U(A+z,u)B_u\,du.
}
\]

The first term is inherited resistance.

The second is future-born replenishment resistance.

This operator form is the coordinate-free version of the Duhamel
decomposition and remains valid for any frozen linear transport geometry.

---

# 44C. Theorem 9 — exact treadmill ancestry law

Consider the stationary memoryless replenishment treadmill

\[
h(a)=\lambda>0,
\qquad
b=\lambda Q,
\]

so total expected displayed depth is the constant \(Q\).

Then for any additional forcing amount \(z\ge0\),

\[
\boxed{
C^{\mathrm{pre}}(z)
=
Qe^{-\lambda z},
}
\]

\[
\boxed{
C^{\mathrm{new}}(z)
=
Q(1-e^{-\lambda z}),
}
\]

and hence

\[
\boxed{
R(z)=Q.
}
\]

Nevertheless,

\[
\boxed{
\alpha(z)=e^{-\lambda z},
\qquad
\eta(z)=1-e^{-\lambda z}.
}
\]

### Proof

Each present unit survives an additional forcing amount \(z\) with
probability \(e^{-\lambda z}\), giving \(C^{\mathrm{pre}}\).

Future births occur at rate \(b=\lambda Q\). Integrating survival of a cohort
born at \(u\) gives

\[
C^{\mathrm{new}}(z)
=
\int_0^z
\lambda Q e^{-\lambda(z-u)}\,du
=
Q(1-e^{-\lambda z}).
\]

The remaining identities follow directly.

\[
\boxed{\square}
\]

### Consequence

A treadmill can satisfy

\[
\boxed{
R(z)=Q\quad\text{for every }z
}
\]

while the fraction of future resistance inherited from the current book
decays exponentially to zero.

This gives an exact mathematical realization of

\[
\boxed{
\text{stable visible depth}
\not\Rightarrow
\text{durable inherited resistance}.
}
\]

---

# 44D. Replacement half-forcing

Define

\[
\boxed{
\zeta_{1/2}(A,r)
=
\inf\{
z\ge0:
\alpha_A(r,z)\le1/2
\}.
}
\]

For the exponential treadmill,

\[
\boxed{
\zeta_{1/2}
=
\frac{\log 2}{\lambda}.
}
\]

Small \(\zeta_{1/2}\) means that even if displayed resistance remains high,
its composition becomes replacement-dominated after little additional
aggression.

Large \(\zeta_{1/2}\) means the present book retains ancestry under continued
forcing.

---

# 45. Theorem 10 — forcing-survival dominance implies resistance dominance under hardening


Consider two equal-depth age distributions \(\mu,\eta\) within a fixed price region.

Suppose

\[
\mu\succeq_F\eta
\]

in age, and suppose for every \(z\ge0\) the future survival kernel

\[
a\mapsto\Pi(a;z)
\]

is nondecreasing.

This condition holds, for example, when destruction hazard is nonincreasing with forcing age.

Then

\[
\boxed{
C_\mu(z)\ge C_\eta(z)
\quad
\text{for all }z\ge0.
}
\]

Consequently,

\[
\boxed{
\tau_\theta(\mu)\ge\tau_\theta(\eta).
}
\]

### Proof

First-order stochastic dominance implies larger expectation for every bounded increasing function.

For fixed \(z\), \(\Pi(a;z)\) is increasing in \(a\).

Therefore

\[
\int\Pi(a;z)\,d\mu
\ge
\int\Pi(a;z)\,d\eta.
\]

Equal total depth converts this into the counterfactual-resistance inequality.

The collapse-threshold inequality follows from pointwise dominance.

\[
\boxed{\square}
\]

### Importance

Under explicit hardening assumptions, the FALM partial order has a direct counterfactual-resistance interpretation rather than being merely descriptive.

---

# 46. Latent aggressor competition

Let

\[
Z_A
\]

be the random remaining same-sign aggressive forcing of the latent aggressive program.

FALM does not claim \(Z_A\) is directly observed.

It must be estimated by a separate order-flow continuation model or represented by a robust distribution set.

Define

\[
\boxed{
P_{\mathrm{penetrate}}(\theta,r)
=
\Pr[
Z_A>\tau_\theta(A,r)
\mid\mathcal F_A
].
}
\]

This compares estimated remaining aggression with estimated resistance durability.

---

# 47. Robust penetration interval

If observation uncertainty implies

\[
\tau_\theta^-\le\tau_\theta^{\mathrm{true}}\le\tau_\theta^+
\]

and the distribution of \(Z_A\) is fixed, then

\[
\boxed{
\Pr(Z_A>\tau_\theta^+)
\le
P_{\mathrm{penetrate}}^{\mathrm{true}}
\le
\Pr(Z_A>\tau_\theta^-).
}
\]

Thus FALM observation uncertainty can propagate into a certified penetration-probability interval.

---

# 47A. Robust ancestry interval

When current hidden cohorts, future birth intensity, or hazards are only
partially identified, ancestry must also remain set-valued.

Let \(\mathcal M_A\) be the admissible model/state set for the counterfactual.

Define

\[
\boxed{
\alpha_A^-(r,z)
=
\inf_{M\in\mathcal M_A}
\alpha_A^{M}(r,z),
\qquad
\alpha_A^+(r,z)
=
\sup_{M\in\mathcal M_A}
\alpha_A^{M}(r,z).
}
\]

Then the true ancestry fraction is certified only as

\[
\boxed{
\alpha_A^{\mathrm{true}}(r,z)
\in
[\alpha_A^-(r,z),\alpha_A^+(r,z)]
}
\]

provided the true data-generating mechanism lies in \(\mathcal M_A\).

A trading system must not replace this interval by a point value unless it
explicitly adopts an estimated probabilistic model.

---

# 47B. Certified FALM versus estimated FALM

FALM has two distinct inference modes.

## Certified mode

Uses only admissibility constraints and returns

\[
\mathfrak F_k,
\quad
S^\pm,
\quad
\Omega,
\quad
\alpha^\pm,
\]

or other guaranteed ranges.

No prior distribution over hidden cohorts is required.

## Estimated mode

Introduces a statistical model or prior over hidden event histories and
returns posterior/point estimates such as

\[
\mathbb E[\mu_k\mid\text{observations}].
\]

Estimated FALM can be sharper but is model-dependent.

The two modes must never be conflated in evaluation or reporting.

---

# 48. Bilateral FALM

At wall-clock time \(t\), maintain two directional clocks

\[
A_+(t),\qquad A_-(t).
\]

Define

\[
\mu_t^{(+)}
\]

for ask liquidity exposed to buy aggression and

\[
\mu_t^{(-)}
\]

for bid liquidity exposed to sell aggression.

The bilateral state is

\[
\boxed{
\mathbf X_t^{F}
=
(
\mu_t^{(+)},
\mu_t^{(-)}
).
}
\]

Each side ages only under the aggressive flow capable of consuming that side.

This preserves directional symmetry.

---

# 49. Directional reflection symmetry

Under reversal of price orientation and buy/sell labels,

\[
s\mapsto-s,
\]

the mathematical form of the FALM equations is unchanged.

A trading implementation should therefore use side-reflected features unless there is measured evidence of market-side asymmetry.

This is an ML inductive bias and a falsification check.

---

# 50. Multi-venue extension

For \(m\) venues define directional forcing vector

\[
\mathbf A_s(t)
=
(A_{s,1}(t),\dots,A_{s,m}(t)).
\]

A liquidity cohort may be assigned vector forcing age

\[
\boxed{
\mathbf a_s(t;b)
=
\mathbf A_s(t)-\mathbf A_s(b).
}
\]

The multi-venue exact state becomes a measure on

\[
\text{price distance}
\times
\mathbb R_+^m.
\]

A venue-specific effective forcing age can be defined by a frozen nonnegative exposure vector \(w_j\):

\[
a^{\mathrm{eff}}_{j,s}
=
w_j^\top\mathbf a_s.
\]

This extension is appropriate when cross-venue aggressive flow affects local liquidity provision.

It is not required for the single-venue FALM core.

---

# 51. Information refinement theorem

Let

\[
X=\text{exact FALM state},
\qquad
Q=\mathcal P(X)=\text{current L2 projection}.
\]

Let \(Y\) be any decision target and \(\ell(a,Y)\) any loss for which conditional Bayes risks exist.

Define optimal risks

\[
R_X^*
=
\inf_{\delta(X)}
\mathbb E[\ell(\delta(X),Y)]
\]

and

\[
R_Q^*
=
\inf_{\gamma(Q)}
\mathbb E[\ell(\gamma(Q),Y)].
\]

Because \(Q\) is a deterministic function of \(X\), every \(Q\)-based decision is also an \(X\)-measurable decision.

Therefore

\[
\boxed{
R_X^*\le R_Q^*.
}
\]

Strict inequality is possible when the Bayes-optimal action differs among FALM states inside the same L2 projection fiber.

\[
\boxed{\square}
\]

This proves that exact FALM has at least as much ideal decision capacity as the terminal L2 projection.

---

# 52. Important converse — FALM does not create information from full raw history

Let \(H_t\) denote the complete observed event history available to the algorithm.

If a computed FALM representation is a deterministic function

\[
X_t^F=\Phi(H_t),
\]

then

\[
\sigma(X_t^F)\subseteq\sigma(H_t).
\]

Hence an ideal unconstrained decision-maker with the full raw history cannot have higher Bayes risk than one restricted to FALM:

\[
\boxed{
R_{H_t}^*\le R_{X_t^F}^*.
}
\]

Therefore FALM's expected practical advantage over a sufficiently powerful raw-history model must come from one or more of

- useful inductive bias;
- lower-dimensional sufficient structure;
- improved sample efficiency;
- invariance/equivariance;
- explicit uncertainty handling;
- robustness;
- easier cross-asset transfer;
- better optimization.

It must not be falsely described as creating information that was not present in the raw feed.

---

# 53. Conditional sufficiency criterion

FALM is sufficient for target \(Y\) relative to observed history \(H_t\) if

\[
\boxed{
Y\perp H_t
\mid
X_t^F.
}
\]

Under this condition,

\[
R_{X_t^F}^*=R_{H_t}^*
\]

for all appropriate decision losses.

This conditional independence is an empirical/modeling hypothesis, not an axiom.

Testing how close FALM comes to such sufficiency is a central ML experiment.

---

# 53A. Theorem 11 — OHLCV non-recoverability

Let

\[
\mathcal A
\]

map the complete event-level market history over a bar to OHLCV statistics.

Then FALM state is not, in general, recoverable from OHLCV.

### Proof by construction

Fix any sequence of executed trade prices and quantities. This fixes the
OHLCV values.

Construct two different displayed-book histories around the same executions:

1. an opposing book whose displayed liquidity survives the executions;
2. an opposing book in which displayed liquidity is repeatedly cancelled and
   replaced between the same executions.

The executed trades, and hence OHLCV, are identical.

The forcing-age cohort measures are different.

Therefore there exist histories \(H_1,H_2\) such that

\[
\mathcal A(H_1)=\mathcal A(H_2)
\]

but

\[
\mu^F(H_1)\ne\mu^F(H_2).
\]

Hence no deterministic OHLCV-only reconstruction can recover exact FALM
state in general.

\[
\boxed{\square}
\]

### Consequence

OHLCV trading algorithms may consume separately computed FALM signals, but
historical candles alone cannot be retroactively treated as if they contain
the missing cohort-survival information.

---

# 53B. Observation hierarchy

FALM identifiability depends on market-data resolution.

### Level 3 / order-identity feed

If resting order identities, additions, reductions, executions, and
timestamps are visible, visible-cohort forcing ages can be tracked nearly
exactly subject to hidden/iceberg liquidity limitations.

### Event-level aggregate L2 + trades

Price-level updates and aggressive trades are visible but individual
resting-order identity is not.

Use the feasible-state/set-valued FALM layer.

### Coarse depth snapshots

Hidden churn inside observation intervals can dominate.

Certified survival intervals can become wide or vacuous unless additional
turnover bounds are justified.

### OHLCV only

Exact FALM reconstruction is impossible in general by Theorem 11.

---

# 53B.1 Visible-liquidity scope and hidden reserve

The exact FALM measure describes **displayed** liquidity.

Iceberg/reserve capacity that has not yet been displayed is not part of the
current visible cohort measure.

When hidden reserve refreshes displayed quantity, that refresh appears in
the visible FALM system as new birth mass unless the feed exposes a stronger
identity relation.

Therefore FALM does not pretend to identify invisible reserve capacity from
ordinary public L2.

Hidden reserve affects

\[
b(A,p)
\]

and future replenishment uncertainty.

This is a feature of the ancestry formulation: persistent visible depth can
be replacement-dependent even when the replacement source is hidden reserve.

---

# 53B.2 Aggressor-sign uncertainty

On venues where aggressor side is not directly identified, let each trade
have an admissible sign set or probability.

Certified FALM must branch the feasible transition set across admissible
sign assignments because the directional forcing clock itself depends on
trade sign.

A guessed tick-rule sign must not be reported as certified forcing age.

---

# 53C. Robust decision certification

Let \(F(\mu)\) be a decision-relevant functional and let

\[
F^-=\inf_{\mu\in\mathfrak F_k}F(\mu),
\qquad
F^+=\sup_{\mu\in\mathfrak F_k}F(\mu).
\]

For threshold \(c\):

- if \(F^-\ge c\), the condition \(F\ge c\) is certified for every admissible
  hidden state;
- if \(F^+<c\), the condition fails for every admissible hidden state;
- otherwise the observation is unresolved.

This converts partial observability into a mathematically explicit
abstention/uncertainty state rather than forcing a false binary decision.

---

# 54. Machine-learning state tensor

Choose distances

\[
0<r_1<\cdots<r_n
\]

and forcing thresholds

\[
0=v_0<v_1<\cdots<v_m.
\]

Construct

\[
\boxed{
Z_{ij}
=
\widehat S(r_i,v_j).
}
\]

For partially identified public data, use

\[
\boxed{
Z_{ij}^{-},
\quad
Z_{ij}^{+},
\quad
\Omega_{ij}.
}
\]

Additional channels may contain

\[
H_F,\quad
K_F,\quad
\chi_F,\quad
E_F,\quad
\tau_\theta.
\]

The tensor axes have explicit mathematical semantics:

1. price distance;
2. same-direction aggressive forcing age.

A model may use parallel channels for

\[
a^{\mathrm{global}}
\]

and one or more **pre-frozen**

\[
a^{\kappa}
\]

challenge-age kernels. Kernel proliferation without frozen ablation is
prohibited.

---

# 55. Shape-constrained ML

FALM supplies exact monotonicity:

\[
S(r_2,v)\ge S(r_1,v)
\quad
(r_2\ge r_1),
\]

\[
S(r,v_2)\le S(r,v_1)
\quad
(v_2\ge v_1).
\]

A model can enforce these constraints architecturally or through projected outputs.

This reduces the hypothesis class relative to unconstrained arbitrary tensors.

---

# 56. Cross-scale normalization

Choose frozen price, depth, and forcing scales

\[
\sigma_x>0,\qquad Q_*>0,\qquad V_*>0.
\]

Define

\[
x'=\frac{x}{\sigma_x},
\qquad
a'=\frac{a}{V_*},
\qquad
\nu'=\frac{1}{Q_*}T_\#\nu.
\]

Then

\[
\boxed{
S'(r',v')
=
\frac{
S(\sigma_x r',V_*v')
}{
Q_*
}.
}
\]

Dimensionless objects such as \(\chi_F\) are unchanged by pure forcing-unit rescaling.

Normalization parameters must be estimated from past/completed data only.

---

# 57. FALM versus ordinary order lifetime

Calendar lifetime is

\[
t-b.
\]

FALM forcing age is

\[
A_s(t)-A_s(b).
\]

Two orders with equal calendar lifetime can have radically different forcing ages.

Two orders with equal forcing age can have radically different calendar lifetimes.

Therefore FALM is not equivalent to conventional order-lifetime filtering unless aggressive-flow intensity is effectively deterministic and constant, which is not assumed.

---

# 58. FALM versus ordinary volume time

Ordinary volume time assigns the market as a whole a cumulative activity clock.

FALM attaches a **cohort-relative exposure age** to currently resting liquidity:

\[
a=A_s(t)-A_s(b).
\]

The state is not merely the current value of a volume clock.

It is a measure over the distribution of birth-relative exposure ages across
the book.

The challenge-age extension further makes age velocity state-dependent via

\[
da/dA=\kappa(x),
\]

which is different from simply resampling the whole market into equal-volume
bars.

---

# 59. FALM versus resiliency

Conventional resiliency asks how depth/spread/intensity recover after a liquidity shock.

FALM asks which currently displayed liquidity has survived how much subsequent same-direction aggressive forcing.

Replenishment can create high conventional depth resiliency while leaving low FALM durability.

The two concepts can therefore disagree by construction.

---

# 60. FALM versus fill-time survival analysis

Fill-time survival analysis estimates how long a newly submitted order takes to fill.

FALM conditions the **current book** on forcing already survived and studies its future resistance to additional forcing.

The target population and time coordinate are different.

---

# 61. Novelty boundary

The following neighboring mathematical/market ideas are established and cannot individually constitute FALM novelty:

- order lifetime;
- fill-time survival models;
- queue-reactive models;
- Hawkes order-flow models;
- order-book resiliency;
- market-impact propagators;
- persistent/metaorder order flow;
- latent/reaction-diffusion order books;
- activity/event/volume clocks;
- volume-bucketed meso-scale LOB analysis;
- measure-valued order-book processes;
- stochastic dominance;
- age-structured transport equations;
- optimal transport;
- robust/set-valued filtering;
- linear programming.

The candidate novelty lies in the composed trading-specific construction:

\[
\boxed{
\text{birth-relative same-sign aggressive forcing age}
}
\]

attached to currently resting opposing liquidity, producing

\[
\boxed{
\text{price}\times\text{forcing-age liquidity measures}
}
\]

with

\[
\boxed{
\text{forcing-survival surfaces},
}
\]

\[
\boxed{
\text{hidden-cohort feasible-state sets and certified envelopes},
}
\]

\[
\boxed{
\text{forcing hazards/hardening},
}
\]

and

\[
\boxed{
\text{counterfactual resistance under continued aggression}.
}
\]

Current claim:

\[
\boxed{
\text{candidate-new composition; global novelty not proven}.
}
\]

---

# 62. Literature attack completed in this pass

The current novelty attack checked adjacent work including:

1. **Krause, Jungblut, Guhr — Two Price Regimes in Limit Order Books**  
   Analyzes price, time, limit-order lifetime, and volume jointly. This is close in dimensional spirit but uses ordinary lifetime rather than birth-relative same-sign aggression survived.

2. **Arroyo, Cartea, Moreno-Pino, Zohren — Deep Attentive Survival Analysis in Limit Order Books**  
   Models passive-order fill-time survival from time-varying LOB features; different target and clock.

3. **Xu et al. — Limit-order book resiliency after effective market orders**  
   Studies spread/depth/intensity recovery around market-order shocks; does not supply FALM cohort forcing ages.

4. **Huang, Lehalle, Rosenbaum — Queue-Reactive Model**  
   Queue state drives order-flow intensities; no identified FALM forcing-age measure.

5. **Wu, Rambaldi, Muzy, Bacry — Queue-Reactive Hawkes Models**  
   Adds past order-flow dependence and queue state; still a different state construction.

6. **Krause et al. / high-frequency lifetime filtration work**  
   Shows ordinary order lifetime can improve structural filtering, reinforcing the need to distinguish ordinary lifetime from FALM forcing age.

7. **Recent latent-book / persistent-order-flow work**  
   Explicitly models liquidity replenishment and front-slope adaptation under persistent signed flow, which is an important neighboring mechanism but does not appear, in the checked sources, to attach cumulative same-sign forcing survived to each current liquidity cohort.

8. **Recent state-dependent Binance L2 work**  
   Shows pre-existing L2 state and order flow can have state-dependent predictive value, supporting state-first evaluation but not establishing FALM.

9. **Bechler & Ludkovski — Order Flows and LOB Resiliency on the Meso-Scale**  
   Uses volume-based bucketing and addition/cancellation/order-flow predictors.
   This is a close neighbor for activity clocks, but it does not attach
   birth-relative same-sign forcing/challenge ages to currently resting
   liquidity cohorts.

No checked source supplied the full FALM composition above.

That is evidence for novelty investigation, not exhaustive proof of absence from all literature.

---

# 63. Binance observability specification

For Binance implementation, the relevant public-feed facts are:

- diff-depth streams update price-level quantities;
- spot supports 100 ms or 1000 ms diff-depth updates;
- USD-M futures supports 100 ms / 250 ms / 500 ms depth pushes depending stream configuration;
- aggregate-trade streams expose aggressor-side inference through the buyer-maker flag;
- public depth data are level quantities, not public resting-order identities.

Therefore Binance naturally places FALM in the partially identified/set-valued regime rather than exact public-order-identity regime.

The correct implementation is:

\[
\text{depth reconstruction}
+
\text{aggressive trades}
+
\text{feasible hidden cohorts},
\]

not invented public order IDs.

---

# 64. Binance trade-sign convention

For Binance aggregate trades:

- buyer is maker \(\Rightarrow\) seller is taker \(\Rightarrow\) sell aggression;
- buyer is not maker \(\Rightarrow\) buyer is taker \(\Rightarrow\) buy aggression.

Thus a practical sign convention is

\[
\boxed{
\epsilon=
\begin{cases}
-1,&m=\text{true},\\
+1,&m=\text{false}.
\end{cases}
}
\]

The forcing clock increments by the frozen chosen quantity/notional measure.

---

# 65. Historical-data constraint

Binance's public-data repository provides historical trades and aggregate trades directly.

Historical tick-by-tick futures L2 has also existed through Binance's futures order-book download facility, with documented data gaps and access requirements.

Therefore rigorous historical FALM evaluation requires one of:

- retained raw diff-depth + aggTrade streams;
- suitable tick-by-tick historical L2 acquired through the documented order-book-data path;
- another source with equivalent event-level depth and aggressive-trade data.

OHLCV alone cannot reconstruct FALM.

---

# 66. Reference discrete update algorithm

For each aggressive direction \(s\):

1. reconstruct the local L2 book from exchange snapshots plus ordered diff-depth updates;
2. ingest aggressive trades and infer sign;
3. determine admissible event sequencing at the feed resolution;
4. for each resolved aggressive event, remove executed pre-event cohorts;
5. increment global \(A_s\) by the event forcing units;
6. age only surviving cohorts by \(\Delta A_s\), and challenge-age cohorts by
   \(\kappa(x)\Delta A_s\);
7. insert post-event new displayed mass at age zero;
8. retain residual cancellation/withdrawal and ambiguous sequencing separately;
9. apply price-level balance
   \[
   q_{k+1}=q_k+B-C-E;
   \]
10. represent hidden matched churn by \(c_k\);
11. update the feasible cohort polytope rather than selecting an unobserved FIFO/LIFO history;
12. compute certified \(S^-,S^+,\Omega\);
13. derive only those hazard/hardening statistics whose numerical differentiation is sufficiently identified/stable;
14. emit the FALM ML tensor using data available at or before the decision timestamp.

---

# 67. Timestamp and sequencing uncertainty

Depth streams and trade streams are separate observations.

When exchange data do not establish a unique cross-stream ordering for multiple events sharing a time bucket, the feasible transition relation must branch over all admissible orderings or include a sequencing uncertainty model.

A single arbitrary merge-sort tie breaker must not be treated as ground truth.

This is particularly important at 100 ms aggregation scales.

---

# 68. Numerical differentiation rule

\(H_F\) and \(K_F\) involve derivatives and are therefore more noise-sensitive than \(S\).

The implementation hierarchy is:

1. survival surface \(S\) — primary;
2. robust envelopes \(S^\pm,\Omega\) — primary under L2 uncertainty;
3. endurance moments — stable integrals;
4. hazard \(H_F\) — derived only after smoothing/regularization frozen on development data;
5. hardening \(K_F\) — second-order derived object requiring the strongest stability checks.

A trading result that exists only in an unstable numerical \(K_F\) estimate should not be accepted.

---

# 69. Robust ML input hierarchy

Preferred order of admission:

### Layer 0
ordinary L2 / trade-flow baseline.

### Layer 1
FALM survival tensor \(S\) or \(\widehat S\).

### Layer 2
identification bounds \(S^-,S^+,\Omega\).

### Layer 3
endurance moments / repair balance.

### Layer 4
total and cause-specific hazards

\[
H_F,\ H_E,\ H_C,\ \psi_E.
\]

### Layer 5
hardening \(K_F,\chi_F\).

### Layer 6
counterfactual resistance \(\tau_\theta\) and penetration quantities.

A higher layer is retained only if it improves frozen out-of-sample evaluation beyond all lower layers.

---

# 70. Required trading-baseline attack

At minimum compare the same ML architecture with and without FALM against:

1. ordinary L2 depth;
2. queue imbalance;
3. multi-level order-flow imbalance;
4. trade-sign history;
5. aggressive-volume history;
6. additions/cancellations;
7. elapsed-time order-lifetime features when available;
8. strong raw-event sequence models;
9. strong deep LOB baselines.

The key comparisons are

\[
\boxed{
\text{baseline+FALM}
\quad\text{vs}\quad
\text{baseline}
}
\]

and

\[
\boxed{
\text{raw-history model}
\quad\text{vs}\quad
\text{FALM-structured model}.
}
\]

---

# 71. Falsification protocol

The protocol is non-negotiable:

- frozen development windows remain frozen;
- the 12:41 contradiction remains an adversarial required case;
- rejected spectrum/OI branches remain rejected;
- no moving test windows to rescue FALM;
- no same-event/future leakage;
- no tuning on final test windows;
- several prediction horizons;
- calm, mixed, stressed, and contradiction windows;
- realistic spread, fees, slippage, latency, and fill assumptions;
- trade count and turnover reported;
- confidence intervals / blocked resampling where applicable;
- FALM accepted only for incremental out-of-sample value.

---

# 72. Synthetic theorem sanity checks completed

A discrete cohort simulator was used to test algebraic identities.

### Extremal removal

Across randomized atomic cohort books, oldest-first removal always produced the minimum first age moment and youngest-first removal the maximum among randomized feasible deletions.

### Endurance balance

For randomized sequences of

- forcing increments;
- birth;
- oldest/youngest removal,

the discrete identity

\[
\Delta M
=
Q_{\mathrm{pre}}\Delta A
-
\text{forcing-age mass removed}
\]

held to floating-point error.

Observed maximum absolute error in the randomized check was approximately

\[
10^{-12}.
\]

### Affine forcing units

The product of appropriately rescaled hazard and collapse forcing remained invariant under forcing-unit changes.

### Hardening dominance

For a decreasing hazard example

\[
h(a)=\frac{1}{1+a},
\]

older stochastically dominant age populations had greater expected survival for every tested additional forcing budget.

These are mathematical/synthetic sanity tests, not market-performance evidence.

---

# 72A. Reduction-consistency checks

The extensions introduced during adversarial closure reduce to earlier FALM
in the required limits:

### Challenge-age reduction

If

\[
\kappa(x)\equiv1,
\]

then

\[
\partial_a(\kappa g)=\partial_ag
\]

and generalized challenge-age transport reduces to canonical global-age
FALM.

### No-front-motion reduction

If

\[
\dot P_A=0,
\]

then

\[
v_x=0,
\qquad
J_x=0,
\]

and the moving-front hazard/repair balances reduce to fixed-coordinate
balances.

### No-cancellation reduction

If

\[
D^C=0,
\]

then all visible destruction is execution destruction and

\[
H_F=H_E,
\qquad
\psi_E=1.
\]

### No-execution reduction

If

\[
D^E=0,
\]

then all visible destruction is withdrawal and

\[
H_F=H_C,
\qquad
\psi_E=0.
\]

### No-future-birth reduction

If

\[
b(A+u)=0
\quad
(0<u\le z),
\]

then

\[
C^{\mathrm{new}}(z)=0,
\qquad
\alpha(z)=1
\]

whenever surviving resistance is nonzero.

### Memoryless treadmill reduction

For

\[
h=\lambda,
\qquad
b=\lambda Q,
\]

the total expected displayed resistance remains \(Q\), while ancestry is

\[
\alpha(z)=e^{-\lambda z}.
\]

These reductions were checked algebraically and with discrete numerical
sanity tests.

---

# 73. What FALM now proves

Under its explicitly stated assumptions, the theoretical core now contains
the following structural results and closure constructions:

1. terminal L2 non-identifiability of forcing durability;
2. one-radius survival-tail completeness;
3. joint survival-surface completeness;
4. existence and uniqueness of the basic forcing-age transport;
5. stability under initial/birth perturbations;
6. endurance-balance identity;
7. upper bound for the correctly scoped repair coefficient;
8. moving-front endurance-flux correction;
9. generalized local challenge-age transport with \(da/dA=\kappa(x)\);
10. corrected survival/hazard balance under challenge-age transport;
11. canonical discrete-event survivor-credit semantics;
12. cause-specific execution/cancellation destruction decomposition;
13. finite-window cause-specific rates for singular event measures;
14. coarse-snapshot impossibility under unbounded hidden churn;
15. robust feasible-state containment;
16. LP-computable certified discretized envelopes;
17. affine forcing-unit covariance;
18. information refinement relative to terminal L2;
19. no information creation relative to full raw history;
20. conditional sufficiency criterion;
21. resistance dominance under age dominance plus hardening;
22. stationary exponential treadmill benchmark;
23. stationary hardening benchmark;
24. competing-risk execution/cancellation benchmark;
25. inherited-versus-new resistance decomposition;
26. exact ancestry tagging under state-dependent common hazards;
27. positive-propagator/Duhamel ancestry representation;
28. exact exponential treadmill ancestry law;
29. robust ancestry interval;
30. OHLCV non-recoverability;
31. visible-liquidity/hidden-reserve scope separation;
32. robust threshold-decision certification.

The framework now distinguishes four concepts that ordinary depth can merge:

\[
\boxed{
\text{how much liquidity exists},
}
\]

\[
\boxed{
\text{how long it has coexisted with the aggressive program},
}
\]

\[
\boxed{
\text{how much aggression occurred while it was locally challengeable},
}
\]

and

\[
\boxed{
\text{whether disappearing resistance was consumed or withdrawn}.
}
\]

This is sufficient for FALM to be treated as a standalone mathematical
framework rather than a single engineered feature.

---

# 74. Mathematical closure matrix

| Area | Status |
|---|---|
| Primitive state | PASS |
| Directional forcing clock | PASS |
| Local challenge-age kernel extension | PASS |
| Exact measure formulation | PASS |
| Front-coordinate transport | PASS |
| Discrete-event survivor convention | PASS |
| Deterministic dynamics | PASS under stated regularity |
| Stochastic/event formulation | PASS as framework |
| Survival representation | PASS |
| Joint state identifiability from exact survival surface | PASS |
| Terminal-L2 non-identifiability | PASS |
| Coarse-snapshot impossibility theorem | PASS |
| OHLCV non-recoverability theorem | PASS |
| Hidden-cohort uncertainty | PASS via feasible-state set |
| Certified discretized reconstruction | PASS via LP formulation |
| Geometry/topology | PASS |
| Scale/unit covariance | PASS |
| Repair coefficient scope/flux correction | PASS |
| Hazard spatial-flux correction | PASS |
| Cause-specific execution/cancellation hazards | PASS |
| Singular/event destruction formulation | PASS |
| Hardening interpretation | PASS as population-tail object |
| Present-book counterfactual survival | PASS conditional on hazard |
| Future replenishment decomposition | PASS |
| Resistance ancestry/replacement calculus | PASS |
| Tagged ancestry under state-dependent hazard | PASS |
| Bilateral extension | PASS |
| Multi-venue extension | DEFINED; optional, not empirically validated |
| ML interface | PASS as representation |
| Certified-vs-estimated distinction | PASS |
| Decision-certification layer | PASS |
| Global novelty | OPEN; finite search cannot prove universal absence |
| Patent novelty search | OPEN; official connector searches failed in this pass |
| Frozen-window empirical alpha | OPEN; exact raw event window not accessible here |
| Real trading dominance | OPEN; must be measured, never assumed |

The **mathematical construction itself is closed for the current single-venue
core scope**. The remaining OPEN rows are evidence claims, not missing
mathematical definitions.

---

# 75. What remains before FALM can honestly be called 100% validated

## Theoretical completion

For the current core scope, the mathematical development loop has reached
closure: subsequent passes found no remaining internal gap that requires
another primitive merely for formal completeness.

That does **not** mean the external claims are 100% established.

The remaining work is evidence that cannot be manufactured by more algebra.

## A. Global novelty evidence

The literature attack found close neighbors in ordinary order lifetime,
resiliency, queue-reactive/Hawkes models, persistent order flow, latent
liquidity, and liquidity replenishment, but no checked primary research
source supplied the complete FALM composition.

A universal proof that no equivalent idea exists anywhere in all papers,
patents, code, or unpublished work is logically unavailable from finite
search.

The patent connector returned provider errors in this pass, so patent
novelty is explicitly unresolved rather than counted as a pass.

## B. Frozen 12:41 empirical reconstruction

The accessible files contain the record that the 12:41 contradiction is a
mandatory adversarial frozen case, but not the underlying raw synchronized
depth/trade event stream.

The protocol forbids replacing it with a newly selected favorable window.

Therefore that empirical falsification cannot be truthfully completed from
the currently accessible artifacts.

## C. Incremental out-of-sample value

FALM must still establish

\[
\text{baseline+FALM}
>
\text{baseline}
\]

on frozen data under the same architecture, costs, and evaluation rules.

## D. Derivative stability

\(H_F,K_F,\chi_F\) must survive feed-resolution and smoothing perturbations.

## E. Strategy-level execution realism

Any claimed trading gain must survive fees, spread, slippage, latency,
fill probability, turnover, and impact assumptions.

Accordingly:

\[
\boxed{
\text{THEORETICAL FALM CORE: CLOSED}
}
\]

but

\[
\boxed{
\text{EMPIRICALLY VALIDATED TRADING EDGE: NOT YET ESTABLISHED}
}
\]

and

\[
\boxed{
\text{GLOBAL NOVELTY: NOT PROVABLE FROM THE FINITE SEARCH COMPLETED HERE}.
}
\]

Calling the latter two items “100% done” would be false.

---

# 76. Current final theoretical verdict

FALM is no longer merely a repair coefficient or an engineered order-book feature.

Its core state transformation is

\[
\boxed{
\text{price}\times\text{displayed quantity}
\quad\longrightarrow\quad
\text{price}\times\text{quantity}\times\text{same-sign aggression survived}.
}
\]

Its public-L2 uncertainty layer is

\[
\boxed{
\text{unknown cohort identities}
\quad\longrightarrow\quad
\text{feasible hidden-state set}
\quad\longrightarrow\quad
\text{certified survival envelopes}.
}
\]

Its counterfactual layer is

\[
\boxed{
\text{current FALM state}
\quad\longrightarrow\quad
\text{survival under additional forcing}
\quad\longrightarrow\quad
\tau_\theta.
}
\]

Its decision layer is

\[
\boxed{
\text{remaining aggression}
\quad\text{versus}\quad
\text{remaining resistance}.
}
\]

This directly addresses the original 12:41 contradiction while preserving uncertainty that public aggregate order-book data cannot resolve.

---

# 77. Theoretical closure rule

The current single-venue theoretical core is closed under the explicit
scope and observation assumptions in this document. All later additions
must now be justified by empirical evidence or by discovery of an actual
counterexample to the mathematics.

Do not add complexity merely to make the theory look larger.

A new FALM object is admitted only if it does at least one of the following:

1. repairs a mathematical defect;
2. proves a missing structural result;
3. reduces observation uncertainty;
4. creates a testable new prediction not reducible to existing admitted state;
5. improves frozen out-of-sample trading value;
6. improves robustness/sample efficiency without degrading frozen performance.

Otherwise it is rejected as unnecessary elaboration.

