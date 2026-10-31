# Catalogue of Mathematical and Modeling Flaws That Could Falsely Make MSR Appear to Break Cryptography

**Framework:** Markovian State Realignment (MSR)  
**Purpose:** Research taxonomy of invalid assumptions, proof errors, model substitutions, and complexity mistakes that could produce the false conclusion that MSR is a generic cryptanalytic shortcut  
**Status:** Explanatory failure-mode document — fourth completeness-audited revision  
**Date:** July 2026

---

## 1. Scope of This Document

Markovian State Realignment defines, for a fixed permutation

\[
f:\mathcal{X}\to\mathcal{X},
\qquad
\mathcal{X}=\{0,1\}^n,
\]

and a fixed arithmetic coordinate map

\[
\phi:\mathcal{X}\to\mathbb{Z}_{2^n},
\]

the latent successor

\[
s_\phi(x)=x\oplus1
\]

and the conjugated visible transition

\[
g_{f,\phi}
=
f\circ s_\phi\circ f^{-1}.
\]

For observed targets

\[
B=f(A),
\qquad
D=f(C),
\]

the directed MSR distance is

\[
d_{f,\phi}(B,D)
=
\left(
\phi(f^{-1}(D))
-
\phi(f^{-1}(B))
\right)
\bmod 2^n.
\]

This distance equals the latent modular displacement

\[
\Delta
=
\left(
\phi(C)-\phi(A)
\right)\bmod 2^n.
\]

The construction is mathematically exact. It does not, by itself, make the hidden coordinates efficiently recoverable.

This document identifies the mistakes one would have to make to derive the **false conclusion**

> “MSR generically recovers \(\Delta\) from \(B,D\), using only forward access to a secure cryptographic permutation, substantially faster than generic inversion.”

No finite document can enumerate every logically possible false statement. The completeness criterion used here is instead **category completeness**: the catalogue covers every materially distinct route identified in the MSR model by which a false generic cryptanalytic conclusion could arise through a changed mathematical object, hidden information, circular definition, invalid inference, altered oracle, incorrect probability argument, suppressed resource, or invalid experimental generalization.

Several entries overlap intentionally. A misleading argument often requires a chain of flaws rather than one isolated mistake.

---

## 2. The Fundamental False Inference

The central invalid inference is:

\[
\text{A hidden relationship exists}
\quad\Longrightarrow\quad
\text{the hidden relationship is efficiently computable}.
\]

MSR proves the first statement:

\[
d_{f,\phi}(B,D)=\Delta.
\]

It does not prove the second:

\[
\Delta
\text{ can be efficiently computed from }
(B,D)
\text{ and forward access to }f.
\]

Nearly every false cryptanalytic conclusion about MSR is a variation of this existence-versus-computability error.

---

# Part I — Definition and Problem-Formulation Errors

## 3. Treating \(C=A\oplus\Delta\) as Additional Information

### False move

Present

\[
C=A\oplus\Delta
\]

as a restrictive structural promise that significantly narrows the possible pair \((A,C)\).

### Why it creates a false attack

It makes the problem appear to contain extra exploitable arithmetic information.

### Correct objection

For unrestricted

\[
\Delta\in\{0,\ldots,2^n-1\},
\]

every ordered pair \((A,C)\) determines exactly one \(\Delta\). The relation is definitional:

\[
\Delta
=
\phi(C)-\phi(A)\pmod{2^n}.
\]

It reduces the search space only if extra information is supplied, such as:

- \(\Delta\) belongs to a small known set;
- \(|\Delta|\) is bounded under a nonmodular interpretation;
- \(\Delta\) follows a concentrated prior;
- some bits of \(\Delta\) are known;
- \(A\) or \(C\) belongs to a restricted subset.

Without such a promise, the relation contributes no entropy reduction.

---

## 4. Leaving the Coordinate Map \(\phi\) Implicit

### False move

Speak of “adding one to a bit string” without fixing a bijection

\[
\phi:\{0,1\}^n\to\mathbb{Z}_{2^n}.
\]

### Why it creates a false attack

It permits the analyst to switch coordinate systems opportunistically until an apparent pattern appears.

### Correct objection

The successor map, graph, and distance all depend on \(\phi\):

\[
s_\phi,\qquad
g_{f,\phi},\qquad
G_{f,\phi},\qquad
d_{f,\phi}.
\]

A different bijection \(\psi\) generally produces different objects:

\[
s_\psi,\qquad
g_{f,\psi},\qquad
d_{f,\psi}.
\]

Any claimed shortcut must state the coordinate map in advance and cannot select it after observing the targets.

---

## 5. Treating an Arbitrary Coordinate Choice as Cryptographically Intrinsic

### False move

Claim that the MSR order is a hidden natural order already present in \(f\).

### Correct objection

The order is transported from the chosen latent arithmetic coordinates. It is not generally an intrinsic property of the permutation.

The same \(f\) can support many different conjugated cycles depending on the chosen coordinate map.

---

## 6. Confusing a Definition with a Prediction

### False move

Compute

\[
\Delta
=
d_{f,\phi}(B,D)
\]

symbolically and present that equality as an algorithm for evaluating \(\Delta\).

### Correct objection

The formula contains

\[
f^{-1}(B)
\quad\text{and}\quad
f^{-1}(D).
\]

It is an exact characterization, not an efficient evaluation procedure under a forward-only oracle model.

---

# Part II — Graph-Theoretic Errors

## 7. Confusing Graph Existence with Graph Accessibility

### False move

Argue that because the entire visible cycle

\[
G_{f,\phi}
\]

exists, an evaluator can traverse it.

### Correct objection

The graph is mathematically defined by

\[
g_{f,\phi}(y)
=
f(f^{-1}(y)\oplus1).
\]

A forward oracle for \(f\) does not automatically provide random-access evaluation of \(g_{f,\phi}\) at an externally specified node.

One can generate edges of the form

\[
f(u)\to f(u\oplus1)
\]

when \(u\) is known. This does not calibrate those edges relative to the externally supplied targets \(B,D\).

---

## 8. Assuming a Sampled Trajectory Must “Intersect” the Target Trajectory

### False move

Use birthday-style reasoning to argue that a randomly generated trajectory will eventually collide with the target trajectory.

### Correct objection

There is only one trajectory cycle. Every sampled segment is already on the same global cycle.

The missing information is not whether the paths intersect. It is the unknown offset between the sampled latent coordinate and the targets.

Thus:

\[
\text{same cycle}
\not\Longrightarrow
\text{known relative position}.
\]

---

## 9. Treating the Cycle Topology as a Cryptanalytic Leak

### False move

Argue that the single-cycle property itself reveals \(\Delta\).

### Correct objection

Every conjugate of the full-cycle successor has the same abstract topology. The topology contains no target-specific labeling information.

A cycle with \(N\) unlabeled positions tells an evaluator only that a directed distance exists, not which distance corresponds to the supplied labels \(B,D\).

---

## 10. Claiming the Graph “Collapses” Under Ordinary MSR

### False move

Describe the transition graph as becoming smaller, lower-dimensional, or topologically simpler merely because it is represented as a Markov chain.

### Correct objection

The induced graph contains all \(N=2^n\) states and remains a single \(N\)-cycle.

Changing vocabulary from “permutation” to “graph” or “Markov chain” does not reduce the state space.

---

## 11. Inventing Sinkholes, Basins, or Attractors

### False move

Claim that trajectories pool, slow down, become trapped, or converge toward certain regions of \(G_{f,\phi}\).

### Correct objection

For the deterministic full cycle:

- every node has indegree \(1\);
- every node has outdegree \(1\);
- every move advances exactly one step;
- no proper subset is absorbing;
- no region attracts more trajectories;
- no node is revisited before the entire cycle is completed.

There are no topological sinkholes in \(G_{f,\phi}\).

A concrete cipher may have algebraic or differential structure, but that does not create attraction in this conjugated one-step cycle.

---

## 12. Confusing Graph Labels with Graph Topology

### False move

Infer that because sampled visible labels appear clustered under some ordinary metric, the graph itself has clustered topology.

### Correct objection

The graph adjacency is defined by \(g_{f,\phi}\), not by Hamming or Euclidean proximity of visible labels.

Two adjacent graph vertices may have maximal-looking Hamming separation, while visibly close outputs may be far apart on the cycle.

---

## 13. Assuming Ordinary Output Distance Approximates MSR Distance

### False move

Use

\[
d_{\mathrm{Hamming}}(B,D)
\]

or numeric subtraction of output encodings as an estimator of

\[
d_{f,\phi}(B,D).
\]

### Correct objection

For an ideal permutation, visible labels are randomly assigned to latent coordinates. Ordinary output-space distances do not preserve the latent modular order.

Such a shortcut becomes valid only if the concrete \(f\) leaks a relation between visible labels and latent coordinates.

---

# Part III — Markov-Chain and Probability Errors

## 14. Calling the Deterministic Orbit a Random Walk

### False move

Refer to repeated applications of \(g_{f,\phi}\) as a random walk and apply random-walk intuition.

### Correct objection

The transition is deterministic:

\[
Y_{t+1}=g_{f,\phi}(Y_t).
\]

There is no transition randomness unless a separate stochastic mechanism is introduced.

A random starting point does not make the subsequent transition rule random.

---

## 15. Misusing the Uniform Stationary Distribution

### False move

Argue either:

1. uniform stationarity proves no output leaks anything; or
2. a nonuniform sample histogram proves the chain has exploitable sinkholes.

### Correct objection

The deterministic full cycle has a uniform stationary distribution, but it is periodic. Starting from a point mass, the distribution does not converge to uniform; it moves around the cycle.

Stationarity alone says nothing decisive about:

- algebraic leakage;
- side channels;
- visible coordinate correlations;
- key-dependent structure;
- distinguishers;
- recoverability of target offsets.

---

## 16. Treating Sampling Density as Entropy Reduction

### False move

Claim that generating many pairs

\[
(u,f(u))
\]

reduces the uncertainty of the unrelated target preimages merely because the sampled graph becomes dense.

### Correct objection

In the ideal-permutation model, unless a sampled input actually hits a target preimage or yields target-linked information, the unqueried target preimages remain uniformly distributed over the unqueried domain.

A large database reduces uncertainty only in proportion to the fraction of the domain actually covered.

---

## 17. Assuming “Warmer/Colder” Feedback Exists

### False move

Use a visible statistic as if moving closer under that statistic implied moving closer to \(A\), \(C\), or \(\Delta\).

### Correct objection

No gradient exists in the ideal-permutation model.

A valid gradient attack would require an explicitly demonstrated correlation such as

\[
h(f(x))
\approx
H(\phi(x))
\]

or

\[
R(f(x),f(x\oplus k))
\]

correlated with \(k\).

Without such a theorem or empirical attack model, “warmer/colder” language is unsupported.

---

## 18. Treating Empirical Bias as Exact Recovery

### False move

Observe a weak statistical correlation and conclude that the exact 256-bit \(\Delta\) is recoverable.

### Correct objection

A distinguisher, a biased bit prediction, partial information, and exact recovery are different achievements.

A complete attack must quantify:

- advantage over random guessing;
- sample complexity;
- error probability;
- number of recovered bits;
- how partial leakage composes into exact recovery;
- total computational cost.

---

## 19. Assuming Independence After Adaptive Queries Without Proof

### False move

Treat adaptively selected oracle responses as independent uniform samples.

### Correct objection

Oracle transcripts are constrained by permutation consistency.

Correct arguments use deferred decisions and conditional uniformity over the unqueried inputs and unused outputs. They do not assume unrestricted independence.

---

## 20. Conditioning on Success Without Paying Its Probability

### False move

Analyze the attack only on the event that a sampled path happens to contain \(B\) or \(D\), then report the conditional cost as the total attack cost.

### Correct objection

The probability of reaching the favorable event must be included.

For a fixed target under \(q\) distinct classical forward queries, the hit probability is

\[
\frac{q}{N}.
\]

Conditioning on a rare hit cannot remove the cost of producing that hit.

---

# Part IV — Oracle-Model Errors

## 21. Treating a Forward Oracle as an Inverse Oracle

### False move

Assume that because \(f\) is bijective and locally executable, \(f^{-1}\) is also available.

### Correct objection

Bijectivity guarantees mathematical existence of the inverse, not oracle access or efficient computability.

The model must distinguish among:

- forward point queries;
- known algorithm and known key;
- known algorithm and unknown key;
- explicit inverse oracle;
- standard quantum function oracle \(O_f\);
- in-place permutation oracle \(U_f\);
- access to \(U_f^\dagger\).

These models have different capabilities.

---

## 22. Treating a Known-Key Block Cipher as One-Way

### False move

Use an ordinary block cipher under a known key as an example of a forward-only hard permutation.

### Correct objection

A conventional block cipher exposes efficient decryption under the known key. Then

\[
A=f^{-1}(B),
\qquad
C=f^{-1}(D)
\]

are directly computable.

