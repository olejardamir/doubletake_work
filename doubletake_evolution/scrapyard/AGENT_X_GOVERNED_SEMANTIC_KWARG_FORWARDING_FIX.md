# Agent_X — Governed Semantic Provider Kwarg Forwarding Fix

Current audited `main` when this prompt was written:

`baabdd9d91b04f53dee4ed2555526086fac4bd5a`

Re-check the actual local working tree before editing.

## Exact failure

A normal build request now fails with:

```text
SEMANTIC_FIRST_DENIED:
SEMANTIC_FIRST_FAILED:
TypeError:
_GovernedSemanticProvider.complete_semantic()
got an unexpected keyword argument 'max_tokens'
```

Example run:

`run_1789346369368_bJEuisSZ`

This is a narrow interface mismatch introduced by the semantic timeout repair.

Do not redesign semantic-first.
Do not remove `max_tokens`.
Do not remove `temperature`.
Do not bypass prompt governance.
Do not authorize structural fallback.

# Root cause

The timeout repair correctly changed `semantic_first/pipeline.py` so bounded generation controls are passed into semantic completions:

```python
complete_semantic(
    messages,
    validator=validator,
    repair_factory=...,
    max_tokens=max_tokens,
    temperature=temperature,
    stage=stage,
)
```

The underlying semantic provider/pool already supports these arguments.

`APIProvider.complete()` now also supports safe generation controls including:

- `max_tokens`
- `temperature`
- `top_p`
- `stop`
- `response_format`

But `_GovernedSemanticProvider` in:

`tools/agentx_evolve/semantic_first/interceptor.py`

still exposes an older interface:

```python
def complete_semantic(
    self,
    messages,
    *,
    validator,
    repair_factory=None,
):
```

and:

```python
def complete(self, messages):
```

So the mandatory governance adapter rejects the new bounded semantic options before the underlying provider can receive them.

# Required fix

## 1. Update `_GovernedSemanticProvider.complete()`

Change it to accept the supported generation controls and forward them only after prompt governance runs.

Conceptually:

```python
def complete(self, messages, **kwargs):
    built = self._build(messages)
    safe_kwargs = validate_generation_kwargs(kwargs)
    return self._context.provider.complete(built, **safe_kwargs)
```

Do not blindly forward arbitrary kwargs.

Reuse one canonical safe-generation-kwargs policy if possible.

At minimum allow only current supported controls:

- `max_tokens`
- `temperature`
- `top_p`
- `stop`
- `response_format`

Unknown kwargs must be rejected or deterministically omitted according to one canonical policy.

## 2. Update `_GovernedSemanticProvider.complete_semantic()`

Its signature must accept the current semantic call contract:

```python
def complete_semantic(
    self,
    messages,
    *,
    validator,
    repair_factory=None,
    stage="",
    max_tokens=0,
    temperature=None,
):
```

If the project has a typed generation-options object, use it instead of ad hoc kwargs.

## 3. Forward controls to underlying semantic provider

When the wrapped provider exposes `complete_semantic`, call it with the same bounded semantic controls:

```python
return underlying(
    built,
    validator=validator,
    repair_factory=governed_repair,
    stage=stage,
    max_tokens=max_tokens,
    temperature=temperature,
)
```

Do not drop `stage`.

Do not drop `max_tokens`.

Do not drop `temperature`.

## 4. Fix simple-provider fallback

The wrapper also supports providers that only expose `complete()`.

Those calls must receive the same validated generation controls:

```python
self._context.provider.complete(
    built,
    max_tokens=max_tokens,
    temperature=temperature,
)
```

The repair completion must also remain bounded.

Do not make JSON repair unlimited.

## 5. Preserve prompt governance

Every initial and repair prompt must still pass through:

```python
self._build(...)
```

Keep:

- provenance classification;
- prompt gate;
- canonical-template verification;
- prompt persistence;
- operator-controller checks.

Generation controls are provider metadata, not a governance bypass.

## 6. Keep governance-only metadata out of HTTP payload

These belong to wrapper/provider orchestration only:

- `stage`
- `validator`
- `repair_factory`

They must never be forwarded as OpenAI-compatible request fields.

Only validated generation controls reach the HTTP provider.

## 7. Avoid double-building prompts

The initial semantic prompt should be governed exactly once.

The repair conversation should be governed exactly once.

Do not accidentally call `_build()` on already-built messages and duplicate system/user context.

Add a test for this.

# Required tests

## A. Governed `complete()` forwarding

Fake underlying provider records kwargs.

Call:

```python
governed.complete(
    messages,
    max_tokens=123,
    temperature=0,
)
```

Assert:

