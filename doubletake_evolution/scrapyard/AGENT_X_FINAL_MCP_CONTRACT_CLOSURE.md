# Agent_X Semantic-First — Final MCP Contract Closure Prompt

Current independently audited `main` at the time this prompt was written:

`32bd82f952139addcf0c58530f10e2538be0dcc2`

Do not assume this SHA is still current. Start by checking the actual current `main`.

## Mission

Close the final remaining semantic-first gap:

> Every real registered MCP/tool capability must have an explicit canonical effect contract. No registered tool may remain usable-but-unclassified, and no heuristic fallback may be reintroduced.

Do **not** redesign semantic-first.

Do **not** redo the canonical baseline, snapshot classifier, UI gate, Borg, Harvest, provider routing, background finalization, legacy transaction cleanup, or semantic model unless this final contract-completeness change requires a narrow update/remint.

Do **not** add CI/CD or GitHub Actions work.

Do **not** create a dedicated Architectural MCP.

Reuse the existing canonical `tool_effects` registry and semantic authorization path.

---

# Current proven remaining defect

The current effect system is fail-closed and materially correct:

- closed effect classes exist;
- unknown tools are denied;
- name/substring heuristics are no longer final authority;
- malformed contracts fail closed;
- resource extraction is explicit;
- read-only contract violations can be quarantined.

However the repository's own validation still expects at least one registered tool to be missing an explicit effect contract.

Current regression logic explicitly allows:

`"action_dispatch" in missing or "system_model_switch" in missing`

That means the canonical MCP registry is not yet complete.

This is the last remaining gap.

---

# 1. Enumerate the actual registered tool universe

Do not manually classify only the two examples already observed.

Build the exact current set of registered MCP/tool names from the real production registries.

Include all tools exposed by:

- `agentx_mcp_server`;
- `borg_mcp_server`;
- dynamic tool-definition providers;
- any tool definitions injected into `handle_tools_list()`;
- any other production MCP/tool registry consumed by LLM7/OpenCode/Codex or Agent_X runtime.

Do not include:

- test-only fake tools;
- fixtures;
- dead code;
- documentation examples.

Produce one deterministic set:

`registered_production_tool_names`

Then compare it to:

`explicit_effect_contract_names`

The required invariant is:

`registered_production_tool_names - explicit_effect_contract_names == ∅`

No exceptions.

---

# 2. Give every real registered tool an explicit effect contract

For every registered production tool, define a complete explicit contract.

Each contract must include the canonical equivalents of:

- exact tool name;
- effect class;
- read-only boolean;
- resource extractor;
- required arguments;
- argument schema;
- locality;
- touched resource categories;
- rollback/recovery semantics;
- explicit flag;
- contract digest.

Use the existing closed effect classes:

- `read_only`;
- `exact_file`;
- `multi_file`;
- `git`;
- `database`;
- `dependency_environment`;
- `service_config`;
- `durable_project_state`;
- `remote_durable`;
- `unknown`.

`unknown` remains deny-only.

Do not add new ad hoc string effect classes unless the current closed enum genuinely cannot represent a required production effect.

If a new effect class is absolutely necessary:

1. justify it architecturally;
2. add it to the canonical enum;
3. add deterministic validation;
4. add resource extraction;
5. add rollback semantics;
6. add tests;
7. remint semantic state afterward.

Prefer using the current closed set.

---

# 3. Fix `action_dispatch` properly

`action_dispatch` is not a simple read-only or single-file tool.

It can invoke different underlying registered actions.

Do not classify it with one broad generic mutation contract.

## Required design

`action_dispatch` must behave as a meta-dispatch authority layer.

Before execution:

1. resolve the exact requested `action_name`;
2. resolve the canonical effect contract for that underlying action;
3. derive the exact typed resources/effects from `args`;
4. validate semantic authorization against those exact effects;
5. validate normal action governance;
6. execute only if both pass.

The dispatcher itself must not widen the underlying action's authority.

If the underlying action:

- has no explicit effect contract;
- has malformed effect metadata;
- cannot derive exact resources;

then `action_dispatch` must deny it.

Do not give `action_dispatch` wildcard repository authority.

Do not classify all dispatched actions as `durable_project_state` merely to make them pass.

## Required tests

Through the real dispatcher:

- dispatch a read-only action → succeeds without mutation authority;
- dispatch an exact-file action inside scope → succeeds;
- dispatch an exact-file action outside scope → denied;
- dispatch a Git action without Git effect authorization → denied;
- dispatch an unknown/uncontracted action → denied;
- dispatch malformed args → denied;
- semantic denial → overrides dispatcher/action approval.

