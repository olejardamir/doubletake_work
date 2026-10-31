# DOUBLETAKE AUTOMATIC CAPABILITY PARTICIPATION — v5 OPENCODE-LLM-ONLY FINAL CLOSURE

## Mission status and authority

You MUST work on `main`.

Other agents may simultaneously be working on the same `main`. Treat the current repository state as authoritative at every iteration. Re-read the files you are about to change immediately before editing them. Do not reset, clean, rebase, overwrite, revert, or discard unrelated work. Do not create a parallel implementation that ignores the current architecture.

Repository:

```text
https://github.com/olejardamir/DT.git
```

At the time this mission was authored, current `main` was observed around:

```text
9f99be3e5ddb80d2e77f13f19f04da11195239cb
```

That SHA is context only, NOT an authority pin. `main` may have moved. Reinspect current `main` before acting.

This mission supersedes the M-closure strategy in:

```text
DOUBLETAKE_AUTOMATIC_CAPABILITY_PARTICIPATION_MISSION_v4_M_FINAL_CLOSURE.md
```

where that strategy attempts to close criterion M by downloading, loading, benchmarking, calibrating, or depending on auxiliary embedding models, sentence-transformer checkpoints, Hugging Face models, WordNet-like semantic substitutes, or other learned semantic models.

Do NOT continue that strategy.

The closure target remains the same: finish criterion M truthfully without weakening the already-established capability-participation invariants, especially criterion G.

---

# 1. Mission objective

Close criterion **M** of DoubleTake automatic capability participation by using **only the LLM already connected through the active OpenCode runtime** for the semantic understanding that DoubleTake's deterministic lexical machinery cannot supply.

The intended architecture is:

```text
user request
    |
    v
DoubleTake deterministic capability machinery
    |
    +--> normal deterministic route succeeds
    |        |
    |        v
    |     continue normally
    |
    +--> genuine semantic gap remains
             |
             v
     active OpenCode-connected LLM
     semantic interpretation ONLY
             |
             v
     typed / bounded semantic evidence
             |
             v
     DoubleTake deterministic validation,
     authority, routing, conflict control,
     governance, execution and evidence
```

The architecture is NOT:

```text
DoubleTake
  -> download MiniLM
  -> download BGE
  -> try sentence-transformers
  -> try Hugging Face checkpoints
  -> try model-specific thresholds
  -> try whichever local embedding model happens to exist
  -> let a model directly rank/execute capabilities
```

Criterion M must be closed by semantic interpretation from the already-connected OpenCode LLM, not by adding another model ecosystem.

---

# 2. Non-negotiable model constraint

For automatic capability participation, exactly **one learned semantic authority** is permitted:

> the LLM already selected and connected through the active OpenCode runtime.

Nothing else may be introduced or relied upon to close M.

## 2.1 Forbidden

Do NOT:

- download any model weights;
- install any model package in order to solve M;
- install or fetch `sentence-transformers`, `transformers`, Hugging Face models, BGE, MiniLM, E5, Cohere embeddings, OpenAI embeddings, local GGUF models, ONNX embedding models, spaCy model packages, or any other learned semantic model;
- call `SentenceTransformer("...")` in a way that can resolve or download a remote model;
- call `from_pretrained(...)` for M;
- use `huggingface_hub` to acquire a model;
- use `wget`, `curl`, Python HTTP calls, package managers, model managers, or OpenCode tools to obtain model weights;
- use `DOUBLETAKE_EMBEDDING_MODEL` as the solution to M;
- select a second model from OpenCode's model catalogue;
- call `get_models()` and choose a "better" model for this task;
- hardcode `all-MiniLM-L6-v2`, `BAAI/bge-base-en-v1.5`, or any similar checkpoint into the M path;
- use an embedding/vector model as a hidden fallback;
- use a capability-specific synonym dictionary;
- encode the held-out expected answers into rules, prompts, aliases, examples, or lookup tables;
- tune thresholds against the M probes and call the result generalization;
- weaken criterion G in exchange for M recall;
- mark M PASS because a synthetic provider returned the expected capability;
- silently fall back to a different learned model when OpenCode is unavailable.

