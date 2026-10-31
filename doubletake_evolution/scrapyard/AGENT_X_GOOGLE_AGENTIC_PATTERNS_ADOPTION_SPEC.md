# Agent_X — Google Agentic Design Patterns Adoption Specification

**Status:** Implementation specification  
**Target:** Current `main` branch of Agent_X  
**Last reconciled with Google guidance:** 2026-09-15  
**Purpose:** Translate Google's current agentic design-pattern guidance into concrete changes for Agent_X without turning Agent_X into an unnecessarily complex multi-agent framework.

---

## 0. Executive decision

Agent_X should adopt Google's agentic design patterns primarily as **control, orchestration, validation, context, and reliability patterns**.

Agent_X should **not** respond by turning every responsibility into an autonomous agent.

The target architecture is:

```text
USER GOAL
   ↓
INTENT / TASK CLASSIFICATION
   ↓
CONTEXT CONSTRUCTION
   ↓
SEMANTIC SPECIFICATION
   ↓
PLAN / TASK DECOMPOSITION
   ↓
POLICY + VALUE + RISK + ARCHITECTURE GATES
   ↓
ROUTED EXECUTION
   ├─ deterministic/non-LLM path where sufficient
   ├─ cheap model path where sufficient
   └─ deep-reasoning model path only where justified
   ↓
TOOL / CODE / AGENT ACTIONS
   ↓
OBSERVATIONS + ARTIFACTS + EVIDENCE
   ↓
VALIDATION
   ↓
REVIEW / CRITIQUE
   ↓
PROMOTE
   ├─ accept
   ├─ bounded repair loop
   ├─ rollback
   └─ reject
```

The main architectural principle is:

> **Agent_X should be a governed execution engine with one authoritative lifecycle, while prompts/models provide intelligence inside that lifecycle.**

The system should prefer the simplest pattern that reliably solves the task:

```text
deterministic code
    before
cheap deterministic/heuristic routing
    before
small/cheap model
    before
single capable reasoning agent
    before
parallel specialists
    before
coordinator/hierarchical multi-agent
    before
swarm-style collaboration
```

Complexity must be earned by measurable benefit.

---

# 1. Google guidance this specification incorporates

This document incorporates the useful architectural lessons from Google's current guidance, especially:

1. **Single-agent systems**
2. **Sequential workflows**
3. **Parallel workflows**
4. **Loop workflows**
5. **Review-and-critique / generator-critic workflows**
6. **Iterative refinement**
7. **Coordinator workflows**
8. **Hierarchical task decomposition**
9. **Swarm/collaborative workflows**
10. **ReAct — reason, act, observe, repeat**
11. **Human-in-the-loop**
12. **Custom deterministic logic**
13. **Context engineering**
14. **Tool-mediated data access**
15. **Bidirectional MCP**
16. **Event-driven concurrency**
17. **Same-quality-bar fallback**
18. **Tiered routing before expensive model calls**
19. **Bounded loops and explicit termination**
20. **Choosing patterns according to cost, latency, task shape, and risk**

Primary Google material reviewed for this specification:

- Google Cloud Architecture Center, **Choose a design pattern for your agentic AI system**, last reviewed 2026-05-28.
- Google Cloud, **What are agentic workflows?**, updated 2026-08-11.
- Google Developers Blog, **4 engineering patterns behind the strongest AI Agents Challenge submissions**, published 2026-09-02.
- Google Developers Blog, **Developer's guide to multi-agent patterns in ADK**.

This specification does **not** require Agent_X to adopt Google ADK or Google Cloud. The patterns are architectural guidance, not a framework dependency.

---

# 2. Agent_X-specific objectives

The adoption must strengthen the architecture Agent_X is already moving toward:

- semantic-first change planning;
- prompt-driven behavior where prompts are sufficient;
- minimal code where deterministic enforcement is not required;
- hard code for security, state, permissions, execution, transactions, concurrency, rollback, resource limits, storage, and deterministic validation;
- Harvest as a governed evidence/specification source rather than a direct code-injection mechanism;
- replacement rather than accumulation when new behavior supersedes old behavior;
- end-to-end implementation instead of placeholders;
- automatic architecture-placement decisions;
- value assessment before implementation;
- explicit anti-slop validation;
- simple UI with automation replacing unnecessary user decisions;
- evidence-based promotion of changes;
- recovery and rollback rather than pile-on repair;
- one authoritative state model.

---

# 3. Non-goals

The following are explicitly **not** goals.

## 3.1 Do not make Agent_X "multi-agent by default"

A planner, coder, reviewer, tester, Harvest evaluator, repairer, researcher, or architect does not need to be a persistent autonomous agent merely because it has a different role.

Prefer:

```text
same governed runtime
+ different prompt / context / permissions / tools
```

over:

```text
many independently persistent agents
+ agent-to-agent chatter
+ duplicated memory
+ duplicated authority
```

## 3.2 Do not port Google ADK simply to claim pattern compliance

Only adopt external frameworks if a measured requirement cannot be met cleanly by existing Agent_X infrastructure.

## 3.3 Do not make model reasoning authoritative

A model may propose:

- plans;
- architecture;
- tool choices;
- replacements;
- risk;
- repairs;
- acceptance.

But hard guarantees must be enforced outside the model when they concern:

- permissions;
- irreversible actions;
- transaction boundaries;
- branch/worktree safety;
- concurrency;
- quotas;
- rollback;
- validation rules that can be deterministic;
- evidence presence;
- promotion state.

## 3.4 Do not create permanent components for one-off prompt roles

If a role can be represented as a prompt, schema, tool policy, and state transition, do not create a separate service.

## 3.5 Do not allow iterative loops without explicit budgets and exit conditions

