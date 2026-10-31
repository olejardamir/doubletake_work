# Prompt 09 — Final End-to-End Validation and Convergence

## Objective

Audit the completed LLM7 integration from the user's perspective and from the Agent_X runtime perspective. Fix anything still incomplete.

Do not merely summarize previous work.

## 1. Repository audit

Re-read the changed files and verify that the implementation follows the existing provider architecture.

Confirm there is no second/parallel provider registry, transport stack, or configuration system created only for LLM7 without necessity.

Review the diff for unrelated changes and revert only unrelated changes introduced by this work, while preserving pre-existing user work.

## 2. End-to-end anonymous flow

Exercise the real Agent_X path:

```text
select/configure LLM7
    ↓
discover models
    ↓
select a usable model
    ↓
build runtime config
    ↓
send chat completion with no credential
    ↓
receive/normalize response
    ↓
stream response where supported
```

Verify the outbound anonymous request contains **no Authorization header**.

Do not substitute a direct `curl` test for the Agent_X runtime test; use direct curl only as an external control.

## 3. Tool/function flow

Where a currently accessible model/access mode supports tools, exercise the Agent_X tool path end to end.

If anonymous tool calling is not currently permitted, prove that Agent_X:

- does not falsely advertise it;
- reports the limitation accurately;
- continues to support ordinary anonymous chat.

## 4. Headless flow

Exercise non-interactive configuration and a real request without manual prompts.

## 5. Existing-provider regression

Verify OpenCode and Codex still work through their normal configuration/runtime paths or, where external credentials make live execution inappropriate, run the strongest existing deterministic/integration coverage.

## 6. External behavior drift

Recheck:

```text
GET https://api.llm7.io/v1/models
POST https://api.llm7.io/v1/chat/completions
```

If LLM7's live anonymous policy differs from the earlier 2026-09-11 verification, do not disguise it.

The correct behavior is:

```text
Agent_X implementation remains structurally capable of anonymous mode
+
Agent_X clearly reports the current external restriction
+
no fake login/key requirement is silently inserted into the design
```

## 7. Final acceptance checklist

Everything below must be true before completion:

```text
[ ] LLM7 is a first-class Agent_X provider.
[ ] Existing OpenCode provider remains intact.
[ ] Existing Codex provider remains intact.
[ ] LLM7 uses https://api.llm7.io/v1.
[ ] Chat uses /chat/completions.
[ ] Anonymous mode needs no Agent_X credential.
[ ] Anonymous requests omit Authorization.
[ ] Models come from /v1/models dynamically.
[ ] Concrete model turnover does not require a code update.
[ ] Model capabilities are represented accurately.
[ ] Streaming is integrated and tested.
[ ] Tool/function calls are capability-aware and tested.
[ ] Interactive configuration works.
[ ] Headless configuration works.
[ ] No fake key is persisted.
[ ] Errors are explicit and safe.
[ ] Provider/unit/integration tests pass.
[ ] Relevant shared regressions pass.
[ ] A live anonymous smoke test succeeds if LLM7 currently allows anonymous chat.
[ ] No placeholders/TODO-only implementation remain.
[ ] No unrelated refactor was introduced.
```

## Final output

Provide a concise implementation report containing:

```text
files changed
provider architecture path used
anonymous-auth behavior
model discovery behavior
streaming/tool behavior
tests run and results
live LLM7 checks and results
any externally imposed limitation that remains
```

Do not declare success for any checklist item that was not actually verified.
