# Agent_X — Repeated Semantic Provider Timeout Repair

Current audited `main` when this prompt was written:

`6d62cc4eada5c29a75a638291fe7e39af56c1693`

Re-check the actual current local `main`/working tree before editing.

## Exact production regression

A normal build request now reaches the semantic provider correctly but repeatedly fails with:

```text
503
Semantic reasoning provider is temporarily unavailable.
The semantic provider timed out.

code: SEMANTIC_PROVIDER_TIMEOUT
retryable: true
```

The user retried and received the same timeout again.

Example run:

`run_1789342143406_bJEuisSZ`

This means the earlier semantic-provider bootstrap, stale-base recovery and prompt-governance blockers have progressed far enough that the remaining failure is now the actual semantic completion transport.

Do **not** weaken semantic-first.

Do **not** authorize structural fallback.

Do **not** turn build requests into read-only requests.

Fix the semantic completion path so a healthy provider can complete reliably and repeated provider timeouts are handled intelligently.

---

# 1. Proven weaknesses in the current code

Inspect actual current code and confirm before changing it.

## 1.1 Semantic provider requests are unbounded in output length

Current:

`tools/agentx_evolve/providers/api_provider.py`

`APIProvider.complete()` builds approximately:

```python
body = {
    "model": self.model,
    "messages": messages,
    "stream": False,
}
```

It accepts `**kwargs` but ignores them.

Therefore semantic-first currently sends no:

- `max_tokens`;
- output budget;
- structured-response generation limit;
- semantic-specific generation controls.

The socket then waits for a full non-streaming response until the timeout.

This is a material defect.

The semantic JSON contracts are bounded and do not require unlimited output.

## 1.2 Timeout is per candidate, not an overall semantic deadline

Current UI semantic provider resolution uses:

```python
resolve_ui_semantic_provider(timeout_seconds=120)
```

Each copied candidate provider inherits the same 120-second timeout.

The candidate pool can contain up to four models.

Therefore a single semantic stage can theoretically consume multiple 120-second waits.

This is not an acceptable failover budget.

## 1.3 Candidate ranking rewards larger context windows

Current `_semantic_rank()` approximately ranks by:

1. advertised JSON support;
2. availability;
3. larger context window;
4. model ID.

The semantic prompt does not need the largest available context window.

Once a model has sufficient context, a larger context window is not evidence that it is a better or faster semantic model.

Do not use maximum context size as a performance preference.

## 1.4 Current diagnostics do not identify the semantic stage

The same provider pool is used for at least:

- request interpretation;
- target-state design.

A timeout response does not tell the user/operator which semantic stage timed out.

Add stage-level diagnostics.

## 1.5 Browser response hides the candidate attempt chain

The provider pool already records sanitized attempt information including:

- model;
- source;
- auth mode;
- attempt;
- failure bucket;
- elapsed time;
- failover.

But the browser error only receives:

```text
The semantic provider timed out.
```

The operator cannot tell whether:

- one model timed out;
- four models timed out;
- discovery returned only one candidate;
- failover happened;
- the configured model monopolized the budget.

Expose a bounded sanitized attempt summary.

Never expose credentials or prompts.

---

# 2. First perform a real local transport diagnosis

Before editing production code, run bounded checks from the same machine/environment as Agent_X.

Use the actual configured:

- base URL;
- anonymous/token mode;
- configured model.

Do not log the API key.

At minimum test:

## A. Models endpoint

Confirm discovery responds.

## B. Tiny semantic-compatible completion

Use a tiny request equivalent to:

```json
{
  "model": "<candidate>",
  "messages": [
    {
      "role": "user",
      "content": "Return exactly one JSON object: {\"ok\":true}"
    }
  ],
  "max_tokens": 32,
  "stream": false
}
```

Use a short diagnostic timeout.

## C. Bounded realistic semantic response

Send a representative architectural JSON request with:

`max_tokens` explicitly bounded.

Record:

- selected model;
- time to completion;
- response size;
- status/error.

