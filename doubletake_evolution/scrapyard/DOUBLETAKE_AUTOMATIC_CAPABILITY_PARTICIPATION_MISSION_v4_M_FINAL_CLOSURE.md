# DoubleTake Automatic Capability Participation Mission
## v4 — M Final Closure / Semantic Abstraction Edition

**YOU MUST WORK ON `main`.**

Other agents may simultaneously work on the same `main`. Treat the current local `main` at the moment of each iteration as authoritative. Do not reset, revert, overwrite, or discard unrelated work from other agents. Before editing shared files or committing, re-read current `main`, preserve compatible concurrent changes, and resolve only genuine conflicts.

Do not branch away from `main` for this mission.

---

# MISSION

Close the **one remaining Automatic Capability Participation criterion: M — USER ABSTRACTION**.

The invariant remains:

> A user should be able to state the need, problem, or intended outcome without knowing or naming DoubleTake's capability inventory, and materially appropriate capabilities should still be discovered and used.

Criterion M is:

> **Removing capability names from a user's request does not materially reduce appropriate capability utilization.**

This is now an **M-only closure mission**.

Do not reopen A–L or N–T as implementation projects unless a change required for M causes a real regression or fresh evidence proves one of them was incorrectly closed.

Preserve all already-established automatic capability participation behavior:
- discovery,
- set selection,
- composition,
- recursive reevaluation,
- dynamic registration,
- recovery-triggered reevaluation,
- conflict handling,
- bounded execution,
- observability,
- production reachability,
- no-memory dependence,
- usefulness suppression,
- extensibility.

The goal is **not more routing activity**.

The goal is:

> **correct capability participation from user intent even when the user does not know DoubleTake's vocabulary.**

---

# AUTHORITATIVE STARTING POINT

Reinspect current `main` before acting.

The expected state at the time this prompt was produced was:

- A–L: PASS
- M: OPEN
- N–T: PASS
- `test_no_criterion_is_open()` remains red because M is genuinely OPEN.
- The executable source of truth is:
  `tools/doubletake_evolve/tests/test_capability_participation_convergence_table.py`
- The main M diagnosis is exercised through:
  `tools/doubletake_evolve/collective_core/test_capability_nameless_reach.py`

At that point the table measured a material gap between requests that name capabilities and requests that express the same need without the capability name.

Do **not** copy historical counts into new claims and assume they remain true.

Re-derive the present state from current `main`.

If current measurements differ, update the diagnosis from evidence rather than preserving stale prose.

---

# WHAT M IS ACTUALLY BLOCKED ON

Do not restart the old broad capability-participation mission.

The remaining failure has already been narrowed substantially.

DoubleTake already has:
- automatic capability discovery,
- real capability inventory routing,
- deterministic lexical fingerprints,
- declared capability descriptions/intents/effects,
- semantic-service plumbing,
- relevance controls,
- coincidence suppression,
- production path coverage,
- dynamic reevaluation.

The remaining M failures are primarily cases where the user's language and the capability's declared language express the same meaning with **different domain vocabulary**.

Examples of the kind of relation involved include:

- `relay` ↔ `link`
- `drone` ↔ `worker`
- `remembered` ↔ `memory`
- `redundancy` ↔ `doubled up`

These examples are explanatory only.

**DO NOT encode these pairs or any equivalent inventory-specific synonym table into production.**

The defect is not that these four mappings are missing.

The defect is that DoubleTake still lacks a sufficiently general, safe, production-usable way to obtain the semantic relation required for these and future unseen cases.

---

# INHERITED FINDINGS — DO NOT REDISCOVER DEAD ENDS WITHOUT NEW EVIDENCE

Treat the following as established findings unless current `main` or a reproducible new measurement falsifies them.

## 1. Threshold tuning is not the solution

Do not solve M by loosening an existing lexical threshold until missed capabilities begin passing.

The M work already established that genuine nameless matches and false lexical coincidences can occupy the same measured lexical region.

A threshold that admits the desired misses can also admit requests criterion G requires DoubleTake to refuse.

Do not trade M for G.

---

## 2. A perfect relevance score alone is insufficient

The existing routing path has had cases where the correct capability ranked first and was later removed by coincidence/refusal logic.

Therefore:

> improving retrieval score is not sufficient unless the downstream decision mechanism can consume the stronger evidence.

Do not add a better scorer while leaving the decisive gate blind to its evidence and then claim M improved.

