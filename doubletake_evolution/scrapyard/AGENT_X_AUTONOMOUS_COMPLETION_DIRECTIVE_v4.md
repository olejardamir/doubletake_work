# Agent_X Autonomous Completion Directive v4

## Intended Use

This file is the master goal, operating contract, and loop-control document for long-running coding-agent development.

Use it with a prompt like:

```text
Our final goal is defined in:
<absolute-path-to-this-file>

Do the next immediate step toward achieving that goal.

You must:
- read the directive
- inspect the repository
- determine the earliest incomplete phase
- choose the smallest executable step that advances that phase
- implement it
- add tests
- run relevant validation
- write evidence into the repository
- update loop state
- continue to the next immediate step

Do not drift into product demos.
Do not make fake progress.
Do not ask for clarification unless the task is genuinely impossible, unsafe, or blocked by missing credentials or unavailable files.
```

This file is designed specifically for a very long autonomous coding loop.

It is not only a product vision. It is also a work-selection algorithm, phase-gate definition, anti-drift policy, evidence contract, recovery guide, and operational safety rule set.

---

# 0. Prime Directive

Agent_X must become a universal governed development system for agentic AI.

More precisely:

```text
Agent_X is a governed self-transforming seed system for building,
transforming, connecting, validating, and evolving agents and agent orchestrators.
```

Agent_X must eventually be able to:

1. take its own source code or an existing agent codebase
2. copy or instantiate itself into a target directory
3. understand a mission
4. gather and organize the information needed for that mission
5. inspect existing tools, prompts, imports, dependencies, memory, tests, runtime assumptions, and agent structure
6. identify missing capabilities
7. decide whether the target should be a single agent or multi-agent orchestrator
8. build missing tools, adapters, schemas, tests, and runtime components
9. modify codebases, imports, dependencies, technologies, and orchestration structure when needed
10. connect multiple agents together
11. validate the result
12. produce machine-checkable evidence
13. promote or reject the evolved system through executable gates
14. operate with little to no human intervention once automated gates are strong enough

Agent_X is not a coding UI.

Agent_X is not merely a code-writing agent.

Agent_X is a governed development and transformation layer for agentic AI systems.

---

# 1. What Agent_X Is Not

Agent_X is not:

- a scraper project
- a coding UI
- a chatbot
- a Hermes fork
- an OpenClaw clone
- a LangGraph wrapper
- a single-agent runtime
- a prompt collection
- a documentation-only governance framework
- a narrow standalone-agent generator
- a product proof by itself

Specialized agents are outputs.

Agent_X is the seed, control plane, transformation system, validation system, evidence system, and promotion system.

---

# 2. Non-Negotiable Product Thesis

All development must preserve this thesis:

```text
Agent_X can instantiate or inspect an agentic codebase, understand a mission,
identify what must change, transform the system through governed actions,
validate the result, produce evidence, and promote or reject the evolved agentic system.
```

If a change does not move Agent_X closer to this thesis, do not do it.

---

# 3. Full Completion Definition

Agent_X is complete only when it can repeatedly perform this full loop through executable code:

```text
mission received
↓
target workspace selected
↓
Agent_X instantiated or existing agentic codebase inspected
↓
mission parsed and validated
↓
context gathered
↓
current agentic system inventoried
↓
capability gaps identified
↓
transformation plan created
↓
missing tools/adapters built
↓
agents connected if needed
↓
tests generated and run
↓
policy enforced
↓
evidence produced
↓
validation gates passed
↓
promotion accepted or rejected
↓
rollback available
```

Completion requires this to work across multiple scenarios, not only one demo.

A hand-built demo does not prove Agent_X.

A report without executable validation does not prove Agent_X.

A compile-only target does not prove Agent_X.

A product proof is valid only if Agent_X machinery generated or transformed it through policy, evidence, validation, and promotion gates.

---

# 4. Required Full-Goal Proofs

Minimum full-goal acceptance requires all of the following proofs.

## 4.1 Control enforcement proof

Expected behavior:

```text
allowed workspace change passes
protected core change is blocked
evidence is logged
exact verdict is produced
promotion behaves correctly
```

## 4.2 Self-instantiation proof

Expected behavior:

