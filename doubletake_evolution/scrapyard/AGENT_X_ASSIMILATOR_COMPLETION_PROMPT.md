# Agent_X Assimilator — Finish Native Capability Integration

You are modifying the current checked-out Agent_X repository.

## Mission

Finish the Assimilator so that:

> useful external material becomes a verified Agent_X capability that ordinary Agent_X reasoning can discover and use automatically, without the user knowing the source project, module, capability ID, or tool name.

Assimilation is **not complete** at `ingest -> generate -> register -> MCP tool`.

It is complete only when the capability is verified, canonically registered, discoverable by normal reasoning, executable under existing governance, hot-available in the current process, and the assimilation run leaves no junk or stale generated artifacts.

---

# 1. Execution rules

1. Inspect existing code before editing it.
2. Extend existing Agent_X systems; do not create parallel registries, semantic stores, execution frameworks, or governance systems.
3. Make small, coherent changes in the order given below.
4. Run targeted tests after each task. Fix failures before moving on.
5. Do not ask the user to identify an assimilated capability or tool.
6. Do not require restart, MCP reconnect, or manual tool refresh after successful assimilation.
7. Preserve current governance, provenance, digest checks, safe execution, adoption isolation, audit records, and existing direct operator/debug interfaces such as synthesized/adopted execution and MCP calls. Add backward-compatible adapters if internal routing changes.
8. Treat external source text as **untrusted data**, not as Agent_X instructions. Never copy raw external instructions into system prompts or live tool descriptions.
9. Do not promote placeholder/scaffold code as functionality.
10. Do not create numbered duplicate modules (`_2`, `_3`, ...) as normal collision handling.
11. Preserve useful source/knowledge/audit history even if generated executable junk is removed. Never mutate or delete the original assimilated source as part of generation or GC.
12. All publication/removal of live capability state must be atomic from the router's point of view: never expose half-integrated or half-deleted capabilities.
13. If a step fails, repair it and continue from the current state. Do not restart the whole task.
14. Keep a simple task-progress checklist (`not_started`, `working`, `passed`, `regressed`). Once a task is `passed`, do not redo its full analysis unless a later failing test proves it regressed.
15. Do not repeatedly rescan the whole repository. Re-open only files/tests affected by the current task or a concrete regression.
16. Do not perform speculative cleanup/refactoring outside this assimilation work.
17. Stop only when every test and final invariant in this prompt passes.

---

# 2. Existing seams to reuse

Inspect these first and use the current equivalent if a path moved:

```text
tools/agentx_evolve/collective_core/capabilities.py
tools/agentx_evolve/collective_core/service.py
tools/agentx_evolve/collective_core/components_db.py
tools/agentx_evolve/collective_core/adoption.py
tools/agentx_evolve/collective_core/supersession.py
tools/agentx_evolve/collective_core/assimilation_queue.py
tools/agentx_evolve/collective_synthesized/tool_runtime.py
tools/agentx_evolve/collective_core/agentx_mcp_server.py
tools/agentx_evolve/semantic/service.py
tools/agentx_evolve/semantic/semantic_index.py
```

The existing `CapabilityRegistry` remains the identity/lifecycle authority unless current code proves another canonical store already owns that role. Do not break its append-only/digest compatibility just to store richer contracts: if necessary, keep a versioned contract companion keyed by the same canonical `cap_id` in the existing Components DB or another existing durable store. One identity matters more than forcing all metadata into one JSON record.

The existing `SemanticService`/semantic index must be reused for capability semantic search. Do not introduce another vector database.

The existing adoption and synthesized runtimes remain execution backends. Do not reimplement them.

---

# 3. Required final flow

```text
external material
  -> source classification
  -> useful knowledge/provenance retention
  -> behavior-level capability extraction
  -> deduplication
  -> integration-strategy choice
  -> adopt / wrap / port / implement / knowledge-only / reject
  -> behavioral/fidelity gate
  -> canonical capability contract
  -> atomic publication to canonical registry + semantic capability index + runtime binding
  -> same-process availability
  -> automatic routing from ordinary request
  -> argument validation/binding
  -> governed execution
  -> postcondition/result verification
  -> fallback/replan on failure
  -> reliability telemetry
  -> cleanup/GC
```

