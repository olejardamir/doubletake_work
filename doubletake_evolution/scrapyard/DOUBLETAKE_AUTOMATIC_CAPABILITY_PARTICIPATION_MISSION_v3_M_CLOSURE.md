# DoubleTake Automatic Capability Participation Mission
## v3 — Criterion M residual-closure edition

**Current local `main` at execution time is authoritative.**
Re-measure before acting. Do not treat any historical commit, count, test result, or diagnosis in this prompt as authoritative if current `main` disagrees.

# MISSION

Make this invariant true in the actual DoubleTake runtime:

> For every task and every meaningful subtask, DoubleTake MUST automatically discover, evaluate, activate, compose, and reuse every available capability that is materially relevant and beneficial. Capability activation MUST be proactive and automatic, not dependent on the user naming the capability, knowing that the capability exists, or a worker/LLM remembering to invoke it.

The user-facing abstraction remains:

**USER STATES INTENT.  
DOUBLETAKE DETERMINES WHICH PARTS OF DOUBLETAKE SHOULD PARTICIPATE.**

Do not weaken the mission to make the tests pass.

# VERIFIED STARTING POINT TO RECHECK

The authoritative convergence table is:

`tools/doubletake_evolve/tests/test_capability_participation_convergence_table.py`

At the time this prompt was reduced:

- A–L: PASS
- M: OPEN
- N–T: PASS
- `test_no_criterion_is_open` fails because M is still OPEN.
- `AGENTS.md` records criterion M as the active capability-participation blocker.

Treat those facts as a starting hypothesis only. Re-run/reinspect current `main`.

If another criterion has genuinely regressed, repair the regression. Otherwise do not spend iterations re-implementing already-proven A–L or N–T behavior.

# CURRENT M BLOCKER TO RE-MEASURE

Criterion M is:

> Removing capability names from a user's request does not materially reduce appropriate capability utilization.

The current measured real-inventory comparison was:

- capability named: 16/16 reached;
- capability name removed: 7/16 reached.

The important partition is more useful than the headline count:

1. A nameless request that shares a meaningful declared non-name word with its target is reached.
2. A request that merely echoes the capability's own name is intentionally refused; criterion G protects that behavior.
3. A genuine paraphrase that shares **no lexical token** with its intended capability is lost.

The held-out population measured 7 zero-overlap losses.
The independent fresh population measured 5 zero-overlap losses.

The remaining useful target is therefore **zero-overlap paraphrase/synonym discovery**, not indiscriminate relaxation of the gate.

Re-derive this partition from current `main` before changing anything.

# DO NOT REPEAT FAILED OR INVALID CLOSURES

Do not close M by:

- changing `"status": "OPEN"` to PASS without production evidence;
- weakening or deleting criterion G's irrelevant/coincidental-capability protections;
- admitting requests merely because a word matches the capability's own name;
- lowering a lexical threshold until unrelated capabilities leak through;
- fitting a semantic-score threshold to the existing M probes;
- hard-coding the current capability names, probe phrases, synonyms, or target mappings;
- rewriting the held-out probes to resemble capability metadata;
- adding per-capability routing exceptions;
- adding a giant synonym dictionary tied to the current inventory;
- making the LLM remember which capability exists;
- adding a silent fallback when the governed semantic/index path is unavailable;
- weakening criterion N's fail-closed behavior;
- declaring a provider-specific result to be a general solution when another supported model/checkpoint changes the decision boundary materially;
- adding metadata that simply memorizes the probes;
- treating retrieval as sufficient if a later production gate still discards the correct candidate;
- editing documentation instead of repairing runtime behavior.

Historical measurements already showed that:

- threshold tuning alone does not solve the problem safely;
- simply retrieving every capability does not by itself rescue candidates that the later decision path rejects;
- a raw semantic similarity floor can separate only part of the population and is model/checkpoint dependent;
- broad user-voice intent additions produced mostly memorization-level gains;
- the provenance/corpus-frequency rescue improved lexical cases but does not cross the zero-token ceiling.

Re-measure rather than blindly trusting those historical findings, but do not repeat an already disproven approach without new evidence that the relevant mechanism has changed.

# RESIDUAL OBJECTIVE

Implement the smallest general, production-reachable mechanism that allows DoubleTake to recognize materially relevant capabilities from **meaning-equivalent user language even when the request and capability share no lexical token**, while preserving the existing false-positive protections.

The repair must operate through DoubleTake's real capability authority and real routing/participation path.

Prefer extending existing capability representation, semantic indexing, evidence, routing, or governance mechanisms over creating a parallel subsystem.

The solution MAY use a non-lexical representation if that is the best fit, but it must not assume that "add embeddings" is automatically sufficient.

If a learned/semantic representation is used:

- use the existing governed/provider architecture where possible;
- preserve explicit unavailability/fail-closed semantics;
- do not fit a magic constant to the probe set;
- calibrate or discriminate using a general property that can be derived from the capability corpus/runtime evidence;
- verify that the same mechanism generalizes to independently authored paraphrases;
- verify that unrelated requests and the measured G coincidences remain refused;
- ensure future ordinary capabilities can participate without central routing edits.

The decision path that finally admits or refuses a capability must actually consume the new evidence. A representation that exists but does not affect production selection does not count.

# LOOP

Repeat until genuine convergence:

1. Inspect current `main`.

2. Run/read the authoritative A–T convergence table and the M-specific evidence.

