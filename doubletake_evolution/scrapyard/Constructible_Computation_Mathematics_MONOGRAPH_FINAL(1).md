![Title page](constructible_computation_mathematics_cover.png)

# Constructible Computation Mathematics
## Foundations, Product Laws, and Optimal Constructors

**Damir Olejar**  
**August 18, 2026**  
**Public monograph draft:** Version 1.0

**Keywords:** finite join-semilattice; polarized set basis; set-wise union; extremal set theory; combinatorial optimization; product laws; graph transversals; constructive combinatorics.

**MSC2020:** Primary **05D05** (Extremal set theory); Secondary **06A12** (Semilattices), **90C27** (Combinatorial optimization), **05C70** (edge covering and packing structures in graph theory).

**Copyright © 2026 Damir Olejar. All rights reserved.**

---

## Abstract

This monograph develops a finite construction theory in which a target family is generated from several **position-sensitive resource libraries**, with cost measured by the total number of stored resources. For a finite join-semilattice \((L,\vee,0)\), a target \(T\subseteq L\), and an integer \(r\ge2\), the central quantity is

\[
\beta_r(T)=\min_{(F_1,\ldots,F_r)}\sum_{i=1}^r |F_i|,
\]

where \(0\in F_i\) for every \(i\) and every target element is a join of one resource from each family.

The principal exact result concerns the rank-two Boolean target \(B(n,\le2)\) composed with a fixed binary control \(C_2\). For every \(n\ge3\),

\[
\boxed{\beta_2(B(n,\le2)\times C_2)=3n-1.}
\]

Equivalently, for a pointed down-set \(Q_n\), one has \(\beta_2(Q_n)=3n-1\). The proof combines a pair normal form, singleton-ownership decomposition, an exact resource-cost identity, a complement-graph extremal lemma, and a matching explicit constructor. The normalized product interaction is therefore

\[
\boxed{\iota_2(B(n,\le2),C_2)=n-2.}
\]

The exact theorem yields constructive consequences: an \(O(n)\) optimal constructor, lower-bound certificates for arbitrary finite down-sets through pointed cliques, exact optimality cells, graph-parametrized two-cover formulas, and a finite witness formulation for general modular construction problems. A countable extension is also given under finite-attained-support assumptions.

The surrounding mathematical operations have close relationships to established work on Set Basis, set-wise union, Boolean rank, biclique covers, monotone optimization, and graph transversal problems. The novelty claim is deliberately narrow: the theorem-level literature comparison summarized in Chapter 11 did not locate an earlier equivalent statement or routine stronger specialization of the exact \(3n-1\) law. No externally certified historical-priority claim is made here.

---

## Main results at a glance

### Central optimization quantity

\[
\boxed{
\beta_r(T)=\min_{\mathbf F}\sum_{i=1}^{r}|F_i|.
}
\]

### Product lower bound

\[
\boxed{
\beta_r(T\times U)\ge\beta_r(T)+\beta_r(U)-r.
}
\]

### Flagship exact law

\[
\boxed{
\beta_2(B(n,\le2)\times C_2)=3n-1,
\qquad n\ge3.
}
\]

### Exact normalized interaction

\[
\boxed{
\iota_2(B(n,\le2),C_2)=n-2.
}
\]

### Graph-parametrized two-cover law

For the pointed graph family \(Q(G)\),

\[
\boxed{
\delta_2(Q(G))=n+1+\tau(G)=2n+1-\alpha(G).
}
\]

---

## Public claim register

| Stable ID | Public number | Claim | Class | Proof/evidence location | External dependency |
|---|---|---|---|---|---|
| CCM-STRUCT-001 | Theorem 3.1 | Zero-axis product lower bound | Supporting theorem | Chapter 3 | none |
| CCM-BOOL-001 | Theorem 4.1 | \(\beta_2(B(n,\le2))=2n\) for \(n\ge2\) | Prerequisite exact theorem | Chapter 4 | none; public proof supplied |
| CCM-PRODUCT-001 | Theorem 5.1 / Theorem A | \(\beta_2(Q_n)=3n-1\) for \(n\ge3\) | Main theorem | Chapter 5 | none |
| CCM-PRODUCT-002 | Corollary 6.1 | \(\iota_2(B(n,\le2),C_2)=n-2\) | Corollary | Chapter 6 | CCM-PRODUCT-001 and CCM-BOOL-001 |
| CCM-TRANSFER-001 | Corollary 7.2 | Pointed-clique lower-bound certificate | Derived corollary | Chapter 7 | CCM-PRODUCT-001 + monotonicity |
| CCM-GRAPH-001 | Theorem 8.1 | \(\delta_2(Q(G))=n+1+\tau(G)=2n+1-\alpha(G)\) | Derived exact result | Chapter 8 | standard vertex-cover identity |
| CCM-WITNESS-001 | Proposition 9.1 | Exact finite witness representation | Structural utility result | Chapter 9 | none |
| CCM-WITNESS-002 | Theorem 9.2 | Eventual exactness under finite attained support | Structural theorem | Chapter 9 | none |

---

## Reader prerequisites

The mathematical core assumes familiarity with elementary finite set systems, finite semilattices or partially ordered structures, basic graph theory, and elementary combinatorial optimization. The core theory does not require prior knowledge of cryptography or software engineering.

---

## How to read this monograph

**15-minute orientation.** Read the abstract, Main Results at a Glance, and Sections 1.1–1.3. This gives the native optimization problem and the exact \(3n-1\) law.

**60-minute practical entry.** Read Chapter 2 through the Quick Start, then Sections 5.1 and 5.12–5.14, followed by Section 7.3. This is enough to construct an optimal \(Q_n\) basis and use the pointed-clique lower-bound certificate.

**Full mathematical verification.** Read Chapters 2–8 in order, using Appendix A for the proof-audit map and Appendix D for prior-art positioning.

---

## Theorem dependency map

```text
polarized bases and beta_r
        |
        +--> monotonicity / restriction
        |
        +--> zero-axis product lower bound

pair normal form
        |
singleton ownership
        |
exact cost identity
        |
complement graph constraints
        |
pointed extremal lemma
        |
 beta_2(Q_n) >= 3n-1
        |
        +-----------------------------+
                                      |
explicit constructor ----------------+--> beta_2(Q_n) = 3n-1
                                             |
                                             +--> interaction n-2
                                             +--> pointed-clique certificates
                                             +--> optimality cells
```

---

# Chapter 1 — Introduction and Main Results

## 1.1 The construction problem

Many finite design problems can be phrased in terms of reusable resources. A system stores several libraries of reusable objects, and each required target must be produced by selecting one object from each library and combining those objects. The mathematical question is not merely whether construction is possible. It is how small the position-sensitive resource libraries can be while still generating every required target.

The present theory studies this question first in finite join-semilattices and then in Boolean set systems, where composition is union. The central distinction is **polarization**: the resource positions are separate. A resource stored in one position is not automatically available in another, and cost is charged separately by position.

This produces optimization behavior that differs from a single reusable basis or a position-free catalog. In particular, composition with even a fixed two-state control can force a growing resource surcharge.

## 1.2 Principal exact theorem

The central family is

\[
T_n=B(n,\le2)=\{S\subseteq[n]:|S|\le2\},
\]

combined with the two-element Boolean chain \(C_2\). The main theorem is

\[
\boxed{
\beta_2(T_n\times C_2)=3n-1,
\qquad n\ge3.
}
\]

The proof is exact: it contains both a lower bound for every feasible pair of libraries and an explicit matching constructor.

## 1.3 Why the product law is structurally interesting

The separate factors satisfy

\[
\beta_2(T_n)=2n,
\qquad
\beta_2(C_2)=3.
\]

A generic axis argument gives only

\[
\beta_2(T_n\times C_2)\ge2n+1.
\]

The exact value is instead \(3n-1\). Thus the normalized interaction

\[
\iota_2(T,U)
=
\beta_2(T\times U)-\beta_2(T)-\beta_2(U)+2
\]

satisfies

\[
\iota_2(T_n,C_2)=n-2.
\]

The second factor remains fixed while the interaction grows linearly.

## 1.4 Scope of the theory

The exact theorem is proved for a specific infinite family. Its usefulness extends farther through monotonicity, homomorphic transfer, pointed-clique certificates, optimality cells, graph-parametrized constructions, and finite witness systems. These extensions do not imply that every software, algorithmic, or cryptographic problem has the same union-semilattice structure. Whenever an application is discussed, the additional modeling assumptions are stated explicitly.

## 1.5 Relation to established mathematics

The ambient neighborhood includes Set Basis and Boolean Basis [2–5], the set-wise union operation on two families [1], Boolean rank and its Kronecker-product behavior [6,7], biclique-cover formulations, semilattice generation, monotone satisfying-assignment formulations, graph transversal problems, and subset-cover constructions [8]. This monograph does not claim those established objects or operations as new.

The narrow theorem-level claim inherited from the master is that an adversarial literature comparison did not locate an earlier equivalent theorem, a routine stronger specialization, or a routine translation producing the exact pointed-family value \(3n-1\). That claim remains revocable if such prior art is later found, and this monograph does not claim externally certified historical priority.

# Chapter 2 — Definitions, Conventions, and Quick Start

## 2.1 Finite join-semilattices and targets

Let

\[
(L,\vee,0)
\]

be a finite join-semilattice with bottom \(0\), and let

\[
T\subseteq L,
\qquad 0\in T.
\]

The elements of \(T\) are the targets that must be constructible.

## 2.2 Polarized resource libraries

For an integer \(r\ge2\), a **polarized \(r\)-basis** of \(T\) is an ordered tuple

\[
\mathbf F=(F_1,\ldots,F_r)
\]

of finite subsets of \(L\) such that

\[
0\in F_i
\]

for every \(i\), and every \(t\in T\) has a representation

\[
t=f_1\vee\cdots\vee f_r,
\qquad f_i\in F_i.
\]

The resource cost of \(\mathbf F\) is

\[
\sum_{i=1}^r |F_i|.
\]

Define

\[
\boxed{
\beta_r(T)
=
\min_{\mathbf F}
\sum_{i=1}^r |F_i|.
}
\]

## 2.3 Conventions

1. Resource libraries are ordinary finite sets, not multisets.
2. Bottom belongs to every polarized library.
3. A constructor may generate elements outside the target; only target coverage is required unless an exact-generation variant is explicitly introduced.
4. A representation chooses one resource from every polarized position.
5. Cost is total library cardinality unless weights are explicitly introduced.
6. Isomorphic relabelings do not change \(\beta_r\).
7. Direct products use coordinatewise join.
8. In Boolean examples, bottom is the empty set and join is set union.

## 2.4 Boolean targets

For \(n\ge1\) and \(k\ge0\), write

\[
B(n,\le k)=\{S\subseteq[n]:|S|\le k\}.
\]

The main theorem uses \(B(n,\le2)\).

## 2.5 Direct products and normalized interaction

For targets \(T\subseteq L\) and \(U\subseteq M\), their product lies in \(L\times M\) with

\[
(x,u)\vee(y,v)=(x\vee y,u\vee v).
\]

Define the normalized product interaction

\[
\boxed{
\iota_r(T,U)
=
\beta_r(T\times U)-\beta_r(T)-\beta_r(U)+r.
}
\]

This is a normalization of the product additivity defect; the substantive results concern its exact value on structured families.

## 2.6 Quick start: the pointed target \(Q_3\)

Let the ordinary vertices be \(\{1,2,3\}\) and introduce a distinguished point \(z\). The pointed target \(Q_3\) contains every subset of \(\{z,1,2,3\}\) of size at most two, together with

\[
\{z,1,2\},\quad
\{z,1,3\},\quad
\{z,2,3\}.
\]

Choose

\[
x=1,
\qquad y_1=2,
\qquad y_2=3.
\]

Then an optimal pair of libraries is

\[
\mathcal X
=
\{\varnothing,\{z\},\{1\},\{z,1\}\},
\]

\[
\mathcal Y
=
\{\varnothing,\{2\},\{3\},\{2,3\}\}.
\]

Each family has size four, so the total cost is eight. The three pointed triples are generated by

\[
\{z,1,2\}=\{z,1\}\cup\{2\},
\]

\[
\{z,1,3\}=\{z,1\}\cup\{3\},
\]

\[
\{z,2,3\}=\{z\}\cup\{2,3\}.
\]

All singletons and pairs are also generated. The main theorem later proves that no cost below eight is possible:

\[
\boxed{\beta_2(Q_3)=8.}
\]

## 2.7 Immediate lower-bound recipe

For a finite down-set \(T\subseteq2^{[d]}\) and a distinguished coordinate \(z\), build a graph \(G_z(T)\) on \([d]\setminus\{z\}\), placing an edge \(uv\) exactly when

\[
\{z,u,v\}\in T.
\]

