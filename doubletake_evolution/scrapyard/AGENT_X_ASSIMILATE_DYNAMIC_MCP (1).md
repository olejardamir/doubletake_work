SOURCE_REPOSITORY: https://github.com/olejardamir/dynamic_mcp

# Agent_X Assimilation Directive — Dynamic MCP

## Execution Directive

This file is an **implementation directive**, not an analysis request.

Inspect the complete source repository named above and the current Agent_X codebase. Then **assimilate all useful architectural knowledge and behavior from Dynamic MCP into Agent_X as native Agent_X/Borg capability infrastructure**.

Do not merely summarize the source repository. Do not stop after an audit, design document, issue list, or recommendations. Modify the Agent_X implementation, tests, configuration, documentation, and migrations as required; run verification; fix failures; and continue until the Definition of Done in this document is satisfied or a genuine hard blocker prevents completion.

The objective is **not to import Dynamic MCP as a parallel subsystem**. The objective is to extract its useful primitives and merge them into the correct existing Agent_X architectural owners.

> All useful source semantics must become native Agent_X behavior. Source-specific package names and abstractions must not become permanent architectural nouns unless there is a compelling protocol-boundary reason.

---

# 1. Mission

Assimilate Dynamic MCP so Agent_X/Borg gains a **unified, scalable, context-efficient capability discovery, retrieval, ranking, projection, and execution path**.

The resulting architecture must support capabilities originating from, where applicable:

- MCP servers
- native Agent_X tools
- skills
- internal APIs and services
- assimilated capabilities
- specialist workers/agents when they are exposed as callable capabilities
- future capability providers without requiring another parallel routing subsystem

The target conceptual flow is:

```text
Capability Sources
    │
    ├── MCP servers
    ├── native tools
    ├── skills
    ├── internal services
    ├── assimilated capabilities
    └── callable specialist workers
    │
    ▼
Unified Capability Catalog
    │
    ▼
Structural Eligibility
    │
    ▼
Governance / Authority Hard Filter
    │
    ▼
Hybrid Retrieval
  lexical + semantic
    │
    ▼
Contextual Reranking
    │
    ▼
Bounded Top-K / Token-Budget Projection
    │
    ▼
Model / Work-Unit Selection
    │
    ▼
Execution-Time Revalidation
    │
    ▼
Governed Execution
    │
    ▼
Telemetry / Outcome Feedback
```

The total capability universe must be allowed to grow very large while the active model-visible capability context remains small and bounded.

---

# 2. Absolute Architectural Constraints

These constraints are mandatory.

## 2.1 Existing Agent_X owners take precedence

Before creating any new production module, class, service, registry, index, database, router, or orchestrator:

1. inspect Agent_X for the existing architectural owner of the concern;
2. extend or refactor that owner;
3. migrate callers into that owner where necessary;
4. remove or retire redundant paths.

Do not create a second implementation merely because the source repository uses a separate abstraction.

## 2.2 MCP is a capability provider, not the core architecture

MCP must remain a protocol/provider boundary.

The core capability system must be protocol-agnostic.

Required conceptual boundary:

```text
External MCP Server
        │
        ▼
MCP Adapter / Client
        │
        ▼
Unified Agent_X Capability Catalog / Resolver
        │
        ▼
Governed Agent_X Execution
```

Do not build an independent MCP-only orchestration stack if Agent_X already has generalized capability, tool, governance, work-unit, or execution machinery.

## 2.3 Governance is a hard constraint

Authority, policy, scope, and safety must **never** be represented only as ranking penalties.

A capability that the current worker/session/work unit is not authorized to use must be excluded from the model-visible candidate set.

The minimum ordering is:

```text
All Capabilities
      │
      ▼
Structural Eligibility
      │
      ▼
Governance / Authority Eligibility
      │
      ▼
Retrieval + Ranking
      │
      ▼
Top-K Projection
      │
      ▼
Model Selection
      │
      ▼
Execution-Time Authority Recheck
      │
      ▼
Execution
```

Recheck authority, policy, provider state, schema revision, and other execution-critical conditions immediately before invocation.

## 2.4 Bounded active context

Never expose the entire capability catalog and all schemas to an LLM merely because they exist.

The final model-visible capability set must be bounded by:

- configurable final K;
- configurable prompt/token budget;
- configurable schema byte/size budget where appropriate;
- current work-unit requirements;
- current authority and policy;
- capability health and availability.

## 2.5 No blind source-code transplantation

Dynamic MCP is a source of architecture and implementation patterns, not a namespace to reproduce.

Do not:

- vendor the repository wholesale;
- paste pseudocode into production code;
- preserve source-specific class names merely for fidelity;
- create parallel databases or vector stores without need;
- recreate behavior already present in Agent_X;
- preserve inferior source behavior when Agent_X already has a stronger implementation.

## 2.6 Minimize architectural entropy

Prefer:

- one catalog rather than multiple registries;
- one resolver path rather than separate native/MCP selection paths;
- one governance path;
- one execution gate;
- one source of capability identity;
- one lifecycle model for discovery/versioning where practicable.

Temporary compatibility adapters are allowed only when necessary for migration and must not become a permanent split-brain architecture.

---

