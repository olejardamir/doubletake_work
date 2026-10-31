# No Primitive Boundary in the Boolean Base
## A Separator-Free Dyadic Factorization of Minimal Two-Valued Structure

**Working manuscript — mathematical foundations / logic**  
**Version 0.4 (proof-audited)**  
**Date:** 27 August 2026

---

## Abstract

This paper asks a deliberately narrow foundational question: **must a primitive boundary or separator be included in the explanatory basis of the two-valued Boolean structure?** The answer is no, but the negative claim must be formulated carefully. Boundary-free symbolic axiomatizations of Boolean algebra are long established, so the paper does **not** claim that Boolean algebra can only now be written without boundary notation. Nor does it claim to derive logic *ex nihilo* from a pre-logical reality.

Instead, the paper studies a specific **separator-free factorization** of the Boolean base. A No-Primitive-Boundary principle (NPB) is treated as a restriction on primitive vocabulary rather than as an algebraic axiom. Minimal nontrivial articulation then yields a two-element carrier. From a bare two-element carrier, three elementary but structurally useful facts follow without postulating polarity: (i) there is a unique nonidentity permutation, necessarily a fixed-point-free involution; (ii) there are exactly two commutative idempotent binary operations, both automatically associative; and (iii) the involution exchanges those two operations by De Morgan duality. No single commutative idempotent operation is invariant under the pole-exchange symmetry.

These facts define a canonical **separator-free dyad**: an unoriented two-status structure carrying a unique pole exchange and an unordered dual pair of semilattice operations. A single additional **indication/orientation**—designation of either pole—then uniquely determines, up to isomorphism, the ordinary two-element Boolean algebra \(\mathbf 2\). The opposite indication yields the dual but isomorphic Boolean orientation.

The mathematical facts proved here are elementary and are not claimed as new algebra. The proposed contribution is the **foundational organization** of those facts into the dependency pattern

\[
\text{no primitive separator}
\;\rightsquigarrow\;
\text{minimal inequivalence}
\;\rightsquigarrow\;
\text{canonical unoriented dyad}
\;\rightsquigarrow\;
\text{indication}
\;\rightsquigarrow\;
\mathbf 2,
\]

contrasted with boundary- or mark-first presentations. A Stone-representation observation is retained only as a limited consistency check: Boolean elements admit clopen representatives with empty topological boundary, but this does not establish metaphysical boundary eliminativism.

The manuscript explicitly identifies what is standard, what is conditional, what is interpretive, and what would falsify or weaken the proposed foundational reading.

**Keywords:** Boolean algebra; Boolean logic; boundary; distinction; separator-free structure; bivalence; indication; Spencer-Brown; Stone duality; partition logic; foundations of logic

---

# 1. Introduction

Boolean logic has many presentations. It can be developed through truth tables, complemented distributive lattices, Boolean rings, set algebras, the Sheffer stroke, or other functionally complete operations. Boundary-free symbolic presentations are therefore not new: Sheffer's 1913 axiomatization already showed that Boolean structure can be presented using a single binary primitive operation, and later work has reduced Boolean algebra to very short single axioms in such signatures.

A separate tradition uses **distinction, enclosure, cuts, or marks**. Peirce's existential graphs use closed cuts for negation. Spencer-Brown's *Laws of Form* begins from distinction and indication, and later boundary-algebra presentations make enclosure central to the notation.

The present paper does not argue that these boundary-based formalisms are incorrect. It asks a dependency question:

> **Does the logical existence of two inequivalent statuses require a primitive separator or boundary object?**

At the level of ordinary mathematics, the answer is straightforwardly negative: \(x\neq y\) does not require a third entity between \(x\) and \(y\). The interesting question is therefore not whether a boundary-free notation is possible. It is whether one can expose a clean **foundational factorization** in which boundaryhood never appears as primitive structure.

The proposed factorization is:

\[
\boxed{
\text{NPB}
\;\leadsto\;
\text{minimal nontrivial articulation}
\;\leadsto\;
\text{unoriented dyad}
\;\leadsto\;
\text{indication}
\;\leadsto\;
\mathbf 2.
}
\]

The principal revisions relative to weaker formulations of this idea are:

1. **NPB is not treated as an algebraic axiom.** It is a primitive-signature restriction.
2. **No polarity axiom is postulated.** On a two-element carrier, the pole-exchange involution is forced.
3. **No order is silently inserted.** Before indication, meet and join are kept as an unordered dual pair.
4. **Indication is isolated as the exact symmetry-breaking step needed to orient the Boolean pair.**
5. **Stone duality is not used to prove NPB.** It only shows that Boolean difference need not be represented by a nonempty topological boundary.
6. **No claim of absolute genesis is made.** Equality, sets, maps, and finite cardinality are resources of the metalanguage.

The paper is therefore best read as a work in **foundational organization and minimal presentation**, not as the discovery of a new finite algebra.

---

# 2. Non-claims

To prevent equivocation, the following claims are explicitly **not** made.

## 2.1 No claim that boundary-free Boolean notation is new

Boolean algebra has long had presentations with no primitive boundary symbol. Sheffer's stroke is a canonical example. The novelty question here concerns the proposed *foundational ordering*, not the mere absence of boundary syntax.

## 2.2 No claim that all physical or topological boundaries are unreal

The paper does not defend general boundary eliminativism. Physical interfaces, mereological boundaries, topological frontiers, and graphical cuts may be mathematically or scientifically useful.

## 2.3 No claim that NPB causes or generates two-valuedness

No-Primitive-Boundary by itself does not imply:

\[
|X|\ge 2,
\]

let alone

\[
|X|=2.
\]

Two-valuedness enters only under a separate minimal-nontriviality condition.

## 2.4 No claim of pre-logical derivation

The theory is written in ordinary mathematics. Thus the metalanguage already distinguishes symbols, objects, proofs, and truth conditions. The paper reconstructs a **presentation-level Boolean base**; it does not derive the absolute first distinction in reality.

## 2.5 No claim that Stone duality proves boundary eliminativism

Clopen representatives have empty topological boundary, but topological boundary is only one meaning of "boundary." Stone duality therefore provides a representation result, not an ontological conclusion.

---

# 2A. Proof protocol and claim classes

Every substantive statement in this manuscript is to be read under one of the following statuses.

- **[Definition]** — introduces terminology or notation. A definition is not proved; its adequacy can be criticized.
- **[Assumption]** — an independent principle adopted for the reconstruction. It is not derived from earlier assumptions.
- **[Proved here]** — a mathematical proposition or theorem whose proof is supplied in this manuscript.
- **[Standard theorem]** — a theorem established in the cited mathematical literature; only the consequence needed here is proved locally.
- **[External historical claim]** — a claim about prior literature supported by citation rather than mathematical proof.
- **[Interpretive claim]** — a philosophical or explanatory reading of the mathematics. It is not presented as a theorem.
- **[Literature-based novelty claim]** — a defeasible statement about what was or was not located in prior work. No literature search can prove a universal historical negative.
- **[Open problem]** — explicitly unproved.

The dependency discipline of the paper is:

\[
oxed{
	ext{Definitions}
+
	ext{Assumptions}
+
	ext{Standard theorems}
\Longrightarrow
	ext{only conclusions proved below}.
}
\]