Do not install dependencies during this mission unless an already-declared repository dependency is genuinely broken for unrelated reasons. A new model dependency is not permitted.

## 2.2 Required

The semantic path MUST:

- reuse the canonical OpenCode provider/agent connection that DoubleTake already owns;
- use the provider/model identity already selected by that active OpenCode connection;
- not choose or switch models;
- not create a new model-selection authority;
- not use conversation memory as semantic state;
- not depend on any external model cache;
- not depend on internet access except the already-existing OpenCode transport if that transport itself is remote;
- fail closed to DoubleTake's deterministic behavior when the OpenCode semantic call is unavailable, times out, fails validation, or returns uncertain/malformed output.

A new isolated OpenCode **session** is allowed if isolation is needed, provided it uses the same already-connected provider/model configuration. A new model/provider is not allowed.

---

# 3. Critical current-state findings to re-verify

Do not trust this list blindly. Reinspect current `main`, then keep, correct, or supersede each finding with executable evidence.

At prompt-authoring time:

1. `tools/doubletake_evolve/tests/test_capability_participation_convergence_table.py`
   still records criterion M as:

   ```python
   "status": "OPEN"
   ```

2. `test_no_criterion_is_open()` therefore correctly prevents final closure.

3. `tools/doubletake_evolve/collective_core/test_capability_nameless_reach.py`
   contains:

   ```python
   def test_m_is_not_satisfied(...)
   ```

   and deliberately fails while removing a capability name materially reduces appropriate utilization.

4. The remaining M failures are semantic/paraphrase gaps such as concepts equivalent to:

   ```text
   remembered        <-> stored memory
   workers            <-> subordinate workers / drones
   link               <-> outbound relay / connection
   doubled up         <-> redundancy
   single point       <-> non-redundant dependency
   ```

5. The existing deterministic lexical machinery is useful and must not be discarded. It already protects criterion G and handles many cases correctly.

6. The M investigation accumulated experiments around sentence embeddings, lexical hierarchy, morphology, thresholds, corpus frequency, and related mechanisms. Those experiments may be useful historical evidence, but they are not the desired runtime architecture for M.

7. `test_capability_nameless_reach.py::_load_embedder()` was observed calling:

   ```python
   SentenceTransformer(
       "sentence-transformers/all-MiniLM-L6-v2",
       device="cpu",
   )
   ```

   without `local_files_only=True`.

   That call is capable of model acquisition and is prohibited by this mission.

8. `tools/doubletake_evolve/models/local_sentence_transformer_embedding.py`
   is more careful and uses local-only loading, but an embedding provider is still NOT the M solution required by this mission.

9. `tools/doubletake_evolve/providers/opencode_provider.py` already provides the OpenCode transport used by DoubleTake. Reuse existing provider authority rather than inventing a second LLM client inside capability routing.

10. DoubleTake already contains provider-authority guards that deliberately keep routine control/ranking decisions model-independent. In particular, capability routing must not simply regain a `provider=` parameter and let a model rank the candidates.

This mission must preserve that architectural distinction.

---

# 4. Architectural rule: LLM cognition is allowed; LLM control authority is not

The OpenCode LLM is allowed to perform the one thing DoubleTake currently lacks:

> interpret natural-language meaning across paraphrases and semantic distance.

The OpenCode LLM is NOT allowed to become the owner of capability control.

The following remain DoubleTake-owned and deterministic:

- capability inventory authority;
- whether a capability exists;
- whether it is routable;
- permission checks;
- safety classification;
- conflict/exclusive-resource handling;
- duplicate suppression;
- participation budgets;
- execution ordering;
- execution;
- retry/recovery policy;
- capability registration;
- capability publication;
- final admissibility validation;
- evidence recording;
- fail-closed behavior.

Do not add a model call directly inside `rank_candidates()` or equivalent routine ranking code.

Do not restore the retired architecture where a provider chooses the winning capability.

If a model-reaching function is introduced, it must be truthfully classified in DoubleTake's provider-authority audit as an interpretive/cognitive model use, not disguised as deterministic routine control.

Do not weaken the provider-authority audit to make the new path pass.

---

# 5. Preferred semantic design

The preferred solution is a **semantic interpretation / canonicalization stage**, not an LLM capability picker.

