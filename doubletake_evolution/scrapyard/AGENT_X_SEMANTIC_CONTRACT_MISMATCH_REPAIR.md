# Agent_X — Semantic Contract-Mismatch Repair

Current audited `main` when this prompt was written:

`b79273a7ffcac5616b40f151cc322fa8499a5210`

Re-check the actual current local working tree before editing.

## Exact production failure

A normal build request now reaches:

- semantic provider resolution;
- bounded semantic interpretation;
- candidate failover;
- target-design generation;

but target design fails with:

```text
502
Semantic reasoning provider response was invalid.

SEMANTIC_PROVIDER_CONTRACT_MISMATCH:
A semantic target has an invalid authority decision.
```

The attempt chain proves:

```text
codestral-latest          → interpretation success
codestral-latest          → target_design CONTRACT_MISMATCH
mistral-Nemo-Instruct...  → target_design CONTRACT_MISMATCH
minimax-m2.7              → target_design CONTRACT_MISMATCH
```

This is no longer a provider-availability problem.

It is a semantic response-contract recovery defect.

Do not weaken semantic-first.

Do not accept invalid authority decisions.

Do not auto-coerce security-sensitive authority values without governed model confirmation.

---

# 1. Proven current root cause

Current semantic authority values are strictly:

```python
_SEMANTIC_AUTHORITY_VALUES = frozenset({
    "deterministic",
    "prompt_driven",
    "prompt_only",
})
```

Target validation correctly rejects any component whose:

```python
component["authority_decision"]
```

is not exactly one of those values.

Keep this strict validator.

The defect is in recovery.

Current `_SemanticProviderPool.complete_semantic()` only gives the model a repair attempt when:

```python
failure.code == INVALID_SEMANTIC_JSON
```

A valid JSON object that violates the schema produces:

```text
CONTRACT_MISMATCH
```

and therefore gets no schema-repair attempt.

The system immediately moves to another model.

All three models can therefore repeat the same trivial schema mismatch and exhaust the candidate pool.

---

# 2. Do not solve this by weakening the validator

Forbidden shortcuts:

- allow arbitrary authority strings;
- accept `"prompt-driven"` directly as production authority;
- accept `"prompt driven"`;
- accept `"PROMPT_DRIVEN"`;
- default unknown values to `prompt_driven`;
- default invalid values to deterministic;
- silently drop invalid components;
- authorize structural fallback.

Authority decisions are architecture/security-sensitive.

The canonical accepted values remain exactly:

```text
deterministic
prompt_driven
prompt_only
```

---

# 3. Add one bounded contract-repair attempt

Treat these semantic provider failures as potentially repairable:

- `INVALID_SEMANTIC_JSON`;
- `CONTRACT_MISMATCH`.

For either class:

1. preserve the original provider response;
2. preserve the original semantic prompt;
3. append a narrow repair instruction;
4. include the exact sanitized validation failure;
5. ask the SAME governed model to repair only the schema violation;
6. bound output with `SEMANTIC_REPAIR_MAX_TOKENS`;
7. validate again with the same strict validator;
8. accept only if validation fully succeeds;
9. otherwise fail over to the next candidate.

One repair attempt per candidate is enough.

Do not create an infinite correction loop.

---

# 4. Repair instruction must be schema-specific

Current generic repair instruction is approximately:

```text
Repair your preceding response into exactly one valid JSON object
matching the requested schema.
```

Strengthen it for contract repair.

For authority decisions, the repair prompt must explicitly state:

```text
For every `authority_decision`, use EXACTLY one of:

"deterministic"
"prompt_driven"
"prompt_only"

These are exact machine enum values.
Do not use hyphens, spaces, capitalization variants, labels, prose,
or any other synonym.
```

Do the same for interpretation-level:

```text
authority_decisions
```

values.

The original design prompt already shows the underscore values, but the natural-language section uses labels such as:

```text
Prompt-driven authority
Prompt-only
```

which may encourage models to emit display-language variants.

Make the machine contract unmistakable.

---

# 5. Separate machine enum tokens from human labels

In `_build_interpretation_prompt()` and `_build_design_prompt()`:

Use human-readable labels only as explanations.

Explicitly distinguish them from the serialized enum.

Example:

```text
Human concept: Prompt-driven authority
JSON enum token: "prompt_driven"
```

and:

```text
Human concept: Prompt-only
JSON enum token: "prompt_only"
```

Do not write prose that makes a hyphenated label look interchangeable with the JSON value.