```text
Agent_X instantiates into a target directory
mission is loaded and validated
instance manifest is created
unsafe mission is rejected
safe mission is accepted for planning
evidence is produced
```

## 4.3 Existing-agent inventory proof

Expected behavior:

```text
Agent_X scans a dummy existing agent codebase
detects entrypoint, tools, prompts, direct LLM calls, dependencies, tests, and unsafe imports
produces machine-readable agent manifest
invalid target fails clearly
```

## 4.4 Capability-gap proof

Expected behavior:

```text
Agent_X compares mission requirements against existing capabilities
identifies missing tools, adapters, tests, evidence, and risks
produces capability graph and gap report
```

## 4.5 Transformation-planning proof

Expected behavior:

```text
Agent_X produces a structured transformation plan
plan includes files to change, imports/dependencies to change, tools to build, tests, evidence, and rollback plan
malformed plan fails validation
```

## 4.6 Permissioned-implementation proof

Expected behavior:

```text
Agent_X applies an allowed change only through a proposal and permissioned adapter
denied change is blocked
evidence and validation results are recorded
rollback metadata is produced
```

## 4.7 Multi-agent interoperability proof

Expected behavior:

```text
Agent_X scans two dummy agents
creates manifests
creates a handoff contract
builds a minimal orchestrator
runs integration test
produces evidence
```

## 4.8 Technology-migration proof

Expected behavior:

```text
Agent_X detects direct provider import or unsafe dependency
proposes a governed replacement
changes imports or adapter structure
validates behavior
records evidence and rollback metadata
```

## 4.9 Product-proof portfolio

Expected behavior:

```text
at least three different product proof classes exist
each proof is generated or transformed through Agent_X machinery
each proof has tests, evidence, README, config, run instructions, and limitations
```

Possible proof classes:

```text
web data extraction agent
document intake agent
research/reporting agent
email/ticket triage agent
QA/test-generation agent
company workflow orchestrator
multi-agent coding orchestrator
```

## 4.10 No-fake-progress proof

Expected behavior:

```text
scorecard and reports cannot count NOT_ACCEPTED as accepted
compile-only targets are not accepted
echo-only targets are not accepted
stale reports are rejected
source/report/scorecard mapping is checked
```

---

# 5. Development Phases

The coding agent must classify the repository into the earliest incomplete phase and work there.

```text
PHASE_0_PRODUCT_THESIS_AND_CONTRACT
PHASE_1_EXECUTABLE_CONTROL
PHASE_2_SELF_INSTANTIATION_AND_MISSION_INTAKE
PHASE_3_AGENTIC_SYSTEM_INVENTORY
PHASE_4_CAPABILITY_GRAPH_AND_GAP_ANALYSIS
PHASE_5_TRANSFORMATION_PLANNER
PHASE_6_PERMISSIONED_IMPLEMENTATION_AND_TOOL_BUILDING
PHASE_7_MULTI_AGENT_INTEROPERABILITY
PHASE_8_VALIDATION_EVIDENCE_PROMOTION_ROLLBACK
PHASE_9_PRODUCT_PROOF_PORTFOLIO
PHASE_10_AUTONOMOUS_LONG_RUN_HARDENING
```

Do not skip phases.

Do not build product proofs before the substrate exists.

Do not build a scraper first.

---

# 6. Phase Exit Criteria

A phase is not complete because files were created.

A phase is complete only when its exit criteria pass through tests or executable validation.

## PHASE_0_PRODUCT_THESIS_AND_CONTRACT

Exit criteria:

- product thesis file exists
- protected core manifest exists
- policy schema exists
- FIC schema exists
- mission schema exists
- agent manifest schema exists
- handoff schema exists
- current reality audit exists
- loop state files exist
- all schemas have validation tests
- valid examples pass
- malformed examples fail

## PHASE_1_EXECUTABLE_CONTROL

Exit criteria:

- policy registry loads valid policies
- malformed policies are rejected
- protected path decisions are enforced
- allowed workspace action passes
- denied protected action fails
- denied action does not modify target
- evidence ledger records decisions
- exact verdict parser exists
- `NOT_ACCEPTED` is not accepted
- Makefile or CLI proof target exists
- proof target runs real behavior, not only compile or echo

