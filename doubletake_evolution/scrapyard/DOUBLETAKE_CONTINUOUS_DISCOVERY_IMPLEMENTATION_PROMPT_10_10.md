# DOUBLETAKE CONTINUOUS DISCOVERY — IMPLEMENTATION EXECUTION PROMPT

**Status: SPECIFICATION COMPLETE — DONE.** This is a complete implementation prompt ready for execution. The Definition of Done checkboxes represent implementation requirements to be verified when code is built, not incomplete sections of this document.

## 0. Mission

You are the coding LLM responsible for implementing the **DoubleTake Continuous Discovery and Assimilation Architecture** in the current `olejardamir/DoubleTake` repository.

This is an **implementation task**, not a design exercise. Do not rewrite the architecture into another proposal. Inspect the live repository, modify the canonical implementation, add/adjust tests, run proofs, and continue until the complete Definition of Done in this prompt is satisfied.

Reference architecture artifact used to derive this task pack:

```text
doubletake_continuous_discovery_assimilation_architecture_FINAL_v4.md
SHA-256: 387197e420a86d3fb7801d2543b648609a88079685fbf126d6240e54f098f911
```

This prompt is self-contained. If that architecture artifact is also present in the working environment, read it as additional authoritative detail. If wording appears to conflict, obey the stricter safety/governance requirement and preserve the architecture's final invariants.

This prompt was prepared against an DoubleTake `main` near commit `9a4143a708119f9ae5e65dc94607f9f3aa57cdc6`, but **live HEAD always wins for file ownership and current implementation shape**. Re-run the preflight instead of forcing the old layout.

The target behavior is:

```text
Balancer + Gap Filler + Frontier Discovery
        ↓
continuous bounded mining only
        ↓
human-readable, evidence-backed KnowledgeObjects
        ↓
durable Knowledge Store + Ready Queue
        ↓
manual or Auto Assimilation
        ↓
CURRENT canonical Assimilation front door
        ↓
bounded Assimilation campaign
        ↓
L1/FIC/governed implementation
        ↓
validation/review/canonical capability authority
```

The mining session is logically infinite while durable user intent is `RUNNING`. Individual units, epochs, queue leases, Assimilation campaigns, implementation units, validation runs, and checkpoints must all be bounded.

## 0.1 Plain-English mental model — memorize this first

A lower-capability coding model must be able to implement this without inventing architecture. Keep this exact mental model:

```text
MINERS READ AND RESEARCH.
MINERS DO NOT WRITE DOUBLETAKE.

EMBEDDINGS HELP FIND INFORMATION.
EMBEDDINGS ARE NOT CODE AND ARE NOT AUTHORITY.

THE KNOWLEDGE STORE SAVES HUMAN-READABLE EVIDENCE.

ASSIMILATION IS THE ONLY BRIDGE FROM KNOWLEDGE TO POSSIBLE CHANGE.

L1/FIC/GOVERNANCE DECIDE AND CONTROL THE ACTUAL CHANGE.

CONTINUOUS DISCOVERY KEEPS SCHEDULING SMALL BOUNDED EPOCHS
WHILE DESIRED_STATE == RUNNING.
ONLY THE USER CHANGES THAT INTENT TO PAUSED OR STOPPED.
```

If you remember only one rule, remember this:

> **A miner may produce knowledge about a possible change. A miner may never perform the change.**

## 0.2 Vocabulary — use these meanings consistently

- **Miner**: Balancer, Gap Filler, or Frontier Discovery running in discovery-only mode.
- **KnowledgeObject**: one durable, versioned, human-readable, evidence-backed finding.
- **Raw evidence**: the original source material or a digest-bound durable reference to it.
- **Derived index**: embedding/vector/search index rebuilt from canonical knowledge; never the canonical truth.
- **Knowledge Ready Queue**: durable queue of knowledge versions eligible to be considered by Assimilation.
- **Assimilation handoff**: durable conversion of one knowledge version or bounded coherent cluster into the current canonical Assimilation source path.
- **Assimilation campaign**: one bounded run of the existing campaign engine. Campaign completion does not complete mining.
- **Implementation lane**: existing L1/FIC/governed path that may create authoritative changes after Assimilation.
- **Desired state**: durable user intent: `RUNNING`, `PAUSED`, or `STOPPED`.
- **Operational state**: what the backend is currently doing: running, recovering, backing off, waiting, stopping, etc.
- **Baseline binding**: exact DoubleTake repository/workspace/relevant-file identity observed when a finding was produced.
- **Authoritative effect**: any write/promotion/adoption/publication/config/runtime mutation that changes DoubleTake behavior or governed state. Miners are forbidden from creating these.

## 0.3 The normal end-to-end success path

Implement and test this exact sequence:

```text
1. Miner performs one bounded read/research unit.
2. Miner retrieves the real supporting source material.
3. System converts the finding into human-readable knowledge.
4. System stores immutable KnowledgeObject version + evidence + provenance.
5. Dedup/relation/index services update derived metadata.
6. Eligible knowledge enters the durable Ready Queue.
7. Manual or Auto Assimilation leases a bounded item/cluster.
8. Handoff materializes a sealed human-readable source artifact and calls the CURRENT canonical Assimilation service/front door with live strategies and governance.
9. Assimilation may reject/defer/no-op/knowledge-only or create a governed implementation request.
10. Only existing L1/FIC/governed mutation + validation + review may change DoubleTake.
```

Any implementation path that skips one of the authority boundaries above is wrong.

## 0.4 Limited-context operating rule

This prompt is large because it contains the full task pack and final proof matrix. A simpler coding LLM must **not** try to reason about all sections at once.

Use this context discipline:

```text
ALWAYS keep in working context:
  Section 0 mental model
  Section 1 non-negotiable rules
  Section 2 execution rules
  current CD task
  directly relevant current code/tests

LOAD WHEN NEEDED:
  Section 3 data/state model for data-plane tasks
  Sections 5-12 for the relevant subsystem
  Appendix A only during the matching proof task / Phase 8
  Appendix B only during final invariant audit

DO NOT:
  regenerate a shorter substitute architecture from memory
  skip tasks because they are outside the current context window
```

The durable ledger is the memory of global progress. The current context only needs to solve one task correctly.

## 0.5 Phase map — follow this order exactly

| Phase | Task range | Primary output | Gate before next phase | Architecture coverage focus |
|---|---|---|---|---|
| 0 | CD-000..005 | live baseline + canonical authority/FIC inventory | L1/baseline/inventory evidence | current DoubleTake placement/authority |
| 1 | CD-010..029 | read-only Knowledge Store/data plane | CD-029 | human-readable knowledge, provenance, dedup, semantic derived index, migration |
| 2 | CD-030..042 | exactly-once Knowledge -> canonical Assimilation handoff | CD-042 | queue/outbox, bounded campaigns, capability separation |
| 3 | CD-050..056 | Frontier becomes miner-only | CD-056 | frontier research/embedding policy -> knowledge |
| 4 | CD-060..067 | Gap Filling becomes miner-only | CD-067 | gap detection preserved, direct apply removed |
| 5 | CD-070..078 | Balancer becomes miner-only | CD-077 + CD-078 | balancing intelligence preserved, direct apply removed |
| 6 | CD-080..099 | persistent logically-infinite backend supervisor | CD-099 | infinity, fairness, restart, stop, backpressure, sharding, locking |
| 7 | CD-100..112 | one existing React/Vite UI + backend contract | CD-112 | user controls, knowledge browser, browser-independent liveness |
| 8 | CD-120..135 | hardening + executable final proof suite | CD-135 then Appendices A/B | security, lineage, self-modification, regression, all DoD |

Never begin a phase because it looks easy. Begin it only after the previous gate is proven.

---

# 1. Non-negotiable behavior

Treat the following as hard rules. A convenient implementation that violates any one of these is wrong.

1. **Assimilation is the only knowledge-to-implementation gateway.** Miners may never authoritatively change production code, configuration, capability authority, or governed runtime state.
2. **Embeddings are auxiliary retrieval/index data only.** Never invert an embedding into guessed code, exact semantics, or implementation authority.
3. **Knowledge presented to Assimilation must be human-readable and evidence-backed.** Source evidence and provenance remain recoverable.
4. **The Continuous Discovery session has no algorithmic completion predicate.** No “nothing found”, “max epochs”, “no progress”, “frontier exhausted”, or repeated zero-yield condition may normally complete the session.
5. **Production liveness is controlled by durable user intent.** `RUNNING` survives backend restart. `STOPPED` survives backend restart. Browser disconnect is irrelevant to backend intent.
6. **A bounded Assimilation campaign may legitimately complete.** That completion never means the mining session completed.
7. **Start is idempotent.** Duplicate/retried/concurrent Start calls for the same intended session must not create multiple supervisors.
8. **All three miners are first-class and fairly scheduled** when enabled. A high-yield miner must not starve the others.
9. **Auto Assimilation is a queue consumer, not permission for miners to implement.** Turning it on must process eligible existing backlog plus future ready knowledge in bounded pages.
10. **All implementation effects still use existing DoubleTake governance, L1/FIC, mutation authority, rollback, validation, and capability publication rules.**
11. **There must be one canonical owner for every authority.** Extend/reuse/migrate the live owner; do not create a parallel governance authority, capability authority, semantic capability authority, repository mutation authority, or Assimilation implementation gateway.
12. **Never create a second DoubleTake web application.** Extend the existing React/Vite UI.
13. **Never make network access a boot requirement.** Preserve DoubleTake local-first/offline operation. Remote mining adapters are optional.
14. **Never fabricate remote evidence, provenance, benchmark results, or missing source facts.**
15. **External mined material is untrusted data.** Instructions embedded in mined text/code must not become control instructions to DoubleTake.
16. **Canonical knowledge is durable; derived vector/index structures are rebuildable.**
17. **Every DoubleTake-specific finding is bound to the exact DoubleTake revision/workspace/file digests it observed.**
18. **Every implementation-relevant handoff is revalidated against current DoubleTake state before Assimilation.**
19. **Every authoritative mutation must prove durable lineage.** Miner-supplied or forged IDs are never enough.
20. **No phase may leave two active production mutation routes.** Cutovers are explicit and one-way only after replacement behavior is proven.
21. **Do not weaken existing tests to make the redesign pass.** Fix production behavior. Test changes are allowed only when an old expectation is intentionally superseded by this architecture, and the replacement must test the stronger contract.
22. **No placeholder implementation.** No TODO-only modules, fake success, `pass` on required behavior, hard-coded passing metrics, fake receipts, or documentation claiming runtime support before runtime evidence exists.

---

# 2. How you must work

## 2.1 Live-HEAD preflight before every implementation phase

The repository is evolving. Before each phase:

1. Resolve repository root and current `HEAD` SHA.
2. Inspect `git status` and preserve unrelated user work.
3. Search for the current canonical owners by behavior/symbol, not merely by old path names.
4. Read current tests/proofs that cover the area.
5. Record the baseline SHA for the phase.
6. If `HEAD` changes materially while the phase is in progress, re-run the ownership/preflight inspection before promotion.

Do not recreate an old module merely because this prompt names it. If the live repository has consolidated or renamed it, extend the current canonical owner.

Never use `git reset --hard`, destructive checkout, broad clean commands, or deletion of unrelated files to make the task easier. Preserve user/unrelated changes and work around them.

## 2.2 Known baseline surfaces to inspect first

At the time this prompt was authored, important current surfaces included:

```text
L1/docs/03_L1_WHOLE_SYSTEM_PSEUDOCODE.md
L1/docs/05_L1_SHARED_TYPES_AND_INTERFACES.md
L1/fic/

tools/doubletake_evolve/collective_core/assimilation_campaign/front_door.py
tools/doubletake_evolve/collective_core/assimilation_campaign/source_resolver.py
tools/doubletake_evolve/collective_core/assimilation_campaign/kernel.py
tools/doubletake_evolve/collective_core/assimilation_campaign/

tools/doubletake_evolve/collective_core/service.py
tools/doubletake_evolve/collective_core/knowledge_corpus.py
tools/doubletake_evolve/collective_core/components_db.py
tools/doubletake_evolve/collective_core/assimilation_queue.py
tools/doubletake_evolve/gap_filling/service.py
tools/doubletake_evolve/learning/stabilization/code_balancer.py

current SemanticService / semantic index owner
current CapabilityAuthority owner
current canonical repository mutation lock / governed effect owner
current Frontier Discovery implementation
current API server/service routing
ui/
```

