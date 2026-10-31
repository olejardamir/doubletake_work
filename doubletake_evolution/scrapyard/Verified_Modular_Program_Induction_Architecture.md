# Architecture Specification: Verified Modular Program Induction

## 1. Executive Summary

This document specifies a machine-learning system for discovering, composing, and verifying discrete algorithms from input-output observations.

The system is not limited to SHA-256. SHA-256 is one demanding benchmark and one reusable verified module among many possible algorithms, including:

- checksums and cyclic redundancy checks;
- bit-vector arithmetic;
- binary encodings and decodings;
- finite-state transformations;
- packet and protocol processing;
- error-correcting code components;
- fixed-point and integer transformations;
- compact control logic;
- legacy or undocumented binary routines;
- modular cryptographic and non-cryptographic functions.

The central objective is:

> Given examples of a transformation, discover a compact modular program or circuit that reproduces the observed behaviour, generalizes within a defined hypothesis class, and can be verified whenever sufficient constraints or coverage exist.

The architecture combines:

- verified primitive operations;
- reusable exact modules;
- differentiable structure learning;
- symbolic and combinatorial search;
- hierarchical abstraction discovery;
- active selection of informative examples;
- counterexample-guided refinement;
- formal or exhaustive verification;
- export to an explicit executable circuit or program.

The final result is not merely a statistical predictor. It is an inspectable discrete implementation whose operations, connections, constants, and repeated structures are explicit.

---

## 2. Core Problem

The general training interface is:

```text
Input A  ->  Observed output Y
```

The hidden transformation may be:

\[
Y = F(A)
\]

or a composition such as:

\[
Y = F(G(A))
\]

where:

- \(G\) may be known, partially known, or previously verified;
- \(F\) may be unknown;
- only \((A,Y)\) pairs may be supplied externally.

For example:

\[
B = SHA256(A)
\]

\[
Y = F(B)
\]

The system may compute \(B\) internally using a frozen exact SHA-256 module, while learning the unknown transformation \(F\) from the final supervision signal alone.

The same architecture must also support cases where no SHA-256 stage is present.

---

## 3. What the System Must Learn

Depending on the problem, the system may learn:

- the operation used at each node;
- the source of each node input;
- constants and masks;
- bit selections and permutations;
- arithmetic width and signedness;
- repeated subcircuits;
- reusable local modules;
- loop or round structure;
- finite-state transitions;
- branch or multiplexing conditions;
- composition order between known and unknown modules;
- a compact program consistent with the observations.

The system should prefer the smallest and most reusable valid explanation rather than memorizing examples.

---

## 4. Fundamental Limitation

No system can identify an arbitrary unknown function exactly from a limited set of input-output examples without additional assumptions.

If two candidate functions agree on all observed examples but disagree elsewhere, the data alone cannot determine which one is correct.

Therefore, exactness claims must be tied to at least one of the following:

- exhaustive coverage of a finite domain;
- query access to the target system;
- a bounded operation library;
- a circuit-size or program-length limit;
- known structural constraints;
- an independently available specification;
- formal equivalence to a reference implementation;
- proof that only one candidate remains within the defined hypothesis class.

The strongest defensible statement is often:

> The recovered program is exact within the specified operation library, size bound, input domain, and observation set.

---

## 5. System Architecture

```text
Observed training pairs (A, Y)
        │
        ▼
Input normalization and typed bit-vector representation
        │
        ▼
Optional frozen verified modules
(hash, parser, encoder, arithmetic, protocol stage, etc.)
        │
        ▼
Intermediate representations
        │
        ▼
Differentiable modular supernetwork
        │
        ├── operator selection
        ├── connection selection
        ├── constant discovery
        ├── width discovery
        ├── repeated-block discovery
        └── state-transition discovery
        │
        ▼
Discrete candidate extraction
        │
        ▼
Symbolic simplification and program synthesis
        │
        ▼
Counterexample-guided testing
        │
        ▼
Exhaustive, SAT, SMT, theorem, or differential verification
        │
        ▼
Explicit verified circuit or program
```

