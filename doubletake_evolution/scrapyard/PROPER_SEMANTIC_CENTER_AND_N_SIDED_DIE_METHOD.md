# Proper Semantic Center and Perfect n-Sided Die Method

This document gives a repeatable procedure for taking **n semantic items**, finding or choosing a semantic Center, and placing the items onto a **perfectly symmetric n-outcome die** without destroying the chosen Center.

The method is generic. It can be used for runes, I Ching states, cards, concepts, texts, or any other set of semantic items.

---

## 1. Important geometric fact

A perfectly symmetric die with **n equivalent outcomes/faces** is represented by a **regular (n-1)-simplex**.

Examples:

- 4 outcomes -> regular 3-simplex (tetrahedron)
- 24 outcomes -> regular 23-simplex
- 64 outcomes -> regular 63-simplex

So:

\[
n\text{ outcomes} \Longrightarrow (n-1)\text{-dimensional regular simplex}
\]

The simplex may be stored in a higher-dimensional coordinate system, but its intrinsic dimension is always \(n-1\).

For a die interpretation, treat each semantic item as the **outward normal direction of one face**. For a regular simplex, those face-normal directions themselves form another regular simplex, so the same regular-simplex coordinates can be used directly.

---

# PART A — FINDING THE SEMANTIC CENTER

## 2. Embed every item in the same semantic space

Let the n source texts be:

\[
T_1,T_2,\ldots,T_n
\]

Embed them all with **the same embedding model and the same preprocessing**:

\[
x_1,x_2,\ldots,x_n \in \mathbb{R}^{d}
\]

Do not compare or combine vectors created by different embedding models or different fitted vector spaces.

If two different corpora will later share a Center, both corpora must be represented in the **same coordinate system**.

---

## 3. Normalize every item before finding the Center

If semantic similarity is being treated primarily through direction/cosine similarity, first normalize every embedding:

\[
u_i=\frac{x_i}{\|x_i\|}
\]

This prevents an item with an unusually large vector norm from contributing more strongly to the Center merely because of scale.

Every semantic item should have equal constitutional weight unless there is a deliberate reason to weight them differently.

---

## 4. Proper equal-weight semantic Center

For n equally important semantic items, use the equal-weight centroid:

\[
\boxed{
C=\frac{1}{n}\sum_{i=1}^{n}u_i
}
\]

This is the natural Center of the semantic system.

It has several useful properties:

1. Every item contributes equally.
2. It is invariant to the ordering of the items.
3. It minimizes total squared Euclidean distance to the normalized embeddings.
4. It is exactly the average of all pairwise segment midpoints.
5. It is naturally compatible with the Center of a regular simplex.

If all pairs of the n points are connected by finite line segments, the average of the midpoints of all those segments is exactly the same centroid.

Therefore there is no need to search for an approximate intersection of all pairwise infinite lines.

---

## 5. Do not use the infinite-line intersection center

A previous possible method is:

\[
\arg\min_C \sum_{i<j} d(C,L_{ij})^2
\]

where \(L_{ij}\) is the infinite line passing through points \(i\) and \(j\).

This is mathematically definable, but it is not the preferred semantic Center.

The semantic objects are n points, not infinite lines. In high-dimensional space the pairwise lines generally do not intersect, so the method produces a least-squares compromise that can be influenced by line orientations in unintuitive ways.

For an equal-status semantic system, use the normalized centroid instead.

---

# PART B — USING A CENTER THAT HAS ALREADY BEEN CHOSEN

## 6. A Center may be inherited from another system

Sometimes the Center is already fixed.

For example:

- System A establishes a Center.
- System B should be interpreted around exactly the same Center.

In that case, do not recompute the Center for System B.

Use:

\[
\boxed{C_{\text{chosen}}}
\]

directly.

However, \(C_{\text{chosen}}\) and the embeddings of System B must exist in the **same semantic coordinate system**.

If they were generated independently, rebuild or transform them into one common embedding basis first.

---

## 7. Two different operations must not be confused

### A. Use the chosen Center as the origin of System B

For every System B embedding:

\[
d_i=x_i-C_{\text{chosen}}
\]

This changes the semantic directions if the chosen Center differs from System B's own natural centroid.

This is appropriate when you explicitly want System B to be measured **relative to another system's Center**.

### B. Rigidly translate the whole System B constellation

If System B has its own Center \(C_B\), and you want to move the entire constellation without changing anything internally:

\[
\Delta=C_{\text{chosen}}-C_B
\]

then:

\[
x_i'=x_i+\Delta
\]

and:

\[
C_B'=C_B+\Delta=C_{\text{chosen}}
\]

This preserves exactly:

- every pairwise distance,
- every rune-to-center distance,
- every internal angle,
- the orientation of the entire constellation.

This operation changes only the **absolute location** of the constellation.

Use this operation only when the goal is literally to pick up the whole semantic object and place its Center at another Center.

---

# PART C — DERIVING SEMANTIC DIRECTIONS FROM THE CENTER

## 8. Subtract the chosen Center

For each item:

\[
d_i=x_i-C
\]

