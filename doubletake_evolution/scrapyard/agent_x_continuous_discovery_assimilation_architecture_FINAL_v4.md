# Agent_X Continuous Discovery and Assimilation Architecture

## Purpose

This document defines the redesign of **Balancer**, **Gap Filler**, and **Frontier Discovery** in Agent_X.

The central architectural change is:

> **Balancer, Gap Filler, and Frontier Discovery are knowledge-mining systems, not code-generation or direct-implementation systems. Assimilation is the single controlled path from discovered information to understanding, planning, implementation, validation, and integration into Agent_X.**

The three discovery systems may continuously search, retrieve, analyze, compare, cluster, score, and store information. They must not directly modify Agent_X production code.

All discovered information must first be converted into a **human-readable, evidence-backed knowledge representation**. That representation is then processed by the existing Assimilation process exactly as any other external information source would be.

The system must support continuous, effectively unbounded mining until explicitly stopped by the user. Internally, however, all work must remain bounded, incremental, resumable, auditable, and chunked.


---

## Repository-Validated Baseline for This Revision

This revision is not an abstract greenfield design. It is constrained by the current `Astrocytech/Agent_X` repository and must extend the capabilities that already exist instead of creating parallel replacements.

The repository was inspected on **2026-08-31** against the current `main` line visible during this review. The relevant current implementation evidence includes:

```text
Repository:
  Astrocytech/Agent_X
Default branch:
  main
Core package:
  agentx 1.2.0
Python:
  >= 3.11
Core dependencies:
  PyYAML + jsonschema
Optional API:
  FastAPI + Uvicorn
UI:
  React 19 + Vite 8
Current architectural layers:
  L0 + L1 + L2
```

Current capabilities that this redesign MUST reuse or preserve include:

```text
L0
  governed seed kernel
  independent from L1/L2

L1
  external evolution/controller control plane
  FIC-governed bounded implementation
  impact assessment
  validation
  evidence
  rollback/review requirements
  traceability
  implementation handoff packets

Current CLI/runtime
  goal lifecycle
  action simulate/execute/rollback
  queue autonomy
  replay
  self-upgrade plan/apply
  review/approve/reject
  migration
  diagnostics
  transformation validation
  rollback proofs
  security/governance proofs
  final acceptance

Current Assimilator
  universal/canonical assimilation front door
  CampaignKernel/campaign execution
  durable campaign state outside LLM/session context
  digest/integrity checking
  CAS revisions
  process locking
  lease/generation fencing
  governed effect registry
  durable intent/effect recovery
  canonical governance routing
  capability publication through one authority
  semantic capability retrieval

Current semantic infrastructure
  SemanticService as the primary semantic indexing/retrieval path
  CapabilitySemanticIndex
  canonical CapabilityAuthority
  fail-closed semantic routing where authority requires it

Current Gap Filling
  durable exactly-once Assimilation handoff exists
  handoff is explicitly adopt=False
  restart/retry does not duplicate the same Assimilation item

Current Frontier Discovery
  external-known findings already have an ASSIMILATION route
  frontier/semantic evidence is advisory and does not authorize effects

Current Balancer
  sealed plans
  isolated qualification against sealed repository revisions
  typed artifact states
  accepted-governance requirements
  repository mutation locking
  exact rollback/recovery evidence
  guarded production apply
```

Repository evidence observed during this review includes the following recent mainline work:

```text
9a4143a7  latest observed CampaignRecord legacy/new compatibility + completion-gate hardening
bde68a9c  recent mainline merge observed during review
841ef9ee  campaign store CAS/atomic persistence/locking hardening
5627d2ec  lease generation fencing at campaign commit boundaries
17d8db7b  durable intent/effect recovery reconciliation
4bf2df67  SemanticService-primary capability semantic indexing
cae244da  canonical governance for effects
1b249ec7  universal Assimilation front door wired into MCP surfaces
712d5549  bounded Assimilation hygiene wiring
c6703f73  Gap Filling durable exactly-once adopt=false Assimilation handoff
57581b26  Frontier external-known → ASSIMILATION route and advisory-authority proof
ca65aebf  Balancer governed apply/typed-state/locking proof completion
6509bfd9  previous Continuous Discovery architecture specification added to repository
```

These commit identities are evidence anchors for compatibility, not permanent API names. The implementation must still inspect the current canonical owner before modifying code.

### Live-HEAD compatibility preflight

Agent_X is actively evolving. The implementation of this specification must therefore begin with a live repository preflight rather than blindly assuming that the file paths, symbols, or exact data structures named in this document are still canonical.

Before the first implementation unit, and again whenever repository `HEAD` changes during the refactor:

```text
1. capture current full commit SHA;
2. inspect the current L0/L1/L2 authority boundaries;
3. locate the current canonical Assimilation front door and campaign runtime;
4. locate the current semantic indexing authority;
5. locate the current capability authority;
6. locate current Balancer, Gap Filling, and Frontier public entrypoints;
7. locate the current repository mutation lock/rollback/governance owners;
8. map this specification onto those current owners;
9. block on conflicting or duplicated authority instead of creating a parallel replacement.
```

Each implementation FIC/handoff must bind itself to the inspected repository baseline. If `HEAD` or a relevant governing artifact changes before mutation, the unit must re-inspect/reconcile or return a stale-baseline/block result according to current Agent_X governance.

This keeps the architecture compatible with **current Agent_X abilities at execution time**, not merely with the snapshot observed while this document was written.

Therefore, this redesign MUST NOT create:

```text
a second governance authority
a second capability authority
a second implementation gateway
a second Assimilation engine
a second semantic authority
a second repository-mutation authority
a second competing queue/recovery protocol where the existing campaign engine
can provide the required semantics
```

The intended refactor is to **reuse and relocate authority**, not throw away mature Agent_X safeguards.

### Current-state delta that this specification must close

The current repository has not already completed this redesign. In particular:

- the current `GapFillingService` still owns a lifecycle that includes generation, staging, validation, **apply**, and observation;
- the current deterministic Balancer still describes and implements guarded replacement of authoritative code after validation;
- the canonical Assimilation front door currently accepts an Assimilation command/source, resolves it to a file, snapshots that file, and runs a `CampaignKernel` pipeline;
- therefore the target architecture must migrate existing write-capable Gap/Balancer paths behind Assimilation while adapting knowledge artifacts to the **current source-oriented Assimilation interface** instead of pretending that a generic structured KnowledgeObject ingestion API already exists.

This document is therefore a **migration architecture grounded in current capabilities**, not a claim that the repository already satisfies the final authority topology.

In particular:

> Existing Balancer and Gap Filling mutation-safety mechanisms that remain useful must be reused behind the Assimilation-owned implementation boundary. Their discovery/mining surfaces must no longer own direct code mutation.

A repository capability mentioned in this section is an existing integration point, not permission to bypass the architecture defined below.


# 1. Core Architectural Principle

The forbidden conceptual model is:

```text
Embedding
   ↓
Infer implementation
   ↓
Modify Agent_X
```

The required model is:

```text
External information
   ↓
Discovery / retrieval
   ↓
Embedding-assisted indexing, similarity, clustering, and prioritization
   ↓
Human-readable knowledge artifact
   ↓
Knowledge Store
   ↓
Assimilation
   ↓
Understanding / reconciliation
   ↓
Implementation plan
   ↓
Incremental implementation
   ↓
Validation / governance
   ↓
Agent_X
```

Embeddings are **navigation and retrieval representations**. They are not executable truth, source code, specifications, or a lossless representation of implementation intent.

Agent_X must never treat an embedding as though it can be reliably inverted into the code that should be implemented.

---

# 2. Hard Architectural Invariants

The redesign must enforce the following invariants.

## 2.1 Assimilation is the only implementation gateway

Balancer, Gap Filler, and Frontier Discovery:

- may discover information;
- may retrieve information;
- may inspect source code and documentation;
- may compare systems;
- may identify patterns;
- may identify weaknesses;
- may identify missing capabilities;
- may identify frontier capabilities;
- may score, cluster, rank, and deduplicate findings;
- may create human-readable knowledge artifacts;
- may populate the Knowledge Store;
- may queue knowledge for Assimilation.

They must **not**:

- directly modify Agent_X production code;
- bypass Assimilation;
- directly translate embeddings into code;
- directly merge external implementations;
- directly execute architectural changes;
- create an alternate implementation pipeline beside Assimilation.

The invariant is:

```text
ALL DISCOVERY → KNOWLEDGE → ASSIMILATION → IMPLEMENTATION
```

There must be no hidden or secondary path around this boundary.

This is an **all-production-entrypoints** rule, not merely a rule for the new Continuous Discovery UI.

After migration, any existing public/CLI/API/worker path associated with Balancer, Gap Filler, or Frontier Discovery that can currently cause authoritative implementation must either:

1. be removed as a direct mutation path; or
2. become a compatibility entrypoint that creates a human-readable knowledge artifact and routes it through canonical Assimilation.

No legacy `apply`, `promote`, `adopt`, or equivalent miner-owned endpoint may remain as an independent production implementation authority.

Existing low-level safety primitives may be retained and reused **behind** Assimilation, but they cease to be miner authority.

## 2.2 Embeddings are not the source of truth

The embedding may help answer:

- what is similar;
- what is related;
- what should be retrieved;
- what may be duplicated;
- what belongs in the same conceptual cluster;
- what may be relevant to a known gap;
- what may deserve higher priority.

The embedding must not itself be treated as:

- authoritative source material;
- exact semantics;
- exact code;
- exact architectural intent;
- an implementation specification;
- a reversible representation of source code.

The system must preserve and reference the underlying source information.

The knowledge representation consumed by Assimilation must be readable and inspectable by a human.

## 2.3 Mining is logically infinite but operationally bounded

The mining process has **no normal global completion condition**.

The authoritative production rule is:

```text
IF desired_state == RUNNING:
    the system MUST continue scheduling bounded discovery work
    for every enabled miner indefinitely
    until the user explicitly changes desired_state.
```

The continuous discovery supervisor therefore has persistent intent:

```text
desired_state = RUNNING | PAUSED | STOPPED
```

and separate observed runtime state:

```text
actual_state =
    STARTING
  | RUNNING
  | BACKING_OFF
  | WAITING_SOURCE
  | WAITING_RESOURCE
  | DEGRADED
  | RECOVERING
  | PAUSING
  | PAUSED
  | STOPPING
  | STOPPED
  | BLOCKED_INTEGRITY
```

There is deliberately **no ordinary `COMPLETED` state for the global mining session**.

A bounded epoch, retrieval, knowledge conversion, Assimilation campaign, implementation unit, validation run, or migration may complete. The mining supervisor does not complete merely because one or many such units completed.

The normal lifecycle is:

```text
START
  ↓
RUNNING
  ↓
epoch
  ↓
checkpoint
  ↓
epoch
  ↓
checkpoint
  ↓
epoch
  ↓
...
```

and continues across:

- zero-yield epochs;
- temporarily exhausted query families;
- transient source failures;
- provider failures;
- UI/browser closure;
- worker restarts;
- backend restarts;
- temporary backpressure;
- temporary lack of new knowledge.

None of those conditions means discovery is done.

### Zero-new-knowledge behavior

If an epoch finds no new unique knowledge:

```text
ZERO_YIELD
   ↓
persist yield metrics
   ↓
update exploration memory
   ↓
diversify query/source/strategy
   ↓
apply bounded adaptive backoff
   ↓
schedule the next epoch
```

Forbidden:

```text
if new_findings == 0:
    return COMPLETE
```

Also forbidden:

```text
if search_space_appears_exhausted:
    stop_forever
```

The external ecosystem changes, Agent_X changes, and prior low-value search regions can become relevant after later architecture changes. Search exhaustion is always **local and temporary**, never proof of global completion.

### Production epoch limit

A production continuous-mining session must not have a hidden `max_epochs`, `max_iterations`, `stop_when_no_progress`, or equivalent terminal limit.

Such limits may exist only for:

- tests;
- benchmarks;
- dry runs;
- explicit user-requested bounded sessions.

They must be clearly separate from production continuous mode.

### Persistence across restart

`desired_state` is durable.

If the process crashes while:

```text
desired_state = RUNNING
```

then, when the Agent_X backend starts again, the supervisor must recover the session and resume bounded mining automatically from durable checkpoints.

If the user previously selected:

```text
desired_state = STOPPED
```

restart must **not** silently resume mining.

This is the practical meaning of "infinite until the user stops":

> the intention to keep mining survives runtime interruption; only explicit user state changes or safety-preserving inability to continue can suspend work.

A safety-critical integrity condition may place the actual runtime in `BLOCKED_INTEGRITY`, but it must not rewrite the user's desired state to `STOPPED` or claim the mining task is complete.

### Operational boundedness

No individual computation may be unbounded.

Continuous mining is implemented as an indefinite sequence of finite work units:

```text
Mining Session
    │
    ├── Epoch 000001
    │      ├── Balancer bounded batch
    │      ├── Gap Filler bounded batch
    │      └── Frontier Discovery bounded batch
    │
    ├── durable checkpoint
    │
    ├── Epoch 000002
    │      ├── Balancer bounded batch
    │      ├── Gap Filler bounded batch
    │      └── Frontier Discovery bounded batch
    │
    ├── durable checkpoint
    │
    └── ...
```

Each epoch must terminate independently, persist its effects, release bounded resources, and return control to the supervisor.

This avoids confusing **an infinite service lifetime** with **an infinite function call**.


## 2.4 All work is incremental and chunked

Chunking must exist throughout the system.

Required chunk types include:

- discovery chunk;
- retrieval chunk;
- parsing chunk;
- knowledge extraction chunk;
- normalization chunk;
- deduplication chunk;
- embedding/indexing chunk;
- scoring chunk;
- assimilation chunk;
- implementation chunk;
- validation chunk;
- checkpoint chunk.

No component should receive an unbounded set of discoveries, files, concepts, or requested code changes at once.

---

# 3. Reframing the Three Systems

Balancer, Gap Filler, and Frontier Discovery should no longer be treated as three independent autonomous developers.

They are three **discovery strategies** operating over shared mining and knowledge infrastructure.

They have different objectives, but share the same underlying machinery.

---

# 4. Balancer

## 4.1 Purpose

Balancer asks:

> Where is Agent_X disproportionately strong, weak, over-engineered, under-engineered, asymmetric, or insufficiently supported relative to its own architecture, requirements, comparable systems, and available techniques?

Balancer performs comparative and structural mining.

It may compare:

```text
Agent_X capabilities
        ↕
Agent_X internal architecture
        ↕
external agent systems
        ↕
known architectural patterns
        ↕
benchmarks
        ↕
research
        ↕
production implementations
```

## 4.2 Balancer output

Balancer should create findings such as:

```text
BALANCE_FINDING

Area:
Memory lifecycle management

Observation:
Agent_X has sophisticated retrieval capabilities but comparatively
weaker lifecycle management and persistence semantics.

Supporting evidence:
- ...
- ...
- ...

Potential balancing directions:
- ...
- ...

Relevant Agent_X components:
- ...
- ...

Confidence:
0.87

Open questions:
- ...
```

Balancer must not implement the balancing change.

Its work ends when the finding has been converted into a durable human-readable knowledge artifact and stored.

Assimilation decides what the finding means for Agent_X and whether any change should occur.

---

# 5. Gap Filler

## 5.1 Purpose

Gap Filler asks:

> What capability, safeguard, infrastructure element, abstraction, test, mechanism, operational behavior, or supporting knowledge is missing from Agent_X?

It detects absence rather than imbalance.

## 5.2 Gap Filler output

A typical finding may look like:

```text
GAP_FINDING

Observed capability:
Tool execution

Expected supporting capability:
Durable execution journaling

Missing or incomplete component:
Persistent operation journal with authorization, result,
rollback, and retry state.

Why this appears to be a gap:
- ...
- ...

Evidence:
- ...
- ...

Candidate approaches:
- ...
- ...

Confidence:
0.91

Open questions:
- ...
```

Gap Filler must not implement the missing capability directly.

It produces knowledge for Assimilation.

---

# 6. Frontier Discovery

## 6.1 Purpose

Frontier Discovery asks:

> What exists outside Agent_X that could materially extend its capabilities, architecture, reliability, intelligence, autonomy, safety, observability, efficiency, or generality beyond its current design?

Frontier Discovery is intentionally exploratory.

It searches for:

- emerging research;
- novel architectures;
- uncommon production patterns;
- advanced agent capabilities;
- newly published techniques;
- relevant tools;
- alternative implementation strategies;
- mechanisms not yet represented in Agent_X;
- useful ideas from adjacent technical fields.

## 6.2 Frontier Discovery output

A typical finding may look like:

```text
FRONTIER_FINDING

Capability / idea:
Event-sourced agent execution

Summary:
...

Existing implementations:
- ...
- ...

Why it may matter:
...

Distance from current Agent_X architecture:
Moderate

Potential applicability:
...

Evidence:
- ...
- ...

Limitations / risks:
- ...
- ...

Confidence:
0.84
```

Frontier Discovery does not decide that the capability must be integrated.

Assimilation evaluates relevance, compatibility, conflicts, cost, consequences, and implementation strategy.

---

# 7. Shared Discovery Architecture

The three discovery strategies should share infrastructure while retaining separate reasoning policies.

```text
                 Discovery Orchestrator
                          │
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
      Balancer        Gap Filler       Frontier
       Policy            Policy          Policy
          │               │               │
          └───────────────┼───────────────┘
                          ▼
                   Shared Mining Core
                          │
             ┌────────────┴────────────┐
             ▼                         ▼
       Retrieval Layer            Analysis Layer
             │                         │
             └────────────┬────────────┘
                          ▼
                    Knowledge Layer
                          │
                          ▼
                    Knowledge Store
                          │
                          ▼
                     Assimilation
```

Shared infrastructure should include:

- search;
- crawling or source acquisition;
- repository inspection;
- document parsing;
- code parsing;
- metadata extraction;
- provenance capture;
- source reliability metadata;
- embeddings;
- semantic retrieval;
- clustering;
- deduplication;
- similarity matching;
- relationship generation;
- scoring;
- checkpointing;
- scheduling;
- resource accounting;
- persistence;
- retry logic;
- failure isolation;
- rate limiting;
- observability.

The three strategies should retain independent:

- goals;
- search hypotheses;
- query generation;
- evaluation criteria;
- scoring criteria;
- interpretation;
- stopping criteria for each bounded batch.

They must not be collapsed into one generic prompt merely because they share infrastructure.

---

# 8. Human-Readable Knowledge Artifacts

Before any discovery can enter Assimilation, it must be converted into a structured, human-readable representation.

Assimilation must never receive an embedding as though the vector itself were the knowledge.

Bad input:

```text
vector[3072]
similarity = 0.934
repository_id = 9281
```

Required conceptual form:

```markdown
# Discovery: Durable Agent Execution Journaling

## Origin
Gap Filler

## Summary
Several agent systems separate reasoning state from execution journals.
The journal preserves tool invocation intent, authorization state,
execution result, retry information, and rollback metadata.

## Why this may matter to Agent_X
Agent_X currently persists ...
This may leave ...

## Existing approaches
1. ...
2. ...
3. ...

## Relevant Agent_X components
- Automated governance
- Tool execution
- Checkpointing
- Recovery

## Potential architectural implication
...

## Evidence
1. ...
2. ...
3. ...

## Contradictions / limitations
...

## Open questions
...

## Confidence
0.91

## Provenance
...
```

The exact schema may evolve, but the following properties are mandatory:

- readable natural-language summary;
- explicit source/provenance;
- actual evidence references;
- origin miner;
- relevant Agent_X context;
- uncertainty;
- contradictions or limitations when known;
- confidence or quality metadata;
- link to raw material;
- embedding as an auxiliary index;
- state/lifecycle metadata.

A `KnowledgeObject` must not become `KNOWLEDGE_READY` merely because a model produced a fluent summary.

Every material factual claim needed for later Assimilation must be either:

- linked to one or more evidence/source references; or
- explicitly typed as inference, hypothesis, uncertainty, or proposed implication.

The human-readable conversion layer is therefore an **evidence-preserving interpretation layer**, not a license to replace missing source information with generated prose.

---

# 9. Knowledge Object Model

A durable knowledge object should conceptually contain:

```text
KnowledgeObject
├── id
├── title
├── origin
│   ├── balancer
│   ├── gap_filler
│   └── frontier_discovery
├── source
├── source_type
├── source_uri_or_reference
├── source_timestamp
├── retrieval_timestamp
├── raw_material_reference
├── extracted_text
├── human_readable_summary
├── normalized_knowledge
├── evidence
├── provenance
├── relevant_agent_x_components
├── implications
├── limitations
├── contradictions
├── open_questions
├── confidence
├── reliability_score
├── relevance_score
├── novelty_score
├── priority_score
├── embedding
├── relationships
├── cluster_id
├── duplicate_of
├── lifecycle_state
├── assimilation_status
├── created_at
└── updated_at
```

The embedding belongs inside the object as an auxiliary retrieval feature.

The embedding is not the object itself.

Every finding about the current Agent_X implementation must also bind to the repository/configuration snapshot it observed, for example:

```text
observed_agent_x_revision
observed_workspace_digest
relevant_file_digests
miner_epoch_id
```

A finding may remain historically valid as evidence after Agent_X changes, but it must never be misrepresented as an observation of the newer state.

---

# 10. Knowledge Lifecycle

Knowledge should move through explicit states.

Recommended lifecycle:

```text
DISCOVERED
    ↓
RETRIEVED
    ↓
PARSED
    ↓
EXTRACTED
    ↓
NORMALIZED
    ↓
EMBEDDED
    ↓
DEDUPLICATED
    ↓
KNOWLEDGE_READY
    ↓
ASSIMILATION_QUEUED
    ↓
ASSIMILATING
    ↓
ASSIMILATED
    ↓
VALIDATED
```

Additional states should include:

```text
DUPLICATE
IRRELEVANT
LOW_CONFIDENCE
CONFLICTING
DEFERRED
OBSOLETE
FAILED
REJECTED
NEEDS_REVIEW
```

State transitions must be persisted.

### State namespaces must remain compatible with current L1 contracts

The current L1 shared contract already defines lifecycle values such as:

```text
BLOCKED
NO_CHANGE
IMPLEMENTED
VALIDATED
ACCEPTED
REJECTED
DEFERRED
```

The new discovery states must **not** silently redefine that enum.

Use separate typed namespaces, for example:

```text
MiningSessionState.RUNNING
KnowledgeState.KNOWLEDGE_READY
QueueState.LEASED
AssimilationCampaignState.COMPLETE
L1LifecycleStatus.VALIDATED
```

Only map between them at explicit subsystem boundaries.

If this refactor needs new shared L1 block codes or lifecycle values, those must first be added to the current L1 shared-types/interfaces authority through the normal governed document/FIC process. A miner must not invent a new global status ad hoc.

A crash or restart must not require the mining system to rediscover its position.

---

# 11. Knowledge Store as Durable Research Memory

The Knowledge Store is not a temporary buffer.

It is a durable research memory for Agent_X.

Stopping the miner must never discard previously acquired knowledge.

The system should support:

```text
RUNNING
PAUSED
STOPPED
RESUMABLE
```

Stopping means:

> Do not create additional discovery work.

It does not mean:

> Delete discoveries or lose mining state.

Stored knowledge must remain available for:

- inspection;
- filtering;
- reprioritization;
- later Assimilation;
- re-Assimilation;
- comparison against future Agent_X architecture;
- improved clustering;
- future miners;
- future models;
- audit.

Knowledge discovered today may be assimilated later by a more capable version of Agent_X.

---

# 12. Cross-Miner Correlation

The Knowledge Layer should actively detect relationships between findings from different discovery strategies.

Example:

```text
BALANCER-293
    │
    ├── related_to ── GAP-1204
    │
    └── related_to ── FRONTIER-982
```

Example interpretation:

```text
Balancer:
Memory architecture is disproportionately weak.

Gap Filler:
Durable execution journaling is missing.

Frontier Discovery:
Event-sourced agent execution is emerging as a strong pattern.
```

These should not remain isolated findings.

The system should cluster and relate them into a stronger multi-source knowledge structure that Assimilation can consume.

Cross-miner convergence may increase:

- confidence;
- priority;
- relevance;
- evidence diversity.

It must not automatically imply that implementation is required.

Assimilation remains responsible for that determination.

---

# 13. Mining Pipeline

The mining pipeline should be independent from Assimilation.

```text
Discover
   ↓
Retrieve
   ↓
Parse
   ↓
Extract
   ↓
Convert to human-readable knowledge
   ↓
Normalize
   ↓
Deduplicate
   ↓
Embed / index
   ↓
Relate / cluster
   ↓
Score
   ↓
Persist
   ↓
KNOWLEDGE_READY
```

The miner's responsibility ends when the knowledge is correctly represented and stored.

---

# 14. Assimilation Pipeline

Assimilation consumes stored human-readable knowledge, not direct miner output and not raw vectors.

For the current Agent_X architecture, the new pipeline must integrate with the **existing canonical Assimilation front door and campaign engine**, rather than building another implementation controller.

Required conceptual flow:

```text
Knowledge Store
      ↓
Knowledge Ready Queue
      ↓
manual selection or Auto Assimilation gate
      ↓
typed Assimilation handoff
      ↓
existing canonical Assimilation front door
      ↓
bounded Assimilation Campaign
      ↓
understand source
      ↓
reconcile with current Agent_X
      ↓
check whether already present
      ↓
check conflicts / dependencies / authority
      ↓
determine disposition
      ↓
if implementation is justified:
      create governed change request
      ↓
L1 classification / impact assessment
      ↓
FIC_REQUIRED or existing valid FIC
      ↓
bounded implementation handoff
      ↓
canonical governed effect / implementation path
      ↓
validation
      ↓
review / acceptance as required
      ↓
canonical capability publication if applicable
      ↓
bounded Assimilation hygiene
      ↓
checkpoint / evidence
```

The current Assimilation campaign engine may legitimately put one bounded campaign into a terminal state such as `COMPLETE`.

That does **not** terminate continuous mining.

The distinction is:

```text
AssimilationCampaign #219 → COMPLETE
ContinuousMiningSession    → RUNNING
```

The current canonical integration surfaces should be reused through a narrow adapter. At the time of this review, relevant current surfaces include the universal Assimilation front door (`handle_assimilate_intent`), `CampaignKernel`/campaign execution, and the service-level Assimilation intent path.

The UI and miners should not couple themselves to internal implementation details. They should call a stable typed handoff adapter that binds to the current canonical front door.

Possible Assimilation dispositions include:

```text
NO_ACTION_ALREADY_PRESENT
KNOWLEDGE_ONLY
REJECT
DEFER
ROADMAP
EXPERIMENT
IMPLEMENT
NEEDS_HUMAN_REVIEW
CONFLICT_REQUIRES_RESOLUTION
INSUFFICIENT_PROVENANCE
STALE_REQUIRES_REEVALUATION
```