The LLM should transform the user's request into bounded, literal, semantically equivalent language that DoubleTake can reason over deterministically.

Example:

```text
original:
"is the link out doubled up or is it a single point"

semantic interpretation:
"determine whether the outbound connection has redundancy or is a single point of failure"
```

Then DoubleTake's normal capability machinery can match concepts such as:

```text
"Redundancy snapshot of the outbound relay"
```

without the LLM selecting `relay_health` directly.

Likewise:

```text
original:
"how much have we remembered, broken down"

semantic interpretation:
"report counts of stored information grouped by category"
```

The LLM is translating meaning, not issuing a routing decision.

## 5.1 Strong preference: do not give the semantic interpreter capability IDs

Prefer an interpreter that sees:

- the current request;
- a narrow instruction defining semantic normalization;
- no conversation history;
- no capability ID;
- no capability canonical name;
- no expected answer;
- no held-out labels.

The ideal output is general semantic language that would still be useful if the capability inventory changed tomorrow.

If current measurements prove that inventory grounding is necessary, do NOT jump directly to capability selection. The next acceptable design is to give the model **published descriptive surfaces without capability names/IDs** and ask it only to restate the request in the vocabulary of the available domain. DoubleTake must still perform the mapping.

Any move from inventory-free interpretation to inventory-grounded interpretation must be justified by an executable A/B measurement, not preference.

## 5.2 Do not ask for chain-of-thought

The runtime must request only the final structured interpretation.

Do not request, store, parse, or depend on private reasoning traces.

A suitable conceptual schema is:

```json
{
  "schema_version": "1",
  "literal_intent": "short literal restatement",
  "paraphrases": [
    "equivalent paraphrase 1",
    "equivalent paraphrase 2"
  ],
  "uncertain": false
}
```

This is illustrative, not a requirement to copy the field names.

The final schema must be:

- small;
- versioned;
- strictly validated;
- bounded in field count and length;
- free of capability decisions;
- free of executable instructions;
- free of tool calls;
- free of arbitrary nested content.

---

# 6. The OpenCode call must be isolated and bounded

The semantic call must use the same active OpenCode provider/model, but it must not inherit arbitrary conversation history.

Criterion N must not be broken while fixing M.

Therefore:

- use a fresh/isolated semantic request context;
- send only the semantic-normalization instruction and current user request, plus explicitly justified published descriptive context if needed;
- do not send previous chat turns;
- do not read DoubleTake memory to decide the interpretation;
- do not rely on an OpenCode session that contains prior unrelated prompts;
- do not expose secrets, repository credentials, API keys, environment dumps, or private filesystem content;
- do not allow the semantic request to execute tools;
- do not allow it to edit files;
- do not allow it to browse the web;
- do not allow it to launch subagents;
- enforce a timeout;
- bound input and output size;
- reject malformed output;
- reject output that does not satisfy the schema.

If the existing provider abstraction has no true no-tools/stateless JSON call, add the narrowest reusable provider-level primitive needed to support one.

Do NOT misuse the existing plan-specific structured-output schema merely because it already returns JSON.

Do NOT duplicate OpenCode HTTP/auth/session logic inside the capability package if the provider layer already owns it.

---

# 7. Provider reuse rule

Find the canonical provider/agent-client instance already used by the active DoubleTake/OpenCode runtime.

Thread the semantic-interpreter dependency through an appropriate existing runtime/session boundary.

Do NOT:

- instantiate `OpenCodeProvider` ad hoc inside `capability_router.py`;
- look up a model from an ambient global inside routine ranking;
- create a second independent provider registry;
- hardcode the OpenCode base URL;
- hardcode the OpenCode password;
- hardcode a model ID;
- silently start a different OpenCode server solely for M if an active canonical provider exists;
- copy provider credentials into persisted evidence.

If an isolated semantic OpenCode session is required, derive it from the existing provider configuration/authority while preserving the current provider and model identity.

The semantic path must be able to state, in non-secret evidence, that it used:

```text
provider family: OpenCode
active model identity: <already selected identity>
semantic mode: isolated / no-tools / bounded
```

Do not persist tokens or passwords.

---