No interpretive or novelty claim is used as a premise in a mathematical proof.

---

# 3. Prior work and the location of the present proposal

## 3.1 Boundary and object projectivism

**Status: [External historical claim].**


Azzouni's *Ontology Without Borders* argues that metaphysical object borders should not be regarded as independently given worldly entities and develops a projectivist account of object individuation. The generic thesis that object boundaries need not be fundamental is therefore prior work.

## 3.2 Boundary-based logical presentations

**Status: [External historical claim].**


Peirce's existential graphs use cuts to encode negation. Spencer-Brown's *Laws of Form* takes distinction and indication as primitive, while later boundary algebra explicitly builds Boolean structure through enclosure and concatenation.

The present paper does not claim priority over those systems. It instead examines whether the algebraic dependency can be presented without primitive separator structure.

## 3.3 Boundary-free Boolean axiomatizations

**Status: [External historical claim].**


Sheffer demonstrated in 1913 that Boolean algebra can be axiomatized using a single binary primitive operation. Modern single-axiom work further emphasizes that no boundary-like primitive is algebraically necessary.

This is a decisive prior-art constraint: the claim

> "Boolean algebra does not require a boundary symbol"

is old and cannot constitute the contribution of this paper.

## 3.4 Partition logic

**Status: [External historical claim] + [Standard mathematical result].**


Ellerman's partition logic makes **distinctions** explicit. The indiscrete partition has no distinctions, and the atoms above it are binary partitions. Thus the mathematical fact that a minimal nontrivial partition refinement is binary is established prior work.

The present manuscript uses a simpler carrier-minimality argument and does not claim novelty for binarity itself.

## 3.5 Stone representation

**Status: [Standard theorem]; Stone (1936), Reference 9.**


Stone's representation theorem represents Boolean algebras as algebras of clopen sets. Since clopen sets have empty topological boundary, Boolean elements admit representations that require no nonempty boundary locus.

Again, this is standard mathematics; only its limited interpretive relevance is discussed here.

## 3.6 Two-element semilattices with involution

**Status: [External historical claim]; Bonzio and St. John (2026), Reference 10.**


Recent universal-algebra work provides another important constraint on novelty. Bonzio and St. John (2026), in their study of unital bands with involution, explicitly note that on a two-element universe an idempotent monoid with the nontrivial swapping involution yields the two-element Boolean algebra. Consequently, the observation

\[
\text{two-element semilattice/monoid}
+
\text{swapping involution}
\cong
\mathbf 2
\]

is not new and is not claimed here.

The present factorization is positioned one step earlier: before selecting a monoidal unit or a single semilattice operation, it classifies the bare two-element carrier, its unique pole exchange, and the **unordered pair** of all commutative-idempotent binary compositions. It then isolates indication as the step that orients this symmetric dyad.

## 3.7 Provisional contribution

**Status: [Literature-based novelty claim].**


The manuscript's proposed contribution is limited to the following organization:

1. primitive separator structure is excluded at the foundational signature level;
2. minimal inequivalence is represented by a bare two-element carrier;
3. without choosing a unit, order, truth pole, or semilattice operation, the carrier canonically determines:
   - its unique nontrivial pole exchange, and
   - the unordered pair of all commutative-idempotent binary operations;
4. no one of those two operations preserves full pole symmetry;
5. indication is isolated as the orientation step that selects Boolean roles;
6. boundary-like representations are therefore optional and downstream in this presentation.

No claim of historical uniqueness is stronger than:

> **In the sources reviewed for this working manuscript, the author did not locate this exact separator-free, pre-unit, pre-orientation dyadic factorization presented as an inversion of boundary-first foundational interpretations.**

That statement is provisional.

---

# 4. Formal scope: separator-free presentation

## Definition 4.1 — Separator-free primitive signature

**Status: [Definition].**


A primitive presentation is **separator-free** when its primitive nonlogical vocabulary contains no:

- boundary sort;
- separator object;
- side-of-boundary predicate;
- inside/outside relation;
- incidence relation whose existence is required in order for two statuses to count as distinct.

Logical equality remains part of the metalanguage.

This definition does not prohibit adding boundaries later. It only prohibits making them explanatory prerequisites of primitive inequivalence.

## Principle NPB — No Primitive Boundary

**Status: [Assumption / presentation constraint].**


The foundational presentation is chosen separator-free.

Symbolically:

\[
\boxed{
x\neq y
\quad\text{does not require}\quad
\exists b\,\operatorname{Sep}(x,b,y).
}
\]

NPB is a **presentation constraint**, not a proposition from which cardinality or algebraic laws follow.

---

# 5. NPB has almost no algebraic consequences by itself

The following are countermodel results. Because NPB is a presentation constraint rather than an ordinary first-order axiom, “does not imply” should be read as **is compatible with a counterexample presentation**.

## Proposition 5.1 — NPB does not imply nontriviality

**Status: [Proved here].**

There exists an NPB-compatible articulated carrier with no inequivalent pair.

### Proof

Take the singleton carrier

\[
X=\{a\}.
\]

Use a primitive signature containing equality but no primitive separator symbols. This satisfies NPB by Definition 4.1.

For all \(x,y\in X\),

\[
x=y=a.
\]

Hence there do not exist \(x,y\in X\) such that \(x\neq y\). Therefore an NPB-compatible presentation can be trivial. \(\square\)

Thus

\[
\boxed{
\mathsf{NPB}\not\Rightarrow \exists x\neq y.
}
\]

---

## Proposition 5.2 — NPB does not imply bivalence

**Status: [Proved here].**

For every cardinal \(\kappa\ge1\), there exists an NPB-compatible carrier of cardinality \(\kappa\).

### Proof

Let \(X\) be any set with

\[
|X|=\kappa.
\]

Equip \(X\) with the separator-free primitive signature of Definition 4.1. NPB imposes no restriction on \(|X|\); it only excludes primitive separator structure. Therefore the resulting presentation is NPB-compatible.

Taking, for example,

\[
|X|=1,\quad |X|=2,\quad |X|=3
\]

gives NPB-compatible carriers of different cardinalities. Hence NPB alone cannot determine bivalence. \(\square\)

Thus

\[
\boxed{
\mathsf{NPB}\not\Rightarrow |X|=2.
}
\]

---

## Proposition 5.3 — NPB does not determine Boolean operations

**Status: [Proved here].**

NPB alone determines no distinguished constants, unary complement, binary meet, binary join, order, distributive law, or law of excluded middle.

### Proof

Choose the three-element carrier

\[
X=\{a,b,c\}
\]

in the separator-free primitive signature consisting only of equality. This is NPB-compatible by Definition 4.1.

Every permutation of \(X\) is an automorphism of this bare structure. Therefore no element of \(X\) is distinguished by the primitive structure as a candidate for \(0\) or \(1\).

Moreover, the primitive signature contains no unary or binary operation symbols. Hence it supplies no operation that could already be identified with Boolean complement, meet, or join.

If one wishes to compare expansions explicitly, the same NPB-compatible carrier can be expanded by many mutually different unary and binary operations. NPB does not select among them.

Therefore NPB alone does not determine Boolean-algebra structure or classical propositional operations. \(\square\)

The precise limitation is:

\[
\boxed{
\text{NPB is foundationally restrictive but algebraically weak.}
}
\]

