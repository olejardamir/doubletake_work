# Historical governed semantic-provider kwarg compatibility case

**Provenance:** archived Agent_X diagnostic/prompt, authored against historical `main` `baabdd9d91b04f53dee4ed2555526086fac4bd5a`. Previous full body recoverable from Git blob `1612783d0cb3f13daeff9e14488383996e491a17`. This is **not** evidence of a defect in current private DT or an approved task. Check current owner/callers and tests before applying any mechanism.

## Observed historical failure and causal hypothesis

A normal build request reportedly failed before semantic authorization:
```text
SEMANTIC_FIRST_DENIED: SEMANTIC_FIRST_FAILED:
TypeError: _GovernedSemanticProvider.complete_semantic()
got an unexpected keyword argument 'max_tokens'
```
The bounded semantic pipeline passed `validator`, `repair_factory`, `max_tokens`, `temperature` and `stage` to `complete_semantic`; the governance adapter in `tools/agentx_evolve/semantic_first/interceptor.py` reportedly accepted only `messages, validator, repair_factory`. The underlying semantic provider/pool reportedly already supported generation controls. This is a **signature/adapter mismatch hypothesis**, not a reason to weaken semantic-first or increase timeouts.

## Transferable mechanism / contracts

- Preserve a single governed path: semantic pipeline → governance adapter → prompt build/gate/persistence → bounded provider completion. Initial and JSON-repair prompts must each be governed **exactly once**; prevent double-building and repeated context.
- Adapt `_GovernedSemanticProvider.complete_semantic` to the **actual** current semantic call contract, including `validator`, `repair_factory`, `stage`, `max_tokens`, `temperature` when supported. `complete()` and simple-provider fallback must forward validated bounded generation controls for both initial and repair calls.
- Canonically allowlist supported HTTP generation fields (historically `max_tokens`, `temperature`, `top_p`, `stop`, `response_format`); reject or deterministically omit unknown kwargs. **Never** leak wrapper-only `stage`, `validator`, `repair_factory` into the OpenAI-compatible HTTP payload.
- Preserve provenance classification, prompt gate, canonical-template checks, prompt persistence, operator-controller checks, strict validator, fail-closed semantic authorization and non-authorizing structural fallback. No model hardcoding, manual semantic-state patch, parallel adapter or unrelated architecture change.

## Falsifiable regression matrix

1. Recording fake provider: governed `complete(messages, max_tokens=123, temperature=0)` forwards exact bounds, builds prompt once, rejects unknown kwargs.
2. Recording semantic provider: `complete_semantic(..., validator, repair_factory, stage, max_tokens, temperature)` receives exact values; stage is retained internally but excluded from outbound HTTP.
3. Simple-provider fallback and malformed-JSON repair: both prompts governed once, bounded, strict validator remains authoritative.
4. Real interpretation and target-design stages: no unexpected-keyword TypeError; stage-specific `SEMANTIC_INTERPRETATION_MAX_TOKENS` and `SEMANTIC_DESIGN_MAX_TOKENS` survive; real provider timeout is reported as timeout.
5. UI status negative control: a reported `OpenCode has produced no stream data for 600s` warning occurred while the semantic gate had failed. Check whether the UI incorrectly labels **pre-runtime semantic authorization** as an OpenCode stream stall; correct only if reproduced.
6. Run focused wrapper, timeout, pipeline, prompt-governance, semantic-first and exact user-path regression tests. Reconcile canonical semantic state through existing authorized process and independently require `SYNCED`, then `SYNCED` again without changes.

**Limits/UNKNOWN:** no test rerun here; historical incident/run identifiers and user-local filesystem paths omitted as unnecessary to mechanism. Current DT adapter existence, kwargs policy, provider API and parity remain unverified. Do not promote this historical fix without a reproducible **current** failure and an authorized existing owner.
