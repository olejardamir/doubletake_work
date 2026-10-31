# Implement Von-1.0 as Agent_X's Borg System-One Runtime

You are operating **inside the current Agent_X repository**.

Your task is to make the already-installed local **Von-1.0** model function as Agent_X's bounded Borg/System-One decision layer, using the prepared Borg/Von package as the design contract and the **current Agent_X codebase as the authoritative integration target**.

This is an implementation task. Do not stop at analysis, architecture notes, scaffolding, or a plan. Inspect the current code, implement the integration end-to-end, run the tests/evaluation corpus, repair failures, and continue until the acceptance criteria are actually satisfied or a concrete external blocker is proven.

---

# Authoritative Inputs

## Agent_X repository

```text
/home/glompy/Desktop/ASTROCYTECH/Agent_X
```

Treat the local current `main` and its actual code as authoritative.

Do not assume an older conceptual architecture is present merely because it appears in documentation.

Inspect before modifying.

Important existing areas likely relevant to this work include, but are not limited to:

```text
L1/controller/
tools/agentx_evolve/unified_runtime/
tools/agentx_evolve/session_runtime/
tools/agentx_evolve/
.agentx-collective/
tests/
```

These are orientation hints, not instructions to force the implementation into those exact files.

Reuse and extend the real architecture that exists.

Do **not** create a second parallel Borg runtime when an existing controller, lifecycle, governance, evidence, worker, session, or collective mechanism should be extended.

---

## Borg/Von design package

The complete prepared package is located at:

```text
/home/glompy/Desktop/ASTROCYTECH/Agent_X/MAIN_DOCS/WISHLIST/Von1/BORG_VON1_PRECODING_PACKAGE_v1.4
```

Read the entire package before implementation.

At minimum locate and consume:

```text
BORG_VON1_RUNTIME_CONTROL_SPEC_v1.4.md
borg_von1_decision_catalog_v1.4.json
borg_von1_eval_seed_v1.4.jsonl
BORG_VON1_SOURCE_COVERAGE_MANIFEST_v1.4.json
BORG_VON1_CONVERGENCE_AUDIT_v1.4.md
```

The package defines the intended Borg behavior, Von decision vocabulary, deterministic invariants, semantic actions, evaluation cases, escalation behavior, nanoprobe responsibilities, governance boundaries, and source coverage.

Do not rewrite this package into a competing specification.

Implement it.

---

## Von runtime

Von should already be installed separately under approximately:

```text
/home/glompy/Desktop/ASTROCYTECH/von-runtime
```

Expected local endpoint:

```text
http://127.0.0.1:8000/v1/systemone
```

Expected backend/model:

```text
von-1.0
```

Verify the real installation and endpoint.

Do not reinstall Von unless it is actually missing or broken.

Do not vendor Von's model weights into Agent_X.

Do not expose Von on `0.0.0.0`.

---

# Core Architecture

The intended control hierarchy is:

```text
USER / QUEEN
      │
      ▼
AGENT_X OBJECTIVES + CURRENT STATE
      │
      ▼
DETERMINISTIC AGENT_X GOVERNANCE / INVARIANTS
      │
      ▼
CHEAP DETERMINISTIC / ALGORITHMIC PROBES WHEN SUFFICIENT
      │
      ▼
VON-1.0
bounded System-One semantic judgment
      │
      ▼
DETERMINISTIC VALIDATION / AUTHORIZATION
      │
      ├── cheap local Agent_X action
      │
      ├── nanoprobe mission
      │
      ├── discovery / assimilation action
      │
      └── OpenCode / strong remote LLM escalation
                    │
                    ▼
           reasoning / coding / research
                    │
                    ▼
              Agent_X execution
                    │
                    ▼
          tests / evidence / outcome
                    │
                    └──────────────► next state
```

Von is **not** the authority.

Von is **not** the coding model.

Von is **not** the planner for open-ended novel work.

Von is **not** allowed to execute arbitrary shell commands, mutate files, bypass governance, or invent unregistered actions.

Von performs bounded decisions among explicitly valid alternatives.

Agent_X remains the authority and execution substrate.

OpenCode / the configured strong LLM remains System Two for heavy reasoning, architecture, coding, debugging, research, synthesis, and novel strategy.