Any stronger conclusion must identify its additional assumptions explicitly.

---

# 6. Minimal nontrivial articulation

## Definition 6.1 — Nontrivial carrier

**Status: [Definition].**


A carrier \(X\) is **nontrivial** when

\[
\exists x,y\in X,\qquad x\neq y.
\]

Equivalently,

\[
|X|\ge 2.
\]

## Principle MN — Minimal Nontriviality

**Status: [Assumption].**


Among nontrivial separator-free carriers, consider one of minimal cardinality.

## Theorem 6.2 — Minimal nontrivial carrier theorem

**Status: [Proved here].**


If \(X\) satisfies MN, then

\[
\boxed{|X|=2.}
\]

### Proof

Nontriviality gives \(|X|\ge2\). A two-element nontrivial carrier exists. Therefore the minimal possible cardinality of a nontrivial carrier is exactly \(2\). \(\square\)

### Status of the theorem

The theorem is elementary and not new.

Its foundational role is conditional:

> **If the first articulated inequivalence is required to contain no superfluous statuses, then the minimal carrier is binary.**

MN is not derived from NPB. It is an independent minimality principle.

---

# 7. What a bare two-element carrier already forces

Let

\[
X=\{a,b\},
\qquad
a\neq b.
\]

No order, truth designation, boundary, or algebraic operation is initially assumed.

---

## Theorem 7.1 — Unique pole exchange

**Status: [Proved here].**


There is exactly one nonidentity permutation

\[
\nu_X:X\to X.
\]

It is given by

\[
\nu_X(a)=b,
\qquad
\nu_X(b)=a.
\]

Moreover,

\[
\nu_X^2=\operatorname{id}_X
\]

and \(\nu_X\) has no fixed point.

### Proof

A permutation of a two-element set is either the identity or the transposition. \(\square\)

### Consequence

No separate "polarity axiom" is needed to obtain the unique abstract pole exchange. It is forced by two-element cardinality.

The operation \(\nu_X\) is not yet called Boolean negation. It is merely the unique nontrivial symmetry of the carrier.

---

# 8. Canonical binary compositions on the dyad

We now introduce an independent restriction on the class of compositions to be studied.

**Status: [Assumption / scope restriction].**

We ask what binary operations are available if composition is required to be:

1. **commutative**
   \[
   x*y=y*x,
   \]
2. **idempotent**
   \[
   x*x=x.
   \]

These conditions are not consequences of NPB. They express two familiar composition desiderata:

- order of presentation should not matter;
- repeating the same status should not change it.

They are stated explicitly rather than smuggled into the construction.

Let

\[
\mathcal C(X)
=
\{
*:X^2\to X
\mid
*\text{ is commutative and idempotent}
\}.
\]

## Theorem 8.1 — Exactly two commutative idempotent binary operations

**Status: [Proved here].**


If \(|X|=2\), then

\[
\boxed{|\mathcal C(X)|=2.}
\]

### Proof

Write \(X=\{a,b\}\).

Idempotence forces

\[
a*a=a,
\qquad
b*b=b.
\]

Commutativity gives

\[
a*b=b*a.
\]

The mixed value \(a*b\) must be either \(a\) or \(b\). Hence exactly two operations are possible. \(\square\)

Call them \(\mu_a\) and \(\mu_b\), where

\[
\mu_a(a,b)=a
\]

and

\[
\mu_b(a,b)=b.
\]

Their tables are:

\[
\begin{array}{c|cc}
\mu_a & a & b\\
\hline
a&a&a\\
b&a&b
\end{array}
\qquad
\begin{array}{c|cc}
\mu_b & a & b\\
\hline
a&a&b\\
b&b&b
\end{array}.
\]

---

## Theorem 8.2 — Associativity is automatic

**Status: [Proved here].**

Both \(\mu_a\) and \(\mu_b\) are associative.

### Proof

Consider \(\mu_a\).

From its table,

\[
\mu_a(x,y)=b
\]

if and only if

\[
x=y=b.
\]

Therefore for any \(x,y,z\in X\),

\[
\mu_a(\mu_a(x,y),z)=b
\]

if and only if

\[
x=y=z=b.
\]

Likewise,

\[
\mu_a(x,\mu_a(y,z))=b
\]

if and only if

\[
x=y=z=b.
\]

In every other case both expressions equal \(a\). Hence

\[
\mu_a(\mu_a(x,y),z)
=
\mu_a(x,\mu_a(y,z))
\]

for all \(x,y,z\in X\).

The proof for \(\mu_b\) is dual: each bracketing equals \(a\) if and only if \(x=y=z=a\), and equals \(b\) otherwise.

Thus both operations are associative. \(\square\)

Consequently both are semilattice operations.

---

## Theorem 8.3 — Identity and absorption are dual

**Status: [Proved here].**

For \(\mu_a\),

\[
\mu_a(b,x)=x,
\qquad
\mu_a(a,x)=a.
\]

Hence \(b\) is its identity and \(a\) its absorber.

For \(\mu_b\),

\[
\mu_b(a,x)=x,
\qquad
\mu_b(b,x)=b.
\]

Hence \(a\) is its identity and \(b\) its absorber.

### Proof

There are only two possible values of \(x\).

For \(\mu_a\),

\[
\mu_a(b,a)=a,\qquad \mu_a(b,b)=b,
\]

so \(\mu_a(b,x)=x\), and

\[
\mu_a(a,a)=a,\qquad \mu_a(a,b)=a,
\]

so \(\mu_a(a,x)=a\).

The corresponding equalities for \(\mu_b\) follow directly from its table:

\[
\mu_b(a,a)=a,\qquad \mu_b(a,b)=b,
\]

and

\[
\mu_b(b,a)=b,\qquad \mu_b(b,b)=b.
\]

Therefore the asserted identity and absorbing elements are exactly as stated. \(\square\)

---

# 9. The two operations are exchanged by pole symmetry

## Theorem 9.1 — De Morgan exchange

**Status: [Proved here].**


For all \(x,y\in X\),

\[
\boxed{
\nu_X(\mu_a(x,y))
=
\mu_b(\nu_X(x),\nu_X(y)).
}
\]

Similarly,

\[
\nu_X(\mu_b(x,y))
=
\mu_a(\nu_X(x),\nu_X(y)).
\]

### Proof

Because the operations are commutative, it is enough to check the three unordered input pairs.

For \((a,a)\),

\[
\nu_X(\mu_a(a,a))
=
\nu_X(a)
=
b,
\]

while

\[
\mu_b(\nu_X(a),\nu_X(a))
=
\mu_b(b,b)
=
b.
\]

For \((a,b)\),

\[
\nu_X(\mu_a(a,b))
=
\nu_X(a)
=
b,
\]

while

\[
\mu_b(\nu_X(a),\nu_X(b))
=
\mu_b(b,a)
=
b.
\]

For \((b,b)\),

\[
\nu_X(\mu_a(b,b))
=
\nu_X(b)
=
a,
\]

while

\[
\mu_b(\nu_X(b),\nu_X(b))
=
\mu_b(a,a)
=
a.
\]

Hence

\[
\nu_X\circ\mu_a
=
\mu_b\circ(\nu_X\times\nu_X).
\]

Applying \(\nu_X\) to both sides and using \(\nu_X^2=\operatorname{id}_X\) yields the dual identity for \(\mu_b\). \(\square\)