If \(G_z(T)\) contains a clique of size \(k\ge3\), then \(T\) contains a pointed copy of \(Q_k\), and Chapter 7 gives

\[
\boxed{\beta_2(T)\ge3k-1.}
\]

## 2.8 Notation table

| Symbol | Meaning |
|---|---|
| \(L\) | finite join-semilattice |
| \(0\) | bottom |
| \(T,U\) | target families |
| \(F_i\) | polarized resource library |
| \(\beta_r(T)\) | minimum total polarized resource cost |
| \(B(n,\le k)\) | subsets of \([n]\) of size at most \(k\) |
| \(C_2\) | two-element Boolean chain |
| \(Q_n\) | pointed rank-two target |
| \(\iota_r(T,U)\) | normalized product interaction |
| \(G_z(T)\) | pointed triple graph |
| \(\operatorname{pcd}(T)\) | pointed-clique dimension |
| \(Q(G)\) | graph-parametrized pointed target |
| \(\delta_2\) | unrestricted at-most-two-cover catalog number |
| \(\tau(G)\) | vertex-cover number |
| \(\alpha(G)\) | independence number |

# Chapter 3 — Basic Structural Theory

## 3.1 Monotonicity

If \(S\subseteq T\) are targets in the same join-semilattice, every polarized basis of \(T\) is also a basis of \(S\). Hence

\[
\boxed{\beta_r(S)\le\beta_r(T).}
\]

This elementary fact becomes a useful transfer mechanism once an exact hard subtarget is known.

## 3.2 Zero-axis product lower bound

### Theorem 3.1 — Zero-axis product lower bound

**Stable ID:** `CCM-STRUCT-001`

For finite targets \(T,U\) and every \(r\ge2\),

\[
\boxed{
\beta_r(T\times U)
\ge
\beta_r(T)+\beta_r(U)-r.
}
\]

#### Proof

Take any polarized product basis:

\[
(H_1,\ldots,H_r).
\]

For each position \(i\), define the two zero-axis fibers

\[
A_i=\{x\in L:(x,0_M)\in H_i\},
\]

and

\[
B_i=\{u\in M:(0_L,u)\in H_i\}.
\]

For each \(i\), both axis fibers contain bottom:

\[
0_L\in A_i,
\qquad
0_M\in B_i.
\]

Every target on the \(T\)-axis:

\[
(t,0_M)
\]

must be generated without introducing a nonbottom \(M\)-coordinate.

Therefore:

\[
(A_1,\ldots,A_r)
\]

is a polarized \(r\)-basis of \(T\).

Likewise:

\[
(B_1,\ldots,B_r)
\]

is a polarized \(r\)-basis of \(U\).

For each \(i\),

\[
|H_i|
\ge
|A_i|+|B_i|-1,
\]

because the two axis fibers intersect at least in the product bottom:

\[
(0_L,0_M).
\]

Summing:

\[
\sum_i|H_i|
\ge
\sum_i|A_i|
+
\sum_i|B_i|
-r.
\]

By optimality of \(\beta_r\),

\[
\sum_i|A_i|
\ge
\beta_r(T),
\]

and:

\[
\sum_i|B_i|
\ge
\beta_r(U).
\]

Hence:

\[
\boxed{
\beta_r(T\times U)
\ge
\beta_r(T)+\beta_r(U)-r.
}
\]

\[
\square
\]

---

## 3.3 Consequence for normalized interaction

By Theorem 3.1,

\[
\boxed{\iota_r(T,U)\ge0.}
\]

The normalization itself is not a novelty claim; it is a convenient way to measure the excess product cost above the zero-axis baseline.


# Chapter 4 — Rank-Two Boolean and Pointed Targets

## 4.1 The exact Boolean rank-two target value

Let

\[
T_n=B(n,\le2).
\]

We first establish the exact prerequisite value

\[
\boxed{\beta_2(T_n)=2n,\qquad n\ge2.}
\]

A direct proof is included so that the flagship theorem has no unpublished mathematical dependency.

### Theorem 4.1 — Exact rank-two Boolean target law

**Stable ID:** `CCM-BOOL-001`

For every integer \(n\ge2\),

\[
\boxed{\beta_2(B(n,\le2))=2n.}
\]

### Proof

Let \((\mathcal F,\mathcal G)\) be any polarized two-basis of \(B(n,\le2)\). For each vertex \(v\in[n]\), the singleton target \(\{v\}\) must be the union of one member of \(\mathcal F\) and one member of \(\mathcal G\). Both chosen sets are subsets of \(\{v\}\), so at least one of the two libraries must contain the singleton \(\{v\}\).

Partition the vertices into

\[
A=\{v:\{v\}\in\mathcal F\setminus\mathcal G\},
\]

\[
B=\{v:\{v\}\in\mathcal G\setminus\mathcal F\},
\]

and

\[
H=\{v:\{v\}\in\mathcal F\cap\mathcal G\}.
\]

Write

\[
a=|A|,\qquad b=|B|,\qquad h=|H|,
\qquad a+b+h=n.
\]

Both libraries contain \(\varnothing\), contributing two memberships. Singleton memberships contribute \(n+h\).

If \(u,v\in A\), neither singleton occurs in \(\mathcal G\). Therefore the pair target \(\{u,v\}\) cannot be generated by opposite-library singletons; at least one library must contain the pair \(\{u,v\}\) explicitly. Thus at least \(\binom a2\) pair memberships are required. Similarly, vertices in \(B\) force at least \(\binom b2\) explicit pair memberships. Consequently

\[
|\mathcal F|+|\mathcal G|
\ge
2+n+h+\binom a2+\binom b2.
\]

For every integer \(m\ge1\),

\[
\binom m2\ge m-1.
\]

Applying this to the nonzero classes among \(A\) and \(B\) gives

\[
\binom a2+\binom b2\ge a+b-2.
\]

Hence

\[
|\mathcal F|+|\mathcal G|
\ge
2+n+h+a+b-2
=
2n.
\]

For the matching upper bound, choose two distinct vertices \(x,y\in[n]\) and let

\[
H=[n]\setminus\{x,y\}.
\]

Take

\[
\mathcal F
=
\{\varnothing,\{x\}\}\cup\{\{h\}:h\in H\},
\]

\[
\mathcal G
=
\{\varnothing,\{y\}\}\cup\{\{h\}:h\in H\}.
\]

Each library has size \(n\). Cross pairs are generated by opposite-library singletons; pairs involving a duplicated vertex in \(H\) are generated in the appropriate orientation; and pairs internal to \(H\) are generated by two duplicated singletons. Therefore every target of size at most two is generated and

\[
\beta_2(T_n)\le2n.
\]

Combining the bounds proves the theorem.

\[
\square
\]

## 4.2 The binary control factor

Let

\[
C_2=\{0,1\}
\]

with Boolean OR. Bottom must appear in both libraries and the nonbottom element must appear in at least one. Therefore

\[
\boxed{\beta_2(C_2)=3.}
\]

## 4.3 Pointed representation of the product

Introduce a distinguished point

\[
z\notin[n].
\]

Identify

\[
(S,0)\longleftrightarrow S,
\qquad
(S,1)\longleftrightarrow S\cup\{z\}.
\]

Under this identification,

\[
B(n,\le2)\times C_2
\]

is isomorphic to

\[
\boxed{
Q_n
=
B(n+1,\le2)
\cup
\{\{z,u,v\}:u,v\in[n],u\ne v\}.
}
\]

Indeed, the control-zero layer gives every ordinary subset of size at most two, while the control-one layer gives the same subsets with \(z\) adjoined. For ordinary singletons and pairs this supplies all pointed sets of size two and three, respectively. Thus \(Q_n\) contains every subset of \([n]\cup\{z\}\) of size at most two and exactly the size-three subsets containing \(z\).

# Chapter 5 — Exact Pointed Rank-Two Product Theorem

## 5.1 Main theorem

### Theorem 5.1 (Theorem A) — Exact pointed rank-two product law

**Stable ID:** `CCM-PRODUCT-001`

For every integer

\[
n\ge3,
\]

\[
\boxed{
\beta_2(Q_n)=3n-1.
}
\]

Equivalently,

\[
\boxed{
\beta_2(B(n,\le2)\times C_2)=3n-1.
}
\]

The proof has two parts: a universal lower bound and an explicit matching constructor.

## 5.2 Pair normal form

Let:

\[
(\mathcal X,\mathcal Y)
\]

be any feasible polarized two-basis of \(Q_n\).

Since \(Q_n\) is downward closed, a generator outside \(Q_n\) can be removed.

The only possible size-three generators are pointed triples:

\[
R=\{z,u,v\}.
\]

Assume:

\[
R\in\mathcal X.
\]

Every singleton target:

\[
\{z\},\{u\},\{v\}
\]

must appear in at least one resource family.

#### Case 1 — one singleton is present in the opposite family

Suppose, without loss of generality:

\[
\{v\}\in\mathcal Y.
\]

Replace:

\[
R
\]

in \(\mathcal X\) by:

\[
R\setminus\{v\}
=
\{z,u\}.
\]

The pointed triple remains generable:

\[
R
=
\{z,u\}
\cup
\{v\}.
\]

No target requiring the old triple is lost, because the replacement is smaller
and the only size-three target of \(Q_n\) relevant to the former use is the
pointed triple itself.

The cost does not increase.

#### Case 2 — none of its singleton vertices appears in the opposite family

Suppose none of:

\[
\{z\},\{u\},\{v\}
\]

lies in \(\mathcal Y\).

Then all three singleton targets must lie in \(\mathcal X\).

Delete:

\[
R
\]

from \(\mathcal X\), and insert, for example:

\[
\{u,v\}
\]

into \(\mathcal Y\).

Then:

\[
R
=
\{z\}
\cup
\{u,v\}.
\]

Again the cost does not increase.

Applying these replacements repeatedly in both resource families gives:

#### Lemma 5.1 — Pair normal form

Every feasible polarized two-basis of \(Q_n\) can be transformed, without
increasing cost, so that every generator has size at most two.

\[
\square
\]

---

## 5.3 Singleton ownership

Work henceforth in pair normal form.

Define:

\[
S_X
=
\{
v:
\{v\}\in\mathcal X
\},
\]

and:

\[
S_Y
=
\{
v:
\{v\}\in\mathcal Y
\}.
\]

Every singleton target must be generated, hence:

\[
S_X\cup S_Y
=
[n]\cup\{z\}.
\]

Partition the vertices into:

\[
A=S_X\setminus S_Y,
\]

\[
B=S_Y\setminus S_X,
\]

and:

\[
H=S_X\cap S_Y.
\]

Let:

\[
h=|H|.
\]

Thus:

- \(A\) consists of vertices whose singleton appears only in \(\mathcal X\);
- \(B\) consists of vertices whose singleton appears only in \(\mathcal Y\);
- \(H\) consists of duplicated singleton vertices.

---

## 5.4 Edge layers and exact cost identity

Define:

\[
E_X
=
\left\{
e\in\binom{[n]\cup\{z\}}2:
e\in\mathcal X
\right\},
\]

and:

\[
E_Y
=
\left\{
e\in\binom{[n]\cup\{z\}}2:
e\in\mathcal Y
\right\}.
\]

Let:

\[
G=E_X\cup E_Y,
\]

and let:

\[
d=|E_X\cap E_Y|
\]

be the duplicate-edge count.

Both resource families contain bottom, contributing:

\[
2.
\]

The number of singleton memberships is:

\[
|S_X|+|S_Y|
=
n+1+h.
\]

The number of edge memberships is:

\[
|E_X|+|E_Y|
=
|G|+d.
\]

Therefore:

\[
\begin{aligned}
|\mathcal X|+|\mathcal Y|
&=
2
+
(n+1+h)
+
(|G|+d)
\\
&=
\boxed{
n+3+h+|G|+d.
}
\end{aligned}
\]

This identity converts the polarized basis lower bound into an extremal graph
problem.

---

## 5.5 Complement graph

Let:

\[
K=\overline G
\]

inside the complete graph on:

\[
[n]\cup\{z\}.
\]

Thus:

\[
uv\in E(K)
\]

means that the pair:

\[
\{u,v\}
\]

is absent as an explicit edge generator from both resource families.

Since:

\[
|G|
=
\binom{n+1}{2}
-
|E(K)|,
\]

an upper bound on \(|E(K)|-h\) will yield a lower bound on the basis cost.

---

## 5.6 Pair constraints

Suppose:

\[
u,v\in A.
\]

Neither singleton:

\[
\{u\},
\{v\}
\]

belongs to \(\mathcal Y\).

If also:

\[
uv\in E(K),
\]

then the pair target:

\[
\{u,v\}
\]

has:

- no explicit edge generator in either family; and
- no representation by opposite-family singletons.

This is impossible.

Hence:

\[
\boxed{
K[A]
\text{ is edgeless}.
}
\]

By symmetry:

\[
\boxed{
K[B]
\text{ is edgeless}.
}
\]

So both \(A\) and \(B\) are independent sets in \(K\).

---

## 5.7 Pointed triple constraint

Take ordinary vertices:

\[
u,v\in[n].
\]

The pointed triple:

\[
\{z,u,v\}
\]

must be the union of two generators, each of size at most two.

Therefore at least one of its three pairs must be explicitly present:

\[
zu\in G,
\]

or:

\[
zv\in G,
\]

or:

\[
uv\in G.
\]

Equivalently, the complement graph \(K\) contains no triangle through \(z\):

\[
zuv.
\]

Therefore:

\[
\boxed{
N_K(z)
\text{ is an independent set in }K.
}
\]

This is the distinguished-point condition that drives the exact lower bound.

---

## 5.8 Pointed complement extremal lemma

### Lemma 5.2 — Pointed complement extremal lemma

Let \(K\) be a graph on:

\[
[n]\cup\{z\},
\qquad
n\ge3.
\]

Suppose:

\[
[n]\cup\{z\}
=
A\sqcup B\sqcup H
\]

and:

1. \(A\) is independent in \(K\);
2. \(B\) is independent in \(K\);
3. \(N_K(z)\) is independent in \(K\).

Then:

\[
\boxed{
|E(K)|-|H|
\le
\binom{n+1}{2}
-
2n
+
4.
}
\]

The proof separates the location of \(z\).

---

## 5.9 Proof of Lemma 5.2 when \(z\in A\)

The case:

\[
z\in B
\]

is symmetric.

Write:

\[
a=|A|-1,
\qquad
b=|B|,
\qquad
h=|H|.
\]

Then:

\[
a+b+h=n.
\]

Let:

\[
A'=A\setminus\{z\}.
\]

Because \(A\) and \(B\) are independent, possible edges of \(K-z\) occur only
in:

\[
A'B,
\quad
A'H,
\quad
BH,
\quad
\binom H2.
\]

The complete allowed edge count is:

\[
\boxed{
E_0
=
ab+ah+bh+\binom h2.
}
\]