3. Re-measure:
   - named reach;
   - nameless reach;
   - zero-overlap losses;
   - name-echo refusals;
   - unrelated negative controls;
   - the two measured G coincidences;
   - fresh/independent paraphrase behavior;
   - behavior with the semantic/index provider available;
   - behavior when that provider/index is unavailable.

4. Trace the exact production route for a zero-overlap nameless request from:
   user text
   → capability representation/index
   → retrieval/ranking
   → relevance evidence
   → refusal/rescue logic
   → final selected set
   → participation.

5. Identify the **single highest-value causal blocker** on that real route.

6. Implement the smallest general runtime change that addresses that blocker.

7. Do not modify the probe wording, target assignment, negative controls, or criterion definition merely to improve the score.

8. Add executable evidence for the new behavior.

9. Require at least:
   - the existing held-out M population;
   - the independent fresh M population;
   - the unrelated negative controls;
   - the measured G coincidence controls;
   - a no-provider/index-unavailable path;
   - a future/new capability case proving no central hard-coded integration is required.

10. Add a non-vacuity/perturbation check for the new mechanism where practical:
    deliberately break or bypass the mechanism and prove the relevant test turns red.

11. Run the M suite.

12. Run the full capability-participation convergence suite.

13. If any previously PASS criterion regresses, repair the regression before proceeding.

14. Reinspect the remaining M misses. Do not assume one improvement closes the whole class.

15. Repeat.

# M CLOSURE REQUIREMENT

Do not mark M PASS merely because nameless reach improved.

M may become PASS only when executable production-path evidence shows that removing internal capability names no longer causes a **material reduction in appropriate capability utilization**.

In particular:

- zero-overlap genuine paraphrases must be materially recoverable by the general mechanism;
- remaining misses must not simply be the same zero-overlap blindness under different wording;
- the independent fresh population must improve consistently with the held-out population;
- the two measured coincidence cases protected by G must remain refused;
- unrelated requests must remain refused;
- capability-name echo alone must not become sufficient evidence;
- no provider-specific fitted threshold may be treated as universal;
- criterion N's fail-closed no-index behavior must remain intact;
- future capabilities must inherit the mechanism from their normal declaration/registration path.

Do not define "material" after seeing the final score merely to declare success. Use the criterion's semantic requirement and adversarial evidence.

# REGRESSION GUARDS

The M repair must preserve all already-proven properties, especially:

- A: nameless automatic activation;
- B: multi-capability composition;
- D/E/P/Q: dynamic/recursive/failure/recovery reevaluation;
- F/O/T: future capability extensibility without central edits;
- G: irrelevant/coincidental capability suppression;
- H/I/J: duplicate/cycle/conflict controls;
- K: useful safe concurrency;
- L: truthful participation observability;
- N: no LLM-memory dependence and fail-closed behavior without the governed index;
- R: useful participation rather than indiscriminate activity;
- S: real capability coverage.

Do not reopen these areas unless current executable evidence shows an actual regression.

# HARD RULES

- Work on authoritative current `main`.
- Make runtime/code/test changes, not cosmetic prompt/documentation changes.
- Do not hard-code the present 16-capability inventory.
- Do not hard-code the held-out/fresh probe phrases.
- Do not special-case individual capabilities.
- Do not solve M by weakening G.
- Do not solve M by weakening N.
- Do not blindly invoke all capabilities.
- Do not depend on an LLM remembering capability names.
- Do not create a second capability authority if the existing one can be extended.
- Keep capability selection set-valued.
- Preserve governance, authorization, evidence, rollback, safety, resource, and compatibility controls.
- Commit substantive progress.
- If an iteration yields no justified runtime/code/test improvement, make no cosmetic commit.
- A helper-level success is not enough; the repair must be production-reachable.
- A semantic/index object that is constructed but not actually used in the final route does not count.
- A test fitted to the implementation is not independent evidence.

# FINAL ADVERSARIAL PASS

Once M appears closable, actively try to break the claim with new wording that was not used to design the mechanism.

Look specifically for:

- semantically obvious paraphrases with zero shared tokens that still miss;
- unrelated prose that now causes false capability activation;
- capability-name echoes that leak through;
- a provider/checkpoint swap that changes a supposedly universal fitted threshold;
- a new ordinary capability that remains invisible without central edits;
- a path that silently falls back to lexical or LLM-memory routing;
- a path where the correct candidate is retrieved but discarded later;
- a route that bypasses the new representation;
- evidence claiming a capability participated when it did not materially affect execution.

Repair any material defect and repeat.

# STOP CONDITION

Stop only when all of the following are true on current `main`:

1. criterion M is supported by real production-path executable evidence rather than a status edit;
2. the A–T table contains no OPEN criterion;
3. `test_no_criterion_is_open` passes for the right reason;
4. all previously PASS criteria remain green;
5. the zero-overlap paraphrase blindness is no longer a material cause of capability loss;
6. G's measured coincidence protections and unrelated negative controls remain intact;
7. N's fail-closed no-index behavior remains intact;
8. future ordinary capabilities inherit the repair without central routing edits;
9. the independent fresh population supports the same conclusion as the held-out population;
10. a fresh adversarial pass finds no material remaining capability-participation gap;
11. another full inspection produces no justified implementation or test delta.

Then report the mission converged and cite the executable evidence.

Until then, continue the loop.
