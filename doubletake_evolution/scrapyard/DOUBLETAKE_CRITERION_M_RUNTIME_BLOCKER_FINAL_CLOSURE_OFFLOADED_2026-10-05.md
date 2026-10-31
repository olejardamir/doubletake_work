# DoubleTake — Criterion M Runtime Blocker Final Closure
## OFFLOADED TERMINAL RUNTIME REVALIDATION — 2026-10-05

Repository:

`/home/glompy/Desktop/OTHER_PROJECTS/DT/`

Work directly on the authoritative `main` branch.

Other agents may simultaneously work on the same `main`. Reinspect current repository and runtime state before every material decision. Preserve concurrent work. Do not reset, clean, or overwrite unrelated changes.

---

# 1. Mission

This is the reduced terminal-delta prompt derived from:

`DOUBLETAKE_CRITERION_M_RUNTIME_BLOCKER_FINAL_CLOSURE_v1.md`

Do **not** restart Criterion M implementation.

The DoubleTake-side Criterion M machinery is already substantially complete and the current remaining blocker has been measured as external/runtime-side.

Your only job is:

> Revalidate the currently active OpenCode runtime and the existing Criterion M live-proof chain. Close M only if the runtime now genuinely exposes the required native structured-output capability and the production proof satisfies M while preserving G. Otherwise preserve M as OPEN and terminate with the measured HONEST BLOCKER result.

This is a revalidation/terminal-closure task, not a new architecture task.

---

# 2. Historical starting state to recheck

At the time this prompt was offloaded:

- GitHub `main`: `e117f732b7a1b582c3ef746c1fee810d46d46d84`
- latest Criterion-M live evidence commit observed:
  `ff16abdf0537244d241bbb538d50ae2ed388a2b5`
- live evidence:
  `reports/capability_semantic_live/evidence.json`
- live proof runner:
  `tools/doubletake_evolve/runtime/capability_semantic_live_proof.py`
- model-free verifier:
  `tools/doubletake_evolve/collective_core/capability_semantic_live_evidence.py`
- transport probe:
  `tools/doubletake_evolve/runtime/capability_semantic_transport_capability.py`

The live evidence was bound to measured source content at:

`402150bb16ceae12beefbd6b1f19a8b09dc9d6ab`

with measured surface digest:

`sha256:2913e724108054637f27816d514857bfe815b8149cedb2cdc0ba7bdb9cda98ad`

At offload time all 25 measured source files were byte-identical at current `main`, so the evidence remained content-current even though HEAD had advanced.

Recheck this. Do not assume these SHAs remain current.

---

# 3. Current measured Criterion M state

At offload time the authoritative live measurement was:

```text
rows:                  34
reached:               10/34
m_positive:            false
g_intact:              true
transport.verdict:     STRUCTURED_REQUEST_REFUSED
semantic calls total:  0
max semantic calls:    0 / 2 per request
auxiliary models:      none
```

The active runtime was OpenCode `2.0.12`, serving model:

`big-pickle`

The blocker had been independently established as follows:

1. `POST /api/session/{id}/prompt` required `text`.
2. The prompt endpoint used `additionalProperties: false`.
3. The endpoint did not expose the required request fields:
   - `model`
   - `tools`
   - `format`
   - `system`
   - `parts`
4. Posting the required §37 native structured request returned HTTP 400:
   `InvalidRequestError: Missing key at ["text"]`.
5. The served OpenAPI surface exposed no usable native JSON-schema structured-output contract for this path.
6. The runtime binary contained structured-output internals, but they were not exposed through the HTTP interface available to DoubleTake.
7. Therefore the semantic compiler could not be called.
8. The deterministic path remained active.
9. G stayed intact.
10. M stayed OPEN.

The live-evidence verifier was expected to fail on exactly the honest Criterion-M target defect rather than certify a false PASS.

---

# 4. Non-vacuity state

At offload time the complete Criterion-M/runtime proof surface had been measured as:

```text
26 fired
0 blind
0 broken
0 no-op
```

