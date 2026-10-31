# Non-Collapsing Adaptive Jumping over a 64-Hex Coordinate Space
## Revision 26 — Implementation-Closed Mathematical and Engineering Blueprint

**Short name:** NCAJ-64  
**Coordinate domain:** all 64-character hexadecimal coordinates  
**Domain size:** \(N=16^{64}=2^{256}\)  
**Default range semantics:** `GUIDE_ONLY`  
**Default operation mode:** `BOUNDED_ADAPTIVE`  
**Specification status:** normative implementation blueprint  
**Application scope:** generic search and navigation over a very large indexed space  
**Excluded assumption:** a 64-hex representation does not imply any particular application domain

---

# 1. Normative language

The words **MUST**, **MUST NOT**, **REQUIRED**, **SHOULD**, **SHOULD NOT**, and **MAY** are normative.

An implementation is conforming only when it satisfies every applicable **MUST** and **MUST NOT** rule and passes the required conformance tests.

---

# 2. Purpose

NCAJ-64 defines a reproducible controller that:

1. operates over a \(2^{256}\)-coordinate space;
2. accepts an optional known region;
3. keeps the full coordinate domain executable unless an explicit hard guarantee says otherwise;
4. generates bounded range, complement, global, and reaction jumps;
5. learns useful jump-pattern sequences from declared rewards;
6. treats closer and farther as separate reaction entities;
7. never converts an unobserved hypothesis into a target fact;
8. never silently becomes exhaustive enumeration;
9. never silently becomes simple random guessing;
10. exposes every budget, state transition, scoring rule, and random choice required for independent replication.

The specification distinguishes:

- **navigation improvement**, such as coverage or movement reduction;
- **target-search improvement**, which requires target-correlated information.

An implementation MUST NOT claim target-search improvement from navigation-only feedback.

---

# 3. Coordinate model

Let:

\[
N=16^{64}=2^{256}.
\]

Define:

\[
\Omega=\mathbb Z_N
=
\{0,1,\ldots,N-1\}.
\]

Every \(x\in\Omega\) has one canonical 64-character hexadecimal form:

\[
\operatorname{hex64}(x).
\]

## 3.1 Canonical parsing

```text
parse_hex64(s):
    require type(s) == string
    require len(s) == 64
    require every character belongs to [0-9a-fA-F]
    return exact integer value in [0, 2^256 - 1]
```

## 3.2 Canonical formatting

```text
format_hex64(x):
    require exact integer x
    require 0 <= x < 2^256
    return lowercase hexadecimal, left-padded to exactly 64 characters
```

## 3.3 Canonical byte representation

The binary representation MUST be exactly 32 bytes in big-endian order:

```text
to_bytes32(x):
    require 0 <= x < 2^256
    return x encoded as unsigned 32-byte big-endian
```

## 3.4 Modular operations

\[
x\oplus_Nd=(x+d)\bmod N,
\]

\[
x\ominus_Nd=(x-d)\bmod N.
\]

Clockwise distance:

\[
d_{\mathrm{cw}}(x,y)=(y-x)\bmod N.
\]

Counterclockwise distance:

\[
d_{\mathrm{ccw}}(x,y)=(x-y)\bmod N.
\]

Shortest cyclic distance:

\[
d_{\mathrm{cyc}}(x,y)
=
\min
\left(
d_{\mathrm{cw}}(x,y),
d_{\mathrm{ccw}}(x,y)
\right).
\]

If the two cyclic directions are tied at \(N/2\), the reference tie direction is clockwise.

All coordinate arithmetic MUST use exact integers.

Floating-point coordinate arithmetic is forbidden.

---

# 4. Supplied region

A supplied region is a directed cyclic interval:

\[
\mathcal R(a,M)
=
\{a\oplus_Nz:0\le z<M\},
\]

where:

\[
a\in\Omega,
\qquad
1\le M\le N.
\]

The length \(M\) MUST be represented by an integer type capable of representing \(N\), which may require 257 bits or arbitrary precision.

The complement is:

\[
\mathcal O=\Omega\setminus\mathcal R.
\]

Let:

\[
C=N-M.
\]

## 4.1 Region membership

For \(x\in\Omega\), define:

\[
r(x)=(x-a)\bmod N.
\]

Then:

\[
x\in\mathcal R
\iff
r(x)<M.
\]

For \(x\in\mathcal R\), the local range coordinate is:

\[
z_R(x)=r(x).
\]

For \(x\in\mathcal O\), the local complement coordinate is:

\[
z_O(x)=r(x)-M,
\]

with:

\[
0\le z_O(x)<C.
\]

## 4.2 Region semantics

Choose exactly one.

### GUIDE_ONLY

The region is focus information.

It does not assert that the target lies inside it.

The active executable domain remains:

\[
\Omega_{\mathrm{active}}=\Omega.
\]

This is the default when only a region is supplied.

### SOFT_HINT

The region may receive greater focus, but complement operations and positive target support remain available.

Any probabilistic weighting MUST be separately calibrated.

An uncalibrated weighting MUST be called a **focus field**, not a posterior.

### HARD_PROMISE

An external contract guarantees that every valid target lies inside \(\mathcal R\).

Only this mode may initialize target support to \(\mathcal R\).

It MUST NOT be inferred merely because a region was supplied.

### LANDMARK

The region is used for orientation, route choice, or pattern measurement.

It does not alter target support.

---

# 5. Independent state spaces

The implementation MUST keep these states separate.

## 5.1 Executable domain

\[
\Omega.
\]

It never shrinks.

## 5.2 Declared target domain

\[
\mathcal D\subseteq\Omega.
\]

If no narrower target domain is declared:

\[
\mathcal D=\Omega.
\]

## 5.3 Guide region

\[
\mathcal R.
\]

It affects only the behaviors allowed by its semantics.

## 5.4 Evidence-consistent target support

\[
V_k\subseteq\mathcal D.
\]

It may shrink only after genuine target-correlated evidence.

Under `GUIDE_ONLY`, `SOFT_HINT`, or `LANDMARK`, the guide region alone MUST NOT remove:

\[
\mathcal D\setminus\mathcal R.
\]

## 5.5 Operation history

This records executed operations.

It does not determine where the target may exist.

## 5.6 Exact-test ledger

This records verified target tests.

It does not define the target domain.

---

# 6. Target-existence contract

Choose exactly one.

## HIDDEN_SINGLE_TARGET

Exactly one hidden target exists.

## HIDDEN_MULTIPLE_TARGETS

More than one valid target may exist.

The implementation MUST supply a separate observation, support, and stopping model.

## TARGET_MAY_BE_ABSENT

No target may exist.

Finite budgets and an explicit not-found result are REQUIRED.

## NAVIGATION_WITHOUT_TARGET

There is no target-search objective.

Target direction MUST NOT be inferred.

---

# 7. Observation interfaces

Every interface is declared independently.

## 7.1 Exact hit test

```text
hit_test(x, test_identity, test_version)
    -> HIT | MISS
```

A hit test provides no direction.

## 7.2 Region-membership observation

```text
in_region(x) -> true | false
```

This is known geometry.

It provides no exact-target information unless a separate validated model says otherwise.

## 7.3 Scalar objective score

```text
score(x, provider_identity, provider_version)
    -> fixed-point integer plus status
```

The reference implementation MUST use fixed-point output.

A floating implementation MAY be used only when:

- precision is declared;
- rounding is declared;
- cross-platform reproducibility is demonstrated.

A scalar score may affect target search only when target correlation is validated.

Otherwise it is a navigation score.

## 7.4 Exact target comparison

```text
compare(anchor, proposal, target_identity, target_version)
    -> CLOSER | FARTHER | EQUAL
```

For target metric \(d_T\):

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

The metric, provider, version, cost, admissible input pairs, and failure statuses MUST be declared.

## 7.5 Noisy comparison

```text
compare_noisy(anchor, proposal, target_identity, target_version)
    -> observation, likelihood_metadata, status
```

It requires:

- a calibrated likelihood;
- a dependence model;
- a finite attempt limit;
- bounded update work;
- a separately stated theorem or empirical acceptance rule.

It does not inherit exact-comparison guarantees.

## 7.6 Execution status

Execution status is independent of the observation.

Required statuses include:

```text
SUCCESS
NO_RESULT
TIMEOUT
UNAVAILABLE
ROUTE_FAILED
RETURN_FAILED
VERSION_CHANGED
INADMISSIBLE
```

Only a `SUCCESS` record may contain a valid target observation.

---

# 8. Evidence-support representation

An implementation MUST NOT explicitly enumerate \(V_k\) unless the declared support is small enough for the memory budget.