These are **inspection anchors**, not permission to duplicate them.

## 2.3 Persistent task ledger

Maintain a restart-safe local implementation ledger at:

```text
.doubletake-init/continuous_discovery_implementation_ledger.json
```

If the live repository has one different canonical generated-state root that all current evolution subsystems already use, place the ledger under that root instead. Record the actual path in the ledger header. Do not invent a third state root.

Use at least:

```text
NOT_STARTED
IN_PROGRESS
BLOCKED
DONE
VERIFIED
```

For every task record:

```text
task_id
title
baseline_sha
files_inspected
files_changed
tests_run
test_results
proof_refs
notes
status
```

A task is not `VERIFIED` merely because code was written. It becomes `VERIFIED` only after its stated acceptance checks pass.

On restart/context loss, load the ledger and continue from the first non-VERIFIED task whose dependencies are satisfied. Before a context/window boundary, persist the ledger and current test evidence so the next coding invocation can resume without redoing completed work.

## 2.4 One-task execution loop

For each atomic task below:

```text
1. inspect current canonical owner
2. inspect relevant tests
3. implement the smallest coherent change
4. add/strengthen targeted tests
5. run targeted tests
6. run directly affected proof(s)
7. inspect diff for duplicate authority / accidental scope expansion
8. mark task VERIFIED only with evidence
9. continue to next dependency-ready task
```

Do not stop after producing a plan. Do not stop after one phase. Continue until the stopping condition in Section 15 is satisfied.

## 2.5 Fail-closed behavior

When required authority, provenance, baseline identity, strategy, lock, storage capacity, migration state, or governance context is unavailable:

- preserve durable state;
- emit a typed blocked/waiting/degraded reason;
- do not silently invent a fallback authority;
- do not direct-write as a fallback;
- do not fabricate success;
- do not interpret “blocked” as global mining completion.

## 2.6 Deterministic decision rules for a simpler coding LLM

Do not improvise when repository reality differs from this prompt. Use this decision tree:

```text
IF a named file/path no longer exists:
    search by symbol/behavior/test references
    identify the live canonical owner
    edit that owner
    DO NOT recreate the old path merely for compatibility

IF required behavior already exists:
    inspect its tests and authority boundary
    strengthen/reuse it
    add missing proof coverage
    DO NOT create a second implementation

IF two apparent owners exist:
    stop that task
    determine which one is canonical from call sites/tests/governance
    migrate callers to one owner
    remove/disable the duplicate only after replacement tests pass

IF the canonical Assimilation front door is called without live strategies/governance and returns NO_REGISTERED_STRATEGY or GOVERNANCE_UNAVAILABLE:
    fix the caller wiring to the existing configured service/registries/governance
    OR extend the canonical strategy registry through its existing extension mechanism
    NEVER bypass Assimilation with direct apply/adopt/write

IF a target test fails:
    compare with CD-001 baseline
    if new/relevant -> fix it before VERIFYING the task
    if demonstrably pre-existing and unrelated -> record exact baseline evidence and keep targeted task tests green

IF remote/network evidence is unavailable:
    record remote-unavailable/degraded truthfully
    continue local/offline-capable work
    NEVER fabricate a remote result

IF storage/backpressure prevents new work while desired_state == RUNNING:
    enter WAITING_RESOURCE/BACKING_OFF/DEGRADED
    persist state
    retry boundedly
    NEVER mark mining COMPLETE or STOPPED

IF context/window/process ends:
    persist ledger + checkpoint first
    next invocation loads ledger and resumes the first unfinished dependency-ready task
```

## 2.7 Strict task order and phase gates

For reliability, execute `CD-*` tasks in the exact order listed in Section 4. Do not optimize by reordering them.

Exception: if one task is blocked only by a truly external dependency, you may complete later **read-only tasks in the same phase** that do not depend on it. You may not begin the next phase until every task in the prior phase is `VERIFIED` or the prompt explicitly defines an allowed external-block exception.

Phase rule:

```text
complete task -> targeted tests -> phase proof gate -> authority scan -> next phase
```

Never cut over a write authority before its replacement route and negative tests pass.

## 2.8 Per-task evidence template

After every task, write/update this structure in the durable ledger:

```text
TASK: CD-XYZ
STATUS: VERIFIED | BLOCKED | IN_PROGRESS
BASELINE_SHA: <sha>
CANONICAL_OWNER_INSPECTED: <path/symbol>
FILES_CHANGED: [...]
TESTS_RUN:
  - command: ...
    result: PASS | FAIL | BASELINE_EXCEPTION
PROOF_EVIDENCE: [...]
AUTHORITY_CHECK: PASS | N/A
NOTES: concise factual notes only
NEXT_TASK: CD-...
```

A task with no explicit `Steps` subsection still requires: inspect owner -> implement Goal -> add/strengthen tests -> satisfy every `Verify` statement -> record evidence.

## 2.9 Canonical placement fallback for genuinely new Continuous Discovery code

First reuse existing owners. Only when no current owner is suitable, use one coherent package rather than scattering new modules. The fallback package is:

```text
tools/doubletake_evolve/continuous_discovery/
    __init__.py
    models.py              # mining/knowledge/queue records and local enums
    store.py               # canonical knowledge/session persistence
    artifacts.py           # human-readable artifact materialization
    queue.py               # ready queue + outbox/reconciliation
    handoff.py             # KnowledgeObject -> canonical Assimilation bridge
    supervisor.py          # durable infinite supervisor
    scheduler.py           # bounded epoch + fairness policy
    backpressure.py        # bounded resource/backpressure policy
    miners/
        base.py            # read-only miner adapter contract
        balancer.py        # adapter around current Balancer intelligence
        gap_filler.py      # adapter around current Gap intelligence
        frontier.py        # adapter around current Frontier intelligence
```

This package is a fallback organizational home, **not** a new governance/capability/semantic/mutation authority. It must call the existing canonical owners for those functions.

UI work stays inside the existing `ui/` application. Backend routes stay inside the existing DoubleTake backend/API owner.

## 2.10 Default bounded limits when live DoubleTake has no stricter canonical value

Do not leave the infinite supervisor with unspecified bounds. If a current canonical config already owns an equivalent limit, reuse it. Otherwise add configurable defaults equivalent to:

```text
max_sources_per_miner_batch = 25
max_source_bytes_per_parse_chunk = 1_048_576       # 1 MiB
max_knowledge_objects_per_store_tx = 50
ready_queue_lease_size = 8
max_knowledge_objects_per_assimilation_campaign = 8
max_active_assimilation_campaigns = 2
max_parallel_miner_units = 3
max_miner_unit_seconds = 120
control_state_poll_seconds = 2
ui_page_size = 100
epochs_per_history_shard = 500
max_recent_epochs_in_memory = 100
```

These are safe starting defaults, not authority. Make them configuration values with validation. Tests must prove that changing a bound changes unit size, not global infinite-session semantics. No bound above may be interpreted as “stop mining after N total units.”

## 2.11 Autonomous execution rule

Do not ask the user to make ordinary implementation decisions that can be resolved from the repository, this prompt, tests, or the safer bounded choice. Continue implementing.

Only a genuinely external requirement such as unavailable credentials, inaccessible mandatory infrastructure, or an irreversible policy choice with no safe default may remain `BLOCKED`. Record it precisely and continue every independent task allowed by Section 2.7.

---

# 3. Canonical target model

Implement these concepts as typed contracts using current repository conventions. Names may adapt to existing canonical naming, but semantic separation is mandatory.

## 3.1 Separate state namespaces

Do not reuse one enum for unrelated subsystems.

Conceptually require distinct namespaces equivalent to:

```text
MiningDesiredState:
  RUNNING
  PAUSED
  STOPPED

MiningOperationalState:
  STARTING
  RUNNING
  PAUSING
  PAUSED
  BACKING_OFF
  WAITING_RESOURCE
  RECOVERING
  STOPPING
  STOPPED
  DEGRADED
  BLOCKED

KnowledgeState:
  DISCOVERED
  RETRIEVED
  PARSED
  EXTRACTED
  NORMALIZED
  EMBEDDED
  DEDUPLICATED
  KNOWLEDGE_READY
  ASSIMILATION_QUEUED
  ASSIMILATING
  ASSIMILATED
  VALIDATED
  DUPLICATE
  IRRELEVANT
  LOW_CONFIDENCE
  CONFLICTING
  DEFERRED
  OBSOLETE
  FAILED
  REJECTED
  NEEDS_REVIEW

QueueState:
  READY
  LEASED
  ACKED
  RETRY_WAIT
  DEAD_LETTER_OR_REVIEW
```

Keep current L1 lifecycle values (`BLOCKED`, `NO_CHANGE`, `IMPLEMENTED`, `VALIDATED`, `ACCEPTED`, `REJECTED`, `DEFERRED`, etc.) separate. Map only at explicit boundaries.

## 3.2 KnowledgeObject minimum contract

A durable KnowledgeObject/version must preserve at least:

```text
id
version
title
origin                    # balancer | gap_filler | frontier_discovery
source
source_type
source_uri_or_reference
source_timestamp
retrieval_timestamp
raw_material_reference
raw_material_digest
extracted_text_reference_or_bounded_payload
human_readable_summary
normalized_knowledge
evidence[]
provenance[]
relevant_doubletake_components[]
implications[]
limitations[]
contradictions[]
open_questions[]
confidence
reliability_score
relevance_score
novelty_score
priority_score
embedding_reference_or_payload
embedding_model_or_space_id
relationships[]
cluster_id
duplicate_of
lifecycle_state
assimilation_status
observed_doubletake_revision
observed_workspace_digest
relevant_file_digests
miner_epoch_id
created_at
updated_at
schema_version
canonical_digest
```

Requirements:

- immutable historical versions;
- current pointer/version relation is explicit;
- source facts are distinguishable from DoubleTake interpretation;
- summaries may synthesize evidence but may not replace it;
- canonical digest excludes nondeterministic formatting noise;
- embedding is optional/derived and never the canonical semantic record.

## 3.3 Durable supervisor model

The infinite session must be represented by a **small bounded manifest**, not a forever-growing array.

Conceptually include:

```text
session_id
workspace_id
desired_state
operational_state
generation
owner/lease identity
started_at
updated_at
last_heartbeat_at
last_checkpoint_ref
next_epoch_number
enabled_miners
fairness_cursor
backoff state
resource/backpressure state
auto_assimilation_enabled
schema_version
baseline/config digest
```

Epoch history, findings, queue items, receipts, and campaigns must be separately addressable/sharded.

## 3.4 Bounded units

Every loop iteration must use explicit budgets such as:

```text
max sources per miner batch
max bytes per retrieval/parse chunk
max knowledge objects per persistence transaction
max ready items per queue lease
max knowledge objects per Assimilation campaign
max execution steps/attempts in campaign
max wall time per cancellable miner operation
max UI page size
max compaction/archive shard
```

Production may run forever by scheduling new bounded units. It may not perform an unbounded individual operation.

## 3.5 Authority ownership table — do not blur these rows

| Concern | Canonical owner after redesign | Miners allowed? | Notes |
|---|---|---:|---|
| Discovery/search hypothesis | Balancer / Gap / Frontier miner policy | Yes | Read/research only |
| Canonical mined knowledge | Continuous Discovery Knowledge Store | Yes, via store API | Human-readable + evidence |
| Embedding/index | current semantic service/index infrastructure | Yes, derived use only | Rebuildable; no authority |
| Ready queue/outbox | Continuous Discovery queue owner | Yes, enqueue only | No implementation effect |
| Assimilation interpretation | current canonical Assimilation service/campaign engine | No direct bypass | Handoff goes here |
| Implementation authorization | existing L1/FIC/governance | No | Required for code changes |
| Repository mutation | existing canonical governed mutation + shared lock/rollback owner | No | One production authority |
| Capability publication/routability | current canonical CapabilityAuthority | No | Knowledge is not a capability |
| UI lifecycle intent | existing React/Vite UI -> backend API | User-facing only | Browser does not own liveness |

