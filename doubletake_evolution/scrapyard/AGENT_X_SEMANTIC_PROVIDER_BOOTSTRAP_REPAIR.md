# Agent_X — Semantic Provider Bootstrap Repair

Current audited `main` when this prompt was written:

`5ebf471c09a6c18585c2b67f1b16ecf2ceaa06f0`

Re-check actual current `main` before editing.

## Problem to fix

A normal build request such as:

`continue completing everything according to: /home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md`

currently fails before the coding runtime starts:

```text
403
Semantic-first authorization required before project mutation.

SEMANTIC_FIRST_DENIED:
SEMANTIC_PROVIDER_UNAVAILABLE:
structural fallback cannot authorize architectural changes
```

Example affected run:

`run_1789268517840_XF5UpbTR`

This is a production-blocking bootstrap defect.

Do **not** weaken semantic-first.

Do **not** allow structural fallback to authorize architectural mutation.

Do **not** add a bypass.

Fix the provider-resolution path so the required governed LLM reasoning is reliably available, and make failures report their real cause.

---

# 1. Preserve the security invariant

The following rule remains mandatory:

> A write-capable Agent_X request may mutate the project only after successful governed LLM semantic interpretation and a valid canonical semantic-first transaction.

Therefore:

- structural-only interpretation remains non-authorizing;
- no provider → no mutation;
- failed provider → no mutation;
- malformed semantic response → no mutation;
- read-only execution must not be silently upgraded to write capability;
- a build request must not be silently downgraded to plan/read-only merely to avoid the gate.

The fix is availability + correctness, not bypass.

---

# 2. Proven current failure chain

Inspect actual current code and confirm each point before editing.

## 2.1 `/api/chat` gates all write-capable runtimes before runtime dispatch

Current `tools/agentx_evolve/api/chat.py` calls:

`run_ui_semantic_gate(...)`

before branching into:

- OpenCode;
- Codex;
- LLM7.

Therefore one broken semantic provider blocks every build runtime.

This is intentional as an authority boundary.

Keep it.

## 2.2 `resolve_ui_semantic_provider()` is too brittle

Current `tools/agentx_evolve/api/semantic_gate.py` approximately does:

```python
provider = LLM7Provider(timeout_seconds=timeout_seconds)
records = provider.discover()
model = default_anonymous_model_id(...)
if not model:
    raise RuntimeError(...)
provider.model = model
return provider
```

Problems:

1. it directly constructs `LLM7Provider`;
2. it does not use the existing env-aware `get_llm7_provider()`;
3. it ignores `AGENTX_LLM7_BASE_URL`;
4. it ignores `AGENTX_LLM7_API_KEY`;
5. it ignores a configured `AGENTX_LLM7_MODEL`;
6. it bypasses existing bounded discovery caching via `refresh_discovery()`;
7. it treats one discovery call as the entire availability decision;
8. it has no last-known-good semantic model;
9. it has no candidate failover;
10. it cannot distinguish discovery failure from model failure.

Repair this.

## 2.3 Existing LLM7 provider infrastructure already contains useful pieces

Reuse existing functions in `providers/llm7_provider.py`, including current equivalents of:

- `get_llm7_provider(...)`;
- `refresh_discovery(...)`;
- `discovery_state(...)`;
- `default_anonymous_model_id(...)`;
- env configuration constants;
- classified provider errors.

Do not build a second LLM7 transport.

## 2.4 Current pipeline hides the real failure

Current `semantic_first/pipeline.py` catches broad exceptions from LLM interpretation and does:

```text
LLM failure
→ structural fallback
→ interpretation_path = "structural"
```

Then `SemanticFirstCheckpoint` sees that the path is not LLM-backed and returns:

```text
SEMANTIC_PROVIDER_UNAVAILABLE:
structural fallback cannot authorize architectural changes
```

That means the user receives the same message for materially different causes:

- model discovery failed;
- DNS/network failed;
- service timeout;
- rate limit;
- authentication/token issue;
- model unavailable;
- no anonymous model;
- LLM returned invalid JSON;
- LLM omitted required semantic fields;
- prompt exceeded model limits;
- provider returned malformed response.

This must be fixed.

---

# 3. Make one canonical semantic-provider resolver

Keep the canonical owner in the existing semantic/UI provider path.

Do not create competing semantic-provider selection logic in:

- `chat.py`;
- `pipeline.py`;
- OpenCode runtime;
- Codex runtime;
- LLM7 chat runtime.

`semantic_gate.py` may own UI semantic-provider resolution, using the existing provider abstraction.

Factor a helper only if needed for clean testing.

The helper must return either:

1. a verified usable governed provider; or
2. a typed/structured failure describing the actual reason.

---

# 4. Honor existing LLM7 configuration

Replace direct raw construction with the existing env-aware provider factory.

Use current equivalent of:

```python
get_llm7_provider(...)
```

so semantic reasoning honors:

- `AGENTX_LLM7_BASE_URL`;
- `AGENTX_LLM7_API_KEY`;
- `AGENTX_LLM7_MODEL`.

Explicit function arguments may still override env configuration according to the existing provider contract.

Do not log API keys.

Do not persist API keys into semantic artifacts.

---

# 5. Resolve candidate models robustly

Use a bounded candidate-resolution algorithm.

## 5.1 Configured model first

If a semantic/LLM7 model is explicitly configured:

1. consider it first;
2. verify it is a chat-capable candidate;
3. use the configured token when present;
4. if running anonymously, do not assume anonymous access merely because the model is configured;
5. prove reachability through live metadata or a bounded no-auth probe.

A configured model that fails must not permanently poison provider state.

## 5.2 Live/cached discovery next

Use:

`refresh_discovery(provider)`

instead of calling `provider.discover()` directly.

Prefer fresh records.

Allow the existing bounded stale cache behavior exactly as intended.

Do not convert an expired stale record into permanent truth.

## 5.3 Anonymous mode

When no API key is configured:

- prefer records explicitly advertising anonymous access;
- prefer chat/text models;
- prefer models with sufficient context for semantic prompts;
- prefer JSON-capable models when metadata advertises it;
- prefer currently available/stable models when metadata supports this.

Do not select image-only or incompatible models.

The existing recorded LLM7 fixture contains `codestral-latest` with:

`usage_based_only = false`

and current LLM7 public model information lists `codestral-latest` as available.

It is a valid example, not a permanent hard-coded authority.

## 5.4 Token mode

When a token is configured:

- token-eligible models may be considered;
- do not artificially filter to anonymous-only records.

## 5.5 Last-known-good semantic model

Persist or retain a bounded last-known-good semantic provider/model identity after a successful semantic completion.

It must include enough information to prove freshness, such as:

- provider id;
- model id;
- base URL identity;
- authenticated/anonymous mode without storing the secret;
- last successful timestamp;
- last successful health/completion timestamp.

If discovery temporarily fails:

1. do not blindly trust last-known-good;
2. attempt a bounded direct completion/health probe;
3. reuse it only if the probe succeeds;
4. otherwise fail closed.

This prevents a transient `/models` failure from disabling a chat model that is still reachable.

Do not make last-known-good permanent.

Use a bounded TTL.

---

# 6. Add candidate failover

One selected model must not be a single point of failure when other valid candidates exist.

For semantic reasoning:

1. build an ordered bounded candidate list;
2. try the preferred candidate;
3. on retryable provider/model failure, try the next candidate;
4. stop after a small bounded number of attempts.

Differentiate failures.

## Retry/failover eligible examples

- model unavailable;
- transient provider/server failure;
- timeout;
- rate limit when another candidate exists;
- malformed/empty provider response if another candidate exists.

## Do not blindly retry as another model when

- request construction is deterministically invalid;
- semantic prompt contract is broken by Agent_X itself;
- authentication configuration is invalid in a way shared by all token-only candidates.

Record the attempt chain without secrets.

---

# 7. Do not perform a separate expensive health call for every prompt

Avoid doubling provider cost/latency on every user request.

Preferred behavior:

- resolution/discovery is cached for a bounded interval;
- the first real semantic completion proves model usability;
- successful completion refreshes last-known-good;
- retry/failover occurs only when needed.

A tiny explicit health probe is acceptable for:

- last-known-good reuse after discovery failure;
- startup diagnostics;
- explicit provider health checks.

Do not require a redundant probe before every semantic interpretation.

---

# 8. Preserve governed read-only provider behavior

The semantic reasoning provider must remain mutation-free.

Do not offer it:

- filesystem write tools;
- shell tools;
- MCP mutation tools;
- Git mutation tools;
- DB/service mutation tools.

The provider is used for architectural reasoning only.

The actual coding runtime receives mutation authority later through the canonical semantic transaction.

---

# 9. Stop collapsing every provider error into structural fallback

This is a key repair.

Structural reasoning may still be computed as evidence.

But when governed LLM reasoning is required and the LLM call fails:

- do not pretend the failure is simply `"structural"`;
- retain the actual provider failure category;
- return/raise a typed semantic-provider failure.

Examples:

```text
SEMANTIC_PROVIDER_DISCOVERY_FAILED
SEMANTIC_PROVIDER_NO_COMPATIBLE_MODEL
SEMANTIC_PROVIDER_AUTH_REQUIRED
SEMANTIC_PROVIDER_MODEL_UNAVAILABLE
SEMANTIC_PROVIDER_RATE_LIMITED
SEMANTIC_PROVIDER_TIMEOUT
SEMANTIC_PROVIDER_SERVER_ERROR
SEMANTIC_PROVIDER_MALFORMED_RESPONSE
SEMANTIC_PROVIDER_INVALID_SEMANTIC_JSON
SEMANTIC_PROVIDER_CONTRACT_MISMATCH
```

Use existing provider error buckets wherever possible instead of inventing redundant error taxonomy.

Structural evidence may accompany the failure.

It must not replace the required LLM result.

---

# 10. Distinguish transport failure from semantic-output failure

Current `_llm_interpret()` can fail after the provider successfully answered.

Do not label that as “provider unavailable”.

Differentiate at minimum:

## Provider/transport failure

Examples:

- network;
- timeout;
- HTTP failure;
- rate limit;
- no model.

## Response-shape failure

Examples:

- empty response;
- malformed provider envelope.

## Semantic JSON failure

Examples:

- invalid JSON;
- JSON fenced or surrounded by recoverable text;
- missing required fields;
- wrong field types;
- no architectural reasoning.

This distinction is necessary to repair the right layer.

---

# 11. Make semantic JSON parsing robust but still strict

The current semantic pipeline requires structured architectural JSON.

Keep that contract.

Improve resilience without accepting arbitrary prose.

Allowed recovery:

1. strip normal Markdown JSON fences;
2. isolate one JSON object when unambiguous;
3. validate required fields/types;
4. optionally perform one bounded “repair your JSON only” retry through the same governed provider;
5. if still invalid, try another valid semantic model if available;
6. otherwise fail closed with `SEMANTIC_PROVIDER_INVALID_SEMANTIC_JSON` or equivalent.

Do not convert invalid prose into guessed architecture.

Do not use structural heuristics to fill missing architectural fields and authorize mutation.

---

# 12. Preserve strict semantic contract validation

A successful provider response must still contain valid architectural reasoning.

Validate current required fields such as:

- affected capabilities;
- affected modules;
- affected invariants;
- affected governance;
- design fit;
- verification needed;
- reasoning;
- authority decisions as applicable.

No empty/placeholder semantic result may authorize a change.

---

# 13. Fix HTTP semantics in `/api/chat`

Currently any semantic gate failure becomes HTTP 403.

That is wrong for transient provider dependency failures.

Classify the failure.

## 403

Use for true policy/authorization denial, for example:

- semantic target incoherent;
- forbidden mutation;
- unresolved policy conflict;
- user/build request cannot be authorized for architectural reasons.

## 503 retryable

Use for temporary semantic provider availability problems, such as:

- discovery service unavailable;
- provider timeout;
- provider server failure;
- no currently reachable semantic provider when that may change;
- all candidate models temporarily rate-limited/unavailable.

Return:

```json
{
  "error": "Semantic reasoning provider is temporarily unavailable.",
  "detail": "<specific sanitized cause>",
  "policy_decision": "semantic_provider_required",
  "retryable": true,
  "run_id": "..."
}
```

Do not permit mutation.

## 502 or non-retryable 5xx

Use when Agent_X's provider-response/semantic parsing contract itself is broken and retrying the same request is unlikely to help.

Choose the current API's consistent error convention.

The key requirement is:

**do not tell the UI a transient dependency outage is a policy rejection.**

---

# 14. UI behavior

The frontend must display the actual sanitized failure.

For retryable provider failures:

- preserve the user's prompt;
- preserve the session;
- do not mark the candidate/change as policy-rejected;
- allow normal retry after provider recovery;
- do not create a fake successful semantic transaction.

Do not expose stack traces or secrets.

Do not automatically resubmit indefinitely.

---

# 15. Clean up failed pre-authorization runs

A provider outage currently reserves a run before semantic authorization.

That is correct because run identity must exist before the semantic transaction.

But repeated provider failures must not create unbounded junk.

For provider failure before change-ID creation:

- mark the reserved run failed/retryable;
- close/prune empty transaction state according to existing run retention policy;
- do not create canonical semantic change files;
- do not create `semantic_project/changes/` junk;
- retain only the minimal failure evidence needed for diagnostics.

A retry must get a new run identity or use the existing canonical retry/idempotency mechanism safely.

---

# 16. Improve observability

Record sanitized semantic-provider diagnostics.

At minimum:

- provider id;
- model id;
- discovery source: fresh/cache/last-known-good/configured;
- anonymous vs token mode;
- attempt number;
- failure bucket;
- HTTP status when safe;
- elapsed time;
- whether failover occurred.

Never log:

- API keys;
- authorization headers;
- full sensitive prompts unless normal governed prompt logging already permits them.

The browser error should not be the only evidence of why semantic reasoning failed.

---

# 17. Do not hard-code `codestral-latest` as unconditional truth

`codestral-latest` is currently a useful known model and the user has already demonstrated anonymous chat completion with it.

However:

- model catalogs change;
- anonymous policy can change;
- model availability can change.

It may be a bootstrap candidate only if it is verified at runtime.

Preferred authority order:

```text
explicit configured model
→ live/cached compatible model discovery
→ last-known-good with successful direct probe
→ optional known bootstrap candidate with successful direct probe
→ fail closed
```

If you use a known bootstrap candidate such as `codestral-latest`, its successful direct completion is the authority, not its hard-coded name.

---

# 18. Use the existing LLM7 cache

The repository already has:

- `DISCOVERY_TTL_SECONDS`;
- `_discovery_cache`;
- `refresh_discovery()`;
- `discovery_state()`.

The semantic resolver currently bypasses that.

Fix it.

Do not create a second discovery cache.

If additional last-known-good state is required, keep it narrowly scoped to verified semantic completion, not general model discovery.

---

# 19. Use the existing env-aware provider constructor

The repository already has:

`get_llm7_provider(...)`

which honors:

- `AGENTX_LLM7_BASE_URL`;
- `AGENTX_LLM7_API_KEY`.

Use it.

If configured model selection should also honor `AGENTX_LLM7_MODEL`, use the existing helper/current convention rather than duplicating env parsing.

Add a test proving semantic provider resolution actually honors all three existing configuration variables.

---

# 20. Keep semantic-first fail-closed

These cases must still block project mutation:

1. no governed provider can be resolved;
2. all candidates fail;
3. provider response cannot be validated;
4. semantic target is incoherent;
5. structural-only interpretation is all that exists.

The expected improvement is:

```text
provider works
→ semantic LLM reasoning succeeds
→ semantic target is created
→ build proceeds normally
```

not:

```text
provider fails
→ structural fallback
→ build proceeds
```

---

# 21. Required tests — provider resolution

Add deterministic tests for:

## A. Anonymous live discovery

Fixture has an anonymous-compatible chat model.

Expected:

- model selected;
- provider returned;
- semantic completion can proceed.

## B. Configured model

`AGENTX_LLM7_MODEL` set.

Expected:

- configured model considered first;
- provider uses it when valid.

## C. Configured token

`AGENTX_LLM7_API_KEY` set.

Expected:

- semantic provider factory receives token;
- token-only model is not incorrectly filtered as anonymous-only;
- secret never appears in diagnostics.

## D. Configured base URL

`AGENTX_LLM7_BASE_URL` set.

Expected:

- semantic provider uses it.

## E. Discovery cache

Fresh cached discovery exists.

Expected:

- no redundant live discovery;
- valid model resolved.

## F. Discovery temporarily fails, last-known-good still works

Expected:

- direct bounded probe/completion succeeds;
- semantic provider is reused;
- build path is not blocked by `/models` outage alone.

## G. Discovery fails and last-known-good fails

Expected:

- fail closed;
- accurate retryable provider error;
- no semantic authorization.

## H. First model unavailable, second candidate succeeds

Expected:

- bounded failover;
- successful LLM interpretation;
- no structural authorization.

## I. All candidates fail

Expected:

- no mutation;
- clear provider-unavailable result.

---

# 22. Required tests — semantic completion

## J. Valid JSON response

Expected:

`interpretation_path` begins with `llm`.

## K. Markdown-fenced valid JSON

Expected:

- safely parsed;
- LLM path retained.

## L. Recoverably wrapped JSON

Expected:

- one bounded deterministic extraction;
- schema validation;
- LLM path retained.

## M. Malformed JSON repaired on one retry

Expected:

- repaired response validated;
- LLM path retained.

## N. Malformed JSON remains invalid

Expected:

- fail closed;
- error identifies invalid semantic JSON;
- no generic provider-unavailable lie.

## O. Missing required semantic field

Expected:

- contract mismatch;
- fail closed.

## P. Provider timeout

Expected:

- categorized timeout;
- candidate failover where available;
- otherwise retryable provider failure.

## Q. Rate limit

Expected:

- candidate failover where available;
- otherwise retryable provider failure.

---

# 23. Required tests — API behavior

Use the real `/api/chat` route.

## R. Exact user regression

Submit a build request equivalent to:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

with a usable semantic provider.