# 8. Deterministic routing must remain deterministic for a fixed semantic input

The existing provider-independence invariant is valuable and must survive.

For a fixed tuple:

```text
(original request, validated semantic interpretation, capability inventory)
```

the DoubleTake routing result must be deterministic.

The model may produce semantic evidence. It may not participate again in:

- sorting candidates;
- breaking ties;
- choosing conflicts;
- choosing execution order;
- deciding retries;
- deciding permissions;
- deciding whether a safety rule applies.

This means the clean architectural seam is:

```text
OpenCode semantic interpretation
        |
        v
validated immutable semantic evidence
        |
        v
deterministic DoubleTake routing
```

not:

```text
DoubleTake router
        |
        v
"LLM, which capability should I run?"
        |
        v
run whatever the LLM says
```

---

# 9. Preserve criterion G

M is not closed if irrelevant capabilities become easier to invoke.

All existing G protections remain binding.

At minimum, preserve the behavior represented by the existing coincidence/negative-control evidence, including the cases around requests that merely echo words such as:

```text
execution
continuous
```

without actually asking for the corresponding capability.

A semantic repair must demonstrate BOTH:

```text
more appropriate nameless needs are reached
AND
irrelevant / coincidence controls remain refused
```

No trade is permitted.

Do not weaken:

- coincidence protections;
- negative-control expectations;
- conflict rules;
- safety rules;
- routability checks;
- validation gates.

If a proposed semantic interpretation improves M but makes any established G test fail, reject the proposal and continue.

---

# 10. Triggering the OpenCode semantic interpreter

Do not call the LLM gratuitously on every routing operation unless measurement proves that is required.

Prefer a bounded semantic-rescue trigger.

A good target shape is:

1. run the normal deterministic capability path;
2. if it produces a valid result with real descriptive evidence, keep it;
3. if it genuinely cannot resolve the request because semantic signal is absent or insufficient, invoke the OpenCode semantic interpreter;
4. validate the returned semantic interpretation;
5. rerun deterministic capability reasoning using the original request plus the validated interpretation;
6. accept only a result that passes all existing deterministic authority and G constraints.

The trigger must be derived from runtime state, not a list of known M probes.

Do not write:

```python
if "remembered" in request:
    ...
```

or any equivalent disguised lookup.

Do not make the trigger depend on capability names appearing in the user request.

The M property is specifically about working when those names are absent.

---

# 11. Semantic interpretation must not silently mutate the user's intent

The interpreter is allowed to clarify or paraphrase.

It is NOT allowed to add a task the user did not request.

Add validation/evidence for semantic drift.

At minimum:

- preserve the requested operation type where possible;
- preserve negation;
- preserve important entities;
- preserve quantity/time constraints;
- preserve whether the user asked for status, listing, action, explanation, etc.;
- do not convert an unrelated request into a capability-shaped request merely to obtain a match.

If the semantic output is uncertain or materially expands the task, fail closed to the original deterministic path.

Do not invent a numeric "semantic confidence threshold" fitted on the M probes unless the repository already has an independently justified invariant that applies here. Prefer explicit enum/state validation over fitted scalar cutoffs.

---

# 12. Remove model-download behavior from the M surface

This is an immediate mandatory repair, independent of whether M closes in the same iteration.

Reinspect:

```text
tools/doubletake_evolve/collective_core/test_capability_nameless_reach.py
```

and remove or retire the M-path code that can resolve/download external sentence-transformer checkpoints.

In particular, no M test may contain behavior equivalent to:

```python
SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
```

unless the call is provably local-only and is retained solely as non-authoritative historical evidence.

However, under this mission the preferred result is stronger:

> M closure must not depend on sentence-transformer tests at all.

Also inspect any M-related tests or scripts for:

- `sentence_transformers`;
- `transformers`;
- `huggingface_hub`;
- `from_pretrained`;
- `DOUBLETAKE_EMBEDDING_MODEL`;
- model cache probing;
- remote model names;
- download helpers;
- model benchmark loops.

Classify each occurrence as:

```text
REMOVE FROM M
RETAIN AS UNRELATED / HISTORICAL
PROHIBITED PRODUCTION REACH
```