Trace the complete decision path.

---

## 3. General lexical hierarchy expansion did not safely separate the populations

A broad lexical hierarchy was measured to bridge the desired zero-overlap needs, but also bridged unrelated controls too broadly.

Do not install a general taxonomy merely because it raises recall.

It must discriminate.

---

## 4. Morphological expansion is not the residual solution

The current normalizer already performs useful morphology.

Broader affix expansion was measured to create false agreements and can break criterion G.

The remaining blocker is predominantly semantic relation across different words, not another suffix table.

---

## 5. Raw embedding similarity is not enough

General sentence-embedding approaches were measured to provide partial separation, but:
- coverage was incomplete,
- results changed materially across checkpoints,
- usable cuts were fitted to the probe population,
- no stable model-independent operating point established closure.

Do not ship a probe-fitted cosine threshold.

Do not define correctness as "works with whichever embedding model happened to be installed during this run."

---

## 6. The previous joint-reading gain was invalid

A prior apparent gain from a cross-encoder/joint-reading channel was traced to capability-name leakage in the hypotheses.

Once own-name echoes were removed, the claimed robust gain disappeared.

Do not reintroduce capability names indirectly through:
- descriptions that fall back to names,
- intents equal to the canonical name,
- generated hypotheses containing the label,
- test text copied from the capability identifier.

Criterion M cannot be closed by laundering the name through another field.

---

## 7. Corpus-coverage style widening is not sufficient

A channel that merely widens token coverage without preserving candidate-specific discrimination cannot solve M.

Coverage that admits every genuine case and every unrelated case is not relevance.

---

## 8. Declared-surface widening has already been measured

The existing work inspected multiple declared surfaces, including routing text, contract fields, implementation/source-related surfaces, and other available declared vocabulary.

The residual semantic information was not simply sitting in an unread field.

Do not repeat another "scan more strings" pass unless you can identify a genuinely new production source and measure that it discriminates.

---

# THE ACTUAL CLOSURE PROBLEM

Close this:

> Given a request that does not name a capability and may share no useful lexical token with it, DoubleTake must be able to establish enough **candidate-specific semantic evidence** to distinguish:
>
> 1. a genuine user need that the capability serves,
> 2. an unrelated request,
> 3. a misleading lexical coincidence,
>
> without relying on the user knowing the capability name.

The mechanism must generalize to capabilities and language that were not manually encoded into the router.

This is a semantic discrimination problem, not a naming problem.

---

# CONTROL-AUTHORITY REQUIREMENT

Do not accidentally create a second orchestration authority.

Current DoubleTake architecture intentionally keeps capability selection under the capability-routing/control path.

A semantic model, embedding provider, language model, lexical resource, or other semantic mechanism may provide **evidence**.

It must not silently become an ungoverned alternate controller.

If a learned/model-based component is used:

1. its role must be explicit;
2. its output must be bounded and typed;
3. the deterministic runtime must decide how that evidence is admitted;
4. failure/unavailability must have defined behavior;
5. it must not obtain mutation, execution, budget, or orchestration authority merely because it can judge semantic relevance;
6. its production use must comply with existing provider/inference authority rules.

Do not restore an old LLM-router path merely because it would be easy.

Integrate with current DoubleTake authority boundaries.

---

# DESIGN TARGET

Find and implement the smallest general mechanism that supplies the semantic evidence M lacks.

Do not presuppose one particular implementation.

Candidates may include, if current architecture supports them safely:
- a governed semantic-relation service,
- an existing provider already available to DoubleTake,
- a model-assisted entailment/relevance judgement used strictly as evidence,
- a stronger semantic representation with a justified non-probe-fitted decision rule,
- composition of multiple independent evidence channels,
- another general mechanism discovered in current `main`.

The mechanism must answer a question closer to:

> "Does this request describe a need this capability is declared to satisfy?"

rather than merely:

> "Do these strings contain similar tokens?"

But the final implementation must be justified by measurements, not by this prompt preferring a technique.

---

# HARD CONSTRAINTS

## No inventory-specific mappings

Forbidden:
- per-capability synonym dictionaries,
- handwritten aliases added specifically for failing M probes,
- conditionals naming current capability IDs,
- rules keyed to the current 16-capability inventory,
- mappings derived from the held-out test text,
- prompt examples containing the exact answer for the test case.

A capability registered tomorrow must be eligible for the same mechanism without central-router edits.