## PHASE_2_SELF_INSTANTIATION_AND_MISSION_INTAKE

Exit criteria:

- `agentx instantiate` or equivalent CLI exists
- target workspace is created
- instance manifest is created
- source snapshot or parent commit is recorded
- mission file is validated
- unsafe mission is rejected
- allowed mission is accepted for planning
- evidence is recorded
- no local absolute path dependency is introduced

## PHASE_3_AGENTIC_SYSTEM_INVENTORY

Exit criteria:

- scanner handles deterministic dummy agent repo
- detects entrypoint
- detects tools
- detects prompts or prompt-like files
- detects direct provider imports
- detects dependencies
- detects tests
- detects missing evidence
- produces agent manifest
- invalid target fails clearly

## PHASE_4_CAPABILITY_GRAPH_AND_GAP_ANALYSIS

Exit criteria:

- mission requirements are parsed
- existing capabilities are extracted from manifest
- missing capabilities are identified
- tools/adapters/tests/evidence needs are listed
- risks are listed
- capability graph and gap report are produced
- deterministic fixture test exists

## PHASE_5_TRANSFORMATION_PLANNER

Exit criteria:

- transformation plan schema exists
- plan includes files to create/modify
- plan includes imports/dependencies to change
- plan includes tools/adapters to build
- plan includes tests and evidence
- plan includes policy risks
- plan includes rollback plan
- malformed/incomplete plans fail validation

## PHASE_6_PERMISSIONED_IMPLEMENTATION_AND_TOOL_BUILDING

Exit criteria:

- proposal bundle format exists
- permissioned file adapter exists
- permissioned command adapter exists or is explicitly denied until implemented
- allowed patch is applied through adapter
- denied patch is blocked
- denied patch does not modify file
- tool-building requires schema, tests, policy, and evidence
- rollback metadata is generated

## PHASE_7_MULTI_AGENT_INTEROPERABILITY

Exit criteria:

- agent handoff schema exists and is validated
- two dummy agents are inventoried
- handoff contract is generated
- minimal orchestrator is built
- integration test passes
- failure path is tested
- evidence is recorded

## PHASE_8_VALIDATION_EVIDENCE_PROMOTION_ROLLBACK

Exit criteria:

- validation runner executes policy, schema, tests, evidence checks, and verdict checks
- promotion gate accepts only validated proposal
- promotion gate rejects missing evidence
- promotion gate rejects protected path violation
- rollback metadata is created
- stale report is rejected
- source/report mapping is checked

## PHASE_9_PRODUCT_PROOF_PORTFOLIO

Exit criteria:

- at least three different product proof classes exist
- each was generated or transformed through Agent_X machinery
- each has tests, evidence, README, config, and run instructions
- each passes standalone or orchestrated runtime proof
- each has clear limitations

## PHASE_10_AUTONOMOUS_LONG_RUN_HARDENING

Exit criteria:

- loop state persists across runs
- blocked items are recorded
- no infinite documentation loops
- repeated runs choose earliest incomplete phase
- no fake progress is accepted
- fresh checkout proof passes
- local path independence proof passes
- no-human-review claim remains gated and honest

---

# 7. Next-Step Selection Algorithm

At the start of every iteration, the coding agent must do this:

```text
1. Read this directive.
2. Inspect repository tree.
3. Inspect git status.
4. Inspect existing loop state.
5. Inspect reports and scorecards.
6. Inspect available tests and Makefile/CLI targets.
7. Determine earliest incomplete phase using phase exit criteria.
8. Choose the smallest executable step that advances that phase.
9. Prefer a vertical slice over broad scaffolding.
10. Implement the step.
11. Add or update tests.
12. Run relevant tests.
13. Write evidence.
14. Update loop state.
15. Recommend the next step.
```

When choosing between possible steps, use this priority order:

```text
1. missing executable enforcement
2. missing schema validation
3. missing negative test
4. missing evidence
5. missing CLI/callable entrypoint
6. missing integration with existing proof system
7. missing documentation for already-implemented behavior
```

Do not choose broad documentation if executable work is possible.

---

# 8. Single-Step Scope Rule

Each iteration should usually complete one small vertical slice.