A capability may be called `FULLY_ASSIMILATED` only after this path works end to end.

---

# 4. Task 0 — Baseline and map the real runtime path

Before behavior changes:

1. Run current tests related to assimilation, capabilities, synthesized tools, adoption, semantic search, MCP, and normal tool execution.
2. Record pre-existing failures separately.
3. Inventory:
   - canonical capability records;
   - Components DB records;
   - synthesized manifest and modules;
   - adoption bindings;
   - semantic index records;
   - MCP synthesized-tool exposure.
4. Find the actual current path from an ordinary user request to model/tool execution.
5. Identify current generated junk/duplicates but do not delete them yet.

**Do not continue until you know where the router must be connected so it affects ordinary Agent_X requests rather than only a debug/API path.**

---

# 5. Task 1 — Classify sources before generating capabilities

A file is not automatically a capability.

Add/persist a normalized source class and classification rationale. Use these classes or a smaller equivalent enum preserving the same distinctions:

```text
EXECUTABLE_SOURCE
ALGORITHM_OR_PROCEDURE
API_OR_INTERFACE_SPEC
CONFIGURATION
SCHEMA_OR_DATA_MODEL
KNOWLEDGE_DOCUMENT
DESIGN_DOCUMENT
TEST_OR_VALIDATION_ASSET
EXAMPLE_OR_SAMPLE
CHANGELOG_OR_HISTORY
AGENT_INSTRUCTIONS
BUILD_OR_PACKAGING_METADATA
GENERATED_ARTIFACT
BINARY_OR_UNSUPPORTED
UNKNOWN
```

## Hard default exclusions from executable generation

These may be retained as knowledge/evidence but must not become whole-file tools by default:

```text
CHANGELOG* / CHANGES* / release history
LICENSE*
AGENTS* / instruction files
README or general prose docs
tests
examples/samples
configuration
package/build metadata
books/papers/design documents
generated caches/temp files
```

A document may produce an executable candidate only if a **separate behavior-extraction step** finds a concrete reusable procedure with defined inputs, outputs, value, and tests.

Source code must be analyzed for useful externally invokable behavior, not converted file-by-file or symbol-by-symbol into synthetic tools.

Keep existing secret/quarantine protections intact.

---

# 6. Task 2 — One canonical Capability Contract

Extend the existing capability model so every live capability, regardless of origin, resolves to one canonical capability ID and one compact machine-readable contract.

Required fields:

```yaml
id:
name:
version:
description:
intents:
inputs:
outputs:
preconditions:
postconditions:
side_effects:
permissions:
implementation_kind:
implementation_ref:
provenance:
fidelity_score:
quality_score:
reliability:
status:
fallback_ids:
supersedes:
superseded_by:
```

Input fields must preserve real parameter names, types, required/optional state, safe defaults, and known constraints.

Do not force all synthesized inputs into `value: string`. If a type is unknown, represent it as unknown rather than lying.

## Canonical ownership

Use this ownership model:

```text
Canonical Capability Registry
  -> Components DB: provenance/audit/lifecycle evidence
  -> implementation binding: native/adopted/synthesized/wrapped/ported
  -> semantic capability record
  -> synthesized manifest view when relevant
  -> adoption binding when relevant
  -> MCP view when exposed
```

One logical capability must not get separate identities merely because it appears in multiple views.

Use stable IDs and schema/version migration so existing registry data continues to load. For existing native/core tools, prefer lightweight contract adapters or lazy contract generation over rewriting every native implementation.

The lifecycle must at least distinguish these meanings, mapped onto existing states where possible: `KNOWLEDGE_ONLY`, `CANDIDATE/IMPLEMENTING`, `FIDELITY_REJECTED`, `ROUTABLE`, `QUARANTINED`, `SUPERSEDED`, `REJECTED`, and `FULLY_ASSIMILATED`.

---

