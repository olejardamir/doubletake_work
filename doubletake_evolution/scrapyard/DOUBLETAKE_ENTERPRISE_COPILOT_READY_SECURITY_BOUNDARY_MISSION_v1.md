# DoubleTake Enterprise Copilot-Ready Security Boundary Mission
## v1 — Pre-Copilot, mock-backed enterprise hardening

### PURPOSE

Prepare current DoubleTake for a future corporate deployment where the only approved AI environment is:

- Visual Studio Code
- GitHub Copilot running through Visual Studio Code

Do **not** integrate GitHub Copilot yet.

The goal of this mission is to make DoubleTake structurally ready for that future integration by creating a restricted enterprise distribution, a generic coding-agent boundary, and a mock coding-agent backend that can prove the architecture without any external AI provider.

The normal/full DoubleTake must remain intact.

The enterprise build must be produced from an **allowlist**, not by installing full DoubleTake and toggling features off.

---

# PRIMARY INVARIANT

Make this true in executable code and tests:

> A DoubleTake enterprise artifact can supervise a coding-agent session without containing or reaching Codex, OpenCode, Claude, generic LLM APIs, remote embeddings, VPN/network manipulation, arbitrary MCP servers, web/browser access, remote knowledge ingestion, autonomous self-evolution, or unrestricted background execution.

The future Copilot integration must fit behind one generic coding-agent contract.

For this mission, that contract is exercised only with a deterministic local mock backend.

---

# AUTHORITY

1. Treat the current checked-out `main` branch as authoritative.
2. Reinspect the real repository before changing anything.
3. Do not rely on this document for file names that no longer exist.
4. Preserve existing behavior outside the new enterprise boundary.
5. Do not weaken existing governance, security, evidence, capability-participation, meta-reasoning, rollback, or verification behavior.
6. Do not delete full-version features merely because the enterprise artifact excludes them.
7. Do not introduce a second orchestration/control plane.

---

# NON-GOALS

Do NOT do any of the following in this mission:

- integrate GitHub Copilot;
- implement VS Code Agent Host Protocol/AHP;
- create a VS Code extension;
- connect to GitHub;
- add external APIs;
- add an external LLM;
- add remote embeddings;
- add new MCP servers;
- browse the web;
- add VPN logic;
- redesign DoubleTake;
- remove Codex/OpenCode/etc. from the normal/full build;
- rewrite working governance systems;
- create a parallel enterprise fork with copied business logic;
- enable self-evolution in the enterprise artifact.

The enterprise artifact is a restricted packaging/runtime profile of the same governed DoubleTake core.

---

# TARGET ARCHITECTURE

The target after this mission is:

```text
User
  |
  v
DoubleTake governed core
  |
  +-- capability selection
  +-- meta reasoning
  +-- task decomposition
  +-- context governance
  +-- evidence / verification
  +-- bounded local state
  +-- workspace security
  |
  v
Canonical CodingAgent contract
  |
  v
MockCodingAgent
```

Later, outside this mission:

```text
Canonical CodingAgent contract
  |
  v
CopilotAgentAdapter
  |
  v
VS Code Agent Host / AHP
  |
  v
GitHub Copilot
```

No Copilot-specific assumption may leak upward into the DoubleTake control plane.

---

# WORKSTREAM A — CREATE THE CANONICAL CODING-AGENT CONTRACT

Create one small provider-neutral contract for coding-agent execution.

Use existing DoubleTake abstractions if a suitable canonical abstraction already exists. Extend rather than duplicate.

The contract must support the minimum concepts required by DoubleTake:

```text
start session
resume session
send task
send continuation / repair instruction
request status
cancel
observe structured events
observe changed files / changeset metadata
observe terminal/test outcome metadata
obtain final result
```

The contract must not assume:

```text
OpenCode REST
Codex SDK
OpenAI chat completion
Claude Code
AHP
MCP
shell scraping
terminal-screen scraping
```

Use typed models where the repository normally uses typed models.

At minimum define normalized concepts equivalent to:

```text
CodingAgentSessionRef
CodingAgentTask
CodingAgentEvent
CodingAgentChange
CodingAgentCommandResult
CodingAgentResult
CodingAgentStatus
CodingAgentAdapter
```