No "keep improving until perfect" loop may execute indefinitely.

---

# 4. The core Agent_X lifecycle

All major Agent_X workflows should converge on one lifecycle.

## 4.1 Canonical states

```text
RECEIVED
CLASSIFYING
CONTEXT_BUILDING
SPECIFYING
PLANNING
GATING
READY
EXECUTING
OBSERVING
VALIDATING
REVIEWING
ACCEPTED
PROMOTING
COMPLETED
```

Failure/recovery states:

```text
BLOCKED
REJECTED
EXECUTION_FAILED
VALIDATION_FAILED
REVIEW_FAILED
DIAGNOSING
REPAIRING
REVALIDATING
ROLLING_BACK
ROLLED_BACK
ABORTED
```

Optional waiting state:

```text
AWAITING_HUMAN_APPROVAL
```

## 4.2 Authoritative transition rule

Only the lifecycle/orchestration layer may change the authoritative task state.

Prompts/models may return a **requested transition**, for example:

```json
{
  "requested_transition": "READY",
  "reason": "...",
  "evidence_refs": [...]
}
```

The runtime decides whether that transition is legal.

## 4.3 State must be durable

State must survive:

- process restart;
- model failure;
- tool failure;
- UI refresh;
- repair cycle;
- fallback-model switch.

A model's conversational context is not authoritative task state.

---

# 5. Pattern-selection layer

Google's guidance begins with choosing a pattern based on workload characteristics. Agent_X should formalize this.

Every task should be classified across at least:

```text
task predictability
task complexity
need for external tools
need for dynamic planning
independent parallel work
iteration requirement
risk / reversibility
latency target
cost budget
context size
human approval requirement
quality threshold
```

The classification result must select the **least complex adequate execution pattern**.

## 5.1 Selection rules

### Deterministic/custom logic

Use when:

- rules are known;
- the answer can be computed reliably;
- orchestration does not require model reasoning.

### Single-agent / ReAct

Use as the default for:

- open-ended tasks;
- dynamic tool use;
- moderate multi-step reasoning;
- tasks where one model can maintain the necessary context.

### Sequential

Use when:

- ordering is fixed;
- later stages depend on earlier outputs;
- the model does not need to decide the order.

### Parallel

Use when:

- subtasks are independent;
- concurrency materially reduces latency or improves evidence coverage;
- a merge/synthesis contract exists.

### Review-and-critique

Use when:

- generated output must pass an independent quality check;
- code, architecture, Harvest imports, or high-impact output is involved.

### Iterative refinement

Use when:

- a single pass is unlikely to meet the quality bar;
- an objective acceptance function exists;
- iteration is bounded.

### Coordinator

Use only when:

- routing cannot be reliably determined using deterministic or cheap classification;
- specialists have genuinely different capabilities or contexts;
- dynamic delegation produces measurable value.

### Hierarchical decomposition

Use only when:

- the task is too large or ambiguous for one planning level;
- decomposition quality has been measured to improve outcomes.

### Swarm

Treat as exceptional.

Swarm-style all-to-all agent collaboration should be disabled by default and require evidence that:

- independent perspectives materially improve results;
- simpler parallel/review patterns are insufficient;
- token/cost/latency budgets remain acceptable;
- communication does not introduce authority ambiguity.

---

# 6. Implement tiered routing before expensive inference

Google's September 2026 engineering guidance strongly supports routing cheap/easy work before invoking the expensive reasoning model.

Agent_X should add one routing pipeline:

```text
L0 — deterministic/rule path
L1 — lightweight classifier or small/local model
L2 — standard reasoning model
L3 — strongest/deep-reasoning model
```

## 6.1 L0 must handle work that does not need an LLM

Examples:

- exact command routing;
- known UI actions;
- schema validation;
- file-type dispatch;
- known state transitions;
- simple regex/keyword classification where reliability is high;
- cached deterministic decisions;
- test execution;
- Git status checks;
- artifact existence checks.

## 6.2 L1 handles ambiguous but low-complexity classification

Its job is to classify, not solve the entire task.

It should emit a constrained schema such as:

```json
{
  "route": "harvest_evaluation",
  "confidence": 0.96,
  "risk": "medium",
  "requires_deep_reasoning": false
}
```

## 6.3 L2 handles normal agentic work

This should be the default LLM execution tier.

## 6.4 L3 is escalation, not default

Use the strongest/most expensive reasoning only for:

- architecture ambiguity;
- difficult debugging;
- conflicting evidence;
- high-impact replacement decisions;
- complex synthesis;
- repeated validation failure;
- tasks demonstrated to benefit from deeper reasoning.

## 6.5 Routing must be observable

Record:

- route chosen;
- reason;
- estimated/actual token use;
- model used;
- latency;
- fallback;
- result quality.

This creates the data needed to improve routing later.

---

# 7. Same-quality-bar fallback

Google's recent guidance is especially important here:

> A fallback model is acceptable only if it is forced through the same validation gate as the primary model.

Agent_X must implement **one validation path after all model execution paths**.

Bad:

```text
primary model → validation → accepted
fallback model → accepted
```

Required:

```text
primary model ─┐
               ├→ SAME VALIDATOR → accepted/rejected
fallback model ┘
```

## 7.1 Fallback rules

Fallback may be triggered by:

- timeout;
- provider outage;
- rate limit;
- capacity error;
- configured cost policy;
- local resource pressure.

Fallback must never:

- bypass evidence checks;
- lower acceptance thresholds silently;
- bypass tests;
- gain additional permissions;
- auto-promote because the preferred model was unavailable.

## 7.2 Quality equivalence telemetry

Record acceptance rates by model and task class.

If a fallback repeatedly fails a task class, stop routing that class to that fallback.