- governance ran;
- `max_tokens=123` reached underlying provider;
- `temperature=0` reached underlying provider;
- prompt content appears once.

## B. Governed `complete_semantic()` forwarding

Fake underlying provider exposes:

```python
complete_semantic(
    messages,
    *,
    validator,
    repair_factory,
    stage,
    max_tokens,
    temperature,
)
```

Assert exact values arrive.

## C. Unknown kwarg

Pass an unsupported arbitrary kwarg.

Assert it is not blindly forwarded.

## D. Simple-provider fallback

Underlying provider only has `complete()`.

Assert:

- initial semantic call remains bounded;
- repair semantic call remains bounded;
- both prompts remain governed.

## E. Pipeline integration

Run actual interpretation and target-design semantic stages through `_GovernedSemanticProvider`.

Assert:

- no unexpected-keyword TypeError;
- interpretation uses `SEMANTIC_INTERPRETATION_MAX_TOKENS`;
- design uses `SEMANTIC_DESIGN_MAX_TOKENS`;
- stage values survive;
- temperature survives.

## F. JSON repair

Force malformed JSON.

Assert:

- repair prompt is governed;
- repair call has bounded output;
- strict validator remains authoritative.

# Exact user regression

Submit:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

Expected:

- no `_GovernedSemanticProvider.complete_semantic() got an unexpected keyword argument 'max_tokens'`;
- semantic interpretation enters the bounded timeout/failover system;
- target design can run;
- normal semantic authorization proceeds.

If the external provider genuinely times out afterward, return the real bounded provider-timeout diagnostics rather than a TypeError.

# Misleading OpenCode 600-second status

The browser also displayed:

```text
OpenCode has produced no stream data for 600s — waiting for the backend
```

even though failure occurred inside the pre-runtime semantic gate.

After fixing the interface mismatch, verify whether this still reproduces.

Before semantic authorization succeeds, the request is in semantic-gate phase, not OpenCode-stream phase.

If the UI/backend marks OpenCode as started before semantic authorization completes:

- move the OpenCode stream/watchdog transition until after semantic authorization;
- or expose a separate semantic-authorization phase.

Do not claim OpenCode is stalled when OpenCode has not yet received mutation authority.

This UI correction is secondary; perform it only if reproducible.

# Do not modify unrelated architecture

Do not:

- weaken semantic-first;
- disable prompt governance;
- remove generation bounds;
- increase timeouts as the primary fix;
- hard-code one model;
- rebuild model discovery;
- modify Harvest;
- manually patch canonical semantic JSON.

This is an adapter-interface repair.

# Canonical reconciliation

Because `interceptor.py` is semantic-authority production code:

1. run wrapper unit tests;
2. run semantic provider timeout tests;
3. run semantic pipeline tests;
4. run prompt-governance tests;
5. run semantic-first enforcement tests;
6. run the exact UI regression;
7. reconcile canonical semantic state through the normal path;
8. independently assess synchronization;
9. require `SYNCED`;
10. immediately reassess with no changes and require `SYNCED` again.

Do not hand-edit canonical baseline files.

# Completion criteria

Do not stop until all are true:

1. `_GovernedSemanticProvider.complete()` safely accepts supported generation controls.
2. `_GovernedSemanticProvider.complete_semantic()` accepts `max_tokens`.
3. It accepts `temperature`.
4. It accepts/preserves `stage`.
5. It forwards those values to underlying `complete_semantic()`.
6. Simple-provider fallback forwards bounded generation controls.
7. JSON repair remains bounded.
8. Initial prompt remains governed.
9. Repair prompt remains governed.
10. No prompt is double-built.
11. `stage` is not sent as an HTTP generation field.
12. Unknown provider kwargs are not blindly forwarded.
13. Interpretation runs without TypeError.
14. Target design runs without TypeError.
15. Repair runs without TypeError.
16. Actual HTTP provider receives bounded `max_tokens`.
17. Semantic-first remains fail-closed.
18. Structural fallback remains non-authorizing.
19. Prompt governance remains mandatory.
20. Exact user build request no longer fails on wrapper signature mismatch.
21. Genuine provider failures surface as provider failures, not adapter TypeErrors.
22. Misleading pre-runtime OpenCode watchdog status is corrected if reproducible.
23. Final independent synchronization is `SYNCED`.
24. Second no-change synchronization remains `SYNCED`.

# Stop condition

Stop when this call chain is interface-compatible:

```text
semantic pipeline
    ↓
max_tokens / temperature / stage
    ↓
_GovernedSemanticProvider
    ↓
prompt governance
    ↓
semantic provider pool
    ↓
bounded provider completion
```

with no dropped bounds, no unexpected-keyword TypeError, and no prompt-governance bypass.
