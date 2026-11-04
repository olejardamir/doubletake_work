# Architecture Specification: Verified Modular Program Induction

## Strengthened Multi-Engine Research and Implementation Version

**Version objective:** increase practical solve rate, algorithm coverage, reuse, and verification robustness without weakening the document's limits on arbitrary or cryptographic black-box recovery.

## 1. Executive Summary

This document specifies a neural-guided symbolic system for discovering, completing, composing, and verifying structured discrete programs from input-output observations.

The system is not a universal learner of arbitrary hidden functions. Its intended target is a bounded hypothesis class consisting of compact, typed, modular algorithms assembled from an explicit operation library.

The central objective is:

> Given observations of a transformation and an explicitly bounded program space, recover an executable discrete program that is consistent with the observations, test its generalization, expose unresolved ambiguity, and formally verify it whenever a complete reference specification or bounded equivalence condition is available.

The strengthened architecture uses:

- exact typed primitives and verified reusable modules;
- a target-characterization stage that probes algebraic, dependency, state, and locality properties before synthesis;
- a portfolio of symbolic, enumerative, SAT, SMT, SyGuS-style, e-graph, superoptimization, and bounded stochastic search methods;
- machine learning to rank, prioritize, retrieve, decompose, and allocate resources across exact search procedures;
- bidirectional, meet-in-the-middle, and constraint-propagating search rather than only forward candidate generation;
- automatic factorization of large transformations into candidate intermediate representations and reusable subprograms;
- separate synthesis engines for different program classes, data types, state models, and memory models;
- adaptive DSL construction with controlled expansion when the initial hypothesis class is insufficient;
- active query generation only when an executable target oracle exists;
- coverage-guided, solver-generated, adversarial, and metamorphic test generation;
- exact candidate execution at every acceptance stage;
- independent proof replay and translation validation for accepted programs;
- explicit confidence and verification levels;
- benchmark-derived reliability rather than unsupported universal percentages.

SHA-256 is included in three carefully separated roles:

1. a frozen verified component inside a larger pipeline;
2. a sketch-completion benchmark in which most SHA structure is already specified;
3. a deliberately infeasible stress test for unconstrained rediscovery from message-digest pairs.

The system must not claim that it can reliably rediscover SHA-256 from ordinary input-output pairs alone.

---

## 2. What the System Is and Is Not

### 2.1 The system is

- a bounded program synthesizer;
- a circuit-discovery framework;
- a module-composition system;
- a neural-guided symbolic search system;
- a verifier of extracted discrete implementations;
- a framework for learning compact deterministic transformations when the operation vocabulary and complexity are constrained;
- a portfolio system that can characterize a target, choose a suitable synthesis representation, and combine several complementary exact and heuristic methods;
- a cross-task learning system that retrieves prior solutions and promotes verified repeated structures into reusable abstractions.

### 2.2 The system is not

- a universal learner of arbitrary programs;
- a method for inferring any function from finite observations;
- a general cryptanalytic shortcut;
- a reliable way to rediscover cryptographic hashes from sparse examples;
- a substitute for a specification when formal equivalence is required;
- a guarantee that a soft differentiable graph will discretize into a correct program.

---

## 3. Supported Problem Modes

Every synthesis run must declare one of the following modes.

### Mode A: Verification

A complete candidate implementation and a complete specification are supplied.

```text
candidate program + reference specification -> equivalence result
```

Purpose:

- prove or disprove equivalence;
- generate a counterexample when they differ;
- validate a known SHA-256 implementation or another exact module.

Expected reliability:

- logically conclusive when the solver or theorem prover completes under the stated model;
- operational reliability still depends on correct modelling, tool implementation, serialization, and environmental assumptions.

### Mode B: Sketch completion

Most program structure is supplied, but selected values or fragments are unknown.

```text
program skeleton + holes + examples/specification -> completed program
```

Possible holes include:

- constants;
- rotations;
- operator choices;
- local connections;
- masks;
- small expressions;
- selected round functions.

This is the strongest realistic SHA-related synthesis mode.

### Mode C: Bounded discovery

Only examples are supplied, but the DSL, types, widths, maximum nodes, maximum depth, and permitted state are tightly bounded.

```text
examples + bounded DSL + resource limits -> candidate program(s)
```

This mode is appropriate for:

- small bit-vector transformations;
- CRC and checksum variants;
- encodings and decodings;
- arithmetic circuits;
- small finite-state systems;
- undocumented compact binary routines.

### Mode D: Known-plus-unknown pipeline

One or more exact modules are known and frozen, while a bounded unknown stage is synthesized.

```text
A -> known G -> unknown F -> Y
```

The external dataset may still contain only:

```text
A -> Y
```

The system calculates the hidden intermediate value internally.

### Mode E: Unconstrained black-box inference

Only examples are supplied and the hidden program structure is not meaningfully bounded.

This mode may produce empirical predictors or multiple hypotheses, but it must not make exact recovery claims. For SHA-256-like outputs, this mode is considered infeasible.

---

## 4. SHA-256 feasibility and evidence boundary

