# AGENT_X — Remove Orphan Harvested Capability and Strengthen Production-Necessity Gate

## Objective

Correct the architectural problem introduced by commit:

`1a0fd70ac01ca1a23670e61963d644b6a280cf07`

The issue is **not** that the added crossover code is syntactically bad or placeholder code. The issue is that Agent_X appears to have promoted a harvested idea into a new production capability without proving that Agent_X actually needs, owns, or executes that capability.

The target state is:

```text
harvested evidence
    ↓
mechanism extraction
    ↓
compare with existing canonical capabilities
    ↓
prove a real Agent_X runtime need
    ↓
patch existing canonical owner
        OR
create a new canonical capability only when no owner exists
    ↓
behavioral/runtime verification
    ↓
canonical promotion
```

The system must explicitly reject this anti-pattern:

```text
1 harvested record
    ↓
interesting algorithm
    ↓
new production .py file
    ↓
new tests
    ↓
declare the new file its own canonical owner
```

Good code that Agent_X does not need is still production slop.

---

# 1. Audit the Exact Commit

Audit every production and test change introduced by:

`1a0fd70ac01ca1a23670e61963d644b6a280cf07`

Pay particular attention to:

```text
tools/agentx_evolve/harvested_algorithms/fitness_weighted_crossover.py
tools/agentx_evolve/harvested_algorithms/test_fitness_weighted_crossover.py
tools/agentx_evolve/harvested_algorithms/__init__.py
tools/agentx_evolve/collective_core/write_code_e2e.py
```

Also inspect every other file touched by the commit.

Do not assume the previous review is correct. Verify all conclusions directly from the repository.

---

# 2. Determine Whether `fitness_weighted_crossover` Has a Real Production Consumer

Search the entire repository for:

- imports of `fitness_weighted_crossover`
- imports of `blend_parents`
- imports of `rank_weights`
- calls to either function
- references from evolution/runtime/orchestration code
- registry or manifest consumers
- dynamic imports
- capability lookup by name
- tests that simulate a real runtime caller
- configuration that activates this capability
- any execution path from Agent_X runtime into this module

Distinguish:

```text
REAL_PRODUCTION_CONSUMER
TEST_ONLY_REFERENCE
EXPORT_ONLY_REFERENCE
ROUTING_ONLY_REFERENCE
REGISTRY_ONLY_REFERENCE
DOCUMENTATION_ONLY_REFERENCE
NO_REFERENCE
```

A module exporting itself through `__init__.py`, appearing in routing metadata, or being referenced by its own tests does **not** count as a real production consumer.

A genuine consumer must demonstrate that an existing Agent_X subsystem actually invokes the behavior for useful work.

---

# 3. Compare Against Existing Canonical Evolution Capabilities

Before preserving or deleting the module, inspect the existing evolution subsystem for overlapping or adjacent behavior.

At minimum inspect:

- mutation logic
- adaptive mutation
- selection/ranking
- recombination/crossover
- genome/vector blending
- candidate scoring
- evolutionary scheduling
- any existing canonical evolution operators

Determine whether the new logic is:

```text
DUPLICATE
PARTIAL_DUPLICATE
USEFUL_PRIMITIVE_FOR_EXISTING_OWNER
GENUINELY_NEW_REQUIRED_CAPABILITY
ORPHAN_INTERESTING_ALGORITHM
```

Do not preserve a new standalone module merely because its exact arithmetic is not duplicated byte-for-byte.

Semantic ownership matters more than textual uniqueness.

---

# 4. Verify Source Fidelity

Inspect the actual source evidence associated with:

`evolution_gap_21_3ee5`

and any referenced source such as:

`knowledge_sources/evolution_gap_21_3ee5_consensus_174-miner.report.md`

Verify whether that evidence actually exists and is available to the promotion process.

Compare the harvested mechanism to the implementation.

Explicitly document:

```text
SOURCE_MECHANISM
IMPLEMENTED_MECHANISM
PRESERVED_BEHAVIOR
OMITTED_BEHAVIOR
UNVERIFIED_CLAIMS
```

If the implementation reduced a richer crossover mechanism to a generic weighted convex blend, do not describe that as full implementation of the harvested mechanism.

If the underlying source evidence is missing, stale, or not reproducibly linked, treat that as a provenance failure.

