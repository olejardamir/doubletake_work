# Agent_X Harvest Completion, Selection, Decision, and End-to-End Implementation Prompt

## Mission

You are working on the Agent_X project:

`/home/glompy/Desktop/ASTROCYTECH/Agent_X/`

Complete the Harvest subsystem so that it becomes a trustworthy end-to-end path from guided discovery to durable inventory, architectural/value decision, semantic-first implementation, stack execution, verified runtime/UI integration, and exact completion bookkeeping.

This is not a greenfield redesign. Work from the current repository architecture, current contracts, current UI, current semantic-first pipeline, current stack system, current resource safeguards, and current Harvest lifecycle. Reuse and extend the canonical owners. Do not build a parallel Harvest system, parallel semantic-first system, parallel implementation gate, parallel stack, or second source of truth.

The repository state inspected when this prompt was written was:

- branch: `main`
- commit: `5f0e2a1a16a0af49636ff36561dfcef9e3ac7e8c`
- inspected on: 2026-09-11

However, **the live current `origin/main` at execution time is authoritative**. Before editing anything, fetch and inspect it. If `main` has advanced beyond the inspected commit, re-evaluate every requirement in this prompt against the newer code and implement only what is still needed. Do not undo newer correct work just to reproduce the inspected state.

---

# Non-negotiable operating rules

1. Start from the current live repository state. Inspect `git status`, local changes, current branch, `origin/main`, and the merge base before modifying files.
2. Do not discard, reset, overwrite, or silently replace unrelated local/user work.
3. Inspect existing architectural contracts, semantic model, Harvest lifecycle, stack implementation, API endpoints, UI state, tests, and resource-budget mechanisms before choosing implementation locations.
4. Reuse existing canonical modules and extension points. Do not create redundant owners because it is easier.
5. Prefer the smallest coherent architecture that completes the behavior end to end.
6. Do not leave required behavior as TODOs, placeholders, fake adapters, hard-coded demonstrations, unreachable code, or tests that only validate mocks instead of the real path.
7. Do not weaken current governance or lifecycle gates to make tests pass.
8. Do not implement a harvested idea merely because it can be implemented.
9. Do not accept code that is technically functional but useless, undiscoverable, unmaintainable, too expensive for the target machine, duplicative, or performance-degrading.
10. Preserve backward compatibility where it has actual value, but do not retain obsolete duplicate paths merely to avoid cleanup.
11. If a replacement is the correct architecture, replace and remove the obsolete implementation rather than accumulating another layer beside it.
12. All repository-changing Harvest implementation must use the existing semantic-first pipeline. Semantic state is changed first; code follows only after semantic authorization.
13. All coding continues through the existing stack mechanism. Do not bypass it with a special Harvest coding runner.
14. A Harvest item is not "done" until its implementation is verified end to end, its inventory state is updated durably, and its exact active stack entry is removed.
15. Any requirement already correctly implemented on current `main` must be preserved and tested rather than rewritten for cosmetic reasons.

---

# Current-state facts that must guide the work

Verify these again on the live branch before coding.

The current Harvest UI already contains a substantial lifecycle model. It understands Gate A, Gate B-style implementation eligibility, dispositions such as `IMPLEMENT`, `MERGE`, `EXPERIMENT`, `NO_CHANGE`, `DEFER`, and `REJECT`, candidate-level slop, evidence, substance, owner resolution, behavioral delta, and other inventory dimensions.

The current Inventory tab already exposes rich multi-select filtering for fields including Type, Evidence, Substance, Gate A, Agent_X Gap, Disposition, Slop Risk, Owner resolution, and Behavioral Delta, together with numeric Worth, Value, and Rank ranges.

The current Harvest discovery controls are narrower than the inventory model. In particular, the Harvest-side slop selection is still represented by a legacy LOW-only boolean behavior, while the Inventory tab already supports LOW/MEDIUM/HIGH multi-selection.

The current autonomous Harvest path already pushes authorized Harvest work into the existing stack. Do not replace this with a new executor.

The current UI path also contains two lifecycle/accounting problems that must be re-evaluated and fixed if still present:

- autonomous Harvest clears the inventory at the start of a cycle;
- completed Harvest stack work can be cleared broadly instead of completing and removing the exact item with a durable inventory completion handshake.

The current repository contains a canonical `semantic_first` package. Its public contract states that Harvest and other repository-changing operations must enter the semantic-first pipeline before implementation, including semantic interpretation, target semantic state, authorization, implementation verification, and reconciliation.

The current repository also contains existing resource/runtime safeguards, including hardware-aware and memory-aware behavior. Reuse them when judging whether a candidate is supportable.

---

# Target behavior

Harvest must become one coherent lifecycle:

`UI discovery guidance/selections`
→ `candidate discovery`
→ `canonical inventory record`
→ `distillation`
→ `Gate A`
→ `assimilation`
→ `Gate B / implementation decision`
→ `revalidation against current Agent_X`
→ `semantic-first target update`
→ `semantic authorization`
→ `existing coding stack`
→ `code/UI/runtime implementation`
→ `verification`
→ `semantic reconciliation`
→ `inventory completion`
→ `remove exact completed stack item`

No stage may silently skip the authority of the stage before it.

---

# Part 1 — Make Search / Exploration Focus a soft semantic guide

The Harvest field currently labeled **Search / Exploration Focus** must improve discovery accuracy without becoming a hard precision filter.

Its semantics must be explicit and consistent in UI, API, and backend:

- It is a **soft semantic prior / exploration guide**.
- It may seed embedding search, query expansion, producer focus, candidate ranking, semantic similarity scoring, or a bounded relevance boost.
- It must **not** be a hard inclusion/exclusion predicate.
- A candidate must never be rejected solely because it is weakly similar to the focus text.
- High-value, strongly evidenced, useful candidates outside the exact wording of the focus must remain discoverable.
- Empty focus means neutral discovery, not an implicit default topic.
- Focus must not destroy producer/domain diversity.
- Focus must not collapse search to keyword matching.
- Focus must not turn into exact text search over the inventory.
- Do not recompute expensive whole-repository embeddings on every keystroke or every UI refresh.
- Reuse existing embedding/index/cache/dedup infrastructure where possible.

Where useful, retain traceability such as a focus relevance score or reason, but do not make that score an implementation authorization.

Add tests demonstrating that a clearly valuable off-focus candidate can still survive discovery.

---

# Part 2 — Unify Harvest selection criteria with canonical inventory truth

## Goal

The user must be able to find and generate inventory that actually corresponds to the selections shown in the Harvest UI.

The values displayed in inventory must be the same canonical values used by selection/filter/eligibility logic. There must not be one set of React-derived labels and another backend-derived authority.

## Required model

Create or extend one canonical Harvest candidate-selection policy/schema that is shared or consistently serialized across UI/API/backend.

It must account for all meaningful dimensions that the Inventory UI exposes and that can reasonably guide candidate selection, including at minimum:

- Worth
- Value
- Rank
- Capability/Item Type
- Evidence
- Substance
- Gate A result/state
- Agent_X Gap classification
- Disposition
- Slop Risk
- Owner resolution
- Behavioral Delta state
- lifecycle/status where semantically appropriate
- domain/source/producer where already part of the current Harvest model

Do not blindly convert every inventory column into an early raw-discovery threshold. Respect lifecycle timing.

## Stage-aware enforcement

Some fields exist during raw gathering; others only exist after distillation or assimilation.

Implement stage-aware qualification:

### Gather-time criteria
Apply only criteria whose canonical values are genuinely available at gather time.

Typical examples may include:

- producer/source
- domain
- raw worth/value if those values are canonical at that stage
- user-selected Harvest kind
- initial relevance guidance

### Post-distillation criteria
Once the candidate has been distilled and fields become authoritative, apply criteria such as:

- candidate-level Slop Risk
- Type
- Evidence
- Substance
- Gate A result

### Post-assimilation / Gate B criteria
Once current-Agent_X analysis has established them, apply criteria such as:

- real Agent_X gap
- owner resolution
- behavioral delta
- disposition
- implementation eligibility
- architecture/placement decision
- value/resource decision

Do not fabricate late-stage values early merely so a threshold can be checked.

## Unknown values

If a selected criterion depends on a field not yet computed:

- allow the record to proceed provisionally to the stage that can compute it;
- mark the field as unknown/pending rather than inventing a value;
- do not count the record as a final qualifying candidate until the required criterion is known and satisfied;
- if it later fails, reconcile the target count and continue discovery if appropriate.

## Selection semantics

Use predictable set semantics:

- **OR within a multi-select category.**
  - Example: selecting `LOW` and `MEDIUM` Slop means LOW OR MEDIUM.
- **AND across independent categories.**
  - Example: selected Type AND selected Evidence AND selected Slop AND numeric ranges.
- Empty/unselected category means no restriction for that category.
- Search / Exploration Focus remains a soft ranking/exploration prior and is not inserted into the hard AND chain.
- Numeric ranges are inclusive unless an existing canonical convention already says otherwise.

Expose this behavior clearly in UI help text/tooltips without cluttering the main interface.

## Target reconciliation

If the user asks Harvest for N qualifying candidates, and later distillation/assimilation disqualifies some based on selected criteria:

- do not silently return fewer and call the target satisfied;
- continue bounded discovery until N final qualifying candidates are obtained or the search space/budget is exhausted;
- report the actual reason if fewer than N could be found.