This total includes the transport probe's own non-vacuity rows.

Do not preserve `26` as a magic number if current repository scope derives a different count.

Re-derive the current intended rows from the current scripts.

A non-vacuity result counts only when:

- the perturbation actually changes the intended variable;
- pytest reaches a valid verdict;
- the target guard goes red;
- no collection/setup failure is being counted as a firing;
- no stale replacement is counted as coverage.

---

# 5. Authority order

Use this authority order:

1. current live OpenCode runtime;
2. current DoubleTake `main`;
3. current production Criterion-M path;
4. current live-proof runner;
5. current transport-capability probe;
6. current verifier;
7. current tests/non-vacuity drivers;
8. current committed evidence;
9. this prompt.

Do not let old evidence override a changed runtime.

Do not let prose override executable measurement.

---

# 6. Begin with repository and runtime identity

Record:

```sh
cd /home/glompy/Desktop/OTHER_PROJECTS/DT

git branch --show-current
git rev-parse HEAD
git status --short
git log -1 --oneline
```

Require branch:

`main`

Then identify the **currently active OpenCode service**, not a remembered port.

Do not assume `51751`, `55129`, or any historical port is still active.

Use the current repository's documented service-discovery procedure.

The live proof must target the runtime actually serving now.

Also verify:

- runtime version;
- base URL;
- model id;
- authentication/lease source;
- whether the runtime instance changed since the committed evidence was produced.

Use the **bare model id** expected by `OpenCodeProvider`, e.g.:

`big-pickle`

Do not pass:

`opencode/big-pickle`

unless current provider semantics have explicitly changed and current code proves that qualified form is now correct.

---

# 7. First decision: did the runtime capability change?

Before changing DoubleTake code, inspect the live runtime.

Determine whether the active HTTP surface now genuinely supports the native structured request/response contract required by Criterion M.

Check behaviorally, not by substring alone.

At minimum establish:

## Request side

Can the active runtime accept the required native body containing the current equivalents of:

```text
model
tools
format/json-schema
system
parts
```

without falling back to a text-only compatibility request?

## Response side

Does the runtime return a genuine structured result through the native response field expected by the production provider?

A successful HTTP request that only returns prose is **not** native structured output.

## Provenance

Can the result be associated with the actual serving provider/model identity?

## No workaround

Do not count any of these as satisfying the runtime requirement:

- parsing JSON from text;
- regex extraction;
- prose coercion;
- a second auxiliary model;
- an embedding model used as a semantic judge;
- tool execution standing in for structured output;
- a fake/mock runtime;
- a test-only response;
- a hand-edited evidence record.

If the runtime still does not expose the required native capability, do not invent a repository-side substitute.

---

# 8. Use the shipped transport measurement

Run the current authoritative transport-capability mechanism.

Use current repository instructions and tests rather than reconstructing the probe by hand.

Inspect:

`tools/doubletake_evolve/runtime/capability_semantic_transport_capability.py`

and its tests.

The terminal runtime verdict must be one of the current repository's declared machine-readable states.

If it remains:

`STRUCTURED_REQUEST_REFUSED`

then the runtime blocker still exists.

If the verdict becomes native structured-output capable, proceed to the full live M proof.

If the probe is undecidable, diagnose the measurement failure. Do not turn an inability to measure into either PASS or runtime refusal.

---

# 9. Re-run the Criterion M live proof

Use the current repository recipe in `AGENTS.md`.

At offload time it was equivalent to:

```sh
PYTHONPATH=.:tools python3 \
  tools/doubletake_evolve/runtime/capability_semantic_live_proof.py \
  --base-url http://127.0.0.1:"$(ps -eo args | sed -n 's/.*opencode .*serve .*--port \([0-9]\+\).*/\1/p' | head -1)" \
  --model big-pickle
```

Then:

```sh
PYTHONPATH=.:tools python3 \
  tools/doubletake_evolve/collective_core/capability_semantic_live_evidence.py \
  --verify
```

