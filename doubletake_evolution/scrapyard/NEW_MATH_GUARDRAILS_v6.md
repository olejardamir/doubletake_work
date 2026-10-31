# NEW MATH GUARDRAILS — VERSION 6
## Research Charter for Evolving DDA / DLDA into Defensible New Mathematics

**Version:** 6.0  
**Date:** 2026-08-15  
**Supersedes:** `NEW_MATH_GUARDRAILS_v5.md` v5.0  
**Applies to:** DDA, DLDA, DLDA v2, and every future descendant  
**Current baseline:** DLDA v2 — Exact Realizability / Synchronization Spectrum work  
**Current novelty status:** **N1 — CANDIDATE**  
**Current proof maturity:** **M3 — PROVED + FINITE EXHAUSTIVE CHECKS FOR STATED SMALL CASE**  
**Current publication status:** **P0 — NOT YET ASSESSED AS A PAPER**

---

# 0. Why Version 2 Was Necessary

Version 1 was deliberately strict, but it contained one conceptual error of its own:

> it mixed **mathematical novelty**, **mathematical strength**, and **publication readiness** into one pass/fail test.

Those are related but different questions.

A single theorem can genuinely be new mathematics even if:

- it has only one corollary;
- it does not create a new branch of mathematics;
- it does not yet generate five open problems;
- it is too small for a full journal article;
- its bound is not yet sharp;
- it has not been formalized in a proof assistant.

Conversely, a polished paper-sized framework can still contain **no new mathematics** if all of its central results are known.

Therefore Version 2 separates three axes:

1. **NOVELTY** — is the mathematical content new?
2. **MATURITY** — how well has it been proved and independently checked?
3. **SIGNIFICANCE / PUBLICATION STRENGTH** — is it substantial enough for a paper?

The primary goal of this project is Axis 1.

---

# 1. Operational Definition of “New Mathematics”

For this project, a result counts as **new mathematics** when all of the following are true:

1. **There is an exact mathematical novelty kernel.**  
   We can state the smallest theorem, construction, classification, proof method, obstruction, or invariant that is claimed to be new.

2. **It is mathematically correct.**  
   The claimed result has a valid proof on its stated domain.

3. **It is not merely definitional.**  
   The result contains mathematical information not already built into the definitions.

4. **It is not a routine consequence of known mathematics.**  
   After translating the result into standard terminology, it is not obtained by a routine specialization, renaming, dualization, direct image, standard counting argument, or short chain of textbook lemmas from an existing theorem.

5. **The nearest prior art has been identified and compared theorem-by-theorem.**

6. **A serious adversarial novelty search has failed to find an equivalent result.**

7. **The claimed novelty survives natural reformulations.**  
   It is not an artifact of notation, labeling, encoding, coordinates, or a chosen representation.

This does **not** mean that we can prove that nobody in history has ever written an equivalent result.

Mathematical novelty is assessed from the strongest available evidence.

Therefore the correct final wording is normally:

> **“To the best of the literature search and theorem-level comparison performed, this result appears to be new.”**

---

# 2. What Can Count as New Mathematics?

Any of the following may qualify if it passes the novelty gates.

## 2.1 A new theorem about known objects

This is the cleanest case.

Example form:

\[
\text{known objects}
+
\text{previously unknown theorem}
=
\text{new mathematics}.
\]

No new vocabulary is required.

---

## 2.2 A new characterization theorem

For example:

\[
X \text{ has property }P
\iff
\text{conditions A, B, C}.
\]

The characterization must not already be a direct corollary of a known representation theorem.

---

## 2.3 A new representation or reconstruction theorem

Examples:

- exactly which objects can occur;
- exactly when partial data extend;
- exactly what information determines an object;
- reconstruction from a smaller invariant.

---

## 2.4 A new impossibility / no-go theorem

A negative result can be new mathematics.

Examples:

\[
\text{No object can satisfy A, B, C simultaneously.}
\]

or

\[
\text{Invariant }I\text{ cannot determine invariant }J.
\]

---

## 2.5 A new sharp bound or extremal theorem

For example:

\[
f(n)\le B(n)
\]

together with a construction attaining equality.

---

## 2.6 A new exact enumeration

A counting formula can be new mathematics even if inclusion-exclusion, generating functions, or Möbius inversion used in its proof are classical.

The novelty is the **enumerated structure and theorem**, not the counting technique.

---

## 2.7 A new invariant with nontrivial discriminatory power

The invariant must do something mathematically new.

It is not enough merely to define it.

---

## 2.8 A genuinely new proof method

A new proof of a known theorem is a mathematical contribution, but for this project's “new math” target it receives full credit only when the proof method itself is substantively new and does at least one of the following:

- proves a stronger theorem;
- works under weaker hypotheses;
- yields new corollaries;
- exposes a new invariant or structure;
- extends to a class not covered by the old proof;
- creates a reusable mathematical method.

A shorter or prettier proof alone is valuable, but it is not the preferred route for this project.

---

# 3. What Does NOT Count?

These are automatic rejection categories unless accompanied by a genuinely new theorem.

## 3.1 New terminology

\[
\text{known object}
\to
\text{new name}
\]

does not count.

---

## 3.2 New notation

Compact notation is useful but not mathematical novelty.

---

## 3.3 A new combination with no new consequence

“Ingredient A and ingredient B have never been discussed together” is insufficient.

The combination must produce new mathematics.

---

## 3.4 A theorem true by definition

If deleting the definition deletes the entire theorem, it is not a flagship novelty result.

---

## 3.5 Applying a standard construction

Examples:

- direct image;
- Cartesian product;
- powerset lifting;
- partition lattice;
- quotient;
- Möbius inversion;
- inclusion-exclusion;
- generating functions;
- ordinary nondeterministic semantics.

The construction may be part of the proof.

It is not novelty by itself.

---

## 3.6 Search-engine novelty

Searching an invented phrase and finding nothing is almost worthless.

Search must target mathematical content.

---

## 3.7 AI novelty

“No LLM knew this” is not evidence of novelty.

---

## 3.8 Computational novelty without proof

A pattern discovered by computation becomes a mathematical theorem only after proof.

---

## 3.9 Artificial generality

Replacing numbers with “an arbitrary algebraic structure” without using the algebra does not deepen the theorem.

---

## 3.10 Encoding artifacts

An invariant that changes merely because:

- selector symbols were renamed;
- coordinates were permuted;
- equivalent objects received different codes;
- sets were represented in a different order;

is not automatically a structural mathematical invariant.

If the encoding is intended to be part of the object, that must be explicit.

---

# 4. THREE INDEPENDENT STATUS AXES

No future report should use a single vague label such as “good” or “new.”

Every version receives three statuses.

---

# 4A. NOVELTY STATUS

## N0 — KNOWN / REFORMULATED

An equivalent theorem, construction, or routine derivation is known.

**Answer to “is this new math?”: NO.**

---

## N1 — CANDIDATE

There is a plausible novelty kernel, but prior-art and equivalence attacks are incomplete.

**Answer: NO.**

---

## N2 — PROVISIONALLY NOVEL

Requirements:

- novelty kernel isolated;
- theorem proved;
- strong prior-art search performed;
- closest results compared;
- no routine derivation found;
- representation-artifact attacks passed.

This means:

> there is significant positive evidence of novelty.

**Answer to a forced yes/no question remains: NO**, because independent novelty challenge is incomplete.

---

## N3 — INTERNALLY DEFENSIBLE NEW MATHEMATICS

Requirements:

- every mandatory novelty gate in Section 6 passes;
- at least one flagship result is proved;
- full theorem-level prior-art comparison is complete;
- citation-chain search is complete to the standard in Section 8;
- no equivalent or routine predecessor has been located.

At N3 we may answer:

> **YES — to the best of the research and comparison performed.**

The statement must retain that qualification in scientific writing.

---

## N4 — EXTERNALLY VETTED NOVEL RESULT

N3 plus independent scrutiny from at least one mathematically competent person familiar with the closest field, who is shown:

- the standard-form theorem;
- the proof;
- the closest prior-art results;
- the difference matrix;

and specifically asked to challenge novelty and correctness.

Peer review or acceptance by a reputable mathematics venue is stronger evidence still, but publication is not what makes the theorem new.

**Answer: YES, with materially higher confidence.**

---

# 4B. MATHEMATICAL MATURITY STATUS

## M0 — IDEA

Definitions or intuition only.

## M1 — CONJECTURE

Precise theorem stated but not proved.

## M2 — PROOF DRAFT

A complete-looking proof exists but has not undergone adversarial audit.

## M3 — PROOF AUDITED

Proof has survived:

- assumption audit;
- edge cases;
- counterexample pressure;
- dependency/circularity check;
- finite computational verification where feasible.

## M4 — INDEPENDENTLY VERIFIED

At least one of:

- independent proof;
- independent implementation;
- formal proof assistant verification;
- independent expert proof check.

Novelty and maturity are independent.

A known theorem can be M4/N0.

A genuinely new but freshly proved theorem can be M2/N3.

---

# 4C. PUBLICATION / SIGNIFICANCE STATUS

## P0 — NOT ASSESSED

No judgment.

## P1 — MATHEMATICAL NOTE

A correct novel result exists but may be small.

## P2 — SHORT-PAPER STRENGTH

One strong theorem plus meaningful consequences.

## P3 — FULL-PAPER STRENGTH

A coherent result package with significance, context, and enough depth for a conventional research paper.

## P4 — FIELD-SIGNIFICANT CANDIDATE

The result appears likely to matter beyond the immediate construction.

This axis is intentionally subjective.

**Publication strength is not part of the definition of novelty.**

Professional mathematics journals commonly evaluate originality and significance as related but distinct concerns; this charter therefore does the same.

---

# 5. THE NOVELTY KERNEL

Before any novelty search begins, write exactly one paragraph titled:

# NOVELTY KERNEL

It must state the smallest mathematical content that would still be new if every project-specific name disappeared.

Example format:

> Let \(F:D^m\to A\). For every partition \(\pi\) of \([m]\), let \(R_\pi\) be the range of \(F\) restricted to tuples satisfying the coordinate equalities induced by \(\pi\). We claim that an abstract family \((R_\pi)\) is realizable if and only if conditions X and Y hold.

Then delete:

- DDA;
- DLDA;
- “synchronization”;
- “correlation spectrum”;
- invented terminology.

If the claim becomes empty, the novelty is branding rather than mathematics.

---

# 6. MANDATORY NOVELTY GATES

These gates determine N3.

Unlike Version 1, gates about paper size, number of corollaries, and number of open problems are **not** novelty gates.

---

## GATE N1 — FORMAL CORRECTNESS AND NON-VACUITY

Every flagship theorem must have:

- exact objects;
- exact quantifiers;
- exact hypotheses;
- exact conclusion;
- complete proof.

Additionally:

### Non-vacuity test

Prove or exhibit that the hypotheses have nontrivial examples.

A universally true implication over an empty class is not interesting evidence.

### Edge cases

Check where relevant:

- empty sets;
- singleton alphabets;
- zero/one arity;
- constant maps;
- injective maps;
- impossible partitions;
- repeated variables;
- degenerate algebras.

---

## GATE N2 — NON-TAUTOLOGY

Remove terminology and definitions.

Ask:

> Is a mathematical statement left whose truth still requires proof?

If no, fail.

---

## GATE N3 — ROUTINE-COROLLARY ATTACK

Attempt to derive the flagship theorem from the nearest known results using ordinary machinery.

Explicitly test:

- specialization;
- relabeling;
- dualization;
- direct image;
- inverse image;
- quotient;
- product;
- restriction;
- standard induction;
- Möbius inversion;
- inclusion-exclusion;
- Hall-type arguments;
- ordinary occupancy/surjection counting;
- standard lattice theory;
- standard universal-algebra minor results.

If the theorem follows routinely, classify it N0 unless the specialization itself resolves an independently recognized open question.

---

## GATE N4 — REPRESENTATION / ISOMORPHISM INVARIANCE

Any claimed structural invariant must be tested under the natural symmetries of the problem.

For DLDA descendants this includes, as appropriate:

- permutation of coordinate positions;
- relabeling of selector symbols;
- relabeling of output symbols;
- isomorphism of the base algebra;
- equivalent representations of partitions;
- replacement of an object by a canonically isomorphic copy.

If a claimed invariant changes, one of two things must be true:

1. the encoding is explicitly part of the mathematical object; or
2. the definition is not structural enough.

This gate prevents accidental “novelty” created by representation choices.

---

## GATE N5 — STRICT-SEPARATION GATE, WHEN APPLICABLE

This gate is mandatory **only when we claim a new invariant, new semantic object, or stronger framework**.

It is not required when the novelty is simply a new theorem about an existing object.

Preferred proof:

\[
I_{\mathrm{old}}(X)=I_{\mathrm{old}}(Y)
\]

but

\[
I_{\mathrm{new}}(X)\ne I_{\mathrm{new}}(Y).
\]

Stronger:

prove there is no map \(G\) such that

\[
I_{\mathrm{new}}
=
G\circ I_{\mathrm{old}}
\]

on the relevant class.

---

## GATE N6 — PRIOR-ART COVERAGE

Raw query counts are not enough.

A novelty search must cover **sources, terminology, mathematical neighborhoods, and citation networks**.

Required coverage is defined in Section 8.

---

## GATE N7 — THEOREM-LEVEL DIFFERENCE MATRIX

For every predecessor within one conceptual step, compare:

| Feature | Our result | Predecessor |
|---|---|---|
| Mathematical objects | | |
| Input data | | |
| Equivalence relation | | |
| Hypotheses | | |
| Conclusion | | |
| Direction(s) proved | | |
| Exact / approximate | | |
| Constructive? | | |
| Enumeration? | | |
| Reconstruction? | | |
| Proof mechanism | | |
| Does predecessor imply ours? | | |
| Does ours imply predecessor? | | |
| Routine translation exists? | | |

A difference in terminology does not count.