---

## No test-set fitting

Do not:
- search for a numeric threshold on the M probe set and commit that threshold;
- tune prompts against individual failing rows until the rows pass;
- use the held-out answers to author production aliases;
- measure many variants on the same set and call the best one generalization.

If a parameter is necessary, derive it from a general invariant, independent calibration population, structural property, or other evidence that does not encode the answers to M's evaluation set.

---

## No regression of criterion G

M must not be "fixed" by indiscriminately routing vaguely related capabilities.

Unrelated requests and misleading lexical coincidences must remain refused.

A gain in nameless reach accompanied by materially worse false activation is failure.

---

## Preserve criterion N

Correct capability participation must not depend on an LLM or worker **remembering that a capability exists**.

If a language/model service is used, it must evaluate candidates supplied through the actual capability inventory/discovery mechanism.

The model must not be expected to recall DoubleTake's tool names from training or conversation memory.

Inventory discovery remains runtime-owned.

---

## Preserve shadow semantics

If an existing semantic channel is configured as `shadow`, it must not affect routing merely because M needs help.

Either:
- keep it shadow and use another authorized mechanism, or
- establish and test the conditions under which it is legitimately promoted from shadow to decision evidence.

Do not make a shadow channel decisive by accident.

---

## Fail honestly when semantic evidence is unavailable

Do not construct or cache a provider/service that cannot actually answer.

Do not silently convert provider failure into fabricated confidence.

Do not report semantic evidence that was never produced.

The fallback behavior must be explicit and tested.

If the semantic source is optional, availability must be observable.

---

## No documentation-only closure

Changing:
- `status: OPEN` to `PASS`,
- the table prose,
- a report,
- a README,
- a limitation field,

does not close M.

The runtime behavior must change or new executable evidence must prove current runtime behavior already meets M.

---

## No test-only closure

A helper reachable only from a unit test does not count.

The semantic evidence path must be reachable from supported production capability routing.

---

## No cosmetic work

Do not spend mission iterations on:
- renaming,
- formatting,
- unrelated refactors,
- comments that do not alter truth,
- documentation cleanup unrelated to evidence,
- speculative framework-building.

Only material M closure work is authorized.

One exception: fix stale M-related prose when it contradicts the executable current state.

---

# REQUIRED WORK LOOP

Repeat the following until the STOP CONDITION is satisfied.

## 1. Rebase mentally on current `main`

At the start of every iteration:

- read current HEAD;
- inspect concurrent changes;
- inspect the executable A–T convergence table;
- confirm M's current status;
- run the smallest authoritative M measurement necessary to know the current residual.

Never assume the previous iteration's repository state still exists.

---

## 2. Re-derive the residual

Partition M failures by the actual stage where the correct capability is lost.

For each failure determine whether the target:
- was never retrieved,
- was retrieved but ranked below a rival,
- ranked correctly but was rejected,
- was admitted but not executed,
- was executed but not credited,
- failed because required semantic evidence was unavailable.

Do not describe all misses as one category.

Fix the stage that actually loses the capability.

---

## 3. Identify one highest-value causal defect

Choose the smallest defect whose repair could materially reduce the genuine residual **without weakening refusal behavior**.

Do not attack several speculative ideas at once.

State the hypothesis in executable terms.

Example shape:

> "The correct capability is already in the candidate set, but the decisive gate cannot observe semantic entailment evidence."

Then make that claim falsifiable.

---

## 4. Measure before implementing

Before changing production behavior, build or reuse a measurement that can distinguish:

- genuine nameless need,
- unrelated request,
- misleading coincidence,
- provider unavailable,
- future/new capability behavior.

The measurement must be capable of proving the proposed mechanism wrong.

If the measurement cannot fail when the hypothesis is false, repair the measurement first.

---

## 5. Implement the smallest production-reachable change

Integrate through existing DoubleTake architecture.

Prefer extending:
- capability contracts,
- capability semantic evidence,
- capability routing,
- semantic provider plumbing,
- existing inference/provider authority,
- existing evidence/governance paths,

over creating a parallel router or parallel agent.

Do not build a second capability system.

---

## 6. Prove both directions

Every proposed semantic mechanism must demonstrate:

### Positive direction
A genuine nameless request can reach the appropriate capability without naming it.

### Negative direction
An unrelated or coincidental request remains refused.

A mechanism with only positive examples is insufficient.

---

