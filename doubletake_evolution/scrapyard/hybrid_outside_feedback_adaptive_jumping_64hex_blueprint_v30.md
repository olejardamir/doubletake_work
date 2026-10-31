# Hybrid Outside-Feedback Adaptive Jumping over a 64-Hex Space
## Revision 30 — Three-Zone Balanced Dataset-Instantiated Blueprint

**Short name:** HOFAJ-64  
**Coordinate domain:** all 64-character hexadecimal coordinates  
**Domain size:** \(N=16^{64}=2^{256}\)  
**Primary deployment profile:** one hidden target guaranteed inside a known region  
**Reference region size:** \(M=2^{70}\)  
**Inside-region feedback:** exact `HIT` or `MISS`  
**Outside-region feedback:** target-relative `CLOSER`, `FARTHER`, or `EQUAL` between an anchor and a proposal  
**Movement domain:** the full \(2^{256}\) coordinate space  
**Target-support domain:** the guaranteed target region  
**Historical context:** ordered nonoverlapping regions with verified or latent targets  
**Instantiated dataset:** `KNOWN_PRIVATE_KEYS_PUZZLES`, SHA-256 `ea1fcb4a5b0dcad39b9b099ac9bffe0b2633975176e72fd8397f962a00009c52`  
**Current search record:** Region 71  
**Operational geometry:** balanced left probe zone, target zone, and trimmed right probe zone  
**Specification status:** normative mathematical and engineering blueprint  
**Application scope:** generic search and navigation; no application-specific interpretation is assumed

---

# 1. Normative language

The words **MUST**, **MUST NOT**, **REQUIRED**, **SHOULD**, **SHOULD NOT**, and **MAY** are normative.

A conforming implementation satisfies every applicable normative rule and passes the required tests.

---

# 2. Central model

Let:

\[
\Omega=\mathbb Z_N,
\qquad
N=2^{256}.
\]

Let the known target region be:

\[
\mathcal R(a,M)
=
\{a\oplus_Nz:0\le z<M\}.
\]

The current hidden target satisfies the hard guarantee:

\[
T\in\mathcal R.
\]

The central distinction is:

\[
\boxed{
\text{target support }V_0=\mathcal R
}
\]

while:

\[
\boxed{
\text{movement and comparison domain }=\Omega
}
\]

Reducing the **target support** to the guaranteed region is correct.

Restricting all movement and information gathering to that region is not required and is normally undesirable in this method.

Inside the region, an unsuccessful exact test provides only:

\[
\texttt{MISS}.
\]

Outside the region, a target-relative comparison provides directional information:

\[
\texttt{CLOSER},
\quad
\texttt{FARTHER},
\quad
\texttt{EQUAL}.
\]

The outside comparisons are the information-producing part of the search.

The region is the target-support and final-verification area.

---

# Dataset-instantiated profile: Region 71

This revision instantiates the generic method with the user-supplied ordered dataset.

The source file is identified by:

```text
filename: KNOWN_PRIVATE_KEYS_PUZZLES
sha256: ea1fcb4a5b0dcad39b9b099ac9bffe0b2633975176e72fd8397f962a00009c52
row_count: 160
verified_target_count: 82
unknown_target_count: 78
```

The source labels may refer to a particular application domain, but this blueprint treats the file only as:

- an ordered region index;
- an optional exact target represented as 64 hexadecimal characters;
- a decimal upper region limit.

The following source columns are intentionally ignored:

```text
WALLET ADDRESS
COMPRESSED PUBLIC KEY IN HEX
SOLVED DATE
```

No property of those ignored columns is used by the search method, sequence model, validation, or target oracle.

## Dataset row parser

Split each data row on the literal pipe character:

```text
field 0: creation index
field 1: optional target in 64-hex form
field 2: ignored
field 3: reported decimal upper bound
field 4: ignored
field 5: ignored
```

A target is `KNOWN_VERIFIED` only when field 1 matches:

```text
^[0-9A-Fa-f]{64}$
```

An empty target field is `LATENT_UNKNOWN`, except record 71, which is `CURRENT_SEARCH`.

The ignored fields MUST NOT be used to infer target status.

## Incremental region construction

The creation index is the sequence index.

For the verified-data range and the current region, the source satisfies:

\[
\mathcal R_n
=
[2^{n-1},2^n-1],
\]

with:

\[
M_n=2^{n-1}.
\]

The same bounds may also be reconstructed incrementally:

\[
L_1=1,
\]

\[
L_n=U_{n-1}+1
\quad
(n>1).
\]

The current Region 71 is:

\[
\mathcal R_{71}
=
[2^{70},2^{71}-1].
\]

Decimal form:

\[
L_{71}
=
1180591620717411303424,
\]

\[
U_{71}
=
2361183241434822606847,
\]

\[
M_{71}
=
1180591620717411303424
=
2^{70}.
\]

Canonical hexadecimal bounds:

```text
lower = 0000000000000000000000000000000000000000000000400000000000000000
upper = 00000000000000000000000000000000000000000000007fffffffffffffffff
```

The unknown local target is:

\[
z_{71}
=
T_{71}-2^{70},
\]

with:

\[
0\le z_{71}<2^{70}.
\]

## Actual sequence structure around Region 71

The relevant ordered block is:

\[
T_{70}
\rightarrow
T_{71}
\rightarrow
T_{72}
\rightarrow
T_{73}
\rightarrow
T_{74}
\rightarrow
T_{75}.
\]

The statuses are:

```text
70: KNOWN_VERIFIED
71: CURRENT_SEARCH
72: LATENT_UNKNOWN
73: LATENT_UNKNOWN
74: LATENT_UNKNOWN
75: KNOWN_VERIFIED
```

The verified Region 70 target is:

```text
0000000000000000000000000000000000000000000000349b84b6431a6c4ef1
```

Its local offset is:

```text
0000000000000000000000000000000000000000000000149b84b6431a6c4ef1
```

The verified Region 75 target is:

```text
0000000000000000000000000000000000000000000004c5ce114686a1336e07
```

Its local offset is:

```text
0000000000000000000000000000000000000000000000c5ce114686a1336e07
```

Records 70 and 75 are separated by five creation transitions.

They MUST NOT be modeled as adjacent targets.

## Available verified-target pattern

The verified target indices are:

```text
1-70,
75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130
```

Thus:

- records 1–70 provide a dense verified prefix;
- after record 70, verified anchors occur every five records through record 130;
- the four intervening records are latent;
- records after 130 currently contain no verified target in the accepted target column.

## Region 71 three-zone optimization

The canonical numeric geometry around Region 71 is:

```text
BALANCED LEFT PROBE ZONE | TARGET ZONE | TRIMMED RIGHT PROBE ZONE
```

The raw right side is vastly larger than necessary.

The reference implementation therefore discards the distant right reserve from core candidate generation and retains only the nearest:

\[
2^{70}-1
\]

right-side probe coordinates.

The left core uses all coordinates:

\[
1\text{ through }2^{70}-1.
\]

Coordinate zero is not needed for complete threshold coverage and remains outside the core collar.

This reduction changes neither the target support nor the exact 70-comparison guarantee.

## Operational inference profiles

### REGION71_FORWARD

Use only verified targets and region information available before Region 71:

\[
R_1,\ldots,R_{70}.
\]

This profile estimates how well the method would have predicted Region 71 at creation time.

### REGION71_RETROSPECTIVE

Use all currently verified targets while keeping Region 71 and all other missing targets latent.

At minimum, Region 75 acts as the next verified bridge anchor.

Later verified anchors MAY inform model parameters or hidden-state smoothing, but every intermediate region transition MUST be represented.

This profile is valid for searching Region 71 now, but it MUST be labeled retrospective and MUST NOT be reported as prospective prediction.

## Dataset-bound anomaly quarantine

Rows 1–151 match:

\[
U_n=2^n-1.
\]

Rows 152–160 do not match that formula in the supplied text:

| Row | Reported upper | Expected \(2^n-1\) | Difference |
|---:|---:|---:|---:|
| 152 | 5708990770823839524233143877797980545530986494 | 5708990770823839524233143877797980545530986495 | 1 |
| 153 | 11417981541647679048466287755595961091061972988 | 11417981541647679048466287755595961091061972991 | 3 |
| 154 | 22835963083295358096932575511191922182123945976 | 22835963083295358096932575511191922182123945983 | 7 |
| 155 | 45671926166590716193865151022383844364247891952 | 45671926166590716193865151022383844364247891967 | 15 |
| 156 | 91343852333181432387730302044767688728495783904 | 91343852333181432387730302044767688728495783935 | 31 |
| 157 | 182687704666362864775460604089535377456991567808 | 182687704666362864775460604089535377456991567871 | 63 |
| 158 | 365375409332725729550921208179070754913983135616 | 365375409332725729550921208179070754913983135743 | 127 |
| 159 | 730750818665451459101842416358141509827966271232 | 730750818665451459101842416358141509827966271487 | 255 |
| 160 | 1461501637330902918203684832716283019655932542464 | 1461501637330902918203684832716283019655932542975 | 511 |

These rows contain no verified target in the accepted target column and do not affect Region 71.

They MUST be marked:

```text
SOURCE_BOUND_ANOMALY
```

and excluded from any model that requires canonical region sizes until the source bounds are confirmed.

The implementation MUST NOT silently repair these rows.

---

# 3. Coordinate representation

Every coordinate is an exact integer:

\[
x\in\{0,1,\ldots,2^{256}-1\}.
\]

Its canonical text representation is exactly 64 lowercase hexadecimal characters.

## 3.1 Parsing

```text
parse_hex64(s):
    require s is a string
    require len(s) == 64
    require every character is in [0-9a-fA-F]
    return exact integer in [0, 2^256 - 1]
```

## 3.2 Formatting

```text
format_hex64(x):
    require exact integer x
    require 0 <= x < 2^256
    return lowercase hexadecimal left-padded to 64 characters
```

## 3.3 Binary representation

The canonical binary form is exactly 32 unsigned big-endian bytes.

## 3.4 Modular operations

\[
x\oplus_Nd=(x+d)\bmod N,
\]

\[
x\ominus_Nd=(x-d)\bmod N.
\]

All coordinate, interval, count, and cost arithmetic MUST use exact integers.

Floating-point coordinate arithmetic is forbidden.

---

# 4. Region-local chart

For any coordinate \(x\in\Omega\), define:

\[
r_a(x)=(x-a)\bmod N.
\]

For the hidden target:

\[
t=r_a(T),
\]

and the hard region guarantee gives:

\[
0\le t<M.
\]

Thus the target may be searched through the local integer interval:

\[
V_0=[0,M-1]\cap\mathbb Z.
\]

The physical target coordinate corresponding to local target candidate \(z\) is:

\[
\operatorname{phys}(z)=a\oplus_Nz.
\]

The evidence state is maintained in local coordinates.

The physical execution state is maintained in global coordinates.

These states MUST remain separate.

---

# 5. Target-knowledge modes

Choose exactly one.

## 5.1 DEPLOYMENT_HIDDEN_TARGET

The controller knows:

- the region;
- the target-feedback interfaces;

but not the exact target.

This is the primary search mode.

## 5.2 TRAINING_KNOWN_TARGET

The trainer or simulator knows the exact target and may generate correct labels.

The search controller presented to the training episode MUST receive only the observations allowed by the deployment interface.

This mode is used for:

- supervised training;
- historical replay;
- policy evaluation;
- synthetic label generation.

## 5.3 DIRECT_TARGET_KNOWN

The controller itself knows the exact target.

No target search is required.

The remaining problem is route or execution optimization.

A direct-known-target result MUST NOT be counted as search performance.

---

# 6. Feedback interfaces

## 6.1 Inside exact test

For \(z\in[0,M-1]\):