A difference in proof style does not make the theorem new.

The key question is **logical derivability**.

---

## GATE N8 — CITATION-CHAIN ATTACK

For each closest predecessor:

1. inspect its references;
2. inspect papers citing it;
3. search the author's other work;
4. search papers using its key theorem names;
5. search predecessor terminology;
6. search the MSC neighborhoods in which it is classified.

This is mandatory because the exact theorem may live one citation away under different language.

---

## GATE N9 — CLAIM PROVENANCE

Every mathematically substantive sentence in the eventual paper must be labeled internally as one of:

- **KNOWN** — cited prior theorem;
- **NEW** — our claimed theorem;
- **LEMMA** — proved here but routine/supporting;
- **CONJECTURE**;
- **COMPUTATIONAL OBSERVATION**;
- **EXAMPLE**;
- **OPEN PROBLEM**.

This prevents a known lemma from gradually being promoted into an alleged new theorem.

---

## GATE N10 — NOVELTY FREEZE

Before the final prior-art comparison, freeze the flagship theorem:

- exact statement;
- hypotheses;
- conclusion;
- notation-free standard formulation.

Assign it a version and date.

If close prior art is found later, do **not** make cosmetic wording changes and then claim the result is different.

Any substantive mutation starts a new theorem version and a new novelty search.

This prevents moving the goalposts.

---

## GATE N11 — EXTERNAL-FORMULATION ATTACK

Ask:

> Could a mathematician in the nearest field recognize this problem without ever hearing the words DDA or DLDA?

The flagship statement must be expressible entirely in standard language.

Search and compare that formulation.

---

## GATE N12 — ALTERNATIVE-FRAMEWORK ATTACK

For DLDA descendants, actively try to translate the novelty kernel into:

1. universal algebra;
2. identification minors;
3. function-minor quasi-orders;
4. clone/minion theory;
5. partition lattices;
6. relational structures;
7. database dependencies;
8. team/dependence semantics;
9. CSP/promise-CSP polymorphisms;
10. semiring provenance;
11. finite model theory;
12. diagonal arrangements;
13. incidence algebras;
14. hypergraph/Sperner-system language;
15. coding/information constraints if capacity arguments appear.

A theorem survives only if the translated mathematical content remains unaccounted for.

---

# 7. MATHEMATICAL MATURITY GATES

These do not determine novelty by themselves, but they protect us from calling a false theorem new.

---

## GATE M1 — PROOF DEPENDENCY AUDIT

Create a dependency graph:

\[
\text{Definitions}
\to
\text{Lemmas}
\to
\text{Flagship theorem}
\to
\text{Corollaries}.
\]

For every arrow, identify exactly what is used.

Check for:

- circular reasoning;
- hidden use of the flagship theorem in a lemma;
- unproved existence assumptions;
- inconsistent conventions;
- quantifier changes;
- finite/infinite domain changes.

---

## GATE M2 — HYPOTHESIS NECESSITY

For each important hypothesis:

- remove it;
- weaken it;
- search for counterexamples.

Classify hypotheses as:

- necessary;
- sufficient but perhaps removable;
- technical;
- unknown.

Do not claim “necessary and sufficient” unless both directions are proved.

---

## GATE M3 — COUNTEREXAMPLE PRESSURE

Attack the theorem with:

- smallest cases;
- degenerate cases;
- maximally symmetric cases;
- constant functions;
- injective functions;
- random functions;
- adversarially constructed functions;
- boundary alphabet sizes;
- boundary codomain sizes.

Every counterexample becomes part of the theorem-development record.

---

## GATE M4 — COMPUTATIONAL INDEPENDENCE

When computation is feasible, do not let the theorem generator and theorem verifier share the same logic unnecessarily.

Preferred hierarchy:

### Level 1
One program enumerates examples.

### Level 2
Forward and inverse routes use separate code paths.

### Level 3
A second implementation is written independently.

### Level 4
A second implementation uses a different representation or language.

### Level 5
Formal verification / proof assistant where practical.

At minimum, any exhaustive verification used as serious evidence must document which components are shared.

---

## GATE M5 — REPRODUCIBILITY PACKAGE

For computational claims archive:

- source code;
- exact input parameters;
- random seeds where applicable;
- software/runtime version;
- expected outputs;
- generated counts;
- hash/version of theorem statement tested.

The code must be able to fail if the theorem is false.

---

## GATE M6 — SECOND-ROUTE CHECK

When feasible, seek a second derivation:

- constructive vs. counting;
- combinatorial vs. algebraic;
- direct proof vs. induction;
- symbolic proof vs. exhaustive finite verification.

This is strongly preferred for N3/M4 but is not logically required for every theorem.

---

# 8. PRIOR-ART SEARCH STANDARD

Version 1 relied too much on arbitrary query counts.

Version 2 uses a **coverage matrix**.

Query/source counts remain useful as floors, but they never substitute for coverage.

---

## 8.1 REQUIRED DATABASE / INDEX COVERAGE

Use as many of the following as accessible:

- MathSciNet / Mathematical Reviews;
- zbMATH Open;
- Google Scholar;
- arXiv;
- Semantic Scholar;
- Crossref / publisher search;
- major journal/publisher full-text search;
- university thesis/dissertation repositories.

If a database is inaccessible, record that explicitly.

---

## 8.2 REQUIRED SEARCH MODES

For the flagship theorem search by:

### A. Object names
What are the mathematical objects called elsewhere?

### B. Operations
What operation is being performed?

### C. Question type
Examples:

- realizability;
- representation;
- reconstruction;
- extension;
- completion;
- enumeration;
- minor range;
- image family;
- forbidden pattern;
- extremal bound.

### D. Formula fragments
Search distinctive mathematical phrases and formulas in words.

### E. Consequences
Search the theorem's strongest corollary.

Sometimes the main theorem is hidden under a consequence.

### F. Proof ingredients
Search combinations of:

- partition lattice;
- falling factorial capacity;
- exact equality patterns;
- variable identification;
- ranges/images.

### G. Alternative fields
Translate into at least three neighboring fields.

### H. Authors
Search authors of the closest papers for related work.

### I. Citation chaining
Backward and forward citations.

### J. Older terminology
Search vocabulary used before current terminology became standard.

---

## 8.3 MINIMUM COVERAGE FOR N2

At least:

- 20 mathematically distinct queries;
- 10 directly relevant sources inspected;
- 3 neighboring fields;
- backward references from the closest 3 sources.

---

## 8.4 MINIMUM COVERAGE FOR N3

At least:

- 30 mathematically distinct queries;
- 15 directly relevant sources inspected;
- at least 4 neighboring formulations/fields;
- backward citation chaining for all closest predecessors;
- forward citation chaining where available;
- author snowballing on the closest predecessors;
- explicit search of theses/preprints/books as well as journal papers;
- search using MSC classifications when identifiable.

These are minimum floors.

They can never compensate for missing a clearly relevant field.

---

## 8.5 SEARCH LEDGER

Every query must be logged:

| Date | Database | Exact query | Why searched | Relevant hits | Action |
|---|---|---|---|---|---|

Every close source must have:

- bibliographic identity;
- theorem numbers inspected;
- summary;
- relationship to our theorem;
- whether derivation was attempted.

---

# 9. ROUTINE-DERIVATION TEST

A result should be classified N0 if an expert can obtain it from known work by a short, standard sequence whose mathematical choices are obvious.

There is no universal numerical cutoff.

Instead document the derivation:

```text
Known Theorem A
+ textbook Lemma B
+ parameter substitution C
= proposed theorem
```

Then ask:

> Does any genuinely new mathematical idea enter?

If no, N0.

If yes, isolate exactly where it enters.

That point becomes the new novelty kernel.

---

# 10. CONDITIONAL GATES

These are important only when the result claims the corresponding strength.

---

## 10.1 SHARPNESS

Required if claiming:

- optimal;
- best possible;
- exact threshold;
- maximal;
- minimal;
- sharp.

Otherwise a non-sharp but new theorem may still be new mathematics.

---

## 10.2 UNIQUENESS / CANONICALITY

Required if using:

- unique;
- canonical;
- minimal;
- maximal.

Prove exactly the relevant universal property.

---

## 10.3 COMPLETENESS

Required if claiming:

- complete classification;
- complete invariant;
- complete proof system;
- exhaustive characterization.

Both directions must be explicit.

---

## 10.4 UNIVERSALITY

Required if claiming the construction applies to:

- every algebra;
- every category;
- every finite function;
- every algebraic theory.

Check the actual hypotheses.

Do not infer universality from examples.

---

## 10.5 STRICT-SEPARATION

Required only for a claimed new framework/invariant.

Not required for a new theorem about a known object.

---

# 11. PUBLICATION-STRENGTH TESTS
## These no longer determine whether the result is new mathematics.

They determine P-status.

A full-paper package may include:

- one flagship theorem;
- multiple corollaries;
- sharp examples;
- counterexamples showing necessity;
- classification;
- enumeration;
- applications;
- open problems;
- conceptual unification.

A single genuinely new theorem may still be N3/P1.

This distinction is essential.

---

# 12. EXTERNAL NOVELTY CHALLENGE

For N4, provide an independent mathematician with the following package **without leading language**:

1. standard-form theorem;
2. proof;
3. closest 3–5 known theorems;
4. difference matrix;
5. novelty kernel;
6. search ledger summary.

Ask:

1. Do you know an equivalent theorem?
2. Does one of the cited theorems imply this routinely?
3. Is the distinction mathematically substantive?
4. What literature are we missing?
5. Is the proof correct?

Record the answer verbatim or in a dated summary.

External review does not create novelty.

It increases the reliability of the novelty assessment.

---

# 13. CLAIM STRENGTH LADDER

The language used must match the evidence.

## N0 wording

> “This is a reformulation/application of known mathematics.”

## N1 wording

> “This is a candidate direction; novelty has not been established.”

## N2 wording

> “We have not found an equivalent result in the search performed, and the theorem appears distinct from the closest literature.”

## N3 wording

> “To the best of our literature search and theorem-level comparison, this result appears to be new.”

## N4 wording

> “The result has additionally survived independent expert novelty and correctness review.”

Never write:

> “This is the first theorem ever.”

Never write:

> “No one has done this before.”

unless there is unusually strong historical evidence.

---

# 14. SPECIAL RULE: NOVEL OBJECT VS NOVEL THEOREM

A new object does not need to be invented if we can prove a new theorem about an old object.

Therefore every evolution cycle must choose one of two routes.

## ROUTE A — NEW THEOREM ROUTE

Keep existing mathematical objects.

Find a genuinely unsolved question and prove it.

This is preferred.

## ROUTE B — NEW OBJECT ROUTE

Define a new object only when:

1. existing objects cannot express the required information naturally;
2. strict separation is proved;
3. the object supports at least one nontrivial theorem not obtainable from the old representation.

Do not invent objects merely to create novelty.

---

# 15. SPECIAL RULE: COUNTEREXAMPLES CAN BECOME THE RESULT

If a candidate theorem fails, do not treat the iteration as wasted.

Ask whether the failure yields:

- a minimal counterexample;
- a forbidden configuration;
- a necessary condition;
- an impossibility theorem;
- a sharp threshold;
- a classification of failure modes.

A new negative theorem is still new mathematics.

---

# 16. SPECIAL RULE: NO MOVING-GOALPOST NOVELTY

Suppose the frozen theorem is:

\[
T_1.
\]

A prior paper is found proving essentially \(T_1\).

We may not make superficial changes and call the result new.

Instead:

1. classify \(T_1\) as known;
2. formulate a materially stronger/different theorem \(T_2\);
3. record exactly what changed;
4. start a new proof and novelty search for \(T_2\).

---

# 17. SPECIAL RULE: HYPOTHESIS DEBT

When a conjecture fails and new assumptions are added, record them.

Template:

| Version | Added hypothesis | Why needed | Counterexample without it | Believed necessary? |
|---|---|---|---|---|

Repeatedly adding assumptions can shrink a theorem until it becomes a known trivial case.

This table prevents that.

---

# 18. SPECIFIC RED-ZONE PRIOR ART FOR DDA / DLDA

The following must be presumed known territory until proven otherwise.

---

## 18.1 Power / complex algebras

Therefore these are not novelty:

- lifting operations to sets;
- union-distributivity;
- finite powerset arithmetic.

---

## 18.2 Identification minors

Therefore this is not novelty:

> identify variables / coordinates and study the resulting functions.

---

## 18.3 Function-minor orders and minor posets

Prior work already organizes variable identifications and simple substitutions in rich order-theoretic structures, including links to partition lattices.

---

## 18.4 Reconstruction from minors

Therefore:

> can a function be reconstructed from identification minors?

is already an established problem family.

---

## 18.5 Affine and structured reconstruction

Prior work already studies reconstruction for classes including affine functions over algebraic structures.

Therefore merely restricting DLDA to “affine” does **not** automatically create novelty.

The exact invariant/question must differ.

---

## 18.6 Team / dependence semantics

Joint assignments and explicit dependency are established.

---

## 18.7 Shared nondeterministic choice

Call-time versus independent choice is established.

---

## 18.8 Incidence algebras and Möbius inversion

Applying Möbius inversion to the partition lattice is standard.

Only a genuinely new theorem about the resulting transform can be novel.

---

## 18.9 CSP clone/minion theory

Variable minors and polymorphism/minion structures are major neighboring areas and must be checked for any constrained-function result.

---

## 18.10 Sperner systems / hypergraph reconstruction

Identification-minor reconstruction has known connections to Sperner-system reconstruction, so frontier/antichain claims must be searched there too.

---

# 19. CURRENT DLDA v2 NOVELTY AUDIT

Current strongest candidate claims:

1. synchronization-range spectrum;
2. exact equality-kernel decomposition;
3. novelty layers;
4. falling-factorial local capacity condition;
5. exact realizability characterization;
6. exact fiber enumeration;
7. minimum selector alphabet.

Current status remains:

\[
\boxed{N1}
\]

until the theorem-level search is completed.

The most serious unresolved question is:

> Is the range-spectrum realizability theorem already a known or routine consequence of identification-minor / minor-poset / finite-function theory when translated into standard terminology?

Specific searches still required:

- ranges/images of identification minors;
- decks of minor ranges;
- image sets under simple variable substitutions;
- realizability of range families of minors;
- partition-indexed image systems;
- kernel partitions of words/tuples;
- equality-pattern strata;
- finite-function image reconstruction;
- antitone set-valued maps on partition lattices;
- quotient/minor-poset range invariants;
- capacity constraints from exact equality types;
- range equivalence of minors;
- relational/table projections under equality constraints.

The exact fiber enumeration requires a separate novelty assessment even if the realizability theorem proves known.

One theorem being known does not automatically make every corollary or enumeration formula known.

---

# 20. EVOLUTION LOOP — VERSION 2

Every future iteration follows this order.

## STEP 1 — State the weakness

Exactly one main weakness.

---

## STEP 2 — Freeze the standard mathematical problem

No DDA/DLDA vocabulary.

---

## STEP 3 — Search prior art BEFORE proving

Try to kill the idea cheaply.

---

## STEP 4 — Define the novelty kernel

One paragraph.

---

## STEP 5 — Generate small cases

Compute the landscape.

---

## STEP 6 — Form a precise conjecture

No vague theory-building.

---

## STEP 7 — Attack the conjecture

Counterexamples first.

---

## STEP 8 — Prove or refute

If refuted, inspect whether the counterexample itself yields a theorem.

---

## STEP 9 — Audit assumptions

Hypothesis-debt table.

---

## STEP 10 — Independent computational check

When feasible.

---

## STEP 11 — Freeze the theorem statement

Version/date it.

---

## STEP 12 — Run the full prior-art attack

Including citation chains and alternative fields.

---

## STEP 13 — Attempt routine derivations from closest results

Write the attempted derivation explicitly.

---

## STEP 14 — Complete the difference matrix

No rhetorical distinctions.

---

## STEP 15 — Assign N/M/P statuses separately

Do not allow publication strength to inflate novelty.

---

# 21. NOVELTY EVIDENCE PACKAGE

No theorem can reach N3 without a folder containing:

```text
/novelty_evidence/
    01_novelty_kernel.md
    02_standard_theorem_statement.md
    03_complete_proof.md
    04_proof_dependency_graph.md
    05_counterexample_log.md
    06_hypothesis_debt.md
    07_search_ledger.csv
    08_closest_prior_art.md
    09_difference_matrix.md
    10_equivalence_attacks.md
    11_computational_verification/
    12_claim_provenance.md
    13_status_decision.md
```

For N4 add:

```text
    14_external_review.md
```

This evidence package is mandatory.

---

# 22. “YES / NO” DECISION RULE

If asked:

> **Is this now new math?**

Answer according to N-status:

- N0 → **No**
- N1 → **No**
- N2 → **No**
- N3 → **Yes**
- N4 → **Yes**

This gives the project a stable target.

The answer is based on mathematical novelty, not paper length.

---

# 23. WHAT IS REQUIRED FOR N3 — FINAL CHECKLIST

All boxes are mandatory.

## Mathematical content

- [ ] A frozen novelty kernel exists.
- [ ] A complete flagship theorem statement exists.
- [ ] A complete proof exists.
- [ ] The theorem is non-vacuous.
- [ ] The theorem is not definitional.
- [ ] The theorem survives edge cases and counterexample pressure.
- [ ] All important hypotheses are audited.

## Structural integrity

- [ ] Natural relabeling/isomorphism tests pass.
- [ ] If a new invariant/framework is claimed, strict separation is proved.
- [ ] The theorem can be stated in standard external terminology.

## Prior art

- [ ] Required database coverage is completed or inaccessible sources are documented.
- [ ] At least 30 mathematically distinct searches are logged.
- [ ] At least 15 directly relevant sources are inspected.
- [ ] At least four neighboring formulations/fields are searched.
- [ ] Backward citation chains are inspected.
- [ ] Forward citation chains are inspected where available.
- [ ] Closest authors' related work is searched.
- [ ] Theses/preprints/books are included.
- [ ] MSC-neighborhood search is performed when identifiable.
- [ ] The difference matrix is complete.
- [ ] Routine derivation attempts are documented.
- [ ] No equivalent theorem or routine derivation has been found.

## Reliability

- [ ] Computational checks pass where feasible.
- [ ] Shared-code risks are documented.
- [ ] A second route or independent checker is used when reasonably feasible.
- [ ] Claim provenance is complete.
- [ ] Novelty statement was frozen before final comparison.

If any mandatory box is unchecked:

\[
\boxed{\text{N3 HAS NOT BEEN REACHED.}}
\]

---

# 24. WHAT IS REQUIRED FOR P3 — FULL PAPER STRENGTH
## This is deliberately separate from new-math status.

Typical P3 package:

- [ ] one strong flagship theorem;
- [ ] multiple meaningful consequences;
- [ ] examples and counterexamples;
- [ ] reasonable significance beyond terminology;
- [ ] adequate literature context;
- [ ] natural open problems;
- [ ] clear paper narrative;
- [ ] reproducible computation where relevant.

A theorem can be N3/P1.

A polished synthesis can be N0/P3 as an exposition.

Do not confuse them.

---

# 25. EXTERNAL STANDARDS CHECK

Professional mathematical publication practice reinforces the distinction used here:

- journals expect original/new results;
- editors and referees separately assess contribution/significance;
- manuscripts are expected to explain novelty explicitly;
- mathematical authors remain responsible for correctness.

Therefore this charter treats:

\[
\text{novelty}
\ne
\text{significance}
\ne
\text{correctness}
\ne
\text{publication readiness}.
\]

All four matter.

They are not the same property.

---

# 26. FINAL PRINCIPLE

The objective is no longer:

> “evolve DDA until it looks unlike existing mathematics.”

The objective is:

> **find a precise mathematical question near the current work that is not already solved, prove a result answering it, and survive a deliberate attempt to show that the result was already known.**

That is the standard.

---

# 27. FINAL RULE

## A new vocabulary does not earn N3.

## A large manuscript does not earn N3.

## A successful exhaustive program does not earn N3.

## A clever construction does not earn N3 by itself.

## Only a proved novelty kernel that survives theorem-level prior-art and equivalence attacks earns N3.

When that happens, the correct answer to:

> **“Is this new math?”**

becomes:

\[
\boxed{\textbf{YES}}
\]

with the scientifically necessary qualifier:

> **to the best of the research and comparison performed.**

---

# 28. VERSION 3 — ADDITIONAL MANDATORY GUARDRAILS

Version 2 was strong, but a further adversarial audit found several remaining loopholes.

The rules in this section are **mandatory additions**. If anything below conflicts with an earlier section, this Version 3 section controls.

The major corrections are:

1. novelty is now explicitly **claim-level**, not project-level;
2. every close prior-art statement must be verified in the **primary source**, not inferred from a search result, abstract, review, or LLM summary;
3. novelty now has a **temporal/priority record** and can be revoked when earlier prior art is discovered;
4. the literature search must reach **search saturation**, not merely numerical query thresholds;
5. enumeration claims must be fingerprinted against **sequence databases** where applicable;
6. historical and non-English terminology must be searched when the field warrants it;
7. computational verification must undergo **mutation/falsification testing**;
8. exhaustive checks at small size may never be rhetorically upgraded into evidence of a general proof;
9. claims of solving an “open problem” require independent verification that the problem was still open;
10. the mathematical foundations and scope of every theorem must be frozen explicitly.

These close the main remaining ways in which a false novelty conclusion could survive Version 2.

---

# 29. CLAIM-LEVEL NOVELTY — MANDATORY

Novelty belongs to **individual mathematical claims**, not automatically to a project, theory name, or manuscript.

Every theorem, construction, invariant, characterization, enumeration, and algorithmic result that matters must receive its own novelty status:

\[
N0,\ N1,\ N2,\ N3,\ \text{or }N4.
\]

Example:

| Claim | Status |
|---|---|
| Powerset lifting | N0 |
| Partition indexing of identifications | N0 |
| Exact realizability theorem | N1 |
| Fiber enumeration formula | N1 |
| A later genuinely new extremal theorem | N3 |

If one theorem reaches N3, the project may say:

> **“This work contains new mathematics.”**

It may **not** say:

> “DLDA is entirely new mathematics.”

unless every component being described as new has independently reached N3 or N4.

## Project-level aggregation rule

Let

\[
\mathcal C=\{C_1,\ldots,C_r\}
\]

be the set of substantive claims.

The project-level novelty report must list the complete vector

\[
(N(C_1),\ldots,N(C_r)).
\]

A project is allowed to answer **YES** to

> “Does this work now contain new mathematics?”

when at least one mathematically substantive flagship claim is N3 or N4.

A project may answer **YES** to

> “Is this whole theory new?”

only if that stronger statement is itself justified claim-by-claim.

This distinction is mandatory.

---

# 30. PRIMARY-SOURCE VERIFICATION GATE

No close prior-art result may be classified solely from:

- a search-engine snippet;
- an abstract;
- a review article;
- a bibliography entry;
- an LLM summary;
- a citation made by another paper;
- a database-generated description.

For every close predecessor, inspect the original source whenever reasonably accessible.

Record:

- exact bibliographic citation;
- publication/preprint date;
- exact theorem/proposition/lemma number where available;
- relevant definitions;
- exact hypotheses;
- exact conclusion;
- page numbers;
- whether the proof was inspected;
- whether our claimed result follows.

If the primary source is inaccessible, mark:

\[
\boxed{\text{PRIMARY SOURCE NOT VERIFIED}}
\]

and do not treat the prior-art comparison as complete.

## Citation hallucination guard

Every source in the novelty evidence package must be verified to exist.

Every theorem attributed to a source must be verified to occur there in substantially the form claimed.

A fabricated, misattributed, or misunderstood citation invalidates the affected novelty assessment until corrected.

---

# 31. TEMPORAL PRIORITY AND CONCURRENT-DISCOVERY RECORD

Novelty assessment must distinguish:

1. **mathematical originality of our derivation**;
2. **literature novelty at the time of derivation**;
3. **publication priority**.

For every frozen flagship theorem record:

- `conjecture_date`;
- `first_complete_proof_date`;
- `theorem_freeze_date`;
- `first_public_timestamp`, if any;
- date of every close prior result;
- whether that result was publicly accessible before our proof.

## Rules

### Earlier equivalent result found

If a mathematically equivalent result was publicly available before our derivation, the claim becomes:

\[
\boxed{N0}
\]

regardless of whether we rediscovered it independently.

Independent rediscovery can still be intellectually valuable.

It is not literature-new mathematics.

### Later equivalent result found

If an equivalent result appears only after our documented proof date, do not automatically downgrade to N0.

Record it as a possible concurrent or later independent development and investigate priority carefully.

### Uncertain date

If priority cannot be resolved, the novelty status cannot exceed N2 until clarified.

---

# 32. NOVELTY STATUS IS REVOCABLE

Novelty status is not permanent.

If later research finds:

- an earlier equivalent theorem;
- a routine derivation previously missed;
- a historical source;
- a thesis/preprint containing the same result;

then downgrade the claim immediately.

Possible transitions include:

\[
N3\to N0,
\qquad
N3\to N1,
\qquad
N2\to N0.
\]

The novelty ledger must preserve the old assessment and the reason for the downgrade.

This is not a failure of the process.

It is the process working correctly.

---

# 33. SEARCH-SATURATION RULE

The numerical search floors from Version 2 are necessary but not sufficient.

Thirty queries can all be bad queries.

Fifteen papers can all come from the wrong subfield.

For N3, the search must also reach **semantic saturation**.

## Saturation criterion

Perform search rounds until at least **two consecutive rounds** produce:

- no new close mathematical framework;
- no new terminology for the same objects;
- no new author cluster directly relevant to the theorem;
- no new theorem within one conceptual step;
- no new citation branch that materially changes the difference matrix.

A “round” must use genuinely new formulations or citation directions.

If a new framework appears, saturation resets.

## Search coverage graph

Maintain a small graph:

```text
our theorem
  ├── identification minors
  │     ├── reconstruction
  │     ├── range/image questions
  │     └── minor posets
  ├── partition lattice
  ├── relational/database formulation
  ├── CSP/minion formulation
  └── combinatorial enumeration formulation
```

Every discovered neighboring vocabulary node must either:

- be searched;
- or be explicitly justified as irrelevant.

This is stronger than query counting.

---

# 34. HISTORICAL AND MULTILINGUAL TERMINOLOGY GATE

Mathematics often changes vocabulary over decades.

When the closest area has substantial historical literature, search:

- older terminology;
- translated terminology;
- names used by major historical authors;
- French, German, Russian, Italian, or other-language terminology where relevant and feasible;
- review papers that map old terminology to modern terminology.

This does not require exhaustive translation of all mathematics ever published.

It requires a good-faith attempt where there is a realistic risk that older work uses different language.

Record which historical terminology was searched.

---

# 35. ENUMERATION FINGERPRINT GATE

Whenever a new result produces an integer sequence such as:

\[
a_1,a_2,a_3,\ldots
\]

or a table of small counts, search the **Online Encyclopedia of Integer Sequences (OEIS)** and related combinatorial references.

Search:

- the exact initial sequence;
- shifted versions;
- normalized versions;
- complements/differences when mathematically natural;
- row/column sequences from a counting table.

If a match is found:

1. inspect the references attached to the sequence;
2. determine whether the counted object is equivalent;
3. compare formulas and recurrences.

A sequence match can reveal prior art under completely different terminology.

A sequence mismatch does **not** prove novelty.

---

# 36. OPEN-PROBLEM CLAIM GATE

Never say:

> “We solved an open problem”

merely because an older paper calls it open.

Before making such a claim:

1. identify the exact original open problem;
2. verify that our theorem really answers the same problem;
3. search later papers citing the source;
4. search the problem statement directly;
5. search major authors working on it;
6. verify that no known solution appeared after the original statement;
7. record the date through which the open status was checked.

If open status remains uncertain, say:

> “This appears to address a problem stated as open in [source], but we have not established that it remained open.”

---

# 37. FOUNDATION AND SCOPE FREEZE

Every frozen theorem must declare its mathematical universe.

Examples:

- finite sets only;
- arbitrary sets;
- ZF;
- ZFC;
- finite combinatorics requiring no Choice;
- classical logic;
- constructive logic;
- commutative monoids;
- arbitrary algebras;
- finite fields;
- total functions only;
- partial functions allowed or excluded.

This prevents hidden generalization.

## Scope rule

If a proof uses finiteness, the theorem may not later be described as “arbitrary” without a new proof.

If a proof uses commutativity, the theorem may not be advertised for arbitrary monoids.

If computation only covers finite cases, it does not support an infinite-domain claim.

The theorem freeze file must contain a `FOUNDATIONAL_SCOPE` block.

---

# 38. SMALL-CASE EXHAUSTION BARRIER

Exhaustive verification of all objects up to a finite size is valuable.

It is never a substitute for a proof of a theorem quantified over all sizes.

Therefore language such as:

> “proved by exhaustive testing”

is permitted only when the theorem's domain itself is the exhausted finite universe.

For a general theorem, computational evidence must be described as:

- verification;
- sanity check;
- counterexample search;
- experimental support.

Never as the universal proof unless the proof is formally a finite exhaustive argument over the whole stated domain.

---

# 39. COMPUTATIONAL MUTATION / FALSIFICATION GATE

A verifier is trustworthy only if it can demonstrably reject false statements.

For important computational evidence, perform **mutation tests**.

Examples:

- change a necessary inequality by \(+1\);
- remove a hypothesis;
- reverse an order relation;
- alter one term of a counting formula;
- inject an intentionally false spectrum;
- modify one expected fiber count.

The checker must fail.

Record:

| Mutation | Expected | Observed | Pass? |
|---|---|---|---|
| Remove capacity condition | checker finds contradiction | ... | ... |
| Change falling factorial | count mismatch | ... | ... |
| Reverse refinement test | mismatch | ... | ... |

A program that only ever reports PASS has not demonstrated that it is capable of detecting the targeted failure.

---

# 40. COMPUTATIONAL ORACLE DIVERSITY

Where feasible, verify important finite claims using a second representation.

Examples:

- direct Python enumeration vs. SAT/SMT encoding;
- tuple enumeration vs. symbolic algebra;
- partition restricted-growth strings vs. explicit block sets;
- independent implementation in another language;
- brute force vs. dynamic programming.

The second route should not import the theorem-specific helper functions from the first route.

Record shared components explicitly.

This gate strengthens M4.

---

# 41. RANDOMIZED EXPERIMENT GUARD

When randomized testing is used:

- record PRNG;
- seed;
- number of trials;
- sampling distribution;
- stopping rule;
- rejected/filtered samples;
- whether the theorem was changed after seeing failures.

Random testing is useful for finding counterexamples.

It is not evidence of exact novelty and is weaker than exhaustive finite verification.

---

# 42. THEOREM-INDEPENDENCE FROM SOFTWARE IMPLEMENTATION

A mathematical definition must exist independently of the code used to test it.

No theorem may be defined by:

> “whatever the verifier computes.”

For every computationally tested theorem, the mathematical specification comes first.

Then code implements it.

If two disagree, the mathematical statement and proof must be re-audited rather than silently modifying one to match the other.

---

# 43. NEGATIVE-SEARCH EVIDENCE RULE

The sentence

> “No prior art was found”

has weak evidential value by itself.

The real novelty evidence is the combination of:

1. a precisely frozen theorem;
2. mathematically close predecessors;
3. theorem-level comparison;
4. failed routine-derivation attempts;
5. broad terminology coverage;
6. citation-chain coverage;
7. search saturation;
8. independent external challenge where possible.

The absence of a search hit is never sufficient on its own.

---

# 44. “CLOSEST KNOWN RESULT” REQUIREMENT

For N3, it is not enough to say:

> “We did not find this.”

We must be able to answer:

> **What is the closest known theorem, and exactly why is ours not that theorem?**

Every N3 flagship claim must name at least one closest predecessor unless an extensive search genuinely finds no plausible predecessor.

If none is found, explain why the search nevertheless covers the relevant mathematical neighborhoods.

---

# 45. RESULT-STRENGTH NORMALIZATION

A weaker theorem is not new merely because a known stronger theorem is phrased differently.

Before claiming novelty, test:

\[
\text{Known theorem}
\Rightarrow
\text{our theorem}?
\]

If yes by a routine implication, ours is N0.

Also test:

\[
\text{our theorem}
\Rightarrow
\text{known theorem}?
\]

when hypotheses are matched.

This prevents novelty claims based on:

- weaker conclusions;
- redundant hypotheses;
- unnecessary finite restrictions;
- restricted parameter ranges already implied by general results.

---

# 46. PARAMETER-RENAMING AND REINDEXING ATTACK

Especially for combinatorics, formulas can look new because parameters are indexed differently.

Before claiming a new formula:

- normalize parameters;
- test substitutions such as \(n\mapsto n-1\), \(k\mapsto n-k\);
- test dual partitions;
- test complements;
- test labeled vs. unlabeled counts;
- test ordered vs. unordered conventions;
- test whether factorial factors arise merely from labeling.

For enumeration formulas, compare both raw counts and symmetry-normalized counts.

---

# 47. PUBLIC / PRIVATE PRIOR ART DISTINCTION

Record whether close prior art is:

- peer-reviewed publication;
- public preprint;
- thesis/dissertation;
- conference proceedings;
- workshop notes;
- technical report;
- public lecture notes;
- MathOverflow/StackExchange discussion;
- private communication.

Publicly available mathematical results can defeat a literature-novelty claim even if they were never journal-published.

Private communication must be handled carefully:

- record permission before quoting;
- do not claim priority based on confidential information;
- treat it as a reason to seek clarification or external review.

---

# 48. GREY-LITERATURE SEARCH

For N3, after conventional literature search, perform a targeted search of:

- dissertations and theses;
- conference/workshop proceedings;
- technical reports;
- author webpages;
- public lecture notes;
- MathOverflow;
- mathematics StackExchange where relevant;
- archived preprints.

These sources do not all carry the same authority.

They may nevertheless reveal an existing theorem or terminology that redirects the primary-source search.

---

# 49. PROOF-ASSISTANT RULE

A proof assistant can materially strengthen correctness assurance.

It does **not** establish novelty.

Formal verification affects M-status, not N-status.

Similarly:

- SAT;
- SMT;
- computer algebra;
- exhaustive search;

can strengthen correctness evidence but cannot by themselves prove bibliographic novelty.

---

# 50. THE NOVELTY RED-TEAM MUST BE BLIND TO BRANDING

When possible, ask an external reviewer or an internal adversarial pass to evaluate the theorem **without project-specific vocabulary first**.

Provide:

- standard-form statement;
- proof;
- standard mathematical objects.

Only later reveal DDA/DLDA terminology.

This reduces anchoring around the belief that an unfamiliar name implies unfamiliar mathematics.

---

# 51. SEARCH-RESULT SOURCE HIERARCHY

For deciding mathematical equivalence, use this preference order:

1. original theorem/proof in primary paper or monograph;
2. authoritative later paper restating the theorem precisely;
3. Mathematical Reviews / zbMATH review;
4. scholarly survey;
5. thesis;
6. public technical note;
7. search snippet / aggregator / informal discussion.

Lower levels may identify leads.

They should not replace primary verification when the primary source is accessible.

---

# 52. NOVELTY-KERNEL HASH AND VERSIONING

At theorem freeze, save:

```text
THEOREM_ID:
VERSION:
DATE:
STANDARD_STATEMENT:
FOUNDATIONAL_SCOPE:
SHA256:
```

The hash should cover the plain-text theorem statement and hypotheses.

If the theorem changes substantively:

- increment the version;
- generate a new hash;
- restart the novelty-comparison phase for the changed part.

This creates a clean audit trail.

---

# 53. CONTRIBUTION-MAP REQUIREMENT

Every manuscript or final package must include an internal contribution map:

| Item | Known / New | N-status | Proof location | Prior-art comparison |
|---|---|---|---|---|
| Definition 1 | Known adaptation | N0 | — | ... |
| Lemma 2 | Routine | N0 | §... | ... |
| Theorem 3 | Claimed new | N3 | §... | ... |
| Corollary 4 | New consequence | N2/N3 | §... | ... |

This makes it impossible for introductory prose to blur known ingredients into the new contribution.

---

# 54. SPECIAL RULE FOR ENUMERATION FORMULAS

An enumeration theorem has three distinct possible novelty levels:

### Level A — known objects, known sequence, known formula
N0.

### Level B — known objects, apparently new derivation of known count
Usually N0 for theorem novelty; possibly a proof contribution.

### Level C — newly characterized class, count follows routinely
The characterization may be new; the count may be N0/N1 separately.

### Level D — genuinely new counting theorem
May reach N3 if the prior-art and equivalence gates pass.

Therefore each enumeration result must be audited separately from the structural theorem that produced it.

---

# 55. SPECIAL RULE FOR “CANONICAL,” “MINIMAL,” AND “EXACT”

These words are high-risk.

## Canonical

Specify the invariance/universal property making the object canonical.

## Minimal

Specify:

- the partial order or cost being minimized;
- whether the minimizer is unique;
- whether “minimal” or “minimum” is intended.

## Exact

Specify whether exact means:

- equality rather than bound;
- no over-approximation;
- exact enumeration;
- necessary-and-sufficient characterization.

Do not use these words rhetorically.

---

# 56. SPECIAL RULE FOR “NEW THEORY”

A single N3 theorem means:

> **the work contains new mathematics.**

It does not automatically justify:

> **“we created a new mathematical theory.”**

To call the framework itself a **new theory**, require all of:

1. at least one N3/N4 foundational result;
2. multiple interacting definitions/results that are not merely inherited;
3. a nontrivial internal problem structure;
4. at least one result that depends essentially on the framework rather than only standard translation;
5. evidence that the framework organizes results not naturally captured by a single existing standard object.

This is a stronger claim than “new theorem.”

---

# 57. FINAL N3 CHECKLIST — VERSION 3
## This checklist supersedes the N3 checklist in Version 2.

### Claim identity

- [ ] Novelty is assigned at claim level.
- [ ] A flagship claim is frozen.
- [ ] The standard, branding-free theorem statement is frozen.
- [ ] Foundational scope is frozen.
- [ ] The theorem statement has an ID, version, date, and hash.
- [ ] Priority dates are recorded.

### Mathematical validity

- [ ] Complete proof exists.
- [ ] Proof-dependency audit passes.
- [ ] The theorem is non-vacuous.
- [ ] The theorem is non-tautological.
- [ ] Hypotheses have been necessity-tested where feasible.
- [ ] Edge cases are checked.
- [ ] Natural isomorphism/relabeling tests pass.
- [ ] No weaker/reindexed version of a known stronger theorem implies it routinely.
- [ ] If a new invariant/framework is claimed, strict separation is proved.

### Computational reliability

- [ ] Exhaustive finite verification is performed where feasible.
- [ ] Small-case evidence is not presented as a general proof.
- [ ] Checker mutation/falsification tests pass.
- [ ] Shared-code risk is documented.
- [ ] An independent computational representation is used when reasonably feasible.
- [ ] Randomized tests, if any, have full seed/provenance records.
- [ ] Reproducibility package exists.

### Prior-art quality

- [ ] At least 30 mathematically distinct searches are logged.
- [ ] At least 15 directly relevant sources are inspected.
- [ ] At least four neighboring mathematical formulations are searched.
- [ ] Search saturation is reached.
- [ ] Primary sources are verified for closest predecessors.
- [ ] Exact theorem/page references are recorded.
- [ ] Backward citation chaining is complete for closest predecessors.
- [ ] Forward citation chaining is performed where available.
- [ ] Closest authors' related work is searched.
- [ ] Theses/preprints/proceedings/books are searched.
- [ ] Grey literature is searched selectively.
- [ ] Historical terminology is searched where relevant.
- [ ] Non-English terminology is searched where relevant and feasible.
- [ ] MSC-neighborhood search is performed where identifiable.
- [ ] OEIS/sequence fingerprint search is performed for enumeration claims.
- [ ] No attributed theorem relies only on a snippet or secondary summary.

### Equivalence attack

- [ ] Closest known theorem is identified.
- [ ] Difference matrix is complete.
- [ ] Routine derivation from closest known theorem has been attempted explicitly.
- [ ] Alternative-framework translations have been attempted.
- [ ] Parameter reindexing/duality/labeling normalization has been checked.
- [ ] No equivalent earlier theorem has been found.
- [ ] No routine derivation has been found.

### Claim discipline

- [ ] Claim provenance map is complete.
- [ ] Contribution map is complete.
- [ ] No N0 ingredient is described as new.
- [ ] “Exact,” “canonical,” “minimal,” “complete,” and similar words are theorem-backed.
- [ ] Open-problem language, if used, passed the open-problem gate.
- [ ] The novelty statement uses evidence-matched wording.
- [ ] The novelty assessment is marked revocable if earlier prior art is later discovered.

If any mandatory item is unchecked:

\[
\boxed{\text{THE CLAIM HAS NOT REACHED N3.}}
\]

---

# 58. UPDATED YES / NO RULE — VERSION 3

The yes/no question must identify its scope.

## Question A

> “Does this work contain new mathematics?”

- N0/N1/N2 for every substantive claim → **NO**
- at least one substantive flagship claim reaches N3/N4 → **YES**

## Question B

> “Is this entire framework/theory new mathematics?”

