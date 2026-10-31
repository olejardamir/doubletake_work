# Architecture Specification: Exact Modular Neural-Circuit Implementation of SHA-256

## 1. Executive Summary

This document specifies a modular, machine-learning-flavoured implementation of SHA-256 that can be made **bit-exact**.

A conventional neural network trained from random examples cannot credibly guarantee exact SHA-256 behaviour on unseen inputs. The state space is too large, modular addition contains rare carry patterns, and 100% validation accuracy on sampled data is not a proof of correctness.

The corrected design therefore uses:

- fixed wiring for rotations, shifts, register movement, constants, and control flow;
- very small trainable Boolean modules;
- exhaustive training and verification of every learned module over its complete truth table;
- composition of those verified modules into 32-bit adders, the message schedule, the compression rounds, and the final state addition;
- hard bit-snapping at every learned Boolean output.

The result is not a generic MLP that approximates SHA-256. It is a **neural Boolean circuit** whose trainable components are small enough to verify completely.

---

## 2. Scope

This specification covers the SHA-256 compression process for one or more 512-bit message blocks.

The following operations remain deterministic:

- message padding;
- block parsing;
- round constants \(K_0 \dots K_{63}\);
- initial hash values;
- bit rotations and shifts;
- register routing;
- block-to-block chaining.

The learned components implement only small Boolean functions such as:

- XOR;
- choice;
- majority;
- one-bit full addition.

Because each learned component has a tiny finite input space, it can be exhaustively tested.

---

## 3. System Architecture

```text
Raw message
    │
    ▼
Deterministic SHA-256 padding
    │
    ▼
512-bit message block
    │
    ▼
Message schedule W[0..63]
    │
    │   fixed rotations/shifts
    │   verified neural XOR cells
    │   verified neural full-adder cells
    ▼
Initial working state A..H
    │
    ▼
┌────────────────────────────────────────────┐
│ Repeat for rounds t = 0..63                │
│                                            │
│  fixed rotations and routing              │
│  verified Ch neural cells                  │
│  verified Maj neural cells                 │
│  verified XOR neural cells                 │
│  verified 32-bit modular adders            │
│  hard bit-snapping after learned cells     │
└────────────────────────────────────────────┘
    │
    ▼
Final working state
    │
    ▼
Verified 32-bit modular additions
with incoming hash state
    │
    ▼
Updated 256-bit hash state
    │
    ▼
Next block or final 256-bit digest
```

---

## 4. Exactness Principle

Exactness is obtained locally and then preserved by composition.

For every learned Boolean cell:

1. enumerate every possible input;
2. train on the complete truth table;
3. snap the output to an exact bit;
4. verify every truth-table row;
5. reject the model unless all rows are correct.

For example, a full-adder cell has only three input bits:

\[
(x, y, c_{in}) \in \{0,1\}^3
\]

Therefore it has only eight possible inputs. If all eight cases are verified, the cell is exact.

A 32-bit ripple-carry adder constructed from 32 exact full-adder cells is then exact for every pair of 32-bit inputs. The same reasoning applies to all larger SHA-256 modules built from verified cells and fixed wiring.

Random holdout accuracy is still useful for implementation testing, but it is not the basis of the correctness claim.

---

## 5. Primitive Learned Modules

## 5.1 XOR Cell

### Function

\[
y = x_1 \oplus x_2
\]

### Input

- 2 binary values.

### Output

- 1 binary value.

### Complete truth table

| \(x_1\) | \(x_2\) | \(y\) |
|---:|---:|---:|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

### Suggested model

- 2 inputs;
- one small hidden layer;
- 1 output logit;
- hard threshold after inference.

Because XOR is not linearly separable, the model requires at least one nonlinear hidden layer.

---

## 5.2 Choice Cell

SHA-256 defines:

\[
Ch(x,y,z) = (x \land y) \oplus (\neg x \land z)
\]

Equivalent selector form:

\[
Ch(x,y,z) =
\begin{cases}
y, & x=1 \\
z, & x=0
\end{cases}
\]

### Input

- 3 binary values.

### Output

- 1 binary value.

### Verification space

