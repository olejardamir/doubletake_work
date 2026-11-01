# Semantic center and regular-simplex n-outcome mapping — distilled method

**Status:** historical mathematical construction, not validated semantic inference or DT capability. Original blob `af73a2d7f8ff939cfd4d7b567b70683413a30117` recoverable from Git history. Applies to n semantic texts (e.g., runes, cards, concepts) embedded in a **shared** vector space. "Perfect die" means a symmetric geometric n-outcome representation, **not** proof of physical or algorithmic probability calibration.

## 1. Natural equal-weight center
For nonzero embeddings `x_i∈R^d` from one model/preprocessing, set `u_i=x_i/||x_i||` if cosine direction is intended. The equal-weight center `C=(1/n)Σ_i u_i` minimizes total squared Euclidean distance to the normalized points, is permutation invariant and equals the average of pairwise midpoints for n≥2. It is generally **not** the intersection of infinite pairwise lines (which need not intersect in high dimensions). Deliberate unequal weighting is a separate design choice.

For a chosen external center `C_ref`, all corpora must use compatible coordinates. Distinguish:
- **Re-reference semantics:** `d_i=u_i-C_ref`, `t_i=d_i/||d_i||`, changing relative directions.
- **Rigidly move an existing constellation:** with own center `C_B`, `Δ=C_ref-C_B`, `x'_i=x_i+Δ`. This preserves pairwise distances/angles and relative center distances. Do not confuse the two operations.

## 2. Exact regular-simplex geometry
For n≥2, construct n unit directions `s_i` in at least n−1 dimensions with `s_i·s_j=−1/(n−1)` for all i≠j, `Σ_i s_i=0`. Intrinsic dimension is n−1 (4 outcomes → 3-simplex; 24 → 23-simplex; 64 → 63-simplex). Pairwise distance `sqrt(2n/(n−1))`, angle `arccos(−1/(n−1))`. The face-normal directions of a regular simplex also form a regular simplex up to orientation. A center is an additional separate state, not one of the n outcomes.

Use `t_i=(u_i-C)/||u_i-C||` for the corpus-defined center, or `t_i=(u_i-C_ref)/||u_i-C_ref||` for a chosen center. A zero displacement makes direction undefined and must be rejected/handled explicitly. If embedding dimension d<n−1, a full regular (n−1)-simplex cannot be embedded in that space without additional dimensions; embedding-space augmentation changes the semantic alignment problem and requires a declared mapping.

## 3. One rigid semantic alignment
Let S have rows `s_i` and T rows `t_i`, in the same ambient dimension. Find a single **proper orthogonal Procrustes** rotation
`Q*=argmin_{QᵀQ=I, det(Q)=+1} ||SQ−T||²_F`.
A reflection (`det Q=−1`) is excluded. Optional minimax refinement may maximize `min_i cos(s_i Q,t_i)` subject to the same rotation constraint. Do **not** independently move faces: that would destroy simplex symmetry.

Choose one radius r>0; final positions `p_i=C+r(s_iQ*)`. Each has distance r from C and the pairwise Gram matrix remains the regular-simplex Gram matrix. To move a completed die from center `C_A` to `C_B`, translate **every** `p_i` by `Δ=C_B−C_A`; do not recompute semantic directions unless intended.

## 4. Required reproducibility/negative tests
Freeze exact item texts, preprocessing, embedding model/version, vectors, center choice, radius, correspondence/permutation, rotation, and numeric tolerance. Verify center equality; `||s_iQ||≈1`; `Σ_i s_iQ≈0`; pairwise inner products `≈−1/(n−1)`, distances `≈sqrt(2n/(n−1))`; `QᵀQ≈I`, `det Q≈+1`; `||p_i−C||≈r`; and invariance after translation. Reject mixed embedding spaces, zero vectors, degenerate centered vectors, reflection, per-face adjustments, and dimension mismatch. The mapping preserves geometric fairness but may distort original semantic distances; report residual alignment error and worst-fitting item rather than asserting semantics are preserved.

**Unknown:** no supplied corpus, executable numerical fixture, independent semantic-validity test, or current DT implementation/benefit comparison. This method is not a candidate for current B1/B7 assimilation absent a separate, falsifiable DT geometry requirement.
