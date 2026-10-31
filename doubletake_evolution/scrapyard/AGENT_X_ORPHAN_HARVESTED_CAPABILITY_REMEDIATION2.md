# AGENT_X — Orphan Harvested Capability Remediation + Production-Necessity Enforcement

## Mission

Audit and remediate commit:

`1a0fd70ac01ca1a23670e61963d644b6a280cf07`

The commit added a substantive, tested `fitness_weighted_crossover` algorithm. The concern is not fake/template code. The concern is a more subtle form of production slop:

```text
harvest discovers an implementable idea
        ↓
code is mathematically real
        ↓
tests prove the local algorithm
        ↓
a new production module is created
        ↓
routing/export metadata is added
        ↓
the new module's existence becomes its own justification
```

Agent_X must prevent this.

The required invariant is:

> Harvested evidence may justify investigation. It does not, by itself, justify adding production code.

Production code must have an independently demonstrated Agent_X need, a legitimate canonical owner, a concrete integration path, resolvable provenance, and meaningful verification.

A real, elegant, fully tested algorithm with no legitimate production need is still slop.

---

# 0. Execution Rules

These rules are mandatory for this task.

## 0.1 Work against current `HEAD`, but audit the exact historical commit

The target commit's parent is:

`c685cc12257ac311906f6e26063bb23aeaab0c84`

Use the historical diff to understand exactly what was introduced:

```bash
git show --stat --oneline 1a0fd70ac01ca1a23670e61963d644b6a280cf07
git diff c685cc12257ac311906f6e26063bb23aeaab0c84 \
         1a0fd70ac01ca1a23670e61963d644b6a280cf07
```

Then inspect the **current** versions of all affected files.

Do not assume current `HEAD` still matches the historical commit.

## 0.2 Do not blindly `git revert` the commit

Later commits may have legitimately modified the same files.

Perform a **semantic remediation on current HEAD**:

- remove only behavior that is still wrong;
- preserve unrelated later fixes;
- preserve current Gate B / promotion hardening;
- preserve current Borg/governance/runtime architecture;
- do not reset, detach, or overwrite later work.

## 0.3 Deletion bias

Use this order:

```text
1. Is the production capability actually needed?
   no -> remove it from production.

2. Is the behavior already owned elsewhere?
   yes -> use/patch the real owner and remove the duplicate standalone module.

3. Is only a small primitive genuinely useful to an existing owner?
   yes -> integrate the minimum primitive into that owner, then delete the orphan module.

4. Is a new coherent production responsibility genuinely required?
   only then consider a new canonical module.
```

Do not preserve code merely because deleting it feels wasteful.


Do not "delete" orphan production code by moving it into another importable Python package such as:

```text
experimental/
research/
future/
archive/
disabled/
legacy/
unused/
```

That is still code clutter if it has no current need.

If raw implementation text must be preserved for provenance, keep it as non-executable evidence in the existing evidence/provenance system, not as an importable production module.

A feature flag set to false is not a production-need proof. Dormant/disabled code without an independently approved experiment or consumer should remain non-production.

## 0.4 Do not solve this by adding architecture

Do not create a new:

- manager
- service
- registry
- facade
- adapter
- compatibility package
- promotion engine
- duplicate ledger
- generic plugin layer
- "harvested capability manager"

Reuse the existing authoring, candidate, Gate B, canonical-owner, promotion, provenance, and lifecycle machinery.

If a small typed result/evidence structure is necessary, extend an existing structure or add the smallest possible value object. Do not create another subsystem.


## 0.5 If current HEAD already partially or fully remediated this commit

Do not reintroduce the crossover merely to perform the exercise.

Instead:

```text
verify deletion/retirement is complete
verify no active references survive
verify the systemic production-necessity rule exists and cannot be bypassed
verify tests prove the rule
```

The task must be idempotent against an already-clean HEAD.

## 0.6 Scope of the new admission rule

The mandatory production-necessity rule applies to **autonomous evidence-origin code promotion**, including material originating from:

- Harvest
- mining
- gap filling
- frontier discovery
- balancer/evolution evidence
- assimilation evidence queues
- other automatically acquired external/internal knowledge records that enter the write-code/promotion pipeline

Do not accidentally impose this exact harvested-evidence protocol on ordinary direct human source edits that do not pass through the autonomous assimilation pipeline.

However, any autonomous path that can turn acquired evidence into Agent_X production code must be covered.

If origin metadata is missing or malformed for a candidate entering an evidence/harvest authoring path, fail closed rather than treating it as non-harvest by default.

---

# 0A. Required Execution Order

Execute in this order. Do not jump directly to implementing a new gate before understanding the current repository.

```text
STEP 1  Capture current HEAD and working-tree state.
STEP 2  Inspect the exact 1a0fd70 commit diff against its parent.
STEP 3  Search current HEAD for every crossover/source/capability reference.
STEP 4  Establish pre-candidate runtime architecture and real need evidence.
STEP 5  Decide crossover disposition: retain / move / merge / retire / delete.
STEP 6  Apply the minimum commit-specific cleanup on current HEAD.
STEP 7  Reconcile active lifecycle/manifest/registry state without erasing history.
STEP 8  Implement systemic production-necessity enforcement before authoring.
STEP 9  Enforce the same invariant fail-closed at canonical promotion.
STEP 10 Fix any IMPLEMENTED-status bypass that can contradict canonical reality.
STEP 11 Add adversarial + exact end-to-end regression tests.
STEP 12 Audit the remaining harvested_algorithms package for the same failure mode.
STEP 13 Run focused tests, compileall, collection, and widest practical affected suite.
STEP 14 Inspect final git diff for unrelated changes.
STEP 15 Update the remediation report with exact evidence and outcomes.
```

