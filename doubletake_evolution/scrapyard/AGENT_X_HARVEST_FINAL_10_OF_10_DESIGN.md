# AGENT_X HARVEST — Final 10/10 Design Specification

**Semantic-first capability assimilation with hard decision gates, replacement discipline, transactional activation, and end-to-end verification**

- **Status:** FINAL DESIGN SPECIFICATION
- **Design rating:** 10/10 as a specification, conditional on implementation conformance
- **Version:** 1.0
- **Date:** 2026-09-11
- **System:** AGENT_X / Harvest

---

## 1. Purpose

Harvest exists to discover useful capabilities, algorithms, patterns, and implementation ideas from inventory; determine whether AGENT_X should contain them at all; place approved capabilities into the correct semantic and architectural location; implement only the minimum code required; replace or supersede obsolete logic rather than accumulating duplicate machinery; wire the result into the real production system; and prove that the resulting system remains coherent under normal execution, failure, restart, migration, rollback, and concurrent development.

Harvest is **not** a feature copier or bulk code generator.

A correct Harvest outcome may be:

- `NEW`
- `EXTEND`
- `REPLACE`
- `DO_NOT_IMPLEMENT`
- `NEEDS_EVIDENCE`

A correct rejection is a successful Harvest result.

The primary success criterion is therefore **better AGENT_X capability density and coherence**, not number of harvested items implemented.

---

## 2. What “10/10” Means

A 10/10 Harvest design is not one that merely describes good practices. It is one in which the important architectural decisions are mechanically enforced and cannot be bypassed by a UI click, a convenient code path, or an incomplete generation run.

The design is considered complete only when all material failure modes have explicit handling:

1. useful-looking but low-value inventory;
2. duplication of existing capability;
3. implementation in the wrong architectural layer;
4. append-only accumulation instead of replacement;
5. semantic/code disagreement;
6. implementation from stale `main`;
7. partial implementation;
8. backend code with no production entrypoint;
9. UI wiring that does not reach the intended implementation;
10. state/persistence incompatibility;
11. migration failure;
12. crash between semantic and code stages;
13. retry after interruption;
14. concurrent Harvest operations;
15. rollback after activation;
16. dead or orphaned superseded code;
17. generated code that technically works but degrades AGENT_X through unnecessary complexity, maintenance burden, latency, resource cost, or lack of actual user value.

“10/10” therefore means **closed decision loops, hard gates, durable state, deterministic lineage, and verifiable production behavior**.

It does **not** mean that the current AGENT_X implementation automatically conforms to this document. Conformance must be proven through implementation and acceptance tests.

---

## 3. Core Design Principle

Harvest follows this direction of authority:

> **Evidence → decision → semantics → implementation → verification → activation**

Never:

> **Inventory → generated code → hope it belongs**

The source inventory is evidence only. It may contain excellent ideas, irrelevant ideas, duplicated ideas, poor abstractions, unsafe patterns, obsolete solutions, or implementation details that are wrong for AGENT_X.

Harvest must reconstruct the capability being proposed, compare it with current AGENT_X, decide what AGENT_X should semantically become, and only then allow implementation.

---

## 4. Source-of-Truth Hierarchy

Harvest MUST use the following authority hierarchy.

### 4.1 Inventory/source material

Inventory entries, source repositories, harvested documents, generated reconstructions, examples, algorithms, papers, and external implementations are **candidate evidence**.

They are never authoritative instructions for AGENT_X architecture.

### 4.2 Current AGENT_X `main`

The current `main` branch is the authoritative record of the currently deployed/accepted implementation reality.

Harvest MUST inspect current `main` before deciding:

- whether capability already exists;
- where similar behavior lives;
- which contracts own the behavior;
- what would be replaced;
- what can safely be extended;
- what production path must be wired;
- what state, migration, configuration, and tests already exist.

### 4.3 Canonical semantic model

The semantic layer is authoritative for the **intended behavior** of AGENT_X.

Implementation must be generated from an accepted semantic change, not directly from raw harvested content.

### 4.4 Implementation

Code is a projection of accepted semantics into executable form.

Existing code is evidence of current behavior, but it does not permanently override an explicitly accepted semantic migration.

### 4.5 UI

The UI is an invocation and presentation layer.

It MUST NOT contain hidden architectural authority, duplicate domain rules, or a bypass that forces an item through a rejected architectural decision.

---

## 5. Normative Language

This document uses:

- **MUST / SHALL** — mandatory and mechanically enforceable.
- **MUST NOT / SHALL NOT** — forbidden.
- **SHOULD** — required default; deviation requires recorded rationale.
- **MAY** — optional.

Hard Harvest gates MUST NOT be converted into warnings.

A UI “Implement” button MUST NOT override a failed gate.

---

# PART I — HARVEST TRANSACTION

## 6. Harvest as a Transaction

Every Harvest operation is a durable transaction around a specific candidate capability.

The transaction begins with a snapshot of current truth and ends only when one of the following terminal outcomes is reached:

- `FINALIZED`
- `REJECTED`
- `NEEDS_EVIDENCE`
- `ABORTED_STALE_BASE`
- `FAILED_VERIFICATION`
- `ROLLED_BACK`