Do not add fields with no current consumer.

The control plane must depend on the canonical contract, not on a concrete backend.

---

# WORKSTREAM B — IMPLEMENT A DETERMINISTIC MOCK CODING AGENT

Implement `MockCodingAgent` or the repository-equivalent name.

It must require no model, network, API key, daemon, browser, MCP server, or external service.

It must support deterministic scenarios needed for tests:

1. successful task;
2. failed task;
3. task requiring repair;
4. cancellation;
5. timeout/stall representation;
6. changed-file reporting;
7. command/test-result reporting;
8. malformed/invalid backend result;
9. backend unavailable;
10. resume of a durable session if the canonical contract supports resume.

The mock must not fake success automatically.

Tests must be able to declare expected outputs and then verify that DoubleTake responds correctly.

Example conceptual fixture:

```python
MockCodingAgent(
    scripted_events=[...],
    result=...,
)
```

Do not put enterprise intelligence inside the mock.

---

# WORKSTREAM C — ENTERPRISE DISTRIBUTION AS AN ALLOWLIST

Create an enterprise packaging profile/manifest whose semantic purpose is:

```text
doubletake-enterprise-copilot-ready
```

The exact naming may follow existing packaging conventions.

The enterprise artifact must be assembled by explicit inclusion.

It must not mean:

```text
install everything
then set ENTERPRISE=true
```

It must mean:

```text
only approved modules are packaged
everything else is absent
```

Start from the smallest useful governed core.

Expected inclusion categories:

```text
governance core
policy enforcement
capability registry / routing
automatic capability participation support
meta reasoning needed for task supervision
task decomposition / run state
prompt/context governance
workspace/path-boundary enforcement
secret redaction
evidence integrity
verification
diff/result inspection
bounded rollback reasoning
local project/run state
canonical CodingAgent contract
MockCodingAgent
enterprise security policy
enterprise acceptance tests
enterprise package manifest
```

Do not mechanically include an entire directory if only a small subset is required.

---

# WORKSTREAM D — ENTERPRISE EXCLUSION SET

The enterprise package must not contain production-reachable implementations of the following classes of behavior.

## D1. Non-Copilot model/provider backends

Exclude:

```text
Codex runtime/provider
OpenCode runtime/provider
generic HTTP LLM providers
OpenAI-compatible chat providers
Claude Code backend
OpenAI/Anthropic direct product adapters
any provider capable of sending prompts directly to an external AI endpoint
```

Known current examples must be reinspected, including areas such as:

```text
tools/doubletake_evolve/providers/codex_provider.py
tools/doubletake_evolve/providers/opencode_provider.py
tools/doubletake_evolve/providers/api_provider.py
tools/doubletake_evolve/api/codex_chat.py
tools/doubletake_evolve/api/opencode_compat.py
tools/doubletake_evolve/enhanced_exploration/claude_code_backend.py
```

Do not delete these from the normal build.

The enterprise artifact must not import them and must not package them.

## D2. External embedding providers

Exclude production-reachable remote embedding implementations, including OpenAI-compatible remote embedding endpoints.

Deterministic/local semantic fallbacks may remain only if they require no network and are genuinely needed.

Do not silently convert a failed remote embedding call into an allowed network path.

## D3. VPN/network manipulation

Exclude all Proton/VPN switching, public-IP probing, NetworkManager mutation, VPN UI/control, and associated runtime integration.

The enterprise artifact must not know how to alter the host VPN configuration.

## D4. Remote corpus/API ingestion

Exclude production-reachable HTTP(S) remote knowledge-source adapters, external corpus fetching, external harvesting, and remote assimilation.

Local-file knowledge use may remain if policy-bounded.

## D5. Arbitrary MCP exposure

Exclude MCP servers and arbitrary MCP execution surfaces from enterprise v1.

Do not remove MCP support from normal DoubleTake.

## D6. Browser/web capability

Exclude browser control, web search/fetch, web research fixtures as production capabilities, and any browser-driven provider path.

## D7. Autonomous self-evolution