- \(2^3 = 8\) cases.

---

## 5.3 Majority Cell

SHA-256 defines:

\[
Maj(x,y,z) = (x \land y) \oplus (x \land z) \oplus (y \land z)
\]

### Input

- 3 binary values.

### Output

- 1 binary value.

### Verification space

- \(2^3 = 8\) cases.

---

## 5.4 Full-Adder Cell

### Function

Inputs:

- \(x\);
- \(y\);
- carry-in \(c_{in}\).

Outputs:

\[
s = x \oplus y \oplus c_{in}
\]

\[
c_{out} = (x \land y) \lor (x \land c_{in}) \lor (y \land c_{in})
\]

### Input

- 3 binary values.

### Output

- sum bit;
- carry-out bit.

### Verification space

- \(2^3 = 8\) cases.

### Suggested model

- 3 inputs;
- one or two small hidden layers;
- 2 output logits;
- independent hard thresholding for both outputs.

---

## 6. Deterministic Modules

The following operations should not be learned because exact fixed implementations are simpler and already known.

## 6.1 Rotations

\[
ROTR^n(x)
\]

A rotation is a fixed permutation of the 32 input wires.

## 6.2 Logical Right Shifts

\[
SHR^n(x)
\]

A shift is fixed routing with zero insertion.

## 6.3 Round Constants

The 64 SHA-256 constants \(K_t\) are fixed 32-bit words and should be embedded directly.

## 6.4 Register Movement

The transitions:

```text
H' = G
G' = F
F' = E
D' = C
C' = B
B' = A
```

are fixed wire assignments, not learned transformations.

## 6.5 Padding and Block Parsing

Padding, message-length encoding, byte order, and 512-bit block parsing should use the standard deterministic SHA-256 procedure.

---

## 7. Composite Exact Modules

## 7.1 32-Bit Modular Adder

A 32-bit modular adder is constructed from 32 verified full-adder cells.

```text
carry[0] = 0

for i = 0..31:
    sum[i], carry[i+1] = FullAdder(x[i], y[i], carry[i])

discard carry[32]
```

The discarded final carry implements arithmetic modulo \(2^{32}\).

### Input

- two 32-bit words.

### Output

- one 32-bit word.

### Exactness

If the full-adder cell is correct for all eight inputs, the chained 32-bit adder is correct for all \(2^{64}\) input pairs.

No exhaustive enumeration of all \(2^{64}\) word pairs is required because correctness follows from the verified local cell and the deterministic carry chain.

---

## 7.2 Multi-Operand Addition

SHA-256 requires sums containing more than two operands.

For example:

\[
T_1 = H + \Sigma_1(E) + Ch(E,F,G) + K_t + W_t \pmod{2^{32}}
\]

This can be implemented as a deterministic tree or chain of verified 32-bit adders:

```text
u1 = add32(H, Sigma1(E))
u2 = add32(u1, Ch(E,F,G))
u3 = add32(u2, K[t])
T1 = add32(u3, W[t])
```

Similarly:

```text
T2 = add32(Sigma0(A), Maj(A,B,C))
```

A carry-save structure may be used later for speed, but a ripple-carry construction is easier to verify initially.

---

## 7.3 Word-Wide Choice and Majority

Apply one verified cell independently to each of the 32 bit positions:

```text
for i = 0..31:
    ch[i]  = ChCell(E[i], F[i], G[i])
    maj[i] = MajCell(A[i], B[i], C[i])
```

The same trained cell weights may be shared across all bit positions.

---

## 8. Message Schedule

The first 16 schedule words are parsed directly from the 512-bit message block:

\[
W_0 \dots W_{15}
\]

For \(t = 16 \dots 63\):

\[
W_t =
\sigma_1(W_{t-2}) +
W_{t-7} +
\sigma_0(W_{t-15}) +
W_{t-16}
\pmod{2^{32}}
\]

where:

\[
\sigma_0(x) = ROTR^7(x) \oplus ROTR^{18}(x) \oplus SHR^3(x)
\]

\[
\sigma_1(x) = ROTR^{17}(x) \oplus ROTR^{19}(x) \oplus SHR^{10}(x)
\]