---

## 6. Verified Operation Library

The operation library defines the system's hypothesis class.

### 6.1 Boolean primitives

- AND;
- OR;
- XOR;
- XNOR;
- NOT;
- NAND;
- NOR;
- multiplexer;
- majority;
- equality;
- comparison predicates.

### 6.2 Bit-vector operations

- logical shift;
- arithmetic shift;
- rotation;
- concatenation;
- slicing;
- bit selection;
- bit permutation;
- zero extension;
- sign extension;
- truncation.

### 6.3 Arithmetic operations

- increment and decrement;
- modular addition;
- subtraction;
- multiplication for bounded widths;
- carry and borrow propagation;
- saturating arithmetic;
- fixed-point scaling;
- comparison;
- min and max.

### 6.4 Stateful operations

- register assignment;
- delay;
- finite-state transition;
- counters;
- conditional state update;
- bounded loops;
- repeated rounds.

### 6.5 Structured modules

- adders;
- comparators;
- CRC modules;
- checksums;
- encoders and decoders;
- substitution tables;
- packet-field extraction;
- parsers;
- error-correcting code modules;
- hash functions such as SHA-256;
- user-supplied verified components.

Each primitive or reusable module must have explicit semantics and a deterministic execution definition.

---

## 7. Learned Primitive Modules

Some Boolean primitives may be represented by tiny neural modules when neuralized execution is part of the experiment.

Examples include:

- XOR;
- selector or choice;
- majority;
- one-bit full addition;
- one-bit comparison;
- carry or borrow cells.

Every learned primitive must be small enough for complete truth-table verification.

For a learned primitive:

1. enumerate every valid input;
2. train on the complete truth table;
3. snap each output to an exact discrete value;
4. reject the model unless every output is correct;
5. require a numerical decision margin;
6. freeze and checksum the accepted model;
7. optionally compile it into equivalent gates or integer arithmetic.

Learned primitives are optional. The general system may also use deterministic primitives directly.

---

## 8. Exact Bit Snapping

Every learned discrete output must be converted to an exact bit before it enters another discrete operation.

For a logit \(z\):

\[
bit(z) =
\begin{cases}
1, & z \ge 0 \\
0, & z < 0
\end{cases}
\]

Acceptance should also require a safety margin:

```text
target 1: logit >= +margin
target 0: logit <= -margin
```

No unsnapped floating-point output may be used as a Boolean input during exact inference.

Soft or relaxed values may be used during structure learning, but the final extracted program must be discrete.

---

## 9. Differentiable Modular Supernetwork

The ML component should learn program structure rather than treating the target as an unrestricted dense mapping.

At each candidate node, the supernetwork may represent a weighted choice among:

- permitted operators;
- source nodes;
- constants;
- widths;
- optional activation or gating conditions;
- reuse of previously discovered modules.

During training, the system may use:

- softmax or Gumbel-softmax operator selection;
- straight-through estimators;
- sparse gates;
- temperature annealing;
- differentiable architecture search;
- learned masks;
- entropy penalties;
- L0-like sparsity penalties;
- minimum-description-length objectives.

After training, all choices must be discretized.

The extracted circuit must then be retested independently of the soft training graph.

---

## 10. Hierarchical Discovery

Flat gate-by-gate discovery does not scale well. The system must search hierarchically.

### Level 1: local relations

Discover small Boolean or arithmetic patterns.

### Level 2: reusable cells

Identify repeated structures such as:

- half adders;
- full adders;
- selectors;
- comparators;
- local substitutions.

### Level 3: word-level modules

Compress repeated cells into:

- ADD8, ADD16, ADD32;
- rotations;
- masks;
- word-wide Boolean functions;
- table lookups;
- encoders.

### Level 4: repeated stages

Detect:

- rounds;
- loops;
- recurrence;
- finite-state transitions;
- repeated protocol steps.

### Level 5: complete program