---

# 8. ReAct becomes the default dynamic execution loop

For open-ended tasks, Agent_X should formalize:

```text
REASON / PLAN NEXT STEP
    ↓
ACT
    ↓
OBSERVE
    ↓
UPDATE AUTHORITATIVE WORKING STATE
    ↓
CHECK COMPLETION / EXIT CONDITION
```

The model should not receive unlimited transcript history.

Each iteration should receive a constructed context containing only what is useful for the next decision.

## 8.1 ReAct loop controls

Every run needs:

- maximum steps;
- maximum model calls;
- maximum tool calls;
- maximum wall-clock budget where applicable;
- token/cost budget;
- repeated-action detection;
- no-progress detection;
- permission boundary;
- completion condition;
- failure condition.

## 8.2 No hidden success

The loop may not stop merely because the model says "done."

Completion requires the configured evidence/validation gate.

---

# 9. Context engineering

Google explicitly treats context engineering as a core design concern. Agent_X should make it a first-class subsystem.

## 9.1 Context should be constructed, not accumulated

Do not continually append everything.

For each reasoning step construct:

```text
task goal
authoritative semantic specification
current state
relevant architecture facts
relevant source excerpts
relevant prior observations
applicable policy
available tools
tool constraints
remaining budget
acceptance criteria
```

## 9.2 Context sources need provenance

Every injected context item should have:

- source;
- timestamp/version where applicable;
- authority level;
- relevance score;
- freshness;
- trust/evidence status.

## 9.3 Context authority classes

Recommended:

```text
A0 — hard runtime truth
A1 — validated project state/specification
A2 — current repository/tool observation
A3 — accepted historical evidence/memory
A4 — retrieved external evidence
A5 — model inference/proposal
A6 — unverified/raw candidate material
```

Lower-authority information may not silently override higher-authority state.

## 9.4 Context compression

Compression may be used when context is too large, but:

- preserve IDs and provenance;
- preserve constraints;
- preserve unresolved conflicts;
- preserve rejection reasons;
- do not replace authoritative source data when exact source is required;
- allow retrieval of original detail on demand.

---

# 10. Semantic-first planning

Agent_X already has the correct direction: semantic state should be updated before implementation state.

The required change pipeline is:

```text
USER INTENT
  ↓
SEMANTIC DELTA
  ↓
ARCHITECTURAL INTERPRETATION
  ↓
IMPLEMENTATION PLAN
  ↓
CODE / PROMPT / CONFIG DELTA
```

Code should not become the first representation of a new capability.

## 10.1 Semantic specification must answer

- What behavior is being added/changed/removed?
- What user value does it provide?
- What existing behavior overlaps?
- What is authoritative?
- What must remain unchanged?
- What are the inputs?
- What are the outputs?
- What are the failure outcomes?
- What evidence proves success?
- What should be replaced rather than added?
- What lifecycle states are involved?
- What permissions are required?
- What UI behavior changes?
- What acceptance criteria apply?

## 10.2 Semantic/code synchronization

After implementation:

```text
semantic state
      ↕
implemented state
```

must be checked for consistency.

If implementation differs from the semantic specification:

- update implementation if the semantic state is still correct;
- revise the semantic state only through an explicit semantic change decision;
- never silently let code redefine intended behavior.

---

# 11. Planning and task decomposition

Planning should be explicit for non-trivial work.

The plan should be represented as structured state, not prose only.

Example:

```json
{
  "goal": "...",
  "steps": [
    {
      "id": "S1",
      "objective": "...",
      "depends_on": [],
      "pattern": "deterministic",
      "tools": [],
      "acceptance": []
    }
  ],
  "completion_criteria": [],
  "rollback_strategy": "...",
  "risk": "medium"
}
```

## 11.1 Plans are revisable

Observations may invalidate a plan.

The runtime should support:

```text
PLAN_VALID
PLAN_NEEDS_REVISION
REPLAN
```

without throwing away already validated work.

## 11.2 Plans may not grant themselves authority

A planning model cannot add permissions or bypass gates by writing them into its plan.

---

# 12. Unified capability/tool registry

Agent_X should have one authoritative capability registry.

Each capability/tool should declare:

```text
tool/capability ID
purpose
input schema
output schema
side effects
required permissions
risk class
reversibility
idempotency
timeout
resource cost
allowed lifecycle states
allowed callers/roles
validation requirements
provenance/evidence returned
```

## 12.1 Tool selection is policy governed

The model may request a tool.

The runtime decides whether it may be executed.

## 12.2 Tools should return bounded, useful observations

Do not dump whole databases/repos/logs into model context when a narrow query can retrieve exactly what is needed.

This follows the same principle highlighted in Google's MCP example: mediate access through purpose-built tools so context remains bounded and access remains governable.

---

# 13. MCP architecture

Agent_X should treat MCP as a protocol boundary, not merely as a plugin convenience.

## 13.1 MCP client side

Agent_X may consume external tools through a normalized capability layer.

External MCP tools should not bypass:

- capability policy;
- permission checks;
- timeout;
- schema validation;
- provenance;
- evidence capture;
- rate/resource limits.

## 13.2 MCP server side

Agent_X may expose selected validated capabilities to external agents/tools.

But do **not** expose raw internal authority.

Only bounded operations should be exposed.

Required controls:

- authentication;
- authorization;
- capability-level ACLs;
- input validation;
- rate limiting;
- audit logging;
- output filtering;
- no raw secret exposure;
- no direct unrestricted DB/shell/repo mutation unless intentionally authorized.

## 13.3 Reuse rather than duplicate

If Agent_X already has a clean internal capability interface, use the same domain logic behind human UI, internal calls, and MCP exposure rather than building three implementations.

