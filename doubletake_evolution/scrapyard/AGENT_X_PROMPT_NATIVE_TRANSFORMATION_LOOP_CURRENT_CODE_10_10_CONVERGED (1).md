# Agent_X Prompt-Native Transformation Loop — Current-Code Bootstrap

## Mission

Transform the **current Agent_X codebase** into a prompt-native / semantic-first system where, where evidence supports it:

```text
~40–55% of behavior may become truly prompt-only
~65–75% of behavior may become prompt/semantic-driven overall
~25–35% remains deterministic
protected deterministic core: reported separately and never targeted downward
```

These are directional architectural targets, not quotas.

The actual goal is:

> Minimize unnecessary bespoke Agent_X code while maximizing reusable semantic/prompt-driven intelligence, without weakening correctness, governance, security, determinism where required, rollback, observability, performance, testability, or behavioral fidelity.

## Current-State Assumption

**Do NOT assume Agent_X already has an Architectural MCP or a complete semantic change gate.**

Start from the real repository as it exists when OpenCode executes this prompt.

Discover the actual current implementations and use them.

The intended migration is:

```text
CURRENT AGENT_X
  current governance / Borg controls
  current OpenCode/tool paths
  current file/patch/subprocess/Git/model controls
  current worktree/candidate/promotion/rollback
  current planner
  current tests/evidence
          |
          v
ONE-TIME BOOTSTRAP SEMANTIC CHANGE RECORD
          |
          v
MINIMUM NATIVE SEMANTIC CHANGE GATE
          |
          v
CUTOVER: semantic-first becomes mandatory
          |
          v
PROMPT-NATIVE TRANSFORMATION LOOP
          |
          +--> OPTIONAL Architectural MCP later
               as a transport/interface over the same native semantic service
               never as a second authority or second database
```

The deterministic trusted kernel remains underneath prompt-native intelligence.

---

# OpenCode Execution Contract

Execute continuously until the convergence condition is satisfied.

Do not pause after each iteration for routine confirmation.

Resolve ordinary implementation details from:

```text
real Agent_X repository evidence
existing repository instructions
current Borg/governance code
current tests/evidence
current planner/worktree/execution code
AGENT_X_SEMANTIC_PROJECT_MODEL_PLAN.md
existing Agent_X conventions
```

Do not invent paths, services, APIs, databases, or MCPs just because this prompt uses conceptual names.

Ask/stop only when:
- actual existing governance requires external human approval;
- a required credential/provider permission is unavailable;
- continuing would require destructive or unsafe behavior;
- the real repository lacks enough evidence to distinguish two materially different architectural choices safely.

Do not stop at analysis, TODOs, stubs, placeholder prompts, unverified migrations, or partial percentage improvement.

If OpenCode/context restarts, resume from repository state, semantic/bootstrap state, ledger, candidate inventory, and verified checkpoints—not hidden conversation memory.

---

# 0. Mandatory Current-Code Discovery

Before modifying Agent_X:

1. locate the real repository root;
2. read all applicable repository-local instructions;
3. read `AGENT_X_SEMANTIC_PROJECT_MODEL_PLAN.md` if present;
4. inspect current Git branch/HEAD/status/worktrees and preserve all user work;
5. discover the real current code paths for:
   - Borg/governance/authority;
   - OpenCode/tool/MCP integration if any;
   - file writes;
   - patch application;
   - subprocess/shell execution;
   - network operations;
   - Git operations;
   - model/LLM operations;
   - worktree/candidate isolation;
   - verification/evidence;
   - promotion/rejection;
   - rollback/recovery;
   - Epoch/Story/Task/Subtask planning;
   - Harvest;
   - Evolution;
   - assimilation;
   - semantic/vector/index/reconstruction code;
   - UI/backend routes that can trigger changes;
6. map dynamic/config-driven paths, registries, plugins, reflection, generated entry points, and subprocess-mediated writes;
7. run the relevant baseline tests and record pre-existing failures separately;
8. capture baseline metrics;
9. create and **verify** an independent rollback checkpoint/backup;
10. build an artifact inventory and initial semantic-responsibility inventory;
11. identify the Protected Deterministic Core and bind it to real current Agent_X files/symbols;
12. do not begin prompt-native conversion yet.

Create/update:

```text
PROMPT_NATIVE_BASELINE.md
PROMPT_NATIVE_CURRENT_CONTROL_PATH_MAP.md
PROMPT_NATIVE_CURRENT_CAPABILITY_MATRIX.md
PROMPT_NATIVE_TRANSFORMATION_LEDGER.md
PROMPT_NATIVE_CAPABILITY_INVENTORY.md
PROMPT_NATIVE_PROTECTED_CORE.md
```

These reports are projections/evidence. They are not independent architectural authority.

The baseline must record:

```text
accepted/current repository revision
current branch/worktree state
existing authority/governance mechanism
existing code-write paths
existing candidate/promotion/rollback mechanism
source LOC
test LOC
prompt/template LOC
generated source LOC
behavior-affecting evaluation/example/retrieval corpus inventory
deterministic capability count
protected deterministic capability count
prompt-only capability count
prompt-driven capability count
known dead/uncalled modules
known duplicate responsibilities
baseline tests/failures
baseline latency/resource usage
baseline model/provider configuration
baseline dependencies
verified rollback checkpoint
minimum_conversion_benefit_threshold
max_conversion_attempts_per_responsibility
```

Do not repair unrelated baseline failures unless they directly block verification of a selected responsibility and a properly scoped semantic change authorizes that repair.

---

# 0A.1 Current-Capability Presence Matrix and Bootstrap Fallbacks

After discovery, classify each required control capability:

```text
PRESENT_AND_REUSABLE
PRESENT_BUT_NEEDS_ADAPTER
PARTIAL
ABSENT
```

Record the real implementation location/evidence.

Do not invent that Agent_X already has a mechanism merely because this prompt names one.

Use these bootstrap rules:

## If Current Governance Exists

Use it.

Do not create a second authority system.

## If Governance Is Partial

Use the strongest real current authority boundary plus the user's explicit transformation instruction as bootstrap intent.

The minimum semantic gate should then formalize the missing change-authorization semantics without replacing valid existing Borg/governance enforcement.

## If No Central Code-Write Gateway Exists

For the **bootstrap gate implementation only**:

```text
use an isolated Git worktree/candidate branch
restrict edits to the bootstrap declared write set
record every changed path
compare actual diff to declared write set before acceptance
reject/rollback scope escape
```

Then create/integrate the smallest native common semantic authorization hook needed for future writes.

Do not build a second full file/patch execution framework if existing writers can instead call one shared authorization check.

## If No Custom Worktree Manager Exists

Use standard Git worktree/branch isolation directly.

Do not build a bespoke worktree manager merely to satisfy this prompt.

## If No Canonical Semantic Store Exists

The bootstrap gate may introduce the minimum canonical structured semantic persistence required by `AGENT_X_SEMANTIC_PROJECT_MODEL_PLAN.md`.

Prefer simple version-controlled structured records initially over an unnecessary database.

Derived graph/vector/search indexes remain rebuildable.

## If No Existing Semantic Responsibility Inventory Exists

Construct it incrementally from:
- repository artifacts;
- real call/dependency structure;
- current planner/governance records;
- tests;
- runtime evidence;
- source inspection.

Do not wait for perfect repository-wide mapping before creating the gate.

Use coverage states and expand mapping progressively.

## If No Existing Prompt Compiler Exists

Do not create it during semantic-gate bootstrap.

Build it later as the first appropriate prompt-native transformation capability.

## If No Architectural MCP Exists

This is the expected starting assumption.

Do nothing special.

The native semantic gate/service is sufficient for the transformation loop.

An optional Architectural MCP may be considered only later under section 0E.

## Bootstrap Acceptance Principle

The bootstrap must add only missing **minimum control-plane primitives**.

It must not use absence of an ideal subsystem as justification for a broad rewrite.

---

# 0B. One-Time Bootstrap Semantic Change — No Architectural MCP Required

There is a bootstrap problem: semantic-first enforcement cannot be used before the semantic change gate exists.

Solve it **without inventing an external Architectural MCP**.

Before the first code change that implements the native semantic change gate, create one durable, machine-readable **BOOTSTRAP SEMANTIC CHANGE RECORD** using the current Agent_X repository/governance/planning conventions.

Preferred format is existing structured Agent_X state if suitable; otherwise use a narrowly scoped version-controlled JSON/YAML record.

It must contain at least:

```yaml
bootstrap_change_id:
base_repository_revision:
created_at:
current_authority_mechanism:
purpose:
current_state:
target_state:
semantic_delta:
affected_responsibilities:
expected_file_write_set:
preserved_invariants:
governance_constraints:
test_and_evidence_contract:
rollback_checkpoint:
proposer_provenance:
approval_or_authority_provenance:
status: bootstrap_authorized
```

The target must describe the real semantic architecture being introduced:

```text
current vs target semantic state
durable semantic change records
semantic responsibility bindings
protected deterministic classifications
change state machine
implementation authorization context
declared semantic/source write sets
integration with CURRENT Agent_X write/execution paths
exact candidate/revision verification
reconciliation
rollback/promotion integration
```

This bootstrap record is **not authority by itself**.

Use the strongest real current Agent_X authority/governance mechanism discovered in the repository to authorize the bootstrap implementation. A status string such as `approved`, `update`, `upgrade`, `candidate`, or `bootstrap_authorized` must never manufacture authority.

Before the first write:

```text
bootstrap semantic record persisted
AND
verified rollback checkpoint exists
AND
real current governance/authority permits the change
AND
candidate/worktree isolation is established where current Agent_X supports it
```

Then implement only the minimum native semantic change gate.

## Bootstrap Scope

The bootstrap exception applies **only** to code necessary to create and wire the minimum semantic gate.

Do not use it for prompt-native conversions, unrelated cleanup, feature work, Harvest/Evolution improvements, UI redesign, or broad refactoring.

Any write outside the bootstrap declared write set invalidates the bootstrap candidate.

## Bootstrap Temporal Evidence

Record equivalent evidence:

```text
bootstrap_semantic_record_persisted_at
    <
bootstrap_authorized_at
    <
first_bootstrap_code_write_at
```

If this cannot be proven, do not accept the bootstrap candidate.

---

# 0C. Minimum Native Semantic Change Gate

Implement the smallest Agent_X-native mechanism that can enforce semantic-first changes after bootstrap.

Do not build a giant framework.

It needs, at minimum:

```text
canonical accepted/current semantic state
staged target semantic change records
stable semantic responsibility IDs/bindings
PROTECTED_DETERMINISTIC classification
change classification
change state machine
semantic + source write sets
implementation authorization context
base revision/freshness checks
current/target separation
exact candidate revision binding
verification/evidence binding
reconciliation
promotion/rejection/rollback integration
audit/provenance
```

Integrate this into **existing Agent_X mechanisms** discovered in section 0.

Do not create parallel replacements for the current:
- planner;
- governance engine;
- worktree manager;
- file/patch/subprocess/network/Git/model adapters;
- evidence store;
- promotion system;
- rollback system.

The native semantic gate is a control layer over/integrated with those mechanisms.

## Native Change States

Use equivalent states consistent with current Agent_X conventions:

```text
DRAFT
SEMANTICS_RECORDED
VALIDATED
AUTHORIZED
WRITING
CANDIDATE
VERIFIED
RECONCILED
PROMOTED

failure:
REJECTED
FAILED
ROLLBACK_REQUIRED
ROLLED_BACK
```

Prohibit illegal transitions such as:

```text
DRAFT -> WRITING
SEMANTICS_RECORDED -> WRITING
VALIDATED -> WRITING
WRITING -> PROMOTED
CANDIDATE -> PROMOTED
VERIFIED -> PROMOTED without RECONCILED
FAILED -> PROMOTED
```