# 3. Phase 0 — Exhaustively Extract the Source Concepts

Read the complete Dynamic MCP repository, including all documentation, pseudocode, examples, schemas, configuration concepts, and implementation notes.

At minimum, explicitly inspect:

- the repository README;
- the dynamic tool orchestrator pseudocode/specification;
- any metadata definitions;
- discovery/refresh behavior;
- lexical retrieval;
- embedding retrieval;
- candidate fusion;
- reranking;
- top-K selection;
- caching;
- fallbacks;
- validation/revalidation;
- error handling;
- observability;
- performance/scaling considerations.

Create an internal concept inventory.

For every non-trivial source concept, assign exactly one disposition:

- `ASSIMILATE` — useful and missing; implement natively;
- `MERGE` — useful but overlaps existing Agent_X behavior; merge into the existing owner;
- `ALREADY_PRESENT` — Agent_X already implements an equivalent or stronger mechanism; preserve the Agent_X implementation and verify it;
- `REJECT` — source concept is inferior, redundant, unsafe, incompatible, or creates needless architectural duplication.

For each `REJECT`, record a concrete reason.

For each `ALREADY_PRESENT`, identify the actual Agent_X production owner and verify that it genuinely satisfies the source intent rather than matching only by name.

"Assimilate everything" means **process every meaningful concept and assimilate all useful knowledge**, not blindly reproduce every source abstraction.

---

# 4. Phase 1 — Inspect Agent_X Before Coding

Before implementation, locate the current Agent_X owners for all of the following concerns:

- capability/tool registry or catalog;
- tool descriptors and schemas;
- MCP clients/adapters/server discovery;
- skills and skill descriptors;
- internal service/API capability descriptions;
- callable specialist-agent or worker interfaces;
- work plans and work units;
- task intent/context representations;
- worker specialization/routing;
- governance;
- authority;
- policy enforcement;
- risk classification;
- approval requirements;
- execution orchestration;
- tool/capability selection;
- caching;
- embeddings/vector indexing;
- lexical/full-text search;
- persistent metadata storage;
- health checks;
- telemetry/metrics;
- tests and benchmarks.

Build and use a mapping of:

```text
Dynamic MCP concept
    ->
existing Agent_X architectural owner/path
    ->
ASSIMILATE / MERGE / ALREADY_PRESENT / REJECT
    ->
implementation action
```

Do not create a new generalized subsystem until this reconnaissance demonstrates that no suitable owner exists.

If no owner exists, create the smallest cohesive generalized Agent_X capability component required. Use capability-centered naming rather than MCP-centered naming unless the code is genuinely an MCP adapter.

---

# 5. Establish a Canonical Unified Capability Descriptor

Agent_X must have one canonical representation, or one clearly authoritative normalized representation, for dynamically selectable capabilities.

Reuse and extend an existing descriptor if one exists.

The representation should support, where applicable:

- stable deterministic capability ID;
- provider/source type;
- provider instance/server identity;
- canonical capability name;
- aliases;
- human-readable description;
- input schema;
- output schema where available;
- schema hash/fingerprint;
- capability version/revision;
- provider revision;
- tags;
- domains;
- use cases/intents;
- required permissions/authority;
- governance/policy class;
- risk class;
- approval requirements;
- compatible task/work-unit types;
- compatible worker/specialization types;
- availability;
- health state;
- freshness/last-seen state;
- local versus remote execution;
- estimated cost or cost hint;
- estimated latency;
- bounded historical reliability/success signals;
- bounded failure-rate signals;
- text used for lexical/semantic indexing;
- embedding/index version;
- created/updated/last-seen timestamps;
- deprecated state;
- disabled state.

Do not require every provider to populate every optional field. Define safe defaults and explicit absence semantics.

MCP tools must be normalized into the same canonical capability representation used by the generalized resolver.

MCP-specific protocol objects must not leak unnecessarily into the core capability-selection architecture.

---

# 6. Stable Identity, Deduplication, and Revisions

Implement or strengthen deterministic identity.

A capability's identity must not depend on transient prompt ordering or ephemeral in-memory position.

Account for:

- provider identity;
- capability name;
- namespace where needed;
- stable source identifiers;
- schema revisions;
- source revisions.

Support deterministic handling of:

- a newly added capability;
- a removed capability;
- a renamed capability;
- a changed schema;
- a changed description/metadata record;
- a restarted provider;
- multiple providers exposing similarly named capabilities;
- duplicate discovery records.

Do not silently treat materially changed schemas as unchanged capabilities.

Maintain enough revision information to invalidate caches and indexes correctly.

---

# 7. Generalize Capability Providers and Discovery

Represent capability sources through a generalized provider/adapter boundary where doing so fits the current Agent_X architecture.

The provider layer should allow the catalog to receive normalized capabilities from:

- MCP;
- native Agent_X tools;
- skills;
- internal services;
- other future sources.

Do not destabilize mature existing code merely to force an artificial interface. Use adapters when that preserves compatibility.

For MCP specifically, support the useful Dynamic MCP behavior:

- discover/list tools from available MCP sources;
- normalize discovered tool metadata;
- detect additions;
- detect removals;
- detect metadata/schema changes;
- refresh on appropriate lifecycle events;
- track provider health;
- handle unavailable providers;
- update catalog revision;
- invalidate affected indexes/caches.