If code being written would make one row own another row's authority, stop and redesign that code.

---

# 4. Atomic implementation task pack

Complete tasks in dependency order. If a task already exists in the live repository, do not duplicate it: inspect it, strengthen it to this contract, add evidence, and mark the task verified.

For every task, the coding model must answer four questions before marking it `VERIFIED`:

```text
1. What is the live canonical owner?
2. What exact behavior changed or was proven already correct?
3. What negative test proves the forbidden path is blocked?
4. What command/evidence proves the required path works?
```

Do not begin the next task until these are recorded in the ledger.

## PHASE 0 — Baseline, authority inventory, and governance contract

### CD-000 — Establish live baseline
**Goal:** Capture current `HEAD`, dirty state, existing proof commands, and canonical owner inventory.

**Implement/inspect:** repository metadata only; do not change runtime behavior yet.

**Verify:** save baseline SHA and list current owners for governance, capability publication, mutation, Assimilation front door/campaign, semantic capability routing, Balancer, Gap Filling, Frontier, API, and UI.

### CD-001 — Prove current regression baseline
**Goal:** Know which failures are pre-existing before redesign changes.

**Steps:** run the narrow existing suites for Assimilation, Balancer, Gap Filling, Frontier/semantic stabilization, L1, and UI where available; record exact failures.

**Verify:** later phases may not introduce unexplained regressions relative to this baseline.

### CD-002 — Create/extend L1-governed implementation contracts
**Goal:** Make the redesign governable before mutation authority moves.

**Steps:** inspect current L1 FIC standards and root docs; add/update bounded FIC units for Continuous Discovery contracts, persistence, handoff, cutovers, supervisor, API/UI, and proof obligations. Do not invent a second governance format.

**Verify:** current L1 validators/proofs accept the new/updated FIC material.

### CD-003 — Add shared block/status vocabulary only where needed
**Goal:** Prevent ad-hoc global statuses.

**Steps:** first prefer subsystem-local typed states. If new shared L1 block codes/interfaces are genuinely required, add them to the current shared-types authority through governed docs/FIC and update dependent code afterward.

**Verify:** no miner module defines a conflicting copy of a shared L1 lifecycle status.

### CD-004 — Add authority-owner regression test
**Goal:** Detect future duplicate canonical owners.

**Verify:** static/dynamic test identifies exactly one current owner for governance authority, capability authority, repository mutation authority, Assimilation implementation gateway, and semantic capability routing authority.

### CD-005 — Add production-entrypoint inventory test harness
**Goal:** Make legacy cutover measurable.

**Steps:** inventory UI/API/CLI/background loop/service/compatibility-wrapper entrypoints for Balancer, Gap Filling, Frontier.

**Verify:** harness can later assert whether each path is read-only mining or routes implementation intent through Assimilation.

---

## PHASE 1 — Contracts and read-only knowledge data plane

### CD-010 — Define namespaced mining/knowledge/queue types
**Goal:** Implement separate typed state namespaces and transition validation.

**Verify:** invalid cross-namespace status assignment/transitions fail clearly; current L1 lifecycle types remain unchanged unless governed change was explicitly required.

### CD-011 — Define KnowledgeObject and immutable version model
**Goal:** Implement the minimum KnowledgeObject contract from Section 3.2.

**Verify:** deterministic serialization/digest; historical versions cannot be silently overwritten; DoubleTake observation binding is required for DoubleTake-specific claims.

### CD-012 — Define evidence and provenance contracts
**Goal:** Preserve source facts independently from model/miner interpretation.

**Verify:** evidence records include source reference/digest/timestamps and can be retrieved without the generated summary; fabricated missing provenance is rejected.

### CD-013 — Define MiningSessionRecord and EpochRecord
**Goal:** Keep the global supervisor manifest small and epoch history bounded/sharded.

**Verify:** session serialization size does not grow linearly with epoch count; epoch records are independently addressable.

### CD-014 — Define queue/outbox record contracts
**Goal:** Create typed ready/lease/ack/retry records with stable idempotency keys and lineage.

**Verify:** one knowledge version maps deterministically to a handoff identity for a given objective/baseline policy.

### CD-015 — Implement or extend the canonical Knowledge Store persistence
**Goal:** Durable local-first storage for KnowledgeObjects and versions without duplicating an existing DoubleTake knowledge authority.

**Decision order:**
1. inspect current `KnowledgeCorpus`, `ComponentsDB`, and any current durable knowledge/index stores;
2. if one can own the Section 3.2 immutable KnowledgeObject/version/evidence contract cleanly, extend that canonical owner;
3. if existing stores are intentionally different concerns and cannot satisfy the contract without corrupting their semantics, create the dedicated Continuous Discovery store from Section 2.9 and reference existing stores by stable IDs rather than copying canonical truth into both;
4. document which store is canonical for mined KnowledgeObjects and which stores are derived/specialized views.

**Requirements:** atomic writes; integrity digest; schema version; bounded transactions; corruption fails closed; sharding/paging; no one giant JSON list; no two independent canonical copies of the same KnowledgeObject.

**Verify:** restart/load, tamper detection, pagination, bounded-memory tests, and a one-canonical-owner test across KnowledgeCorpus/ComponentsDB/Continuous Discovery storage.

### CD-016 — Implement raw-material/evidence storage references
**Goal:** Preserve byte-faithful or source-faithful evidence without inflating every KnowledgeObject.

**Verify:** object points to raw artifact by digest/ref; retrieval verifies digest; missing/corrupt raw data is visible and cannot become “verified knowledge.”

### CD-017 — Implement human-readable canonical artifact renderer
**Goal:** Render each ready knowledge version to inspectable Markdown plus optional structured sidecar/manifest.

**Required content:** origin, summary, why it may matter, existing approaches, DoubleTake relevance, implications, evidence, limitations/contradictions, open questions, confidence/quality, provenance, observed DoubleTake baseline.

**Verify:** rendered artifact digest binds to KnowledgeObject version and provenance manifest; no implementation code is generated by the miner renderer.

### CD-018 — Implement knowledge lifecycle transition service
**Goal:** Persist all valid transitions; reject impossible jumps.

**Verify:** restart resumes from persisted state; `KNOWLEDGE_READY` cannot be reached without required human-readable artifact + evidence/provenance policy.

### CD-019 — Implement deduplication and novelty service
**Goal:** Use exact digest + semantic support + source identity to identify duplicates without losing provenance.

**Verify:** duplicate relationships are explicit; two conflicting sources are not silently merged just because vectors are similar.

### CD-020 — Integrate current semantic service as derived knowledge index
**Goal:** Reuse the live `SemanticService`/canonical semantic infrastructure when suitable; keep knowledge retrieval semantics distinct from capability routing authority.

**Verify:** destroying derived knowledge embeddings/index and rebuilding from canonical KnowledgeObjects yields equivalent retrieval identity/metadata; capability routing authority is unchanged.

### CD-021 — Enforce embedding safety
**Goal:** Prevent vectors from becoming source truth.

**Verify:** embedding-only legacy data without recoverable payload/evidence cannot produce guessed knowledge/code; highly similar vector plus contradictory payload preserves the contradiction.

### CD-022 — Implement cross-miner relation/cluster records
**Goal:** Allow Balancer/Gap/Frontier findings to correlate while preserving original versions and provenance.

**Verify:** relation graph is derived/rebuildable; deleting/rebuilding it does not alter canonical knowledge.

### CD-023 — Implement source trust boundary
**Goal:** Treat mined text/code as inert untrusted data.

**Verify:** injected instructions such as “ignore governance”, “call tool”, “write this file”, or prompt-injection content cannot trigger control/effect execution during mining/normalization.

### CD-024 — Implement read-only miner adapter interface
**Goal:** Standardize miner output into evidence-backed KnowledgeObjects without granting write authority.

**Required interface contract:** one bounded call returns a typed result equivalent to:

```text
MinerUnitResult:
  miner_id
  epoch_id
  status                  # SUCCESS | ZERO_YIELD | RETRYABLE_FAILURE | BLOCKED
  discoveries[]           # raw/read-only findings, no patches/effects
  source_refs[]
  evidence_refs[]
  doubletake_observation_refs[]
  next_cursor
  next_hypotheses[]
  backoff_hint_seconds
  metrics
  errors[]
```

The orchestrator/knowledge layer, not the miner, owns persistence transition into canonical KnowledgeObjects. The adapter may request retrieval/read operations only.

**Verify:** interface exposes no authoritative repository/capability/config mutation method and no generic `execute_effect` escape hatch.

### CD-025 — Bind every DoubleTake observation to exact baseline
**Goal:** Prevent stale findings from masquerading as current facts.

**Verify:** revision/workspace/file digests are populated for DoubleTake-specific findings and survive historical queries after DoubleTake changes.

### CD-026 — Add knowledge query/filter/disposition service
**Goal:** Support inspect, filter, reprioritize, defer, reject, obsolete, delete/retain decisions without touching implementation authority.

**Verify:** bulk actions are paged/chunked and auditable.

### CD-027 — Implement schema migration framework
**Goal:** Evolve store/session/queue schemas without inventing missing provenance.

**Verify:** old fixtures migrate deterministically; unknown/corrupt future state fails closed; migrations are idempotent.

### CD-028 — Implement archive/compaction primitives
**Goal:** Allow infinite history to remain operationally bounded per shard.

**Requirements:** digest-preserving manifest, atomic/recoverable compaction, stable evidence refs, derived index rebuild support.

**Verify:** crash mid-compaction recovers; active mining reads/writes unaffected shards safely.

### CD-029 — Add Phase-1 read-only proof gate
**Goal:** Prove the new data plane can exist without changing any current mutation path yet.

**Verify:** all Phase-1 tests pass; current production behavior still follows baseline mutation authorities; no documentation claims cutover happened yet.

---

## PHASE 2 — Canonical Knowledge → Assimilation handoff

### CD-030 — Implement or generalize the durable Knowledge Ready Queue
**Goal:** Queue ready knowledge independently of miners and campaigns while reusing existing DoubleTake queue machinery when it already provides the needed ownership semantics.

**Decision order:** inspect current `assimilation_queue.py`, the Gap Filling exactly-once handoff store, campaign queue/state, and any canonical queue owner. Generalize/reuse the best current owner if it can represent KnowledgeObject version + lineage + lease/ACK/retry semantics. Create a new queue module only if no current owner can do so without conflating incompatible concerns.

**Requirements:** bounded pages, leases, retry/backoff, idempotency key, integrity, priority advisory only, restart recovery, one canonical Ready Queue authority.

**Verify:** duplicate enqueue is idempotent; lease expiration/restart does not duplicate logical handoff effects; source scan/owner test proves there is one production Ready Queue owner for this workflow.

### CD-031 — Implement transactional/outbox consistency
**Goal:** Prevent “knowledge marked queued but queue item missing” and the reverse.

**Verify:** crash at every persistence boundary reconciles to one valid outcome with no silent divergence.

### CD-032 — Implement `AssimilationHandoffAdapter`
**Goal:** Stable typed boundary from one KnowledgeObject version or bounded coherent cluster to current canonical Assimilation source semantics.

**Input:** only persisted `KNOWLEDGE_READY` versions selected by manual/auto queue logic. Never accept a free-form miner code patch as the authoritative payload.

**Must carry:** knowledge IDs/versions, source refs, provenance digests, materialized artifact ref/digest, workspace ID, observed/current DoubleTake baseline, reason/objective, idempotency key, `adopt=false` at miner boundary.

**Required behavior:**
1. load the exact immutable knowledge version;
2. re-check disposition and evidence/provenance completeness;
3. materialize/seal the human-readable source artifact through CD-033;
4. compute stable handoff identity;
5. submit only through CD-034 canonical service binding;
6. persist campaign/result lineage before ACK;
7. on retry, return/reconcile the existing logical handoff instead of creating a second effect.

**Forbidden interface:** no `apply`, `adopt`, `promote`, `write_code`, direct repository path write, or capability publication method may be exposed from this adapter to miners.

**Verify:** tests import/use the miner-facing adapter and prove there is no reachable direct adoption/implementation path.

### CD-033 — Materialize canonical knowledge source artifact for current front door
**Goal:** Use the current source/file-oriented Assimilation front door rather than inventing a second ingestion API.