where \(C\) is either:

- the normalized equal-weight centroid found from the same corpus, or
- an explicitly chosen external Center in the same semantic space.

Then normalize each displacement:

\[
t_i=\frac{d_i}{\|d_i\|}
\]

The \(t_i\) are the **semantic target directions**.

At this point:

- the Center is fixed,
- each item has a direction away from that Center,
- but the items do not yet form a perfectly symmetric die.

Do not directly move each target direction independently into an arbitrary symmetric arrangement. That can silently introduce uncontrolled distortions.

Instead, construct the perfect die separately and then orient the entire die as one rigid object.

---

# PART D — CONSTRUCTING THE PERFECT n-SIDED DIE

## 9. Construct a canonical regular simplex

Create n unit vectors:

\[
s_1,\ldots,s_n
\]

such that:

\[
\|s_i\|=1
\]

and for every distinct pair:

\[
\boxed{
s_i\cdot s_j=-\frac{1}{n-1}
}
\]

These are the directions of a perfect regular \((n-1)\)-simplex.

They automatically satisfy:

\[
\sum_{i=1}^{n}s_i=0
\]

The angle between every pair is therefore:

\[
\boxed{
\theta=\arccos\left(-\frac{1}{n-1}\right)
}
\]

and every pairwise distance is identical:

\[
\boxed{
\|s_i-s_j\|=\sqrt{\frac{2n}{n-1}}
}
\]

for unit-radius simplex directions.

This is the exact symmetry condition.

---

## 10. Face interpretation

If each semantic item is supposed to be one **face of the die**, interpret each \(s_i\) as the direction from the Center toward the outward normal of face \(i\).

For a regular simplex:

- all faces are congruent,
- all face areas are equal,
- all dihedral angles are equal,
- all outcomes are geometrically equivalent,
- every outcome has equal probability in an ideal fair die.

No item receives a privileged geometric position.

---

# PART E — ORIENTING THE PERFECT DIE TOWARD THE SEMANTICS

## 11. Do not move individual die points independently

The perfect simplex geometry must remain frozen.

Only a **single global rotation** is allowed.

Let:

\[
S=
\begin{bmatrix}
s_1\\
\vdots\\
s_n
\end{bmatrix}
\]

and let the normalized semantic target directions be:

\[
T=
\begin{bmatrix}
t_1\\
\vdots\\
t_n
\end{bmatrix}
\]

Find an orthogonal matrix \(Q\) that best aligns the perfect simplex with the semantic directions:

\[
\boxed{
Q^*=\arg\min_{Q^TQ=I,\ \det(Q)=+1}
\|SQ-T\|_F^2
}
\]

This is the **proper orthogonal Procrustes problem**.

The determinant constraint

\[
\det(Q)=+1
\]

ensures that the operation is a true rotation rather than a reflection.

The rotated die is:

\[
S'=SQ^*
\]

Because \(Q^*\) is orthogonal, all original simplex geometry remains exact.

---

## 12. Optional minimax refinement

Ordinary Procrustes maximizes overall/average alignment.

If one semantic item fits much worse than the others, refine the rotation while still enforcing:

\[
Q^TQ=I,\qquad \det(Q)=+1
\]

to improve the worst-fitting item.

A useful objective is:

\[
\boxed{
\max_Q\min_i \cos(s_iQ,t_i)
}
\]

The important restriction is that **only the one global rotation may change**.

Never move a single face independently.

This preserves the perfect die.

---

# PART F — PLACING THE DIE AT THE CHOSEN CENTER

## 13. Choose one common radius

Choose a single radius \(r>0\).

Then the final absolute semantic position of each die direction is:

\[
\boxed{
p_i=C+r(s_iQ)
}
\]

where:

- \(C\) is the chosen semantic Center,
- \(r\) is the same for every item,
- \(s_iQ\) is the rotated perfect-simplex direction.

This is the final n-sided semantic die.

Every face is the same distance from the Center:

\[
\|p_i-C\|=r
\]

Every pair remains geometrically equivalent.

The Center itself remains:

\[
\boxed{C}
\]

and is not counted as one of the n faces.

Therefore the state system contains:

\[
\boxed{n\text{ face states}+1\text{ separate Center state}}
\]

---

# PART G — IF THE WHOLE FINISHED DIE MUST BE MOVED TO ANOTHER CENTER

## 14. Rigid center-to-center translation

Suppose a finished die has Center:

\[
C_A
\]

and must be moved so that its Center becomes:

\[
C_B
\]

without changing anything inside the die.

Compute:

\[
\Delta=C_B-C_A
\]

Then translate every die point:

\[
\boxed{
p_i'=p_i+\Delta
}
\]

and the Center:

\[
C_A'=C_A+\Delta=C_B
\]

This operation preserves the die exactly.

It does **not** change:

\[
\|p_i-p_j\|
\]

or:

\[
\|p_i-C_A\|
\]

or any angle.

This is the correct operation when the instruction is:

> Pick up the entire die and move it until its Center is exactly another Center.

Do not instead subtract the new Center from every original semantic embedding unless you intentionally want to change the semantic directions.