A provider becoming unavailable must not leave its capabilities appearing normally executable indefinitely.

---

# 8. Structural Eligibility Before Retrieval

Before relevance ranking, remove capabilities that are structurally unsuitable.

Structural eligibility should account for relevant existing Agent_X semantics such as:

- enabled/disabled state;
- deprecated state;
- provider availability;
- health state;
- required runtime availability;
- task/work-unit compatibility;
- worker compatibility;
- known input/output compatibility;
- environment constraints;
- source/provider scope.

Do not waste model-visible shortlist slots on capabilities already known to be unusable.

---

# 9. Governance and Authority Hard Filtering

Apply current Agent_X/Borg governance **before model exposure**.

Use the existing governance and authority implementation rather than building a second policy system.

Eligibility must account for all relevant existing concepts, including where applicable:

- worker authority;
- session authority;
- project/repository scope;
- tenant/user scope;
- granted permissions;
- policy;
- risk class;
- approval requirements;
- execution mode;
- protected resources;
- existing governance invariants.

A forbidden capability must not become visible to the model merely because it has a high semantic score.

If approval is a valid existing Agent_X state, represent the capability consistently with current governance rules; do not bypass approval or manufacture authority.

Governance is a gate, not a relevance feature.

---

# 10. Hybrid Capability Retrieval

Assimilate the Dynamic MCP principle of using multiple retrieval signals rather than forcing the LLM to inspect the entire catalog.

Implement or strengthen a hybrid retrieval path using existing Agent_X infrastructure where possible.

At minimum support:

1. lexical retrieval;
2. semantic retrieval when semantic infrastructure is available;
3. fusion/deduplication;
4. contextual reranking;
5. bounded final projection.

## 10.1 Lexical retrieval

Use the repository's existing search/index technology where possible.

BM25 is acceptable, but do not introduce a redundant search stack merely to match the source specification if Agent_X already has an equivalent or stronger lexical retriever.

Index useful fields such as:

- canonical name;
- aliases;
- description;
- tags;
- domains;
- use cases;
- concise schema summary;
- provider/source metadata where relevant.

## 10.2 Semantic retrieval

Use Agent_X's existing embeddings/vector infrastructure if it exists and is production-suitable.

Do not create a separate MCP vector database if a generalized semantic index already exists or can be extended.

Version semantic representations by material inputs, including as appropriate:

- normalized indexed text;
- embedding model/version;
- embedding configuration;
- schema summary revision.

Do not regenerate embeddings unnecessarily when the meaningful indexed representation has not changed.

If semantic infrastructure is unavailable or degraded, the resolver must degrade gracefully rather than disabling all capability resolution.

## 10.3 Independent candidate pools

Lexical and semantic retrieval should be able to contribute independent candidates.

Do not require a capability to score highly in both channels before it can be considered.

## 10.4 Deterministic fusion

Combine candidate sets with a clear and testable method, for example:

- reciprocal rank fusion;
- normalized weighted score combination;
- another deterministic method already established in Agent_X.

Deduplicate by stable capability identity.

Do not make fusion depend on incidental result ordering.

---

# 11. Contextual Reranking

Rerank only the already-eligible candidate set.

Relevant positive signals may include:

- semantic relevance;
- lexical relevance;
- exact-name/alias match;
- work-unit objective fit;
- task-type fit;
- worker specialization fit;
- source/provider suitability;
- locality/data proximity;
- prior execution success;
- bounded reliability;
- healthy provider state.

Relevant negative signals may include:

- estimated latency;
- estimated execution/compute cost;
- failure probability;
- degraded health;
- stale metadata;
- known incompatibility;
- redundancy with a clearly better candidate.

Risk may help distinguish among **already authorized** choices, but risk must not replace governance gating.

Requirements:

- ranking weights/configuration must be inspectable and testable;
- avoid unbounded feedback loops from historical success;
- historical telemetry must never permanently suppress a capability solely due to sparse early failures;
- new capabilities need sensible cold-start behavior;
- deterministic behavior should be available for tests;
- any model/cross-encoder reranker must justify its latency and dependency cost.

A heavyweight learned reranker is optional. Do not add one merely because the source architecture mentions reranking if simpler existing Agent_X scoring satisfies the objective.

---

# 12. Top-K Capability Projection

This is a critical assimilation requirement.

The model or worker assigned to a work unit must receive only a bounded set of relevant, authorized capabilities.

Do not dump the complete catalog into every prompt.

Implement configurable stages such as:

```text
Large Catalog
    │
    ▼
Eligible Set
    │
    ▼
Retrieval Candidate Pool
    │
    ▼
Reranked Candidate Pool
    │
    ▼
Final Top-K Projection
```

Do not hardcode the example values below if Agent_X already has configuration conventions, but support equivalent controls:

- retrieval candidate count;
- rerank candidate count;
- final K;
- token budget;
- schema byte/size budget;
- optional per-provider or diversity constraints.

Reasonable defaults may be selected from evidence and tests. Example ranges such as 20-50 retrieval candidates and 5-12 final capabilities are starting points, not architectural constants.