If current `AGENTS.md` or current code has changed the authoritative invocation, use the current one.

The live proof must drive the governed populations through the **production ingress**.

Do not call an internal matcher directly and call that M.

---

# 10. M closure conditions

Criterion M may be changed from OPEN to PASS only if the live production proof demonstrates all of the following simultaneously:

```text
[ ] the active runtime genuinely accepts the native structured semantic request
[ ] the native structured response is actually returned
[ ] the response is validated without prose extraction
[ ] the serving provider/model identity matches the requested reference
[ ] the semantic channel is actually consulted
[ ] model-call accounting remains within the declared per-request bound
[ ] the governed M-positive populations achieve the current mission's required utilization condition
[ ] G remains intact on coincidence controls
[ ] negative controls remain refused
[ ] no auxiliary learned model is introduced
[ ] no capability name is leaked into the semantic request in a way forbidden by the mission
[ ] execution occurs through the real governed production path
[ ] live evidence re-derives successfully
[ ] source/vocabulary/profile evidence is current
[ ] non-vacuity remains intact
```

Do not close M merely because:

- transport became available;
- the model was called;
- reach improved somewhat;
- one held-out row passed;
- a mock passed;
- the evidence file says `m_positive=true` without re-derivation.

Transport availability is necessary but not sufficient.

---

# 11. Preserve Criterion G

Criterion M must not be closed by weakening G.

The two must-refuse coincidence controls and all current negative controls are part of the same live proof.

If a proposed repair increases positive reach by also admitting coincidences or unrelated requests, reject the repair.

Do not:

- lower a threshold blindly;
- disable the coincidence guard;
- remove negative controls;
- change expected labels after seeing outcomes;
- fit profiles to the test probes;
- expose canonical capability names to the semantic compiler.

A higher M score with broken G is not closure.

---

# 12. No auxiliary semantic system

Do not create another semantic authority to bypass the OpenCode runtime limitation.

Specifically do not introduce:

- sentence-transformer adjudication;
- another remote LLM;
- a new embedding-based final router;
- a text-to-JSON parser treated as native structure;
- a sidecar semantic service whose result is trusted as M evidence.

Current mission architecture requires the native structured channel.

If the runtime does not provide it, the correct result remains an honest blocker.

---

# 13. Do not modify DoubleTake unless a real in-repo defect is exposed

If the active runtime is still incapable of the required structured request:

**make no speculative runtime/provider redesign merely to keep working.**

Repository changes are justified only when current revalidation exposes a concrete DoubleTake defect such as:

- wrong service discovery;
- wrong live-runtime identity;
- wrong model-id construction;
- request shape differs from current declared runtime support;
- native structured response exists but provider discards it;
- verifier accepts forged/stale evidence;
- production ingress fails to reach a now-supported bridge;
- a non-vacuity row is blind/broken/no-op.

Fix demonstrated DoubleTake defects.

Do not modify DoubleTake to emulate a capability the external runtime still does not expose.

---

# 14. Evidence freshness

If the live runtime instance has changed, regenerate the live evidence even when the result is substantively identical.

The evidence must describe the runtime actually serving now.

Check whether current `main` changed any file in the evidence's measured source surface.

If no measured source file changed, an older bound commit may remain valid through content binding.

If any measured source file changed:

- re-run the relevant proof;
- regenerate the evidence;
- verify it again.

Never re-point the evidence to a newer HEAD without re-measuring the content it claims.

---

# 15. Non-vacuity

Run the current Criterion-M/runtime non-vacuity drivers if:

- the transport probe changed;
- the live evidence verifier changed;
- admission/matching changed;
- profiles/vocabulary logic changed;
- the live proof runner changed;
- any guard involved in closure changed.

At offload time the combined result was:

`26 fired / 0 blind / 0 broken / 0 no-op`

Derive current scope and require:

```text
blind = 0
broken = 0
no-op = 0
```

Every intended mutation must fire.

Do not satisfy non-vacuity by making the suite fail to collect.

---

# 16. Fast stopping condition when runtime is unchanged