Allowed:

```text
one schema + validator + tests + evidence
one adapter + tests + evidence
one CLI command + tests + evidence
one proof target + verifier + evidence
one phase-gate status update backed by tests
```

Avoid:

```text
many unrelated modules
large directory reorganizations
broad refactors
product demos
rewriting strategy documents
adding many scaffolds with no behavior
```

If multiple files are necessary for one vertical slice, that is allowed.

If multiple unrelated goals appear, choose only the earliest foundational one.

---

# 9. Preflight Checklist for Every Iteration

Before modifying files, the coding agent must inspect:

```text
pwd
git status --short
repository tree at shallow depth
existing Makefile or task runner
pyproject.toml/setup.cfg/package files if present
tests directory if present
reports/agentx_autonomous_loop/ if present
existing schemas/configs if present
existing Agent_X CLI if present
```

If the repository is not clean, do not overwrite unrelated uncommitted user changes.

If a file exists, extend it carefully instead of replacing it blindly.

---

# 10. Autonomous Loop State

The coding agent must maintain persistent state.

Required directory:

```text
reports/agentx_autonomous_loop/
```

Required files:

```text
loop_state.json
iteration_log.jsonl
current_phase.json
current_reality_audit.json
evidence_index.json
blocked_items.json
phase_gate_status.json
run_summary.md
```

Suggested `loop_state.json`:

```json
{
  "current_phase": "PHASE_0_PRODUCT_THESIS_AND_CONTRACT",
  "phase_status": "PARTIAL",
  "last_completed_step": null,
  "next_recommended_step": "create protected-core manifest and validator",
  "blocked": false,
  "blocked_reason": null,
  "human_review_required": false,
  "last_verdict": "PARTIAL"
}
```

Suggested iteration log entry:

```json
{
  "iteration": 1,
  "phase": "PHASE_0_PRODUCT_THESIS_AND_CONTRACT",
  "selected_step": "create protected-core manifest schema",
  "reason": "executable governance requires a machine-readable protected core",
  "files_changed": [],
  "tests_added": [],
  "tests_run": [],
  "evidence_written": [],
  "verdict": "PARTIAL",
  "next_step": "implement protected path validator"
}
```

---

# 11. Recovery After Context Loss

Long coding loops may lose context.

If context is lost, the coding agent must recover by reading:

```text
this directive
reports/agentx_autonomous_loop/loop_state.json
reports/agentx_autonomous_loop/iteration_log.jsonl
reports/agentx_autonomous_loop/phase_gate_status.json
reports/agentx_autonomous_loop/run_summary.md
git status --short
recent reports
```

Do not restart from the beginning unless evidence is missing or invalid.

Do not redo already validated work.

Continue from the earliest incomplete phase.

---

# 12. Repetition and Stuck-Loop Rule

If the same step fails three times for the same reason:

1. stop attempting the same implementation path
2. record the repeated failure in `blocked_items.json`
3. choose a smaller fallback from the same phase
4. if no fallback exists, move to the nearest prerequisite missing from the same phase
5. do not mark the phase complete

If the coding agent notices it has created more than two documentation-only changes in a row, it must switch to executable work or write a blocker explaining why executable work is impossible.

---

# 13. Test Strategy

Use the smallest test scope that validates the current change.

Preferred order:

```text
targeted unit test for changed module
schema validation test
negative test for failure case
integration test for current vertical slice
phase proof target
broader test suite when relevant
```

Do not run unrelated expensive tests by default unless required by the phase gate or if the change touches shared infrastructure.

Do not claim success if relevant tests were not run.

If tests cannot be run, write why in evidence and mark verdict as `PARTIAL`, not `ACCEPTED`.

---

# 14. Evidence Requirements

Every iteration must write evidence.

Evidence should include:

- selected phase
- selected step
- reason for step
- files changed
- tests added
- tests run
- command outputs or summaries
- evidence files produced
- verdict
- next recommended step
- blockers
- known limitations

The coding agent must not rely only on chat output.

The repository must contain evidence.

Recommended evidence files:

```text
reports/agentx_autonomous_loop/iteration_log.jsonl
reports/agentx_autonomous_loop/evidence_index.json
reports/agentx_autonomous_loop/run_summary.md
reports/<module_or_phase_name>/final_verdict.json
```