---

# 4. Fix `system_model_switch` explicitly

`system_model_switch` changes active Agent_X runtime state.

It is not read-only.

Classify it explicitly using the most accurate existing effect class, likely:

`durable_project_state`

or another already-existing class if the current implementation semantics fit better.

Its resource scope should identify the exact runtime/model-selection state being changed.

Bind at least:

- runtime/workspace identity where applicable;
- requested model identifier;
- current model state;
- target model state.

Do not use a file-path extractor unless the production effect is genuinely file-backed.

## Required tests

- authorized model switch → succeeds;
- same tool without semantic authorization → denied;
- malformed model identifier → denied;
- switching to an unavailable/invalid model → fails without leaving inconsistent state;
- read-only tool path cannot invoke model switching indirectly.

---

# 5. Classify every other currently missing tool

Run:

`validate_registered_tool_effects()`

on the actual production registry.

For each returned name:

1. inspect the real implementation;
2. determine actual effect semantics;
3. add a complete explicit contract;
4. add exact resource extraction;
5. add a regression test.

Do not classify based on:

- tool name substring;
- description wording;
- guessed intent;
- arbitrary argument-key names.

Inspect the actual code path.

If the tool is truly read-only:

- declare explicit read-only contract.

If effectful:

- declare exact effect class and resources.

If exact effects cannot be bounded safely:

- leave it unavailable/denied;
- do not pretend classification is complete.

But the final production registry must not expose it as a normal usable tool while it remains uncontracted.

---

# 6. Make registry completeness a hard startup/runtime invariant

Do not leave `validate_registered_tool_effects()` as an informational helper only.

At startup or tool-registry construction time, run a deterministic completeness validation.

If any production registered tool lacks a valid explicit effect contract:

- mark it unavailable/disabled;
- exclude it from the offered executable tool list;
- report the exact missing contract;
- do not silently continue exposing it.

The preferred final invariant is stronger:

`validate_registered_tool_effects() == ()`

for the normal production registry.

Do not require the whole Agent_X backend to crash if one optional tool is missing a contract unless current architecture requires that.

But an uncontracted tool must never be executable.

---

# 7. Keep annotation and execution contracts identical

The effect metadata exposed through tool discovery must come from the same canonical contract used at execution.

Do not maintain:

- one contract in `handle_tools_list()`;
- another in LLM7 execution;
- another in MCP server dispatch.

One logical canonical effect contract per tool.

Required:

`discovery contract digest == execution contract digest`

for the same tool/version.

If they differ:

deny execution.

Add a regression test.

---

# 8. Preserve fail-closed behavior for dynamic tools

Dynamic tools may appear after startup.

Every dynamically registered production tool must supply a complete explicit effect contract at registration time.

Registration without valid effect metadata must:

- fail;
- or register the tool as disabled/unknown-denied.

It must not become executable and “figure out” its effect class later.

Add tests for:

- dynamic valid read-only tool;
- dynamic valid effectful tool;
- dynamic missing contract;
- dynamic malformed contract;
- dynamic contract digest mismatch.

---

# 9. Preserve read-only observation as defense-in-depth only

Read-only classification must still come from explicit contract metadata.

The before/after observation check is secondary protection.

Do not use observation as the primary classifier.

If a declared read-only tool mutates state:

- quarantine the tool;
- record discrepancy;
- deny result as successful;
- require contract correction before reuse.

Keep this behavior.

---

# 10. Final registry acceptance test

At the end, run against the real production tool registry:

`missing = validate_registered_tool_effects()`

Required:

`missing == ()`

Then enumerate every registered tool and assert:

- `contract.explicit is True`;
- `contract.effect_class != "unknown"`;
- `contract.contract_digest` recomputes;
- effectful tools have a valid resource extractor;
- read-only tools declare read-only explicitly;
- rollback semantics are present;
- touched resource categories are valid;
- malformed definitions fail closed.

No exception list.

No `"action_dispatch" or "system_model_switch"` allowance.

Remove the existing regression assertion that expects a missing tool.

Replace it with:

`assert validate_registered_tool_effects() == ()`

against the real production registry.

---

# 11. Re-run the actual LLM7/MCP execution boundary

Do not stop at registry unit tests.

Use the real LLM7/MCP checked execution path.

Verify:

## Read-only tool

- offered;
- explicit read-only contract;
- no semantic mutation authority required;
- observed mutation causes quarantine/failure.