Answer **YES** only if the stronger framework-level requirements in Section 56 pass.

Otherwise:

\[
\boxed{\text{NO}}
\]

even if the work contains one genuinely new theorem.

---

# 59. VERSION 3 DEFINITION OF DONE

For the current project, the immediate target is **not**:

> prove every part of DLDA new.

The target is:

1. select one precise flagship claim;
2. make it mathematically correct;
3. prove it;
4. freeze it;
5. attack it through the Version 3 novelty process;
6. reach N3 for that claim.

At that point the justified statement becomes:

> **“Yes. This work contains new mathematics: specifically, [frozen theorem].”**

Everything else remains individually classified.

---

# 60. FINAL PRINCIPLE — VERSION 3

The strongest protection against false novelty is not more terminology and not more searches.

It is **traceability**.

At the end of the process we must be able to trace:

\[
\text{claim}
\to
\text{proof}
\to
\text{computational tests}
\to
\text{closest predecessor}
\to
\text{difference}
\to
\text{failed equivalence attacks}
\to
\text{novelty decision}.
\]

If any arrow is missing, the novelty claim is premature.

---

# 61. VERSION 4 — FINAL PROCESS-GAP AUDIT

Version 3 closed the major logical and bibliographic loopholes, but a further audit identified a different class of risk:

> **research-process bias can manufacture a convincing-looking theorem even when every individual proof and literature-search step is performed carefully.**

The remaining failure modes are:

1. trying many conjectures on the same finite data and reporting only the survivor;
2. evolving hypotheses until they fit every already-seen example;
3. searching only the exact successful theorem rather than its natural theorem family;
4. counting many papers from one citation lineage as broad prior-art coverage;
5. allowing internally generated DDA/DLDA documents to count as independent evidence;
6. failing to record which definitions are standard, adapted, or genuinely new;
7. allowing a checklist to substitute for final mathematical judgment;
8. making algorithmic or complexity claims without freezing an encoding/model;
9. letting title/abstract/conclusion language become stronger than the actual claim ledger;
10. continuing to revise the guardrails indefinitely without a concrete newly discovered failure mode.

Version 4 closes these gaps.

---

# 62. NECESSARY-BUT-NOT-SUFFICIENT CHECKLIST RULE

Passing every checkbox is **necessary** for N3.

It is not mechanically sufficient.

After the checklist passes, a final written decision must answer:

1. What exact mathematical content is claimed new?
2. What is the closest known theorem?
3. Why does that theorem not imply ours routinely?
4. What translation/equivalence attacks were attempted?
5. What is the strongest reason to believe the claim may still be known?
6. Why, despite that risk, is N3 justified?

The final decision must include an explicit adversarial paragraph titled:

> **BEST CASE AGAINST NOVELTY**

followed by:

> **REASON N3 STILL SURVIVES**

This prevents checklist gaming.

---

# 63. CANDIDATE-THEOREM REGISTRY

Every serious conjecture investigated must be registered, including failed ones.

Maintain:

| ID | Date | Statement | Discovery data used | Status | Counterexample / proof | Mutation from |
|---|---|---|---|---|---|---|

Statuses:

- PROPOSED;
- REFUTED;
- PROVED;
- KNOWN;
- ABANDONED;
- SUPERSEDED.

No failed conjecture may simply disappear.

## Purpose

If 200 candidate formulas were tried and one fits all explored cases, the survivor is less evidentially impressive than if it was predicted before testing.

Proof ultimately resolves correctness, but the registry remains important for:

- diagnosing overfitting;
- understanding how assumptions accumulated;
- preventing selective reporting;
- reconstructing the research path;
- assessing computational discovery claims.

---

# 64. DISCOVERY / VALIDATION SEPARATION

When computation is used to invent a conjecture, split finite instances into:

## Discovery region

Cases allowed to guide:

- definitions;
- conjecture shape;
- constants;
- exceptional cases;
- hypotheses.

## Validation region

Cases withheld until the conjecture statement is frozen.

Examples:

- discover on \(m\le3\), validate on \(m=4\);
- discover at \(q=2\), validate at \(q=3\);
- discover on one algebra family, validate on another natural family.

After validation is opened, it may no longer be treated as unseen.

If the conjecture changes, create a new version and, where feasible, identify a new validation region.

## Important limitation

Holdout validation is **not a proof**.

Its purpose is to detect theorem overfitting before proof and to strengthen computational maturity.

---

# 65. POST-SELECTION / THEOREM-MINING GUARD

If a theorem was selected after searching a large space of:

- formulas;
- invariants;
- constants;
- partitions;
- sequences;
- conjectures;

record that search space.

Do not describe the final observed finite pattern as independently predicted.

The mathematical theorem can still be fully valid once proved.

This guardrail concerns the honesty and diagnostic value of the empirical discovery process.

---

# 66. THEOREM-FAMILY CLOSURE ATTACK

Do not search only the exact frozen theorem.

Construct its **natural theorem family**.

For the flagship result, systematically examine:

- stronger conclusion;
- weaker conclusion;
- weaker hypotheses;
- stronger hypotheses;
- dual statement;
- contrapositive;
- quotient form;
- reconstruction form;
- representation form;
- counting form;
- optimization form;
- ordered/unordered form;
- labeled/unlabeled form;
- finite/infinite analogue where mathematically natural.

Then search the strongest natural nearby statements.

## Reason

A prior theorem may not match our exact statement because it proves something more general.

If a known result \(T^\ast\) implies our theorem \(T\),

\[
T^\ast\Rightarrow T,
\]

then \(T\) is N0 even if no paper states \(T\) verbatim.

---

# 67. TERMINOLOGY / TRANSLATION DICTIONARY

Maintain a living dictionary for the flagship theorem.

Example columns:

| Our term | Universal algebra | Combinatorics | Logic | Database/CSP | Older terminology |
|---|---|---|---|---|---|

For example:

| Our language | Possible standard language |
|---|---|
| sharing partition | equality pattern / variable identification |
| spectrum | family of ranges / image profile |
| exact kernel stratum | equality type / kernel class |
| frontier | maximal support antichain |

Every new synonym discovered during literature search is added to the dictionary and triggers targeted search if not already covered.

This artifact belongs in the novelty evidence folder.

---

# 68. INDEPENDENT-LINEAGE PRIOR-ART RULE

Fifteen papers from one research group or citation lineage do not constitute broad coverage.

For N3, the closest-area search should, where the literature permits, include at least **three substantially independent scholarly lineages**, meaning different author groups or communities not all merely restating one source.

Examples:

- universal-algebra line;
- finite-function/minor line;
- combinatorics/database/CSP line.

If the subject is so narrow that fewer independent lineages exist, document that explicitly.

This requirement concerns diversity of mathematical viewpoints, not a rigid author count.

---

# 69. SELF-REFERENCE FIREWALL

Internally generated materials do not count as external evidence of novelty.

The following may not be counted toward prior-art coverage or independent verification:

- earlier DDA/DLDA manuscripts;
- our own generated summaries;
- our own generated citations unless primary-verified;
- one verifier reusing theorem-specific helper code from another verifier;
- an LLM restating our theorem in different words.

They may be part of the research record.

They are not independent evidence.

---

# 70. DEFINITION-PROVENANCE LEDGER

Every important definition must be classified as:

- **STANDARD** — established object/definition;
- **STANDARD WITH NOTATIONAL ADAPTATION**;
- **COMBINATION OF KNOWN DEFINITIONS**;
- **NEW CANDIDATE DEFINITION**;
- **TEMPORARY RESEARCH DEFINITION**.

Template:

| Definition | Classification | Source / origin | Natural equivalence checked? | Used by flagship theorem? |
|---|---|---|---|---|

A new theorem may rely entirely on standard definitions.

That is often preferable.

A new definition receives no novelty credit merely for being new.

---

# 71. SOURCE-CORRECTION / ERRATA CHECK

For every closest primary source, check where reasonably possible for:

- errata;
- corrigenda;
- retractions;
- later corrections;
- later papers that strengthen or replace the theorem.

If a theorem used in the difference matrix was later corrected, compare against the corrected version.

Do not base a novelty distinction on a known typo or obsolete formulation.

---

# 72. MINIMAL-COUNTEREXAMPLE ARCHIVE

Whenever a conjecture or weakened hypothesis fails, preserve a small counterexample.

For each:

```text
COUNTEREXAMPLE_ID:
THEOREM_VERSION:
PARAMETERS:
OBJECT:
EXPECTED:
ACTUAL:
MINIMALITY_KNOWN?: YES/NO
DISCOVERY_METHOD:
DATE:
```

When feasible, minimize the counterexample.

Minimal counterexamples are valuable because they can:

- expose the exact missing hypothesis;
- suggest forbidden-pattern theorems;
- prevent old false conjectures from being resurrected;
- become publishable negative mathematics.

---

# 73. MANUSCRIPT CLAIM-AUDIT GATE

After the mathematics and novelty status are frozen, audit the final:

- title;
- abstract;
- introduction;
- contribution list;
- theorem captions;
- discussion;
- conclusion;
- cover letter.

Every novelty sentence must map to the contribution ledger.

Forbidden drift:

\[
\text{“Theorem X appears new”}
\]

becoming:

\[
\text{“We introduce an entirely new mathematics.”}
\]

unless the framework-level gate independently passes.

The final manuscript must never claim more novelty than the strongest frozen claim status allows.

---

# 74. CONDITIONAL COMPLEXITY-THEOREM GATE

If a future novelty claim concerns computational complexity, freeze:

1. the exact decision/function problem;
2. input representation;
3. size measure;
4. computational model;
5. whether numbers are unary/binary encoded;
6. parameters and parameterization;
7. promise conditions;
8. reduction notion;
9. deterministic/randomized setting.

A statement such as:

> “the problem is NP-hard”

is incomplete without a precise encoding and reduction framework.

For fixed-parameter claims specify:

- parameter;
- FPT/W-hierarchy convention;
- whether kernelization is claimed.

For counting claims specify the counting class/model where relevant.

---

# 75. CONDITIONAL ALGORITHMIC-RESULT GATE

If claiming a new algorithmic theorem, distinguish:

- mathematical correctness;
- asymptotic complexity;
- practical performance;
- novelty of algorithm;
- novelty of data structure.

Required:

- pseudocode or formal algorithm;
- proof of correctness;
- termination proof where nontrivial;
- complexity derivation;
- benchmark methodology only if empirical superiority is claimed.

Performance on selected examples is not an algorithmic theorem.

---

# 76. CONDITIONAL ASYMPTOTIC-CLAIM GATE

If claiming an asymptotic theorem, freeze the regime:

\[
n\to\infty,
\qquad
q\text{ fixed?},
\qquad
q=q(n)?,
\qquad
|A|\text{ fixed?}
\]

State all uniformity assumptions.

A formula valid for fixed \(q\) is not automatically uniform in growing \(q\).

Computational agreement at small \(n\) carries very weak evidential weight for asymptotics.

---

# 77. CONDITIONAL ENUMERATION-CONVENTION GATE

Before comparing enumeration formulas, freeze:

- labeled vs. unlabeled objects;
- ordered vs. unordered objects;
- isomorphism classes vs. raw objects;
- whether symmetries are quotiented;
- whether empty objects are included;
- indexing origin;
- parameter order.

Many apparently different sequences differ only by convention.

This gate supplements the OEIS and reindexing checks.

---

# 78. CONDITIONAL PROBABILISTIC / STATISTICAL GATE

If future mathematics introduces random structures or empirical probabilistic claims, specify:

- probability space;
- random-variable definitions;
- independence assumptions;
- asymptotic regime;
- conditioning;
- confidence/statistical interpretation if simulation is used.

Do not import probabilistic language such as:

- “almost surely”;
- “with high probability”;
- “expected”;

without a fully specified probability model.

---

# 79. EXTERNAL-REVIEWER INDEPENDENCE STANDARD

For N4, record the reviewer's relationship to the work.

Preferred reviewer:

- is mathematically competent in the closest area;
- is not a coauthor;
- did not invent the flagship theorem with us;
- has no direct incentive to validate the claim;
- receives the branding-free theorem first.

Record:

```text
REVIEW_DATE:
FIELD:
RELATIONSHIP_TO_PROJECT:
MATERIALS_SEEN:
NOVELTY_CHALLENGE:
CORRECTNESS_CHALLENGE:
MISSING_LITERATURE_SUGGESTED:
OUTCOME:
```

One supportive opinion does not prove novelty.

A substantive challenge is more valuable than praise.

---

# 80. EVIDENCE-IMMUTABILITY RULE

Once a theorem version enters final N3 assessment:

- do not overwrite its proof;
- do not overwrite its search ledger;
- do not overwrite its verification output;
- do not overwrite its difference matrix.

Create a new version instead.

Keep hashes for frozen evidence files.

This provides an audit trail showing what evidence supported the decision at that time.

---

# 81. ANTI-CHERRY-PICKING SUMMARY

Before N3, produce:

```text
NUMBER OF SERIOUS CONJECTURES TESTED:
NUMBER REFUTED:
NUMBER PROVED:
NUMBER FOUND KNOWN:
NUMBER ABANDONED:
NUMBER SUPERSEDED:

FLAGSHIP THEOREM CHOSEN BECAUSE:
```

The reason may be mathematical strength.

It may not falsely imply that the theorem was the only conjecture examined.

---

# 82. FINAL ADVERSARIAL REPLICATION TEST

Before N3, give the frozen theorem and definitions to a fresh reasoning pass that does **not** receive:

- the intended proof strategy;
- the novelty argument;
- the desired conclusion.

Its task is only:

1. try to find a counterexample;
2. try to derive the theorem from standard results;
3. identify ambiguous definitions;
4. identify hidden assumptions.

This is not independent human review.

It is an additional red-team layer.

Any substantive objection must be resolved and logged.

---

# 83. GUARDRAIL-COMPLETION META-RULE

The guardrails themselves should not evolve forever.