Choose one bounded support representation.

Every representation used for learning MUST expose a deterministic nonnegative uncertainty measure:

\[
\mathcal U(V_k).
\]

Lower values mean less uncertainty.

The uncertainty function, numeric scale, and version MUST be stored in the manifest.

## 8.1 NONE

No target support is maintained.

Allowed in navigation mode.

No evidence-gain reward is available:

\[
G_{\mathrm{evidence}}=0.
\]

## 8.2 LINEAR_INTERVAL

\[
V_k=[L_k,U_k]\cap\mathbb Z.
\]

Storage:

\[
O(1).
\]

Reference uncertainty:

\[
\mathcal U(V_k)=U_k-L_k+1.
\]

## 8.3 CYCLIC_INTERVAL_SET_K

A union of at most \(K_V\) pairwise-disjoint directed cyclic intervals.

Operations MUST remain bounded by \(K_V\).

Reference uncertainty is the exact total cardinality:

\[
\mathcal U(V_k)
=
\sum_{j=1}^{m_k}|I_{k,j}|,
\qquad
m_k\le K_V.
\]

If conditioning would create more than \(K_V\) intervals, the configured merge, approximation, or failure policy applies.

A merge policy MUST NOT claim an exact posterior after approximation.

## 8.4 WEIGHTED_PARTICLES_K

At most \(K_V\) weighted target hypotheses.

Weights MUST be nonnegative integers:

\[
w_i\ge0,
\qquad
W=\sum_iw_i>0.
\]

Choose uncertainty scale:

\[
Q_U\ge1.
\]

Reference effective-support uncertainty:

\[
\mathcal U_Q(V_k)
=
\left\lfloor
\frac{
Q_UW^2
}{
\sum_iw_i^2
}
\right\rfloor.
\]

This quantity decreases as the normalized weight distribution becomes more concentrated.

Resampling algorithm, seed use, weight scale, rounding, and degeneracy threshold MUST be specified.

Evidence reward MUST be calculated from the conditioned pre-resampling weights or from another declared resampling-invariant uncertainty estimate.

Resampling by itself MUST receive zero evidence-gain reward.

## 8.5 WEIGHTED_BINS_K

At most \(K_V\) weighted bins.

Use the same fixed-point effective-support uncertainty as Section 8.4, applied to bin weights.

Bin boundaries, update rules, normalization, and empty-bin handling MUST be specified.

## 8.6 APPLICATION_BOUNDED

The application supplies:

```text
uncertainty_measure()
partition(anchor, proposal, observation_model)
condition(observation)
contains(x)
sample_or_representatives(limit)
memory_bound()
work_bound()
representation_version()
```

`uncertainty_measure()` MUST return a deterministic nonnegative integer.

All operations MUST have declared finite bounds.

## 8.7 Evidence update rule

A target observation may update \(V_k\) only when:

1. the observation status is `SUCCESS`;
2. target identity and version match;
3. the support representation can apply the update within budget;
4. the observation law is declared valid.

Otherwise:

\[
V_{k+1}=V_k.
\]

The implementation MUST record:

\[
\mathcal U_{\mathrm{before}},
\qquad
\mathcal U_{\mathrm{after}}.
\]

Normalized probability mass is not an uncertainty measure because it normally renormalizes to one.

---

# 9. Execution adapter

Choose one adapter.

## 9.1 VIRTUAL

No physical movement is required.

## 9.2 RANDOM_ACCESS

A coordinate can be probed or tested directly.

## 9.3 MOVE_COMMITTED

The physical position becomes the selected coordinate after successful movement.

## 9.4 MOVE_TRIAL_RETURNABLE

The controller may move to a proposal, observe it, and return to the retained anchor.

## 9.5 APPLICATION_ADAPTER

The application supplies bounded:

```text
admissible(state, ticket, candidate)
predict_cost(state, ticket, candidate)
worst_case_cost(state, ticket, candidate)
execute(state, ticket, candidate)
restore(state, retained_anchor)
```

`worst_case_cost` MUST be a valid upper bound for every hard-budget component, or the adapter MUST provide atomic capped execution.

## 9.6 Cost contract

Every predicted, worst-case, and actual cost record uses nonnegative integers:

```text
movement_cost
probe_cost
test_cost
observation_cost
evaluation_cost
```

Each unit and normalization rule MUST be identified by `cost_model_id` and `cost_model_version`.

Before execution, the controller checks worst-case costs against remaining hard budgets.

After execution, budget counters are decremented by actual recorded costs.

If an actual cost exceeds its declared worst-case bound, the implementation MUST return:

```text
COST_CONTRACT_VIOLATION
```

and terminate the affected run.

---

# 10. Ticket model

Testing, probing, movement, comparison, and adaptive selection MUST be scheduled explicitly.

A ticket is:

\[
\tau=
(
\text{region class},
\text{operation kind},
\text{selection mode},
\text{ordered fixed arms}
).
\]

## 10.1 Region classes

```text
RANGE
COMPLEMENT
GLOBAL
EVIDENCE_SUPPORT
```

A candidate satisfies a ticket region class exactly as follows:

\[
\operatorname{match}(Y,\texttt{RANGE})
\iff
Y.y\in\mathcal R,
\]

\[
\operatorname{match}(Y,\texttt{COMPLEMENT})
\iff
Y.y\in\mathcal O,
\]

\[
\operatorname{match}(Y,\texttt{GLOBAL})
\iff
Y.y\in\Omega,
\]

\[
\operatorname{match}(Y,\texttt{EVIDENCE\_SUPPORT})
\iff
Y.y\in V_k.
\]

For a comparison ticket, the predicate applies to the proposal coordinate unless the ticket schema explicitly declares a pair constraint.

`GLOBAL` may generate any coordinate and therefore does not, by itself, guarantee an outside-region operation.

`EVIDENCE_SUPPORT` is valid only when a support representation exists.

## 10.2 Operation kinds

```text
MOVE
PROBE
EXACT_TEST
COMPARE
```

Final verification of an already isolated singleton is a terminal operation, not an epoch ticket.

## 10.3 Selection modes

```text
FIXED
ADAPTIVE
```

A `FIXED` ticket MUST declare a nonempty ordered list:

```text
fixed_arm_ids
```

The controller tries those arms in that exact order.

An `ADAPTIVE` ticket uses the contextual learner.

## 10.4 Ticket counts

Let \(\mathcal T\) be the finite configured ticket set.

For each ticket \(\tau\), choose integer count:

\[
K_\tau\ge0.
\]

Epoch length is:

\[
E=\sum_{\tau\in\mathcal T}K_\tau.
\]

No intended service may be represented only by a fractional percentage.

## 10.5 Non-collapse validation

When:

- \(M<N\);
- range semantics are `GUIDE_ONLY`, `SOFT_HINT`, or `LANDMARK`;

the epoch MUST contain at least one executable ticket whose region class is:

```text
COMPLEMENT
```

A `GLOBAL` ticket does not satisfy this requirement because a bounded global prefix may remain inside the range.

If:

- a hidden target may be outside \(\mathcal R\);
- exact tests are enabled;

the configured epoch MUST contain at least one:

```text
(COMPLEMENT, EXACT_TEST, FIXED or ADAPTIVE)
```

ticket.

If the method is described as adaptive, at least one ticket MUST use `ADAPTIVE` selection.

## 10.6 Fresh exact-test requirement

An `EXACT_TEST` ticket MUST select a coordinate with no compatible certificate in the exact-test ledger.

A stored `MISS` prevents duplicate work but does not complete another exact-test ticket and does not count as new progress.

If no fresh compatible coordinate can be generated within the bounded arm and candidate attempts, the ticket fails with:

```text
NO_FRESH_TEST_CANDIDATE
```

## 10.7 No implicit exact tests

An exact test occurs only under an `EXACT_TEST` ticket or as the one terminal verification of an isolated candidate.

Movement and probe tickets MUST NOT silently perform an exact test.

---

# 11. Reproducible online scheduler

For ticket \(\tau\), maintain:

- configured count \(K_\tau\);
- emitted count \(S_\tau(n)\).

At zero-based epoch position \(n\), among tickets with remaining count, choose the ticket maximizing:

\[
D_\tau(n)
=
(n+1)K_\tau
-
E\,S_\tau(n).
\]

Tie order is the canonical tuple order:

1. `ADAPTIVE` before `FIXED`;
2. `EXACT_TEST`, `COMPARE`, `PROBE`, `MOVE`;
3. `COMPLEMENT`, `GLOBAL`, `RANGE`, `EVIDENCE_SUPPORT`;
4. configured ticket identifier.

The tie order MAY be overridden only when the override is stored in the run manifest.

