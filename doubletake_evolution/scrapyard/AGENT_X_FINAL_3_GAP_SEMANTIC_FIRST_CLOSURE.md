# Agent_X Semantic-First — Final 3-Gap Closure Prompt

Current independently audited `main` at the time this prompt was written:

`7346f477f23fe38025875a6e459a27b6e96d0689`

Do not assume this SHA is still current. Start by checking the actual current `main`.

## Mission

Close the final three material semantic-first defects.

Do **not** redo semantic-first.

Do **not** redesign Harvest, Borg, the UI, provider routing, rollback, verification, or canonical state unless one of these three defects requires a narrow correction.

Do **not** add CI/CD or GitHub Actions work.

Do **not** create a dedicated Architectural MCP.

Reuse the existing canonical semantic-first stack.

The task is complete only when all three defects below are closed and a fresh independent synchronization assessment returns `SYNCED`.

---

# Gap 1 — Canonical baseline/model were not reminted from the current snapshot rules

The current `artifact_role()` / `source_snapshot()` logic has already changed, but the accepted canonical model/baseline still contains files that the current implementation no longer classifies as production implementation.

Examples currently present in accepted `source_hashes` include:

- `mcp-test-skill.skill`
- `test-skill.skill`

This proves the stored canonical state is stale relative to the current snapshot boundary.

A stored `"status": "SYNCED"` is therefore not enough.

## Required fix

Do not hand-edit individual `source_hashes`.

Do not preserve the existing `implementation_revision`.

Rebuild canonical state from the current code path.

Required sequence:

1. load current accepted semantic state as historical input only;
2. compute the current `source_snapshot()` using the current artifact-role rules;
3. compute the current production `implementation_revision`;
4. compute the separate verification/evidence revision;
5. regenerate deterministic project facts from the corrected production boundary;
6. regenerate the semantic model through governed LLM enrichment;
7. validate semantic claims and evidence;
8. remove stale bindings/capabilities/invariants whose only source is no longer part of production implementation;
9. run production behavioral verification;
10. reconcile semantic current state against actual current production implementation;
11. construct a new baseline only through the canonical baseline builder;
12. persist model + baseline transactionally;
13. reload both;
14. independently call synchronization assessment;
15. require `SYNCED`;
16. run the same assessment again with no changes and require `SYNCED` again.

## Required proof

After reminting:

- `mcp-test-skill.skill` must not appear in production `source_hashes` unless deterministic runtime-consumer evidence proves it is production-authoritative;
- `test-skill.skill` must not appear in production `source_hashes` unless deterministic runtime-consumer evidence proves it is production-authoritative;
- every accepted source hash must be reproducible from the current `source_snapshot()`;
- `baseline.implementation_revision == implementation_revision(source_snapshot(repo_root))`;
- `model.source_hashes == source_snapshot(repo_root)`;
- a stored `SYNCED` marker that disagrees with these values must be rejected.

---

# Gap 2 — Non-code artifact classification is still too broad

The current artifact classifier still broadly treats file extensions such as:

- `.json`
- `.yaml`
- `.yml`
- `.toml`
- `.ini`
- `.cfg`
- `.conf`
- `.sh`

as runtime configuration outside excluded directories.

That is too broad.

A file does not become production implementation simply because of its extension.

The current accepted snapshot still contains examples such as:

- `dataset_stats.json`
- `evidence_manifest.json`
- `final_verdict.json`

These may or may not be runtime-authoritative. Their role must be proven, not assumed.

## Required architecture

Non-code artifacts enter production `implementation_revision` only when there is deterministic evidence that current production Agent_X consumes them.

Use one canonical role-resolution mechanism.

Each non-code artifact should resolve to one of:

- runtime prompt;
- runtime configuration;
- runtime schema/contract;
- runtime-required production data;
- verification/evidence artifact;
- generated/runtime state;
- human documentation;
- research/reference;
- wishlist/future design;
- archive/dataset;
- secret/private/external;
- unknown.

## Production-consumer evidence

A non-code artifact is production-authoritative only when at least one protected deterministic source proves its runtime use, such as:

- an explicit protected runtime registry;
- a production loader/import/reference;
- a production schema registry;
- a production prompt registry;
- a production config loader;
- a protected manifest declaring the artifact runtime-authoritative.

Do not classify by extension alone.

Do not classify merely because Git tracks it.

Do not classify merely because its name sounds important.

## Unknown files

If a file cannot be deterministically classified:

- keep it outside production implementation authority;
- retain it as evidence/unknown;
- do not silently allow it to alter `implementation_revision`.

If excluding an unknown artifact could compromise a protected deterministic responsibility, require explicit classification before synchronization can become `SYNCED`.

## Required current-repository checks

Determine the real production role of at least:

- `dataset_stats.json`
- `evidence_manifest.json`
- `final_verdict.json`
- `mcp-test-skill.skill`
- `test-skill.skill`

Do not assume the answer in advance.

If runtime code genuinely loads one of these:

- keep it in implementation truth;
- record the deterministic runtime consumer.

If not:

- exclude it from production implementation truth.

## Required regression tests

Prove:

- runtime-loaded prompt edit changes implementation revision;
- runtime-loaded policy/config edit changes implementation revision;
- runtime-loaded schema edit changes implementation revision;
- runtime-required production data edit changes implementation revision;
- arbitrary JSON file with no runtime consumer does not change implementation revision;
- arbitrary YAML/TOML file with no runtime consumer does not change implementation revision;
- verification report does not change implementation revision;
- generated evidence manifest does not change implementation revision unless it is truly runtime-consumed;
- future/wishlist/reference/archive artifact does not change implementation revision;
- new untracked production config referenced by the runtime is visible before commit.

## Snapshot-boundary invariant

The classifier/registry deciding runtime-authoritative artifacts is itself protected production implementation.

A change must not hide itself by changing classification rules to exclude the file that implements those rules.

Add an adversarial regression for this.

---

# Gap 3 — MCP/LLM7 effect contracts are still partly heuristic

The new MCP tool-effect layer is materially better:

- unknown tools are denied;
- wildcard fallback is removed;
- exact path scopes are checked;
- read-only claims are observed.

But the effect class is still partly inferred using:

- hard-coded read-only tool-name lists;
- substrings such as `git`, `commit`, `database`, `install`, `service`, `remote`;
- recognized argument-key names.

That is not strong enough for final semantic mutation authority.

A tool's actual side effects must come from an explicit canonical tool contract.

## Required fix

Extend the canonical MCP/tool registry so every tool explicitly declares:

- effect class;
- read-only status;
- resource extractor/argument schema;
- whether effects are local or remote;
- whether effects touch files, Git, DB, environment, service config, durable project state, or multiple resources;
- rollback/recovery semantics where applicable.

Use a closed effect enum equivalent to:

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

`unknown` is always denied.

Do not infer final authority from tool names.

Name heuristics may be used only as diagnostics/migration support, never as mutation authorization.

## Resource extraction

The registry must define how validated tool arguments map to exact governed resources.

Examples:

- file tool → exact path(s);
- Git tool → repository/worktree + operation;
- DB tool → database/store + operation + target;
- dependency tool → environment + package/action;
- service-config tool → exact service/config target;
- remote durable tool → provider/resource identity.

If exact resource scope cannot be derived:

DENY

or amend/reseal the semantic target first.

## Read-only tools

Read-only must be an explicit registered contract.

Do not use a manually maintained global allowlist as the canonical source of truth.

For high-risk/protected tools, optionally preserve a deterministic observation check as defense-in-depth.

A read-only tool observed performing an effect must:

- fail;
- record the discrepancy;
- revoke or quarantine the incorrect tool contract;
- never silently continue.

## Required authorization order

Every effectful tool call must require:

`semantic authorization`
AND
`canonical tool-effect contract`
AND
`normal MCP/tool governance`
AND
`other required approval`

Human/provider approval never overrides semantic denial.

## Required regression tests

Test explicit registered contracts for:

- read-only search/query;
- exact file write;
- multi-file write;
- Git mutation;
- database mutation;
- dependency installation;
- service/runtime-config mutation;
- remote durable write;
- durable Agent_X project-state mutation;
- unknown tool;
- registered tool missing effect metadata;
- registered tool whose resource extractor fails;
- read-only tool observed mutating state.

Unknown/malformed effect contract must fail closed.

---

# Final canonical remint

After all three gaps are fixed:

1. compute corrected production snapshot;
2. compute corrected verification/evidence snapshot;
3. regenerate the whole-project semantic model;
4. run governed LLM enrichment;
5. validate semantic quality/provenance;
6. verify production behavior;
7. issue real semantic target evidence;
8. issue real verification evidence;
9. reconcile semantic model against actual implementation;
10. build the accepted baseline using the canonical builder;
11. persist atomically;
12. reload and validate evidence references/digests;
13. independently run synchronization assessment;
14. require `SYNCED`;
15. perform a no-change second assessment;
16. require `SYNCED` again.