# 7. Task 3 — Extract behavior, deduplicate, choose integration strategy

Capability extraction asks:

> What reusable behavior in this source could satisfy a future Agent_X/user need?

A source file may yield zero, one, or several candidates. Several files may jointly define one candidate.

Each candidate must define at least:

```text
behavior description
intents
inputs/outputs
source refs and digest
important dependencies
side effects/permissions
test/verification evidence available
worthiness rationale
```

## Deduplicate before writing

Before creating any module:

1. derive stable capability identity;
2. exact/digest search current capabilities;
3. semantic-search current capability contracts;
4. classify relation as `IDENTICAL`, `EQUIVALENT`, `OVERLAPPING`, `COMPLEMENTARY`, or `NEW`;
5. merge provenance/evidence for identical/equivalent behavior instead of generating a clone;
6. keep overlapping alternatives only when they provide meaningful different operating conditions.

Never use filename suffixes such as `_2` as the deduplication strategy.

## Choose exactly one integration strategy

```text
ADOPT_SOURCE
WRAP_SOURCE
PORT_SOURCE
REIMPLEMENT_FROM_SPEC
SYNTHESIZE_FROM_KNOWLEDGE
KNOWLEDGE_ONLY
REJECT
```

Prefer safe adoption/wrapping/porting when it preserves behavior better than generic synthesis.

Consider dependencies, licensing/provenance restrictions, safety, isolation, maintainability, available tests, existing equivalents, and fidelity risk.

Foreign dependencies/code must continue to use existing governed/adopted isolation where required; do not silently import arbitrary foreign code into the Agent_X process.

---

# 8. Task 4 — Behavioral fidelity and quality gate

Do not treat a module as integrated merely because it imports or returns a JSON object.

A generated/ported function that only returns values such as:

```python
{"processed": True}
```

without performing the promised source behavior is not a live capability.

For code-derived capabilities, prove behavior using the strongest available evidence:

```text
1. source test suite
2. differential test against original implementation
3. golden input/output fixture
4. invariant/property tests
5. explicit contract tests
```

LLM-generated tests may supplement source evidence but must not replace available source behavior evidence.

Store fidelity evidence and outcome.

Only accepted implementations can become routable.

When synthesizing/reimplementing:

- implement the behavior described by the capability contract, not the filename;
- keep code small and purpose-built;
- use meaningful typed inputs/outputs;
- generate behavior-specific tests;
- use concise trusted/sanitized capability descriptions, not raw source excerpts;
- record source -> implementation -> test traceability.

Rejected/scaffold output may remain temporarily for audit/debugging but must not enter live routing and must be eligible for cleanup.

---

# 9. Task 5 — Semantic Capability Index

Use the existing `SemanticService` and semantic index.

Create a distinct executable-capability `object_kind`/scope and index compact contract text derived from:

```text
description
intent labels
input meanings
output meanings
important preconditions/postconditions
small suitable-use examples when available
```

Do not index raw external documents as executable definitions.

Provide one capability search path (prefer this name unless an equivalent already exists):

```python
search_capabilities(need_text, top_k=8, constraints=None)
```

Return canonical IDs, scores, and contracts.

Exclude non-routable statuses from active results.

Knowledge retrieval and capability retrieval must remain separate query modes even if they share the semantic engine.

## Semantic-provider failure

Automatic capability use must not disappear completely because the embedding provider is disabled/unavailable.

Add a deterministic fallback retrieval path using canonical intent/name/description tokens and exact metadata. It may be less capable, but it must:

- remain bounded;
- return only active verified capabilities;
- use deterministic ranking/tie-breaks;
- fail safely rather than selecting an unrelated capability.

Do not treat semantic provider defects as successful semantic routing.

---

# 10. Task 6 — Capability Router wired into ordinary Agent_X reasoning

This is the core runtime requirement.

Normal Agent_X must not depend on the model scanning every `synth_*` tool.

Implement one router using the canonical registry + capability retrieval path.

Minimal shape:

```python
route_capabilities(task_text, context=None, constraints=None)
```