Discovery does not control this disposition.

Any disposition that can cause code, configuration, capability authority, or governed runtime state to change must remain subject to the existing Agent_X L1/FIC/governance contracts.


# 15. Queue Boundary

Miners must not call Assimilation as an implementation function directly.

Forbidden:

```text
Frontier Discovery → implement(...)
```

Also undesirable:

```text
Frontier Discovery → Assimilation internal execution bypass
```

Required:

```text
Frontier Discovery
        ↓
Knowledge Store
        ↓
Knowledge Ready Queue
        ↓
Assimilation
```

The same applies to Balancer and Gap Filler.

This queue boundary provides:

- replayability;
- batching;
- prioritization;
- auditability;
- manual inspection;
- pause/resume;
- filtering;
- deduplication;
- source review;
- reprocessing;
- re-Assimilation;
- separation of concerns.

---

# 16. Continuous Discovery UI

Balancer, Gap Filler, and Frontier Discovery should be presented as a single continuous discovery/mining experience.

Conceptual UI:

```text
┌────────────────────────────────────────────────────────────┐
│                    CONTINUOUS DISCOVERY                    │
├────────────────────────────────────────────────────────────┤
│ Status:                 RUNNING                            │
│ Session runtime:        17h 42m                            │
│ Epoch:                  1,284                              │
│ Sources processed:      42,197                             │
│ Discoveries:            18,421                             │
│ Unique knowledge:       12,481                             │
│ Ready for assimilation: 7,893                              │
│ Assimilated:            3,102                              │
│                                                            │
│ [✓] Balancer                                               │
│ [✓] Gap Filler                                             │
│ [✓] Frontier Discovery                                     │
│                                                            │
│ [ ] Automatically assimilate ready knowledge               │
│                                                            │
│ Mining ───────────────────────────────────────────────► ∞   │
│                                                            │
│ [ PAUSE ] [ RESUME ] [ STOP ]                              │
├────────────────────────────────────────────────────────────┤
│ BALANCER        GAP FILLER         FRONTIER DISCOVERY       │
│ 3,214           6,882              8,325                    │
│ +42 epoch       +87 epoch          +113 epoch               │
├────────────────────────────────────────────────────────────┤
│ KNOWLEDGE STORE                                            │
│ Discovered      18,421                                     │
│ Parsed          17,994                                     │
│ Unique          12,481                                     │
│ Ready            7,893                                     │
│ Queued           1,024                                     │
│ Assimilated      3,102                                     │
└────────────────────────────────────────────────────────────┘
```

The exact visual design may differ.

The behavioral model must remain the same.

---

# 17. User-Controlled Operating Modes

The UI must support at least two major workflows.

## 17.1 Mining-only mode

```text
[x] Balancer
[x] Gap Filler
[x] Frontier Discovery

[ ] Automatically assimilate ready knowledge
```

Behavior:

```text
Mine
  ↓
Normalize
  ↓
Store
  ↓
Continue mining
```

The user may allow the Knowledge Store to grow indefinitely.

At any point the user may:

- pause mining;
- stop mining;
- inspect discoveries;
- filter data;
- remove or reject data;
- reprioritize data;
- select specific knowledge;
- launch Assimilation manually;
- resume mining later.

## 17.2 End-to-end mode

```text
[x] Balancer
[x] Gap Filler
[x] Frontier Discovery

[x] Automatically assimilate ready knowledge
```

Behavior:

```text
Mine bounded chunk
      ↓
Store knowledge
      ↓
Queue bounded Assimilation chunk
      ↓
Assimilate
      ↓
Implement only justified bounded changes
      ↓
Validate
      ↓
Checkpoint
      ↓
Continue mining
      ↓
...
```

The automatic checkbox connects the Knowledge Ready Queue to Assimilation.

It does **not** authorize the miners to bypass Assimilation.

---

# 18. User Control Over Stopping and Data Use

The system should explicitly permit the user to decide:

- when mining starts;
- which miners are enabled;
- when mining pauses;
- when mining stops;
- whether stored knowledge should remain untouched;
- whether knowledge should be inspected first;
- whether particular data should be rejected;
- whether particular classes of knowledge should be prioritized;
- when Assimilation begins;
- what subset should be assimilated;
- whether Assimilation runs automatically as mining proceeds.

The continuous miner does not need an artificial global completion criterion.

The global stopping condition is primarily:

```text
USER_STOP
```

A miner may complete an individual epoch, batch, source, query family, or search strategy, but the overall discovery process remains open-ended.

---

# 19. Bounded Epoch Execution

Continuous discovery must never be implemented as one giant non-terminating operation.

The supervisor is persistent; every unit it launches is finite.

Conceptually:

```python
while load_session(session_id).desired_state == RUNNING:
    recover_expired_or_interrupted_work()

    baseline = capture_current_agent_x_snapshot()
    epoch = create_or_resume_bounded_epoch(
        session_id=session_id,
        baseline=baseline,
    )

    schedule_fair_balancer_batch(epoch)
    schedule_fair_gap_filler_batch(epoch)
    schedule_fair_frontier_batch(epoch)

    persist_raw_results(epoch)
    convert_to_human_readable_knowledge(epoch)
    normalize_knowledge(epoch)
    resolve_provenance(epoch)
    deduplicate(epoch)
    update_embeddings_as_derived_indexes(epoch)
    update_relationships(epoch)
    score_advisory_metadata(epoch)
    persist_knowledge(epoch)

    if auto_assimilation_enabled():
        queue_bounded_ready_knowledge_exactly_once(epoch)

    checkpoint_epoch(epoch)

    if epoch.unique_new_knowledge == 0:
        update_exploration_memory()
        diversify_next_strategy()
        bounded_adaptive_backoff()

    process_pause_stop_and_configuration_changes()
```

The actual implementation does not need one Python loop or one process. It may use async tasks, workers, the existing campaign/runtime infrastructure, or a persistent scheduler. The semantics above are mandatory.

Every epoch must have bounded:

- source count;
- query count;
- bytes fetched;
- repository files inspected;
- token budget;
- runtime;
- retrieval size;
- parse size;
- transaction size;
- worker concurrency;
- ready-queue contribution;
- temporary disk use.

Exact values are configurable.

### No accidental terminal branch

Production continuous mode must have no control-flow branch equivalent to:

```text
no findings
→ no gaps
→ frontier exhausted
→ balanced
→ COMPLETE
```

Instead:

```text
no findings
→ checkpoint
→ diversify
→ backoff
→ next bounded epoch
```

### Every enabled miner receives work

A valid epoch may allocate different amounts of work to each miner, but the scheduling window must guarantee that every enabled miner is revisited.

Default Continuous Discovery starts with:

```text
Balancer          ENABLED
Gap Filler        ENABLED
Frontier Discovery ENABLED
```

This satisfies the requirement that all three are continuously explored.

Per-miner disabling, if exposed at all, is an explicit advanced user control and must be persisted/audited. It must never happen implicitly because a miner had low recent yield.


# 20. Fair Exploration of All Three Miners

When all three miners are enabled, continuous operation must ensure that all three continue receiving work.

One miner must not permanently starve another because it continuously generates higher-scoring tasks.

The Discovery Orchestrator should provide scheduling fairness.

Possible approaches include:

- round-robin bounded batches;
- weighted fair scheduling;
- minimum epoch allocation per miner;
- adaptive allocation with guaranteed minimum share.

A reasonable conceptual epoch is:

```text
Epoch N
  ├── Balancer batch
  ├── Gap Filler batch
  ├── Frontier Discovery batch
  ├── shared normalization
  ├── shared deduplication
  ├── shared relationship analysis
  └── checkpoint
```

---

# 21. Incremental Assimilation

Automatic Assimilation must not mean:

> Accumulate 20,000 discoveries and ask the model to improve Agent_X from all of them at once.

It must operate on bounded coherent batches.

Example:

```text
Epoch 731
 ├── 25 Balancer discoveries
 ├── 25 Gap Filler discoveries
 └── 25 Frontier discoveries
        ↓
   41 unique knowledge objects
        ↓
   7 high-priority Assimilation candidates
        ↓
   Assimilation batch #194
        ↓
   2 justified implementation units
        ↓
   implementation unit A
        ↓
   validation
        ↓
   checkpoint
        ↓
   implementation unit B
        ↓
   validation
        ↓
   checkpoint
```

Each implementation unit must be independently understandable and testable wherever practical.

---

# 22. Chunking Requirements

## 22.1 Discovery chunk

A bounded set of search/retrieval operations.

## 22.2 Source chunk

A bounded amount of source material to inspect.

## 22.3 Knowledge chunk

One coherent concept, capability, gap, imbalance, technique, or finding.

## 22.4 Assimilation chunk

A bounded set of strongly related knowledge objects that can be reasoned about coherently.

## 22.5 Implementation chunk

One independently manageable code or architecture change.

## 22.6 Validation chunk

A bounded validation target tied to a specific implementation unit.

## 22.7 Checkpoint

A persisted recoverable state after every significant bounded unit.

---

# 23. Deduplication and Novelty

Because mining may run indefinitely, duplicate control is essential.

Before a discovery becomes a new durable knowledge object, the system should compare it against:

- existing raw discoveries;
- existing knowledge objects;
- existing knowledge clusters;
- already assimilated knowledge;
- current Agent_X implementation;
- previously rejected findings where relevant.

Possible outcomes:

```text
NEW
DUPLICATE
NEAR_DUPLICATE
EXTENSION
CONTRADICTION
UPDATED_EVIDENCE
STRONGER_EVIDENCE
OBSOLETES_PREVIOUS
```

Repeated rediscovery should not endlessly inflate the database.

However, repeated independent evidence can increase confidence and should be linked rather than discarded blindly.

---

# 24. Provenance Requirements

Every knowledge artifact must preserve enough provenance to reconstruct why the system believes it.

At minimum preserve:

- origin miner;
- original query or discovery context;
- source identifier;
- source type;
- source location/reference;
- retrieval time;
- source publication/update time when known;
- raw excerpt or raw-material pointer;
- extraction mechanism;
- transformation history;
- relationships to other knowledge objects;
- confidence;
- any model-generated interpretation separately from source facts.

Human-readable synthesis must never destroy access to the evidence behind it.

---

# 25. Source Facts vs Agent_X Interpretation

Knowledge artifacts should distinguish:

```text
SOURCE EVIDENCE
```

from:

```text
AGENT_X INTERPRETATION
```

and from:

```text
POTENTIAL IMPLICATION
```

Example:

```text
Evidence:
System A records authorization state in a durable execution journal.

Interpretation:
This pattern separates execution history from reasoning context.

Potential Agent_X implication:
Agent_X may benefit from evaluating whether its current tool-state
persistence provides equivalent durability.
```

The third statement must not be represented as though it came from the original source.

---

# 26. Current-Agent_X Awareness

Before Assimilation proposes implementation, it must reconcile every relevant finding against the current Agent_X state.

It must determine whether the idea is:

- already implemented;
- partially implemented;
- implemented differently but equivalently;
- incompatible with current architecture;
- made obsolete by newer Agent_X changes;
- useful only after another dependency;
- useful as knowledge but not code;
- duplicative of another planned change.

This is another reason miners must not directly implement their discoveries.

A discovery describes external or comparative information.

Assimilation determines its meaning in the present Agent_X context.

---

# 27. Re-Assimilation

The architecture must support re-Assimilation.

A knowledge object may be revisited because:

- Agent_X changed;
- Assimilation improved;
- stronger evidence arrived;
- a dependency was implemented;
- a previous conflict disappeared;
- a formerly irrelevant capability became relevant;
- the knowledge cluster gained additional supporting discoveries.

Therefore:

```text
ASSIMILATED
```

must not necessarily mean:

```text
NEVER CONSIDER AGAIN
```

The system should preserve assimilation history and allow a later reassessment without erasing previous decisions.

---

# 28. Backpressure

In automatic end-to-end mode, mining may produce knowledge faster than Assimilation can safely process it.

The system must support backpressure.

Possible controls include:

- cap Assimilation queue size;
- reduce mining intensity;
- reduce lower-priority retrieval;
- temporarily prioritize normalization and deduplication;
- pause auto-queueing while continuing raw mining;
- expose queue backlog in UI;
- prevent unbounded memory consumption.

Mining and Assimilation must remain independently controllable.

---

# 29. Failure Isolation and Recovery

A failure in one stage must not invalidate the entire mining session.

Examples:

- one source fails to download;
- one repository fails to parse;
- one embedding request fails;
- one knowledge artifact cannot be normalized;
- one Assimilation candidate fails validation;
- one implementation unit fails tests.

The system should:

```text
record failure
   ↓
preserve context
   ↓
retry when appropriate
   ↓
mark terminal failure if necessary
   ↓
continue unrelated bounded work
```

Continuous discovery should be resilient to partial failure.

---

# 30. Checkpointing

Checkpointing is mandatory.

At minimum checkpoint after:

- discovery epoch completion;
- significant source ingestion;
- knowledge normalization batch;
- deduplication batch;
- queue state mutation;
- Assimilation batch;
- implementation unit;
- validation result;
- user pause;
- user stop.

A restarted process should be able to resume from the latest valid persisted state.

---

# 31. Observability

The UI and backend should expose enough state to understand what the system is doing.

Useful metrics include:

- current session state;
- current epoch;
- enabled miners;
- source count;
- retrieval rate;
- findings per miner;
- unique findings;
- deduplication rate;
- knowledge-ready count;
- queue depth;
- Assimilation throughput;
- implementation candidate count;
- accepted/rejected/deferred counts;
- failure counts;
- storage growth;
- embedding/index growth;
- current resource use;
- time of last checkpoint.