At the end of the epoch:

- all emitted counters reset to zero;
- configured ticket counts remain unchanged;
- the next epoch begins only if budgets remain.

The scheduler uses:

\[
O(|\mathcal T|)
\]

work and state per transaction.

Since \(|\mathcal T|\) is configuration-bounded, this is constant relative to \(N\).

---

# 12. Jump-pattern contexts and arms

The learner operates over finite contexts and finite arms.

`FIXED` tickets do not use the contextual exploration index; they use their declared `fixed_arm_ids`.

## 12.1 Pattern order

Choose:

\[
H\in\{0,1,2\}.
\]

The context remembers the previous \(H\) executed arm identifiers.

Larger unbounded pattern histories are forbidden in the reference implementation.

## 12.2 Context key

A context is:

\[
\kappa=
(
\text{ticket id},
\text{current coordinate class},
\text{last observation class},
\text{previous }H\text{ arm ids}
).
\]

The current coordinate class is:

```text
RANGE
COMPLEMENT
```

Observation classes are:

```text
NONE
CLOSER
FARTHER
EQUAL
HIT
MISS
SCORE_UP
SCORE_DOWN
SCORE_SAME
FAILURE
```

The maximum context count is:

\[
K_{\mathrm{ctx}}
\le
|\mathcal T|
\cdot
2
\cdot
10
\cdot
(K_{\mathrm{arm}}+1)^H.
\]

The configuration MUST fit this bound inside the memory budget.

## 12.3 Arm definition

An arm is:

\[
A_i=
(
\text{arm id},
\text{generator id},
\text{compatible tickets},
\text{direction policy},
\text{scale policy},
\text{reaction policy}
).
\]

Example arms:

```text
RANGE_LEFT_LOCAL
RANGE_RIGHT_LOCAL
RANGE_LEFT_MULTISCALE
RANGE_RIGHT_MULTISCALE
REGION_ENTRY
COMPLEMENT_AFFINE
GLOBAL_AFFINE
GLOBAL_GAP
CLOSER_CONTINUE
FARTHER_REVERSE
FARTHER_SIDE_STEP
```

The arm set is finite and versioned.

Dynamic creation of unlimited arms is forbidden.

## 12.4 Context-arm state

For each enabled pair \((\kappa,i)\), store:

- trial count:
  \[
  n_{\kappa,i};
  \]
- successful execution count;
- cumulative fixed-point reward:
  \[
  R_{\kappa,i};
  \]
- generation-failure count;
- execution-failure count;
- initialization state:
  ```text
  UNTRIED
  GENERATION_FAILED
  TRIED
  ```
- last trial transaction;
- nominal scale;
- enabled state.

A trial count increments whenever a candidate from the arm is actually executed, whether execution succeeds or fails.

A generator failure does not increment the trial count, but it marks the arm `GENERATION_FAILED` for the current initialization pass so it cannot block all later arms.

---

# 13. Deterministic contextual exploration index

The reference learner uses only integer arithmetic.

Let reward scale be:

\[
Q_R\ge1.
\]

Rewards are integers in:

\[
\{0,\ldots,Q_R\}.
\]

## 13.1 Initialization phase

Within each new context, every enabled compatible arm is considered once in ascending arm-id order before an already tried arm is reused.

For one arm:

- if it produces an executed candidate, mark it `TRIED`;
- if bounded generation produces no admissible candidate, mark it `GENERATION_FAILED`;
- then continue to the next arm.

A `GENERATION_FAILED` arm MAY be reconsidered only after the configured cooldown or a meaningful state change.

## 13.2 Exploration index

For a tried context-arm pair:

\[
\mu_{\kappa,i}
=
\left\lfloor
\frac{R_{\kappa,i}}{n_{\kappa,i}}
\right\rfloor.
\]

Let \(t_\kappa\) be the number of completed adaptive arm trials in context \(\kappa\).

Define the exact integer logarithm term:

\[
L_\kappa
=
\operatorname{bit\_length}
(
\max(1,t_\kappa)
),
\]

which equals:

\[
\left\lceil
\log_2(t_\kappa+1)
\right\rceil
\]

for \(t_\kappa\ge1\).

Define:

\[
X_{\kappa,i}
=
\left\lfloor
\frac{
2L_\kappa Q_R^2
}{
n_{\kappa,i}
}
\right\rfloor.
\]

Let:

\[
s_{\kappa,i}
=
\operatorname{isqrt}
(
X_{\kappa,i}
).
\]

For configured exploration coefficient:

\[
c_E\in\{0,\ldots,Q_R\},
\]

define:

\[
B_{\kappa,i}
=
\left\lfloor
\frac{
c_Es_{\kappa,i}
}{
Q_R
}
\right\rfloor.
\]

The arm index is:

\[
I_{\kappa,i}
=
\mu_{\kappa,i}
+
B_{\kappa,i}.
\]

Select the enabled compatible `TRIED` arm with maximum \(I_{\kappa,i}\).

Tie order is ascending arm id.

This is a deterministic exploration heuristic.

No claim of universal optimality is made.

## 13.3 Arm failure handling

If the selected arm produces no admissible candidate:

1. increment its generation-failure count;
2. place it in cooldown when configured;
3. try the next-highest eligible arm;
4. stop after:
   \[
   K_{\mathrm{arm\_attempt}}
   \]
   arm attempts.

No unbounded arm scan is allowed.

If a candidate is executed and execution fails, the trial count increments and the configured failure reward is applied.

---

# 14. Candidate-generation interface

Every generator implements:

```text
generate(
    controller_state,
    ticket,
    arm_state,
    limit
) -> ordered candidate list plus generator status
```

Requirements:

- output length is at most `limit`;
- output order is deterministic;
- work is bounded;
- no full-domain, full-range, or full-complement scan occurs;
- generator version is recorded;
- every candidate includes an operation class;
- every stateful generator exposes serializable state;
- generator state changes only through a logged deterministic transition.

Stateful examples include affine source index \(j\), offsets, strides, permutation counters, cooldowns, and bounded priority-queue versions.

---

# 15. Reference candidate generators

## 15.1 Range boundary generator

If:

\[
M=1,
\]

the sole range coordinate may be returned when compatible.

For:

\[
M>1,
\]

let \(x\in\mathcal R\) and:

\[
z=z_R(x).
\]

Construct at most \(K_{\mathrm{scale}}\) unique scales from:

\[
1,
\left\lfloor\frac{\sigma}{2}\right\rfloor,
\sigma,
2\sigma,
\left\lfloor\frac M8\right\rfloor,
\left\lfloor\frac M4\right\rfloor,
\left\lfloor\frac M2\right\rfloor.
\]

Keep only scales in:

\[
[1,M-1].
\]

Generate:

\[
z_L=\max(0,z-s),
\]

\[
z_R'=\min(M-1,z+s).
\]

Map to:

\[
y_L=a\oplus_Nz_L,
\]

\[
y_R=a\oplus_Nz_R'.
\]

Zero-displacement and duplicate candidates are removed.

## 15.2 Region-entry generator

For \(x\notin\mathcal R\), configured landmarks MAY include:

\[
a,
\]

\[
a\oplus_N(M-1),
\]

\[
a\oplus_N\left\lfloor\frac{M-1}{2}\right\rfloor.
\]

The generator selects at most the configured number of lowest-cost landmarks.

This is navigation toward the region, not proof of target direction.

## 15.3 Complement affine generator

If:

\[
C=0,
\]

the generator is disabled.

If:

\[
C=1,
\]

emit:

\[
a\oplus_NM.
\]

If:

\[
C>1,
\]

choose offset:

\[
b_O\in[0,C-1],
\]

and stride:

\[
q_O\in[1,C-1]
\]

with:

\[
\gcd(q_O,C)=1.
\]

Try at most \(K_{\gcd}\) configured or seeded stride candidates.

If none is coprime, use:

\[
q_O=1.
\]

For source index \(j\):

\[
u_j=(b_O+jq_O)\bmod C,
\]

\[
y_j=a\oplus_N(M+u_j).
\]

The emitted prefix length is bounded.

## 15.4 Global affine generator

Choose:

\[
b_G\in[0,N-1],
\]

and odd:

\[
q_G\in[1,N-1].
\]

For source index \(j\):

\[
y_j=b_G\oplus_N(jq_G).
\]

Since:

\[
\gcd(q_G,N)=1,
\]

the complete sequence would be a permutation, but the adaptive controller emits only a bounded prefix.

## 15.5 Gap generator

The gap generator reads at most \(K_{\mathrm{gap}}\) top deficit representatives from the applicable sketch.