After Version 4, create a new guardrail version only when one of the following is true:

1. a **concrete failure mode** is discovered that Version 4 would not catch;
2. an N3/N4 assessment exposes an ambiguity in the rules;
3. an external expert identifies a materially missing novelty/correctness safeguard;
4. the project enters a fundamentally new kind of mathematics requiring a conditional gate not covered here.

Do **not** create Version 5 merely to:

- rephrase existing rules;
- add more arbitrary query counts;
- make the standard sound stricter without identifying a failure;
- add stylistic preferences.

Version 4 is therefore the **frozen core charter** unless a demonstrable gap appears.

---

# 84. VERSION 4 N3 CHECKLIST
## This supersedes all earlier N3 checklists.

## A. Claim identity

- [ ] Novelty is tracked claim-by-claim.
- [ ] One flagship claim is selected.
- [ ] Candidate-theorem registry includes all serious variants.
- [ ] Novelty kernel is frozen.
- [ ] Branding-free theorem statement is frozen.
- [ ] Natural theorem family has been generated and searched.
- [ ] Foundational scope is frozen.
- [ ] Enumeration/algorithm/complexity conventions are frozen where applicable.
- [ ] Theorem has ID, version, date, and hash.
- [ ] Priority dates are recorded.

## B. Mathematical correctness

- [ ] Complete proof exists.
- [ ] Proof dependency graph passes audit.
- [ ] Non-vacuity is established.
- [ ] Non-tautology is established.
- [ ] Hypotheses are audited.
- [ ] Counterexample pressure was performed.
- [ ] Minimal counterexamples are archived where found.
- [ ] Edge cases are covered.
- [ ] Natural symmetry/isomorphism tests pass.
- [ ] New-framework/invariant claims have strict separation where applicable.
- [ ] No hidden change of finite/infinite or algebraic scope occurs.

## C. Discovery-process integrity

- [ ] Discovery cases are identified.
- [ ] Validation cases were held out where computational discovery made this feasible.
- [ ] Post-selection search space is documented.
- [ ] Failed/superseded conjectures remain archived.
- [ ] Hypothesis debt is documented.
- [ ] No empirical survivor is misrepresented as pre-specified.

## D. Computational maturity

- [ ] Exhaustive finite checks were run where feasible.
- [ ] Small-case checks are not presented as general proof.
- [ ] Mutation/falsification tests show checker can reject false variants.
- [ ] Shared-code dependencies are documented.
- [ ] Independent oracle/representation is used where reasonably feasible.
- [ ] Randomized experiments have reproducibility metadata.
- [ ] Code/specification separation is respected.
- [ ] Reproducibility package is frozen and hashed.

## E. Prior-art coverage

- [ ] Search ledger meets numerical minimums.
- [ ] Search saturation reached.
- [ ] Terminology/translation dictionary is complete enough for the closest fields.
- [ ] At least four neighboring formulations were searched.
- [ ] Independent scholarly lineages were covered where the literature permits.
- [ ] Primary sources verified for closest predecessors.
- [ ] Exact theorem/page references recorded.
- [ ] Backward citations searched.
- [ ] Forward citations searched where available.
- [ ] Author snowballing completed.
- [ ] Books/surveys checked.
- [ ] Theses/preprints/proceedings checked.
- [ ] Grey literature checked selectively.
- [ ] Historical terminology checked where relevant.
- [ ] Non-English terminology checked where relevant and feasible.
- [ ] MSC neighborhoods checked where identifiable.
- [ ] OEIS fingerprinting completed for sequence/count claims.
- [ ] Errata/corrections checked for closest sources.
- [ ] No material prior-art statement relies only on a secondary snippet.

## F. Equivalence and strength attack

- [ ] Closest known theorem is explicitly named.
- [ ] Difference matrix is complete.
- [ ] Routine derivation attempt is written out.
- [ ] Stronger-known-theorem implication was tested.
- [ ] Parameter reindexing/renaming was tested.
- [ ] Dual/contrapositive/quotient/restriction forms were tested.
- [ ] Alternative-framework translations were tested.
- [ ] No equivalent earlier theorem was found.
- [ ] No routine derivation was found.

## G. Claim discipline

- [ ] Definition provenance ledger complete.
- [ ] Claim provenance ledger complete.
- [ ] Contribution map complete.
- [ ] Self-reference firewall respected.
- [ ] No N0 ingredient is described as new.
- [ ] High-risk words such as “exact,” “canonical,” “minimal,” “complete,” and “universal” are theorem-backed.
- [ ] Open-problem claims passed the dedicated gate.
- [ ] Manuscript claim audit passes.
- [ ] Novelty status is understood to be revocable.

## H. Final judgment

- [ ] BEST CASE AGAINST NOVELTY is written.
- [ ] REASON N3 STILL SURVIVES is written.
- [ ] Anti-cherry-picking summary is complete.
- [ ] Final adversarial replication pass is complete.
- [ ] Passing the checklist has not been treated as automatic proof of novelty.
- [ ] Final decision explicitly identifies the exact claim receiving N3.

If any mandatory item is unchecked:

\[
\boxed{\text{N3 HAS NOT BEEN REACHED.}}
\]

---

# 85. VERSION 4 DEFINITION OF DONE

The immediate project objective is reached when one frozen mathematical claim satisfies all Version 4 N3 gates.

Then the correct statement is:

> **“Yes. This work contains new mathematics, specifically [THEOREM ID and statement], to the best of the literature search and theorem-level comparison performed.”**

This does **not** imply that:

- DDA as a whole is new;
- DLDA as a whole is new;
- every definition is new;
- every corollary is new;
- the result is important enough for a full journal article;
- no equivalent unpublished result exists anywhere;
- novelty can never later be revised.

Those are separate claims.

---

# 86. VERSION 4 FINAL META-PRINCIPLE

A trustworthy novelty process must resist four different errors:

\[
\boxed{
\text{false theorem}
+
\text{known theorem}
+
\text{overfit conjecture}
+
\text{overstated claim}.
}
\]

Version 4 therefore requires four corresponding defenses:

\[
\text{proof audit}
+
\text{prior-art attack}
+
\text{discovery-process audit}
+
\text{claim audit}.
\]

Only when all four survive can a flagship result reach N3.

---

# 87. VERSION 5 — CLAIM-TYPE CORRECTION AND COMPUTER-ASSISTED PROOF SAFEGUARDS

Version 4 identified itself as the frozen core charter unless a concrete uncovered failure mode appeared.

A concrete failure mode has now been found.

## The Version 4 contradiction

Earlier sections correctly allowed the possibility that a **genuinely new proof method for a known theorem** could itself constitute new mathematics.

However, the Version 4 N3 checklist required:

> “No equivalent earlier theorem was found.”

Those requirements are incompatible.

A known theorem necessarily has an equivalent earlier theorem. Therefore Version 4 would automatically force every proof-method novelty claim to N0, even when the proof method itself was genuinely new.

That is a structural error in the novelty taxonomy.

Version 5 fixes it by making the novelty test explicitly **claim-type dependent**.

This section also closes two related gaps:

1. computer-assisted proofs need a stronger standard than ordinary computational “verification”;
2. unpublished folklore / standard-exercise status can defeat a novelty claim even when no formal paper states the theorem verbatim.

The rules below supersede every earlier rule that treats all novelty claims as theorem-novelty claims.

---

# 88. CLAIM-TYPE TAXONOMY — MANDATORY

Every substantive candidate novelty claim must be assigned exactly one primary claim type.

Use:

- **R — RESULT / THEOREM**
- **P — PROOF OR PROOF METHOD**
- **O — MATHEMATICAL OBJECT / FRAMEWORK**
- **E — ENUMERATION / CLASSIFICATION**
- **A — ALGORITHM / COMPLEXITY**
- **I — INVARIANT / REPRESENTATION**
- **X — APPLICATION**
- **S — SYNTHESIS / EXPOSITION**

A project may contain several claims of different types.

Each claim receives its own:

```text
CLAIM_ID:
CLAIM_TYPE:
STANDARD_FORM:
N_STATUS:
M_STATUS:
P_STATUS:
```

Novelty gates are evaluated against the mathematical content actually claimed.

---

# 89. TYPE R — NEW RESULT / THEOREM

This is the default theorem-novelty route.

A Type R claim reaches N3 only if:

1. the theorem is proved;
2. the theorem is not definitional or routine;
3. no earlier equivalent theorem is found;
4. no earlier stronger theorem routinely implies it;
5. no routine translation to an existing theorem is found;
6. prior-art saturation and theorem-level comparison pass;
7. the remaining Version 5 N3 requirements pass.

For Type R:

\[
\boxed{\text{Earlier equivalent theorem} \Rightarrow N0}
\]

unless the actual novelty claim is reclassified as Type P, A, I, or another appropriate type.

---

# 90. TYPE P — NEW PROOF OR PROOF METHOD

A Type P claim is explicitly allowed to concern a theorem that is already known.

Therefore:

\[
\boxed{
\text{known theorem}
\not\Rightarrow
\text{proof-method claim is N0}
}
\]

The novelty question is instead:

> Is the **proof method or proof architecture** itself mathematically new?

## Type P N3 requirements

A Type P claim must satisfy all of the following.

### P1. Known-proof census

Identify the main existing proof families for the theorem or theorem class.

Do not compare only against the original proof.

### P2. Method kernel

State precisely what is claimed new about the proof.

Examples:

- a new invariant;
- a new induction parameter;
- a new bijection;
- a new algebraic decomposition;
- a new probabilistic argument;
- a new local-to-global principle;
- a new proof transformation.

“Shorter” or “cleaner” is not a mathematical novelty kernel by itself.

### P3. Non-routine transformation test

Attempt to obtain the new proof from existing proofs by:

- reordering steps;
- simplifying notation;
- specializing an existing argument;
- replacing terminology;
- standard dualization;
- standard induction conversion;
- known proof compression.

If this works routinely, the proof-method claim is N0.

### P4. Mathematical consequence

For this project's “new mathematics” target, the proof method must do at least one substantive thing beyond aesthetic simplification:

- prove a stronger theorem;
- weaken hypotheses;
- yield a new corollary;
- unify multiple existing proofs nontrivially;
- extend to a new class;
- expose a new invariant/structure;
- lead to a new algorithm or bound;
- supply a reusable lemma/method with independent mathematical content.

### P5. Proof-method prior art

Search for the method independently of the target theorem.

A method can be old even if it has never before been applied to this theorem.

## Type P conclusion

An existing theorem can therefore have:

```text
THEOREM CLAIM: N0
PROOF-METHOD CLAIM: N3
```

In that case the work **contains new mathematics**, specifically the proof method, not the theorem statement.

---

# 91. TYPE O — NEW MATHEMATICAL OBJECT / FRAMEWORK

A new definition alone does not earn N3.

Type O requires:

1. the object is not routinely isomorphic/equivalent to an established object;
2. natural symmetry and representation attacks pass;
3. strict separation from the nearest existing object is proved;
4. at least one nontrivial theorem depends essentially on the new structure;
5. the theorem is not merely a translation of a theorem already known for an equivalent object;
6. the framework-level requirements of the earlier charter pass.

If an isomorphism to a known object is discovered, the Type O claim becomes N0.

Any theorems proved about it are re-assessed separately as Type R claims.

---

# 92. TYPE I — NEW INVARIANT / REPRESENTATION

A Type I claim reaches N3 only if:

1. the invariant is well-defined on the intended equivalence classes;
2. it survives natural relabelings/isomorphisms;
3. it is not a routine repackaging of a known invariant;
4. strict separation from weaker known invariants is shown where claimed;
5. at least one nontrivial theorem uses the invariant;
6. its discriminatory/classification/reconstruction power is proved rather than asserted;
7. closest known invariants are compared mathematically.

A different encoding of the same complete information is not automatically a new mathematical invariant.

---

# 93. TYPE E — ENUMERATION / CLASSIFICATION

Enumeration and classification remain distinct claims even when derived from a new structural theorem.

For Type E:

1. freeze the exact counted/classified objects and conventions;
2. normalize labeled/unlabeled and ordered/unordered conventions;
3. search OEIS and combinatorial databases where relevant;
4. compare generating functions, recurrences, and parameter changes;
5. search stronger known classifications;
6. determine whether the claimed formula is already a routine corollary of a known result.

Possible split:

```text
STRUCTURAL CHARACTERIZATION: N3
ENUMERATION FORMULA: N0
```

or the reverse.

Do not inherit novelty automatically between them.

---

# 94. TYPE A — ALGORITHM / COMPLEXITY

Implementation novelty alone does not count as new mathematics.

A Type A mathematical novelty claim requires a formal object such as:

- a new correctness theorem;
- a new complexity upper bound;
- a new lower bound;
- a new reduction;
- a new approximation guarantee;
- a new fixed-parameter result;
- a new exact algorithmic characterization.

Prior-art comparison must target the algorithmic theorem, not merely software packages.

If the only novelty is engineering speed on benchmarks, classify it as an engineering contribution, not new mathematics.

---

# 95. TYPE X — NEW APPLICATION

A genuinely new application of known mathematics can be valuable.

It does **not**, by itself, count as new mathematics for the YES/NO target.

Type X alone cannot reach the project's “contains new mathematics” threshold.

It can support publication significance.

If the application forces a new theorem, invariant, algorithmic bound, or proof method, create a separate R/I/A/P claim and assess that claim independently.

---

# 96. TYPE S — SYNTHESIS / EXPOSITION

A new synthesis can be intellectually useful and publishable.

It does not count as new mathematics merely because:

- the connection was not previously emphasized;
- several fields are presented together;
- the notation is unified;
- examples are reorganized.

A synthesis contains new mathematics only when a separately registered R/P/O/I/E/A claim reaches N3.

---

# 97. CLAIM-TYPE-SPECIFIC PRIOR-ART RULE

The phrase:

> “No equivalent earlier theorem was found”