Do not manually edit canonical JSON to reach this result.

---

# Non-regression checks

Do not redo these systems. Just prove they still hold after the fixes:

- UI run identity exists before semantic authorization;
- active transactions are run-local;
- UI uses canonical `SemanticFirstCheckpoint`;
- architectural reasoning requires governed LLM;
- structural fallback alone cannot authorize architecture;
- semantic-first remains mandatory/non-degradable;
- exact file effects remain scoped to the write set;
- stale backend remains fail-closed;
- background OpenCode completion runs canonical semantic finalization;
- LLM7 no longer wildcard-authorizes opaque effects;
- legacy `semantic_project/changes/` migration/retention remains active;
- committed canonical baseline remains portable across checkout paths;
- placeholder target/verification evidence remains rejected;
- test files remain verification evidence rather than production capabilities/invariants;
- tests do not mutate canonical production semantic state.

---

# Final production tests

## A. Current snapshot consistency

Fresh current `main`:

`source_snapshot(repo_root)`
must exactly equal:

- accepted model `source_hashes`;
- accepted baseline `source_hashes`.

Then:

`implementation_revision(source_snapshot(repo_root))`
must equal:

`baseline.implementation_revision`.

## B. Non-code role tests

Use real Agent_X files plus temporary fixtures.

Prove extension alone cannot make a file production-authoritative.

## C. Tool-effect tests

Run actual LLM7/MCP authorization path with explicit contracts.

No name-heuristic-only authorization is permitted.

## D. Fresh checkout

Check out the exact accepted `main` to another absolute path.

Without rewriting canonical semantic files:

- load model/baseline;
- establish local runtime binding;
- independently assess synchronization;
- require `SYNCED`.

## E. Normal UI write

ordinary user request
→ run reservation
→ semantic target
→ provider mutation
→ exact effect authorization
→ verification
→ semantic reconciliation
→ canonical promotion
→ completed
→ independent `SYNCED`.

## F. No-change second pass

Run synchronization assessment again.

Require:

- `SYNCED`;
- no new conflict;
- no canonical rewrite;
- no transaction junk.

---

# Completion criteria

Do not stop until all are true:

1. Accepted model and baseline source hashes come from the current `source_snapshot()` implementation.
2. No stale source hash remains from pre-classification snapshot rules.
3. `mcp-test-skill.skill` is included only if deterministic production consumption is proven.
4. `test-skill.skill` is included only if deterministic production consumption is proven.
5. Non-code artifact authority is based on deterministic runtime-consumer evidence, not extension.
6. `dataset_stats.json` has an explicitly verified runtime/non-runtime role.
7. `evidence_manifest.json` has an explicitly verified runtime/non-runtime role.
8. `final_verdict.json` has an explicitly verified runtime/non-runtime role.
9. Arbitrary JSON/YAML/TOML files cannot alter implementation revision without production-consumer evidence.
10. Runtime-loaded prompts/configs/schemas/data still alter implementation revision.
11. Snapshot-boundary implementation cannot exclude itself from authority.
12. MCP effect class comes from explicit canonical registry metadata.
13. Read-only status comes from explicit canonical registry metadata.
14. Resource extraction comes from explicit canonical tool contract.
15. Tool-name substrings are not final mutation authority.
16. Unknown effect type fails closed.
17. Missing/invalid resource extraction fails closed.
18. Read-only contract violation is detected and blocked.
19. Semantic denial overrides all other approvals.
20. Canonical semantic model is regenerated after snapshot/effect corrections.
21. Canonical baseline is reminted after those corrections.
22. Accepted baseline contains real target/verification evidence.
23. Independent synchronization assessment returns `SYNCED`.
24. Fresh checkout at another path independently returns `SYNCED`.
25. A second no-change assessment remains `SYNCED`.
26. Normal UI mutation completes the full semantic-first lifecycle automatically.
27. No write-capable runtime or tool can mutate outside the sealed semantic target.
28. No legacy semantic transaction junk is recreated.

---

# Stop condition

Stop only when actual current `main` satisfies all completion criteria.

Do not stop because:

- the commit message says fixed;
- stored JSON says `SYNCED`;
- AGENTS.md says complete;
- a test name implies coverage;
- source code contains the expected function names.

Stop only when:

1. current production behavior passes the required tests;
2. current canonical model and baseline are generated from the current rules;
3. independent synchronization assessment returns `SYNCED`;
4. a second no-change assessment remains `SYNCED`.