If an earlier step proves that a later change is unnecessary, do not add it merely because it appears in this sequence.

For example, if current HEAD already has a correct production-necessity check at the canonical boundary, verify it with the required adversarial tests instead of creating a duplicate check.

---

# 1. Exact Commit Surface

Commit `1a0fd70ac01ca1a23670e61963d644b6a280cf07` changed exactly this functional area:

```text
tools/agentx_evolve/algorithmic_substance_gate/test_substance_gate.py
tools/agentx_evolve/collective_core/write_code_e2e.py
tools/agentx_evolve/harvested_algorithms/__init__.py
tools/agentx_evolve/harvested_algorithms/fitness_weighted_crossover.py
tools/agentx_evolve/harvested_algorithms/test_fitness_weighted_crossover.py
```

Audit all five explicitly.

Also search current HEAD for every reference to:

```text
fitness_weighted_crossover
blend_parents
rank_weights
evolution_gap_21_3ee5
fcda4d3cc44fc3b7
```

Search:

- production Python
- tests
- package exports
- manifests
- registries
- capability maps
- routing tables
- candidate stores
- promotion ledgers
- harvest lifecycle state
- remediation audit files
- reports
- documentation
- Make/CI
- dynamic loader configuration

Do not stop at direct imports.

---

# 2. Establish the Pre-Candidate Architectural Baseline

Before deciding whether the crossover belongs in production, establish what Agent_X already did before the target commit.

Use the parent revision and current architecture to answer:

```text
What subsystem evolves/adapts candidates?
What representation is actually evolved?
Are there genomes/vectors that are recombined?
Does any runtime path currently need crossover/recombination?
What existing operator performs selection/mutation/replacement?
What existing canonical owner would logically own recombination?
What measurable runtime objective would crossover improve?
```

Inspect at minimum:

- adaptive mutation
- elite preservation
- ranked selection
- hybrid ranking
- adaptation engine/runtime
- any population/genome representation
- any mutation/recombination/crossover operator
- evolution scheduler/orchestrator
- any subsystem that consumes offspring/candidate vectors

Do not infer need from vocabulary alone.

A file named `adaptation.py` is not proof that crossover is needed.

---

# 3. Classify Every Reference to the New Capability

Every discovered reference must be classified as exactly one of:

```text
REAL_RUNTIME_CALL
REAL_EXTERNAL_ENTRYPOINT
PREEXISTING_ACCEPTANCE_REQUIREMENT
PREEXISTING_ARCHITECTURAL_GAP
MEASURED_EXISTING_RUNTIME_IMPROVEMENT_PATH

TEST_ONLY_REFERENCE
EXPORT_ONLY_REFERENCE
ROUTING_ONLY_REFERENCE
REGISTRY_ONLY_REFERENCE
MANIFEST_ONLY_REFERENCE
PROVENANCE_ONLY_REFERENCE
DOCUMENTATION_ONLY_REFERENCE
SAME_CHANGE_SELF_JUSTIFICATION
DEAD_REFERENCE
```

The first five categories may contribute to production-need evidence.

The remaining categories do **not** prove production need.

In particular, none of these are sufficient:

```text
the module exports itself
the package __init__ exports it
its own test imports it
a routing table names it
a manifest names it
a Gate B decision says MERGE
a harvested record proposes it
a substance gate accepts it
a lexical worthiness score says it is codable
a new integration test invented only to justify it
a caller added in the same change solely to make it look used
```

---

# 4. Define What Counts as a Real Production Need

Do not implement a simplistic rule of "must already have a direct caller." Legitimate new capabilities can be integrated into an existing runtime objective.

A harvested capability may become production code only if at least one of these independent need paths is demonstrated.

## 4.1 Existing runtime demand

A production subsystem already requires the behavior.

Evidence may include:

- an existing callable path that expects the behavior;
- an existing unimplemented hook/interface;
- a failing acceptance test that predates the harvested candidate;
- an existing runtime branch currently using an inferior placeholder/fallback.

The need must exist independently of the harvested implementation.

## 4.2 Measurable substitution or improvement of existing behavior

The harvested mechanism can replace or augment an already executed Agent_X mechanism.

Require:

```text
existing runtime owner
existing baseline behavior
real integration point
measurable acceptance criterion
comparison against the current baseline
```

The comparison must test Agent_X behavior, not merely the standalone arithmetic.

A claimed improvement without a real baseline does not qualify.

## 4.3 Independently established architectural gap

A real Agent_X requirement/gap predating the implementation explicitly needs this responsibility.

The gap must be tied to an existing subsystem and acceptance criteria.

The harvested source record itself cannot be the only evidence for the gap.

## 4.4 Real external contract

A real API/CLI/plugin/public-library contract requires the capability and has a concrete consumer.

A self-declared "stable public API" in the module/package docstring is not enough.

## 4.5 Otherwise

Use a non-production outcome:

```text
ALREADY_EXISTS
CONCEPT_ONLY
DEFERRED
REJECTED
EVIDENCE_ONLY
```

Use the closest outcome already supported by the current data model.

Do not invent a new lifecycle vocabulary unless absolutely necessary.

---

# 5. Anti-Self-Justification Rule

This rule is critical.

A candidate must not create the evidence that is then used to justify its own production necessity.

Reject reasoning like:

```text
candidate creates new module
candidate adds export
candidate adds owner-map row
candidate adds manifest entry
candidate adds new caller
candidate adds test for new caller
therefore capability is "used"
```

Production need must be anchored to the repository **before** the candidate's production mutation, or to an independently authorized requirement.

## 5.1 Base-revision evidence

Where practical, capture the repository revision used for production-need evaluation.

Evidence should identify:

```text
base_repo_revision
source/gap identity
existing owner path
existing integration point
existing acceptance requirement or baseline
```

If the repository changes materially before promotion, re-evaluate rather than reusing stale need evidence.

## 5.2 Same-change integration exception

A legitimate feature may need both new behavior and new wiring in one patch.

That is allowed only when the **need** is independently established by:

- a pre-existing runtime objective;
- a pre-existing acceptance requirement;
- a separately authorized architectural gap;
- or a measured replacement of existing behavior.

The newly added caller itself cannot be the sole need evidence.

---

# 6. Real Consumer Evidence Standard

A production consumer must be more than a textual reference.

For static calls, prefer evidence such as:

```text
entrypoint -> subsystem callable -> imported symbol -> actual invocation
```

For dynamic loading, prove:

```text
runtime entrypoint
    -> active loader/registry
    -> exact capability registration
    -> invocation path
```

Exclude as consumer evidence by default:

- `tests/`
- fixtures
- examples
- docs
- comments
- reports
- remediation/audit files
- generated inventories
- package exports
- type-check-only imports
- dead/unreachable branches
- `.agentx-init` historical records

A test can prove behavior, but a test is not itself the production consumer.


## 6.1 Evidence strings are not evidence

Do not trust caller/candidate fields such as:

```text
consumer_path
integration_path
owner_path
runtime_used=true
production_needed=true
```

without resolving them against the base repository.

For each evidence item used to authorize production, verify as applicable:

- path exists at the evaluated base revision;
- symbol exists;
- import/loader relation is real;
- invocation/reachability relation is real enough for the current architecture;
- path is not excluded evidence such as a test/doc/report;
- evidence was not manufactured solely by the candidate being evaluated.

Persist a stable identity/digest for decisive evidence where the existing candidate/Gate B structures support it.

A fabricated path string or stale symbol name must not satisfy the gate.

---

# 7. Audit `fitness_weighted_crossover` Against Existing Owners

Classify the capability as one of:

```text
DUPLICATE
PARTIAL_DUPLICATE
USEFUL_PRIMITIVE_FOR_EXISTING_OWNER
GENUINELY_NEW_REQUIRED_CAPABILITY
ORPHAN_INTERESTING_ALGORITHM
```

Use semantic behavior and architectural ownership, not filename similarity.

## 7.1 If DUPLICATE

Delete the new module/test/export/routing additions.

Route future matching evidence to the real existing owner.

## 7.2 If PARTIAL_DUPLICATE

Keep only genuinely missing behavior.

Do not keep a standalone module if an existing canonical owner should absorb it.

## 7.3 If USEFUL_PRIMITIVE_FOR_EXISTING_OWNER

Integrate the minimum necessary primitive into the real owner.

Then remove the standalone harvested module and its self-justifying routing/export ceremony.

Add a real integration test at the owner boundary.

## 7.4 If GENUINELY_NEW_REQUIRED_CAPABILITY

A new module is allowed only after satisfying the stronger new-module gate in this document.

## 7.5 If ORPHAN_INTERESTING_ALGORITHM

Remove it from production and preserve only the evidence/concept record.

This is the expected disposition unless contrary runtime evidence is found.

---

# 8. Source Fidelity and Provenance

Inspect the actual source evidence associated with:

```text
evolution_gap_21_3ee5
fcda4d3cc44fc3b7
```

and any referenced artifact such as:

`knowledge_sources/evolution_gap_21_3ee5_consensus_174-miner.report.md`

Do not assume a referenced path is valid merely because a docstring mentions it.

The source is considered resolvable only when Agent_X can retrieve the evidence from:

- a committed source artifact;
- a durable provenance store;
- or another current canonical evidence location with a verifiable digest/identity.

A path string by itself is not provenance.

Document:

```text
SOURCE_ID
SOURCE_LOCATION
SOURCE_DIGEST / DURABLE ID
SOURCE_MECHANISM
IMPLEMENTED_MECHANISM
PRESERVED_BEHAVIOR
OMITTED_BEHAVIOR
UNVERIFIED_CLAIMS
FIDELITY_VERDICT
```

Possible fidelity verdicts:

```text
FAITHFUL
FAITHFUL_SUBSET
MATERIAL_SEMANTIC_DRIFT
SOURCE_UNRESOLVED
```

`FAITHFUL_SUBSET` may be valid only if the production capability is described truthfully as the smaller primitive.

Do not promote the subset under a name/description implying the full source mechanism.

---

# 9. If the Crossover Is Retained, Audit Its Actual Semantics

Do this only if genuine production need is proven.

Do not spend time polishing code that should be deleted.

Check at minimum:

- whether "rank" means actual ordinal rank or min-max normalized score;
- whether "uniform crossover" is being used correctly as a term;
- whether equal-weight arithmetic blending is incorrectly described as uniform crossover;
- handling of `NaN`;
- handling of positive/negative infinity;
- whether booleans should be accepted as numeric scores/genes;
- empty parent/genome behavior;
- dimension mismatch;
- score/genome count mismatch;
- deterministic behavior;
- negative fitness values;
- degenerate equal-fitness populations;
- floating-point edge cases.