```text
inside_test(z, test_id, test_version)
    -> HIT | MISS
```

The physical coordinate tested is:

\[
a\oplus_Nz.
\]

A `MISS` removes only that exact candidate unless another valid observation already implies more.

## 6.2 Outside target-relative comparison

For outside anchor \(x\notin\mathcal R\) and outside proposal \(y\notin\mathcal R\):

```text
outside_compare(x, y, target_id, target_version)
    -> CLOSER | FARTHER | EQUAL
```

For the declared target metric \(d_T\):

\[
\texttt{CLOSER}
\iff
d_T(y,T)<d_T(x,T),
\]

\[
\texttt{FARTHER}
\iff
d_T(y,T)>d_T(x,T),
\]

\[
\texttt{EQUAL}
\iff
d_T(y,T)=d_T(x,T).
\]

Execution failure is separate from the observation.

Required failure statuses include:

```text
NO_RESULT
TIMEOUT
UNAVAILABLE
ROUTE_FAILED
RETURN_FAILED
VERSION_CHANGED
INADMISSIBLE
```

A failed comparison produces no evidence update.

## 6.3 Optional scalar score

An application MAY additionally expose a target-correlated scalar score.

Its provider, scale, calibration, cost, and version MUST be declared.

It is not required by the exact straddling algorithm.

---

# 7. Accepted comparison metrics

The exact threshold theorem applies only under a declared valid distance chart.

## 7.1 UNWRAPPED_ABSOLUTE

For outside representatives \(\xi,\eta\) and local target \(t\):

\[
d_T(\xi,t)=|\xi-t|,
\qquad
d_T(\eta,t)=|\eta-t|.
\]

## 7.2 CYCLIC_SHORTEST_SAFE_COLLAR

The physical oracle uses shortest cyclic distance:

\[
d_{\mathrm{cyc}}(x,T).
\]

The unwrapped proof is accepted only when all probe-to-target distances are strictly less than \(N/2\), so the shortest cyclic path agrees with the local linear chart.

## 7.3 APPLICATION_PROVED

An application-specific metric is accepted only when it supplies a proof or validated exact partition law for every allowed comparison pair.

A distance to the known region, a region boundary, or a navigation landmark is not automatically a distance to the target.

---

# 8. Three-zone operational geometry

The search uses three operational zones in the target-region local chart:

\[
\mathcal Z_L,
\qquad
\mathcal Z_T,
\qquad
\mathcal Z_R.
\]

The target zone is:

\[
\mathcal Z_T=[0,M-1].
\]

The raw left and right probe zones are:

\[
\mathcal Z_L^{\mathrm{raw}}
=
[-W_L^{\mathrm{raw}},-1],
\]

\[
\mathcal Z_R^{\mathrm{raw}}
=
[M,M+W_R^{\mathrm{raw}}-1].
\]

The target is guaranteed to lie only in:

\[
\mathcal Z_T.
\]

The left and right zones are comparison zones, not target-support zones.

## 8.1 Raw physical widths

For a nonwrapping target region with physical start \(a\):

\[
W_L^{\mathrm{raw}}=a,
\]

\[
W_R^{\mathrm{raw}}=N-(a+M).
\]

The implementation MUST compute these widths exactly.

It MUST NOT assume that the two sides are equal.

## 8.2 Minimum complete collar width

Define:

\[
W^*=M-1.
\]

Every internal integer threshold can be implemented by outside probes if and only if:

\[
W_L^{\mathrm{raw}}\ge M-1
\]

and:

\[
W_R^{\mathrm{raw}}\ge M-1.
\]

The necessity follows from the two extreme thresholds:

- threshold \(m=0\) requires a left representative no greater than:
  \[
  -(M-1);
  \]
- threshold \(m=M-2\) requires a right representative at least:
  \[
  2M-2.
  \]

The sufficiency follows from the threshold-pair construction in Sections 9 and 10.

## 8.3 Balanced effective zones

When both raw sides satisfy the minimum width, define the effective comparison zones:

\[
\mathcal Z_L^{\mathrm{eff}}
=
[-(M-1),-1],
\]

\[
\mathcal Z_R^{\mathrm{eff}}
=
[M,2M-2].
\]

Each effective side has exactly:

\[
M-1
\]

coordinates.

Any additional coordinates on the larger raw side are unnecessary for exact threshold coverage.

They may be removed from the core candidate space without changing:

- threshold feasibility;
- branch correctness;
- the 70-comparison result for \(M=2^{70}\).

## 8.4 Reserve zones

Define:

\[
\mathcal Z_L^{\mathrm{reserve}}
=
\mathcal Z_L^{\mathrm{raw}}
\setminus
\mathcal Z_L^{\mathrm{eff}},
\]

\[
\mathcal Z_R^{\mathrm{reserve}}
=
\mathcal Z_R^{\mathrm{raw}}
\setminus
\mathcal Z_R^{\mathrm{eff}}.
\]

Reserve coordinates are excluded from the reference core algorithm.

A custom movement optimizer MAY use them only when:

1. the same internal threshold is preserved;
2. the comparison metric remains valid;
3. lifecycle cost is reduced;
4. the operation remains bounded;
5. the run logs that a reserve coordinate was used.

The reserve zones do not increase target information.

## 8.5 Region 71 instantiated geometry

For Region 71:

\[
a=2^{70},
\qquad
M=2^{70},
\qquad
N=2^{256}.
\]

The raw left width is:

\[
W_L^{\mathrm{raw}}
=
2^{70}.
\]

The raw right width is:

\[
W_R^{\mathrm{raw}}
=
2^{256}-2^{71}.
\]

Therefore the right raw side is the much larger side in the canonical numeric chart.

Both raw widths satisfy:

\[
W_L^{\mathrm{raw}}\ge M-1,
\qquad
W_R^{\mathrm{raw}}\ge M-1.
\]

The exact balanced effective zones are:

### Left probe zone

\[
[1,2^{70}-1].
\]

Decimal:

```text
1
to
1180591620717411303423
```

Hexadecimal:

```text
0000000000000000000000000000000000000000000000000000000000000001
to
00000000000000000000000000000000000000000000003fffffffffffffffff
```

### Target zone

\[
[2^{70},2^{71}-1].
\]

Decimal:

```text
1180591620717411303424
to
2361183241434822606847
```

Hexadecimal:

```text
0000000000000000000000000000000000000000000000400000000000000000
to
00000000000000000000000000000000000000000000007fffffffffffffffff
```

### Right probe zone

\[
[2^{71},3\cdot2^{70}-2].
\]

Decimal:

```text
2361183241434822606848
to
3541774862152233910270
```

Hexadecimal:

```text
0000000000000000000000000000000000000000000000800000000000000000
to
0000000000000000000000000000000000000000000000bffffffffffffffffe
```

The effective right probe zone uses only:

\[
2^{70}-1
\]

coordinates from the enormous raw right side.

The unused right reserve begins at:

\[
3\cdot2^{70}-1.
\]

Thus the largest outside side is cut from approximately \(2^{256}\) coordinates to only \(2^{70}-1\) core probe coordinates without losing any exact split.

## 8.6 Historical-region interpretation

The operational probe zones are not identical to one historical numbered region.

For Region 71:

- historical Region 70 alone has size:
  \[
  2^{69},
  \]
  which is too small to supply the complete left collar;
- the effective left probe zone aggregates the available coordinates from earlier regions:
  \[
  [1,2^{70}-1];
  \]
- the effective right probe zone fits entirely inside the beginning of historical Region 72.

An implementation that restricts the left probe zone to Region 70 alone MUST NOT claim complete threshold coverage or the exact 70-comparison theorem.

## 8.7 Cyclic-distance safety

The balanced collars are safe for cyclic shortest distance when:

\[
2M-2<\frac N2.
\]

Equivalently:

\[
4M-4<N.
\]

For:

\[
M=2^{70},
\qquad
N=2^{256},
\]

this condition holds.

The implementation MUST reject the cyclic safe-collar theorem if the condition fails.

---

# 9. Threshold comparison theorem

Let the desired integer split threshold be:

\[
m\in\{0,1,\ldots,M-2\}.
\]

Choose:

\[
\xi\in\mathcal Z_L^{\mathrm{eff}},
\qquad
\eta\in\mathcal Z_R^{\mathrm{eff}},
\]

such that:

\[
\xi+\eta=2m+1.
\]

Use the left point as anchor and the right point as proposal.

For any integer target offset:

\[
t\in[0,M-1],
\]

the midpoint of the two representatives is:

\[
m+\frac12.
\]

Therefore:

\[
|\eta-t|<|t-\xi|
\iff
t\ge m+1,
\]

and:

\[
|\eta-t|>|t-\xi|
\iff
t\le m.
\]

There is no equality case because the midpoint is a half-integer while \(t\) is an integer.

Thus, for left-to-right orientation:

\[
\boxed{
\texttt{CLOSER}
\Rightarrow
t\ge m+1
}
\]

and:

\[
\boxed{
\texttt{FARTHER}
\Rightarrow
t\le m
}
\]

within the current exact support.

For right-to-left orientation, the observation names swap while the partition remains the same.

---

# 10. Asymmetric feasibility and trimming theorem

For arbitrary raw widths:

\[
W_L=W_L^{\mathrm{raw}},
\qquad
W_R=W_R^{\mathrm{raw}},
\]

the feasible left-representative interval for threshold \(m\) is:

\[
\xi_{\min}(m)
=
\max
\left(
-W_L,
2m-M-W_R+2
\right),
\]

\[
\xi_{\max}(m)
=
\min
\left(
-1,
2m+1-M
\right).
\]

A threshold is feasible exactly when:

\[
\xi_{\min}(m)\le\xi_{\max}(m).
\]

Every integer:

\[
\xi\in
[\xi_{\min}(m),\xi_{\max}(m)]
\]

produces:

\[
\eta=2m+1-\xi
\]

inside the raw right zone.

## 10.1 Complete-threshold theorem

Every threshold:

\[
m\in[0,M-2]
\]

is feasible if and only if:

\[
W_L\ge M-1
\]

and:

\[
W_R\ge M-1.
\]

## 10.2 Largest-side cutoff

When one raw side is larger than \(M-1\), replacing that side by its nearest \(M-1\)-coordinate collar preserves every threshold.

Therefore the larger side can be cut to:

\[
M-1
\]

core coordinates.

Cutting it further may remove valid thresholds.

## 10.3 Limited-flank mode

If either raw side has width less than:

\[
M-1,
\]

the exact complete-threshold theorem does not apply.

The controller MUST then:

1. compute the feasible threshold set analytically;
2. choose the feasible threshold minimizing the largest surviving live-support branch;
3. record the actual contraction ratio;
4. use a separately proved worst-case bound;
5. avoid claiming the exact 70-comparison profile.

Trimming a larger side cannot compensate for an undersized opposite side.

---

# 11. Balanced cost-aware probe-pair selection

The core selector searches only the effective left and right zones.

For threshold \(m\), under the balanced effective zones:

\[
\xi_{\min}
=
\max
\left(
-(M-1),
2m-2M+3
\right),
\]

\[
\xi_{\max}
=
\min
\left(
-1,
2m+1-M
\right).
\]

For each selected left representative:

\[
\eta=2m+1-\xi.
\]

The pair selector evaluates a bounded candidate set containing at least:

1. \(\xi_{\min}\);
2. \(\xi_{\max}\);
3. the feasible \(\xi\) nearest the current physical position;
4. the feasible \(\xi\) nearest the retained anchor;
5. the feasible pair minimizing immediate movement under the declared chart.

Calculate lifecycle cost:

\[
C_{\mathrm{pair}}
=
C_{\mathrm{reposition}}
+
C_{\mathrm{anchor\ setup}}
+
C_{\mathrm{proposal}}
+
C_{\mathrm{observation}}
+
C_{\mathrm{return}}
+
C_{\mathrm{controller}}.
\]