The diagnostic result determines whether the external service itself is unavailable or Agent_X's unbounded request behavior is the dominant defect.

Do not make the production fix depend on the service being available during tests; add deterministic mocked tests too.

---

# 3. Make `APIProvider.complete()` honor safe generation controls

Do not silently merge arbitrary caller kwargs into the provider payload.

Define a whitelist of supported OpenAI-compatible generation fields, at minimum:

- `max_tokens`;
- `temperature`;
- `top_p`;
- `stop`;

and only if already supported/verified by the target provider:

- `response_format`.

Example contract:

```python
_ALLOWED_COMPLETION_KWARGS = {
    "max_tokens",
    "temperature",
    "top_p",
    "stop",
    "response_format",
}
```

Validate values before sending.

Unknown kwargs must not silently become API payload.

Existing callers with no kwargs must remain behavior-compatible.

---

# 4. Give semantic-first an explicit output budget

The semantic pipeline knows its output schema.

Use a bounded semantic output budget.

Do not use unlimited generation.

Create current-equivalent constants such as:

```python
SEMANTIC_INTERPRETATION_MAX_TOKENS = ...
SEMANTIC_DESIGN_MAX_TOKENS = ...
SEMANTIC_REPAIR_MAX_TOKENS = ...
```

Choose values from measured realistic responses, with margin.

The limits must be high enough for legitimate Agent_X architectural JSON but low enough that runaway generation cannot consume the full transport timeout.

Do not arbitrarily use `100` tokens.

The user's earlier simple LLM7 curl used a small `max_tokens` successfully, but the semantic schema needs materially more room.

Measure representative payloads.

A reasonable implementation may initially use a bounded range such as approximately 1,500–3,000 output tokens per semantic stage, then refine from real evidence.

The exact value must be justified by tests.

---

# 5. Pass the semantic generation budget through the actual provider call

Current semantic code eventually calls:

```python
provider.complete(messages)
```

Change the canonical semantic completion path so it sends the bounded controls.

Conceptually:

```python
provider.complete(
    messages,
    max_tokens=stage_budget,
    temperature=0,
)
```

or the closest supported deterministic temperature.

Do this in the semantic-specific layer rather than globally imposing semantic settings on ordinary chat.

Repair calls also need a smaller bounded budget.

---

# 6. Keep semantic responses deterministic where the provider supports it

Semantic authorization is architectural evidence.

Prefer:

```text
temperature = 0
```

or the provider's closest verified deterministic setting.

Do not rely on stochastic long-form generation.

If the provider rejects a specific optional parameter:

- classify it as an Agent_X request compatibility issue;
- remove only the unsupported optional control for that provider;
- keep the output token bound.

Do not drop all generation bounds.

---

# 7. Introduce one overall semantic-stage deadline

Do not give every candidate the entire user-facing timeout.

Each semantic stage must have:

- an overall deadline;
- bounded per-candidate attempt deadlines.

For example conceptually:

```text
interpretation total budget: bounded
candidate 1: portion of budget
candidate 2: remaining portion
candidate 3: remaining portion
```

Do not hard-code this exact split without measurement.

Required invariant:

```text
sum of candidate waits <= semantic-stage total deadline
```

A four-model pool must not produce four independent 120-second waits.

Use monotonic time.

Before each attempt:

1. compute remaining stage budget;
2. derive bounded candidate timeout;
3. skip further attempts if no useful time remains.

---

# 8. Separate connection/read timeout policy from total failover budget where practical

One socket timeout value currently serves too many purposes.

If the existing transport can support it without broad redesign, distinguish:

- connection/open timeout;
- response/read timeout;
- overall semantic-stage deadline.

At minimum, the provider pool must enforce a total deadline externally even if urllib still has one socket timeout.

Do not rewrite the whole HTTP transport merely for this repair.

---

# 9. Stop preferring the largest context window

Before ranking, determine whether a candidate has sufficient context for the actual semantic prompt.

Use a conservative deterministic estimate.