The final projection must satisfy both:

```text
count(projected_capabilities) <= configured_K
```

and the configured context/schema budget.

---

# 13. Compact Metadata First, Exact Schema When Needed

Avoid paying the full schema cost for every candidate when the runtime can safely defer it.

Where compatible with the current model/tool invocation mechanism:

1. retrieve using compact normalized metadata;
2. rerank using compact metadata;
3. project concise capability information;
4. materialize full exact schemas for finalists or the selected capability at the latest safe stage;
5. validate the actual invocation against the current exact schema before execution.

If the LLM tool-calling API requires full schemas for all final candidates, limit that cost to the bounded final shortlist.

Never execute from an outdated approximate schema summary.

---

# 14. Diversity and Near-Duplicate Handling

A top-K list containing several nearly identical capabilities can waste scarce context.

Where multiple capabilities are functionally similar:

- retain the strongest candidates;
- preserve meaningful provider/source alternatives when useful;
- avoid filling the entire shortlist with aliases or duplicates;
- distinguish genuinely different execution characteristics.

Any diversity logic must remain subordinate to relevance, authority, and correctness.

---

# 15. Work-Unit-Aware Capability Resolution

Resolve capabilities for the actual Agent_X/Borg work unit rather than only the raw user prompt.

Use all relevant existing structured information, such as:

- objective;
- work-unit type;
- expected output;
- required artifacts;
- repository/path scope;
- worker specialization;
- constraints;
- previous step outputs;
- data locality;
- current execution environment.

Do not collapse structured work-unit semantics into one lossy string if Agent_X already has typed representations that can improve filtering or ranking.

The capability resolver should support the broader Borg orchestration architecture, not bypass it.

---

# 16. Selection Must Be Restricted to the Projected Set

The model or worker may select only capabilities actually projected to it and authorized for that execution context.

Do not permit:

- invented capability names;
- arbitrary raw MCP method names;
- free-form provider/tool identifiers;
- hidden tools not present in the authorized projection;
- direct bypass of the catalog/resolver.

Resolve any model-emitted capability identifier back to the canonical catalog entry before execution.

Unknown IDs or stale aliases must fail closed and trigger controlled re-resolution if appropriate.

---

# 17. Execution-Time Revalidation

Immediately before invocation, revalidate the selected capability.

At minimum verify:

- canonical capability still exists;
- provider still exists;
- provider is sufficiently healthy/available;
- capability is enabled;
- capability is not newly deprecated/removed;
- current schema/revision is valid;
- arguments validate against the current schema;
- current worker/session authority still permits execution;
- current policy still permits execution;
- current risk/approval state is satisfied;
- scope still matches;
- no required governance state has expired or changed.

This check must use the existing Agent_X execution/governance authority rather than a source-specific MCP policy layer.

If state changed after projection, do not honor the stale shortlist blindly.

---

# 18. Failure, Retry, and Re-Resolution

Use existing Agent_X retry, timeout, cancellation, circuit-breaker, and execution-failure semantics wherever present.

On capability-selection or provider failures:

- classify the failure;
- invalidate stale provider/catalog state when appropriate;
- refresh discovery if appropriate;
- re-resolve the capability set when appropriate;
- choose another authorized candidate only through the normal resolver;
- respect retry limits;
- surface a clear failure when no suitable authorized capability remains.

Never respond to failure by relaxing governance or invoking an unregistered tool directly.

---

# 19. Caching

Assimilate caching only where it reduces repeated resolution cost without creating stale security decisions.

Possible cached objects include:

- normalized catalog metadata;
- lexical index results;
- semantic embeddings;
- retrieval candidates;
- reranking results;
- final projections.

Cache keys must include the state needed to prevent invalid reuse. Depending on current Agent_X architecture, include relevant fingerprints/revisions such as:

- normalized task/work-unit intent;
- worker/specialization;
- authority scope;
- policy/governance version;
- catalog revision;
- provider revisions;
- health state where material;
- retrieval configuration/version;
- lexical index version;
- embedding model/index version;
- reranker configuration/version;
- projection-budget configuration.

Invalidate affected entries when any material dependency changes.

Do not permanently cache a positive authorization result.

Execution-time authorization must always be current.

---

# 20. Fallback Behavior

When retrieval confidence is low or no suitable capability is found, use safe fallback behavior.

A reasonable order is:

1. widen non-policy retrieval candidate counts;
2. relax only relevance thresholds that are safe to relax;
3. refresh stale capability providers/catalog;
4. retry lexical and semantic channels independently;
5. use deterministic category/provider introspection if Agent_X supports it;
6. return "no suitable authorized capability" when none exists.

Never relax:

- authority;
- policy;
- approval requirements;
- protected-resource restrictions;
- safety boundaries;
- execution-time validation.

Fallback is a retrieval mechanism, not a governance bypass.

---

# 21. Telemetry and Outcome Feedback

Instrument the generalized capability resolver using Agent_X's existing telemetry system where possible.

Record useful operational signals such as:

- total catalog size;
- number of active providers;
- number of structurally eligible capabilities;
- number excluded by governance in safe aggregate form;
- lexical candidate count;
- semantic candidate count;
- fused candidate count;
- final shortlist count;
- selected capability ID;
- provider/source type;
- retrieval/reranking latency;
- execution latency;
- execution result;
- failure class;
- resolver retry count;
- fallback count;
- estimated/actual cost where Agent_X already tracks it;
- final context token/schema cost;
- estimated full-catalog context cost;
- resulting context savings.

Do not log:

- secrets;
- credentials;
- protected payloads;
- unnecessarily sensitive arguments;
- sensitive policy details that current Agent_X logging rules prohibit.

Historical outcome data may influence ranking, but keep the influence bounded and auditable.

---

# 22. Scale Without Context Explosion

The architecture must continue working when the catalog contains at least:

- 100 capabilities;
- 1,000 capabilities;
- 5,000 capabilities;
- larger future catalogs subject to practical test limits.

The model-visible capability count must remain bounded rather than growing linearly with catalog size.

Measure at minimum:

- retrieval latency;
- rerank latency;
- final prompt/schema size;
- context/token savings;
- top-K relevance on representative test tasks;
- end-to-end selection success.

The desired scaling property is:

```text
more learned/discovered capabilities
        │
        ▼
larger external capability universe
        │
        ▼
retrieval + filtering + projection
        │
        ▼
small bounded active context
```

Do not allow:

```text
more capabilities
        │
        ▼
larger prompts
        │
        ▼
more model confusion
```

to become the architecture.

---

# 23. Explicitly Forbidden Parallel Subsystems

Do not introduce independent permanent production abstractions equivalent to the following merely because the source repository contains such concepts:

```text
DynamicMCPManager
MCPVectorDatabase
MCPToolOrchestrator
MCPAgentRouter
MCPToolRegistry
MCPPolicyEngine
MCPExecutionAuthority
```

If Agent_X lacks a required generalized owner, create capability-centered abstractions instead, for example conceptually:

```text
CapabilityCatalog
CapabilityProvider
CapabilityResolver
CapabilityIndex
CapabilityProjection
```

Use actual names consistent with the existing Agent_X codebase.

MCP-specific naming is appropriate only inside protocol-specific adapter/client/provider code.

---

# 24. Other Forbidden Anti-Patterns

Do not finish the assimilation with any of the following:

- entire capability catalog injected into every prompt;
- every capability schema injected into every prompt;
- a second registry representing the same production capabilities;
- a second governance or authority layer;
- authorization represented only as a ranking score;
- stale cached authorization trusted at execution time;
- arbitrary capability execution by free-form model name;
- direct raw MCP execution bypassing Agent_X governance;
- copied source pseudocode masquerading as integration;
- a new heavyweight vector database without demonstrated need;
- duplicate semantic indexes when an existing generalized index can be extended;
- permanent old/new parallel production routing;
- shadow compatibility code with no removal path;
- source-specific branding throughout the Agent_X core;
- TODO-only production paths;
- unimplemented interfaces;
- dead abstractions;
- placeholder success telemetry;
- benchmark claims without measurements;
- unrelated repository-wide refactoring.

---

# 25. Migration and Cleanup

After the generalized path is implemented:

1. migrate relevant callers to the authoritative capability path;
2. preserve compatibility through the smallest temporary adapter only when necessary;
3. remove obsolete duplicate code once it has no required callers;
4. remove unused source-specific configuration;
5. remove unused dependencies;
6. update examples;
7. update documentation;
8. update configuration documentation;
9. remove stale tests that assert superseded architecture only after replacing their behavioral coverage;
10. ensure there is no split-brain production capability resolution.

Do not preserve old architecture indefinitely merely to avoid deleting code.

---

# 26. Security and Adversarial Requirements

Add tests proving that capability retrieval cannot become an authority bypass.

At minimum test:

- unauthorized capability is absent from the model-visible shortlist;
- unauthorized capability cannot be invoked by guessing its name;
- unauthorized capability cannot be invoked by guessing its ID;
- prompt injection cannot request a hidden/unprojected capability directly;
- malformed provider metadata cannot manufacture authority;
- malicious descriptions cannot bypass governance;
- authority revoked after projection is caught at execution;
- provider removed after projection is caught;
- schema changed after projection is caught;
- stale cache cannot resurrect removed authorization;
- duplicate aliases cannot create a bypass identity;
- provider/server spoofing does not collapse unrelated identities;
- malformed schemas are rejected safely;
- a model cannot request arbitrary MCP methods outside the normalized catalog.

Authorization leakage into projected capability sets must be **zero** in the test suite.

---

# 27. Required Unit Tests

Add or strengthen unit tests for all applicable behavior.

At minimum cover:

- capability descriptor normalization;
- deterministic stable IDs;
- alias handling;
- source/provider identity;
- deduplication;
- revision detection;
- schema hash/change detection;
- provider add;
- provider remove;
- capability add;
- capability remove;
- capability change;
- refresh behavior;
- structural eligibility;
- authority filtering;
- policy filtering;
- lexical retrieval;
- semantic retrieval;
- semantic-unavailable fallback;
- candidate fusion;
- deterministic deduplication;
- reranking;
- cold-start ranking behavior;
- health effects;
- top-K limiting;
- token/schema-budget limiting;
- compact-versus-full schema materialization where applicable;
- cache key correctness;
- cache invalidation;
- fallback ordering;
- unknown capability rejection;
- pre-execution revalidation;
- argument/schema validation;
- authority revocation;
- provider unavailability;
- schema revision races.