---

# Hard Design Rules

These rules are mandatory.

## 1. Deterministic governance remains above Von

All existing authorization, policy, boundary, evidence, validation, rollback, promotion, workspace, concurrency, and publication rules remain authoritative.

A Von result is a recommendation/decision proposal inside those rules.

A Von response must never itself grant mutation authority.

---

## 2. Do not build one module/process per Borg bullet

The v1.4 package already compiles the source material into reusable decision families and semantic actions.

Use that compiled catalog.

Do not recreate hundreds of bespoke prompts, classes, daemons, or processes.

---

## 3. Do not feed the Borg documents to Von at runtime

The documents are compile-time/design inputs.

Runtime Von requests must contain only the compact state needed for the specific decision plus the bounded candidate choices/criteria.

Never send giant repository dumps, long logs, whole documents, or entire Borg specifications to Von.

Inspect the installed Von implementation and respect its actual token/input limits.

---

## 4. Prefer deterministic logic before Von

If an outcome follows directly from a hard invariant or machine-verifiable condition, do not waste a Von call.

Examples:

```text
unauthorized mutation
invalid schema
known stale snapshot
failed required test
missing required evidence
hard budget exceeded
known lock conflict
explicit user stop
```

These should normally be resolved deterministically.

Use Von where bounded semantic judgment is genuinely useful.

---

## 5. Escalate intelligence only when necessary

Preserve the hierarchy:

```text
Level 0: deterministic probes/rules
Level 1: algorithms / graphs / similarity / ranking
Level 2: Von bounded semantic judgment
Level 3: OpenCode + strong LLM
Level 4: parallel/multi-worker reasoning when justified
```

Do not call the expensive reasoning path when cheaper mechanisms have sufficient confidence.

Do not force Von to solve tasks requiring generative reasoning.

---

## 6. Von failure must not corrupt Agent_X

Handle:

```text
service unavailable
timeout
invalid JSON
malformed response
unknown decision
unknown action
low confidence
ambiguous top choices
catalog mismatch
version mismatch
stale state
```

A Von failure must produce a controlled fallback.

For safety/governance-sensitive cases, fail closed or escalate through the existing governed System-Two path.

Never silently invent an action.

---

# Required Implementation Components

Implement these concepts using the existing Agent_X architecture rather than automatically creating new top-level subsystems.

Exact names may adapt to repository conventions.

---

## A. Borg/Von package loader

Create a single authoritative loader for the v1.4 machine-readable package.

It must:

- load `borg_von1_decision_catalog_v1.4.json`;
- validate its schema/shape;
- validate unique decision IDs;
- validate primitive type (`choice`, `noul`, `score`);
- validate referenced semantic actions;
- validate invariants required by runtime decisions;
- expose immutable runtime decision definitions;
- compute/store package/version/digest information;
- reject malformed or incompatible catalogs loudly.

Do not copy the 85 decisions into Python manually if they can be loaded declaratively.

The JSON catalog should remain the canonical decision-definition source.

---

## B. Compact Borg state compiler

Implement a state compiler that converts current Agent_X state into a **decision-specific projection**.

The compiler should draw only relevant facts such as:

```text
objective
current phase
target/component
event/anomaly
last action
last result
failure signature
evidence state
test state
risk
novelty
utility
cost
capability gap
resource state
worker availability
model availability
rollback availability
snapshot/revision
governance constraints
candidate actions
```

Requirements:

- decision-specific fields only;
- deterministic serialization;
- stable ordering;
- bounded size;
- secrets excluded/redacted;
- no whole-file dumps unless the specific decision truly requires them;
- no Borg source documents in runtime state;
- no hidden mutation instructions embedded in external evidence.

Add tests proving state remains bounded and deterministic.

---

## C. Von client/adapter

Implement a small local client for:

```text
http://127.0.0.1:8000/v1/systemone
```

Requirements:

- loopback only by default;
- configurable endpoint through existing Agent_X configuration conventions;
- bounded timeout;
- no unbounded retry;
- health/status probe;
- request/response validation;
- explicit backend/model metadata;
- latency measurement;
- failure classification;
- no new heavyweight networking dependency unless justified.