Thus the two semilattice operations form a dual pair under the unique pole exchange.

---

## Theorem 9.2 — No unbiased single commutative-idempotent composition

**Status: [Proved here].**


There is no operation

\[
\mu\in\mathcal C(X)
\]

that is invariant under pole exchange in the sense

\[
\nu_X(\mu(x,y))
=
\mu(\nu_X(x),\nu_X(y))
\]

for all \(x,y\in X\).

### Proof

Take the mixed pair \(a,b\). By commutativity,

\[
\mu(a,b)=\mu(b,a).
\]

Equivariance would imply

\[
\nu_X(\mu(a,b))
=
\mu(b,a)
=
\mu(a,b).
\]

Thus \(\mu(a,b)\) would be a fixed point of \(\nu_X\), but \(\nu_X\) has no fixed points. Contradiction. \(\square\)

### Interpretation

This theorem is structurally important.

A bare two-pole system does **not** canonically privilege a single meet-like or join-like operation. The symmetry exchanges the two possible semilattice compositions.

Therefore an unoriented first distinction naturally contains:

\[
\boxed{
\{\mu_a,\mu_b\}
}
\]

as an unordered dual pair.

---

# 10. The separator-free dyad

## Definition 10.1 — Separator-Free Dyad

**Status: [Definition].**


For a two-element carrier \(X\), define

\[
\boxed{
\mathfrak D(X)
=
\bigl(
X,\nu_X,\mathcal C(X)
\bigr),
}
\]

where:

- \(\nu_X\) is the unique nonidentity permutation;
- \(\mathcal C(X)=\{\mu_a,\mu_b\}\) is the unordered pair of commutative idempotent binary operations.

No pole is designated as true/false, marked/unmarked, \(0/1\), inside/outside, or positive/negative.

No boundary object occurs.

---

## Proposition 10.2 — Bijection invariance

**Status: [Proved here].**

Let

\[
f:X\to Y
\]

be a bijection between two-element carriers. Then:

\[
f\circ\nu_X=\nu_Y\circ f,
\]

and transporting the operations in \(\mathcal C(X)\) along \(f\) yields exactly \(\mathcal C(Y)\).

### Proof

The conjugate map

\[
f\circ\nu_X\circ f^{-1}:Y\to Y
\]

is a nonidentity permutation of the two-element set \(Y\). By Theorem 7.1, \(Y\) has exactly one nonidentity permutation, namely \(\nu_Y\). Hence

\[
f\circ\nu_X\circ f^{-1}=\nu_Y,
\]

equivalently,

\[
f\circ\nu_X=\nu_Y\circ f.
\]

Now let \(\mu\in\mathcal C(X)\). Transport \(\mu\) along \(f\) by defining

\[
\mu^f(y_1,y_2)
=
f\!\left(
\mu(f^{-1}(y_1),f^{-1}(y_2))
\right).
\]

Bijections preserve equations, so if \(\mu\) is commutative and idempotent then \(\mu^f\) is commutative and idempotent. Thus

\[
\mu^f\in\mathcal C(Y).
\]

Transport along \(f^{-1}\) gives the inverse correspondence, so the map

\[
\mathcal C(X)\to\mathcal C(Y),\qquad \mu\mapsto\mu^f
\]

is a bijection. Since each set has exactly two operations by Theorem 8.1, the transported set is exactly \(\mathcal C(Y)\). \(\square\)

### Consequence

**Status: [Derived interpretation].**

The dyadic structure is invariant under relabeling. What is canonical is not an orientation, but the **unoriented isomorphism type**.

---

# 11. Indication is exactly the orientation step

The bare dyad still does not distinguish truth from falsity or meet from join.

To obtain ordinary Boolean algebra, one additional choice is necessary.

## Definition 11.1 — Indication

**Status: [Definition / additional orientation choice].**


An **indication** on \(X\) is the designation of one element

\[
t\in X
\]

as the positive or \(1\)-pole.

Define

\[
f:=\nu_X(t).
\]

The labels \(t\) and \(f\) may then be written \(1\) and \(0\), respectively.

This is a role assignment, not a boundary.

---

## Theorem 11.2 — Indication uniquely orients the dual operations

**Status: [Proved here].**


Exactly one operation in \(\mathcal C(X)\) has \(t\) as its identity. Call it \(\wedge_t\).

Exactly one operation in \(\mathcal C(X)\) has \(f\) as its identity. Call it \(\vee_t\).

Then:

\[
t\wedge_t x=x,
\qquad
f\wedge_t x=f,
\]

and

\[
f\vee_t x=x,
\qquad
t\vee_t x=t.
\]

### Proof

This follows immediately from Theorem 8.3. \(\square\)

---

# 12. Boolean orientation theorem

## Theorem 12.1 — Unique Boolean orientation

**Status: [Proved here].**


Let \(X\) be a two-element carrier and let \(t\in X\) be indicated.

Set:

\[
1:=t,
\qquad
0:=\nu_X(t),
\]

\[
\neg:=\nu_X,
\]

and let \(\wedge,\vee\) be the operations selected by Theorem 11.2.

Then

\[
\boxed{
\mathfrak B(X,t)
=
(X,\wedge,\vee,\neg,0,1)
}
\]

is a Boolean algebra isomorphic to the standard two-element Boolean algebra \(\mathbf2\).

Moreover, it is the unique Boolean algebra structure on \(X\) with the specified \(0\) and complement \(\nu_X\).

### Proof

Let

\[
f:=\nu_X(t).
\]

By Definition 11.1,

\[
0=f,\qquad 1=t.
\]

By Theorem 11.2, \(\wedge\) is the unique operation in \(\mathcal C(X)\) having \(1\) as identity and \(0\) as absorber. Therefore:

\[
0\wedge0=0,\qquad
0\wedge1=0,\qquad
1\wedge0=0,\qquad
1\wedge1=1.
\]

Likewise, \(\vee\) is the unique operation in \(\mathcal C(X)\) having \(0\) as identity and \(1\) as absorber:

\[
0\vee0=0,\qquad
0\vee1=1,\qquad
1\vee0=1,\qquad
1\vee1=1.
\]

Finally, Theorem 7.1 gives:

\[
\neg0=1,\qquad
\neg1=0.
\]

Define

\[
\phi:X\to\{0,1\}
\]

by the same labels:

\[
\phi(0)=0,\qquad \phi(1)=1.
\]

The three displayed operation tables are exactly those of the standard two-element Boolean algebra. Hence \(\phi\) preserves \(\wedge,\vee,\neg,0,1\) and is bijective. It is therefore a Boolean-algebra isomorphism.

For uniqueness, let