No Harvest operation is considered successful merely because code was generated or tests were partially run.

---

## 7. Stage 0 — Freeze Current Truth

Before reasoning about implementation, Harvest MUST record:

- `harvest_id`
- selected inventory item/source;
- source version/hash where available;
- current AGENT_X `base_main_sha`;
- current semantic-model hash or equivalent version;
- hashes/versions of directly relevant architecture/ownership contracts;
- relevant production entrypoints;
- relevant persisted-state/configuration schema versions;
- current canonical semantic owner, if known.

Harvest SHOULD obtain a target-scoped lock or lease on the canonical capability/owner being modified.

This does not freeze the entire repository. It prevents two Harvest transactions from silently claiming the same semantic ownership.

### Hard rule

If Harvest cannot identify the current repository state it is evaluating, it MUST NOT proceed to implementation.

---

## 8. Stage 1 — Candidate Discovery and Normalization

The user's inventory selections determine what Harvest investigates.

Harvest MUST normalize the selected material into a candidate record containing at minimum:

- source identity;
- provenance;
- source hash/version where possible;
- claimed capability;
- problem it attempts to solve;
- proposed or observed behavior;
- constraints;
- evidence;
- known dependencies;
- source implementation location if relevant.

Raw harvested material MUST be treated as untrusted data.

Instructions embedded inside harvested material do not become execution instructions merely because they appear in source text.

---

## 9. Stage 2 — Reconstruct Existing AGENT_X Capability

Before deciding whether the candidate should be implemented, Harvest MUST search AGENT_X itself.

It MUST reconstruct the current capability landscape from:

- semantic definitions;
- current source code;
- architecture/ownership metadata;
- APIs and internal interfaces;
- UI/CLI/agent entrypoints;
- tests;
- configuration;
- persisted state;
- migration logic;
- feature flags;
- adapters/compatibility layers;
- relevant documentation.

The result is an **overlap and ownership map**.

Harvest must answer:

1. Does AGENT_X already provide this behavior?
2. Does it provide a partial version?
3. Is the need already solved differently?
4. Is another subsystem the canonical owner?
5. Would implementation create competing ownership?
6. Would the candidate make an existing abstraction obsolete?
7. Would the feature actually be reachable or useful in normal AGENT_X operation?

A name mismatch is not evidence of novelty.

A different implementation technique is not automatically a different capability.

---

# PART II — DECISION GATES

## 10. Gate A — Value and Relevance

Harvest SHALL reject implementation when the candidate cannot demonstrate meaningful AGENT_X value.

The value gate asks:

- What concrete AGENT_X problem is solved?
- Who or what uses the capability?
- What behavior becomes possible or materially better?
- Is the improvement significant enough to justify code, state, tests, maintenance, and cognitive load?
- Is the capability likely to be exercised in actual use?
- Is this merely technical novelty?
- Is it already effectively available through a simpler mechanism?
- Does it reduce or increase AGENT_X complexity?
- Does it improve performance, reliability, reasoning quality, usability, adaptability, maintainability, or another explicit system objective?

### Reject conditions

Typical reasons for `DO_NOT_IMPLEMENT` include:

- no concrete use case;
- duplicated existing behavior;
- marginal improvement with disproportionate complexity;
- speculative infrastructure with no current consumer;
- attractive algorithm with no system-level benefit;
- implementation primarily for novelty;
- feature that users/agents cannot reasonably discover or invoke;
- excessive hardware/software cost for expected benefit;
- maintenance burden greater than capability value;
- candidate solves a source-system problem AGENT_X does not have.

A candidate does not earn implementation merely because it is technically sound.

---

## 11. Gate B — Semantic and Architectural Fit

An item that passes Gate A does **not** automatically qualify for implementation.

Gate B SHALL classify the candidate into exactly one semantic action:

- `REJECT`
- `NEW`
- `EXTEND`
- `REPLACE`
- `NEEDS_EVIDENCE`

Before any implementation is allowed, Gate B MUST establish all of the following.

### 11.1 Distinct value

The capability provides a meaningful improvement not already satisfied by the current system.

### 11.2 Canonical semantic owner

One and only one AGENT_X semantic capability/subsystem is identified as the canonical owner.

### 11.3 Architectural placement

The correct implementation layer, module family, integration boundary, and production entrypoint are known.

The source repository's architecture MUST NOT be copied merely because it is the source architecture.

### 11.4 Non-duplication

Harvest has determined whether the capability:

- already exists;
- partially exists;
- overlaps another mechanism;
- supersedes another mechanism.

### 11.5 Supersession plan

For `EXTEND` and `REPLACE`, Harvest has an explicit plan for the existing semantic definitions, code, call sites, tests, configuration, state, migrations, UI paths, and compatibility layers affected.

### 11.6 Complexity budget

The expected benefit is greater than the added:

- implementation complexity;
- state complexity;
- latency;
- resource usage;
- dependency burden;
- operational burden;
- maintenance burden;
- user-facing complexity.

### 11.7 Failure and rollback model

Harvest understands what happens if:

- implementation fails;
- activation fails;
- migration partially fails;
- the process crashes;
- a retry occurs;
- rollback is required.

### 11.8 Objective testability