Enterprise v1 must not contain production-reachable mechanisms capable of modifying/evolving the installed DoubleTake executable itself.

Exclude from the enterprise runtime/package as needed:

```text
autonomous project self-evolution
self-regeneration
external harvest/mining
automatic assimilation of new external code
automatic promotion of newly generated DT implementation
self-update mechanisms
```

Do not damage these systems in the full build.

Enterprise DoubleTake may improve task execution but may not rewrite its own approved implementation.

## D8. Unnecessary background/daemon infrastructure

Do not package detached autonomous daemon behavior or autonomous background schedulers unless a specific enterprise runtime requirement proves they are necessary.

For v1, prefer invocation-bound execution.

---

# WORKSTREAM E — DEPENDENCY SEPARATION

The enterprise package must not install dependencies solely required by excluded providers.

Reinspect at least:

```text
pyproject.toml
requirements/runtime.txt
package.json
ui/package.json
```

The enterprise artifact must not require packages such as:

```text
openai-codex
@opencode-ai/plugin
```

unless an executable test demonstrates that the enterprise core itself genuinely requires them, which should normally be false.

Do not remove these dependencies from the normal/full distribution if the full distribution still requires them.

Implement separate enterprise dependency metadata if needed.

Produce a deterministic dependency manifest.

---

# WORKSTREAM F — NETWORK MUST FAIL CLOSED

Enterprise DoubleTake itself must have no general external network capability.

Create an enterprise network policy with a distinction between:

```text
EXTERNAL_NETWORK_EGRESS
LOCAL_APPROVED_AGENT_IPC
```

For this mission:

```text
EXTERNAL_NETWORK_EGRESS = DENY
LOCAL_APPROVED_AGENT_IPC = NOT YET IMPLEMENTED
```

The future AHP transport must eventually receive its own narrowly typed local IPC capability.

Do not set a generic `network_allowed=True` in preparation for Copilot.

Add executable negative tests showing that enterprise code cannot use:

```text
generic HTTP(S)
provider HTTP APIs
remote embeddings
remote knowledge ingestion
VPN/public-IP lookups
remote MCP
```

The test must exercise the real enterprise package/import surface, not merely inspect a config string.

---

# WORKSTREAM G — WORKSPACE FILESYSTEM BOUNDARY

Create or tighten an enterprise workspace policy.

Default enterprise rule:

```text
READ:
  active authorized workspace
  explicitly bounded DoubleTake runtime-state directory

WRITE:
  DoubleTake runtime-state directory

SOURCE WRITE:
  not directly required for this pre-Copilot mission

OUTSIDE AUTHORIZED WORKSPACE:
  deny
```

Do not grant broad filesystem access because the future Copilot agent may need it.

Add Windows-oriented path-security tests for at least:

```text
drive-letter case differences
.. traversal
absolute paths outside workspace
UNC paths
junction/reparse-point escape where testable
symlink escape where testable
case-insensitive collisions
mixed separators
workspace-prefix collisions
```

Use platform-conditional tests where appropriate.

Do not weaken existing Linux/path-boundary behavior.

---

# WORKSTREAM H — NO DIRECT ARBITRARY COMMAND EXECUTION IN ENTERPRISE V1

The enterprise package should not need an unrestricted subprocess launcher.

Preserve generic process-governance code in full DT.

For enterprise v1:

```text
arbitrary shell = unavailable
arbitrary PowerShell = unavailable
arbitrary CMD = unavailable
package installation = unavailable
git push = unavailable
```

If enterprise tests need a command-like result, use the mock coding-agent event/result contract.

Do not create shell wrappers to simulate Copilot.

Future approved Copilot/VS Code execution will be represented through CodingAgent events.

---

# WORKSTREAM I — CORPORATE-SAFE LOGGING

Enterprise builds must not support full raw prompt/response logging by an environment-variable toggle.

Reinspect current logging behavior.

Enterprise invariant:

```text
full prompt logging = unavailable
full response logging = unavailable
raw source-code transcript logging = unavailable by default
secrets = never persisted
```

Allowed metadata may include:

```text
run id
timestamps
operation type
backend id
content digest
content length
status
changed-file names if policy allows
verification result
duration
reason code
```