---

# 0D. Semantic-Gate Cutover

Before closing the bootstrap exception, verify at minimum:

```text
missing semantic change blocks/invalidates governed writes
stale base revision blocks authorization/promotion
undeclared write scope is rejected
forged status/metadata does not grant authority
current and target semantic states remain separate
protected deterministic declassification is rejected
exact candidate revision is bound to evidence
rollback restores accepted state
the semantic gate can govern later changes to itself
existing planner/governed adapters/worktree/promotion paths remain intact
```

Then:

1. import/normalize the bootstrap semantic change into canonical semantic state;
2. bind it to the exact verified bootstrap candidate revision;
3. mark the native semantic gate active;
4. permanently close the bootstrap exception;
5. from this point onward, every governed change must use semantic-first gating.

After cutover, preserve:

```text
semantic_change_persisted_at
    <
implementation_authorized_at
    <
first_governed_write_at
```

for every governed change.

The bootstrap exception must never reopen because a later change is inconvenient.

If the semantic gate later fails:
- stop new governed changes;
- restore the last verified semantic-gate revision via the pre-recorded rollback path;
- verify it;
- use the restored gate to authorize any new repair code.

Do not create a bypass.

---

# 0E. Optional Architectural MCP — Later, Not a Prerequisite

An Architectural MCP may be useful later for OpenCode/external-agent access.

It is **optional** for this transformation loop.

If implemented:

```text
OpenCode/external client
        |
        v
Architectural MCP transport
        |
        v
existing native Agent_X semantic change service/gate
```

Rules:

- MCP is transport/interface, not canonical state;
- no second semantic database;
- no second transaction engine;
- no second authority;
- no separate change lifecycle;
- internal Agent_X can continue using the native semantic service directly through its governed internal APIs;
- MCP mutations must invoke the same native gate;
- MCP transport/permission/framing code becomes Protected Deterministic Core;
- failure of optional MCP transport must not corrupt canonical semantic state.

Do not build an Architectural MCP merely to satisfy this prompt.

Build it only if it materially improves Agent_X/OpenCode integration.

---

# 0A. Agent_X Integration Constraints — Transform, Do Not Duplicate

This work must transform the **existing Agent_X architecture**, not create a parallel prompt-native framework beside it.

Before converting responsibilities, locate the real current implementations of:

```text
native semantic change gate/service (once bootstrapped)
Semantic/Architecture Service
Borg governance
Borg execution/orchestration
OpenCode/MCP bridge
governed file operations
governed patch operations
governed subprocess operations
governed network operations
governed Git operations
governed model/LLM operations
worktree/candidate isolation
verification/evidence
promotion/rejection
rollback/recovery
Epoch/Story/Task/Subtask planning
Harvest
Evolution
assimilation
semantic/vector representation
vector -> semantic reconstruction work
UI/backend tool routing
```

Preserve mechanisms that are actually present and valid as the integration backbone unless a native-semantic-gate-governed change later proves replacement is necessary.

For conceptual mechanisms that are absent, do not manufacture a parallel subsystem merely to match this document; use the current-capability fallback rules above.

Do **not** create:

```text
second planner
second governance engine
second semantic store
second semantic/change authority
second worktree manager
second promotion service
second file/patch/subprocess writer
second tool permission system
second long-term memory authority
second independent vector identity system
```

## Planning

Keep the existing Agent_X:

```text
Epoch -> Story -> Task -> Subtask
```

persistence/identity/lifecycle as the canonical planning structure.

Prompt-native conversion should move **planning reasoning** into P1/P2 capabilities where useful, not create another planner database.

Example:

```text
existing planning records
        |
        v
semantic context
        |
        v
prompt-native planning reasoning
        |
        v
structured proposal
        |
        v
existing planner / native semantic change service
```

## Borg

Borg governance and governed execution remain deterministic authority/execution boundaries.

Prompt-native reasoning may advise/interpret/plan around them but must not replace their enforcement with prompts.

## OpenCode

Use the existing Agent_X/OpenCode integration/bridge, including MCP if present and tool-registration conventions.

Do not create a separate prompt-native code-edit path.

## Governed Adapters

Prompt outputs that propose actions must flow into the existing governed adapters rather than directly manipulating:
- files;
- patches;
- subprocesses;
- network;
- Git;
- models;
- worktrees.

## Semantic / Vector Reconstruction

Preserve the existing Agent_X semantic/vector direction:

```text
source
  <-> semantic model
  <-> vector representation
```

Prompt-native conversion should improve semantic fidelity and reduce bespoke code; it must not introduce a competing embedding identity or semantic representation.

Where Agent_X uses F0–F4 semantic fidelity/regeneration concepts, preserve them.

For F3/F4 responsibilities, prompt-native conversion must not remove implementation-independent algorithm/behavior details required for behavioral regeneration.

## UI

Use the existing UI/backend architecture.

Prompt-native conversion should generally **reduce** exposed controls and internal machinery rather than adding dashboards for every prompt capability.

---

# 1. Absolute Rule — Semantic Intent Before Governed Changes

After semantic-gate cutover, before **every governed Agent_X change**, where governed means:

```text
A. EVERY tracked code change without exception
   including behavior changes, refactors, formatting,
   rename/move/delete, tests, build scripts, generated code,
   dependency/lockfile changes, and semantic-gate/transformation code

PLUS

B. EVERY non-code behavior-affecting change
   including prompts, templates, semantic capability definitions,
   model/provider routing, tool permissions,
   evaluation rules/datasets/cases/thresholds,
   few-shot examples, prompt fixtures,
   retrieval/context corpora,
   runtime/governance configuration, or context policy
```

perform:

```text
1. read current accepted semantic state
2. create/update TARGET semantic intent FIRST
3. persist semantic change record
4. classify change
5. calculate impact
6. validate current Borg/governance authority
7. validate protected core / duplication / slop / algorithms
8. declare semantic read/write set
9. declare source/prompt/config write set
10. define preserved invariants
11. define tests/evidence
12. define rollback checkpoint
13. validate base/freshness
14. obtain implementation authorization from native semantic gate + current governance
15. ONLY THEN write
16. freeze exact candidate revision/config/model state
17. verify
18. reconcile against pre-declared target
19. promote or rollback
```

For every governed change prove:

```text
semantic_change_persisted_at
    <
implementation_authorized_at
    <
first_governed_write_at
```

No post-hoc semantic backfill.

The one-time bootstrap semantic-gate implementation described in sections 0B–0D is the only bootstrap exception, and even it requires a durable semantic target record **before** the first bootstrap code write.


---

# 2. Architectural Target

Agent_X should progressively move from:

```text
many narrow Python modules
many handlers
many hard-coded orchestration rules
many generated "algorithm" files
many special-case planners
many duplicated decision paths
```

toward:

```text
small deterministic kernel
        +
structured semantic model
        +
prompt compiler
        +
LLM reasoning
        +
generic reusable tools
        +
hard verification/governance boundaries
```

The desired boundary is approximately:

```text
ABOVE NATIVE SEMANTIC CHANGE / GOVERNANCE BOUNDARY
  mostly semantic / prompt / LLM-driven

BELOW NATIVE SEMANTIC CHANGE / GOVERNANCE BOUNDARY
  mostly deterministic / stateful / security-critical
```

---

# 2A. Protected Deterministic Core — DO NOT CONVERT TO PROMPT EXECUTION

This transformation has a **hard protected core**.

These responsibilities may be maintained, repaired, refactored, optimized, or replaced by another deterministic implementation through the normal semantic-first change-gate workflow, but they must **not be converted into prompt-only or prompt-driven execution by this transformation loop**.

The transformation loop has no authority to declassify these responsibilities.

## Protected Responsibilities

At minimum protect the real Agent_X implementations of:

```text
ARCHITECTURAL CONTROL / AUTHORITY
- native Agent_X semantic change gate / transaction enforcement
- semantic-change transaction enforcement
- current vs target semantic-state separation
- implementation-authorization issuance/validation
- semantic change state machine
- authorization freshness/base-revision checks
- semantic read/write-set enforcement
- exact candidate/revision binding

BORG / GOVERNANCE
- Borg governance enforcement
- authority evaluation
- approval/permission enforcement
- governance fail-closed logic
- governance audit/provenance
- authority-bearing status validation
- policy boundary enforcement

GOVERNED EXECUTION
- governed file operations
- governed patch operations
- governed subprocess/shell operations
- governed network operations
- governed Git operations
- governed model/LLM invocation guards
- governed tool permission enforcement
- path/root/symlink traversal protection
- secret/credential protection
- filesystem safety

REPOSITORY / CANDIDATE SAFETY
- Git/worktree isolation
- accepted-vs-candidate separation
- candidate base/freshness validation
- merge/promotion gating
- rollback/recovery execution
- exact-revision verification
- immutable/checkpoint backup verification

STATE / PERSISTENCE / TRANSACTIONS
- canonical semantic persistence
- durable change/evidence persistence
- database/storage transactions
- atomic commit/update primitives
- locking/concurrency primitives
- idempotency/recovery primitives
- schema migrations/execution
- serialization/deserialization primitives
- protocol parsing

VERIFICATION / EVIDENCE
- schema validation
- deterministic invariant checks
- hashes/digests/content identity
- provenance generation/validation
- audit-log integrity
- test-result/evidence binding
- promotion eligibility checks
- benchmark/evaluation metric calculation where exact arithmetic is required

SECURITY
- authentication/authorization primitives
- encryption/cryptographic primitives
- secret handling
- permission boundaries
- sandboxing/isolation
- input/path validation
- resource-limit enforcement
- rate/attempt limits where hard enforcement is required

CORE ALGORITHMIC PRIMITIVES
- parsers/compilers
- graph traversal primitives
- deterministic indexing/search primitives where correctness/performance matters
- numerical algorithms
- schedulers/queues/priority structures
- ranking/retrieval primitives where exact algorithmic behavior is required
- cache invalidation primitives
- concurrency algorithms
- deterministic routing tables/state machines
- any implementation with a required complexity/resource bound

OPENCODE / MCP TRANSPORT
- OpenCode/MCP transport/registration plumbing
- MCP schema validation if MCP exists
- MCP capability discovery/identity if MCP exists
- MCP request/response framing if MCP exists
- tool-call dispatch enforcement
- tool permission binding

PLANNING PERSISTENCE
- Epoch/Story/Task/Subtask canonical IDs
- planner persistence
- planner lifecycle/state transitions
- planner referential integrity

SEMANTIC / VECTOR INFRASTRUCTURE
- canonical semantic identity
- source/symbol binding identity
- vector/index persistence primitives
- deterministic embedding/index plumbing
- semantic graph storage
- semantic graph traversal
- F3/F4 fidelity verification machinery
- regeneration-equivalence measurement

RUNTIME SAFETY / HOT PATHS
- hard real-time or latency-critical loops
- safety-critical runtime checks
- bounded retry/circuit-breaker enforcement
- watchdog/health enforcement
- deterministic fallback activation
```

## Protected Means "Do Not Promptify", Not "Never Edit"

A protected responsibility may still need code changes.

Those changes must still follow:

```text
native semantic change gate
    ↓
semantic target/change FIRST
    ↓
validate + authorize
    ↓
deterministic code edit
    ↓
verify/reconcile
    ↓
promote/rollback
```

But its accepted execution mode must remain:

```text
mode: deterministic
protection: PROTECTED_DETERMINISTIC
```

The loop must not change it to `P1`, `P2`, or runtime prompt execution.

## Advisory LLM Use Around Protected Code

The LLM may:

```text
explain protected behavior
propose a deterministic patch
analyze logs/evidence
suggest tests
suggest parameters
suggest architecture
```