Acceptance criteria can be proven through executable checks or clearly verifiable system behavior.

### 11.9 Production reachability

The intended real production entrypoint is identified.

A module existing in the repository is not sufficient.

### 11.10 Persistence/migration correctness

If behavior touches durable state, its schema, migration, downgrade/rollback behavior, and restart semantics are known.

### 11.11 Current-main freshness

The assumptions used by Gate B still match current `main`.

### Hard decision rule

If any required Gate B proof is missing, the item SHALL NOT proceed to code generation.

The result must be either:

- `DO_NOT_IMPLEMENT`, or
- `NEEDS_EVIDENCE`.

There is no “implement anyway” path.

---

# PART III — REPLACEMENT, NOT ACCUMULATION

## 12. Mandatory Supersession Discipline

Harvest MUST prefer coherent replacement or extension of the current canonical capability over creation of parallel machinery.

Every `REPLACE` or `EXTEND` decision MUST enumerate what happens to:

- old semantic definitions;
- old implementation modules;
- old exported symbols;
- old routing;
- old UI behavior;
- old tests;
- old configuration;
- old state;
- old migrations;
- old feature flags;
- old documentation;
- old adapters;
- old compatibility paths.

### Core invariant

There SHALL be one canonical implementation path for a behavior unless a deliberately time-bounded compatibility path is documented.

### Compatibility shims

A compatibility shim MAY remain only if its record contains:

- explicit reason;
- owner;
- callers depending on it;
- tests;
- expiry/removal condition;
- removal plan.

A compatibility shim is not a permanent excuse for duplicate systems.

### Reference proof

Before finalization, Harvest MUST perform appropriate reference/call-site scans proving that superseded paths are removed or appear only on an explicit allowlist.

---

## 13. No “V2” Junk Pile

Harvest MUST NOT create parallel structures such as:

- `new_*`
- `*_v2`
- replacement managers/controllers/services beside the old ones;
- duplicate registries;
- duplicate semantic owners;
- alternate persistence paths;

merely to avoid understanding or modifying the existing architecture.

A new parallel architecture is allowed only as part of an explicitly approved migration with:

- migration boundary;
- interoperability plan;
- cutover criteria;
- removal criteria for old architecture.

The default is to modify the canonical existing stack.

---

# PART IV — SEMANTIC-FIRST WITHOUT SPLIT-BRAIN

## 14. Semantic Proposal

Once Gate B approves a direction, Harvest creates a semantic delta.

The semantic proposal MUST describe the desired behavior independently of incidental source implementation details.

It SHOULD include, where relevant:

- capability purpose;
- inputs;
- outputs;
- contracts;
- invariants;
- state transitions;
- ownership;
- lifecycle;
- error behavior;
- failure behavior;
- permissions/safety boundaries;
- dependencies;
- performance constraints;
- persistence behavior;
- migration behavior;
- production invocation path;
- compatibility implications;
- superseded semantics.

---

## 15. Semantic Acceptance Checkpoint

The semantic delta is reviewed/validated and, if accepted, stored as an immutable checkpoint:

`SEMANTIC_ACCEPTED_PENDING_IMPLEMENTATION`

This is crucial.

“Semantic first” MUST NOT mean that the new semantic truth becomes globally active while implementation still reflects the old system.

The accepted semantic checkpoint authorizes code generation, but it is not yet the active production semantic state.

The checkpoint receives a stable content hash.

All subsequent implementation planning and code generation MUST bind to that hash.

---

## 16. Semantic-to-Code Authority Rule

After semantic acceptance:

> The accepted semantic checkpoint, current AGENT_X architecture, and current-main implementation contracts are authoritative for implementation.

Raw harvested source content MAY be consulted as evidence for algorithms, techniques, edge cases, or implementation ideas, but MUST NOT override the accepted semantic specification.

This prevents source architecture from leaking into AGENT_X merely because it was harvested.

---

# PART V — IMPLEMENTATION

## 17. Implementation Plan

Harvest translates the semantic delta into an explicit implementation plan.

The plan SHALL map:

- semantic change → canonical module(s);
- semantic contracts → interfaces;
- semantic state → persistence/migrations;
- semantic behaviors → tests;
- semantic entrypoint → UI/API/CLI/agent wiring;
- semantic supersession → files/symbols/routes/state to remove or modify.

The plan MUST also record:

- files expected to change;
- files expected to disappear;
- tests expected to change/add/remove;
- migration operations;
- production entrypoints;
- forbidden duplicate implementation locations.

Implementation SHOULD minimize new code.

A smaller coherent change is preferred over a generalized framework unless the framework is itself justified by current, demonstrated needs.

---

## 18. Isolated Code Staging

Implementation MUST occur in an isolated branch/worktree/change set rather than mutating production state piecemeal.

The staged implementation MUST:

- conform to the accepted semantic checkpoint;
- use the canonical architecture;
- avoid duplicate ownership;
- perform required replacement/removal;
- include required migration logic;
- include production wiring;
- include tests.

Generated code that compiles but is not connected to actual production behavior is incomplete.

---

# PART VI — VERIFICATION

## 19. Verification Is Multi-Layered

Harvest SHALL verify more than syntax and unit tests.

The relevant verification stack includes:

1. syntax/compile checks;
2. formatting/lint/static analysis where applicable;
3. type checks where applicable;
4. unit tests;
5. semantic contract tests;
6. subsystem integration tests;
7. cross-subsystem integration tests;
8. real production-entrypoint tests;
9. UI/API/CLI/agent end-to-end tests;
10. serialization/deserialization tests;
11. persistence tests;
12. migration tests;
13. restart tests;
14. retry/idempotency tests;
15. failure-injection tests;
16. rollback tests;
17. supersession/reference scans;
18. stale-main/concurrency tests;
19. dependency/security policy checks;
20. clean-tree/unexplained-file checks.

Not every capability needs every test class, but omitted classes require a reason when they would logically apply.

---

## 20. Production-Path Proof

For user-facing or agent-facing capabilities, Harvest MUST prove the complete production path.

Example:

> user/agent action → UI/API/command → routing → domain capability → persistence/state if applicable → result → presentation

Passing a direct Python call or isolated service test is not equivalent to production-path verification.

The final acceptance evidence MUST identify the tested production entrypoint.

---

## 21. Failure Injection

Harvest MUST test critical failure boundaries where applicable, including failures:

- after semantic staging;
- after semantic acceptance;
- during code staging;
- during migration;
- after code verification but before activation;
- during activation;
- after partial external side effect where relevant.

The intended result is never an ambiguous half-active capability.

---

# PART VII — CURRENT-MAIN DRIFT

## 22. Freshness Gate

Harvest records `base_main_sha` at analysis time.

Before:

1. semantic acceptance;
2. implementation generation/staging;
3. final activation;

Harvest MUST compare current `main` with the recorded base and determine whether relevant assumptions changed.

### Irrelevant drift

If `main` moved only in unrelated areas, Harvest MAY rebase and continue after recording the evidence.

### Relevant drift

If changes affect:

- the canonical owner;
- touched code;
- semantic contracts;
- interfaces;
- state schema;
- dependencies;
- routing;
- UI production path;
- superseded behavior;

Harvest MUST invalidate the affected analysis and rerun the relevant gates.

A stale plan SHALL NOT finalize merely because its code still merges cleanly.

---

## 23. Concurrency

Two Harvest transactions MUST NOT silently modify the same canonical semantic ownership simultaneously.

Use target-scoped locking/leases or equivalent deterministic conflict detection.

If ownership conflicts, one transaction must:

- wait,
- rebase/re-analyze, or
- abort.

Automatic last-writer-wins behavior is forbidden for semantic ownership.

---

# PART VIII — DURABILITY, RESTART, AND ROLLBACK

## 24. Durable State Machine

Each Harvest transaction MUST use a durable state machine.

Recommended states:

```text
DISCOVERED
  ↓
ANALYZED
  ↓
┌─────────────────────┬────────────────────┬────────────────────┬─────────────────────┐
│ REJECTED            │ NEEDS_EVIDENCE     │ APPROVED_NEW       │ APPROVED_EXTEND /   │
│                     │                    │                    │ APPROVED_REPLACE    │
└─────────────────────┴────────────────────┴────────────────────┴─────────────────────┘
                                              ↓
                                      SEMANTIC_STAGED
                                              ↓
                              SEMANTIC_ACCEPTED_PENDING_IMPLEMENTATION
                                              ↓
                                         CODE_STAGED
                                              ↓
                                          VERIFIED
                                              ↓
                                     WIRING_VERIFIED
                                              ↓
                                    READY_TO_ACTIVATE
                                              ↓
                                         FINALIZED
```

Exceptional terminal/interruption states include:

```text
ABORTED_STALE_BASE
FAILED_VERIFICATION
ROLLED_BACK
```

Transitions MUST be validated.

Stages MUST NOT be silently skipped.

---

## 25. Restart Safety

Every durable stage records enough information to determine whether that stage actually completed.

On restart Harvest MUST reconcile:

- state-machine record;
- repository/worktree state;
- hashes;
- semantic checkpoint;
- implementation plan;
- generated/staged code;
- migration status;
- verification evidence;
- activation state.

Harvest MUST NOT infer successful completion merely because a stage was started.

---

## 26. Idempotency

Retried operations MUST be safe.

Where possible, stage artifacts should be content-addressed or tied to stable hashes.

Re-running a completed deterministic stage against the same inputs SHOULD return/reuse the same result rather than duplicating work or creating additional semantic/code objects.

---

## 27. Rollback

Activation MUST have an explicit rollback strategy.

Rollback must restore a coherent semantic + implementation state.

If persistent-state migration is not directly reversible, Harvest MUST define a compensating migration or another verified rollback strategy before activation.

A feature with no credible recovery path from foreseeable activation failure SHALL NOT activate.

---

# PART IX — ATOMIC ACTIVATION

## 28. The Semantic/Implementation Truth Boundary

The most important correction to naive semantic-first implementation is the activation boundary.

The new semantic state MUST NOT become active before its implementation exists and is verified.

The new implementation MUST NOT become production-authoritative while the old semantic model remains active.

Therefore final activation is a logical transaction:

> **accepted semantic checkpoint + verified implementation + verified wiring + migrations + tests → active semantic/code state**