\[
(X,\wedge',\vee',\neg',0,1)
\]

be any Boolean algebra on the same two-element carrier with

\[
\neg'=\nu_X.
\]

In every bounded lattice, \(1\) is the identity for meet and \(0\) is the identity for join. On a two-element set, Theorem 8.1 shows that there is exactly one commutative idempotent operation with identity \(1\), namely \(\wedge\), and exactly one with identity \(0\), namely \(\vee\). Hence

\[
\wedge'=\wedge,\qquad
\vee'=\vee.
\]

The complement and constants were already fixed, so the Boolean structure is unique. \(\square\)

---

## Corollary 12.2 — Opposite indication yields the dual orientation

**Status: [Proved here].**

Indicating \(\nu_X(t)\) instead of \(t\) exchanges:

\[
0\leftrightarrow1,
\qquad
\wedge\leftrightarrow\vee.
\]

The two resulting Boolean algebras are isomorphic.

### Proof

Under the original indication \(t\),

\[
1=t,\qquad 0=\nu_X(t).
\]

Under the opposite indication

\[
t':=\nu_X(t),
\]

the new roles are

\[
1'=t'=\nu_X(t)=0,
\]

and

\[
0'=\nu_X(t')=\nu_X^2(t)=t=1.
\]

Thus the constants are exchanged.

By Theorem 11.2, the operation whose identity is the indicated pole is meet. Since the indicated pole has changed from \(1\) to the old \(0\), the old join operation becomes the new meet; similarly the old meet becomes the new join.

The map

\[
\nu_X:X\to X
\]

is a bijection exchanging the old and new constants and, by Theorem 9.1, exchanging the two operations. Therefore it is an isomorphism from one oriented Boolean algebra to the other. \(\square\)

### Interpretation

**Status: [Interpretive claim].**

The bare dyad is symmetric under pole exchange. A particular Boolean truth orientation appears only after indication.


---

## Theorem 12.3 — Primitive-separator non-necessity for the Boolean base

**Status: [Proved here].**

There exists a presentation of the two-element Boolean algebra whose primitive Boolean signature contains no boundary object, separator predicate, inside/outside relation, or side-of-boundary relation.

Consequently, a primitive separator is not a mathematical prerequisite for the existence of the Boolean base \(\mathbf2\).

### Proof

The construction of Theorem 12.1 produces the algebra

\[
\mathfrak B(X,t)
=
(X,\wedge,\vee,\neg,0,1)
\]

in the ordinary Boolean signature

\[
\mathcal L_{\mathrm{BA}}
=
\{\wedge,\vee,\neg,0,1\}.
\]

No symbol in this signature denotes a boundary, separator, side relation, or inside/outside relation.

By Theorem 12.1,

\[
\mathfrak B(X,t)\cong\mathbf2,
\]

so it satisfies the Boolean-algebra axioms.

Therefore there is an explicit Boolean-base model whose primitive signature is separator-free. Hence the existence of \(\mathbf2\) does not mathematically require a primitive separator symbol or object. \(\square\)

### Limitation

This theorem is a statement about **formal presentation and mathematical dependency**. It does not establish that physical, metaphysical, or cognitive boundaries are unreal.

---

# 13. The revised foundational factorization

The strongest defensible chain is therefore:

\[
\boxed{
\underbrace{\mathsf{NPB}}_{\text{primitive-signature restriction}}
\quad+\quad
\underbrace{\mathsf{MN}}_{\text{minimal nontriviality}}
}
\]

which yields a two-element carrier, followed by structures that are mathematically forced by that carrier:

\[
\boxed{
X
\Longrightarrow
\nu_X
\quad\text{and}\quad
\mathcal C(X)=\{\mu_a,\mu_b\}.
}
\]

This gives the unoriented dyad:

\[
\boxed{
\mathfrak D(X).
}
\]

Only then is indication added:

\[
\boxed{
\mathfrak D(X)+t
\Longrightarrow
\mathfrak B(X,t)\cong\mathbf2.
}
\]

Thus:

\[
\boxed{
\text{No primitive separator}
\;\rightsquigarrow\;
\text{minimal two-pole articulation}
\;\rightsquigarrow\;
\text{canonical unoriented dyad}
\;\rightsquigarrow\;
\text{indication}
\;\rightsquigarrow\;
\mathbf2.
}
\]

The arrows do not represent temporal or metaphysical causation. They represent **successive enrichment of a formal presentation**.

---

# 14. What is genuinely derived, and what is assumed?

This section is essential because several superficially similar claims have very different logical status.

| Item | Status |
|---|---|
| No primitive separator | modeling/foundational constraint |
| Existence of at least two statuses | assumed through nontriviality |
| Exactly two statuses | derived from minimality |
| Unique pole exchange | derived from two-element cardinality |
| Exactly two commutative idempotent binary operations | derived |
| Associativity of those two operations | derived |
| Duality of those operations under pole exchange | derived |
| No symmetry-invariant single C-I composition | derived |
| Designation of one pole | additional indication/orientation |
| Assignment of \(0/1\) roles | derived from indication |
| Meet/join orientation | derived from indication and operation identities |
| Two-element Boolean algebra | proved after indication |
| Primitive separator unnecessary for a presentation of \(\mathbf2\) | proved by explicit separator-free model (Theorem 12.3) |
| General Boolean algebra / propositional logic | standard subsequent theory; not re-proved here |

This table replaces the stronger but vulnerable claim that "No-Boundary derives Boolean logic."

It does not.

The paper instead identifies exactly where each additional structure enters.

---

# 15. Relation to Spencer-Brown

**Status of this section: [Interpretive comparison] supported by References 6–8; no theorem about Spencer-Brown's intended ontology is claimed.**


Spencer-Brown distinguishes **distinction** from **indication**. The present factorization is compatible with that separation while rejecting the need to interpret the first distinction as a primitive ontological boundary.

The comparison may be written:

### Boundary-first reading

\[
\text{mark/boundary}
\to
\text{two sides}
\to
\text{indication}.
\]

### Separator-free reading

\[
\text{minimal inequivalence}
\to
\text{unoriented dyad}
\to
\text{indication}
\to
\text{optional boundary/mark representation}.
\]

The manuscript does not claim that Spencer-Brown himself must be read in the first way. The claim is only that the second reading is formally available.

The unique involution \(\nu_X\) also supplies a boundary-free interpretation of "crossing":

\[
\nu_X^2=\operatorname{id}_X.
\]

It can be understood as pole exchange rather than literal passage across a separator.

---

# 16. Relation to Sheffer and minimal Boolean signatures

**Status of the historical claims: [External historical claim], Reference 4 and related work.**


Sheffer's work creates a major constraint on any novelty claim.

A single binary operation can axiomatize Boolean algebra. Later automated-reasoning work has produced very short single axioms in the Sheffer-stroke signature.

Therefore:

\[
\boxed{
\text{absence of primitive boundary notation is already standard Boolean mathematics.}
}
\]

The present manuscript differs only in explanatory order. It begins before Boolean operations have been oriented and asks:

> What algebraic structure is already canonical on the minimally nontrivial separator-free carrier?

The answer is the unoriented dyad \(\mathfrak D(X)\), not yet NAND, AND, OR, true, or false.

Thus the proposed contribution is not a smaller Boolean signature. It is a **pre-orientation factorization**.

---

# 17. Relation to partition logic

**Status of the mathematical prior-work claims: [Standard / external], Reference 3.**


Ellerman's partition logic is close in spirit because distinction is explicit and binary partitions are the atoms above the indiscrete partition.

However:

1. partition logic begins with a universe \(U\) and partitions of \(U\);
2. the present manuscript begins with a minimal articulated carrier and classifies its canonical internal operations;
3. the binary result itself is not claimed as new;
4. the present focus is the separation of:
   - inequivalence,
   - pole exchange,
   - dual composition,
   - indication,
   - boundary representation.