Select the admissible pair with minimum predicted lifecycle cost.

Tie order:

1. lower worst-case cost;
2. lower predicted lifecycle cost;
3. lower total movement;
4. lower \(\xi\);
5. lower physical anchor coordinate.

The selector MUST inspect no more than:

\[
K_{\mathrm{pair}}
\]

candidate pairs.

It MUST NOT scan either effective zone.

## 11.1 Space-reduction rule

The reference core candidate space is exactly:

\[
\mathcal Z_L^{\mathrm{eff}}
\cup
\mathcal Z_R^{\mathrm{eff}}.
\]

Raw-side coordinates outside these collars are excluded before candidate generation.

This is a probe-space reduction only.

It does not reduce the target zone and does not discard any valid threshold.

## 11.2 Optional asymmetric reserve use

A reserve pair MAY be evaluated only as one of a bounded number:

\[
K_{\mathrm{reserve}}
\]

of analytic candidates.

The matching opposite point MUST remain valid and the midpoint equation MUST remain exact.

Reserve use cannot replace or weaken the balanced core guarantee.

---

---

# 12. Exact evidence support

The exact target support is a sorted union of pairwise-disjoint integer intervals:

\[
V_k
=
\bigcup_{j=1}^{q_k}
[A_{k,j},B_{k,j}]
\cap\mathbb Z,
\]

where:

\[
0\le A_{k,j}\le B_{k,j}<M.
\]

Intervals are sorted and separated:

\[
B_{k,j}+1<A_{k,j+1}.
\]

The exact live-candidate count is:

\[
S_k
=
|V_k|
=
\sum_{j=1}^{q_k}
(
B_{k,j}-A_{k,j}+1
).
\]

Initially:

\[
V_0=[0,M-1],
\qquad
q_0=1,
\qquad
S_0=M.
\]

## 12.1 Representation bound

Let:

\[
K_D
\]

be the maximum number of failed bounded direct tests.

Then the reference implementation permits:

\[
q_k\le K_D+1.
\]

An outside comparison intersects the current intervals with one half-space and cannot increase \(q_k\).

A failed direct test removes one singleton and can increase \(q_k\) by at most one.

The support representation therefore remains bounded.

## 12.2 Outside comparison update

For threshold \(m\), define:

\[
V_k^L
=
V_k\cap[0,m],
\]

\[
V_k^R
=
V_k\cap[m+1,M-1].
\]

A valid comparison retains exactly one of these sets.

Empty intervals are removed and adjacent intervals are merged.

## 12.3 Direct miss update

For failed direct test at \(z^*\):

\[
V_{k+1}
=
V_k\setminus\{z^*\}.
\]

The update is implemented by bounded interval splitting.

A direct test candidate MUST belong to \(V_k\).

## 12.4 Rank selection

The support interface MUST provide bounded:

```text
cardinality()
count_leq(m)
select_by_rank(r)
intersect_left(m)
intersect_right(m)
remove_singleton(z)
contains(z)
only_candidate()
serialize()
```

`select_by_rank(r)` is one-indexed and returns the \(r\)-th live candidate in numeric order.

All operations use:

\[
O(q_k)
\]

work.

## 12.5 Movement independence

Evidence-support reduction does not shrink the global movement or outside-comparison domain.

---

# 13. Minimax balanced threshold

Assume:

\[
S_k=|V_k|>1.
\]

Choose left-branch target count:

\[
r_k
=
\left\lfloor
\frac{S_k}{2}
\right\rfloor.
\]

Select:

\[
m_k
=
\operatorname{select\_by\_rank}
(
V_k,
r_k
).
\]

Then:

\[
|V_k\cap[0,m_k]|
=
r_k,
\]

and:

\[
|V_k\cap[m_k+1,M-1]|
=
S_k-r_k.
\]

Therefore:

\[
\max
\left(
|V_k^L|,
|V_k^R|
\right)
=
\left\lceil
\frac{S_k}{2}
\right\rceil.
\]

Because \(S_k>1\), at least one live candidate lies to the right of \(m_k\), so:

\[
m_k\le M-2.
\]

For the pure minimax profile with no preliminary direct tests and:

\[
M=2^{70},
\]

every split is exactly balanced until one candidate remains.

---

# 14. Exact hybrid search algorithm

```text
INPUT:
    N = 2^256
    region start a
    region size M
    one stationary hidden target T in the region
    valid outside comparison oracle
    compatible inside exact-test oracle
    movement and observation budgets
    optional frozen sequence prior

INITIALIZE:
    V <- interval_set([0, M - 1])
    posterior <- frozen sequence prior or uniform prior
    physical_state <- supplied initial state
    comparison_count <- 0
    direct_test_count <- 0

WHILE cardinality(V) > 1:

    action <- choose between:
        OUTSIDE_COMPARE
        BOUNDED_DIRECT_TEST
    under the declared policy

    if action == BOUNDED_DIRECT_TEST:

        z <- highest-value live candidate permitted by policy
        result <- inside_test(z)

        if result == HIT:
            return FOUND

        V.remove_singleton(z)
        posterior.condition_not_equal(z)
        direct_test_count <- direct_test_count + 1
        continue

    m <- select_threshold(V, posterior, contraction_guard)

    require:
        V.count_leq(m) > 0
        cardinality(V) - V.count_leq(m) > 0

    feasible_interval <- outside_pair_bounds(m, M)

    pair <- select_bounded_cost_aware_pair(
        feasible_interval,
        m,
        physical_state
    )

    if no pair is admissible:
        return NO_ADMISSIBLE_OUTSIDE_PAIR

    move or establish outside anchor
    move or establish outside proposal

    observation <- outside_compare(anchor, proposal)

    if observation status is not SUCCESS:
        preserve V and posterior
        execute finite retry or terminate

    if orientation is LEFT_TO_RIGHT:

        if observation == CLOSER:
            V <- V.intersect_right(m)
            posterior.condition_right(m)

        else if observation == FARTHER:
            V <- V.intersect_left(m)
            posterior.condition_left(m)

        else:
            return ORACLE_INCONSISTENT

    else:

        if observation == CLOSER:
            V <- V.intersect_left(m)
            posterior.condition_left(m)

        else if observation == FARTHER:
            V <- V.intersect_right(m)
            posterior.condition_right(m)

        else:
            return ORACLE_INCONSISTENT

    comparison_count <- comparison_count + 1
    update pattern-learning state
    record complete transaction

candidate_offset <- V.only_candidate()
result <- inside_test(candidate_offset)

if result == HIT:
    return FOUND

return MODEL_OR_ORACLE_INCONSISTENCY
```

No inside-region brute-force scan is part of this algorithm.

---

# 15. Comparison complexity

For a live-support balanced split:

\[
S_{k+1}
\le
\left\lceil
\frac{S_k}{2}
\right\rceil.
\]

Therefore the number of successful outside comparisons after any bounded direct-test misses is at most:

\[
Q_{\mathrm{compare}}
\le
\left\lceil
\log_2S_{\mathrm{start}}
\right\rceil,
\]

where \(S_{\mathrm{start}}\) is the live support size when outside comparison begins.

For the pure minimax profile with:

- no preliminary direct tests;
- \(M=2^{70}\);

the exact profile is:

\[
\boxed{
Q_{\mathrm{compare}}=70
}
\]

followed by one inside exact verification.

A successful bounded direct test may terminate earlier.

Failed bounded direct tests reduce live support but do not worsen the 70-comparison upper bound.

---

# 16. Fair hit-only comparison

Within a guaranteed region of size:

\[
M=2^{70},
\]

a hit-only nonrepeating search has:

\[
\Pr(\text{success by }q)=\frac q{2^{70}}.
\]

Random without replacement requires approximately:

\[
2^{69}
\]

tests on average.

A complete fixed-order search requires at most:

\[
2^{70}
\]

tests.

The hybrid method uses approximately:

\[
70
\]

target-relative comparisons plus one exact test.

This is a genuine information-model advantage.

It is valid only because an outside comparison reveals a binary relation to the exact hidden target.

---

# 17. Cost qualification

The query-count advantage does not automatically prove wall-clock, movement, or monetary advantage.

Define total hybrid cost:

\[
C_{\mathrm{hybrid}}
=
C_{\mathrm{setup}}
+
\sum_{k=0}^{Q-1}
C_{\mathrm{pair},k}
+
C_{\mathrm{final\ test}}
+
C_{\mathrm{controller}}.
\]

Define the strongest matched baseline cost:

\[
C_{\mathrm{baseline}}.
\]

A runtime superiority claim requires:

\[
C_{\mathrm{hybrid}}
<
C_{\mathrm{baseline}}
\]

by a preregistered practical margin.

Every comparison-provider cost and movement cost MUST be included.

---

# 18. Why inside-only search is a trap

Inside the region:

```text
MISS
```

normally removes one exact coordinate.

It provides no direct information about:

- which side contains the target;
- whether the jump scale was too large;
- whether the direction was useful;
- whether the next jump should continue or reverse.

Outside the region, a valid comparison removes an entire branch:

\[
[A_k,m_k]
\]

or:

\[
[m_k+1,B_k].
\]

The method therefore MUST preserve outside comparison capability until:

- the evidence interval is a singleton;
- the comparison budget is exhausted;
- or the outside oracle becomes invalid.

It MUST NOT switch to an inside-only scan silently.

---

# 19. Closer and farther as two entities

Before one comparison, maintain both possible branch states:

\[
H_C:
t\in[m+1,B_k],
\]

\[
H_F:
t\in[A_k,m].
\]

These are two counterfactual entities.

After the observation:

\[
V_{k+1}
=
\begin{cases}
H_C,&\texttt{CLOSER},\\
H_F,&\texttt{FARTHER}.
\end{cases}
\]

For balanced splitting, both results carry approximately one bit of information.

`FARTHER` is not a failed search operation.

`CLOSER` is not intrinsically more valuable.

Reward is based on actual uncertainty reduction and lifecycle cost.

---

# 20. Two-comparison histories

Before two observations, possible histories include:

\[
CC,
\quad
CF,
\quad
FC,
\quad
FF.
\]

The controller MAY represent these histories symbolically for planning.

It MUST NOT assert that the target simultaneously caused contradictory results.

After each exact observation, inconsistent branches are discarded.

No exponential branch tree is retained in exact mode.

---

# 21. Pattern-learning objective

The exact balanced algorithm is already minimax-optimal in comparison count.

Pattern learning is used to improve:

- outside pair placement;
- anchor orientation;
- movement cost;
- observation reliability;
- retry behavior;
- threshold choice under a validated nonuniform prior;
- direct-test versus compare decisions;
- total lifecycle cost.

A conforming implementation MUST NOT claim fewer than 70 worst-case exact comparisons for a uniform \(2^{70}\) support under the same binary threshold oracle.

---

# 22. Information reward

Let:

\[
S_{\mathrm{before}}
=
|V_k|,
\]

\[
S_{\mathrm{after}}
=
|V_{k+1}|.
\]

Define information gain:

\[
I_k
=
\log_2
\left(
\frac{
S_{\mathrm{before}}
}{
S_{\mathrm{after}}
}
\right).
\]

For exact balanced splits:

\[
I_k=1
\]

when \(S_{\mathrm{before}}\) is even.

Define cost-normalized reward:

\[
R_k
=
\frac{
I_k
}{
C_{\mathrm{pair},k}
+
\epsilon_C
}.
\]

The implementation MUST use a declared fixed-point approximation or an equivalent monotone rational reward.

A simpler exact rational alternative is:

\[
R_k^{\mathrm{fraction}}
=
\frac{
S_{\mathrm{before}}-S_{\mathrm{after}}
}{
S_{\mathrm{before}}
\left(
C_{\mathrm{pair},k}+\epsilon_C
\right)
}.
\]