No measured success probabilities are available for this proposed architecture. Prior numerical recovery percentages were unsupported planning guesses and are deliberately retired, not empirical benchmarks. Verification of a supplied SHA-256 implementation is conclusive only if a correct formal model is used and the proof completes. A frozen, independently verified SHA-256 module can be composed with a bounded unknown transformation; tightly constrained sketch completion may be testable. Recovering the full SHA-256 algorithm from ordinary message–digest pairs without a strong structural sketch is not a credible practical objective: padding, word schedule, 64 rounds, constants, rotations, chaining and nonlinear operations make the unconstrained search enormous. Unknown cryptographic post-processing likewise cannot be assumed learnable. Report task-specific measured outcomes with budgets, seeds, independent controls and failure cases instead of assigning probabilities.

---

## 5. Formal Problem Definition

The external observation interface is:

```text
Input A -> observed output Y
```

The target may be:

\[
Y = F(A)
\]

or:

\[
Y = F(G(A))
\]

where:

- \(G\) may be known, partially specified, or previously verified;
- \(F\) is bounded by an explicit DSL and complexity limit;
- the externally supplied data may contain only \((A,Y)\) pairs.

A synthesis task is fully defined by:

```text
Task = (
    input_schema,
    output_schema,
    examples,
    target_mode,
    target_access,
    oracle,
    operation_library,
    dsl_expansion_policy,
    known_modules,
    maximum_program_size,
    maximum_depth,
    branch_bound,
    state_bound,
    memory_bound,
    loop_or_round_bound,
    table_bound,
    noise_model,
    probe_budget,
    query_budget,
    solver_portfolio,
    search_profile,
    verification_specification
)
```

No run is valid unless these limits are recorded.

---

## 6. Fundamental Identifiability Limitation

Finite examples cannot uniquely determine an unrestricted unknown function.

If two programs agree on every supplied example but disagree elsewhere, the examples alone do not identify which program is intended.

Exactness requires at least one of the following:

- exhaustive coverage of a finite domain;
- a complete formal specification;
- an executable target oracle that can answer new queries;
- a bounded DSL and program-size limit;
- a structural sketch;
- a proof that every surviving candidate is equivalent over the complete stated domain;
- a proof that only one candidate remains within the declared hypothesis class.

The correct default claim is:

> The recovered program is consistent with the observations and exact only within the declared domain, DSL, structural assumptions, and verification model.

---

## 7. Corrected Architecture

```text
Task declaration and bounds
        |
        v
Typed input normalization
        |
        v
Optional frozen verified modules
        |
        v
Select synthesis engine by program class
        |
        +--> combinational expression engine
        +--> straight-line bit-vector engine
        +--> fixed-round engine
        +--> finite-state-machine engine
        +--> bounded-loop engine
        |
        v
Symbolic candidate generation
        ^
        |
Neural ranking, decomposition, and module proposals
        |
        v
Exact candidate execution
        |
        v
Candidate elimination and simplification
        |
        v
Optional oracle-guided counterexample generation
        |
        v
SAT/SMT/exhaustive/formal verification
        |
        v
Explicit program + assumptions + ambiguity report
```

### Central correction

The symbolic system owns program semantics and candidate construction.

The neural system does not define the final program. It only assists by:

- ranking grammar expansions;
- ranking component connections;
- proposing constants;
- predicting likely module boundaries;
- recognizing repeated structures;
- choosing which synthesis engine or abstraction level to try first;
- prioritizing candidate programs for exact evaluation.

---

## 8. Why the Symbolic Core Must Be Primary

A differentiable supernetwork may contain soft mixtures of operators and connections that perform well during training but do not correspond to any equally successful discrete program.

Therefore:

1. soft execution may be used only for proposal generation;
2. every accepted candidate must be a discrete syntax tree, graph, circuit, or program;
3. every accepted candidate must be executed with exact integer and bit-vector semantics;
4. no result may be accepted from relaxed accuracy alone;
5. discretization failure must be recorded as a normal failure mode, not treated as an anomaly.

The main search loop should manipulate discrete candidates from the beginning whenever feasible.

---

## 9. Synthesis Engines

A single universal supernetwork should not attempt to learn every program class simultaneously.

### 9.1 Combinational expression engine

Targets:

- Boolean functions;
- bit permutations;
- masks;
- comparisons;
- small arithmetic expressions.

Methods:

- bottom-up enumeration;
- e-graphs and equivalence classes;
- SAT or SMT synthesis;
- neural ranking of expressions.

### 9.2 Straight-line bit-vector engine

Targets:

- fixed sequences of typed operations;
- packed-format transformations;
- checksums;
- small encoders and decoders.

Methods:

- component-based synthesis;
- bounded dataflow synthesis;
- exact constant solving;
- symmetry breaking;
- dead-node elimination.

### 9.3 Fixed-round engine

Targets:

- repeated arithmetic or Boolean rounds;
- Feistel-like educational constructions;
- fixed recurrence patterns;
- structured hash or checksum components.

The round count or repetition skeleton should initially be supplied.

### 9.4 Finite-state-machine engine

Targets:

- protocol state transitions;
- sequence detectors;
- bounded controllers;
- counters and conditional updates.

State count must be bounded explicitly.

### 9.5 Bounded-loop engine

Targets:

- loops with fixed maximum iterations;
- bounded array scans;
- compact recurrences.

Loops should initially be unrolled or described through a supplied loop skeleton. General unrestricted loop discovery is outside the first implementation.

### 9.6 Conditional and decision-tree engine