The goal is to make indefinite operation inspectable rather than opaque.

---

# 32. Data Retention and User Decisions

The user should be able to determine what happens to stored discoveries.

Potential user actions may include:

- retain all;
- retain only normalized knowledge;
- delete rejected raw data;
- archive old discoveries;
- remove a source;
- invalidate knowledge derived from a source;
- reprocess data;
- re-embed data;
- re-run deduplication;
- prioritize a cluster;
- exclude a category from Assimilation.

These are data-management actions.

They must remain separate from implementation authorization.

---

# 33. Continuous Mining Does Not Mean Continuous Code Mutation

This distinction must be explicit.

The system may mine continuously while making no code changes.

Example:

```text
Continuous Mining: ON
Auto Assimilation: OFF

Result:
Knowledge Store grows.
Agent_X code remains unchanged.
```

If Auto Assimilation is enabled:

```text
Continuous Mining: ON
Auto Assimilation: ON

Result:
Knowledge is periodically processed through bounded Assimilation
and only justified, validated changes proceed through the existing
implementation/governance path.
```

The phrase "continuous improvement" must not be interpreted as uncontrolled continuous rewriting.

---

# 34. Completion Semantics

## 34.1 Bounded units may complete

These can and should terminate:

```text
Discovery batch → DONE
Source retrieval → DONE
Knowledge extraction → DONE
Normalization → DONE
Deduplication → DONE
Embedding/index update → DONE
Assimilation batch/campaign → COMPLETE
Implementation unit → IMPLEMENTED / BLOCKED / NO_CHANGE
Validation unit → VALIDATED / REJECTED / BLOCKED
Checkpoint → DONE
```

This is required for recoverability and bounded resource use.

## 34.2 The global mining session has no natural completion state

The production Continuous Discovery supervisor does not reach:

```text
ALL_KNOWLEDGE_FOUND
NO_MORE_GAPS
FRONTIER_COMPLETE
BALANCED_FOREVER
COMPLETE
DONE
```

as the result of its own search logic.

Those are invalid global conclusions.

The external environment changes.

Agent_X changes.

New research and repositories appear.

Existing sources change.

A capability that was irrelevant can become relevant after Agent_X evolves.

A newly integrated capability can create a new imbalance or expose a new gap.

Therefore:

```text
RUNNING
  ↓
bounded epoch
  ↓
checkpoint
  ↓
RUNNING
  ↓
...
```

until the durable user-requested state becomes:

```text
STOPPED
```

## 34.3 `STOPPED` is not `COMPLETED`

`STOPPED` means:

> The user requested that this mining session no longer schedule discovery work.

It does not mean:

> Agent_X has finished discovering everything.

The Knowledge Store, evidence, history, and queues remain durable and inspectable.

## 34.4 Infrastructure failure is not completion

If mining cannot safely continue because of:

- disk exhaustion;
- corrupted state;
- unavailable source;
- unavailable model/provider;
- network outage;
- lock-service failure;
- schema migration requirement;

then the runtime uses an explicit operational state such as:

```text
WAITING_RESOURCE
WAITING_SOURCE
DEGRADED
RECOVERING
BLOCKED_INTEGRITY
```

It does not emit `COMPLETE`.

If the durable desired state is still `RUNNING`, recovery should resume automatically when the blocking condition is safely resolved.


# 35. Recommended Top-Level Architecture

```text
┌───────────────────────────────────────────────────────────┐
│                CONTINUOUS DISCOVERY UI                    │
│                                                           │
│ Balancer │ Gap Filler │ Frontier Discovery                │
│                     ∞                                     │
│                                                           │
│ Start / Pause / Resume / Stop                             │
│ Auto Assimilation checkbox                               │
└───────────────────────────┬───────────────────────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────────────┐
│                 DISCOVERY ORCHESTRATOR                    │
│                                                           │
│ scheduling │ fairness │ epochs │ budgets │ checkpoints    │
└───────────────────────────┬───────────────────────────────┘
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
         BALANCER        GAP FILLER      FRONTIER
          policy           policy          policy
             └──────────────┼──────────────┘
                            ▼
┌───────────────────────────────────────────────────────────┐
│                    SHARED MINING CORE                     │
│                                                           │
│ search → retrieve → parse → extract → normalize           │
│ dedupe → embed → cluster → relate → score                 │
└───────────────────────────┬───────────────────────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────────────┐
│                     KNOWLEDGE STORE                       │
│                                                           │
│ Human-readable artifacts                                 │
│ Raw evidence                                              │
│ Provenance                                                │
│ Embeddings                                                │
│ Relationships                                             │
│ Scores                                                    │
│ Lifecycle states                                          │
└───────────────────────────┬───────────────────────────────┘
                            │
                            ▼
                    KNOWLEDGE READY QUEUE
                            │
                            │ manual or automatic
                            ▼
┌───────────────────────────────────────────────────────────┐
│                       ASSIMILATION                        │
│                                                           │
│ understand → reconcile → decide → plan                    │
│ integrate incrementally → validate → govern → checkpoint  │
└───────────────────────────┬───────────────────────────────┘
                            │
                            ▼
                         Agent_X
```

---


# 36. Runtime Model: Decoupled Continuous Producers and Assimilation Consumers

The runtime must not serialize the entire system as:

```text
mine → wait for assimilation → mine again
```

That would allow slow Assimilation to stop discovery and would violate the intended continuous-mining behavior.

The required runtime model is a decoupled producer/consumer architecture:

```text
                           ┌───────────────────────┐
                           │ Discovery Control UI  │
                           └───────────┬───────────┘
                                       │
                                       ▼
                           ┌───────────────────────┐
                           │ Discovery Orchestrator│
                           └───────────┬───────────┘
                                       │
              ┌────────────────────────┼────────────────────────┐
              ▼                        ▼                        ▼
        Balancer worker          Gap Filler worker       Frontier worker
              │                        │                        │
              └────────────────────────┼────────────────────────┘
                                       ▼
                           Canonical Knowledge Store
                                       │
                                       ▼
                              Knowledge Ready Queue
                                       │
                         manual gate or auto gate
                                       │
                                       ▼
                           Assimilation Consumers
                                       │
                                       ▼
                         Controlled Integration Lane
```

Mining workers and Assimilation workers may run concurrently.

The miners must continue producing bounded work while Assimilation processes previously prepared knowledge, subject only to explicit user pause/stop, configured resource limits, or a safety-critical infrastructure condition that makes continued persistence impossible.

The global mining session therefore has two concepts:

```text
desired_state
actual_state
```

Example:

```text
desired_state = RUNNING
actual_state  = RETRYING_AFTER_TRANSIENT_FAILURE
```

A transient failure must not be interpreted as completion or user stop.

When the failure clears, the system should resume from persisted checkpoints automatically.

---

# 37. Delivery Semantics, Idempotency, and Exactly-Once Effects

Long-running resumable systems must assume retries, duplicated messages, worker crashes, process restarts, and network failures.

Therefore, every bounded unit must have a stable identity.

Examples:

```text
session_id
epoch_id
miner_batch_id
source_ingestion_id
knowledge_object_id
assimilation_batch_id
implementation_unit_id
validation_run_id
```

Every state-changing operation must be idempotent.

Reprocessing the same work identifier must never:

- create duplicate canonical knowledge;
- enqueue the same Assimilation item indefinitely;
- apply the same code change twice;
- create duplicate governance requests;
- duplicate validation state;
- corrupt counters or lifecycle state.

The architecture should target **exactly-once effects**, even if the underlying transport provides at-least-once delivery.

This means:

```text
at-least-once message delivery
           +
stable idempotency keys
           +
transactional state transitions
           +
deduplication constraints
           =
exactly-once externally visible effect
```

The implementation must not rely on a claim of perfect exactly-once message delivery from a queue.

---

# 38. Transaction Boundaries, Durable Events, and Queue Correctness

A crash must not be able to produce states such as:

```text
knowledge marked READY
but never actually queued
```

or:

```text
implementation committed
but state still says NOT_IMPLEMENTED
```

For transitions that update persistent state and emit follow-on work, use an atomic persistence pattern such as a transactional outbox or equivalent durable mechanism.

Conceptually:

```text
BEGIN TRANSACTION
    update canonical state
    append durable next-step event/outbox record
COMMIT
```

A dispatcher may then publish the durable event.

If publishing fails, it retries from the outbox.

If publishing succeeds twice, the consumer remains safe because the event carries an idempotency key.

Queue consumers must use leases or ownership claims with expirations so that abandoned work can be recovered after a worker crash.

A work item should conceptually support:

```text
PENDING
LEASED
PROCESSING
SUCCEEDED
RETRYABLE_FAILED
DEAD_LETTERED
CANCELLED
```

Retry policy must distinguish:

- transient failures;
- permanent failures;
- malformed data;
- unsupported source types;
- policy/governance rejection;
- cancellation due to user stop.

Infinite retry loops on permanently invalid work are forbidden.

---

# 39. Canonical Data vs Derived Indexes

The system must define one durable canonical representation of acquired knowledge.

Embeddings, vector indexes, search indexes, caches, cluster assignments, and ranking scores are derived data.

They must be rebuildable.

Conceptually:

```text
Raw Source / Source Reference
          ↓
Canonical Human-Readable Knowledge Artifact
          ↓
Versioned Knowledge Object
          ↓
┌─────────┼────────────┬─────────────┐
▼         ▼            ▼             ▼
Embedding Search index Cluster data Ranking data
```

The vector database must never become the only surviving copy of the knowledge.

If the vector index is deleted or corrupted, Agent_X must be able to rebuild it from canonical stored artifacts without losing semantic content or provenance.

Likewise, a new embedding model may require full re-embedding. Re-embedding must not change the canonical knowledge object's factual content.

---

# 40. Embedding-Origin and Legacy Embedding-Only Records

The redesign specifically changes how pre-existing embedding-backed information is interpreted.

For every embedding-derived candidate, the system must resolve the vector to the associated recoverable payload, source record, code fragment, document, metadata, or other stored evidence before it can become `KNOWLEDGE_READY`.

Required flow:

```text
embedding similarity / embedding candidate
                ↓
resolve associated payload and provenance
                ↓
retrieve supporting source material
                ↓
reconstruct human-readable explanation
                ↓
separate evidence from interpretation
                ↓
normalize into KnowledgeObject
                ↓
Assimilation
```

Forbidden:

```text
embedding vector
      ↓
attempt to "decode" original code
      ↓
implement guessed reconstruction
```

An embedding vector is lossy. It cannot be assumed to contain enough information to reconstruct exact source code or exact implementation semantics.

If a legacy record contains only a vector and no recoverable associated source/payload, it must not be automatically promoted to Assimilation as an implementation candidate.

It should instead become something like:

```text
INSUFFICIENT_PROVENANCE
UNRESOLVABLE_EMBEDDING
NEEDS_REDISCOVERY
```

The miner may use that record to guide a fresh search for recoverable evidence.

This rule is mandatory because the desired architecture treats embeddings as discovery information, not as a reversible source-code format.

---

# 41. Knowledge Versioning and Immutability

Canonical knowledge objects must be versioned.

Source evidence and historical decisions must not be silently overwritten.

A changed interpretation should create a new version or revision relationship.

Conceptually:

```text
KnowledgeObject K-100
  ├── v1
  ├── v2
  └── v3
```

Each Assimilation decision must record the exact knowledge versions it consumed.

Each implementation unit must record the exact Assimilation decision that authorized it.

This creates traceability:

```text
source
  ↓
knowledge version
  ↓
assimilation decision
  ↓
implementation plan
  ↓
code change
  ↓
validation evidence
```

Historical versions may be archived, but audit lineage must remain intact.

---

# 42. Assimilation Snapshot Safety and Stale-Code Protection

Assimilation reasons about a changing codebase.

Therefore, every Assimilation batch must evaluate knowledge against an explicit Agent_X code/architecture snapshot.

At minimum record:

```text
repository
branch
commit_sha / revision_id
configuration version
relevant architecture manifest version
```

An Assimilation decision is valid relative to that snapshot.

Before implementation is committed, the system must verify that the relevant Agent_X state has not changed incompatibly.

If it has changed:

```text
STALE_ASSIMILATION
      ↓
rebase / re-evaluate
      ↓
re-plan if necessary
      ↓
re-validate
```

It must never blindly apply a plan generated against stale architecture.

This is especially important when mining, Assimilation, humans, and other Agent_X improvement processes can operate concurrently.

---

# 43. Controlled Integration Lane and Conflict Prevention

Multiple Assimilation analyses may run concurrently.

Multiple code-changing implementation units must not mutate overlapping architecture without coordination.

The architecture should allow parallel:

- retrieval;
- normalization;
- clustering;
- knowledge analysis;
- Assimilation reasoning;
- testing in isolated workspaces.

But integration into the authoritative Agent_X codebase must pass through a controlled integration lane.

The controlled lane must provide:

- conflict detection;
- dependency ordering;
- current-head verification;
- governance checks;
- validation gates;
- rollback information;
- commit identity;
- idempotency.

Overlapping implementation units should be serialized, rebased, merged through an explicit conflict-resolution process, or rejected for replanning.

No two workers may independently assume they have exclusive ownership of the same mutable code state.

---

# 44. Governance Is Not Bypassed by Auto Assimilation

The `Automatically assimilate ready knowledge` checkbox means:

> automatically feed eligible bounded knowledge into Assimilation.

It does **not** mean:

> disable Agent_X governance or grant unconditional authority to modify anything.

Auto mode must preserve all existing governance requirements.