---

# 5. Preferred Disposition

Unless a real production consumer and canonical architectural need are demonstrated, remove the orphan capability.

That means deleting:

```text
tools/agentx_evolve/harvested_algorithms/fitness_weighted_crossover.py
tools/agentx_evolve/harvested_algorithms/test_fitness_weighted_crossover.py
```

and removing all supporting ceremony added solely for that orphan capability, including as applicable:

- `__init__.py` exports
- routing hints
- concept mappings
- owner mappings
- registry entries
- manifest entries
- test fixtures
- provenance entries that falsely imply production ownership
- documentation claiming it is a canonical capability

Do **not** keep an unused module just because its tests pass.

Do **not** create a new abstraction, registry, compatibility layer, adapter, facade, or wrapper to justify keeping it.

---

# 6. Preserve the Harvested Knowledge Without Producing Code

If the harvested crossover idea remains useful as research evidence, preserve it only in the appropriate evidence/provenance/concept layer.

The correct representation may be:

```text
CONCEPT_ONLY
DEFERRED
EVIDENCE_ONLY
RESEARCH_CANDIDATE
```

depending on the existing Agent_X data model.

The record may document:

- the mechanism
- source/provenance
- confidence
- possible future subsystem owner
- missing runtime need
- missing source fidelity
- reasons it was not promoted

Do not manufacture executable code merely to satisfy a harvested record.

---

# 7. Strengthen the Production-Necessity Gate

The more important fix is systemic.

Agent_X already has gates for matters such as:

- compilation
- algorithmic substance
- behavioral tests
- test evidence
- promotion authority

Add or strengthen a gate that asks:

> Why must this become production code inside Agent_X?

A candidate must not receive `REAL_IMPLEMENTATION` merely because:

- the code is non-trivial
- it compiles
- it has behavioral tests
- it implements an interesting published mechanism
- no exact duplicate exists

Require a demonstrated production reason.

A new production implementation should require evidence for all applicable conditions:

```text
1. REAL_RUNTIME_NEED
   An existing Agent_X workflow requires this behavior.

2. CANONICAL_OWNER
   The subsystem that should own the behavior is identified.

3. EXISTING_OWNER_CHECK
   Existing canonical implementations were searched and compared.

4. INTEGRATION_PATH
   There is a concrete execution path from runtime to the behavior.

5. SOURCE_FIDELITY
   The implementation faithfully captures the mechanism actually being promoted,
   or explicitly states that only a smaller primitive is being implemented.

6. BEHAVIORAL_VERIFICATION
   Tests prove meaningful behavior.

7. RUNTIME_VERIFICATION
   At least one test or bounded integration proof demonstrates the actual
   Agent_X subsystem invoking the implementation where appropriate.
```

If these cannot be demonstrated, the default outcome should be:

```text
ALREADY_EXISTS
CONCEPT_ONLY
DEFERRED
REJECTED
```

—not a new production module.

---

# 8. New-Module Creation Must Be Harder Than Patching an Existing Owner

A new canonical production module should be the last resort.

Before `CREATE_CANONICAL_MODULE` is allowed, require evidence that:

```text
- no existing canonical owner can reasonably absorb the mechanism;
- the capability represents a coherent architectural responsibility;
- at least one real runtime path will consume it;
- creating the module reduces rather than increases fragmentation;
- the module is not being created solely because a harvested record exists.
```

The candidate evaluator should prefer:

```text
PATCH_EXISTING_CANONICAL_OWNER
```

over:

```text
CREATE_CANONICAL_MODULE
```

whenever the mechanism naturally belongs to an existing subsystem.

---

# 9. Prevent Self-Justifying Canonical Ownership

Do not allow this sequence:

```text
harvested idea
    ↓
create module
    ↓
add module to owner map
    ↓
owner map now proves module is canonical
```

Canonical ownership must come from pre-existing architecture or a separately justified architectural decision.

Routing metadata cannot be the sole evidence that a capability belongs in production.

Add checks so that:

- newly created candidate paths do not automatically validate themselves as canonical owners;
- owner mappings added in the same promotion cannot be used as the only justification for promotion;
- a new owner requires explicit architectural evidence.

---

# 10. Tests Must Prove Need, Not Just Arithmetic

Keep mathematical unit tests when a capability is legitimately retained.

