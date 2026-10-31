# Agent_X Continuous Discovery and Assimilation Architecture

## Purpose

This document defines the redesign of **Balancer**, **Gap Filler**, and **Frontier Discovery** in Agent_X.

The central architectural change is:

> **Balancer, Gap Filler, and Frontier Discovery are knowledge-mining systems, not code-generation or direct-implementation systems. Assimilation is the single controlled path from discovered information to understanding, planning, implementation, validation, and integration into Agent_X.**

The three discovery systems may continuously search, retrieve, analyze, compare, cluster, score, and store information. They must not directly modify Agent_X production code.

All discovered information must first be converted into a **human-readable, evidence-backed knowledge representation**. That representation is then processed by the existing Assimilation process exactly as any other external information source would be.

The system must support continuous, effectively unbounded mining until explicitly stopped by the user. Internally, however, all work must remain bounded, incremental, resumable, auditable, and chunked.

---

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

The mining process has no natural global completion condition.

Its normal lifecycle is:

```text
RUNNING → RUNNING → RUNNING → ...
```

until:

```text
USER_STOP
```

However, no individual computation may be unbounded.

Continuous mining must be implemented as an indefinite sequence of bounded work units:

```text
Session
  ├── Epoch 1
  │    ├── Balancer batch
  │    ├── Gap Filler batch
  │    └── Frontier Discovery batch
  │
  ├── checkpoint
  │
  ├── Epoch 2
  │    ├── Balancer batch
  │    ├── Gap Filler batch
  │    └── Frontier Discovery batch
  │
  ├── checkpoint
  │
  └── ...
```

Each epoch must terminate independently and persist its state.

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

Assimilation consumes stored knowledge, not direct miner output.

Required architecture:

```text
Knowledge Store
      ↓
Ready Queue
      ↓
Selection / prioritization
      ↓
Bounded Assimilation batch
      ↓
Understand
      ↓
Reconcile with current Agent_X
      ↓
Check whether already implemented
      ↓
Check conflicts and dependencies
      ↓
Determine implications
      ↓
Decide disposition
      ↓
Plan incremental changes if justified
      ↓
Implement bounded unit
      ↓
Validate
      ↓
Governance / approval where required
      ↓
Checkpoint
```

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
```

Discovery does not control this disposition.

---

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

Continuous discovery must never be implemented as one giant non-terminating unit of work.

Conceptually:

```python
while session.running:
    epoch = create_bounded_epoch()

    run_balancer_batch(epoch)
    run_gap_filler_batch(epoch)
    run_frontier_batch(epoch)

    persist_raw_results(epoch)
    extract_knowledge(epoch)
    normalize_knowledge(epoch)
    deduplicate(epoch)
    update_embeddings(epoch)
    update_relationships(epoch)
    score_knowledge(epoch)
    queue_ready_knowledge(epoch)

    checkpoint(epoch)
    process_stop_or_pause_signal()
```

Every epoch must have bounded:

- source count;
- query count;
- token budget;
- runtime;
- retrieval size;
- parse size;
- database transaction size;
- assimilation queue contribution.

Exact limits should be configurable.

---

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

## 34.1 Bounded unit completion

These can reach DONE:

```text
Discovery batch → DONE
Source retrieval → DONE
Knowledge extraction → DONE
Normalization → DONE
Deduplication → DONE
Assimilation batch → DONE
Implementation unit → DONE
Validation unit → DONE
Checkpoint → DONE
```

## 34.2 Global discovery completion

The overall discovery system does not normally reach:

```text
ALL_KNOWLEDGE_FOUND
NO_MORE_GAPS
FRONTIER_COMPLETE
BALANCED_FOREVER
```

Those states are not realistic.

The environment changes.

Agent_X changes.

New research appears.

New repositories appear.

New implementation patterns emerge.

Agent_X improvements can expose new gaps.

Therefore the global lifecycle is:

```text
START
  ↓
RUNNING
  ↕
PAUSED
  ↓
RUNNING
  ↓
USER_STOP
```

and later:

```text
RESUME
```

if desired.

---

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

# 36. Design Rule Summary

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

---

# 37. Final Architectural Statement

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