**Required layout:** use a durable generated-state location keyed by knowledge ID/version, for example:

```text
<canonical_state_root>/continuous_discovery/assimilation_sources/<knowledge_id>/<version>/knowledge.md
<canonical_state_root>/continuous_discovery/assimilation_sources/<knowledge_id>/<version>/manifest.json
```

If the repository already has a canonical assimilation-source artifact layout, use that instead.

**Steps:**
1. render `knowledge.md` from the immutable KnowledgeObject version;
2. write a manifest containing knowledge ID/version, canonical digest, evidence/provenance digests, workspace/baseline binding, renderer/schema version, and file digest;
3. atomically persist and fsync/verify according to current store conventions;
4. build the current source intent using the front door's file syntax (`Assimilate this file:<quoted local path>` or the exact live equivalent);
5. never insert source text directly into the control prompt as instructions.

**Verify:** current resolver accepts the local artifact; source snapshot digest equals the manifest binding; path with spaces is handled correctly; substitution/tamper/missing manifest evidence fails closed.

### CD-034 — Bind to configured canonical Assimilation service/front door
**Goal:** Reuse the live service-owned strategies/effect registry/predicate registry/governance context.

**Decision order:**
1. search for the current service-level `run_assimilation_intent`/equivalent that already supplies live registries/governance; use it if present;
2. otherwise call the canonical `handle_assimilate_intent`/equivalent **with** the configured strategy/effect/predicate registries and governance from the live owner;
3. if human-readable knowledge files have no applicable registered strategy, add/extend a strategy through the canonical strategy registry mechanism and prove it is bounded;
4. never solve `NO_REGISTERED_STRATEGY` by calling a write/adopt/apply API directly.

**Forbidden:** instantiating a bare parallel campaign runtime that omits live registries or governance; copying the campaign engine; inventing a second knowledge-specific implementation gateway.

**Verify:** valid knowledge artifact reaches a registered strategy through the existing campaign engine; `NO_REGISTERED_STRATEGY` or missing governance is surfaced as blocked integration state, never direct implementation fallback.

### CD-035 — Implement manual Assimilation from stored knowledge
**Goal:** User/service can select one or bounded set of ready items and submit through the adapter.

**Verify:** campaign ID/decision/receipts are linked back to queue item and KnowledgeObject version.

### CD-036 — Implement Auto Assimilation controller
**Goal:** A backend consumer drains eligible ready knowledge in bounded pages while mining may continue.

**Implement this bounded loop:**

```text
while auto_assimilation_enabled:
    reread durable setting
    lease <= ready_queue_lease_size eligible items
    if no eligible items:
        wait/backoff boundedly
        reread durable setting
        continue
    revalidate each item against current baseline/disposition/lineage
    group only strongly related items, never > max_knowledge_objects_per_assimilation_campaign
    submit each bounded group through the SAME handoff used by manual Assimilation
    persist result/ACK or retry/defer reason
    reread setting before leasing the next page
```

**Verify:** enabling it after a backlog exists drains old eligible items plus future items without one giant campaign; disabling it prevents new automatic leases after the current bounded page while miners continue.

### CD-037 — Revalidate backlog eligibility before handoff
**Goal:** Old `KNOWLEDGE_READY` knowledge cannot blindly act on a changed DoubleTake.

**Exact rule:** if the finding contains DoubleTake-specific claims and its observed revision/workspace/relevant-file digest no longer matches, do not submit it as current. Re-run the required DoubleTake observation/relevance check and create a new immutable knowledge version if the finding remains valid. If it cannot be revalidated, set a typed stale/deferred/review state.

**Queue supersession rule:** if revalidation creates version `V+1`, the queue item for `V` must be terminally recorded as `SUPERSEDED`/ACKed-with-disposition (using the live queue vocabulary), store `superseded_by = V+1`, and enqueue `V+1` only if it is eligible. Never leave both versions independently eligible for the same logical handoff.

**Verify:** current baseline mismatch produces one of exactly: revalidated-new-version, deferred-stale, obsolete, or needs-review; stale finding is never silently promoted; superseded queue versions cannot both execute.

### CD-038 — Enforce campaign boundedness
**Goal:** One campaign handles one bounded coherent unit/cluster.

**Verify:** thousands of batches do not accumulate in a single campaign record; current campaign execution budgets remain effective.

### CD-039 — Persist complete source→knowledge→queue→campaign lineage
**Goal:** Every campaign can trace its materialized source back to immutable knowledge/evidence.

**Verify:** lineage query can walk both directions.

### CD-040 — Enforce no capability publication from knowledge/miner boundary
**Goal:** Knowledge remains non-routable `KNOWLEDGE` until governed Assimilation/promotion publishes a validated capability via current `CapabilityAuthority`.

**Verify:** high confidence/priority cannot make a KnowledgeObject executable.

### CD-041 — Integrate bounded post-Assimilation hygiene
**Goal:** Reuse current `AssimilationHygiene` after relevant bounded campaigns without coupling mining liveness to one campaign’s completion.

**Verify:** hygiene failure is visible/bounded and cannot falsely complete the mining session.

### CD-042 — Add Phase-2 handoff proof gate
**Verify:** manual handoff, exactly-once queue semantics, front-door compatibility, `adopt=false`, tamper rejection, stale baseline, and capability separation tests all pass before miner cutovers begin.

---

## PHASE 3 — Frontier Discovery cutover

### CD-050 — Inventory Frontier production entrypoints and authorities
**Goal:** Find every live path that discovers, promotes, reconstructs, synthesizes, adopts, or applies Frontier output.

**Verify:** update the production-entrypoint inventory with exact files/functions/tests.

### CD-051 — Split Frontier research from implementation authority
**Goal:** Preserve search/semantic/frontier intelligence but make output read-only knowledge.

**Verify:** Frontier path returns/stores KnowledgeObjects and never authoritatively writes production code/capabilities.

### CD-052 — Preserve embedding-supported research with evidence retrieval
**Goal:** Similarity/reconstruction may prioritize or hypothesize but human-readable payload/evidence is required.

**Verify:** vector candidate without recoverable evidence remains research-only/needs-review, not executable.

### CD-053 — Route implementation-relevant Frontier findings to Knowledge Ready Queue
**Goal:** Generalize current `ASSIMILATION` routing to all implementation-relevant Frontier findings.

**Verify:** queue handoff uses common CD-032 adapter and current front door.

### CD-054 — Preserve low-evidence novelty as research-only
**Goal:** Frontier novelty must not pressure automatic implementation.

**Verify:** low provenance/confidence can be stored, related, and revisited but cannot be auto-promoted to implementation.

### CD-055 — Close Frontier legacy promotion/write entrypoints
**Goal:** UI/API/CLI/background/service wrappers either mine only or route through KnowledgeObject→Assimilation.

**Verify:** static/dynamic no-direct-write proof for Frontier.

### CD-056 — Run Frontier cutover regression gate
**Verify:** existing honest Frontier/semantic tests still pass or are intentionally strengthened; no fabricated benchmark wins; no direct implementation path remains.

---

## PHASE 4 — Gap Filling cutover

### CD-060 — Inventory Gap Filling production entrypoints and authorities
**Goal:** Locate preview/start/auto-fill/apply/rollback/service/API/UI/background paths and current exactly-once Assimilation handoff.

### CD-061 — Preserve Gap detection/specification intelligence
**Goal:** Keep baseline capture, map/discover/verify/value/specification behavior as read-only mining evidence.

**Required transformation:** output the observed gap, why it is believed missing, evidence, expected supporting capability, candidate approaches, uncertainty, and DoubleTake baseline binding. Any old generated source candidate is optional raw evidence only; it is not the canonical knowledge and not an implementation payload.

**Verify:** the miner can still identify real gaps and produce evidence-backed Gap KnowledgeObjects without requiring a write/apply stage.

### CD-062 — Generalize existing exactly-once `adopt=false` handoff
**Goal:** Reuse the current durable handoff semantics behind the shared Knowledge Ready Queue/adapter.

**Verify:** retry + restart + retry-after-restart creates one logical Assimilation handoff.

### CD-063 — Remove Gap miner-owned authoritative apply
**Goal:** Gap Filling may no longer independently mutate repository/capabilities.

**Important:** do not delete useful transaction, baseline, validation, rollback, or governance code if the canonical implementation lane can reuse it.

### CD-064 — Reuse Gap write-side safeguards only inside the governed implementation lane
**Goal:** Preserve useful strict-baseline, qualification, transaction, receipt, mutation-lock, and rollback machinery without preserving Gap Filler as an implementation authority.

**Exact migration rule:** the code may remain physically in existing Gap modules if moving it would create needless churn, but the authoritative call graph must change. Only a canonical Assimilation/L1/FIC implementation adapter with resolved durable lineage may reach the mutating primitives. Miner/UI/preview/auto-fill paths may not.

**Critical distinction:** a source candidate generated by Gap Filler is evidence/a possible approach, not the implementation payload. Assimilation must independently decide the implementation unit. If it chooses materially identical code, that code must still be emitted as a new governed implementation artifact bound to the Assimilation/FIC lineage and revalidated against the current baseline.

**Verify:** miner cannot forge lineage to call these primitives authoritatively; direct candidate bytes from the miner cannot be promoted merely because old Gap validation passed.

### CD-065 — Redirect all legacy Gap apply/auto-fill paths
**Goal:** compatibility entrypoints convert implementation intent into human-readable KnowledgeObject + queue handoff rather than direct apply.

**Verify:** user-visible behavior reports queued/assimilation state truthfully instead of fake “applied.”

### CD-066 — Keep rollback compatibility for historical/current governed implementation
**Goal:** Ensure moving authority does not weaken rollback/recovery.

**Verify:** current governed implementation lane can still restore exact state on post-write failure.

### CD-067 — Run Gap cutover proof gate
**Verify:** gap detection quality, exactly-once handoff, no direct adopt/apply, forged-lineage rejection, and current Gap regression/proof suites pass.

---

## PHASE 5 — Balancer cutover

### CD-070 — Inventory Balancer production entrypoints and write helpers
**Goal:** Identify worker/API/CLI/loop/service functions for preview, prepare, qualification, sealed plans, production apply, rollback, mutation lock, and promotion.

### CD-071 — Preserve Balancer analysis and qualification intelligence
**Goal:** Balancer becomes comparative/structural miner producing human-readable imbalance findings with source/DoubleTake evidence.

**Verify:** useful scoring/qualification remains advisory evidence, not authority.

### CD-072 — Convert Balancer findings/plans to KnowledgeObjects
**Goal:** Any implementation-relevant Balancer result becomes human-readable knowledge before Assimilation.

**Required transformation:** describe the observed imbalance, evidence, affected DoubleTake components, why the existing candidate/transform suggests a possible direction, limitations, and baseline binding. If old Balancer code produced candidate source, store it only as digest-bound supporting evidence/raw material. The human-readable knowledge must stand on its own without requiring inversion of an embedding or blind adoption of candidate bytes.

**Verify:** sealed candidate/source may be referenced as evidence but is not directly promoted by the miner or treated as the implementation specification.

### CD-073 — Remove Balancer miner-owned authoritative apply
**Goal:** No Balancer public/background path can write production code on its own.

### CD-074 — Reuse Balancer safety mechanisms only inside the governed implementation lane
**Goal:** Keep useful immutable-plan sealing, staged qualification, exact source envelope handling, governance binding, shared mutation lock, rollback snapshot, and truthful receipt mechanisms without preserving Balancer as an implementation authority.

**Exact migration rule:** the safety code may stay in its current module when it is the canonical tested implementation, but its authoritative entrypoint must require resolved Assimilation/L1/FIC lineage. Balancer miner/public/background code cannot satisfy that requirement by inventing IDs.

**Critical distinction:** a Balancer-produced transform/candidate is non-authoritative evidence. Do not promote its candidate bytes directly from mining. Assimilation must independently derive/approve a bounded implementation unit; only then may the implementation lane reuse the sealing/qualification/rollback machinery on the governed implementation artifact.

**Verify:** safeguards remain functional, but are callable authoritatively only after durable canonical lineage is resolved; miner-origin candidate bytes alone can never unlock promotion.