If activation fails, the system must either:

- remain on the previous coherent active state, or
- complete a deterministic rollback.

There SHALL NOT be a durable state in which production semantics say one thing and executable production behavior knowingly implements another.

---

# PART X — USER INTERFACE

## 29. Inventory Discovery UI

The UI SHALL allow the user to find inventory based on relevant selections and filters.

Search/filter behavior should make it practical to locate candidate capabilities without exposing unnecessary Harvest internals.

The inventory UI provides source selection only.

It does not determine implementation eligibility.

---

## 30. Decision UI

For a selected candidate, the primary Harvest view SHOULD show only the information necessary to understand and act on the decision:

- candidate;
- current AGENT_X equivalent/overlap;
- decision:
  - `Do not implement`
  - `Replace`
  - `Extend`
  - `New`
  - `Needs evidence`
- concise reason;
- semantic target/owner;
- what would be superseded;
- important risk/migration note;
- verification status;
- current-main freshness status.

Detailed graphs, evidence, tests, diffs, and lineage SHOULD be available through progressive disclosure.

---

## 31. “Implement” Button Semantics

The Implement action does not mean:

> “Generate code regardless of the architectural decision.”

It means:

> “Continue the already-approved Harvest transaction through semantic checkpoint, implementation, verification, and activation.”

If Gate A or Gate B rejects the candidate, implementation controls MUST be disabled for that decision state.

If the user provides new evidence or challenges the decision, Harvest may rerun the analysis.

That is a new decision input, not a bypass.

---

## 32. End-to-End UI Wiring

When an approved capability is meant to be user accessible, Harvest MUST wire it through the existing real UI rather than creating disconnected implementation.

The verification must cover:

- UI control/action;
- frontend state;
- request/command contract;
- routing;
- backend capability;
- data transformation;
- persistence, if any;
- result/error return;
- rendered/user-visible outcome.

Domain decisions MUST remain outside the UI layer.

---

# PART XI — DATA MODEL AND LINEAGE

## 33. Harvest Change-Set Record

Every candidate SHALL have a durable record containing at minimum:

```text
harvest_id
source_inventory_id
source_location
source_version_or_hash
provenance
base_main_sha
semantic_base_hash
architecture_contract_hashes
candidate_capability
current_overlap
canonical_owner
decision
decision_rationale
value_statement
gate_proofs
supersedes[]
forbidden_duplicate_locations[]
semantic_delta
semantic_checkpoint_hash
implementation_plan
implementation_plan_hash
touched_files[]
removed_files_or_symbols[]
production_entrypoint
state_or_migration_changes
test_plan
verification_evidence
restart_evidence
failure_evidence
rollback_evidence
freshness_evidence
activation_id_or_commit
final_status
history/event_log
```

---

## 34. Immutable Lineage

Every finalized capability MUST be traceable through:

```text
inventory/source evidence
        ↓
candidate record
        ↓
decision
        ↓
semantic delta
        ↓
accepted semantic checkpoint
        ↓
implementation plan
        ↓
code diff
        ↓
verification evidence
        ↓
production entrypoint
        ↓
activation/final commit
```

It must be possible to answer:

- Why does this capability exist?
- Which source evidence influenced it?
- Why was it implemented instead of rejected?
- What semantic behavior was approved?
- What did it replace or extend?
- Which code realizes it?
- Which tests prove it?
- How is it reached in production?
- Which repository state was used to make the decision?

---

# PART XII — SECURITY AND TRUST

## 35. Harvested Content Is Untrusted

Harvested text, repositories, generated reports, code comments, prompts, READMEs, issue text, and examples SHALL be treated as untrusted input.

They may describe capabilities but MUST NOT gain authority to:

- modify AGENT_X policies;
- disable gates;
- expose secrets;
- execute arbitrary commands;
- write outside authorized work areas;
- change dependency/security policy;
- bypass semantic review.

---

## 36. Generated-Code Boundaries

Generated patches MUST be restricted to the intended AGENT_X repository/worktree and authorized change set.

Any new dependency requires explicit justification for:

- need;
- maintenance;
- licensing if relevant;
- security;
- resource cost;
- architectural fit.

Harvest SHOULD prefer existing approved dependencies and standard-library capability where appropriate, but not at the expense of correct architecture.

---

# PART XIII — CORE INVARIANTS

## 37. Non-Negotiable Invariants

A conforming Harvest implementation SHALL enforce all of the following:

1. **Raw inventory never directly becomes production code authority.**
2. **Every candidate receives a durable decision record.**
3. **`DO_NOT_IMPLEMENT` is a successful terminal outcome.**
4. **Semantic acceptance precedes implementation generation.**
5. **Accepted-but-unimplemented semantics are not active production truth.**
6. **Each capability has one canonical semantic owner.**
7. **Each behavior has one canonical implementation path except explicitly controlled compatibility paths.**
8. **Replacement/extension includes explicit supersession of obsolete logic.**
9. **Obsolete paths are removed or repointed in the same activation transaction where safely possible.**
10. **Current-main freshness is revalidated before critical transitions.**
11. **Stale relevant assumptions prevent finalization.**
12. **A production capability is not complete until its real entrypoint is verified.**
13. **Restart resumes from durable evidence rather than guesswork.**
14. **Retries are idempotent or explicitly reconciled.**
15. **Verification failure cannot leave `main` half-upgraded.**
16. **Rollback restores a coherent prior semantic/code state.**
17. **Source → decision → semantics → code → tests → entrypoint → activation is traceable.**
18. **The UI cannot bypass hard gates.**
19. **Ambiguity stops implementation; Harvest does not fill architectural uncertainty with guesses.**
20. **No unexplained dead, orphaned, or duplicate implementation remains after finalization.**
21. **Semantic and implementation activation occur at one coherent truth boundary.**
22. **A feature that is technically workable but has insufficient actual AGENT_X value is rejected.**
23. **A source architecture is never copied merely because the capability originated there.**
24. **Implementation complexity must be proportional to demonstrated benefit.**

---

# PART XIV — TEST MATRIX

## 38. Required Test Categories

The Harvest platform itself SHOULD have automated tests for the following classes.

| # | Test class | Required behavior |
|---|---|---|
| 1 | Duplicate decision | Existing equivalent capability results in rejection or explicit extension/replacement, never silent duplication |
| 2 | Low-value decision | Technically viable but unjustified capability is rejected |
| 3 | Semantic contract | Implementation satisfies accepted semantic contracts/invariants |
| 4 | Canonical ownership | Only one owner is selected; conflicting ownership blocks |
| 5 | Unit | Changed low-level behavior works |
| 6 | Integration | Changed components interoperate |
| 7 | Production entrypoint | Real UI/API/CLI/agent path reaches intended capability |
| 8 | Supersession | Old references are removed/repointed |
| 9 | Persistence | New behavior survives valid restart/state reload |
| 10 | Migration | Existing state is correctly transformed |
| 11 | Restart by phase | Crash/restart at each durable phase resumes safely |
| 12 | Failure injection | Partial stage failures cannot activate inconsistent state |
| 13 | Rollback | Previous coherent state is recoverable |
| 14 | Stale main | Relevant changes to `main` invalidate old analysis |
| 15 | Concurrent harvest | Same-owner transactions conflict deterministically |
| 16 | Retry/idempotency | Repetition does not duplicate artifacts or side effects |
| 17 | Negative/error | Invalid inputs and expected failures preserve contracts |
| 18 | Security | Harvested instructions cannot bypass policy/gates |
| 19 | Dependency policy | New dependency cannot appear without explicit approval evidence |
| 20 | Clean tree | No unexplained generated/dead files remain |
| 21 | Semantic activation | Accepted pending semantics do not become active before verified code |
| 22 | Atomic activation | Semantic/code activation cannot leave split-brain state |

---

# PART XV — OBSERVABILITY AND QUALITY

## 39. Event Log

Every material Harvest transition SHOULD create an immutable or append-only event containing:

- `harvest_id`;
- transition;
- timestamp;
- inputs/hashes;
- decision;
- actor/process where applicable;
- result;
- failure information;
- resulting state.

This is not verbose user-facing logging. It is evidence for debugging, audit, restart, and architectural analysis.

---

## 40. Quality Metrics

Harvest SHOULD track metrics that measure architectural quality rather than output volume.

Useful metrics include:

- duplicate candidates rejected;
- low-value candidates rejected;
- candidates classified `REPLACE`/`EXTEND` rather than duplicated;
- stale-base abort/reanalysis count;
- failed verification count;
- rollback count;
- semantic↔code drift incidents;
- orphan/dead/superseded reference count;
- production-entrypoint pass rate;
- restart recovery pass rate;
- post-activation regressions;
- average code added versus code removed for replacements;
- net capability value versus implementation complexity.

Do **not** treat:

- number of generated files;
- number of lines added;
- number of harvested entries implemented;

as primary success metrics.

---

# PART XVI — DEFINITION OF DONE

## 41. Per-Candidate Definition of Done

A Harvest candidate is `FINALIZED` only when all applicable items below are true:

- [ ] source/provenance recorded;
- [ ] `base_main_sha` recorded;
- [ ] current semantic/architecture versions recorded;
- [ ] AGENT_X overlap/capability search completed;
- [ ] value gate passed;
- [ ] canonical semantic owner identified;
- [ ] architectural placement identified;
- [ ] decision is explicitly `NEW`, `EXTEND`, or `REPLACE`;
- [ ] non-duplication proof completed;
- [ ] supersession plan completed where applicable;
- [ ] semantic delta created;
- [ ] semantic checkpoint accepted and hashed;
- [ ] implementation plan generated from accepted semantics;
- [ ] implementation staged in canonical architecture;
- [ ] obsolete implementation removed/repointed where applicable;
- [ ] migration/state handling completed where applicable;
- [ ] relevant static/unit/contract tests pass;
- [ ] relevant integration tests pass;
- [ ] production entrypoint verified;
- [ ] UI wiring verified when applicable;
- [ ] persistence/restart verified when applicable;
- [ ] failure handling verified when applicable;
- [ ] retry/idempotency verified when applicable;
- [ ] rollback verified when applicable;
- [ ] current-main freshness revalidated;
- [ ] concurrency/ownership conflict absent;
- [ ] duplicate/reference scan passes;
- [ ] repository contains no unexplained generated/dead artifacts;
- [ ] activation succeeds atomically;
- [ ] active semantics match active deployed behavior;
- [ ] immutable lineage/evidence bundle is complete.