---

# 6. Improve validator diagnostics

Current target validator returns only:

```text
A semantic target has an invalid authority decision.
```

That is too vague for deterministic repair and debugging.

Change it to identify at least:

- component index or component ID;
- field name;
- actual received value;
- allowed values.

Example:

```text
Component 'semantic_first.provider_resolution':
field 'authority_decision' received 'prompt-driven';
allowed values are ['deterministic', 'prompt_driven', 'prompt_only'].
```

Do not include sensitive prompt content.

Likewise improve interpretation validator diagnostics for invalid:

```python
authority_decisions
```

entries.

The diagnostic itself must not mutate/normalize the response.

---

# 7. Pass the exact validation failure into repair

When validator raises `SemanticProviderFailure(CONTRACT_MISMATCH, detail)`:

the provider pool should construct the repair turn using:

- original invalid content;
- canonical repair instruction;
- sanitized failure detail.

Conceptually:

```text
Your preceding JSON failed schema validation:

<exact validation detail>

Return the same semantic decision, corrected only so it satisfies
the exact schema.

Do not change architectural meaning merely to pass validation.
```

For an invalid authority enum specifically:

```text
Use only exact enum tokens:
"deterministic", "prompt_driven", "prompt_only".
```

---

# 8. Preserve prompt governance on repair

The repaired conversation must still flow through:

```text
semantic pipeline
→ _GovernedSemanticProvider
→ governed prompt construction
→ prompt gate
→ provider pool
```

Do not send the repair request directly to LLM7 outside governance.

Do not bypass provenance classification.

---

# 9. Keep contract repair distinct from semantic reinterpretation

A contract-repair pass may fix:

- enum spelling;
- missing required field;
- wrong JSON type;
- malformed list shape;
- missing required component field;
- machine-schema formatting.

It must not invent a new architectural answer merely because the original answer failed validation.

The repair instruction must state:

> Preserve the semantic/architectural meaning of the preceding response. Correct only what is necessary to satisfy the machine contract.

If the response cannot be repaired without changing substantive meaning:

- fail that candidate;
- try another candidate;
- ultimately fail closed if none succeed.

---

# 10. Do not deterministically normalize authority decisions in code

Do not implement:

```python
value.replace("-", "_")
```

or:

```python
value.lower()
```

as authority acceptance.

Even if the current observed issue is probably a formatting variant, code-side coercion creates an authority boundary that guesses model intent.

Use the bounded governed repair instead.

The strict validator remains final authority.

---

# 11. Contract repair applies to interpretation too

Current interpretation validation also strictly checks:

```python
authority_decisions
```

against the same enum.

The interpretation stage happened to pass in this run, but the same brittleness exists.

Apply the same bounded contract-repair behavior to:

- interpretation;
- target design;
- JSON repair paths where applicable.

Do not fix only target design.

---

# 12. Repair attempt diagnostics

Record repair attempts distinctly.

Example:

```json
{
  "stage": "target_design_contract_repair",
  "model": "codestral-latest",
  "failure_bucket": "success",
  "repair_of": "SEMANTIC_PROVIDER_CONTRACT_MISMATCH"
}
```

If repair fails:

```json
{
  "stage": "target_design_contract_repair",
  "failure_bucket": "SEMANTIC_PROVIDER_CONTRACT_MISMATCH"
}
```

Do not report a contract-repair attempt as another ordinary target-design generation.

This makes the attempt chain intelligible.

---

# 13. Do not mark a contract mismatch as model-health timeout failure

Current semantic health ranking is intended to penalize timeouts/provider unreliability.

A valid transport response with a semantic contract mismatch is not equivalent to a timeout.

Do not put the model into timeout cooldown solely because:

```text
CONTRACT_MISMATCH
```

occurred.

Track semantic-contract failure separately if health metrics need it.

Provider availability and semantic schema compliance are different dimensions.

---

# 14. Failover order after repair

Correct order per candidate:

```text
candidate initial response
        ↓
strict validation
        ↓
PASS → use result
        ↓
INVALID_JSON or CONTRACT_MISMATCH
        ↓
one governed bounded repair
        ↓
strict validation
        ↓
PASS → use repaired result
        ↓
FAIL → next candidate
```

Not:

```text
contract mismatch
→ immediately abandon candidate
```

---

# 15. Optional JSON-schema response mode