If existing code has a raw/full logging mode, leave it intact for normal DT but exclude or hard-disable it in the enterprise package.

Add a negative test proving an environment variable cannot enable full-content logging in the enterprise artifact.

---

# WORKSTREAM J — ENTERPRISE MEMORY POLICY

Create a strict enterprise memory profile.

Default:

```text
run-scoped memory            ALLOW
same-project bounded memory  OPTIONAL/ALLOW under policy
cross-project memory         DENY
global/personal memory       DENY
remote memory sync           DENY
cross-project propagation    DENY
restricted/secret content    DENY
```

Do not use external embeddings for enterprise memory.

Memory must remain under an explicitly configured local state root.

Add executable tests proving:

1. run memory stays inside the run/project boundary;
2. project A memory cannot be retrieved into project B;
3. restricted/secret-like content is not persisted unredacted;
4. enterprise memory has no remote transport;
5. enterprise packaging does not include global personal knowledge corpora by default.

---

# WORKSTREAM K — DO NOT SHIP DEVELOPMENT/RESEARCH CORPORA

The enterprise artifact must not include large development-only/research-only corpora merely because they are in the repository.

Review and exclude categories such as:

```text
knowledge/knowledge_corpus/
assimilation donor/reference material
MAIN_DOCS research/wishlist material
development-only proof fixtures
deliberately unsafe adversarial fixtures
historical implementation prompts
```

Keep only runtime documentation/tests/artifacts necessary for the enterprise package and its review.

Do not delete those resources from normal DoubleTake.

---

# WORKSTREAM L — ENTERPRISE SECURITY REVIEW BUNDLE

Create a deterministic command or build step that produces an enterprise review bundle.

The bundle must contain machine-readable artifacts for at least:

```text
source git commit
enterprise build/package digest
included-file manifest
excluded capability/provider summary
dependency manifest
provider inventory
network capability inventory
process/subprocess capability inventory
filesystem scope
memory policy
logging policy
self-modification status
security-test results
```

If practical using existing repository facilities, also emit an SBOM.

Do not fabricate claims.

If a property cannot be proved, report it as unknown/not-proven instead of PASS.

The review bundle must contain no secrets or raw proprietary prompt/source payloads.

---

# WORKSTREAM M — NEGATIVE ENTERPRISE ACCEPTANCE SUITE

Create a dedicated enterprise acceptance test suite.

It must prove at least the following:

```text
Codex provider import/use from enterprise artifact       -> unavailable/blocked
OpenCode provider import/use from enterprise artifact    -> unavailable/blocked
generic remote LLM provider                              -> unavailable/blocked
Claude backend                                           -> unavailable/blocked
remote embedding                                         -> unavailable/blocked
arbitrary HTTPS                                          -> blocked
remote corpus fetch                                      -> blocked
VPN operation                                            -> unavailable
remote MCP server/client capability                      -> unavailable/blocked
arbitrary subprocess                                     -> unavailable/blocked
source read outside authorized workspace                 -> blocked
runtime write outside allowed state root                 -> blocked
cross-project memory                                     -> blocked
full conversation logging via environment variable       -> impossible
self-evolution of enterprise installation                -> unavailable/blocked
```

Also prove positive behavior:

```text
enterprise package imports successfully
governed core starts
MockCodingAgent session works
task can be dispatched
events can be observed
failure can trigger bounded repair logic
verification can accept a valid result
verification can refuse an invalid result
cancellation propagates truthfully
enterprise review bundle can be produced
normal/full DT tests remain green
```

Negative tests must perturb the real mechanisms.

Do not satisfy them using tests that simply assert a constant string.

---

# WORKSTREAM N — ENTERPRISE PACKAGE INTEGRITY

The enterprise package must be self-describing.

At build time generate a package manifest containing:

```text
package name/version
source commit
file list
file digests where practical
dependency list
policy profile id
approved coding-agent adapters
network posture
self-modification posture
build timestamp if repository conventions permit it
```

Add a test that:

1. builds the enterprise package;
2. enumerates its files;
3. compares them against the allowlist;
4. fails on unexpected provider/network/self-evolution files.