Reuse the existing reconciliation mechanisms instead of writing another loop if they already own this behavior.

---

# Part 3 — Replace Harvest's LOW-only slop control with LOW/MEDIUM/HIGH multi-select

In the **Harvest discovery controls**, replace the legacy LOW-only boolean behavior with a multi-select set:

- `LOW`
- `MEDIUM`
- `HIGH`

Any non-empty combination is valid.

The visual interaction should match the existing Producers and Harvest-kind chip/toggle selection pattern as closely as the current design system permits.

The Inventory tab already has multi-select slop semantics. Reuse the same conceptual semantics and, where cleanly possible, shared UI primitives/constants instead of creating another interpretation.

## Migration

Migrate persisted legacy frontend state safely:

- old `slopLowOnly = true` → `["LOW"]`
- old `slopLowOnly = false` → `["LOW", "MEDIUM", "HIGH"]`

After successful migration, stop using the boolean as the canonical state.

Backend/API selection should use an allowed set, not a binary `low_only/all` assumption.

Candidate-level slop assigned after distillation remains authoritative. Raw/gather slop may remain provenance only.

If a candidate that provisionally qualified is later classified outside the selected slop set, remove it from the qualifying result and reconcile the target count.

Add tests for:

- LOW only
- MEDIUM only
- HIGH only
- LOW+MEDIUM
- LOW+HIGH
- MEDIUM+HIGH
- all three
- persisted legacy migration
- candidate-level reclassification after distillation

---

# Part 4 — Extend the existing Gate B into a complete implementation-worthiness decision

Do **not** build another independent "should we implement?" gate.

Extend the current assimilation/Gate B ownership so that before the Implement action becomes authoritative, every candidate is evaluated against the current Agent_X state.

An inventory entry is evidence and a proposal. It is never permission to code by itself.

## Gate B must answer all of the following

### 1. Is this a real current gap?
Check current code, semantic model, runtime wiring, existing capabilities, configuration, UI reachability, and tests.

Reject or merge candidates that are already materially present.

### 2. Does it have actual value?
Evaluate whether the capability:

- solves a real Agent_X need;
- improves a meaningful user or system outcome;
- is likely to be used;
- is reachable/discoverable in the actual workflow;
- is not merely interesting in theory.

A feature that works but would never be used is not an implementation success.

### 3. Will it improve rather than degrade Agent_X?
Estimate likely effects on:

- correctness
- reliability
- latency
- responsiveness
- startup/runtime cost
- memory
- CPU
- disk
- background activity
- dependency burden
- operational complexity
- maintainability
- debugging complexity
- failure surface

If expected net effect is negative, do not implement.

### 4. Can the current hardware/software support it?
Use the existing runtime environment and resource-budget owners rather than inventing a Harvest-only hardware profiler.

A candidate must be rejected, deferred, or redesigned if its expected runtime footprint cannot fit the supported environment.

Pay particular attention to:

- RAM pressure
- CPU-heavy background loops
- repeated embedding scans
- large persistent indexes
- model/dependency footprint
- storage growth
- excessive concurrency
- continuous polling
- processes that can cause UI/system freezing

Prefer bounded, cached, incremental designs.

### 5. Is it slop?
Apply the existing slop/evidence/substance logic and reject code-shaped filler, placeholders, vague wrappers, decorative abstractions, unverifiable claims, generic boilerplate, or features with no concrete behavioral delta.

### 6. Where does it belong?
Resolve the canonical owner and best architectural placement.

Do not accept "create a new module" as the default.

Search for:

- the current owner;
- semantically equivalent behavior;
- an existing extension point;
- an obsolete implementation that should be replaced;
- a shared primitive that should be improved instead of duplicated.

### 7. Should it be NEW, REPLACE, EXTEND, or MERGE?
Record a separate implementation-mode decision, preserving existing lifecycle/disposition compatibility where possible:

- `NEW`
- `REPLACE`
- `EXTEND`
- `MERGE`

If current `main` already has a canonical equivalent enum or model, extend/reuse that instead.

Do not overload a lifecycle status if a separate implementation-mode field keeps semantics cleaner.

### 8. What exactly changes?
Gate B must produce a concrete behavioral delta and implementation target, not vague prose.

It should identify:

- semantic capability change;
- canonical owner;
- affected interfaces;
- expected files/components or architectural regions;
- current behavior being replaced/extended;
- UI/runtime reachability;
- verification plan;
- rollback/recovery expectations where relevant.

### 9. Is implementation safe and testable?
Require concrete verification before authorization:

- unit/integration/e2e coverage;
- regression expectations;
- resource/performance checks where relevant;
- UI reachability where relevant;
- no unauthorized side effects.

## Gate B outcomes

Preserve current no-code outcomes such as:

- `NO_CHANGE`
- `DEFER`
- `REJECT`
- `EXPERIMENT`

and existing `IMPLEMENT`/`MERGE` semantics where they are already canonical.

Only an outcome that explicitly allows implementation may enable the implementation path.

The UI should show a concise reason for the decision, including:

- implementation allowed/blocked;
- why;
- selected architecture/owner;
- NEW/REPLACE/EXTEND/MERGE mode;
- blocking reason(s), if any.

Do not expose large internal diagnostics by default.

---

# Part 5 — Revalidate Gate B when Implement is actually invoked

A previously authorized inventory item can become stale because Agent_X changes after the original decision.

Therefore, pressing **Implement** must not blindly reuse an old authorization.

Immediately before semantic/code mutation:

1. reload the current semantic project model;
2. inspect current relevant code/runtime/UI state;
3. re-run duplicate/equivalence detection;
4. re-check the resolved owner;
5. re-check architectural placement;
6. re-check user/system value if assumptions changed;
7. re-check resource feasibility;
8. re-check slop/evidence blockers;
9. detect if the requested behavioral delta is already satisfied;
10. detect whether another recently implemented item superseded or overlaps this one.

The result must be one of:

- authorization remains valid;
- authorization changes to a different mode/owner;
- merge with another current capability;
- no change because already satisfied;
- defer;
- reject/block.

Persist the revalidation result and timestamp/revision evidence.

This must be concurrency-safe enough that two overlapping Harvest items cannot both independently create duplicate implementations.

---

# Part 6 — Make semantic-first mandatory in the real Harvest implementation path

Use the existing canonical `tools/agentx_evolve/semantic_first` architecture and its current public interfaces.

Do not invent a Harvest-specific semantic document writer that bypasses the canonical pipeline.

The mandatory sequence is:

1. Gate B/revalidation authorizes a behavioral change.
2. Convert the approved Harvest candidate into semantic intent.
3. Run the existing semantic-first interpretation against the current project model.
4. Produce/persist the semantic target-state overlay/design.
5. Validate semantic coherence.
6. Obtain the existing semantic authorization/checkpoint required for repository mutation.
7. Only after successful authorization, allow stack-driven code mutation.
8. After implementation, run semantic verification against the approved target state.
9. Reconcile the verified result back into the canonical semantic project model.

Code mutation must fail closed if the semantic stage fails.

No "best effort" fallback may bypass semantic authorization.

Persist enough linkage in the Harvest inventory record to trace:

- inventory item/capability ID;
- semantic interpretation/overlay ID or equivalent;
- authorization evidence;
- implementation stack item;
- verification/reconciliation result.

Add tests proving that code is not mutated if semantic preparation or authorization fails.

---

# Part 7 — Prevent junk accumulation: choose replacement/extension deliberately

A central goal is to prevent Agent_X from becoming a junk pile of successive Harvest implementations.

Before writing new code, compare the candidate against existing implementation and semantic ownership.

## REPLACE

Choose REPLACE when the new capability supersedes an existing owner/implementation.

A successful REPLACE must, where safe and appropriate:

- migrate callers;
- update UI/API/runtime wiring;
- remove obsolete implementation;
- remove dead routes/config;
- remove stale tests that validate removed behavior;
- update relevant documentation/semantic bindings;
- eliminate duplicate execution paths.

Do not leave the old implementation alive "just in case" unless there is a documented compatibility reason.

## EXTEND

Choose EXTEND when the canonical owner is correct and should gain behavior.

Modify the existing owner rather than creating a sibling system.

## MERGE

Choose MERGE when multiple Harvest candidates or current capabilities should become one coherent implementation.

Preserve provenance to all contributing inventory items.

## NEW

Choose NEW only when there is genuinely no suitable owner and the new responsibility is architecturally distinct enough to justify one.

A new module/package must have:

- clear responsibility;
- clear interface;
- clear caller/runtime path;
- tests;
- semantic ownership;
- no overlap with existing owners.

---

# Part 8 — Complete every approved implementation end to end

"Code exists" is not completion.

For every approved Harvest implementation, trace and implement the complete path needed for the behavior to be usable:

`UI/input`
→ `API/command`
→ `domain/service owner`
→ `state/persistence if needed`
→ `runtime behavior`
→ `observable result`
→ `tests/verification`

Where a capability does not need a UI element, do not invent one. But if it affects user-visible behavior or requires configuration/activation, wire it into the existing UI/workflow so the user does not need to know an internal migration occurred.

Requirements:

- no orphan backend capability;
- no dead frontend control;
- no manual file editing required to activate a completed feature;
- no hidden second configuration path;
- no route that returns success without the runtime behavior being active;
- no "implemented" status based solely on files compiling;
- no separate Harvest-only UX unless the feature truly belongs there.