Conceptually:

```text
Auto Assimilation ON
       ↓
automatic knowledge selection
       ↓
Assimilation
       ↓
proposed implementation
       ↓
existing governance policy
       ↓
automatic approval if policy permits
OR
human approval if policy requires
       ↓
implementation
```

A user enabling end-to-end mode authorizes the workflow to proceed automatically only within the authority already allowed by governance policy.

Sensitive operations must continue to require the approval level defined by Agent_X governance.

### Defense-in-depth: miner origin can never authorize mutation

Do not rely only on "the miner code currently does not call apply."

Every mutating governed effect produced by this architecture should carry verifiable lineage such as:

```text
origin_kind
knowledge_object_ids
assimilation_campaign_id
assimilation_decision_id
fic_id / governed handoff id
current baseline identity
```

For a Balancer/Gap/Frontier-originated change, the canonical effect boundary must verify that the referenced Assimilation decision and governed implementation authorization actually exist in canonical durable state.

A string claiming `assimilation_decision_id = X` is not sufficient.

Required:

```text
miner evidence
    ↓
valid durable Assimilation decision
    ↓
valid L1/FIC/governed implementation authority
    ↓
effect may be considered for execution
```

If that chain cannot be verified, the mutation fails closed.

This makes the no-direct-miner-write invariant enforceable even if a future refactor accidentally exposes a low-level mutation function.

---

# 45. Stop, Pause, Resume, Drain, and Persistent Intent Semantics

The UI controls must have unambiguous runtime semantics.

The backend supervisor, not the browser tab, owns the mining lifecycle.

Closing or refreshing the UI must not stop a running mining session.

## 45.1 Pause

`PAUSE` means:

- persist `desired_state = PAUSED`;
- stop issuing new mining batches;
- allow already-running bounded operations to reach a safe checkpoint unless immediate cancellation is required;
- preserve queues;
- preserve knowledge;
- preserve session/miner cursors;
- preserve exploration memory;
- do not mark the session complete.

State:

```text
RUNNING → PAUSING → PAUSED
```

A backend restart while `desired_state = PAUSED` must restore `PAUSED`, not automatically resume.

## 45.2 Resume

`RESUME` means:

- persist `desired_state = RUNNING`;
- continue from persisted checkpoints;
- recover expired leases;
- reconcile interrupted work;
- do not restart completed bounded work;
- maintain the same session unless the user explicitly starts a new session.

State:

```text
PAUSED → RESUMING/RECOVERING → RUNNING
```

## 45.3 Stop

Default `STOP` is a graceful user terminal state for the mining session:

```text
RUNNING → STOPPING → STOPPED
```

It must:

- persist `desired_state = STOPPED` before acknowledging the user action;
- stop creating new mining batches;
- prevent restart from auto-resuming mining;
- allow bounded active work to reach a safe persistence boundary;
- release or expire worker leases;
- persist final scheduler/miner cursors;
- preserve all mined knowledge and history;
- record `USER_STOP` as the termination reason.

`STOPPED` is not discovery completion.

## 45.4 Process crash/restart while RUNNING

If a process dies without a durable user stop:

```text
desired_state remains RUNNING
```

When the backend returns:

```text
RECOVERING
  ↓
reconcile leases / interrupted epochs
  ↓
RUNNING
```

This is mandatory for the "mine indefinitely until the user stops" contract.

## 45.5 Force abort

A separate `FORCE_ABORT` may exist for operational emergencies.

It must:

- be visually distinct from graceful Stop;
- persist an abnormal termination reason;
- never claim clean completion;
- leave enough durable intent/evidence for recovery and reconciliation.

## 45.6 Mining and Assimilation are independent controls

Stopping mining and stopping Assimilation are separate decisions.

The UI must distinguish at least:

```text
STOP MINING ONLY
STOP MINING + DRAIN ALREADY-QUEUED ASSIMILATION
STOP ALL PROCESSING
```

Turning Auto Assimilation on means:

> enqueue the eligible existing ready backlog and then future eligible knowledge, always in bounded coherent batches.

Turning Auto Assimilation off means:

> do not create new automatic handoffs after the toggle takes effect.

It does not silently cancel or corrupt an already-running bounded Assimilation campaign or erase already queued work. Already queued work follows the explicit drain/stop policy selected by the user.

No ambiguous implicit behavior should exist.

## 45.7 Bounded control latency

Because every work unit is bounded, Pause/Stop must have a documented upper-bound policy.

The system does not have to interrupt an atomic safety-critical commit halfway through, but it must:

- notice the requested desired-state change promptly;
- stop launching new work immediately after durable observation;
- finish, cancel, or roll back the current bounded unit according to its safe-cancellation contract;
- checkpoint and persist the resulting state.

The practical graceful-stop latency is therefore bounded by the configured maximum safe active-unit duration plus checkpoint/reconciliation overhead.

An unbounded model call, network read, repository scan, validation command, or subprocess is forbidden because it would make user Stop non-functional.


# 46. Backpressure Without Permanent Miner Starvation

Backpressure must protect system stability while preserving the intended endless exploration behavior.

When downstream Assimilation is slower than mining, the system may:

- reduce discovery batch sizes;
- lower concurrency;
- delay low-priority source expansion;
- spill ready items durably to storage;
- pause promotion from normalized knowledge to the ready queue;
- compact or archive low-value raw artifacts according to retention policy.

It must not permanently stop one enabled miner while allowing the others to run indefinitely.

Fairness constraints apply even under pressure.

A scheduler should maintain:

```text
minimum service share per enabled miner
+
priority-based adaptation
+
bounded queue growth
```

If persistence capacity is exhausted or data integrity cannot be guaranteed, the system may enter a protective suspended state instead of losing data.

That state is not `DONE`; it is an operational fault requiring recovery.

---

# 47. Search-Space Coverage and Anti-Loop Controls

An infinite miner can waste unlimited resources rediscovering the same concepts unless it remembers where it has searched.

Each miner should maintain exploration memory including:

- query families already attempted;
- source domains already explored;
- repository revisions already processed;
- conceptual clusters already saturated;
- repeated low-yield strategies;
- exclusion reasons;
- freshness timestamps;
- rediscovery cadence;
- unresolved hypotheses.

The scheduler should bias toward novelty while still periodically revisiting older areas for freshness.

The goal is:

```text
continuous exploration
≠
continuous repetition
```

The system should detect mining loops such as:

```text
same query
→ same sources
→ same knowledge
→ same duplicate result
→ repeat forever
```

and automatically diversify search strategy.

A bounded epoch may finish because its local search strategy is exhausted, but the global system then generates a new strategy rather than declaring discovery complete.

---

# 48. Resource Budgets and Long-Running Stability

Every bounded operation must operate under explicit resource budgets.

Relevant configurable limits include:

- maximum sources per batch;
- maximum bytes per source;
- maximum repository files per chunk;
- maximum tokens per model call;
- maximum model calls per epoch;
- maximum wall-clock time per unit;
- maximum concurrent workers;
- maximum retry count;
- maximum database transaction size;
- maximum ready-queue promotion per epoch;
- maximum Assimilation batch size;
- maximum implementation scope per unit.

Long-running operation must also include:

- connection recycling;
- cleanup of temporary workspaces;
- cache eviction;
- bounded logs or log rotation;
- storage monitoring;
- worker health checks;
- leaked-lease recovery;
- orphan artifact cleanup;
- periodic integrity verification.

"Infinite" describes the workflow lifetime, not unlimited resource consumption.

---

# 49. Security and Trust Boundaries for Mined Content

External content is untrusted input.

Repositories, documents, issues, webpages, comments, metadata, and code may contain malicious or misleading instructions.

Mining content must be treated as data, not as trusted control instructions.

The pipeline must defend against:

- prompt injection embedded in source content;
- malicious repository instructions;
- poisoned examples;
- source impersonation;
- hidden executable payloads;
- path traversal during repository/file processing;
- accidental secret ingestion;
- licenses or usage restrictions where relevant.

External text must never be allowed to directly alter system policy, governance, tool permissions, or Assimilation authority.

The trust flow is:

```text
untrusted external content
        ↓
sandboxed retrieval/parsing
        ↓
evidence extraction
        ↓
human-readable knowledge artifact
        ↓
Assimilation under Agent_X policy
```

Not:

```text
external instruction
        ↓
agent obeys instruction
```

---

# 50. Schema Evolution and Migration

This redesign changes the meaning of existing Balancer, Gap Filler, Frontier Discovery, and embedding-backed records.

Migration must be explicit.

The implementation should provide a versioned migration path for:

- existing vector records;
- existing miner findings;
- existing status fields;
- existing queues;
- existing code-generation outputs;
- existing UI controls;
- existing Assimilation inputs.

Legacy records should be classified into categories such as:

```text
MIGRATED_WITH_FULL_PROVENANCE
MIGRATED_WITH_PARTIAL_PROVENANCE
NEEDS_SOURCE_RESOLUTION
NEEDS_RENORMALIZATION
UNRESOLVABLE_LEGACY_VECTOR
ARCHIVED_LEGACY_OUTPUT
```

No migration should fabricate provenance that did not exist.

Direct-implementation pathways formerly owned by the three miners must be removed, disabled, or routed into the new Knowledge Ready Queue.

A compatibility shim may exist temporarily, but it must preserve the central invariant:

```text
no miner directly implements
```

---

# 51. Required End-to-End State Machine

A canonical end-to-end item should be able to follow a state model similar to:

```text
DISCOVERED
   ↓
RETRIEVING
   ↓
RETRIEVED
   ↓
PARSING
   ↓
PARSED
   ↓
EXTRACTING
   ↓
EXTRACTED
   ↓
NORMALIZING
   ↓
NORMALIZED
   ↓
RESOLVING_PROVENANCE
   ↓
PROVENANCE_RESOLVED
   ↓
EMBEDDING
   ↓
EMBEDDED
   ↓
DEDUPLICATING
   ↓
DEDUPLICATED
   ↓
RELATING
   ↓
SCORED
   ↓
KNOWLEDGE_READY
   ↓
ASSIMILATION_QUEUED
   ↓
ASSIMILATING
   ↓
ASSIMILATION_DECIDED
   ├──────────────► KNOWLEDGE_ONLY
   ├──────────────► REJECTED
   ├──────────────► DEFERRED
   ├──────────────► NEEDS_REVIEW
   └──────────────► IMPLEMENTATION_PLANNED
                         ↓
                    GOVERNANCE_GATE
                         ↓
                    IMPLEMENTING
                         ↓
                     VALIDATING
                    ├────────► VALIDATION_FAILED
                    └────────► VALIDATED
                                    ↓
                                INTEGRATED
```

Failure, retry, cancellation, stale-snapshot, duplicate, obsolete, and dead-letter states must be representable without corrupting the primary lifecycle.

The implementation does not have to use these exact names, but it must encode equivalent semantics.

---

# 52. UI Data Decisions Before Assimilation

The user requirement to decide "what to do with the data" must be first-class.

Before manual Assimilation, the UI should allow selection and policy by:

- miner;
- knowledge cluster;
- relevance;
- novelty;
- confidence;
- source;
- age/freshness;
- Agent_X subsystem;
- status;
- contradiction state;
- provenance completeness.

User actions should include at minimum:

```text
ASSIMILATE
DEFER
REJECT
ARCHIVE
REPROCESS
RESEARCH_FURTHER
```

Destructive deletion should be distinguished from logical rejection/archival so auditability is not accidentally lost.

Bulk actions must be chunked and resumable.

---

# 53. Acceptance Criteria and Architecture Tests

The redesign must not be considered complete merely because the UI exists or because the three miners can write to a database.

The implementation must pass end-to-end behavioral tests.

## 53.1 Routing invariant test

For each miner:

```text
Balancer
Gap Filler
Frontier Discovery
```

attempt to produce an implementation-relevant finding.

Pass condition:

```text
finding → Knowledge Store → Ready Queue → Assimilation
```

There must be no direct code mutation path.

## 53.2 Embedding safety test

Provide an embedding-backed legacy candidate.

Pass condition:

- associated payload/evidence is resolved;
- human-readable artifact is created;
- provenance is preserved;
- Assimilation receives the artifact, not a vector-to-code reconstruction.

If associated evidence cannot be recovered, the candidate is not implemented automatically.

## 53.3 Infinite-session boundedness test

Run many epochs.

Pass condition:

- every epoch terminates;
- memory/resource use remains bounded under configured limits;
- checkpoints advance;
- the session remains logically RUNNING.

## 53.4 Three-miner fairness test

Enable all three miners under sustained load.

Pass condition:

- each receives repeated bounded execution opportunities;
- no miner is permanently starved.

## 53.5 Crash recovery test

Crash workers at each major state transition.

Pass condition:

- restart resumes from persisted state;
- no completed work is incorrectly repeated;
- no knowledge or implementation is lost;
- duplicate delivery causes no duplicate effect.

## 53.6 Queue/outbox atomicity test

Crash immediately after state persistence but before event publication, and vice versa.

Pass condition:

- durable recovery eventually produces the correct next step exactly once in effect.

## 53.7 Assimilation stale-snapshot test

Change Agent_X after an Assimilation plan is generated but before integration.

Pass condition:

- stale plan is detected;
- blind implementation is prevented;
- re-evaluation occurs.

## 53.8 Concurrent implementation conflict test

Generate two implementation units that touch overlapping code.

Pass condition:

- conflict is detected;
- both are not blindly committed;
- serialization, rebase, or replanning occurs.

## 53.9 Auto-mode governance test

Enable Auto Assimilation.

Pass condition:

- governance requirements remain active;
- auto mode does not bypass approval-required operations.