Do not add a heavyweight tokenizer dependency.

A conservative character-based estimate plus response budget/margin is sufficient for eligibility.

Conceptually:

```text
estimated_input_tokens
+ max_output_tokens
+ safety_margin
<= advertised_context_tokens
```

If context size is unknown:

- keep the candidate probe-eligible if other evidence permits;
- do not rank it above known-sufficient candidates merely because context is unknown.

After sufficiency is established, context size should not receive a "larger is better" bonus.

---

# 10. Rank for semantic reliability, not model size

Use current available evidence.

Preferred factors:

1. explicit configured model, if user configured one and it is not in cooldown;
2. recent successful last-known-good semantic completion;
3. advertised JSON mode;
4. current availability;
5. recent measured semantic success/latency;
6. sufficient context;
7. stable deterministic tie-breaker.

Do not use model-name guesses such as:

```text
small model = fast
large model = slow
```

Use measured runtime evidence where available.

---

# 11. Add bounded semantic model health/latency memory

The system already has last-known-good semantic identity.

Extend it minimally with bounded non-secret health data, for example:

- last success timestamp;
- last timeout timestamp;
- recent success count;
- recent timeout/failure count;
- EWMA/recent semantic completion latency.

Keep it:

- process-local or bounded persisted state if current architecture already has an appropriate runtime state owner;
- non-authoritative;
- non-secret.

This data is ranking evidence only.

It never authorizes mutation.

---

# 12. Add a short timeout cooldown/circuit breaker

After a candidate produces a real semantic timeout:

- temporarily demote it for semantic selection;
- prefer another compatible candidate on the next request;
- do not immediately hammer the same model first on every retry.

Cooldown must be bounded.

A model must eventually become probe-eligible again.

Do not permanently blacklist a model because of one timeout.

If no alternative candidate exists:

- a bounded retry/probe may still be attempted according to cooldown policy;
- fail closed if it remains unavailable.

---

# 13. Last-known-good must react to current failure

A model that was last-known-good yesterday or earlier in the process must not remain first preference after repeated current timeouts.

On timeout:

- retain historical success evidence;
- record current failure;
- lower immediate preference;
- do not falsely call it healthy.

A new successful semantic completion restores its preference.

---

# 14. Add semantic stage identity

Every semantic completion invocation must identify its stage, at minimum:

- `interpretation`;
- `target_design`;
- `json_repair`;
- any conflict-resolution semantic call if it uses the same pool.

Pass the stage into diagnostics.

Example sanitized attempt record:

```json
{
  "stage": "interpretation",
  "provider": "llm7",
  "model": "...",
  "source": "fresh",
  "attempt": 1,
  "failure_bucket": "SEMANTIC_PROVIDER_TIMEOUT",
  "elapsed_ms": 45012,
  "failover": false
}
```

No prompt contents.

No tokens/keys.

---

# 15. Surface bounded sanitized attempt diagnostics to the API

When all semantic candidates fail, the 503 response may include a bounded diagnostic field such as:

```json
"attempts": [
  {
    "stage": "interpretation",
    "model": "...",
    "source": "...",
    "failure_bucket": "SEMANTIC_PROVIDER_TIMEOUT",
    "elapsed_ms": 45012
  }
]
```

Cap the number of records.

Do not expose:

- API key;
- Authorization header;
- full prompt;
- sensitive provider response bodies.

This will let future failures be diagnosed without guessing.

The existing run-local `semantic_provider_failure.json` should contain the same sanitized evidence.

---

# 16. Do not hide successful failover

If model A times out and model B succeeds:

- continue semantic-first normally;
- record that failover occurred;
- update last-known-good to B;
- do not show an error to the user.

The user should only see an error when the entire bounded semantic provider pool fails.

---

# 17. Consider streaming only if bounded non-streaming remains unreliable

Do not immediately rewrite semantic JSON completion around streaming.

First implement:

- max output tokens;
- correct candidate ranking;
- bounded per-attempt time;
- overall deadline;
- timeout cooldown.