Preserve the existing UI's interaction model and density unless a change is necessary for correctness.

---

# Part 9 — Use the existing stack and implement an exact completion handshake

Harvest coding must continue through the existing stack.

Do not create another queue/executor.

Each Harvest implementation dispatch must have a stable identity that links:

- inventory record;
- capability ID/digest;
- run ID if relevant;
- stack item ID;
- semantic authorization;
- implementation attempt.

## Success path

Only after the stack has successfully completed the implementation and the end-to-end verification has passed:

1. persist the implementation result in the canonical inventory;
2. set a durable terminal implementation state;
3. record the mode: NEW / REPLACE / EXTEND / MERGE;
4. record the resolved owner/placement;
5. record semantic authorization/verification evidence;
6. record implementation evidence such as relevant revision/commit/change digest if available;
7. record verification results;
8. remove **that exact completed stack item** from the active stack.

The inventory update and stack cleanup should be idempotent.

## Failure path

If coding, validation, semantic verification, UI wiring, runtime verification, or resource checks fail:

- do not mark the inventory item implemented;
- do not silently delete its evidence;
- retain an accurate failed/blocked/deferred state;
- do not remove unrelated Harvest stack work;
- preserve enough information to diagnose/retry according to existing stack conventions.

## Stop/cancel path

A stopped/cancelled job is not completed.

Do not convert "stopped" into "implemented."

## Avoid broad clearing

If the current path still contains logic equivalent to clearing all Harvest-source stack items after one run, replace that behavior with item-level completion/removal.

Concurrent unrelated Harvest items must survive.

---

# Part 10 — Make inventory durable; do not erase completion history each autonomous cycle

The inventory must become the durable source of truth for what was discovered, decided, implemented, rejected, replaced, merged, deferred, or archived.

If the autonomous Harvest loop still deletes the entire inventory at the start of a cycle, remove that behavior.

Separate these concepts:

### Durable canonical inventory/history
Contains the historical truth and terminal states.

### Current-run/actionable view
Contains records currently eligible for attention/implementation.

Completed/rejected/deferred/archived entries should be excluded from the active work view by state/filtering, not by destroying history.

A user-explicit **Clear Inventory** operation may remain if that is an intentional existing function, but autonomous housekeeping must not invoke destructive clearing as a substitute for lifecycle management.

If growth requires maintenance:

- archive;
- compact;
- deduplicate;
- apply existing retention/governance rules;

but do not destroy audit truth required to know an item was already handled.

---

# Part 11 — Make inventory lookup based on UI selections truthful and scalable

The Inventory tab must reliably find the canonical records matching the user's selected filters.

Current client-side filtering may remain for a small bounded result set if it is correct and performant, but do not let the UI become the sole authority for filter semantics.

Create one canonical filtering/query contract that can be enforced by the backend and reflected by the UI.

At minimum, support the current inventory dimensions and the selection semantics defined earlier.

Requirements:

- the count shown to the user corresponds to the same records the filter would return;
- displayed canonical values are the values being filtered;
- sort keys map to canonical fields;
- completed/history states are searchable when the user selects them;
- actionable views can exclude terminal records without deleting them;
- text search and structured filters do not silently use different normalized field names;
- pagination/bounded fetch may be added if inventory volume requires it;
- do not perform an expensive embedding operation on every inventory search interaction;
- text search may use a lightweight/debounced approach;
- semantic discovery Focus remains separate from inventory lookup.

If backend filtering is added, retain a small reusable client-side predicate only if it is generated/shared from the same contract or used strictly for presentation—not as a second definition of truth.

---

# Part 12 — Apply resource and performance safeguards before implementation

Reuse Agent_X's existing runtime environment, resource budget, memory pressure, and hardware-adaptive mechanisms.

Gate B must be able to block/defer or require redesign of candidates whose projected footprint is incompatible with the supported machine/runtime.

At minimum evaluate, where relevant:

- peak/steady RAM;
- CPU intensity;
- thread/process count;
- storage growth;
- dependency footprint;
- model footprint;
- embedding/index cost;
- background frequency;
- startup cost;
- network/provider dependency;
- latency impact;
- UI responsiveness impact.

Avoid architectural choices such as:

- repeated whole-repository scans;
- repeatedly rebuilding embeddings/indexes;
- unbounded caches;
- unbounded history in active memory;
- high-frequency background loops with little user value;
- heavyweight dependencies for trivial behavior.

Prefer:

- incremental updates;
- cached indexes;
- batching;
- bounded queues;
- lazy loading;
- existing shared infrastructure.

Where a candidate's expected benefit does not justify the resource cost, reject it rather than optimizing an unnecessary feature.

Add performance/resource regression tests or bounded probes for code paths where the risk is material.