---

# 14. Event-driven concurrency

Google's recent challenge guidance shows when event-driven concurrency is useful.

Agent_X should support events where components need to react independently to the same occurrence.

Examples:

```text
IMPLEMENTATION_READY
VALIDATION_COMPLETED
REPOSITORY_CHANGED
HARVEST_CANDIDATE_ACCEPTED
TEST_FAILURE
SECURITY_ALERT
PROMOTION_COMPLETED
```

## 14.1 Use concurrency only for independent work

Good:

```text
PATCH_READY
 ├─ unit tests
 ├─ static analysis
 ├─ architecture consistency check
 └─ security scan
```

These can run in parallel if they do not mutate conflicting state.

Bad:

```text
patch generation
and
patch validation
```

running concurrently when validation requires the final patch.

## 14.2 Events are typed contracts

Every event should define:

```text
event type
schema/version
producer
correlation/task ID
causation ID
timestamp
payload
authority level
deduplication/idempotency key
```

## 14.3 Avoid event-bus overengineering

Do not convert straightforward synchronous operations into events merely to appear "agentic."

---

# 15. Sequential workflow pattern

Use sequential orchestration for deterministic pipelines.

Likely Agent_X examples:

```text
semantic specification
→ plan
→ implementation
→ test
→ validation
→ promotion
```

or:

```text
Harvest extraction
→ evidence normalization
→ quality/slop analysis
→ value assessment
→ architecture placement
→ inventory admission
```

The orchestration should be deterministic where the order is known.

The model should perform the reasoning **inside** a stage, not decide a known stage order repeatedly.

---

# 16. Parallel workflow pattern

Use parallel execution when work is independent.

Useful Agent_X candidates:

- independent test suites;
- independent static checks;
- independent evidence retrieval;
- comparing multiple architecture options;
- multiple candidate retrieval queries;
- independent repository inspections.

## 16.1 Parallel merge contract

Before fan-out, define how outputs are merged.

The merge layer must handle:

- duplicates;
- conflict;
- missing output;
- timeout;
- partial success;
- provenance;
- differing confidence.

Parallelism without merge semantics is not acceptable.

---

# 17. Review-and-critique pattern

Important Agent_X outputs should not be self-certified by the same unconstrained generation pass.

Required candidates:

- code changes;
- architectural decisions;
- Harvest admissions;
- replacement decisions;
- migrations;
- prompt-system changes;
- security-sensitive behavior;
- high-impact repair.

Use:

```text
GENERATOR
   ↓
ARTIFACT
   ↓
CRITIC against explicit criteria
   ↓
PASS / REPAIR_INSTRUCTIONS / REJECT
```

The critic should evaluate against the original semantic specification and acceptance criteria, not against whether the implementation "looks good."

## 17.1 Reviewer independence

Independence does not require a second persistent agent.

It can mean:

- separate inference call;
- fresh context;
- read-only tools;
- explicit critic prompt;
- inability to modify the artifact it judges.

---

# 18. Iterative refinement and bounded repair

Use a bounded loop:

```text
GENERATE
→ VALIDATE
→ DIAGNOSE
→ REPAIR
→ REVALIDATE
```

## 18.1 Every loop must have exit conditions

Required:

```text
quality threshold reached
OR
max iterations reached
OR
no-progress threshold reached
OR
budget reached
OR
hard blocker discovered
```

## 18.2 No-progress detection

Detect:

- same validation errors repeating;
- patch oscillation;
- repeated revert/reapply;
- unchanged score;
- repeated tool call with no new evidence;
- growing code without increased acceptance.

## 18.3 Escalation

If ordinary repair repeatedly fails:

```text
repair
→ re-plan
→ stronger reasoning tier if justified
→ human approval only if required
→ rollback/reject
```

Do not simply increase iteration count.

---

# 19. Coordinator pattern

Agent_X should **not** default to an LLM coordinator.

Use deterministic routing first.

A model-based coordinator is justified only when:

- input types are genuinely ambiguous;
- a deterministic classifier cannot route reliably;
- specialist capability boundaries are meaningful;
- evaluation shows better completion/quality.

The coordinator may:

- decompose;
- select specialized role;
- merge outputs.

It may not:

- bypass policy;
- grant permissions;
- redefine authoritative state;
- promote its own result.

---

# 20. Hierarchical task decomposition

Use only for tasks where one planning layer is objectively insufficient.

Example:

```text
ROOT GOAL
   ↓
WORKSTREAMS
   ↓
TASKS
   ↓
EXECUTABLE ACTIONS
```

Each level must produce structured output with stable IDs and parent/child relationships.

## 20.1 Depth limit

Set a maximum decomposition depth.

Deep trees create:

- lost context;
- cost;
- duplicated work;
- conflicting authority;
- difficult debugging.

## 20.2 Leaf criterion

A task becomes a leaf when:

- inputs are known;
- output contract is clear;
- allowed tools are known;
- acceptance criteria can be evaluated.

---

# 21. Swarm pattern policy

Swarm should be marked:

```text
DEFAULT: DISABLED
```

Enable only when an experiment demonstrates that it beats simpler approaches on:

- task success;
- output quality;
- failure rate;
- latency acceptable for workload;
- cost acceptable for workload;
- trace/debug complexity.

Agent_X should not use agent-to-agent conversation as a substitute for architecture.

---

# 22. Human-in-the-loop

Human approval should be **risk based** rather than inserted into every workflow.

## 22.1 Suggested risk classes

```text
R0 — read-only / deterministic / harmless
R1 — reversible local change
R2 — meaningful code/config mutation with automated rollback
R3 — architectural/destructive/external side effect
R4 — security-sensitive / irreversible / high-impact
```