A new source file added to full DT must **not** automatically enter the enterprise package.

---

# WORKSTREAM O — NORMAL DOUBLETAKE MUST REMAIN INTACT

Run regression tests for the full product.

The enterprise work must not silently break:

```text
Codex support in normal DT
OpenCode support in normal DT
normal provider abstractions
normal MCP behavior
normal self-evolution/research behavior
normal UI
normal packaging
existing security/governance tests
automatic capability participation
meta reasoning
```

If enterprise separation requires refactoring, preserve full-build adapters behind the canonical interfaces.

Do not make enterprise restrictions global.

---

# IMPLEMENTATION ORDER

Use this order unless repository evidence proves a different dependency order is necessary.

## Phase 1 — Inspect and map

1. inspect current `main`;
2. locate authoritative provider/runtime abstractions;
3. locate packaging system;
4. locate security policies;
5. locate memory policy;
6. locate logging/evidence paths;
7. locate self-evolution/assimilation entry points;
8. identify the smallest set of enterprise-needed modules;
9. record the implementation plan in the coding agent's working notes only.

Do not create broad documentation before code.

## Phase 2 — CodingAgent contract

1. reuse/extend a canonical existing abstraction if one exists;
2. introduce the normalized contract;
3. adapt no real external provider yet;
4. add deterministic unit tests.

## Phase 3 — Mock backend

1. implement deterministic mock;
2. test success/failure/repair/cancel/invalid-result paths;
3. prove higher-level DT logic can operate without Codex/OpenCode/API providers.

## Phase 4 — Enterprise package allowlist

1. create enterprise packaging profile;
2. include minimal governed core;
3. create enterprise dependency set;
4. build artifact;
5. inspect actual packaged files.

## Phase 5 — Enterprise restrictions

Implement and test:

```text
network deny
workspace scope
memory isolation
logging restrictions
no arbitrary subprocess
no self-modification
no external provider
```

## Phase 6 — Security review bundle

Generate review artifacts from measured package/runtime facts.

## Phase 7 — Full regression

Run:

```text
enterprise focused tests
enterprise package build
enterprise negative suite
relevant security/governance tests
full existing DoubleTake suite appropriate to the repository
```

Repair regressions caused by this mission.

---

# LOWER-CAPABILITY CODING MODEL RULES

Follow these rules strictly.

1. Do not guess when repository code can answer the question.
2. Inspect before editing.
3. Prefer small edits.
4. Do not duplicate an existing abstraction.
5. Do not rename unrelated systems.
6. Do not perform cosmetic cleanup.
7. Do not delete normal DoubleTake functionality.
8. Do not claim security because a config flag is set.
9. Do not claim absence because a code path was not exercised.
10. Do not add TODO-only stubs and mark the work complete.
11. Do not create mock tests that bypass production abstractions.
12. Do not weaken tests to make them pass.
13. Do not add Copilot integration.
14. Do not add web/network dependencies.
15. Do not add another orchestration loop.
16. Do not move intelligence into the mock adapter.
17. Do not use hard-coded file-name checks as the only security boundary.
18. Use repository-native patterns and naming.
19. Preserve fail-closed behavior.
20. Every security claim requires executable evidence.

---

# REQUIRED DESIGN PROPERTIES

The finished design must satisfy all of these.

### P1 — Full DT remains full
Normal DoubleTake retains its existing providers and capabilities.

### P2 — Enterprise is physically smaller
The enterprise artifact does not contain excluded provider/network/self-evolution implementations.

### P3 — Default deny
Unknown provider/tool/network/process requests fail closed.

### P4 — No provider credential ownership
Enterprise DT stores no Codex/OpenCode/OpenAI/Anthropic/Copilot credentials.

For this mission, it stores no external-model credentials at all.

### P5 — Provider neutrality above adapter boundary
Meta reasoning, capability routing, planning, evidence and verification do not depend on Copilot-specific concepts.

### P6 — Mock proves decoupling
A useful supervised task lifecycle works with only the mock coding agent.

### P7 — No external network
Enterprise DoubleTake performs no general network egress.

### P8 — Workspace isolation
Enterprise operations cannot escape the authorized workspace/state roots.

