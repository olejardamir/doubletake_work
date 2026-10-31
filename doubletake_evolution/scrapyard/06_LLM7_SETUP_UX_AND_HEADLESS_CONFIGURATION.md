# Prompt 06 — Implement LLM7 Setup UX and Non-Interactive Configuration

## Objective

Make LLM7 easy to select in Agent_X without creating a login ceremony that contradicts the provider's anonymous mode.

## Interactive setup

Integrate LLM7 into the existing provider setup flow.

The default anonymous path should require only what is genuinely necessary, normally:

```text
provider: LLM7
model: dynamically discovered or a validated selector
```

Do not ask for:

```text
account
email
password
API key
token
login
```

unless the user explicitly chooses an optional authenticated LLM7 mode supported by the current architecture.

If model discovery can be performed immediately, show the discovered choices through the existing UX conventions.

If live discovery fails, provide a precise error and preserve the user's provider configuration state. Do not convert that failure into a credential prompt.

## Headless / non-interactive setup

Support the repository's existing non-interactive configuration mechanism.

The LLM7 configuration must be expressible without prompts, suitable for automation/CI/headless execution.

Reuse existing configuration conventions. Do not invent a second config file if Agent_X already has one.

Support the minimum necessary fields, conceptually:

```text
provider = llm7
model = <dynamic id or supported selector>
base_url = default unless existing architecture permits override
auth = none by default
```

Use real current field names from the repository rather than literally introducing these names if the schema differs.

## Configuration validation

Validation must understand that:

```text
provider=llm7 + anonymous mode + no credential
```

is a valid configuration when the service supports anonymous access.

Do not reuse a generic "remote provider requires API key" assertion against LLM7.

Optional token configuration, if implemented, must not become mandatory.

## Persistence

- Store only actual configuration.
- Do not persist fake API keys.
- Never expose optional secrets in logs or diagnostics.
- Preserve existing migration/versioning conventions.
- Existing OpenCode/Codex saved configurations must continue to load.

## Tests

Cover:

```text
interactive LLM7 selection
anonymous setup with no credential
dynamic model selection
cancel/back behavior if applicable
headless LLM7 configuration
config reload
config validation
no fake credential persistence
legacy OpenCode/Codex config regression
```

## Completion criteria

A user can configure and use LLM7 without logging in, and automation can configure it without interactive input.
