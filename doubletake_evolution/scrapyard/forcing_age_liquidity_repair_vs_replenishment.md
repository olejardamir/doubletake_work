# Forcing-Age Liquidity: Repairing Opposing Book vs. Replenishment Treadmill

## Continuation Point

This continues from the **L1 liquidity-state falsification**, without reopening the rejected spectrum/OI branches.

The 12:41 contradiction suggests that the missing state variable is not:

> How much opposing liquidity exists?

but rather:

> How much continued aggression that liquidity has already survived?

The missing object must distinguish a **repairing opposing book** from an opposing book that is merely being replenished while a latent aggressive program is still consuming it.

---

## Candidate Primitive: Forcing-Age Liquidity

Let \(s\in\{-1,+1\}\) denote the direction of the aggressive program.

Instead of measuring time in seconds, define a same-sign aggressive-volume clock:

\[
A_s(t)
=
\int_{t_0}^{t}
\mathbf 1_{\{\text{trade direction}=s\}}\,dV.
\]

Now take every new unit of opposing liquidity posted after \(t_0\).

If cohort \(j\) appeared when the aggressive clock was \(A_j\), its **forcing age** at the present aggressive volume \(A\) is

\[
a_j(A)=A-A_j.
\]

This differs from ordinary order lifetime because the age coordinate is measured in **cumulative subsequent same-direction aggressive volume**, not elapsed calendar time.

Represent opposing replenishment as the measure

\[
\boxed{
\mu_A(da)
=
\sum_j x_j(A)\,
\delta_{A-A_j}(da)
}
\]

where \(x_j(A)\) is the amount of cohort \(j\) still resting.

This retains information that ordinary visible book depth destroys.

The visible opposing depth is merely

\[
Q(A)=\int_0^\infty \mu_A(da).
\]

Therefore two books can have exactly the same \(Q\), while one consists of old, durable liquidity and the other consists almost entirely of liquidity posted moments ago to replace what the aggressor just consumed.

That is the missing distinction.

---

## Opposing Liquidity Endurance Mass

Take the first forcing-age moment:

\[
\boxed{
M(A)
=
\int_0^\infty a\,\mu_A(da)
}
\]

Provisionally call this **opposing liquidity endurance mass**.

Suppose replenishment enters at forcing age \(0\), while execution/cancellation removes liquidity with hazard \(h(A,a)\).

Then the age-structured dynamics take the form

\[
\partial_A\mu+\partial_a\mu
=
-h(A,a)\mu,
\]

with new replenishment injected at \(a=0\).

The visible-depth moment satisfies

\[
\frac{dQ}{dA}
=
b(A)-\int h(A,a)\mu_A(da),
\]

where \(b(A)\) is replenishment.

The endurance-mass moment satisfies

\[
\boxed{
\frac{dM}{dA}
=
Q(A)
-
\int a\,h(A,a)\mu_A(da)
}
\]

The crucial property is:

**Fresh replenishment does not directly increase \(M\), because it enters with forcing age zero.**

A large quantity of rapidly replaced liquidity can therefore make the visible book look extremely strong while contributing almost nothing to endurance mass.

---

## Repair Coefficient

Define the finite-window quantity

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

under the clean tracked-cohort formulation.

Interpretation:

- \(\mathcal R\approx1\): opposing liquidity is **surviving continued aggression**. This resembles genuine repair.
- \(\mathcal R\approx0\): displayed depth is maintained primarily through replacement while earlier liquidity disappears. This is the **replenishment treadmill**.
- \(\mathcal R<0\): aged opposing liquidity is disappearing faster than endurance can accumulate. This is an especially strong continuation state.

This directly addresses the pathological case:

\[
\text{large opposing terminal book}
\not\Rightarrow
\text{impact repair}.
\]

Instead,

\[
\boxed{
\text{large book}
+
\text{low forcing-age endurance}
\Rightarrow
\text{apparent opposition produced by rapid replacement}.
}
\]

Whereas

\[
\boxed{
\text{large book}
+
\text{high forcing-age endurance}
\Rightarrow
\text{opposition that is actually surviving aggression}.
}
\]

---

## Why the Previous L1 State Necessarily Failed

There is a simple non-identifiability result.

Consider two processes with the same constant displayed opposing depth \(Q_0\).

### Case 1: Genuinely Durable Book

Let

\[
b=0,\qquad h=0.
\]

Then

\[
Q(A)=Q_0,
\qquad
M(A)=M(0)+Q_0A.
\]

The displayed book remains present and its forcing age accumulates continuously.

### Case 2: Replenishment Treadmill

Choose

\[
b=\lambda Q_0,\qquad h=\lambda.
\]

Then

\[
\frac{dQ}{dA}=0,
\]

so again

\[
Q(A)=Q_0.
\]

The visible depth is identical to the durable-book case even though liquidity is continuously disappearing and being replaced.

After reaching its stationary age structure,

\[
M(A)\approx \frac{Q_0}{\lambda},
\]

and therefore over a sufficiently developed window,

\[
\mathcal R\approx0.
\]

Thus

\[
\boxed{
Q_{\rm repair}(A)=Q_{\rm treadmill}(A)
}
\]

can hold while

\[
\boxed{
\mathcal R_{\rm repair}\approx1,
\qquad
\mathcal R_{\rm treadmill}\approx0.
}
\]

Therefore **no function of terminal depth alone can universally solve the distinction**.

That explains mathematically why book alignment encountered the 12:41 contradiction.

---

## Current Status

This is the first candidate since the L1 falsification that directly targets the missing variable instead of adding another predictor to the old state.

Its current status is:

- **L1 terminal-book alignment:** falsified as sufficient.
- **Spectrum/OI branches:** remain rejected.
- **Visible depth:** retained only as a baseline observable.
- **New candidate state variable:** forcing age measured in same-sign aggressive volume.
- **New object:** forcing-age liquidity measure \(\mu_A\).
- **New derived quantity:** opposing liquidity endurance mass \(M(A)\).
- **New discriminator:** repair coefficient \(\mathcal R(A_1,A_2)\).
- **Main result so far:** terminal depth is non-identifying; durable repair and replenishment treadmill can produce the same displayed depth while differing in forcing-age structure.
- **Novelty status:** candidate only; not yet globally proven novel.
- **Development status:** branch remains alive and should be falsified empirically against the frozen trading windows before formal promotion.