Implementation:

- rotations and shifts: fixed wiring;
- XOR operations: verified XOR cells;
- additions: verified 32-bit modular adders.

A sequence-to-sequence neural network is neither necessary nor suitable for the exact version.

---

## 9. Compression Round

For round \(t\):

\[
\Sigma_0(A) = ROTR^2(A) \oplus ROTR^{13}(A) \oplus ROTR^{22}(A)
\]

\[
\Sigma_1(E) = ROTR^6(E) \oplus ROTR^{11}(E) \oplus ROTR^{25}(E)
\]

\[
T_1 = H + \Sigma_1(E) + Ch(E,F,G) + K_t + W_t \pmod{2^{32}}
\]

\[
T_2 = \Sigma_0(A) + Maj(A,B,C) \pmod{2^{32}}
\]

The next working state is:

\[
\begin{aligned}
A' &= T_1 + T_2 \pmod{2^{32}} \\
B' &= A \\
C' &= B \\
D' &= C \\
E' &= D + T_1 \pmod{2^{32}} \\
F' &= E \\
G' &= F \\
H' &= G
\end{aligned}
\]

This round is a structured composition of:

- fixed wiring;
- verified XOR cells;
- verified Choice cells;
- verified Majority cells;
- verified full-adder cells.

It is not represented by a single generic 320-to-256 MLP.

---

## 10. Final State Addition

After 64 rounds, add each working register to its corresponding incoming hash word:

\[
H_i^{new} = H_i^{old} + S_i^{64} \pmod{2^{32}}
\]

for \(i = 0 \dots 7\).

Each addition uses the verified 32-bit modular adder.

For multi-block messages, the resulting state becomes the incoming state for the next block.

---

## 11. Bit Snapping

Every learned Boolean cell must emit an exact binary value before its output is used elsewhere.

For a logit \(z\):

\[
bit(z) =
\begin{cases}
1, & z \ge 0 \\
0, & z < 0
\end{cases}
\]

Equivalently, after a sigmoid:

\[
bit(z) =
\begin{cases}
1, & \sigma(z) \ge 0.5 \\
0, & \sigma(z) < 0.5
\end{cases}
\]

Bit snapping prevents floating-point values from entering later Boolean operations.

It does not repair incorrect predictions. Therefore every primitive model must pass exhaustive verification before assembly.

---

## 12. Training Procedure

## 12.1 Dataset Construction

Use complete truth tables rather than random large datasets.

| Module | Input bits | Possible inputs |
|---|---:|---:|
| XOR | 2 | 4 |
| Choice | 3 | 8 |
| Majority | 3 | 8 |
| Full adder | 3 | 8 |

Every possible row is included in training and verification.

## 12.2 Loss

Use binary cross-entropy with logits:

```python
loss = BCEWithLogitsLoss()
```

For the full adder, compute loss over both output bits.

## 12.3 Optimizer

A small optimizer such as Adam or AdamW is sufficient.

The networks are tiny, so training cost is negligible.

## 12.4 Acceptance Gate

A learned module is accepted only when:

```text
exact truth-table accuracy = 100%
```

This means every output bit is correct for every possible input row after hard thresholding.

Average bit accuracy is not an acceptable substitute.

## 12.5 Model Freezing

After verification:

- freeze all learned weights;
- export them;
- prevent further training during SHA-256 assembly;
- record a checksum of each model artifact.

---

## 13. Verification Strategy

Verification occurs at several levels.

## 13.1 Primitive Verification

Exhaustively test every learned primitive over its complete input space.

Required result:

```text
0 incorrect rows
0 incorrect output bits
```

## 13.2 Component Verification

Test:

- 32-bit addition;
- all \(\sigma\) and \(\Sigma\) functions;
- message schedule generation;
- one compression round;
- final state addition.

Compare each component against a conventional integer or bitwise reference implementation.

## 13.3 End-to-End Known-Answer Tests

Test standard SHA-256 vectors, including:

- empty message;
- `"abc"`;
- messages around padding boundaries;
- one-block and multi-block messages;
- long repeated-input tests.