Targets:

- bounded if/else programs;
- piecewise integer and bit-vector transformations;
- protocol decisions;
- parsers with a bounded number of branches.

Methods:

- path-condition synthesis;
- decision-tree induction followed by exact symbolic simplification;
- branch predicate solving;
- path merging and unreachable-branch elimination.

### 9.7 Bounded-array and memory engine

Targets:

- byte and word arrays with fixed maximum length;
- table-driven transformations;
- packet and record processing;
- bounded scans, maps, folds, and indexed updates.

Required bounds:

- maximum array length;
- maximum reads and writes;
- legal index range;
- aliasing policy;
- initialization and out-of-range semantics.

### 9.8 Grammar and parser engine

Targets:

- fixed or bounded binary formats;
- field extraction and validation;
- small deterministic protocol grammars;
- encoders and decoders with bounded nesting.

The engine should synthesize typed parser combinators or a bounded state machine rather than unrestricted source code.

---

## 10. Algorithm Characterization and Fingerprinting

Before launching a broad synthesis search, the system should actively characterize the observed transformation.

The characterization stage does not prove the target's structure. It produces evidence that narrows the initial DSL, engine, and search strategy.

### 10.1 Dependency and influence analysis

Estimate which input bits, bytes, fields, or prior states influence each output component using:

- single-bit and multi-bit perturbations;
- influence matrices;
- dependency clustering;
- locality and receptive-field estimates;
- boundary and length perturbations;
- temporal influence tests for stateful targets.

### 10.2 Algebraic probes

Test candidate properties such as:

- linearity or affinity over GF(2);
- modular linearity over bounded integers;
- permutation behaviour;
- idempotence;
- commutativity and associativity where meaningful;
- monotonicity;
- periodicity;
- conservation, parity, and checksum relations;
- approximate algebraic degree;
- differential and rotational regularities.

### 10.3 Structural classification

Use the probe results to rank target classes such as:

- Boolean or affine circuit;
- arithmetic expression;
- permutation or routing network;
- checksum or CRC family;
- table-driven transformation;
- encoder or decoder;
- fixed-round recurrence;
- finite-state system;
- bounded parser;
- irregular or likely pseudorandom transformation.

### 10.4 Probe-aware caution

A fingerprint is a heuristic and may be misleading on small datasets. It may prioritize search, but it must not silently exclude all other program classes in the complete profile.

---

## 11. Portfolio Synthesis Orchestrator

No single synthesis method dominates across all bounded algorithm families.

The strengthened system should run a coordinated portfolio containing methods such as:

- bottom-up enumerative synthesis;
- top-down grammar-guided synthesis;
- component-based SAT or SMT synthesis;
- SyGuS-style constraint solving;
- e-graph equality saturation;
- superoptimization and peephole search;
- bounded stochastic local search;
- beam search or Monte Carlo tree search over program structures;
- finite-state-machine inference;
- bounded symbolic execution;
- sketch completion;
- library retrieval and adaptation.

### 11.1 Adaptive resource allocation

A portfolio controller should allocate compute based on:

- target fingerprints;
- progress in candidate elimination;
- solver conflict statistics;
- novelty of produced semantic signatures;
- time since last improvement;
- historical performance on similar tasks.

A contextual-bandit or learned scheduler may be used, but a deterministic fallback policy must remain available.

### 11.2 Cross-engine communication

Engines should exchange:

- discovered constants;
- partial expressions;
- unsatisfiable cores;
- counterexamples;
- semantic equivalence classes;
- inferred module boundaries;
- candidate intermediate representations.

This prevents each engine from restarting the same reasoning independently.

### 11.3 Complete and heuristic guarantees

In complete mode, portfolio scheduling changes order and resource allocation but must preserve completeness within the declared bounds.

In heuristic mode, aggressive pruning is allowed, but every report must state that failure is inconclusive.

---

## 12. Bidirectional, Meet-in-the-Middle, and Constraint-Propagating Search

Purely forward construction becomes inefficient as program depth grows.

The system should combine several search directions.

### 12.1 Forward semantics

Construct candidate values from inputs and constants using permitted operations.

### 12.2 Backward constraints

Propagate required output conditions backward through inverse or relational operator semantics.

Examples:

- required XOR outputs constrain operand relationships;
- slices constrain only selected source bits;
- modular addition constrains operand sums;
- comparisons constrain numeric ranges;
- multiplexers constrain predicates and branches.

### 12.3 Meet-in-the-middle synthesis

For a bounded composition:

```text
A -> P -> intermediate Z -> Q -> Y
```

search for prefix programs `P` and suffix programs `Q`, then match compatible intermediate semantic signatures.

This can reduce an exponential depth search from approximately one large search into two smaller searches, subject to memory and signature costs.

### 12.4 Constraint propagation

Use:

- interval and bit-mask propagation;
- known-zero and known-one analysis;
- congruence reasoning;
- abstract interpretation;
- type and width propagation;
- path-condition pruning;
- unsatisfiable-core extraction.

Candidates that cannot satisfy an observation should be rejected before complete execution.

---

## 13. Automatic Decomposition and Intermediate Representation Discovery

Large algorithms should be attacked through factorization rather than flat synthesis.

The system should search for decompositions such as:

\[
Y = H(G(A))
\]

or:

\[
Y = C(G_1(A), G_2(A), \ldots, G_k(A))
\]

where the intermediate functions are themselves bounded programs.

### 13.1 Candidate decomposition signals

Use:

- output dependency clusters;
- repeated semantic signatures;
- common subexpressions across examples;
- word and byte boundaries;
- repeated-round evidence;
- separable output fields;
- conditional independence under probes;
- known protocol or format boundaries.

### 13.2 Latent intermediate search

When no intermediate labels are supplied, propose candidate latent representations and accept them only when they:

- reduce total description length;
- improve exact search efficiency;
- recur across multiple outputs, rounds, or tasks;
- admit exact deterministic semantics;
- survive independent verification.

### 13.3 Recursive synthesis

Once a decomposition is accepted provisionally:

1. synthesize smaller components;
2. verify each component locally where possible;
3. compose them exactly;
4. test the complete program;
5. reject the decomposition if global counterexamples remain.

### 13.4 Retrieval from prior solutions

Maintain an indexed repository of verified programs and subprograms keyed by:

- type signature;
- semantic fingerprints;
- dependency pattern;
- constants and widths;
- normalized graph structure;
- benchmark family.

A new target may reuse, specialize, or compose prior verified modules rather than rediscovering them.

---

## 14. Semantic Pruning, Version Spaces, and Learned Equivalences

Search strength depends heavily on eliminating redundant candidates.

### 14.1 Semantic signatures

Evaluate partial and complete candidates on carefully selected probe inputs and hash their output vectors.

Candidates with identical signatures may share an equivalence bucket until a solver or new counterexample separates them.

### 14.2 Version-space representation

Represent sets of consistent programs compactly using:

- version-space algebras;
- shared packed parse forests;
- e-graphs;
- binary decision diagrams for suitable Boolean fragments;
- solver constraints over program holes.

The system should reason about candidate sets rather than materializing every program independently.

### 14.3 Equivalence-aware rewriting

Use verified rewrite rules for:

- Boolean algebra;
- modular arithmetic;
- shifts and masks;
- concatenation and slicing;
- constant propagation;
- dead-code and redundant-branch elimination.

Learned rewrite proposals are permitted only after exact validation. Validated rewrites may be promoted into a versioned rule library.

### 14.4 Symmetry breaking

Add constraints that remove semantically redundant orderings, including:

- canonical operand order for commutative operations;
- canonical naming of equivalent temporaries;
- fixed ordering of identical modules;
- minimal constant encodings;
- canonical branch ordering.

---

## 15. Test Generation, Invariant Discovery, and Oracle Efficiency

Examples should be selected to distinguish candidate programs and expose structural errors.

### 15.1 Test-generation portfolio

Use:

- SAT/SMT-generated distinguishing inputs;
- concolic execution;
- coverage-guided fuzzing;
- mutation-based adversarial tests;
- boundary-value generation;
- pairwise and combinatorial field coverage;
- state-transition coverage;
- length, alignment, padding, and overflow boundaries;
- differential tests against independent implementations.

### 15.2 Metamorphic relations

When direct expected outputs are expensive or unavailable, test validated relations such as:

- permutation consistency;
- round-trip encode/decode behaviour;
- conservation or parity properties;
- invariance under irrelevant input changes;
- known composition identities;
- state reset and replay properties.

Metamorphic relations must be independently justified. They cannot replace an oracle unless they fully characterize the target within the declared model.

### 15.3 Invariant discovery

The system may propose candidate invariants from examples and solver traces, but an invariant becomes a hard constraint only after it is:

- proven from a specification;
- confirmed exhaustively over the bounded domain; or
- explicitly supplied as a trusted assumption.

### 15.4 Query selection objective

For queryable black boxes, choose inputs that maximize a combination of:

- expected candidate elimination;
- semantic coverage;
- uncertainty reduction;
- unexplored path or state coverage;
- boundary relevance;
- cost of obtaining the target output.

Batch query selection should avoid redundant probes.

---

## 16. Typed Operation Library

The operation library defines the hypothesis class.

Every operation must specify:

- input types;
- output type;
- bit width;
- signedness;
- overflow semantics;
- exact deterministic execution;
- symbolic encoding;
- cost in the description-length objective.

### 16.1 Boolean operations

- AND;
- OR;
- XOR;
- XNOR;
- NOT;
- NAND;
- NOR;
- multiplexer;
- majority;
- equality and inequality.

### 16.2 Bit-vector operations

- logical and arithmetic shifts;
- rotation;
- concatenation;
- slicing;
- permutation;
- zero extension;
- sign extension;
- truncation.

### 16.3 Arithmetic operations

- increment and decrement;
- modular addition and subtraction;
- bounded multiplication;
- comparison;
- min and max;
- carry and borrow operations;
- fixed-point scaling where explicitly enabled.

### 16.4 Control-flow operations

- typed conditional expression;
- bounded branch;
- pattern predicate;
- bounded early termination;
- fixed-count iteration combinator.

### 16.5 Stateful operations

- register assignment;
- delay;
- conditional update;
- bounded counter;
- finite-state transition.

### 16.6 Bounded data and memory operations

- byte and word arrays with fixed maximum length;
- records and tuples;
- typed field access;
- bounded table lookup;
- bounded indexed load and store;
- map, fold, scan, and zip over fixed bounds;
- explicit out-of-range behaviour.