If a candidate explicitly advertises reliable JSON/schema response support and the existing LLM7/OpenAI-compatible provider path supports it, consider supplying a schema-aware `response_format`.

Do not require this for the fix.

Do not assume every candidate supports it.

Do not send unsupported schema options to models whose metadata does not advertise support.

Strict post-response validation remains mandatory even when JSON mode is used.

---

# 16. Required unit tests — target authority enum

Test valid target responses containing:

```text
deterministic
prompt_driven
prompt_only
```

All must pass.

Test invalid responses:

```text
prompt-driven
prompt driven
PROMPT_DRIVEN
Prompt-driven authority
automatic
llm
```

All must fail direct validation.

This proves the validator stayed strict.

---

# 17. Required unit tests — contract repair

## A. Hyphenated authority value

Initial response:

```json
{
  "components": [{
    "component_id": "x",
    "component_type": "capability",
    "authority_decision": "prompt-driven",
    "target_state": "x",
    "verification_requirements": ["x"],
    "rationale": "x"
  }],
  "intended_architecture": "x",
  "verification_strategy": "x"
}
```

Validator must fail.

Repair provider returns same object with:

```text
prompt_driven
```

Expected:

- repair validated;
- result accepted;
- no fallback to structural authority.

## B. Invalid value remains invalid

Repair returns:

```text
"authority_decision": "model_decides"
```

Expected:

- repair rejected;
- next candidate tried.

## C. Missing required field

Initial valid JSON omits `rationale`.

Expected:

- CONTRACT_MISMATCH;
- one repair attempt;
- repaired result validated if field restored meaningfully.

## D. Wrong type

`verification_requirements` is a string.

Expected:

- strict failure;
- one repair;
- accept only if it becomes a list of strings.

---

# 18. Required unit tests — interpretation contract repair

Initial interpretation emits:

```json
"authority_decisions": {
  "component-x": "prompt-driven"
}
```

Expected:

- strict direct validator failure;
- one governed repair;
- repaired exact `prompt_driven`;
- successful validation.

---

# 19. Required tests — no semantic drift during repair

Give an initial response with:

```text
component A = deterministic
component B = prompt-driven
```

Repair is needed only for B's enum formatting.

Expected repaired result:

```text
A remains deterministic
B becomes prompt_driven
```

If repair changes A to `prompt_only`, the system must detect the substantive mutation if current architecture can compare repair semantics.

At minimum instruct repair not to change unrelated fields and add a deterministic comparison that non-invalid stable fields remain unchanged where practical.

For contract repair, prefer preserving all already-valid fields exactly.

---

# 20. Deterministic repair-integrity check

For repairable contract mismatches, identify invalid field paths when possible.

After repair:

- fields not implicated by validation failure should remain identical;
- only invalid/missing schema fields may change.

For the current authority-decision case:

```text
all target fields except invalid authority_decision value
```

should remain identical.

This prevents the repair turn from silently redesigning the architecture.

If general field-level integrity is too broad for all contract errors, implement it at minimum for authority-decision enum repair.

---

# 21. Improve design prompt examples

The schema example must use concrete valid values rather than the pipe-delimited pseudo-value:

Current style:

```json
"authority_decision": "deterministic|prompt_driven|prompt_only"
```

This can be misread as a literal or descriptive placeholder.

Replace with an explicit schema statement such as:

```text
`authority_decision` MUST be exactly one of:
- "deterministic"
- "prompt_driven"
- "prompt_only"
```

Then show a concrete JSON example:

```json
"authority_decision": "prompt_driven"
```

Do the same for interpretation:

```json
"authority_decisions": {
  "component_id": "prompt_driven"
}
```

Do not use pipe-delimited strings inside example JSON for enums.

---

# 22. Validate `component_type` explicitly too

Current design prompt describes:

```text
capability|invariant|interface|governance|module
```

but current validator appears to require only meaningful text, not membership in a closed component-type set.

If `component_type` is intended to be a closed semantic contract, define and validate it explicitly now.

If it is intentionally extensible, document that and leave it open.

Do not leave an accidental mismatch between prompt contract and validator contract.

This is adjacent to the current bug and should be resolved deliberately, not cosmetically.

---

# 23. Validate top-level `verification_strategy`

The design prompt asks for:

```json
"verification_strategy": "..."
```

but current `_validate_design_content()` validates `intended_architecture` and component fields and does not appear to require `verification_strategy`.

Make prompt and validator agree.

Choose one:

- require meaningful `verification_strategy`; or
- remove it from the required response schema if it is not consumed.