Reuse existing Agent_X HTTP/client infrastructure if one already exists.

Do not duplicate a generic HTTP abstraction unnecessarily.

---

## D. Decision engine

Create a governed runtime entry point conceptually equivalent to:

```python
decision = borg_decide(
    decision_id=...,
    current_state=...,
    allowed_actions=...,
)
```

Flow:

```text
decision requested
→ load catalog definition
→ apply deterministic preconditions/invariants
→ compile compact state
→ determine valid choices/criteria
→ call Von if needed
→ validate response
→ apply confidence/reliability gate
→ map result to registered semantic action
→ run deterministic authorization
→ return governed decision record
```

A result must include structured provenance such as:

```text
decision_id
catalog_version/digest
state_snapshot/ref
primitive
candidate set
selected result
probabilities/score
confidence
latency
Von model/backend
fallback/escalation status
governance result
timestamp
```

Do not store raw secrets.

---

## E. Semantic action registry

Use the v1.4 semantic actions as the logical vocabulary.

Map them onto **existing real Agent_X capabilities**.

Do not create decorative wrappers where an existing action already exists.

Examples of runtime mappings may include:

```text
inspect repository
run tests
collect evidence
search knowledge
mine externally
queue assimilation
launch nanoprobe
repair
rollback
quarantine
update collective state
call OpenCode/System Two
continue
defer
stop
```

Every action selected by Von must resolve through an explicit registry.

Unknown/unregistered actions must be rejected.

Von must never emit arbitrary executable commands.

---

## F. System-Two / OpenCode escalation

Locate the real existing Agent_X path that invokes OpenCode or the configured coding/reasoning worker.

Do not invent a parallel shell wrapper if Agent_X already has a worker/runtime/session abstraction.

Wire semantic escalation actions into that path.

The handoff should contain the smallest sufficient packet:

```text
goal
problem/state
why escalation occurred
evidence
relevant files/components
constraints
allowed authority
required output
validation requirements
```

The strong LLM may reason, design, research, debug, or code.

Its result returns to Agent_X, is executed through normal governed mechanisms, and becomes new state/evidence for subsequent Borg decisions.

Von must not directly generate the coding prompt from unconstrained external text without Agent_X sanitization/governance.

---

## G. Nanoprobe integration

Implement the nanoprobe runtime semantics defined by the v1.4 package by extending existing Agent_X mechanisms wherever possible.

Do not model a nanoprobe as a full autonomous LLM agent by default.

Support the hierarchy:

```text
deterministic probe
algorithmic probe
small reasoning/Von-assisted probe
agent/OpenCode escalation
collective escalation
```

Nanoprobe missions must be:

```text
bounded
typed
scoped
budgeted
authorized
evidence-producing
lineage-tracked
stale-target protected
reversible where mutation occurs
terminating by default
```

A read-only probe may discover a mutation opportunity but may not self-promote to mutation authority.

Preserve:

```text
DISCOVERY_PROBE
EVIDENCE_PROBE
TOPOLOGY_PROBE
BEHAVIOR_PROBE
LINEAGE_PROBE
SLOP_PROBE
ASSIMILATION_PROBE
ADAPTER_PROBE
REPAIR_PROBE
REGENERATION_PROBE
ADAPTATION_PROBE
COUNTER_PROBE
```

Reuse current Agent_X probes/tools when behavior already exists.

Implement missing behavior only where the audit proves a real gap.

---

## H. Collective state + decision provenance

Integrate results into the existing Agent_X collective/evidence/ledger mechanisms.

Do not create a disconnected second database merely for Von unless the existing stores cannot support the required data.

Persist enough to answer:

```text
What did Von see?
What decision was requested?
What alternatives were legal?
What did Von return?
How confident was it?
Was it accepted or overridden?
Which invariant/governance rule applied?
What action actually executed?
What happened afterward?
Did the result improve the Collective?
```

Preserve append-only/auditable behavior where existing Agent_X conventions require it.

---

## I. Reliability and promotion registry

Do **not** assume all 85 decision families are equally reliable because Von works on a generic benchmark.

Use the supplied evaluation corpus.

Create a persistent machine-readable reliability record per decision family.

At minimum distinguish:

```text
UNTESTED
ADVISORY
AUTO_ELIGIBLE
DISABLED
```