---

# Part 13 — Version and migrate Harvest state cleanly

Use existing schema/versioning conventions.

Do not silently reinterpret old persisted state.

Required migration areas include:

- legacy `slopLowOnly`;
- new selection-policy fields;
- implementation-mode metadata;
- implementation/completion evidence;
- durable status/history if the previous inventory assumed ephemeral records.

For pre-existing inventory records:

- deterministically backfill fields when the canonical value can be derived;
- otherwise mark the field `UNKNOWN`, `PENDING`, or current equivalent;
- never invent evidence, owner, behavioral delta, or implementation status;
- preserve provenance.

Migration must be idempotent.

---

# Part 14 — Prevent duplicate Harvest inventory and duplicate implementation

Reuse the current semantic duplicate/embedding/digest machinery.

A repeated Harvest run should recognize materially equivalent ideas even when wording differs.

The duplicate model should distinguish:

- same raw proposal;
- same semantic capability;
- same capability already present in Agent_X;
- same capability already implemented from an older Harvest item;
- related but genuinely distinct extension.

Do not simply delete duplicate historical records if they carry useful provenance. Link/merge them where appropriate.

Before implementation, a semantically equivalent already-implemented capability should normally result in `NO_CHANGE` or a merge/extension decision, not another code path.

---

# Part 15 — Keep evidence, slop, value, and implementation authority separate

Do not let a single numeric score become accidental implementation authority.

Preserve conceptual separation:

- Focus relevance → discovery guidance
- Worth/Value/Rank → candidate prioritization
- Evidence/Substance → epistemic quality
- Slop → implementation-quality risk
- Gate A → learn-worthiness / candidate admission
- Agent_X Gap → whether current system lacks meaningful behavior
- Gate B / disposition → implementation decision
- Resource feasibility → supportability
- semantic authorization → permission/order for repository mutation
- stack result + verification → implementation completion

No field should silently substitute for another.

In particular:

- `agentx_status = update/upgrade` or similar metadata is not implementation authority;
- high worth/value is not implementation authority;
- LOW slop is not implementation authority;
- Gate A PASS is not implementation authority;
- an existing inventory label `IMPLEMENT` must still be revalidated before mutation.

---

# Part 16 — UI requirements

## Harvest tab

Make the discovery controls simpler while increasing correctness.

Required changes:

- Search / Exploration Focus clearly behaves as soft guidance.
- Discovery Thresholds / Candidate Criteria expose the meaningful canonical selection dimensions without turning the form into an unreadable wall.
- Use progressive disclosure/grouping if needed.
- Slop Risk is a LOW/MEDIUM/HIGH multi-select matching the visual language of Producers/Harvest selection.
- Selections persist safely.
- Legacy state migrates.
- Criteria summaries make it clear what is currently selected.
- The Start Harvest request serializes the canonical selection policy, not ad hoc unrelated fields.

Do not make the user understand lifecycle internals just to run Harvest.

## Inventory tab

Preserve the useful existing filter model and improve canonicality rather than redesigning it unnecessarily.

Required behavior:

- structured selections find the correct records;
- OR within group, AND across groups;
- status/history can be inspected;
- implementation candidates are clearly distinguishable;
- Implement remains unavailable unless the current backend authority permits it;
- Gate B rationale/owner/mode/blocking reasons are inspectable without excessive clutter.

## Implementation UX

When a user selects Implement:

- perform revalidation;
- if still allowed, dispatch through semantic-first + existing stack;
- if no longer allowed, surface the current reason instead of pushing stale work;
- do not make the user manually move the item through internal systems.

---

# Part 17 — Backend/API requirements

Audit existing Harvest endpoints before adding any new route.

Prefer extending existing endpoints/models.

The API must support, directly or through existing lifecycle calls:

- canonical discovery/candidate-selection policy;
- stage-aware criteria;
- slop allowed set;
- durable inventory query/filtering as needed;
- Gate B implementation decision;
- implementation revalidation;
- semantic-first linkage;
- exact stack dispatch identity;
- implementation completion/failure update;
- item-level cleanup;
- history/status retrieval.

Responses must not claim success before the underlying authoritative operation is complete.

Avoid duplicating business rules in `api_server.py`; keep domain authority in the existing Harvest/collective/semantic/stack owners and use API handlers as adapters.

---

# Part 18 — Tests and acceptance criteria

Do not consider this task complete until these behaviors are proven.

## A. Search / Exploration Focus

- A strong semantic focus improves ranking/discovery relevance.
- Focus does not hard-filter candidates.
- An off-focus but high-quality/high-value candidate can still be discovered.
- Empty focus is neutral.
- No expensive full embedding rebuild occurs on every UI edit.

## B. Selection/threshold semantics