It MUST NOT scan every sketch bin during a transaction.

## 15.6 Reaction generator

The implementation supports two bounded packet types.

### Observed reaction packet

Created only after a valid target-linked result.

\[
P_O=
(
\text{source transaction},
\text{anchor},
\text{proposal},
\text{direction chart},
\text{direction},
\text{magnitude},
\text{observed class},
\text{expiry transaction}
).
\]

If the observed class is `CLOSER`, only closer-compatible reactions are generated.

If the observed class is `FARTHER`, only farther-compatible reactions are generated.

### Counterfactual dual packet

MAY be created when the application intentionally preserves both reaction hypotheses before or without target feedback.

\[
P_D=
(
\text{source transaction},
\text{anchor},
\text{proposal},
\text{direction chart},
\text{direction},
\text{magnitude},
\text{closer reaction set},
\text{farther reaction set},
\text{expiry transaction}
).
\]

The dual packet:

- contains at most one bounded closer set and one bounded farther set;
- is valid for at most one adaptive opportunity;
- generates candidates but does not update target support;
- does not assert that both relations were true;
- rewards only the arm that is actually executed.

### Closer reactions

Configured examples:

- continue the same direction;
- expand or retain magnitude using a bounded rational gain set.

### Farther reactions

Configured examples:

- reverse direction;
- side-step using a declared chart;
- contract or change magnitude using a bounded rational gain set.

At most one observed packet or one dual packet is active at a time.

## 15.7 Optional custom generator

A custom generator is conforming only when it declares:

- deterministic inputs;
- output order;
- maximum outputs;
- maximum work;
- memory use;
- version;
- admissibility requirements.

---

# 16. Direction charts

A cyclic coordinate does not have one universal signed direction.

Every directional arm MUST declare a direction chart.

## 16.1 CYCLIC_CW_CCW

Direction is:

```text
CW
CCW
```

with magnitude in:

\[
[1,N-1].
\]

## 16.2 RANGE_LOCAL

Direction is:

```text
LEFT
RIGHT
```

in local range coordinates.

## 16.3 LINEAR_TARGET_CHART

A declared bijection:

\[
\phi:\mathcal D\to\{0,\ldots,S-1\}
\]

defines linear direction for an exact comparison module.

The observation law MUST be valid in this chart.

## 16.4 APPLICATION_CHART

The application supplies bounded:

```text
delta(anchor, proposal)
step(origin, direction, magnitude)
reverse(direction)
```

Without a direction chart, closer/farther reaction arms are disabled.

---

# 17. Coverage sketches

Maintain separate bounded sketches when applicable.

## 17.1 Range sketch

Domain size:

\[
S_R=M.
\]

Coordinate:

\[
z_R(x).
\]

## 17.2 Complement sketch

Enabled when:

\[
C>0.
\]

Domain size:

\[
S_O=C.
\]

Coordinate:

\[
z_O(x).
\]

## 17.3 Global sketch

Domain size:

\[
S_G=N.
\]

Coordinate:

\[
z_G(x)=x.
\]

## 17.4 Bin mapping

For sketch domain size \(S\), level \(\ell\), and:

\[
B_\ell=2^\ell,
\]

define:

\[
b_\ell(z)
=
\min
\left(
B_\ell-1,
\left\lfloor
\frac{zB_\ell}{S}
\right\rfloor
\right).
\]

Each bin stores:

- seen bit;
- saturating count;
- representative coordinate;
- deficit;
- version.

Total bins across all sketches MUST be at most:

\[
B_{\mathrm{sketch}}.
\]

## 17.5 Deficit

For a coordinate \(z\):

\[
D(z)
=
\frac1{L+1}
\sum_{\ell=0}^{L}
\left[
\alpha(1-s_{\ell,b_\ell(z)})
+
(1-\alpha)
\frac1{1+n_{\ell,b_\ell(z)}}
\right].
\]

The reference implementation stores a fixed-point approximation.

Sketch updates touch only:

- one bin per level;
- at most \(K_{\mathrm{neighbor}}\) configured neighboring bins.

A bounded indexed priority structure maintains high-deficit representatives.

---

# 18. Candidate record and local scoring

A candidate is:

\[
Y=
(
y,
\text{operation kind},
\text{region class},
\text{arm id},
\text{generator id},
\text{provenance},
\text{anchor},
\text{direction chart},
\text{direction},
\text{magnitude},
\text{predicted costs},
\text{worst-case costs},
\text{admissibility},
\text{version}
).
\]

At most:

\[
K_{\mathrm{candidate}}
\]

candidates are generated by the selected arm.

## 18.1 Duplicate merge

Candidates are operation-equivalent only when they have the same:

- coordinate;
- operation kind;
- target-test identity where applicable;
- comparison anchor where applicable.

Operation-equivalent candidates are merged.

For an `EXACT_TEST` ticket, a candidate with a compatible existing certificate is removed rather than merged into a fresh-test candidate.

## 18.2 Fixed-point candidate score

Choose score scale:

\[
Q_S\ge1.
\]

Every component is an integer in:

\[
[0,Q_S].
\]

Define:

\[
U(Y)
=
w_DD(Y)
+
w_FF(Y)
+
w_TT(Y)
+
w_BB(Y)
-
w_CC(Y)
-
w_RR(Y)
-
w_EE(Y).
\]

Where:

- \(D\): immediate sketch deficit;
- \(F\): allowed region focus;
- \(T\): valid target-linked value;
- \(B\): directional or reaction balance;
- \(C\): normalized predicted operation cost;
- \(R\): repeat or oscillation penalty;
- \(E\): normalized evaluator cost.

All weights are nonnegative integers and versioned.

The utility accumulator MUST use arbitrary-precision signed integers or a validated width that cannot overflow:

\[
\sum_j w_jQ_S.
\]

Every component function MUST declare:

```text
component_id
component_version
input_fields
fixed_point_scale
rounding_rule
work_bound
```

The manifest MUST identify the exact component implementations.

## 18.3 Reference component requirements

### Coverage component

\(D(Y)\) is derived from the applicable bounded sketch deficit.

### Focus component

\(F(Y)\) uses configured fixed-point values for in-range and outside-range candidates.

Under `GUIDE_ONLY`, \(F\) may prioritize but MUST NOT make outside candidates inadmissible.

### Target component

\[
T(Y)=0
\]

unless derived from:

- a validated comparison model;
- a calibrated scalar target score;
- a calibrated prior;
- another declared target-correlated model.

Range geometry alone MUST NOT make \(T(Y)>0\).

### Cost components

\(C(Y)\) and \(E(Y)\) are normalized against declared per-ticket caps using exact integer arithmetic.

### Repeat component

\(R(Y)\) is produced by the versioned revisit and oscillation policy.

## 18.4 Candidate tie order

1. admissible before inadmissible;
2. higher \(U(Y)\);
3. lower worst-case total cost;
4. lower predicted total cost;
5. lower repeat penalty;
6. lower coordinate;
7. lower generator id.

---

# 19. Reward contract

The executed arm is updated from observed outcomes.

Rewards MUST NOT treat `CLOSER` as intrinsically good and `FARTHER` as intrinsically bad.

Either result may be equally informative.

Choose reward scale:

\[
Q_R.
\]

## 19.1 Coverage gain

Let \(h_t\) be the number of newly seen tracked bins and \(h_{\max}\) the maximum bins that the operation could touch.

\[
G_{\mathrm{coverage}}
=
\begin{cases}
0,&h_{\max}=0,\\
\left\lfloor
\frac{Q_Rh_t}{h_{\max}}
\right\rfloor,&h_{\max}>0.
\end{cases}
\]

## 19.2 Evidence gain

Let:

\[
\mathcal U_{\mathrm{before}}
\]

and:

\[
\mathcal U_{\mathrm{after}}
\]

be the uncertainty values declared by Section 8.

Define:

\[
G_{\mathrm{evidence}}
=
\begin{cases}
0,&\mathcal U_{\mathrm{before}}=0,\\
\operatorname{clip}_{[0,Q_R]}
\left(
\left\lfloor
Q_R
\frac{
\mathcal U_{\mathrm{before}}
-
\mathcal U_{\mathrm{after}}
}{
\mathcal U_{\mathrm{before}}
}
\right\rfloor
\right),
&\mathcal U_{\mathrm{before}}>0.
\end{cases}
\]

A normalized posterior mass of one is not used as uncertainty.

A valid `CLOSER` and a valid `FARTHER` receive reward according to actual uncertainty reduction, not the label name.

## 19.3 Scalar-score gain

For fixed-point score \(s\), with declared maximum useful improvement \(\Delta_{\max}>0\):