The LLM may **not** become the executable authority that decides or enforces the protected invariant.

Examples:

```text
GOOD:
LLM proposes a rollback plan
deterministic rollback engine validates + executes it

BAD:
LLM decides whether rollback is valid and directly mutates Git state

GOOD:
LLM proposes governance interpretation
Borg governance deterministically authorizes/rejects

BAD:
prompt output itself becomes authority

GOOD:
LLM suggests scheduler parameters
deterministic scheduler enforces bounds/order

BAD:
LLM replaces queue/locking semantics
```

## Protected Core Registry

During bootstrap/discovery, record the protection registry in the bootstrap semantic record; after cutover, persist it in canonical semantic state through the native semantic gate.

Equivalent semantic fields should exist:

```yaml
responsibility_id:
mode: deterministic
protection: PROTECTED_DETERMINISTIC
protection_reason:
hard_invariants:
real_code_bindings:
tests:
evidence:
```

Bind protected semantic responsibilities to their **actual current Agent_X files/symbols/modules**.

Do not rely on the conceptual names above after discovery.

Create/update a generated report:

`PROMPT_NATIVE_PROTECTED_CORE.md`

This report is a projection of canonical semantic state, not the source of truth.

## No Declassification Inside This Loop

This transformation loop must not remove `PROTECTED_DETERMINISTIC`.

If a future project genuinely needs to reconsider a protected boundary, that must be a **separate explicitly authorized architectural project outside this prompt-native transformation loop**.

Until then:

```text
PROTECTED_DETERMINISTIC -> P1          FORBIDDEN
PROTECTED_DETERMINISTIC -> P2          FORBIDDEN
PROTECTED_DETERMINISTIC -> unprotected FORBIDDEN
```

## Protected-Code Change Discipline

The transformation loop must **not modify protected code merely to make prompt-native conversion easier**.

Prohibited opportunistic changes include:

```text
weakening an invariant
adding an LLM bypass
adding a "temporary" direct-write path
moving authority into prompt text
removing deterministic checks because the LLM "already validates"
changing protected APIs solely to fit a prompt wrapper
rewriting a real algorithm as a model call
```

Protected code may be changed only when needed for:

```text
bug repair
security repair
performance repair
deterministic refactor
interface adaptation required by a valid integration
test/evidence improvement
dependency/platform maintenance
```

and every such change must:
- have its own native semantic-gate change/target;
- preserve `PROTECTED_DETERMINISTIC`;
- preserve or strengthen hard invariants;
- remain independently testable without trusting LLM judgment.

## Prompt Boundary Around Protected Core

A prompt capability may sit **above** a protected deterministic responsibility:

```text
LLM reasoning
    ↓ structured proposal
deterministic validator / authority
    ↓
protected deterministic primitive
```

but never **inside** the invariant boundary:

```text
protected invariant
    ↓
LLM decides whether invariant applies   <- FORBIDDEN
```

## Protection Is Semantic, Not Path-Only

Do not implement protection as a brittle hard-coded filename list alone.

Use semantic responsibility IDs + code bindings.

A rename/move of protected code must preserve protection through binding reconciliation.

If a protected symbol/file moves:

```text
same protected responsibility ID
new source binding
protection remains
```

Do not accidentally unprotect code because its path changed.

---

# 3. What Should Prefer Prompt/Semantic Representation

Strong candidates include:

```text
planning reasoning within the existing Epoch/Story/Task/Subtask system
task decomposition
architecture interpretation
impact interpretation
Harvest reasoning
Evolution strategy
assimilation strategy
proposal generation
slop reasoning
duplication reasoning
refactor strategy
failure diagnosis
candidate comparison
semantic reconstruction
code-generation strategy
UI explanations
natural-language project views
context reduction
agent coordination strategy
benchmark interpretation
semantic change proposal drafting
requirements interpretation
policy explanation
documentation generation
```

These should increasingly become:

```text
semantic capability
        +
structured prompt template/compiler
        +
bounded context
        +
structured LLM output
        +
deterministic validation
```

instead of bespoke code implementing the reasoning itself.

---

# 4. What Must Normally Remain Deterministic Code

Do **not** convert the following into prompt-only behavior unless a later semantic proof demonstrates an equivalent deterministic enforcement mechanism:

```text
Borg governance enforcement
native semantic change-gate transaction enforcement
semantic persistence
change-state machine
authorization validation
Git/worktree operations
file/patch/subprocess/network guards
locking/concurrency primitives
schema validation
hashing
provenance
audit logs
rollback
promotion
exact-revision verification
graph traversal primitives
index persistence
cache invalidation
filesystem/path safety
security boundaries
credential handling
runtime safety checks
transaction atomicity
protocol parsing
serialization
migration execution
hard resource limits
canonical planner persistence/identity
vector/index primitives where deterministic implementation is superior
```

The LLM may advise these systems.

The LLM must not become the only enforcement mechanism for them.

---

# 4A. Capability Criticality Is Separate From P1/P2/D

Classify each responsibility by **criticality** independently from execution mode.

Suggested tiers:

```text
C0 — advisory/non-operational
  explanation, summarization, optional analysis

C1 — reversible development assistance
  planning, proposal drafting, diagnostics

C2 — consequential development decision
  impact analysis, refactor strategy, candidate ranking,
  code-generation strategy, acceptance recommendations

C3 — authority/safety/state boundary
  governance enforcement, authorization, persistence,
  transactions, filesystem/network security, promotion
```

Default rule:

```text
C0/C1 -> P1 or P2 often suitable
C2    -> P1/P2 allowed only with strong independent verification/fallback
C3    -> deterministic enforcement required; LLM may advise only
```

All C3 responsibilities are `PROTECTED_DETERMINISTIC` by default.

A responsibility explicitly listed in the Protected Deterministic Core is protected regardless of criticality label.

A responsibility must not be downgraded in criticality merely to make it easier to convert.

Criticality controls:
- verification depth;
- model/provider restrictions;
- retry policy;
- fallback requirement;
- shadow/canary requirement;
- acceptable nondeterminism.

---

# 4B. Classification Semantics

`P1`, `P2`, and `D` are mutually exclusive **primary execution modes for a semantic responsibility at a given accepted revision**.

For metrics:

```text
P1 = prompt-only reasoning responsibility
P2 = prompt-driven responsibility with deterministic execution/verification
D  = deterministic responsibility
PD = protected deterministic responsibility (`PROTECTED_DETERMINISTIC`)
```

Therefore:

```text
prompt_only_behavior_percentage = P1 / total_mapped_responsibility_weight

prompt_driven_overall_percentage =
    (P1 + P2) / total_mapped_responsibility_weight

deterministic_behavior_percentage =
    (D + PD) / total_mapped_responsibility_weight

protected_deterministic_percentage =
    PD / total_mapped_responsibility_weight
```

Do not double-count P1 separately and again as an additional capability.

Report both:
- unweighted responsibility counts;
- weighted responsibility percentages.

Weights must be anchored to the baseline responsibility inventory.

Default weighting rule, unless Agent_X already has an approved semantic weighting model:

```text
each verified baseline semantic responsibility starts with weight = 1.0
```

Do not invent subjective importance weights merely to improve the target percentages.

If useful, report additional secondary weighted views based on measured runtime usage, maintenance cost, or criticality, but keep the equal-baseline-weight view as the stable comparable reference.

When responsibilities split/merge during transformation:

```text
split:
  child weights must sum to the parent baseline weight

merge:
  merged weight must equal the sum of merged baseline weights

deleted dead responsibility:
  retain it in historical reporting but remove it from active denominator
  only after dead/duplicate status is verified

genuinely new responsibility:
  assign weight through an explicit native-semantic-gate-governed weighting update
```

Never game the target percentages by splitting one responsibility into many tiny prompt capabilities or by deleting hard deterministic responsibilities from the denominator without verified retirement.

Report baseline-weighted and current-active-weighted metrics when structural changes materially affect interpretation.

---

# 5. Three Transformation Classes

Every selected Agent_X responsibility must be classified into one of these.

## Class P1 — Prompt-Only

The behavior can be represented primarily as:

```text
semantic definition
prompt
LLM reasoning
structured output
```

with no bespoke deterministic decision implementation.

Examples may include:

```text
planning interpretation
proposal critique
architecture explanation
failure analysis
candidate comparison
semantic summarization
```

A deterministic tool may still:
- validate output schema;
- persist records;
- enforce governance;
- execute approved actions.

The **reasoning/decision behavior itself** is prompt-only.

`P1` does **not** mean "LLM directly performs unrestricted side effects." Persistence, authorization, tool execution, schema validation, audit, and side-effect enforcement remain deterministic/governed.

Classification honesty rule:

```text
If deterministic code merely:
  validates schema
  enforces permissions/invariants
  persists/executes an already-selected action
then P1 may still be correct.

If deterministic code materially:
  ranks alternatives
  selects the outcome
  applies business/policy decision rules
  changes the substantive model decision
then the responsibility is not truly P1;
classify as P2 or D, or decompose the responsibility honestly.
```

Do not inflate prompt-only percentages by hiding decision logic in a "validator."

---

## Class P2 — Prompt-Driven

The LLM chooses/constructs behavior, but deterministic mechanisms execute or verify it.

Example:

```text
semantic context
      |
      v
LLM chooses transformation
      |
      v
structured action plan
      |
      v
deterministic tool executes
      |
      v
tests/evidence verify
```

This is likely the dominant Agent_X architecture.

---

## Class D — Deterministic

The responsibility must remain coded because it requires:

```text
hard invariants
reproducibility
atomicity
security boundary
exact protocol behavior
bounded resource behavior
low latency
transaction semantics
cryptographic integrity
state correctness
```

The LLM may generate configuration/specification for it, but does not replace the executable mechanism.

---

# 5A. Prefer Change-Time Intelligence Over Runtime LLM Dependence

Prompt-native does not mean "call an LLM on every runtime operation."

For each P1/P2 capability classify execution timing:

```text
change_time
  LLM reasons during planning/configuration/code-change/control-plane work;
  accepted result is compiled/persisted into deterministic runtime state

runtime
  LLM reasoning is genuinely required while Agent_X is operating

both
  some reasoning occurs at change time and some at runtime
```

Prefer `change_time` when the result can be safely compiled into:

```text
validated configuration
semantic plan
routing table
policy-neutral strategy parameters
prompt capability definition
static/generated artifact
```

Advantages:

```text
lower runtime latency
lower provider dependence
better reproducibility
easier rollback
lower token cost
better offline behavior
```

Use runtime LLM calls only where runtime context/judgment is genuinely necessary.

A conversion that moves deterministic runtime behavior into a remote LLM hot path without a clear capability benefit is usually a regression.

Any compiled result produced by an LLM must still be:
- schema-validated;
- semantically versioned;
- evidence-bound;
- promoted through the native semantic change gate;
- reproducible/rollbackable.

---

# 6. Prompt-Native Representation

Do not replace code with giant static Markdown prompts.

The canonical representation should remain structured.

Preferred architecture:

```text
semantic capability record
        |
        +--> purpose
        +--> inputs
        +--> outputs
        +--> constraints
        +--> invariants
        +--> evidence requirements
        +--> prompt role/template
        +--> allowed tools
        +--> output schema
        +--> model requirements
        +--> fallback behavior
        +--> tests
        |
        v
dynamic prompt compiler
        |
        v
bounded prompt
        |
        v
LLM
```

Prompts should normally be generated from the semantic model.

Static prompt files may exist where useful, but must not become a second source of truth.

---

# 7. Required Prompt Capability Schema

For prompt-only or prompt-driven responsibilities, represent enough structure to avoid prompt slop.

Equivalent fields should exist:

```yaml
capability_id:
name:
responsibility:
semantic_owner:
mode: prompt_only | prompt_driven | deterministic
protection: none | PROTECTED_DETERMINISTIC
criticality: C0 | C1 | C2 | C3
execution_timing: change_time | runtime | both

purpose:
inputs:
outputs:
preconditions:
postconditions:
invariants:
constraints:
failure_modes:
side_effects:

prompt_role:
prompt_objective:
context_requirements:
context_budget:
allowed_tools:
forbidden_tools:
output_schema:
model_requirements:
model_allowlist:
provider_allowlist:
data_classification:
data_residency_policy:
offline_requirement:
temperature_or_determinism_policy:
max_attempts:
timeout_policy:
token_budget:
cost_budget:
latency_budget:

untrusted_context_policy:
prompt_injection_policy:
tool_permission_scope:
side_effect_policy:

verification:
evaluation_suite:
evaluation_corpus_revision:
few_shot/example_revision:
retrieval_corpus_revision:
shadow_policy:
canary_policy:
fallback:
rollback_behavior:

source_bindings:
test_bindings:
evidence_bindings:
```

Do not require this exact YAML format if Agent_X already has a better schema.

Use the existing semantic model.

---

# 8. Required Prompt Compiler

Prefer one reusable Agent_X prompt compiler over many unrelated prompt files.

Conceptually:

```text
compile_prompt(
    capability,
    task,
    current_semantic_state,
    target_semantic_state,
    dependencies,
    governance,
    evidence,
    tools,
    context_budget,
)
```

The compiler should:

```text
resolve semantic responsibility
select only relevant context
include current vs target state explicitly
include invariants
include known unknowns
include allowed tools
include required output schema
include evidence requirements
include governance constraints
exclude irrelevant repository context
separate trusted instructions from untrusted repository/external text
label provenance of retrieved context
bind tool permissions independently from model text
include prompt/capability/model revision identifiers
```

Do not duplicate prompt construction logic across Harvest, Evolution, assimilation, the existing planner, and orchestration if one shared mechanism can serve them.

Integrate the shared compiler behind existing Agent_X services/interfaces rather than creating an alternate execution framework.

The compiler must treat source comments, harvested text, external project documentation, issue text, retrieved web/file content, runtime logs, and model-generated summaries as **untrusted data**, not higher-priority instructions.

Prompt text must never be able to grant itself additional tools, write scope, governance authority, model permissions, or semantic authority.

---

# 8A. Provider, Privacy, and Code-Exfiltration Boundary

Prompt-native conversion must not silently turn Agent_X source, user data, secrets, proprietary material, credentials, or internal evidence into external-model payloads.

For every P1/P2 capability, define:

```text
data classification
allowed providers/models
whether source code may leave the machine
whether runtime/user data may leave the machine
redaction requirements
retention/privacy requirements
offline/local fallback requirements
```

Before sending context to any model/provider:

1. classify the context;
2. remove secrets/credentials;
3. enforce provider/data policy deterministically;
4. record provider/model identity;
5. reject the call if policy cannot be satisfied.

Do not let the LLM decide whether data is allowed to be sent to itself.

If a responsibility requires sensitive context that cannot be sent to an approved provider:

```text
use approved local/on-prem model
OR
retain deterministic implementation
OR
fail/require authorized alternative
```

A prompt-native conversion that introduces unacceptable data exfiltration risk must be rejected.

---

# 9. Structured LLM Output Rule

Prompt-driven behavior must not rely on free-form prose where downstream code expects machine action.

Prefer structured outputs such as:

```yaml
decision:
reason:
semantic_changes:
actions:
affected_responsibilities:
evidence:
confidence:
unknowns:
```

or a schema appropriate to the capability.

Model-reported `confidence` is advisory metadata only. It must not grant authority, relax governance, bypass verification, or serve as the sole acceptance threshold.

Validate all structured output before use.

Invalid output must not silently become authority.

---

# 9A. Prompt Injection, Tool Authority, and Untrusted Context

Prompt-native Agent_X increases exposure to prompt injection and instruction confusion.

For every P1/P2 capability:

```text
system/governance instructions
        >
semantic capability contract
        >
task intent
        >
retrieved/contextual data
```

Retrieved data must never be interpreted as authority.

Required controls:

```text
strict tool allowlist
per-change write scope
schema-constrained output
context provenance
instruction/data separation
path/root restrictions
secret redaction
no tool expansion from model output
no authority expansion from model output
no shell/network/file action outside governed adapters
```

Adversarial tests must include:
- source comments telling the model to ignore governance;
- harvested text requesting tool expansion;
- retrieved documents containing fake "system" instructions;
- malicious filenames/paths;
- attempts to smuggle code-write requests through structured fields;
- attempts to alter model/tool permissions through prompt output.

A prompt-injection success that changes authorization or write scope is a release-blocking failure.

---

# 9B. Test Architecture — Stable Unit Tests + Live Model Evaluations

Do not make the ordinary deterministic Agent_X unit test suite depend on live external LLM calls.

Use layered testing:

## Layer 1 — Deterministic Unit Tests

Test without live models:

```text
prompt compiler
context selection
schema construction
permission binding
redaction
state transitions
fallback selection
parser/validator behavior
recorded model-output fixtures
```

## Layer 2 — Replay / Golden Fixtures

Store sanitized representative input/output/evidence fixtures where licensing/privacy permits.

Use them to detect prompt/compiler regressions deterministically.

Recorded fixtures are not proof of current model quality; they are regression tools.

## Layer 3 — Live Model Evaluation

For behavior-affecting prompt/model changes, run an evaluation suite against the actual approved model/provider.

Measure:

```text
task success
constraint adherence
schema validity
behavioral equivalence
adversarial resistance
latency
tokens
cost
disagreement
fallback frequency
```

## Layer 4 — Shadow / Canary / Runtime Evidence

Use for consequential C2 prompt-native behavior before deleting the old deterministic implementation where practical.

A prompt/model change must not be accepted solely because deterministic fixture tests pass.

Conversely, routine deterministic tests must remain runnable when the external model/provider is unavailable.

---

# 9C. Evaluation Overfitting Protection

Prompt optimization, Evolution, and repeated manual tuning must not optimize against the entire acceptance suite until it becomes a memorized benchmark.

Where evaluation volume permits, separate:

```text
development cases
regression/golden cases
adversarial cases
holdout cases
runtime/canary evidence
```

Rules:

- prompt optimizers/agents may use development cases;
- regression cases protect known behavior;
- adversarial cases protect safety/robustness;
- holdout cases should not be exposed to the optimizer as ordinary context;
- final acceptance of consequential changes should include holdout or fresh evaluation evidence.

If the evaluation corpus is too small for a formal holdout, generate/collect fresh independent cases and record the limitation.

---

# 10. Deterministic Validation Rule

Every prompt-only or prompt-driven responsibility must have deterministic validation appropriate to risk.

Possible validation:

```text
JSON/schema validation
static checks
property tests
unit tests
integration tests
behavioral replay
differential testing
benchmark
governance validation
semantic invariant checks
dependency checks
runtime assertions
mutation testing
golden cases
holdout cases
```

The model's explanation is never proof that the result is correct.

Do not let the same prompt/model that produced a candidate be the sole judge of that candidate.

For high-impact conversions, verification must include at least one independent oracle such as:

```text
existing deterministic behavior
pre-existing tests
independently authored golden cases
property/invariant checks
runtime replay
benchmark
different evaluation mechanism/model where appropriate
human-approved acceptance contract already present in semantic state
```

If the current responsibility has inadequate tests/evidence, **characterize the existing behavior before conversion** rather than converting first and inventing acceptance criteria afterward.

---

# 11. Model Failure / Unavailability

Prompt-native Agent_X must degrade safely.

For each prompt capability define:

```text
model timeout
model unavailable
invalid structured output
low confidence
tool failure
context overflow
contradictory evidence
nondeterministic disagreement
```

Possible safe responses:

```text
retry within bounded policy
switch to a PRE-APPROVED + PRE-EVALUATED fallback model
reduce/rebuild context
request deterministic fallback
mark unknown
reject candidate
stop change
```

Never route consequential behavior to an unevaluated model merely because the preferred provider is unavailable.

Do not silently fabricate a decision.

Security/governance-critical behavior must fail closed.

Define circuit breakers for:
- repeated provider failures;
- latency spikes;
- excessive token/cost use;
- repeated invalid schema;
- repeated disagreement;
- injection/adversarial failures.

Where Agent_X requires useful offline/local development behavior, preserve an approved deterministic/local fallback rather than making the project unnecessarily dependent on a remote model.

Retries must be bounded. A prompt capability must not recurse, self-retry, spawn subagents, or switch models indefinitely.

If repeated runs materially disagree on a responsibility that requires stable behavior:

```text
mark nondeterministic instability
reject or downgrade prompt suitability
retain/restore deterministic implementation
```

---

# 12. Prompt Versioning and Reproducibility

Every prompt-executed result that affects Agent_X must record enough provenance to reproduce or analyze it.

At minimum:

```text
capability ID
semantic revision
prompt compiler version
prompt template/version
model/provider identity
model version where available
sampling/determinism parameters
tool set
input context digest
output digest
timestamp
candidate/change ID
```

Do not store secrets in prompt/evidence records.

For consequential prompt runs, compute a reproducibility key/digest over at least:

```text
capability revision
semantic revision
prompt compiler revision
model/provider identity
sampling policy
tool schema/version
selected-context digest
input/task digest
```

Caching may be used for safe/idempotent analysis when semantically valid, but cached model output must never be reused across incompatible semantic/model/tool revisions or treated as fresh runtime evidence when it is stale.

---

# 12A. Prompt Execution Trace and Debuggability

Consequential P1/P2 executions must produce a compact, privacy-safe trace sufficient to answer:

```text
which capability ran?
which semantic revision?
which prompt/compiler/model revision?
which context was selected?
which tools were available?
which tool calls were proposed/executed?
what structured output was produced?
which validator accepted/rejected it?
what fallback/retry occurred?
which change/candidate/evidence record resulted?
```

Do not require storing full raw prompts or sensitive context when policy forbids it. Store digests, provenance, redacted excerpts, structured decisions, and references as appropriate.

A prompt-native conversion that makes failures substantially harder to diagnose must account for that cost in the net-complexity decision.

---

# 12B. Model / Prompt Drift Is a Behavior Change

A change to any of the following is behavior-affecting and must go through the native semantic change gate first:

```text
prompt template
prompt compiler
semantic capability instructions
model/provider
model version
sampling parameters
tool set
context-selection algorithm
output schema
retry policy
fallback model
evaluation threshold
evaluation dataset/case set
few-shot/example set
retrieval/context corpus used by the capability
```

Do not assume that "same prompt, newer model" preserves behavior.

Before accepting a model/provider/template change:

1. run the capability evaluation suite;
2. compare against the accepted baseline;
3. measure failure rate, latency, tokens, and cost;
4. test adversarial/injection cases;
5. run shadow/canary where runtime impact justifies it;
6. reconcile through the native semantic change gate.

Record the accepted model/prompt matrix per capability.

Prefer pinned model versions when the provider supports them. If a provider exposes only a mutable alias, record returned model metadata where available and treat material observed behavior drift as a re-evaluation trigger.

Fallback models/providers must have their own accepted evaluation evidence for the capability/criticality in which they are used.

---

# 12C. Stochastic Behavior Requires Statistical Contracts

Prompt-native behavior is often probabilistic. Do not accept or reject it based on one lucky run.

For each consequential P1/P2 capability define measurable acceptance thresholds appropriate to the responsibility, such as:

```text
schema-valid rate
task-success rate
hard-invariant violation rate
tool-policy violation rate
behavioral-equivalence rate
unsupported-claim/error rate
fallback rate
latency percentile
token/cost percentile
disagreement rate
```

Specify:
- evaluation sample/source;
- minimum sample size or rationale;
- pass/fail threshold;
- hard-zero-tolerance failures;
- comparison baseline.

For hard invariants such as unauthorized tool use, governance bypass, secret leakage, or out-of-scope writes:

```text
allowed violation rate = 0
```

For stochastic quality metrics, use repeated/fresh cases and report uncertainty where practical rather than presenting a single percentage as exact truth.

Do not repeatedly rerun a failing evaluation until randomness produces a passing sample.

---

# 13. Behavioral Equivalence Requirement

When replacing deterministic Agent_X logic with prompt-only or prompt-driven behavior:

1. preserve the original implementation as the baseline;
2. define the pre-declared target contract before implementation;
3. if semantics are intended to remain unchanged, require behavioral equivalence;
4. if semantics intentionally change, require conformance to the approved target delta and preservation of all unaffected invariants;
5. run both implementations where practical;
6. compare outputs/side effects/latency/failure behavior;
7. test edge cases;
8. verify public/API/caller compatibility;
9. verify side-effect equivalence or explicitly approved differences;
10. verify rollback;
11. only remove old code after the prompt-native replacement proves sufficient.

Use shadow execution where useful:

```text
old deterministic behavior
        |
        +--> actual path
        |
prompt-native candidate
        |
        +--> shadow output
        |
compare
```

Do not remove the old path just because the new prompt looks simpler.

If the responsibility lacks an adequate behavioral contract, first add characterization evidence through a native-semantic-gate-authorized change.

For medium/high-impact runtime responsibilities, use staged rollout where practical:

```text
shadow
  ↓
canary
  ↓
limited accepted traffic/workload
  ↓
soak window / sufficient evaluation sample
  ↓
remove old path only after evidence threshold is satisfied
```

Keep rollback cheap until the prompt-native path has demonstrated stable behavior.

A short happy-path test is not enough to delete a mature deterministic implementation.

If required canary/soak evidence cannot be completed within the current OpenCode execution window:

```text
do not delete old implementation
do not fake completion
leave accepted state unchanged or keep approved shadow/canary state
mark candidate DEFERRED/BLOCKED_PREREQUISITE with explicit evidence requirement
resume later when sufficient evidence exists
```

Temporary deterministic fallback/dual-run paths must have:
- explicit semantic ownership;
- precedence rules;
- activation conditions;
- observability;
- retirement criteria.

Do not leave an old implementation indefinitely as an undocumented shadow source of behavior after the prompt-native path is accepted.

---

# 13A. Acceptance-Oracle Integrity — Do Not Weaken the Test to Pass the Prompt

A conversion may require new tests or corrections to defective tests, but it must not silently weaken the oracle that defines success.

When implementation and acceptance tests/evaluations change in the same semantic change:

1. identify every oracle change explicitly;
2. explain why the old oracle was incorrect/incomplete;
3. preserve unaffected baseline/holdout cases;
4. compare old and new oracle behavior;
5. obtain native semantic-gate/current-governance validation for the contract change.

Prohibited pattern:

```text
prompt candidate fails existing requirement
        ↓
relax test/evaluation threshold
        ↓
candidate now "passes"
```

unless the semantic target explicitly and legitimately changed that requirement before implementation.

For behavior-preserving conversions, acceptance criteria must not be relaxed merely to accommodate model variability.

Where practical, mutation-test or adversarially perturb the validator/evaluation to prove it detects broken prompt behavior.

---

# 14. Prompt Migration Anti-Slop Rules

Do not convert code into prompt slop.

Reject transformations that merely replace:

```text
clear deterministic code
```

with:

```text
"LLM, figure this out"
```

without a semantic contract.

Prompt-native conversion must reduce complexity while preserving clarity.

Reject a conversion if it creates:

```text
giant ambiguous prompt
duplicate prompt logic
hidden second planner
unbounded context
unstructured output
LLM-controlled authority
unverifiable behavior
unbounded retries
unbounded token cost
non-reproducible critical decision
latency regression with no benefit
new vendor lock-in without value
more prompt/compiler/adapter complexity than the code removed
hidden operational dependence on a specific model
prompt duplication disguised as semantic reuse
```

---

# 14A. Prompt Quality Contract

A prompt capability is not acceptable merely because it is natural language.

Every accepted prompt capability should be:
- single-responsibility or intentionally compositional;
- explicit about objective and non-objectives;
- explicit about trusted vs untrusted inputs;
- bounded in tools, attempts, context, tokens, latency, and cost;
- explicit about output schema;
- explicit about failure/unknown behavior;
- free of duplicated governance rules that belong in deterministic governance;
- free of vague catch-all wording such as "do whatever is best" where a contract can be stated;
- testable against representative and adversarial cases.

Prefer concise structured semantic instructions over giant prose prompts.

If a prompt grows because it is compensating for missing semantic structure, improve the semantic capability model rather than endlessly appending instructions.

---

# 15. Agent_X-Specific Anti-Clutter Rule

Prioritize eliminating Agent_X-specific generated clutter where behavior can be represented semantically.

Examples of suspicious code:

```text
single-use handlers
symbol-only adapters
algorithm-named placeholders
constant "adaptive" logic
thin wrappers around generic LLM calls
isolated generated modules
uncalled Evolution/Harvest files
duplicated planner logic
duplicated context assembly
duplicated decision trees
```

Before keeping such code, ask:

```text
Does this contain real deterministic behavior?
Does it enforce a hard invariant?
Does it own state?
Does it implement a protocol?
Does it provide performance that prompts cannot?
Does it provide safety?
Does it provide a reusable algorithm?
```

Before declaring code unused/dead, inspect not only static imports/callers but also:

```text
dynamic imports
registries
plugin/tool registration
configuration-driven dispatch
string/symbol lookup
subprocess entry points
reflection
generated entry points
runtime traces where available
```

`no static caller` does not prove `unused`.

If not, strongly consider replacing it with a semantic capability + prompt-driven execution.

---

# 15A. Net Complexity Must Decrease

A conversion is not successful merely because Python LOC decreases.

Evaluate net complexity across:

```text
deleted bespoke code
new prompt/template complexity
new semantic schema complexity
new adapter code
new validation code
new evaluation corpus
new dependencies/services
runtime token/cost burden
latency burden
operational/model dependency
CI/evaluation burden
provider/privacy burden
debuggability burden
failure modes
```

Reject or rework the conversion if total operational/architectural complexity increases without a compelling capability gain.

Prefer:

```text
one reusable prompt capability replacing many bespoke decision paths
```

over:

```text
one bespoke prompt + wrapper for every old function
```

---

# 16. Do Not Destroy Real Algorithms

A real algorithm must not be replaced by a prompt merely because a prompt can imitate its outputs on a few examples.

Keep deterministic implementations where they provide:

```text
proven complexity bound
stable optimization
graph algorithm
search algorithm
parser/compiler
scheduler primitive
index algorithm
numerical method
transaction algorithm
ranking/retrieval primitive
cryptographic operation
concurrency control
```

The LLM may choose parameters or strategy.

The underlying algorithm should remain code if doing so is more reliable and efficient.

---

# 16A. Semantic Coverage Requirement — Do Not Converge Over Only the Mapped Easy Parts

The transformation candidate inventory must cover the real Agent_X project, not just already-semanticized components.

Maintain at least two layers:

```text
artifact inventory:
  every relevant production/test/build/config/prompt artifact

semantic responsibility inventory:
  mapped responsibilities/capabilities and bindings
```

Classify inventoried artifacts explicitly:

```text
FIRST_PARTY_BEHAVIOR
FIRST_PARTY_GENERATED
TEST_OR_EVALUATION
BUILD_OR_TOOLING
PROMPT_OR_SEMANTIC
THIRD_PARTY_OR_VENDOR
GENERATED_VIEW
NON_BEHAVIORAL_DOC
RUNTIME_EVIDENCE_OR_DATA
```

Do not attempt to "prompt-convert" vendored/third-party source merely to reduce Agent_X LOC. Treat external code as a dependency boundary unless Agent_X intentionally owns/forks it through a separate semantic change.

Generated views and runtime evidence do not count as independent behavioral responsibilities.

Before final convergence:

- every relevant production source artifact must be inventoried;
- every behavior-affecting prompt/template/configuration must be inventoried;
- every known code-producing path must be inventoried;
- unmapped artifacts must be mapped, explicitly classified as generated/third-party/non-behavioral, or documented as a blocker;
- dead/uncalled code must not disappear from the denominator merely because it lacks a semantic node.

Report:

```text
artifact_inventory_coverage
semantic_responsibility_coverage
verified_binding_coverage
prompt_capability_coverage
```

`eligible_candidate_count == 0` is meaningless if substantial behavior-affecting code remains unmapped.

Do not declare final convergence until relevant behavior-affecting inventory coverage is complete enough to support the claim.

---

# 16B. Metrics Must Describe Accepted State, Not Aspirational Target State

Project transformation percentages and LOC/capability metrics must be calculated from the **accepted current repository + accepted current semantic state**.

Do not count:
- unpromoted target overlays;
- shadow candidates;
- failed candidates;
- temporary prompt capability experiments;
- code scheduled for deletion but still accepted;
as completed prompt-native conversion.

During an active migration, report separately:

```text
accepted_current_metrics
candidate_target_metrics
```

The headline `prompt_only_behavior_percentage` and `prompt_driven_overall_percentage` always refer to accepted current state.

---

# 17. Transformation Metrics

Maintain metrics across iterations.

At minimum:

```text
total Agent_X source LOC
bespoke decision/orchestration LOC
deterministic kernel LOC
prompt-only capability count
prompt-driven capability count
deterministic capability count
protected deterministic capability count
generated algorithm files
uncalled production modules
duplicate responsibilities
semantic coverage
test coverage
runtime evidence coverage
average prompt tokens
prompt execution latency
prompt failure rate
rollback success rate
behavioral-equivalence success rate
new dependency count
evaluation pass rate
prompt-injection failure rate
model disagreement rate
fallback rate
canary rollback rate
semantic responsibility coverage
artifact inventory coverage
verified binding coverage
protected-core binding coverage
prompt capability coverage
net complexity score
change-time vs runtime prompt capability count
runtime LLM call rate
remote-provider dependency count
statistical evaluation sample size
hard-invariant violation count
```

Also estimate:

```text
prompt_only_behavior_percentage
prompt_driven_behavior_percentage
deterministic_behavior_percentage
```

These percentages should be based on mapped semantic responsibilities/capabilities, not raw `.md` file count.

Use the fixed responsibility-weighting model established in preflight. Report both weighted and unweighted figures and explain material divergence.

Do not count:
- deleted/dead responsibilities;
- duplicate aliases;
- generated views;
- one capability split into many prompt fragments;
as multiple independent prompt-native successes.

---

# 17A. Project-Level Cost and Provider Budget

In addition to per-capability budgets, respect an Agent_X/project-level evaluation and runtime model budget.

Track at minimum:

```text
live-evaluation calls
runtime LLM calls
tokens
provider cost
wall-clock latency
fallback/provider-switch count
```

Do not run an unbounded number of live evaluations merely because the transformation loop is iterative.

If the authorized evaluation budget is exhausted:
- preserve current accepted state;
- record which candidates remain unevaluated;
- do not fake/assume successful verification;
- use deterministic/replay evidence only for what it can legitimately prove.

Cost savings are not allowed to justify skipping required high-criticality verification.

---

# 18. Directional Targets — Never Quotas

The desired mature architecture may roughly approach:

```text
prompt-only:
  40–55%

prompt/semantic-driven overall:
  65–75%

deterministic:
  25–35%
```