---

# PART H — REQUIRED VALIDATION

## 15. Verify the Center

For a Center computed from the corpus:

\[
C=\frac1n\sum_i u_i
\]

Confirm numerically that this is the stored Center.

For a Center inherited from another corpus, confirm that the exact intended Center vector was used and that both corpora share the same embedding coordinate system.

---

## 16. Verify perfect simplex geometry

For unit-radius die directions \(v_i\), verify:

### Equal radius

\[
\|v_i\|=1
\]

for every \(i\).

### Zero centroid

\[
\left\|\frac1n\sum_i v_i\right\|\approx0
\]

### Equal pairwise inner products

\[
v_i\cdot v_j\approx-\frac1{n-1}
\]

for all \(i\neq j\).

### Equal pairwise angles

\[
\angle(v_i,v_j)\approx
\arccos\left(-\frac1{n-1}\right)
\]

### Equal pairwise distances

\[
\|v_i-v_j\|\approx
\sqrt{\frac{2n}{n-1}}
\]

---

## 17. Verify the rotation

Confirm:

\[
Q^TQ\approx I
\]

and:

\[
\boxed{\det(Q)\approx+1}
\]

A determinant near \(-1\) means a reflection was used rather than a proper rotation.

---

## 18. Verify the final absolute positions

For:

\[
p_i=C+rv_i
\]

verify:

\[
\|p_i-C\|\approx r
\]

for every item.

If the entire die was translated from Center \(C_A\) to Center \(C_B\), also verify:

\[
C_A+\Delta=C_B
\]

and that pairwise distances before and after translation are numerically unchanged.

---

# PART I — COMPLETE REPEATABLE PROCEDURE

## 19. Procedure when the corpus defines its own Center

1. Clean one complete semantic text for each of the n items.
2. Embed all n texts with one shared embedding model.
3. L2-normalize each embedding.
4. Compute the equal-weight centroid:

\[
C=\frac1n\sum_i u_i
\]

5. Subtract the Center from every item.
6. Normalize the resulting semantic directions.
7. Construct an exact regular \((n-1)\)-simplex with n outcomes.
8. Treat the simplex vectors as die-face normal directions.
9. Find one proper global Procrustes rotation toward the semantic directions.
10. Optionally refine that one rotation to improve the worst-fitting item.
11. Choose one common radius.
12. Place the die at:

\[
p_i=C+r(s_iQ)
\]

13. Store the Center separately as state \(n+1\).
14. Validate all symmetry and rotation conditions.
15. Freeze the Center, radius, rotation and die together.

---

## 20. Procedure when another system already supplies the Center

1. Ensure both systems exist in the same semantic embedding space.
2. Obtain the fixed reference Center \(C_{\text{reference}}\).
3. Decide explicitly which operation is intended:

### If meanings should be measured relative to the reference Center

Use:

\[
x_i-C_{\text{reference}}
\]

before fitting the perfect die.

### If the complete existing die should merely be moved to the reference Center

Use the rigid translation:

\[
\Delta=C_{\text{reference}}-C_{\text{source}}
\]

\[
p_i'=p_i+\Delta
\]

4. Never mix these two operations accidentally.
5. Validate that the intended Center now matches exactly.
6. Preserve one common radius and one rigid simplex geometry.

---

# PART J — RULES THAT SHOULD NOT BE BROKEN

## 21. Non-negotiable rules

- **n outcomes require a regular (n-1)-simplex** for a perfectly symmetric simplex die.
- The Center is separate from the n outcomes.
- All semantic items must be embedded in one compatible coordinate system.
- Normalize embeddings before computing an equal-weight semantic centroid when cosine semantics are intended.
- Use the equal-weight centroid as the natural corpus Center.
- Do not use approximate intersections of pairwise infinite lines as the default Center.
- Do not independently move individual die faces.
- Construct the perfect simplex exactly first.
- Use only one global proper rotation to orient it semantically.
- Use the same radius for every face.
- A center-to-center move of an already finished die must be one common rigid translation.
- Never confuse rigid translation with redefining semantic directions relative to a different Center.
- Validate the final Gram matrix, centroid, radius, rotation determinant and pairwise distances numerically.

---

# Compact Formula

For a corpus that defines its own Center:

\[
u_i=\frac{x_i}{\|x_i\|}
\]

\[
\boxed{
C=\frac1n\sum_i u_i
}
\]

\[
t_i=\frac{u_i-C}{\|u_i-C\|}
\]

Construct regular-simplex directions \(s_i\) satisfying:

\[
s_i\cdot s_j=-\frac1{n-1}
\quad(i\neq j)
\]

Find:

\[
Q^*=\arg\min_{Q^TQ=I,\det Q=+1}
\sum_i\|s_iQ-t_i\|^2
\]

Then:

\[
\boxed{
p_i=C+r(s_iQ^*)
}
\]

This gives:

\[
\boxed{
\text{chosen semantic Center}
+
\text{perfectly symmetric n-outcome die}
+
\text{best rigid semantic orientation}
}
\]

without sacrificing the equality of any face.