---

# 15. Exact Verdict Rules

The exact accepted verdict is:

```text
ACCEPTED
```

These are not accepted:

```text
NOT_ACCEPTED
REJECTED
PARTIAL
ACCEPTED_WITH_WARNINGS
UNKNOWN
missing verdict
malformed verdict
```

Never count `NOT_ACCEPTED` as accepted because it contains the substring `ACCEPTED`.

Every verdict parser must test this explicitly.

---

# 16. What Counts as Real Progress

Real progress means executable capability increased.

Valid progress examples:

- a schema is created and validated by tests
- a malformed schema fixture fails
- a policy file is loaded and checked
- a protected path write is denied by code
- an allowed workspace write is allowed by code
- evidence ledger records a policy decision
- exact verdict parser treats `NOT_ACCEPTED` as not accepted
- mission file is parsed and validated
- unsafe mission is rejected
- dummy agent repo is scanned and an agent manifest is produced
- direct provider import is detected
- capability graph identifies missing tools
- two dummy agents are connected through a tested handoff contract
- generated tool includes schema, policy, tests, and evidence

Invalid progress examples:

- more architecture notes only
- empty scaffolds
- compile-only proof
- echo-only proof
- static report with no executable validation
- accepted verdict without tests
- changing scorecard logic to improve percentage
- deleting blockers instead of resolving them
- adding Hermes as runtime dependency
- building product demo before substrate
- production-readiness claim without proof
- no-human-review claim without gates

---

# 17. Protected Core Rules

The coding agent must treat these as protected:

```text
L0/
policies/
policy_registry/
promotion_gate/
scorecard logic
verifier logic
evidence ledger
final acceptance gates
secrets/
.env
deployment credentials
production settings
```

Protected files may be read.

Protected files may be changed only if:

1. the current phase explicitly requires it
2. policy allows it
3. the change is made through a proposal or controlled adapter once available
4. evidence records it
5. tests validate it
6. promotion gate accepts it

Before a policy engine exists, avoid protected changes except for creating the first minimal protected-core manifest, schemas, and validators.

---

# 18. Required Core Contracts

Implement these early.

## 18.1 Protected core manifest

Recommended files:

```text
configs/protected_core_manifest.yaml
schemas/protected_core_manifest.schema.json
tools/agentx_evolve/protected_core/
tests/test_protected_core_manifest.py
```

Required proof:

```text
valid manifest passes
malformed manifest fails
protected path is detected
allowed workspace path is not protected
```

## 18.2 Policy schema

Recommended files:

```text
schemas/policy.schema.json
tools/agentx_evolve/policy_registry/
tests/test_policy_registry.py
```

Required proof:

```text
valid policy loads
malformed policy fails
allowed action returns ALLOW
protected write returns DENY
decision includes reason
```

## 18.3 FIC schema

Recommended files:

```text
schemas/fic.schema.json
tools/agentx_evolve/fic/
tests/test_fic_schema.py
```

Required proof:

```text
valid FIC passes
malformed FIC fails
allowed paths are parsed
blocked paths are parsed
required artifacts are parsed
```

## 18.4 Mission schema

Recommended files:

```text
schemas/mission.schema.json
tools/agentx_evolve/mission/
tests/test_mission_schema.py
```

Required proof:

```text
valid mission passes
unsafe mission fails
missing goal fails
forbidden actions are parsed
required outputs are parsed
```

## 18.5 Agent manifest schema

Recommended files:

```text
schemas/agent_manifest.schema.json
tools/agentx_evolve/agent_inventory/
tests/test_agent_manifest_schema.py
```

Required proof:

```text
valid agent manifest passes
missing entrypoint fails
direct provider imports can be represented
tool list can be represented
```

## 18.6 Handoff schema

Recommended files:

```text
schemas/agent_handoff.schema.json
tools/agentx_evolve/agent_interop/
tests/test_agent_handoff_schema.py
```

Required proof:

```text
valid handoff passes
missing source agent fails
missing target agent fails
input/output contracts are represented
failure policy is represented
```

---

# 19. First Five Work Items

If the coding agent is unsure where to start, do these in order.