The router must:

1. turn the ordinary request into one or more capability needs;
2. retrieve a small candidate set;
3. reject candidates that are unavailable, unverified, permission-incompatible, input-incompatible, or fail preconditions;
4. rank remaining candidates;
5. choose one capability when one is sufficient;
6. create a bounded multi-step plan when composition is required;
7. return route confidence and auditable reasons;
8. return `NO_MATCH` when no candidate clears a configurable minimum suitability/confidence threshold. Never force a tool call merely because capabilities exist.

## Ranking — keep it simple

Use a small deterministic scoring function based on:

```text
semantic/lexical fit
input/output compatibility
precondition satisfaction
fidelity
verified reliability
permissions/side effects
latency/cost constraints when known
```

Use deterministic tie-breaks. Do not invent a large weight system.

## Competition

Allow different valid implementations to win under different constraints, e.g. offline, low latency, high accuracy, or no side effects.

Reuse existing supersession logic for lifecycle, but runtime ranking must choose among remaining valid alternatives.

## Bounded composition

Support a small execution plan. Default maximum: **4 capability steps**. Make the bound configurable only if Agent_X already has a standard configuration mechanism.

Each step must contain:

```text
capability_id
inputs
mapping from previous outputs
expected output/postcondition
```

Reject cycles and plans with unresolved required inputs.

Most importantly, wire this router into the **actual normal user-request execution path identified in Task 0**. A standalone API/helper that no ordinary request uses does not satisfy this task. `NO_MATCH` must preserve the current normal model/reasoning path unchanged.

---

# 11. Task 7 — Argument binding, governed execution, verification, fallback, telemetry

## Argument binding

Build capability arguments from:

```text
user request
conversation/workspace context
previous plan-step outputs
canonical input contract
```

Never fabricate missing required values.

Return a clear state:

```text
READY
MISSING_REQUIRED_INPUT
AMBIGUOUS_INPUT
INVALID_INPUT
PERMISSION_REQUIRED
```

Agent_X may ask the user for missing task information, but never for the capability/tool name.

## Canonical governed executor

Create/extend one internal execution entry point:

```text
canonical capability ID + validated args -> correct existing runtime backend
```

Dispatch to existing native/adoption/synthesized/wrapped/ported backends. Do not duplicate backend logic.

## Verification receipt

For each routed execution record at least:

```text
route_id
capability_id
capability version / implementation digest
input digest
execution status
verification status
result digest
failure class
fallback used
```

Run declared postcondition/result validators when available.

## Failure handling

On failure:

1. classify it;
2. record telemetry;
3. do not immediately repeat the identical route;
4. try the next valid fallback or reroute once per new route state;
5. stop safely when no valid route remains.

Integrate with existing Agent_X failure memory/learning/immune/resistance systems where applicable.

## Reliability telemetry

Track only useful signals:

```text
calls
verified successes
failures
postcondition failures
argument-binding failures
recent success rate
mean latency
last success/failure
failure classes
```

Use reliability as a routing signal, but never let popularity override semantic fit or fidelity.

---

# 12. Task 8 — Atomic hot publication and bounded LLM exposure

## Atomic publication

A newly validated capability must become live as one logical publication transaction/revision.

Do not set `FULLY_ASSIMILATED` until all required active views are ready:

```text
canonical registry
implementation binding
semantic capability record (or deterministic fallback metadata)
routing visibility
relevant manifest/adoption binding
```

If publication fails partway:

- roll back/unpublish the new live state;
- keep provenance/evidence;
- leave the capability non-routable with an explicit failure state;
- do not leave stale manifest/index/cache records.

## Same-process hot availability

Required invariant:

> Once publication succeeds, the next normal Agent_X reasoning cycle can discover and execute the capability without restart, MCP reconnect, or user action.

Use a simple capability-revision event/counter to invalidate route caches and refresh runtime views.

## Bound LLM-visible tools

The current MCP path dynamically appends synthesized tools to `tools/list`. Change the **default normal mode** so OpenCode/the LLM is not given every per-capability `synth_*` definition.