Correct misleading documentation and tests if retained.

Do not retain it merely because these local issues are fixable.


## 9.1 Numeric/performance claims

If retention is justified by an improvement claim such as faster convergence, better hit rate, or a percentage gain:

- define the actual Agent_X baseline;
- define the workload/simulation;
- fix seeds where randomness exists;
- bound runtime/sample size;
- record the exact metric;
- make the result reproducible from repository tests/benchmarks where practical.

If this cannot be reproduced, label the source performance claim `UNVERIFIED` and do not use it as production-need evidence.

A source paper/report saying "22%" or ">=15%" is motivation, not proof of Agent_X benefit.

---

# 10. Preferred Immediate Disposition of Commit `1a0fd70...`

Unless sections 4–9 prove a real production need, remove the production capability.

At current HEAD, semantically undo the commit's crossover-specific additions.

## 10.1 Delete

As applicable:

```text
tools/agentx_evolve/harvested_algorithms/fitness_weighted_crossover.py
tools/agentx_evolve/harvested_algorithms/test_fitness_weighted_crossover.py
```

## 10.2 Clean `harvested_algorithms/__init__.py`

Remove:

- `blend_parents`
- `rank_weights`
- crossover imports
- crossover `__all__` entries
- claims that the package has eight canonical mechanisms if only seven remain

Do not blindly restore old wording if the current canonical count has legitimately changed again.

Make the text reflect current reality.

## 10.3 Clean `write_code_e2e.py`

Remove the crossover-specific `_CANONICAL_MECHANISMS` routing row unless the capability survives this audit for a legitimate reason.

Do not replace it with a differently named self-routing rule.

## 10.4 Clean `algorithmic_substance_gate/test_substance_gate.py`

Remove `fitness_weighted_crossover` from the list of accepted production algorithm modules if the module is removed.

Reconcile the scan expectation.

Do **not** treat the substance gate as a production-necessity gate.

A module may have algorithmic substance and still be disallowed from production because it is unnecessary.

Add a separate regression test proving that distinction.

## 10.5 Clean every other active reference

Search and remove stale:

- exports
- routing mappings
- manifests
- registries
- active capability listings
- API surfaces
- package metadata
- runtime configuration
- current-state indexes

Do not leave a dangling active identity for a deleted capability.

---

# 11. Preserve History; Remove Active Authority

Do not erase historical truth merely because the capability is removed.

Distinguish:

```text
historical audit/provenance
vs.
current active production authority
```

## 11.1 Historical promotion records

If an append-only promotion/Gate B/audit record truthfully says the capability was previously approved/promoted, do not silently rewrite history.

Instead:

- preserve the historical record;
- add a superseding remediation/retirement decision if the current schema supports it;
- ensure historical entries cannot make the capability active again.

## 11.2 Current active state

Remove or invalidate any current:

- manifest registration
- active capability registry entry
- package export
- current canonical-owner mapping
- runtime lifecycle assertion
- "implemented" active status

that depends on the deleted capability.

## 11.3 Harvested evidence record

Keep the harvested knowledge.

Record why it is not production code, for example:

```text
CONCEPT_ONLY / DEFERRED / EVIDENCE_ONLY
reason: no independent Agent_X production need
source: <durable provenance>
prior implementation: retired after necessity audit
```

Use existing supported fields/outcomes where possible.

Do not delete the source evidence merely to eliminate the code.

---

# 12. `IMPLEMENTED` Must Mean Current Verified Production Implementation

Audit the harvest lifecycle/status code related to this capability.

A harvested item must not be considered `IMPLEMENTED` merely because:

- a caller supplied the string `IMPLEMENTED`;
- an old promotion once existed;
- a module path appears in stale metadata;
- a test once passed;
- a routing table points somewhere.

For harvest-origin items, active implemented state should be derivable from current evidence such as:

```text
canonical target exists
promotion receipt is valid
current target matches expected identity/digest where applicable
required tests were executed
production-necessity approval is present
capability is not retired/superseded
```

If current `verify_items()` / lifecycle APIs can manufacture `IMPLEMENTED` from caller-supplied status without canonical evidence, close that bypass as part of this remediation.

Do not create a second implementation-status database.

Reuse canonical promotion/lifecycle evidence.

---

# 13. Strengthen the Production-Necessity Decision

The existing `assess_worthiness()`/codability logic is not enough.

A lexical score can answer:

> "Could this be coded?"

It cannot answer:

> "Should this become Agent_X production code?"

Keep those concepts separate.

Do not simply add more keywords to `CODABLE_VERBS`.


Do not replace the current lexical worthiness score with a second lexical "necessity score."

Production necessity is an evidence/reachability/requirement decision, not a bag-of-words classifier.

The coding/authoring LLM must not be allowed to satisfy this gate by writing persuasive prose about why its own candidate is needed. LLM rationale may be recorded, but decisive evidence must be independently resolved from repository/provenance state.

## 13.1 Required decision data

For a harvest-origin `REAL_IMPLEMENTATION`, record enough structured evidence to answer:

```text
source identity
source provenance/fidelity
base repository revision
need type
existing canonical owner search
chosen owner
why existing owner can/cannot absorb the behavior
integration path
real consumer or independent requirement
baseline behavior/acceptance criterion when applicable
promotion action
new-module justification when applicable
```

## 13.2 Fail-closed

Missing/unreadable/ambiguous production-need evidence must result in non-production behavior.

Do not default to approval on:

- parser failure
- source lookup failure
- repository search failure
- owner-resolution exception
- missing revision
- malformed evidence

## 13.3 No caller-supplied boolean authority

This is forbidden:

```python
production_needed=True
```

as the sole authority.

The canonical boundary must verify store-backed or candidate-bound evidence.

---

# 14. Enforce Necessity Before Authoring and Again at Promotion

Use defense in depth without creating another promotion system.

## 14.1 Before expensive code authoring

Where feasible, evaluate production need before invoking the real coding author.

If no need exists:

```text
do not generate production code
do not generate a paired production test
do not stage a production candidate
```

Return the correct typed non-production outcome.

This prevents "generate first, rationalize later."

## 14.2 Canonical promotion boundary

The canonical mutation authority must also refuse harvest-origin promotion without valid production-necessity evidence.

Do not rely solely on `write_code_e2e.py` or `coding_loop.py` callers behaving correctly.

Audit all callers of:

```text
promote_candidate
CREATE_CANONICAL_MODULE
PATCH_CANONICAL
author_functional_module
write_code_e2e
register_mcp_tool
```

Every harvest-origin path that can eventually mutate production must be covered.

## 14.3 Reuse existing authority

Prefer one of these patterns, depending on current architecture:

```text
A. extend the existing Gate B/store-backed decision with production-need evidence
```

or:

```text
B. persist a typed production-need evaluation in the staged candidate and
   require canonical promotion to validate it against candidate/source/revision
```

Do not create a parallel "ProductionNeedLedger" unless the existing architecture makes reuse impossible.


Do not add a normal-path bypass such as:

```text
skip_production_need=True
force_production=True
trusted=True
allow_orphan=True
```

If the repository genuinely has an exceptional human-governed path for trust-boundary/manual intervention, reuse that existing exceptional authority and keep it clearly outside autonomous harvest promotion.

Do not let an ordinary caller opt out with a boolean.

## 14.4 Bind the evidence

At minimum bind necessity approval to:

```text
source/capability identity
base repository revision
canonical owner/target
promotion action
independent need evidence
```

If candidate identity is available at approval time, bind to it too.

A necessity decision for one target/action must not authorize a different target/action.


## 14.5 Caller compatibility

Audit every existing caller before changing function signatures.

If canonical promotion becomes stricter:

- update all legitimate evidence-origin callers to supply/derive verified necessity evidence;
- keep tests explicit;
- do not silently default missing evidence to PASS;
- do not accidentally break a distinct human-governed maintenance path without understanding it.

If a caller cannot supply necessity evidence because it has no independent need proof, that caller should not be promoting harvest-origin production code.

---

# 15. New-Module Creation Gate

`CREATE_CANONICAL_MODULE` must be much harder to justify than patching an existing owner.

Before a harvest-origin `CREATE_CANONICAL_MODULE`, require all of:

```text
1. independent production need exists;
2. existing canonical owner search was performed;
3. no existing owner can reasonably absorb the responsibility;
4. the new module represents a coherent responsibility, not one harvested record;
5. at least one real integration path or independently required contract exists;
6. creation reduces architectural fragmentation compared with alternatives;
7. source provenance is resolvable;
8. behavior is source-faithful or truthfully scoped as a subset;
9. behavioral verification exists;
10. runtime/integration verification exists where appropriate.
```

Record rejected owner alternatives.

A candidate-supplied filename is not evidence.

`agentx_status=update/upgrade/new` is not authority.

A Gate B `MERGE` classification alone is not production-need evidence.

---

# 16. Prevent Self-Justifying Canonical Ownership

Do not allow:

```text
harvest idea
    ↓
new module
    ↓
same patch adds module to _CANONICAL_MECHANISMS / owner map
    ↓
owner resolver sees the new mapping
    ↓
mapping is cited as proof that module is canonical
```

Rules:

- routing/owner metadata created by the same candidate is not independent owner evidence;
- a newly created path cannot prove its own necessity;
- current owner resolution must distinguish architectural owner evidence from candidate hints;
- proposed `target_rel`, symbols, names, status labels, and descriptions are untrusted hints;
- existing canonical architecture or independently authorized architecture must justify the owner.

---

# 17. Substance Gate vs Necessity Gate

Keep these responsibilities distinct.

## Substance gate asks:

```text
Is this meaningful executable code rather than placeholder/template slop?
```

## Production-necessity decision asks:

```text
Does Agent_X need this behavior in production, and where does it belong?
```

Both must pass for a new harvest-origin production implementation.

Add a regression case where:

```text
candidate is a real deterministic algorithm
candidate has meaningful behavioral tests
substance gate accepts it
no independent runtime need exists
=> production promotion is blocked / downgraded
```

This exact class of regression is what commit `1a0fd70...` exposed.

---

# 18. Tests Must Prove More Than Arithmetic

Local unit tests such as:

```text
weights sum to one
fitter parent gets more weight
result lies in a convex hull
invalid dimensions are rejected
```

prove algorithm behavior only.

They do not prove production necessity.

For any retained harvest-origin production capability, add a bounded test proving the real Agent_X owner executes the behavior for the independently established need.

Do not invent a fake production caller solely to satisfy the test.

If no legitimate integration test can be written without inventing a consumer, treat that as evidence for non-production disposition.

---

# 19. Required Adversarial Tests for the New Rule

Add tests for at least these cases.

## 19.1 Substantive orphan

```text
real code
real behavioral test
no independent need
=> no production promotion
```

## 19.2 Self-export

```text
candidate adds package export only
=> export is not consumer evidence
```