Assemble the discovered modules into a compact executable algorithm.

Whenever a repeated substructure is found, it should be promoted into the reusable module library.

---

## 11. Neural Proposal and Symbolic Search

ML should guide the search, while symbolic methods enforce exactness.

### Neural component

- rank promising operators;
- rank promising connections;
- suggest constants;
- identify likely repeated structures;
- propose decompositions;
- estimate useful module boundaries.

### Symbolic component

- enforce type and width constraints;
- reject impossible circuits;
- search local alternatives;
- solve constants exactly;
- simplify equivalent expressions;
- deduplicate candidate programs;
- prove equivalence where possible.

### Verification component

- exhaustive enumeration for small domains;
- SAT solving for Boolean circuits;
- SMT solving for bit-vectors and arithmetic;
- theorem proving where appropriate;
- hardware-equivalence checking;
- differential testing against a reference implementation.

---

## 12. Training from End-to-End Pairs Only

The external dataset may contain only:

```text
A -> Y
```

Intermediate values do not need to be supplied as labels.

If a known module \(G\) is available:

```python
B = frozen_verified_G(A)
Y_hat = learned_F(B)
loss = compare(Y_hat, Y)
```

The training file still contains only \((A,Y)\).

This supports problems such as:

\[
Y = F(SHA256(A))
\]

\[
Y = F(CRC(A))
\]

\[
Y = Decode(UnknownEncode(A))
\]

\[
Y = UnknownPostProcess(KnownProtocolStage(A))
\]

It also supports completely unknown transformations when the operation library and complexity bounds are sufficiently constrained.

---

## 13. Loss Functions

The training objective may combine several terms.

### 13.1 Output loss

- binary cross-entropy;
- exact-vector mismatch;
- Hamming distance;
- integer or field-specific error;
- sequence mismatch;
- state-transition mismatch.

### 13.2 Structure loss

Penalize:

- unnecessary nodes;
- excessive depth;
- unused branches;
- duplicated subcircuits;
- large constants without evidence;
- inconsistent widths;
- excessive state;
- non-reusable structure.

### 13.3 Verification-aware loss

Penalize candidates that violate known invariants, such as:

- parity;
- conservation relations;
- monotonicity;
- legal state transitions;
- type constraints;
- checksum relations;
- protocol grammar;
- arithmetic bounds.

### 13.4 Minimum-description objective

Among candidates with comparable predictive accuracy, prefer the program with the shortest explicit description.

This discourages memorization and promotes recoverable structure.

---

## 14. Counterexample-Guided Refinement

Random examples are often inefficient.

The system should maintain multiple candidate programs and search for an input on which they disagree.

```text
Candidate programs
        │
        ▼
Find distinguishing input A*
        │
        ▼
Query target system for Y*
        │
        ▼
Reject inconsistent candidates
        │
        ▼
Retrain or resynthesize
```

The selected input should maximize expected information gain or candidate elimination.

This loop continues until:

- only one candidate remains within the defined hypothesis class;
- all surviving candidates are equivalent;
- the query budget is exhausted;
- ambiguity is explicitly reported.

---

## 15. Candidate Confidence Levels

The system must distinguish several kinds of success.

### Level 0: memorization

The candidate reproduces training examples but has no demonstrated generalization.

### Level 1: empirical generalization

The candidate performs well on held-out and random tests.

### Level 2: structural recovery

The candidate is compact, modular, and consistent with known operation constraints.

### Level 3: bounded uniqueness

No alternative candidate within the defined operation library and complexity bound fits the observations while differing on any valid tested or solver-reachable input.

### Level 4: formal equivalence

The candidate is formally proven equivalent to a specification or reference implementation over the complete stated domain.

Reports must state the achieved level explicitly.

---

## 16. Verification Strategy

### 16.1 Primitive verification

Exhaustively verify every learned primitive over its complete truth table.

### 16.2 Module verification

Verify discovered modules independently, including:

- arithmetic blocks;
- permutations;
- state transitions;
- lookups;
- encoders;
- checksums;
- round functions.