## 7. Prove the mechanism is used

Add evidence that fails if:
- the new semantic signal is calculated but ignored;
- the router still decides using only the old lexical path;
- the semantic mechanism is replaced with a constant;
- the production path is bypassed;
- the mechanism silently returns no evidence.

A green test for an unused helper is not closure.

---

## 8. Prove non-vacuity

For every important new guard, perform a controlled perturbation or equivalent executable falsification.

At minimum establish that:
- removing the semantic evidence makes a positive case fail;
- forcing the semantic mechanism to over-admit makes a negative/G case fail;
- disabling the production wiring makes the production-path test fail.

Do not merely assert that the guard is meaningful.

---

## 9. Run regression evidence

After every material implementation delta, run:

1. the focused M suite;
2. criterion G / irrelevant-capability protections;
3. semantic-service availability/failure tests;
4. capability-router tests affected by the change;
5. the A–T convergence table;
6. all capability-participation suites materially touched by the implementation.

If the repository defines a canonical broader suite for this subsystem, run it before closure.

Do not interpret "19 old criteria still say PASS in a dict" as non-regression.

Their cited certifiers must still pass.

---

## 10. Commit coherent evidence-backed deltas

Commit each coherent material improvement to `main`.

Do not commit:
- exploratory dead ends,
- broken partial mechanisms,
- knowingly red replacements,
- unrelated cleanup.

If an experiment disproves the hypothesis, revert only that experiment's own uncommitted changes, preserve the measurement if it adds durable knowledge, and choose the next causal hypothesis.

Never revert unrelated concurrent work.

---

## 11. Restart from current `main`

After each commit:
- re-read current HEAD,
- re-run the M residual measurement,
- re-evaluate the decision path,
- choose the next highest-value gap.

Do not continue executing a stale plan against a changed repository.

---

# REQUIRED EVALUATION POPULATIONS

M must not be closed from one friendly set.

Use executable evidence spanning all of the following.

## A. Current real inventory

The mechanism must work against representative real DoubleTake capabilities.

Synthetic-only proof is insufficient.

---

## B. Name-stripped requests

Take requests whose named form reaches the intended capability and test semantically equivalent forms that do not contain the capability's canonical name or obvious spelling variant.

The target must not be recoverable simply because the name remains hidden in punctuation, morphology, metadata fallback, or another field.

---

## C. Zero-useful-overlap semantic cases

Include cases where lexical token overlap is insufficient but the semantic relation is legitimate.

These are the core M residual.

---

## D. Unrelated negative controls

Include ordinary user requests for which none of the candidate capabilities should participate.

A semantic channel that raises every score is failure.

---

## E. Misleading coincidences

Retain cases that share a lexical token but describe a different need.

This protects G and prevents "semantic improvement" from becoming permissive routing.

---

## F. Fresh/held-out paraphrases

Maintain a set of evaluation requests not used to author production mappings, thresholds, examples, or capability-specific rules.

The production implementation must not import or inspect this evaluation corpus.

---

## G. Extensibility case

Demonstrate that a newly declared capability can benefit from the same semantic mechanism without editing central routing code or adding a special mapping for that capability.

This may use a synthetic newly registered capability only for the extensibility property; M's real-inventory proof must still remain real.

---

## H. Semantic-source unavailable case

Exercise the same production path when the richer semantic source is absent, broken, times out, or declines to answer.

The system must:
- remain bounded,
- remain truthful,
- avoid fabricated relevance,
- preserve existing safe fallback behavior.

---

# EVIDENCE MODEL

For a routed capability, internal evidence should make it possible to tell at least:

- what capability was considered;
- what declared surface was compared;
- which evidence channels contributed;
- whether richer semantic evidence was available;
- whether it supported, contradicted, or abstained on relevance;
- why the candidate was admitted or refused;
- whether the semantic evidence actually influenced the decision.

Do not add excessive telemetry.

Use existing evidence structures where possible.

---

# WHAT COUNTS AS A GENERAL SEMANTIC MECHANISM

A solution is acceptable only if its correctness does not depend on the present inventory's vocabulary.

It should have a principled path for a future capability whose declaration uses language not known when this prompt was written.

Examples of acceptable properties:

- semantic evidence is computed from the current request and current capability declaration;
- the capability inventory is discovered at runtime;
- no capability-specific table is required;
- no central router edit is required for an ordinary new capability;
- decisions can abstain instead of guessing;
- false-positive control is explicit.

