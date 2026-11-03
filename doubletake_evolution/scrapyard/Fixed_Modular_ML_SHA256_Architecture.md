# Exact modular neural-Boolean SHA-256 — distilled architecture

**Source/provenance:** In-place reduction of this file, original blob `38de201f75587db24eacf29fcf82ee5c38de78e4` (16,164 Git bytes), 2026-11-02. Original equations, circuit diagram, pseudocode and discussion recoverable from Git history. This is a **design argument**, not a trained model, certified cryptographic implementation, current DoubleTake requirement or benchmark. No code or model was executed in this Scout review. The relevant external normative specification is NIST FIPS 180-4 (SHA-256); the design must be checked against it before use.

## Core claim and proof obligation

A monolithic neural network trained on sampled SHA-256 examples cannot establish exact behavior on all inputs. Instead, implement SHA-256 with **deterministic standard wiring/control** and frozen, hard-thresholded learned Boolean primitives whose *entire finite truth tables* are independently checked. Exact local truth tables plus correct deterministic composition imply exact global Boolean behavior; random test accuracy alone does not. This is a **conditional correctness argument**: correctness of wiring, constants, padding, byte order, state chaining, model export/inference, and all primitive evaluations remains separately required. Learned gates confer no cryptanalytic shortcut or security advantage and are expected to be slower than conventional SHA-256.

**Primitive contracts (complete finite input domain):**
- XOR(x,y) = x ⊕ y; 2 inputs, **4 rows**, 1 output. A nonlinear hidden layer is needed for a basic feed-forward XOR classifier.
- Ch(x,y,z) = (x∧y) ⊕ (¬x∧z) = (x ? y : z); **8 rows**, 1 output.
- Maj(x,y,z) = (x∧y) ⊕ (x∧z) ⊕ (y∧z); **8 rows**, 1 output.
- FullAdder(x,y,c): sum = x⊕y⊕c; carry = (x∧y)∨(x∧c)∨(y∧c); **8 rows**, **both** output bits checked on each row.

Each tiny model may use logits trained with binary cross-entropy (e.g. Adam); accept only **zero wrong output bits across all truth-table rows** after thresholding at logit ≥0 or sigmoid ≥0.5. Freeze/export weights and record artifact digest; preserve threshold, inference precision and execution environment. Hard snapping is necessary to feed binary bits downstream but **does not repair** a wrong prediction. Re-verify exported/inference representation, not merely the training-time model.

## Deterministic composition

- Use standard SHA-256 padding, 512-bit blocks, big-endian parsing, initial hash words, 64 round constants, fixed rotations/shifts and register routing. These are **not learned**.
- A 32-bit ripple-carry adder chains 32 fully verified FullAdder cells from carry-in 0 and discards final carry, giving addition modulo 2^32. For any 32-bit pair, exactness follows inductively from each cell's 8-row contract, not from enumerating 2^64 word pairs. Multioperand sums use repeated exact add32 operations; carry-save/lookahead only if separately proven equivalent.
- Apply XOR/Ch/Maj bitwise to 32-bit words (shared frozen cell weights are permissible). Define σ0(x)=ROTR7(x)⊕ROTR18(x)⊕SHR3(x); σ1(x)=ROTR17(x)⊕ROTR19(x)⊕SHR10(x). W[0..15] are parsed input words; for t=16..63: W[t]=σ1(W[t-2])+W[t-7]+σ0(W[t-15])+W[t-16] mod 2^32.
- Define Σ0(A)=ROTR2(A)⊕ROTR13(A)⊕ROTR22(A); Σ1(E)=ROTR6(E)⊕ROTR11(E)⊕ROTR25(E). For each round t: T1=H+Σ1(E)+Ch(E,F,G)+K[t]+W[t] mod 2^32; T2=Σ0(A)+Maj(A,B,C) mod 2^32. New (A,B,C,D,E,F,G,H)=(T1+T2,A,B,C,D+T1,E,F,G), with sums mod 2^32.
- After 64 rounds add each working register to its incoming corresponding hash-state word modulo 2^32; carry resulting eight words into the next block. Serialize final digest big-endian.

## Required independent validation and negative controls

1. **Primitive exhaustive gate:** enumerate all 4/8 inputs; compare *every output bit* of each frozen exported model against Boolean truth tables. Fail on one incorrect row, output-bit error, threshold ambiguity, nondeterministic inference or mismatched exported model digest.
2. **Component differential tests:** compare add32 (including long carry chains, overflow and wrap), σ/Σ, W[16..63], Ch/Maj, one full round, final state addition and multi-block chaining with trusted integer/bitwise reference. Verify bit order and modulo semantics.
3. **End-to-end:** standard known-answer vectors including empty bytes, `abc`, padding boundaries (55/56/63/64 bytes), multi-block and long messages; randomized differential digest comparison against a trusted SHA-256 implementation. These detect wiring bugs but do not substitute for local exhaustiveness plus correct composition.
4. **Negative:** a sampled-accuracy-only model, unsnapped float output, mutable/unverified weights, incorrect constants, endian swap, missing length padding, off-by-one round, corrupted carry or changed inference precision must not receive an exactness verdict. Optional SMT/SAT/hardware-equivalence checking strengthens the composition argument.

**Distinct alternative:** a monolithic learned round function (state,W[t],K[t])→next state is only an *approximation experiment*; report per-bit and exact-state sample accuracy, never universal equivalence. Potential vectorization, shared weights, quantization, FPGA/ASIC mapping and gate export require re-verification; no performance claim is supported.

## DoubleTake relevance and disposition

**KEEP / SURGICALLY_REDUCED_IN_PLACE / RESEARCH-ONLY.** Transferable methodological idea: small exhaustive contracts can justify composition where sampling cannot, provided the composition and actual runtime artifacts are independently checked. This does **not** validate DT's integrity history, B7 mission consumer, external assimilation, learned cognitive capability or natural cycle. No demonstrated DT consumer, architecture delta, license need or authorized experiment; **do not offer as a new implementation task**. Revisit only on a verified DT requirement for a finite primitive composition proof or a concrete counterexample to a current validator; otherwise keep compact as distinct general research.