If an applicable item is not proven, the candidate is not final.

---

# PART XVII — EXAMPLE DECISIONS

## 42. Existing Equivalent Capability

**Candidate:** Harvest finds an algorithm that appears novel.

**AGENT_X analysis:** Equivalent behavior already exists under a different name and architecture.

**Decision:** `DO_NOT_IMPLEMENT`.

**Reason:** Implementation would duplicate capability and increase maintenance without new value.

This is a successful Harvest outcome.

---

## 43. Better Replacement for Existing Logic

**Candidate:** Harvest finds a demonstrably better scheduling algorithm.

**AGENT_X analysis:** Current scheduler owns the behavior and can be replaced without introducing a second scheduling subsystem.

**Decision:** `REPLACE`.

Harvest must:

1. update scheduler semantics;
2. define changed invariants;
3. stage implementation in current scheduler ownership;
4. migrate configuration/state if required;
5. repoint callers;
6. remove old algorithm;
7. run comparative tests;
8. verify production scheduling path;
9. activate semantics and implementation together.

---

## 44. Useful Capability, Wrong Source Architecture

**Candidate:** Source uses a dedicated manager/service hierarchy.

**AGENT_X analysis:** The behavior belongs inside an existing canonical subsystem and requires no new service.

**Decision:** `EXTEND`.

Harvest takes the capability, not the source architecture.

---

## 45. Technically Valid but Unnecessary Feature

**Candidate:** Implementation is easy and tests cleanly.

**AGENT_X analysis:** No current agent/user path needs it; it introduces state and maintenance.

**Decision:** `DO_NOT_IMPLEMENT`.

Technical feasibility is insufficient.

---

## 46. Incomplete Persistence Understanding

**Candidate:** Valuable feature modifies long-lived state.

**AGENT_X analysis:** Migration/rollback consequences cannot yet be proven.

**Decision:** `NEEDS_EVIDENCE`.

No code activation occurs until persistence behavior is resolved.

---

## 47. Main Changes Mid-Harvest

**Candidate:** Approved replacement is being implemented.

**Event:** `main` changes in the same canonical subsystem before activation.

**Decision:** `ABORTED_STALE_BASE` or return to the relevant analysis stage.

A clean merge is not enough; the semantic assumptions must be revalidated.

---

## 48. Unit Tests Pass, UI Does Not

**Candidate:** Backend capability passes all direct tests.

**Event:** Existing production UI still routes to the superseded behavior.

**Decision:** `FAILED_VERIFICATION`.

No activation.

---

## 49. Crash After Semantic Acceptance

**Candidate:** Semantic checkpoint is accepted but code has not completed.

**Event:** Process crashes.

**Restart behavior:** Harvest resumes from `SEMANTIC_ACCEPTED_PENDING_IMPLEMENTATION`.

The semantic proposal remains durable evidence but is not active production truth.

---

# PART XVIII — HARVEST UI WORKFLOW

## 50. User-Level Flow

The intended high-level UI should remain simple:

```text
Find inventory
    ↓
Select candidate
    ↓
Harvest analyzes AGENT_X + candidate
    ↓
Decision appears
    ├── Do not implement
    ├── Needs evidence
    ├── New
    ├── Extend
    └── Replace
              ↓
        Semantic proposal
              ↓
        Approved transaction continues
              ↓
        Implementation + verification
              ↓
        Final result
```

The user should not need to manually perform architectural bookkeeping that Harvest can prove automatically.

Automation should reduce interaction, not hide architectural evidence.

---

## 51. What the User Should Not Have to Manage

The normal user SHOULD NOT be required to manually decide:

- target source file;
- class placement;
- import layout;
- dependency graph;
- migration sequencing;
- redundant-code removal;
- exact test files;
- restart checkpointing;
- superseded reference scans;
- repository freshness comparisons.

Harvest owns this technical analysis.

The user may inspect details, but correctness must not depend on the user discovering every hidden implementation consequence.

---

# PART XIX — IMPLEMENTATION ORDER FOR AGENT_X

## 52. Recommended Construction Sequence

The safest implementation order is:

### Phase 1 — Durable change-set and state machine

Implement:

- Harvest transaction record;
- durable states;
- event log;
- hash/provenance fields;
- restart reconciliation.

### Phase 2 — Hard decision gates

Implement:

- capability overlap search;
- value gate;
- canonical ownership detection;
- `DO_NOT_IMPLEMENT`;
- `NEEDS_EVIDENCE`;
- `NEW` / `EXTEND` / `REPLACE`.

No code generation should bypass these gates.

### Phase 3 — Semantic transaction

Implement:

- semantic delta staging;
- accepted semantic checkpoint;
- semantic checkpoint hash;
- `ACCEPTED_PENDING_IMPLEMENTATION`;
- activation separation between accepted and active semantics.

### Phase 4 — Supersession and semantic-to-code planning

Implement:

- overlap/supersession map;
- implementation-plan derivation;
- forbidden duplicate locations;
- removal/repoint plan.