Default policy:

```text
R0 → automatic
R1 → automatic if validation passes
R2 → automatic only under configured policy
R3 → explicit approval normally required
R4 → explicit approval required
```

Exact classifications should be adjusted to Agent_X's actual capabilities.

## 22.2 Approval must bind to a concrete artifact

Approval should reference:

- exact plan/version;
- exact diff/action;
- exact scope;
- risk summary.

If the plan materially changes after approval, approval expires.

---

# 23. Memory architecture

Agent_X memory should store **validated useful state**, not indiscriminately preserve model conversation.

Separate at least:

```text
working/session state
project semantic state
validated architectural decisions
validated implementation outcomes
failure/recovery knowledge
user/project preferences
external/reference knowledge
```

## 23.1 Promotion into durable memory

Information may enter durable authoritative memory only when:

- source is known;
- status is validated;
- scope is known;
- staleness policy is known;
- conflicts are resolved or recorded.

## 23.2 Negative memory matters

Store useful rejection knowledge:

- approaches tried and rejected;
- reason;
- evidence;
- conditions under which the decision may be reconsidered.

This prevents Agent_X from repeatedly rediscovering bad approaches.

---

# 24. Evidence ledger

Every meaningful autonomous decision should be evidence-backed.

Create a common evidence record:

```text
evidence ID
task ID
claim/decision supported
source
source version/commit
tool/action that produced it
timestamp
authority/trust class
raw artifact reference
derived interpretation
validator status
```

Decisions that should require evidence include:

- Harvest candidate quality;
- architecture placement;
- replace vs extend;
- implementation success;
- test success;
- performance claim;
- regression absence;
- promotion eligibility.

---

# 25. Validation as a first-class layer

Validation must be external to the implementation/fallback choice.

Use layers:

```text
V0 schema/structural validation
V1 deterministic invariants
V2 tests/static checks
V3 behavioral acceptance
V4 semantic/specification alignment
V5 quality/slop review
V6 optional independent model critique
```

Not every task needs every layer, but the applicable layers must be chosen before execution.

## 25.1 Promotion cannot precede validation

No code, prompt, architecture decision, Harvest admission, or memory update becomes authoritative merely because generation succeeded.

---

# 26. Anti-slop architecture

The Google patterns should strengthen Agent_X's existing anti-slop direction.

Before accepting an implementation, check for:

- placeholder logic;
- TODO-as-implementation;
- fake algorithmic depth;
- unused abstractions;
- duplicate subsystems;
- wrapper-on-wrapper accumulation;
- new code where existing code should be replaced;
- dead configuration;
- dead UI;
- features with no reachable user path;
- features with no real use case;
- unnecessary new dependencies;
- unnecessary persistent agents;
- unnecessary services;
- no-op "architecture";
- tests that assert implementation trivia rather than behavior;
- self-reported success without evidence.

## 26.1 Complexity delta

Every implementation plan should estimate:

```text
behavioral value added
code added
code removed
concepts added
concepts removed
dependencies added
runtime processes added
model calls added
state stores added
UI decisions added/removed
```

A change should be rejected or redesigned if complexity rises disproportionately to value.

---

# 27. Replace-vs-extend rule

Before implementation, Agent_X must decide:

```text
REPLACE
EXTEND
COMPOSE
NO CHANGE
REJECT
```

Default toward **REPLACE** when the new mechanism supersedes an existing one.

The decision must consider:

- behavior overlap;
- migration risk;
- compatibility;
- old call sites;
- old tests;
- old configs;
- old UI;
- old prompts;
- old state;
- cleanup.

A completed replacement is not:

```text
new system added + old system left dormant
```

A replacement is complete only when obsolete paths are removed or intentionally retained with explicit justification.

---

# 28. Harvest integration under these patterns

Harvest should become a governed upstream source of semantic capability candidates.

Recommended flow:

```text
DISCOVER
  ↓
EXTRACT EVIDENCE
  ↓
NORMALIZE
  ↓
SLOP / QUALITY CHECK
  ↓
VALUE CHECK
  ↓
FIT / ARCHITECTURE CHECK
  ↓
CONFLICT / DUPLICATION CHECK
  ↓
REPLACE-vs-EXTEND DECISION
  ↓
INVENTORY
  ↓
USER SELECTS / POLICY SELECTS IMPLEMENTATION
  ↓
SEMANTIC DELTA
  ↓
IMPLEMENTATION PLAN
  ↓
IMPLEMENT
  ↓
VALIDATE
  ↓
PROMOTE / REPAIR / REJECT
```

## 28.1 Harvest inventory is not authority to implement

Admission to inventory means:

> "This candidate is sufficiently evidenced and potentially useful to consider."

It does not mean:

> "This must be coded."

## 28.2 Pre-implementation gate

Before the UI offers implementation as a valid action, Agent_X should know:

- expected value;
- architectural fit;
- feasibility;
- hardware/software compatibility;
- dependencies;
- overlap with existing implementation;
- replacement target if applicable;
- expected complexity;
- regression risk;
- evidence quality.

## 28.3 End-to-end requirement

Harvest implementation is not complete until:

- runtime path is wired;
- UI path is wired if user-facing;
- configuration is wired;
- semantic state is updated;
- obsolete path is cleaned up;
- tests exist;
- evidence exists;
- promotion succeeds.

---

# 29. UI implications

Google's patterns should make the Agent_X UI **simpler**, not expose orchestration machinery to the user.

The UI should primarily show:

```text
what Agent_X understood
what it intends to do
risk/approval when needed
current meaningful state
result
evidence/problems when relevant
```

Do not routinely expose:

- every internal agent;
- every prompt;
- every routing decision;
- every loop iteration;
- every internal event;
- every confidence value;
- every tool call.

Advanced diagnostics may expose them separately.

## 29.1 Recommended user-facing states

```text
Analyzing
Planning
Ready
Working
Checking
Needs approval
Completed
Could not complete
Rolled back
```

Internally the lifecycle can remain more detailed.

---

# 30. Observability and traceability

Every run should be reconstructible.

Capture:

```text
task ID
parent/child task IDs
pattern selected
route/tier selected
model(s)
prompt template/version
context package IDs
tool calls
events
state transitions
artifacts
cost/tokens
latency
validation results
fallbacks
retries
repair iterations
promotion decision
final outcome
```

## 30.1 Trace meaning, not hidden model reasoning

The trace should capture decisions and reasons in structured summaries, not depend on preserving private chain-of-thought.

Example:

```json
{
  "decision": "replace_existing_component",
  "reason_summary": "New capability fully subsumes old path and duplicate execution would create conflicting authority.",
  "evidence_refs": ["E17", "E23"]
}
```

---

# 31. Cost and resource governance

Every execution class should have budgets.

Possible controls:

```text
max model calls
max tokens
max tool calls
max parallel fan-out
max repair iterations
max decomposition depth
max runtime
max external requests
max artifact size
```

Budgets should be task-class specific.

A task exceeding budget should transition to:

```text
BLOCKED
REPLAN
ESCALATE
or
ABORTED
```

rather than silently continue.

---

# 32. Security and permission boundaries

Capabilities must run under least privilege.

A role/prompt should receive only the tools it needs.

Examples:

- reviewer: read-only;
- planner: normally read-only;
- code implementer: scoped repo mutation;
- validator: read/execute tests but no arbitrary promotion;
- promoter: promotion operation only after validation state.

No model role should receive broad authority merely because it might be convenient.

---

# 33. Determinism where determinism is available

A central lesson from Google's pattern selection is that not everything should be agentic.

Convert model-mediated operations to deterministic logic when:

- the rule is stable;
- a schema can express it;
- a direct computation is reliable;
- exact reproducibility is desirable.

Agent_X should actively identify **de-agentification opportunities** during refactoring.

---

# 34. Prompt-driven architecture rules

Agent_X's prompt-driven direction remains valid, but prompts must be bounded by deterministic infrastructure.

Good prompt-owned responsibilities:

- semantic interpretation;
- plan proposals;
- architecture option analysis;
- contextual classification when heuristics are insufficient;
- synthesis;
- critique;
- diagnosis;
- repair proposals.

Code-owned responsibilities:

- state;
- transactions;
- permissions;
- sandboxing;
- Git safety;
- locking;
- event delivery guarantees;
- timeout enforcement;
- budgets;
- schemas;
- artifact storage;
- rollback;
- deterministic validators;
- secret handling;
- audit records.

---

# 35. One authority per decision

For every decision type, define exactly one authoritative layer.

Example:

| Decision | Proposed by | Authoritative layer |
|---|---|---|
| task interpretation | model | semantic state manager after validation |
| pattern selection | classifier/model | orchestration policy |
| tool request | model | capability policy |
| permission | none/model may request | deterministic policy |
| code change | implementer | working tree artifact |
| success | implementer may claim | validator |
| promotion | model may recommend | promotion gate |
| durable memory | model may propose | memory admission policy |
| user approval | none | user-bound approval record |

No duplicated authority.

---

# 36. Failure recovery model

Failures should be typed.

At minimum:

```text
TRANSIENT_PROVIDER_FAILURE
TOOL_FAILURE
INVALID_TOOL_OUTPUT
PERMISSION_DENIED
RESOURCE_EXHAUSTED
PLAN_INVALIDATED
EXECUTION_ERROR
TEST_FAILURE
SEMANTIC_MISMATCH
QUALITY_FAILURE
SECURITY_FAILURE
CONFLICT
NO_PROGRESS
```

Each type should have a recovery policy.

Example:

```text
TRANSIENT_PROVIDER_FAILURE
→ bounded retry
→ same-bar fallback
→ fail if still unavailable
```

```text
TEST_FAILURE
→ diagnose
→ bounded repair
→ revalidate
→ rollback/reject if exhausted
```

```text
SEMANTIC_MISMATCH
→ do not patch blindly
→ return to plan/spec alignment
```

---

# 37. Promotion model

Promotion should be a distinct transaction.

Required preconditions:

```text
implementation artifact exists
semantic specification exists
required validators passed
required evidence exists
risk policy satisfied
approval exists where needed
replacement cleanup satisfied
no blocking conflict
```

Promotion should atomically update the authoritative state or fail cleanly.

---

# 38. Pattern registry

Create a machine-readable registry of supported orchestration patterns.

Suggested entries:

```text
deterministic
single_agent_react
sequential
parallel
review_critique
iterative_refinement
coordinator
hierarchical
human_in_loop
custom
swarm
```

Each entry declares:

```text
selection criteria
required inputs
state transitions
maximum budgets
failure behavior
tool permissions
merge behavior
validation requirements
telemetry fields
```

This prevents pattern behavior from being scattered through prompts.

---

# 39. Evaluation framework

Agent_X should compare architectures empirically.

For each task class measure:

```text
completion rate
behavioral correctness
acceptance-test pass rate
regression rate
repair frequency
mean model calls
token cost
latency
tool-call count
fallback frequency
human intervention frequency
slop/complexity delta
```

Pattern escalation should require data.

Example:

> Do not introduce coordinator agents because a task "sounds complex." Introduce them when the single-agent route is measurably inadequate and the coordinator route measurably improves results enough to justify cost/complexity.

---

# 40. Acceptance tests for the architecture itself