### P9 — Memory isolation
Cross-project knowledge leakage is blocked.

### P10 — No self-update
Enterprise installation cannot evolve or rewrite itself.

### P11 — Reviewable artifact
A reviewer can determine exactly what code and dependencies are present.

### P12 — Testable negative claims
Attempts to reach prohibited capabilities demonstrably fail.

---

# REQUIRED EVIDENCE

Before declaring completion, produce executable evidence for:

```text
E1  enterprise package builds from allowlist
E2  excluded provider modules are absent from package
E3  external-provider dependencies are absent from enterprise dependency set
E4  mock coding-agent lifecycle works
E5  higher-level orchestration works against mock
E6  generic external network request is denied
E7  remote embedding path is unavailable/denied
E8  remote knowledge ingestion is unavailable/denied
E9  VPN code is absent from enterprise package
E10 arbitrary subprocess is unavailable/denied
E11 path escape attempts fail
E12 Windows-relevant path cases are covered where runnable
E13 cross-project memory retrieval fails
E14 raw/full conversation logging cannot be enabled
E15 self-evolution entry points are absent/unavailable
E16 review bundle is generated from measured facts
E17 full DoubleTake regression suite remains healthy
```

Where the current execution platform cannot exercise a Windows-only behavior, add a deterministic unit-level proof for path normalization plus mark live Windows validation as pending. Do not fake a Windows live PASS on Linux.

---

# CONVERGENCE LOOP

Repeat until no justified mission delta remains:

1. Inspect current authoritative code.
2. Run focused tests for the area being changed.
3. Identify the single highest-value remaining violation of the enterprise invariant.
4. Trace the real production/package path.
5. Make the smallest general repair.
6. Add or strengthen executable evidence.
7. Run the focused tests.
8. Build the enterprise artifact.
9. Inspect its actual contents.
10. Run the enterprise negative suite.
11. Run affected full-DT regression tests.
12. Record only real unresolved blockers.
13. Repeat.

Do not reopen a solved area unless a regression or new evidence shows it is still broken.

---

# STOP CONDITION

Stop only when all are true:

```text
[ ] canonical CodingAgent contract exists
[ ] MockCodingAgent exercises it
[ ] useful governed task lifecycle works using the mock only
[ ] enterprise artifact is built from an allowlist
[ ] enterprise artifact excludes Codex
[ ] enterprise artifact excludes OpenCode
[ ] enterprise artifact excludes generic remote LLM providers
[ ] enterprise artifact excludes Claude backend
[ ] enterprise artifact excludes remote embeddings
[ ] enterprise artifact excludes VPN/network manipulation
[ ] enterprise artifact excludes remote corpus ingestion
[ ] enterprise artifact excludes arbitrary MCP servers
[ ] enterprise artifact excludes autonomous self-evolution
[ ] enterprise artifact excludes unnecessary daemon/background autonomy
[ ] enterprise dependencies exclude provider-only dependencies
[ ] enterprise network policy is fail-closed
[ ] enterprise workspace boundary is enforced
[ ] enterprise arbitrary subprocess execution is blocked/unavailable
[ ] enterprise raw/full conversation logging cannot be enabled
[ ] enterprise cross-project memory is blocked
[ ] enterprise review bundle is generated
[ ] enterprise negative acceptance suite passes
[ ] full DoubleTake behavior outside enterprise packaging has not regressed
[ ] no Copilot/AHP integration has been added
```

Then output exactly:

```text
DOUBLETAKE_ENTERPRISE_COPILOT_READY_BOUNDARY_COMPLETE
```

---

# FINAL REMINDER

The purpose of this mission is **not** to make DoubleTake corporate-approved.

Only the organization can approve it.

The purpose is to create a small, reviewable, fail-closed DoubleTake enterprise artifact whose only missing external integration is the future organization-approved VS Code/GitHub Copilot adapter.

The finished state should make this future change small:

```text
MockCodingAgent
      ↓ replace adapter only
CopilotAgentAdapter
      ↓
VS Code Agent Host / AHP
```

Everything above that adapter boundary should already be tested, governed, provider-neutral, and enterprise-restricted.