### CD-075 — Redirect every legacy Balancer apply path
**Goal:** API/CLI/UI/background compatibility path becomes knowledge→Assimilation; no hidden “old apply” remains.

### CD-076 — Add Balancer stale-plan and forged-lineage tests
**Verify:** changed baseline blocks/re-evaluates; fabricated campaign/FIC IDs cannot unlock low-level mutation.

### CD-077 — Run Balancer cutover proof gate
**Verify:** current Balancer safety proofs remain green/strengthened, but direct miner mutation tests now prove denial/redirect.

### CD-078 — Global legacy-entrypoint closure gate
**Goal:** After Frontier+Gap+Balancer cutover, there must be exactly one authoritative implementation route.

**Verify:** production-entrypoint inventory shows no direct miner apply/adopt/promote route.

---

## PHASE 6 — Persistent logically-infinite supervisor

### CD-080 — Implement durable session create/start semantics
**Goal:** Exactly one active Continuous Discovery session may exist per DoubleTake workspace. Start is durable and idempotent.

**Exact semantics:**

```text
start(workspace):
  atomically read/create the workspace active-session pointer
  if a non-STOPPED session already exists:
      return that session; do not create another supervisor
  if none exists or the prior session is STOPPED:
      create one new session record + active pointer atomically/CAS
      desired_state = RUNNING
      enabled_miners default = all three
      return the new session

resume(session):
  reuses the same PAUSED session; it is not a new Start
```

A user may start a new session after a prior one is `STOPPED`; historical stopped sessions remain queryable. Concurrent Start calls race through one CAS/idempotency boundary and return the same winner.

**Verify:** concurrent/retried starts return one active session/generation; Stop then Start creates exactly one new session while preserving old history.

### CD-081 — Implement supervisor lease/generation fencing
**Goal:** Reuse/extend current campaign-style lease/fencing concepts for supervisor ownership.

**Verify:** stale supervisor cannot schedule/commit checkpoint state after ownership changes.

### CD-082 — Implement backend-owned run loop
**Goal:** Browser-independent scheduling while `desired_state == RUNNING`.

**Forbidden production logic:** global max epochs, no-progress completion, “frontier exhausted”, “all gaps closed”, or repeated-zero-yield stop.

### CD-083 — Implement bounded epoch scheduler
**Goal:** Each epoch gives bounded work to enabled miners and persists independent epoch/checkpoint state.

**Verify:** every epoch terminates even when sources hang/fail via timeouts/cancellation contracts.

### CD-084 — Implement three-miner fairness
**Goal:** Every enabled miner receives bounded service even when another miner has more work or higher scores.

**Use the simplest deterministic policy unless a current canonical scheduler already exists:** round-robin one bounded miner unit per enabled miner per epoch, with the starting miner rotated by persisted `fairness_cursor`. Backpressure may skip a miner only for a recorded resource-specific reason; it must remain eligible in later epochs.

**Fairness horizon:** with all three enabled and resources available, each miner must be scheduled at least once in every complete epoch and therefore within 3 miner-unit dispatches.

**Verify:** one high-yield miner cannot monopolize work; priority/novelty score never removes another enabled miner from the fairness horizon.

### CD-085 — Implement miner-specific durable cursors/exploration memory
**Goal:** Prevent infinite operation from becoming repeated identical queries/sources.

**Verify:** visited source/revision/hypothesis memory is bounded/sharded and supports diversification.

### CD-086 — Implement zero-yield diversification/backoff
**Goal:** Zero novelty changes search hypotheses/source classes/backoff; it never completes the session.

**Verify:** after 100 zero-yield epochs, a later new source/revision is still found.

### CD-087 — Implement explicit Pause/Resume
**Goal:** Pause stops launching new mining units after safe checkpoint; resume continues same durable session.

**Verify:** queued knowledge and stored data survive pause; Auto Assimilation control remains independent.

### CD-088 — Implement explicit Stop
**Goal:** Persist terminal user intent, stop new mining units, let/cancel bounded work per safe policy, checkpoint, then reach STOPPED.

**Verify:** restart does not resume a user-stopped session.

### CD-089 — Implement explicit processing-stop policies
**Goal:** Distinguish graceful mining Stop from what happens to already queued/running Assimilation work.

**Backend must support these three policies, even if the UI initially exposes them through one Stop dialog/action:**

```text
STOP_MINING_ONLY
STOP_MINING_AND_DRAIN_ASSIMILATION
STOP_ALL_PROCESSING
```

`STOP_ALL_PROCESSING` may cancel only at safe bounded cancellation boundaries. If current DoubleTake already has a `FORCE_ABORT` emergency mechanism, integrate it as a fourth abnormal policy; otherwise do not invent a half-safe kill primitive solely for UI symmetry.

**Verify:** policy choice is persisted; restart honors it; no half-applied authoritative mutation remains after cancellation/reconciliation; abnormal abort never reports clean completion.

### CD-090 — Implement bounded stop/pause observation latency
**Goal:** Every long operation periodically observes cancellation intent or has a documented maximum timeout.

**Required bound:** when no stricter live config exists, new miner operations use `max_miner_unit_seconds <= 120` and control intent is re-read at least every `control_state_poll_seconds <= 2` between sub-operations. Atomic governed commit/rollback sections may finish before stopping; they may not be interrupted mid-commit.

**Verify:** the slowest supported cancellable operation reaches a safe checkpoint/stop within its configured unit timeout plus bounded reconciliation/checkpoint overhead; the test records the actual upper bound.

### CD-091 — Implement restart reconciliation and auto-resume
**Goal:** Backend crash while RUNNING preserves intent, fences stale owner, reconciles interrupted units/effects, then resumes without Start click.

### CD-092 — Implement heartbeat/watchdog
**Goal:** Detect stale supervisor/worker without confusing host downtime with user Stop.

**Verify:** logical `RUNNING` intent survives host/backend downtime; execution resumes when an executor returns.

### CD-093 — Implement backpressure controller
**Goal:** Bound ready queue, in-flight campaigns, retrieval concurrency, memory, disk pressure, and provider rate usage.

**Verify:** pressure moves operational state to `BACKING_OFF`/`WAITING_RESOURCE`/`DEGRADED` while desired state remains RUNNING; no silent drops.

### CD-094 — Implement resource accounting/budgets
**Goal:** Track bounded per-unit resource use and long-run totals without turning budget exhaustion into false completion.

**Verify:** per-unit exhaustion retries/defer/waits according to policy; session intent remains durable.

### CD-095 — Implement infinite-history sharding/paging
**Goal:** No session/campaign/in-memory list grows forever.

**Verify:** long soak keeps active memory bounded and page/shard access stable.

### CD-096 — Implement platform-safe locking mode
**Goal:** Cross-process safety on supported platforms; fail closed or enforce safe single-process mode where required primitives are unavailable.

**Verify:** never silently pretend a process lock exists.

### CD-097 — Implement runtime version pinning for self-modification
**Goal:** A running bounded worker/campaign executes against a known code/config version; changes to mining/Assimilation machinery drain/checkpoint and switch atomically.

**Verify:** failed new version can recover/rollback without mutating execution underneath old workers.

### CD-098 — Add test-only bounded horizon without production stop logic
**Goal:** Tests can run N epochs/seconds deterministically.

**Verify:** test horizon is injected/test-only and cannot become a production completion predicate.

### CD-099 — Run supervisor soak/recovery gate
**Verify:** infinite liveness, zero-yield recovery, duplicate Start, crash/restart, persistent Stop, fairness, backpressure, bounded stop latency, fencing, storage sharding all pass before UI claims full support.

---

## PHASE 7 — Unified current React/Vite UI + backend contract

### CD-100 — Define backend Continuous Discovery API/service contract
**Goal:** Extend current DoubleTake backend, not a second daemon/application.

**Required service operations:**

```text
get_status()
start(enabled_miners=[balancer,gap_filler,frontier], auto_assimilation=bool)
pause()
resume()
stop(processing_policy=STOP_MINING_ONLY|STOP_MINING_AND_DRAIN_ASSIMILATION|STOP_ALL_PROCESSING)
set_enabled_miners(...)
set_auto_assimilation(bool)
list_knowledge(filters, cursor/page, limit)
get_knowledge(id, version?)
set_knowledge_disposition(id/version, disposition)
assimilate_selected(ids/versions)
get_metrics()
stream_or_poll_events(cursor)
```

Use the existing backend route/service conventions. If no current route namespace exists for this feature, use `/api/continuous-discovery` as the route prefix. Keep request/response schemas closed and validated.

**Verify:** every UI action maps to one backend operation; no backend operation lets a miner request direct mutation.

### CD-101 — Make API Start idempotent
**Goal:** The API must expose CD-080 semantics without relying on the browser to deduplicate requests.

**Required behavior:** accept/use the backend's normal request-id/idempotency mechanism if one exists; otherwise derive the active-session decision from the workspace CAS pointer. A timeout/retry of the same Start and two simultaneous browsers must return the same active session.

**Verify:** duplicate/reordered browser requests do not create duplicate session records, leases, supervisor processes, or generations.

### CD-102 — Make UI transport stateless with respect to liveness
**Goal:** UI observes/controls durable backend state; closing tab/socket never changes desired state.

### CD-103 — Add one Continuous Discovery surface to existing React/Vite app
**Goal:** No separate web app.

**Display at minimum:** durable status, runtime, epoch/checkpoint, sources processed, discovery/unique/ready/queued/assimilated counts, all three miner stats, backpressure/degraded reason, Auto Assimilation state.

### CD-104 — Implement Start/Pause/Resume/Stop controls
**Verify:** controls reflect backend durable state after refresh/reconnect/restart.

### CD-105 — Implement standard all-three-miner start
**Goal:** Default Continuous Discovery start enables Balancer, Gap Filler, Frontier together; per-miner disablement is explicit user policy, not scheduler starvation.

### CD-106 — Implement Auto Assimilation control
**Goal:** Toggle affects durable backend consumer state.

**Verify:** ON drains eligible backlog and future items; OFF stops future automatic handoffs without stopping mining.

### CD-107 — Implement Knowledge Store browser
**Goal:** Paged/filterable list with origin/state/priority/evidence/provenance/baseline/assimilation status.

### CD-108 — Implement knowledge detail view
**Goal:** Human can inspect summary plus underlying evidence, contradictions, limitations, provenance, raw refs, and DoubleTake observation binding.

### CD-109 — Implement manual disposition and manual Assimilation actions
**Goal:** defer/reject/reprioritize/obsolete/delete-retain policy/assimilate selected; bulk actions chunked.

### CD-110 — Prevent unsupported runtime claims in UI
**Goal:** Do not label a miner, Auto Assimilation, or capability “active/implemented/validated” unless backend/runtime evidence supports it.

### CD-111 — Add UI reconnect/browser-disconnect tests
**Verify:** close/reopen client reconnects same session; mining continues while UI absent.

### CD-112 — Add UI unit/e2e regression gate
**Verify:** current UI build/lint/tests remain green; Continuous Discovery controls/stats use real backend responses, not fake local timers.

---

## PHASE 8 — Hardening, security, migration closure, and final proof suite

### CD-120 — Enforce source-content isolation end-to-end
**Goal:** Prompt injection or code-looking material remains data through retrieval, normalization, rendering, queueing, and Assimilation source ingestion until governed strategies explicitly interpret it.

### CD-121 — Enforce stale DoubleTake baseline at implementation promotion
**Goal:** A plan created against revision A cannot blindly mutate revision B.

**Verify:** re-evaluate/rebase/reject path is explicit and evidenced.

### CD-122 — Enforce overlapping implementation conflict protection
**Goal:** Concurrent Assimilation/FIC units cannot blindly change overlapping authoritative files/state.

**Verify:** canonical lock/plan/baseline rules serialize or block conflicts.

### CD-123 — Enforce durable-lineage authorization at low-level mutation boundary
**Goal:** Mutation primitives resolve actual durable campaign/FIC/governance lineage rather than trusting caller strings.

### CD-124 — Verify capability publication ownership
**Goal:** Native/adopted/synthesized/new Continuous Discovery-derived capabilities still converge on one canonical `CapabilityAuthority` and routability rules.

### CD-125 — Verify semantic authority separation
**Goal:** Knowledge semantic retrieval can use current SemanticService without becoming a second capability-routing authority.