## Work Item 1: Loop state and reality audit

Create or update:

```text
reports/agentx_autonomous_loop/loop_state.json
reports/agentx_autonomous_loop/iteration_log.jsonl
reports/agentx_autonomous_loop/current_phase.json
reports/agentx_autonomous_loop/current_reality_audit.json
reports/agentx_autonomous_loop/phase_gate_status.json
reports/agentx_autonomous_loop/run_summary.md
```

Audit current modules as:

```text
executable
documentation_only
scaffold_only
compile_only
report_only
stale_report
accepted_with_real_proof
not_accepted
unknown
```

## Work Item 2: Protected core manifest and validator

Create:

```text
configs/protected_core_manifest.yaml
schemas/protected_core_manifest.schema.json
tools/agentx_evolve/protected_core/
tests/test_protected_core_manifest.py
```

Prove:

```text
valid manifest passes
malformed manifest fails
protected path is detected
allowed workspace path is not protected
```

## Work Item 3: Policy schema and policy registry

Create:

```text
schemas/policy.schema.json
tools/agentx_evolve/policy_registry/
tests/test_policy_registry.py
```

Prove:

```text
valid policy loads
malformed policy fails
allowed action returns ALLOW
protected write returns DENY
decision includes reason
```

## Work Item 4: Permissioned file adapter

Create:

```text
tools/agentx_evolve/permissioned_actions/file_adapter.py
tests/test_permissioned_file_adapter.py
```

Prove:

```text
allowed workspace write succeeds
protected L0 write is denied
denied write does not modify file
decision is logged
```

## Work Item 5: Evidence ledger and verdict parser

Create:

```text
tools/agentx_evolve/evidence_ledger/
tools/agentx_evolve/verdicts/
tests/test_evidence_ledger.py
tests/test_exact_verdict_parser.py
```

Prove:

```text
policy decisions are logged
ACCEPTED is accepted
NOT_ACCEPTED is not accepted
missing verdict fails
malformed verdict fails
```

After these, continue to:

```text
proposal bundle
validation runner
promotion gate
self-instantiation
mission schema
agent inventory
capability graph
transformation planner
multi-agent interop
product proofs
```

---

# 20. Hermes Usage

Hermes may be used only if it helps Agent_X reach the goal in this document.

Local Hermes paths:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent-self-evolution/
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/
```

Allowed Hermes uses:

- inspect architecture
- inspect skills format
- inspect progressive skill loading
- inspect session search patterns
- inspect subagent/delegation patterns
- inspect tool registry patterns
- inspect terminal/runtime abstraction
- inspect safety and approval patterns
- inspect trajectory/evidence ideas
- selectively copy MIT-compatible code only when justified

Forbidden Hermes uses:

- do not turn Agent_X into a Hermes fork
- do not import Hermes as Agent_X runtime dependency
- do not depend on local Hermes clone paths
- do not use Hermes provider routing as Agent_X’s LLM layer
- do not use Hermes model switching as Agent_X’s identity
- do not add Hermes gateway, desktop UI, voice/media, or unrelated features
- do not bring AGPL code into Agent_X core

Before copying any Hermes code, create an evidence note:

```text
reports/hermes_usage/hermes_usage_decision.json
```

It must include:

```json
{
  "used": true,
  "reason": "why Hermes was needed",
  "source_path": "Hermes source path",
  "source_commit": "commit if known",
  "license": "MIT or other",
  "copied_extent": "none | pattern only | small code excerpt | module",
  "destination": "Agent_X destination path",
  "path_independence_test": "test name or planned test",
  "llm_boundary_test": "test name or planned test"
}
```

Hermes may inspire Agent_X, but Agent_X must remain the controller, governance, validation, mission understanding, evidence, and promotion layer.

---

# 21. LLM Call Boundary

All LLM calls must be controlled by Agent_X.

Transformed or generated code must not directly call provider APIs unless explicitly allowed by policy.

Forbidden direct provider imports in Agent_X core or Hermes-derived modules include:

```text
openai
anthropic
cohere
mistral
groq
google.generativeai
hermes_cli.runtime_provider
Hermes model switching
Hermes auxiliary client
```

Approved path:

```text
generated/transformed component
↓
Agent_X-approved LLM adapter
↓
configured provider/model
```

Default foundational proofs should prefer deterministic fixtures over LLM-dependent behavior.

---

# 22. Agentic System Inventory Requirements

Agent_X must inspect existing agent codebases and produce a machine-readable inventory.

Inventory must detect:

- language
- framework
- package manager
- entry points
- agents
- tools
- prompts
- direct LLM calls
- model/provider imports
- memory/state
- dependencies
- unsafe imports
- tests
- runtime commands
- deployment assumptions
- missing evidence
- missing validation
- multi-agent boundaries if present

Recommended output:

```text
reports/agent_system_inventory/<target>/agent_manifest.json
```

---

# 23. Capability Graph Requirements

Agent_X must compare the mission against current capabilities.

It should produce:

```text
reports/capability_graph/capability_graph.json
reports/capability_graph/gap_analysis.json
```

The gap analysis must identify:

- existing capabilities
- missing capabilities
- tools to build
- adapters to build
- imports to change
- dependencies to add or remove
- tests to create
- evidence to produce
- risks to control

---

# 24. Transformation Planner Requirements

The transformation plan must include:

- mission summary
- current system summary
- target system summary
- files to create
- files to modify
- imports to change
- dependencies to add or remove
- tools to build
- adapters to build
- agents to connect
- tests to generate
- evidence to produce
- policy risks
- rollback plan

Recommended output:

```text
reports/transformation_plans/<plan_id>/transformation_plan.json
```

Malformed or incomplete plans must fail validation.

---

# 25. Permissioned Implementation Requirements

All implementation changes must go through a proposal bundle once the proposal system exists.

Recommended structure:

```text
proposal/
  proposal.json
  patch.diff
  changed_files.json
  risk_report.json
  evidence_plan.json
  validation_plan.json
  dependency_plan.json
  rollback_plan.json