The Google-pattern adoption is not complete until these system-level tests pass.

## A. Tiered routing

- A deterministic request never invokes an LLM.
- A low-complexity ambiguous request can be routed by the cheap classifier.
- A deep-reasoning task escalates correctly.
- Route choice is recorded.

## B. Same-bar fallback

- Primary and fallback outputs pass through the same validator.
- A bad fallback output is rejected.
- Fallback cannot bypass permission/evidence rules.

## C. ReAct

- A task can reason → act → observe across multiple steps.
- It terminates on completion.
- It terminates on max-step budget.
- Repeated no-progress behavior is detected.

## D. Sequential

- Known workflow order is enforced without unnecessary model orchestration.

## E. Parallel

- Independent checks run concurrently.
- dependent stages do not.
- merge handles missing/conflicting results.

## F. Review/critique

- Generator cannot mark itself accepted.
- reviewer can reject with structured criteria.
- failed critique routes to bounded repair.

## G. Context engineering

- irrelevant history is not injected by default.
- provenance survives context compression.
- lower-authority context cannot override runtime truth.

## H. Human approval

- approval is requested only where policy requires it.
- approval is bound to exact plan/action.
- material plan change invalidates prior approval.

## I. State durability

- process restart does not lose authoritative lifecycle state.

## J. Harvest

- inventory admission does not trigger implementation.
- pre-implementation value/fit checks occur.
- implementation is end-to-end.
- replacement removes obsolete implementation.

## K. Anti-slop

- placeholder-only implementation fails.
- duplicate architecture fails.
- unused new subsystem fails.
- feature with no reachable user path fails.

## L. Promotion

- failed validation prevents promotion.
- successful validated change promotes atomically.
- failed promotion preserves recoverable state.

---

# 41. Migration plan

The work should be implemented in this order to avoid adding another architecture beside the existing one.

## Phase 0 — Inventory the current architecture

Before coding:

- inspect current `main`;
- identify every current agent/role;
- identify current task state stores;
- identify current orchestration loops;
- identify current model-routing code;
- identify current tool registries;
- identify MCP implementation;
- identify Harvest lifecycle;
- identify validation/promotion logic;
- identify UI states;
- identify duplicated authority.

Output: a mapping from current components to the target architecture in this document.

Do not assume file names or modules from older Agent_X versions.

## Phase 1 — Establish one authoritative lifecycle

Implement or consolidate:

- canonical states;
- legal transitions;
- durable task record;
- transition API;
- blocking/failure states.

Remove competing lifecycle authorities.

## Phase 2 — Establish capability/tool policy

Create/consolidate:

- capability registry;
- permissions;
- risk classification;
- tool schemas;
- evidence/provenance outputs.

Route all tools through it.

## Phase 3 — Build pattern selection and tiered routing

Implement:

- deterministic routing;
- cheap classifier path;
- normal model path;
- deep reasoning escalation;
- telemetry.

## Phase 4 — Standardize model execution and fallback

Create one model-execution abstraction with:

- timeout;
- retries;
- fallback;
- unified post-generation validation;
- model telemetry.

## Phase 5 — Formalize ReAct and bounded loops

Unify existing loops around:

- next-action request;
- tool/action execution;
- observation;
- state update;
- termination check;
- budgets;
- no-progress detection.

## Phase 6 — Context engineering

Build/consolidate:

- context package builder;
- authority levels;
- provenance;
- retrieval;
- compression;
- context budgets.

Remove uncontrolled transcript accumulation.

## Phase 7 — Review/critique + validation framework

Unify validators.

Add explicit generator/critic separation where required.

## Phase 8 — Event-driven parallelism

Only after lifecycle and authority are stable:

- typed events;
- correlation IDs;
- safe parallel validators/retrieval;
- idempotency.

Do not event-ify everything.

## Phase 9 — Harvest integration

Refit Harvest to the common lifecycle:

- discovery/evidence;
- admission;
- pre-implementation gate;
- semantic delta;
- implementation;
- validation;
- promotion.

Remove Harvest-specific duplicate orchestration where common lifecycle machinery can replace it.

## Phase 10 — Human approval policy

Move approval decisions into risk policy.

Remove unnecessary approval steps and add missing high-risk approvals.

## Phase 11 — MCP externalization

Once internal capabilities are clean:

- normalize MCP client access;
- selectively expose safe internal capabilities as MCP server tools;
- apply authentication/authorization/rate limiting/auditing.

## Phase 12 — UI simplification

Map detailed internal states to a small set of user-facing states.

Hide internal agent topology by default.

## Phase 13 — De-agentification and cleanup

Search for:

- LLM calls now replaceable with deterministic routing;
- persistent agents now replaceable with prompt roles;
- duplicate state stores;
- old validators;
- old orchestration loops;
- obsolete Harvest paths;
- dead UI;
- duplicated adapters.

Delete them.

## Phase 14 — Evaluate whether any true multi-agent escalation is justified

Only now evaluate:

- coordinator;
- hierarchical decomposition;
- swarm.

Adopt none unless benchmarks justify them.

---

# 42. Required implementation artifacts

The final implementation should leave clear artifacts for:

```text
1. canonical lifecycle/state schema
2. orchestration/pattern registry
3. routing policy
4. model execution + fallback policy
5. capability/tool registry
6. permission/risk policy
7. context package schema
8. evidence schema
9. event schema
10. validation registry
11. memory admission policy
12. promotion gate
13. Human-in-the-loop approval record
14. Harvest integration contract
15. observability/trace schema
16. budgets/limits configuration
17. architecture acceptance tests
18. migration/compatibility tests
```