## 19.3 Self-routing

```text
candidate/same change adds canonical-owner or routing row
=> row cannot justify production need
```

## 19.4 Same-change fake caller

```text
candidate adds otherwise-unused caller solely to invoke new capability
no pre-existing need/requirement
=> blocked
```

## 19.5 Pre-existing runtime demand

```text
existing production owner has real missing behavior / integration point
candidate fills it
=> may proceed through normal gates
```

## 19.6 Measured replacement

```text
existing runtime behavior + real baseline + accepted improvement criterion
new mechanism integrated and verified
=> may proceed
```

## 19.7 New module without owner search

```text
CREATE_CANONICAL_MODULE
no evidence of existing-owner comparison
=> blocked
```

## 19.8 New module with only harvested source as "need"

```text
interesting source record
no independent Agent_X requirement
=> CONCEPT_ONLY/DEFERRED, not production
```

## 19.9 Stale necessity evidence

```text
necessity decision bound to older repository revision
relevant repository state changes
=> re-evaluation required / promotion blocked
```

## 19.10 Missing provenance

```text
source path/id cannot be resolved
=> full-mechanism production claim blocked
```

## 19.11 Lifecycle spoof

```text
caller asks verify/status API to mark item IMPLEMENTED
no valid current canonical promotion evidence
=> IMPLEMENTED is refused
```

## 19.12 Historical retired capability

```text
old promotion exists
current capability has been retired/deleted
=> historical record remains
=> capability is not active/IMPLEMENTED
```


## 19.13 Fabricated consumer evidence

```text
candidate claims consumer_path=some/production/file.py
path/symbol/call relation does not exist at evaluated base revision
=> blocked
```

## 19.14 Test/doc/manifest-only "consumer"

```text
only references are tests/docs/manifest/registry/export
no real runtime or external contract
=> not production need
```

## 19.15 Unknown evidence origin on autonomous authoring path

```text
candidate enters harvest/assimilation write-code path
origin/provenance cannot be established
=> fail closed / non-production
```


## 19.16 Disabled/experimental orphan

```text
unused capability is moved behind a feature flag or into experimental/
no independent approved experiment/runtime need
=> still non-production; retire it
```

## 19.17 Generic bypass flag

```text
normal autonomous caller sets skip_production_need=True
=> API/design must not permit this bypass
```

## 19.18 Existing legitimate caller regression

```text
pre-existing evidence-origin promotion path has valid independent need
new enforcement is added
=> caller is updated and remains functional
=> enforcement is not weakened to preserve compatibility
```


## 19.19 Exact end-to-end orphan replay

Create a regression fixture based on the `fitness_weighted_crossover` / `evolution_gap_21_3ee5` class of record:

```text
record is substantive and codable
author could produce real deterministic code
behavioral test could pass
no independent Agent_X production need exists
```

Run it through the real harvest/assimilation authoring path as far as practical.

Required result:

```text
no production source created
no production export added
no manifest/tool registration
no canonical promotion
no active IMPLEMENTED state
source evidence remains preserved
typed result explains non-production disposition
```

Where the author is injectable, use a spy/fake author and assert it is **not invoked** when production need fails before authoring.

## 19.20 Re-run does not recreate retired code

After retiring/removing the crossover, replay the same evidence.

Required result:

```text
same non-production decision
no new crossover .py
no new route/manifest/export
no stale promotion record reactivates it
```

## 19.21 Positive end-to-end control

Use one existing, legitimately needed evidence-origin capability with a real canonical owner/integration need.

Prove the stronger rule does not block valid work:

```text
independent need passes
normal substance/tests/Gate B pass
canonical promotion succeeds through the existing single authority
```

Do not weaken the rule merely to make this positive case pass.

---

# 20. Audit All Other `harvested_algorithms` Modules for the Same Failure Mode

Perform a bounded repository-wide audit of every production module under:

`tools/agentx_evolve/harvested_algorithms/`

Do not assume the seven previously accepted modules are automatically exempt.

For each module, report:

```text
MODULE
SOURCE/PROVENANCE
CURRENT PRODUCTION CALLER(S)
RUNTIME ENTRY PATH
CANONICAL OWNER
NEED TYPE
BEHAVIORAL TEST
INTEGRATION/RUNTIME EVIDENCE
DISPOSITION
```

Allowed dispositions:

```text
RETAIN_RUNTIME_USED
RETAIN_REQUIRED_EXTERNAL_CONTRACT
MOVE_INTO_EXISTING_OWNER
MERGE_WITH_EXISTING_OWNER
RETIRE_TO_CONCEPT_ONLY
DELETE_DUPLICATE
```

Avoid a vague `UNUSED_BUT_JUSTIFIED` category.

If code is unused, require a concrete external contract or independent requirement. Otherwise remove it from production.

Do not mass-delete the package without evidence.

Do not preserve modules merely because earlier remediation called them "canonical."

---

# 21. Routing Table Audit

Audit `_CANONICAL_MECHANISMS` or its current equivalent.

For every entry, ask:

```text
Does this row point to a real, independently justified canonical owner?
Or does it merely canonize a harvested module after the fact?
```

Remove rows whose only justification is the existence of the generated/harvested module itself.

Routing tables should help recognize existing capabilities.

They must not manufacture architectural legitimacy.

Add a regression test if necessary to prevent a newly created harvested module from becoming canonical merely by adding a routing tuple.


Ordering rule:

```text
independent need
    ↓
existing-owner comparison
    ↓
owner decision
    ↓
author/verify
    ↓
successful canonical promotion
    ↓
only then, if truly needed, expose/update stable routing metadata
```

Do not add routing metadata first and then use it as evidence for the same decision.

---

# 22. Trust-Boundary Review

The production-necessity enforcement itself must not be autonomously weakened by ordinary harvested candidates.

Inspect current `TRUST_BOUNDARY_RELS` / equivalent governance protection.

Ensure whichever code becomes authoritative for:

- production-need evaluation;
- necessity verification at promotion;
- lifecycle derivation of `IMPLEMENTED`;

is protected by the existing trust-boundary policy.

Do not expand the trust boundary indiscriminately.

Protect only the actual decision/mutation authority.

If `write_code_e2e.py` remains merely advisory and canonical promotion re-verifies necessity, it does not need to become the sole trusted authority.

---

# 23. Do Not Reopen Correct Promotion Architecture

Preserve the existing single canonical promotion transaction.

Do not reintroduce:

- a second promotion engine;
- direct source writes from `coding_loop`;
- local rollback logic competing with assimilation governance;
- a second promotion-result ledger;
- manifest publication outside the canonical transaction;
- collision-suffixed canonical siblings;
- packet-era source identity;
- fake generated algorithms;
- compatibility clutter.

This task adds a missing admission criterion. It does not redesign promotion.

---

# 24. Idempotency and Concurrency

The remediation and new gate must behave safely on retries.

Requirements:

```text
rerunning the same remediation does not recreate deleted capability
re-evaluating the same need evidence is deterministic where inputs are unchanged
a stale decision cannot authorize a materially changed repository state
a retired capability is not reactivated by stale routing/ledger data
```

Do not make current production state depend on whichever stale ledger entry is encountered first.

Canonical current state must win over historical records.

---

# 25. Required Searches After Remediation

Run repository searches for:

```text
fitness_weighted_crossover
blend_parents
rank_weights
evolution_gap_21_3ee5
fcda4d3cc44fc3b7
```

For each remaining match, classify it.

After deletion, acceptable remaining matches are normally:

- historical provenance;
- remediation report;
- concept/deferred evidence;
- tests specifically proving retirement/non-promotion.

No active production import/route/export/registry may remain unless the capability was legitimately retained.

Also search for all production creation paths:

```text
promote_candidate(
CREATE_CANONICAL_MODULE
PATCH_CANONICAL
author_functional_module
register_mcp_tool
REAL_IMPLEMENTATION
```

Verify harvest-origin production cannot bypass the necessity rule.

---

# 26. Required Verification

Run the relevant commands available in the repository.

At minimum:

```bash
PYTHONPATH=.:tools python -m pytest \
  tools/agentx_evolve/algorithmic_substance_gate/test_substance_gate.py

PYTHONPATH=.:tools python -m pytest \
  <write-code / authoring focused tests>

PYTHONPATH=.:tools python -m pytest \
  <assimilation-governance / canonical-promotion focused tests>

PYTHONPATH=.:tools python -m pytest \
  <harvest-lifecycle focused tests>

PYTHONPATH=.:tools python -m pytest \
  <harvested-algorithms focused tests>

python -m compileall -q tools tests
```

Also run:

```bash
PYTHONPATH=.:tools python -m pytest --collect-only -q
```

if repository size/resources permit, and record the exact collection result.


New tests added for this remediation must be:

- deterministic;
- bounded;
- offline/no-network;
- isolated from the developer's real `.agentx-init` state;
- based on temporary repository/candidate fixtures where mutation is tested;
- free of sleep-based timing assumptions;
- explicit about base revision/evidence inputs;
- capable of running repeatedly without changing the real checkout.

Do not use an LLM response as the authoritative expected value in a test.

Run the widest practical affected suite.

Do not claim full repository test success if only collection or focused tests were run.


Before finalizing, inspect:

```bash
git diff --stat
git diff
```

Ensure the remediation did not include unrelated formatting, generated files, broad rewrites, or deletion of unrelated later work.

Also verify no new placeholder/scaffold markers or existence-only tests were added merely to satisfy the new gate.

---

# 27. Required Final Repository State

The task is complete only when all conditions below hold.

## Commit-specific cleanup

- [ ] All five files changed by `1a0fd70...` were explicitly audited.
- [ ] `fitness_weighted_crossover` is either independently justified or removed from production.
- [ ] If removed, its module and paired test are gone.
- [ ] If removed, package exports are gone.
- [ ] If removed, crossover-specific canonical routing is gone.
- [ ] Substance-gate bookkeeping reflects current reality.
- [ ] No active dangling reference remains.

## Knowledge preservation

- [ ] Original source evidence remains queryable where available.
- [ ] Historical promotion/audit truth is not silently erased.
- [ ] A superseding non-production/retirement decision is recorded when appropriate.
- [ ] Stale history cannot reactivate the capability.

## Production-necessity enforcement

- [ ] Codability/substance is not treated as necessity.
- [ ] Necessity is evaluated before production authoring where feasible.
- [ ] Canonical promotion re-verifies necessity fail-closed.
- [ ] Caller-supplied booleans/status strings cannot bypass it.
- [ ] Evidence is bound to source/owner/action/repository context.
- [ ] Same-change self-justification is rejected.
- [ ] `CREATE_CANONICAL_MODULE` has a stricter evidence requirement.
- [ ] `agentx_status` does not grant production authority.
- [ ] Gate B MERGE alone does not grant production necessity.

## Lifecycle truthfulness