But:

```text
correct 45% prompt-only > unsafe 55%
correct 65% prompt-driven > artificial 75%
```

Do not convert a responsibility merely to meet a percentage.

The transformation is complete when further conversion would reduce quality or violate hard constraints.

---

# 19. Required Rollback Before Every Iteration

Before changing a selected responsibility:

```text
record accepted base revision
record semantic base revision
create semantic change
create/verify rollback checkpoint
freeze baseline tests/evidence
create/use existing Agent_X isolated candidate worktree/workspace
bind candidate worktree to semantic change ID + base revision
```

Do not perform experimental prompt-native migration directly in the accepted working tree when Agent_X's existing candidate/worktree mechanism is available.

After implementation:

```text
verify candidate
reconcile
promote
```

If failed:

```text
freeze failure evidence
rollback
verify previous accepted state
record failed approach
try a different strategy later
```

Never stack repeated failed prompt migrations on top of one another.

---

# 20. Transformation Ledger

Maintain a persistent transformation ledger.

Suggested file:

`PROMPT_NATIVE_TRANSFORMATION_LEDGER.md`

For each responsibility record:

```text
semantic responsibility ID
original mode
selected target mode
reason
old implementation bindings
new semantic/prompt bindings
deleted code
retained deterministic code
tests
shadow comparison
latency
token cost
failure rate
rollback checkpoint
result
candidate_status
attempt_number
failure_classification
next_eligible_after_condition
```

The ledger is reporting/provenance, not canonical architectural truth.

Any candidate status, accepted classification, semantic ownership, or transformation decision that affects what the loop is permitted to do next must be:
- represented in canonical semantic/change state through the native semantic gate; or
- deterministically reconstructible from canonical state/evidence.

The ledger may mirror those facts for convenience but must not be able to override them.

If ledger and canonical semantic state disagree:

```text
canonical semantic-gate state wins
mark ledger stale
rebuild/update ledger projection
```

---

# 21. Candidate Selection Priority

Each loop iteration must select a **different semantic responsibility**.

Prioritize candidates with high expected simplification value.

Score candidates based on:

```text
bespoke logic volume
number of duplicated branches
prompt suitability
semantic clarity
current slop risk
maintenance burden
testability
LLM reasoning advantage
deterministic requirement
runtime criticality
security sensitivity
latency sensitivity
criticality
privacy/data sensitivity
offline requirement
provider dependency
execution timing (change_time/runtime/both)
expected net benefit
```

Use a consistent conversion-value rubric.

For each candidate, score each dimension 0–5 with evidence:

```text
BENEFIT
  B1 bespoke-code/branch reduction
  B2 duplicate-responsibility removal
  B3 adaptability/reasoning advantage
  B4 maintenance/debug simplification
  B5 shared-capability reuse potential

COST/RISK
  R1 criticality/safety risk
  R2 latency/runtime dependency cost
  R3 provider/privacy/offline cost
  R4 verification/evaluation burden
  R5 nondeterminism/failure complexity
```

Default normalized value:

```text
benefit_score = B1+B2+B3+B4+B5
risk_score    = R1+R2+R3+R4+R5
net_conversion_score = benefit_score - risk_score
```

Use `minimum_conversion_benefit_threshold` against `net_conversion_score`.

If Agent_X already has a better approved scoring model, use it instead and record the mapping.

The score is a prioritization aid, not authority. Any hard governance/security/algorithm-preservation failure rejects conversion regardless of score.

Maintain candidate states:

```text
UNASSESSED
PROTECTED_DETERMINISTIC
KEEP_DETERMINISTIC
ELIGIBLE_P1
ELIGIBLE_P2
DEFERRED
BLOCKED_PREREQUISITE
IN_PROGRESS
PROMOTED
FAILED_RETRYABLE
FAILED_FINAL
SUPERSEDED
```

State semantics:

```text
DEFERRED
  prompt-native conversion might be useful later but current net score,
  timing, cost, or evidence does not justify action.
  Must record a concrete revisit condition.

BLOCKED_PREREQUISITE
  conversion cannot be evaluated/implemented until a named prerequisite
  is satisfied (coverage, tests, provider, dependency, governance, etc.).
```

Never select or reconsider `PROTECTED_DETERMINISTIC` for prompt conversion inside this loop.

Do not reconsider `KEEP_DETERMINISTIC` or `FAILED_FINAL` every loop unless new evidence or architecture materially changes its suitability.

Do not reconsider `DEFERRED` or `BLOCKED_PREREQUISITE` until their recorded revisit/unblock condition becomes true.

For `FAILED_RETRYABLE`, allow only a bounded number of **meaningfully different** strategies per responsibility (for example, 2–3 by default unless Agent_X governance/config defines another bound). If all bounded strategies fail for the same fundamental reason:

```text
mark FAILED_FINAL
retain/restore accepted implementation
record evidence
```

Do not create an infinite migration loop by making cosmetic prompt variations.

A retry must change a meaningful part of the strategy (for example capability decomposition, execution timing, context design, fallback, or validation). Re-running the same stochastic prompt until it passes is not a new strategy.

Prefer responsibilities that are:

```text
reasoning-heavy
policy-interpretation-heavy
planning-heavy
text/semantic-heavy
duplicated across subsystems
implemented by shallow handlers
```

Do not select `PROTECTED_DETERMINISTIC` responsibilities at all.

Also avoid weak prompt candidates such as:

```text
security boundary
transaction engine
filesystem guard
Git primitive
state persistence
low-latency hot loop
parser
cryptographic code
concurrency primitive
```

If one of these is discovered and not already protected, classify/protect it before continuing.

---

# 22. Conversion Decision

For each selected responsibility decide:

```text
PROTECTED_DETERMINISTIC
KEEP_DETERMINISTIC
CONVERT_TO_PROMPT_DRIVEN
CONVERT_TO_PROMPT_ONLY
HYBRIDIZE
MERGE_INTO_EXISTING_PROMPT_CAPABILITY
DELETE_AS_DUPLICATE_OR_DEAD
NO_CHANGE
```

Every decision must include evidence.

If the selected responsibility is protected:

```text
decision: PROTECTED_DETERMINISTIC
conversion: forbidden
action: record/verify protection binding and select another candidate
```

Do not attempt a trial prompt migration "just to compare."

`HYBRIDIZE` is an implementation decision, not a fourth metric class. After hybridization, each resulting semantic responsibility must still resolve to P1, P2, or D. In most cases, "LLM decides + deterministic execution" is P2.

A shared prompt capability may serve multiple responsibilities, but percentages are responsibility-based, not prompt-file/prompt-capability-count based.

A loop iteration that selects a candidate and concludes:

```text
KEEP_DETERMINISTIC
  -> candidate state KEEP_DETERMINISTIC

NO_CHANGE because benefit is currently insufficient
  -> candidate state DEFERRED + revisit condition

NO_CHANGE because a prerequisite is missing
  -> candidate state BLOCKED_PREREQUISITE + unblock condition
```

must record that conclusion so the next iteration selects a different unresolved candidate rather than cycling.

---

# 23. Required Analysis Before Conversion

Before coding:

```text
1. identify semantic owner
2. identify real callers/consumers
3. identify inputs/outputs
4. identify state/side effects
5. identify algorithms
6. identify hard invariants
7. identify latency/resource constraints
8. identify governance/security requirements
9. identify tests
10. identify runtime evidence
11. identify duplicate responsibilities
12. classify prompt suitability
13. classify criticality
14. classify data/privacy/provider requirements
15. identify deterministic/live evaluation strategy
16. identify offline/degraded-mode requirement
17. estimate net complexity and operational cost
18. classify execution timing and justify any runtime LLM dependence
19. define temporary fallback retirement criteria if dual-run is needed
```

Then update target semantics through the native semantic change gate.

---

# 24. Prompt Suitability Test

A responsibility is a strong prompt candidate if most of the following are true:

```text
requires interpretation/reasoning
input is semantic/textual/structured
multiple acceptable strategies exist
human-like judgment helps
behavior evolves frequently
hard-coded rules are growing
many special cases exist
output can be schema-constrained
result can be independently verified
latency is tolerable
side effects are mediated by deterministic governed tools
independent verification is feasible
```

A responsibility is a weak prompt candidate if most are true:

```text
exact deterministic output required
microsecond/millisecond hot path
security boundary
atomic transaction
state mutation primitive
protocol parser
cryptographic primitive
hard real-time behavior
unverifiable output
LLM failure is unacceptable
responsibility is PROTECTED_DETERMINISTIC
```

---

# 25. Prompt Conversion Pattern

Preferred conversion:

```text
OLD:

custom decision/orchestration code
        |
        v
many branches / handlers
        |
        v
action


NEW:

semantic capability
        |
        v
prompt compiler
        |
        v
LLM structured decision
        |
        v
deterministic validator
        |
        v
existing governed action/tool
```

Do not duplicate the action/execution layer.

Reuse existing Agent_X governed adapters.

If prompt behavior proposes code generation, file mutation, Git operations, network operations, or other side effects, the model output is only a **proposal**. The actual side effect must still be authorized by the pre-existing native semantic change and executed through the governed adapter within the declared write/tool scope.

---

# 26. Delete Old Code Only After Proof

Old implementation may be removed only after:

```text
prompt-native replacement exists
semantic bindings updated
tests pass
shadow/differential comparison passes where applicable
runtime evidence acceptable
latency/token cost acceptable
failure fallback works
rollback tested
no static callers remain bound to old path
no known dynamic/config/registry/plugin/subprocess callers remain bound
unresolved dynamic reachability is low enough for the deletion risk, or deletion is blocked
prompt/model evaluation suite passes
injection/adversarial suite passes
canary/soak requirement satisfied where applicable
accepted fallback behavior exists
```

Retiring the old implementation is itself a governed change.

If deletion/retirement was not already included in the currently authorized semantic target + write set:

```text
create a new native semantic change through the semantic gate
declare retirement target FIRST
authorize deletion/write scope
only then delete
```

Then:

```text
delete old implementation
remove only implementation-specific tests that are truly obsolete
PRESERVE or migrate behavioral/contract/acceptance tests for the replacement
remove dead config/imports
retire obsolete implementation bindings in TARGET state
reconcile exact candidate
promote target -> accepted current state through the native semantic gate + existing promotion mechanism
```

Never mutate accepted current semantic state directly.

Do not delete a behavioral oracle merely because the implementation that originally motivated it was removed.

---

# 27. Context Compression Requirement

Prompt-native conversion must reduce rather than explode context usage.

Use:

```text
semantic neighborhood
task-specific evidence
relevant governance
relevant interfaces
relevant tests
```

Avoid:

```text
entire repository
entire semantic graph
entire Git history
all Harvest documents
all runtime logs
```

Measure context size before/after.

Context selection itself is behavior-affecting. Version it, test it, and record the selected-context digest for consequential runs.

Do not let context compression silently omit a governance rule, invariant, required test, or known contradiction. If required context does not fit the budget, fail/partition/escalate rather than truncate critical constraints.

---

# 28. Shared Prompt Capabilities

Look for opportunities to consolidate multiple Agent_X behaviors into reusable semantic prompt capabilities.

Examples:

```text
analyze_candidate
compare_implementations
diagnose_failure
propose_semantic_change
analyze_impact
detect_slop
evaluate_harvest_item
evaluate_evolution_candidate
plan_refactor
build_task_context
```

Do not create one prompt per file.

Create prompts around **semantic responsibilities**.

Do not turn the shared prompt compiler into a giant hard-coded "god prompt." Keep:
- generic compilation/permission/provenance logic in code;
- capability-specific reasoning instructions in semantic capability records;
- reusable prompt fragments only where semantics are genuinely shared.