is mandatory only for **Type R theorem novelty** and theorem-like Type E/A claims where the theorem statement itself is claimed new.

For other types, substitute the correct question.

## Type P

> Was the proof method already known, either for this theorem or elsewhere?

## Type O

> Is the object already known up to a natural equivalence/isomorphism?

## Type I

> Is the invariant already known up to information-equivalent transformation?

## Type E

> Is the enumeration/classification already known under another convention or parameterization?

## Type A

> Is the algorithmic theorem/bound/reduction already known?

This rule supersedes every earlier blanket N3 checkbox requiring “no equivalent earlier theorem” regardless of claim type.

---

# 98. UPDATED N0 RULE

N0 means:

> **the specific mathematical content claimed as novel is already known or routinely derivable.**

It does not mean:

> “some surrounding theorem is known.”

Examples:

### Example 1

Known theorem, genuinely new proof method:

```text
R1 theorem statement = N0
P1 proof method = potentially N3
```

### Example 2

Known object, new theorem:

```text
O1 object = N0
R1 theorem = potentially N3
```

### Example 3

New structural theorem, routine count:

```text
R1 characterization = potentially N3
E1 enumeration = N0
```

This is the required granularity.

---

# 99. FOLKLORE / STANDARD-EXERCISE GATE

A theorem can fail to be meaningfully novel even when no journal paper states it verbatim.

Possible reasons:

- it is standard folklore;
- it is a common exercise;
- experts routinely derive it from a standard theorem;
- it appears in lecture notes/problem sets under informal status;
- it is considered an immediate lemma in the field.

For N3, search where relevant:

- textbooks;
- monographs;
- graduate lecture notes;
- problem sets;
- MathOverflow;
- expert expository notes.

For N4, explicitly ask the external reviewer:

> “Is this result or proof method standard folklore or an exercise-level consequence in this field?”

If the answer is yes and no substantive new idea remains, classify the affected claim N0.

Absence from formal literature is not enough.

---

# 100. COMPUTER-ASSISTED PROOF GATE

Version 4 distinguished computational verification from proof, but it did not fully specify what happens when computation is **part of the proof itself**.

If any theorem depends logically on a finite computation, search, SAT/SMT result, computer algebra calculation, interval computation, or exhaustive enumeration, classify it as a **computer-assisted proof** and apply this gate.

## Required proof record

Document:

```text
COMPUTER_ASSISTED: YES
ROLE_OF_COMPUTATION:
FINITE_DOMAIN_PROVED:
TRUSTED_COMPUTING_BASE:
EXACT_OR_APPROXIMATE_ARITHMETIC:
CERTIFICATE_AVAILABLE:
INDEPENDENT_CHECKER:
REPRODUCTION_COMMAND:
SOFTWARE_VERSIONS:
HARDWARE_DEPENDENCE:
```

## Exact arithmetic rule

If the claimed proof is discrete/exact, use exact arithmetic wherever possible.

Floating-point equality is not a proof of exact combinatorial or algebraic equality.

## Rigorous numerical rule

If numerical approximation is unavoidable, use mathematically validated error bounds such as:

- interval arithmetic;
- exact rational enclosures;
- certified root isolation;
- proof certificates.

A floating-point experiment without rigorous enclosure remains evidence, not proof.

## Certificate preference

Prefer a proof-producing computation where the expensive search emits a certificate that a much smaller trusted checker can verify.

Examples include:

- SAT unsatisfiability certificates;
- independently checkable combinatorial witnesses;
- exact count tables with reproducible hashes;
- formal proof objects where available.

## Trusted computing base

List what must be trusted:

- language runtime;
- libraries;
- solver;
- certificate checker;
- operating assumptions.

The objective is to make the trusted core as small as reasonably practical.

---

# 101. COMPUTER-ASSISTED PROOF VS COMPUTATIONAL VERIFICATION

Use these labels precisely.

## Computational verification

A program checks many or all small examples, but the human proof of the general theorem does not depend on the computation.

This strengthens M-status.

## Computer-assisted proof

The theorem is not established without the machine computation.

Then the machine calculation is part of the proof and must satisfy Section 100.

Do not call the first “proof.”

Do not treat the second as ordinary empirical testing.

---

# 102. EXHAUSTIVE FINITE THEOREM RULE

If the stated theorem concerns one explicitly finite universe, an exhaustive computation can be the proof **provided**:

1. every object in the stated universe is enumerated;
2. enumeration completeness is proved or transparently obvious from the representation;
3. the predicate checked is exactly the theorem predicate;
4. exact computation is used;
5. the program passes mutation/falsification tests;
6. an independent checker/certificate exists where reasonably feasible.

Then the mathematical proof is:

\[
\text{complete finite enumeration}.
\]

This does not extend the theorem beyond that finite universe.

---

# 103. PROOF-CONTENT CLAIM LEDGER

When a known theorem is reproved, separate claims:

| Claim | Type | Status |
|---|---|---|
| Theorem statement | R | N0 |
| New lemma used in proof | R | N? |
| Proof architecture | P | N? |
| Resulting stronger corollary | R | N? |
| New algorithm extracted | A | N? |

This prevents proof novelty from being hidden inside theorem novelty or vice versa.

---

# 104. UPDATED YES / NO DECISION

The governing question remains:

> **Does this work contain new mathematics?**

Answer YES if at least one mathematically substantive claim of type:

\[
R,\ P,\ O,\ I,\ E,\ \text{or }A
\]

reaches N3 or N4.

Type X application novelty and Type S synthesis novelty do not, by themselves, make the answer YES.

## Stronger question

> **Is the main theorem itself new?**

Answer using the N-status of the Type R theorem claim only.

## Stronger framework question

> **Is DLDA itself a new mathematical theory/framework?**

Answer using the Type O/framework-level status and the earlier framework requirements.

These questions may legitimately have different answers.

---

# 105. VERSION 5 N3 CHECKLIST — CLAIM-TYPE-AWARE
## This supersedes every earlier N3 checklist where there is a conflict.

## Universal requirements for every N3 claim

- [ ] Claim ID and claim type assigned.
- [ ] Standard branding-free novelty kernel frozen.
- [ ] Foundational scope frozen.
- [ ] Complete mathematical justification exists.
- [ ] Non-vacuity passes.
- [ ] Non-tautology passes.
- [ ] Natural symmetry / representation attacks pass.
- [ ] Discovery-process integrity requirements pass where applicable.
- [ ] Primary-source prior-art verification passes.
- [ ] Search saturation is reached.
- [ ] Terminology dictionary and neighboring-framework search are complete enough.
- [ ] Closest prior mathematical content is identified.
- [ ] The appropriate claim-type routine-derivation/equivalence attack passes.
- [ ] Folklore / standard-exercise risk is assessed.
- [ ] Computational evidence is correctly classified as verification or proof.
- [ ] Computer-assisted proof gate passes if computation is part of the proof.
- [ ] Claim provenance and contribution maps are complete.
- [ ] BEST CASE AGAINST NOVELTY is written.
- [ ] REASON N3 STILL SURVIVES is written.
- [ ] Final adversarial replication pass is complete.

## Additional Type R requirements

- [ ] No earlier equivalent theorem found.
- [ ] No earlier stronger theorem routinely implies it.
- [ ] The theorem is not a routine specialization/dual/translation.

## Additional Type P requirements

- [ ] Existing proof families are surveyed.
- [ ] The new proof-method kernel is explicit.
- [ ] Method is not a routine transformation of a known proof.
- [ ] Method has substantive mathematical consequences beyond cosmetic simplification.
- [ ] Method itself is searched across other theorem areas.

## Additional Type O requirements

- [ ] No natural equivalence/isomorphism to an established object defeats the object claim.
- [ ] Strict separation is proved.
- [ ] At least one theorem depends essentially on the new structure.

## Additional Type I requirements

- [ ] Invariant is structural on the intended equivalence classes.
- [ ] Information-equivalence with known invariants is tested.
- [ ] Nontrivial discriminatory/reconstruction/classification power is proved.

## Additional Type E requirements

- [ ] Counting/classification conventions are frozen.
- [ ] OEIS/sequence and parameter-normalization searches pass.
- [ ] Enumeration/classification is not merely inherited routinely from a known theorem unless the actual new claim is elsewhere.

## Additional Type A requirements

- [ ] Formal computational problem/algorithm is frozen.
- [ ] Correctness is proved.
- [ ] Complexity/bound/reduction model is precise.
- [ ] Algorithmic prior art is searched at theorem level.

If the applicable boxes are not all checked:

\[
\boxed{\text{THE CLAIM IS NOT N3.}}
\]

---

# 106. UPDATED EVIDENCE PACKAGE

Add the following files to the Version 4 novelty evidence package:

```text
15_claim_type.md
16_proof_content_ledger.md
17_folklore_exercise_check.md
18_computer_assisted_proof_record.md   # if applicable
19_known_proof_family_comparison.md    # Type P
```

The `15_claim_type.md` file must state why the selected claim type is correct.

---

# 107. VERSION 5 STATUS OF THE CURRENT DDA / DLDA PROJECT

At the current checkpoint, the main candidates are primarily:

- Type R — realizability characterization;
- Type E — fiber enumeration;
- Type I — synchronization/range-spectrum invariants;
- possibly Type O — framework claim, but only if strict framework-level novelty survives.

They remain individually below N3 until the full claim-type-appropriate prior-art audit is completed.

The fact that known identification-minor theory exists does not automatically settle every Type R/E/I claim.

Conversely, finding one genuinely new Type R theorem would not automatically make the entire Type O “DLDA theory” claim new.

---

# 108. VERSION 5 META-RULE

Version 5 restores the intended frozen-core principle.

Create Version 6 only if a **specific failure mode** is found that:

1. can realistically cause a false novelty or false correctness decision; and
2. is not already covered by Version 5.

Do not create another version merely for additional strictness or stylistic refinement.

---

# 109. VERSION 5 FINAL PRINCIPLE

The novelty question must always be asked at the correct level.

A work can simultaneously contain:

\[
\boxed{
\begin{aligned}
&\text{known object},\\
&\text{known theorem},\\
&\text{new proof},\\
&\text{new corollary},\\
&\text{known enumeration},\\
&\text{new application}.
\end{aligned}
}
\]

There is no contradiction.

The guardrails must identify **which mathematical content is actually new**, rather than forcing the whole project into one undifferentiated label.

That claim-level precision is now mandatory.

---

# 110. VERSION 6 — ANTI-TYPE-SHOPPING AND EXTERNAL-DEPENDENCY INTEGRITY

Version 5 corrected an important category error by making novelty claim-type aware.

A further audit found two concrete loopholes not adequately covered by Version 5:

1. **type shopping** — a hybrid claim could be assigned whichever single claim type has the easiest novelty gate;
2. **external-proof dependency drift** — a proof could look complete while using a known theorem outside its actual hypotheses or in a stronger form than the cited source proves.

Either failure can produce a false N3 decision.

Version 6 fixes both.

It also strengthens formal-proof integrity and computational specification traceability where those methods are used.

These rules supersede every earlier instruction that says a claim must have exactly one novelty type or that treats citation correctness only as a prior-art issue.

---

# 111. MULTI-TYPE CLAIM TAXONOMY

A claim has:

- exactly one **PRIMARY TYPE** for organization; and
- zero or more **SECONDARY APPLICABLE TYPES**.

Allowed types remain:

- R — RESULT / THEOREM
- P — PROOF OR PROOF METHOD
- O — MATHEMATICAL OBJECT / FRAMEWORK
- E — ENUMERATION / CLASSIFICATION
- A — ALGORITHM / COMPLEXITY
- I — INVARIANT / REPRESENTATION
- X — APPLICATION
- S — SYNTHESIS / EXPOSITION

Example:

```text
CLAIM_ID: C17
PRIMARY_TYPE: R
SECONDARY_TYPES: E, I
```

means the claim is principally a theorem, but it also substantively contains enumeration/classification and invariant content.

## Governing rule

\[
\boxed{
\text{ALL substantively applicable type-specific gates must pass.}
}
\]

The primary type does not exempt the claim from secondary-type safeguards.

---

# 112. ANTI-TYPE-SHOPPING GATE

Before novelty assessment, answer for every claim:

1. Does the conclusion give an exact count or classification?
2. Does it define or rely on a claimed new invariant?
3. Does it claim a new object/framework?
4. Does it claim an algorithm, complexity result, or reduction?
5. Does it claim a new proof method?
6. Is the mathematical novelty only in an application?
7. Is it primarily synthesis/exposition?

If the answer is YES, add the corresponding type unless the feature is purely incidental.

## Forbidden behavior

A claim may not be labeled Type R merely to avoid:

- OEIS checks required by Type E;
- invariant-equivalence checks required by Type I;
- object-equivalence checks required by Type O;
- computational-model precision required by Type A.

Likewise, a claim may not be labeled Type I or O to evade the earlier-equivalent-theorem test when its actual novelty kernel is a theorem.

## Type audit record

Add:

```text
TYPE_AUDIT:
  R: applicable / not applicable — reason
  P: applicable / not applicable — reason
  O: applicable / not applicable — reason
  E: applicable / not applicable — reason
  A: applicable / not applicable — reason
  I: applicable / not applicable — reason
  X: applicable / not applicable — reason
  S: applicable / not applicable — reason
```

Any disputed type classification blocks N3 until resolved.

---

# 113. COMPOSITE-CLAIM SPLITTING RULE

When one sentence contains several mathematically separable contributions, split it into separate claims.

Bad:

> “We introduce invariant \(J\), prove it completely characterizes class \(C\), and derive the first exact enumeration formula.”

This contains at least:

- I-claim: invariant \(J\);
- R-claim: characterization theorem;
- E-claim: enumeration theorem.

Register them separately.

Then record logical dependencies:

\[
I_1 \to R_2 \to E_3.
\]

Novelty does not automatically propagate along this chain.

Possible outcome:

```text
I1 = N0
R2 = N3
E3 = N0
```