Do not delete unrelated functionality merely to make a grep empty. The requirement is architectural reachability, not cosmetic deletion.

---

# 13. Add a permanent no-model-acquisition guard

Add executable evidence that prevents this regression from returning.

The guard must prove that the automatic capability-participation/M path cannot cause auxiliary model acquisition.

It should cover at least:

- production modules reachable from automatic capability participation;
- M certifier tests;
- M proof scripts.

The guard should detect the relevant acquisition patterns structurally where practical, including direct model constructors and common pretrained/download APIs.

Do not use a fragile substring test over prose.

The guard must have a non-vacuity test proving it detects a synthetic prohibited model-acquisition call.

The guard must NOT falsely ban the OpenCode provider transport.

The intended invariant is:

```text
automatic capability participation
    may reach active OpenCode LLM
    may NOT acquire another learned model
```

If a live OpenCode proof is run, constrain its egress so no model hub/download endpoint is needed. The proof must succeed with model-hub/network model acquisition disabled.

---

# 14. Testing strategy: mechanism tests and semantic proof are different

Do not confuse a fake-provider unit test with proof that the real OpenCode LLM understands the request.

Use two layers.

## Layer A — deterministic/unit tests

Use fake/stub semantic outputs to test:

- provider seam wiring;
- isolation;
- schema parsing;
- malformed response rejection;
- timeout/failure behavior;
- no-tool behavior where observable;
- deterministic routing from fixed semantic evidence;
- provider-authority classification;
- G preservation;
- fail-closed fallback;
- no model download/acquisition.

These tests may use synthetic model responses because they test plumbing, not semantic intelligence.

## Layer B — real OpenCode semantic proof

Create or adapt a focused proof that uses the **actual active OpenCode-connected LLM** and no other learned model.

It must exercise real nameless requests against the real routable capability inventory.

It must not contain the expected capability mapping in the semantic prompt.

It must record enough evidence to show:

- OpenCode was actually consulted;
- which already-active model identity served the call;
- no auxiliary semantic model served the call;
- the returned semantic interpretation;
- the deterministic router result;
- whether the target was reached;
- whether negative controls remained clean.

Do not call the live proof "passing" if OpenCode was unavailable and the test skipped.

A skip is not closure evidence.

---

# 15. M proof populations

Reuse the existing real M populations where valid rather than inventing an easier benchmark.

At minimum include:

1. the current held-out nameless requests;
2. the current fresh held-out nameless requests;
3. the negative controls;
4. the existing G coincidence controls;
5. name-present counterparts where the M comparison requires them.

Do not rewrite the test requests to make the LLM look better.

Do not feed the target labels to the LLM.

Do not add the probes themselves to capability descriptions/intents.

Do not add aliases derived from these probes.

If an existing probe is discovered to be invalidly labelled, repair the label only with independent evidence and record the reason.

---

# 16. Required semantic non-vacuity

A closure test must prove the OpenCode semantic stage is load-bearing.

At minimum, demonstrate these perturbations:

### A. Disable semantic interpretation

Force the semantic interpreter to return no interpretation.

Expected:

- M loses the semantic gains and the M property fails again;
- G should remain safe.

### B. Return malformed output

Expected:

- output is rejected;
- no capability is activated solely because parsing failed;
- deterministic fallback remains intact.

### C. Return an unrelated but schema-valid paraphrase

Expected:

- DoubleTake does not treat "valid JSON" as "valid semantic evidence";
- either the deterministic route refuses it or semantic-drift validation blocks it.

### D. Attempt to reintroduce a prohibited auxiliary model

Inject a synthetic model-acquisition call into the guarded surface.

Expected:

- the no-model-acquisition certifier fails.

### E. Attempt to let a provider directly rank candidates

Reintroduce a provider/model reach into the routine routing/ranking owner.

Expected:

- existing provider-authority/provider-independence guards fail.

### F. OpenCode unavailable

Expected:

- no second model is selected;
- no download is attempted;
- no fake PASS is produced;
- the route degrades honestly to the deterministic path with explicit evidence.

---

# 17. Criterion N must remain true

Do not fix M by introducing conversation-memory dependence.

Reinspect criterion N's exact current meaning and tests.