## Exact file tool

- exact authorized file → allowed;
- unauthorized file → denied.

## Multi-file tool

- all resources inside semantic scope → allowed;
- one outside → entire operation denied.

## Git tool

- requires Git typed-effect authorization.

## Durable project-state tool

- requires exact durable-state authorization.

## `action_dispatch`

- inherits underlying action contract exactly.

## `system_model_switch`

- requires explicit durable-state authorization.

## Unknown tool

- not executable.

---

# 12. Re-run non-regression semantic-first checks

Do not redo prior work.

Just prove these remain intact after the registry changes:

- canonical source snapshot remains clean;
- ambiguous JSON/YAML/TOML/skill files remain excluded without production-consumer evidence;
- accepted model source hashes match current snapshot;
- accepted baseline source hashes match current snapshot;
- baseline implementation revision recomputes;
- evidence digests remain artifact-backed;
- background semantic finalization remains fail-closed;
- legacy transaction migration/retention remains correct;
- fresh checkout portability remains correct;
- normal UI write still performs semantic-first automatically.

---

# 13. Final canonical remint

Because the tool-effect registry is production behavior and part of semantic/governance authority, changing it changes production implementation truth.

After all contracts are complete:

1. compute current corrected production snapshot;
2. compute implementation revision;
3. regenerate/update affected semantic model scope;
4. run governed LLM semantic enrichment for affected governance/tool responsibilities;
5. verify the effect-contract registry behavior;
6. issue real target evidence;
7. issue real verification evidence;
8. reconcile semantic model against implementation;
9. build a new canonical baseline;
10. persist atomically;
11. reload;
12. independently assess synchronization;
13. require `SYNCED`;
14. run a second no-change assessment;
15. require `SYNCED` again.

Do not hand-edit canonical JSON.

---

# Final completion criteria

Do not stop until every condition is true:

1. The actual current production MCP/tool registry has been enumerated deterministically.
2. Every registered production tool has an explicit canonical effect contract.
3. `validate_registered_tool_effects() == ()`.
4. No production tool depends on name/substring heuristics for final effect authority.
5. No production tool depends on guessed argument-key names for final effect authority.
6. `action_dispatch` delegates effect authority to the exact underlying action contract.
7. `action_dispatch` cannot widen underlying authority.
8. Unknown/uncontracted dispatched actions are denied.
9. `system_model_switch` has an explicit non-read-only effect contract.
10. `system_model_switch` requires semantic authorization.
11. Every effectful tool has deterministic resource extraction.
12. Every effectful tool has rollback/recovery semantics.
13. Every read-only tool declares read-only explicitly.
14. Read-only mutation observation remains defense-in-depth.
15. Read-only contract violations quarantine the tool.
16. Dynamic tool registration requires a valid explicit contract.
17. Missing/malformed dynamic contracts cannot become executable.
18. Discovery metadata and execution metadata come from the same canonical contract.
19. Discovery contract digest equals execution contract digest.
20. Uncontracted tools are excluded/disabled rather than exposed as executable.
21. The previous test allowing `action_dispatch`/`system_model_switch` to remain missing is removed.
22. The real production test asserts `validate_registered_tool_effects() == ()`.
23. Real LLM7/MCP execution tests pass for read-only, file, multi-file, Git, durable-state, dispatcher, and model-switch cases.
24. Semantic denial overrides all other approval mechanisms.
25. Canonical semantic model is updated/reminted after registry completion.
26. Canonical baseline is reminted after registry completion.
27. Accepted model source hashes equal current `source_snapshot()`.
28. Accepted baseline source hashes equal current `source_snapshot()`.
29. Baseline implementation revision recomputes from current snapshot.
30. Accepted target and verification evidence remain real and recomputable.
31. Independent synchronization assessment returns `SYNCED`.
32. Fresh checkout remains portable and returns `SYNCED`.
33. A second no-change assessment remains `SYNCED`.
34. Normal UI write path still completes the full semantic-first lifecycle automatically.
35. No semantic transaction junk is recreated.

---

# Stop condition

Stop only when actual current `main` proves all 35 conditions.

Do not stop because:

- commit message says fixed;
- tool registry “looks complete”;
- stored JSON says `SYNCED`;
- tests merely check a few example tools.

The decisive condition is:

`validate_registered_tool_effects() == ()`

for the real production registry,

followed by a canonical remint and two independent no-conflict `SYNCED` assessments.

At that point the semantic-first foundation is complete.