Partition theory provides important prior mathematical context but does not remove the usefulness of making these dependencies explicit.

---

# 18. Stone representation: a limited consistency check

The following section is intentionally weaker than in earlier versions.

## Lemma 18.1 — Clopen boundary lemma

**Status: [Proved here].**


If \(C\) is clopen in a topological space, then

\[
\partial C=\varnothing.
\]

### Proof

Because \(C\) is closed,

\[
\overline C=C.
\]

Because \(C\) is open,

\[
C^\circ=C.
\]

Hence

\[
\partial C
=
\overline C\setminus C^\circ
=
\varnothing.
\]

\(\square\)

## Theorem 18.2 — Empty-boundary Stone representation

**Status: [Standard theorem + proved consequence].**

Every Boolean algebra admits a Stone representation in which each represented Boolean element is a clopen set and therefore has empty topological boundary.

### Proof

The Stone representation theorem for Boolean algebras is a standard theorem due to Stone (1936) [Reference 9]. It states that every Boolean algebra \(B\) is isomorphic to the Boolean algebra of clopen subsets of its Stone space \(S(B)\).

Let

\[
\eta:B\to\operatorname{Clop}(S(B))
\]

be such an isomorphism. For every \(b\in B\), the set

\[
\eta(b)
\]

is clopen. By Lemma 18.1,

\[
\partial\eta(b)=\varnothing.
\]

Hence every Boolean element has a Stone representative with empty topological boundary. \(\square\)

### Interpretation

**Status: [Interpretive claim].**

This proves only:

\[
\boxed{
\text{Boolean distinction does not universally require a nonempty topological boundary locus.}
}
\]

It does **not** prove:

- that no separator structure exists;
- that boundaries are metaphysically unreal;
- that Stone spaces are "boundaryless" in every sense;
- that NPB follows from Stone duality.

Indeed, complementary clopen sets remain distinct and strongly separated in the topology.

The theorem is therefore an **illustration of representation independence**, not evidence for an ontological thesis.

---

# 19. Adversarial objections

## Objection 19.1 — "The whole theory is trivial because standard logic never required a boundary."

### Response

This objection defeats any claim of new algebraic necessity, and the paper accepts it.

NPB is not presented as a new Boolean theorem. The proposed contribution is the explicit factorization:

\[
\text{minimal inequivalence}
\to
\text{unoriented dyad}
\to
\text{indication}
\to
\mathbf2,
\]

and the use of that factorization to invert a boundary-first foundational interpretation.

If that organization has no philosophical or explanatory value, then the paper's contribution is correspondingly limited.

---

## Objection 19.2 — "Equality already smuggles in distinction."

### Response

Correct.

The paper is not an absolute genesis theory. It assumes an articulated metatheory in which equality and inequality are already meaningful.

The result is:

> no **additional primitive separator** is required.

It is not:

> distinction has been generated from complete pre-distinction.

---

## Objection 19.3 — "Minimality simply assumes bivalence."

### Response

Minimality does most of the cardinality work, but it does not literally assert \(|X|=2\). It asserts that the first nontrivial carrier has no superfluous statuses.

Nevertheless, the philosophical justification of MN is independent and contestable. If MN is rejected, bivalence is not forced.

The paper therefore states only the conditional:

\[
\boxed{
\mathsf{MN}\Rightarrow |X|=2.
}
\]

---

## Objection 19.4 — "The polarity axiom is Boolean structure in disguise."

### Response

Earlier versions were vulnerable to this objection. The revised manuscript eliminates the polarity axiom.

Pole exchange is now Theorem 7.1: the unique nonidentity permutation of a two-element carrier.

---

## Objection 19.5 — "Meet and join are inserted by hand."

### Response

The revised manuscript does not assume a prior order or explicitly posit meet and join.

It first classifies **all** commutative idempotent binary operations on the two-element carrier and proves there are exactly two. They are automatically associative and exchanged by the unique pole symmetry.

Only after indication are they named meet and join according to their identity elements.

The remaining independent assumption is the decision to study commutative-idempotent composition. That choice is explicit.

---

## Objection 19.6 — "Why commutative and idempotent composition?"

### Response

They encode two structural desiderata:

\[
x*y=y*x
\]

(order-insensitivity) and

\[
x*x=x
\]

(repetition-insensitivity).

They are not consequences of NPB or MN.

A different choice of composition laws could produce a different post-dyadic theory. Thus Boolean logic is one branch of the separator-free program, not the only possible branch.

---

## Objection 19.7 — "Indication is arbitrary symmetry breaking."

### Response

Yes, and the paper treats that as a feature rather than hiding it.

The unoriented dyad has no privileged pole. A truth-valued Boolean algebra requires orientation. Indication supplies precisely that orientation.

The opposite indication yields a dual isomorphic structure, so no orientation is privileged by the bare dyad itself.

---

## Objection 19.8 — "Stone duality equivocates between topological and ontological boundary."

### Response

Correct if used as an ontological argument.

For this reason the Stone result has been demoted to a limited representation theorem and carries no metaphysical inference.

---

## Objection 19.9 — "Boundary eliminativism is prior work."

### Response

Yes.

Azzouni and others prevent any novelty claim for the generic thesis that object boundaries are projected or nonfundamental.

The manuscript's novelty claim is restricted to the specific pre-orientation Boolean factorization.

---

## Objection 19.10 — "Sheffer already proves Boolean logic needs no boundary."

### Response

Yes.

Sheffer prevents any novelty claim for boundary-free Boolean axiomatization.

The present manuscript concerns the structure **before Boolean operations are oriented**, not the existence of an economical Boolean primitive.

---

## Objection 19.11 — "The mathematics is elementary."

### Response

Yes.

No new deep finite-algebra theorem is claimed. The paper is foundational/conceptual mathematics.

Its value, if any, lies in exposing a dependency structure that is obscured when a mark, boundary, truth value, unit, or Boolean operation is taken as primitive.

## Objection 19.12 — "Two-element semilattice + swapping involution is already known to be Boolean."

### Response

Correct. Recent universal-algebra work states this explicitly.

The revised manuscript therefore does not claim novelty for the oriented semilattice-with-involution stage. Its candidate contribution is earlier and more specific:

- begin with the bare minimally nontrivial carrier;
- retain **both** commutative-idempotent compositions as an unordered dual pair;
- prove that no single such composition is pole-symmetry invariant;
- identify indication as the precise operation that selects a unit and thereby orients the pair into Boolean meet/join.

If prior work is found with this same pre-unit and pre-orientation factorization, the novelty claim should be reduced again.

---

# 20. Falsification and failure criteria

**Status: [Methodological criteria], not theorems.**


The central foundational proposal should be weakened or abandoned if any of the following occurs.

## F1 — Exact prior factorization is located

A prior source is found that explicitly develops:

\[
\text{no primitive separator}
\to
\text{minimal two-pole carrier}
\to
\text{canonical unoriented dual operations}
\to
\text{indication}
\to
\mathbf2
\]

for the same foundational purpose.

This would substantially reduce the novelty claim.

## F2 — "Separator" cannot be defined non-arbitrarily

If no principled distinction can be drawn between a forbidden primitive separator and ordinary relational/algebraic structure, NPB risks becoming merely verbal.

## F3 — MN lacks defensible motivation