Preserve backward-compatible direct execution through generic operator/debug interfaces such as `synth_call` and `synth_list`. Individual `synth_<name>` definitions may remain only behind an explicit operator/debug mode or a task-scoped relevant-capability view.

Normal reasoning must use either:

1. the internal router + one generic governed capability executor; or
2. only a small top-N capability schema set selected for the current task.

If `tool_runtime.mcp_tool_defs()` or `agentx_mcp_server.handle_tools_list()` currently emits every synthesized tool, modify that seam rather than leaving the unbounded list in place. Any capability description exposed to MCP must come from the concise sanitized canonical contract, not raw assimilated file text.

Add a hard bound so capability inventory growth cannot grow normal LLM tool context without limit. Default maximum dynamic capability definitions visible to one normal planning turn: **8**. If using one generic executor, this count may be zero.

---

# 13. Task 9 — Mandatory Assimilation Cleanup / GC

Create/extend one governed cleanup operation, e.g. `assimilation_cleanup()` or `capability_gc()`.

Run it:

- after every assimilation run;
- after failed/rolled-back publication when artifacts were created;
- as a standalone maintenance operation.

## Detect at minimum

```text
orphan synthesized modules
manifest entry with missing module
module with no canonical live capability binding
canonical routable capability with broken implementation binding
identical/equivalent duplicate generated modules
numbered duplicate clones
scaffold-only artifacts
fidelity-rejected generated artifacts
never-promoted temporary/generated files
stale generated tests
stale semantic capability records
stale routing-cache entries
stale generated MCP exposure
retired/superseded implementation with no live reference/fallback
knowledge/document material incorrectly exposed as executable
generic passthrough processors with no proven useful behavior
```

## Safe deletion rules

Never delete an artifact just because it looks unused.

Before deleting generated executable code:

1. prove no live canonical capability references it;
2. prove no active fallback references it;
3. prove it is Agent_X-generated/managed, not manually maintained source code;
4. preserve provenance, receipts, and lifecycle history;
5. preserve useful source/knowledge corpus content;
6. quarantine instead of delete if reachability/ownership is uncertain;
7. use governed atomic mutation/deletion;
8. emit cleanup receipt.

Cleanup must never destroy original assimilated source solely to remove a bad generated tool.

## Compact active views

After cleanup:

```text
manifest -> only valid intentional live synthesized bindings
semantic capability index -> only active routable capability records
route caches -> only valid IDs/revision
canonical active queries -> no retired/junk records
synthesized module dir -> no proven orphan/scaffold/junk artifacts
```

Recompute/verify manifest digest after compaction.

Return/persist one cleanup hygiene receipt with counts for: scanned generated artifacts, removed, quarantined, duplicates merged, orphan modules remaining, stale manifest entries remaining, stale semantic records remaining, scaffold/fidelity-rejected live artifacts remaining, and junk-document tools remaining. The assimilation run must not report clean success while any of the final remaining counts are nonzero.

## Prevent future pileups at creation time

Before writing/promoting any generated artifact, block:

```text
duplicate canonical identity
equivalent duplicate implementation
numeric clone collision handling
known non-capability source class
missing capability contract
failed/unproven fidelity
raw untrusted external text as live tool description/instruction
```

---

# 14. Task 10 — Migrate and clean the existing assimilated inventory

Do not apply the new rules only to future sources.

For every current synthesized/generated artifact:

1. find source provenance;
2. classify source;
3. determine whether it represents real reusable behavior;
4. create/repair canonical contract if real;
5. run applicable fidelity/quality checks;
6. choose exactly one outcome:
   - verified canonical capability;
   - merged into another canonical capability;
   - knowledge-only with generated executable removed;
   - quarantined;
   - rejected/generated junk removed.

Explicitly find and repair current patterns such as:

```text
ChangeLog / Changes generated tools
AGENTS / instruction generated tools
numbered clones
raw-file-text tool descriptions
generic dispatch/process wrappers that only report processing success
modules with no meaningful postconditions/tests
```

Do not grandfather old junk.