If real measurements still show that LLM7 commonly produces first tokens quickly but cannot complete before a non-streaming read timeout, then implement a semantic-specific streaming collector.

A streaming collector must:

- use no tools;
- accumulate assistant text only;
- enforce max output size;
- enforce total deadline;
- preserve strict final JSON validation;
- propagate transport errors rather than emitting fake success.

Do not use streaming as an excuse to accept partial JSON.

---

# 18. Do not increase the timeout as the primary fix

Forbidden shortcut:

```text
120 seconds → 300 seconds
```

without addressing unbounded output and failover budget.

A larger timeout may make the UI appear hung for even longer.

Timeout may be adjusted after measurement, but only after:

- output bounds;
- total deadline;
- failover policy;
- ranking/cooldown;

are correct.

---

# 19. Do not hard-code a single replacement model

Do not solve the issue by replacing:

`codestral-latest`

with one different fixed model name.

Model availability changes.

Use live discovery + measured health.

A known bootstrap model may remain a final probe, but successful current completion is the authority.

---

# 20. Preserve anonymous/token behavior

Anonymous mode must still use only models proven or successfully probed as anonymous-compatible.

Token mode may use token-eligible models.

Do not leak the token into diagnostics.

Do not force the user to obtain a token merely because one anonymous model is slow if another valid provider/model exists.

---

# 21. Required unit tests — transport generation controls

## A. `APIProvider.complete()` sends max tokens

Mock `_post`.

Call:

```python
complete(messages, max_tokens=123)
```

Assert payload contains:

```json
"max_tokens": 123
```

## B. Unknown generation kwarg

Assert it is rejected or ignored according to the explicit safe contract.

Do not blindly forward it.

## C. Existing chat caller

Call without generation kwargs.

Assert compatibility.

---

# 22. Required tests — semantic output budget

For interpretation:

- assert semantic call sends its configured max token budget.

For target design:

- assert its stage-specific budget is sent.

For JSON repair:

- assert repair budget is bounded.

No semantic stage may use unlimited output.

---

# 23. Required tests — overall deadline

Use fake providers that sleep/time out.

Example:

- candidate A consumes part of budget and times out;
- candidate B succeeds quickly.

Expected:

- B is attempted;
- total elapsed stays under configured semantic-stage deadline.

Then:

- A times out;
- B times out;
- C would exceed remaining budget.

Expected:

- C is not given a fresh full timeout;
- total elapsed remains bounded;
- one 503 is returned.

---

# 24. Required tests — candidate ranking

Create candidates with:

- huge context / slow recent history;
- sufficient context / strong recent semantic success;
- insufficient context;
- JSON-supported candidate;
- configured candidate.

Prove:

- insufficient context candidate is not preferred;
- largest context alone does not win;
- current successful/healthy candidate is preferred;
- explicit configured candidate is respected unless recent health/cooldown makes immediate use unreasonable under the defined policy.

---

# 25. Required tests — timeout cooldown

Request 1:

- candidate A times out;
- B also unavailable;
- request fails.

Request 2 immediately:

- alternative healthy candidate C exists.

Expected:

- A is not blindly first again;
- C is preferred according to health evidence.

After cooldown expiry:

- A becomes eligible again.

---

# 26. Required tests — exact repeated user regression

Simulate the actual sequence:

1. submit the normal build request;
2. semantic candidate times out;
3. 503 returned;
4. user retries the same request.

The second request must not simply repeat the identical bad selection/wait sequence when a healthy alternative exists.

Expected options:

```text
bad model times out
→ cooldown/demotion
→ alternative semantic model selected
→ semantic interpretation succeeds
→ target design succeeds
→ canonical semantic authorization proceeds
```

If no provider/model is actually healthy:

- fail closed;
- return bounded attempts explaining that all candidates timed out/unavailable.

---

# 27. Required tests — phase diagnostics

Force:

## Interpretation timeout

Response diagnostic must identify:

`stage = interpretation`.