Do not ask the provider for fields the validator/runtime ignores without reason.

---

# 24. Contract schema must have one canonical source

Avoid duplicated hand-written schema rules across:

- prompt text;
- validator;
- tests;
- repair instruction.

Create one small canonical schema/enum definition layer inside semantic-first.

At minimum canonicalize:

```python
SEMANTIC_AUTHORITY_VALUES
SEMANTIC_COMPONENT_TYPES  # if closed
```

and render those values into:

- prompts;
- validators;
- repair instructions;
- tests where appropriate.

This prevents prompt/validator drift.

Do not introduce a large schema framework.

---

# 25. Exact user regression

Submit:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

Expected attempt sequence if the first target response has a formatting mismatch:

```text
interpretation success
→ target_design response
→ CONTRACT_MISMATCH
→ same-model governed contract repair
→ strict validation success
→ semantic target accepted
→ normal semantic-first authorization continues
```

The request must not fail merely because all candidate models emitted a repairable enum-format mismatch.

---

# 26. Keep genuine invalid authority closed

Test a provider that repeatedly returns:

```text
authority_decision = "anything"
```

or values outside the canonical set.

After one repair per candidate and bounded failover:

Expected:

```text
SEMANTIC_PROVIDER_CONTRACT_MISMATCH
```

No mutation authority.

The fix is recovery for repairable schema mistakes, not acceptance of invalid authority.

---

# 27. Browser/API diagnostics

If all repairs fail, return a useful sanitized detail.

For example:

```text
Target design failed semantic contract validation after bounded repair:
component 'x' authority_decision='automatic';
allowed=['deterministic','prompt_driven','prompt_only'].
```

Include bounded attempt records.

Do not return provider raw output to the browser if it may contain sensitive project context.

---

# 28. Canonical reconciliation

This changes semantic-provider contract behavior.

After implementation:

1. run semantic validator unit tests;
2. run contract-repair tests;
3. run provider pool tests;
4. run governed wrapper tests;
5. run timeout/failover tests;
6. run semantic-first enforcement tests;
7. run the exact UI regression;
8. reconcile canonical semantic state through normal semantic-first;
9. independently assess synchronization;
10. require `SYNCED`;
11. run immediate no-change assessment;
12. require `SYNCED` again.

Do not hand-edit canonical semantic JSON.

---

# 29. Bootstrap note

If the current normal UI cannot authorize this fix because the target-design contract mismatch occurs before mutation authority, apply this repair through the trusted external/bootstrap maintenance path.

Do not introduce a permanent bypass.

After restart, future changes must again use normal semantic-first.

---

# Completion criteria

Do not stop until all are true:

1. strict authority enum remains exactly:
   - `deterministic`
   - `prompt_driven`
   - `prompt_only`
2. invalid values still fail direct validation.
3. `CONTRACT_MISMATCH` receives one bounded governed repair attempt.
4. `INVALID_SEMANTIC_JSON` still receives bounded repair.
5. repair receives sanitized validator error detail.
6. repair explicitly states exact authority enum tokens.
7. prompt distinguishes display labels from machine enum tokens.
8. pipe-delimited pseudo-enum examples are removed.
9. same candidate is repaired before failover.
10. repaired output is revalidated strictly.
11. already-valid unrelated fields are preserved during authority enum repair.
12. no deterministic code-side enum guessing/coercion is used.
13. interpretation contract can be repaired too.
14. target-design contract can be repaired.
15. contract mismatch does not count as a provider timeout.
16. contract mismatch does not trigger timeout cooldown.
17. repair attempt is separately visible in diagnostics.
18. genuine unrepaired invalid authority still fails closed.
19. prompt and validator agree on `component_type`.
20. prompt and validator agree on `verification_strategy`.
21. one canonical enum/schema source prevents future drift.
22. exact user request no longer fails on a repairable authority-decision formatting mismatch.
23. semantic-first remains mandatory and non-bypassable.
24. final independent synchronization is `SYNCED`.
25. second no-change synchronization remains `SYNCED`.

# Stop condition

Stop when a valid but schema-imperfect semantic response can be corrected through one governed bounded repair:

```text
provider response
    ↓
strict validator
    ↓
CONTRACT_MISMATCH
    ↓
governed schema repair with exact validation error
    ↓
strict validator
    ↓
valid canonical semantic target
```

while genuinely invalid/unrepairable authority decisions still fail closed.