The semantic stage must be a function of the current request plus explicitly permitted published context, not prior chat memory.

Add a test showing that two semantically identical calls receive the same permitted input regardless of unrelated prior conversation state.

If the active OpenCode provider normally maintains a conversational session, create an isolated semantic session or use an existing stateless/no-history call path.

Do not delete or weaken `test_route_without_semantic_index_fails_closed` or equivalent N evidence merely because the architecture has evolved. If the test has become semantically stale, replace it with a stronger test for the same invariant and document why.

---

# 18. Evidence must distinguish model cognition from model authority

Introduce an immutable/typed evidence record for the semantic stage if no equivalent already exists.

It should make the following distinguishable:

```text
not_needed
served_by_opencode
opencode_unavailable
opencode_timeout
opencode_failed
malformed_response
semantic_drift_rejected
uncertain
```

Names may differ, but these states must not collapse into one silent fallback.

Record:

- semantic prompt/schema version;
- non-secret provider family;
- non-secret active model identity if available;
- whether the call was isolated/no-tools;
- a digest of relevant capability/inventory state if inventory grounding is used;
- validated interpretation;
- reason for acceptance/rejection;
- downstream deterministic route outcome.

Do not record:

- API keys;
- passwords;
- auth headers;
- raw secret environment variables.

If persisted, follow the repository's existing governed-artifact conventions rather than inventing an ungoverned JSON dump.

---

# 19. Do not create a second semantic subsystem if one can be adapted cleanly

Before adding a new module, inspect:

```text
tools/doubletake_evolve/providers/opencode_provider.py
tools/doubletake_evolve/providers/direct_agent_client.py
tools/doubletake_evolve/collective_core/capability_semantic.py
tools/doubletake_evolve/collective_core/capability_router.py
tools/doubletake_evolve/collective_core/capability_participation.py
tools/doubletake_evolve/provider_authority_audit.py
tools/doubletake_evolve/tests/test_capability_routing_is_provider_independent.py
tools/doubletake_evolve/tests/test_provider_wiring.py
tools/doubletake_evolve/collective_core/test_capability_nameless_reach.py
tools/doubletake_evolve/tests/test_capability_participation_convergence_table.py
```

Also inspect the actual current ingress/session path that owns the active OpenCode provider.

Reuse the narrowest existing seam that satisfies the mission.

Do not force the implementation into a file merely because this prompt named it.

---

# 20. Performance and boundedness

The semantic rescue must be bounded.

Requirements:

- no unbounded LLM loop;
- no "ask again until the model agrees";
- no recursive capability-semantic self-calls;
- no per-capability network call if one bounded interpretation call can serve the request;
- no hidden retry storm;
- use the existing provider retry/timeout policy where appropriate;
- semantic output size is bounded;
- semantic interpretation has an explicit per-request call budget;
- repeated identical retries within the same participation round must not multiply model calls.

Prefer one semantic-normalization call per unresolved request/reevaluation round.

If caching is introduced, it must be keyed by sufficient semantic/provenance state and must not introduce cross-user or stale-inventory leakage.

Do not add caching unless measurement shows it is needed.

---

# 21. Concurrency and reevaluation

Automatic capability participation already reevaluates under multiple runtime triggers.

Ensure the semantic rescue does not:

- run twice concurrently for the same exact participation round without need;
- cause an infinite reevaluation cycle;
- create a semantic interpretation whose own output is reinterpreted indefinitely;
- bypass repeat-key suppression;
- bypass max-round limits.

A semantic interpretation is evidence for the current round, not a new user request that recursively starts another semantic interpretation.

---

# 22. Migration of the existing M evidence

The existing M investigation contains valuable negative findings. Do not blindly delete them.

Refactor the evidence so it clearly separates:

```text
historical eliminated approaches
current production architecture
current closure certifiers
```

Embedding-model experiments may remain as historical/offline evidence only if:

- they cannot download anything;
- they are not required to run for M closure;
- they are not part of the production path;
- they do not make criterion M environment-dependent;
- their presence does not imply they are supported semantic dependencies.

Prefer moving stale exploratory claims out of the active M closure row rather than leaving hundreds of lines of superseded architecture in the PASS justification.