If "first articulation should be cardinal-minimal" has no acceptable methodological or metaphysical justification, the route to bivalence becomes an arbitrary modeling choice.

## F4 — Commutative-idempotent composition lacks relevance

If there is no reason to privilege order-insensitive and repetition-insensitive composition in the target foundational setting, the passage from dyad to Boolean-like dual operations loses explanatory force.

## F5 — The factorization has no explanatory advantage over standard Boolean presentations

If the dyadic stage does not clarify anything that Sheffer, Boolean algebra, partition logic, or Spencer-Brown already clarifies more directly, the paper becomes an unnecessary re-description.

These are genuine risks, not rhetorical caveats.

---

# 21. What survives the adversarial audit

After the preceding attacks, the claims that remain defensible are:

### Claim A — Presentation-level boundary non-necessity

A primitive separator is not required in a formal presentation of inequivalence or the Boolean base.

This is not new by itself.

### Claim B — Minimal articulation yields a dyad

Under explicit minimal nontriviality,

\[
|X|=2.
\]

Standard/elementary.

### Claim C — The bare dyad canonically determines pole exchange

The unique nonidentity permutation is a fixed-point-free involution.

Standard/elementary.

### Claim D — The bare dyad canonically determines an unordered pair of C-I compositions

There are exactly two commutative idempotent binary operations; both are associative and exchanged by pole symmetry.

Elementary but structurally useful.

### Claim E — No single C-I composition preserves full pole symmetry

Choosing one operation rather than the unordered pair already orients the distinction.

This isolates a precise symmetry-breaking point.

### Claim F — Indication uniquely yields \(\mathbf2\)

Once one pole is designated, the Boolean roles and operations are uniquely determined.

### Claim G — A primitive boundary is not required by this Boolean-base presentation

**Status: [Proved here], Theorem 12.3.**

The explicit construction of \(\mathbf2\) uses no primitive separator symbol or object. Therefore a boundary-first presentation is **not mathematically necessary** for the Boolean base.

The stronger metaphysical statement that all boundaries are derivative remains interpretive and is not proved.

---

# 22. Revised novelty statement

**Status: [Literature-based novelty claim], not mathematically provable.**


The manuscript should **not** claim:

- a new Boolean algebra;
- a new boundary-free axiomatization;
- the first proof that distinctions can exist without boundaries;
- the first binary minimality result;
- the first relation between distinction and Boolean logic.

The strongest responsible statement is:

> **The algebraic facts used here are elementary or standard, and the identification of a two-element semilattice with swapping involution as Boolean is also prior work. The proposed contribution is a separator-free, pre-unit and pre-orientation factorization of the Boolean base in which minimal inequivalence first yields a bare dyad, the dyad canonically supplies pole exchange and the unordered pair of all commutative-idempotent compositions, no individual composition preserves full pole symmetry, and indication alone selects the Boolean orientation. In the literature reviewed for this manuscript, this exact factorization was not located as an explicit inversion of boundary-first foundational interpretations.**

This is a claim about **organization and interpretation**, not discovery of new finite algebra.

---

# 23. Research directions that could turn the program into stronger mathematics

**Status: [Open problems].**


The present paper is intentionally modest. More substantial mathematics would require extending the dyadic factorization.

## 23.1 Universal characterization of the dyad

Give \(\mathfrak D(X)\) a universal property rather than defining it by enumeration of operations.

## 23.2 Category of orientations

Study indication as a functor from unoriented dyads to pointed Boolean algebras and characterize the two orientations categorically.

## 23.3 Non-Boolean descendants

Replace commutative-idempotent composition with other explicitly motivated composition laws and classify which logical algebras arise.

## 23.4 Boundary-enriched conservative extensions

Define rigorous boundary-enriched signatures and determine when boundary structure is a conservative, definitional, or genuinely stronger extension of separator-free algebraic structure.

This would turn the philosophical word "boundary" into a model-theoretically testable notion.

## 23.5 Relation to partition logic

Investigate whether the dyad is naturally related to atoms of the partition lattice by a universal construction.

## 23.6 Relation to Spencer-Brown

Determine whether the primary arithmetic can be factored through the separator-free dyad plus indication in a theorem-preserving way, rather than only compared conceptually.

A genuine equivalence or conservative translation would be significantly stronger than the present manuscript.

---

# 24. Conclusion

The strongest form of the original idea—

\[
\text{No Boundary}\Rightarrow\text{Boolean logic}
\]

—is false.

No-Primitive-Boundary does not imply nontriviality, bivalence, negation, or composition.

A more defensible structure emerges when each dependency is exposed.

Minimal nontrivial articulation yields a two-element carrier:

\[
X=\{a,b\}.
\]

That carrier automatically has one nontrivial symmetry:

\[
\nu_X(a)=b,\qquad \nu_X(b)=a.
\]

It also has exactly two commutative idempotent binary operations. Both are associative, and the pole exchange interchanges them. There is no single commutative-idempotent composition that respects the full pole symmetry.

The natural pre-Boolean structure is therefore not an already oriented truth algebra but an **unoriented separator-free dyad**:

\[
\boxed{
\mathfrak D(X)
=
(X,\nu_X,\{\mu_a,\mu_b\}).
}
\]

A single indication chooses one pole. That designation simultaneously fixes:

\[
0/1,
\]

the orientation of the two semilattice operations as

\[
\wedge/\vee,
\]

and the ordinary Boolean complement.

Thus:

\[
\boxed{
\mathfrak D(X)+\text{indication}
\cong
\mathbf2.
}
\]

No primitive boundary object is required anywhere in this factorization.

The correct scientific conclusion is therefore not that boundary has been disproved, nor that Boolean logic has been derived from nothing. It is:

\[
\boxed{
\textbf{The two-element Boolean base admits a separator-free pre-orientation factorization in which boundaryhood is not a primitive mathematical dependency.}
}
\]

That is the claim this manuscript can defend.

---

# References

1. **Azzouni, J.** (2017). *Ontology Without Borders*. Oxford University Press.  
   https://doi.org/10.1093/oso/9780190622558.001.0001

2. **Azzouni, J.** (2017). “The Master Argument Against Ontological Borders.” In *Ontology Without Borders*, pp. 143–170. Oxford University Press.  
   https://doi.org/10.1093/oso/9780190622558.003.0008

3. **Ellerman, D.** (2010). “The Logic of Partitions: Introduction to the Dual of the Logic of Subsets.” *The Review of Symbolic Logic*, 3(2), 287–350.  
   https://doi.org/10.1017/S1755020310000018

4. **Sheffer, H. M.** (1913). “A Set of Five Independent Postulates for Boolean Algebras, with Application to Logical Constants.” *Transactions of the American Mathematical Society*, 14(4), 481–488.  
   https://doi.org/10.2307/1988701

5. **McCune, W., Veroff, R., Fitelson, B., Harris, K., Feist, A., & Wos, L.** (2002). “Short Single Axioms for Boolean Algebra.” *Journal of Automated Reasoning*, 29, 1–16.  
   https://doi.org/10.1023/A:1020542009983

6. **Spencer-Brown, G.** (1969). *Laws of Form*. London: Allen & Unwin.