- Every selected canonical field is serialized correctly.
- OR semantics within each multi-select group.
- AND semantics across groups.
- Numeric range boundaries are consistent.
- Unknown late-stage values remain provisional.
- Later-stage failure removes a candidate from the qualifying count.
- Harvest continues bounded discovery to refill the target.
- UI-displayed values equal backend filter/eligibility values.

## C. Slop multi-select

Test all meaningful LOW/MEDIUM/HIGH combinations.

Test legacy migration.

Test candidate-level slop reconciliation after distillation.

## D. Gate B / implementation-worthiness

Fixtures must cover:

- valuable new capability → implement NEW;
- existing but incomplete owner → EXTEND;
- superior replacement of obsolete implementation → REPLACE;
- overlapping candidates → MERGE;
- already implemented equivalent → NO_CHANGE;
- useful knowledge but no code value → no-code result;
- low user value → REJECT/NO_CHANGE as appropriate;
- excessive resource demand → DEFER/REJECT/redesign;
- likely performance regression → blocked;
- unresolved owner → blocked;
- missing behavioral delta → blocked;
- slop/evidence blocker → blocked.

## E. Revalidation

- Previously approved item becomes duplicate after another change → no duplicate implementation.
- Owner changes → authorization updates or blocks.
- Resource state/policy changes → revalidation respects it.
- Stale inventory item cannot bypass current Agent_X state.

## F. Semantic-first order

Prove the actual order:

1. semantic interpretation/target-state update;
2. semantic authorization;
3. code mutation;
4. semantic verification;
5. model reconciliation.

If semantic preparation or authorization fails, code mutation must not occur.

## G. Replacement cleanup

A REPLACE scenario must prove:

- new behavior works;
- callers use the new owner/path;
- obsolete duplicate implementation is gone where safe;
- stale route/config/test artifacts are removed or migrated;
- no double execution remains.

## H. End-to-end wiring

For at least one representative candidate, test:

`Harvest UI/request`
→ `discovery`
→ `distill`
→ `Gate A`
→ `assimilation/Gate B`
→ `implementation revalidation`
→ `semantic-first target`
→ `semantic authorization`
→ `stack`
→ `code`
→ `UI/runtime reachable behavior`
→ `verification`
→ `semantic reconciliation`
→ `inventory terminal completion`
→ `exact stack item removed`

Do not substitute a unit-test-only mock chain for this acceptance proof.

## I. Stack lifecycle

- successful item removes only itself after durable completion;
- failed item is not marked complete;
- stopped item is not marked complete;
- unrelated concurrent Harvest items remain;
- repeated completion callback is idempotent.

## J. Inventory durability

- autonomous Harvest cycle does not destroy completed history;
- completed records remain queryable;
- completed records do not re-enter active implementation queue unless explicitly reopened according to lifecycle rules;
- duplicate future Harvest recognizes prior completion.

## K. Resource/performance

- no material baseline regression for ordinary Harvest UI use;
- no unbounded background work;
- no repeated unnecessary whole-project embedding rebuilds;
- resource-heavy candidates are blocked/deferred before code implementation.

## L. Regression

Run and preserve all relevant existing tests, especially:

- Harvest UI tests;
- collective core Harvest tests;
- assimilation governance tests;
- capability distillation tests;
- coding-loop/write-code e2e tests;
- semantic-first tests;
- stack tests;
- API tests touching Harvest/stack routes;
- broader project tests required by the repository's normal acceptance path.

Do not "fix" failures by weakening assertions that enforce real safety/correctness.

---

# Part 19 — Implementation sequence

Use this order unless the live architecture makes a different ordering clearly safer.

## Phase 0 — Baseline and ownership audit

1. Fetch/inspect current `origin/main`.
2. Record current SHA.
3. Inspect local changes.
4. Read current Harvest UI, API, collective-core Harvest lifecycle, assimilation/Gate B logic, semantic-first public interfaces, stack lifecycle, resource budget/runtime profile, schema/versioning, and tests.
5. Produce an internal map of current owners and data flow.
6. Identify which requirements in this prompt are already satisfied.
7. Do not rewrite satisfied behavior.

## Phase 1 — Canonical Harvest selection policy

1. Define/extend the canonical policy schema.
2. Implement normalization and migration.
3. Define stage-aware predicates.
4. Generalize slop allowed-set behavior.
5. Add backend tests.

## Phase 2 — Harvest UI controls

1. Bind UI to canonical policy.
2. Implement Slop Risk multi-select.
3. Expand/group candidate criteria.
4. Preserve Focus as soft guidance.
5. Migrate persisted local UI state.
6. Add/update UI tests.

## Phase 3 — Inventory query/durability

1. Make filter truth canonical.
2. Fix autonomous destructive inventory clearing if still present.
3. Separate active/actionable view from durable history.
4. Add migration/backfill.
5. Add durability/filter tests.