The convergence table should describe the mechanism that actually ships.

---

# 23. Update the convergence table only when earned

Do NOT change:

```python
"M": {"status": "OPEN", ...}
```

to PASS early.

M becomes PASS only when ALL closure gates below are green.

When it is earned:

1. change M to `PASS`;
2. replace the current enormous OPEN limitation with a concise, current description of the shipped mechanism and its remaining honest limitations;
3. cite the exact executable certifiers for:
   - nameless-use preservation;
   - OpenCode semantic interpretation;
   - G preservation;
   - N/no-memory preservation;
   - no auxiliary model acquisition;
   - provider-authority separation;
   - OpenCode failure fallback;
   - real live OpenCode proof;
4. make `test_no_criterion_is_open()` pass for the right reason.

Do not mark `NOT-APPLICABLE-BY-PROVEN-EQUIVALENCE`. M is a real property and must be satisfied.

---

# 24. Closure gates

You may declare this mission complete only if every item below is demonstrated.

## Gate 1 — No auxiliary-model acquisition

Automatic capability participation and its M certifiers cannot download, select, or require a second learned model.

PASS requires executable non-vacuous evidence.

## Gate 2 — Active OpenCode LLM is the only learned semantic path

The semantic interpretation used for M is served by the active OpenCode-connected model already selected by the runtime.

No model switching.

No fallback model.

## Gate 3 — OpenCode does semantic interpretation, not capability authority

No direct model ranking/selection authority is reintroduced into routine routing.

Existing provider-independence/provider-authority safeguards remain green.

## Gate 4 — Nameless M property

Removing the capability name no longer materially reduces appropriate utilization on the governed M populations.

The existing negative test must become a positive property, not be skipped or deleted.

## Gate 5 — G remains intact

All existing negative controls and coincidence controls remain refused as required.

No M/G trade.

## Gate 6 — N remains intact

The semantic result does not depend on prior conversation memory or hidden state.

## Gate 7 — Real inventory

The M proof must exercise the actual routable capability inventory, not only synthetic capabilities.

## Gate 8 — Real OpenCode proof

A live proof against the already-connected OpenCode LLM passes.

A skipped live test is not evidence.

## Gate 9 — Honest failure

When OpenCode is unavailable or returns invalid data:

- no model is downloaded;
- no second model is selected;
- no unsafe capability is activated;
- fallback is explicit and bounded.

## Gate 10 — No probe fitting

No expected-answer map, per-capability synonym list, probe-derived alias list, or fitted semantic threshold is present.

## Gate 11 — Non-vacuity

The semantic mechanism and all new guards demonstrably fail under targeted perturbations.

## Gate 12 — Collection

Every certifier relied on for M closure is collected by the repository's authoritative test configuration or explicitly by the repository's evidence-collection mechanism.

A green test that `pytest` never collects is not evidence.

## Gate 13 — Convergence table

M is truthfully `PASS`, and `test_no_criterion_is_open()` passes.

## Gate 14 — No unrelated regression

Focused affected suites pass, and the repository-wide/default test result is checked and reported honestly.

Do not hide pre-existing unrelated failures. Distinguish them from failures caused by this mission.

---

# 25. Minimum focused test set

Determine the exact current paths, but at minimum run the relevant current equivalents of:

```text
tools/doubletake_evolve/collective_core/test_capability_nameless_reach.py
tools/doubletake_evolve/collective_core/test_capability_participation.py
tools/doubletake_evolve/collective_core/test_capability_router.py
tools/doubletake_evolve/collective_core/test_capability_relevance_floor_calibration.py
tools/doubletake_evolve/collective_core/test_capability_control_audience.py
tools/doubletake_evolve/collective_core/test_capability_retrieval_channel_evidence.py
tools/doubletake_evolve/tests/test_capability_routing_is_provider_independent.py
tools/doubletake_evolve/tests/test_provider_wiring.py
tools/doubletake_evolve/meta_reasoning/tests/test_meta_provider_authority_convergence.py
tools/doubletake_evolve/tests/test_capability_participation_convergence_table.py
```

Also run every new semantic-interpretation/no-download test you add.

Then run the repository's authoritative broader/default test command and report the result.