---

# 28. Required Integration Tests

Add integration tests using controlled/mock capability providers.

At minimum cover:

## 28.1 Mixed provider universe

Expose overlapping capabilities from:

- at least one MCP-like provider;
- at least one native Agent_X capability source.

Verify they enter one generalized selection path.

## 28.2 Similar names

Expose different providers with similar/identical tool names.

Verify stable identity and correct provider selection.

## 28.3 Capability added mid-run

Add a capability after initial discovery.

Verify refresh/index invalidation makes it discoverable.

## 28.4 Capability removed mid-run

Remove a capability after it has previously been projected.

Verify execution-time validation prevents stale execution.

## 28.5 Permission revoked mid-run

Project a capability while authorized, revoke permission before invocation, and verify execution is denied.

## 28.6 Schema changed mid-run

Change a schema after retrieval and before invocation.

Verify stale arguments are not blindly executed.

## 28.7 Provider outage

Take a provider unavailable.

Verify its capabilities are not treated as normally executable and fallback behaves correctly.

## 28.8 No candidates

Verify a clean "no suitable authorized capability" outcome rather than bypass behavior.

## 28.9 Malicious metadata

Use misleading descriptions/tags intended to manipulate relevance.

Verify policy and identity remain authoritative.

## 28.10 Near-duplicate candidate saturation

Provide many near-identical capabilities.

Verify the final shortlist remains useful and bounded.

---

# 29. Required Scale Tests

Use synthetic capability catalogs or equivalent controlled fixtures to evaluate at least:

- ~100 capabilities;
- ~1,000 capabilities;
- ~5,000 capabilities, if the local test environment can reasonably support it.

For each scale, record:

- catalog construction/index time where relevant;
- retrieval latency;
- reranking latency;
- final shortlist size;
- final prompt/schema size;
- estimated full-catalog prompt/schema size;
- percentage or absolute context reduction;
- top-K hit quality against known representative queries.

Do not claim large-scale readiness without recording actual measurements from the implementation environment.

---

# 30. Baseline and Benchmark Evaluation

Before or during migration, establish the behavior of the existing Agent_X selection path sufficiently to compare it with the assimilated architecture.

Compare:

```text
BASELINE:
current/old capability selection behavior

VERSUS

ASSIMILATED:
eligibility
→ governance hard filter
→ lexical + semantic retrieval
→ fusion
→ reranking
→ bounded projection
→ execution-time revalidation
```

Measure as applicable:

- top-K hit rate on a curated representative task set;
- correct capability-selection rate;
- execution-success rate;
- catalog-to-prompt token reduction;
- schema-byte reduction;
- retrieval latency;
- reranking latency;
- end-to-end latency;
- fallback rate;
- authorization leakage;
- behavior as catalog size grows.

Authorization leakage must remain zero.

Do not fabricate performance improvements. Report regressions as regressions and fix material regressions before declaring completion.

---

# 31. Configuration Requirements

Use Agent_X's existing configuration system.

Make meaningful values configurable rather than scattering magic constants through production code.

Potential configuration includes:

- discovery refresh behavior;
- lexical candidate count;
- semantic candidate count;
- fusion parameters;
- rerank candidate count;
- final K;
- context/token budget;
- schema budget;
- reliability weighting;
- latency weighting;
- cost weighting;
- health weighting;
- cache TTL where appropriate;
- fallback behavior;
- semantic retrieval enabled/disabled;
- index/model versions.

Defaults must be safe and documented.

Avoid creating multiple unrelated configuration namespaces for the same capability resolver.

---

# 32. Dependency Discipline

Before adding any dependency:

1. prove Agent_X does not already have an adequate equivalent;
2. prove the standard library/existing dependency set cannot reasonably satisfy the need;
3. estimate runtime and maintenance cost;
4. avoid provider-specific lock-in where unnecessary.

Do not add a standalone vector database just to reproduce the Dynamic MCP pseudocode.

Use the existing Agent_X embeddings/index/storage architecture unless there is a documented correctness or scaling blocker.

---

# 33. Compatibility Discipline

Preserve compatibility where it is materially required by Agent_X, but do not use compatibility as an excuse for permanent duplication.

For public/internal interfaces that must transition:

- prefer adapters;
- preserve semantics;
- issue deprecation markers where repository conventions support them;
- migrate all in-repo callers;
- add regression tests;
- remove obsolete paths when safe within this task.

Do not require every consumer to understand whether a capability originated from MCP, native tools, or another provider unless provider identity is functionally necessary.

---

# 34. Documentation Requirements

Update the relevant Agent_X documentation so the final architecture is clear.

Document:

- the unified capability model;
- provider/adaptor boundaries;
- how MCP integrates;
- discovery and synchronization;
- structural eligibility;
- governance hard filtering;
- hybrid retrieval;
- reranking;
- top-K projection;
- execution-time revalidation;
- caching/invalidation;
- fallback behavior;
- telemetry;
- configuration;
- extension points for future capability providers.