7. **Meguire, P.** (2003). “Discovering Boundary Algebra: A Simple Notation for Boolean Algebra and the Truth Functors.” *International Journal of General Systems*, 32(1), 25–87.  
   https://doi.org/10.1080/0308107031000075690

8. **Kauffman, L. H.** (1980). “Form Dynamics.” *Journal of Social and Biological Structures*, 3(2), 171–206.  
   https://doi.org/10.1016/0140-1750(80)90008-1

9. **Stone, M. H.** (1936). “The Theory of Representations for Boolean Algebras.” *Transactions of the American Mathematical Society*, 40(1), 37–111.  
   https://doi.org/10.2307/1989664

10. **Bonzio, S., & St. John, G.** (2026). “On the structure and theory of McCarthy algebras.” *Semigroup Forum*, 113, 1–44.  
    https://doi.org/10.1007/s00233-026-10641-7

11. **Peirce, C. S.** Existential graphs, especially the alpha system for propositional logic; see standard editions of *Collected Papers*, Vol. 4, and modern expositions.

---

# Appendix 0. Claim-provenance ledger

This ledger is intended to prevent hidden premises and unsupported claims.

| ID | Claim | Status | Support |
|---|---|---|---|
| P0 | Boundary-free Boolean signatures existed before this work | External historical claim | Sheffer (1913), Ref. 4; McCune et al. (2002), Ref. 5 |
| P1 | Boundary/projectivist metaphysics has prior art | External historical claim | Azzouni (2017), Refs. 1–2 |
| P2 | Partition logic has an indiscrete partition and binary atoms above it | Standard/external | Ellerman (2010), Ref. 3 |
| P3 | Stone representation represents Boolean algebras by clopen sets | Standard theorem | Stone (1936), Ref. 9 |
| P4 | Two-element i-uband with swapping involution is Boolean | External prior mathematics | Bonzio & St. John (2026), Ref. 10 |
| D1 | Separator-free primitive signature | Definition | Def. 4.1 |
| A1 | NPB | Assumption / presentation constraint | Principle NPB |
| T1 | NPB does not imply nontriviality | Proved here | Prop. 5.1 |
| T2 | NPB does not imply bivalence | Proved here | Prop. 5.2 |
| T3 | NPB does not determine Boolean operations | Proved here | Prop. 5.3 |
| D2 | Nontrivial carrier | Definition | Def. 6.1 |
| A2 | Minimal Nontriviality | Assumption | Principle MN |
| T4 | Minimal nontrivial carrier has two elements | Proved here | Thm. 6.2 |
| T5 | Two-element carrier has unique nonidentity permutation | Proved here | Thm. 7.1 |
| A3 | Restrict composition study to commutative-idempotent operations | Assumption / scope restriction | §8 |
| T6 | Exactly two C-I operations exist | Proved here | Thm. 8.1 |
| T7 | Both C-I operations are associative | Proved here | Thm. 8.2 |
| T8 | Identity/absorber roles are dual | Proved here | Thm. 8.3 |
| T9 | Pole exchange interchanges the two C-I operations | Proved here | Thm. 9.1 |
| T10 | No single C-I operation is fully pole-equivariant | Proved here | Thm. 9.2 |
| D3 | Separator-Free Dyad | Definition | Def. 10.1 |
| T11 | Dyad is invariant under relabeling | Proved here | Prop. 10.2 |
| D4 | Indication | Definition / extra choice | Def. 11.1 |
| T12 | Indication orients the two operations uniquely | Proved here | Thm. 11.2 |
| T13 | Indication produces the unique Boolean orientation | Proved here | Thm. 12.1 |
| T14 | Opposite indication gives the dual isomorphic orientation | Proved here | Cor. 12.2 |
| T15 | Primitive separator is unnecessary for a presentation of \\(\\mathbf2\\) | Proved here | Thm. 12.3 |
| T16 | Clopen sets have empty topological boundary | Proved here | Lemma 18.1 |
| T17 | Boolean elements have empty-boundary Stone representatives | Standard theorem + local consequence | Stone theorem + Thm. 18.2 |
| I1 | Indication is the philosophically relevant symmetry-breaking step | Interpretive claim | Motivated by T9–T14; not a theorem |
| I2 | Boundary may be viewed as downstream of distinction | Interpretive claim | Compatible with T15; not established ontologically |
| N1 | Exact separator-free pre-unit/pre-orientation factorization was not found in reviewed literature | Literature-based novelty claim | Defeasible; not a mathematical theorem |

**Dependency check.** The principal mathematical conclusion T15 depends only on:

\[
\text{A1}+\text{A2}+\text{A3}+\text{D4}
\]

together with the ordinary set-theoretic metalanguage and the locally proved chain

\[
T4\to T5,T6\to T7,T8,T9,T10\to T11\to T12\to T13\to T15.
\]

No historical, interpretive, or novelty claim is used in that proof chain.

---

# Appendix A. Exhaustive two-element composition classification

Let

\[
X=\{a,b\}.
\]

Idempotence fixes:

\[
a*a=a,\qquad b*b=b.
\]

Commutativity reduces the remaining two mixed table entries to a single value:

\[
a*b=b*a.
\]

Since the value lies in \(X\), there are exactly two cases.

### Case A

\[
a*b=a.
\]

Then:

\[
\begin{array}{c|cc}
* & a & b\\
\hline
a&a&a\\
b&a&b
\end{array}
\]

and \(b\) is identity while \(a\) is absorbing.

### Case B

\[
a*b=b.
\]

Then:

\[
\begin{array}{c|cc}
* & a & b\\
\hline
a&a&b\\
b&b&b
\end{array}
\]

and \(a\) is identity while \(b\) is absorbing.

These are the only commutative idempotent binary operations.

---

# Appendix B. Dependency diagram

```text
No Primitive Boundary (presentation constraint)
                    +
Minimal Nontriviality (independent principle)
                    |
                    v
             two-element carrier
                 {a,b}
                    |
          +---------+---------+
          |                   |
          v                   v
unique nonidentity      exactly two commutative-
permutation ν           idempotent binary operations
          |                   |
          +---------+---------+
                    |
                    v
         UNORIENTED SEPARATOR-FREE DYAD
            (no true/false designation)
                    |
                    | indication: choose one pole
                    v
             Boolean orientation
                    |
                    v
       two-element Boolean algebra 2
                    |
                    | standard theory
                    v
       Boolean algebras / classical logic
```

---

# Appendix C. Referee-proof summary

The paper survives only under the following narrow reading:

1. **NPB is a signature restriction, not a generative axiom.**
2. **Minimality, not NPB, yields two-valuedness.**
3. **Pole exchange is derived, not postulated.**
4. **The two candidate semilattice operations are exhaustively classified.**
5. **Indication, not boundary, supplies Boolean orientation.**
6. **No absolute genesis of distinction is claimed.**
7. **No novelty is claimed for boundary-free Boolean syntax, binary minimality, Stone duality, or the two-element algebra.**
8. **Stone theory is only a limited representation check.**
9. **The possible novelty is the specific separator-free dyadic factorization and its foundational interpretation.**
10. **A prior source with the same factorization would defeat the novelty claim without affecting the mathematics.**
11. **Every mathematical conclusion used in the main dependency chain is either proved locally or explicitly identified as an independent assumption.**
12. **Every externally established theorem used in the paper is identified by citation and is not rebranded as a new result.**