### 16.3 Composition verification

Check:

- bit order;
- byte order;
- signedness;
- width truncation;
- overflow behaviour;
- constant placement;
- state routing;
- loop and round count;
- serialization.

### 16.4 Differential testing

Compare the extracted discrete program against the observed or reference system on:

- held-out examples;
- random inputs;
- boundary cases;
- adversarial cases;
- state-transition edge cases;
- maximum and minimum values;
- length and padding boundaries.

### 16.5 Formal verification

Where feasible, use:

- SAT;
- SMT;
- symbolic execution;
- theorem proving;
- equivalence checking;
- bounded model checking.

---

## 17. SHA-256 as One Benchmark and Reusable Module

SHA-256 remains useful for three purposes:

1. a demanding benchmark for exact modular composition;
2. a frozen known transformation inside larger unknown pipelines;
3. a source of reusable modules such as rotations, Boolean functions, and modular adders.

A verified SHA-256 implementation may use:

- deterministic padding and parsing;
- fixed constants;
- fixed rotations and shifts;
- verified XOR, choice, majority, and full-adder cells;
- verified 32-bit modular addition;
- fixed register movement;
- exact multi-block chaining.

The system may then learn transformations such as:

\[
Y = F(SHA256(A))
\]

without requiring \(SHA256(A)\) to be supplied as a training label.

SHA-256 is not the overall architecture. It is one module and one benchmark family.

---

## 18. Other Benchmark Families

### 18.1 Boolean and arithmetic circuits

- adders and subtractors;
- comparators;
- population count;
- parity;
- bit reversal;
- masks and permutations;
- fixed-point transformations.

### 18.2 Checksums and coding

- CRC variants;
- Adler-style checksums;
- Fletcher checksums;
- Hamming-code components;
- parity and syndrome generation;
- scrambling and descrambling.

### 18.3 Encodings and binary formats

- base encodings;
- endian conversion;
- packed-field extraction;
- undocumented record formats;
- reversible obfuscation;
- binary protocol transformations.

### 18.4 Stateful systems

- counters;
- sequence detectors;
- finite-state controllers;
- protocol state machines;
- compact scheduling or routing logic.

### 18.5 Known-plus-unknown pipelines

- known parser followed by unknown transformation;
- known checksum followed by unknown encoding;
- known hash followed by unknown postprocessing;
- unknown preprocessing followed by a known verified module;
- multiple known modules connected by one learned module.

### 18.6 Legacy and black-box behaviour

- recover compact logic from obsolete software;
- infer device protocol transformations;
- reproduce hardware behaviour;
- identify undocumented data conversion rules;
- replace inaccessible deterministic components.

---

## 19. Feasibility by Problem Structure

Execution size alone does not determine learnability.

A large function may be discoverable when it has:

- repeated rounds;
- shared local rules;
- small operation vocabulary;
- strong invariants;
- reusable subcircuits;
- bounded state;
- identifiable module boundaries.

A smaller function may be difficult when it behaves like:

- a random lookup table;
- a secure pseudorandom function;
- unknown-key encryption;
- an unrestricted high-complexity Boolean mapping;
- a deliberately irregular program.

The intended target class is:

> Structured discrete algorithms with compact descriptions, reusable modules, and execution complexity ranging from small circuits to SHA-sized repeated computations.

---

## 20. Security and Cryptanalytic Significance

The architecture does not automatically weaken cryptographic algorithms.

A verified neural or symbolic implementation of SHA-256 still computes SHA-256.

The system does not inherently provide shortcuts for:

- preimages;
- second preimages;
- collisions;
- hidden-key recovery;
- reversing secure hashes;
- defeating secure encryption.

When an unknown transformation is deliberately cryptographic or pseudorandom, learning from sparse examples is expected to fail unless the hypothesis class contains exploitable structural weaknesses.

---

## 21. Implementation Phases

### Phase 1: exact operation library

Implement and test:

- Boolean primitives;
- bit-vector operations;
- modular arithmetic;
- explicit typing and widths;
- serialization rules.

### Phase 2: verified reusable modules

Implement:

- adders;
- comparators;
- CRCs;
- checksums;
- finite-state blocks;
- SHA-256 as one benchmark.

### Phase 3: differentiable structure learner

Learn:

- operator selection;
- connections;
- constants;
- sparse modular graphs.

### Phase 4: discrete extraction

Convert the soft supernetwork into an explicit circuit.

### Phase 5: symbolic refinement

Simplify, solve exact constants, and search nearby alternatives.

### Phase 6: active learning

Generate distinguishing inputs and query the target system.

### Phase 7: hierarchical module induction

Promote repeated subgraphs into reusable learned modules.

### Phase 8: formal verification

Prove bounded uniqueness or full equivalence where possible.

---

## 22. Reference Training Flow

```python
def train_verified_program_induction(dataset, operation_library, known_modules):
    # dataset contains only observed input-output pairs: (A, Y)
    normalized = normalize_bitvector_examples(dataset)

    graph = initialize_differentiable_supernetwork(
        operation_library=operation_library,
        known_modules=known_modules,
    )

    for stage in curriculum_stages():
        train_end_to_end(
            graph,
            normalized,
            output_loss=True,
            sparsity_loss=True,
            description_length_loss=True,
            invariant_loss=True,
        )

        candidate = discretize_graph(graph)
        candidate = symbolically_simplify(candidate)

        failures = differential_test(candidate, normalized)
        if failures:
            refine_from_counterexamples(graph, failures)

    candidate = extract_best_discrete_program(graph)
    candidate = discover_and_promote_repeated_modules(candidate)
    report = verify_candidate(candidate, normalized, operation_library)

    return candidate, report
```

---

## 23. Output Artifacts

A successful run should produce:

- an explicit circuit or program;
- a typed operation graph;
- discovered constants;
- reusable submodules;
- a human-readable explanation;
- training and held-out accuracy;
- exact-vector accuracy;
- counterexamples found during refinement;
- ambiguity and surviving alternatives;
- verification level;
- SAT, SMT, or exhaustive proof artifacts where available;
- a checksum of the final executable representation.

---

## 24. Claims the System May Make

Appropriate claims include:

- the system recovered a compact program consistent with all observations;
- the program generalizes empirically to held-out inputs;
- the program is unique within a defined bounded hypothesis class;
- every learned primitive was exhaustively verified;
- the complete program is formally equivalent to a reference implementation;
- the system discovered reusable submodules from end-to-end supervision.

Inappropriate claims include:

- finite examples prove an unrestricted unknown function universally;
- high bit accuracy implies exact output-vector correctness;
- a soft neural model is equivalent to an extracted discrete circuit without retesting;
- random testing alone proves universal equivalence;
- SHA-like computational size implies SHA-like learnability;
- any hidden cryptographic function can be recovered from examples.

---

## 25. Research Contribution

The proposed contribution is:

> A hierarchical neural-symbolic architecture for discovering exact or bounded-exact discrete programs from end-to-end input-output observations, using reusable verified modules, differentiable circuit proposals, symbolic refinement, active counterexample selection, and formal verification.

The strongest novelty should come from the integration of:

- end-to-end supervision with hidden intermediate modules;
- automatic discovery of reusable abstractions;
- promotion of repeated structures into a module library;
- active distinguishing-input generation;
- explicit bounded-uniqueness claims;
- compilation from learned soft structures into exact discrete programs.

---

## 26. Final Verdict

This approach can be expanded well beyond SHA-256.

The resulting system should be described as:

> a verified modular program-induction and circuit-discovery framework for structured discrete algorithms

SHA-256 is one benchmark, one reusable verified module, and one example of exact modular composition.

The broader objective is to learn unknown structured transformations from observed behaviour, recover explicit modular computation, and provide the strongest verification claim supported by the domain, constraints, and available evidence.