### 16.7 Verified reusable modules

- typed adders;
- comparators;
- CRCs;
- checksums;
- encoders and decoders;
- parsers;
- fixed state-machine components;
- SHA-256;
- user-supplied verified components.

Large modules must be enabled intentionally. They must not silently make a discovery benchmark trivial.

---

## 17. Exact Semantics and Learned Primitives

Deterministic primitives should be preferred.

Tiny learned primitives may be used experimentally only when:

1. the complete truth table is finite and enumerated;
2. every truth-table entry is correct after discretization;
3. a numerical margin is required;
4. the accepted model is frozen and checksummed;
5. an equivalent exact Boolean or integer implementation is exported when possible.

No unsnapped floating-point value may enter exact inference.

For a logit \(z\):

\[
bit(z) =
\begin{cases}
1, & z \ge 0 \\
0, & z < 0
\end{cases}
\]

Acceptance also requires a configurable margin around zero.

---

## 18. Neural Guidance

The neural component is trained across families of synthesis tasks, not merely optimized independently for one target whenever possible. It should combine graph, sequence, and set representations so it can reason about typed programs, examples, and solver state.

It may predict:

- likely root operators;
- likely input dependencies;
- useful constants and masks;
- likely widths;
- reusable subexpressions;
- probable repeated modules;
- likely decomposition boundaries and intermediate types;
- retrieval keys for previously verified modules;
- search-engine selection and compute allocation;
- promising distinguishing inputs;
- useful exact rewrite proposals;
- likely causes of solver failure or DSL mismatch.

Neural scores are heuristics. They must never remove all lower-ranked candidates unless the resulting incompleteness is explicitly declared.

Training may use:

- supervised traces from solved synthesis tasks;
- imitation of strong solver decisions;
- reinforcement learning on verified solve outcomes;
- contrastive learning over equivalent and non-equivalent programs;
- curriculum generation from small to larger programs;
- hard-negative mining from near-correct candidates;
- self-play between candidate generation and counterexample generation.

The reward must prioritize verified semantic success, not token-level similarity to one source implementation.

Two search profiles should exist:

### Complete profile

- neural guidance changes ordering only;
- the bounded search remains complete;
- failure means no solution exists within the declared bound, assuming correct encoding and solver completion.

### Heuristic profile

- low-ranked branches may be pruned;
- faster but incomplete;
- failure does not imply absence of a solution.

---

## 19. Hierarchical Module Discovery

Reusable module discovery should occur across solved tasks and within repeated subgraphs.

### Stage 1: solve tasks using the current DSL

Generate exact candidate programs.

### Stage 2: detect repeated subgraphs

Identify repeated typed structures across candidates.

### Stage 3: validate abstraction usefulness

A proposed module must:

- reduce total description length;
- recur across multiple tasks or multiple independent locations;
- have exact semantics;
- improve subsequent search under controlled evaluation.

### Stage 4: promote the module

Add it to a versioned library with:

- a canonical definition;
- type signature;
- verification record;
- cost;
- provenance;
- checksum.

This is safer and more measurable than expecting one supernetwork to invent all abstraction levels during one optimization run.

The library must support abstraction retirement and versioning. A promoted module that later harms search, duplicates a simpler module, or embeds accidental benchmark-specific structure should be deprecated without invalidating earlier proof artifacts.

---

## 20. End-to-End Training with Hidden Known Modules

The dataset may contain only:

```text
A -> Y
```

If a known exact module \(G\) is enabled:

```python
B = frozen_verified_G(A)
Y_hat = candidate_F(B)
error = exact_compare(Y_hat, Y)
```

The intermediate value \(B\) does not need to be externally labeled.

This supports:

\[
Y = F(SHA256(A))
\]

provided that \(F\) belongs to the declared bounded program class.

Important limitation:

If SHA-256 behaves as intended, the values \(B\) appear widely dispersed. Therefore the learner receives useful evidence about \(F\), but almost no useful evidence for rediscovering the internal structure of SHA-256 itself.

---

## 21. Candidate Search Objective

Candidates are ordered lexicographically or by a configurable weighted objective.

Recommended priority:

1. exact agreement with all required examples;
2. satisfaction of hard invariants;
3. minimum program size;
4. minimum depth;
5. maximum module reuse;
6. minimum number of distinct constants;
7. empirical held-out performance when exact consistency is impossible because of noise.

A suggested objective is:

```text
score =
    output_error
  + lambda_size * node_count
  + lambda_depth * depth
  + lambda_constants * constant_cost
  + lambda_state * state_cost
  - lambda_reuse * verified_module_reuse
```

Hard correctness constraints should not be replaced by soft penalties when exact examples are available.

---

## 22. Candidate Equivalence and Deduplication

The search must avoid repeatedly evaluating syntactically different but semantically equivalent programs.

Use:

- canonical operand ordering for commutative operators;
- constant folding;
- algebraic simplification;
- e-graph saturation where practical;
- test-vector signatures;
- solver-based equivalence checks for promising candidates;
- dead-code elimination;
- common-subexpression elimination.

Deduplication is a core scaling mechanism, not an optional cleanup stage.

---

## 23. Oracle and Counterexample Modes

The system must declare one of three observation capabilities.