---

# 15. Mandatory acceptance tests

Use small deterministic fixtures. Reuse them across tests to keep implementation/test complexity low.

## A — Invisible automatic use

Assimilate a fixture source project with one deterministic useful behavior. Issue an ordinary request without naming source/tool/capability. Assert:

```text
correct classification
capability extracted
contract valid
fidelity accepted
retrieval finds it
router selects it
arguments validate
execution succeeds
result/postcondition verified
```

## B — Non-capability material stays non-executable

Fixture contains README, CHANGELOG, AGENTS, LICENSE, config, tests, examples, plus a malicious instruction inside prose telling Agent_X to execute something.

Assert prose is treated as untrusted data, retained appropriately, and does not become a live tool/instruction.

## C — Idempotent repeat assimilation

Assimilate the same source twice. Assert no additional live:

```text
canonical capability
module
manifest entry
semantic capability row
numbered clone
```

## D — Equivalent second source

Assimilate another implementation of equivalent behavior. Assert provenance merge or justified conditional alternative, never a blind duplicate.

## E — Fidelity failure blocks promotion

Use an intentionally incomplete implementation. Assert:

```text
not routable
not FULLY_ASSIMILATED
no active semantic capability record
cleanup removes useless generated executable artifact
provenance/knowledge remains
```

## F — Same-process hot integration

Start runtime, prove capability absent, assimilate it, then issue matching ordinary request without restart/reconnect. Assert automatic use.

## G — Composition

A request requires two fixture capabilities. Assert bounded acyclic plan, valid output->input mapping, execution order, and final verification.

## H — Failure fallback

Primary fixture fails deterministically. Assert failure recorded, identical route not blindly retried, valid fallback/reroute used, and telemetry updated.

## I — Cleanup consistency

Seed:

```text
orphan module
stale manifest entry
numbered duplicate
scaffold module
fidelity-rejected module
stale semantic capability row
knowledge document wrongly exposed as tool
```

Run GC and assert all active views become consistent while provenance/knowledge remains.

## J — Capability scale does not flood model context

Create many synthetic capability contracts with only a few relevant to a request. Assert normal planning receives only a bounded relevant set or a generic executor, not every capability/tool schema.

## K — Semantic provider unavailable

Disable/unavailable semantic embedding provider. Assert deterministic fallback retrieval can still find a clearly matching active capability, remains bounded, and does not select an unrelated one.

## L — Atomic publication rollback

Force failure during capability publication after one live view is written. Assert rollback leaves no routable half-capability and no stale manifest/index/cache entry.

---

# 16. Final invariants

Every statement below must be true.

```text
1. File/document/symbol != capability by default.
2. Non-capability material does not become live executable tools.
3. External text is untrusted data, never silently promoted to Agent_X instructions.
4. Every live capability has one canonical ID and contract.
5. No capability is routable without a valid implementation binding.
6. Code-derived capability is not routable without accepted behavioral evidence.
7. Placeholder/scaffold processors are not assimilated functionality.
8. Knowledge retrieval and capability retrieval are distinct modes.
9. Normal requests can use assimilated abilities without knowing their names.
10. Routing is connected to the ordinary Agent_X request path.
11. Required arguments are never fabricated.
12. Execution uses existing governance and appropriate isolation.
13. Failures can fallback/reroute without retry loops.
14. Execution outcomes update reliability evidence.
15. New capabilities are same-process hot-available after atomic publication.
16. Failed publication cannot leave half-live state.
17. Semantic-provider unavailability has a bounded deterministic fallback.
18. Normal LLM-visible capability/tool context stays bounded as inventory grows.
19. Re-assimilating the same source is idempotent.
20. Equivalent capabilities do not create uncontrolled duplicates.
21. Numbered filename clones are not normal conflict handling.
22. Cleanup removes stale/generated junk but preserves useful knowledge/provenance.
23. Active registry/manifest/index/cache views are mutually consistent after cleanup.
24. Existing assimilated inventory obeys the same rules as new assimilation.
25. Original assimilated source/evidence is never deleted by generated-artifact GC.
26. Existing direct synthesized/adopted/MCP operator paths remain backward compatible.
27. A completed assimilation run has a hygiene receipt with zero live orphan/stale/scaffold/fidelity-rejected/junk-tool counts.
```