Do not describe a separate "Dynamic MCP subsystem" if no such subsystem exists after correct assimilation.

The documentation must reflect production behavior, not aspirational pseudocode.

---

# 35. Required Verification Commands

Use the repository's actual established toolchain.

Run all applicable checks, including the repository equivalents of:

- formatting;
- linting;
- type checking;
- unit tests;
- integration tests;
- security/adversarial tests;
- capability/MCP-specific tests;
- orchestration tests affected by the change;
- full regression suite where practical;
- benchmark/scale evaluation.

Do not silently skip failing tests.

For every failure:

1. determine whether the change caused it;
2. repair the implementation or test as appropriate;
3. rerun the affected checks;
4. continue until clean or a genuine hard blocker remains.

---

# 36. Acceptance Gates

Do not declare this assimilation complete unless all applicable gates pass.

## Architecture gates

- [ ] Dynamic MCP source repository was fully inspected.
- [ ] Every significant source concept received a disposition.
- [ ] Existing Agent_X architectural owners were identified before creating new ones.
- [ ] MCP remains a provider/adapter boundary.
- [ ] Core capability selection is generalized rather than MCP-specific.
- [ ] No redundant permanent MCP registry/router/orchestrator was introduced.
- [ ] There is one authoritative production capability-selection path or an explicit, temporary, tested migration boundary.

## Capability model gates

- [ ] Capabilities have stable identities.
- [ ] Provider identity is preserved.
- [ ] Schema/revision changes are detectable.
- [ ] Discovery handles add/remove/change.
- [ ] Stale/unavailable capabilities are handled safely.

## Governance gates

- [ ] Governance/authority filtering occurs before model exposure.
- [ ] Unauthorized capabilities never enter the model-visible shortlist.
- [ ] Execution-time governance is revalidated.
- [ ] No ranking score can override a denied capability.
- [ ] No raw MCP path bypasses Agent_X governance.

## Retrieval gates

- [ ] Lexical retrieval is operational.
- [ ] Semantic retrieval is operational when semantic infrastructure is enabled.
- [ ] Graceful fallback exists when semantic retrieval is unavailable.
- [ ] Candidate fusion is deterministic/testable.
- [ ] Reranking uses useful context rather than semantic similarity alone.

## Projection gates

- [ ] Final capability count is bounded by configuration.
- [ ] Final capability context respects the configured token/schema budget.
- [ ] Full catalog/schema dumping is eliminated from affected selection paths.
- [ ] Exact current schemas are validated before execution.

## Execution gates

- [ ] Only projected/authorized canonical capabilities can be selected.
- [ ] Unknown/invented capability names fail closed.
- [ ] Provider state is checked before invocation.
- [ ] Schema revision is checked before invocation.
- [ ] Arguments are validated.
- [ ] Authority/policy is checked immediately before invocation.

## Cache gates

- [ ] Cache keys include material catalog/config/context revisions.
- [ ] Catalog/schema/provider changes invalidate affected caches.
- [ ] Authority/policy changes cannot be hidden by stale caches.
- [ ] Execution does not trust permanently cached authorization.

## Security gates

- [ ] Unauthorized projection leakage is zero in tests.
- [ ] Guessed capability names/IDs cannot bypass projection/governance.
- [ ] Malicious metadata cannot grant authority.
- [ ] Revocation between projection and execution is caught.
- [ ] Removed/changed capabilities cannot execute through stale state.

## Scale gates

- [ ] Large synthetic catalogs were tested.
- [ ] Final shortlist remains bounded as catalog size grows.
- [ ] Context/schema reduction was measured.
- [ ] Retrieval/rerank latency was measured.
- [ ] Representative top-K quality was evaluated.

## Quality gates

- [ ] New unit tests pass.
- [ ] New integration tests pass.
- [ ] Security/adversarial tests pass.
- [ ] Existing affected Agent_X tests pass.
- [ ] Full regression suite passes where practical.
- [ ] Lint/format/type checks pass according to repository conventions.
- [ ] Documentation matches the implementation.
- [ ] No placeholder production code remains.
- [ ] No dead duplicate architecture remains.
- [ ] Diff contains no unnecessary unrelated refactors.

---

# 37. Definition of Done

This assimilation is `DONE` only when all of the following are true:

1. the complete Dynamic MCP repository has been inspected;
2. every meaningful source concept has been evaluated;
3. every useful missing concept has been implemented or merged;
4. already-superior Agent_X mechanisms have been preserved rather than replaced;
5. rejected source concepts have explicit technical reasons;
6. MCP tools are represented through the generalized Agent_X capability architecture;
7. native and MCP capabilities can participate in the same generalized resolution path where applicable;
8. structural eligibility occurs before relevance selection;
9. governance/authority is a hard pre-projection filter;
10. lexical and semantic retrieval are integrated where infrastructure permits;
11. candidate fusion and contextual reranking are implemented and tested;
12. only a bounded top-K/token-budget capability set reaches the model;
13. capability schemas/context no longer scale linearly with the total catalog on the affected path;
14. capability selection is restricted to canonical projected capabilities;
15. execution performs current schema/provider/authority/policy revalidation;
16. caching cannot preserve stale authorization;
17. provider and schema changes invalidate affected state;
18. safe retrieval fallbacks exist without governance relaxation;
19. telemetry measures resolution and context savings;
20. scale tests demonstrate bounded active context;
21. security/adversarial tests demonstrate zero unauthorized capability projection/invocation;
22. relevant legacy/duplicate code has been migrated and removed or explicitly deprecated with no permanent split-brain architecture;
23. configuration and documentation have been updated;
24. no unnecessary Dynamic MCP-specific architecture remains in the Agent_X core;
25. no unimplemented TODO/placeholders remain in the production assimilation path;
26. all applicable verification passes;
27. the final git diff has been inspected for accidental or unrelated changes.