Expected:

- no 403 `SEMANTIC_PROVIDER_UNAVAILABLE`;
- run identity reserved;
- governed semantic LLM interpretation succeeds;
- semantic change target is created;
- coding runtime receives the authorized transaction.

The test does not need the exact local file path to exist merely to prove provider bootstrap; if later implementation requires the file, that is a separate runtime/file-access concern.

## S. Provider genuinely unavailable

Expected:

- no mutation;
- retryable 503 or current equivalent;
- precise sanitized reason;
- no fake policy rejection.

## T. Structural fallback only

Expected:

- still blocked.

## U. Semantic provider recovers

After an earlier temporary failure:

- retry succeeds;
- no stale failed transaction authorizes the retry;
- new/valid semantic transaction binds the new run.

---

# 24. Required tests — no regression

Re-run semantic-first closure tests.

Prove:

- no structural fallback can authorize mutation;
- exact run/change/workspace binding remains;
- exact tool-effect authorization remains;
- no wildcard authority is reintroduced;
- stale-backend behavior remains fail-closed;
- canonical finalization/reconciliation remains unchanged;
- tests do not mutate canonical semantic files;
- no `semantic_project/changes/` transaction pile returns.

---

# 25. Avoid a circular bootstrap trap

This repair changes the semantic gate itself.

The normal Agent_X build UI is currently blocked before it can obtain mutation authority.

Therefore do **not** require this broken UI path to authorize the repair that restores its own prerequisite.

Apply this one repair through a trusted external/bootstrap maintenance path, such as:

- direct repository edit;
- external coding agent/editor operating on the repository;
- an already-authorized maintenance mechanism outside `/api/chat`.

This is not permission to create a permanent bypass.

After the repair:

1. restart Agent_X;
2. run the normal UI regression;
3. remove/close any temporary bootstrap mechanism if one was introduced;
4. prove all future project mutations again require normal semantic-first.

Do not add a hidden emergency bypass flag.

---

# 26. Canonical semantic reconciliation after repair

Because this changes production semantic enforcement code:

1. implement the provider-resolution repair;
2. run provider/semantic/API regression tests;
3. restart the backend;
4. verify the real build request gets governed LLM semantic authorization;
5. run canonical semantic-first verification/reconciliation;
6. remint/update accepted semantic baseline through the canonical builder;
7. independently assess synchronization;
8. require `SYNCED`;
9. run a second no-change assessment;
10. require `SYNCED` again.

Do not manually edit canonical JSON to claim success.

---

# 27. Completion criteria

Do not stop until all are true:

1. `resolve_ui_semantic_provider()` no longer directly depends on one raw `LLM7Provider().discover()` call.
2. The resolver uses the existing env-aware LLM7 factory.
3. `AGENTX_LLM7_BASE_URL` is honored.
4. `AGENTX_LLM7_API_KEY` is honored.
5. `AGENTX_LLM7_MODEL` is honored.
6. Existing discovery cache is used.
7. Fresh live discovery works.
8. Temporary discovery failure alone does not block a still-working verified model.
9. Last-known-good reuse requires a successful bounded probe/completion.
10. Candidate failover is bounded.
11. No incompatible model is selected.
12. Anonymous mode never assumes access without evidence.
13. Token mode is not artificially anonymous-only.
14. Semantic provider is tool-less/read-only.
15. Provider transport errors retain their real category.
16. Invalid semantic JSON is not mislabeled as provider unavailable.
17. Missing semantic fields are not mislabeled as provider unavailable.
18. Structural fallback remains non-authorizing.
19. True policy denial remains 403.
20. Temporary provider unavailability is reported as retryable service failure rather than policy denial.
21. Failed provider runs do not create canonical semantic transaction junk.
22. Retry after provider recovery cannot reuse stale authority.
23. The exact user regression request reaches semantic LLM reasoning.
24. The exact user regression request can proceed to the selected coding runtime after authorization.
25. Existing semantic-first closure tests still pass.
26. Canonical semantic model/baseline are reconciled through the normal path.
27. Independent synchronization assessment returns `SYNCED`.
28. A second no-change assessment remains `SYNCED`.

---

# Stop condition

Stop only when the real Agent_X UI can submit an ordinary build request and:

```text
/api/chat
→ run reservation
→ semantic provider resolution
→ governed LLM architectural interpretation
→ canonical semantic target
→ exact mutation authorization
→ coding runtime
```

works without the current false:

```text
SEMANTIC_PROVIDER_UNAVAILABLE:
structural fallback cannot authorize architectural changes
```

while a genuinely unavailable/invalid semantic provider still fails closed and cannot authorize mutation.