\[
G_{\mathrm{score}}
=
\operatorname{clip}_{[0,Q_R]}
\left(
\left\lfloor
\frac{
Q_R(s_{\mathrm{after}}-s_{\mathrm{before}})
}{
\Delta_{\max}
}
\right\rfloor
\right).
\]

## 19.4 Ticket completion

\[
G_{\mathrm{ticket}}
=
\begin{cases}
Q_R,&\text{primary ticket completed},\\
0,&\text{otherwise}.
\end{cases}
\]

## 19.5 Cost penalty

For declared per-ticket cost cap \(C_{\max}>0\):

\[
P_{\mathrm{cost}}
=
\operatorname{clip}_{[0,Q_R]}
\left(
\left\lfloor
\frac{
Q_RC_{\mathrm{actual}}
}{
C_{\max}
}
\right\rfloor
\right).
\]

## 19.6 Repeat penalty

\[
P_{\mathrm{repeat}}
\in[0,Q_R]
\]

is calculated by the declared repeat policy.

## 19.7 Total reward

Choose nonnegative integer weights:

\[
\beta_C,
\beta_E,
\beta_S,
\beta_T,
\beta_K,
\beta_R.
\]

Let:

\[
W=
\beta_C+\beta_E+\beta_S+\beta_T+\beta_K+\beta_R.
\]

Require:

\[
W>0.
\]

Then:

\[
r_t
=
\operatorname{clip}_{[0,Q_R]}
\left(
\left\lfloor
\frac{
\beta_CG_{\mathrm{coverage}}
+
\beta_EG_{\mathrm{evidence}}
+
\beta_SG_{\mathrm{score}}
+
\beta_TG_{\mathrm{ticket}}
-
\beta_KP_{\mathrm{cost}}
-
\beta_RP_{\mathrm{repeat}}
}{
W
}
\right\rfloor
\right).
\]

The division in the reward formula uses mathematical floor, not language-specific truncation toward zero.

The reward accumulator MUST use arbitrary precision or a validated nonoverflowing signed width.

The reward is assigned to the executed context-arm pair.

The context-arm trial count increments for every executed attempt, including failed execution. A configured failure reward, normally zero, is recorded for failed attempts.

A reaction arm is rewarded when that reaction arm is later executed, not merely when it is created.

---

# 20. Scale policies

Every directional arm declares one scale policy.

All multiplicative gains MUST be exact rational pairs.

For gain \(g\), store:

\[
g=\frac{p_g}{q_g},
\qquad
p_g\ge0,
\quad
q_g>0.
\]

## 20.1 FIXED_SCALE

The scale never changes.

## 20.2 LABEL_REACTION_SCALE

For configured closer gain:

\[
g_C=\frac{p_C}{q_C},
\]

a real `CLOSER` result updates:

\[
\sigma
\leftarrow
\operatorname{clip}
\left(
\left\lfloor
\frac{p_C\sigma}{q_C}
\right\rfloor,
1,
\sigma_{\max}
\right).
\]

For configured farther gain:

\[
g_F=\frac{p_F}{q_F},
\]

a real `FARTHER` result updates:

\[
\sigma
\leftarrow
\operatorname{clip}
\left(
\left\lfloor
\frac{p_F\sigma}{q_F}
\right\rfloor,
1,
\sigma_{\max}
\right).
\]

The values do not assume that one label is more informative.

They define only the next proposal scale.

## 20.3 REWARD_SELECTED_SCALE

Scale choices are separate finite arms and are learned from reward.

This is the reference choice when closer/farther reaction semantics are uncertain.

## 20.4 ACTUAL_DISPLACEMENT

Either set:

\[
\sigma\leftarrow d_{\mathrm{actual}},
\]

or use configured rational blend:

\[
\sigma
\leftarrow
\left\lfloor
\frac{
p_Bd_{\mathrm{actual}}
+
(q_B-p_B)\sigma_{\mathrm{old}}
}{
q_B
}
\right\rfloor,
\]

where:

\[
0\le p_B\le q_B,
\qquad
q_B>0.
\]

## 20.5 Missing result

A failed or missing observation MUST NOT trigger a closer/farther scale update.

---

# 21. Exact-test ledger and revisit policy

## 21.1 Exact-test certificate

A certificate is:

\[
(
x,
\text{test identity},
\text{test version},
\text{result},
\text{integrity status}
).
\]

A valid matching `MISS` prevents another exact oracle call at that coordinate.

It does not satisfy a future fresh `EXACT_TEST` ticket and does not count as progress.

A valid matching `HIT` terminates the run.

An `EXACT_TEST` generator MUST exclude coordinates with compatible certificates.

## 21.2 Terminal verification

When evidence has isolated exactly one candidate, the controller MAY perform one terminal verification.

The verification:

- consumes the exact-test budget;
- uses a compatible test identity and version;
- is exempt from the adaptive unique-test ceiling in Section 26.1;
- is not treated as an epoch `EXACT_TEST` ticket.

If no compatible verifier exists, return:

```text
ISOLATED_UNVERIFIED
```

## 21.3 Movement revisits

Movement and probe revisits are permitted.

Choose one:

```text
ALLOW
PENALIZE
FORBID_IMMEDIATE_REPEAT
```

A general `FORBID_ALL_REVISITS` policy is nonconforming unless the application proves it cannot break:

- return movement;
- route traversal;
- range re-entry;
- required anchor restoration.

---

# 22. Stagnation and bounded rescue

A meaningful progress event is at least one of:

- a newly seen tracked coarse bin;
- a newly seen tracked fine bin;
- a new exact-test certificate;
- positive evidence reduction;
- positive validated scalar-score improvement;
- completion of a previously blocked ticket;
- lower actual cost for the same context and operation class by a declared margin.

The following alone are not progress:

- a new coordinate in history;
- nonzero movement;
- direction switching;
- reaction-packet creation;
- evaluator work.

Use this finite rescue state machine:

```text
NORMAL
WIDEN_SCALE_ONCE
FORCE_GAP_ONCE
FORCE_COMPLEMENT_ONCE
FORCE_GLOBAL_ONCE
DISABLE_INVALID_TARGET_MODEL
NONLEARNING_BASELINE
TERMINATE_NO_PROGRESS
```

A meaningful progress event may reset the rescue state.

The number of resets is bounded by:

\[
K_{\mathrm{rescue\_epoch}}.
\]

No rescue state activates exhaustive certification.

If only a seeded baseline generator remains, the status MUST be:

```text
BASELINE_ONLY
```

and adaptive superiority MUST NOT be claimed.

---

# 23. Budget model

Declare finite nonnegative budgets:

```text
transaction_budget
movement_budget
probe_budget
exact_test_budget
comparison_budget
observation_attempt_budget
evaluation_budget
memory_budget_bytes
```

## 23.1 Budget order

Before a transaction:

1. verify the transaction budget;
2. verify the ticket-specific remaining budget;
3. verify predicted admissibility;
4. execute;
5. charge actual costs;
6. terminate immediately if any hard budget is exceeded.

An operation MUST NOT begin when its declared worst-case cost exceeds the remaining hard budget, unless the adapter supports an atomic capped execution.

## 23.2 Memory validation

Before execution, estimate maximum memory for:

- contexts;
- context-arm states;
- sketches;
- ledgers;
- history;
- evidence representation;
- candidate pool;
- audit buffering.

The configuration is rejected when the total exceeds `memory_budget_bytes`.

---

# 24. Core controller state machine

## 24.1 States

```text
VALIDATING
INITIALIZING
SCHEDULING
SELECTING_ARM
GENERATING
SCORING
EXECUTING
OBSERVING
UPDATING
RESCUING
TERMINAL
```

## 24.2 Terminal statuses

```text
FOUND
ISOLATED_UNVERIFIED
NOT_FOUND_WITHIN_BUDGET
BUDGET_EXHAUSTED
NO_EXECUTABLE_TICKET
NO_ADMISSIBLE_CANDIDATE
COMPARISON_FAILED
TARGET_MODEL_INVALID
VERSION_CHANGED
NO_PROGRESS
BASELINE_ONLY
CONFIGURATION_REJECTED
EXPLICIT_CERTIFICATION_COMPLETE
```

## 24.3 Reference pseudocode