These may be implemented as code, schemas, configuration, or prompt contracts according to the prompt-driven/minimal-code rule. Do not create one file/service per concept unless technically warranted.

---

# 43. Rules for the implementation LLM

When this document is handed to a coding model, it must follow these rules:

1. Inspect the current `main` branch first.
2. Map the current architecture before proposing changes.
3. Reuse and consolidate existing mechanisms before adding new ones.
4. Do not blindly implement names or pseudo-components from this document.
5. Treat this document as semantic requirements, not a demanded file layout.
6. Prefer deletion/consolidation over parallel replacement systems.
7. Preserve existing behavior unless the specification explicitly requires replacement.
8. Keep hard guarantees outside prompts.
9. Keep semantic/reasoning behavior in prompts when code is not required.
10. Do not add Google ADK solely because the guidance came from Google.
11. Do not add a message bus unless real independent concurrency warrants it.
12. Do not add true multi-agent infrastructure unless evaluation proves it is needed.
13. Do not accept placeholder implementations.
14. Do not leave dead old paths after replacement.
15. Run applicable tests after each meaningful migration step.
16. Record evidence for each acceptance criterion.
17. Stop and reject rather than silently weakening a quality/security gate.
18. Fallback execution must pass the same validator as primary execution.
19. Every iterative loop must be bounded.
20. Promotion must remain separate from generation.

---

# 44. Definition of done

This initiative is complete only when all of the following are true:

- Agent_X has one authoritative execution lifecycle.
- Pattern selection is explicit and chooses the least-complex adequate architecture.
- deterministic work avoids unnecessary model calls.
- cheap routing occurs before expensive reasoning where appropriate.
- primary and fallback models share the same quality gates.
- ReAct-style dynamic work is bounded and evidence-driven.
- context is purpose-built rather than endlessly accumulated.
- semantic intent precedes implementation.
- plans are structured and revisable.
- tools are centrally registered and policy governed.
- MCP access is bounded and auditable.
- independent work can run concurrently without creating authority conflicts.
- review/critique is separate from generation where quality requires it.
- refinement/repair loops terminate deterministically.
- coordinator/hierarchical/swarm patterns are opt-in based on evidence.
- human approval is risk based.
- durable memory contains validated state rather than arbitrary model claims.
- an evidence ledger supports important decisions.
- validation is shared across primary/fallback/repair paths.
- Harvest uses the same governed lifecycle.
- replacement removes obsolete paths.
- UI hides unnecessary orchestration complexity.
- traces reconstruct what happened without depending on private model reasoning.
- budgets and resource limits are enforced.
- permissions use least privilege.
- promotion is an explicit gated transaction.
- architecture-level acceptance tests pass.
- duplicated old orchestration/state/validation mechanisms have been removed.
- measured behavior is at least as good as before the migration.
- complexity is lower or justified by measurable capability/reliability gains.

---

# 45. Final target architecture

```text
                        ┌──────────────────────┐
                        │      USER GOAL       │
                        └──────────┬───────────┘
                                   │
                         ┌─────────▼─────────┐
                         │ CLASSIFY + ROUTE  │
                         │ L0/L1/L2/L3 tier  │
                         └─────────┬─────────┘
                                   │
                     ┌─────────────▼─────────────┐
                     │     CONTEXT ENGINEERING    │
                     │ provenance + authority     │
                     └─────────────┬─────────────┘
                                   │
                     ┌─────────────▼─────────────┐
                     │  SEMANTIC SPECIFICATION   │
                     └─────────────┬─────────────┘
                                   │
                     ┌─────────────▼─────────────┐
                     │ PLAN / DECOMPOSE / SELECT │
                     │     SIMPLEST PATTERN       │
                     └─────────────┬─────────────┘
                                   │
                     ┌─────────────▼─────────────┐
                     │ POLICY / VALUE / RISK /   │
                     │ ARCHITECTURE / PERMISSION │
                     └─────────────┬─────────────┘
                                   │
                           ┌───────▼───────┐
                           │   EXECUTION   │
                           │ ReAct / Seq / │
                           │ Parallel/etc. │
                           └───────┬───────┘
                                   │
              ┌────────────────────▼─────────────────────┐
              │       GOVERNED CAPABILITY / TOOL LAYER   │
              │ local | Git | MCP | sandbox | external  │
              └────────────────────┬─────────────────────┘
                                   │
                           ┌───────▼───────┐
                           │  OBSERVATION  │
                           │  + EVIDENCE   │
                           └───────┬───────┘
                                   │
              ┌────────────────────▼─────────────────────┐
              │     UNIFIED VALIDATION + CRITIQUE        │
              │ primary/fallback/repair same quality bar │
              └────────────────────┬─────────────────────┘
                                   │
                      ┌────────────▼────────────┐
                      │ PASS?                   │
                      └──────┬───────────┬──────┘
                             │ yes       │ no
                    ┌────────▼──────┐  ┌─▼────────────────┐
                    │   PROMOTION   │  │ BOUNDED REPAIR / │
                    │ transaction   │  │ REPLAN / ROLLBACK│
                    └────────┬──────┘  └──────────────────┘
                             │
                    ┌────────▼────────┐
                    │ AUTHORITATIVE   │
                    │ UPDATED STATE   │
                    └─────────────────┘
```

This is the architecture Agent_X should converge on.

The strongest lesson from Google's guidance is not that Agent_X needs more agents. It is that Agent_X needs **clearer pattern selection, bounded autonomy, shared validation, deliberate context, governed tools, evidence, and a simple authoritative lifecycle**.

If implemented correctly, the result should be **less architectural duplication, fewer unnecessary model calls, fewer autonomous components, stronger recovery, clearer authority, lower cost, and better reliability** than a conventional "many agents talking to each other" design.