Because \(z\in A\), the vertex \(z\) has no neighbor in \(A'\).

Let:

\[
R=N_K(z)
\subseteq B\cup H.
\]

Write:

\[
r_B=|R\cap B|,
\qquad
r_H=|R\cap H|.
\]

Since \(R\) is independent, among the complete allowed edges of \(K-z\), at
least:

\[
r_Br_H+\binom{r_H}{2}
\]

must be removed.

Adding the:

\[
r_B+r_H
\]

edges incident with \(z\), we obtain:

\[
|E(K)|
\le
E_0
+
r_B+r_H
-
r_Br_H
-
\binom{r_H}{2}.
\]

The gain term satisfies:

\[
r_B+r_H-r_Br_H-\binom{r_H}{2}
\le
\max(b,\mathbf 1_{h>0}).
\]

Indeed:

- if \(r_H=0\), the gain is \(r_B\le b\);
- if \(r_H=1\), the gain is \(1\);
- if \(r_H\ge2\), the expression is at most \(1\).

Therefore:

\[
|E(K)|
\le
E_0+\max(b,\mathbf 1_{h>0}).
\]

#### Subcase \(b\ge1\)

The maximum term is \(b\).

After substituting:

\[
n=a+b+h,
\]

twice the gap required by the lemma simplifies to:

\[
\boxed{
(a-1)(a-2)
+
(b-2)(b-3).
}
\]

For integers:

\[
a\ge0,
\qquad
b\ge1,
\]

each factor product is nonnegative:

\[
(a-1)(a-2)\ge0,
\]

and:

\[
(b-2)(b-3)\ge0.
\]

Hence the desired inequality follows.

#### Boundary subcase \(b=0,\ h>0\)

Twice the required gap becomes:

\[
a^2-3a+6
=
(a-1)(a-2)+4
\ge0.
\]

#### Boundary subcase \(b=h=0\)

Twice the required gap becomes:

\[
a^2-3a+8
=
(a-1)(a-2)+6
\ge0.
\]

Therefore Lemma 5.2 holds when:

\[
z\in A.
\]

By symmetry it also holds when:

\[
z\in B.
\]

---

## 5.10 Proof of Lemma 5.2 when \(z\in H\)

Write:

\[
h_0=|H|-1,
\]

and:

\[
a=|A|,
\qquad
b=|B|.
\]

Then:

\[
a+b+h_0=n.
\]

For \(K-z\), the complete allowed edge count is:

\[
\boxed{
E_0
=
ab+ah_0+bh_0+\binom{h_0}{2}.
}
\]

Let:

\[
R=N_K(z).
\]

Write:

\[
r_A=|R\cap A|,
\]

\[
r_B=|R\cap B|,
\]

and:

\[
r_H=|R\cap(H\setminus\{z\})|.
\]

Since \(R\) is independent, compared with the complete allowed \(K-z\) graph,
at least:

\[
r_Ar_B
+
r_Ar_H
+
r_Br_H
+
\binom{r_H}{2}
\]

edges must be absent.

The net gain from choosing \(R\) is therefore bounded above by:

\[
\boxed{
\max(a,b,\mathbf1_{h_0>0}).
}
\]

Assume without loss of generality that the maximum is \(a\), with \(a\ge1\).

Twice the required gap simplifies to:

\[
\boxed{
(a-2)(a-3)
+
(b-1)(b-2)
+
2.
}
\]

For integer \(a\ge1\) and \(b\ge0\), this is nonnegative.

If:

\[
a=b=0,
\]

twice the gap is:

\[
8.
\]

Thus Lemma 5.2 also holds when:

\[
z\in H.
\]

All cases are complete.

\[
\square
\]

---

## 5.11 Lower bound for Theorem A

Lemma 5.2 gives:

\[
|E(K)|-h
\le
\binom{n+1}{2}
-
2n
+
4.
\]

Since:

\[
|G|
=
\binom{n+1}{2}
-
|E(K)|,
\]

we rearrange to obtain:

\[
h+|G|
\ge
2n-4.
\]

Recall the exact cost identity:

\[
|\mathcal X|+|\mathcal Y|
=
n+3+h+|G|+d,
\]

with:

\[
d\ge0.
\]

Therefore:

\[
\begin{aligned}
|\mathcal X|+|\mathcal Y|
&\ge
n+3+(2n-4)
\\
&=
\boxed{
3n-1.
}
\end{aligned}
\]

Hence:

\[
\boxed{
\beta_2(Q_n)\ge3n-1.
}
\]

---

## 5.12 Matching upper construction

Assume:

\[
n\ge3.
\]

Choose three distinct ordinary vertices:

\[
x,y_1,y_2\in[n].
\]

Let:

\[
H
=
[n]\setminus\{x,y_1,y_2\}.
\]

Define the first resource family \(\mathcal X\) by:

- \(\varnothing\);
- \(\{z\}\);
- \(\{x\}\);
- every singleton:
  \[
  \{h\},
  \qquad h\in H;
  \]
- the edge:
  \[
  \{z,x\};
  \]
- every pointed edge:
  \[
  \{z,h\},
  \qquad h\in H.
  \]

Define the second resource family \(\mathcal Y\) by:

- \(\varnothing\);
- \(\{y_1\}\);
- \(\{y_2\}\);
- every singleton:
  \[
  \{h\},
  \qquad h\in H;
  \]
- the edge:
  \[
  \{y_1,y_2\}.
  \]

Count the first family:

\[
|\mathcal X|
=
1
+
1
+
1
+
(n-3)
+
1
+
(n-3)
=
\boxed{
2n-2.
}
\]

Count the second family:

\[
|\mathcal Y|
=
1
+
2
+
(n-3)
+
1
=
\boxed{
n+1.
}
\]

Therefore:

\[
|\mathcal X|+|\mathcal Y|
=
\boxed{
3n-1.
}
\]

---

## 5.13 Coverage of all size-at-most-two targets

The singleton ownership classes are:

\[
A=\{z,x\},
\]

\[
B=\{y_1,y_2\},
\]

and:

\[
H=[n]\setminus\{x,y_1,y_2\}.
\]

All singletons occur.

Now consider pairs.

#### Cross-class pairs

If one vertex has its singleton in \(\mathcal X\) and the other in
\(\mathcal Y\), their union generates the pair.

#### Pair internal to \(A\)

The only pair is:

\[
\{z,x\},
\]

and it occurs explicitly in \(\mathcal X\).

#### Pair internal to \(B\)

The only pair is:

\[
\{y_1,y_2\},
\]

and it occurs explicitly in \(\mathcal Y\).

#### Pair internal to \(H\)

Every vertex in \(H\) has its singleton in both resource families.

Hence for distinct \(h_1,h_2\in H\),

\[
\{h_1\}\in\mathcal X,
\qquad
\{h_2\}\in\mathcal Y,
\]

and their union generates:

\[
\{h_1,h_2\}.
\]

Therefore every target of size at most two is generated.

---

## 5.14 Coverage of every pointed triple

Take any target:

\[
\{z,u,v\},
\qquad
u,v\in[n],
\quad
u\ne v.
\]

#### Special case

If:

\[
\{u,v\}
=
\{y_1,y_2\},
\]

use:

\[
\{z\}\in\mathcal X
\]

and:

\[
\{y_1,y_2\}\in\mathcal Y.
\]

Their union is:

\[
\{z,y_1,y_2\}.
\]

#### General case

Otherwise \(\{u,v\}\neq\{y_1,y_2\}\). The remaining cases are exhaustive:

1. If one of \(u,v\) is \(x\), let the other be \(q\). Since the pair is not \(\{y_1,y_2\}\), we have \(q\in H\cup\{y_1,y_2\}\). Then
   \[
   \{z,x\}\in\mathcal X,
   \qquad
   \{q\}\in\mathcal Y,
   \]
   and their union is \(\{z,u,v\}\).

2. If neither is \(x\) and at least one is \(h\in H\), choose such an \(h\). The other vertex \(q\) lies in \(H\cup\{y_1,y_2\}\), hence \(\{q\}\in\mathcal Y\). Since \(\{z,h\}\in\mathcal X\), the two generators again unite to \(\{z,u,v\}\).

3. The only case with neither \(x\) nor an element of \(H\) is \(\{u,v\}=\{y_1,y_2\}\), already handled above.

Thus every pointed triple is generated.

Therefore:

\[
\boxed{
\beta_2(Q_n)\le3n-1.
}
\]

Combined with the lower bound:

\[
\boxed{
\beta_2(Q_n)=3n-1.
}
\]

Equivalently:

\[
\boxed{
\beta_2(B(n,\le2)\times C_2)=3n-1.
}
\]

\[
\square
\]

---

## 5.15 Boundary cases

Independent finite optimization recorded in the computational provenance gives:

\[
\beta_2(Q_n)
=
4,6,8,11,14,17
\]

for:

\[
n=1,2,3,4,5,6.
\]

The formula:

\[
3n-1
\]

gives:

\[
2,5,8,11,14,17.
\]

Thus:

\[
n=1,2
\]

are genuine exceptions.

The theorem begins exactly at:

\[
\boxed{
n=3.
}
\]

This also matches the explicit construction, which requires three distinct
ordinary vertices:

\[
x,y_1,y_2.
\]

Therefore the domain restriction is structural rather than cosmetic.

---

# Chapter 6 — Consequences and Construction Principles

## 6.1 Exact linear product interaction

### Corollary 6.1 — Exact linear product interaction

**Stable ID:** `CCM-PRODUCT-002`

For:

\[
n\ge3,
\]

we have:

\[
\beta_2(T_n)=2n,
\]

\[
\beta_2(C_2)=3,
\]

and:

\[
\beta_2(T_n\times C_2)=3n-1.
\]

Hence:

\[
\begin{aligned}
\iota_2(T_n,C_2)
&=
\beta_2(T_n\times C_2)
-
\beta_2(T_n)
-
\beta_2(C_2)
+
2
\\
&=
(3n-1)-2n-3+2
\\
&=
\boxed{
n-2.
}
\end{aligned}
\]

Therefore:

\[
\boxed{
\iota_2(B(n,\le2),C_2)=n-2.
}
\]

A fixed two-state control factor creates an interaction cost that grows without
bound.

The second factor remains constant.

The surcharge nevertheless grows linearly in \(n\).

---

## 6.2 Explicit optimal constructor

For \(n\ge3\), select distinct ordinary coordinates

\[
x,y_1,y_2\in[n]
\]

and let

\[
H=[n]\setminus\{x,y_1,y_2\}.
\]

The optimal constructor is the pair

\[
\mathcal X
=
\{\varnothing,\{z\},\{x\}\}
\cup
\{\{h\}:h\in H\}
\cup
\{\{z,x\}\}
\cup
\{\{z,h\}:h\in H\},
\]

\[
\mathcal Y
=
\{\varnothing,\{y_1\},\{y_2\}\}
\cup
\{\{h\}:h\in H\}
\cup
\{\{y_1,y_2\}\}.
\]

Its sizes are

\[
|\mathcal X|=2n-2,
\qquad
|\mathcal Y|=n+1,
\]

so the total cost is \(3n-1\). Given the three distinguished ordinary vertices, the libraries can be emitted in \(O(n)\) set insertions.

## 6.3 A local-versus-global preference reversal

The master also records a finite example in which a locally minimum architecture is not the best architecture after composition. This result is supporting mathematics rather than part of the novelty claim of Theorem A.

A supporting finite example establishes a second exact phenomenon:

\[
\boxed{
\text{a locally worse architecture can become globally better after
composition}.
}
\]

This result is supporting evidence.

It is not needed to prove Theorem A and is not treated as an independent novelty claim.

---

In the Boolean lattice on four coordinates, define:

\[
\boxed{
T_A
=
\{0,3,4,6,8,9\}.
}
\]

Its complete two-family Pareto size spectrum is:

\[
\boxed{
\mathscr S_2(T_A)
=
\{
(1,6),
(2,5),
(3,3),
(5,2),
(6,1)
\}.
}
\]

Therefore:

\[
\boxed{
\beta_2(T_A)=6.
}
\]

Every minimum basis has size pair:

\[
(3,3).
\]

Thus:

\[
\boxed{
\mu_2(T_A)=3.
}
\]

A minimum local architecture therefore has total cost:

\[
6.
\]

If one insists on taking a minimum local architecture and then lifts its
smallest library through binary control, the cost is:

\[
6+3
=
\boxed{
9.
}
\]

---

Take:

\[
X'=\{0\},
\]

and:

\[
Y'=T_A.
\]

This is a valid local basis because:

\[
0\vee y=y.
\]

Its local cost is:

\[
1+6
=
\boxed{
7.
}
\]

Thus it is locally worse:

\[
6<7.
\]

But its smallest resource library has size one.

Lift that one-element library through the binary control.

Its size becomes two.

The other resource library remains size six.

Hence the composite cost is:

\[
2+6
=
\boxed{
8.
}
\]

Complete finite enumeration proves no product basis of total cost seven exists,
so:

\[
\boxed{
\beta_2(T_A\times C_2)=8.
}
\]

Therefore:

\[
\boxed{
6<7
\quad\text{locally},
}
\]

but:

\[
\boxed{
9>8
\quad\text{after composition}.
}
\]

The local preference ordering reverses.

---

The finite theorem yields a practical construction principle:

\[
\boxed{
\text{do not discard every locally nonoptimal architecture before future
composition is evaluated}.
}
\]

A synthesis system that retains only one locally minimum representation may
destroy the globally optimal composite architecture.

The system may need to preserve enough of the resource tradeoff structure to
retain architectures that become optimal under later composition.

The principle follows from an exact theorem, not from a heuristic analogy.

---

The construction principle is therefore:

\[
\boxed{
\text{do not discard every locally nonoptimal architecture before future composition is evaluated.}
}
\]

This is an exact finite phenomenon, not a claim that every composition problem behaves this way.


# Chapter 7 — Certificates, Transfer, and Optimality Cells

## 7.1 Monotonicity transfer

If \(S\subseteq T\) are targets in the same join-semilattice, then every basis
for \(T\) is also a basis for \(S\). Hence

\[
\boxed{\beta_r(S)\le\beta_r(T).}
\]

Therefore every occurrence of the pointed target \(Q_n\) inside a larger target
immediately gives

\[
\boxed{\beta_2(T)\ge3n-1.}
\]

This is elementary and receives no independent novelty credit. Its value is
that it turns Theorem A into a reusable lower-bound obstruction.

---

## 7.2 Join-homomorphic transfer

### Proposition 7.1 — Join-homomorphic transfer

Let \(\phi:L\to M\) be a bottom-preserving join homomorphism:

\[
\phi(0)=0,
\qquad
\phi(x\vee y)=\phi(x)\vee\phi(y).
\]

If \(T\subseteq L\) and \(U\subseteq \phi(T)\), then

\[
\boxed{
\beta_r(T)\ge\beta_r(U).
}
\]

#### Proof

Take any polarized \(r\)-basis \((F_1,\ldots,F_r)\) for \(T\). The image
families \(\phi(F_i)\) contain bottom and generate every element of \(\phi(T)\),
hence every element of \(U\). Deduplication under \(\phi\) can only decrease
family sizes:

\[
|\phi(F_i)|\le|F_i|.
\]

Thus

\[
\beta_r(U)
\le
\sum_i|\phi(F_i)|
\le
\sum_i|F_i|.
\]

Minimize over bases of \(T\).

\[
\square
\]

#### Consequence

If an arbitrary construction system admits a sound join-homomorphic abstraction
whose image contains \(Q_n\), then Theorem A gives a certified lower bound on
the concrete system.

No independent novelty claim is made for this transfer principle.

---

## 7.3 Pointed-clique certificate

### Corollary 7.2 — Pointed-clique lower-bound certificate

**Stable ID:** `CCM-TRANSFER-001`

Let

\[
T\subseteq2^{[d]}
\]

be a finite down-set.

For each coordinate \(z\in[d]\), define the **pointed triple graph**

\[
G_z(T)
\]

on vertex set

\[
[d]\setminus\{z\}
\]

by putting an edge \(uv\) exactly when

\[
\{z,u,v\}\in T.
\]

Suppose \(S\) is a clique of size \(k\) in \(G_z(T)\).

Because \(T\) is downward closed, for every \(u,v\in S\),

\[
\{z,u,v\}\in T
\]

forces all of its subsets into \(T\). Therefore the restriction of \(T\) to

\[
S\cup\{z\}
\]

contains the full pointed target \(Q_k\).

Hence:

\[
\boxed{
\beta_2(T)\ge\beta_2(Q_k).
}
\]

Using the exact small cases and Theorem A,

\[
\boxed{
\beta_2(T)\ge
\begin{cases}
6,&k=2,\\[2mm]
3k-1,&k\ge3.
\end{cases}
}
\]

This is the first generic usefulness mechanism produced by the new theorem.

A clique itself is a short independently checkable lower-bound certificate.

---

## 7.4 Pointed-clique dimension

Define, for a down-set \(T\),

\[
\operatorname{pcd}(T)
=
\max_{z\in[d]}\omega(G_z(T)),
\]

where \(\omega\) is clique number.

Then for

\[
\operatorname{pcd}(T)\ge3,
\]

\[
\boxed{
\beta_2(T)\ge3\,\operatorname{pcd}(T)-1.
}
\]

The definition receives no novelty credit. The importance is computational:
an exact theorem for one structured family becomes a certified lower-bound
routine for arbitrary finite down-sets.

---

## 7.5 Optimality-cell principle

Let \(T_0\) have an optimal constructor \((F_1,\ldots,F_r)\) of cost \(c\).
Let

\[
R=F_1\vee\cdots\vee F_r
\]

be everything generated by that constructor.

For every target \(T\) satisfying

\[
T_0\subseteq T\subseteq R,
\]

monotonicity gives

\[
\beta_r(T)\ge\beta_r(T_0)=c,
\]

while the same constructor gives

\[
\beta_r(T)\le c.
\]

Therefore

\[
\boxed{
\beta_r(T)=c.
}
\]

This elementary sandwich principle means one exact theorem automatically
solves an entire region of neighboring requirement sets.

---

## 7.6 Exact exponential cell around \(Q_n\)

Use the explicit Theorem A constructor.

Choose distinct ordinary vertices

\[
x,y_1,y_2
\]

and put

\[
H=[n]\setminus\{x,y_1,y_2\}.
\]

The optimal libraries are:

\[
\mathcal X=
\{\varnothing,\{z\},\{x\},\{h\}:h\in H,
\{z,x\},\{z,h\}:h\in H\},
\]

and

\[
\mathcal Y=
\{\varnothing,\{y_1\},\{y_2\},\{h\}:h\in H,
\{y_1,y_2\}\}.
\]

Their total cost is \(3n-1\).

The complete generated closure is \(Q_n\) plus, for every

\[
w\in[n]\setminus\{y_1,y_2\},
\]

the two possible extra targets

\[
\{w,y_1,y_2\}
\]

and

\[
\{z,w,y_1,y_2\}.
\]

For a down-set, those extras form an independent three-state chain:

1. add neither;
2. add the triple only;
3. add both the triple and its pointed four-set.

There are \(n-2\) independent choices.

Therefore one frozen optimal constructor certifies exactly

\[
\boxed{
3^{\,n-2}
}
\]

distinct down-set targets, each with

\[
\boxed{
\beta_2(T)=3n-1.
}
\]

Thus exact optimization has expanded from one target family to an exponential
family of target families without solving any new integer program.

---

## 7.7 Incremental requirement robustness

The optimality cell provides an incremental engineering certificate.

If an implementation already uses the Theorem A optimal libraries, and new
requirements are added but remain inside

\[
\mathcal X\vee\mathcal Y,
\]

then:

\[
\boxed{
\text{no increase in optimum cost is possible or necessary}.
}
\]

The old lower bound still applies because \(Q_n\) remains a subtarget, and the
old constructor still covers the enlarged requirements.

This converts a static theorem into a no-reoptimization certificate.

---

# Chapter 8 — Graph-Parametrized Construction Theory

The graph-parametrized theory concerns a different, position-free catalog quantity. It is included because it gives a useful exact contrast with the polarized flagship theorem. Its core reduction is close to standard vertex-cover theory, so it is treated here as a derived exact result rather than as an independent novelty claim.

## 8.1 Pointed graph family

Let

\[
G=(V,E),
\qquad |V|=n,
\]

and let \(z\notin V\).

Define:

\[
Q(G)
=
\binom{V\cup\{z\}}{\le2}
\cup
\{\{z,u,v\}:uv\in E\}.
\]

Thus the complete-family theorem corresponds to:

\[
G=K_n.
\]

---

## 8.2 Single-catalog two-cover number

Define:

\[
\delta_2(Q(G))
\]

to be the minimum size of a single catalog \(\mathcal C\) such that every member
of \(Q(G)\) is the union of at most two members of \(\mathcal C\).

Every singleton target forces its singleton into the catalog.

Every pair is then already covered by two singletons.

For every required pointed triple:

\[
\{z,u,v\},
\qquad uv\in E,
\]

at least one of its three constituent pairs must be stored, after the same
pair-normal-form replacement used for the pointed family.

Hence the extra catalog pairs form an edge transversal of the triangles:

\[
zuv
\qquad(uv\in E)
\]

in the cone over \(G\).

---

## 8.3 Cone triangle-transversal lemma

Let \(H\) be any pair set hitting every triangle \(zuv\) with \(uv\in E(G)\).

From \(H\), build a vertex set \(C\subseteq V(G)\):

- if \(zu\in H\), put \(u\) into \(C\);
- if \(uv\in H\), choose either \(u\) or \(v\) and put it into \(C\).

Then:

\[
|C|\le|H|.
\]

Every graph edge \(uv\) is covered by \(C\), because its cone triangle is hit by
one of:

\[
zu,\quad zv,\quad uv.
\]

Therefore:

\[
\tau(G)\le|H|.
\]

Conversely, if \(C\) is a vertex cover of \(G\), the star-pair set:

\[
\{zu:u\in C\}
\]

hits every required cone triangle.

Hence:

\[
\boxed{
\text{minimum extra pair count}=\tau(G).
}
\]

---

## 8.4 Exact graph catalog theorem

### Theorem 8.1 — Exact graph two-cover catalog law

**Stable ID:** `CCM-GRAPH-001`

There are \(n+1\) mandatory singletons.

By the cone lemma:

\[
\boxed{
\delta_2(Q(G))
=
n+1+\tau(G).
}
\]

Using:

\[
\tau(G)=n-\alpha(G),
\]

we obtain:

\[
\boxed{
\delta_2(Q(G))
=
2n+1-\alpha(G).
}
\]

This solves the unrestricted two-cover catalog problem exactly for every finite
graph.

For:

\[
G=K_n,
\]

\[
\alpha(K_n)=1,
\]

so:

\[
\boxed{
\delta_2(Q(K_n))=2n.
}
\]

---

## 8.5 Exact price of polarization

Theorem A gives:

\[
\beta_2(Q(K_n))=3n-1.
\]

The unrestricted one-catalog theorem gives:

\[
\delta_2(Q(K_n))=2n.
\]

Therefore the exact cost of requiring two separate resource positions on this
family is:

\[
\boxed{
\beta_2(Q(K_n))-\delta_2(Q(K_n))
=
n-1.
}
\]

This clarifies the flagship theorem:

\[
\boxed{
\text{the positional/polarized architecture itself has an exact linear price.}
}
\]

This is a derived interpretation of Theorem A, not a second independent novelty claim.

---

## 8.6 Exact graph Pareto characterization

Every Pareto-optimal pair-hitting catalog has a canonical representative.

Let:

\[
S=
\{u\in V:zu\text{ is not stored}\}.
\]

If:

\[
uv\in E(G[S]),
\]

then both star pairs are absent, so \(uv\) itself must be stored.

Any stored ordinary edge outside \(E(G[S])\) is unnecessary and can be deleted.

Thus every Pareto optimum is represented by some \(S\subseteq V\) with pair
catalog:

\[
\{zu:u\notin S\}
\cup
E(G[S]).
\]

Its exact total catalog size is:

\[
\boxed{
C_G(S)
=
2n+1-|S|+|E(G[S])|.
}
\]

In the direct subset-key realization, its worst receiver key incidence is:

\[
\boxed{
K_G(S)
=
\max\{
n-|S|+1,\;
1+\Delta(G[S]),\;
2
\}.
}
\]

Therefore the entire storage/catalog frontier for an arbitrary graph is reduced
to induced-subgraph optimization.

---

## 8.7 Independence-number derivation

For every \(S\subseteq V\),

\[
|S|-|E(G[S])|
\le
\alpha(G).
\]

Proof: select at most one endpoint per edge of \(G[S]\) to obtain a vertex cover
of \(G[S]\) of size at most \(|E(G[S])|\). The remaining vertices form an
independent set of size at least:

\[
|S|-|E(G[S])|.
\]

Equality is attained by taking \(S\) to be a maximum independent set.

Hence the exact graph catalog formula follows again from the Pareto
characterization.

---

## 8.8 Complexity transfer

Because:

\[
\delta_2(Q(G))=n+1+\tau(G),
\]

exact catalog optimization on the graph-parametrized policy class is
polynomial-time equivalent, up to the trivial transformation, to minimum
vertex cover / maximum independent set.

Therefore:

- exact algorithms for special graph classes transfer immediately;
- fixed-parameter algorithms transfer;
- approximation guarantees transfer;
- NP-hardness transfers on unrestricted graphs.

The mathematics now tells an engineer exactly when the derived catalog problem
is easy or hard.

---

## 8.9 Complete-graph specialization

For \(G=K_n\),

\[
\alpha(K_n)=1,
\]

so

\[
\delta_2(Q(K_n))=2n.
\]

The polarized theorem gives

\[
\beta_2(Q(K_n))=3n-1.
\]

Therefore

\[
\boxed{
\beta_2(Q(K_n))-\delta_2(Q(K_n))=n-1.
}
\]

This is an exact comparison between position-sensitive and position-free resource architectures on the same pointed family.


# Chapter 9 — Finite Witness Systems and Countable Extensions

The witness layer is a general utility interface. The master itself treats this shell conservatively and does not claim that generic finite witness optimization is new mathematics.

## 9.1 Finite witness systems

### Proposition 9.1 — Exact finite witness representation

**Stable ID:** `CCM-WITNESS-001`

A finite \(r\)-position construction problem consists of:

- finite resource sets:
  \[
  R_1,\ldots,R_r;
  \]
- a finite target set:
  \[
  \mathcal T;
  \]
- for each target \(t\), a finite witness relation:
  \[
  W_t\subseteq R_1\times\cdots\times R_r;
  \]
- optional nonnegative resource weights.

A selected library tuple

\[
F_i\subseteq R_i
\]

constructs \(t\) exactly when

\[
W_t\cap(F_1\times\cdots\times F_r)\ne\varnothing.
\]

The optimization problem is to minimize selected resource cost while every
target has a witness.

This is an established monotone finite optimization shell; no novelty is
claimed for the shell itself.

---

Any finite modular algorithm-design problem for which:

1. candidate reusable modules are finite;
2. each valid construction is a finite tuple of modules;
3. the design objective is additive over selected reusable modules;

can be encoded exactly as a finite witness system.

The encoding does not require composition to be set union.

The set-union CCM model is the special case in which a tuple is a witness
precisely when its join equals the target.

Therefore the engineering framework now accepts algorithm-construction
problems beyond semilattices.

The novel \(Q_n\) theorem transfers only when an additional sound
join/homomorphic motif is present; the generic witness solver itself is not
claimed as new mathematics.

---

A reference implementation may include:

```text
ccm_witness_solver.py
```

The solver accepts:

- arbitrary finite resource positions;
- arbitrary finite resource catalogs;
- arbitrary finite witness tuples;
- weighted or unweighted resource costs.

It compiles the problem to an exact 0–1 MILP:

- one variable per reusable resource;
- one activation variable per witness tuple;
- implication constraints from each active witness to its selected resources;
- one coverage constraint per target.

This gives an exact engineering path from a finite modular construction problem
to a certified optimum.

The solver is a utility layer, not the mathematical novelty claim.

---

The strongest honest statement is now:

\[
\boxed{
\text{any finite, explicitly enumerated modular algorithm-construction problem}
}
\]

can be represented and optimized by the witness layer.

For algorithm classes with a sound join-semilattice abstraction, CCM's
pointed-motif bounds and exact cells additionally supply theorem-derived
certificates.

This does not imply that unbounded program synthesis, arbitrary undecidable
program properties, or infinite search spaces have become tractable.

The distinction is preserved explicitly.

---

## 9.2 Countable modular problems and eventual exactness

### Theorem 9.2 — Eventual exactness under finite attained support

**Stable ID:** `CCM-WITNESS-002`

Let:

\[
R_i^{(1)}
\subseteq
R_i^{(2)}
\subseteq\cdots
\]

be finite resource sets whose union is a countable resource universe \(R_i\).

Let each target have a computably enumerable set of finite witness tuples.

Let:

\[
P_1\subseteq P_2\subseteq\cdots
\]

be nested finite witness snapshots that eventually contain every enumerated
resource and witness.

Write:

\[
\operatorname{OPT}_N
\]

for the exact optimum of snapshot \(P_N\), with \(+\infty\) when the snapshot is
not yet feasible.

Then:

\[
\boxed{
\operatorname{OPT}_{N+1}\le\operatorname{OPT}_N.
}
\]

Every finite-snapshot solution is also a legal solution of the full problem, so:

\[
\boxed{
\operatorname{OPT}_N\ge\operatorname{OPT}_\infty.
}
\]

---

Assume the full countable modular problem has an attained optimum whose selected
resource support is finite.

For every target choose one witness tuple realized by that optimum.

Because:

- the optimum uses only finitely many resources; and
- there are only finitely many targets; and
- each chosen witness tuple is finite,

there exists a finite index \(N_0\) at which all resources and all chosen
witness tuples of that optimum have entered the truncation.

Therefore:

\[
\operatorname{OPT}_{N_0}
\le
\operatorname{OPT}_\infty.
\]

But every finite-snapshot optimum is a full feasible solution, so:

\[
\operatorname{OPT}_{N_0}
\ge
\operatorname{OPT}_\infty.
\]

Hence:

\[
\boxed{
\operatorname{OPT}_{N_0}
=
\operatorname{OPT}_\infty.
}
\]

Monotonicity then gives:

\[
\boxed{
\forall N\ge N_0:
\quad
\operatorname{OPT}_N
=
\operatorname{OPT}_\infty.
}
\]

Thus a countably enumerable modular search with a finite attained optimum is
eventually solved exactly by the finite witness sequence.

There need not be a computable bound telling us when \(N_0\) has been reached.

---

Let \(A\) be any program or algorithm.

Choose:

- a finite set of observations/tests/requirements;
- a finite or computably enumerable library of candidate reusable components;
- a finite number of composition positions.

For each requirement, enumerate the component tuples that satisfy the chosen
observation.

This produces a witness system independent of the language or internal program
representation.

Therefore:

\[
\boxed{
\text{every algorithm can be analyzed by CCM's witness layer at every finite
explicit observational specification}.
}
\]

This is an applicability statement.

It does not claim that semantic equivalence, termination, or correctness over
all possible inputs is decidable for arbitrary programs.

---

The framework deliberately records the following boundary:

\[
\boxed{
\text{unrestricted semantic optimization of arbitrary programs cannot in
general be guaranteed to terminate}.
}
\]

the countable extension does not weaken this fact.

Instead it provides the maximal constructive envelope:

1. exact finite witness optimization;
2. exact theorem-derived CCM certificates when join structure exists;
3. monotonically improving finite truncations for countable modular spaces;
4. eventual exactness whenever the full optimum is attained on finite support;
5. immediate stopping whenever an independent full-problem lower bound meets
   the current finite optimum.

This is the strongest honest sense in which the framework can be applicable to
arbitrary algorithms.

---

## 9.3 Scope boundary

The strongest honest applicability statement is finite and explicit: any finite modular construction problem with finitely many resources, finitely many targets, explicit valid witness tuples, and additive resource costs has an exact witness representation. Countably enumerable extensions are eventually exact only under the stated finite-attained-support assumptions. No decision procedure for unrestricted semantic properties of arbitrary programs is claimed.


# Chapter 10 — Algorithms, Worked Examples, and Verification

## 10.1 Optimal constructor algorithm for \(Q_n\)

**Input:** integer \(n\ge3\).  
**Output:** optimal libraries \((\mathcal X,\mathcal Y)\).

```text
choose distinct x, y1, y2 in [n]
H <- [n] \ {x,y1,y2}

X <- {empty, {z}, {x}, {z,x}}
for h in H:
    add {h} to X
    add {z,h} to X

Y <- {empty, {y1}, {y2}, {y1,y2}}
for h in H:
    add {h} to Y

return X,Y
```

Theorem A proves that the returned total size \(3n-1\) is optimal.

## 10.2 Worked example: \(Q_5\)

Choose

\[
x=1,
\qquad y_1=2,
\qquad y_2=3,
\qquad H=\{4,5\}.
\]

Then

\[
\mathcal X=
\{\varnothing,\{z\},\{1\},\{4\},\{5\},\{z,1\},\{z,4\},\{z,5\}\},
\]

so

\[
|\mathcal X|=8=2(5)-2.
\]

And

\[
\mathcal Y=
\{\varnothing,\{2\},\{3\},\{4\},\{5\},\{2,3\}\},
\]

so

\[
|\mathcal Y|=6=5+1.
\]

Hence

\[
\boxed{\beta_2(Q_5)=14.}
\]

## 10.3 Worked example: a nontrivial down-set certificate

Let the ground set be

\[
\{z,1,2,3,4\}
\]

and let

\[
T=B(5,\le2)\cup
\{\{z,1,2\},\{z,1,3\},\{z,2,3\}\}.
\]

This is a down-set because all subsets of the three displayed triples already lie in \(B(5,\le2)\).

For the distinguished point \(z\), the pointed triple graph \(G_z(T)\) has a triangle on vertices \(1,2,3\):

\[
12,13,23\in E(G_z(T)).
\]

Hence \(\omega(G_z(T))\ge3\). Corollary 7.2 immediately gives

\[
\boxed{\beta_2(T)\ge 3(3)-1=8.}
\]

The certificate consists only of the clique \(\{1,2,3\}\). No global optimization of \(T\) is needed to justify this lower bound.

## 10.4 Pointed-clique certificate algorithm

For a finite down-set \(T\subseteq2^{[d]}\):

```text
best <- 0
for z in [d]:
    build graph G_z on [d] \ {z}
    put edge u-v iff {z,u,v} is in T
    k <- clique number of G_z
    best <- max(best,k)

if best >= 3:
    return lower bound 3*best - 1
else:
    return only the available small-case bound
```

The clique search may itself be computationally hard on unrestricted graphs; the theorem supplies a certificate once a clique is found.

## 10.5 Worked example: graph-parametrized catalog

Let \(G=P_4\) be the path

\[
1-2-3-4.
\]

A minimum vertex cover is

\[
C=\{2,3\},
\]

so

\[
\tau(G)=2.
\]

The complementary independent-set identity gives

\[
\alpha(G)=4-2=2.
\]

Theorem 8.1 therefore yields

\[
\boxed{
\delta_2(Q(G))
=4+1+2
=7.
}
\]

An optimal catalog is

\[
\mathcal C=
\{\{z\},\{1\},\{2\},\{3\},\{4\},\{z,2\},\{z,3\}\}.
\]

For example,

\[
\{z,1,2\}=\{1\}\cup\{z,2\},
\]

\[
\{z,2,3\}=\{2\}\cup\{z,3\},
\]

and

\[
\{z,3,4\}=\{z,3\}\cup\{4\}.
\]

Thus every required pointed triple associated with an edge of \(P_4\) uses at most two catalog sets.

## 10.6 Finite witness MILP template

Use one binary variable for each reusable resource and one activation variable for each witness tuple. An activated witness forces all resources in that tuple to be selected; every target requires at least one activated witness. The objective minimizes total selected resource cost. This is an exact encoding of the finite witness problem defined in Chapter 9.

## 10.7 Worked example: finite witness system

Take two resource positions

\[
R_1=\{a,b\},
\qquad
R_2=\{c,d\},
\]

with two targets \(t_1,t_2\). Let

\[
W_{t_1}=\{(a,c),(b,d)\},
\]

and

\[
W_{t_2}=\{(a,d)\}.
\]

The second target forces selection of \(a\) and \(d\). To satisfy \(t_1\), one must then add either \(c\), enabling witness \((a,c)\), or \(b\), enabling witness \((b,d)\). Thus every feasible selected-resource system has cost at least three, and both

\[
\{a,c,d\}
\]

and

\[
\{a,b,d\}
\]

achieve cost three. Therefore the exact optimum is

\[
\boxed{3.}
\]

This example illustrates that the witness layer is more general than literal set union: the valid tuples are supplied externally by the construction problem.

## 10.8 Computational corroboration

The source provenance records an independent 0–1 MILP verification returning

\[
\boxed{4,6,8,11,14,17}
\]

for

\[
n=1,\ldots,6.
\]

For \(n=3,\ldots,6\), these values agree with \(3n-1\). The same provenance records constructor checks through \(n=100\). These computations corroborate the analytic theorem but are not used in its proof.


# Chapter 11 — Applications and Relationship to Existing Mathematics

## 11.1 Modular construction systems

A finite modular design problem can be brought into the witness framework whenever the candidate reusable modules are finite, the required targets are finite, valid construction tuples are explicit, and resource costs are additive. If the domain additionally admits a sound join-homomorphic abstraction containing a pointed motif, the exact CCM lower bounds can be transferred back to the concrete problem.

This is a modeling criterion, not a claim that every algorithmic system naturally has a union-semilattice semantics.

## 11.2 Subset-cover cryptographic resource design

The master gives a constrained subset-cover interpretation in which long-lived subset keys are assigned to catalog subsets and a supported privileged receiver set is covered by one or two catalog entries. The combinatorial optimization of the catalog is then an instance of the set-union construction problem.

### 11.2.1 Two-stratum catalog model

Subset-cover broadcast encryption is an established cryptographic framework:
a system prepares subsets of receivers, assigns long-lived keys to those
subsets, and covers a privileged receiver set by a union of catalog subsets.

Define a **two-stratum subset-cover catalog**:

\[
(\mathcal F,\mathcal G),
\]

where each supported privileged set must be expressible as

\[
P=F\cup G,
\qquad
F\in\mathcal F,\quad G\in\mathcal G.
\]

Allow \(\varnothing\) as the no-op subset.

Then the minimum total number of catalog entries required for a policy family
\(T\) is exactly

\[
\beta_2(T).
\]

Therefore Theorem A immediately gives the following exact constrained
broadcast-encryption catalog theorem:

For the pointed policy family \(Q_n\),

\[
\boxed{
\text{minimum two-stratum catalog size}=3n-1.
}
\]

The explicit CCM constructor supplies the catalog.

Each supported policy needs at most two subset-key encryptions: one subset from
each stratum.

This is a concrete cryptographic resource-design application.

It does **not** by itself prove:
- security of a key-assignment scheme;
- optimal per-user key storage;
- optimality among unrestricted subset-cover architectures;
- applicability to arbitrary revocation policies.

Those remain separate cryptographic questions.

---

The subset-cover framework of Naor, Naor, and Lotspiech is established
cryptography, and later work explicitly treats subset representation and
communication/storage tradeoffs.

Accordingly, no novelty claim is made here for:

- broadcast encryption;
- subset-cover encryption;
- subset-difference methods;
- catalog storage versus communication tradeoffs.

The only theorem carrying the master’s flagship novelty claim remains Theorem A.

The broadcast-encryption statement is a new *application of the theorem under
a restricted two-stratum catalog model*, not evidence that CCM invented
subset-cover cryptography.

---

### 11.2.2 Direct-key instantiation

Let \(\mathcal C\) be one of the exact two-cover catalogs for \(Q_n\).

For every catalog subset

\[
S\in\mathcal C,
\]

sample an independent long-lived symmetric key:

\[
K_S.
\]

Give \(K_S\) to every receiver in \(S\).

To encrypt a message to a supported privileged set

\[
P\in Q_n,
\]

choose catalog subsets

\[
A,B\in\mathcal C
\]

with:

\[
P=A\cup B,
\]

allowing a one-subset cover when available.

Sample a fresh session key \(K\).

Send:

\[
\operatorname{Enc}_{K_A}(K),
\qquad
\operatorname{Enc}_{K_B}(K)
\]

for the nonempty cover subsets, together with:

\[
\operatorname{Enc}_K(M).
\]

Every privileged receiver belongs to at least one cover subset and therefore
possesses at least one key that recovers the session key.

Every receiver outside \(P\) belongs to neither \(A\) nor \(B\), because

\[
A\cup B=P.
\]

Thus outside receivers do not receive either covering subset key in the direct
key-distribution model.

---

### 11.2.3 Security boundary

Under:

1. independently sampled long-lived catalog keys;
2. a standard secure symmetric encryption / key-encapsulation mechanism;
3. no compromise of privileged receivers;

a coalition consisting solely of receivers outside the privileged set has no
covering subset key and therefore cannot recover the fresh session key except
by breaking the underlying encryption.

This is the ordinary security logic of direct subset-key broadcast encryption.

CCM contributes the exact catalog construction and resource optimum.

CCM does **not** introduce a new cryptographic hardness assumption.

---

The application is deliberately limited. The mathematics gives exact catalog-size and cover-size resource statements under the stated model. It does not introduce a new cryptographic hardness assumption, does not prove universal broadcast-encryption optimality, and does not replace a full security analysis of an implementation.

## 11.3 Two-cover catalog tradeoff for the pointed family

Let

\[
V=\{z\}\cup[n].
\]

Let \(Q_n\) be the pointed family from Theorem A, now interpreted as a family of
supported recipient sets.

A catalog is a set family

\[
\mathcal C\subseteq2^V.
\]

Every policy \(P\in Q_n\) must be representable as the union of at most two
catalog subsets.

Define

\[
\delta_2(Q_n)
=
\min |\mathcal C|.
\]

The empty set need not be stored because the cover may use one or two actual
catalog subsets.

---

Every singleton target forces its singleton to belong to \(\mathcal C\).

Thus the \(n+1\) singleton subsets are mandatory.

Every pair target is then automatically covered by its two singletons.

For a pointed triple

\[
\{z,u,v\},
\]

three singletons would require three catalog subsets, which violates the
two-cover limit.

Therefore at least one two-element subset of that triple must be present, unless
the triple itself is stored.

Any stored triple can be replaced, at the same catalog cost, by one of its
constituent pairs. The replacement still covers that triple and cannot reduce
coverage of any smaller target.

Hence an optimum exists consisting of:

1. all \(n+1\) mandatory singletons; and
2. a set of pair-edges meeting every triangle:
   \[
   zuv.
   \]

The catalog problem has become an exact graph hitting problem.

---

Let \(H\) be the graph of selected pair-sets.

Define

\[
S=\{u\in[n]:zu\notin E(H)\}.
\]

If

\[
u,v\in S,
\]

then neither \(zu\) nor \(zv\) is selected.

To hit triangle \(zuv\), the edge \(uv\) is therefore mandatory.

Consequently:

\[
\binom S2\subseteq E(H).
\]

Conversely, the graph consisting only of

\[
\{zu:u\notin S\}
\]

together with

\[
\binom S2
\]

hits every pointed triangle.

Every additional edge is unnecessary for feasibility and can only increase
catalog size and direct incidence load.

Thus every Pareto optimum has a canonical representative parameterized by

\[
s=|S|.
\]

---

For fixed \(s\),

\[
|E(H)|
=
n-s+\binom s2.
\]

Including the \(n+1\) mandatory singletons gives:

\[
\boxed{
C_n(s)
=
2n+1-s+\binom s2.
}
\]

The edge count

\[
n-s+\binom s2
\]

is minimized at:

\[
s=1
\quad\text{or}\quad
s=2,
\]

where it equals:

\[
n-1.
\]

Therefore:

\[
\boxed{
\delta_2(Q_n)=2n,
\qquad n\ge3.
}
\]

So, under the unrestricted one-catalog / at-most-two-cover model, the pointed
policy family needs exactly \(2n\) long-lived subset entries.

A concrete optimum is obtained by choosing two ordinary users \(a,b\),
omitting \(za,zb\), storing the pair \(ab\), and storing \(zu\) for every other
ordinary user \(u\), in addition to all singletons.

---

Assume the simplest direct-key realization: every receiver directly stores the
long-lived key of each catalog subset containing it.

For the canonical catalog determined by \(S\):

- the distinguished receiver \(z\) occurs in:
  \[
  1+n-s
  \]
  catalog subsets;
- each receiver in \(S\) occurs in:
  \[
  1+(s-1)=s
  \]
  catalog subsets;
- each ordinary receiver outside \(S\) occurs in exactly:
  \[
  2
  \]
  catalog subsets.

Hence the worst direct-key load is:

\[
\boxed{
K_n(s)
=
1+\max\{n-s,s-1\}.
}
\]

The complete exact catalog/storage tradeoff is therefore:

\[
\boxed{
\left(
C_n(s),K_n(s)
\right)
=
\left(
2n+1-s+\binom s2,\;
1+\max\{n-s,s-1\}
\right).
}
\]

No search or heuristic is required.

---

For \(n\ge3\), the undominated portion is obtained by

\[
2\le s\le
\left\lfloor\frac{n+1}{2}\right\rfloor.
\]

At:

\[
s=2,
\]

catalog size is minimum:

\[
2n,
\]

and worst direct-key load is:

\[
n-1.
\]

At the balanced end,

\[
s=
\left\lfloor\frac{n+1}{2}\right\rfloor,
\]

the minimum achievable worst direct-key load is:

\[
\boxed{
\left\lceil\frac{n+1}{2}\right\rceil.
}
\]

Thus the model exposes an exact bandwidth-fixed storage tradeoff.

The cover size remains at most two throughout the entire frontier.

---

Suppose the engineering constraint is:

\[
\text{every receiver stores at most }K\text{ direct catalog keys}.
\]

Feasibility requires:

\[
\boxed{
K\ge
\left\lceil\frac{n+1}{2}\right\rceil.
}
\]

For

\[
\left\lceil\frac{n+1}{2}\right\rceil
\le
K
\le
n-1,
\]

the smallest feasible canonical parameter is:

\[
s=n-K+1,
\]

and the exact minimum catalog size on this frontier is:

\[
\boxed{
C_{\min}(n,K)
=
n+K+
\binom{n-K+1}{2}.
}
\]

For:

\[
K\ge n-1,
\]

the absolute minimum catalog size:

\[
\boxed{2n}
\]

is already achievable.

---

## 11.4 Relationship to neighboring mathematics

The following areas are treated as established neighboring mathematics rather than as CCM inventions:

- Set Basis;
- Boolean Basis;
- set-wise union;
- Boolean rank and Boolean matrix factorization;
- biclique cover;
- semilattice generation;
- monotone satisfying-assignment formulations;
- graph transversal and vertex cover;
- subset-cover broadcast encryption.

The closest theorem-level comparisons used for this public draft are summarized below.

A particularly close structural predecessor is Frankl's two-family set-wise-union theory [1].

Peter Frankl explicitly defines and studies the set-wise union of two families [1]:

\[
\mathcal F\vee\mathcal G
=
\{F\cup G:F\in\mathcal F,G\in\mathcal G\}.
\]

This is exactly the operation appearing in Theorem A.

Therefore **set-wise union itself is not claimed new**.

The theorem-level distinction is the direction of optimization.

Frankl's main questions have the form:

\[
\text{given structured }\mathcal F,\mathcal G,
\quad
\text{bound }|\mathcal F\vee\mathcal G|.
\]

Theorem A asks:

\[
\text{given the pointed target }Q_n,
\quad
Q_n\subseteq\mathcal F\vee\mathcal G,
\quad
\min(|\mathcal F|+|\mathcal G|).
\]

A Frankl-style inequality:

\[
|\mathcal F\vee\mathcal G|
\ge
c(|\mathcal F|+|\mathcal G|)
\]

does not produce the needed sharp lower bound on input cost.

The generic product-cardinality inequality:

\[
|\mathcal F\vee\mathcal G|
\le
|\mathcal F||\mathcal G|
\]

does give a lower bound, but since:

\[
|Q_n|=n^2+n+2,
\]

it yields only:

\[
|\mathcal F|+|\mathcal G|
\ge
2\sqrt{n^2+n+2},
\]

which is asymptotically \(2n\), not \(3n-1\).

Thus the closest known set-wise-union theorems do not routinely imply
Theorem A.

---

The product audit promotes:

- Valerie L. Watts, *Boolean rank of Kronecker products* (2001) [6];
- Ishay Haviv and Michal Parnas, *Upper bounds on the Boolean rank of Kronecker products* (2022) [7];
- the associated nondeterministic-communication/direct-sum lineage.

These results establish that nontrivial product-rank behavior and failure of
simple multiplicativity are known phenomena.

Accordingly, no novelty credit is assigned merely to:

\[
\text{“composition changes the optimum.”}
\]

The remaining difference is the invariant and objective:

- Boolean rank counts rectangles/bicliques;
- Theorem A counts total memberships in two position-specific set-union
  libraries.

No routine objective-preserving translation was found.

---

The re-audit includes:

- Stockmeyer Set Basis [2];
- Kou–Wong Set Basis [3];
- Lubiw Boolean Basis [5];
- Gligor–Maier augmented-set basis [4];
- strict group testing / Set Basis;
- biclique and Boolean-rank lineages.

The relevant distinction is:

\[
\boxed{
\text{one reusable basis}
\neq
\text{two separately costed resource libraries}.
}
\]

The augmented-set-basis comparison is treated as neighboring prior art rather than evidence of novelty [4].

---

Theorem A was searched under:

- Set Basis;
- Boolean Basis;
- Boolean matrix factorization / Boolean rank;
- biclique cover / bipartite dimension;
- minimum monotone satisfying assignment;
- strict group testing;
- nondeterministic communication complexity;
- hypergraphs;
- semilattice generation;
- set-wise union;
- cross-union;
- augmented/disjoint set basis;
- Boolean-rank Kronecker products;
- sumsets and additive complements;
- union products and union-closed-family factorization.

Historical/multilingual probes and OEIS fingerprints were included.

No equivalent theorem or stronger routine specialization was found.

---

The strongest skeptical case is:

> Theorem A might be an overlooked inverse factorization theorem for the
> established set-wise-union operation \(\mathcal F\vee\mathcal G\), perhaps
> under old Set-Basis, augmented-basis, extremal-set, or matrix-factorization
> terminology. Frankl's theory proves nontrivial results for the exact
> operation, and Boolean-rank Kronecker-product theory already proves
> nontrivial product behavior. Therefore neither the operation nor the phrase
> “product interaction” is new.

This objection is accepted as the strongest current attack.

---

The smallest claimed theorem is only:

\[
\boxed{
\min\{
|\mathcal F|+|\mathcal G|:
Q_n\subseteq\mathcal F\vee\mathcal G,\;
\varnothing\in\mathcal F\cap\mathcal G
\}
=
3n-1.
}
\]

Every closest predecessor found differs in a theorem-essential dimension:

- forward output-size bound vs inverse input-cost minimum;
- one basis vs two resource positions;
- arbitrary-subcollection unions vs one cross choice;
- rectangle count vs library-membership cost;
- universal cross-pair restriction vs existential target coverage;
- generic product statement vs exact pointed family.

No predecessor found implies the theorem by a routine substitution,
dualization, restriction, product identity, or generic cardinality bound.

The theorem-specific ownership/complement argument remains essential.

---

## 11.5 Conservative novelty statement

The public claim is limited to the exact theorem:

\[
\boxed{
\min\{|\mathcal F|+|\mathcal G|:
Q_n\subseteq\mathcal F\vee\mathcal G,
\ \varnothing\in\mathcal F\cap\mathcal G\}
=3n-1,
\qquad n\ge3.
}
\]

The theorem-level search record summarized in Appendix D did not find an earlier equivalent statement, a stronger theorem routinely specializing to it, or a routine translation that yields the formula. This is evidence supporting a provisional theorem-level novelty claim, not a proof of historical priority.

## 11.6 Verified neighboring literature used in this public draft

For this public draft, the bibliographic metadata for the principal neighboring works was independently checked against publisher, author, or archival records on August 18, 2026. The resulting references are listed in the References section.

The closest directly relevant items used for positioning are:

- Frankl's exact two-family set-wise-union operator and inequalities [1];
- the classical Set Basis lineage of Stockmeyer and Kou–Wong [2,3];
- augmented-set basis work of Gligor and Maier [4];
- Lubiw's Boolean Basis formulation [5];
- Boolean-rank Kronecker-product results of Watts and Haviv–Parnas [6,7];
- the Subset-Cover framework of Naor, Naor, and Lotspiech for the cryptographic application layer [8].

These references establish neighboring objects, operations, and optimization problems. They are not presented as implying Theorem 5.1. The theorem-level novelty statement remains the narrower one in Section 11.5.

# Chapter 12 — Open Problems and Research Program

The problems below are research directions generated by the present theory. “Open” here means **not resolved by the results of this monograph**. Before asserting that any item is historically open in the wider literature, a dedicated literature review should be performed in the corresponding neighboring formulation.

## 12.1 Higher rank and higher target depth — *Frontier*

**Problem.** Determine

\[
\boxed{\beta_r(B(n,\le k))}
\]

for broader parameter ranges \((r,k)\).

**Known here.** The monograph proves the exact rank-two value \(\beta_2(B(n,\le2))=2n\).

**Closest neighboring mathematics.** Classical Set Basis and Boolean Basis study reusable union-generation problems in broader forms [2–5].

**What remains.** Derive exact formulas, asymptotics, or structural lower bounds that genuinely use the position-sensitive \(r\)-library objective rather than reducing the question to an established one-library basis problem.

## 12.2 Higher-control products — *Frontier*

**Problem.** Determine exact or asymptotic laws for

\[
\boxed{\beta_r(B(n,\le k)\times C_m).}
\]

**Known here.** For \(r=2\), \(k=2\), and the two-state factor \(C_2\), Theorem 5.1 gives \(3n-1\).

**Closest neighboring mathematics.** Boolean-rank product and Kronecker-product phenomena are established [6,7], but use a different invariant and cost model.

**What remains.** Identify which higher controls preserve linear interaction, create thresholds, or lead to different asymptotic regimes.

## 12.3 Zero-interaction characterization — *Intermediate/Frontier*

**Problem.** Characterize target pairs satisfying

\[
\boxed{\iota_r(T,U)=0.}
\]

**Known here.** Theorem 3.1 proves \(\iota_r(T,U)\ge0\), and Theorem 5.1 supplies a family with strictly positive, linearly growing interaction.

**Closest neighboring mathematics.** The conceptual neighbors are exact additivity and product laws for other rank, cover, and basis invariants, including Boolean-rank product theory [6,7].

**What remains.** Find necessary and sufficient structural conditions for exact additivity, then distinguish bounded, linear, and superlinear interaction regimes.

## 12.4 Graph-polarized exact laws — *Intermediate*

**Problem.** For the graph-parametrized pointed family \(Q(G)\), determine

\[
\boxed{\beta_2(Q(G))}
\]

in terms of graph invariants.

**Known here.** Chapter 8 solves the position-free catalog quantity

\[
\delta_2(Q(G))=n+1+\tau(G),
\]

and Theorem 5.1 solves the polarized complete-graph specialization \(G=K_n\).

**Closest neighboring mathematics.** Vertex cover and related graph-transversal problems govern the unpolarized model.

**What remains.** Determine which graph invariants control the additional positional cost introduced by polarization.

## 12.5 Hypergraph-pointed analogues — *Frontier*

**Problem.** Replace graph edges by higher-order hyperedges and define pointed targets whose required higher sets correspond to those hyperedges.

**Known here.** Graph edges generate pointed triples in \(Q(G)\).

**Closest neighboring mathematics.** Hypergraph transversals, coverings, and extremal set systems provide the natural established comparison class.

**What remains.** Determine exact catalog and polarized-library laws and identify when they reduce to familiar transversal parameters.

## 12.6 Complexity classification — *Intermediate*

**Problem.** Classify the computational complexity of evaluating \(\beta_r(T)\) on natural restricted families of semilattices and down-sets.

**Known here.** Finite explicit witness systems have exact 0–1 optimization formulations, and several structured families admit closed forms.

**Closest neighboring mathematics.** Set Basis is NP-complete [2,3]; augmented-set-basis optimization is also computationally hard [4].

**What remains.** Separate polynomial-time CCM families from NP-hard ones and identify useful parameterizations.

## 12.7 Approximation theory — *Intermediate*

**Problem.** When exact evaluation is hard, determine approximation ratios and parameterized algorithms compatible with the polarized cost model.

**Known here.** Exact formulas eliminate approximation on the flagship, pointed-clique-certificate, and graph-catalog families developed above.

**Closest neighboring mathematics.** Approximation hardness is known for augmented-set-basis variants [4].

**What remains.** Determine whether polarization creates different approximation thresholds or fixed-parameter structure from one-library basis problems.

## 12.8 Optimality-cell structure — *Intermediate*

**Problem.** Characterize all targets that share a fixed optimal constructor.

**Known here.** Chapter 7 exhibits an exact cell of size

\[
3^{n-2}
\]

around the flagship constructor.

**Closest neighboring mathematics.** The closest general themes are sensitivity regions and families of instances sharing an optimum in combinatorial optimization; no claim of a unique established analogue is made here.

**What remains.** Find intrinsic conditions describing the full cell of a constructor and determine adjacency or inclusion relations among cells.

## 12.9 Product-law classification — *Frontier*

**Problem.** Identify natural target classes for which product costs admit closed forms or sharp universal inequalities.

**Known here.** Theorem 3.1 gives a universal lower bound and Theorem 5.1 gives one exact nonadditive infinite family.

**Closest neighboring mathematics.** Product behavior of Boolean rank provides a clear comparison point [6,7].

**What remains.** Develop a taxonomy of exact additive, bounded-defect, and growing-defect product families for \(\beta_r\).

## 12.10 Duality — *Frontier*

**Problem.** Determine whether polarized construction theory has a natural dual formulation that yields new exact theorems rather than merely re-encoding the primal optimization problem.

**Known here.** The current theory is formulated entirely through generators, joins, and resource libraries.

**Closest neighboring mathematics.** Lattice duality, covering/packing dualities, and mathematical-programming duality are natural comparison classes, but no dual CCM theorem is assumed from them.

**What remains.** Identify a dual object with theorem-level content and prove a nontrivial correspondence or min–max law.

# References

[1] Peter Frankl. “Best possible bounds concerning the set-wise union of families.” *European Journal of Combinatorics* **69** (2018), 1–6. The paper defines
\(\mathcal F\vee\mathcal G=\{F\cup G:F\in\mathcal F, G\in\mathcal G\}\) and studies inequalities for its size.

[2] Larry J. Stockmeyer. *The Set Basis Problem is NP-Complete*. IBM Research Report RC5431, IBM Thomas J. Watson Research Center, 1975.

[3] Lawrence T. Kou and C. K. Wong. “A note on the set basis problem related to the compaction of character sets.” *Communications of the ACM* **18** (1975), 656–657. DOI: `10.1145/361219.361225`.

[4] Virgil D. Gligor and David Maier. “Finding Augmented-Set Bases.” *SIAM Journal on Computing* **11**(3) (1982), 602–609. DOI: `10.1137/0211051`.

[5] Anna Lubiw. “The Boolean Basis Problem and How to Cover Some Polygons by Rectangles.” *SIAM Journal on Discrete Mathematics* **3**(1) (1990), 98–115. DOI: `10.1137/0403010`.

[6] Valerie L. Watts. “Boolean rank of Kronecker products.” *Linear Algebra and its Applications* **336** (2001), 261–264. DOI: `10.1016/S0024-3795(01)00338-X`.

[7] Ishay Haviv and Michal Parnas. “Upper bounds on the Boolean rank of Kronecker products.” *Discrete Applied Mathematics* **318** (2022), 82–96. DOI: `10.1016/j.dam.2022.04.001`. Preprint: arXiv:2102.07486.

[8] Dalit Naor, Moni Naor, and Jeff Lotspiech. “Revocation and Tracing Schemes for Stateless Receivers.” In Joe Kilian (ed.), *Advances in Cryptology — CRYPTO 2001*, Lecture Notes in Computer Science 2139, Springer, 2001, 41–62. DOI: `10.1007/3-540-44647-8_3`.

---

# Appendix A — Auxiliary Proof and Proof-Audit Notes

The public mathematical spine is intended to be self-contained. The following proof-risk items identified during conversion from the v562 master were explicitly addressed in this draft.

| Item | Public treatment | Draft status |
|---|---|---|
| Definition of zero-axis fibers in Theorem 3.1 | Added before first use | closed |
| \(\beta_2(B(n,\le2))=2n\) internal dependency | Full proof supplied as Theorem 4.1 | closed |
| Pair-normal-form replacement | Feasibility and cost preservation stated in Chapter 5 | closed for authorial draft; external review pending |
| Pointed complement extremal lemma | Case structure retained with explicit integer ranges | closed for authorial draft; external review pending |
| Matching-constructor pointed-triple coverage | Expanded to an exhaustive case split | closed |
| Boundary values \(n=1,2\) | Explicitly separated from Theorem 5.1 | closed |
| Graph-catalog reduction | Vertex-cover equivalence stated explicitly | closed for authorial draft |
| Countable eventual exactness | Finite-target, finite-witness, finite-attained-support assumptions stated | closed |

This table is an authorial proof audit, not a substitute for independent peer review.

---

# Appendix B — Computational Verification Record

The v562 source reports:

1. exact finite optimization values
   \[
   4,6,8,11,14,17
   \]
   for \(n=1,\ldots,6\);
2. agreement with \(3n-1\) for \(n=3,\ldots,6\);
3. explicit constructor verification through \(n=100\);
4. randomized checks of exact optimality-cell recognition in later utility code.

These computations are corroboration only. Theorem 5.1 is analytic and does not depend on finite computation.

For an archival public release, the exact scripts, solver version, runtime environment, commands, input files, and output hashes should be frozen alongside the PDF.

---

# Appendix C — Algorithm Specifications

## C.1 Optimal constructor for \(Q_n\)

**Input:** integer \(n\ge3\); distinct ordinary vertices \(x,y_1,y_2\in[n]\).  
**Output:** optimal polarized libraries \((\mathcal X,\mathcal Y)\).

```text
H <- [n] \ {x,y1,y2}
X <- {empty, {z}, {x}, {z,x}}
Y <- {empty, {y1}, {y2}, {y1,y2}}
for h in H:
    add {h} to X
    add {z,h} to X
    add {h} to Y
return (X,Y)
```

Correctness is Theorem 5.1. The total number of stored memberships is \(3n-1\), and construction time is \(O(n)\) set insertions.

## C.2 Pointed-clique certificate

**Input:** finite down-set \(T\subseteq2^{[d]}\).  
**Output:** a certified lower bound on \(\beta_2(T)\).

```text
best <- 0
for z in [d]:
    build G_z(T) on [d] \ {z}
    put edge uv iff {z,u,v} is in T
    k <- size of a maximum clique in G_z(T)
    best <- max(best,k)
if best >= 3:
    return 3*best - 1
else:
    return the applicable small-case bound
```

The mathematical certificate is the clique itself. Finding a maximum clique may be computationally hard on unrestricted graphs; any exhibited clique still gives a valid lower bound.

## C.3 Exact graph two-cover catalog from a vertex cover

**Input:** finite graph \(G=(V,E)\), a minimum vertex cover \(C\).  
**Output:** an optimal at-most-two-cover catalog for \(Q(G)\).

```text
Catalog <- all singletons {v} for v in V union {z}
for u in C:
    add {z,u} to Catalog
return Catalog
```

By Theorem 8.1, the catalog has size \(|V|+1+\tau(G)\) and is optimal.

## C.4 Finite witness MILP

For one binary variable \(x_{i,r}\) per reusable resource and one binary activation variable \(y_w\) per witness tuple \(w\):

- impose \(y_w\le x_{i,r_i(w)}\) for every resource used by witness \(w\);
- impose \(\sum_{w\in W_t}y_w\ge1\) for every target \(t\);
- minimize the additive selected-resource cost.

The formulation is exact for the finite witness model of Proposition 9.1.

## C.5 Progressive countable optimization

```text
for N = 1,2,3,...:
    build finite snapshot P_N
    solve P_N exactly
    record OPT_N
    verify OPT_N <= OPT_(N-1) whenever both are finite
    if an independent full-problem lower bound L is known and OPT_N = L:
        certify global exactness and stop
```

Repeated equal finite optima without a matching full-problem lower bound are empirical stability, not a proof of stabilization.

---

# Appendix D — Prior-Art and Novelty Audit

The public novelty claim is limited to Theorem 5.1. The framework deliberately does **not** claim novelty for ordinary union, set-wise union, Set Basis, Boolean Basis, Boolean rank, biclique cover, vertex cover, MILP, or subset-cover broadcast encryption.

A normalized statement of the flagship claim is

\[
\boxed{
\min\{|\mathcal F|+|\mathcal G|:
Q_n\subseteq\mathcal F\vee\mathcal G,
\ \varnothing\in\mathcal F\cap\mathcal G\}
=3n-1,
\quad n\ge3.
}
\]

The closest public comparison points used in this draft are summarized below.

| Neighbor | Native object/objective | Relationship to CCM | Routine implication of Theorem 5.1 located? |
|---|---|---|---|
| Frankl [1] | bounds on \(|\mathcal F\vee\mathcal G|\) for given families | exact same two-family union operation | no |
| Stockmeyer; Kou–Wong [2,3] | minimum reusable Set Basis | nearby inverse union-generation problem | no |
| Gligor–Maier [4] | augmented-set bases | nearby basis optimization | no |
| Lubiw [5] | Boolean/set basis | nearby reusable basis formulation | no |
| Watts [6] | Boolean rank under Kronecker product | product behavior of a different invariant | no |
| Haviv–Parnas [7] | Boolean rank under Kronecker product | product behavior of a different invariant | no |
| Naor–Naor–Lotspiech [8] | subset-cover revocation catalogs | application framework only | not applicable |

The strongest skeptical interpretation remains that Theorem 5.1 could be an overlooked inverse-factorization theorem in an older set-basis or set-wise-union language. This draft therefore uses the restrained statement: **to the best of the literature search and theorem-level comparison performed, no earlier equivalent theorem or routine stronger specialization has been located.** Historical priority is not claimed as proven.

---

## D.1 Terminology-collision check

The names used in this monograph are descriptive labels, not independent novelty claims. Before a formal journal submission they should be checked again against the terminology of the target field.

| Term used here | Collision risk | Public convention in this draft |
|---|---|---|
| polarized basis | “basis” is heavily overloaded across mathematics; “polarized” also has established uses | always defined as an ordered tuple of position-sensitive resource families; never used without the definition nearby |
| normalized product interaction | “interaction” is generic and used in many fields | used only for the explicit additivity-defect formula \(\iota_r\); no novelty assigned to the word |
| constructor | common in computer science and constructive mathematics | used informally for an explicit feasible resource-library construction |
| pointed target | “pointed” is standard descriptive terminology | means a target with distinguished element \(z\); no new-object claim attached |
| optimality cell | similar phrases occur in parametric optimization | used descriptively for targets sharing a fixed certified optimum; no terminology novelty claimed |
| witness system | generic term | explicitly classified as a utility layer, not a new mathematical primitive |
| construction complexity | potentially confusable with complexity theory | used only when the relevant cost model is stated explicitly |

If external reviewers identify a material terminology conflict, terminology should be changed before Version 1.0 is archived as the canonical public release. Mathematical statements should not depend on branding.

---

# Appendix E — Source Provenance and Internal-to-Public Crosswalk

This monograph is reorganized from the `Constructible_Computation_Mathematics_v562_FINAL_MASTER` source. Internal pass numbering, usefulness scorecards, loop-completion language, and project-management history have been removed from the main mathematical narrative.

## E.1 Source-to-public conversion matrix

| v562 material | Mathematical role | Public disposition | Destination |
|---|---|---|---|
| polarized-basis and \(\beta_r\) definitions | foundation | retained and normalized | Chapter 2 |
| zero-axis product lower bound | supporting theorem | retained with public numbering and missing fiber definitions supplied | Chapter 3 |
| \(\beta_2(B(n,\le2))=2n\) | prerequisite theorem | retained; unpublished dependency removed by full proof | Chapter 4 |
| product-to-pointed representation | structural equivalence | retained with explicit explanation | Chapter 4 |
| R-PBI-002 | flagship theorem | retained and rewritten as Theorem 5.1 | Chapter 5 |
| pair normal form and complement-graph machinery | proof engine | retained and expanded | Chapter 5 |
| explicit optimal constructor | upper bound / algorithm | retained; coverage expanded | Chapters 5 and 10 |
| interaction formula | corollary | retained | Chapter 6 |
| local/global preference reversal | supporting exact phenomenon | retained selectively | Chapter 6 |
| transfer and optimality-cell results | derived theory | retained | Chapter 7 |
| graph-parametrized catalog results | derived exact theory | retained | Chapter 8 |
| finite/countable witness systems | utility theory | retained with scope boundaries | Chapter 9 |
| engineering and cryptographic interpretations | applications | retained selectively with external assumptions stated | Chapter 11 |
| prior-art/Guardrails audit | provenance and positioning | removed from proof narrative; condensed | Appendix D |
| sequential passes, X-status, usefulness scores | project-management history | excluded from main monograph | provenance archive only |
| conflicting Python benchmark paragraph | application data | not asserted | Appendix F discrepancy record |

No source block is treated as public merely because it existed in v562; it is classified, checked, and rewritten according to its mathematical role.

Two public-proof completions were added during conversion:

1. a direct proof of \(\beta_2(B(n,\le2))=2n\), because v562 states the theorem but points to an earlier internal version for its proof;
2. an exhaustive pointed-triple coverage split for the matching constructor, replacing a compressed sentence in v562.

These additions are proof/exposition completions, not new novelty claims.

| Internal identifier in v562 | Public role |
|---|---|
| R-PBI-001 | Theorem 3.1 / `CCM-STRUCT-001` |
| R-PBI-002 | Theorem 5.1 / `CCM-PRODUCT-001` |
| R-PBI-003 | Corollary 6.1 / `CCM-PRODUCT-002` |
| R-PBI-L1 | Lemma 5.1 |
| R-PBI-L2 | Lemma 5.2 |
| R-PBI-008 | Supporting local/global reversal in Chapter 6 |
| U-PASS 5425–5431 | Chapter 7 transfer and optimality-cell theory |
| U-PASS 5440–5447 | Chapter 11 two-cover catalog theory |
| U-PASS 5460–5468 | Chapter 8 graph-parametrized theory |
| U-PASS 5451–5454, 5476–5479 | Chapter 9 witness-system theory |

---

# Appendix F — Extended Applications and Source Discrepancy

One application benchmark in v562 contains conflicting figures. Its graph table reports, for a 60-vertex Python dependency graph,

\[
n=60,\qquad |E|=178,\qquad \alpha(G)=30,
\]

with exact two-cover catalog size \(91\) and \(2069\) supported nonempty policies. A later prose paragraph in the same source instead reports \(101\) bundles and \(2304\) supported targets while attaching the same percentage reduction. These statements are mutually inconsistent.

This monograph does not silently select one as correct. The disputed benchmark should not be used as publication evidence until the original code/data reproduce a single consistent result.

The mathematical graph theorem itself is independent of this application-data discrepancy.

---

# Appendix G — Version, Errata, Citation, and Publication Metadata

## G.1 Version record

**Version 1.0 — August 18, 2026.** First reader-facing monograph draft reorganized from CCM v562 under the final monograph plan.

No public errata are recorded at the time of this draft. Later releases should preserve earlier versions and record any material theorem correction explicitly rather than silently changing a stable theorem identifier.

## G.2 Stable theorem identifiers

Major results use stable identifiers such as `CCM-PRODUCT-001`. A materially changed theorem statement must receive a new stable identifier.

## G.3 Suggested citation for this draft

Damir Olejar, *Constructible Computation Mathematics: Foundations, Product Laws, and Optimal Constructors*, Version 1.0, August 18, 2026.

A DOI or archival identifier should replace the version-only citation when a permanent public archive is created.

A provisional BibTeX record for the unarchived draft is:

```bibtex
@book{Olejar2026CCM,
  author = {Damir Olejar},
  title = {Constructible Computation Mathematics: Foundations, Product Laws, and Optimal Constructors},
  year = {2026},
  month = {August},
  note = {Version 1.0, draft dated August 18, 2026}
}
```

When a persistent archive DOI exists, the BibTeX record should be replaced by the archived citation and the exact release version should remain immutable.

## G.4 Authorship and responsibility

Damir Olejar is the named author of this monograph and is responsible for the mathematical claims in the public release. Computational and automated drafting/verification tools may assist preparation but do not replace author responsibility for correctness.

## G.5 Licensing

Copyright © 2026 Damir Olejar. All rights reserved for this draft. Any later open manuscript, code, or data license should be stated explicitly for the corresponding archived artifact.

## G.6 Archival release package

The canonical public release should freeze the following alongside the PDF:

```text
/monograph
    CCM_monograph_v1.0.pdf
    CCM_monograph_v1.0.tex
/bibliography
    references.bib
/code
    verification and constructor scripts
/data
    exact verification inputs and outputs
/metadata
    theorem_register.csv
    manifest.json
    SHA256SUMS
    version_history.md
    README.md
```

The archive version cited by the PDF should be immutable. Later corrections should create a new release and preserve the earlier one.

## G.7 External-review status

This draft has not been represented as externally peer reviewed. The internal proof audit and prior-art comparison are preparatory steps for independent mathematical review, not substitutes for it.

---

# End of Monograph