```

Tool-building must include:

- tool schema
- tool policy
- tool tests
- tool evidence
- failure behavior
- security boundary
- documentation
- registration
- proof target

---

# 26. Multi-Agent Interoperability Requirements

Agent_X must eventually make different agents work together.

It must define:

- agent manifest
- agent role
- task input schema
- task output schema
- status schema
- error schema
- evidence schema
- handoff rules
- retry rules
- stop conditions
- memory boundaries
- tool permission boundaries
- orchestration logic

First proof:

```text
Input:
Two dummy agents:
- research_agent
- report_writer_agent

Expected:
Agent_X scans both.
Creates manifests.
Creates handoff contract.
Builds minimal orchestrator.
Runs integration test.
Produces evidence.
```

---

# 27. Technology Migration Requirements

Agent_X must be able to change technologies when needed.

Examples:

- replace direct OpenAI imports with Agent_X-approved LLM adapter
- replace JSON memory with SQLite memory
- wrap script as a tool
- convert script to CLI
- add FastAPI service wrapper
- add Docker packaging
- remove unsafe dependency
- add missing tests
- modify imports after moving modules
- connect custom agent to orchestrator

Any technology migration must include:

- reason
- risk
- files changed
- dependency changes
- tests
- evidence
- rollback plan

---

# 28. Scorecard and Report Integrity

The coding agent must not game progress.

It must not:

- delete unaccepted modules to improve score
- shrink denominator without explicit justified scope change
- mark modules accepted without executable proof
- create final verdicts without running real validation
- create reports with stale source commit
- claim production readiness without production gate
- claim no-human-review readiness without automated gates

Every counted module should map:

```text
source module
↓
proof target
↓
report directory
↓
final_verdict.json
↓
scorecard entry
```

Any exception must be explicit and justified.

---

# 29. No-Human-Review Goal

The long-term goal is little to no human intervention.

This means:

```text
human review is replaced by executable gates where possible
```

No-human-review operation is allowed only when:

- policy is machine-readable
- actions are permissioned
- tests are generated and run
- negative tests exist
- evidence is produced
- validation gates pass
- promotion gates enforce acceptance
- rollback metadata exists
- unsafe missions are rejected
- no protected boundary is violated

Until then, Agent_X should be described as moving toward no-human-review autonomy, not already achieving it.

---

# 30. Handling Failures and Blockers

If blocked, do not stop silently.

Write:

```text
reports/agentx_autonomous_loop/blocked_items.json
```

Blocker entry:

```json
{
  "blocked_step": "short name",
  "phase": "phase name",
  "reason": "why blocked",
  "needed_input": "what is missing",
  "safe_fallback": "what can be done instead",
  "severity": "low | medium | high"
}
```

Then choose a safe fallback from the same phase if possible.

If tests fail:

- do not hide the failure
- do not mark accepted
- record the failure
- fix if caused by current change
- if unrelated, record as existing failure

---

# 31. Repository Hygiene

The coding agent must:

- inspect before modifying
- avoid large unrelated refactors
- avoid changing formatting across many files unless needed
- avoid deleting files to improve score
- avoid overwriting human-authored strategy files unless explicitly required
- preserve existing working behavior
- keep changes small and testable
- prefer additive vertical slices
- record evidence for every meaningful change

If using git:

- inspect `git status`
- do not assume a clean tree
- do not overwrite uncommitted user changes
- do not commit unless the operating instructions explicitly allow commits

---

# 32. Product Proofs

Product proofs come after the core substrate.

Potential proof classes:

- public web data extraction agent
- document intake/extraction agent
- research/reporting agent
- email/ticket triage agent
- QA/test-generation agent
- internal knowledge agent
- compliance/audit agent
- company onboarding orchestrator
- multi-agent coding orchestrator
- workflow automation agent

A product proof is valid only if produced or transformed through Agent_X machinery.

A hand-built demo does not prove Agent_X.

---

# 33. Long-Run Anti-Drift Rules

During long autonomous runs, the coding agent must not:

- keep adding documentation without executable follow-through
- keep creating new phases
- keep creating empty modules
- endlessly reorganize directories
- jump to demos
- chase competitor parity features
- import large external systems unnecessarily
- make progress by scorecard manipulation
- hide uncertainty
- mark partial work as done
- make production/no-human-review claims prematurely
- modify this directive unless explicitly instructed by the user

When in doubt:

```text
choose earliest incomplete phase
choose smallest executable step
add test
add evidence
update loop state
```

---

# 34. Standard Iteration Summary

Each iteration must end with an evidence entry containing:

```text
Phase:
Selected step:
Reason:
Files changed:
Tests added:
Tests run:
Result:
Evidence written:
Verdict:
Next recommended step:
Blocked items:
```

The authoritative summary should be written to:

```text
reports/agentx_autonomous_loop/iteration_log.jsonl
```

Chat output is not enough.

---

# 35. Long-Run Checkpoint Rule

Every five iterations, or when a phase may be complete, update:

```text
reports/agentx_autonomous_loop/phase_gate_status.json
reports/agentx_autonomous_loop/run_summary.md
```

The status must include:

```json
{
  "phase": "PHASE_1_EXECUTABLE_CONTROL",
  "exit_criteria": [
    {
      "criterion": "malformed policies are rejected",
      "status": "PASS",
      "evidence": "tests/test_policy_registry.py::test_malformed_policy_rejected"
    }
  ],
  "phase_verdict": "PARTIAL"
}
```

A phase can be marked complete only if all exit criteria have evidence.

---

# 36. Dependency and License Discipline

Before adding a new dependency, the coding agent must record:

```text
why it is needed
whether the standard library can do it
license
runtime impact
test impact
whether it is required for core or only optional
```

Do not add large frameworks to solve small problems.

Do not add a dependency only because Hermes uses it.

Do not add AGPL or unclear-license code to Agent_X core.

---

# 37. Final Instruction to Coding Agent

Do not optimize for looking done.

Optimize for becoming real.

A small executable control loop with honest evidence is better than a large set of documents, scaffolds, or fake accepted reports.

Agent_X must become the system that can say by code:

```text
allowed
denied
unsafe
incomplete
validated
accepted
rejected
promoted
rolled back
```

If unsure what to do next, follow this one-sentence rule:

```text
Find the earliest incomplete phase in this file, choose the smallest executable step that advances it, implement that step with tests and evidence, update loop state, and do not move to product proofs until the control, instantiation, inventory, planning, and validation substrate exists.
```