---

# 17. Simplicity constraints

This task is about assimilation integration only. Do not redesign unrelated UI, providers, memory, planning, or governance subsystems unless a small integration change is required by tests A-L.

Prefer exactly these concepts unless current code already provides an equivalent:

```text
one canonical Capability Contract
one canonical capability registry authority
one capability retrieval path using existing SemanticService + deterministic fallback
one Capability Router
one canonical governed capability executor that delegates to existing backends
one cleanup/GC path
one capability revision mechanism for hot refresh
```

Avoid:

```text
new vector database
second capability registry
second adoption/synthesized runtime
second governance framework
unbounded planner
large scoring framework
raw source text in runtime tool descriptions
all synthesized tools injected into every LLM request
new abstractions not needed by tests A-L
```

When two designs pass the requirements, choose the smaller one that reuses more existing Agent_X code.

---

# 18. Final verification sequence

Before completion, do this in order:

1. run targeted tests for every changed subsystem;
2. run acceptance tests A-L;
3. run the relevant full Agent_X suite;
4. run GC against seeded test state;
5. run GC/migration against the current assimilated inventory in governed safe mode;
6. verify manifest digest/integrity;
7. verify every active manifest binding resolves to one active canonical capability;
8. verify every active semantic capability record resolves to one active canonical capability;
9. verify every active routable canonical capability has a valid implementation binding;
10. verify zero live scaffold/fidelity-rejected generated modules;
11. verify zero known junk-document tools;
12. verify zero equivalent numbered clones;
13. repeat-assimilate the main fixture and verify live counts do not increase;
14. re-run same-process hot-integration test;
15. re-run bounded-context scale test;
16. re-run semantic-provider fallback test;
17. re-run publication rollback test.

If any check fails, fix it, rerun the affected tests, then rerun A-L before declaring completion.

---

# 19. Completion report

Output measured results, not guesses:

```yaml
status: COMPLETE | INCOMPLETE
changed_files:
new_tests:
targeted_tests_passed:
acceptance_A_to_L_passed:
full_relevant_suite_passed:
canonical_contract_live:
automatic_routing_live:
composition_live:
hot_integration_live:
semantic_fallback_live:
atomic_publication_live:
fidelity_gate_live:
cleanup_gc_live:
existing_inventory_migrated:
active_capabilities:
active_synthesized_bindings:
junk_tools_removed:
duplicates_merged:
orphan_generated_modules_remaining:
stale_manifest_entries_remaining:
stale_semantic_capability_records_remaining:
scaffold_live_modules_remaining:
fidelity_rejected_live_modules_remaining:
known_limitations:
```

`status: COMPLETE` is allowed only if:

```text
all acceptance tests A-L pass
relevant regression suite passes
orphan_generated_modules_remaining == 0
stale_manifest_entries_remaining == 0
stale_semantic_capability_records_remaining == 0
scaffold_live_modules_remaining == 0
fidelity_rejected_live_modules_remaining == 0
```

`known_limitations` may contain optional future improvements only. It must not hide an unmet requirement from this prompt.

---

# 20. Stop condition

Do not stop at generated, registered, importable, directly callable, or listed in MCP.

Stop only when tests prove this statement:

> Agent_X can turn useful external material into verified canonical capabilities, keep non-capability material as knowledge instead of junk tools, automatically discover/select/compose assimilated abilities from ordinary requests without user tool-name knowledge, bind arguments safely, execute under existing governance, verify results, fallback safely, hot-publish new abilities in the current process, continue routing when semantic embeddings are unavailable, learn reliability from execution, roll back failed publication cleanly, and finish each assimilation with a deduplicated consistent live inventory containing no orphaned, stale, scaffold, fidelity-rejected, or useless generated pileups.

If this statement is not proven, continue fixing the implementation.