## 13.4 Random Differential Testing

Generate many random messages and compare the complete digest with a trusted SHA-256 implementation.

This provides strong implementation evidence, but the exactness argument still comes from exhaustive primitive verification and correct deterministic composition.

## 13.5 Optional Formal Verification

For stronger assurance, encode the exported primitive networks and their threshold decisions in:

- an SMT solver;
- a SAT solver;
- a theorem prover;
- a hardware-equivalence checker.

Because the primitive input spaces are tiny, direct exhaustive verification is normally sufficient.

---

## 14. Reference Execution Flow

```python
def sha256_neural_exact(message: bytes) -> bytes:
    blocks = deterministic_pad_and_split(message)
    hash_state = INITIAL_HASH_WORDS

    for block in blocks:
        W = build_schedule_with_verified_cells(block)

        A, B, C, D, E, F, G, H = hash_state

        for t in range(64):
            sigma1_e = big_sigma1(E)
            ch_efg = wordwise_ch(E, F, G)
            t1 = add32(H, sigma1_e)
            t1 = add32(t1, ch_efg)
            t1 = add32(t1, K[t])
            t1 = add32(t1, W[t])

            sigma0_a = big_sigma0(A)
            maj_abc = wordwise_maj(A, B, C)
            t2 = add32(sigma0_a, maj_abc)

            new_A = add32(t1, t2)
            new_E = add32(D, t1)

            A, B, C, D, E, F, G, H = (
                new_A, A, B, C, new_E, E, F, G
            )

        hash_state = tuple(
            add32(old_word, working_word)
            for old_word, working_word in zip(
                hash_state, (A, B, C, D, E, F, G, H)
            )
        )

    return serialize_big_endian(hash_state)
```

All helpers that perform learned logic must return snapped binary values and must use only frozen, verified models.

---

## 15. Optional Experimental Approximation Variant

A monolithic round network may still be useful as a research experiment:

```text
(State, W[t], K[t]) -> next State
```

However, it must be described accurately.

Appropriate claims:

- it approximates the SHA-256 round function;
- it may memorize or generalize over sampled inputs;
- it can be evaluated by per-bit and exact-state accuracy;
- it is not guaranteed to be exact outside the tested sample.

Inappropriate claims:

- random holdout accuracy proves universal equivalence;
- bit snapping corrects prediction errors;
- a reachable-state argument makes exhaustive correctness unnecessary;
- millions of random examples cover the relevant state space;
- 100% sampled validation accuracy implies exact SHA-256 emulation.

The approximate network should remain separate from the exact architecture.

---

## 16. Security and Cryptanalytic Significance

This architecture does not weaken SHA-256 and does not provide a shortcut for:

- finding preimages;
- finding second preimages;
- producing collisions;
- reversing hashes;
- recovering hidden message data.

It is an alternative implementation of the forward hash computation.

A neural implementation that exactly reproduces SHA-256 still computes the same function and inherits the same one-way computational problem.

---

## 17. Performance Considerations

The initial implementation should prioritize correctness over speed.

A bit-level neural-circuit version will likely be much slower and larger than an ordinary SHA-256 implementation.

Possible later optimizations include:

- shared cell weights across bit positions;
- vectorized inference over all 32 bit positions;
- batched evaluation of multiple words;
- carry-lookahead structures;
- carry-save addition trees;
- integer or binary weight quantization;
- FPGA or ASIC mapping;
- replacement of verified learned cells by exported Boolean gate equivalents.

These optimizations must preserve the verified truth tables.

---

## 18. Corrected Verdict

This design can achieve exact SHA-256 behaviour under the following conditions:

1. every learned primitive is exhaustively verified over its complete input space;
2. every output is hard-snapped to a binary value;
3. rotations, shifts, routing, constants, padding, and control flow are implemented deterministically;
4. larger arithmetic modules are composed only from verified primitives;
5. the assembled implementation follows the SHA-256 specification exactly.

The resulting system is best described as:

> an exact modular neural Boolean-circuit implementation of SHA-256

It should not be described as a conventional MLP that learned the complete SHA-256 function from sampled examples.