This task must **not** churn indefinitely.

If all of the following are true:

```text
- current runtime is identified
- runtime still refuses the required native structured request
- transport probe agrees
- live evidence is current or has been regenerated
- M remains false
- G remains intact
- no auxiliary model is used
- verifier reports only the expected M-target loss / honest blocker condition
- current non-vacuity is intact
- no new DoubleTake-side defect is exposed
```

then stop.

Do not continue searching for a repository-side workaround.

The mission has reached the allowed terminal state:

`CRITERION_M_RUNTIME_HONEST_BLOCKER`

---

# 17. Closure path if the runtime has changed

If the active runtime now exposes genuine native structured output:

1. prove that capability behaviorally;
2. run the live proof over all governed populations;
3. inspect each semantic outcome;
4. verify provider/model provenance;
5. verify call budgets;
6. verify G and negative controls;
7. regenerate live evidence;
8. run the evidence verifier;
9. run relevant focused Criterion-M tests;
10. run current non-vacuity drivers;
11. update the convergence table only if the evidence now satisfies M;
12. re-run the convergence test that currently expects M OPEN;
13. inspect current `main` again for concurrent changes;
14. close M only from the final stable evidence state.

If native transport works but M still fails semantically, M remains OPEN and the blocker classification changes from runtime transport to the actual newly measured semantic failure.

Do not retain the old runtime-blocker explanation after the runtime blocker disappears.

---

# 18. Never use these shortcuts

Do not:

- edit `m_positive` by hand;
- change expected outcomes to observed outcomes;
- suppress `m_target_lost`;
- mark `test_no_criterion_is_open` xfail;
- remove M from the convergence table;
- weaken G;
- remove negative controls;
- parse model prose as native structure;
- use a mock as live evidence;
- call an unavailable provider a PASS;
- infer native structured support from binary strings alone;
- infer refusal from source inspection alone when the live endpoint can be tested;
- use a stale port;
- use a stale runtime lease;
- use a stale evidence record;
- create a second semantic authority.

---

# 19. Final report

Return:

## Repository

- baseline HEAD
- final HEAD
- branch
- working-tree state

## Runtime identity

- OpenCode version
- runtime endpoint
- model
- how endpoint was discovered
- whether this is the same instance as the previously committed evidence

## Transport measurement

- request-side result
- response-side result
- machine-readable verdict
- exact blocker if refused

## Live M proof

- total rows
- positive/reach result
- `m_positive`
- `g_intact`
- semantic call total/max
- auxiliary models
- provider/model provenance result

## Evidence

- evidence path
- bound commit
- measured-surface digest
- measured-surface drift, if any
- verifier result
- exact verifier defects, if any

## Non-vacuity

- intended rows
- fired
- blind
- broken
- no-op

## Repository changes

Separate:

- runtime code changes
- test/proof changes
- evidence-only regeneration
- no changes

Do not claim changes made by concurrent workers.

---

# 20. Terminal status

Use exactly one terminal status.

If Criterion M is genuinely proven closed through the live native structured channel while G remains intact:

`CRITERION_M_FINAL_CLOSED`

If the current runtime still lacks the required native structured-output surface and DoubleTake's measurement/proof chain is current and sound:

`CRITERION_M_RUNTIME_HONEST_BLOCKER`

If a newly discovered in-repository defect prevents a truthful conclusion and cannot safely be completed in this run:

`CRITERION_M_CLOSURE_BLOCKED`

Prefer the first two whenever the evidence supports them.

Do not use `CRITERION_M_CLOSURE_BLOCKED` merely because M is OPEN.

An externally unavailable native runtime capability with complete, current proof is an **HONEST BLOCKER**, not an unfinished DoubleTake implementation.

---

# 21. Final principle

The goal is not to force Criterion M green.

The goal is to make its state **true**.

If the runtime changes and M passes honestly, close it.

If the runtime has not changed, preserve the measured blocker and stop.

A truthful OPEN criterion with complete evidence is better than a fabricated PASS.