This is valid.

---

# 114. NOVELTY-INHERITANCE PROHIBITION

The following inferences are forbidden:

\[
\text{new definition}
\Rightarrow
\text{new theorem},
\]

\[
\text{new theorem}
\Rightarrow
\text{new corollary},
\]

\[
\text{new characterization}
\Rightarrow
\text{new enumeration},
\]

\[
\text{new proof}
\Rightarrow
\text{new theorem statement},
\]

\[
\text{new application}
\Rightarrow
\text{new mathematics}.
\]

Every substantive claim receives its own novelty assessment.

Dependencies can explain how claims are proved.

They cannot transfer N-status automatically.

---

# 115. EXTERNAL MATHEMATICAL DEPENDENCY GATE

The correctness audit must cover not only our new proof steps but also every nontrivial external theorem used by the proof.

For every imported result \(T\), record:

```text
DEPENDENCY_ID:
SOURCE:
THEOREM_NUMBER_OR_EXACT_LOCATION:
STATEMENT_AS_PUBLISHED:
HYPOTHESES_AS_PUBLISHED:
HOW_USED_HERE:
HYPOTHESES_MATCH?: YES/NO
STRENGTHENED_BEYOND_SOURCE?: YES/NO
PRIMARY_SOURCE_VERIFIED?: YES/NO
```

## Pass condition

Every external dependency must satisfy one of:

1. it is a truly standard elementary fact whose exact form is uncontroversial; or
2. the source and hypotheses have been verified.

If an imported theorem is used outside its hypotheses:

\[
\boxed{\text{THE PROOF FAILS UNTIL REPAIRED.}}
\]

If a source proves only:

\[
A\Rightarrow B
\]

but the manuscript uses:

\[
A'\Rightarrow B'
\]

with stronger \(B'\) or weaker \(A'\), that difference requires a separate proof.

It may not be silently attributed to the source.

---

# 116. EXTERNAL-DEPENDENCY SCOPE MATCHING

For every nontrivial imported theorem, compare at least:

- finite vs. infinite domain;
- labeled vs. unlabeled objects;
- ordered vs. unordered structures;
- total vs. partial functions;
- commutative vs. noncommutative assumptions;
- finite arity vs. arbitrary arity;
- classical vs. constructive logic where material;
- exact vs. asymptotic statement;
- deterministic vs. randomized setting;
- simple vs. multiple edges/relations where relevant;
- field/ring/group assumptions;
- characteristic restrictions.

A theorem is not transferable merely because the notation looks similar.

---

# 117. EXTERNAL-DEPENDENCY VERSION LOCK

When the proof reaches M3 or higher, freeze the exact external references used.

Record:

- paper/book version;
- preprint revision or journal version;
- theorem number;
- access date;
- DOI/arXiv identifier where applicable.

If the source later changes materially, re-check the dependency.

If a journal version differs from a preprint on a hypothesis relevant to us, the proof audit must say which version is being used and why.

---

# 118. DERIVED-LEMMA ORIGIN RULE

If a supporting lemma is obtained by combining known results, explicitly distinguish:

- **quoted theorem**;
- **routine derived lemma**;
- **new supporting lemma**.

A derived lemma is not “known from source X” unless source X actually states it.

Use wording such as:

> “By Theorem 4 of X together with standard fact Y, we obtain Lemma 2.”

This matters both for correctness and novelty.

A derived lemma can itself become a novelty candidate if the combination is non-routine.

---

# 119. PROOF-DEPENDENCY TRANSITIVE AUDIT

The proof dependency graph must include:

\[
\text{our theorem}
\to
\text{our lemmas}
\to
\text{external theorems}
\to
\text{critical external hypotheses}.
\]

For critical nonstandard dependencies, inspect one level deeper when the cited theorem itself invokes a convention or definition that affects applicability.

This does not require re-proving all of mathematics.

It requires tracing every place where a mismatch could invalidate our argument.

---

# 120. FORMAL-PROOF INTEGRITY GATE
## Conditional: applies if Lean, Coq, Isabelle, HOL, Agda, Metamath, or another proof assistant is used as evidence.

Record:

```text
PROOF_ASSISTANT:
VERSION:
KERNEL:
IMPORTED_LIBRARIES:
NONSTANDARD_AXIOMS:
CLASSICAL_AXIOMS:
CHOICE_AXIOMS:
QUOTIENT_AXIOMS:
UNSAFE_FEATURES:
ADMITS_SORRIES_HOLES:
BUILD_COMMAND:
CHECKED_COMMIT:
```

## Mandatory rules

- No unresolved `sorry`, `admit`, hole, or equivalent may occur in the proof of an N3 theorem.
- Any nonstandard axiom must be disclosed.
- Any trusted external oracle/plugin that can introduce theorem objects must be disclosed.
- The exact project/library versions must be frozen.
- The theorem statement checked by the assistant must match the frozen human-readable statement.

## Interpretation

Formal proof strengthens M-status.

It does not establish N-status.

A formally verified known theorem remains N0 as a Type R claim.

---

# 121. FORMALIZATION-STATEMENT EQUIVALENCE GATE

A formal theorem can prove the wrong statement perfectly.

Therefore, when formal proof is used, produce a correspondence table:

| Human concept | Formal symbol/type | Notes |
|---|---|---|
| partition | ... | ... |
| refinement | ... | orientation checked |
| spectrum | ... | ... |
| realizable | ... | ... |

Then state:

> **FORMAL STATEMENT MATCH CHECK**

and verify:

1. quantifier order;
2. equality/containment directions;
3. strict/non-strict inequalities;
4. finite/infinite restrictions;
5. empty-case handling;
6. indexing conventions;
7. assumptions imported through typeclasses/locales.

A kernel-checked proof of a mistranslated theorem does not establish the intended theorem.

---

# 122. COMPUTATIONAL SPECIFICATION TRACEABILITY

For every serious computational verifier, maintain a mapping from the frozen mathematical statement to code.

Template:

| Mathematical object/condition | Code location | Independent cross-check |
|---|---|---|
| partition refinement | function/file:line | second representation |
| novelty layer | ... | ... |
| capacity inequality | ... | ... |
| fiber formula | ... | ... |

The verifier must not contain undocumented extra assumptions.

The verifier must not omit a quantified case from the mathematical theorem.

This gate supplements the earlier code/specification separation rule.

---

# 123. EXHAUSTIVE-ENUMERATION COMPLETENESS CERTIFICATE

If a computational claim says:

> “all objects of size \(n\) were checked,”

record a completeness argument.

At minimum:

1. mathematical count of the universe;
2. program-generated count;
3. equality check;
4. duplicate policy;
5. symmetry quotient policy if any.

Example:

\[
|A|^{|D|^m}
\]

is the mathematical number of maps \(D^m\to A\).

The program must account for exactly that many raw maps unless a proved symmetry reduction is used.

If symmetry reduction is used, prove every orbit is represented.

---

# 124. SYMMETRY-REDUCTION PROOF GATE

Optimization by quotienting symmetries can silently remove counterexamples.

Whenever enumeration uses:

- coordinate permutations;
- output relabeling;
- selector relabeling;
- graph isomorphism;
- canonical representatives;

prove:

1. the tested property is invariant under the symmetry;
2. every equivalence class has a representative;
3. canonicalization does not merge inequivalent objects.

Otherwise use raw exhaustive enumeration.

---

# 125. IMPORTED-DATA INTEGRITY
## Conditional: applies when a theorem or experiment depends on an external mathematical dataset, database, catalogue, or generated corpus.

Record:

- source;
- version/date;
- exact extraction query;
- completeness assumptions;
- preprocessing;
- exclusions;
- checksum/hash;
- known missing records.

A result conditioned on an incomplete catalogue must not be described as an unconditional classification theorem.

---

# 126. CONDITIONAL CLASSIFICATION-COMPLETENESS GATE

If claiming a complete classification, there are two obligations:

## Soundness

Every listed object really belongs to the class.

## Completeness

Every object in the class is represented by the list/parameterization.

A classification theorem must therefore include both:

\[
\text{constructed objects}\subseteq\text{target class}
\]

and

\[
\text{target class}\subseteq\text{constructed objects}.
\]

If classification is “up to isomorphism,” the isomorphism relation and duplicate-elimination argument must be explicit.

This gate is especially important for hybrid R/E claims.

---

# 127. CONDITIONAL BIJECTION GATE

If an enumeration proof uses a bijection, verify separately:

- well-definedness;
- injectivity;
- surjectivity;
- inverse map;
- preservation of all parameters being counted.

A map that merely preserves cardinality in tested examples is not a proved bijection.

If the bijection itself is claimed new, register it as a Type P/R/I candidate as appropriate.

---

# 128. CONDITIONAL GENERATING-FUNCTION GATE

For generating-function claims, freeze:

- ordinary vs. exponential generating function;
- coefficient indexing;
- formal vs. analytic interpretation;
- convergence assumptions if analytic steps are used.

Coefficient checks at small order are verification only.

Any analytic continuation, singularity analysis, or asymptotic extraction requires its own hypotheses.

---

# 129. CONDITIONAL “EXACT CHARACTERIZATION” GATE

When claiming:

\[
X\iff C_1,\ldots,C_k,
\]

audit each condition for:

- necessity;
- sufficiency;
- independence/redundancy where claimed;
- domain restrictions.

If one condition follows from the others, the characterization can still be correct, but do not call the conditions “minimal” or “independent.”

If minimality of conditions is claimed, provide for every \(C_i\) a witness satisfying all other conditions but violating \(C_i\).

---

# 130. CONDITIONAL “FIRST” / “ONLY” / “UNIQUE” HISTORICAL CLAIM GATE

Mathematical theorem novelty and historical superlatives are different claims.

Statements such as:

- “the first”;
- “the only known”;
- “never previously studied”;
- “the first exact formula”;

require a stronger historical search than:

> “this theorem appears new.”

Default rule:

\[
\boxed{\text{DO NOT USE HISTORICAL SUPERLATIVES.}}
\]

Prefer:

> “We did not locate an earlier equivalent result in the search described.”

---

# 131. N3 DECISION MUST SPECIFY CLAIM TYPES

The final N3 statement must look like:

```text
CLAIM_ID: R-004
PRIMARY_TYPE: R
SECONDARY_TYPES: E
N_STATUS: N3

NEW MATHEMATICAL CONTENT:
[precise statement]

TYPE-SPECIFIC GATES PASSED:
R: YES
E: YES
```

A bare:

> “DLDA is N3”

is invalid.

---

# 132. VERSION 6 EVIDENCE-PACKAGE ADDITIONS

Add:

```text
20_type_audit.md
21_external_dependency_ledger.md
22_dependency_scope_check.md
23_external_reference_lock.md
24_formal_proof_integrity.md          # if applicable
25_formal_statement_match.md          # if applicable
26_code_spec_traceability.md          # if applicable
27_enumeration_completeness.md        # if applicable
28_symmetry_reduction_proof.md        # if applicable
29_imported_data_integrity.md          # if applicable
```

---

# 133. VERSION 6 N3 CHECKLIST
## This supersedes the Version 5 checklist where expanded below.

### Claim typing

- [ ] Primary claim type assigned.
- [ ] All substantive secondary types assigned.
- [ ] Type audit completed.
- [ ] No type-shopping route remains.
- [ ] Composite claims have been split where mathematically separable.
- [ ] Novelty has not been inherited automatically between dependent claims.

### Proof integrity

- [ ] Complete proof exists.
- [ ] Every nontrivial external mathematical dependency is identified.
- [ ] External hypotheses match our use.
- [ ] No cited theorem is silently strengthened.
- [ ] External source versions are locked.
- [ ] Derived lemmas are labeled as derived rather than directly sourced.
- [ ] Transitive critical dependency audit passes.
- [ ] Formal-proof integrity gate passes if applicable.
- [ ] Formal/human statement correspondence passes if applicable.

### Computational integrity

- [ ] Code/spec traceability exists where computation is significant.
- [ ] Exhaustive-universe completeness count is verified where applicable.
- [ ] Symmetry reductions are proved safe where applicable.
- [ ] Imported mathematical datasets are versioned and checked where applicable.
- [ ] Earlier mutation, oracle-diversity, reproducibility, and exact-arithmetic gates pass.

### Type-specific novelty

- [ ] Every applicable type-specific N3 gate passes, not only the primary type's gates.
- [ ] Closest prior art has been searched for each substantive novelty component.
- [ ] Historical superlatives are avoided unless separately justified.

### Final decision

- [ ] Exact claim ID is named.
- [ ] Primary and secondary claim types are named.
- [ ] NEW MATHEMATICAL CONTENT is stated exactly.
- [ ] BEST CASE AGAINST NOVELTY is included.
- [ ] REASON N3 STILL SURVIVES is included.
- [ ] The answer “YES” is limited to the claim(s) that actually reached N3/N4.

If any applicable item is unchecked:

\[
\boxed{\text{THE CLAIM HAS NOT REACHED N3.}}
\]

---

# 134. VERSION 6 META-RULE

Create Version 7 only if a specific realistic failure mode is found that Version 6 does not catch.

Potential future mathematical areas may require conditional modules, but the core charter should not be rewritten merely for more strictness.

Version 6 is intended to be operationally complete for the current DDA/DLDA research program.

---

# 135. VERSION 6 FINAL PRINCIPLE

There are now two independent ways a novelty process can be gamed:

1. **claim shopping** — choosing which result to advertise;
2. **type shopping** — choosing which novelty category gives the easiest test.

The charter already controls claim shopping through the candidate registry and anti-cherry-picking rules.

Version 6 controls type shopping through mandatory multi-type auditing.

At the same time, mathematical correctness must propagate through the entire dependency chain:

\[
\boxed{
\text{flagship theorem}
\to
\text{supporting lemmas}
\to
\text{external results}
\to
\text{their actual hypotheses}.
}
\]

A novelty claim is only as sound as the mathematics beneath it.