---

# 29. Harvest Integration

Harvest should stop turning every idea directly into code.

Preferred flow:

```text
Harvest idea
    |
    v
native semantic change gate
    |
    v
semantic responsibility match
    |
    +--> existing prompt capability?
    |       |
    |       v
    |   extend semantic/prompt behavior
    |
    +--> real deterministic algorithm required?
            |
            v
        code proposal
```

Harvest must ask:

```text
Can this be expressed as semantic/prompt behavior?
Does code provide a hard deterministic advantage?
Would new code duplicate an existing prompt capability?
```

Code becomes the exception, not the default.

Any code proposal still enters the native semantic change gate -> existing governed worktree/write -> verification -> promotion path.

However, Harvest must not classify something as prompt-suitable solely because a prompt can describe it. The same P1/P2/D suitability, independent verification, latency/cost, and algorithm-preservation rules apply.

---

# 30. Evolution Integration

Evolution should evolve:

```text
prompts
semantic strategies
context selection
tool-selection policy
structured reasoning templates
verification strategies
model routing
```

before generating new source modules.

Evolution may still evolve deterministic algorithms when the responsibility genuinely requires them.

Any evolved prompt/template/model-routing change is behavior-affecting and must also enter the native semantic change gate before becoming accepted Agent_X state.

Fitness must be based on measured behavior, not prompt eloquence.

Evolution must not optimize prompts against the same fixed evaluation set indefinitely. Maintain holdout/adversarial cases to reduce evaluation overfitting.

---

# 31. Assimilation Integration

When assimilating an external project:

```text
1. extract semantic capabilities
2. classify each capability P1 / P2 / D
3. assimilate prompt/semantic behavior where appropriate
4. assimilate deterministic algorithms only where required
5. avoid importing whole frameworks unnecessarily
```

Do not equate assimilation with copying source code.

Assimilated prompt capabilities must map into the existing Agent_X semantic model and governed tool/execution system; they must not bring a parallel semantic store, planner, governance authority, or change gate.

---

# 32. Borg Integration

Borg governance remains deterministic authority.

LLM/prompt behavior may:

```text
interpret policy
explain policy
identify relevant rules
propose compliant action
```

but deterministic Borg governance must decide whether the action is authorized.

Prompt-native conversion must never turn:

```text
"LLM believes this is authorized"
```

into authority.

---

# 32A. Prompt Memory and State Boundary

Do not let prompt transcripts become hidden canonical state.

Long-term Agent_X state must live in explicit semantic/persistent structures.

Prompt conversation history may be used as ephemeral working context, but consequential decisions must be materialized into structured semantic/evidence records.

Do not rely on an LLM "remembering" previous loop decisions instead of the transformation ledger and canonical semantic model.

Model/provider conversation IDs, cached chat histories, and hidden assistant memory must never be required to reproduce an accepted Agent_X capability.

---

# 33. UI Simplification

Prompt-native Agent_X should reduce UI complexity.

Prefer presenting:

```text
what Agent_X is doing
why
semantic responsibility
target change
blocked decision
verification result
rollback result
```

Do not expose every internal prompt/module/tool by default.

---

# 33A. Iteration Isolation and Context Reset

This is a long-running loop. Do not depend on the accumulated OpenCode conversation as authoritative state.

At the end of every iteration, persist a concise structured iteration record **before continuing or allowing context reset**, containing:

```text
iteration ID
selected responsibility
starting revision
semantic change ID
semantic_change_persisted_at
implementation_authorized_at
first_governed_write_at
classification
decision
files/prompts changed
candidate revision
verification evidence
promotion/rollback result
metrics delta
candidate-state updates
```

At the beginning of the next iteration:

1. re-query the native semantic change service/gate;
2. re-read canonical candidate/change state through the native semantic gate;
3. read the transformation ledger only as a projection/report;
4. use the accepted repository/semantic revision as truth;
5. reconcile/rebuild stale ledger entries if needed;
6. discard assumptions that exist only in prior conversational context.

If OpenCode/context is restarted, the loop must be resumable from repository + semantic state + ledger without hidden conversational memory.

---

# 33B. Protected-Core Adversarial Tests

Before relying on the transformation loop, add tests proving protected code cannot be promptified accidentally.

## Protected Test P1 — Protected Candidate Selection
Attempt to select a `PROTECTED_DETERMINISTIC` responsibility for P1/P2 conversion.

Expected:
```text
candidate rejected before semantic conversion proposal
```

## Protected Test P2 — Protection Removal
Attempt to remove `PROTECTED_DETERMINISTIC` within this loop.

Expected:
```text
rejected
requires separate explicitly authorized architectural project
```

## Protected Test P3 — Hidden Prompt Insertion
Modify a protected deterministic responsibility so a prompt/LLM result becomes the substantive runtime decision while the semantic mode still claims `deterministic`.

Expected:
```text
classification-integrity failure
candidate rejected
```

## Protected Test P4 — Governance Promptification
Attempt to make Borg governance authorization depend solely on LLM output.

Expected:
```text
blocked
```

## Protected Test P5 — Semantic Change Gate Promptification
Attempt to replace the native semantic change-gate transaction/authorization enforcement with LLM judgment.

Expected:
```text
blocked
```

## Protected Test P6 — Guard Adapter Promptification
Attempt to replace deterministic file/patch/subprocess/network/Git permission enforcement with prompt judgment.

Expected:
```text
blocked
```

## Protected Test P7 — Real Algorithm Degradation
Attempt to replace a protected parser/graph/index/concurrency/numerical primitive with an LLM approximation.

Expected:
```text
blocked unless the algorithmic primitive remains deterministic
```

## Protected Test P8 — Protected Refactor
Perform a normal deterministic refactor of protected code through the native semantic change gate while preserving `PROTECTED_DETERMINISTIC`.

Expected:
```text
allowed if semantics/invariants remain valid
```

This proves the protection blocks **prompt conversion**, not legitimate maintenance.

---

# 34. The Transformation Loop

Repeat the following loop.

## LOOP STEP 1 — Read Current State

Use the native semantic change service/gate to query:

```text
accepted semantic state
current code bindings
prompt capabilities
deterministic capabilities
coverage
known drift
known slop
recent transformations
candidate-state inventory
accepted prompt/model versions
evaluation suites
failed/final candidates
current weighted P1/P2/D/PD metrics
artifact inventory coverage
semantic responsibility coverage
verified binding coverage
protected-core binding coverage
unmapped behavior-affecting artifacts
tracked code artifacts not yet semantically classified
```

## LOOP STEP 2 — Select Candidate

Select a different semantic responsibility.

Maximize diversity across:

```text
Harvest
Evolution
orchestration
planning
assimilation
UI
semantic systems
agent coordination
evaluation
memory/intelligence
```

Avoid repeatedly optimizing the same subsystem.

Within one full candidate sweep, do not select the same responsibility twice unless the previous attempt was explicitly `FAILED_RETRYABLE` and the new attempt is a meaningfully different strategy.

Do not select a responsibility marked `PROTECTED_DETERMINISTIC`.

Do not select a responsibility already marked `KEEP_DETERMINISTIC`, `FAILED_FINAL`, or `PROMOTED` unless new evidence materially changes the prior decision.

Do not select `DEFERRED` or `BLOCKED_PREREQUISITE` candidates unless their recorded revisit/unblock condition is now satisfied.

## LOOP STEP 3 — Analyze Prompt Suitability

Classify:

```text
execution mode:
  P1 prompt-only
  P2 prompt-driven
  D deterministic
  PD protected deterministic (conversion forbidden)

criticality:
  C0 / C1 / C2 / C3

execution timing:
  change_time / runtime / both
```

If the responsibility is protected:

```text
record/verify PROTECTED_DETERMINISTIC
do not prompt-convert it
continue to next candidate
```

If ordinary D is clearly correct:

```text
record KEEP_DETERMINISTIC
do not rewrite it for prompt conversion
continue to next candidate
```

## LOOP STEP 4 — Propose Semantic Change FIRST

Through the native semantic change gate:

```text
create semantic change
update target semantics
declare target mode
declare prompt capability
declare prompt/model/context versions
declare retained deterministic kernel
declare execution timing
declare runtime-model justification if applicable
declare fallback/retirement plan
declare code/prompts/config to remove or change
declare invariants
declare tests
declare rollback
```

No code change yet.

## LOOP STEP 5 — Validate

Run:

```text
governance
impact
duplication
slop
algorithm authenticity
protected-core check
security
latency
resource
dependency
caller/consumer
prompt-injection exposure
model/provider dependency
context-budget feasibility
independent-verification feasibility
net complexity/operational cost
criticality suitability
data/privacy/provider compliance
offline/degraded-mode behavior
evaluation architecture
```

If unsafe:

```text
reject change
record reason
continue
```

## LOOP STEP 6 — Checkpoint

Create/verify rollback checkpoint.

## LOOP STEP 7 — Implement Narrowly

Implement the smallest valid transformation.

Possible changes:

```text
semantic capability
prompt compiler extension
structured output schema
generic validator
adapter to existing tools
delete obsolete bespoke decision code
```

Do not rewrite unrelated systems.

## LOOP STEP 8 — Verify

Run:

```text
existing tests compared to recorded baseline
new tests
no new unrelated regressions
behavioral equivalence / approved target-delta conformance
shadow comparison
edge cases
failure fallback
latency
token cost
model failure
model disagreement
prompt injection
malformed output
tool-permission escalation
context overflow
model/provider drift
canary/shadow where required
rollback test
deterministic unit/replay tests
live approved-model evaluation
privacy/redaction checks
execution-trace/debuggability checks
holdout/fresh-evaluation evidence where required
statistical acceptance thresholds/sample requirements
acceptance-oracle integrity
dynamic caller/reachability checks before deletion
semantic_change_persisted_at < implementation_authorized_at < first_governed_write_at
```

## LOOP STEP 9 — Reconcile

Through the native semantic change gate reconcile against the **exact frozen candidate revision/configuration**:

```text
target semantics
actual source/prompt/template/config changes
accepted prompt/compiler/model identifiers
structured prompt behavior
tests/evaluation results
runtime/shadow/canary evidence
provider/privacy policy
actual write set vs authorized write set
```

Do not reconcile evidence from one candidate/model/configuration/worktree and promote another.

Verify candidate worktree base freshness before promotion. If accepted base changed in a semantically relevant way while the candidate was being evaluated:

```text
revalidate/rebase/replan through the native semantic gate
rerun affected verification
```

A clean Git merge does not prove semantic freshness.

## LOOP STEP 10 — Promote or Roll Back

If successful:

```text
promote
update ledger
continue
```

If failed:

```text
capture failure
rollback
verify restoration
record failed approach
continue later with different strategy
```

## LOOP STEP 11 — Recalculate Project Metrics

After promotion/rollback, recompute metrics from the newly accepted current state.

Update:

```text
prompt-only %
prompt-driven %
deterministic %
bespoke LOC
prompt capability count
duplicate/slop count
latency
token cost
failure rate
evaluation pass rate
model disagreement rate
prompt-injection failure rate
fallback rate
net complexity
runtime LLM call rate
change-time vs runtime prompt ratio
```

## LOOP STEP 12 — Convergence Test

Do not stop based only on the LLM saying "nothing else looks useful."

Build the unresolved candidate set from the semantic responsibility inventory.

A responsibility is **conversion-eligible** only if:

```text
candidate state is UNASSESSED / ELIGIBLE_P1 / ELIGIBLE_P2 / FAILED_RETRYABLE
candidate is NOT PROTECTED_DETERMINISTIC
prompt suitability is P1 or P2
net_conversion_score >= predeclared minimum_conversion_benefit_threshold
independent verification is feasible
security/governance constraints are satisfiable
latency/cost budgets are satisfiable
rollback is available
```