## 53.10 Pause/resume test

Pause during active mining.

Pass condition:

- current bounded work reaches safe checkpoint;
- no new batches begin;
- resume continues without duplicate work.

## 53.11 Stop persistence test

Stop mining.

Pass condition:

- mining ceases;
- stored knowledge remains;
- queues and history remain inspectable;
- session termination reason is USER_STOP.

## 53.12 Backpressure test

Make Assimilation intentionally slower than mining.

Pass condition:

- queues stay within configured durability/resource policy;
- mining adapts without uncontrolled memory growth;
- enabled miners retain fair service.

## 53.13 Poisoned-content test

Place prompt-injection-like instructions in mined content.

Pass condition:

- content is treated as source data;
- it cannot alter governance, miner policy, or Assimilation authority.

## 53.14 Vector-index rebuild test

Delete the derived vector index.

Pass condition:

- it can be recreated from canonical human-readable knowledge and source references;
- no knowledge meaning or provenance is lost.

## 53.15 Re-Assimilation test

Assimilate a knowledge object, later change Agent_X or add stronger evidence, then requeue it.

Pass condition:

- previous decision history is preserved;
- new decision uses current state;
- duplicate code is not blindly reimplemented.

The architecture is not 10/10 until these tests are representable and the implementation can satisfy them.

---



# 54. Implementation Isolation, Atomic Promotion, and Rollback

Assimilation-generated implementation must not edit the authoritative live Agent_X workspace incrementally while reasoning is still in progress.

Each implementation unit should execute in an isolated change context such as:

- isolated worktree;
- temporary branch;
- sandbox;
- ephemeral workspace;
- equivalent transactional change environment.

Required flow:

```text
validated Assimilation decision
        ↓
create isolated implementation context
        ↓
apply one bounded implementation unit
        ↓
run scoped validation
        ↓
run required regression validation
        ↓
governance gate
        ↓
verify current authoritative head
        ↓
atomic promotion / controlled merge
        ↓
record resulting revision
```

If implementation or validation fails before promotion:

```text
authoritative Agent_X remains unchanged
```

If a promoted change later fails a post-promotion health check, the system must have enough recorded information to revert, roll back, or create a corrective unit through the governed integration process.

User pause/stop during an implementation unit must never leave half-written authoritative code.

The safe rule is:

```text
work may be partial inside an isolated workspace;
authoritative integration is discrete and recorded.
```

---

# 55. Runtime Version Pinning and Safe Self-Modification

Agent_X may eventually assimilate changes that modify:

- Balancer;
- Gap Filler;
- Frontier Discovery;
- Discovery Orchestrator;
- Knowledge Layer;
- queueing;
- Assimilation itself;
- governance;
- persistence schemas.

The running system must not unpredictably replace the code underneath an active bounded operation.

Every active work unit should be pinned to a runtime/software version.

Example:

```text
epoch 731
runtime_version = commit A
```

If Assimilation integrates commit B that changes the mining engine:

```text
existing bounded work on A → finish/checkpoint safely
new bounded work           → start on B after deployment health checks
```

No mid-function hot mutation of executing logic is allowed unless the runtime explicitly supports safe versioned hot deployment.

Changes to persistence schemas require coordinated migrations that remain compatible with in-flight work or first drain incompatible workers.

If an Assimilation change modifies Assimilation itself, the decision that created that change must still be auditable under the previous version.

This prevents self-modification from erasing or changing the rules by which its own change was authorized.

---

# 56. Scoring, Ranking, and Automation Must Not Become Hidden Authority

Novelty, confidence, relevance, similarity, source quality, cross-miner agreement, and priority scores are decision-support metadata.

They may determine:

- queue ordering;
- what receives additional research;
- what is surfaced to the user;
- what enters automatic Assimilation first.

They must not independently determine:

```text
IMPLEMENT THIS CODE
```

The authority boundary remains:

```text
scores
  ↓
candidate selection
  ↓
Assimilation reasoning
  ↓
governance
  ↓
validated implementation
```

A high score is never equivalent to proof that a change is correct.

Cross-miner agreement is stronger evidence of relevance, but can still reflect shared bad assumptions or common source bias.

---

# 57. Feedback-Loop Stability

Because Agent_X changes itself, successful Assimilation can create new Balancer findings, close Gap Filler findings, and change the Frontier relevance landscape.

This feedback is desirable but must not create uncontrolled oscillation.

Example failure:

```text
Balancer proposes architecture A
        ↓
Assimilation implements A
        ↓
new scan favors architecture B
        ↓
Assimilation replaces A with B
        ↓
next scan favors A
        ↓
repeat forever
```

The system should preserve decision history and use stabilization controls such as:

- knowledge/decision lineage;
- recently changed subsystem markers;
- cooldown windows where appropriate;
- stronger evidence requirements for immediate reversal;
- explicit detection of contradictory recommendations;
- comparison against measured validation outcomes;
- recognition of previously rejected or reverted changes.

A previously integrated design may still be changed when new evidence justifies it.

The goal is not to prevent evolution; it is to prevent low-information thrashing.

---



# 58. Current Agent_X Compatibility Map

The implementation must bind this design to current Agent_X capabilities through adapters and existing authorities.

The following compatibility map is normative for this revision:

| Required concern | Current Agent_X capability to reuse | Redesign rule |
|---|---|---|
| Governed code change | L1 request classification, impact assessment, FIC, handoff, validation, review | Assimilation-generated code change must enter this path; miners never bypass it |
| Bounded autonomous work | current goal/action/queue/campaign machinery | Reuse bounded units and durable identities |
| Assimilation orchestration | `collective_core/assimilation_campaign`, canonical front door, CampaignKernel | Use one bounded campaign per coherent Assimilation unit |
| Durable campaign state | current campaign store with digest/revision/CAS semantics | Reuse for Assimilation campaigns; do not put the entire infinite mining history into one campaign record |
| Worker ownership | current lease/generation fencing | Reuse or extend for discovery-worker/supervisor fencing |
| Governed external effects | current governed effect registry + canonical governance | All implementation effects remain governed |
| Capability authority | current `CapabilityAuthority` | Only Assimilation/promotion may publish routable capabilities |
| Semantic routing | current `SemanticService` / `CapabilitySemanticIndex` | Reuse semantic infrastructure; never create a competing authority/index as code truth |
| Gap → Assimilation | existing durable exactly-once `adopt=False` handoff | Generalize the same semantic boundary to every miner |
| Frontier → Assimilation | existing external-known `ASSIMILATION` route | Generalize to every implementation-relevant frontier finding |
| Balancer safety | sealed plan, isolated qualification, rollback, governance, mutation lock | Move/reuse write-side safeguards behind Assimilation; mining Balancer loses write authority |
| Post-assimilation cleanup | current `AssimilationHygiene` integration | Run bounded hygiene after relevant campaigns |
| UI | current React/Vite UI | Add one Continuous Discovery surface; no second web application |
| API/runtime | existing Agent_X backend/API surfaces | Extend current service; no second autonomous daemon unless governed architecture explicitly requires one |
| Local-first behavior | current offline-capable core | Network discovery is optional capability, not a new boot requirement |

If implementation discovers that a named current module has moved, been superseded, or been consolidated since this review, it must bind to the **current canonical owner**, not recreate the older name.

The compatibility principle is:

```text
reuse canonical owner
or
extend canonical owner
or
migrate canonical owner

never
duplicate canonical owner
```

---

# 59. Placement in the Existing L0/L1/L2 Architecture

This redesign must respect the repository's current layer contract.

## 59.1 L0

Continuous Discovery does not belong in L0.

L0 remains:

```text
independent governed seed kernel
```

L0 must not import the miners, Knowledge Store, Continuous Discovery UI, or Assimilation campaign engine.

## 59.2 L1

Continuous Discovery is part of the **external governed evolution/control plane**.

Its implementation, governance contracts, validators, and FICs belong under the current L1-controlled/tooling architecture.

The current runtime code may continue to live under existing `tools/agentx_evolve/...` canonical modules where that is already the repository convention, but its authority remains L1-governed.

## 59.3 L2

Mined knowledge is not automatically an L2 specialization profile.

Assimilation may decide that a finding should:

- update knowledge only;
- affect an existing L2 profile;
- propose a new specialization profile;
- generate a governed handoff.

That decision remains downstream of Assimilation.

## 59.4 L3/L4/L5

This redesign does not justify creating L3, L4, or L5 merely because mining is continuous.

The current repository rule remains:

```text
do not create higher layers without their existing governed trigger
```

Continuous mining is an evolution-control capability, not permission to pre-create implementation/release layers.

---

# 60. Reuse the Current Assimilation Campaign Engine Instead of Rebuilding It

The current repository already contains a campaign-oriented Assimilator with capabilities that directly solve major parts of this architecture:

- campaign identity;
- durable state outside model context;
- digest/integrity sealing;
- CAS revision checks;
- atomic file persistence;
- process locking;
- lease/generation fencing;
- governed effects;
- idempotency/effect receipts;
- recovery from ambiguous/interrupted effects;
- universal front-door routing.

The redesign should use these capabilities as follows:

```text
Continuous Discovery supervisor
    owns infinite mining intent
        ↓
Knowledge Ready Queue
        ↓
one coherent bounded batch
        ↓
Assimilation campaign
    owns bounded Assimilation lifecycle
        ↓
campaign reaches COMPLETE/BLOCKED/etc.
        ↓
supervisor remains RUNNING
```

Do **not** model the whole infinite mining session as one forever-growing Assimilation campaign.

That would eventually create:

- unbounded task/receipt arrays;
- ever-growing rewrite cost;
- contention on one campaign record;
- recovery latency;
- large integrity-seal operations;
- poor compaction behavior.

Instead:

```text
MiningSessionRecord = small durable supervisor manifest
EpochRecord         = bounded/sharded
KnowledgeObject     = independently addressable
QueueItem           = independently addressable
AssimilationCampaign= bounded unit
```

The campaign engine is therefore a reusable bounded executor, not the persistent container for infinity.

The current campaign completion gate is valid for these **bounded Assimilation campaigns**. A campaign reaching its legitimate completion state means only that the bounded campaign satisfied its own completion contract. It must never be interpreted by the Continuous Discovery supervisor as evidence that mining is complete, that all gaps have been exhausted, or that the frontier has been fully explored.

The separation is explicit:

```text
bounded Assimilation campaign:
    may COMPLETE

continuous mining session:
    remains RUNNING while desired_state == RUNNING
    and only stops because of explicit user intent or a fail-closed operational block
```

### Stable handoff boundary

A stable `AssimilationHandoffAdapter` should translate a `KnowledgeObject` or bounded cluster into the input accepted by the **current canonical front door without bypassing it**.

The current front door is source/file-oriented: it parses an Assimilation command, resolves a source, snapshots the resolved file, and passes a `ResolvedSource` into `CampaignKernel`. The first implementation of this redesign must therefore use an adapter such as:

```text
KnowledgeObject / bounded cluster
        ↓
render canonical human-readable Markdown/JSON sidecar artifact
        ↓
persist artifact durably under the Continuous Discovery knowledge state
        ↓
seal artifact digest + knowledge version + provenance manifest
        ↓
construct canonical Assimilation source/intent accepted by current front door
        ↓
handle_assimilate_intent(...)
        ↓
current source resolver + snapshot
        ↓
CampaignKernel
```

This is preferable to inventing a second direct `KnowledgeObject → CampaignKernel` API.

This adapter is compatible with the inspected current implementation:

- the current source resolver accepts ordinary local files without requiring a code-specific extension;
- the current `CampaignKernel` declares itself material-agnostic and receives a resolved path plus snapshot digest;
- the kernel already enforces bounded execution (`max_execution_steps`, `max_total_attempts`, bounded parallelism), source-drift checking, governed effects, verification, and bounded campaign completion.

Therefore a persisted human-readable `.md` or structured text artifact can be the initial canonical bridge into Assimilation without requiring the miners to synthesize code or bypass the campaign kernel. The implementation must still register/select an Assimilation strategy capable of treating that artifact as information; `NO_REGISTERED_STRATEGY` is a valid fail-closed outcome and must not cause a fallback to direct miner implementation.

In production, the handoff must use the current **configured Collective/Assimilation service integration seam** (or invoke the front door with the same canonical strategy/effect/predicate registries and governance context). It must not instantiate a bare campaign kernel that accidentally omits the registries/governance the running Agent_X service owns. Configuration absence is a blocked integration defect, never permission to construct a second autonomous Assimilation runtime.

A later typed structured-ingestion API may be added only through normal Agent_X governance if it becomes useful, and it must remain an adapter to the same canonical Assimilation semantics rather than a parallel front door.

The adapter should preserve:

```text
knowledge_object_ids
knowledge_versions
source_refs
provenance_digests
human_readable_artifact_refs
workspace_id
Agent_X baseline digest
reason for Assimilation
idempotency key
adopt = false at miner boundary
```

The materialized artifact is not generated code and is not an implementation package. It is the human-readable information source that Assimilation reads. The source file's content digest must bind back to the immutable `KnowledgeObject` version and provenance manifest so a stale or substituted artifact fails closed.

The miner never calls capability adoption or implementation directly.

---

# 61. Balancer Migration: Preserve Intelligence, Remove Miner Write Authority

The current Balancer has mature mutation safeguards. They are valuable, but their ownership must change.

Current useful Balancer capabilities include:

- sealed repository revision;
- stable epoch identity;
- typed artifact states;
- plan/qualification evidence;
- isolated staged qualification;
- accepted-governance binding;
- canonical repository mutation locking;
- rollback snapshots;
- exact restoration evidence;
- production apply guards.