Do not use test exclusion to manufacture green.

---

# 26. Required static and runtime searches before closure

Before declaring completion, search the M/capability-participation reachability surface for at least:

```text
SentenceTransformer
sentence_transformers
transformers
huggingface
from_pretrained
DOUBLETAKE_EMBEDDING_MODEL
bge-
MiniLM
embedding model
download
provider.complete
OpenCodeProvider(
get_models(
```

Interpret findings structurally.

The closure claim must be:

```text
No auxiliary learned model is reachable from automatic capability participation.
The only learned semantic call reachable for M is the governed active OpenCode LLM.
```

Do not claim the whole repository contains no embedding code unless you actually prove that much larger statement.

---

# 27. Implementation quality rules

Do not:

- duplicate large existing modules;
- add a second router;
- add a second capability registry;
- add a second provider registry;
- introduce a global mutable "current semantic result";
- add magic constants without independent justification;
- add massive comments instead of executable guards;
- leave dead experimental code on the production path;
- catch `Exception` and silently pretend semantic success;
- treat "no exception" as evidence that OpenCode served the request;
- make the real live proof optional and still mark M PASS;
- solve one held-out set by embedding its wording into the prompt.

Prefer:

- small typed objects;
- explicit enums;
- immutable evidence;
- narrow interfaces;
- fail-closed validation;
- derived scope;
- tests that prove the guard can fail;
- one authoritative implementation path.

---

# 28. The coding loop

Execute this mission iteratively.

Each iteration:

1. sync your mental model to current `main`;
2. inspect the current M evidence and provider wiring;
3. identify the smallest unresolved blocker;
4. make the smallest coherent production change;
5. add or strengthen executable evidence for that change;
6. run the focused tests;
7. run the no-auxiliary-model guard;
8. run the real OpenCode semantic proof when the implementation reaches that stage;
9. re-read criterion G and N evidence;
10. update the convergence record only if the evidence changed;
11. repeat.

Do not continue exploring unrelated semantic mechanisms after the OpenCode architecture is implemented.

Do not enter an infinite research loop.

The loop stops only when:

```text
all closure gates pass
```

or when a genuine architectural blocker remains that cannot be repaired without violating a mission invariant.

If blocked, leave M OPEN and state the exact executable failing condition.

---

# 29. Completion report

At the end, output a compact factual report containing:

```text
STATUS: PASS / OPEN

main HEAD:
<sha>

Production files changed:
<paths>

Tests/evidence changed:
<paths>

OpenCode semantic path:
<exact entrypoint -> provider seam -> validation -> deterministic routing path>

Active learned semantic dependencies:
OpenCode only / violation

Auxiliary model downloads:
0 / violation

M:
PASS / OPEN
evidence: <exact tests>

G:
PASS / regression
evidence: <exact tests>

N:
PASS / regression
evidence: <exact tests>

Provider authority:
PASS / regression
evidence: <exact tests>

Live OpenCode proof:
PASS / FAIL / NOT RUN
provider/model identity: <non-secret identity>

Default/broader pytest:
<exact result>

Remaining blocker:
none / exact blocker
```

Do not report PASS if the live OpenCode proof was skipped.

Do not report PASS if `test_no_criterion_is_open()` still fails because M remains OPEN.

Do not report PASS if any test requires a downloaded auxiliary model.

---

# 30. Final definition of done

This mission is DONE only when DoubleTake can truthfully demonstrate all of the following at once:

> A user can express a genuine capability need without knowing or naming the capability. When DoubleTake's deterministic language representation cannot bridge the wording, DoubleTake uses only the already-connected active OpenCode LLM to obtain a bounded, isolated semantic interpretation. The LLM does not choose or execute capabilities. DoubleTake validates that interpretation and retains deterministic authority over routing, governance, conflicts, execution and evidence. Appropriate nameless capabilities are no longer materially lost; irrelevant/coincidental capabilities remain suppressed; prior conversation memory is not required; no auxiliary model is downloaded, selected, benchmarked or required; OpenCode failure is explicit and fail-closed; and the complete claim is backed by collected, non-vacuous executable evidence plus a real live proof against the active OpenCode LLM.

Anything weaker is not final closure.