The MSR problem is hard only under an explicit restriction that inverse evaluation is unavailable.

---

## 23. Treating an Unknown-Key Cipher as an Ideal Random Permutation Without Qualification

### False move

Transfer the ideal-permutation \(\Theta(2^n)\) input-search bound directly to a keyed family with key length \(\kappa\).

### Correct objection

The public keyed-family description provides additional structure. Generic key search may cost approximately

\[
2^\kappa
\]

classical family evaluations or

\[
2^{\kappa/2}
\]

quantum candidate-key search iterations, subject to verification and identifiability conditions.

The input-domain size and key-space size are different parameters.

---

## 24. Confusing \(O_f^{-1}\) with \(f^{-1}\)

### False move

For the standard quantum oracle

\[
O_f|x,z\rangle
=
|x,z\oplus f(x)\rangle,
\]

argue that applying \(O_f^{-1}\) reveals \(f^{-1}\).

### Correct objection

For this oracle,

\[
O_f^{-1}=O_f,
\]

but this only uncomputes the answer register. It does not map

\[
|y\rangle
\]

to

\[
|f^{-1}(y)\rangle.
\]

---

## 25. Ignoring Access to \(U_f^\dagger\)

### False move

State a Grover-style \(\Theta(\sqrt N)\) inversion bound while silently granting access to the adjoint of the in-place permutation unitary:

\[
U_f|x\rangle=|f(x)\rangle.
\]

### Correct objection

If \(U_f^\dagger\) is available, then

\[
U_f^\dagger|y\rangle
=
|f^{-1}(y)\rangle.
\]

The preimages can then be recovered with constant oracle invocations.

---

## 26. Treating Sampled Edges as a Random-Access \(g_{f,\phi}\) Oracle

### False move

From the ability to generate

\[
f(u)\to f(u\oplus1),
\]

conclude that one can query

\[
g_{f,\phi}(y)
\]

for any chosen visible \(y\).

### Correct objection

The sampled edge is indexed by the known latent input \(u\), not by an arbitrary visible label.

An externally specified \(y\) has an unknown latent coordinate.

---

## 27. Hiding Preprocessing or Advice

### False move

Claim a fast online attack after precomputing a table correlated with \(f\), while excluding the preprocessing time, oracle queries, and storage from the complexity.

### Correct objection

The model must account for:

- preprocessing queries;
- preprocessing time;
- stored advice size;
- whether the same \(f\) is reused;
- whether targets are chosen before or after preprocessing;
- amortization across many attacks.

A complete inverse table requires exponential storage and classical preprocessing in the extensional ideal-permutation model.

---

# Part V — Algebraic and Structural Errors

## 28. Assuming Low Algebraic Degree Implies Polynomial-Time Solvability

### False move

Express the cipher as low-degree polynomial equations over \(GF(2)\) and conclude that Gröbner-basis elimination is polynomial-time.

### Correct objection

Low degree alone does not imply efficient solution. Multivariate quadratic solving is hard in general, and Gröbner-basis computations may have exponential complexity.

A valid algebraic attack needs additional exploitable structure, such as:

- unusually low solving degree;
- strong overdefinition;
- sparsity;
- rank defects;
- separable variables;
- invariant subspaces;
- special elimination order;
- a provable or experimentally demonstrated complexity reduction.

---

## 29. Assuming Elimination Preserves Low Degree and Sparsity

### False move

Start with low-degree equations in \(A,\Delta\), eliminate \(A\), and assume the resulting equations in \(\Delta\) remain low-degree and compact.

### Correct objection

Elimination can produce dense, high-degree polynomials and very large intermediate representations.

The complexity of the eliminated system must be analyzed rather than assumed.

---

## 30. Assuming a Shared Variable Automatically Creates an Easy Attack

### False move

Argue that because

\[
B=f(A),
\qquad
D=f(A\oplus\Delta)
\]

share \(A\), the joint system must be substantially easier than two independent inversions.

### Correct objection

Shared variables can help only when the concrete representation exposes exploitable joint structure.

For an ideal black-box permutation, the relation does not create a generic shortcut.

---

## 31. Confusing Representability with Solvability

### False move

Argue that because the cipher can be represented exactly as Boolean equations, it can therefore be solved efficiently.

### Correct objection

Every finite computation can be encoded as a Boolean or polynomial system. An exact representation is not an efficient solver.

---

## 32. Assuming a Distinguisher Is an Inverter

### False move

Find a statistical property distinguishing \(f\) from an ideal permutation and conclude that \(A,C,\Delta\) can be recovered.

### Correct objection

A distinguisher may prove nonideality without providing an inversion or displacement-recovery algorithm.

The reduction from the distinguisher to exact recovery must be constructed and costed.

---

## 33. Assuming Differential Bias Produces a Global Coordinate

### False move

Observe a biased differential for certain inputs and infer an efficient global function that reveals \(\phi(x)\) or \(\Delta\).

### Correct objection

A local or key-dependent differential property does not automatically provide a global coordinate system.

The attack must show how the bias is queried, accumulated, and converted into target-linked displacement information.

---

## 34. Assuming an Invariant Creates a Markov Sinkhole

### False move

Translate an algebraic invariant of the cipher into an attracting region of \(G_{f,\phi}\).

### Correct objection

The graph remains a single regular directed cycle for every bijective \(f\).

An invariant may partition labels, expose weak keys, or support a distinguisher, but it does not create graph attraction.

---

## 35. Failing to Distinguish Exact and Approximate Commutation

### False move

Write

\[
f(x\oplus1)\approx f(x)\oplus c
\]

and treat the approximation as if it were an exact identity.

### Correct objection

An approximate relation requires a precise model:

- probability of failure;
- distribution of the error;
- whether \(c\) is fixed;
- whether the relation holds for all keys;
- whether errors are detectable;
- the number of samples needed;
- how errors affect exact recovery.

Without these quantities, “nearly commutes” is not a theorem.

---

## 36. Ignoring the Invertibility of the Affine Step

Suppose integer coordinates satisfy

\[
F(z+1)=F(z)+c\pmod N,
\qquad
F=\phi\circ f\circ\phi^{-1}.
\]

### False move

Immediately write

\[
\Delta
=
c^{-1}
\bigl(\phi(D)-\phi(B)\bigr)
\pmod N.
\]

### Correct objection

The inverse \(c^{-1}\) exists only if

\[
\gcd(c,N)=1.
\]

For \(N=2^n\), this requires \(c\) to be odd.

If \(F\) is itself a permutation and the identity holds globally, invertibility follows, but it should be stated rather than silently assumed.

---

## 37. Calling Affine Visibility a Topological Collapse

### False move

If

\[
g_{f,\phi}(y)
=
y\oplus c
\]

in visible coordinates, claim that the graph topology has collapsed.

### Correct objection

The graph was already a single cycle. What has changed is the labeling: the visible labels now expose an efficiently computable affine coordinate.

The shortcut is a **coordinate leakage**, not a topological collapse.

---

# Part VI — Collision and Birthday-Paradox Errors

## 38. Applying the Birthday Bound to a Fixed Target

### False move

Use the \(\sqrt N\) birthday scale to claim that random sampling will hit \(B\) or \(D\).

### Correct objection

Birthday bounds concern arbitrary collisions among sampled values. Hitting a fixed target is a preimage problem.

For a fixed target, \(q\) distinct classical queries succeed with probability

\[
\frac{q}{N}.
\]

Constant success requires \(q=\Theta(N)\).

---

## 39. Applying Collision Reasoning to a Permutation

### False move

Search for ordinary output collisions of \(f\).

### Correct objection

A permutation has no distinct-input output collisions:

\[
f(x)=f(x')
\Longrightarrow
x=x'.
\]

Any useful collision problem must be defined on a derived object, and one must prove that solving it recovers the specified \(\Delta\).

---

## 40. Treating Any Collision as a Target-Linked Collision

### False move

Find a collision or repeated statistic somewhere in sampled data and infer information about \(B,D\).

### Correct objection

An arbitrary collision is not automatically related to the two specified targets.

The attack must establish a reduction from the sampled event to the target displacement.

---

# Part VII — Complexity-Theoretic Errors

## 41. Confusing Query Complexity with Running Time

### False move

Compare:

- one ideal-oracle query;
- one keyed-family circuit evaluation;
- one Gröbner-basis step;
- one table lookup;
- one quantum query;

as if all were the same unit.

### Correct objection

These are distinct resources.

A rigorous analysis states separately:

- target-oracle queries;
- local computation;
- gate count;
- circuit depth;
- memory;
- preprocessing;
- communication;
- parallel rounds;
- success probability.

---

## 42. Confusing Upper Bounds with Lower Bounds

### False move

Show one attack costing \(O(T)\) and conclude that the problem has complexity \(\Theta(T)\).

### Correct objection

An upper bound gives only achievability. A matching lower bound is required for a \(\Theta\) statement.

---

## 43. Using \(O(2^n)\) as Evidence of Exact Cost

### False move

Treat big-\(O\) as an equality or expected count.

### Correct objection

Big-\(O\) gives only an asymptotic upper bound.

Expected, worst-case, median, and high-probability costs must be distinguished.

---

## 44. Using Asymptotic Notation for One Fixed Instance

### False move

State that a single fixed 256-bit instance “has complexity \(\Theta(2^{256})\)” without defining a family indexed by \(n\).

### Correct objection

Asymptotic notation applies to a sequence of problems as \(n\to\infty\).

For the fixed instance, one may say the generic scale is on the order of \(2^{256}\).

---

## 45. Reporting Conditional Cost Instead of Total Cost

### False move

Say:

> “Once the correct seed is found, only \(\Delta\) steps remain.”

and present \(\Delta\) as the attack cost.

### Correct objection

The cost of finding the seed must be included.

---

## 46. Ignoring Success Probability

### False move

Present an algorithm that succeeds with probability \(2^{-n}\) as a valid efficient attack because each trial is cheap.

### Correct objection

The total cost to obtain constant success probability must include repetitions or amplitude amplification.

---

## 47. Hiding the Verification Cost

### False move

Claim that searching a \(\kappa\)-bit key space costs \(2^\kappa\) operations while ignoring that every candidate must be checked against \(t\) samples.

### Correct objection

A straightforward classical verification cost is

\[
O(t2^\kappa).
\]

A straightforward quantum candidate-key search uses, for \(r\) marked keys,

\[
O\!\left(
t\sqrt{\frac{2^\kappa}{r}}
\right)
\]

coherent family-circuit evaluations.

---

## 48. Ignoring Key Identifiability

### False move

Find one key consistent with a finite verification set and assume it is the operative key or yields the correct displacement.

### Correct objection

Several keys may survive.

Exact displacement recovery requires that all accepted keys yield the same candidate displacement:

\[
\left|
\{\Delta_{K'}:K'\in\mathcal{K}_S\}
\right|
=
1.
\]

This may be supplied as a promise or may require costly certification.

---

## 49. Treating Key Uniqueness as Necessary

### False move

Reject a key-search route unless the true key is uniquely identified.

### Correct objection

Key uniqueness is sufficient but not necessary. Multiple surviving keys are acceptable if they all induce the same \(\Delta\).

The correct property is displacement identifiability.

---

## 50. Assuming Efficient Inversion from a Candidate Key

### False move

Define a keyed family of permutations and assume that knowing \(K'\) automatically makes \(f_{K'}^{-1}\) efficient.

### Correct objection

Bijectivity does not imply efficient invertibility from a succinct description.

Efficient public encryption and decryption algorithms must be part of the keyed-family model.

---

## 51. Ignoring Advice and Amortization

### False move

Use a massive precomputed structure across many targets and report only the per-target online cost.

### Correct objection

One must state:

- advice size;
- preprocessing time;
- preprocessing queries;
- number of amortized instances;
- whether \(f\) changes between instances.

---

## 52. Treating Memory as Free

### False move

Store an exponential table and call the resulting lookup “constant-time cryptanalysis.”

### Correct objection

Time-memory trade-offs do not erase storage cost.

For an extensional ideal permutation, a complete inverse table requires exponential space.

---

## 53. Treating Parallel Time as Total Work

### False move

Run \(2^n\) processors in parallel and claim an \(O(1)\)-time attack without reporting total work and hardware.

### Correct objection

Parallel depth and total work are different complexity measures.

---

# Part VIII — Lower-Bound and Proof Errors

## 54. Proving Only Preimage Hardness and Claiming Displacement Hardness Automatically

### False move

State that inversion is hard and conclude, without reduction, that displacement recovery is equally hard.

### Correct objection

A reduction is required.

A correct reduction can use a displacement solver on a pair

\[
(B,f(c_0))
\]

to recover

\[
f^{-1}(B)=c_0\ominus\Delta.
\]

Without such a reduction, the lower-bound transfer is only intuition.

---

## 55. Proving Average-Case Hardness and Claiming Every Fixed Permutation Is Hard

### False move

Use the uniform ideal-permutation distribution to claim that every fixed permutation requires exponential work.

### Correct objection

A specially structured fixed permutation may be easy.

The classical bound is distributional unless a separate worst-case theorem is proved.

---

## 56. Proving Worst-Case Hardness and Claiming Every Distribution Is Hard

### False move

Use a worst-case quantum theorem to claim the same average-case lower bound under every possible target-generation distribution.

### Correct objection

Worst-case and average-case statements require separate quantifiers and reductions.

---

## 57. Assuming the Transcript Reveals Nothing Without Conditioning Carefully

### False move

Say unqueried preimages remain uniform without conditioning on what outputs have already appeared.

### Correct objection

The correct statement is conditional on the observed permutation-consistent transcript.

Deferred-decisions arguments must respect used inputs and used outputs.

---

## 58. Double Counting Success Cases

### False move

Partition success events that overlap, sum their probabilities, and report the result as an exact bound.

### Correct objection

The success partition must be disjoint, such as:

- both target preimages queried;
- exactly one queried;
- neither queried.

---

## 59. Ignoring the No-Query Baseline

### False move

Claim that every nonzero success probability comes from oracle information.

### Correct objection

For distinct targets under the uniform ideal-permutation model,

\[
\Delta
\]

is uniform over the \(N-1\) nonzero residues. A no-query guess succeeds with probability

\[
\frac{1}{N-1}.
\]

Any advantage must be measured above this baseline.

---

## 60. Mistaking an Upper-Bound Counting Argument for Optimality

### False move

Derive a success upper bound for a particular event decomposition and call it exact without proving tightness.

### Correct objection

An inequality may establish a lower bound on required queries without identifying the optimal constant or strategy.

---

# Part IX — Experimental and Empirical Errors

## 61. Testing Toy Permutations and Generalizing to Cryptographic Sizes

### False move

Demonstrate MSR on \(n=8\), \(n=16\), or a weak toy function and extrapolate the observed runtime to \(n=256\).

### Correct objection

Exhaustive phenomena that are easy at toy sizes may still scale exponentially.

One must fit and justify the asymptotic model rather than extrapolate informally.

---

## 62. Choosing the Cipher After Seeing the Desired Pattern

### False move

Search many functions, keys, coordinate maps, metrics, and sample rules, then report only the configuration that appears correlated with \(\Delta\).

### Correct objection

This is selection bias.

A valid experiment preregisters:

- the function family;
- keys or key-generation method;
- coordinate map;
- statistic;
- sample size;
- success criterion;
- held-out evaluation.

---

## 63. Evaluating on the Same Samples Used to Discover the Pattern

### False move

Fit a mapping from visible statistics to \(\Delta\) and test it on the training pairs.

### Correct objection

The result may be memorization.

Held-out keys, targets, and permutations are required.

---

## 64. Confusing Statistical Significance with Cryptanalytic Significance

### False move

Report a statistically detectable correlation and call it a break.

### Correct objection

A cryptanalytic result must quantify operational advantage and total attack cost.

A tiny correlation may be statistically significant while providing no practical or asymptotic recovery improvement.

---

## 65. Ignoring False Positives Across Many Candidate Metrics

### False move

Try thousands of output metrics and report the strongest accidental correlation without multiple-testing correction or held-out confirmation.

### Correct objection

The search procedure itself must be included in the statistical analysis.

---

## 66. Using Nonrandom or Biased Targets Without Disclosure

### False move

Choose \(A,C,\Delta\) from an easy distribution and present results as generic.

### Correct objection

The target-generation distribution changes the problem.

For example, a small known candidate set for \(\Delta\) can reduce the problem independently of MSR.

---

## 67. Accidentally Leaking Latent Inputs into Features

### False move

Construct a feature using filenames, generation order, random seeds, memory addresses, or metadata correlated with \(A\) or \(C\).

### Correct objection

This creates an implementation side channel rather than a cryptanalytic property of \(f\).

---

## 68. Treating Simulation Access as Real-World Oracle Access

### False move

In an experiment, retain the latent input used to produce every output and then claim that the visible graph is navigable.

### Correct objection

The simulation environment has granted the evaluator information excluded by the stated attack model.

---

# Part X — Specific False Narratives That Must Be Rejected

## 69. “Infinite Sampling Eventually Makes the Inverse Locally Bounded”

False because “infinite sampling” is equivalent to enumerating the finite domain. Any finite useful coverage must be costed.

---

## 70. “The Markov Chain Learns the Hidden Arithmetic”

False because the transition matrix is a restatement of the hidden arithmetic under conjugation. It does not learn or infer it.

---

## 71. “The Graph Stores \(\Delta\), Therefore \(\Delta\) Is Extractable”

False because many hard problems have solutions encoded in mathematically well-defined structures. Encoding does not imply efficient extraction.

---

## 72. “Trajectory Rigidity Removes Cryptographic Entropy”

False because rigidity determines what happens once the latent coordinate is known. It does not identify the coordinate of an externally supplied target.

---

## 73. “A Random Walk Will Eventually Reach \(D\)”

Misleading because:

- the walk is deterministic;
- traversing from \(B\) requires access to the edge leaving \(B\);
- eventual reachability may require \(N-1\) steps;
- reachability is not an efficient attack.

---

## 74. “The Birthday Paradox Finds the Target Path”

False because every sampled point is already on the same path, while fixed-target alignment remains a preimage problem.

---

## 75. “The Avalanche Effect Creates Useful Randomness for Search”

False because pseudorandom-looking outputs remove visible gradients; they do not create an optimization signal.

---

## 76. “Uniformity Means Repeated Sampling Must Converge Toward the Target”

False because uniformity gives no directional preference toward a fixed target.

---

## 77. “Low-Level Determinism Means Predictability”

False because deterministic functions can still be computationally unpredictable under restricted information.

---

## 78. “Knowing \(f\) Conceptually Means Knowing Its Inverse Operationally”

False because mathematical specification, efficient forward evaluation, and efficient inverse evaluation are distinct notions.

---

# Part XI — Additional Failure Modes Identified by the Completeness Audit

## 79. Treating a Compressing Function as a Permutation

### False move

Use a function

\[
f:\{0,1\}^n\to\{0,1\}^m,
\qquad
m<n,
\]

while continuing to write \(f^{-1}\), \(g_{f,\phi}\), and
\(d_{f,\phi}\) as though every output had one unique preimage.

### How the false conclusion appears

The argument silently imports the permutation proof into a many-to-one
setting and then treats an arbitrarily selected preimage as the true latent
state. This makes a nonunique relation appear uniquely recoverable.

### Correct objection

By the pigeonhole principle, a compressing map cannot be injective. In
general,

\[
f^{-1}(y)
\]

is a set, not a point. The conjugation

\[
f\circ s_\phi\circ f^{-1}
\]

is therefore not a well-defined function unless additional state or an
inverse-branch rule is supplied.

The permutation-based MSR theorem does not apply unchanged.

---

## 80. Treating “Near-Injective” as Equivalent to Injective

### False move

Claim that collisions are rare enough to ignore and therefore use a unique
inverse “with overwhelming probability.”

### How the false conclusion appears

The proof discards precisely the ambiguity that prevents the visible state
from identifying a latent coordinate.

### Correct objection

“Near-injective” requires a formal distribution, collision bound, and target
model. Even a small collision fraction may be fatal if the supplied targets
fall in ambiguous fibers.

A valid result must quantify:

- the distribution of fiber sizes;
- the probability that \(B\) and \(D\) have unique preimages;
- how ambiguity affects \(\Delta\);
- whether the algorithm detects ambiguous cases;
- conditional and unconditional success probabilities.

---

## 81. Selecting an Arbitrary Inverse Branch

### False move

For a non-injective \(f\), define a branch

\[
r(y)\in f^{-1}(y)
\]

and substitute \(r\) for \(f^{-1}\).

### How the false conclusion appears

The resulting transition

\[
y\mapsto f(r(y)\oplus1)
\]

is treated as if it were the true transported latent successor.

### Correct objection

Different branch choices generally produce different transitions and
different distances. Unless the true latent states are guaranteed to equal
the selected branch values, the computed displacement need not be the
original \(\Delta\).

---

## 82. Confusing the Actual Displacement with a Minimum over Preimage Pairs

### False move

For a many-to-one function, define

\[
\min_{a\in f^{-1}(B),\,c\in f^{-1}(D)}
\bigl(\phi(c)-\phi(a)\bmod N\bigr)
\]

and call it the hidden displacement.

### How the false conclusion appears

A computable or small pairwise distance is substituted for the actual
relation between the unknown generating states.

### Correct objection

The minimum over all compatible preimage pairs is a new optimization problem.
It need not equal the displacement of the specific latent pair that generated
\(B,D\).

---

## 83. Ignoring Domain–Codomain and Bit-Length Mismatches

### False move

Use 256-bit latent states and truncated or 192-bit outputs, but continue to
identify the visible and latent vertex sets.

### Correct objection

The single-cycle conjugacy requires a bijection between equal-size state
spaces. Truncation changes both the inverse structure and the graph model.

The original compression-style MDT formulation and the permutation-based MSR
formulation are different mathematical problems.

---

## 84. Confusing Modular Displacement with a Signed Integer Distance

### False move

Recover

\[
\Delta\bmod N
\]

and report it as an unrestricted ordinary integer difference.

### How the false conclusion appears

A residue class is presented as a unique signed or non-wrapped distance.

### Correct objection

MSR returns the directed modular representative in

\[
\{0,\ldots,N-1\}.
\]

Additional conventions or promises are required to infer a signed distance,
a shortest circular distance, or an unbounded integer difference.

---

## 85. Replacing Directed Distance with an Undirected Distance

### False move

Treat

\[
d_{f,\phi}(B,D)
\]

and

\[
d_{f,\phi}(D,B)
\]

as equal, or replace both with their minimum.

### Correct objection

For distinct states,

\[
d_{f,\phi}(B,D)+d_{f,\phi}(D,B)=N.
\]

The directed displacement and the shortest undirected cycle distance are
different quantities. Replacing one by the other changes the recovery target.

---

## 86. Ignoring Modular Wraparound

### False move

Use ordinary subtraction without reducing modulo \(N\), or infer that
\(C<A\) is impossible.

### Correct objection

The latent successor is cyclic. A displacement may cross the \(N-1\) to \(0\)
boundary. Any nonmodular treatment requires an additional no-wrap promise.

---

## 87. Choosing \(\phi\) Adaptively to Encode the Answer

### False move

Select the coordinate map after seeing \(f,B,D\), for example by assigning
convenient coordinates to the target preimages or observed labels.

### How the false conclusion appears

The coordinate system itself stores the desired displacement, which is then
“recovered” by MSR.

### Correct objection

The cost and information used to construct \(\phi\) must be included.
Choosing \(\phi\) using \(f^{-1}(B)\), \(f^{-1}(D)\), or a complete inverse
table is circular.

The coordinate map must be fixed independently of the target instance for a
generic attack claim.

---

## 88. Defining a Visible Metric Using the Hidden Inverse

### False move

Define

\[
\rho(y_1,y_2)
=
\phi(f^{-1}(y_2))-\phi(f^{-1}(y_1))
\pmod N
\]

and then claim that \(\rho\) exposes latent proximity.

### Correct objection

This metric is exactly the unknown quantity rewritten with \(f^{-1}\). It is
not an independently computable visible statistic.

---

## 89. Choosing the Step Operator to Make \(g\) Easy

### False move

After inspecting \(f\), choose a successor \(s\) such that

\[
f\circ s\circ f^{-1}
\]

has a convenient visible representation.

### How the false conclusion appears

An easy visible transition is presented as evidence that the original
arithmetic successor \(s_\phi(x)=x\oplus1\) is accessible.

### Correct objection

Changing \(s_\phi\) changes the hidden relation being recovered. A valid MSR
attack must preserve the predeclared latent arithmetic operator.

---

## 90. Programming or Selecting the Permutation After Seeing the Targets

### False move

Construct \(f\), choose its key, or select a weak instance so that the desired
\(B,D,\Delta\) relation is visible.

### Correct objection

This proves only that some deliberately structured permutations are easy.
It does not establish a generic attack against an independently selected
secure permutation.

---

## 91. Selecting Targets from the Precomputed Table

### False move

Generate a large table first, then choose \(B,D\) among entries whose latent
inputs are already known.

### How the false conclusion appears

The attack appears to recover target preimages, although the targets were
selected precisely because their preimages were already available.

### Correct objection

Fixed-target and chosen-target experiments are different. Targets must be
selected independently of the attack transcript unless adaptive target
selection is part of the declared model.

---

## 92. Smuggling in Chosen-Input, Related-Input, or Related-Key Access

### False move

Use oracle calls that expose relationships such as

\[
f(A\oplus k),
\]

faulted executions, related keys, internal rounds, or decryptions, while
describing the model as forward black-box access only.

### Correct objection

Such interfaces may support real attacks, but they are stronger models. The
result must be attributed to the added interface rather than to MSR alone.

---

## 93. Assuming One Computable \(g_{f,\phi}\) Step Gives the Entire Distance

### False move

Show how to compute

\[
g_{f,\phi}(B)
\]

and conclude that \(\Delta\) follows immediately.

### Correct objection

Even with random-access evaluation of \(g_{f,\phi}\), naïve traversal may
require up to \(N-1\) iterations to reach \(D\).

A shortcut must also explain how to fast-forward, solve the associated orbit
index problem, or otherwise avoid linear traversal.

---

## 94. Assuming Fast-Forwarding from Black-Box Iteration

### False move

Treat a black-box ability to compute \(g(y)\) as an ability to compute

\[
g^k(y)
\]

in logarithmically many steps by “exponentiation.”

### Correct objection

Repeated squaring requires a composable representation of the function, not
merely pointwise black-box evaluation. An oracle for \(g\) does not
automatically supply succinct circuits for \(g^{2^j}\).

---

## 95. Treating a Sparse Transition Matrix as Cheap to Construct

### False move

Observe that the permutation matrix has one nonzero entry per row and infer
that it can be built efficiently.

### Correct objection

Sparsity reduces the number of stored entries only after their locations are
known. Determining the nonzero column in the row for a specified visible
state is exactly the transition-access problem.

The matrix has \(N\) rows; full construction remains exponential.

---

## 96. Applying Matrix Exponentiation to an Unavailable Matrix

### False move

Write

\[
M^k
\]

and use fast matrix exponentiation to claim logarithmic-time trajectory
navigation.

### Correct objection

The matrix is exponentially large and is not supplied explicitly. Fast
exponentiation of a known succinct matrix and access to an implicitly defined
unknown permutation matrix are different models.

---

## 97. Claiming Spectral Analysis Reveals Target Offsets

### False move

Use the known eigenvalues of an \(N\)-cycle to infer the positions of \(B\)
and \(D\).

### Correct objection

The spectrum reveals the abstract cycle structure, which is already known.
It is invariant under relabeling and therefore does not identify the target
vertices' latent coordinates.

---

## 98. Applying Fourier Analysis in the Wrong Ordering

### False move

Run a Fourier transform over the lexicographic or numeric ordering of visible
labels and treat it as Fourier analysis over the hidden cycle coordinate.

### Correct objection

The visible label ordering is generally unrelated to the transported latent
cycle ordering. Fourier methods become relevant only if the hidden ordering
or an equivalent coordinate representation is already accessible.

---

## 99. Treating the Strict Avalanche Criterion as One-Wayness

### False move

Argue that a function satisfying avalanche behavior is therefore a secure
one-way permutation or ideal pseudorandom permutation.

### Correct objection

Avalanche behavior is a local diffusion property. It does not imply:

- preimage resistance;
- pseudorandomness;
- resistance to algebraic attacks;
- resistance to key recovery;
- absence of invariant structure;
- security under the relevant oracle model.

---

## 100. Treating Statistical Randomness Tests as a Security Proof

### False move

Pass output-frequency, avalanche, or randomness tests and conclude that no
MSR shortcut exists.

### Correct objection

Statistical tests examine selected distributions and finite samples. They
cannot prove ideal-permutation security or rule out structural attacks.

Conversely, failing a test does not by itself yield displacement recovery.

---

## 101. Treating Near-Collisions as Latent Adjacency

### False move

Infer that outputs with small Hamming distance correspond to nearby points on
the MSR cycle.

### Correct objection

Near-collisions are metric events in the visible encoding, not graph
adjacency events. A target-linked correlation must be proved.

---

## 102. Assuming a Learned Model Generalizes an Ideal Random Permutation

### False move

Train a neural network or regression model on sampled pairs
\((x,f(x))\) and claim that it has learned the inverse or hidden coordinate
globally.

### Correct objection

An ideal random permutation has no compressible rule available from a
subexponential random sample. Training accuracy, memorization, or
generalization on related sample generation does not establish performance on
independent unseen targets.

Any learning claim must include held-out random permutations or keys, sample
complexity, model size, and target-independent evaluation.

---

## 103. Generalizing from One Weak Key or a Small Weak-Key Class

### False move

Demonstrate the shortcut for one key and call the cipher or generic MSR model
broken.

### Correct objection

The fraction of affected keys and the key-selection distribution must be
reported. A weak-key attack is not automatically an average-key or
all-key attack.

---

## 104. Confusing Multi-Target or Multi-User Advantage with Single-Target Recovery

### False move

Use many targets, many users, or repeated instances under the same
permutation and report the amortized cost as the complexity of one fresh
target pair.

### Correct objection

The number of targets and reuse of \(f\) are resources. Multi-target attacks
may be valid, but their success and cost must be stated as functions of the
number of available targets.

---

## 105. Hiding Time–Memory Preprocessing Behind Constant Online Time

### False move

Build Hellman-style, rainbow-style, or custom trajectory tables, then report
only a fast online lookup.

### Correct objection

The preprocessing queries, time, memory, coverage probability, false alarms,
chain merges, and amortization count must be included.

A fast online phase does not imply a cheap single-instance attack.

---

## 106. Assuming the Same Permutation Persists Across Instances

### False move

Amortize preprocessing across many experiments while silently changing keys
or permutations, or assume long-term reuse when the real system rotates keys.

### Correct objection

Preprocessing correlated with one \(f\) generally does not transfer to an
independently sampled permutation. The lifetime and reuse model of \(f\) must
be explicit.

---

## 107. Using the Wrong Baseline for Biased Target Distributions

### False move

Compare an attack to uniform guessing even though \(\Delta\) or the targets
come from a concentrated distribution.

### Correct objection

The proper baseline is the optimal prior-only estimator under the declared
target distribution. An apparent advantage may come entirely from the prior
rather than from MSR or oracle information.

---

## 108. Returning a Candidate Set but Claiming Exact Recovery

### False move

Output a list containing the correct \(\Delta\) with some probability and
describe the result as recovering \(\Delta\).

### Correct objection

List recovery, partial recovery, and unique exact recovery have different
success criteria. The list size and the cost of identifying the correct
candidate must be counted.

---

## 109. Hiding the Cost or Impossibility of Verification

### False move

Guess a value \(\widehat{\Delta}\) and assume it can be cheaply verified from
\(B,D\) under forward-only access.

### Correct objection

Verification may itself require finding a compatible preimage \(A\) such that

\[
f(A)=B,
\qquad
f(A\oplus\widehat{\Delta})=D.
\]

An unverifiable guess is not an efficiently certified recovery result.

---

## 110. Reversing the Direction of a Reduction

### False move

Show that solving inversion permits displacement recovery and conclude that
solving displacement must therefore be at least as hard as inversion.

### Correct objection

To transfer a lower bound from inversion to displacement, one needs a
reduction from inversion **to** displacement recovery, not merely from
displacement recovery to inversion in the opposite direction.

The reduction direction must match the claimed hardness implication.

---

## 111. Using a Circular Reduction

### False move

Construct a reduction that calls the desired inverter, inverse table, or
unknown transition as part of preparing the displacement instance.

### Correct objection

A valid reduction may use only the resources granted in the source problem
plus the assumed solver for the target problem. Hidden use of the desired
answer invalidates the argument.

---

## 112. Ignoring Bit Complexity and Representation Cost

### False move

Treat arithmetic on \(n\)-bit integers, storage addresses in a \(2^n\)-entry
table, or giant symbolic polynomials as unit-cost operations.

### Correct objection

Word-RAM, bit-complexity, circuit, and algebraic-operation models are
different. A polynomial number of operations on exponentially large objects
may still require exponential time or space.

---

# Part XII — Composite False-Proof Pipelines

The false conclusion usually appears through a combination of errors. The
following pipelines show how the flaws must cooperate.

## Pipeline A — The Compression-to-Cycle Illusion

1. Start with a truncating or hashing function \(f:\{0,1\}^n\to\{0,1\}^m\)
   with \(m<n\).
2. Call it “near-injective.”
3. Select one arbitrary inverse branch.
4. Construct a branch-dependent visible transition.
5. Treat the resulting distance as the actual latent \(\Delta\).
6. Ignore other compatible preimages.

The apparent attack is produced by replacing the original many-to-one
problem with a different branch-selected permutation-like problem.

---

## Pipeline B — The Coordinate-Encoded Answer

1. Observe \(f,B,D\).
2. Construct \(\phi\) using target preimages, an inverse table, or a chosen
   ordering that places \(B,D\) conveniently.
3. Compute an easy visible distance.
4. Attribute the result to MSR rather than to the information embedded in
   \(\phi\).

The claimed recovery is circular because the coordinate map already contains
the answer.

---

## Pipeline C — The Sparse-Matrix Shortcut

1. Define the exponentially large permutation matrix \(M^{(f,\phi)}\).
2. Note that it is sparse.
3. Assume its nonzero positions are available.
4. Apply matrix powers, spectral analysis, or Fourier methods.
5. Read off the target path length.

The hidden step is constructing or random-accessing the matrix, which is
essentially the original transition problem.

---

## Pipeline D — The Sampling-and-Birthday Shortcut

1. Generate many unrelated sampled edges.
2. Call them independent random walks.
3. Use birthday language to assert intersection with a target path.
4. Ignore that all edges lie on the same cycle but lack calibrated offsets.
5. Condition on accidentally hitting a target.
6. Report only the conditional traversal cost.

The false speedup comes from substituting arbitrary collisions for fixed
target alignment and omitting the hit probability.

---

## Pipeline E — The Algebraic Polynomial-Time Shortcut

1. Encode \(f\) with low-degree Boolean equations.
2. Assume low initial degree implies low solving degree.
3. Eliminate \(A\) without accounting for degree and size explosion.
4. Treat the resulting \(\Delta\)-equation as uniquely solvable.
5. Ignore solver runtime, memory, multiple solutions, and verification.

The claimed polynomial attack is created by assuming the conclusion about the
algebraic solver.

---

## Pipeline F — The Hidden-Preprocessing Shortcut

1. Precompute a large inverse, trajectory, Hellman, or learned table for a
   fixed \(f\).
2. Choose or receive targets after preprocessing.
3. Report only online lookup time.
4. Ignore preprocessing queries, memory, coverage, reuse assumptions, and
   amortization.

The attack may have low online latency while retaining exponential total
resources.

---

## Pipeline G — The Weak-Instance Generalization

1. Select a weak key, toy permutation, affine instance, or adaptively chosen
   coordinate map.
2. Demonstrate exact recovery.
3. Omit the instance-selection process.
4. Generalize to secure random keys or ideal permutations.

The result proves only that the selected weak instance is weak.

---

## Pipeline H — The Oracle Substitution

1. State a forward-only model.
2. Use decryption, \(f^{-1}\), \(U_f^\dagger\), related-input access, or a
   random-access \(g_{f,\phi}\) oracle inside the algorithm.
3. Compute \(\Delta\) efficiently.
4. Attribute the result to the original model.

The break is caused by the stronger oracle, not by MSR.

---

## Pipeline I — The Partial-Information Upgrade

1. Find a distinguisher, biased bit, candidate list, or weak correlation.
2. Assume errors disappear under repetition.
3. Assume partial bits combine independently.
4. Skip the cost of disambiguation and verification.
5. Report exact 256-bit recovery.

The false conclusion upgrades partial statistical information into exact
cryptanalysis without a valid reconstruction theorem.

---

## Pipeline J — The Modular-to-Ordinary Distance Substitution

1. Recover or define a residue \(\Delta\bmod N\).
2. Ignore wraparound and direction.
3. Select the numerically convenient signed representative.
4. Report it as the unique ordinary arithmetic distance.

The output solves a different distance problem from the one formally defined
by MSR.

---


# Part XIII — Further Independent Failure Modes Identified by the Second Completeness Audit

## 113. Leaving “Break Cryptography” Undefined

### False move

Claim that MSR “breaks cryptography” without defining the security game or
the adversary's required output.

### How the false conclusion appears

Any nonrandom pattern, distinguisher, partial bit prediction, weak-key result,
or impractical asymptotic improvement is relabeled as a full cryptographic
break.

### Correct objection

A result must state the exact goal, for example:

- distinguish a keyed permutation from an ideal permutation;
- invert one specified output;
- recover the secret key;
- recover the exact displacement \(\Delta\);
- recover some bits of \(\Delta\);
- produce a candidate list containing \(\Delta\);
- forge, decrypt, or violate a named security notion.

Success probability, data, queries, time, and memory must be measured in that
game. Different goals are not interchangeable.

---

## 114. Substituting One Security Goal for Another

### False move

Prove a distinguisher, related-key property, weak-key phenomenon, or partial
state leak and conclude exact target displacement recovery.

### How the false conclusion appears

A weaker achievement is silently upgraded to the stronger game needed for
the advertised break.

### Correct objection

A reduction must show how the weaker capability produces the stronger output
with quantified loss. Without that reduction,

\[
\text{nonideality}
\not\Longrightarrow
\text{inversion}
\not\Longrightarrow
\text{key recovery}
\not\Longrightarrow
\text{exact }\Delta\text{ recovery}.
\]

---

## 115. Swapping Quantifiers

### False move

Confuse statements such as

\[
\forall f\ \exists A_f
\]

with

\[
\exists A\ \forall f,
\]

where \(A_f\) is an algorithm tailored to a particular permutation and \(A\)
is one uniform generic algorithm.

### How the false conclusion appears

For every fixed finite permutation, one can define a program containing its
complete inverse table. This is then misreported as one efficient attack
working against arbitrary secure permutations.

### Correct objection

The order of quantifiers is part of the theorem. A generic attack requires a
single uniform algorithm, or a clearly bounded nonuniform advice family, that
works under the declared sampling and access model.

---

## 116. Treating an Existentially Easy Instance as a Generic Algorithm

### False move

Show that there exists a permutation, key, target pair, or coordinate map for
which recovery is easy.

### Correct objection

An existential example establishes only

\[
\exists(f,B,D)\ \text{easy}.
\]

A generic claim requires appropriate universal or high-probability
quantifiers over independently selected instances.

---

## 117. Using a Reduction That Does Not Preserve the Game

### False move

Reduce one problem to another while changing one or more of:

- target distribution;
- key distribution;
- oracle access;
- adaptivity;
- preprocessing;
- number of targets;
- success criterion;
- computational resources.

### How the false conclusion appears

The target solver appears to solve the original problem only because the
reduction gave it an easier instance or a stronger interface.

### Correct objection

A valid reduction must explicitly map instances, simulate all oracles, bound
resource overhead, and transfer success probability under the same relevant
distribution or worst-case quantifiers.

---

## 118. Treating Nonconstructive Existence as an Algorithm

### False move

Prove that a minimum, inverse, path, labeling, eigenbasis, or optimal
coordinate map exists and then treat it as efficiently obtainable.

### Correct objection

Finite existence does not imply constructive or efficient computation. An
algorithm must specify how the object is represented and produced within the
claimed resource bound.

---

## 119. Encoding Exponential Information in an Infinite-Precision Constant

### False move

Store an inverse table, target path, or all values of \(f\) in the binary
expansion of one real number and count access to that real as constant cost.

### How the false conclusion appears

Exponential advice is hidden inside an object described as “one parameter.”

### Correct objection

The precision, representation length, preparation cost, and bit-access model
must be counted. Exact arbitrary real arithmetic is not a standard efficient
computational resource.

---

## 120. Assuming Exact Access to Expectations or Probabilities

### False move

Define an expectation, density, stationary statistic, or infinitesimal bias
and assume its exact value can be queried directly.

### Correct objection

An empirical algorithm receives finite samples. Estimating a quantity to
additive error \(\epsilon\) generally requires sample complexity depending on
\(1/\epsilon\). An exact probability oracle is a stronger, separately stated
model.

---

## 121. Treating an Exponentially Small Bias as Efficiently Detectable

### False move

Show that a statistic differs from uniform by a nonzero amount such as
\(2^{-n}\), then call the statistic an efficient compass.

### Correct objection

Nonzero advantage is not necessarily useful. Detecting advantage \(\epsilon\)
with constant confidence commonly requires on the order of
\(1/\epsilon^2\) independent samples in a standard estimation setting.
The sample-generation and dependence model must also be justified.

---

## 122. Confusing Information-Theoretic Leakage with Efficient Extraction

### False move

Show positive mutual information between a transcript and \(\Delta\) and
conclude polynomial-time recovery.

### Correct objection

Information may exist but be computationally inaccessible. A complete attack
needs an efficient decoder and a quantitative relation among mutual
information, error probability, transcript size, and computational cost.

---

## 123. Misusing Shannon Entropy as Search Complexity

### False move

Subtract an estimated number of entropy bits per observation and infer that
the remaining brute-force work is \(2^{H}\).

### Correct objection

Shannon entropy, min-entropy, guesswork, and computational search complexity
are different quantities. Correlated observations cannot be credited as
independent entropy reductions.

---

## 124. Treating Positive Correlation as a Monotone Gradient

### False move

Observe that a feature is weakly correlated with latent distance on average
and assume greedy local optimization will converge to the target.

### Correct objection

Correlation does not imply monotonicity, absence of local optima, or an
efficient optimization landscape. The attack needs a proved navigation
algorithm with convergence and error guarantees.

---

## 125. Applying Ergodic or Mixing-Time Theorems to the Deterministic Cycle

### False move

Call the full cycle irreducible and then assume ordinary mixing convergence
from a point mass.

### Correct objection

The deterministic \(N\)-cycle is periodic with period \(N\). Its distribution
from a fixed initial state rotates rather than converges to the stationary
distribution.

Aperiodic mixing theorems do not apply unless randomness or self-loops are
added, which changes the process.

---

## 126. Treating Expected Hitting Time as an Observable Quantity

### False move

Write an expected hitting-time formula and assume the evaluator can read the
actual target distance from it.

### Correct objection

An expectation over a starting distribution is not the realized directed
distance for a particular pair \(B,D\). Computing hitting times through
linear equations also presupposes access to the transition structure.

---

## 127. Solving Hitting-Time Linear Equations for an Unavailable Matrix

### False move

Use the standard system

\[
h(y)=1+h(g_{f,\phi}(y))
\]

with a boundary at \(D\), then claim that linear algebra recovers
\(h(B)=\Delta\).

### Correct objection

The system has exponentially many variables, and its coefficients require
knowledge of the unknown outgoing edge of every visible state. Writing the
equations does not supply them.

---

## 128. Confusing Existence of the Conjugacy with Knowledge of the Conjugator

### False move

Argue that because \(g_{f,\phi}\) is conjugate to the simple shift
\(s_\phi\), the evaluator can transfer computations between them.

### How the false conclusion appears

The conjugating map is treated as a free coordinate conversion.

### Correct objection

The conjugator is \(f\), and conversion in the reverse direction uses
\(f^{-1}\). Existence of an isomorphism does not mean the isomorphism or its
inverse is available in the required direction.

---

## 129. Assuming Every Arithmetic Step Produces One Full Cycle

### False move

Replace the successor by

\[
s_k(x)=x\oplus k
\]

and continue to claim a single cycle of length \(N\).

### Correct objection

The number of cycles is

\[
\gcd(k,N),
\]

and each cycle has length

\[
\frac{N}{\gcd(k,N)}.
\]

A full cycle occurs only when \(\gcd(k,N)=1\). For \(N=2^n\), \(k\) must be
odd.

---

## 130. Extending a Local Differential Relation Globally

### False move

Find that

\[
f(x\oplus1)
\]

has a biased or approximately affine relation to \(f(x)\) on some samples and
then integrate that relation across the entire cycle.

### Correct objection

Local average behavior need not compose. Errors can accumulate, dependencies
can change with \(x\), and a relation valid for a subset or one round need
not define a global visible coordinate.

---

## 131. Assuming Pairwise Difference Behavior Depends Only on the Difference

### False move

Infer that

\[
f(x\oplus\delta)-f(x)
\]

is a function only of \(\delta\), without proving independence from \(x\).

### Correct objection

That property is a strong homomorphic or affine structure. If it holds, it
must be proved for the concrete function; it is not implied by determinism,
avalanche behavior, or the MSR definition.

---

## 132. Treating One Quantum Superposition Query as the Entire Truth Table

### False move

Query

\[
\sum_x |x\rangle|0\rangle
\]

and describe the resulting state as if all pairs \((x,f(x))\) had been read
classically.

### Correct objection

The state contains amplitudes over all pairs, but measurement yields limited
classical information. Quantum query complexity accounts for what can be
extracted through interference and measurement, not merely what appears in a
formal superposition.

---

## 133. Ignoring Quantum Measurement and Readout Limits

### False move

Perform a coherent computation containing all candidate distances and assume
the correct one can be read without amplification or a distinguishing
measurement.

### Correct objection

The final success probability depends on the amplitude of the correct answer
and the measurement procedure. Producing a superposition containing the
answer is not the same as recovering it.

---

## 134. Using Postselection Without Paying for Its Probability

### False move

Condition on an exponentially unlikely measurement outcome that reveals
\(\Delta\), then report only the conditional circuit depth.

### Correct objection

Ordinary quantum algorithms must include the probability and repetition or
amplification cost. Free postselection defines a strictly stronger
computational model.

---

## 135. Applying Shor’s Algorithm Merely Because the Graph Is a Cycle

### False move

Treat the directed cycle as a cyclic group with an efficiently usable group
oracle and claim that phase estimation or discrete logarithms recover the
offset.

### Correct objection

Shor-style algorithms require efficiently implementable coherent group
operations, powers, inverses, suitable state preparation, and a measurement
encoding the hidden relation. An abstract cycle and a forward oracle for
\(f\) do not automatically provide these resources.

---

## 136. Assuming Efficient Coherent Fast-Forwarding

### False move

Assume one can implement

\[
|y\rangle\mapsto|g_{f,\phi}^{\,2^j}(y)\rangle
\]

at cost polynomial in \(j\) from ordinary one-step black-box access.

### Correct objection

Generic black-box iteration does not provide exponential fast-forwarding.
Such an implementation would itself be substantial additional structure.

---

## 137. Assuming a Generic Quantum-Walk Quadratic Speedup

### False move

Place the problem on a cycle and invoke “quantum walk” to claim a quadratic
or exponential improvement.

### Correct objection

Quantum-walk speedups depend on the graph oracle, marked-state test,
initial-state preparation, spectral gap, and problem formulation. A cycle
labeling hidden behind \(f\) does not by itself instantiate a useful quantum
walk search.

---

## 138. Ignoring Precision in Spectral or Phase Estimation

### False move

Assume an eigenphase or Fourier coefficient reveals an exact
\(n\)-bit displacement at constant precision and cost.

### Correct objection

Recovering an \(n\)-bit index may require correspondingly fine phase
resolution, coherent powers, and controlled error. Precision and state
preparation costs must be included.

---

## 139. Substituting Random-Oracle, Random-Function, PRF, and PRP Models

### False move

Move freely among:

- a random function;
- a random oracle;
- a random permutation;
- a pseudorandom function;
- a pseudorandom permutation;
- a concrete keyed cipher.

### Correct objection

These objects have different collision behavior, inverse structure, oracle
interfaces, and security definitions. A theorem in one model transfers only
through a stated reduction, such as an appropriately bounded PRP/PRF
switching argument where applicable.

---

## 140. Treating Computational Pseudorandomness as Information-Theoretic Randomness

### False move

Assume a secure PRP is literally uniformly sampled from all permutations and
therefore inherits every information-theoretic statement without reduction.

### Correct objection

A PRP is computationally indistinguishable from an ideal permutation for a
specified class of adversaries and query bounds. Transferring an attack or
lower bound requires a security reduction and attention to reduction loss.

---

## 141. Ignoring Reduction Loss

### False move

Use a distinguisher or solver with advantage \(\epsilon\), transform it
through several reductions, and report the original advantage and runtime
unchanged.

### Correct objection

Reductions can multiply queries, time, data, and failure probability. A
claimed practical or asymptotic break must include the total loss.

---

## 142. Conflating Randomness over Keys, Permutations, Targets, and Algorithms

### False move

State that an attack succeeds “with high probability” without identifying
which random variables are averaged.

### Correct objection

The probability space must specify whether randomness comes from:

- the sampled key;
- an ideal permutation;
- target selection;
- the attacker's coins;
- measurement;
- noise;
- preprocessing.

Average-key, average-target, and worst-case guarantees are different.

---

## 143. Assuming Self-Reducibility Without Proof

### False move

Claim that an algorithm working for random targets can solve every target by
randomly transforming the instance.

### Correct objection

The transformation must preserve the oracle model and map solutions back
correctly. Random self-reducibility is a theorem to be proved, not a generic
property of every keyed or structured permutation family.

---

## 144. Treating a Heuristic Optimizer as a Proven Cryptanalytic Algorithm

### False move

Use simulated annealing, evolutionary search, gradient surrogates, or machine
learning and infer a generic break from occasional empirical success.

### Correct objection

A heuristic may be useful against a concrete weak structure, but a generic
claim needs reproducible distributions, scaling, success bounds, and
comparison with baselines. Failure cases and restart costs must be included.

---

## 145. Assuming Numerical Stability and Exact Arithmetic

### False move

Derive a shortcut requiring exact cancellation, exact eigenvectors, or
exponentially precise real-valued scores, then implement it with ordinary
finite precision without error analysis.

### Correct objection

Rounding and condition numbers may destroy the signal. Precision requirements
belong in the complexity analysis.

---

## 146. Ignoring Multiple Oracle-Consistent Worlds

### False move

Given a partial transcript, reason as if the unqueried part of \(f\) had one
fixed completion favorable to the claimed answer.

### Correct objection

A correct black-box argument must consider all permutations consistent with
the transcript. If two consistent completions produce different target
displacements while the transcript is identical, the algorithm cannot know
which answer is correct.

---

## 147. Treating a Randomized, Tweakable, or Stateful Primitive as the Fixed \(f\)

### False move

Apply the deterministic-permutation MSR model while ignoring nonces, tweaks,
randomness, state updates, or domain separation.

### Correct objection

The true state space must include all parameters that affect the mapping. If
the mapping changes between calls, there may be no single fixed
\(g_{f,\phi}\) or reusable trajectory graph.

---

## 148. Omitting Context from the State Space

### False move

Model only the message block while leaving the key, tweak, nonce, round
counter, chaining value, or protocol state outside \(\mathcal X\).

### How the false conclusion appears

Outputs generated under different contexts are incorrectly placed on one
common cycle.

### Correct objection

Either the context is fixed, or it must be incorporated into the formal
state. Otherwise, the conjugacy relation does not describe the observed
system.

---

## 149. Calling an Asymptotic Improvement a Practical Break

### False move

Reduce a generic cost from \(2^n\) to \(2^{0.99n}\), or from \(2^{256}\) to
\(2^{128}\), and call the system practically broken without resource
estimates.

### Correct objection

“Asymptotically better,” “security-level reduction,” and “practically
executable” are different conclusions. Hardware, depth, memory, energy,
parallelism, and error-correction costs must be reported.

---

## 150. Calling a Practical Heuristic a Proven Asymptotic Break

### False move

Demonstrate success for available sizes and claim a subexponential or
polynomial asymptotic algorithm without a justified scaling law.

### Correct objection

Finite-size empirical performance does not determine asymptotic complexity.
Both practical and asymptotic claims must be stated at the level actually
supported by evidence.

---

# Part XIV — Additional Composite False-Proof Pipelines

## Pipeline K — The Undefined-Break Upgrade

1. Find any detectable nonideality.
2. Avoid defining the security game.
3. call the result “breaking cryptography.”
4. Let readers infer key recovery or exact \(\Delta\) recovery.

The false conclusion is created by leaving the required achievement
undefined.

---

## Pipeline L — The Quantifier-Swap Attack

1. For each fixed \(f\), define a tailored inverse-table algorithm.
2. Omit the table from the algorithm description.
3. Reverse \(\forall f\,\exists A_f\) into \(\exists A\,\forall f\).
4. Claim one generic efficient solver.

The hidden nonuniform advice contains the entire solution.

---

## Pipeline M — The Infinite-Precision Shortcut

1. Encode the inverse table or target path in a real constant.
2. Count the constant as one word.
3. Extract arbitrary bits at unit cost.
4. Report constant-space, polynomial-time recovery.

The speedup is supplied by an unphysical infinite-precision advice model.

---

## Pipeline N — The Mixing-and-Hitting-Time Shortcut

1. Call the deterministic cycle an ergodic random walk.
2. Assume convergence to stationarity.
3. Write standard hitting-time equations.
4. Ignore that the transition matrix is unavailable and exponentially large.
5. Read \(h(B)\) as \(\Delta\).

The false answer is produced by importing stochastic and linear-algebraic
oracles not present in MSR.

---

## Pipeline O — The Quantum-Parallelism Shortcut

1. Query all inputs in superposition.
2. Treat the quantum state as a classically readable truth table.
3. Assume the desired pair can be selected without amplitude cost.
4. Ignore measurement and postselection probability.
5. Claim one-query inversion.

The apparent speedup comes from violating quantum readout limits.

---

## Pipeline P — The Shor-on-a-Cycle Shortcut

1. Observe that \(G_{f,\phi}\) is a cycle.
2. Call the unknown offset a discrete logarithm.
3. Assume coherent fast powers of \(g_{f,\phi}\).
4. Apply phase estimation.
5. Ignore that neither a usable group representation nor fast-forwarding is
   supplied.

The cyclic topology alone does not instantiate Shor's oracle model.

---

## Pipeline Q — The PRP-to-Ideal Substitution

1. Prove a statement for a uniform ideal permutation.
2. Replace it with a concrete keyed cipher.
3. Omit the PRP reduction, query range, and security loss.
4. Report the ideal-model conclusion as unconditional.

The false claim comes from replacing computational indistinguishability with
literal identity of models.

---

## Pipeline R — The Tiny-Bias Compass

1. Measure a nonzero but exponentially small bias.
2. Call it a gradient.
3. Ignore sample complexity and dependence.
4. Run a heuristic optimizer.
5. Upgrade occasional success to exact generic recovery.

The attack omits the cost required to resolve and use the bias.

---

## Pipeline S — The Missing-Context Cycle

1. Observe outputs under different keys, tweaks, nonces, or states.
2. model them as one fixed permutation.
3. Construct one visible cycle.
4. infer a distance across outputs that do not belong to the same mapping.

The claimed MSR relation is applied to a system for which its defining
function is not fixed.

---


# Part XV — Final Framework-Specific Failure Modes Identified by the Third Completeness Audit

## 151. Conflating Modular Addition with Bitwise XOR

### False move

Interpret

\[
s_\phi(x)=x\oplus1
\]

as bitwise XOR with the word \(1\), even though the MSR construction intends
addition by one modulo \(N=2^n\) through the coordinate map \(\phi\).

### How the false conclusion appears

The analyst silently switches between two different algebraic structures:

\[
\mathbb{Z}_{2^n}
\qquad\text{and}\qquad
(\mathbb{Z}_2)^n.
\]

Properties proved for one operation are then attributed to the other.

### Correct objection

Bitwise XOR by \(1\) flips only the least significant bit and consists of
\(2^{n-1}\) disjoint 2-cycles. It is not a single cycle of length \(2^n\).

The full-cycle successor is

\[
s_\phi(x)
=
\phi^{-1}\!\left(\phi(x)+1\bmod 2^n\right).
\]

The notation must distinguish modular addition from bitwise XOR explicitly.
Otherwise, the conjugacy theorem and the graph topology being analyzed are
not the same as the implemented operation.

---

## 152. Confusing Modular Displacement with XOR Difference

### False move

Replace

\[
\Delta
=
\phi(C)-\phi(A)\pmod{2^n}
\]

with the bitwise difference

\[
A\mathbin{\mathrm{XOR}}C
\]

and treat them as interchangeable.

### How the false conclusion appears

A visible or algebraic property involving XOR differences is presented as a
recovery of the MSR modular displacement.

### Correct objection

Modular subtraction includes carries and wraparound; XOR does not. In
general,

\[
\phi(C)-\phi(A)\pmod{2^n}
\neq
A\mathbin{\mathrm{XOR}}C.
\]

An attack recovering one quantity has not recovered the other unless an
additional promise proves that they coincide on the relevant instances.

---

## 153. Inferring That \(f\) Is a Full Cycle Because \(g_{f,\phi}\) Is

### False move

Use the fact that

\[
g_{f,\phi}
=
f\circ s_\phi\circ f^{-1}
\]

is conjugate to a full cycle and conclude that \(f\) itself must be a full
cycle.

### How the false conclusion appears

The analyst treats the cipher permutation's own iteration structure as the
MSR trajectory and assumes every state is reached by repeated encryption.

### Correct objection

Conjugacy preserves the cycle structure of \(s_\phi\) and
\(g_{f,\phi}\), not the cycle structure of the conjugating permutation
\(f\).

The permutation \(f\) may have any valid cycle decomposition. The fact that
\(g_{f,\phi}\) is one \(N\)-cycle says nothing comparable about the cycles of
\(f\).

---

## 154. Iterating \(f\) Instead of Iterating \(g_{f,\phi}\)

### False move

Start from \(B\) and compute

\[
B,\ f(B),\ f^2(B),\ldots
\]

as though this followed the MSR path from \(B\) to \(D\).

### How the false conclusion appears

Forward cipher evaluation is mistaken for direct access to the visible MSR
successor, producing an apparently executable trajectory.

### Correct objection

The MSR transition is

\[
g_{f,\phi}(y)
=
f\!\left(
s_\phi(f^{-1}(y))
\right),
\]

whereas iteration of \(f\) follows

\[
y\mapsto f(y).
\]

These are unrelated in general. Equality would require strong additional
structure that must be proved for the concrete permutation.

Thus, ordinary repeated encryption does not traverse the MSR cycle.

---

## 155. Claiming That the Output Pair Alone Identifies \(\Delta\)

### False move

Construct a statistic of \(B,D\) alone and claim that it predicts the hidden
nonzero displacement for an ideal random permutation without using
permutation-correlated oracle information.

### How the false conclusion appears

Patterns in the visible encodings are interpreted as latent displacement
information.

### Correct objection

Fix any nonzero displacement \(\delta\), choose \(A\) uniformly, let

\[
C=A\oplus\delta,
\]

and sample \(f\) uniformly from all permutations. Then

\[
(B,D)=(f(A),f(C))
\]

is uniform over all ordered pairs of distinct visible outputs. Its
distribution is the same for every nonzero \(\delta\).

Therefore, when \(\Delta\) is uniform over the nonzero residues,

\[
I(\Delta;B,D)=0
\]

in the ideal-permutation experiment before permutation-correlated queries or
advice are supplied. No output-only statistic can beat the prior baseline in
that model.

A successful output-only rule must therefore exploit nonideal structure,
biased target generation, leaked metadata, adaptive instance selection, or
some other model change.

---

## 156. Misusing Floyd’s or Brent’s Cycle-Finding Algorithm

### False move

Invoke Floyd's tortoise-and-hare algorithm or Brent's algorithm and claim
that the offset from \(B\) to \(D\) can be recovered in
\(O(\sqrt N)\) time or constant memory.

### How the false conclusion appears

A cycle-detection algorithm is relabeled as a target-distance algorithm.

### Correct objection

Floyd's and Brent's methods detect eventual repetition and determine cycle
parameters when a successor function can be evaluated. They do not
generically determine the directed index of an arbitrary labeled target
\(D\) relative to \(B\) faster than traversing until \(D\) is encountered.

In MSR:

- the cycle length \(N\) is already known;
- random-access evaluation of \(g_{f,\phi}\) is not supplied by the forward
  oracle for \(f\);
- constant memory does not create a sublinear target-index algorithm.

Cycle detection and target-offset recovery are different problems.

---

## 157. Misusing Baby-Step–Giant-Step, Pollard Rho, or Meet-in-the-Middle

### False move

Call \(\Delta\) a discrete logarithm and immediately claim a classical
\(O(\sqrt N)\) attack using baby-step–giant-step, Pollard rho, or a generic
meet-in-the-middle method.

### How the false conclusion appears

The square-root complexity of algorithms in efficiently represented groups
is transferred to an implicitly labeled black-box cycle.

### Correct objection

These algorithms require additional operations such as:

- efficient composition or group multiplication;
- inverses;
- efficiently computable giant steps or powers;
- a collision relation that reveals the desired index;
- an efficiently testable match condition.

One-step access to a successor does not automatically provide
\(g^{m}\), \(g^{-m}\), or a usable group encoding at unit cost. In the actual
MSR forward-oracle model, even random-access one-step \(g\) evaluation is not
given.

A valid square-root classical algorithm must explicitly construct the
required operations and include their costs. The analogy to discrete
logarithms is not itself an algorithm.

---

## 158. Hiding a Promise Condition Needed by the Shortcut

### False move

Prove an attack only when, for example:

- \(\Delta\) is small;
- selected bits of \(A\) are known;
- the key is weak;
- \(f\) is affine on a subset;
- the target belongs to a precomputed region;
- an error rate stays below a threshold;

and then report the result as an unrestricted generic attack.

### How the false conclusion appears

The promise supplies the actual entropy reduction or structural weakness,
while MSR receives credit for the resulting shortcut.

### Correct objection

The promise set, its probability under the real instance distribution, and
whether membership can be recognized must all be stated.

An attack on a promise problem does not solve the unrestricted problem unless
a reduction covers all instances or the claimed success probability includes
the frequency of promised instances.

---

## 159. Treating the Absence of a Lower Bound as Evidence of an Attack

### False move

Argue that because no theorem rules out a particular heuristic,
representation, or shortcut, it should be regarded as a cryptographic break.

### How the false conclusion appears

A gap in the impossibility proof is converted into positive evidence for an
algorithm.

### Correct objection

Failure to prove a lower bound does not construct an attack. The burden for a
break remains:

- a fully specified algorithm;
- a precise access model;
- a proof or reproducible success analysis;
- total time, memory, data, and preprocessing costs;
- a defined security goal and baseline.

Likewise, inability to identify a flaw in a heuristic is not evidence that
the heuristic succeeds.

---


# Part XVI — Security-Consequence and Parameterization Errors Identified by the Fourth Completeness Audit

## 160. Equating Recovery of \(\Delta\) with Breaking Encryption

### False move

Show that an algorithm outputs

\[
\Delta
=
\phi(C)-\phi(A)\pmod N
\]

and immediately call this an encryption break, key-recovery attack, or plaintext-recovery attack.

### How the false conclusion appears

The MSR displacement game is silently substituted for a standard
cryptographic security game.

### Correct objection

Recovering a relative displacement is a distinct task. By itself, it does
not necessarily reveal:

- \(A\);
- \(C\);
- the secret key;
- a decryption oracle;
- future plaintexts;
- semantic information about a message.

A cryptographic break requires a reduction showing how displacement recovery
violates a stated security goal. For example, if \(A\) is independently known
and the block-level representation is the relevant plaintext representation,
then \(C\) follows from

\[
C
=
\phi^{-1}\!\left(\phi(A)+\Delta\bmod N\right).
\]

Without such an anchor or another reduction, exact \(\Delta\) recovery may be
interesting without constituting a confidentiality break.

---

## 161. Assuming \(\Delta\) Determines the Absolute Preimages

### False move

Treat knowledge of \(\Delta\) as though it directly identifies both
\(A=f^{-1}(B)\) and \(C=f^{-1}(D)\).

### How the false conclusion appears

A relative coordinate is presented as an absolute coordinate.

### Correct objection

Before using \(f\), the relation

\[
C=A\oplus\Delta
\]

has one compatible pair for every possible \(A\). Knowing \(\Delta\) removes
one degree of freedom but does not supply an absolute anchor.

Even with \(B,D\) available, locating the unique compatible pair can still
require solving

\[
f(A)=B,
\qquad
f(A\oplus\Delta)=D.
\]

The cost of that residual search or inversion problem must be included.

---

## 162. “Recovering” a Displacement Already Known from Chosen Plaintexts

### False move

Choose \(A\) and \(C\), compute

\[
B=f(A),
\qquad
D=f(C),
\]

and then present successful computation of

\[
\Delta
=
\phi(C)-\phi(A)\pmod N
\]

as recovery of a hidden cryptographic secret.

### How the false conclusion appears

The experiment uses known inputs to generate the challenge, but the resulting
known relation is described as if it were unknown to the attacker.

### Correct objection

In a chosen-plaintext experiment, the attacker already knows \(A,C\), and
therefore already knows \(\Delta\). Recomputing that value from the outputs
may validate an implementation or statistic, but it does not by itself break
encryption.

A meaningful challenge must hide the quantity being claimed as recovered and
must prevent the attack algorithm from using the generation metadata.

---

## 163. Smuggling in a Hidden-Anchor Related-Input Oracle

### False move

Assume access to values such as

\[
f(A\oplus r)
\]

for attacker-chosen \(r\), even though \(A\) is the hidden preimage of the
target \(B\).

### How the false conclusion appears

The attack receives related evaluations centered on the unknown target
preimage, creating exactly the alignment information that MSR lacks.

### Correct objection

Ordinary chosen-input access lets the attacker choose complete inputs \(x\)
and obtain \(f(x)\). It does not let the attacker request a transformation of
an unknown hidden input \(A\).

A hidden-anchor related-input oracle is a strictly stronger interface. Any
attack using it must be described as an attack in that stronger model.

---

## 164. Confusing a Block-State Relation with Recovery of the Semantic Message

### False move

Recover a relation between internal block inputs and claim that the
application-level plaintext, file, protocol message, or user secret has been
recovered.

### How the false conclusion appears

The encoding layer, mode of operation, padding, nonce, tweak, authentication
data, and protocol context are omitted.

### Correct objection

The MSR state may correspond to:

- a raw block-cipher input;
- a chaining value;
- a counter-derived block;
- an encoded or padded fragment;
- an internal protocol state.

A relation between such states does not automatically reveal meaningful
application plaintext. The mapping from the recovered state relation to the
claimed security consequence must be explicit.

---

## 165. Confusing \(n\), \(N=2^n\), and the Key Length \(\kappa\)

### False move

Treat the bit length \(n\), the state-space size \(N\), and the key length
\(\kappa\) as interchangeable.

### How the false conclusion appears

An exponential cost is made to look polynomial or small. Typical invalid
substitutions include:

\[
O(\sqrt N)
\rightsquigarrow
O(\sqrt n),
\]

or setting \(N=256\) for a 256-bit state instead of

\[
N=2^{256}.
\]

### Correct objection

These parameters describe different quantities:

\[
N=2^n,
\]

while \(\kappa\) describes the key space and need not equal \(n\).

Therefore,

\[
O(\sqrt N)
=
O(2^{n/2}),
\]

which is exponential in the security parameter \(n\), not polynomial in
\(n\).

Every complexity claim must identify the parameter with respect to which
efficiency is measured.

---

## 166. Calling Polynomial Time in \(N\) Efficient in the Security Parameter

### False move

Give an algorithm running in

\[
O(N^c)
\]

time and call it polynomial-time cryptanalysis.

### How the false conclusion appears

The algorithm is polynomial in the number of graph vertices but exponential
in the bit length of a vertex.

### Correct objection

Since

\[
N=2^n,
\]

we have

\[
N^c=2^{cn}.
\]

Cryptographic efficiency is normally measured as polynomial in \(n\) and
\(\kappa\), not polynomial in the exponentially large state count \(N\).

This error can falsely make full graph construction, matrix processing, or
linear traversal appear efficient.

---

## 167. Using a Ground-Truth Verifier or Stopping Rule Unavailable to the Attacker

### False move

During simulation, repeatedly test a candidate against the hidden
\(A,C,\Delta\) used to generate the instance and stop when the candidate is
correct.

### How the false conclusion appears

The experiment's evaluator becomes an oracle for correctness, eliminating
the real-world verification problem.

### Correct objection

Ground truth may be used after an experiment to score success. It must not be
used inside the attack algorithm, for candidate selection, parameter tuning,
restart decisions, or stopping.

The attack must use only information available under the declared
cryptographic interface.

---


# Part XVII — Final Composite False-Proof Pipelines

## Pipeline S — The XOR/Addition Substitution

1. Write the successor as \(x\oplus1\).
2. Implement bitwise XOR instead of modular addition.
3. Continue to claim one cycle of length \(2^n\).
4. Recover an XOR relation.
5. Report it as the modular MSR displacement.

The claimed result is generated by changing both the graph and the quantity
being recovered.

---

## Pipeline T — The Iterated-Cipher Trajectory

1. Observe that \(g_{f,\phi}\) is a full cycle.
2. Incorrectly infer that \(f\) is the same full cycle.
3. Iterate \(f(B),f^2(B),\ldots\).
4. Stop when a visible relation to \(D\) appears.
5. Call the iteration count \(\Delta\).

The procedure follows the cycles of \(f\), not the MSR cycle generated by
\(g_{f,\phi}\).

---

## Pipeline U — The Output-Only Classifier

1. Train or design a statistic using only visible pairs \((B,D)\).
2. Evaluate on biased, reused, selected, or metadata-leaking instances.
3. Observe above-baseline prediction.
4. Attribute the signal to ideal-permutation MSR geometry.
5. Claim generic displacement recovery.

For uniformly random ideal permutations and independent nonzero
displacements, the visible pair distribution is identical for every
displacement. Any real signal must enter through the changed experiment.

---

## Pipeline V — The Classical Discrete-Log Analogy

1. Call the target offset a discrete logarithm.
2. Invoke baby-step–giant-step, Pollard rho, Floyd, or Brent.
3. Assume unit-cost powers, inverses, collision equations, or random-access
   \(g_{f,\phi}\).
4. Ignore the construction cost of those operations.
5. Report a square-root classical attack.

The square-root bound belongs to a stronger computational representation, not
to the stated MSR forward-oracle model.

---

## Pipeline W — The Hidden-Promise Break

1. Restrict to small \(\Delta\), weak keys, affine regions, or precovered
   targets.
2. Run an attack that succeeds on that subset.
3. Omit the promise and its frequency.
4. Ignore the cost of recognizing promised instances.
5. Report a generic cryptographic break.

The apparent success is supplied by the hidden promise, not by MSR alone.

---

## Pipeline X — The Relative-Displacement-to-Key-Break Upgrade

1. Recover or guess \(\Delta\).
2. Assume \(\Delta\) directly reveals \(A,C\), or the secret key.
3. Skip the residual inversion or anchoring problem.
4. Call the result full decryption or key recovery.

The false break is created by upgrading a relative relation into an absolute
secret without a reduction.

---

## Pipeline Y — The Chosen-Plaintext Circular Demonstration

1. Choose \(A,C\).
2. Compute \(B=f(A)\) and \(D=f(C)\).
3. Use generation metadata, directly or indirectly, while tuning the method.
4. Recover the already-known \(\Delta\).
5. Report the experiment as hidden-plaintext cryptanalysis.

The challenge was never secret in the claimed sense.

---

## Pipeline Z — The Security-Parameter Collapse

1. Let \(N=2^n\).
2. Find an \(O(\sqrt N)\), \(O(N)\), or \(O(N^c)\) procedure.
3. Rewrite the cost as \(O(\sqrt n)\), \(O(n)\), or “polynomial.”
4. For a 256-bit state, treat \(N\) as 256.
5. Declare the exponential procedure efficient.

The speedup is produced entirely by changing the complexity parameter.

---

## Pipeline AA — The Hidden Ground-Truth Oracle

1. Generate the test instance with known \(A,C,\Delta\).
2. Try many candidate rules, parameters, or restarts.
3. Use the hidden values to choose the successful branch or stopping point.
4. Report only the selected run.
5. Present the procedure as deployable against an unknown challenge.

The experimental harness has supplied an oracle absent from the attack model.

---

# Part XVIII — Conditions That Would Constitute a Real Shortcut

A genuine MSR-related attack would need to establish at least one of the following, with a complete algorithm and complexity analysis.

## 168. Efficient Target Preimage Recovery

An algorithm computes

\[
f^{-1}(B)
\quad\text{or}\quad
f^{-1}(D)
\]

faster than generic inversion under the stated model.

---

## 169. Efficient Direct Displacement Recovery

An algorithm computes

\[
d_{f,\phi}(B,D)
\]

without recovering both preimages, with a proved advantage over generic search.

This would be a genuine result even if the algorithm did not explicitly output \(A\) or \(C\).

---

## 170. Efficient Visible Transition Evaluation

An algorithm computes

\[
g_{f,\phi}(y)
\]

for arbitrary externally specified \(y\), under a clearly stated model, at a cost that enables faster target-distance recovery.

The document must prove how this leads to \(\Delta\), not merely that one transition can be predicted.

---

## 171. Observable Coordinate Leakage

An efficiently computable function \(h\) reveals latent-coordinate information, for example:

\[
h(f(x))
=
\phi(x)\bmod m,
\]

or predicts such information with a quantified advantage.

The attack must show how enough leaked information is combined into exact or meaningfully partial recovery.

---

## 172. Exact Affine Conjugacy

If visible coordinates satisfy

\[
\phi(f(x\oplus1))
=
\phi(f(x))+c\pmod N
\]

with invertible \(c\), then

\[
\Delta
=
c^{-1}
\left(
\phi(D)-\phi(B)
\right)
\bmod N.
\]

This would be a real shortcut, but it would show that the concrete permutation leaks the latent arithmetic coordinate. It would not be a generic consequence of MSR.

---

## 173. A Provably Effective Algebraic Attack

A concrete algebraic representation yields an actual solver with demonstrated complexity below generic inversion.

Required evidence includes:

- system size;
- degree growth;
- solving degree;
- memory;
- runtime scaling;
- success probability;
- behavior across independent keys and targets.

---

## 174. A Key-Recovery Reduction

A public keyed family permits recovery of a key or an equivalent decryption capability faster than input-space inversion.

The analysis must include:

- key length;
- verification data;
- surviving-key ambiguity;
- displacement identifiability;
- family-evaluation cost;
- inversion after key recovery.

---

## 175. A Side-Channel or Related-Input Attack

Timing, power, faults, cache behavior, related-key access, chosen-ciphertext access, or internal-state leakage reveals the target coordinates.

This would be a valid attack on an implementation or expanded interface, but it must not be attributed to the forward-only MSR model.

---

# Part XIX — Minimal Recipe for a False MSR “Break”

A misleading proof that MSR breaks cryptography will usually contain several of the following steps:

1. Define the exact hidden distance

   \[
   d_{f,\phi}(B,D)=\Delta.
   \]

2. Replace “is defined” with “is efficiently computable.”

3. Treat sampled edges as random-access access to \(g_{f,\phi}\).

4. Apply birthday reasoning to a fixed-target problem.

5. Treat deterministic traversal as a stochastic random walk.

6. Invent a visible gradient, density, or sinkhole without proving a target-linked correlation.

7. Suppress inversion, preprocessing, or table-construction cost.

8. Equate low algebraic degree with polynomial-time solving.

9. Mix ideal-oracle query counts with local circuit evaluations.

10. Ignore success probability or condition on a rare favorable event.

11. Generalize from a toy function or weak key to an ideal permutation.

12. Treat a compressing or truncated function as though it had a unique inverse.

13. Choose the coordinate map, step operator, targets, or permutation after seeing the desired relation.

14. Assume sparsity, a known spectrum, or matrix notation makes the hidden transition matrix accessible.

15. Hide multi-target preprocessing, table construction, or function reuse behind a fast online phase.

16. Replace modular directed displacement with a convenient signed or undirected distance.

17. Upgrade a distinguisher, candidate list, or partial leakage result into exact recovery without reconstruction and verification costs.

18. Leave “break” undefined or switch among distinguishing, inversion, key recovery, and exact displacement games.

19. Swap quantifiers, tailor an algorithm to each fixed permutation, or hide nonuniform advice.

20. Treat a nonconstructive existence proof, an exact expectation, or an infinite-precision constant as an executable algorithm.

21. Apply mixing, hitting-time, spectral, Fourier, Shor, or quantum-walk machinery without the transition, group, precision, or readout oracle those methods require.

22. Move between ideal permutations, random functions, PRFs, PRPs, and concrete ciphers without a reduction.

23. Ignore the random variable over which success is measured, or transfer average-case success to every key and target.

24. Omit key, tweak, nonce, state, or context from the function being modeled.

25. Conflate modular addition with bitwise XOR, or modular displacement with XOR difference.

26. Infer that \(f\) is the MSR cycle and iterate the cipher instead of \(g_{f,\phi}\).

27. Apply Floyd, Brent, baby-step–giant-step, Pollard rho, or meet-in-the-middle without constructing the operations those algorithms require.

28. Hide a small-displacement, weak-key, selected-target, or other promise condition.

29. Treat the absence of a lower bound as evidence that a shortcut exists.

30. Equate recovery of a relative displacement with plaintext recovery, key recovery, or a standard encryption break without a reduction.

31. Use chosen plaintexts whose displacement is already known and present the result as secret recovery.

32. Supply related evaluations centered on an unknown target preimage as though ordinary chosen-input access provided them.

33. Confuse \(n\), \(N=2^n\), and \(\kappa\), or call polynomial time in \(N\) polynomial time in the security parameter.

34. Use hidden test-generation values to verify candidates, tune the algorithm, or decide when to stop.

35. Present the resulting symbolic identity as a cryptanalytic algorithm.

Any claimed MSR shortcut containing these moves should be rejected until each step is replaced with a precise theorem or experimentally reproducible attack.

---

# Part XX — Audit Checklist for Future Claims

Before accepting a claimed MSR cryptanalytic result, require explicit answers to all of the following.

## Mathematical object

- What are \(n,\mathcal{X},\phi,f,s_\phi,g_{f,\phi}\)?
- Are the domain and codomain equal in size?
- Does \(\oplus\) mean modular addition through \(\phi\) or bitwise XOR?
- Is the claimed output modular displacement, XOR difference, signed distance, or another quantity?
- Is \(f\) genuinely bijective, merely assumed “near-injective,” or compressing?
- If \(f\) is non-injective, which preimage relation is the claimed output about?
- Is \(\Delta\) modular, signed, directed, undirected, or promised to lie in a smaller set?
- Does the result depend on choosing \(\phi\), \(s_\phi\), \(f\), or the targets after seeing the data?

## Access model

- What exact security game is being claimed as broken?
- Is \(f\) an ideal oracle, random function, PRF, PRP, known algorithm, or keyed family?
- Is the key known?
- Is \(f^{-1}\) available?
- Is \(g_{f,\phi}\) available?
- Are quantum queries allowed?
- Is \(U_f^\dagger\) available?
- Is preprocessing correlated with \(f\) allowed?
- Are targets fixed before preprocessing or selected from the transcript?
- Is the same permutation reused across targets or users?
- Are key, tweak, nonce, randomness, and protocol state fixed or included in the state space?
- Are chosen-input, related-input, decryption, fault, or side-channel interfaces being used?
- Does any related-input query require transformations of an unknown hidden target preimage?
- Were \(A,C,\Delta\) chosen or known when the challenge pair was generated?

## Algorithm

- What exact inputs does the attacker receive?
- What does each query return?
- What is the stopping rule?
- Does the algorithm output exact \(\Delta\), partial information, or merely a distinguisher?
- What is the success probability, and over exactly which random variables?
- Are the theorem's quantifiers uniform, worst-case, average-case, or nonuniform?
- Is the output exact, modular only, signed, partial, or a candidate list?
- Can the claimed answer be efficiently verified under the same access model?
- Is the algorithm iterating \(g_{f,\phi}\) or merely iterating \(f\)?
- If \(g_{f,\phi}\) is computable, how is its orbit fast-forwarded to recover the index?
- If a cycle-finding or discrete-log method is invoked, where do powers, inverses, collision equations, and match tests come from?
- Does the attack rely on an unstated promise, and can promised instances be recognized?
- After recovering \(\Delta\), what exact algorithm recovers plaintext, a preimage, a key, or another standard security-game secret?
- Does \(\Delta\) have an independently known absolute anchor?
- Is hidden ground truth used only for final scoring, or also inside candidate selection and stopping?

## Complexity

- Target-oracle queries?
- Local computation?
- Memory?
- Preprocessing?
- Advice?
- Parallel depth?
- Quantum query, gate, depth, state-preparation, precision, amplification, and readout cost?
- Expected versus worst-case cost?
- Cost to verify the answer?
- Data complexity and number of targets?
- Cost of constructing or accessing any transition matrix, spectrum, learned model, or coordinate map?
- Bit complexity and representation size of symbolic or tabular objects?
- Is online complexity being reported separately from total and amortized complexity?
- Which parameter is asymptotic: \(n\), \(N=2^n\), \(\kappa\), number of targets, or something else?
- Is a polynomial in \(N\) being incorrectly called polynomial in the security parameter?

## Evidence

- Is there a constructive algorithm, a valid reduction, a nonconstructive existence proof, or only intuition?
- Are experiments held out?
- Are keys and targets independently generated?
- Are all attempted metrics reported?
- Is the asymptotic scaling supported?
- Is the claimed advantage above the correct prior-only baseline?
- Does the claim hold across independent keys or only weak selected instances?
- Are non-bijective ambiguity, wraparound, and directionality tested?
- Is a distinguisher or partial leak being incorrectly reported as exact recovery?
- Could the apparent signal come only from biased targets, weak keys, selected instances, or leaked metadata?
- Is an output-only predictor being claimed despite the ideal-model independence of \((B,D)\) from nonzero \(\Delta\)?
- Is lack of a lower bound being substituted for positive attack evidence?
- Does the reduction preserve the target distribution, oracle interface, resources, and success probability?
- Does any claimed quantum method actually receive coherent powers, a group operation, or fast-forwarding?
- Does any statistical compass have detectable advantage at the available sample size?
- Does the claimed output actually violate the named cryptographic security game?
- Is a chosen-plaintext demonstration merely recomputing a relation already known from the selected inputs?
- Would the attack still run if the test harness withheld \(A,C,\Delta\) until final scoring?

If any of these are omitted, the claimed break is incomplete.

---

# Part XXI — Final Conclusion

MSR provides a correct mathematical equivalence:

\[
\boxed{
d_{f,\phi}(B,D)
=
\Delta
}
\]

where the visible directed-cycle distance equals the latent modular displacement.

To turn that equivalence into the false claim that MSR generically breaks a secure cryptographic permutation, one must make at least one invalid move:

- confuse existence with efficient computability;
- grant an oracle not present in the model;
- assume visible proximity preserves latent proximity;
- misuse Markov-chain or birthday-paradox reasoning;
- suppress inversion, preprocessing, memory, verification, or success probability;
- assume algebraic representation implies efficient solution;
- transfer ideal-permutation bounds incorrectly to or from a structured keyed family;
- infer exact recovery from a distinguisher, bias, or toy experiment;
- treat a coordinate leak in a weak implementation as a generic consequence of MSR;
- import the permutation theorem into a truncated or many-to-one function;
- encode the answer into an adaptively chosen coordinate map or step operator;
- assume an exponentially large sparse matrix is explicitly accessible;
- hide preprocessing, multi-target data, or permutation reuse;
- confuse modular directed displacement with another notion of distance;
- promote partial information, a candidate list, or an unverifiable guess to exact recovery;
- confuse the additive group \(\mathbb{Z}_{2^n}\) with bitwise XOR space;
- mistake the cycles or iterates of \(f\) for the conjugated MSR transition;
- import cycle-finding or discrete-log algorithms without their required operations;
- conceal a promise subset or use absence of a lower bound as if it were an attack;
- equate relative displacement recovery with plaintext or key recovery without an anchoring reduction;
- present a chosen-plaintext relation already known to the experimenter as secret recovery;
- smuggle in related-input access around an unknown target preimage;
- confuse \(n\), \(N=2^n\), and \(\kappa\), or polynomial time in \(N\) with cryptographic efficiency;
- use ground-truth challenge data as a hidden verifier or stopping oracle.

A real cryptanalytic contribution must identify additional structure not present in the ideal-permutation forward-oracle model and prove that this structure enables a complete attack with fully stated resources and success probability.

Without such additional structure, MSR remains a rigorous graph-theoretic reframing of the hidden displacement—not a shortcut for breaking cryptography.

---


## Coverage Result

After the completeness audit, the catalogue covers the following materially
distinct sources of a false MSR break:

1. **Object substitution:** changing permutation, domain, codomain, inverse
   semantics, coordinate map, step operator, or distance definition.
2. **Information substitution:** supplying hidden preimages, stronger oracles,
   side channels, adaptive targets, correlated advice, or answer-bearing
   preprocessing.
3. **Computability errors:** confusing existence, representation, sparsity,
   spectrum, algebraic encoding, or one-step evaluation with an efficient
   full recovery algorithm.
4. **Probability errors:** invalid independence, birthday misuse, conditioning,
   wrong baselines, weak-key selection, and partial-to-exact upgrades.
5. **Resource errors:** omitting preprocessing, data, verification, memory,
   bit complexity, multi-target amortization, or circuit cost.
6. **Experimental errors:** target leakage, overfitting, toy-size
   extrapolation, post-selection, and unreported interface advantages.
7. **Claim-scope errors:** transferring results between ideal permutations,
   structured keyed families, compressing hashes, fixed instances, average
   cases, worst cases, and different quantum oracle models.
8. **Security-game and quantifier errors:** leaving “break” undefined,
   switching goals, reversing quantifiers, and using reductions that do not
   preserve the game.
9. **Analytic-resource errors:** treating exact expectations,
   infinite-precision constants, unavailable spectra, or nonconstructive
   objects as efficiently accessible.
10. **Quantum-model errors:** treating superposition as readable parallelism,
    using free postselection, or assuming group operations, fast-forwarding,
    and phase precision not present in the oracle model.
11. **Context-model errors:** omitting keys, tweaks, nonces, state, or
    randomness needed to define one fixed permutation.
12. **Algebra and operator-substitution errors:** interchanging modular
    addition, bitwise XOR, directed displacement, and unrelated iteration
    operators.
13. **Algorithm-analogy errors:** importing cycle detection, discrete
    logarithm, meet-in-the-middle, spectral, or quantum algorithms without
    the representations and operations on which their complexity bounds
    depend.
14. **Promise and epistemic errors:** hiding the restricted instance class on
    which an attack works or treating the absence of a lower bound as positive
    evidence for a shortcut.
15. **Security-consequence errors:** equating displacement recovery with
    plaintext recovery, key recovery, semantic compromise, or another
    security-game violation without a reduction and an absolute anchor.
16. **Parameterization errors:** confusing \(n\), \(N=2^n\), key length,
    state count, and the variable relative to which polynomial or exponential
    complexity is measured.
17. **Challenge-integrity errors:** using chosen-known relations, hidden-anchor
    related inputs, or ground-truth generation data as part of the attack
    rather than solely for final evaluation.

Within the declared MSR setting, the audits found no remaining materially
distinct route to a false generic cryptanalytic conclusion outside these
categories. This is category completeness, not a claim to list every
possible sentence-level mistake: new examples can always be invented, but
they will instantiate one or more of the categories above rather than create
a different logical mechanism.

---

## References

1. Ashwin Nayak, “Inverting a Permutation is as Hard as Unordered Search,” *Theory of Computing*, vol. 7, article 2, pp. 19–25, 2011. DOI: 10.4086/toc.2011.v007a002.

2. Jintai Ding and Dieter Schmidt, “Solving Degree and Degree of Regularity for Polynomial Systems over Finite Fields,” and related literature on multivariate polynomial solving. The relevant general lesson is that low polynomial degree does not by itself imply polynomial-time solvability.

3. The multivariate quadratic problem over finite fields is hard in general; exact algebraic-attack complexity depends on system structure, solving degree, field equations, sparsity, and available elimination strategies.

4. Blake Holman, Ronak Ramachandran, and Justin Yirka, “Quantum Search with In-Place Queries,” TQC 2025, LIPIcs vol. 350, article 1. DOI: 10.4230/LIPIcs.TQC.2025.1.