Both `CLOSER` and `FARTHER` are rewarded according to the actual branch reduction.

---

# 23. Finite pattern arms

A pattern arm is:

\[
A_i=
(
\text{threshold policy},
\text{pair policy},
\text{orientation policy},
\text{movement policy},
\text{retry policy}
).
\]

Example arms:

```text
BALANCED_NEAREST_PAIR
BALANCED_LEFT_BOUNDARY_ANCHOR
BALANCED_RIGHT_BOUNDARY_ANCHOR
BALANCED_RETAINED_ANCHOR
PRIOR_WEIGHTED_NEAREST_PAIR
PRIOR_WEIGHTED_LOWEST_WORST_COST
DIRECT_TOP_CANDIDATE_TEST
```

The arm set is finite and versioned.

Dynamic unbounded arm creation is forbidden.

Each arm stores:

- trial count;
- successful comparison count;
- cumulative fixed-point reward;
- failure count;
- total lifecycle cost;
- last-use transaction.

---

# 24. Deterministic adaptive arm selection

The reference learner uses a deterministic finite-arm exploration policy.

Every enabled arm is tried once before reuse.

After initialization, use a declared integer UCB-style index:

\[
J_i
=
\left\lfloor
\frac{R_i}{n_i}
\right\rfloor
+
c_E
\operatorname{isqrt}
\left(
\left\lfloor
\frac{
2L(t)Q^2
}{
n_i
}
\right\rfloor
\right),
\]

where:

- \(R_i\) is cumulative scaled reward;
- \(n_i\) is trial count;
- \(Q\) is reward scale;
- \(L(t)=\operatorname{bit\_length}(\max(1,t))\);
- \(c_E\) is a configured rational or scaled integer coefficient.

Tie order is ascending arm identifier.

The learner may be replaced by another bounded deterministic policy if the replacement is fully specified and benchmarked.

---

# 25. Ordered region-sequence registry

Let the creation sequence contain:

\[
\mathcal S
=
(R_1,R_2,\ldots,R_n),
\]

where region record \(R_i\) is:

\[
R_i
=
(
i,
a_i,
M_i,
\chi_i,
T_i^{\mathrm{optional}},
\phi_i,
g_i
).
\]

Where:

- \(i\) is the immutable creation index;
- \(a_i\) is region start;
- \(M_i\) is region size;
- \(\chi_i\) is target status;
- \(T_i\) is present only when verified;
- \(\phi_i\) contains pre-search features;
- \(g_i\) is the number of generator transitions since the previous recorded region.

Allowed target statuses are:

```text
KNOWN_VERIFIED
LATENT_UNKNOWN
CURRENT_SEARCH
```

The sequence order is creation order.

It MUST NOT be replaced by numeric coordinate order.

Every recorded region is assumed to have exactly one target unless a different target-existence contract is explicitly supplied.

## 25.1 Nonoverlap invariant

For all distinct records:

\[
\mathcal R_i\cap\mathcal R_j=\varnothing.
\]

The registry MUST validate nonoverlap exactly.

Nonoverlap prevents shared candidate coordinates.

It does not prove statistical independence and does not prove a sequential target pattern.

## 25.2 Sequence completeness

When every generated region is recorded:

\[
g_i=1
\]

for every \(i>1\).

If some generated regions are missing from the registry, the exact transition count MUST be recorded when known:

\[
g_i>1.
\]

When the number of unrecorded transitions is unknown, a step-dependent sequence model MUST be disabled or use an explicitly validated unknown-gap transition model.

## 25.3 Current region

Let \(c\) be the `CURRENT_SEARCH` index.

For live deployment, only records with:

\[
i<c
\]

may be used to construct the initial prior for region \(c\).

---

## Dataset-instantiated registry rules

For this profile:

```text
creation_index = source field 0
reported_upper = source field 3
target_status = KNOWN_VERIFIED when field 1 is valid 64-hex
target_status = CURRENT_SEARCH for index 71
target_status = LATENT_UNKNOWN otherwise
transition_count_from_previous = 1 for consecutive recorded rows
```

The registry contains every row from 1 through 160.

Rows MUST NOT be removed merely because their target is unknown.

For model fitting that requires canonical region size, rows marked `SOURCE_BOUND_ANOMALY` are unavailable but remain present in the sequence registry.

# 26. Local target states

For every verified historical target:

\[
z_i
=
(T_i-a_i)\bmod N,
\]

with:

\[
0\le z_i<M_i.
\]

For a latent region, \(z_i\) exists but is unknown.

For the current region, \(z_c\) is the search target offset.

When all region sizes are equal, the exact offsets \(z_i\) may be modeled directly.

For varying sizes, define the center-normalized fixed-point offset:

\[
u_i
=
\left\lfloor
\frac{
Q_U(2z_i+1)
}{
2M_i
}
\right\rfloor,
\]

where:

\[
Q_U\ge1.
\]

A sequence model MAY instead operate on:

- exact local offset \(z_i\);
- normalized offset \(u_i\);
- absolute target coordinate \(T_i\);
- a bounded hidden generator state;
- an application-proved state chart.

The selected state chart MUST be declared and versioned.

---

# 27. Stateful sequence hypothesis

The most general accepted sequence model is a bounded state-space model.

Let \(H_i\) be a latent generator state.

Define transition context:

\[
\psi_i
=
(
a_{i-1},
M_{i-1},
a_i,
M_i,
g_i,
\phi_{i-1},
\phi_i
).
\]

The model is:

\[
H_i
\sim
K_\theta
(
H_i
\mid
H_{i-1},
\psi_i
),
\]

\[
z_i
\sim
E_\theta
(
z_i
\mid
H_i,
\phi_i,
M_i
).
\]

A simpler direct-offset model is the special case:

\[
P_\theta
(
z_i
\mid
z_{i-1},
\psi_i
).
\]

The existence of creation order alone does not prove that this conditional distribution differs from the marginal distribution.

If successive targets are independent after conditioning on region features, the sequence module provides no advantage and MUST be disabled.

---

# 28. Meaning of unknown-target regions

A `LATENT_UNKNOWN` region is an unobserved state in the target-generation sequence.

It MUST NOT be:

- skipped as if no transition occurred;
- assigned a guessed exact target;
- copied from the previous known target;
- treated as a training label;
- removed from the transition count.

Unknown regions contribute:

- one or more known transition steps;
- region starts and sizes;
- gaps and sequence position;
- pre-search features;
- uncertainty propagation.

They do not contribute exact target labels.

---

# 29. Forward filtering for live deployment

Let:

\[
b_i(h)
=
P(H_i=h\mid\text{information available through region }i).
\]

For the first record, initialize:

\[
b_1^-(h)
=
P_\theta(H_1=h\mid\phi_1).
\]

For every later record, predict:

\[
b_i^-(h)
=
\sum_{h'}
K_\theta
(
h\mid h',\psi_i
)
b_{i-1}(h').
\]

For a verified target \(z_i\):

\[
b_i(h)
\propto
E_\theta
(
z_i\mid h,\phi_i,M_i
)
b_i^-(h).
\]

For an unknown target:

\[
b_i(h)=b_i^-(h).
\]

For the current region \(c\), the sequence prior over target offset is:

\[
\pi_c^{\mathrm{seq}}(z)
=
\sum_h
E_\theta
(
z\mid h,\phi_c,M_c
)
b_c^-(h).
\]

The live controller MUST use forward filtering only.

It MUST NOT condition the current prior on a target or observation created after region \(c\).

---

# 30. Multi-step propagation through unknown regions

Suppose region \(i\) has a verified target and the next verified target is at region \(j>i\), with latent regions between them.

The forward predictive law is the composed transition:

\[
P(H_j\mid H_i)
=
K_{\theta,j}
K_{\theta,j-1}
\cdots
K_{\theta,i+1}.
\]

In direct-offset notation:

\[
P(z_j\mid z_i)
=
\sum_{z_{i+1},\ldots,z_{j-1}}
\prod_{k=i+1}^{j}
P_\theta
(
z_k
\mid
z_{k-1},
\psi_k
).
\]

A conforming implementation MUST NOT evaluate this sum by enumerating a \(2^{70}\)-sized state at each step.

It MUST use a bounded analytic, binned, particle, parametric, or application-proved representation.

The exact number and descriptors of intermediate regions MUST be included in propagation.

The model MUST NOT pretend that two known targets separated by latent regions were created in adjacent transitions.

---

# 31. Retrospective smoothing and bridge inference

When reconstructing an older latent region, later verified targets MAY be used.

For latent region \(i\), smoothing estimates:

\[
P
(
H_i,z_i
\mid
\text{verified observations before and after }i
).
\]

For a known target before and after a latent block, this is bridge inference.

Smoothing can:

- estimate likely intermediate offsets;
- improve offline transition-model training;
- reveal whether a low-noise sequence relation is plausible.

A smoothed latent target remains a posterior distribution.

It MUST NOT be stored as a verified exact target.

Retrospective smoothing MUST NOT be used to report live forward-prediction performance.

---

# 32. Bounded sequence-belief representations

Choose one bounded representation.

## 32.1 FINITE_STATE_HMM

Use at most:

\[
K_S
\]

hidden states and at most:

\[
B_S
\]

offset-emission bins.

Transition and emission matrices use fixed-point nonnegative integers.

## 32.2 PARAMETRIC_RECURRENCE

Use a declared recurrence such as:

\[
u_i
=
f_\theta
(
u_{i-1},
\psi_i
)
+
\varepsilon_i.
\]

The noise family and bounded inference algorithm MUST be specified.

## 32.3 PARTICLE_FILTER_K

Maintain at most:

\[
K_S
\]

weighted particles.

The propagation, weighting, resampling, seed, and degeneracy rules MUST be specified.

Resampling does not create information and MUST receive zero evidence reward.

## 32.4 MIXTURE_BINS_K

Maintain at most:

\[
K_S
\]

weighted offset or hidden-state bins.

## 32.5 CANDIDATES_PLUS_TAIL

Maintain:

- at most \(K_S\) high-probability state or offset candidates;
- a strictly positive residual tail.

## 32.6 APPLICATION_BOUNDED

The application supplies bounded:

```text
initialize(region_record)
predict(belief, transition_context)
condition_verified_target(belief, offset)
smooth(sequence_records)
offset_prior(belief, region_record)
weighted_median(prior, A, B)
top_candidates(prior, limit)
uncertainty(belief)
serialize(belief)
work_bound()
memory_bound()
```

No sequence operation may scan all \(2^{70}\) offsets.

---

# 33. Safe sequence prior

An empirical sequence model MUST NOT eliminate a target candidate.

Choose exact integers:

\[
0<p_{\mathrm{tail}}\le q_{\mathrm{tail}}.
\]

Define:

\[
\lambda_{\mathrm{tail}}
=
\frac{
p_{\mathrm{tail}}
}{
q_{\mathrm{tail}}
}.
\]

Let:

\[
\pi_c^{\mathrm{seq}}(z)
\]

be the normalized sequence prediction.

Define the deployment prior:

\[
\pi_c(z)
=
(1-\lambda_{\mathrm{tail}})
\pi_c^{\mathrm{seq}}(z)
+
\lambda_{\mathrm{tail}}
\frac1{M_c}.
\]

The reference implementation represents prior masses as fixed-point nonnegative integers and performs the mixture using a declared common denominator and rounding rule.

Every live target offset therefore retains positive prior mass.

The sequence prior changes:

- threshold placement;
- direct-test preference;
- expected-cost planning.

It does not reduce exact evidence support:

\[
V_0=[0,M_c-1].
\]

Only outside comparison evidence and inside exact misses remove candidates.

---

# 34. Sequence feature contract

A feature is allowed only when available before the relevant region search.

Allowed examples include:

- creation index;
- region start;
- region size;
- exact number of transitions since the previous record;
- coordinate gap from the preceding region;
- selected fixed-width bit fields of region starts;
- earlier verified target offsets;
- earlier forward-filter beliefs;
- external pre-search metadata.

Forbidden leakage includes:

- the current exact target;
- smoothed current-target estimates using future targets;
- post-search measurements;
- later target values during live prediction;
- labels derived from the current final result;
- features selected after inspecting final-audit targets.

Every feature has:

```text
feature_id
feature_version
availability_index
numeric_encoding
```

---

# 35. Model identifiability and complexity gate

Before enabling a sequence model, declare:

```text
model_family
parameter_count_or_capacity
maximum_markov_order
minimum_verified_targets
minimum_verified_anchor_blocks
maximum_latent_gap_supported
regularization
training_algorithm
selection_metric
```

Unknown targets do not count as verified labels.

The model MUST be disabled when:

- the configured minimum verified-target count is not met;
- the observed anchor pattern cannot identify the selected model class;
- the latent gaps exceed the validated range;
- optimization fails reproducibility checks;
- held-out improvement does not clear the declared margin.

Model complexity MUST be selected without using final-audit targets.

---

# 36. Sequence-model training with latent targets

Known verified targets contribute exact observations.

Unknown targets are marginalized as latent states.

Permitted training approaches include:

- exact forward-backward for a bounded finite-state model;
- expectation-maximization with bounded state;
- particle expectation-maximization;
- Bayesian bounded-state inference;
- direct marginal-likelihood optimization;
- application-proved alternatives.

A latent posterior mode or mean MUST NOT be converted into a verified label for ordinary supervised training.

If pseudo-labels are used experimentally, the run MUST be labeled and compared against a no-pseudo-label model.

Offline simulated closer/farther labels may be generated only for verified historical targets.

---

# Region 71 analogue validation

The dense verified prefix permits validation that mirrors the actual missing-target geometry around Region 71.

For an analogue start index \(j\), construct:

```text
j:     hidden evaluation target
j+1:   latent
j+2:   latent
j+3:   latent
j+4:   known future bridge anchor
```

For each eligible fold:

1. fit or select the sequence model without using targets \(j\) through \(j+3\);
2. propagate through all four transitions;
3. permit target \(j+4\) only in the retrospective-smoothing profile;
4. predict the target distribution for \(j\);
5. compare with the actual verified target at \(j\);
6. restore all hidden values only after scoring.

Eligible dense-prefix folds satisfy:

\[
1\le j\le66.
\]

To avoid training on the evaluated target through parameter selection, use:

- rolling-origin fitting;
- nested chronological validation;
- or cross-fitting with disjoint model-selection and scoring folds.

Required outputs include:

- forward-only performance for \(j\);
- bridge-smoothed performance for \(j\);
- uniform-prior performance;
- nonsequential empirical-prior performance;
- shuffled-order performance;
- shuffled-offset performance;
- expected outside-comparison count;
- total lifecycle cost.

This analogue validation is the primary admissibility test for applying a bridge model to Region 71.

It is stronger than merely fitting the known targets and inspecting the result.

---

# 37. Chronological validation

Sequence-model validation MUST reproduce deployment chronology.

Use one of:

- rolling-origin evaluation;
- expanding-window evaluation;
- an untouched chronological suffix;
- leave-one-anchor-block-out evaluation that preserves order.

For prediction of region \(i\), train and condition only on information available before \(i\).

Random record-level cross-validation is insufficient when it lets future targets influence past predictions.

The validation missing-target mask SHOULD match the real pattern of known and unknown historical targets.

---

# 38. Sequence baselines and falsification controls

Every sequence claim MUST compare against:

1. uniform offset prior;
2. nonsequential empirical offset distribution;
3. region-feature model without target sequence;
4. last-known-offset persistence;
5. last-known-offset plus configured drift;
6. the same model with region order shuffled;
7. the same model with verified offsets shuffled among regions;
8. balanced 70-comparison search;
9. sequence prior without online pattern learning.

A genuine sequential effect should degrade when creation order is destroyed.

If shuffled order performs equally well, the sequence interpretation is unsupported.

---

# 39. Sequence-model acceptance metrics

Required held-out metrics include:

- proper log loss or another proper scoring rule;
- calibration;
- target rank;
- top-\(K\) recall;
- expected outside comparisons;
- expected direct tests;
- total lifecycle cost;
- failure rate;
- worst-case contraction compliance.

A sequence model is enabled only when it materially improves the preregistered primary metric over the strongest nonsequence baseline.

If not:

```text
SEQUENCE_PRIOR_DISABLED
```

The exact balanced search remains active.

---

# 40. Online sequence-prior integration

At the start of the current search, freeze:

- model identity;
- model version;
- features;
- forward-filter belief;
- safety-tail coefficient;
- fixed-point mass scale.

Let the active prior be:

\[
\pi_0(z).
\]

For current exact support \(V_k\), all posterior operations are restricted to live candidates.

After outside comparison branch \(B_k\):

\[
\pi_{k+1}(z)
=
\frac{
\pi_k(z)\mathbf 1[z\in B_k]
}{
\sum_{u\in V_k\cap B_k}\pi_k(u)
}.
\]

After an inside exact miss at \(z^*\):

\[
\pi_{k+1}(z)
=
\frac{
\pi_k(z)\mathbf 1[z\ne z^*]
}{
\sum_{u\in V_k\setminus\{z^*\}}\pi_k(u)
}.
\]

The exact interval-set support is updated independently and remains the source of truth for candidate validity.

Because the safety tail is positive, every nonempty exact branch has positive prior denominator.

The sequence model MUST remain frozen during the current target search.

It may be retrained only after the final target is verified and appended as a new sequence record.

---

# 41. Sequence-aware threshold and direct-test policy

Use the active posterior over the exact live support \(V_k\).

Choose a weighted-median threshold:

\[
m_{\mathrm{seq}}
\in
\arg\min_m
\left|
\sum_{\substack{z\in V_k\\z\le m}}\pi_k(z)
-
\frac12
\sum_{z\in V_k}\pi_k(z)
\right|,
\]

subject to:

\[
|V_k\cap[0,m]|>0,
\]

\[
|V_k\cap[m+1,M-1]|>0.
\]

The prior interface MUST implement bounded:

```text
weighted_median(V)
branch_mass(V, m)
top_live_candidates(V, limit)
```

A high-probability exact candidate MAY be tested directly under a finite declared policy:

```text
maximum_direct_tests_per_search
minimum_candidate_probability
maximum_direct_test_cost
```

The selected candidate MUST belong to \(V_k\).

A failed direct test removes exactly one live candidate through bounded interval splitting.

It MUST NOT start an inside scan.

---

# 42. Contraction guard and no-sequence fallback

Choose:

\[
\frac12\le\rho_{\max}<1.
\]

Every sequence-weighted threshold MUST satisfy:

\[
\max
\left(
|V_k\cap[0,m]|,
|V_k\cap[m+1,M-1]|
\right)
\le
\left\lceil
\rho_{\max}|V_k|
\right\rceil.
\]

If the weighted median violates the guard, project it to the nearest threshold satisfying the exact live-support count constraint.

The support interface performs this operation in bounded time using its interval set.

If the sequence model is unavailable, invalid, uncalibrated, or rejected:

- set the prior to uniform over live support;
- use the live-support minimax threshold;
- disable sequence-based direct tests;
- retain cost-aware outside pair selection;
- retain the 70-comparison upper bound for \(M=2^{70}\).

Unknown regions therefore cannot force random or brute-force fallback.

---

# 43. Comparison transaction

Each comparison transaction stores:

```text
transaction_id
target_id
target_version
region_start
region_size
evidence_interval_set_before
evidence_cardinality_before
threshold_m
feasible_pair_bounds
evaluated_pair_candidates
selected_unwrapped_anchor
selected_unwrapped_proposal
selected_physical_anchor
selected_physical_proposal
orientation
predicted_costs
actual_costs
execution_status
comparison_result
evidence_interval_set_after
evidence_cardinality_after
information_gain
pattern_arm_id
pattern_state_after
```

All values required to reproduce the decision MUST be logged.

---

# 44. Finite retries

Choose:

\[
B_{\mathrm{attempt}}<\infty.
\]

All retries for one comparison use the same:

- target identity and version;
- region;
- evidence interval;
- threshold;
- outside pair;
- orientation.

A failure after the final attempt produces:

```text
COMPARISON_FAILED
```

The evidence interval remains unchanged.

The controller MUST NOT guess a branch.

---

# 45. Target and oracle stationarity

The exact theorem requires:

- one target;
- stationary target identity;
- stationary target version;
- stable comparison semantics;
- stable distance chart.

If any version changes:

```text
VERSION_CHANGED
```

Accumulated evidence is invalidated.

The run terminates or restarts as a new instance.

---

# 46. Final verification

When:

\[
A=B=t^*,
\]

the controller computes:

\[
T^*=a\oplus_Nt^*.
\]

It performs exactly one compatible inside test.

If:

```text
HIT
```

return:

```text
FOUND
```

If:

```text
MISS
```

return:

```text
MODEL_OR_ORACLE_INCONSISTENCY
```

If no compatible verifier exists:

```text
ISOLATED_UNVERIFIED
```

An isolated but unverified candidate is not reported as found.

---

# 47. No hidden brute-force fallback

The controller MUST NOT respond to failure by:

- scanning the region;
- enumerating the complement;
- testing sequential candidates indefinitely;
- completing an affine permutation;
- converting every miss into the next numeric test.

An explicit exhaustive mode, if implemented, is separate and labeled:

```text
EXPLICIT_CERTIFICATION
```

It is not adaptive search.

---

# 48. No hidden random fallback

A seeded random or pseudorandom policy may be used only as:

- an explicit benchmark;
- an explicitly labeled fallback;
- a bounded exploration arm.

If it becomes the sole active policy, the run status is:

```text
BASELINE_RANDOMIZED
```

The system MUST NOT claim adaptive superiority.

---

# 49. Budgets

Declare finite budgets:

```text
comparison_budget
comparison_attempt_budget
inside_test_budget
movement_budget
observation_cost_budget
controller_work_budget
memory_budget
historical_model_work_budget
```

For the minimax \(2^{70}\) profile, the comparison budget SHOULD be at least:

\[
70.
\]

An operation MUST NOT begin when its declared worst-case cost exceeds the remaining hard budget.

Actual costs are charged after execution.

---

# 50. Complexity

## 50.1 Uniform minimax profile

Target-related query complexity:

\[
70\text{ comparisons}+1\text{ exact test}.
\]

Evidence memory is:

\[
O(K_D+1)
\]

intervals when at most \(K_D\) bounded direct misses are permitted.

For the pure comparison-only profile:

\[
K_D=0,
\]

so evidence memory is \(O(1)\).

## 50.2 Pair selection

Per comparison:

\[
O(K_{\mathrm{pair}})
\]

candidate-pair evaluation.

## 50.3 Pattern learning

For \(K_A\) finite arms:

\[
O(K_A)
\]

selection work or a bounded indexed equivalent.

## 50.4 Historical prior

Per threshold selection, the prior model MUST have declared bounded work independent of \(M\), or logarithmic work in \(M\).

No operation may scan all \(2^{70}\) candidates.

---


## 50.5 Sequence filtering

For bounded sequence state size \(K_S\):

- dense finite-state transition work is:
  \[
  O(K_S^2)
  \]
  per recorded transition;
- sparse transition work is proportional to the declared nonzero transition count;
- particle filtering is:
  \[
  O(K_S)
  \]
  plus bounded emission work;
- analytic recurrence work follows its declared bound.

Processing \(g\) latent transitions costs at most \(g\) bounded prediction steps unless an exact powered transition operator is used.

No sequence operation may enumerate the \(2^{70}\) target offsets.

---

# 51. Fair baselines

Every performance claim includes the applicable baselines.

## 51.1 Region hit-only random without replacement

For small simulations, use exact Fisher–Yates.

For the full region, use a declared bijective pseudorandom permutation.

## 51.2 Region sequential order

Test offsets:

\[
0,1,2,\ldots,M-1.
\]

## 51.3 Region affine no-repeat order

Use:

\[
z_j=(b+jq)\bmod M,
\]

with:

\[
\gcd(q,M)=1.
\]

For \(M=2^{70}\), \(q\) is odd.

## 51.4 Same-information balanced comparison baseline

Use:

- balanced thresholds;
- the same outside oracle;
- the same pair admissibility;
- the simplest deterministic pair policy.

This is the essential same-information baseline.

## 51.5 Historical-prior baselines

Compare against:

- uniform balanced search;
- empirical offset histogram;
- prior-weighted search without online pattern learning;
- shuffled-label historical model;
- top-candidate tests without outside learning.

---

## 51.6 Sequence baselines

For every sequence-prior claim, include:

- uniform offset prior;
- nonsequential historical offset prior;
- region-feature-only model;
- last-known-offset persistence;
- configured simple drift;
- shuffled creation order;
- shuffled verified offsets;
- forward filter with latent regions removed incorrectly, as a negative-control implementation;
- frozen sequence prior without online arm learning.

The deployed sequence method MUST outperform the strongest valid baseline, not merely the uniform prior.


---

# 52. Acceptance criteria

Before evaluation, declare:

```text
primary metric
practical margin
confidence level
failure penalty
historical split strategy
target-instance distribution
movement-cost model
observation-cost model
run count or stopping rule
```

## 52.1 Capability claim

To claim superiority over hit-only random or brute force, include all comparison-oracle costs.

## 52.2 Pattern-learning claim

To claim the learned pattern is better than the core method, it MUST beat the same-information balanced comparison baseline on:

- expected lifecycle cost;
- movement;
- latency;
- reliability;
- or another preregistered metric.

It cannot claim a better minimax comparison count than the 70-comparison core.

## 52.3 Historical-pattern claim

A historical model is accepted only if it improves untouched-region performance beyond:

- uniform prior;
- shuffled labels;
- and the strongest simple historical baseline.

---

## 52.4 Sequence claim

To claim that sequential creation helps:

1. evaluation MUST be chronological;
2. latent regions MUST remain latent;
3. future targets MUST be unavailable in live prediction;
4. the prior MUST include a positive safety tail;
5. the sequence model MUST beat the strongest nonsequence baseline;
6. shuffled-order and shuffled-offset controls MUST materially degrade;
7. the exact balanced fallback MUST remain available;
8. model and feature versions MUST be frozen before final audit.


---

# 53. Required implementation states

```text
VALIDATING
INITIALIZING
VALIDATING_THREE_ZONE_GEOMETRY
TRIMMING_PROBE_ZONES
LOADING_SEQUENCE
FORWARD_FILTERING
SELECTING_THRESHOLD
CONSTRUCTING_OUTSIDE_PAIR
REPOSITIONING_ANCHOR
EXECUTING_PROPOSAL
OBSERVING_COMPARISON
UPDATING_EVIDENCE
LEARNING_PATTERN
FINAL_VERIFYING
TERMINAL
```

Terminal statuses include:

```text
FOUND
ISOLATED_UNVERIFIED
NO_ADMISSIBLE_OUTSIDE_PAIR
INSUFFICIENT_LEFT_PROBE_WIDTH
INSUFFICIENT_RIGHT_PROBE_WIDTH
LIMITED_FLANK_MODE_REQUIRED
COMPARISON_FAILED
ORACLE_INCONSISTENT
MODEL_OR_ORACLE_INCONSISTENCY
VERSION_CHANGED
BUDGET_EXHAUSTED
SEQUENCE_PRIOR_DISABLED
SEQUENCE_MODEL_INVALID
SEQUENCE_GAP_UNSUPPORTED
TARGET_SEARCH_ADVANTAGE_NOT_ESTABLISHED
```

---

# 54. Reference data structures

```text
Coordinate256:
    exact integer in [0, 2^256 - 1]
```

```text
Region:
    start: Coordinate256
    size: exact integer
```

```text
EvidenceIntervalSet:
    intervals: sorted disjoint list
    cardinality: exact integer
    maximum_intervals
```

```text
ProbeZoneGeometry:
    target_start
    target_size
    raw_left_width
    raw_right_width
    effective_left_interval
    effective_right_interval
    left_reserve_interval_optional
    right_reserve_interval_optional
    geometry_mode
    cyclic_safety_verified
```

```text
OutsidePair:
    threshold
    unwrapped_anchor
    unwrapped_proposal
    physical_anchor
    physical_proposal
    orientation
    predicted_costs
    worst_case_costs
```

```text
PatternArm:
    arm_id
    threshold_policy
    pair_policy
    orientation_policy
    movement_policy
    retry_policy
    trial_count
    success_count
    cumulative_reward
    cumulative_cost
    failure_count
```

```text
RegionSequenceRecord:
    creation_index
    region_start
    region_size
    target_status
    verified_target_optional
    local_offset_optional
    transition_count_from_previous
    pre_search_features
    feature_versions
```

```text
SequenceBelief:
    representation_type
    state_payload
    uncertainty
    last_creation_index
    model_id
    model_version
```

```text
SequenceModel:
    model_id
    model_version
    state_chart
    transition_model
    emission_model
    safety_tail
    parameter_payload
    training_record
    chronological_validation_record
    falsification_control_record
```

```text
ControllerState:
    target_id
    target_version
    region
    evidence_interval_set
    physical_state
    retained_anchor_optional
    comparison_count
    inside_test_count
    pattern_states
    sequence_registry
    frozen_sequence_belief_optional
    frozen_sequence_prior_optional
    budgets_remaining
    random_state_if_used
```

---

# 55. Required conformance tests

A conforming implementation MUST pass at least the following.

## 55.1 Coordinate and region tests

1. Parse the all-zero 64-hex coordinate.
2. Parse the all-\(f\) coordinate.
3. Reject invalid length.
4. Reject invalid characters.
5. Format exactly 64 lowercase hex characters.
6. Correctly map wrapping regions.
7. Correctly compute local target offsets.
8. Preserve global movement outside the target region.
9. Initialize evidence support to the hard region.
10. Keep physical and evidence coordinates separate.
11. Verify every registered region target lies inside its region.
12. Reject overlapping registered regions.

## 55.2 Collar tests

13. Construct the left collar.
14. Construct the right collar.
15. Verify all collar coordinates are outside the region.
16. Verify collars are physically distinct.
17. Verify the cyclic safe-collar inequality.
18. Reject the cyclic theorem when the inequality fails.
19. Correctly map negative representatives to global coordinates.
20. Correctly map right representatives to global coordinates.

## 55.3 Threshold-pair tests

21. Compute exact feasible pair bounds.
22. Verify nonempty feasibility for every threshold in exhaustive small models.
23. Verify:
    \[
    \xi+\eta=2m+1.
    \]
24. Verify both representatives are outside.
25. Verify no equality result occurs for integer targets.
26. Verify `CLOSER` selects the right branch in left-to-right orientation.
27. Verify `FARTHER` selects the left branch in left-to-right orientation.
28. Verify reversed orientation swaps observation names.
29. Verify pair selection examines at most \(K_{\mathrm{pair}}\) candidates.
30. Verify deterministic pair tie breaking.

## 55.4 Evidence tests

31. Initialize the interval set to:
    \[
    \{[0,M-1]\}.
    \]
32. Compute exact live-support cardinality.
33. Preserve the true target after every exact update.
34. Remove the inconsistent comparison branch.
35. Remove exactly one candidate after a direct miss.
36. Split one interval into at most two after a direct miss.
37. Enforce the \(K_D+1\) interval bound.
38. Never enlarge exact live support.
39. Never update after failed comparison.
40. Report inconsistency on impossible equality.
41. Select the minimax threshold by live-candidate rank.
42. Reach a singleton for every target in exhaustive small models.
43. Produce exactly 70 comparisons for every target in the pure \(M=2^{70}\) symbolic profile.
44. Never exceed 70 outside comparisons after bounded direct misses.
45. Perform one final inside verification.
46. Report inconsistency after a final miss.
47. Update posterior mass only inside the surviving exact branch.
48. Preserve a positive posterior tail before evidence conditioning.

## 55.5 Dual-entity tests

49. Maintain closer and farther branches before observation.
50. Do not treat both branches as factual.
51. Discard one branch after exact observation.
52. Reward equal-size closer and farther branches equally.
53. Keep two-comparison histories symbolic.
54. Do not create an exponential exact branch tree.

## 55.6 Pattern-learning tests

55. Try every enabled pattern arm once before reuse.
56. Use actual information reduction in reward.
57. Include actual pair cost in reward.
58. Do not reward branch names intrinsically.
59. Reproduce arm selection from the same state.
60. Respect finite arm count.
61. Respect finite pair-candidate count.
62. Never replace a valid split with an unbounded search.

## 55.7 Sequence-registry tests

63. Creation indices are unique.
64. Creation order is preserved independently of coordinate order.
65. Target statuses are valid.
66. Verified targets are stored only under `KNOWN_VERIFIED`.
67. Latent targets have no exact stored value.
68. Exactly one current-search record exists.
69. Transition counts are positive.
70. Missing unknown transition counts disable step-dependent models.
71. Nonoverlap is validated exactly.
72. Nonoverlap is not interpreted as independence.

## 55.8 Forward-filter tests

73. A verified target conditions the sequence belief.
74. A latent target performs prediction without conditioning.
75. A latent region is not skipped.
76. A latent target is not replaced by a pseudo-label.
77. Multi-step gaps execute the declared number of transitions.
78. The current prior uses only earlier records.
79. Future target records are inaccessible in deployment mode.
80. The forward belief is reproducible from the same registry and model.
81. Sequence propagation respects its work bound.
82. No propagation enumerates all \(2^{70}\) offsets.

## 55.9 Smoothing tests

83. Retrospective smoothing may use later verified targets.
84. Smoothing output remains probabilistic.
85. A smoothed mode is not marked verified.
86. Smoothing is excluded from live forward-performance metrics.
87. Bridge inference uses both bounding anchors when available.
88. A later known target does not leak into an earlier live prediction.

## 55.10 Sequence-prior tests

89. The safety-tail coefficient is strictly positive.
90. Every target offset retains positive initial prior mass.
91. Sequence prior does not reduce exact support.
92. Weighted-median calculation is bounded.
93. Branch conditioning renormalizes exactly.
94. Direct-test miss removes only one candidate.
95. Direct tests obey their finite cap.
96. The contraction guard is enforced.
97. Invalid sequence prior falls back to balanced splitting.
98. Sequence model remains frozen during one current search.
99. Verified final target may create only a new future model version.

## 55.11 Sequence-training and validation tests

100. Known targets contribute exact observations.
101. Unknown targets are marginalized.
102. Unknown targets do not count as verified labels.
103. Pseudo-label experiments are labeled separately.
104. Feature availability indices are enforced.
105. Post-search features are rejected.
106. Random record-level folds cannot be used as the sole sequence validation.
107. Rolling-origin prediction uses only prior information.
108. The real missing-target mask is reproduced or explicitly modeled.
109. Uniform prior baseline is included.
110. Nonsequence historical prior is included.
111. Last-known-offset baseline is included.
112. Simple drift baseline is included.
113. Shuffled-order control is included.
114. Shuffled-offset control is included.
115. Sequence prior is disabled when held-out gain fails.
116. Model capacity gate is enforced.
117. Unsupported latent gaps disable the sequence model.
118. Final-audit targets do not influence model selection.

## 55.12 Failure and budget tests

119. Finite comparison attempts terminate.
120. Failed comparisons preserve evidence.
121. No branch is guessed after failure.
122. Version change invalidates accumulated evidence.
123. Movement-budget exhaustion terminates.
124. Comparison-budget exhaustion terminates.
125. Inside-test-budget exhaustion terminates.
126. Controller-work budget terminates.
127. Historical-model work budget terminates.
128. No failure activates inside brute force.
129. No failure activates hidden random search.
130. Baseline random mode is labeled explicitly.
131. Sequence-model failure returns the balanced fallback.

## 55.13 Baseline and benchmark tests

132. Region random baseline samples without replacement.
133. Region sequential baseline is correct.
134. Region affine baseline has no repeats.
135. Same-information balanced baseline receives the same oracle.
136. All oracle costs are included.
137. All movement costs are included.
138. Pattern-learning claim is compared with balanced comparison search.
139. Sequence claim uses chronological untouched regions.
140. Capability claim distinguishes stronger feedback from hit-only feedback.
141. Shuffled-order performance is reported.
142. Failed performance gate reports the required status.

## 55.14 Reproducibility tests

143. Same configuration and observations reproduce the same thresholds.
144. Same state reproduces the same outside pair.
145. Same costs reproduce the same orientation.
146. Same sequence registry and model reproduce the same forward belief.
147. Same historical model reproduces the same prior.
148. Transaction logs reproduce every evidence update.
149. Sequence logs reproduce every prediction and conditioning step.
150. Configuration digests detect changes.
151. All provider and model versions are logged.
152. All exact integer formulas are platform-stable.

---


---

## Three-zone balance conformance tests

A conforming implementation MUST additionally verify:

1. Compute raw left and right widths exactly.
2. Identify the larger raw side without relying on user-facing orientation labels.
3. Verify the complete-threshold condition:
   \[
   W_L^{\mathrm{raw}}\ge M-1
   \quad\text{and}\quad
   W_R^{\mathrm{raw}}\ge M-1.
   \]
4. Trim each sufficient raw side to the nearest \(M-1\)-coordinate effective collar.
5. Preserve all thresholds after trimming.
6. Reject a collar narrower than \(M-1\) for the complete-threshold profile.
7. Verify Region 71 raw left width is \(2^{70}\).
8. Verify Region 71 raw right width is \(2^{256}-2^{71}\).
9. Verify the right side is the larger side in the canonical numeric chart.
10. Verify the effective left zone is:
    \[
    [1,2^{70}-1].
    \]
11. Verify the effective target zone is:
    \[
    [2^{70},2^{71}-1].
    \]
12. Verify the effective right zone is:
    \[
    [2^{71},3\cdot2^{70}-2].
    \]
13. Verify both effective probe zones contain exactly \(2^{70}-1\) coordinates.
14. Verify the right effective zone lies entirely inside historical Region 72.
15. Verify historical Region 70 alone is too small for the complete left collar.
16. Verify the cumulative left space supplies the complete left collar.
17. Exclude the right reserve before core candidate generation.
18. Verify reserve exclusion does not change threshold feasibility.
19. Limit reserve evaluation to \(K_{\mathrm{reserve}}\) analytic candidates.
20. In limited-flank mode, report actual feasible thresholds and never claim 70 comparisons.

---

## Dataset-instantiated conformance tests

A conforming Region 71 implementation MUST additionally pass:

1. Parse exactly 160 data rows.
2. Parse exactly 82 verified targets.
3. Parse exactly 78 unknown targets.
4. Ignore source columns 2, 4, and 5.
5. Never infer target status from an ignored column.
6. Mark Region 71 as `CURRENT_SEARCH`.
7. Mark Regions 72–74 as `LATENT_UNKNOWN`.
8. Mark Region 75 as `KNOWN_VERIFIED`.
9. Reconstruct the exact Region 71 decimal bounds.
10. Reconstruct the exact Region 71 hexadecimal bounds.
11. Verify Region 71 size is exactly:
    \[
    2^{70}.
    \]
12. Verify every accepted historical target lies inside its region.
13. Verify the accepted known-target index set exactly matches the instantiated profile.
14. Preserve all unknown rows as transition states.
15. Treat Region 70 to Region 75 as five transitions.
16. Prevent direct Region-70-to-75 adjacency modeling.
17. Produce forward-only Region 71 prior using no target after index 70.
18. Label any use of Region 75 or later targets as retrospective.
19. Run Region 71 analogue bridge folds on eligible dense-prefix indices.
20. Hide all four analogue-block targets before prediction.
21. Prevent hidden analogue targets from influencing model selection.
22. Compare analogue predictions with uniform and shuffled controls.
23. Detect rows 152–160 as source-bound anomalies.
24. Exclude anomaly rows from canonical-size models.
25. Never silently rewrite anomaly bounds.
26. Reproduce the verified-target registry from the source digest.

---

# 56. Mathematical claims

## Claim 1: hard target support with global movement

\[
V_0=\mathcal R,
\]

while:

\[
\Omega_{\mathrm{movement}}=\Omega.
\]

The target-support reduction does not trap physical or informational jumping inside the region.

## Claim 2: balanced cutoff of the oversized side

When both raw probe sides have width at least:

\[
M-1,
\]

each side may be reduced to its nearest \(M-1\)-coordinate collar without losing any internal threshold.

For Region 71, this cuts the enormous raw right side to exactly:

\[
2^{70}-1
\]

core probe coordinates.

## Claim 3: adjacent Region 70 alone is insufficient

Historical Region 70 has only:

\[
2^{69}
\]

coordinates.

The full left collar therefore uses the cumulative space to the left of Region 71, not Region 70 alone.


## Claim 4: every internal threshold is externally realizable

For every:

\[
m\in[0,M-2],
\]

there exists an outside pair satisfying:

\[
\xi+\eta=2m+1.
\]

## Claim 5: exact branch information

One successful outside comparison identifies whether:

\[
t\le m
\]

or:

\[
t\ge m+1.
\]

## Claim 6: 70-comparison localization

For:

\[
M=2^{70},
\]

the pure balanced comparison-only profile isolates the target offset after exactly 70 comparisons.

Profiles with successful bounded direct tests may terminate earlier and never require more than 70 successful outside comparisons.

## Claim 7: one final exact test

After localization, one compatible inside test verifies the target.

## Claim 8: unknown regions are latent transitions

An unknown-target region supplies a transition step and known region context but no exact target label.

Skipping it changes the sequence model and is nonconforming.

## Claim 9: sequence information is conditional

Ordered regions improve expected search performance only when the target-generation process has a stable, held-out predictive sequence relation.

Creation order alone provides no guaranteed advantage.

## Claim 10: sequence prior cannot remove exact support

The safety-tail mixture gives every offset positive prior mass.

Only genuine outside comparison evidence and inside exact misses remove candidates.

## Claim 11: exact fallback is preserved

If the sequence model fails, balanced outside comparisons retain the exact 70-comparison result for \(M=2^{70}\), assuming the outside oracle remains valid.

## Claim 12: no hidden fallback

Loss of sequence information or comparison feedback does not trigger brute-force or random search.

---

# 57. Double-slit inspiration: precise interpretation

| Inspiration | Engineering interpretation |
|---|---|
| Two paths | Closer branch and farther branch |
| Wave-like state | Both target-support branches represented before feedback |
| Particle-like action | One concrete outside anchor-to-proposal comparison |
| Measurement | Actual target-relative closer/farther result |
| Collapse | Keep the branch consistent with the result |
| Interference | Not implemented |
| Quantum speedup | Not claimed |
| Actual speedup | One comparison removes approximately half the target region |

The analogy is organizational.

The mathematical advantage comes from the real outside target-relative comparison.

---

# 58. Final engineering rule

> Use three operational zones around Region 71: a cumulative left probe zone, the guaranteed target zone, and a trimmed right probe zone. Do not cut the target region. Compute the raw flank widths exactly, then retain only the nearest \(M-1\) probe coordinates on each sufficient side. For Region 71, use left probe coordinates \([1,2^{70}-1]\), target coordinates \([2^{70},2^{71}-1]\), and right probe coordinates \([2^{71},3\cdot2^{70}-2]\). Exclude the enormous distant right reserve from core candidate generation because it adds no threshold capability. Do not restrict the left side to historical Region 70 alone, because its \(2^{69}\) coordinates are insufficient for complete threshold coverage. Preserve every unknown historical target as a latent sequence state, validate sequence priors chronologically, and retain the balanced 70-comparison fallback. If either effective flank is too narrow, enter explicitly labeled limited-flank mode and never claim the exact 70-comparison theorem.

---

# Appendix A — Verified target registry

For all verified targets in this dataset, the region is:

\[
\mathcal R_n=[2^{n-1},2^n-1].
\]

The local offset is:

\[
z_n=T_n-2^{n-1}.
\]

| Region | Verified target, canonical 64-hex | Local offset, canonical 64-hex |
|---:|---|---|
| 1 | `0000000000000000000000000000000000000000000000000000000000000001` | `0000000000000000000000000000000000000000000000000000000000000000` |
| 2 | `0000000000000000000000000000000000000000000000000000000000000003` | `0000000000000000000000000000000000000000000000000000000000000001` |
| 3 | `0000000000000000000000000000000000000000000000000000000000000007` | `0000000000000000000000000000000000000000000000000000000000000003` |
| 4 | `0000000000000000000000000000000000000000000000000000000000000008` | `0000000000000000000000000000000000000000000000000000000000000000` |
| 5 | `0000000000000000000000000000000000000000000000000000000000000015` | `0000000000000000000000000000000000000000000000000000000000000005` |
| 6 | `0000000000000000000000000000000000000000000000000000000000000031` | `0000000000000000000000000000000000000000000000000000000000000011` |
| 7 | `000000000000000000000000000000000000000000000000000000000000004c` | `000000000000000000000000000000000000000000000000000000000000000c` |
| 8 | `00000000000000000000000000000000000000000000000000000000000000e0` | `0000000000000000000000000000000000000000000000000000000000000060` |
| 9 | `00000000000000000000000000000000000000000000000000000000000001d3` | `00000000000000000000000000000000000000000000000000000000000000d3` |
| 10 | `0000000000000000000000000000000000000000000000000000000000000202` | `0000000000000000000000000000000000000000000000000000000000000002` |
| 11 | `0000000000000000000000000000000000000000000000000000000000000483` | `0000000000000000000000000000000000000000000000000000000000000083` |
| 12 | `0000000000000000000000000000000000000000000000000000000000000a7b` | `000000000000000000000000000000000000000000000000000000000000027b` |
| 13 | `0000000000000000000000000000000000000000000000000000000000001460` | `0000000000000000000000000000000000000000000000000000000000000460` |
| 14 | `0000000000000000000000000000000000000000000000000000000000002930` | `0000000000000000000000000000000000000000000000000000000000000930` |
| 15 | `00000000000000000000000000000000000000000000000000000000000068f3` | `00000000000000000000000000000000000000000000000000000000000028f3` |
| 16 | `000000000000000000000000000000000000000000000000000000000000c936` | `0000000000000000000000000000000000000000000000000000000000004936` |
| 17 | `000000000000000000000000000000000000000000000000000000000001764f` | `000000000000000000000000000000000000000000000000000000000000764f` |
| 18 | `000000000000000000000000000000000000000000000000000000000003080d` | `000000000000000000000000000000000000000000000000000000000001080d` |
| 19 | `000000000000000000000000000000000000000000000000000000000005749f` | `000000000000000000000000000000000000000000000000000000000001749f` |
| 20 | `00000000000000000000000000000000000000000000000000000000000d2c55` | `0000000000000000000000000000000000000000000000000000000000052c55` |
| 21 | `00000000000000000000000000000000000000000000000000000000001ba534` | `00000000000000000000000000000000000000000000000000000000000ba534` |
| 22 | `00000000000000000000000000000000000000000000000000000000002de40f` | `00000000000000000000000000000000000000000000000000000000000de40f` |
| 23 | `0000000000000000000000000000000000000000000000000000000000556e52` | `0000000000000000000000000000000000000000000000000000000000156e52` |
| 24 | `0000000000000000000000000000000000000000000000000000000000dc2a04` | `00000000000000000000000000000000000000000000000000000000005c2a04` |
| 25 | `0000000000000000000000000000000000000000000000000000000001fa5ee5` | `0000000000000000000000000000000000000000000000000000000000fa5ee5` |
| 26 | `000000000000000000000000000000000000000000000000000000000340326e` | `000000000000000000000000000000000000000000000000000000000140326e` |
| 27 | `0000000000000000000000000000000000000000000000000000000006ac3875` | `0000000000000000000000000000000000000000000000000000000002ac3875` |
| 28 | `000000000000000000000000000000000000000000000000000000000d916ce8` | `0000000000000000000000000000000000000000000000000000000005916ce8` |
| 29 | `0000000000000000000000000000000000000000000000000000000017e2551e` | `0000000000000000000000000000000000000000000000000000000007e2551e` |
| 30 | `000000000000000000000000000000000000000000000000000000003d94cd64` | `000000000000000000000000000000000000000000000000000000001d94cd64` |
| 31 | `000000000000000000000000000000000000000000000000000000007d4fe747` | `000000000000000000000000000000000000000000000000000000003d4fe747` |
| 32 | `00000000000000000000000000000000000000000000000000000000b862a62e` | `000000000000000000000000000000000000000000000000000000003862a62e` |
| 33 | `00000000000000000000000000000000000000000000000000000001a96ca8d8` | `00000000000000000000000000000000000000000000000000000000a96ca8d8` |
| 34 | `000000000000000000000000000000000000000000000000000000034a65911d` | `000000000000000000000000000000000000000000000000000000014a65911d` |
| 35 | `00000000000000000000000000000000000000000000000000000004aed21170` | `00000000000000000000000000000000000000000000000000000000aed21170` |
| 36 | `00000000000000000000000000000000000000000000000000000009de820a7c` | `00000000000000000000000000000000000000000000000000000001de820a7c` |
| 37 | `0000000000000000000000000000000000000000000000000000001757756a93` | `0000000000000000000000000000000000000000000000000000000757756a93` |
| 38 | `00000000000000000000000000000000000000000000000000000022382facd0` | `00000000000000000000000000000000000000000000000000000002382facd0` |
| 39 | `0000000000000000000000000000000000000000000000000000004b5f8303e9` | `0000000000000000000000000000000000000000000000000000000b5f8303e9` |
| 40 | `000000000000000000000000000000000000000000000000000000e9ae4933d6` | `00000000000000000000000000000000000000000000000000000069ae4933d6` |
| 41 | `00000000000000000000000000000000000000000000000000000153869acc5b` | `00000000000000000000000000000000000000000000000000000053869acc5b` |
| 42 | `000000000000000000000000000000000000000000000000000002a221c58d8f` | `000000000000000000000000000000000000000000000000000000a221c58d8f` |
| 43 | `000000000000000000000000000000000000000000000000000006bd3b27c591` | `000000000000000000000000000000000000000000000000000002bd3b27c591` |
| 44 | `00000000000000000000000000000000000000000000000000000e02b35a358f` | `00000000000000000000000000000000000000000000000000000602b35a358f` |
| 45 | `0000000000000000000000000000000000000000000000000000122fca143c05` | `0000000000000000000000000000000000000000000000000000022fca143c05` |
| 46 | `00000000000000000000000000000000000000000000000000002ec18388d544` | `00000000000000000000000000000000000000000000000000000ec18388d544` |
| 47 | `00000000000000000000000000000000000000000000000000006cd610b53cba` | `00000000000000000000000000000000000000000000000000002cd610b53cba` |
| 48 | `0000000000000000000000000000000000000000000000000000ade6d7ce3b9b` | `00000000000000000000000000000000000000000000000000002de6d7ce3b9b` |
| 49 | `000000000000000000000000000000000000000000000000000174176b015f4d` | `000000000000000000000000000000000000000000000000000074176b015f4d` |
| 50 | `00000000000000000000000000000000000000000000000000022bd43c2e9354` | `00000000000000000000000000000000000000000000000000002bd43c2e9354` |
| 51 | `00000000000000000000000000000000000000000000000000075070a1a009d4` | `00000000000000000000000000000000000000000000000000035070a1a009d4` |
| 52 | `000000000000000000000000000000000000000000000000000efae164cb9e3c` | `0000000000000000000000000000000000000000000000000006fae164cb9e3c` |
| 53 | `00000000000000000000000000000000000000000000000000180788e47e326c` | `00000000000000000000000000000000000000000000000000080788e47e326c` |
| 54 | `00000000000000000000000000000000000000000000000000236fb6d5ad1f43` | `00000000000000000000000000000000000000000000000000036fb6d5ad1f43` |
| 55 | `000000000000000000000000000000000000000000000000006abe1f9b67e114` | `000000000000000000000000000000000000000000000000002abe1f9b67e114` |
| 56 | `000000000000000000000000000000000000000000000000009d18b63ac4ffdf` | `000000000000000000000000000000000000000000000000001d18b63ac4ffdf` |
| 57 | `00000000000000000000000000000000000000000000000001eb25c90795d61c` | `00000000000000000000000000000000000000000000000000eb25c90795d61c` |
| 58 | `00000000000000000000000000000000000000000000000002c675b852189a21` | `00000000000000000000000000000000000000000000000000c675b852189a21` |
| 59 | `00000000000000000000000000000000000000000000000007496cbb87cab44f` | `00000000000000000000000000000000000000000000000003496cbb87cab44f` |
| 60 | `0000000000000000000000000000000000000000000000000fc07a1825367bbe` | `00000000000000000000000000000000000000000000000007c07a1825367bbe` |
| 61 | `00000000000000000000000000000000000000000000000013c96a3742f64906` | `00000000000000000000000000000000000000000000000003c96a3742f64906` |
| 62 | `000000000000000000000000000000000000000000000000363d541eb611abee` | `000000000000000000000000000000000000000000000000163d541eb611abee` |
| 63 | `0000000000000000000000000000000000000000000000007cce5efdaccf6808` | `0000000000000000000000000000000000000000000000003cce5efdaccf6808` |
| 64 | `000000000000000000000000000000000000000000000000f7051f27b09112d4` | `00000000000000000000000000000000000000000000000077051f27b09112d4` |
| 65 | `000000000000000000000000000000000000000000000001a838b13505b26867` | `000000000000000000000000000000000000000000000000a838b13505b26867` |
| 66 | `000000000000000000000000000000000000000000000002832ed74f2b5e35ee` | `000000000000000000000000000000000000000000000000832ed74f2b5e35ee` |
| 67 | `00000000000000000000000000000000000000000000000730fc235c1942c1ae` | `00000000000000000000000000000000000000000000000330fc235c1942c1ae` |
| 68 | `00000000000000000000000000000000000000000000000bebb3940cd0fc1491` | `000000000000000000000000000000000000000000000003ebb3940cd0fc1491` |
| 69 | `0000000000000000000000000000000000000000000000101d83275fb2bc7e0c` | `0000000000000000000000000000000000000000000000001d83275fb2bc7e0c` |
| 70 | `0000000000000000000000000000000000000000000000349b84b6431a6c4ef1` | `0000000000000000000000000000000000000000000000149b84b6431a6c4ef1` |
| 75 | `0000000000000000000000000000000000000000000004c5ce114686a1336e07` | `0000000000000000000000000000000000000000000000c5ce114686a1336e07` |
| 80 | `00000000000000000000000000000000000000000000ea1a5c66dcc11b5ad180` | `000000000000000000000000000000000000000000006a1a5c66dcc11b5ad180` |
| 85 | `00000000000000000000000000000000000000000011720c4f018d51b8cebba8` | `00000000000000000000000000000000000000000001720c4f018d51b8cebba8` |
| 90 | `000000000000000000000000000000000000000002ce00bb2136a445c71e85bf` | `000000000000000000000000000000000000000000ce00bb2136a445c71e85bf` |
| 95 | `0000000000000000000000000000000000000000527a792b183c7f64a0e8b1f4` | `0000000000000000000000000000000000000000127a792b183c7f64a0e8b1f4` |
| 100 | `000000000000000000000000000000000000000af55fc59c335c8ec67ed24826` | `0000000000000000000000000000000000000002f55fc59c335c8ec67ed24826` |
| 105 | `000000000000000000000000000000000000016f14fc2054cd87ee6396b33df3` | `000000000000000000000000000000000000006f14fc2054cd87ee6396b33df3` |
| 110 | `00000000000000000000000000000000000035c0d7234df7deb0f20cf7062444` | `00000000000000000000000000000000000015c0d7234df7deb0f20cf7062444` |
| 115 | `0000000000000000000000000000000000060f4d11574f5deee49961d9609ac6` | `0000000000000000000000000000000000020f4d11574f5deee49961d9609ac6` |
| 120 | `0000000000000000000000000000000000b10f22572c497a836ea187f2e1fc23` | `0000000000000000000000000000000000310f22572c497a836ea187f2e1fc23` |
| 125 | `000000000000000000000000000000001c533b6bb7f0804e09960225e44877ac` | `000000000000000000000000000000000c533b6bb7f0804e09960225e44877ac` |
| 130 | `000000000000000000000000000000033e7665705359f04f28b88cf897c603c9` | `000000000000000000000000000000013e7665705359f04f28b88cf897c603c9` |

---

# Appendix B — Dataset-specific run manifest

A Region 71 run MUST include:

```text
dataset_filename = KNOWN_PRIVATE_KEYS_PUZZLES
dataset_sha256 = ea1fcb4a5b0dcad39b9b099ac9bffe0b2633975176e72fd8397f962a00009c52
current_region_index = 71
current_region_lower_decimal = 1180591620717411303424
current_region_upper_decimal = 2361183241434822606847
current_region_size = 1180591620717411303424
current_region_lower_hex = 0000000000000000000000000000000000000000000000400000000000000000
current_region_upper_hex = 00000000000000000000000000000000000000000000007fffffffffffffffff
left_raw_width = 1180591620717411303424
right_raw_width = 115792089237316195423570985008687907853269984665640564037096400766478307033088
effective_probe_width_per_side = 1180591620717411303423
left_probe_lower_hex = 0000000000000000000000000000000000000000000000000000000000000001
left_probe_upper_hex = 00000000000000000000000000000000000000000000003fffffffffffffffff
right_probe_lower_hex = 0000000000000000000000000000000000000000000000800000000000000000
right_probe_upper_hex = 0000000000000000000000000000000000000000000000bffffffffffffffffe
probe_geometry_mode = THREE_ZONE_BALANCED_TRIMMED
target_status = CURRENT_SEARCH
sequence_mode = REGION71_FORWARD or REGION71_RETROSPECTIVE
ignored_source_columns = [2, 4, 5]
source_bound_anomaly_rows = [152,153,154,155,156,157,158,159,160]
```

The manifest MUST also include:

- the exact set of verified target indices used for fitting;
- the exact latent indices;
- whether Region 75 or later anchors were used;
- every analogue-validation fold;
- every hidden row in each fold;
- model and feature versions;
- sequence prior safety-tail parameters;
- the frozen prior supplied to the outside-comparison controller.