### CD-126 — Verify local-first/offline mode
**Goal:** With network/providers disabled, DoubleTake core boots/proofs run; local miners work where possible; Frontier truthfully reports remote freshness unavailable.

### CD-127 — Verify archive/retention/data-decision behavior
**Goal:** Stop never deletes knowledge; user can later inspect/reprioritize/re-assimilate; retention/compaction preserves lineage.

### CD-128 — Verify re-Assimilation semantics
**Goal:** Historical knowledge can be intentionally re-evaluated against a newer DoubleTake baseline without pretending its original observation was current.

### CD-129 — Verify feedback-loop anti-thrashing
**Goal:** Contradictory findings/failed changes/oscillating scores do not cause endless undo-redo implementation churn.

**Implement:** store prior Assimilation disposition and evidence/baseline digest. Do not automatically retry the same rejected/rolled-back implementation unless at least one material input changes (knowledge version/evidence digest, DoubleTake baseline, governing policy, or explicit user decision). Apply a bounded cooldown after transient failures. Scoring remains advisory and can never override this rule.

### CD-130 — Remove/disable dead parallel production mutation routes
**Goal:** After cutover, compatibility wrappers must route canonically or be removed safely; no hidden old authority remains.

### CD-131 — Add canonical Continuous Discovery proof runner(s)
**Goal:** Convert the 32 acceptance specifications in Appendix A into executable repository proofs/tests using current proof conventions.

### CD-132 — Run full current DoubleTake regression suite
**Goal:** New feature is additive and does not weaken L0/L1/core governance.

### CD-133 — Run final source scan for forbidden patterns
**Search for:** direct miner writes/adopt/promote, duplicate capability/governance authorities, production `max_epochs`, no-progress completion, fake remote evidence, miner-created code from embeddings, UI-only liveness, giant append-only session JSON, unbounded in-memory history.

### CD-134 — Update runtime documentation only from proven behavior
**Goal:** README/docs describe commands/UI/states that actually exist and have passing evidence. Remove stale descriptions of direct miner apply if superseded.

### CD-135 — Final clean-run acceptance
**Verify all of:** targeted suites; all new proofs; existing relevant product-readiness/prove-all commands; UI build/tests; `git diff --check`; no unexpected generated artifacts; authority-owner proof; lineage proof.

---

# 5. Miner-specific output contracts

## 5.1 Balancer finding

At minimum preserve a human-readable structure equivalent to:

```text
Area
Observation / imbalance
Supporting evidence
Potential balancing directions
Relevant DoubleTake components
Observed DoubleTake baseline
Confidence / reliability / relevance
Limitations / contradictions
Open questions
Provenance
```

Balancer ends at durable knowledge. It does not implement the balancing direction.

## 5.2 Gap finding

At minimum preserve:

```text
Observed capability/context
Expected supporting capability
Missing/incomplete component
Why this appears to be a gap
Evidence
Candidate approaches
Observed DoubleTake baseline
Confidence / limitations
Open questions
Provenance
```

Gap Filler ends at durable knowledge. It does not fill the gap directly.

## 5.3 Frontier finding

At minimum preserve:

```text
Capability / idea
Summary
Existing implementations/research
Why it may matter
Distance from current DoubleTake
Potential applicability
Evidence
Observed DoubleTake baseline if applicable
Limitations / risks / contradictions
Confidence / novelty / reliability
Provenance
```

Frontier Discovery ends at durable knowledge. It does not decide integration.

---

# 6. Queue, idempotency, and transaction rules

Use current DoubleTake conventions where possible.

## 6.1 Stable identities

Derive stable IDs/digests from material inputs. Do not use random IDs as the only idempotency authority for logical effects.

At minimum bind:

```text
knowledge_id + knowledge_version
canonical artifact digest
workspace identity
objective/reason digest
current/revalidated DoubleTake baseline
route kind
```

## 6.2 Queue semantics

At-least-once delivery is acceptable internally only when **logical effects are exactly-once/idempotent**.

A retry may re-run safe analysis. It must not duplicate:

- capability publication;
- repository mutation;
- queue handoff identity;
- accepted implementation effect.

## 6.3 Outbox/state atomicity

If store transaction A says “ready/queued” and queue record B is separate, implement a durable outbox/reconciliation mechanism so a crash cannot permanently split them.

## 6.4 Fencing

Before authoritative state commit/effect commit, verify current lease/generation. Stale workers may finish computation but may not commit state/effects.

---

# 7. Infinite mining contract — implement literally

Production supervisor pseudocode must be semantically equivalent to:

```text
while durable_desired_state == RUNNING:
    reconcile_if_needed()
    observe_backpressure_and_resources()

    for miner in fair_schedule(enabled_miners):
        if durable_desired_state != RUNNING:
            break
        run_one_bounded_miner_unit(miner)
        persist_unit_result_and_cursor()

    persist_epoch_checkpoint()

    if zero_yield_or_low_novelty:
        diversify_search_state()
        bounded_backoff_if_needed()

    if auto_assimilation_enabled:
        schedule_bounded_ready_queue_consumption()

# PAUSE / STOP are explicit durable user intent, not discovery conclusions.
```

Forbidden production patterns include semantic equivalents of:

```python
for epoch in range(MAX_EPOCHS): ...
if no_findings: return COMPLETE
if zero_yield_count >= N: stop()
if frontier_exhausted: complete_session()
if all_known_gaps_closed: complete_session()
if browser_disconnected: stop()
```

A **test-only** horizon may terminate a test runner, never production session semantics.

## 7.1 Concrete production supervisor algorithm

Implement semantics equivalent to this. Names may follow live repository conventions, but do not omit a step:

```text
acquire_or_renew_supervisor_lease()
load_session_manifest()

while manifest.desired_state == RUNNING:
    assert_current_generation_before_state_commit()
    refresh_manifest_and_control_intent()
    reconcile_interrupted_epoch_and_expired_queue_leases()
    refresh_backpressure_and_resource_state()

    epoch = open_new_bounded_epoch(next_epoch_number)

    for miner in round_robin_enabled_miners(fairness_cursor):
        refresh_control_intent()
        if desired_state != RUNNING:
            break
        if miner_is_temporarily_resource_blocked:
            record_skip_reason_and_keep_future_eligibility()
            continue
        result = run_bounded_miner_unit_with_timeout(miner)
        atomically_persist_result_cursor_and_epoch_event(result)

    seal_epoch_record_and_checkpoint()
    rotate_and_persist_fairness_cursor()

    if zero_yield_or_low_novelty:
        mutate_exploration_hypothesis_or_source_class()
        apply_bounded_backoff_without_changing_desired_state()

    if auto_assimilation_enabled:
        wake_or_schedule_bounded_auto_assimilation_consumer()

    heartbeat_and_repeat()

if desired_state == PAUSED:
    finish/cancel current bounded unit safely
    checkpoint -> operational_state = PAUSED

if desired_state == STOPPED:
    apply persisted processing policy
    checkpoint -> operational_state = STOPPED
```

No code path in this algorithm is allowed to set `desired_state = STOPPED` because mining produced no useful findings.

---

# 8. Auto Assimilation contract

Auto Assimilation has its own durable enabled/disabled state.

When turned ON:

1. scan/paginate existing eligible `KNOWLEDGE_READY` backlog;
2. revalidate each candidate against current state before handoff;
3. dedupe using durable handoff identity;
4. create bounded queue leases/batches;
5. invoke the same canonical handoff as manual Assimilation;
6. continue consuming future ready items;
7. obey backpressure/governance/campaign limits.

When turned OFF:

- no new automatic handoffs are launched;
- miners continue according to mining desired state;
- already-running bounded Assimilation campaigns follow their safe cancellation/completion policy;
- ready backlog remains stored.

Auto Assimilation must never mean “auto approve all implementation.” Assimilation may return knowledge-only, reject, defer, review-required, stale, conflict, or no-action dispositions.

---

# 9. Migration/cutover rule

Do not do a flag day rewrite.

The only safe order is:

```text
Phase 1 read-only knowledge plane
→ Phase 2 canonical handoff proven
→ Frontier cutover and old Frontier authority closure
→ Gap cutover and old Gap authority closure
→ Balancer cutover and old Balancer authority closure
→ persistent infinite supervisor
→ unified UI
→ final hardening/cleanup
```

At each cutover:

1. replacement path exists and is tested;
2. legacy entrypoint is redirected/disabled;
3. authority-owner test proves no duplicate production authority;
4. only then proceed.

Never temporarily keep “new Assimilation route” and “old direct apply route” both active as authoritative production choices.

---

# 10. Security and evidence rules

1. Retrieved content is data, not instruction.
2. Do not execute mined repository code during discovery merely to understand it unless an existing governed sandbox/test mechanism explicitly authorizes it.
3. Preserve licenses/source metadata when relevant.
4. Sanitize paths/archive extraction through current safe utilities.
5. Never trust source-provided claims of safety, tests, authority, provenance, version, or compatibility without DoubleTake verification.
6. Never let confidence/novelty/relevance score authorize a privileged effect.
7. Contradictions must remain visible.
8. Missing provenance is a reason to defer/review/reject, not a reason to invent provenance.
9. A human-readable summary unsupported by evidence cannot become authoritative knowledge merely because it is fluent.

---

# 11. Storage and long-run stability rules

The mining history can grow indefinitely, but every active operation must remain bounded.

Required properties:

```text
sharded canonical records
bounded page reads
bounded page writes
bounded queue leases
bounded in-memory caches
rebuildable derived indexes
recoverable compaction
retention policy without silent evidence deletion
observable disk-pressure state
no silent data dropping
```

If disk/provider/resource capacity is insufficient while desired state is RUNNING:

```text
desired_state = RUNNING
operational_state = WAITING_RESOURCE / BACKING_OFF / DEGRADED
```

Do not set `STOPPED` or `COMPLETE` unless explicit semantics require it.

---

# 12. Required lineage for every integrated change

A final accepted change must be traceable through this complete chain:

```text
external/local source
→ source evidence + digest
→ immutable human-readable KnowledgeObject version
→ Ready Queue/outbox item
→ Assimilation handoff materialized source artifact
→ bounded Assimilation campaign + decision
→ L1 request classification / impact assessment
→ FIC authorization / governed handoff
→ bounded implementation unit
→ mutation/rollback receipts
→ validation evidence
→ review/acceptance
→ accepted repository revision and/or canonical capability publication
```

If any required link is missing, authoritative promotion fails closed.

---

# 13. Tests must prove negative paths, not only happy paths

For every authority/safety feature, include at least one negative test:

- missing governance;
- stale baseline;
- stale lease/generation;
- duplicate enqueue;
- crash between state and queue persistence;
- corrupted knowledge record;
- corrupted raw evidence;
- forged lineage ID;
- poisoned/prompt-injection source;
- vector similar but payload contradictory;
- no registered Assimilation strategy;
- offline remote source unavailable;
- unsupported process-lock platform/mode;
- disk/backpressure threshold;
- duplicate Start;
- browser disconnect;
- Stop during slow bounded work;
- compaction crash;
- self-modification/runtime version mismatch.

A failure must leave state truthful and recoverable.

---

# 14. Documentation discipline

Do not update top-level documentation to say “Continuous Discovery is complete” until executable evidence passes.

Before that, documentation may describe work as planned/experimental only if true.

When complete, document:

- how to start/pause/resume/stop;
- that all three miners are part of one Continuous Discovery service;
- difference between mining and Auto Assimilation;
- durable restart semantics;
- local/offline limitations;
- knowledge inspection/re-assimilation;
- no algorithmic mining completion;
- canonical implementation/authority path.

---

# 15. HARD stopping condition for this coding task

Do **not** stop because:

- one phase is done;
- most tests pass;
- the UI appears correct;
- mining runs for a few epochs;
- you reached a context limit;
- an old direct path seems unused;
- code “looks architecturally right.”

Persist progress and continue.

You may declare the implementation task complete only when all are true:

```text
[ ] all 112 atomic `CD-*` tasks explicitly listed in Section 4 are VERIFIED (an already-implemented task still needs current evidence)
[ ] any task judged already-implemented has current evidence and tests, not assumption
[ ] all 32 repository-level acceptance proofs in Appendix A pass
[ ] all 94 final design invariants in Appendix B are individually checked PASS
[ ] current relevant DoubleTake regression/proof suites pass with no unexplained regressions
[ ] no production miner entrypoint can authoritatively mutate/adopt/promote independently
[ ] exactly one canonical Assimilation implementation gateway exists
[ ] exactly one canonical capability authority exists
[ ] exactly one canonical repository mutation authority exists
[ ] production session has no hidden algorithmic completion predicate
[ ] duplicate Start cannot create duplicate supervisors
[ ] RUNNING resumes after restart; user STOP remains stopped after restart
[ ] browser disconnect does not stop mining
[ ] all enabled miners satisfy fairness horizon
[ ] zero-yield epochs do not stop mining
[ ] storage/history is sharded and active memory remains bounded
[ ] Auto Assimilation drains existing eligible backlog and future knowledge in bounded units
[ ] knowledge remains human-readable/evidence-backed and vectors remain auxiliary
[ ] stale baselines and forged lineage fail closed
[ ] offline DoubleTake still works without fake remote evidence
[ ] UI is the existing React/Vite application and reflects real backend state
[ ] documentation contains no unsupported runtime claim
[ ] git diff --check passes
[ ] final clean-run evidence is recorded in the implementation ledger
```

If a truly external dependency prevents one item from running, leave that item `BLOCKED` with exact evidence and continue every independent task. Do not convert blocked work to DONE.

---

# APPENDIX A — AUTHORITATIVE REPOSITORY-LEVEL ACCEPTANCE MATRIX

**Lower-LLM context rule:** do not try to hold this entire appendix in working memory during Phases 0–7. Use the current phase tasks and ledger. During Phase 8 / CD-131, process these proofs one at a time in numeric order and record each result.

The following acceptance specifications are part of the implementation task. Implement executable tests/proofs for all of them; do not merely copy the prose into docs.

# 72. Expanded Definition of Done and Repository-Level Acceptance Matrix

This architecture is only "10/10" when the implementation passes the existing DoubleTake proof philosophy and the following new proofs without weakening current proofs.

## 72.1 Current-regression gate

Before accepting this refactor:

```text
make prove-l1
make prove-all
```

and the relevant current product-readiness/final-acceptance suites must still pass.

The implementation may add a dedicated Continuous Discovery proof target, but it must not replace existing proof targets.

## 72.2 No-miner-write-authority proof

For each:

```text
Balancer
Gap Filler
Frontier Discovery
```

construct the strongest possible implementation-relevant finding.

Pass condition:

```text
authoritative repository bytes remain unchanged
until an Assimilation-generated governed implementation unit is accepted.
```

Static/source inspection should also prove the Continuous Discovery miner paths do not call direct adopt/apply/execute mutation primitives.

## 72.3 Balancer migration proof

Exercise the current Balancer discovery against a transformable target.

Pass condition:

- a `BALANCE_FINDING` is stored;
- evidence/qualification information remains usable;
- no direct Balancer apply occurs;
- any later implementation is traceable to Assimilation/L1 authorization;
- existing rollback/locking safety is still used on the eventual implementation path.

## 72.4 Gap migration proof

Exercise gap discovery for:

- internal-known candidate;
- external-known candidate;
- ambiguous candidate.

Pass condition:

- all implementation-relevant routes terminate at human-readable knowledge + Assimilation;
- no gap path directly adopts/applies code;
- retries/restarts create one logical handoff per material finding version;
- `adopt=false` at the miner boundary.

## 72.5 Frontier migration proof

Exercise embedding/relation/frontier discovery.

Pass condition:

- vector result resolves to associated evidence;
- human-readable artifact is required;
- no vector reconstruction becomes authoritative code;
- implementation-relevant finding enters Assimilation;
- low-evidence novel result remains research-only rather than being guessed into code.

## 72.6 Infinite liveness soak proof

Run a deterministic test supervisor for at least a large configurable number of epochs, including long runs of zero novelty.

Pass condition:

- no global `COMPLETE` is emitted;
- all epochs terminate;
- every enabled miner keeps receiving service;
- checkpoints advance;
- memory per active bounded unit remains bounded;
- historical state is paged/sharded rather than loaded monolithically.

A test may stop the run after its test horizon.

That artificial test stop is not production completion logic.

## 72.7 Zero-yield recovery proof

Simulate:

```text
100 consecutive zero-yield epochs
then introduce a new source/repository revision
```

Pass condition:

- session remains RUNNING through all zero-yield epochs;
- backoff/diversification occurs;
- new material is discovered after it appears.

## 72.8 Restart-without-user-stop proof

Kill the backend while desired state is RUNNING.

Restart it.

Pass condition:

- durable desired state remains RUNNING;
- stale supervisor/worker generation is fenced;
- interrupted work is reconciled;
- mining resumes without the user clicking Start again;
- duplicate logical effects do not occur.

## 72.9 Persistent-user-stop proof

Click Stop and persist it.

Restart the backend.

Pass condition:

- session remains STOPPED;
- no miner resumes;
- all previous knowledge remains accessible.

## 72.10 UI disconnect proof

Start mining, then close the browser/disconnect UI transport.

Pass condition:

- backend mining continues;
- heartbeat/checkpoints continue;
- reopening UI reconnects to the same session.

## 72.11 Fairness proof

With all three enabled and one miner producing much higher yield:

Pass condition:

- every miner receives work within the configured fairness horizon.

## 72.12 Backpressure/capacity proof

Slow Assimilation and fill queues/storage toward thresholds.

Pass condition:

- memory remains bounded;
- data is not silently dropped;
- if provider/rate pressure is the cause, state becomes `BACKING_OFF`; if disk/memory/queue capacity is the cause, state becomes `WAITING_RESOURCE`; if a non-terminal subsystem fault reduces functionality, state becomes `DEGRADED`;
- desired state remains RUNNING;
- recovery resumes when pressure clears.

## 72.13 Campaign-boundary proof

Process thousands of Assimilation batches.

Pass condition:

- each campaign remains bounded;
- the infinite mining supervisor does not accumulate all campaign tasks/receipts inside one campaign record.

## 72.14 Lock/fencing proof

Run competing supervisors/workers.

Pass condition:

- stale generation cannot mutate;
- only current lease owner commits;
- unsupported lock platform fails safely or enforces single-process mode.

## 72.15 Knowledge/capability separation proof

Create a high-confidence KnowledgeObject.

Pass condition:

- it is non-routable;
- it does not appear as an executable capability;
- only governed Assimilation/promotion can publish a capability contract.

## 72.16 Semantic rebuild proof

Destroy the derived knowledge vector index.

Pass condition:

- it rebuilds from canonical human-readable knowledge;
- provenance and decisions are unchanged.

## 72.17 Poisoned-source proof

Inject source instructions attempting to:

- bypass Assimilation;
- alter governance;
- call tools;
- request code execution.

Pass condition:

- source remains inert data;
- no privileged effect occurs.

## 72.18 Stale DoubleTake baseline proof

Generate an Assimilation plan, mutate relevant DoubleTake state, then attempt promotion.

Pass condition:

- stale baseline is detected;
- plan is re-evaluated/rebased/rejected;
- blind promotion cannot occur.

## 72.19 Self-modification proof

Assimilate a change to the mining/Assimilation machinery itself.

Pass condition:

- affected workers drain/checkpoint;
- runtime version is pinned;
- migration is validated;
- switch is atomic;
- old version can recover/rollback if new version fails.

## 72.20 Existing authority proof

Static and dynamic inspection must prove there is still only one canonical owner for each of:

```text
governance authority
capability authority
repository mutation authority
Assimilation implementation gateway
semantic capability routing authority
```

## 72.21 Offline compatibility proof

With all remote providers/network disabled:

Pass condition:

- DoubleTake core still boots and existing offline proofs run;
- local Balancer/Gap discovery can operate where possible;
- Frontier reports unavailable remote freshness truthfully;
- no fake remote evidence is synthesized.

## 72.22 Data-lineage proof

For any integrated change, traverse:

```text
source
→ evidence
→ human-readable knowledge version
→ ready-queue item
→ Assimilation campaign/decision
→ L1/FIC authorization
→ implementation unit
→ validation evidence
→ accepted revision/capability publication
```

Every link must be recoverable.

## 72.23 Legacy-entrypoint closure proof

Inventory all production entrypoints for Balancer, Gap Filler, and Frontier Discovery:

- UI;
- API;
- CLI;
- background workers;
- scheduled loops;
- service methods;
- compatibility wrappers.

Pass condition:

- none can independently mutate/adopt/promote code or capabilities;
- any implementation-intent compatibility path routes through human-readable KnowledgeObject → canonical Assimilation → L1/FIC;
- low-level mutation helpers are callable authoritatively only from the canonical governed implementation lane.

## 72.24 Auto-Assimilation backlog proof

Mine with Auto Assimilation OFF until a significant ready backlog exists.

Then turn it ON.

Pass condition:

- existing eligible backlog is processed;
- processing is bounded/paged;
- no giant campaign is created;
- duplicates are not re-enqueued;
- newly ready items continue after the backlog;
- mining remains RUNNING throughout.

## 72.25 Human-readable evidence fidelity proof

Provide a source whose embedding is highly similar but whose actual payload contradicts the inferred concept.

Pass condition:

- associated payload is retrieved;
- contradiction is visible in the human-readable artifact;
- unsupported generated claims are not silently promoted to `KNOWLEDGE_READY`;
- embedding similarity cannot override source evidence.

## 72.26 Phased implementation order

Implement this redesign incrementally so current DoubleTake remains functional throughout.

### Phase 1 — contracts and read-only data plane

- add/extend FICs and shared contracts;
- define namespaced mining/knowledge states;
- define `KnowledgeObject`;
- define durable small `MiningSessionRecord`;
- add sharded Knowledge Store;
- add read-only miner adapters;
- no existing mutation path is changed yet.

### Phase 2 — canonical Assimilation handoff

- generalize current Gap Filling exactly-once handoff shape;
- create stable typed `AssimilationHandoffAdapter`;
- bind to current canonical Assimilation front door;
- prove `adopt=false` at miner boundary;
- implement manual Assimilation from stored knowledge.

### Phase 3 — Frontier cutover

- convert all implementation-relevant Frontier outputs to human-readable knowledge;
- redirect legacy Frontier promotion paths to Assimilation;
- preserve research/semantic tests.

### Phase 4 — Gap Filling cutover

- route all implementation-relevant gap decisions to Assimilation;
- retire direct miner-owned apply authority;
- preserve its detection/specification intelligence and useful transaction safety behind the governed implementation lane.

### Phase 5 — Balancer cutover

- preserve analysis/qualification/sealed evidence;
- rehome write-side promotion/rollback/lock primitives behind Assimilation;
- redirect every public/direct Balancer apply entrypoint to Assimilation;
- prove Balancer cannot authoritatively mutate alone.

### Phase 6 — persistent infinite supervisor

- add backend-owned durable supervisor;
- implement all-three fairness;
- restart recovery;
- heartbeat;
- zero-yield diversification/backoff;
- no production completion predicate.

### Phase 7 — unified UI

- integrate into current React/Vite application;
- expose durable session state;
- Start/Pause/Resume/Stop;
- knowledge inspection/disposition;
- Auto Assimilation backlog + future behavior.

### Phase 8 — hardening and cutover

- disable/remove legacy parallel mutation routes;
- run soak/crash/fencing/backpressure tests;
- run existing DoubleTake proofs;
- run new Continuous Discovery proof suite;
- update documentation only after runtime evidence exists.

No phase may temporarily create two active production mutation authorities.

## 72.27 Duplicate-Start/supervisor proof

Issue concurrent/retried Start requests from multiple clients.

Pass condition:

- one intended active session is returned;
- one current supervisor generation owns scheduling;
- duplicate Starts do not multiply mining work.

## 72.28 Forged-lineage mutation proof

Attempt to call a low-level governed mutation primitive from a miner with fabricated Assimilation/FIC identifiers.

Pass condition:

- canonical authority resolves durable lineage;
- fabricated references fail closed;
- no repository/capability mutation occurs.

## 72.29 Bounded-stop-latency proof

Request Stop while workers are in their slowest supported bounded operations.

Pass condition:

- no new work launches after Stop observation;
- each operation obeys its cancellation/safe-checkpoint contract;
- session reaches STOPPED within the documented maximum safe bound;
- no half-applied authoritative mutation remains.

## 72.30 Compaction/archive integrity proof

Compact/archive old raw and epoch data during continued mining.

Pass condition:

- active mining continues safely;
- canonical evidence references still resolve;
- digests match;
- derived indexes remain rebuildable;
- crash during compaction recovers without orphaning evidence.

## 72.31 No unsupported runtime claim

Documentation and UI may display a capability as active only after implementation evidence and the required proof passes.

A specification entry is not runtime evidence.

---


## 72.32 Current-front-door knowledge-artifact compatibility proof

Materialize a canonical human-readable knowledge artifact as a local `.md` or structured text file and pass it through the current canonical Assimilation front door.

Pass condition:

- `parse_assimilation_command` accepts the generated source locator;
- `resolve_source` resolves the local artifact without a code-extension requirement;
- the artifact is snapshot-bound before campaign execution;
- the current material-agnostic `CampaignKernel` receives the resolved source;
- execution remains bounded by campaign budgets;
- source drift fails closed;
- a missing suitable Assimilation strategy yields a blocked/no-strategy outcome;
- **no fallback path asks the miner to generate or apply code directly**;
- the handoff retains the KnowledgeObject/provenance binding.

---

---

# APPENDIX B — 94 FINAL DESIGN INVARIANTS

Every invariant below is mandatory. Before final completion, produce evidence for each invariant in the implementation ledger/proof outputs.

# 73. Design Rule Summary

The redesign is complete only if all of the following are true:

1. **Balancer is a miner, not an implementer.**
2. **Gap Filler is a miner, not an implementer.**
3. **Frontier Discovery is a miner, not an implementer.**
4. **All three route discoveries through the same Knowledge Layer.**
5. **All three ultimately route implementation decisions through Assimilation.**
6. **There is no alternative implementation path around Assimilation.**
7. **Embeddings are used for retrieval, similarity, clustering, indexing, and prioritization—not as executable or reversible code truth.**
8. **Underlying evidence and provenance are preserved.**
9. **All knowledge is converted into human-readable form before Assimilation.**
10. **Mining and Assimilation are independently controllable.**
11. **The user may mine without assimilating.**
12. **The user may manually trigger Assimilation later.**
13. **The user may enable automatic end-to-end Assimilation through an explicit UI control.**
14. **Automatic mode still routes every finding through Assimilation.**
15. **Mining continues indefinitely until the user stops or pauses it.**
16. **Indefinite mining is implemented as bounded epochs, never one giant unbounded operation.**
17. **All work is incremental and chunked.**
18. **All significant state is checkpointed and resumable.**
19. **The three miners share infrastructure but retain distinct reasoning objectives.**
20. **Scheduling prevents permanent starvation of any enabled miner.**
21. **Cross-miner findings are correlated and clustered.**
22. **The Knowledge Store is durable research memory, not a temporary buffer.**
23. **The Ready Queue separates mining from Assimilation.**
24. **Assimilation operates on bounded coherent batches.**
25. **Implementation occurs in bounded independently validated units.**
26. **Current DoubleTake state is checked before any implementation decision.**
27. **Duplicate and already-implemented discoveries are not repeatedly implemented.**
28. **Failures are isolated and do not terminate unrelated mining work.**
29. **Backpressure prevents unbounded Assimilation backlog.**
30. **Stopping mining does not delete stored knowledge.**
31. **Stored knowledge can be inspected, filtered, reprioritized, deferred, rejected, or re-assimilated later.**
32. **The system exposes sufficient observability for long-running operation.**

33. **Mining and Assimilation are decoupled producer/consumer pipelines and may run concurrently.**
34. **All state-changing bounded work is idempotent and crash-recoverable.**
35. **Persistent state transitions and follow-on queue events cannot diverge silently.**
36. **The canonical knowledge artifact, not the vector index, is the durable semantic source.**
37. **Derived indexes must be rebuildable from canonical artifacts.**
38. **Embedding-only legacy records without recoverable evidence are never decoded into guessed code.**
39. **Every Assimilation decision is tied to an explicit DoubleTake code snapshot.**
40. **Stale Assimilation plans are re-evaluated before integration.**
41. **Concurrent implementation units cannot blindly mutate overlapping code.**
42. **Auto Assimilation never bypasses existing DoubleTake governance.**
43. **Pause, resume, stop, drain, and force-abort semantics are explicit and distinct.**
44. **Infinite discovery includes anti-loop exploration memory so endless operation does not become endless repetition.**
45. **External mined content is untrusted data and cannot issue control instructions to DoubleTake.**
46. **Legacy data is migrated without fabricating missing provenance.**
47. **User decisions about stored data are first-class and bulk operations remain chunked.**
48. **Architecture acceptance tests verify routing, recovery, boundedness, fairness, stale-state protection, governance, and index rebuildability.**

49. **Implementation occurs in isolated change contexts and authoritative promotion is discrete and recoverable.**
50. **Running bounded work is version-pinned so self-modification cannot mutate execution underneath itself.**
51. **Scores and rankings prioritize investigation but never become hidden implementation authority.**
52. **Continuous self-improvement preserves history and includes anti-thrashing controls for contradictory feedback loops.**




53. **The design reuses the current DoubleTake Assimilation campaign engine rather than creating a second Assimilation controller.**
54. **The infinite mining supervisor is a separate small durable lifecycle from bounded Assimilation campaigns.**
55. **A bounded Assimilation campaign may complete without terminating Continuous Discovery.**
56. **Production Continuous Discovery has no hidden `max_epochs`, no-progress stop, or exhaustion-based completion predicate.**
57. **Zero-yield epochs cause diversification/backoff and another epoch, never global completion.**
58. **A RUNNING desired state survives backend restart and automatically resumes after reconciliation.**
59. **A user STOP persists across restart and is the only normal terminal mining intent.**
60. **Closing the browser or losing UI transport never changes mining desired state.**
61. **The standard Continuous Discovery start enables Balancer, Gap Filler, and Frontier Discovery together.**
62. **Fair scheduling guarantees every enabled miner recurring bounded service.**
63. **The infinite history is sharded; no single campaign/session record or in-memory list grows forever.**
64. **Storage exhaustion produces an observable waiting/degraded state, never silent loss or false completion.**
65. **Balancer's current mutation safeguards are preserved behind Assimilation, while Balancer miner write authority is removed.**
66. **Gap Filling's current exactly-once `adopt=false` handoff is generalized to every implementation-relevant gap.**
67. **Frontier's current Assimilation route is generalized to every implementation-relevant frontier finding.**
68. **Mined artifacts remain non-routable KNOWLEDGE until Assimilation/governance publishes a validated capability through the canonical CapabilityAuthority.**
69. **The existing SemanticService is reused/extended for knowledge indexing unless a governed FIC proves it insufficient.**
70. **Capability-routing semantics and mining-retrieval semantics remain distinct.**
71. **The current L0 independence and L0/L1/L2 authority boundaries remain intact.**
72. **Continuous Discovery is an L1-governed evolution/control-plane capability and does not itself justify creating L3/L4/L5.**
73. **Current local-first/offline DoubleTake behavior is preserved; remote mining adapters are optional and truthfully unavailable when not configured.**
74. **Unsupported process-lock platforms fail closed or enforce a safe single-process mode; they never silently lose concurrency safety.**
75. **The existing React/Vite UI is extended with one persistent Continuous Discovery surface rather than creating a second UI.**
76. **The backend, not the browser, owns the infinite loop and its durable state.**
77. **Every integrated change remains traceable source → knowledge → Assimilation → L1/FIC → implementation → validation.**
78. **Existing DoubleTake proofs remain regression gates; new Continuous Discovery proofs are additive.**
79. **No miner-generated confidence, semantic score, reconstruction, or candidate code is implementation authority.**
80. **The implementation is not considered complete until repository-level tests prove the infinite liveness, no-direct-write, restart, fairness, storage, and authority invariants.**


81. **Every production Balancer/Gap/Frontier entrypoint—not only the new UI—must lose independent implementation authority.**
82. **Turning Auto Assimilation ON drains eligible existing ready backlog and future knowledge in bounded batches.**
83. **MiningSessionState, KnowledgeState, queue/campaign states, and L1 LifecycleStatus are distinct typed namespaces.**
84. **Human-readable summaries are evidence-preserving interpretations; unsupported fluent prose cannot substitute for source evidence.**
85. **Migration is phased so there is never a period with two active authoritative mutation paths.**

86. **Repeated Start requests are idempotent and cannot accidentally create duplicate supervisors for the same intended session.**
87. **Every finding about DoubleTake is bound to the exact repository/configuration snapshot it observed.**
88. **Auto-Assimilation backlog eligibility is revalidated against current state before handoff.**
89. **Canonical mutation authority verifies durable Assimilation/FIC lineage; miner-supplied identifiers cannot be forged into authority.**
90. **Pause/Stop latency is bounded by bounded-unit cancellation/checkpoint contracts.**
91. **Archival/compaction cannot break evidence lineage and is itself recoverable.**
92. **Every implementation phase performs a live-HEAD compatibility preflight and revalidates if the repository baseline changes.**
93. **The first KnowledgeObject handoff uses a durable human-readable source artifact through the current canonical source-oriented Assimilation front door; it does not invent a parallel ingestion API.**
94. **Logical infinite mining preserves RUNNING intent across host/backend downtime and resumes when an executor returns; it does not falsely claim computation occurs while the host is unavailable.**

---

---

# APPENDIX C — ARCHITECTURE SECTION COVERAGE CHECK

Use this as a final omission check. The task pack above must collectively implement the requirements from all original architecture sections:

```text
1–8    core epistemic boundary, three miner purposes, shared discovery, human-readable artifacts
9–12   KnowledgeObject, lifecycle, durable research memory, cross-miner correlation
13–15  mining pipeline, Assimilation pipeline, queue boundary
16–18  unified UI, mining-only/end-to-end modes, user data/control
19–34  bounded epochs, fairness, incremental Assimilation, chunking, dedup, provenance,
       source-vs-interpretation, current-state awareness, re-Assimilation, backpressure,
       failure isolation, checkpointing, observability, retention, no continuous mutation,
       bounded-unit completion vs infinite-session semantics
35–38  top-level runtime architecture, producer/consumer decoupling, idempotency, transaction/outbox correctness
39–44  canonical-vs-derived data, legacy embeddings, knowledge immutability, stale snapshots,
       controlled integration lane, governance under Auto Assimilation
45–52  pause/resume/stop/drain, starvation-safe backpressure, anti-loop exploration,
       resource budgets, untrusted content, schema migration, end-to-end state machine, UI data decisions
53–57  architecture tests, isolated promotion/rollback, runtime version pinning,
       scores-not-authority, feedback-loop stability
58–63  current DoubleTake compatibility, L0/L1/L2 placement, reuse campaign engine,
       Balancer/Gap/Frontier migration
64–71  formal infinity, supervisor/watchdog, sharded infinite storage, SemanticService policy,
       CapabilityAuthority, local-first behavior, platform locking, existing React/Vite UI/backend contract
72      executable Definition of Done / proof matrix
73      final invariants
74      final repository-specific architecture closure
```

If any original section cannot be mapped to implemented code/tests/evidence, the work is not complete.

---

# FINAL EXECUTION DIRECTIVE

Start with `CD-000` against the **live repository**, not against assumptions in this prompt.

Use this execution loop until the hard stopping condition is satisfied:

```text
load ledger
find first CD task not VERIFIED
inspect live canonical owner
implement smallest complete change
run targeted positive + negative tests
fix failures caused by this work
record evidence
mark VERIFIED only when true
if phase ended: run phase gate and authority scan
checkpoint ledger
continue to next task

after CD-135:
    execute Appendix A proofs 72.1 -> 72.32 one by one
    audit Appendix B invariants 1 -> 94 one by one
    run final regression/clean-run gates
    if any check fails: reopen the responsible CD task and continue the loop
    only stop when every required check is PASS/VERIFIED
```

Do not ask the user to manually translate architecture into tasks: that translation is already contained here.
Do not create a new parallel architecture to avoid difficult migrations.
Do not stop at a partial implementation.
Do not claim completion without executable evidence.