## Target design timeout

Diagnostic must identify:

`stage = target_design`.

This distinction must appear in:

- server log;
- run-local failure artifact;
- bounded API error diagnostics.

---

# 28. Required tests — no semantic regression

Re-run all semantic-first enforcement tests.

Prove:

- structural fallback still cannot authorize mutation;
- failed provider still grants no write authority;
- malformed JSON still blocks;
- semantic contract mismatch still blocks;
- exact run/change/workspace binding remains;
- canonical tool-effect authorization remains;
- failed semantic attempts create no canonical transaction junk;
- successful semantic failover still creates exactly one valid semantic target.

---

# 29. Real local acceptance test

From the real Agent_X UI, submit:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

Expected:

1. provider candidates are resolved;
2. interpretation stage uses bounded generation;
3. target-design stage uses bounded generation;
4. timeout/failover budget is bounded;
5. one healthy model succeeds;
6. semantic target is created;
7. exact mutation authority is issued;
8. selected coding runtime starts.

If all external semantic candidates are genuinely unavailable, the error must show a sanitized bounded attempt chain proving that.

---

# 30. Canonical reconciliation after repair

This repair changes production semantic-provider behavior.

After implementation:

1. run provider transport tests;
2. run semantic provider pool tests;
3. run semantic-first tests;
4. run the real UI regression;
5. reconcile the semantic model through the canonical semantic-first process;
6. issue real verification evidence;
7. build accepted baseline canonically;
8. independently assess;
9. require `SYNCED`;
10. immediate no-change reassessment must remain `SYNCED`.

Do not manually patch canonical JSON.

---

# 31. Bootstrap note

If the ordinary Agent_X build UI cannot authorize this repair because the semantic provider itself is the failing prerequisite, apply this repair through the trusted external/bootstrap maintenance path.

Do not add a permanent bypass.

After restart, all normal mutations must again use semantic-first.

---

# 32. Completion criteria

Do not stop until all are true:

1. semantic completion has an explicit max output token budget;
2. `APIProvider.complete()` honors approved generation kwargs;
3. arbitrary kwargs are not blindly forwarded;
4. interpretation has a bounded output budget;
5. target design has a bounded output budget;
6. JSON repair has a bounded output budget;
7. candidate failover has one overall semantic-stage deadline;
8. individual candidates cannot each consume the full stage budget;
9. largest context window is no longer treated as intrinsically better;
10. insufficient-context models are excluded/demoted;
11. semantic health/latency evidence can influence ranking;
12. repeated timeout demotes a candidate temporarily;
13. timeout cooldown is bounded and expires;
14. last-known-good does not override current repeated failures;
15. failover success updates last-known-good;
16. diagnostics identify semantic stage;
17. diagnostics identify candidate model/source;
18. diagnostics identify timeout elapsed time;
19. bounded sanitized attempts are available in run evidence;
20. all-candidate failure returns a bounded 503;
21. healthy failover is transparent to user;
22. timeout does not grant mutation authority;
23. structural fallback remains non-authorizing;
24. no single hard-coded replacement model becomes authority;
25. anonymous/token access rules remain correct;
26. repeated same user request does not blindly hammer the same timed-out candidate when alternatives exist;
27. real UI build request can proceed when at least one semantic provider candidate is healthy;
28. final canonical synchronization is `SYNCED`;
29. second no-change synchronization remains `SYNCED`.

---

# Stop condition

Stop only when either:

## Healthy-provider case

```text
normal build request
→ bounded semantic interpretation
→ bounded semantic target design
→ healthy candidate succeeds
→ canonical semantic authorization
→ coding runtime
```

works reliably,

or:

## Genuine external outage case

```text
normal build request
→ bounded attempts across all eligible candidates
→ every candidate independently fails
→ one bounded 503 with sanitized attempt evidence
→ no mutation authority
```

is proven.

Repeated user retries must never reproduce an opaque identical 120-second timeout loop when Agent_X has another healthy semantic candidate available.