The redesign must split Balancer into two conceptual parts:

```text
BALANCER DISCOVERY / ANALYSIS
    remains Balancer-owned

WRITE-SIDE PROMOTION / MUTATION SAFETY
    becomes shared or Assimilation-owned governed implementation machinery
```

Required post-refactor behavior:

```text
Balancer observes Agent_X
    ↓
Balancer compares / measures / detects imbalance
    ↓
Balancer creates BALANCE_FINDING
    ↓
human-readable artifact + evidence + provenance
    ↓
Knowledge Store
    ↓
Assimilation
```

Forbidden from the post-migration production architecture:

```text
Balancer finding
    ↓
Balancer prepare
    ↓
Balancer apply to authoritative Agent_X
```

This prohibition applies to:

- Continuous Discovery workers;
- existing Balancer UI actions;
- API endpoints;
- CLI commands;
- background loops;
- compatibility callers.

A legacy caller requesting "apply Balancer result" must be redirected into:

```text
Balancer knowledge artifact
    ↓
Assimilation
    ↓
L1/FIC governed implementation
```

rather than retaining a second write authority.

### Reuse, do not discard

Existing sealed-plan, isolated-validation, lock, and rollback code should be:

- extracted into a shared governed implementation primitive;
- delegated to by Assimilation;
- or retained behind a compatibility adapter whose only authoritative caller is the Assimilation/governed implementation path.

The end state must be that **Balancer itself is no longer an implementation authority**.

A compatibility function named `apply_balancer_from_plan` may temporarily remain for migration, but Continuous Discovery must never call it directly. The final migrated architecture should either:

1. retire it; or
2. make it a thin compatibility wrapper around an Assimilation-owned governed promotion service that requires an Assimilation/FIC authorization identity.

There must be an acceptance test proving that a Balancer miner finding alone cannot mutate the repository even when its advisory confidence is maximal.

---

# 62. Gap Filling Migration: Generalize the Existing Exactly-Once Assimilation Handoff

Gap Filling is already closest to the target architecture.

The current implementation proves a durable, restart-safe, exactly-once handoff for the `DECLINED_ASSIMILATE_INSTEAD` path with:

```text
adopt = false
```

and no Gap Filling call to adopt/execute.

The redesign must generalize that rule.

After migration:

```text
ALL implementation-relevant Gap Filler discoveries
    ↓
GAP_FINDING
    ↓
human-readable knowledge artifact
    ↓
durable exactly-once Assimilation handoff
    ↓
Assimilation decides implementation
```

Not only "external known" gaps.

Any current Gap Filling path that can directly apply source changes must be removed from the miner authority path or rehomed as an Assimilation-owned governed implementation primitive.

This applies to every production UI/API/CLI/worker entrypoint. A compatibility "fill/apply" request may remain as a user-facing verb only if its implementation is now:

```text
detect gap
→ persist human-readable knowledge
→ Assimilation handoff
→ governed implementation
```

and not a hidden direct source edit.

Gap Filling may still:

- scan;
- classify;
- produce gap specifications;
- determine evidence;
- estimate impact;
- stage non-authoritative analysis;
- identify candidate solution approaches.

It must not decide that a discovered candidate is code that should simply be adopted.

### Exactly-once key

The generalized handoff should use a stable digest derived from material identity such as:

```text
workspace_id
miner_kind = GAP_FILLER
gap/finding digest
knowledge_object_id
knowledge_version
route = ASSIMILATION
```

A later material knowledge revision or a deliberate re-Assimilation generation may create a new handoff identity.

A retry/restart of the same material decision must not.

---

# 63. Frontier Discovery Migration: Embedding-Supported Research Becomes Knowledge, Not Code

Frontier Discovery already contains governed research/semantic modes and an external-known → `ASSIMILATION` route.

The redesign extends that principle to the entire implementation-relevant frontier pipeline.

Frontier may continue to use:

- embeddings;
- semantic neighborhoods;
- held-out evaluation;
- calibration;
- relation discovery;
- reconstruction experiments;
- novelty scoring;
- prior-art evidence;
- external research.

But every output that might affect Agent_X must first become a human-readable artifact.

Required:

```text
embedding / relation / frontier signal
        ↓
resolve associated material evidence
        ↓
retrieve source/code/docs/paper context
        ↓
human-readable explanation
        ↓
separate source fact from Agent_X interpretation
        ↓
FRONTIER_FINDING
        ↓
Knowledge Store
        ↓
Assimilation
```

A semantic reconstruction or predicted embedding is never treated as "the code to implement."

If a frontier result is genuinely novel but has insufficient external evidence:

```text
RESEARCH_ONLY
or
NEEDS_MORE_EVIDENCE
```

is valid.

When additional evidence makes the concept ready, it can become `KNOWLEDGE_READY`.

Existing frontier scores remain advisory.

They may influence research priority.

They may not authorize effects.

Any current Frontier promotion/apply/adoption surface that can bypass this route must be removed or converted into an Assimilation compatibility entrypoint. The rule applies to all production entrypoints, not only the unified mining UI.

---

# 64. Formal Infinite Mining Contract

This section is the authoritative contract for "mine infinitely until the user stops."

## 64.1 Global invariant

For every Continuous Discovery session:

```text
desired_state == RUNNING
AND backend is operational
AND persistence safety permits scheduling
    ⇒
eventually another bounded discovery scheduling window occurs
```

This is a liveness property.

The system must not remain indefinitely idle while reporting healthy `RUNNING` unless it is in an explicit bounded backoff period.

## 64.2 No hidden completion predicate

The following must never terminate production continuous mode:

```text
no_new_findings
no_new_unique_knowledge
all_current_queries_exhausted
current_repo_unchanged
no_gap_detected
balance_score_stable
frontier_low_yield
assimilation_queue_empty
all_current_sources_seen
N consecutive duplicate epochs
N consecutive zero-yield epochs
```

They influence scheduling/backoff only.

## 64.3 Exploration refresh

Every miner must maintain a durable exploration memory and periodically revisit:

- changed Agent_X subsystems;
- sources whose revision changed;
- stale knowledge;
- previously low-yield query families after cooldown;
- unresolved contradictions;
- deferred findings whose prerequisites changed;
- external sources according to freshness policy.

## 64.4 Fairness liveness

When all three miners are enabled and schedulable, there must exist a configured bounded scheduling horizon `H` such that:

```text
within every H scheduling windows:
    Balancer receives work
    Gap Filler receives work
    Frontier Discovery receives work
```

Adaptive weighting may change how much work each receives.

It may not starve one enabled miner forever.

## 64.5 Backoff is not stop

Backoff must be:

- bounded by configured maximum delay;
- persisted;
- observable;
- interruptible by user Stop/Pause;
- reset or reduced by material new events;
- followed by another scheduling attempt while desired state remains RUNNING.

## 64.6 Crash/restart liveness

A process failure must not convert `RUNNING` into `STOPPED`.

When the backend returns, it must:

1. load durable desired state;
2. acquire/advance supervisor fencing generation;
3. reconcile interrupted work;
4. recover/expire stale worker leases;
5. resume scheduling.

## 64.6A Durable intent versus physical host availability

"Infinite" is a durable liveness contract, not a claim that computation occurs while the Agent_X backend, operating system, or machine is powered off.

If the host/backend is unavailable:

```text
desired_state remains RUNNING durably
no mining computation can occur while no executor exists
when Agent_X backend becomes operational again:
    recover
    reconcile
    resume automatically
```

The system must not require the user to press Start again after an ordinary process restart if the last durable desired state was `RUNNING`.

This is the strongest truthful form of "mine until the user stops": downtime suspends execution physically but does not terminate the mining session logically.

## 64.7 Browser independence

The browser is a control/observation client.

It is not the owner of the loop.

```text
close browser
refresh browser
lose websocket
sleep laptop UI tab
```

must not alter durable mining intent.

## 64.8 Test-only bounded mode

Tests may set:

```text
max_epochs
max_runtime
stop_after_checkpoint
```

Production continuous mode must explicitly reject or ignore those as terminal controls unless the user intentionally selected a bounded run.

---

# 65. Persistent Supervisor, Heartbeat, and Watchdog Semantics

Current Agent_X already has long-running UI/run behavior and has had to distinguish a genuinely active run from an ambiguous timeout.

Continuous Discovery must make that distinction explicit.

A small durable `MiningSessionRecord` should contain at least:

```yaml
MiningSessionRecord:
  session_id: string
  workspace_id: string
  schema_version: string
  created_at: timestamp
  updated_at: timestamp

  desired_state: RUNNING|PAUSED|STOPPED
  actual_state: string

  supervisor_generation: integer
  supervisor_owner: string|null
  supervisor_lease_expires_at: timestamp|null

  enabled_miners:
    balancer: boolean
    gap_filler: boolean
    frontier_discovery: boolean

  auto_assimilate: boolean

  next_epoch_number: integer
  last_completed_epoch: integer|null
  last_checkpoint_at: timestamp|null
  last_heartbeat_at: timestamp|null

  miner_cursors: references
  exploration_state_refs: references
  backoff_state: object
  queue_watermarks: object
  storage_watermarks: object

  stop_reason: string|null
```

The record stays small. It points to sharded state rather than embedding the entire history.

### Idempotent Start and one active supervisor authority

Repeated `START` actions from double-clicks, retries, multiple browser tabs, or API retries must not create duplicate mining universes for the same intended session.

For a normal workspace/scope:

```text
START
  ↓
atomic get-or-create active MiningSessionRecord
  ↓
if already RUNNING:
    return existing session_id
  ↓
otherwise:
    transition desired_state to RUNNING
```

There must be one current supervisor lease/generation per active session.

If the product later intentionally supports multiple independent mining sessions over the same workspace, they must have explicitly different user-visible scope/session identities. Accidental duplication is not a feature.

### Heartbeat contract

The backend must periodically publish:

```text
session_id
actual_state
desired_state
supervisor_generation
last_heartbeat
active bounded work count
last checkpoint
current epoch
per-miner state
```

The UI watchdog must treat a recent authoritative backend heartbeat as proof the intended infinite process is alive.

It must not cancel an active continuous session merely because one HTTP request, model call, or UI timer exceeded a normal chat timeout.

### Stale supervisor recovery

If the supervisor heartbeat/lease expires:

```text
new supervisor acquires higher generation
        ↓
old generation is fenced
        ↓
reconcile in-flight work
        ↓
continue
```

A stale supervisor must not be able to write after ownership changes.

Use the current Agent_X lease/generation semantics or an equivalent extension of the canonical implementation.

---

# 66. Infinite Session Storage Must Be Sharded, Compactable, and Bounded Per Unit

Logical infinity cannot be represented by one ever-growing JSON object, one in-memory list, or one model context.

The storage model must support indefinite accumulation.

Required separation:

```text
MiningSessionRecord
    small mutable manifest

EpochRecord
    one bounded epoch

RawSourceBlob / SourceRef
    content-addressed, deduplicated

KnowledgeObject + versions
    independently addressable

Relationship/cluster records
    independently updateable

Derived semantic indexes
    rebuildable

ReadyQueueItem
    independently addressable

AssimilationCampaign
    one bounded downstream unit

Decision / implementation / evidence records
    durable lineage
```

### No monolithic append forever

Forbidden:

```text
session.json:
    epochs: [1, 2, 3, ... forever]
    discoveries: [... forever]
    receipts: [... forever]
```

Also forbidden:

```text
load every historical knowledge object into RAM on each epoch
```

Use:

- paged access;
- indexed lookups;
- content-addressed blobs;
- bounded transactions;
- incremental compaction;
- archival tiers;
- durable summaries/cursors.

### Hot vs archival data

A reasonable retention model is:

```text
HOT
  active session manifest
  recent epochs
  ready queue
  active knowledge versions
  active relationships

WARM
  older knowledge/evidence needed for re-Assimilation
  decision history
  provenance

COLD/ARCHIVE
  raw duplicate blobs
  superseded raw snapshots
  old epoch detail
```

Compaction must never destroy:

- provenance;
- evidence identity;
- decision lineage;
- references needed to reproduce a claim;
- the ability to rebuild derived indexes.

Before a hot raw blob is removed, the system must verify that its authoritative archived/content-addressed replacement is retrievable and digest-identical, or that retention policy explicitly permits irreversible removal without breaking any accepted evidence chain.

Compaction itself is a bounded, journaled, recoverable operation.

### Capacity exhaustion

If storage reaches a hard safety threshold:

```text
actual_state = WAITING_RESOURCE
desired_state = RUNNING
```

The system stops accepting unsafe new writes, surfaces the problem, and retries/reassesses capacity according to policy.

It does not:

- silently drop discoveries;
- corrupt state;
- mark mining complete;
- change desired state to stopped.

---

# 67. SemanticService and Embedding Policy Aligned With Current Agent_X

Agent_X already has semantic infrastructure.

This redesign should extend the existing `SemanticService` rather than create a separate vector authority unless a governed FIC proves the existing service cannot satisfy the requirement.

For mining knowledge, a new semantic object kind or equivalent may be introduced, for example:

```text
knowledge_artifact
knowledge_evidence
knowledge_cluster
```

but the canonical semantic content remains the human-readable `KnowledgeObject`.

### Two distinct semantic uses must not be confused

Agent_X currently uses semantic indexing for capability routing.

Continuous Discovery uses semantic similarity for knowledge discovery.

These have different authority:

```text
Capability routing
  semantic result participates in canonical capability routing
  current fail-closed routing rules remain authoritative

Knowledge mining
  semantic result is advisory retrieval/discovery evidence
  result must resolve back to human-readable source material
```