- [ ] `IMPLEMENTED` means a current verified production implementation.
- [ ] A retired/deleted module is not still active because of old metadata.
- [ ] Status APIs cannot manufacture `IMPLEMENTED` without canonical evidence.

## Broader harvested-algorithm audit

- [ ] Every current `harvested_algorithms` production module has a documented real need or external contract.
- [ ] Orphan algorithms are moved/merged/retired rather than preserved by inertia.
- [ ] No new wrappers/managers were created merely to keep unused code alive.

## End-to-end regression

- [ ] Exact orphan-record replay cannot author/promote/register production code without independent need.
- [ ] Failed-need path does not invoke the real code author where pre-authoring evaluation is possible.
- [ ] Replaying retired crossover evidence does not recreate the module.
- [ ] At least one valid positive-control path still promotes through normal governance.

## Verification

- [ ] New adversarial necessity tests pass.
- [ ] Existing substance-gate tests pass.
- [ ] Write-code/authoring tests pass.
- [ ] Promotion/governance tests pass.
- [ ] Lifecycle tests pass.
- [ ] Harvested-algorithm affected tests pass.
- [ ] `compileall` passes.
- [ ] pytest collection remains clean, or any unrelated external blocker is precisely documented.

---

# 28. Required Final Report

Update the appropriate current remediation report, or create one concise report if no current report covers this change.

Include:

```text
COMMIT AUDITED:
1a0fd70ac01ca1a23670e61963d644b6a280cf07

BASE/PARENT:
c685cc12257ac311906f6e26063bb23aeaab0c84

CURRENT HEAD AUDITED:
<sha>

FITNESS_WEIGHTED_CROSSOVER DISPOSITION:
RETAINED / MOVED / MERGED / RETIRED / DELETED

INDEPENDENT PRODUCTION NEED:
<evidence or NONE>

REAL PRODUCTION CALLERS:
<paths/symbols or NONE>

CANONICAL OWNER:
<path or NONE>

SOURCE PROVENANCE:
<id/path/digest/status>

SOURCE FIDELITY:
FAITHFUL / FAITHFUL_SUBSET / MATERIAL_SEMANTIC_DRIFT / SOURCE_UNRESOLVED

ACTIVE REFERENCES REMOVED:
...

HISTORICAL REFERENCES PRESERVED:
...

FILES DELETED:
...

FILES MODIFIED:
...

LINES ADDED/REMOVED:
...

PRODUCTION-NECESSITY ENFORCEMENT:
...

NEW-MODULE ENFORCEMENT:
...

IMPLEMENTED-STATUS ENFORCEMENT:
...

OTHER HARVESTED ALGORITHMS AUDITED:
<table or concise list>

ADVERSARIAL TESTS:
...

FOCUSED TESTS:
...

PYTEST COLLECTION:
...

COMPILE:
...

REMAINING BLOCKERS:
NONE / exact blockers
```

The report must distinguish:

```text
historically promoted
currently active
currently implemented
retired/deferred/concept-only
```

Do not collapse those states.

---

# 29. Stop Condition

Stop only when a future harvested record with a mathematically real implementation and good local tests **cannot** become production code merely by:

```text
creating a new module
creating its own tests
adding itself to __init__
adding itself to _CANONICAL_MECHANISMS
adding a manifest/registry entry
claiming Gate B MERGE
or setting an "implemented/update/upgrade" status
```

The only successful production paths must be based on independent Agent_X need plus normal governance and verification.

That is the stopping condition.

---

# Core Policy

> Harvest is an evidence acquisition system, not a source-code vending machine.

The correct progression is:

```text
evidence
    ↓
distill mechanism
    ↓
dedupe / compare
    ↓
prove independent Agent_X need
    ↓
identify canonical owner
    ↓
CONCEPT/DEFER if no need
    ↓
only if needed: author minimum implementation
    ↓
substance + behavioral verification
    ↓
Gate B / governance
    ↓
canonical promotion re-checking necessity
    ↓
current lifecycle derives IMPLEMENTED from real canonical evidence
```

Never optimize for the number of harvested ideas converted into `.py` files.

Optimize for useful, integrated, non-duplicative Agent_X capability.


---

# 30. No False Closure

Do not declare success based only on:

```text
crossover file deleted
tests green
new boolean named production_needed added
new documentation says "necessity checked"
```

Closure requires proof that the rule is actually on every relevant autonomous production path and is enforced at the canonical mutation boundary.

In the final report, explicitly list every discovered autonomous evidence-to-production entry path and where the necessity requirement is enforced for that path.

If any path can still reach canonical production without verified necessity evidence, the task is not complete.


## Final self-audit before declaring completion

Answer all of these with concrete code/test evidence:

```text
Can a substantive orphan algorithm still pass because it has good unit tests?
Can a module justify itself via __init__ export?
Can a module justify itself via _CANONICAL_MECHANISMS?
Can a manifest/registry entry count as its only consumer?
Can a same-change fake caller create its own need?
Can candidate-supplied consumer_path/production_needed fields be trusted blindly?
Can missing provenance fail open?
Can stale repository-bound need evidence be replayed?
Can CREATE_CANONICAL_MODULE proceed without owner comparison?
Can an ordinary autonomous caller bypass the gate with a boolean?
Can a deleted/retired capability remain IMPLEMENTED through stale state?
Can replaying the same harvest evidence recreate the retired module?
Can a legitimate independently-needed capability still progress?
```

Every answer except the last must be **NO**.

The last must be **YES**, through the existing governed promotion path.