### Phase 5 — Isolated implementation and verification

Implement:

- worktree/branch staging;
- implementation generation;
- test harness;
- reference scans;
- migration checks;
- security/dependency checks.

### Phase 6 — Production-path verification

Implement:

- existing UI/API/CLI/agent integration;
- real entrypoint tests;
- persistence/restart;
- failure injection;
- rollback;
- stale-main tests.

### Phase 7 — Atomic activation and observability

Implement:

- final freshness gate;
- coherent semantic + code activation;
- final lineage bundle;
- quality metrics;
- rollback evidence.

---

# PART XX — 8.5/10 → 10/10 CLOSURE

## 53. What Was Already Strong

The earlier Harvest design already had the right central direction:

- inventory discovery and selection;
- semantic-first thinking;
- architecture/placement analysis;
- implement-versus-reject reasoning;
- replacement rather than blind addition;
- concern for actual user/system value;
- end-to-end UI integration;
- verification against current AGENT_X rather than source assumptions.

Those principles are strong enough for an approximately 8.5/10 design.

---

## 54. What Closes the Remaining Gap

| Earlier strength | 10/10 closure |
|---|---|
| Semantic-first | Separate **semantic acceptance** from **semantic activation** so code and semantics cannot become split-brain |
| Decide whether to implement | Make decision gates mechanically non-bypassable; rejection becomes a first-class success |
| Avoid junk pileups | Require explicit `NEW` / `EXTEND` / `REPLACE` classification and mandatory supersession proof |
| Check current AGENT_X | Bind decisions to `base_main_sha` and invalidate relevant stale analysis |
| Choose best architecture | Require one canonical semantic owner and architectural placement before coding |
| End-to-end implementation | Require proof through the real production UI/API/CLI/agent entrypoint |
| Code verification | Add migration, restart, retry, failure-injection, rollback, concurrency, and activation tests |
| Replacement intent | Require old references/state/config/UI/tests to be removed, repointed, or explicitly migrated |
| Traceability | Create immutable source → decision → semantics → code → tests → entrypoint → activation lineage |
| UI simplification | UI expresses decisions/status but cannot become a domain-logic authority or bypass gates |
| Useful-code preference | Add explicit value/complexity budget so technically valid but low-value code is rejected |
| Transactional assimilation | Make semantic + verified implementation activation one coherent truth boundary |

This is the material difference between a good workflow and a system that can be trusted to assimilate capabilities repeatedly without gradually degrading AGENT_X.

---

# PART XXI — FINAL ACCEPTANCE STANDARD

## 55. Harvest Contract

The final Harvest contract is:

> **Harvest must first understand current AGENT_X, determine whether the candidate deserves to exist, identify exactly where the capability belongs and what it supersedes, stage the desired semantic change, accept that semantic change without prematurely activating it, generate the minimum canonical implementation from the accepted semantics, remove or migrate obsolete behavior, verify the complete production path and failure lifecycle against current `main`, and only then atomically activate semantic and executable truth. If any of those proofs fail, implementation does not activate.**

This is the non-bypassable standard.

---

## 56. Final Design Rating

**Specification completeness: 10/10.**

That rating applies because the design now closes the previously unresolved architectural gaps:

- semantic/code activation split-brain;
- bypassable implementation decisions;
- append-only capability accumulation;
- weak supersession enforcement;
- stale-main implementation;
- partial UI/backend wiring;
- crash/restart ambiguity;
- migration/rollback gaps;
- concurrency conflicts;
- missing provenance and lineage;
- technically valid but low-value implementation.

The implementation itself should only be called 10/10 once these invariants exist as executable guards, state transitions, and acceptance tests rather than documentation alone.

---

# Appendix A — Minimal Gate-B Decision Record

```yaml
harvest_id: ...
base_main_sha: ...
candidate: ...
canonical_owner: ...

value:
  passes: true|false
  reason: ...

overlap:
  existing_capabilities: [...]
  duplicate: true|false

decision:
  type: REJECT|NEW|EXTEND|REPLACE|NEEDS_EVIDENCE
  reason: ...

architecture:
  semantic_target: ...
  implementation_target: ...
  production_entrypoint: ...

supersession:
  semantics: [...]
  code: [...]
  call_sites: [...]
  ui: [...]
  state: [...]
  config: [...]
  tests: [...]

complexity:
  benefit: ...
  added_cost: ...
  justified: true|false

failure_model:
  restart: ...
  rollback: ...
  migration: ...

freshness:
  analyzed_main_sha: ...
  current_main_sha: ...
  relevant_drift: true|false

gate_b_pass: true|false
```

---

# Appendix B — Minimal Activation Preconditions

```text
[ ] Gate A passed
[ ] Gate B passed
[ ] semantic checkpoint accepted
[ ] implementation bound to semantic checkpoint hash
[ ] current-main freshness passed
[ ] supersession completed
[ ] migrations verified
[ ] required tests passed
[ ] production entrypoint passed
[ ] restart/failure/rollback tests passed where applicable
[ ] no ownership conflict
[ ] no forbidden duplicates
[ ] final semantic/code activation can occur coherently
```

If any required item is false, activation is forbidden.