```python
target_access = (
    "static_dataset"
    | "queryable_black_box"
    | "formal_specification"
)
```

### 23.1 Static dataset

The system may:

- fit candidates;
- compare candidates on supplied data;
- generate hypothetical distinguishing inputs;
- report ambiguity.

It may not obtain the correct outputs for new inputs.

### 23.2 Queryable black box

The system may generate an input \(A^*\), query the target, receive \(Y^*\), and eliminate inconsistent candidates.

### 23.3 Formal specification

The verifier may search symbolically for an input on which the candidate differs from the specification.

If no such input exists under the complete stated model, equivalence is proven.

Counterexample-guided refinement is genuine only in the second and third modes.

---

## 24. Verification Levels

### Level 0: training consistency

The candidate matches the supplied training examples.

### Level 1: empirical generalization

The candidate also passes independently generated held-out, boundary, and randomized tests.

### Level 2: structural recovery

The candidate is compact, typed, modular, and stable across repeated synthesis runs.

### Level 3: bounded candidate uniqueness or equivalence

Within the declared DSL and complexity bound:

- only one semantic candidate remains; or
- every surviving candidate is equivalent over the stated domain.

### Level 4: formal equivalence

The candidate is proven equivalent to an independent reference specification over the complete stated domain.

A report must never describe Level 0 or Level 1 as proof of exact recovery.

### Independent acceptance pipeline

A Level 3 or Level 4 result should pass an implementation-independent acceptance path:

1. serialize the extracted program into a canonical intermediate representation;
2. execute it in a second exact interpreter;
3. replay the proof or solver certificate where supported;
4. compare against an independent specification or implementation;
5. run generated boundary and adversarial tests;
6. checksum the canonical program, assumptions, and proof artifacts together.

This reduces the risk that the synthesizer and verifier share the same defect.

---

## 25. SHA-256 Benchmark Ladder

SHA-256 should be evaluated through a progression of increasingly difficult tasks.

### SHA-0: verify a supplied implementation

Goal:

- confirm bit order, padding, constants, rounds, and chaining against an independent model.

Expected result:

- formal equivalence or a counterexample.

### SHA-1: recover one local Boolean function

Supply:

- complete surrounding structure;
- candidate operations such as XOR, AND, NOT, majority, and multiplexer.

Unknown:

- one local function.

### SHA-2: recover selected rotations or constants

Supply:

- complete round structure.

Unknown:

- a small bounded set of rotation amounts or constants.

### SHA-3: recover a round fragment

Supply:

- typed 32-bit word structure;
- known inputs and outputs of the fragment;
- bounded node count.

Unknown:

- a small straight-line expression.

### SHA-4: complete a round skeleton

Supply:

- 64-round structure;
- register routing;
- message schedule form;
- most constants and operators.

Unknown:

- selected holes.

### SHA-5: unknown postprocessing after frozen SHA-256

```text
A -> frozen SHA256 -> bounded unknown F -> Y
```

This tests hidden intermediate computation and end-to-end supervision.

### SHA-6: full rediscovery from message-digest pairs

This benchmark should be included as a negative control.

Expected outcome:

- failure or unresolved ambiguity;
- no claim that more ordinary training data will make the task practical.

### Cross-family benchmark ladder

The system should also maintain benchmark ladders for:

- Boolean and affine circuits;
- bit permutations and routing networks;
- modular arithmetic kernels;
- CRC and checksum families;
- encoders, decoders, and packed formats;
- bounded parsers;
- table-driven transformations;
- fixed-point numeric kernels;
- finite-state controllers;
- bounded array scans;
- known-plus-unknown pipelines;
- intentionally irregular negative controls.

Each ladder should range from local-hole completion to bounded discovery and should include out-of-DSL targets to measure model-mismatch detection.

---

## 26. Reliability Measurement Protocol

Reliability must be measured per benchmark family, not assigned as one architecture-wide percentage.

For each benchmark configuration:

1. generate at least 100 independent target programs where computationally feasible;
2. use multiple random seeds;
3. define a fixed compute and query budget;
4. separate training, validation, held-out, and adversarial inputs;
5. record whether the exact target was recovered;
6. record whether a semantically equivalent target was recovered;
7. record time, solver calls, memory, and query count;
8. verify every reported success independently;
9. report median and worst-case performance;
10. report confidence intervals for the measured success rate;
11. perform ablations for neural ranking, fingerprinting, decomposition, retrieval, active queries, and each solver engine;
12. measure calibration: when the system assigns a confidence level, that level must correspond to observed recovery frequency;
13. evaluate out-of-distribution targets and deliberately missing DSL operations;
14. replay a sample of successful proof artifacts with an independent toolchain.

Primary metrics:

- exact semantic recovery rate;
- verified equivalence rate;
- time-to-first-correct-candidate;
- solver completion rate;
- ambiguity rate;
- false-acceptance rate;
- candidate size relative to target size;
- query efficiency.

Bit accuracy alone is not an acceptable primary metric for exact discrete programs.

---

## 27. Initial Practical Scope

The first working release should support only:

### Inputs and outputs

- fixed-width bit vectors;
- initially 1 to 32 bits per value;
- fixed arity;
- no unbounded arrays or strings.

### DSL