The implementation may use learned components, but their output must be treated as governed evidence rather than magical truth.

---

# STALE-PROSE REPAIR

The convergence-table module has carried introductory prose that can lag the executable table.

If current `main` still contains prose claiming M is PASS while `TABLE["M"]["status"] == "OPEN"`, correct the prose as part of this mission.

Do not use that documentation repair as evidence that M is closed.

When M actually closes, update the prose to describe the final mechanism and delete obsolete M-only historical instructions that have become actively misleading.

Preserve useful measured history where it prevents regression.

---

# CLOSURE TEST

Do not weaken criterion M's meaning to make it pass.

Do not redefine "materially reduce" after looking at the result.

Use the existing executable M contract as the baseline bar.

If the current M certifier was written as an intentionally red `test_m_is_not_satisfied`, replace/invert/retire it only when executable positive evidence establishes the criterion.

The replacement must be stronger than simply deleting the red test.

---

# ADVERSARIAL FINAL PASS

When M appears closed, perform one fresh adversarial pass before changing the mission to complete.

Try to break the solution with at least these attacks:

- paraphrase the need with vocabulary absent from the capability name;
- remove every obvious lexical hint while preserving meaning;
- give an unrelated request semantically generic wording;
- create a request sharing one misleading content word;
- register a new capability after the mechanism was written;
- remove or disable the semantic provider;
- return malformed semantic evidence;
- make the provider abstain;
- make the provider over-claim relevance;
- reorder the capability inventory;
- ensure the mechanism does not rely on capability position;
- ensure capability names are not leaking through a fallback field;
- ensure a shadow-only signal cannot change the route;
- ensure a model/provider change does not silently redefine a hard-coded threshold;
- ensure two relevant capabilities can still both participate where B/K/P require composition;
- ensure a semantic miss does not bypass ordinary capability reevaluation.

If a material defect is found:
- repair it,
- add executable evidence,
- restart the closure loop.

---

# STOP CONDITION

Stop with **MISSION COMPLETE** only when all of the following are true on current `main`:

1. `TABLE["M"]["status"]` is legitimately PASS or a strictly proven equivalent accepted by the table's existing rules.

2. No A–T criterion is OPEN.

3. `test_no_criterion_is_open()` is green for the right reason.

4. M has real-inventory executable evidence showing user abstraction no longer materially reduces appropriate capability utilization.

5. The closing evidence includes nameless semantic cases that cannot be solved merely by capability-name echo or trivial lexical overlap.

6. Unrelated requests and misleading coincidences remain refused; criterion G is not weakened.

7. Correct activation does not depend on an LLM remembering the capability inventory; criterion N remains intact.

8. The semantic mechanism is production-reachable and its evidence is actually consumed by the routing decision.

9. Semantic-provider absence/failure is bounded and truthful.

10. No inventory-specific synonym dictionary, per-probe alias, or test-fitted threshold is part of the fix.

11. Extensibility remains intact for newly registered capabilities.

12. All A–L and N–T cited certifiers materially affected by the change remain green.

13. The focused M tests and relevant capability-routing/semantic/participation suites are green.

14. The final adversarial pass finds no material M defect.

15. The executable evidence table and its M-related prose agree with reality.

Only then change M to PASS and stop.

---

# BLOCKED-END CONDITION

Do not fake convergence if the remaining blocker is genuinely external.

If exhaustive measurement on current `main` proves that:
- all production-available general semantic sources have been tested,
- none can safely discriminate the M residual,
- closing M requires a new semantic dependency/provider/model/resource that is not available or cannot be legitimately introduced under DoubleTake's existing architecture,

then:

1. leave M OPEN;
2. keep `test_no_criterion_is_open()` red;
3. record the exact missing production dependency in M's executable evidence/limitation;
4. prove with executable tests that the blocker is external rather than an unexamined internal routing gap;
5. stop with **MISSION BLOCKED — EXTERNAL SEMANTIC DEPENDENCY REQUIRED**, not MISSION COMPLETE.

Do not loop forever by retrying already-disproved lexical thresholds, affix tables, embedding cuts, or name-leaking variants.

---

# FINAL RULE

Do not optimize for making the table green.

Optimize for making this statement true in the real DoubleTake runtime:

> **The user states the need. DoubleTake recognizes which capabilities can satisfy that need, even when the user does not know what those capabilities are called.**