Promotion must be evidence-based.

A decision can remain advisory while the integration is otherwise complete.

Do not globally enable autonomous control solely from aggregate accuracy.

High-risk decisions require stricter treatment than low-risk routing decisions.

Keep thresholds/configuration explicit and testable rather than buried in code.

---

# Evaluation Harness

Use:

```text
/home/glompy/Desktop/ASTROCYTECH/Agent_X/MAIN_DOCS/WISHLIST/Von1/BORG_VON1_PRECODING_PACKAGE_v1.4/borg_von1_eval_seed_v1.4.jsonl
```

Build or adapt an evaluation runner that executes all supplied cases against the real local Von runtime.

The harness must report at least:

```text
total cases
passed
failed
per-decision-family accuracy
confidence distribution
latency distribution
malformed-response count
timeout/failure count
fallback count
decision families with insufficient evidence
```

Preserve actual outputs for audit.

Do not modify expected labels merely to make Von pass.

The seed corpus is a starting validation suite, not permission to overclaim statistical certainty where a family has too few examples.

---

# Required Runtime Modes

Support at least:

## 1. Disabled

```text
Von is not consulted.
Existing Agent_X behavior remains functional.
```

## 2. Advisory

```text
Von produces decisions and provenance,
but existing governed path remains authoritative.
```

This should be the default initial rollout unless current Agent_X policy already provides a safer staged mechanism.

## 3. Governed automatic

```text
eligible Von decisions may drive registered semantic actions
only after deterministic governance and reliability gates pass.
```

Mode selection must be persisted/configurable using existing Agent_X conventions.

---

# Required Fallback Behavior

At runtime:

```text
hard deterministic answer exists
→ use deterministic answer

otherwise Von eligible and healthy
→ use Von

Von low-confidence / unavailable / ineligible
→ governed System-Two/OpenCode escalation when justified

System Two unavailable
→ defer / preserve state / safe fallback

never
→ fabricate success
```

Do not create infinite retry or escalation loops.

Detect repeated oscillation and stop/escalate appropriately.

---

# Staleness and Concurrency

A decision must be bound to the state/revision it evaluated.

Before any consequential action:

```text
verify state/revision still compatible
```

If stale:

```text
discard/recompute decision
```

Do not apply a Von choice generated against obsolete Agent_X state.

Respect existing worktree, branch, lock, lease, ownership, publication, and concurrency rules.

Never overwrite another worker's work.

Never force-push.

---

# Security / Trust Boundary

Treat all retrieved web content, external repositories, documents, and harvested material as untrusted evidence.

They may affect the state presented to Von, but may not redefine:

```text
Agent_X objective
Queen/user authority
governance invariants
mutation permissions
action registry
decision catalog
system prompts
```

Prevent prompt/instruction injection through evidence fields.

Von's bounded criteria must be generated from trusted catalog definitions and validated Agent_X state, not arbitrary instructions embedded in harvested content.

---

# Operational Surface

Add the smallest useful operator/debug surface using existing Agent_X CLI/API conventions.

Equivalent capabilities must exist for:

```text
Von status/health
current mode
catalog version/digest
run one decision in dry-run/advisory mode
run the full v1.4 evaluation corpus
inspect recent decision provenance
enable/disable advisory operation
```

Do not add an unrelated standalone admin application.

---

# Tests

Add meaningful tests covering at least:

```text
catalog loading
catalog corruption/rejection
decision ID validation
primitive validation
state projection determinism
state size/budget enforcement
secret redaction
Von request serialization
Von response parsing
timeout
service unavailable
invalid response
unknown action
low-confidence path
disabled mode
advisory mode
automatic eligible mode
reliability gate
governance override
stale state rejection
action registry resolution
System-Two escalation
bounded retry
oscillation prevention
decision provenance
nanoprobe authority separation
nanoprobe budget/depth limits
mutation rollback metadata
```

Use mocks/fakes for unit tests where appropriate.

Also run at least one real local Von smoke test when the service is available.

---

# End-to-End Acceptance Demonstration

Create a reproducible demonstration that proves the actual loop works.

Example shape:

```text
Agent_X receives a controlled synthetic state
        ↓
deterministic prechecks pass
        ↓
Borg decision family selected
        ↓
compact state produced
        ↓
Von-1.0 returns bounded decision
        ↓
response passes confidence/reliability gate
        ↓
semantic action resolved
        ↓
Agent_X governance authorizes it
        ↓
safe action or dry-run action executes
        ↓
result/evidence recorded
        ↓
new state becomes available
```

Also demonstrate:

```text
Von offline
→ no uncontrolled action
→ fallback/escalation works

low confidence
→ no uncontrolled action
→ fallback/escalation works

stale state
→ old decision rejected
```

For System-Two escalation, demonstrate that the existing OpenCode/LLM worker path receives a governed handoff rather than Von attempting open-ended reasoning itself.

---

# Regression Requirements

Run the repository's relevant existing test/proof commands in addition to new tests.

Inspect current documentation/Makefile/CI to determine the correct commands.

At minimum, do not leave:

```text
broken default tests
broken L0 governance
broken L1 controller tests
broken session runtime
broken unified runtime
broken transformation lifecycle
broken CLI imports
```

Do not declare success with pre-existing failures silently mixed together.

Record clearly which failures were pre-existing and which were introduced by this work.

---

# Implementation Discipline

Prefer:

```text
reuse
small interfaces
declarative catalog loading
existing stores
existing governance
existing runtime
existing workers
existing evidence mechanisms
```

over:

```text
parallel framework
duplicate orchestrator
giant new abstraction
85 handwritten handlers
decorative Borg naming
unbounded agents
hard-coded prompts
```

Remove or replace obsolete temporary integration code introduced during this task before final acceptance.

Do not count lines of code, files, commits, prompts, or architecture diagrams as success.

Success is demonstrated behavior.

---

# Work Loop

Repeat this loop until acceptance:

```text
1. inspect current authoritative code
2. read relevant v1.4 contract section
3. identify the smallest real integration gap
4. implement
5. test locally
6. run affected existing regression tests
7. run Borg/Von evaluation where applicable
8. inspect evidence/failure
9. repair root cause
10. simplify/prune if possible
11. continue
```

Do not churn working code.

If functionality already exists, map/reuse it and prove equivalence instead of rewriting it.

---

# Acceptance Criteria

Do not claim completion until all of the following are true:

```text
[ ] v1.4 decision catalog is loaded and validated at runtime
[ ] Von local health/status is integrated
[ ] compact decision-specific state compiler exists
[ ] Von cannot execute arbitrary actions
[ ] deterministic governance remains authoritative
[ ] semantic action registry maps to real Agent_X capabilities
[ ] existing OpenCode/System-Two execution path is used for heavy reasoning/coding
[ ] Von failure has a safe bounded fallback
[ ] low-confidence decisions have a governed fallback
[ ] decision provenance is persisted
[ ] stale decisions cannot execute against changed state
[ ] nanoprobe missions are bounded and governed
[ ] read-only probe authority cannot silently become mutation authority
[ ] all supplied v1.4 evaluation cases can be executed by the harness
[ ] per-decision reliability results are produced
[ ] advisory/automatic eligibility is evidence-based
[ ] real Von smoke test succeeds when local service is running
[ ] Von-offline test succeeds safely
[ ] System-Two escalation is demonstrated
[ ] relevant Agent_X regression/proof suite passes or all pre-existing failures are explicitly proven
[ ] no second parallel Borg/controller architecture was created unnecessarily
[ ] no unsupported claim of 100% behavioral correctness is made
```

---

# Final Deliverables

When complete, provide a concise implementation report containing:

```text
1. current repository revision used
2. files added
3. files modified
4. existing Agent_X mechanisms reused
5. Von integration point
6. Borg state compilation path
7. decision catalog loading path
8. semantic action mapping path
9. OpenCode/System-Two escalation path
10. nanoprobe integration path
11. decision provenance storage
12. runtime modes
13. fallback behavior
14. evaluation corpus results
15. per-decision reliability summary
16. real Von smoke-test result
17. regression/proof commands and results
18. known remaining limitations
19. exact commands to operate/test the integration
```

Do not substitute a design document for working code.

Do not stop merely because the architecture looks complete.

Finish only when the runtime path is demonstrably functional.