- constants;
- variables;
- AND, OR, XOR, NOT;
- equality and multiplexer;
- shifts and rotations;
- slicing and concatenation;
- modular ADD and SUB.

### Programs

- acyclic straight-line graphs;
- explicit maximum nodes;
- explicit maximum depth;
- no state;
- no loops;
- no implicit width conversion.

### Search

- enumerative and SMT/component-based baseline;
- exact semantic deduplication where feasible;
- optional neural ranking;
- complete and heuristic profiles.

### Verification

- exhaustive enumeration for small total input width;
- SMT equivalence for larger fixed-width domains;
- differential tests against independent implementations.

This restricted version is sufficiently narrow to be implemented, benchmarked, and falsified.

---

## 28. Expansion Phases

### Phase 1: exact baseline without ML

Build:

- typed AST and graph representation;
- exact executor;
- operation library;
- enumerative search;
- SMT and SyGuS-style encodings;
- simplifier, e-graph, and deduplicator;
- verification reports.

Purpose:

- establish what can be solved before introducing learning.

### Phase 2: characterization and solver portfolio

Add:

- influence and algebraic probes;
- target-family classification;
- multiple coordinated synthesis engines;
- adaptive deterministic resource scheduling;
- cross-engine sharing of constants, counterexamples, and semantic signatures.

### Phase 3: neural search ranking and retrieval

Train models to:

- rank expansions;
- retrieve prior verified modules;
- predict decomposition points;
- allocate portfolio resources.

Measure:

- speedup over the exact baseline;
- change in solve rate;
- calibration;
- any loss of completeness in heuristic mode.

### Phase 4: bidirectional and meet-in-the-middle synthesis

Add:

- backward relational semantics;
- prefix/suffix matching;
- abstract interpretation;
- unsatisfiable-core-guided pruning.

### Phase 5: active query and adversarial test generation

Add query generation only for queryable targets and specifications.

Measure:

- reduction in examples needed;
- candidate-elimination efficiency;
- path and state coverage;
- counterexample quality.

### Phase 6: reusable module and rewrite learning

Mine repeated verified subgraphs and exact equivalences, then promote useful abstractions and rewrite rules into versioned libraries.

### Phase 7: conditionals, bytes, arrays, and bounded memory

Add:

- typed branches;
- fixed-size arrays and records;
- bounded table lookup;
- bounded load/store;
- parser and format combinators.

### Phase 8: fixed-round programs

Add supplied repetition skeletons, recursive round-body synthesis, and round-level decomposition.

### Phase 9: finite-state systems

Add bounded state, transition synthesis, state minimization, and transition-coverage testing.

### Phase 10: bounded loops and recurrences

Add restricted loop templates, bounded unrolling, invariant-assisted search, and fixed-bound folds and scans.

### Phase 11: noisy and approximate observations

Add a separate mode for inconsistent or approximate observations. Exact and noisy modes must not share acceptance criteria.

### Phase 12: advanced formal verification

Add:

- proof artifacts;
- independent solver replay;
- theorem-prover integration;
- translation validation;
- proof-carrying exported programs.

## 29. Reference Synthesis Flow

```python
def synthesize_verified_program(task):
    validate_task_bounds(task)
    examples = normalize_examples(task.examples, task.input_schema, task.output_schema)

    fingerprint = characterize_target(
        examples=examples,
        oracle=task.oracle,
        probe_budget=task.probe_budget,
    )

    dsl = configure_or_expand_dsl(
        base_library=task.operation_library,
        fingerprint=fingerprint,
        expansion_policy=task.dsl_expansion_policy,
    )

    retrieved_modules = retrieve_verified_modules(
        fingerprint=fingerprint,
        input_schema=task.input_schema,
        output_schema=task.output_schema,
    )

    portfolio = initialize_solver_portfolio(
        program_class_hypotheses=fingerprint.ranked_program_classes,
        operation_library=dsl,
        known_modules=task.known_modules + retrieved_modules,
        bounds=task.declared_bounds,
        neural_ranker=task.optional_neural_ranker,
        search_profile=task.search_profile,
    )

    survivors = []

    while portfolio.within_budget():
        candidate = portfolio.next_discrete_candidate()
        candidate = canonicalize_and_simplify(candidate)

        if not exact_match(candidate, examples, task.known_modules):
            portfolio.reject(candidate)
            continue

        survivors.append(candidate)

        if task.target_access == "queryable_black_box":
            distinguishing_input = choose_distinguishing_input(survivors)
            if distinguishing_input is not None:
                observed_output = task.oracle(distinguishing_input)
                examples.add(distinguishing_input, observed_output)
                survivors = retain_exact_matches(survivors, examples)

        if task.target_access == "formal_specification":
            result = verify_against_specification(candidate, task.specification)
            if result.proved_equivalent:
                return build_success_report(candidate, result, examples, task)
            if result.counterexample is not None:
                examples.add(result.counterexample.input, result.counterexample.output)
                survivors = retain_exact_matches(survivors, examples)

    mismatch = diagnose_model_mismatch(
        portfolio=portfolio,
        examples=examples,
        fingerprint=fingerprint,
    )

    return build_bounded_report(
        candidates=survivors,
        examples=examples,
        assumptions=task.declared_bounds,
        ambiguity=analyze_candidate_ambiguity(survivors),
        model_mismatch=mismatch,
        portfolio_statistics=portfolio.statistics(),
    )
```