But for harvested code promotion, passing tests like:

```text
weights sum to one
fitter parent gets larger weight
output lies within convex hull
malformed input is rejected
```

only proves the implementation works.

It does not prove Agent_X needs it.

Where a production capability is retained, add an integration test showing a real Agent_X subsystem using it.

If no such legitimate test can be written without inventing a fake caller, that is evidence the capability should remain non-production.

Do not create synthetic runtime wiring merely to make the integration test pass.

---

# 11. Audit Other Harvested Algorithms for the Same Failure Mode

Do a bounded audit of all modules under:

`tools/agentx_evolve/harvested_algorithms/`

For each module classify:

```text
REAL_RUNTIME_USED
CANONICAL_PRIMITIVE_USED_BY_REAL_OWNER
UNUSED_BUT_JUSTIFIED
ORPHAN_PRODUCTION_ALGORITHM
```

For every retained module, provide:

- real production caller(s)
- canonical owner
- execution path
- source provenance
- behavioral test
- runtime/integration evidence where appropriate

Do not automatically delete the previously validated canonical algorithms.

Only remove modules that fail the same production-necessity test.

The purpose is to ensure `fitness_weighted_crossover` is not merely one instance of a broader regression.

---

# 12. Do Not Reopen the Correct Promotion Architecture

The canonical promotion architecture was recently corrected.

Do not reintroduce:

- a second promotion engine
- local promotion ledgers
- duplicate rollback systems
- direct production writes from `coding_loop`
- manifest publication outside the canonical promotion transaction
- parallel source-writing paths

If the production-necessity gate belongs inside authoring/evaluation or canonical promotion validation, integrate it minimally into the existing authority.

Do not perform another broad architecture rewrite unless a concrete defect requires it.

---

# 13. Acceptance Criteria

This task is complete only when all of the following are true.

## Exact commit disposition

- Every change from `1a0fd70ac01ca1a23670e61963d644b6a280cf07` is classified.
- `fitness_weighted_crossover` has either:
  - a demonstrated real runtime consumer and justified canonical owner, or
  - been removed from production.

## No orphan capability preservation

- No export, owner mapping, routing entry, registry entry, manifest entry, or test remains solely to preserve a deleted orphan module.
- No new wrapper or compatibility layer is created to avoid deletion.

## Production-necessity gate

- A harvested candidate cannot become production code solely because it is:
  - substantive,
  - compilable,
  - tested,
  - interesting,
  - or unique.
- New production code requires explicit runtime/architectural need.

## New-module gate

- `CREATE_CANONICAL_MODULE` requires evidence that no existing canonical owner is appropriate.
- Same-promotion owner metadata cannot self-justify the new module.

## Provenance

- Source evidence must be resolvable.
- Missing or incomplete provenance blocks full-mechanism promotion.
- Partial implementations are described truthfully as partial primitives.

## Verification

Run at minimum:

```bash
PYTHONPATH=.:tools python -m pytest <focused affected tests>
python -m compileall -q tools tests
```

Also run the relevant harvested-algorithm, authoring, substance-gate, promotion, and integration tests.

If practical, run repository test collection to ensure no new collection failures were introduced.

---

# 14. Required Final Report

Update or create a concise remediation report containing:

```text
COMMIT AUDITED:
1a0fd70ac01ca1a23670e61963d644b6a280cf07

FITNESS_WEIGHTED_CROSSOVER:
RETAINED / MOVED / DELETED

REAL PRODUCTION CALLERS:
...

CANONICAL OWNER:
...

SOURCE FIDELITY:
...

FILES DELETED:
...

FILES MODIFIED:
...

LINES REMOVED:
...

PRODUCTION-NECESSITY GATE:
...

NEW-MODULE GATE:
...

OTHER HARVESTED ALGORITHMS AUDITED:
...

TESTS:
...

COMPILE:
...

REMAINING BLOCKERS:
...
```

Do not claim completion if the only evidence for a production capability is its own module, its own test, its export, or routing metadata.

---

# Core Rule

The final policy should be:

> Harvest discovers knowledge. Harvest does not earn the right to create production code merely by discovering an implementable idea.

Production code must exist because Agent_X has a demonstrated architectural and runtime need for it.

A real, elegant, fully tested algorithm with no legitimate consumer is still slop.