```text
state <- VALIDATING
validate configuration, memory, tickets, arms, generators, adapters, models

if invalid:
    return CONFIGURATION_REJECTED

state <- INITIALIZING
initialize coordinates, scheduler, contexts, arms, sketches, ledgers,
evidence representation, PRNG, budgets, and audit log

while transaction_budget remains:

    state <- SCHEDULING
    ticket <- scheduler.next_ticket()

    if ticket cannot be supported:
        apply declared ticket failure policy
        continue or terminate

    context <- build_context(ticket, current state)

    state <- SELECTING_ARM

    if ticket.selection_mode == FIXED:
        arm_order <- ticket.fixed_arm_ids
    else:
        arm_order <- initialization order or descending exploration index

    selected_arm <- NONE

    for at most K_arm_attempt arms:
        state <- GENERATING
        candidates <- arm.generate(limit=K_candidate)

        filter by ticket compatibility and admissibility
        merge operation-equivalent candidates

        if candidates is not empty:
            selected_arm <- arm
            break

        record arm generation failure

    if selected_arm is NONE:
        state <- RESCUING
        advance bounded rescue state
        continue or terminate

    state <- SCORING
    score every candidate with exact fixed-point rules
    candidate <- deterministic maximum

    if candidate worst-case cost exceeds remaining budget:
        remove candidate and select next
        or invoke bounded failure policy

    state <- EXECUTING
    execution <- adapter.execute(ticket, candidate)

    charge actual costs
    record physical and logical state changes

    if execution.status != SUCCESS:
        increment the selected context-arm trial count
        assign configured failure reward
        update execution-failure statistics
        restore anchor when required
        continue or terminate

    state <- OBSERVING

    if ticket.operation == EXACT_TEST:
        require selected candidate has no compatible certificate
        perform exactly one authorized fresh exact test
        store certificate

        if certificate.result == HIT:
            return FOUND

    if ticket.operation == COMPARE:
        perform at most configured observation attempts
        accept an observation only with SUCCESS status and matching versions

    obtain any authorized scalar score or navigation observation

    state <- UPDATING

    uncertainty_before <- evidence uncertainty when available

    if valid target-linked observation exists:
        condition evidence representation
        create at most one observed reaction packet
        discard inconsistent exact branches
    else if counterfactual dual reactions are configured:
        create at most one one-use dual hypothesis packet
        do not alter evidence support

    uncertainty_after <- evidence uncertainty when available

    update sketches
    update movement history
    calculate exact reward components
    update the executed context-arm state
    update scale under the declared scale policy
    expire old reaction packets
    update progress and rescue counters
    append complete audit record

    if meaningful stagnation threshold is reached:
        state <- RESCUING
        advance bounded rescue state

return NOT_FOUND_WITHIN_BUDGET
```

---

# 25. Optional exact ordered-comparison module

This module is enabled only when:

1. a valid target-linked exact comparison exists;
2. a linear target chart is declared;
3. the support representation is `LINEAR_INTERVAL`;
4. the target is stationary and unique;
5. comparison pairs are admissible;
6. the comparison and verification target identities match.

Let:

\[
V_k=[L_k,U_k]\cap\mathbb Z,
\]

in the declared linear chart.

Let:

\[
S_k=U_k-L_k+1.
\]

## 25.1 Even support

For:

\[
S_k=2m,
\]

choose:

\[
\ell=L_k+m-1,
\qquad
r=L_k+m.
\]

No integer equality target exists.

## 25.2 Odd support

For:

\[
S_k=2m+1,
\]

choose:

\[
c=L_k+m,
\]

\[
\ell=c-1,
\qquad
r=c+1.
\]

`EQUAL` isolates \(c\).

## 25.3 Left orientation

For:

\[
x=\ell,\quad y=r:
\]

\[
\texttt{CLOSER}
\Rightarrow
V_{k+1}=[r,U_k],
\]

\[
\texttt{FARTHER}
\Rightarrow
V_{k+1}=[L_k,\ell].
\]

For odd support:

\[
\texttt{EQUAL}
\Rightarrow
V_{k+1}=\{c\}.
\]

For even support, `EQUAL` is inconsistent.

## 25.4 Right orientation

Swap the left and right branch updates.

## 25.5 Bound

Under the exact assumptions:

\[
Q(S)
=
\left\lfloor
\log_2S
\right\rfloor.
\]

This bound belongs to the exact comparison interface.

It is not produced by the guide region or by branch naming.

## 25.6 Integration with the general controller

In `EXACT_COMPARISON_SEARCH`:

- the comparison module determines the split pair;
- the adaptive learner MAY choose orientation or movement implementation;
- the adaptive learner MUST NOT replace a balanced split with a worse split unless a declared lifecycle objective and contraction bound permit it;
- evidence reward uses actual support reduction;
- both `CLOSER` and `FARTHER` can receive equal information reward.

---

# 26. Anti-enumeration rules

## 26.1 Adaptive exact-test ceiling

When:

\[
|\mathcal D|>1,
\]

choose:

\[
U_{\mathrm{test}}^{\max}<|\mathcal D|.
\]

In `BOUNDED_ADAPTIVE`:

\[
\text{distinct search-stage exact tests}
\le
U_{\mathrm{test}}^{\max}.
\]

The one terminal verification allowed by Section 21.2 is charged to the exact-test budget but excluded from the search-stage enumeration ceiling.

Complete testing of a set with more than one candidate requires `EXPLICIT_CERTIFICATION`.

## 26.2 Regional unique-operation ceiling

For a declared large region of size \(S\), choose rational:

\[
\rho=\frac pq,
\qquad
0<p<q.
\]

For planned unique mandatory operations \(U\), require:

\[
qU\le pS.
\]

Use exact integer arithmetic.

## 26.3 Bounded generator prefixes

No adaptive generator is required to complete a permutation.

## 26.4 No automatic mode switch

The controller MUST NOT enter certification because of:

- stagnation;
- budget exhaustion;
- target-model failure;
- empty candidate pools;
- failed comparisons;
- poor benchmark performance.

---

# 27. Deterministic seeded behavior

The reference pseudorandom generator is SplitMix64.

State is one unsigned 64-bit integer.

```text
next_u64():
    state = state + 0x9E3779B97F4A7C15 mod 2^64
    z = state
    z = (z xor (z >> 30)) * 0xBF58476D1CE4E5B9 mod 2^64
    z = (z xor (z >> 27)) * 0x94D049BB133111EB mod 2^64
    return z xor (z >> 31)
```

Define:

```text
next_u256():
    w0 = next_u64()
    w1 = next_u64()
    w2 = next_u64()
    w3 = next_u64()
    return (w0 << 192) | (w1 << 128) | (w2 << 64) | w3
```

## 27.1 Reference test vector

For initial state:

```text
0x0000000000000000
```

the first eight `next_u64()` outputs MUST be:

```text
e220a8397b1dcdaf
6e789e6aa1b965f4
06c45d188009454f
f88bb8a8724c81ec
1b39896a51a8749b
53cb9f0c747ea2ea
2c829abe1f4532e1
c584133ac916ab3c
```

Hexadecimal outputs are zero-padded to 16 characters.

## 27.2 Seeded affine order

For a seeded affine order:

```text
offset = next_u256()
stride = next_u256() | 1
```

This produces a deterministic no-repeat affine permutation over \(\Omega\).

It is not a uniform sample from the set of all \(N!\) permutations and MUST be labeled:

```text
SEEDED_AFFINE_ORDER
```

## 27.3 Seeded pseudorandom-permutation baseline

A pseudorandom-permutation baseline MAY be used when it declares:

- algorithm id and version;
- key or seed derivation;
- bijection proof or test;
- reference vectors;
- work bound.

It MUST be labeled pseudorandom, not mathematically uniform.

The PRNG is used only where the configuration explicitly requests seeded behavior.

A seeded generator does not become target-directed merely because it is reproducible.

---

# 28. Complexity bounds

Let:

- \(K_T=|\mathcal T|\);
- \(K_A\): arm count;
- \(K_{\mathrm{arm\_attempt}}\): arm attempts;
- \(K_{\mathrm{candidate}}\): candidates from one arm;
- \(L\): maximum sketch levels;
- \(K_H\): bounded history inspected;
- \(K_V\): evidence-representation bound.

Per transaction:

\[
O
\left(
K_T
+
K_{\mathrm{arm\_attempt}}
K_{\mathrm{candidate}}
+
L
+
K_H
+
K_V
\right).
\]

With fixed configuration caps, this is constant relative to:

\[
N,
\quad
M,
\quad
C.
\]

A transaction MUST NOT perform work proportional to the full domain, range, or complement.

Memory is bounded by the validated configuration, including all stateful generator indices, heaps, cooldowns, and permutation state.

---

# 29. Performance eligibility

## 29.1 Uniform hit-only theorem

Assume:

1. one target is uniform over \(S\) candidates;
2. exact hit or miss is the only target-linked result;
3. \(q\) distinct candidates are tested.

Then:

\[
\Pr(\text{success by }q)
=
\frac qS.
\]

This remains true for:

- adaptive order;
- random order without replacement;
- sequential order;
- affine order;
- region-alternating order.

Therefore, when significant target-search superiority is mandatory:

```text
UNIFORM_HIT_ONLY -> ADVANTAGE_INELIGIBLE
```

The correct behavior is to reject the target-search claim, not to hide random or exhaustive behavior behind learning terminology.

## 29.2 Valid advantage sources

A target-search advantage requires at least one validated source:

- calibrated nonuniform target distribution;
- real closer/farther comparison;
- calibrated target-correlated scalar score;
- exploitable target structure;
- target-dependent cost relation;
- another declared signal with held-out evidence.

## 29.3 Range location

Knowing where a region is located does not by itself imply that the target lies inside it or that movement toward its center is movement toward the target.

Its value MUST be measured or guaranteed.

---

# 30. Required baselines

Every target-search claim MUST include all applicable baselines.

## 30.1 Exact uniform random permutation

When the evaluated support is small enough to materialize, generate an exact uniform random permutation using a specified Fisher-Yates implementation and seeded random source.

This is the reference exact random-without-replacement baseline.

## 30.2 Seeded pseudorandom-permutation order

For very large supports, use a declared bijective pseudorandom permutation with:

- algorithm id and version;
- seed or key;
- test vectors;
- no-repeat proof;
- bounded per-coordinate work.

Report it as a pseudorandom-permutation baseline, not an exact uniform permutation.

## 30.3 Seeded affine order

Use the Section 27 affine permutation as a separate structured no-repeat baseline.

It MUST NOT be described as uniform over all permutations.

## 30.4 Sequential numeric order

Use increasing canonical coordinate order.

## 30.5 Region-budget baseline

Use the same ticket schedule and range/complement/global allocations, but disable arm learning.

## 30.6 Contextual-learning ablation

Use the same generators but round-robin eligible arms.

## 30.7 Module ablations

At minimum:

- no reaction arms;
- no boundary arms;
- no gap generator;
- no adaptive scales;
- no target model;
- pattern order \(H=0\).

## 30.8 Same-information baseline

Every baseline receives the same:

- target observations;
- score interface;
- prior;
- support initialization;
- budgets;
- cost model.

For exact ordered comparison, the central split is the minimax comparison-count reference.

---

# 31. Acceptance criteria

Before evaluation, declare:

```text
primary_metric
practical_margin
confidence_level
failure_penalty
target_or_instance_distribution
run_count_or_stopping_rule
development_set
validation_set
final_audit_set
```

## 31.1 Target-search acceptance

The complete method MUST:

1. use matched targets or instances;
2. use matched success requirements;
3. include all observation, test, movement, evaluation, and controller costs;
4. materially beat the exact uniform random-permutation baseline when feasible, otherwise the declared seeded pseudorandom-permutation baseline;
5. materially beat the applicable nonlearning fixed-order or exhaustive baseline;
6. be noninferior to the strongest same-information baseline;
7. pass on untouched final audit data.

## 31.2 Navigation acceptance

Without target-correlated feedback, only navigation metrics may be accepted:

- coverage;
- dispersion;
- movement cost;
- repeat rate;
- region entry;
- region re-entry;
- ticket-completion reliability.

## 31.3 Failed gate

If the target-search gate fails, the implementation MUST report:

```text
TARGET_SEARCH_ADVANTAGE_NOT_ESTABLISHED
```

It MAY still report navigation results.

---

# 32. Reproducibility manifest

Every run MUST write a manifest containing:

```text
specification_version
implementation_version
configuration_digest
digest_algorithm
canonical_configuration
space_bits
hex_width
target_domain
range_start_hex
range_length
range_semantics
target_existence_mode
support_representation
observation_interfaces
provider_identities_and_versions
execution_adapter
cost_model_id_and_version
ticket_definitions_counts_and_fixed_arm_orders
pattern_order
arm_definitions
generator_definitions_and_versions
generator_initial_states
support_uncertainty_function_and_version
scoring_component_definitions_and_versions
all budgets
all fixed_point_scales
all score_weights
all reward_weights
all rational_scale_parameters
all scale_policies
all retry_limits
all rescue_limits
prng_algorithm
random_seed
start_coordinate_hex
start_physical_state
```

The canonical configuration MUST use:

- UTF-8;
- sorted object keys;
- preserved array order;
- no duplicate object keys;
- no insignificant whitespace;
- decimal integer encoding;
- lowercase canonical hex coordinates;
- explicit `null` only where the schema permits it.

The digest algorithm and version MUST be fixed for the experiment and stored in the manifest.

---

# 33. Transaction event log

Each transaction MUST record:

```text
transaction_id
epoch_id
ticket_id
context_key
current_coordinate_before
physical_state_before
evidence_summary_before
eligible_arm_ids
arm_attempt_order
selected_arm_id
generator_status
generator_state_before
generator_state_after
candidate_records
selected_candidate
predicted_costs
execution_status
actual_costs
hit_certificate_reference
comparison_observation
scalar_score_observation
evidence_summary_after
coverage_updates
reward_components
total_reward
context_arm_state_after
scale_state_after
budget_state_after
rescue_state_after
current_coordinate_after
physical_state_after
terminal_status_if_any
```

Coordinates MUST be recorded as:

- canonical 64-hex text;
- 32-byte big-endian data when binary logging is supported.

---

# 34. Reference data structures

```text
Coordinate256:
    exact integer in [0, 2^256 - 1]
```

```text
RegionLength:
    exact integer in [1, 2^256]
```

```text
GuideRegion:
    start: Coordinate256
    length: RegionLength
    semantics: enum
```

```text
Ticket:
    ticket_id
    region_class
    operation_kind
    selection_mode
    fixed_arm_ids
    epoch_count
    failure_policy
```

```text
ArmDefinition:
    arm_id
    generator_id
    compatible_ticket_ids
    direction_chart
    direction_policy
    scale_policy
    reaction_policy
    version
```

```text
ContextArmState:
    context_key
    arm_id
    trial_count
    successful_execution_count
    cumulative_reward
    generation_failure_count
    execution_failure_count
    initialization_state
    nominal_scale
    last_trial_transaction
    enabled
```

```text
Candidate:
    coordinate
    operation_kind
    region_class
    arm_id
    generator_id
    provenance
    anchor_optional
    direction_chart_optional
    direction_optional
    magnitude_optional
    predicted_costs
    worst_case_costs
    admissible
    version
```

```text
ExecutionRecord:
    status
    actual_costs
    coordinate_after
    physical_state_after
    retained_anchor_optional
```

```text
ObservationRecord:
    status
    hit_result_optional
    comparison_result_optional
    scalar_score_optional
    provider_identity
    provider_version
    target_identity_optional
    target_version_optional
```

```text
ControllerState:
    transaction_id
    epoch_id
    current_coordinate
    physical_state
    guide_region
    evidence_representation
    scheduler_state
    generator_states
    context_arm_states
    sketch_states
    exact_test_ledger
    movement_history
    reaction_state_optional
    budgets_remaining
    rescue_state
    prng_state
```

---

# 35. Required conformance tests

A conforming implementation MUST pass at least these tests.

## 35.1 Coordinate tests

1. Parse the all-zero coordinate.
2. Parse the all-\(f\) coordinate.
3. Reject text whose length is not 64.
4. Reject nonhexadecimal characters.
5. Format exactly 64 lowercase hexadecimal characters.
6. Encode exactly 32 big-endian bytes.
7. Modular addition wraps at \(2^{256}\).
8. Modular subtraction wraps at \(2^{256}\).
9. The cyclic half-domain direction tie resolves deterministically.

## 35.2 Region tests

10. Nonwrapping membership is correct.
11. Wrapping membership is correct.
12. Local range coordinates are correct.
13. Local complement coordinates are correct.
14. \(M=N\) disables the complement.
15. \(C=1\) emits the sole complement coordinate.
16. `GUIDE_ONLY` preserves complement target support.
17. `HARD_PROMISE` requires explicit selection.
18. `RANGE` tickets reject outside candidates.
19. `COMPLEMENT` tickets reject in-range candidates.
20. `GLOBAL` tickets accept either location.
21. `EVIDENCE_SUPPORT` tickets use the declared support-membership operation.

## 35.3 Ticket and scheduler tests

