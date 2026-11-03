# Verified modular program induction — distilled research design

**Source provenance:** Historical self-contained architecture proposal at this path, original Git blob `089207d3e1bd9219ddca3abdeaaa1a5e8acdc90d` (22,292 tree bytes). Original 26-section specification is recoverable through Git history. Authorship, empirical implementation, formal proofs, source licensing and current DT parity **UNKNOWN**. This is a proposed mechanism, not demonstrated performance or permission to implement.

## Problem, scope and impossibility boundary
From end-to-end input/output pairs `(A,Y)`, infer a compact typed discrete program `F`, optionally composed with a **frozen independently verified** module `G` (e.g. `Y=F(G(A))`). Intermediate labels need not exist. Candidate targets: bounded bit-vector arithmetic, Boolean logic, CRC/checksums, encodings, parsers, finite-state transforms, packet fields and compact legacy routines. SHA-256 is a benchmark or known module, **not** proof that a secure hash can be learned or inverted.

Finite observations cannot uniquely identify arbitrary functions. Exactness requires exhaustive finite-domain coverage, a reference equivalence proof, a bounded operator/program hypothesis class, known structure or an oracle with distinguishing queries. Secure pseudorandom/cryptographic unknown functions generally remain intractable from sparse pairs. Report ambiguity rather than extrapolating.

## Reusable mechanism
1. **Typed exact library:** Boolean AND/OR/XOR/NOT, MUX, majority; bit shifts/rotations/slices/permutations, sign/zero extension; width-defined modular arithmetic, comparisons; registers, finite-state transitions, bounded loops; composable verified adders, CRCs, parsers and hashes. Explicit widths, signedness, overflow, byte/bit order and state semantics.
2. **Optional primitive induction:** Small neural primitive trained on *complete* truth table; snap logits to exact 0/1 with a verified nonzero margin, exhaustively check all combinations, freeze/checksum. Differentiable floats never feed an exact discrete inference path.
3. **Structure proposal:** Differentiable sparse supernetwork ranks operators, edges, constants, masks, widths, reusable blocks and repeated rounds (softmax/Gumbel, straight-through, sparsity and minimum-description-length penalties). This only proposes candidates; it does not prove them.
4. **Discrete synthesis:** Extract explicit typed graph, symbolically simplify, solve constants, deduplicate equivalent forms, identify repeated local cells → word modules → repeated stages → full program. Favor minimal valid description over memorization.
5. **Counterexample loop:** Maintain competing programs; find an input on which they disagree; query permitted target oracle; eliminate inconsistent candidates and refine. Stop at bounded uniqueness, equivalence, exhausted budget or explicitly unresolved ambiguity.
6. **Verification:** Exhaustive primitive/module tables where tractable; differential held-out/random/boundary/adversarial tests; SAT/SMT/bounded-model/equivalence proofs for stated domains. Independently retest the **extracted discrete program**, not just the soft training graph.

## Proof and reporting contract
Report exact program/circuit and typed graph, constants, modules, checksum, training and held-out **whole-vector** accuracy, counterexamples, remaining alternatives, solver constraints/proof artifacts and budget. Distinguish:
- L0 training-set reproduction only;
- L1 held-out empirical generalization;
- L2 compact structural recovery;
- L3 uniqueness **within stated bounded class**;
- L4 formal equivalence over **specified full domain**.

Negative controls: indistinguishable functions outside observed inputs; bit/byte order, signedness, overflow, padding/length, state transitions, round count; soft-model success but discrete-extraction failure; low per-bit error with wrong full output; underconstrained hypothesis class; unverified reference or exhausted oracle. Random tests cannot establish universal equivalence.

## DT/Borg transfer hypothesis (NOT VERIFIED)
Potential narrow use: evidence-driven discovery of deterministic micro-transformations or compact protocol adapters, followed by a canonical-owner search, source/license check, bounded sandbox, negative controls and explicit Gate B authorization before any private DT source change. A small authorized proof experiment could infer a 4-bit arithmetic/CRC transform from partial observations, obtain solver-generated distinguishing examples, verify exact bounded equivalence, then test a withheld transform for transfer. Compare against direct symbolic synthesis without neural proposals on query count, solve time, accuracy and resource cost. Falsifiers: no measurable advantage, oracle unavailable, nonunique candidates, or existing DT owner already supplies the behavior. **No present private DT consumer, accepted mission, executed experiment or runtime Ground has been established.**

**Revisit trigger:** Director identifies an authorized actual DT deterministic transformation gap, bounded target oracle and canonical owner; otherwise retain as speculative standalone research, not a Code Engineer task.