Do not claim `DONE` if any material gate is unverified.

If a genuine external blocker prevents completion, return `BLOCKED` and identify the exact blocker and the furthest verified state reached.

---

# 38. Execution Behavior

Work directly against the current Agent_X branch/worktree provided to the agent.

Follow existing repository engineering conventions.

Do not:

- reset unrelated user work;
- overwrite unrelated changes;
- force-push;
- discard existing changes merely to obtain a clean tree;
- stop at recommendations when implementation is possible;
- ask the user to choose between equivalent implementation details that can be resolved from the codebase.

If an implementation choice is ambiguous:

1. inspect the current architecture;
2. prefer the existing owner;
3. prefer the option with fewer duplicate abstractions;
4. prefer the option with lower architectural entropy;
5. prefer generalized capability behavior over MCP-specific core behavior;
6. preserve governance invariants;
7. choose and implement the best-supported option.

If the existing Agent_X implementation already satisfies a Dynamic MCP concept better than the source repository:

- mark it `ALREADY_PRESENT`;
- verify it with tests;
- do not replace it merely to make the diff larger.

If a Dynamic MCP concept is technically inferior or inappropriate:

- mark it `REJECT`;
- document the reason;
- do not reproduce it.

Continue implementation, test, repair, and verification cycles until all acceptance gates pass or a true blocker remains.

---

# 39. Required Final Execution Report

At completion, output a concise but complete implementation report using exactly these top-level sections:

```text
STATUS: DONE
```

or:

```text
STATUS: BLOCKED
```

Then report:

## 1. Source Concept Disposition

For every significant Dynamic MCP concept:

```text
concept
→ ASSIMILATE / MERGE / ALREADY_PRESENT / REJECT
→ Agent_X owner/path
→ result/reason
```

## 2. Existing Agent_X Owners Found

List the production architectural owners discovered and used.

## 3. Files Changed

List every changed/added/deleted file and its purpose.

## 4. Architecture Implemented

Describe the final production flow, including:

```text
providers
→ catalog
→ eligibility
→ governance
→ hybrid retrieval
→ reranking
→ bounded projection
→ selection
→ revalidation
→ execution
→ telemetry
```

## 5. Duplicate / Legacy Architecture Removed

List obsolete paths, duplicate registries, wrappers, adapters, or source-specific structures removed or retired.

## 6. Configuration / Dependency Changes

List configuration additions/changes and all dependency changes with justification.

## 7. Verification Performed

List the exact commands run and exact outcomes.

Do not write only "tests passed."

## 8. Benchmark / Context-Savings Results

Report measured:

- catalog sizes tested;
- shortlist sizes;
- token/schema context before versus after where measurable;
- retrieval latency;
- reranking latency;
- top-K quality results;
- any relevant regressions.

## 9. Security Validation

Report results for:

- unauthorized projection;
- guessed/unprojected invocation;
- authority revocation;
- provider removal;
- schema change;
- stale-cache behavior;
- malicious metadata.

## 10. Intentional ALREADY_PRESENT / REJECT Items

Explain what was not reimplemented and why.

## 11. Remaining Blockers

Include only if `STATUS: BLOCKED`.

For each blocker, state:

- exact blocker;
- why it cannot be resolved from the current repository/environment;
- affected acceptance gate;
- verified work completed before the blocker.

## 12. Git Diff Summary

Report:

- files added;
- files modified;
- files deleted;
- relevant diff statistics;
- commit hash if a commit was created under the normal Agent_X execution workflow.

---

# 40. Final Architectural Principle

The successful end state is **not**:

```text
Agent_X
    └── Dynamic MCP subsystem
            └── MCP tools
```

The successful end state is:

```text
                         Agent_X / Borg

                    Unified Capability Space
                 /          |          |       \
                /           |          |        \
             MCP         native      skills    other
              \             |          |       /
               \            |          |      /
                ───── Capability Catalog ─────
                            │
                            ▼
                     Eligibility Gates
                            │
                            ▼
                  Governance / Authority
                            │
                            ▼
                    Hybrid Retrieval
                            │
                            ▼
                  Contextual Reranking
                            │
                            ▼
                  Bounded Projection
                            │
                            ▼
                      Borg Work Unit
                            │
                            ▼
                  Execution Revalidation
                            │
                            ▼
                   Governed Execution
                            │
                            ▼
                  Telemetry / Learning
```

Dynamic MCP must disappear as a separate architectural idea after assimilation while its useful mechanisms remain as native Agent_X/Borg capability behavior.