If one or more eligible candidates remain:

```text
continue loop with the highest-value candidate,
while maintaining subsystem diversity
```

If no eligible candidates remain:

```text
perform final full-project audit
```

After the final audit, rebuild the candidate set.

Stop only when:

```text
eligible_candidate_count == 0
AND
full audit produced no new eligible candidates
AND
all accepted transformations are reconciled/promoted or rolled back
AND
no unresolved conversion candidate is left IN_PROGRESS
AND
artifact/semantic coverage is sufficient to prove no major unmapped conversion pool remains
AND
protected-core binding coverage is complete enough to prevent accidental promptification of hard boundaries
AND
no post-cutover governed change lacks a prior native semantic-gate transaction, and the bootstrap gate implementation is backed by the one-time bootstrap semantic record
```

Do not convert low-value responsibilities merely to avoid convergence.

---


---

# 35. Final Full-Project Audit

When the loop believes it has converged, perform a complete audit across the whole mapped Agent_X semantic project.

Check every major responsibility **and every unmapped/inventoried behavior-affecting artifact**.

If an artifact is behavior-affecting but has no semantic responsibility, map/classify it before deciding convergence.

Also scan every protected responsibility and verify:

```text
protection still present
real code bindings still resolve
no hidden LLM decision moved inside invariant boundary
no prompt/tool path bypasses deterministic enforcement
```

For each ask:

```text
Could this become prompt-only?
Could this become prompt-driven?
Is deterministic code genuinely required?
Is this bespoke code duplicated?
Is this code merely orchestration?
Is this a real algorithm?
Is this stateful/security-critical?
Can existing generic tools replace it?
Would conversion preserve existing planner/Borg/OpenCode/governed-adapter boundaries?
Would conversion preserve semantic/vector reconstruction fidelity?
```

Also inspect:

```text
uncalled production modules
generated evolution code
Harvest-created modules
thin wrappers
duplicated planners
duplicated decision trees
duplicated prompt builders
hard-coded policy logic
dead adapters
unused configuration
duplicated prompt templates
prompt capabilities with no real caller
model-specific hacks
unbounded retry loops
prompt-injection exposure
context selectors that can omit hard constraints
prompt migrations that increased total complexity
runtime LLM calls that could be compiled to change-time decisions
stale dual-run/fallback paths that should be retired
capabilities overfit to visible evaluation cases
acceptance tests/evaluations weakened to accommodate a prompt
old code deleted despite unresolved dynamic/config-driven reachability
loop decisions that exist only in chat rather than ledger/semantic state
```

If the audit finds another worthwhile conversion:

```text
return to loop
```

If the audit finds no substantive safe conversion:

```text
stop
```

Do not perform cosmetic conversions merely to increase prompt percentages.

---

# 36. Final Scoring

Score from 0–10:

```text
prompt-native architecture
semantic-first integration
semantic-first change-gate compliance
bespoke-code reduction
deterministic-kernel quality
protected-core integrity
prompt capability reuse
anti-slop effectiveness
algorithm preservation
behavioral equivalence
testability
governance integrity
security
rollback reliability
model-failure handling
prompt reproducibility
context efficiency
latency
token cost
Harvest integration
Evolution integration
assimilation integration
UI simplicity
maintainability
prompt-injection resistance
model-drift resilience
independent verification quality
net complexity reduction
candidate-loop convergence quality
semantic/artifact coverage
provider/privacy safety
offline/degraded-mode resilience
stable-test/live-evaluation separation
change-time vs runtime architecture quality
prompt decision traceability/debuggability
evaluation-overfitting resistance
statistical evaluation rigor
acceptance-oracle integrity
dynamic reachability/deletion safety
iteration resumability
P1/P2/D/PD classification honesty
fallback-model governance
ledger/canonical-state consistency
exact candidate/model/config reconciliation
existing Agent_X planner/Borg/OpenCode integration
semantic/vector reconstruction preservation
no-parallel-stack integrity
```

If an in-scope score is below 10 because of a fixable defect:

```text
create semantic change
fix through the native semantic gate
verify
rescore
```

Repeat until another full audit produces no substantive update.

---

# 37. Required Final Report

Create:

`AGENT_X_PROMPT_NATIVE_TRANSFORMATION_REPORT.md`

Include:

```text
starting source LOC
ending source LOC

bootstrap semantic change ID
bootstrap semantic-record timestamp
first bootstrap code-write timestamp
native semantic-gate cutover revision
bootstrap-exception closure proof
optional Architectural MCP added: yes/no

starting bespoke orchestration/decision LOC
ending bespoke orchestration/decision LOC

prompt-only capability count
prompt-driven capability count
deterministic capability count
protected deterministic capability count

estimated prompt-only behavior %
estimated prompt-driven overall %
estimated deterministic %

accepted-current metrics vs any remaining target/deferred metrics

major code removed
major deterministic code retained
why retained

shared prompt capabilities created

Harvest changes
Evolution changes
assimilation changes

performance impact
token-cost impact
failure-rate impact
baseline failures vs ending failures
new unrelated regressions: must be zero

rollback tests
failed transformation approaches

protected deterministic responsibilities
with real Agent_X bindings and protection reasons

remaining ordinary deterministic responsibilities
why they should remain code

remaining prompt-conversion candidates
if any

KEEP_DETERMINISTIC responsibilities
with evidence

FAILED_FINAL conversions
with reason

DEFERRED candidates
with revisit condition

BLOCKED_PREREQUISITE candidates
with unblock condition

candidate-score distribution
and scoring model used

model/prompt version matrix
evaluation-suite summary
prompt-injection/adversarial results
canary/shadow results
net complexity before/after
artifact/semantic coverage
provider/privacy impact
offline/degraded-mode impact
deterministic test vs live-evaluation split
change-time vs runtime prompt capability distribution
runtime LLM call/cost impact
fallback paths retained/retired
current capability matrix
existing Agent_X systems reused vs adapted vs newly required
planner/Borg/OpenCode/governed-adapter integration
semantic/vector reconstruction impact
parallel-system avoidance proof
statistical evaluation thresholds/results
acceptance-oracle changes
dynamic reachability/deletion evidence
iteration/resume integrity
semantic-gate-first temporal-order proof for every governed transformation change
```

Do not claim a percentage that is not grounded in the semantic responsibility inventory.

---

# 38. Definition of Done

The transformation is complete when:

```text
EVERY post-cutover tracked code change went native-semantic-gate-first, including formatting/refactor/test/generated-code changes; the bootstrap gate implementation used the one-time bootstrap semantic record before its first write
EVERY post-cutover non-code behavior-affecting prompt/template/model/semantic/configuration change went native-semantic-gate-first
all semantic targets/intents were recorded before governed writes

the one-time bootstrap exception was used only to implement the minimum native semantic gate
the bootstrap semantic record predated the first bootstrap code write
the bootstrap exception was permanently closed after cutover
no Architectural MCP was assumed or required
if an Architectural MCP was later added, it is only an adapter over the native semantic gate and owns no independent authority/state

most reasoning/orchestration that benefits from LLMs is semantic/prompt-driven

protected deterministic code remains deterministic and was never prompt-converted

deterministic code remains only where it provides real value:
  safety
  state
  performance
  algorithms
  protocols
  persistence
  verification
  governance

Agent_X has a shared prompt compiler
prompt capabilities are semantic-responsibility based
structured outputs are validated
prompt provenance is recorded
model failure is bounded
rollback is proven
Harvest prefers semantic/prompt extension before new code
Evolution evolves prompts/strategies before new modules
assimilation classifies capabilities before importing code

old code is removed only after proof
no prompt slop replaced code slop
no real algorithm was degraded into probabilistic imitation
no second planner/semantic authority was created
prompt/model/context/evaluation/example/retrieval-corpus changes are versioned and native-semantic-gate-governed
no prompt transcript acts as hidden canonical state
independent verification exists for consequential prompt behavior
prompt-injection cannot expand authority/tool scope
no unbounded retry/self-agent loop exists
model/provider changes require re-evaluation
all protected deterministic responsibilities have canonical protection records + real code bindings
all remaining ordinary deterministic responsibilities have documented reasons
conversion-eligible candidate set is empty after a full audit
DEFERRED/BLOCKED_PREREQUISITE candidates have explicit revisit/unblock conditions
relevant artifact/semantic coverage is sufficient to make convergence meaningful
prompt-native behavior does not require hidden provider conversation state
sensitive context obeys deterministic provider/data policy
routine deterministic test suite does not require live external LLM availability
C2 prompt-native capabilities have appropriate independent/live evaluation and fallback
runtime LLM dependence exists only where runtime judgment is genuinely required
temporary dual-run/fallback paths have explicit retirement state
evaluation tuning is not based solely on exposed acceptance cases
consequential prompt decisions are traceable/debuggable
stochastic capabilities meet predeclared statistical acceptance criteria
acceptance tests were not weakened merely to pass prompt migrations
code deletion accounts for dynamic/config/registry/plugin reachability
the loop can resume without hidden conversational state
no new unrelated regression was introduced relative to baseline
OpenCode reached convergence without requiring routine user confirmation between iterations
third-party/vendor code was not counted as prompt-native conversion merely by exclusion/deletion
P1 metrics contain no hidden deterministic substantive decision logic
fallback models/providers were pre-evaluated for their allowed capabilities
transformation ledger does not function as a second semantic authority
reconciliation evidence binds to the exact candidate + prompt/model/config/worktree state promoted
headline transformation metrics are computed from accepted current state only
behavioral/contract tests survive implementation retirement where still applicable
old implementation retirement was itself native-semantic-gate-governed
every governed transformation change proves:
  semantic_change_persisted_at < implementation_authorized_at < first_governed_write_at
existing Epoch/Story/Task/Subtask planner remains canonical
Borg governance/execution remains deterministic authority
existing OpenCode integration/bridge (including MCP only if present) and governed adapters are reused
no parallel prompt-native planner/governance/semantic/MCP/write stack was created
no nonexistent current Agent_X mechanism was assumed as an implementation prerequisite
semantic/vector reconstruction direction and required F3/F4 fidelity are preserved
```

The final stopping condition is:

> **A full semantic review of Agent_X finds no additional UNPROTECTED code that can be safely and beneficially replaced by prompt-only or prompt-driven behavior without weakening the system, while every protected deterministic responsibility remains protected, correctly bound, and free of hidden prompt execution inside its invariant boundary.**

---

# 39. Core Philosophy

Do not optimize for the fewest lines of code.

Optimize for:

```text
fewest unnecessary bespoke lines of code
maximum semantic clarity
maximum reusable prompt-driven intelligence
minimum duplicated orchestration
small trusted deterministic kernel
strong governance
strong verification
strong rollback
```

The end-state should feel like:

```text
Agent_X kernel:
  small
  deterministic
  trusted
  reusable

Agent_X intelligence:
  semantic
  prompt-native
  adaptive
  model-driven
  evidence-checked
```

The transformation rule is:

```text
IF behavior requires judgment/reasoning:
    prefer semantic + prompt + LLM + deterministic verification

IF responsibility is PROTECTED_DETERMINISTIC:
    do not prompt-convert it in this loop

IF behavior requires hard guarantees:
    keep deterministic code

IF behavior is duplicate/slop:
    remove it

IF uncertain:
    preserve code until evidence proves prompt-native replacement is better
```

Never convert code merely because prompts are fashionable.

Never preserve code merely because deterministic code already exists.

Choose the representation with the best verified combination of:

```text
correctness
security
simplicity
maintainability
cost
latency
observability
rollback
testability
adaptability
```

Convert only when prompt-native Agent_X is **simpler or more capable without unacceptable loss of guarantees**.