## Phase 4 — Gate B completion

1. Extend current implementation-worthiness analysis.
2. Add resource/value/use/architecture checks.
3. Add NEW/REPLACE/EXTEND/MERGE decision.
4. Add duplicate/already-satisfied handling.
5. Persist concise rationale/evidence.
6. Add decision tests.

## Phase 5 — Revalidation + semantic-first

1. Add implementation-time current-state revalidation.
2. Route approved Harvest implementation into the canonical semantic-first pipeline.
3. Persist semantic linkage.
4. Fail closed on semantic errors.
5. Add ordering/authorization tests.

## Phase 6 — Stack completion handshake

1. Preserve existing stack execution.
2. Introduce exact item identity/linkage where missing.
3. Update inventory only after verified completion.
4. Remove exact completed stack item.
5. Preserve failed/stopped items according to canonical lifecycle.
6. Eliminate broad Harvest stack clearing if still present.
7. Add concurrency/idempotency tests.

## Phase 7 — End-to-end wiring and cleanup

1. Run representative end-to-end Harvest implementation.
2. Verify UI/runtime usability.
3. Verify semantic reconciliation.
4. Verify durable inventory completion.
5. Verify exact stack cleanup.
6. Remove obsolete/duplicate code from replacements.
7. Remove dead migration-only compatibility code when no longer needed, except where persistent-state migration requires it.

## Phase 8 — Full validation

1. Run targeted suites after each subsystem change.
2. Run full relevant project test suite.
3. Run static/type/lint/build checks used by the repo.
4. Run UI build/tests.
5. Run resource/performance checks.
6. Inspect git diff for accidental changes, duplicate architecture, generated junk, and secrets.
7. Confirm no required behavior remains TODO/unwired.

---

# Part 20 — Anti-slop implementation rules

Reject or rewrite any implementation that exhibits these patterns:

- a new wrapper that only forwards to an existing function;
- a "manager/service/controller" with no unique responsibility;
- duplicate schemas representing the same Harvest state;
- duplicated filter logic in UI and backend with different rules;
- status flags that can contradict the canonical lifecycle;
- boolean shortcuts where the domain is actually a set or enum;
- hard-coded sample inventory pretending to be integration;
- API success responses before authoritative completion;
- unused abstractions "for future extensibility";
- repeated scans where an existing index/cache exists;
- a new dependency for behavior achievable with existing stack/stdlib/project packages;
- orphan feature flags with no lifecycle;
- compatibility layers with no actual caller;
- dead old implementation after REPLACE;
- tests that assert implementation details but not behavior;
- fake resource checks using arbitrary thresholds disconnected from existing runtime policy;
- semantic-first calls added after code mutation merely to satisfy naming requirements;
- marking inventory complete when only stack submission succeeded;
- deleting historical inventory to make active lists clean.

---

# Part 21 — Completion definition

This task is complete only when all of the following are true on the current branch:

- Harvest UI selections reliably control the candidates/inventory found.
- Search / Exploration Focus is soft semantic guidance, not hard precision exclusion.
- Discovery/Candidate criteria are canonical, stage-aware, and aligned with inventory values.
- Slop Risk supports LOW/MEDIUM/HIGH combinations in Harvest with correct migration.
- Gate B decides whether implementation has real value and fit before implementation.
- Gate B chooses NEW/REPLACE/EXTEND/MERGE and correct architectural owner.
- Duplicate, useless, damaging, unsupported, overly complex, and slop candidates do not enter coding.
- Implementation is revalidated against current Agent_X state at click/dispatch time.
- Semantic state is updated/authorized before code mutation through the existing semantic-first pipeline.
- Coding uses the existing stack.
- Approved changes are implemented end to end and are actually reachable/usable.
- Replacement work removes obsolete duplicate implementation where safe.
- Resource limits are respected.
- Successful stack work updates durable inventory completion before exact stack-item removal.
- Failed/stopped work is not falsely completed.
- Autonomous Harvest no longer erases durable completion history.
- Historical implemented items prevent future duplicate implementation.
- Existing lifecycle/governance protections remain intact.
- All relevant tests/builds pass.
- No duplicate Harvest/semantic/stack architecture was introduced.

---

# Historical evidence boundary

This September 2026 Agent_X execution prompt is archival research, not a live DT worker instruction. The retained lifecycle, criteria, tests and completion definition above are design hypotheses requiring current-DT parity and authorized execution verification. The former post-execution report template (baseline SHA, files, migrations, tests, end-to-end proof, resource bounds and remaining risks) was administrative boilerplate, not independent implementation evidence. Original text remains recoverable at Git blob `c24cb33bdaee5d529711b360fcce5881851ba6d4`.