---

## 30. Output Artifacts

Every run should produce:

- explicit source code or circuit representation;
- typed operation graph;
- DSL and all bounds;
- known modules used;
- discovered constants;
- reusable submodules;
- exact training consistency;
- held-out exact-vector performance;
- counterexamples;
- surviving alternatives;
- search budget and resource usage;
- completeness status;
- verification level;
- solver or proof artifacts where available;
- checksum of the final executable representation;
- failure analysis when no candidate is accepted;
- target fingerprint and probe results;
- solver-portfolio allocation and per-engine contribution;
- retrieved modules and their provenance;
- decomposition hypotheses considered;
- independent replay status;
- calibrated confidence estimate tied to benchmark evidence.

---

## 31. Failure Categories

Failures should be classified rather than merged into one unsuccessful result.

- **No candidate in bound:** the complete bounded search found no solution.
- **Search budget exhausted:** a solution may exist but was not reached.
- **Solver unknown or timeout:** no logical conclusion was obtained.
- **Ambiguous candidates:** multiple non-equivalent candidates remain.
- **Insufficient observations:** additional oracle queries are required.
- **Discretization failure:** a soft proposal did not yield an exact candidate.
- **Model mismatch:** the target uses operations or state outside the DSL.
- **Noise inconsistency:** no exact candidate fits all observations.
- **Formal-model mismatch:** implementation and specification disagree because of modelling assumptions such as width, padding, or byte order.
- **Fingerprint uncertainty:** characterization evidence is insufficient or contradictory.
- **Decomposition failure:** no useful bounded factorization was found.
- **Library retrieval contamination:** a retrieved module overfits benchmark identity or introduces an unintended shortcut.
- **Proof replay failure:** the primary verifier accepted the candidate but an independent replay did not.
- **Resource-allocation failure:** the portfolio spent insufficient budget on an engine that later proved appropriate.

---

## 32. Appropriate Claims

The system may claim:

- a candidate matches every supplied observation;
- a candidate generalizes empirically to an independent test set;
- a candidate is the smallest found under a declared objective;
- the bounded search was complete and found no alternative within the declared hypothesis class;
- all surviving candidates are semantically equivalent over the stated domain;
- a candidate is formally equivalent to an independent specification;
- neural ranking improved synthesis speed or solve rate relative to the symbolic baseline;
- reusable verified modules improved subsequent synthesis.

The system may not claim:

- finite examples prove an unrestricted function universally;
- high average bit accuracy establishes an exact algorithm;
- a soft neural graph is a recovered program;
- random testing proves equivalence;
- SHA-256 can be rediscovered reliably from ordinary message-digest pairs;
- failure to find a program in heuristic mode proves that no program exists;
- a cryptographic transformation can be learned merely because its implementation is modular.

---

## 33. Research Contribution

The defensible research contribution is:

> A bounded neural-guided symbolic architecture that recovers and verifies structured discrete programs from end-to-end observations, supports hidden verified modules, learns reusable abstractions across tasks, actively selects distinguishing inputs when oracle access exists, and reports exactness only relative to explicit domains and hypothesis classes.

Potentially novel contributions include:

- combining hidden frozen modules with bounded downstream synthesis from final outputs only;
- target fingerprinting that selects and adapts the synthesis representation before search;
- a coordinated portfolio of exact and heuristic synthesis engines with learned resource allocation;
- bidirectional and meet-in-the-middle synthesis over typed bit-vector and bounded-memory programs;
- automatic discovery of latent intermediate representations that reduce verified description length;
- retrieval, specialization, and composition of previously verified modules;
- learning search heuristics across heterogeneous task families;
- automatic promotion of verified repeated subgraphs and rewrite rules into versioned typed libraries;
- calibrated ambiguity, model-mismatch, and bounded-uniqueness reporting;
- independent proof replay and proof-carrying program export;
- benchmark ladders that distinguish verification, sketch completion, bounded discovery, and infeasible unconstrained rediscovery.

Novelty must be established by a dedicated literature and patent review before publication or patent claims are made.

---

## 34. Final Verdict

The strengthened architecture is substantially more capable than a single neural supernetwork or a single symbolic synthesizer. Its strength comes from combining target characterization, adaptive DSL selection, a coordinated solver portfolio, bidirectional search, decomposition, module retrieval, active testing, and independent verification.

The realistic system is:

> a verified modular, multi-engine neural-guided symbolic program-induction framework for bounded structured deterministic algorithms.

This version can address a broader range of non-SHA targets, including Boolean and arithmetic circuits, checksums, encoders, bounded parsers, table-driven transformations, fixed-round routines, finite-state systems, and bounded array programs. Its practical reliability should improve materially on medium-sized structured targets because it no longer depends on one representation or one search direction.

The added strength does not remove the identifiability or cryptographic barrier. For complete SHA-256 rediscovery from raw message-digest pairs, expected reliability remains effectively zero. For SHA-256 as a frozen verified module, a verification target, a local-hole benchmark, or a tightly constrained sketch-completion problem, reliability can be high and the task is technically meaningful.

The first implementation should still begin with small exact bit-vector programs, but it should be designed around the portfolio, characterization, semantic-pruning, and proof-replay interfaces from the start so that later expansion does not require replacing the core architecture.