22. Ticket counts sum to epoch length.
23. Every configured count is emitted exactly once per completed epoch.
24. Scheduler counters reset at the epoch boundary.
25. A positive complement allocation cannot disappear.
26. Guide-only non-collapse requires an actual complement ticket.
27. A global ticket alone does not satisfy complement service.
28. Outside exact-test allocation uses a complement exact-test ticket.
29. Fixed tickets use the exact declared fixed-arm order.
30. Adaptive tickets use the contextual learner.
31. Movement and probe tickets do not perform implicit exact tests.
32. Scheduler tie order is deterministic.
33. Unsupported-ticket failure follows the declared bounded policy.

## 35.4 Contextual learner tests

34. Every enabled arm is considered once in a new context before reuse.
35. A generation failure marks initialization and does not block later arms.
36. An executed failure increments the trial count.
37. A generation failure does not increment the trial count.
38. The integer logarithm term matches the declared `bit_length` rule.
39. The integer square-root index is platform-stable.
40. Exploration bonus decreases as \(n_{\kappa,i}\) grows with fixed \(t_\kappa\).
41. Context includes the previous \(H\) arms.
42. Context count fits memory validation.
43. The arm-attempt limit terminates.
44. Cooldown state is reproducible.

## 35.5 Generator tests

45. Singleton range handling is correct.
46. Range-left and range-right candidates are correct.
47. Complement affine candidates remain outside the range.
48. Global affine stride is odd.
49. Affine prefixes do not repeat within their tested cap.
50. Region-entry landmarks are correct.
51. The gap generator does not scan every bin.
52. Observed reaction packets generate only the observed reaction class.
53. Dual hypothesis packets expose both bounded reaction classes.
54. Dual hypothesis packets expire after one adaptive opportunity.
55. Custom-generator work bounds are enforced.
56. Generator state serializes and restores exactly.
57. Affine source index \(j\) advances only through logged transitions.

## 35.6 Duality tests

58. Boundary deltas satisfy:
    \[
    \Delta_R=-\Delta_L.
    \]
59. Closer and farther are not simultaneous facts for one fixed target.
60. Two-jump histories remain hypotheses without observations.
61. Reaction-packet creation does not alter target support.
62. Exact observations remove inconsistent exact branches.
63. Executing one dual-reaction arm does not assert that its hypothesis was true.

## 35.7 Reward and scale tests

64. Closer and farther with equal uncertainty reduction receive equal evidence reward.
65. Normalized posterior mass is not used as uncertainty.
66. Weighted effective-support uncertainty decreases when weights concentrate.
67. Resampling alone produces zero evidence-gain reward.
68. Range geometry creates zero target reward.
69. Failed observations create zero evidence reward.
70. Reward arithmetic uses exact mathematical floor.
71. Reward and utility accumulators cannot overflow.
72. Rational closer-scale update follows configuration.
73. Rational farther-scale update follows configuration.
74. Missing results do not trigger label-based scale updates.
75. Reaction arms are rewarded only when executed.
76. Dual hypothesis packets do not alter evidence support.

## 35.8 Runtime and budget tests

77. Transaction budget terminates.
78. Movement budget terminates.
79. Probe budget terminates.
80. Exact-test budget terminates.
81. Comparison budget terminates.
82. Observation-attempt budget terminates.
83. Evaluation budget terminates.
84. Memory-overflowing configuration is rejected.
85. Empty candidate generation enters bounded rescue.
86. The rescue sequence terminates.
87. Rescue never activates certification.
88. Movement revisits remain possible.
89. Exact duplicate tests are prevented.
90. A certified miss does not complete a fresh exact-test ticket.
91. No fresh exact-test candidate returns the required failure.
92. Terminal singleton verification is allowed and charged.
93. Worst-case-cost validation prevents unsafe operation start.
94. A cost-contract violation terminates the affected run.
95. Baseline-only rescue is labeled explicitly.

## 35.9 Evidence tests

96. `NONE` support never performs evidence updates.
97. Linear-interval uncertainty equals exact cardinality.
98. Cyclic interval-set cardinality is exact for disjoint intervals.
99. The interval-set cap is enforced.
100. The particle cap is enforced.
101. The weighted-bin cap is enforced.
102. A failed support update preserves prior support.
103. Target-version mismatch preserves support and terminates or restarts correctly.
104. Conditioning records uncertainty before and after.
105. Approximate merges are not labeled exact.

## 35.10 Exact comparison tests

106. A valid linear chart is required.
107. An even central split has no equality target.
108. An odd central split isolates the center on equality.
109. Closer and farther branches are exact.
110. Worst-case comparisons equal:
     \[
     \lfloor\log_2S\rfloor.
     \]
111. The guide range does not alter split branches.
112. Both labels are rewarded by actual uncertainty reduction.
113. Comparison failure does not guess a branch.
114. Comparison and verification target identities must match.
115. Final isolated verification is separate from search-stage enumeration.

## 35.11 Baseline and acceptance tests

116. Exact uniform random order uses Fisher-Yates when feasible.
117. A seeded pseudorandom baseline is labeled pseudorandom.
118. A seeded affine baseline is not labeled uniform.
119. The fixed affine baseline uses no learning.
120. The region-budget baseline uses identical tickets.
121. The round-robin ablation uses identical generators.
122. The same-information baseline receives identical observations and costs.
123. Uniform hit-only simulation matches:
     \[
     q/S.
     \]
124. No-target mode reports navigation-only.
125. A failed target-search gate reports the required status.

## 35.12 Reproducibility tests

126. The same manifest and observation stream reproduce the same run.
127. The same seed reproduces all seeded generators.
128. A changed seed affects only seeded behavior.
129. Canonical configuration encoding is stable.
130. Duplicate configuration keys are rejected.
131. The configuration digest detects parameter changes.
132. The event log contains every required field.
133. Candidate-score ties are stable across platforms.
134. SplitMix64 seed-zero vectors match Section 27.1.
135. Fixed-arm order is reproduced.
136. Scoring-component versions are present in the manifest.
137. Support-uncertainty function and version are present.
138. Generator initial and final states reproduce the same sequence.

---

# 36. Mathematical claims

## Claim 1: no automatic domain collapse

Under `GUIDE_ONLY`, `SOFT_HINT`, or `LANDMARK`:

\[
\Omega_{\mathrm{active}}=\Omega.
\]

The supplied region cannot remove the complement from executable search.

## Claim 2: explicit outside service

When a complement ticket is configured, the scheduler emits its exact integer count in every completed epoch. A global ticket is not treated as proof of outside-region service.

## Claim 3: factual boundary duality

For a nonzero in-region local jump:

\[
\Delta_R=-\Delta_L.
\]

The jump is closer to one region boundary and farther from the other.

## Claim 4: target-result exclusivity

For one fixed target, one metric, and one successful comparison, exactly one of closer, farther, or equal is true.

## Claim 5: bounded learning state

With finite ticket, context, arm, history, sketch, and evidence caps, the controller has bounded auxiliary state.

## Claim 6: bounded transaction work

With fixed caps, transaction work is constant relative to the \(2^{256}\) domain size.

## Claim 7: no hidden exhaustive fallback

Exhaustive enumeration occurs only in `EXPLICIT_CERTIFICATION`.

## Claim 8: no hidden random fallback

A run using only a seeded baseline generator is explicitly labeled `BASELINE_ONLY`.

## Claim 9: hit-only limitation

Under uniform unstructured hit-only feedback:

\[
\Pr(\text{success by }q)=\frac qS.
\]

Jump learning cannot change this probability without additional target-correlated information.

## Claim 10: conditional target-search advantage

Significant target-search improvement is possible only when a validated target-correlated source exists and the complete implementation passes the matched baseline gate.

---

# 37. Double-slit inspiration: exact engineering interpretation

| Inspiration | NCAJ-64 interpretation |
|---|---|
| Two paths | Closer-reaction and farther-reaction policies |
| Wave | Bounded set of currently available patterns or target hypotheses |
| Particle | One selected and executed ticket-candidate operation |
| Both paths available | Both reaction policies remain represented before feedback |
| Measurement | A genuine target-linked observation |
| Collapse | Keep or activate only the observation-consistent reaction state |
| Interference | Not implemented |
| Quantum speedup | Not claimed |
| Learning | Deterministic reward update of finite context-arm states |

The metaphor MUST NOT be used as evidence that a target was approached.

---

# 38. Final engineering rule

> Preserve the full 64-hex executable domain. Treat a supplied region as guidance unless an explicit hard guarantee says otherwise. Schedule range, complement, global, test, comparison, and adaptive operations with exact integer tickets. Learn bounded jump-pattern sequences through deterministic context-arm rewards. Maintain closer and farther as separate reaction entities, but update target support only from genuine target-linked observations. Use finite budgets, bounded rescue, explicit baseline labels, and reproducible logs. Accept target-search superiority only after the complete implementation materially outperforms fair matched baselines.