A knowledge artifact must start as non-routable knowledge.

It is not automatically a capability contract.

### Embedding provenance

Every derived embedding should record:

```text
embedding_model/provider identity
embedding dimension
normalization/version
input knowledge version
created_at
index/object id
```

Changing the embedding model creates a new derived representation, not a new factual knowledge version unless the human-readable interpretation itself changes.

### Legacy vectors

Legacy vector-only records remain:

```text
UNRESOLVABLE_EMBEDDING
NEEDS_REDISCOVERY
INSUFFICIENT_PROVENANCE
```

until recoverable evidence is found.

They never become guessed source code.

---

# 68. Knowledge-to-Capability Promotion Must Use the Current Capability Authority

Current Agent_X distinguishes knowledge from routable capabilities.

This redesign must preserve that distinction.

Miner output is:

```text
source_class = KNOWLEDGE
routable = false
```

even if the finding appears highly useful.

After Assimilation determines that a capability should exist, the governed implementation path may:

1. define or update the capability contract;
2. implement it through bounded/FIC-governed work;
3. validate fidelity and behavior;
4. publish it through the one current canonical `CapabilityAuthority`;
5. index the routable capability through the current semantic capability path.

Required:

```text
MINED KNOWLEDGE
    ≠
ROUTABLE CAPABILITY
```

and:

```text
embedding similarity
    ≠
capability authority
```

This prevents a miner from accidentally turning advisory research into executable authority.

---

# 69. Preserve Agent_X Local-First and Offline Capabilities

Current Agent_X explicitly supports local-only operation for core governance, transformation, rollback, and proofs.

Continuous Discovery must not make cloud/network access a mandatory boot dependency for the rest of Agent_X.

Discovery sources are capability-adapted.

Possible source classes:

```text
LOCAL_AGENT_X_REPOSITORY
LOCAL_CONFIGURED_REPOSITORIES
LOCAL_DOCUMENT_CORPUS
LOCAL_KNOWLEDGE_STORE
REMOTE_GIT
REMOTE_WEB
REMOTE_PAPERS
REMOTE_APIS
```

If remote access is not configured:

- Balancer can still inspect current/local Agent_X;
- Gap Filler can still inspect current/local Agent_X;
- Frontier Discovery may use configured local corpora and prior stored external knowledge;
- unavailable fresh external sources must be reported truthfully as unavailable.

The system must not fabricate frontier freshness.

If human-readable synthesis requires a model/provider that is unavailable, the item may remain:

```text
SYNTHESIS_PENDING
```

while the global session continues other schedulable work.

Optional remote/provider dependencies should remain optional extras or adapters unless a governed architecture change explicitly revises Agent_X's local-first contract.

---

# 70. Cross-Process Locking and Platform Correctness

Current Assimilation campaign persistence and Balancer mutation paths already use process locking and generation fencing.

The redesign must preserve those guarantees.

A critical rule:

> A platform that does not support the current POSIX `fcntl` lock implementation must not silently degrade into unsafe multi-process writes.

If the existing lock primitive is unavailable, one of the following must occur:

```text
use an equivalent canonical process-safe lock
or
run in explicitly single-process mode with enforcement
or
fail closed for concurrent mutation
```

Never:

```text
fcntl unavailable
→ no lock
→ pretend concurrent safety still exists
```

This matters for:

- mining supervisor ownership;
- campaign state;
- knowledge-store mutations;
- queue claims;
- capability publication;
- repository mutation;
- migrations.

The current repository mutation lock authority should remain singular.

Moving Balancer/Gap write operations behind Assimilation must reduce, not increase, the number of competing mutation authorities.

---

# 71. Single Continuous Discovery UI and Backend Contract

Agent_X already has a React/Vite UI. This redesign adds one unified Continuous Discovery experience inside that application.

The normative default screen should represent:

```text
CONTINUOUS DISCOVERY
────────────────────────────────────────

Status: RUNNING
Desired state: RUNNING
Supervisor heartbeat: healthy
Epoch: 1,284

Miners
  ✓ Balancer
  ✓ Gap Filler
  ✓ Frontier Discovery

[ ] Automatically assimilate ready knowledge

Knowledge
  discovered
  unique
  ready
  queued
  assimilated
  rejected/deferred
  storage usage

Per miner
  last run
  next eligible run
  findings
  unique knowledge
  duplicates
  current backoff
  errors

Controls
  PAUSE
  RESUME
  STOP
```

### Start semantics

The standard `START CONTINUOUS DISCOVERY` action starts all three miners.

All three are enabled by default.

If advanced per-miner toggles exist, they must require explicit user action and persist that decision.

### Auto Assimilation

The checkbox controls automatic routing of eligible `KNOWLEDGE_READY` items.

```text
OFF:
  ready knowledge accumulates
  no new automatic handoffs are created

ON:
  first drain eligible existing KNOWLEDGE_READY backlog in bounded prioritized chunks
  then continue enqueueing newly ready knowledge in bounded chunks
```

This matters when the user mines for hours or days with Auto Assimilation off and later decides to make the workflow end-to-end.

Turning Auto Assimilation on must **not** create one giant campaign from the backlog. Existing ready knowledge is paged, deduplicated, clustered, and submitted as bounded coherent campaigns.

Before each backlog item/cluster is handed off, eligibility must be revalidated against:

- current knowledge version;
- current rejection/defer/obsolete state;
- current provenance completeness;
- current Agent_X baseline;
- duplicate/in-flight Assimilation identity;
- current user filters/policy.

A stale backlog item is re-evaluated, superseded, or deferred; it is not blindly implemented because it once became ready.

The auto-enqueue loop must re-read the Auto Assimilation setting between bounded batches. Turning the checkbox off therefore prevents the system from having pre-enqueued an unbounded backlog.

The user may optionally scope Auto Assimilation to selected filters/clusters. Without such a scope, `ON` means all eligible existing backlog plus future eligible knowledge.

It does not let miners implement.

### Data disposition UI

The user can inspect/filter and perform chunked actions:

```text
ASSIMILATE
DEFER
REJECT
ARCHIVE
REPROCESS
RESEARCH_FURTHER
```

### Persistent backend

The UI must call the existing Agent_X backend/service architecture.

It must not implement mining as:

```text
React component mount
    ↓
while loop in browser
```

The persistent backend owns scheduling.

The UI owns:

- intent;
- configuration;
- status;
- inspection;
- explicit user decisions.

### Transport disconnect

SSE/WebSocket/polling transport may reconnect.

A transport disconnect changes:

```text
UI connectivity
```

not:

```text
mining desired state
```

---

# 72. Expanded Definition of Done and Repository-Level Acceptance Matrix

This architecture is only "10/10" when the implementation passes the existing Agent_X proof philosophy and the following new proofs without weakening current proofs.

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
- state becomes observable `BACKING_OFF`/`WAITING_RESOURCE` as appropriate;
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

## 72.18 Stale Agent_X baseline proof

Generate an Assimilation plan, mutate relevant Agent_X state, then attempt promotion.

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

- Agent_X core still boots and existing offline proofs run;
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

Implement this redesign incrementally so current Agent_X remains functional throughout.

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
- run existing Agent_X proofs;
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
26. **Current Agent_X state is checked before any implementation decision.**
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
39. **Every Assimilation decision is tied to an explicit Agent_X code snapshot.**
40. **Stale Assimilation plans are re-evaluated before integration.**
41. **Concurrent implementation units cannot blindly mutate overlapping code.**
42. **Auto Assimilation never bypasses existing Agent_X governance.**
43. **Pause, resume, stop, drain, and force-abort semantics are explicit and distinct.**
44. **Infinite discovery includes anti-loop exploration memory so endless operation does not become endless repetition.**
45. **External mined content is untrusted data and cannot issue control instructions to Agent_X.**
46. **Legacy data is migrated without fabricating missing provenance.**
47. **User decisions about stored data are first-class and bulk operations remain chunked.**
48. **Architecture acceptance tests verify routing, recovery, boundedness, fairness, stale-state protection, governance, and index rebuildability.**

49. **Implementation occurs in isolated change contexts and authoritative promotion is discrete and recoverable.**
50. **Running bounded work is version-pinned so self-modification cannot mutate execution underneath itself.**
51. **Scores and rankings prioritize investigation but never become hidden implementation authority.**
52. **Continuous self-improvement preserves history and includes anti-thrashing controls for contradictory feedback loops.**




53. **The design reuses the current Agent_X Assimilation campaign engine rather than creating a second Assimilation controller.**
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
73. **Current local-first/offline Agent_X behavior is preserved; remote mining adapters are optional and truthfully unavailable when not configured.**
74. **Unsupported process-lock platforms fail closed or enforce a safe single-process mode; they never silently lose concurrency safety.**
75. **The existing React/Vite UI is extended with one persistent Continuous Discovery surface rather than creating a second UI.**
76. **The backend, not the browser, owns the infinite loop and its durable state.**
77. **Every integrated change remains traceable source → knowledge → Assimilation → L1/FIC → implementation → validation.**
78. **Existing Agent_X proofs remain regression gates; new Continuous Discovery proofs are additive.**
79. **No miner-generated confidence, semantic score, reconstruction, or candidate code is implementation authority.**
80. **The implementation is not considered complete until repository-level tests prove the infinite liveness, no-direct-write, restart, fairness, storage, and authority invariants.**


81. **Every production Balancer/Gap/Frontier entrypoint—not only the new UI—must lose independent implementation authority.**
82. **Turning Auto Assimilation ON drains eligible existing ready backlog and future knowledge in bounded batches.**
83. **MiningSessionState, KnowledgeState, queue/campaign states, and L1 LifecycleStatus are distinct typed namespaces.**
84. **Human-readable summaries are evidence-preserving interpretations; unsupported fluent prose cannot substitute for source evidence.**
85. **Migration is phased so there is never a period with two active authoritative mutation paths.**

86. **Repeated Start requests are idempotent and cannot accidentally create duplicate supervisors for the same intended session.**
87. **Every finding about Agent_X is bound to the exact repository/configuration snapshot it observed.**
88. **Auto-Assimilation backlog eligibility is revalidated against current state before handoff.**
89. **Canonical mutation authority verifies durable Assimilation/FIC lineage; miner-supplied identifiers cannot be forged into authority.**
90. **Pause/Stop latency is bounded by bounded-unit cancellation/checkpoint contracts.**
91. **Archival/compaction cannot break evidence lineage and is itself recoverable.**
92. **Every implementation phase performs a live-HEAD compatibility preflight and revalidates if the repository baseline changes.**
93. **The first KnowledgeObject handoff uses a durable human-readable source artifact through the current canonical source-oriented Assimilation front door; it does not invent a parallel ingestion API.**
94. **Logical infinite mining preserves RUNNING intent across host/backend downtime and resumes when an executor returns; it does not falsely claim computation occurs while the host is unavailable.**

---

# 74. Final Architectural Statement

The redesign should establish one clear epistemic and implementation boundary inside Agent_X:

```text
THE MINERS DISCOVER WHAT AGENT_X MAY NEED TO KNOW.

THE KNOWLEDGE LAYER PRESERVES WHAT WAS FOUND,
WHERE IT CAME FROM, AND WHAT IT APPEARS TO MEAN.

ASSIMILATION DETERMINES WHAT THAT KNOWLEDGE ACTUALLY MEANS
FOR THE CURRENT AGENT_X SYSTEM.

ONLY ASSIMILATION MAY TURN THAT KNOWLEDGE INTO
JUSTIFIED, INCREMENTAL, VALIDATED CHANGES TO AGENT_X.
```

Balancer, Gap Filler, and Frontier Discovery therefore become continuous external intelligence and research mechanisms.

Assimilation becomes the single controlled **knowledge-to-Agent_X integration boundary**.

The overall system can mine indefinitely, accumulate durable knowledge indefinitely, and—when explicitly configured by the user—continuously route bounded knowledge chunks through Assimilation for incremental, validated evolution of Agent_X.

That separation is the foundation of this redesign.

## Repository-Specific Closure

For the current Agent_X repository, the concrete target is therefore:

```text
CURRENT BALANCER
  analysis + qualification + safety evidence
        │
        └── remove miner-owned authoritative apply
                 ↓

CURRENT GAP FILLING
  detection + specification
        │
        └── generalize existing exactly-once adopt=false handoff
                 ↓

CURRENT FRONTIER DISCOVERY
  semantic/frontier research
        │
        └── generalize existing ASSIMILATION route
                 ↓

        HUMAN-READABLE KNOWLEDGE STORE
                 ↓
        KNOWLEDGE READY QUEUE
                 ↓
        CANONICAL ASSIMILATION FRONT DOOR
                 ↓
        BOUNDED ASSIMILATION CAMPAIGN
                 ↓
        L1 / FIC / GOVERNED IMPLEMENTATION
                 ↓
        VALIDATION / REVIEW / ACCEPTANCE
                 ↓
        CANONICAL CAPABILITY AUTHORITY
```

running under:

```text
ONE PERSISTENT CONTINUOUS DISCOVERY SUPERVISOR

desired_state = RUNNING
        ↓
all 3 miners receive bounded work
        ↓
checkpoint
        ↓
all 3 miners receive bounded work
        ↓
checkpoint
        ↓
...
        ↓
USER_STOP
```

There is no algorithmic "we are done mining" state.

The system can become idle for a bounded backoff, wait for resources, recover from a crash, or wait for an unavailable external source. As long as the durable user intent remains `RUNNING`, it remains an active Continuous Discovery session and returns to bounded exploration whenever safely possible.

That is the required end state of this redesign.

