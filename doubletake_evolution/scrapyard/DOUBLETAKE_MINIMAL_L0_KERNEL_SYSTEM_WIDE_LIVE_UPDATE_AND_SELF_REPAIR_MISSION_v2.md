# DOUBLETAKE_MINIMAL_L0_KERNEL_SYSTEM_WIDE_LIVE_UPDATE_AND_SELF_REPAIR_MISSION_v2

**Status:** Implementation mission; **NOT** a declaration that the functionality exists.  
**Supersedes:** `DOUBLETAKE_MINIMAL_L0_KERNEL_SYSTEM_WIDE_LIVE_UPDATE_AND_SELF_REPAIR_MISSION_v2.md`; this is the complete revised implementation specification, not a supplement.  
**Architectural authority:** `L0/README.md`, `L0/docs/EXTENSION_ABI.md`, `L0/manifests/SEED_INVARIANTS.yaml`, `L0/manifests/SEED_PACKAGE_MANIFEST.yaml` and the canonical seed proof suite. Do not treat this document as permission to weaken or replace them.  
**Repository:** `olejardamir/DT` — inspect the current authorized local checkout, `AGENTS.md`, `main`, active work, and live routes before touching code.  
**Recommended execution order:** Implement and verify `DOUBLETAKE_GENERAL_PURPOSE_AUTONOMOUS_MISSION_MANAGER_EVOLUTION_MISSION_v2_DIRECTORY_DISCOVERY.md` first; then execute this mission. If the manager has changed, discover the current active interface and integrate with that—not with an assumed v2 module name.  
**Scope:** **EVERY DoubleTake execution surface**, whether its behavior changes through ordinary engineering, an agent's patch, an operator edit, a Git update, a research-assisted improvement, an evolutionary mutation, a config/prompt update, or an external dependency update; **also system-wide fault containment, verified automatic recovery and governed code repair**.  
**Fundamental architecture:** **The existing L0 core IS the minimal kernel. There is no second kernel. Everything else is a governed extension, service, worker, agent or tool controlled through L0's canonical ports and the existing host-supervision boundary.**  
**Execution mode:** One bounded implementation campaign with incremental, independently evidenced work packages, not a fictional single all-at-once hot-reload.  
**Non-goals:** Rewriting DoubleTake as microservices; separating every Python directory into a `pyproject.toml`; inventing a second/"recovery"/"deployment" kernel; bloating L0 with AI diagnosis, worker implementations, networking, shell access, package installation, or repair code; running arbitrary changed source from a mutable checkout; bypassing governance; promising that CPython, browser bundles, database migrations, external providers, or a broken trust root can always update or self-repair in process.

---

## K. Binding constitutional architecture: ONE existing minimal L0 kernel, everything else governed by it

**This section has precedence over any ambiguous language elsewhere in this mission.** The user specifies a single, minimal DoubleTake core: **L0 is that core**, not one core alongside a newly invented recovery/activation kernel. Never create an independent "minimal recovery kernel", a rival supervisory brain, a new root approval authority, or an autonomous repair controller with powers outside L0.

### K.1 Verified repository baseline: do not confuse the seed with production wiring

- `L0/README.md` describes the **Governed Universal Seed Kernel** and its chain: `KernelService.run_turn` → `PlannerPort` → `GovernancePort` → `ToolGatewayPort` → memory/evaluation/trace/checkpoint ports.
- `L0/docs/EXTENSION_ABI.md` defines **one stable L0 turn entrypoint**: `core_kernel.public.kernel_service.KernelService.run_turn(request)`; external features attach **via composed/injected ports**, not imports into L0 core modules.
- `L0/manifests/SEED_INVARIANTS.yaml` forbids direct L0 shell/network/filesystem-write/self-modification/promotion/package-install/credential-access tool classes and requires governance before gateway effects. The seed must boot without an LLM, GPU, network, Docker, or secrets.
- `L0/docs/SEED_ACCEPTANCE.md` requires `make seed-boot`, `make prove-seed`, `make build-seed` and manifest closure checks.
- Repository also contains large, historically grown API/Borg/collective/session runtimes. **Their existence does not prove that production traffic currently passes through L0.** W00 must prove or disprove actual `/api/chat`, CLI, MCP, background and agent ingress → L0 admission/governance → injected-port execution. If production is not yet wired this way, treat that as an architectural gap; integrate through adapters without pretending otherwise and without casually breaking existing production flows.

### K.2 What belongs in L0, and what emphatically does not

**L0 owns the minimal, durable trust and control contract, not the implementation of every controlled action:** stable bootstrap identity; public turn/intent interface; policy and governance-before-effect ordering; approved extension/port invocation; minimal health/error and capability state needed to decide admit, isolate, delegate, resume, or deny; references to durable evidence/checkpoints; and a **small, deterministic fault-response decision contract** (not an AI fixer). These are responsibilities, not a demand for a new L0 subsystem. Implement them using existing L0 ports/interfaces, reusing external implementations wherever possible.

**Outside L0, invoked under L0-controlled authorization through existing ports and host supervision:** Autonomous Mission Manager; Borg planners and agents; evolution; research and knowledge pipelines; dynamic capability execution; HTTP/MCP/CLI adaptors; process supervisors and launchers; runtime freshness and release coordinators; health collectors; fault analyzers; test runners; rollback and repair executors; model clients; UI; stores and index builders. Such services may have domain-local control loops but **must not have independent final authority to violate L0 admission/effect governance**.

**No forbidden L0 imports or side effects:** The seed must never directly import extension implementation code, spawn arbitrary subprocesses, open sockets, install packages, mutate production code, or write unrestricted files. A process launcher/supervisor can exist outside `L0/CODE`, but is **mechanical host infrastructure**, not a second policy kernel; all actions with effects require the established gate and explicit authority. L0 cannot repair its own executable instructions while dead; a previously trusted, minimal launcher may boot a retained known-good L0 image, with no ability to issue new unauthorized policy decisions.

**Minimum-size requirement:** Before changing any L0 source, report baseline and target L0 file count, source lines, dependency/import surface, public API/ABI, boot dependencies, and proof coverage. Prefer **zero new L0 files** and **zero new privileged L0 interfaces**. Every change must show why an existing port and an external delegated component could not achieve it. Any additional L0 code must be less risky than the verified missing function, stay deterministic, and pass the unmodified seed invariants. No wholesale migration of large Borg/collective modules into L0.

### K.3 The correct control flow

```text
                    User / agents / API / CLI / MCP / background events
                                        |
                   Existing public adapters (external to L0, preserved)
                                        |
              SINGLE L0 KERNEL: KernelService.run_turn() / composed ports
                     |               |                  |
             policy/governance   bounded dispatch   evidence/checkpoints
                     +---------------+------------------+
                                        |
                         existing approved ToolGatewayPort
                                        |
          +-----------------------------+-------------------------------+
          |                             |                               |
   Mission Manager / Borg      Version activation services      Repair/recovery services
   research / evolution        agents / tools / UI / API        diagnostics / patches
          |                             |                               |
          +----------- subordinate execution, never another kernel ----+
                                        |
                            independently observed outcomes
                                        |
                  L0-compatible evidence + bounded response decision
```

For a non-turn operational event such as worker death or frontend release, use a governed **port-level lifecycle/event adapter** through the established composition boundary. Do not fabricate a second public L0 turn entrypoint or inject fake user chat to authorize maintenance. W00 must verify how actual lifecycle events meet the L0 contract; if not yet wired, report and implement a minimal adapter outside L0 compatible with `EXTENSION_ABI.md`.

### K.4 Core resilience is architectural, not magical

The requirement “the core can fix errors so DT keeps running” means **L0 guarantees orderly fault containment and governed recovery delegation** to the maximum technically achievable extent. L0 detects/receives trusted failures, classifies whether an operation can safely continue, isolates the affected executable release, selects a verified recovery strategy, records state, and dispatches a delegated repair task if safe. The external repair worker diagnoses, proposes patches, tests and validates them; existing authorities approve; the deployment mechanism activates a verified fix; L0 sees the observed result. **Unaffected services must keep running.** An irrecoverable L0 binary, destroyed trust store, unavailable host, invalid authorization, or unsupported state downgrade is reported honestly and safely stopped or recovered from an existing verified snapshot—not wished away.

---

## 0. Binding mission statement — read this first

**Implement DoubleTake-wide version-aware execution, live activation and bounded self-repair, governed by the existing minimal L0 kernel.** When anything that can change DoubleTake's behavior is changed, new work must use the **latest compatible, tested, approved, and activated implementation**. Existing in-flight work must retain a coherent version until a verified handoff, drain, restart, or rollback. A change must never appear active merely because a source file, registry row, prompt, or Git commit has changed. A newly approved version must not remain silently stale behind Python import caches, long-running workers, copied workspace config, backend processes, browser assets, or external agent sessions.

**This is not an evolution-only feature and not a capability-only feature, nor is it an additional kernel.** All human-authored changes, automated maintenance, ordinary feature development, model/provider selection changes, task prompts, agent policies, routing, research, reasoning, mission management, MCP tools, frontend changes, and future kinds of work use the same activation truth contract where they can affect executable behavior.

Activation means **operational reachability**, not merely deploying bytes. A successful activation is evidenced by invoking the normal relevant public surface after promotion and proving that it executed the newly approved version. If no safe live activation exists, choose a scoped, coordinated restart or an explicit `PENDING_RESTART`/`BLOCKED` state. Do not lie, silently use stale code, or trade away state safety to meet a zero-restart slogan.

**Stable request:** `execute this authorized operation under the current compatible active implementation`. The caller must not hard-code a particular current three-phase evolutionary policy, named research implementation, manager revision, or backend generation. Dynamic strategy succession, when authorized, stays governed by its existing owner.

**Target user-visible result:** The operator can update and verify DoubleTake without manually determining which modules, workers, instances, sessions, or frontend clients are stale. When errors emerge from any change or operation, the existing L0-controlled system isolates the fault, keeps safe unaffected operations usable, and attempts bounded, evidence-based recovery/repair instead of stalling the entire platform. A single status surface tells what changed, which approved versions are active where, what remains stale or requires restart, and whether real new work actually executed the updated implementation.

### 0.1 Precise meanings

- **Changed**: content, dependencies, configuration, schema, code, route, model/profile selection, prompt/policy, asset, or executable package differs by a verifiable fingerprint. `mtime`, Git HEAD and filenames alone are insufficient.
- **Approved**: the existing relevant authority has validated the exact content/dependency closure and authorized its effects. The deployment subsystem may verify approvals; it must not mint substitute approvals.
- **Promoted**: the authoritative version selection changed under that owner's existing gates. Promotion is **not** automatically activation.
- **Activated**: new matching work is routed to the approved implementation and operational execution has been observed and attributed.
- **Latest**: newest *approved, compatible, activation-eligible* version, not the newest untested file edit. Expose a newer `CANDIDATE` distinctly from `ACTIVE`.
- **Freshness**: for the specific request/worker/client, the loaded and executed version matches its contractually selected active version; where not possible, show an explicit lag state.
- **Continuous availability**: preserve useful service whenever safe, using per-component fresh worker processes and rolling transitions. It does **not** mean every kind of change is restart-free.
- **Everything**: an extensible inventory of every production-reachable behavior-changing surface, including future components; this does not mean mechanically launching every documentation file or treating data sources as executable code.

### 0.2 Mandatory distinction between two change categories

1. **Ordinary work**: user asks DoubleTake to perform research, write code, analyze files, run tools, manage campaigns, answer a question, or use a capability. Such work must resolve the currently active version and execute correctly even if no evolution happens.
2. **Changing DoubleTake**: a person, agent, tool, updater, or evolutionary system alters code, configuration, model selection, prompt, workflow, dependency, worker or UI. This requires verification, authorization, compatible activation, and observable effect. Research facts and task artifacts are **not** self-authorizing executable changes.

Both use the same version/freshness contract, but only category 2 triggers release/activation transitions. Ordinary work cannot accidentally authorize self-modification.

---

## 1. Mandatory repository audit — do not build until gaps are measured

The following existing paths and semantics were observed in repository review on October 17, 2026. They are **leads to revalidate at execution time**, not a guarantee that the files or behavior are unchanged. Read their actual implementations, tests, callers and live API surfaces. Produce `reports/runtime_freshness/W00_CURRENT_STATE.json` with source digests, observed entrypoints, measured existing behavior and a gap matrix.

| Existing surface | Inspected path / public entry | Reuse / known issue to measure |
|---|---|---|
| **The one L0 minimal core** | `L0/README.md`, `L0/CODE/core_kernel/public/kernel_service.py`, `L0/docs/EXTENSION_ABI.md`, `L0/manifests/SEED_INVARIANTS.yaml`, `L0/CODE/kernel_composition/` | **Binding architecture; verify which production ingresses truly reach L0.** Never fork it or add external imports/direct shell/network powers to L0. Maintain seed proofs. |
| Existing service/host supervision and repair signals | `run-instance.sh`, `api/health.py`, `session_runtime/runtime.py`, `collective_core/adaptive_immune.py`, `regeneration.py`, `immune.py`, `runtime/host_crash_capture.py` (confirm at execution) | Reuse observed fault signaling/restart/repair, map gaps in evidence, isolate ordinary errors from broken trust root. No second recovery control plane. |
| Canonical capability contracts and authority | `tools/doubletake_evolve/collective_core/capability_contract/` | Respect its approvals, fidelity, schemas and routability; never create parallel capability authorization |
| Capability routing and execution | `collective_core/capability_router.py`, `capability_execution.py` | Extend existing bound execution; do not invent competing route or effect gates |
| Bound callable resolver | `collective_core/capability_runtime.py` | `_LOADED[str(path)]` caches path-loaded Python modules; `importlib.import_module` caches dotted imports: measured freshness gap candidate |
| Synthesized tools | `collective_synthesized/tool_runtime.py`, `mcp_tools.manifest.json` | Manifest is digest-verified; tool call imports via Python process cache; published manifest alone does not demonstrate code refresh |
| Adopted tools | `collective_core/adoption.py`, `adopt_runner.py` | Existing sealed virtualenv/subprocess path; per-call runner refresh exists, but adoption into the generic bound resolver has a documented missing bridge |
| Borg capability fabric | `borg_capability_fabric/registry.py`, `execution.py` | Registry and execution gates; revalidation before use already exists; don't fork lifecycle or manifest authority |
| Governed changes | `workflow_governance/orchestrator.py`, `runtime_adapter_enforcement/` | Preserve existing effects, approvals, checkpoint, rollback and isolation gates |
| Evolutionary policy succession | `collective_innovation/evolution_policy.py`, `phase_policy.py` | Canonical current-policy record and fail-closed resolver exist. Never hard-code `OUTWARD/INWARD/GROUNDING` in shared activation logic |
| Research | `universal_research/`, `research_source_evolution/` | Research is another consumer/producer of versions, not a special update system |
| Agents and sessions | `session_runtime/runtime.py`, `resume.py`, `worktrees/manager.py` | Detached subprocesses, checkpoints, supervised restoration; reissue is not identical to reviving a process and needs exact dedupe/version semantics |
| User-facing chat | `api/chat_sse/chat_route.py`, `api/chat_sse/event_stream.py` | Preserve current request boundary, session IDs, SSE progress, explicit evolution and research; add version status without hijacking ordinary prompts |
| API restart | `api/health.py`, `run-instance.sh`, `scripts/run-ui.sh` | An existing graceful-restart barrier and supervised relaunch exist. Reuse, verify drain limits and avoid restart loops |
| UI client | `ui/src`, `ui/src/api/client.js`, `ui/package.json`, Vite/Vitest/Playwright | Dev HMR is not proof that production browsers run the newest bundle; measure served build and client epoch |
| Resource containment | `runtime/host_workload.py`, `AGENTS.md` | Respect currently declared CPU/memory/task caps and host guard for all experiments and spawned workers |
| Process and command state | `run_manager.py`, `runtime/durable_command_log.py`, `unified_runtime/store.py` | Preserve durable state and per-run identity; reuse proven stores only with exact semantics |
| Unified runtime | `unified_runtime/worker.py`, `coordinator.py`, `rollout_binding.py` | As inspected, worker/coordinator were stubs: **not** evidence of already-live activation; don't declare them production owners without hard proof |
| Autonomous Mission Manager | Discover current actual implementation after AMM completion | Manager is a client of this shared contract; do not create manager-only hot reload or break its durable campaign state |
| External agents/providers/MCP | Active OpenCode/Codex/Copilot/LLM service adapters and MCP transports found by audit | Some may not support hot swap or be controlled by DT; measure contracts and report truthful limitations |

**L0 mandatory audit first:** (a) run/inspect the canonical seed proof unmodified; (b) trace at least one actual normal production API and CLI request to `KernelService.run_turn` or prove the integration gap with negative evidence; (c) measure how existing supervisors relay faults without bypassing L0 governance; (d) classify what recovery lives inside versus outside L0; (e) identify external loops or direct execution paths that still require integration. Do not claim existing `L0/` is already production-wired just because it passes its seed tests.

**Locate missing inventory from execution, not guessing:** Trace calls reachable from supported CLI commands, public HTTP routes, MCP endpoints, background jobs, agent/session launchers, Vite build, workflow engine, user-defined adapters, active AI/model configurations and registered extensions. Enumerate every interpreter/worker boundary and every operation that reads changed code or config. Existing file names are not permission to assume they are called.

Mandatory W00 baseline questions:

1. Can an already-running DT API call newly changed Python source without restart? Test ordinary imports, file-loaded bound capabilities, synthesized tools, native services, and adoption subprocesses separately.
2. Which updates are already immediately visible (e.g., owner-controlled policy records), which appear only on the next task, which require worker restart, and which require full API/UI restart?
3. Which workers, agent sessions, MCP servers and model gateways have their own code/config lifetime? Who owns the process and permissions?
4. What are the real activation, rollback, state compatibility, schema and retention mechanisms, including which paths already atomically persist state?
5. Which external provider processes or browser clients DT cannot forcibly update? Identify a truthful handoff mechanism.
6. Can users see a stale version while the system claims a newer one? Show a reproducible baseline case.
7. Where can mutable checkout files be loaded during active writes or Git changes? Can running calls mix different commits/dependency sets?
8. Do the current bound-resolver and synthesized-tool code hashes actually correspond to executed bytes after an update? Show before/after and a negative control.

**Deliver W00:** A machine-readable inventory of source-to-runtime consumers; categorized actual/future/unsupported; live test results; a map of owners; prior verified fixes to preserve; newly justified integration points; the smallest defensible changes. No speculative whole-repository refactor.

---

## 2. Architecture: one activation truth, not a replacement for existing owners

### 2.1 Separation of authorities

**There is one superior L0 admission/effect boundary; existing specialized authorities remain authoritative *within their delegated domains*:**

- Security, user consent, effect permissions, write isolation, capability eligibility and approval remain under their existing owners.
- Evolutionary policy selection and promotion remain under the canonical active-policy state; the universal runtime must not choose or promote evolutionary policies itself.
- Borg/collective and Autonomous Mission Manager remain responsible for *what* work is valuable and how to coordinate it; they do not own code-version activation.
- Existing source assimilation and research decide relevance/provenance; they do not grant execution permission.
- The activation layer owns **only deployment eligibility, version binding, process/client freshness, change propagation, and observed activation receipts**, consuming owner-issued authorization/evidence.
- The **existing L0 kernel is the only trusted foundational core**. Neither activation, recovery, mission management, Borg, nor evolution becomes an alternative kernel or can authorize effects not admitted through L0's governance/ToolGatewayPort contract.
- A minimal external process supervisor may keep the L0 process running; it does not gain permission to change policy, select new arbitrary code, or generate patches. L0 recovery uses bounded declarative decisions and external workers, never an unrestricted repair executor embedded in the seed.

Use one thin shared runtime-freshness interface. If the audit identifies an existing actual production owner for one of these behaviors, **extend it instead of adding another state machine**. A small adapter package such as `tools/doubletake_evolve/runtime_activation/` is permissible **only for demonstrably missing cross-surface glue and schema**. It must not duplicate the `CapabilityAuthority`, `RolloutGate`, governed-effect gateway, process supervisor or evolutionary policy ledger.

### 2.2 End-to-end flow

```text
User/agent/API/CLI/operational event
     |
     v
ONE existing L0 kernel: admitted action, governance, port invocation
     |
     v
Human/agent/code tool/Git/promoted evolution/config or UI change
     |
     v
Observed change with exact content + dependency provenance
     |
     v
Classify impact and owning authority; build immutable candidate
     |
     v
Existing validation, security, compatibility, experiments, approvals
     |
     v
Existing authoritative promotion / release eligibility
     |
     v
Runtime freshness layer selects safe activation plan
     |              |                 |                  |
  live data     fresh isolated    worker drain/     coordinated scoped
  refresh       invocation        replacement        service restart
     |              |                 |                  |
     +--------------+-----------------+------------------+
                            |
                  new requests bind version
                            |
              actual-path execution attestation
                            |
               observe errors and regressions
                            |
                 isolate affected component
                            |
            safe last-good rollback / degraded service
                            |
             governed external diagnosis and repair
                            |
               verify / activate / observe outcome
```

**Invariant:** no `PROMOTED` label can be substituted for evidence of `ACTIVE`, and no `ACTIVE` claim can be made without a real execution path using the selected approved version. Passive config may have a stronger *read/apply* proof rather than running a capability, but must still prove the effective consumer state.

### 2.3 Declarative evolvable/updateable unit

Represent an executable or behavior-changing unit through a common **version/compatibility descriptor**. Do not mandate one physical Python package per unit. Shape (names indicative; reuse existing types where possible):

```json
{
  "unit_id": "stable.logical.identifier",
  "unit_kind": "python-module|worker|service|agent|prompt|policy|config|routing|knowledge-index|model-profile|tool|mcp|api|frontend|schema|dependency|other",
  "owner": "existing.authority.identifier",
  "source_identity": {"repository":"...","revision":"...","paths":["..."]},
  "artifact_digest": "sha256:...",
  "dependency_closure_digest": "sha256:...",
  "interface_contract_digest": "sha256:...",
  "state_schema_version": "...",
  "runtime_environment_digest": "sha256:...",
  "required_permissions": ["..."],
  "activation_class": "LIVE_DATA|FRESH_PROCESS|REPLACE_WORKER|SCOPED_RESTART|CLIENT_REFRESH|EXTERNAL_HANDOFF|NON_ACTIVATABLE",
  "provenance_refs": ["..."],
  "approval_evidence_refs": ["..."],
  "compatibility_evidence_refs": ["..."],
  "rollback_target": "...",
  "retention_policy": "..."
}
```

Rules:

- Identities are stable logical IDs; **versions are content-addressed** and bind transitive runtime dependencies, interpreter/venv, installed package hashes where relevant, script entrypoints and config affecting behavior—not merely a Git SHA.
- Include source version *and* evaluated runtime environment. Different hosts may execute identical source under different interpreters/configs; state the difference.
- Capture generated artifacts, models (identity only; **do not download**), scripts, templates, prompt files, MCP definitions, JS bundles and schema migrations where executable behavior depends on them.
- Document-only changes with no runtime impact are `NO_ACTIVATION_NEEDED`, not fake deployments. Research observations/data changes use data/index refresh only if an actual runtime consumer depends on them.
- Unknown dynamically generated code, opaque plugins, non-Python code, external processes and future extension formats cannot be silently treated as safe Python reloads. Require an adapter or explicit unsupported result.
- Content and dependency state must be captured in an immutable, atomic release location or equivalent pinned immutable object. Reading a shared mutable `.py` while an agent writes it is forbidden for deployment.

### 2.4 Atomic version binding and request consistency

At an execution boundary, atomically resolve `unit_id + compatible active revision + authority state` to one immutable snapshot or release pointer, then establish a **version lease** for the invocation. Do not change it mid-call. A composed multi-unit task binds either a compatible release set or an explicit version compatibility matrix; it cannot accidentally mix old schema with new producers. An asynchronous background job, agent subtask, retry and SSE reconnect retain the same execution identity unless an independently authorized migration rebinds them.

**Freshness should be measured at invocation:** after promotion, a second invocation starts under the new version without restarting the entire platform if its adapter class supports that. A previously begun invocation finishes under its initial snapshot. Never implement a per-line/per-function live code switch.

### 2.5 Scope of activation methods

| Class | Appropriate for | Preconditions | Not allowed |
|---|---|---|---|
| `LIVE_DATA` | Versioned prompt, config, policy, routing table, knowledge index | Consumer re-reads authoritative immutable record and validates schema; per-request pin | Direct unsynchronized modification of shared mutable process state |
| `FRESH_PROCESS` | Isolatable Python tools, source-derived scripts, adoption runner, bounded compute | Immutable artifact, declared args/output, sandbox/effects governance, startup budget | Running an unapproved checkout path; arbitrarily pip-installing packages |
| `REPLACE_WORKER` | Long-lived research/agent/LLM wrapper/services | Existing supervisor, leases, health/readiness, graceful drain, compatibility | Killing in-flight work or double-applying effects |
| `SCOPED_RESTART` | Import-cached core modules or coordinated service changes | Drain/stop admission, checkpoint, existing launcher, health verification, fallback | Pretending `importlib.reload` gives atomic safety |
| `CLIENT_REFRESH` | Production frontend JS/CSS/assets | Build digest, browser update handshake, session preservation, asset cache strategy | Claiming the server can force every remote client's code to mutate in place |
| `EXTERNAL_HANDOFF` | Third-party/local provider, externally owned MCP/gateway or inaccessible agent process | Published owner capability/contract; explicit status, safe reconnect | Killing, modifying or hot-patching an external process without authority |
| `NON_ACTIVATABLE` | Unsupported/broken/incompatible update | Typed blocker, evidence and recoverable next step | Silent fallback marked `ACTIVE` |

Classification is per change and impact set. An apparently local library edit may require worker replacement or an API restart because transitively imported modules remain cached. A JSON record is not automatically safe for live reload if the consumer captured it in process state. Prove both.

---

## 3. Scope and runtime surfaces: no evolution-only shortcut

The final inventory and validation must cover, at minimum, all **currently reachable** instances of the following. A nonexistent subsystem is reported `NOT_PRESENT`; an existing but unwired class is `PRESENT_NOT_ACTIVE`. Neither may be reported `PASS` by testing a fixture-only implementation.

| Scope | Expected outcome when its behavior is approved and changed |
|---|---|
| CLI commands and entrypoints | Next authorized command uses active version; loaded old service process cannot silently override it |
| HTTP/FastAPI routes and middleware | Next request uses new active implementation or serves explicit update-pending state until supervised replacement |
| Chat SSE and session handling | Session-specific implementation binding, truthful progress, reconnect replay and no duplicate effects |
| MCP servers and tool catalogs | Registry version, tool schema and invoked code correspond; stale clients negotiate/reconnect explicitly |
| Synthesized Python tools | New invocation executes newest approved content, not `_LOADED` or `sys.modules` stale copy |
| Adopted tools and venvs | Existing isolated bridge reused; exact sealed package/runner digest and runtime version verified |
| Native capabilities and collective services | Service methods cannot masquerade as fresh when held in already-imported Python objects |
| Borg agents, drone methods, dispatchers | Newly dispatched work uses compatible active handler/strategy; running work stays pinned |
| Autonomous Mission Manager and campaigns | New campaign steps see new approved manager; in-flight campaign resumes with compatible durable state |
| Reasoning/research/knowledge/assimilation | Updated algorithms, catalogs, retrievers, parsers and policy are reflected at next eligible execution |
| Evolutionary policy and mechanisms | Current promoted owner policy is resolved dynamically, including successor strategies, without hard-coded phases |
| Prompt/skill/workflow manifests | Changed approved documents are re-resolved with identity/version, without loading untrusted command as authority |
| Config and model/provider selection | Changed approved connection/profile is observed; external sessions replaced only under contract |
| External plugins/adapters | Honest executable artifact binding or explicit handoff limitation |
| Job runners/watchdogs/background tasks | New tasks use new image; no lost, duplicated or unbounded tasks during replacement |
| Database/state/schema | Migration executed under governance, backward/forward compatibility and rollback safeguards |
| UI and web assets | Dev hot update and production build/client refresh treated separately; no false current-client claim |
| Shell launchers/system services | Existing supervisory process reads new launch scripts only on new launch; versioned replacement or restart plan where needed |
| Shared libraries and dependencies | Transitive consumer invalidation/migration, not just the directly edited filename |
| Experimental/new future units | Self-describing adapter contract; missing adapter is explicit rather than quietly untracked |

Do not try to rewrite every repository module in this mission. Build a **coverage inventory**, classify real activation behavior by category, implement the common activation seam and prove representative end-to-end instances of **each real lifecycle class**, then close uncovered critical live paths or declare precise blockers. Breadth is measured by reached consumers and correctness, not by sheer number of refactored files.

---

## 4. Required state machine and invariants

### 4.1 State vocabulary

At minimum expose distinguishable states (existing names may be reused):

`DISCOVERED`, `CANDIDATE`, `VALIDATING`, `VALIDATED`, `AWAITING_AUTHORIZATION`, `APPROVED`, `PROMOTED_NOT_ACTIVE`, `ACTIVATING`, `ACTIVE`, `PARTIALLY_ACTIVE`, `PENDING_DRAIN`, `PENDING_RESTART`, `PENDING_CLIENT_REFRESH`, `BLOCKED`, `FAILED`, `ROLLBACK_PENDING`, `ROLLED_BACK`, `SUPERSEDED`, `RETIRED`, `NO_ACTIVATION_NEEDED`.

A single global status cannot mask a mixed deployment. Track per unit, version, service instance, agent/worker and client cohort where known. `PARTIALLY_ACTIVE` must include exactly where the old version remains and why. Do not assert simultaneous global atomicity over disconnected machines or browser tabs.

### 4.2 Write path

`capture artifact` → `validate` → `owner authorizes` → `prepare immutable release` → `preflight compatibility + impact` → `atomic promotion reference` → `activate safely` → `run observed consumer probes` → `mark effective` → `monitor` → `retain/rollback`.

All effectful transitions are journaled with idempotency and compare-and-swap or an existing equivalent owner lock. A failure in the activation journal must not be swallowed if it is the source of authority; a best-effort diagnostic log must not be mistaken for authoritative persisted state.

### 4.3 Required event fields

```json
{
  "event_id":"...", "operation_id":"...", "unit_id":"...",
  "from_version":"sha256:...", "to_version":"sha256:...",
  "source_revision":"...", "dependency_closure_digest":"sha256:...",
  "owner_approval_ref":"...", "activation_class":"...",
  "deployment_scope":["..."], "compatible_release_set_digest":"sha256:...",
  "preflight_verdict":"...", "effect_receipts":["..."],
  "runtime_instances":[{"id":"...","reported_version":"...","observed_version":"..."}],
  "consumer_proof_refs":["..."], "state_migration_ref":"...",
  "recovery_pointer":"...", "rollback_ref":"...", "status":"...",
  "previous_event_digest":"...", "record_digest":"sha256:..."
}
```

Never store secrets, raw prompt contents, personally identifying user payloads, private provider responses or confidential paths in public evidence. Public reports use sanitized IDs, digests and approved test fixtures.

### 4.4 Non-negotiable invariants

- **I01**: Promotion never bypasses the existing owner's authorization.
- **I02**: A caller binds exactly one executable version/release set for its transaction.
- **I03**: No invocation imports mutable, partially written, unvalidated code as active.
- **I04**: All activation claims reference actual consuming-process evidence; file presence is insufficient.
- **I05**: Cache/memory values cannot contradict the chosen active contract without a visible stale/refusal state.
- **I06**: A transient failure or process crash cannot make an effect execute twice without existing effect-aware idempotency/compensation.
- **I07**: State migrations are explicit and independently tested; code rollback is not presented as data rollback.
- **I08**: Restricted/untrusted changes cannot become runnable through a hot-update backdoor.
- **I09**: A broken update must leave a known-good compatible release available, or fail closed with truthful service unavailability.
- **I10**: Existing security controls, locks, budgets, approvals, runtime adapter enforcement, policy successors and resource limits remain effective.
- **I11**: Cross-host/client mixed versions are honestly visible and bounded by contracts.
- **I12**: An old session may be pinned to an old release; a **new** compatible request must not silently reuse stale code after activation.
- **I13**: Updating this activation system itself is covered by a minimal trusted bootstrap and existing supervisor, with no recursive dependency on a new version to activate that same new version.
- **I14**: No busy-loop/watchdog thrashing, unbounded process spawning, uncontrolled package downloads, or global restart storms.
- **I15**: **Exactly one existing L0 kernel**—no new recovery kernel, policy kernel, deployment kernel, runtime kernel, second public L0 turn entrypoint, or duplicate privileged root authority.
- **I16**: L0's current extension ABI, governed phase order, seed tool restrictions, boot independence and canonical proof suite remain intact at all times; other systems run only via authorized port composition and existing subordinate infrastructure.
- **I17**: A failure in one replaceable component cannot terminate, corrupt or block independent compatible components unless shared-state safety requires explicit containment; degraded operation is truthful.
- **I18**: Repair workers cannot authorize their own patches, disable guards, edit kernel trust roots, alter source evidence, or promote self-repairs without independent verification.
- **I19**: A failing component can be isolated and rolled back without forcing an unrelated subsystem's restart when compatibility permits; repair budgets, retry limits and quarantines prevent loops.
- **I20**: A failure of L0 itself cannot rely on the failed L0 implementation to recover. The existing external launcher may restore an immutable last-known-good L0 under a fixed, pre-authorized mechanical rule; no claims of arbitrary zero-downtime or autonomous patching of an unusable trust root.
- **I21**: An error cannot be silently suppressed as success or used to bypass policy. Known-unsafe effects are refused; unknown outcomes are reconciled before retrying.
- **I22**: Repair follows measured reproduction → hypothesis → bounded candidate → existing governance → independent validation → safe activation → post-activation observation → retain/revert. Repeated no-gain repairs lead to defer/escalate, not busy-looping.

---

## 5. Work packages W00–W23: exactly what to implement, where, how, and definition of done

**Execution rule for every W package (including W17–W23):** Inspect current code first. Record the baseline, smallest justified diff, owning paths, regression/negative tests, an actual-path proof, and result to `reports/runtime_freshness/`. Do not mark completed on mock-only tests, documentation, proposed API names, or an agent's narrative.

### W00 — Audit all live ingress-to-consumer lifetimes

**Where:** **Start with** `L0/README.md`, `L0/docs/EXTENSION_ABI.md`, `L0/manifests/`, `L0/CODE/core_kernel/`, the seed proof suite; then `tools/doubletake_evolve/{api,runtime,collective_core,collective_innovation,session_runtime,unified_runtime,...}`, `ui/`, `scripts/`, `run-instance.sh`; enumerate actual current code.  
**How:** Prove actual existing L0 participation rather than assume it; run the canonical seed proofs, map production entrypoints to L0 or document missing edges, inventory error handling and trusted supervisor behavior. Static reachability inventory + active-process/manual probe tracing; classify all surfaces in §3; measure stale-module behavior in running process; record existing authority and restart owners. Run resource-guarded focused tests only, with no source changes in W00.  
**Done when:** `W00_CURRENT_STATE.json` contains measured **kernel-versus-extension ownership**, L0 seed proof evidence, production L0 integration proof or precise missing-edge gaps, crash-handling and repair-control inventory, actual tested code-path matrix, call chains, current HEAD and source digests, gaps, prior functionality and explicit `NOT_PRESENT`/`PRESENT_NOT_ACTIVE` statuses. Failing baseline reproduction includes Python import caching and one web/API or agent lifetime case. **No implementation before W00 is complete.**

### W01 — Common contract and change-impact graph

**Where:** Extend existing authority metadata or add a narrowly scoped `tools/doubletake_evolve/runtime_activation/models.py` and `impact.py` as pure adapters; no duplicate owner registry.  
**How:** Build updateable-unit descriptors for code, config, prompt, agent, service, UI, schema, external plugin; content/dependency closure digest, version/compatibility constraints, consumer relationships, release set, permissions and runtime class. Derive graph from actual imports, manifest bindings, routing and registered consumers; use explicit declared edges for dynamic imports. Mark unknown edges, don't guess full closure. Include Python import aliases (`tools.doubletake_evolve` versus `doubletake_evolve`).  
**Done when:** Change to shared dependency identifies every known affected active consumer; unknown edge causes preflight refusal or conservative restart. Inert documentation change gives `NO_ACTIVATION_NEEDED`. Fingerprinting detects same-path changed bytes and different-dependency same-source changes; false positives bounded/measured.

### W02 — Immutable artifact capture and reproducible release identity

**Where:** Reuse existing artifacts/staging/rollback/worktree machinery; if necessary new `runtime_activation/releases.py` strictly for immutable snapshots and digest checking.  
**How:** Stage exact approved bytes/dependencies in content-addressed, non-editable release folders or equivalent immutable objects, use atomic fsync + rename/pointer update, verify source digest before and after capture, reject symlink escapes and path races, record interpreter/venv version, lockfile/dependency integrity, UI asset identity. Never execute directly from shared mutable `main`; developer edits stay candidates until validated. Provide garbage collection aware of leases, rollback targets and coexisting versions.  
**Done when:** Mid-write mutation, Git HEAD change, symlink swap, data corruption, missing dependency and manifest tamper are detected. Running v1 retains v1 bytes while v2 is created, and at least one new invocation uses immutable v2 without a whole-system restart.

### W03 — Activation authority adapter and state persistence

**Where:** Connect existing `CapabilityAuthority`, `collective_innovation/evolution_policy.py`, Borg manifests, governed workflow and (only where applicable) `unified_runtime/store.py` to one thin activation view; new `runtime_activation/authority.py`, `store.py` only if missing.  
**How:** Check exact owner-issued approval + source/dependency hash + deployability, maintain atomic release pointer per unit or compatible set, durable transitions and idempotency, detect concurrent promoters and stale references, provide fail-closed verification. Do not force all underlying owners to adopt a new authority.  
**Done when:** Fake approval, mismatched digest, expired/incompatible permission, swapped candidate, split-brain pointers, duplicate request, interrupted promotion and stale lease are rejected or recovered. Current three-phase policy still resolves via its own owner and successor policy works unmodified.

### W04 — Runtime resolver: bind the effective version at invocation

**Where:** `collective_core/capability_runtime.py`, `capability_execution.py`, `collective_synthesized/tool_runtime.py`, actual `api`/MCP/CLI call edges; add common `runtime_activation/resolve.py` if needed.  
**How:** Bind request to approved exact immutable artifact/environment and return typed plan/lease. Remove unjustified per-path module caching from *newly promoted* eligible tool execution: use fresh subprocess loading a content-addressed release or a supervised worker. Avoid `importlib.reload` across live object graphs. Preserve explicit native provider, adopted and synthesized semantics. If cache remains in a pinned running worker, correctly mark worker v1 and route v2 tasks elsewhere.  
**Done when:** With API process staying up, change a synthesized tool's approved implementation v1→v2; v1 in-flight call finishes v1; next v2 call returns v2; restart count for main API is zero. Repeating under a dotted import path and two-module transitive dependency yields no stale module or mixed classes. All existing authorization and argument/output validation still fire.

### W05 — Isolated subprocess and adopted-tool reuse

**Where:** `collective_core/adoption.py`, `adopt_runner.py`, `collective_core/capability_runtime.py`, `collective_synthesized/tool_runtime.py`, `runtime/host_workload.py`.  
**How:** Reuse the existing sealed-venv process execution where applicable, including declared missing generic `adopted:` binding bridge only if actual call sites require it. Define typed argv/stdin/output protocol, time/memory/CPU quotas, process ownership, no shell string, no automatic package download, environment isolation, cancel signal, bounded stdout/stderr. Bind exact venv/package/interpreter digest; version runner at next call.  
**Done when:** A changed approved executable loads on next isolated invocation; malicious/invalid/unapproved package refuses; timeout, crash, resource kill, cancellation, unknown output and old-version lease result in honest typed outcomes. Existing adoption path doesn't regress. Startup/latency cost is measured.

### W06 — Long-running worker and service replacement

**Where:** Existing Borg/agent supervisors, `session_runtime/runtime.py`, `run_manager.py`, `api/health.py`, current instance/UI launchers; a narrow `runtime_activation/worker_adapter.py` if needed.  
**How:** Launch new worker under its own immutable release, verify health/readiness/version, redirect *new* work, drain old leases, persist state, terminate old only after safe settlement or explicit cancel/compensation, with generation fencing against zombie old workers. Implement bounded retries and restart suppression. Prefer existing worker/supervisor infrastructure; **do not** build an unused `unified_runtime/worker.py` stub into claimed core functionality.  
**Done when:** Stateful worker v1→v2 transition preserves in-flight work, routes new calls to v2, blocks ambiguous replay, and survives a simulated crash between switch and drain. A failed v2 health gate keeps v1 serving; no restart storm.

### W07 — Prompts, policies, routing, configuration, knowledge and models

**Where:** `collective_innovation/evolution_policy.py`, current prompts/skills/manifests, `collective_core/capability_router.py`, model routing and config modules discovered in W00, research/knowledge indexes.  
**How:** Add consumer-side authoritative version re-read at task boundary; validate documents and declarative policies; invalidate derived caches by version digest; maintain per-task snapshot; update only allowed non-code state. For provider/model changes distinguish local config switch, new provider session, download-needed model, and externally owned process; no model downloads. Current evolutionary policy succession remains dynamic and old phase names must not become a required control-plane vocabulary.  
**Done when:** Update each representative prompt/policy/router config and show the next actual request using new content without backend restart where safe; in-flight requests preserve earlier context; invalid configs are rejected. Test that normal research/new knowledge alone does not mutate code or grant permissions.

### W08 — Autonomous Mission Manager and agent continuity

**Where:** Discover actual AMM v2 implementation after completion; `session_runtime/runtime.py`, `resume.py`, Borg dispatch and current campaign checkpoint store.  
**How:** Treat AMM as a managed, versioned *consumer and possible update target*. Bind each campaign decision step to a manager implementation version; persist campaign goals, approvals, leases, state schema and current execution ownership; schedule upgrade at a safe checkpoint; if compatibility unavailable, defer/drain and use existing session restore. Give manager a read-only freshness API and gated activation request, not deployment authority. Preserve mission-source digests and directory rescans across updates.  
**Done when:** AMM v1 actively manages two missions; approved v2 becomes active for future decisions without losing priorities/progress, and an old decision cannot double-dispatch work. Mutating manager implementation itself doesn't cause recursive activation or orphan its durable state. A version mismatch or interrupted handoff blocks honestly.

### W09 — HTTP, MCP and CLI entry point coverage

**Where:** `api/chat_sse/chat_route.py`, `event_stream.py`, API tool routes, MCP service/transport routes, CLI app entrypoints and per-run state.  
**How:** Integrate the resolver at *real ingress-to-effect boundaries*; ensure all alternate paths (session injection, background, direct MCP tool call, CLI, API tool execution) cannot bypass approval/freshness. Expose status and a narrow operator activation/control API only if not already present; use existing auth/session/governance. SSE events report actual state changes with evidence/version pointers and no false success text. Reconnect replays state, not effects.  
**Done when:** The same updated test capability executes v2 through HTTP, MCP and CLI normal paths after promotion, or each unsupported transport reports a precise unsupported state. Matched ablation of the resolver/activation edge breaks the expected test. An unauthorized alternate ingress cannot run an unpromoted revision.

### W10 — UI assets and production browser freshness

**Where:** `ui/src`, `ui/src/api/client.js`, production launch/build/asset serving, Vite and Playwright tests.  
**How:** Distinguish dev HMR from production deploy. Bind build asset digest, server API compatibility and client cohort version; expose update-needed signal and user-safe refresh/reconnect preserving chat/session/state. Never claim forced refresh of remote tabs; for major incompatibility enforce a typed compatibility barrier and resumable update handoff. Avoid changing browser bundle in-place while being served.  
**Done when:** With an old browser client open, new approved UI build becomes served; client detects it, safely refreshes or displays explicit `PENDING_CLIENT_REFRESH`; chat progress and execution receipt remain retrievable. An old incompatible bundle cannot silently issue newly incompatible requests. Real browser E2E validates it.

### W11 — Backend core and launcher changes: scoped safe restart

**Where:** `api/health.py`, `run-instance.sh`, `scripts/run-ui.sh`, resource guard, current shutdown/recovery/status routes.  
**How:** For code that cannot safely reload, classify impact, stop new admissions, settle/ checkpoint work, verify durable pointers, invoke existing supervised restart, check health/readiness/effective code digest, reopen admission and reattach clients. Respect automatic launcher restart semantics, environment changes, module caching and dependency migrations. Fail closed if live sessions cannot be reconciled. Avoid editing running shell scripts without preserving the currently executed script snapshot.  
**Done when:** A real core-code update correctly reports `PENDING_RESTART`, then after a scoped restart active request uses v2 and no committed effect is lost/duplicated. Failure or blocked drain leaves an honest state with recovery instructions. An invalid update never takes over healthy v1.

### W12 — State schema and persistent-data compatibility

**Where:** Existing state stores and schema migration ownership across API, AMM, sessions, Borg, research, collective and runtime.  
**How:** Build a compatibility matrix; prefer expand/contract migration with old/new readers, backups and migrator validation. Bind data schema to release-set identity. Persist migration checkpoints, provision downgrade logic only where data transformations are reversible, prohibit code rollback that cannot read current data. Protect state from unverified dual writers and cross-generation leases.  
**Done when:** Forward/back compatible change runs v1 and v2 safely during declared transition; incompatible change blocks until verified drain/migration. A crash during migration recovers exactly once. Rollback correctly refuses unsupported data downgrade and offers a safe forward fix without corrupting records.

### W13 — Cross-component and multi-instance consistency

**Where:** The runtime version map and current existing leases/locks, multiple DT instances/workspaces, two-machine setups if actually connected, Borg shared writers.  
**How:** Activate compatible *sets* when schema/protocol requires it; compare-and-swap active pointer, fencing tokens, stage per instance, represent disconnected instance as unknown/stale, prevent old writers from overwriting new-format records. Do not require consensus machinery where there is only one process; do not assert atomic global switch over disconnected hosts. Restrict load based on actual current host-budget limits, avoid process explosion.  
**Done when:** Concurrent agents promoting conflicting versions cannot both win; mixed clients report truthful status; a disconnected worker fails safe on incompatible work; two connected instances converge or report partial deployment without falsely claiming success. Unrelated units can evolve independently.

### W14 — Failure recovery, rollback and retention

**Where:** Existing authoritative rollback, deployment state, process supervisors and reconciliation pathways; new coordinator only if justified by W00.  
**How:** Recovery across every cut point (capture/preflight/pointer/launch/health/drain/commit); idempotent reconciliation; version pinning of in-flight work; last-known-good retain/revert using existing authority; canary where appropriate; max failure rate abort; targeted fault isolation. Maintain resource-capped artifact retention and cleanup only owned bytes never artifacts pinned by active/rollback leases.  
**Done when:** Inject failures at every cut point, kill API/worker, corrupt one release, lose power-equivalent between fsyncs, simulate retries and concurrent updates. No false `ACTIVE`, no duplicate side effects, no destroyed last-good version, and recovery works without manual directory surgery.

### W15 — Runtime visibility, audit and operator controls

**Where:** Existing `/api/...` operational status routes, Chat UI, CLI status, MCP read-only tools and logs; choose least invasive additions.  
**How:** Show desired / approved / promoted / active / observed / pending / stale versions; release-set and owner digests; impacted services/clients; reason for restart; in-flight leases; compatibility; rollout/canary cohort; true effect evidence; last-good and rollback ability. Allow authorized `inspect`, `activate-approved`, `pause-activation`, `resume`, `drain`, `rollback-if-safe`; preserve role/permission checks. Ordinary user queries should not instantiate upgrades.  
**Done when:** After change, an operator can answer “is the system actually using the new code everywhere that matters?” from machine-readable receipts, not logs guessed from Git HEAD. Demonstrate redacted outputs, unauthorized-control refusal, and correct cross-tab/session display.

### W16 — Benchmarks, acceptance, independent closure

**Where:** `tools/doubletake_evolve/runtime_activation/tests/` (or actual target packages), `ui/e2e/`, `reports/runtime_freshness/`, an independent closure verifier with a read-only interface.  
**How:** Build frozen representative integration cases across every lifecycle class, matched old/new outcomes and stale-module ablation, synthetic crashes, realistic multiple agents, real HTTP/MCP/CLI/UI paths, resource metrics and compatibility rollback. Generate report artifacts from executed tests, not agent-authored PASS statements; verifier recomputes digests and checks required event chains.  
**Done when:** Acceptance matrix A01–A52 all PASS with source-bound independently re-derivable proof; zero unexplained high-severity regressions; exact blockers stated rather than waived; final closure `COMPLETE` only when required end-to-end behavior is proven.

---

### W17 — Enforce the actual L0 kernel as the unique root (not an extra recovery kernel)

**Where:** `L0/README.md`, `L0/docs/EXTENSION_ABI.md`, `L0/CODE/core_kernel/public/kernel_service.py`, `L0/CODE/kernel_composition/`, seed manifests/tests and actual production API/CLI/MCP ingress adapters. **The goal is normally zero new code inside L0.**

**How:** Inventory canonical L0 methods/ports and seed tests, then trace production routing from ordinary chat, CLI, MCP, agents and background tasks. For routes that bypass canonical L0 policy/gateway boundaries, create the smallest **external port adapter** to bridge them; preserve existing user-facing paths and effects semantics. Avoid claiming that all processes directly call `run_turn` unless demonstrated. Lifecycle events can attach through existing port composition, not by inventing a second public turn entrypoint. Assert L0 imports no extension and retains no direct shell/network/promotion power. Prove minimality with LOC/import/privileged-interface deltas, and keep/restore L0's exact known-good build and manifests.

**Done when:** A real normal Chat UI request, a genuine CLI call and an enabled MCP route demonstrably respect L0 governance and gateway control; denying a tool at L0 prevents all execution downstream. Seed proof suite and manifest closure pass unchanged; no duplicate root authority or kernel appeared. If an existing route cannot be migrated safely in one step, it remains an explicitly named **blocking architecture gap** and cannot count toward final closure.

### W18 — Common fault intake, causal classification, quarantine, and graceful degradation

**Where:** Existing API/launcher/session monitors, `collective_core/{adaptive_immune,immune,regeneration}.py` if actually live, existing event and evidence facilities; narrow external `runtime_activation/faults.py` or equivalent only when W00 demonstrates a missing seam. Do **not** add an L0 fault-analysis engine.

**How:** Map *actual observed failures* to durable typed events bound to unit/release/request, error class, call path, dependency scope, trusted observation, previous known-good release and irreversible side-effect stage. At a stable L0-controlled invocation/event boundary decide `CONTINUE_UNAFFECTED`, `ISOLATE`, `ROLLBACK`, `RETRY_SAFE`, `REPAIR_ELIGIBLE`, `PAUSE_AFFECTED`, `REFUSE_UNSAFE`, `ESCALATE`. Use existing Borg/worker execution for actions; default to isolation and evidence capture when certainty is insufficient. Recovery must not incorrectly turn security denials into fixable "errors" or restart endlessly on a deterministic code defect.

**Done when:** Inject syntax/import error, bad dependency, runtime exception, failing API worker, damaged generated tool, bad prompt/config, resource timeout and incompatible schema separately. Each results in a truthful fault receipt and safe containment. An unrelated read-only Chat UI/API operation remains available when its dependencies are healthy. A corrupt shared authority forces relevant writes to refuse, not to use an insecure fallback.

### W19 — Repair as ordinary external governed work, not code inside the kernel

**Where:** Existing Autonomous Mission Manager and Reliability & Recovery specialty, Borg task/executor paths, relevant research/evolution tools, workflow governance and version activation; a small external repair-request/receipt adapter if needed. No L0 repair LLM, no new kernel.

**How:** After fault isolation, construct a bounded repair task with input evidence, affected scope, known-good baseline, authorization classification, concrete reproduction, falsifiable causal hypotheses, proposed smallest fix, clean isolated worktree, immutable test fixtures, independent output oracle, security/compatibility/regression gates and revert plan. Delegate to existing authorized worker/manager. The repair component may use adaptive research/evolution **only when relevant and allowed**. It cannot declare itself authorized or successful. Keep L0 logically available to delegate unrelated work while a repair proceeds. Preserve open evidence and decide between `FIXED_VERIFIED`, `ROLLED_BACK`, `DEFERRED_BLOCKED`, `REQUIRES_APPROVAL`, `UNREPAIRABLE_NOW`.

**Done when:** A real injected Python defect is reproduced (RED), repaired by a replaceable external worker, verified GREEN on active path, independently promoted and activated; an indistinguishable superficial change lacking causal improvement is rejected; a second component still works throughout. Operator approval/refusal and an unverified patch provably prevent activation. No invented repair success if external model/agent unavailable.

### W20 — L0/host bootstrap failure and minimality proof

**Where:** Existing `run-instance.sh`, `scripts/run-ui.sh`, `api/health.py`, `runtime/host_workload.py`, L0 immutable seed artifacts/manifests; extend actual existing launcher and supervisor **only if necessary**. An OS-external launcher remains a mechanical host bootstrap, never another decision-making kernel.

**How:** Detect L0 health/readiness, distinguish corrupt new L0 image from normal transient crash, select only **already approved and retained** last-good L0 on bounded relaunch, verify artifact hashes and ABI, enforce restart backoff and circuit breaker, preserve run journals and operator stops. The launcher must not generate policies, execute research, approve changes, bypass governance, or install dependencies. A stopped/nonfunctional L0 cannot magically write a fix; either trusted rollback succeeds or fail closed with diagnostic evidence. Keep L0's dependency-free/offline boot. Measure core LOC/import/call-graph baseline vs final; justify every additional L0 line and minimize public API changes.

**Done when:** A deliberately broken new core release fails readiness, existing launcher restores verifiably good L0 (when preapproved rollback is viable), and stable unaffected state resumes; deleting/breaking last-good or trust material yields clear `BLOCKED`/operator action, not a fake recovery. Restart storms are prevented. L0 seed boot, manifests, tool restrictions and required make targets all pass.

### W21 — Repair loops, impasse reasoning, regressions and prevention

**Where:** Autonomous Mission Manager external to L0, existing failure-learning records, reliability mission, immutable release/evidence ledger.

**How:** Limit each repair to a declared budget and causal hypothesis family; store fingerprints of previously failed fixes, observed effects, rollback reason, quarantine and escalation threshold. Repeated deterministic failures with no new evidence must **park** the issue, notify the manager and redirect unaffected work; never keep generating patches indefinitely. A repair that repeatedly regresses other functionality is quarantined; tests for root cause, held-out cases and baseline equivalence are mandatory. Feed verified learned mitigations into health tests and release preflight. A successful *rollback* restores availability but does not automatically mean the defect is fixed; track those states separately.

**Done when:** A deliberately unsolvable fault terminates repair attempts cleanly, preserves nonaffected services, records an actionable blocker and leaves a valid resume point. A genuinely new root-cause hypothesis may restart a bounded attempt, but replaying the same edit does not. Verify circuit-breaker reset conditions and no global starvation.

### W22 — Autonomous repair observability and control from normal UI

**Where:** Existing Chat UI activity/SSE, CLI/MCP operational status, `api/health.py`, AMM campaign status; no independent repair dashboard or ungoverned root console.

**How:** Show kernel version/health/minimality, degraded subsystems, healthy available services, fault IDs, repair attempt/experiment budget, last-good versus active candidate, reason for isolation, progress/proof, pending approval, rollback and unrecoverable blocker. Keep repair data redacted; operator controls `inspect`, `pause_repair`, `resume_authorized`, `rollback_approved`, `quarantine` use existing L0/authority gate and durable identities. Do not falsely claim repair completion because process is alive. Chat normal questions remain separate from repair authorization.

**Done when:** Browser E2E demonstrates a failing tool with repair underway, unrelated task still succeeding, then verified repair activation or honest blocked state. Unauthorized repair promotion, ambiguous UI progress and lost SSE reconnect are caught by tests.

### W23 — Cross-system failure campaigns and L0 preservation closure

**Where:** Existing L0 proof suite, `tools/doubletake_evolve/runtime_activation/tests/` (if actually built), API/MCP/CLI tests, `ui/e2e/`, `reports/runtime_freshness/` and independently verified closure tooling.

**How:** Run bounded fault-injection campaigns across ordinary work, evolution, research, AMM and code update routes, including correlated failures, schema corruption, crash while saving a patch, root compromise, resource starvation and multi-instance partial deployment. Use actual public routes and real launcher behavior for the critical edges, with clearly marked mocks only for irrelevant external providers. Compare continued availability/repair outcome against a matched baseline or disabled recovery edge; require actual RED→GREEN improvements without relaxing governance. Verify non-regression of all L0 seed tests and no addition of forbidden capabilities to `L0/CODE`.

**Done when:** A35–A52 and S31–S50 pass on source-bound evidence; no L0 ABI/invariant violations, hidden second kernel, compromised trace/ledger, false success, uncontrolled repair storm or unsafe code promotion; final closure verified independently.

---

## 6. Concrete public runtime contract to implement

Use an existing public API/CLI/MCP surface if it already offers equivalent semantics. Otherwise provide the following **logical operations**; actual route names may differ as long as identical behavior is reachable and tested from normal surfaces:

```text
inspect_kernel_health_and_fidelity() -> KernelHealthReport  # existing L0 kernel, no second kernel
record_fault(observation, kernel_authority) -> FaultReceipt  # external adapter through existing ports
plan_containment(fault, current_bindings) -> ContainmentPlan
request_governed_repair(fault, authorization) -> RepairTaskReceipt  # external worker
inspect_repair_state(fault_id) -> RepairStatus
inspect_updateable_inventory(scope) -> InventoryReport
inspect_freshness(unit_id?, instance_id?, run_id?) -> FreshnessReport
inspect_impact(candidate_artifact, owning_authority) -> ImpactAssessment
prepare_release(approved_candidate, proof_refs) -> PreparedRelease
plan_activation(release_set, impact, active_work, budget) -> ActivationPlan
activate_approved(plan, authorization) -> ActivationReceipt
bind_execution(request, active_policy, runtime_context) -> ExecutionBinding
ack_effective(binding, observation) -> ObservedExecutionReceipt
reconcile_activation(operation_id) -> ReconciledState
rollback_activation(operation_id, authorization) -> RollbackOutcome
```

**Keep pure calculations pure:** `inspect_impact` and `plan_activation` must not import arbitrary candidate source, create worker processes, modify authoritative pointers or trigger evolution. Only the existing effect boundary and explicit execution methods may change live state.

Expected outcome of `bind_execution`:

```json
{
  "request_id":"...",
  "selected_release_set_digest":"sha256:...",
  "unit_bindings":[{"unit_id":"...","version_digest":"sha256:...","runtime_instance":"..."}],
  "authorization_ref":"...",
  "version_lease_id":"...",
  "compatibility_verdict":"PASS|BLOCKED",
  "activation_state":"ACTIVE|STALE|PENDING_RESTART|...",
  "reason":"..."
}
```

Every real effect receipt includes the binding digest. `ack_effective` must correlate observed execution to that binding, not merely trust a worker's self-reported intended version. Where an interpreter cannot directly attest source bytes, independently compare pinned loaded artifact and observed behavior under a distinguishable canary probe. Do not pretend cryptographic remote attestation exists where it does not.

**Version-selection rules:**

1. Explicit authorized pin (for continuation/replay) wins if compatible and retained.
2. Otherwise resolve the latest active compatible release under its current owner policy.
3. If promoted newer release is pending activation, either route to the still-active version with a visible pending state **or** refuse under changed compatibility; never mislabel the old version as new.
4. No approved release: typed fail closed, not fallback to raw mutable source.
5. Model and externally owned provider version resolution can only verify what exposed provider metadata makes knowable; unknown must stay unknown.

---

## 7. Handling cases outside today's known component list

To avoid needing a new mission whenever DT learns a new kind of work, implement extensible **activation adapters** with a strict capability/effect declaration. An adapter may define: `detect`, `fingerprint`, `dependencies`, `preflight`, `prepare`, `activate`, `observe`, `drain`, `reconcile`, `rollback`, `limitations`. Registration and activation must pass the existing governance boundary; arbitrary plugin code must not run merely because it is present in a directory.

**No new privileged kernel for new component types.** Extend only governed **external** adapters; L0 continues to use its original ports and stable ABI.

**Default for an unknown change is not “safe hot reload.”** Record `UNKNOWN_IMPACT` or `NO_ADAPTER` and refuse or choose a conservative supervised restart only if that path is explicitly established as safe, authorized, and sufficient. Source analysis is advisory, not a substitute for runtime evidence. Do not generate a bespoke per-file Python package as a response to unknown change.

#### Cross-cutting unusual cases to test

- An old imported class remains referenced by a singleton even after its defining file changes.
- A helper module changes but the top-level tool file, manifest and route do not.
- A Python module has two import spellings and resolves to distinct identities.
- A `.pyc` or bytecode/cache contains old executable instructions.
- A Python plugin imports a native `.so` library that cannot be unloaded safely.
- `pip` package, interpreter, provider SDK or transitive dependency changes without `.py` content changes.
- A running thread holds a callback closure into an old module.
- An MCP client caches tool schemas and continues sending incompatible arguments.
- A background job retries after the new version has been activated.
- A UI tab goes offline during a backend/UI release and returns days later.
- A changed prompt is referenced by several campaigns; one should remain pinned, another should adopt updated approved text.
- A source file is modified but fails approval, while an earlier active version must continue serving.
- A deployed file disappears or a symlink is exchanged after fingerprinting.
- The current Git checkout is mid-merge, peer agents are editing, or `HEAD` advances between snapshot and activation.
- A configuration value is removed or renamed while an older worker still reads it.
- An externally owned service is updated by its owner but cannot report precise version.
- A newly evolved algorithm changes policy schema, then changes the activation policy itself.
- The Autonomous Mission Manager is upgraded while deciding which update to attempt.
- A new version crashes during readiness, before accepting any work, or immediately after a committed effect.
- A rollback candidate cannot parse data already written by a newer schema.
- Two machines cannot contact each other; one has the new release while another does not.
- High system load makes new-process-per-call cost worse than a pinned pool.
- Normal user asks “what changed?” without any authorization to change code; inspection only.
- An agent attempts to label a raw worktree change “approved” by writing a synthetic success receipt.
- A malicious local file asks the activation system to disable authorization or silently rewrite active pointers.
- CI tests pass under a mocked provider but the actual API/MCP/Chat UI path still runs old code.

Add newly discovered material scenarios to the coverage inventory and tests, prioritizing their risk. No invented “all future architectures supported” statement is acceptable; future adapters must satisfy the documented contract.

---

## 8. Concurrency, safety, permissions and performance

### 8.1 Shared `main` safety

- Follow `AGENTS.md` verbatim, inspect `git status --porcelain=v2`, current HEAD, staged/unstaged/untracked/ignored relevant files and active peers. Do not silently modify, stash, reset, clean, rebase, force push or squash away unrelated work. Use owned minimal commits and verify changed HEAD before applying.
- Avoid multiple agents editing central activation owners simultaneously. Parallel read-only analysis is fine; use explicit path ownership and existing locks for mutations and high-cost tests.
- All experiments/builds use the currently approved `runtime/host_workload.py` wrapper and budgets. Check actual current code, not budget constants from this prompt.
- Never download models or install dependencies without explicit authorized workflow and operator permission. Never access employer systems, credentials, secrets, or private data to test these mechanisms.

### 8.2 Performance contract

Define and freeze baseline for p50/p95 request latency, cold-start time, memory, CPU, worker counts, and crash/recovery time on representative paths. Run candidate and baseline on comparable loads. Hot-swappability that doubles latency for every cheap request is not automatically an improvement. Use persistent version-pinned worker pools where per-invocation subprocess overhead is unacceptable, but workers must refresh on release changes. Bound artifact storage and GC. Report degradation and accepted trade-offs; do not tweak acceptance thresholds after seeing results.

### 8.3 Failure classification

Map errors to stable typed reasons: `UNAPPROVED_SOURCE`, `STALE_DEPENDENCY`, `MISMATCHED_DIGEST`, `OWNER_UNAVAILABLE`, `INCOMPATIBLE_INTERFACE`, `INCOMPATIBLE_STATE`, `MIGRATION_REQUIRED`, `DRAIN_BLOCKED`, `INSTANCE_UNKNOWN`, `CLIENT_UPDATE_REQUIRED`, `EXTERNAL_OWNER`, `RESOURCE_REFUSED`, `TIMEOUT`, `VALIDATION_FAILED`, `ROLLBACK_UNSAFE`, `ACTIVATION_FAILED`, `FAULT_ISOLATED`, `REPAIR_DEFERRED`, `REPAIR_REQUIRES_APPROVAL`, `REPAIR_UNVERIFIED`, `KERNEL_BOOT_FAILED`, `LAST_GOOD_UNAVAILABLE`, `L0_CONTRACT_VIOLATION`, `RECOVERY_ESCALATED`. No broad `except` returning `success=True`, no omission that implies completion.

### 8.4 Kill switch and blast radius

A bad release must be suppressible at the smallest relevant unit while preserving useful unaffected services. Repeated activation failures quarantine the candidate with a bounded circuit breaker. Stop/disable respects current operator control; no self-resurrecting runaway manager. A global disable may be required for a compromised trust root, but must be explicit and evidenced. Security checks cannot be toggled off by a released component.

---

## 9. Required acceptance matrix — A01 through A52

All entries are **mandatory** for `COMPLETE`. `NOT_APPLICABLE` is permissible only for a genuinely absent/nonreachable optional class verified by independent inventory proof and **never** for a required end-to-end route. A class with an unimplemented production pathway is `BLOCKED`/`FAIL`, not `N/A`. Each criterion requires independent pass/fail oracle, source-bound proof references and attributable actual-path tests.

| ID | Required verifiable outcome |
|---|---|
| **A01** | W00 inventories every current ingress/worker/consumer family, names actual owners and distinguishes present vs production-reachable |
| **A02** | Ordinary operations use version binding even when no evolution or updates are occurring |
| **A03** | Manual/operator and routine agent-authored changes use the same governed deployment path as evolutionary changes |
| **A04** | No unapproved edits, tampered manifests, symlink swaps or partially written `.py` files become runnable |
| **A05** | Source, transitive dependencies, environment, prompts/config and runtime effect are content/version bound |
| **A06** | Approvals and owner policy cannot be counterfeited by activation callers; promotion is separate from activation |
| **A07** | In-flight task remains on coherent old release; next new compatible task uses promoted-and-activated new release |
| **A08** | Same-path synthesized Python tool v1→v2 works through real execution path with API remaining up |
| **A09** | Dotted Python imports/dual module aliases/transitive dependencies do not leave new work on stale code |
| **A10** | Adopted sealed-venv tools execute pinned code via existing isolation, with measured updated-runner behavior |
| **A11** | Native service/collective owner changes cannot be falsely marked hot activated when cached in a live process |
| **A12** | Prompts, configuration, routing and policy refresh at safe request boundaries with current owner authority |
| **A13** | Future successor evolutionary policy is adopted automatically by stable request contract, no phase-name hardcode |
| **A14** | Research/knowledge tools and ordinary business/user work share the freshness contract, not bespoke evolution glue |
| **A15** | Autonomous Mission Manager resumes after its own compatible upgrade without lost/double campaign actions |
| **A16** | Borg multi-agent/workers preserve leases, worker versions and effect idempotency during replacement |
| **A17** | Long-running worker v1→v2 drain/replacement has readiness and failed-new-worker safety proof |
| **A18** | CLI, HTTP, MCP and background alternate execution routes cannot bypass freshness or authorization |
| **A19** | Chat UI and SSE show accurate activation state and survive reconnect without duplicate activation |
| **A20** | Production frontend update is detected by real browser; old clients safely refresh or show accurate pending state |
| **A21** | Core module update uses coordinated scoped restart and shows observed new code after health/readiness, not a claim of zero-restart |
| **A22** | State schema migration compatibility is verified; unsafe rollback is refused and reported |
| **A23** | Concurrent promotions / stale worker leases / two instances cannot silently split authoritative active state |
| **A24** | Disconnected external workers/clients and inaccessible provider versions stay `UNKNOWN`/`PARTIAL`, not fake `ACTIVE` |
| **A25** | Rollback preserves known-good exact release and correctly reconciles effects and data compatibility |
| **A26** | Crash/interrupt injection at every activation stage yields idempotent recovery and honest state |
| **A27** | Existing security, approval, permissions, isolation, policy ownership and resource budgets remain enforced |
| **A28** | No worker/restart storms; concurrency/resource refusal and circuit breaker operate as documented |
| **A29** | Performance measurements compare baseline vs candidate under frozen comparable workloads and state regressions |
| **A30** | New/unknown component type reports unsupported/adapter-needed honestly; extensibility verified with test adapter |
| **A31** | Effective source-version proof is generated from observed execution, not a mock or `git rev-parse` alone |
| **A32** | Negative/matched ablation disabling the new activation link demonstrably causes stale or missing behavior |
| **A33** | Every mandatory artifact is re-derivable from immutable source refs and tests; verifier catches doctored PASS |
| **A34** | An independent closure verifier returns `COMPLETE` iff A01–A33 and A35–A52 pass and there are no unresolved high-severity regressions |
| **A35** | Existing **L0** is acknowledged as the only kernel; no duplicate privileged kernel/control-plane/approval authority or second public L0 turn entrypoint is created |
| **A36** | Every L0 seed invariant, extension ABI, manifest closure, required seed command and offline/model-free boot remains valid and proved from real `L0/` sources |
| **A37** | L0 minimality budget reported: before/after LOC, imports, ports, privileged effects, startup dependencies; any growth has explicit demonstrated necessity and remains within seed invariants |
| **A38** | Actual production Chat API, CLI and MCP-enabled routing are traced to L0-controlled policy/gateway or missing edges are accurately blocked; no mere seed-only test earns PASS |
| **A39** | Ordinary user task, update task, operational fault and repair trigger share the single L0 authorization/effects boundary; no fault path bypasses it |
| **A40** | Real component failure generates a durable typed fault tied to exact version, known affected consumers, actual outcome and bounded recovery plan |
| **A41** | Failing replaceable component is isolated while independent unaffected work still runs correctly; failure contagion is absent or a precisely measured shared dependency blocker |
| **A42** | Known-good rollback restores actual function where safe; code rollback vs causal root-fix are separately represented and never conflated |
| **A43** | Governed external repair worker reproduces a real defect RED, constructs a falsifiable candidate and gets real-path GREEN after independent approval and activation |
| **A44** | A bogus fix, fabricated approval, self-approved patch, missing held-out evidence or adversarial injection cannot enter active execution through repair flow |
| **A45** | L0 itself contains no agentic repair, arbitrary shell/network/package install, extension runtime imports or direct privileged deployment; repair workers are replaceable/isolated |
| **A46** | Simulated broken new L0 release reboots via existing trusted launcher to verifiable last-good under bounded mechanical rules, or reports unrecoverable safely |
| **A47** | Kernel failure or loss of immutable last-good/trust state does not cause fabricated autonomous repair success, unapproved image launch or an infinite restart storm |
| **A48** | Deterministic repeated errors trigger bounded retry/circuit breaker/defer/escalate and **do not** monopolize the manager or disable unrelated healthy work |
| **A49** | Resource starvation, multi-component failure, corrupted persisted state and interrupted fix/promotion remain contained, reconciled and transparently reported |
| **A50** | Live normal UI and machine-readable CLI/API status display truthful kernel/extension fault state, repair receipts, available work and pending approvals, with safe controls |
| **A51** | Matched negative control disabling the recovery/repair link (not policy guard) reproduces the failure; restoration explains observed improvement while seed guards remain active |
| **A52** | Independent verifier binds A35–A51 and S31–S50 to actual sources, executed probes and unaffected-service evidence; rejects fake PASS, missing L0 proof or a hidden second kernel |

### 9.1 Full acceptance evidence requirement

For each A criterion, create a row with fields:

`criterion_id`, `status`, `scope`, `baseline_behavior`, `required_behavior`, `source_rev`, `source_digest`, `test_command`, `test_exit_code`, `runtime_entrypoint`, `runtime_invocation_id`, `before_observation`, `after_observation`, `negative_or_ablation_observation`, `oracle`, `evidence_refs`, `limitations`, `owner`, `next_remedy`.

A criterion cannot pass because a test has that name. Verification must inspect the test assertions and/or execute the described independent oracle. If production integration requires running a live provider that is unavailable in test context, mark the *provider-specific* coverage `UNVERIFIED`, and do not claim full coverage.

---

## 10. Test scenarios — S01 through S50

These are the minimum end-to-end and adversarial scenarios; implement targeted unit tests too. Record cases in versioned fixtures. All tests involving subprocesses must run within the host guard and clean only owned temporary files.

| Scenario | Test and expected decisive result |
|---|---|
| **S01** | No-change ordinary chat/API task runs existing active release with correct receipt; no deployment triggered |
| **S02** | Manual `.py` edit without approval remains candidate; active worker stays on approved earlier bytes |
| **S03** | Approved synthesized tool update (same filename) returns v2 through a fresh call while API stays alive |
| **S04** | Start v1 long-running call, switch, start v2 call: concurrent outputs distinguish versions correctly |
| **S05** | Update shared Python helper only: dependent tool v2 loads helper v2 or requires conservative replacement |
| **S06** | Alias import via `tools.doubletake_evolve`/`doubletake_evolve` yields one consistent generation |
| **S07** | Tamper artifact after approval: activation fails before effects |
| **S08** | Mutable checkout file rewritten mid-capture: snapshot rejected or retried without serving inconsistent bytes |
| **S09** | Unknown dependency/incompatible interface: typed safe refusal, not accidental mixed versions |
| **S10** | Approved live config/prompt update consumed by next task; old task's context unchanged |
| **S11** | Current evolutionary policy swapped to a compatible successor and a normal governed evolution request resolves it |
| **S12** | Research mission activation uses newly approved parser; research facts alone do not cause code changes |
| **S13** | Adopted tool invokes newly approved runner with exact venv fingerprint; broken tool process isolated |
| **S14** | Simulated native service code edit cannot be falsely marked current until worker/service replacement |
| **S15** | Stateful worker drain/replacement; failure before readiness keeps v1 serving |
| **S16** | Kill API between release pointer switch and ready acknowledgement; reconciliation resumes without duplicate effects |
| **S17** | Kill old worker after effect commit; retry does not repeat side effect |
| **S18** | Direct CLI, HTTP API and MCP call all use current contract and identity; negative bypass case refused |
| **S19** | AMM manager v1→v2 during active multi-mission campaign; checkpoint correctness verified |
| **S20** | Browser receives new UI bundle while open; preserves session and shows its actual code version |
| **S21** | Offline browser with stale schema returns; compatibility refusal/update path works |
| **S22** | Pure backend core code change requires controlled restart; status and real post-restart behavior verified |
| **S23** | Schema expand/contract compatible transition passes; incompatible backward change prevented |
| **S24** | Two agents attempt conflicting promotions; one canonical winner and no lost ledger updates |
| **S25** | Two instances with one disconnected: incomplete cohort explicitly reported, no global ACTIVE lie |
| **S26** | Externally owned model/MCP process cannot change code in place: handoff reports exact limitation |
| **S27** | Failed new release quarantined; rollback restores last-good bytes and user-facing function |
| **S28** | Resource exhaustion/worker timeout prevents retry storm, leaves live old services intact |
| **S29** | Switch off only new activation edge in matched ablation; novel v2 behavior disappears; restore repairs it |
| **S30** | Forge one PASS/evidence digest; independently run closure verifier rejects tampering and incomplete coverage |
| **S31** | L0 seed proves boot, governance-before-gateway, one entrypoint, manifest closure with **no** network/model/GPU/secrets and no extra files in closed seed manifest |
| **S32** | Discover production API→L0 path on a genuine chat request; if absent, test fails and implementation must wire an authorized external adapter instead of claiming PASS |
| **S33** | Direct CLI and enabled MCP request cannot bypass L0 governance even when capability or provider reports success; denial prevents effect |
| **S34** | Change an L0 kernel dependency to fail import; measure bounded last-good bootstrap or explicit safe failure, not an agent trying to patch dead L0 |
| **S35** | Malicious proposed repair calls subprocess/socket from inside L0; static manifest/invariant proof rejects it and original seed still boots |
| **S36** | Deliberately introduce syntax error to a replaceable capability while two independent tasks run; affected task quarantines, unaffected task completes |
| **S37** | Real governed repair worker fixes v1 parsing defect under isolated worktree; RED pre-fix, GREEN post-fix, held-out and ablation proof, then approved active v2 |
| **S38** | Worker claims repair complete without verification or real effect; L0/authority reports `REPAIR_UNVERIFIED`, refuses active promotion |
| **S39** | A poisoned research document instructs repair worker to disable approval; source treated as data and guard prevents mutation |
| **S40** | Rollback restores service from verified old code, with state `ROLLED_BACK`, while underlying defect remains open as `NOT_FIXED` |
| **S41** | Three identical failed repair hypotheses trigger circuit breaker and manager reallocation; no rapid infinite retry, safe unaffected work continues |
| **S42** | Repair needs operator approval but none granted; repair state `REQUIRES_APPROVAL`, no effect executed, unaffected work continues |
| **S43** | Kill repair worker after applying candidate but before writing receipt; reconcile actual effects without double execution |
| **S44** | New API release crashes on startup; existing supervisor uses known-good approved image only and kernel readiness/identity verify, preserving durable sessions |
| **S45** | Corrupt both candidate and last-good references; fail closed with action-needed signal and no fabricated availability |
| **S46** | Dependency change breaks reasoning and research but not an unrelated tool; contain only affected dependency graph, show correct degraded scope |
| **S47** | Database schema corrupted so rollback would overwrite newer data; reject unsafe rollback, preserve forensic evidence, continue unrelated read-only services if possible |
| **S48** | Multi-agent repair collision: only one approved commit/promotion wins, no lost user work, shared main unaffected by duplicate patches |
| **S49** | Real browser receives fault/recovery SSE, displays partial availability, then current version after verified repair; reload/reconnect never repeats repair effect |
| **S50** | Remove the recovery delegation wire and show specifically lost automatic repair, restore it, then tamper evidence and demonstrate independent verifier refusal |

**Minimum repair routes:** At least one actual L0 seed proof, one production L0 linkage measurement, one authentic failing module, one real contained external repair execution, one observable same-session unaffected task, one L0 core-failure boot/recovery proof, one real browser fault/repair display and one independent closure tampering proof.

**Minimum integration routes:** one genuine `/api/chat` route and SSE event, one actual CLI command, one actual MCP call if enabled, one real browser Playwright flow, one subprocess worker, one long-lived service, and one AMM-managed two-objective campaign. No mocks in lieu of the specific execution edge each route is meant to prove. Stubs may isolate unrelated providers but must be named and must not fabricate successful update behavior.

---

## 11. Explicit integration examples and expected behavior

### 11.1 Ordinary tool request

Operator: `Analyze this CSV using DoubleTake.`  
System: resolves currently approved CSV-analysis implementation, binds exact version, executes, validates and records it. It does not begin evolution or deploy a new release.

### 11.2 Routine engineering patch

An agent fixes a parser in an authorized mission. It commits candidate source and runs baseline/held-out tests. Existing governance approves promotion. The runtime classifies the parser as `FRESH_PROCESS` or `REPLACE_WORKER`, captures immutable artifact and activates it; the next research invocation uses the fixed parser. The API remains up when safely possible.

### 11.3 Manager self-improvement

AMM manages several prompt directories. A verified improvement is made to AMM's selection logic. Its next decision uses the approved new implementation after a durable checkpoint. An in-progress decision/dispatch retains its bound version and cannot execute twice. If state schema is incompatible, the campaign pauses at a safe boundary until migration/restart succeeds.

### 11.4 Existing evolution policy update

A future successor to three-phase evolution passes its existing adoption governance. A user issues a generic `evolve this capability` instruction. The existing evolution owner resolves the active successor policy, while the shared activation contract ensures its code/process is current. No Bank prompt or AMM code has to name `three-phase` explicitly.

### 11.5 Core patch that cannot hot-swap

An API-wide import graph or authorization module changes. The runtime detects incompatibility and reports `PENDING_RESTART`, checkpoints/drains affected work, triggers existing supervised restart, validates code identity and readiness, then reports `ACTIVE`. Zero downtime may be unavailable on a single server; the record must say so. Safe availability is more important than an impossible zero-restart promise.

### 11.6 UI update

A production React bundle is rebuilt from approved sources. Existing clients detect new build ID. Compatible clients refresh while preserving session state; incompatible clients are blocked from unsafe actions and offered a guided refresh. A sleeping browser that cannot receive events remains a known unknown/stale cohort until reconnection.

### 11.7 Prompt directory update

A new approved mission file appears in directory `xyz`; the AMM's directory scan discovers it according to its own source classification. The manager may assess it and update the portfolio after authorization. No capability runner executes arbitrary instructions simply because a Markdown file appeared; running missions must remain under the manager's approval model.

---

### 11.8 Runtime defect, independent tasks remain alive

A new parser version fails at import. L0-controlled fault handling isolates the parser release, records the exact failing version and schedules a bounded repair assessment externally through existing mission manager/Borg. A separate unimpacted task runs successfully. If the prior parser version is compatible and safe, it is restored; if not, only parser-dependent tasks are blocked. A verified repair candidate can later activate without a whole-system restart.

### 11.9 Core L0 release breaks at boot

A newly approved candidate L0 image breaks startup. The existing mechanical launcher attempts a bounded preauthorized rollback to **an immutable, independently verified last-good L0 image**, then resumes only after standard seed and readiness checks. It cannot make policy decisions or author patches; no "repair kernel" starts in parallel. Without a valid last-good or intact trust material, report `BLOCKED` for operator recovery. Honest temporary downtime is better than running untrusted instructions.

### 11.10 Repair is itself broken

The diagnosis agent crashes, returns invalid code, or invents a PASS receipt. L0-governed runtime quarantines that repair worker, preserves healthy services and delegates to an already-approved alternative **only if authorized and materially different**, otherwise degrades/parks the repair with a clear resume point. The repair worker's failure must not stop L0 or launch infinite automatic replacements.

---

## 12. Nonfunctional requirements and explicit exclusions

1. **Do not force package-per-component architecture.** Directory/module/package boundaries are not isolation by themselves. Choose release units along genuine process, state, ownership, effect and dependency boundaries measured in W00.
2. **Do not rewrite Python's module cache globally.** Removing entries from `sys.modules`, `importlib.reload`, monkeypatching class objects or forcibly unloading native modules can create split identities, old closures and thread races. Prefer process-level version isolation or verified scoped service replacement.
3. **Do not require restarting all of DT for harmless content updates.** The purpose is smaller activation blast radius, not a new global restart mechanism.
4. **Do not promise no restart ever.** Expose and automate necessary scoped restarts, with safe checkpoints, observable reason and explicit limitations.
5. **Do not claim a new `pyproject.toml` solves stale code.** Installing a package into the same already-running interpreter does not refresh its cached module objects.
6. **Do not secretly use draft code.** “Latest” means approved and activated, not the latest uncommitted local edit.
7. **Do not broaden permissions.** An updater may change the implementation of a previously authorized action only under the owner's existing verified effect contract. If effects change, new authorization/validation is mandatory.
8. **Do not duplicate runtime control planes.** If equivalent proven system-wide activation already exists, preserve it and add tests/integration only.
9. **Do not convert one passing synthetic test into an all-surfaces claim.** Cross-route proof and honest limitations are mandatory.
10. **Do not auto-solve user problems by evolving the system.** Normal work should remain normal work and use currently active capabilities.
11. **Do not hold the repo hostage for nonexistent perfect atomicity.** Where only bounded consistency is technically possible, state the compatibility window and risks precisely.
12. **Do not turn documentation and external research sources into executable authorities.** Prompt files are instructions only when explicitly accepted by their authorized owner; source texts are untrusted inputs otherwise.
13. **Do not create a second kernel.** L0/CODE and its existing ports are the single trusted root. Activation/repair managers and host supervisors are subordinate external implementations, never a sovereign policy plane.
14. **Do not bloat L0.** Prefer existing port composition; no AI models, shell, network, task scheduler, dynamic extension imports, repair scripts or mutation logic in L0 seed. Maintain minimal boot and manifest closure.
15. **Do not promise that any error can always be repaired.** Preserve unaffected work, refuse unsafe effects, record irrecoverable failures, and escalate when evidence, authorization, dependencies or trustworthy rollback are unavailable.
16. **Do not hide errors or reset whole repo to "recover".** Repairs must be scope-owned, evidence-based, independently validated, reversible when safe and non-destructive to peer agents.
17. **Do not treat an external process supervisor as a new core.** It provides mechanical availability/last-good bootstrap and is forbidden from independently selecting unapproved patches or changing governance.

---

## 13. Required durable evidence and final closure

Use `reports/runtime_freshness/` or an existing authoritative evidence home if W00 confirms one. At minimum generate:

```text
reports/runtime_freshness/
  W00_CURRENT_STATE.json
  COVERAGE_INVENTORY.json
  IMPACT_GRAPH_EVIDENCE.json
  VERSION_BINDINGS.json
  PROMOTION_ACTIVATION_SEPARATION.json
  FRESH_PROCESS_EXECUTION.json
  WORKER_REPLACEMENT.json
  PROMPT_CONFIG_POLICY_REFRESH.json
  AMM_CAMPAIGN_CONTINUITY.json
  HTTP_CLI_MCP_E2E.json
  BROWSER_UI_E2E.json
  CORE_RESTART_RECOVERY.json
  SCHEMA_COMPATIBILITY.json
  SECURITY_AND_RESOURCE_REGRESSIONS.json
  PERFORMANCE_COMPARISON.json
  FAILURE_INJECTION.json
  L0_KERNEL_ARCHITECTURE_AND_MINIMALITY.json
  L0_PRODUCTION_INTEGRATION.json
  FAULT_CLASSIFICATION_AND_ISOLATION.json
  UNAFFECTED_SERVICE_CONTINUITY.json
  EXTERNAL_REPAIR_RED_GREEN.json
  L0_LAST_GOOD_BOOTSTRAP.json
  REPAIR_IMPASSE_AND_CIRCUIT_BREAKER.json
  REPAIR_UI_E2E.json
  RECOVERY_MATCHED_ABLATION.json
  MATCHED_ABLATION.json
  CRITERION_TABLE.json
  EVIDENCE_MANIFEST.json
  FINAL_CLOSURE.json
```

Some artifacts may be equivalent output under existing evidence tooling, but retain a single manifest mapping every criterion to immutable evidence. Do not fabricate empty pass files. Generated artifacts have independent verifier paths; a human report is explanatory only, not authoritative evidence.

**Independent closure interface** (adapt to actual existing tooling; do not invent a CLI that isn't implemented):

```sh
python3 tools/doubletake_evolve/runtime/host_workload.py -- \
  python3 -m tools.doubletake_evolve.runtime_activation.final_closure --verify
```

This command is a *required implementation target*, not a claim that the module exists today. It must check bound source identity, dependency closure, authenticity of owner approvals, real effect/consumer observations, criterion rows, test provenance, adversarial cases, regression status and retained HEAD. It must not call the same unverified predicate that generated a row as its independent proof of that row. Tests include tampering with records, replacing source after a proof, deleting one needed route, and claiming ACTIVE with no consumer receipt.

Final states:

- `COMPLETE`: all A01–A52 satisfied, **the original L0 seed remains minimal and authoritative**, actual production routes are verified as L0-governed, and fault containment/real repair have executed, real routes proven, no unresolved critical/high regression, source-bound artifacts verifiable, resource limits respected.
- `PARTIAL_WITH_BLOCKERS`: worthwhile integrated subsets complete with precise remaining high-priority blockers and safe continuations; do not imply global freshness.
- `BLOCKED`: no safe permitted path to progress; preserve state and identify required operator action.
- `FAILED`: acceptance or governance violated, evidence corrupt, or nonrecoverable regressions; rollback/containment documented.

**Never use an estimated percent as final sign-off.** Percent may be displayed for operator convenience only when accompanied by independently scored criteria and their weights. A passing suite is insufficient without actual consumer-version proof.

### Definition of done for the entire mission

The mission is complete only when these user statements are **operationally true**:

1. “When I normally ask DoubleTake to do something, I know which approved code, tools, prompts, policies, models, and worker versions it actually used.”
2. “When I or DoubleTake update a behavior, new work uses the newer validated active implementation automatically when safe, without restarting unrelated parts.”
3. “If a restart, refresh, migration, or external handoff is necessary, DoubleTake handles or explicitly reports it without pretending the update is already active.”
4. “My ongoing research, Bank campaign, agent sessions, UI conversations and other tasks survive changes with correct version consistency and no duplicated side effects.”
5. “I can distinguish ‘source changed’, ‘approved’, ‘promoted’, ‘deployed’, ‘effective’, ‘stale’, and ‘blocked’ from a reliable runtime report.”
6. “A failed upgrade cannot silently sacrifice last-known-good behavior, permissions, model safety, or committed state.”
7. “DoubleTake still has **one minimal L0 core**. The manager, agents, repair logic and evolving runtime are delegated components, not new kernels.”
8. “If an updated tool or subsystem breaks, unaffected functionality continues; a known-good version is restored when safe, and a governed external repair can fix the defect without hijacking core authority.”
9. “If the core itself breaks, a trusted retained kernel can be mechanically restored or the system refuses safely; it does not claim a dead kernel can diagnose itself.”
10. “An unrepaired fault cannot trap DoubleTake in an infinite loop or consume resources indefinitely while other useful work remains available.”

---

## 14. Execution instructions to the implementing agent

**You are implementing this mission in DoubleTake; do not just review or summarize it.**

1. Read this entire prompt plus current `AGENTS.md`, the canonical L0 README/extension ABI/invariants and current seed proofs. Prove L0 is the **only** kernel and audit actual production wiring before proposing any new supervisory module. Establish the actual checkout and shared `main` rules. Confirm existing AMM if already implemented; if not, implement the parts independent of AMM first and mark W08 blocked until it exists—do not fabricate its interface.
2. Run W00 as a bounded audit and publish the measured gap map, including existing L0-to-production wiring and recovery/repair authority boundaries. If an existing live update/activation mechanism already satisfies a requirement, record its passing evidence and **do not replace it**.
3. Prioritize retaining a clean, provably minimal L0; wire any verified missing L0 governance ingress using external adapters; then prioritize the smallest common version-binding contract, immutable release handling, existing owner approval checks, and real `capability_runtime.py`/synthesized-tool freshness issue. Those are the earliest decisive live behavior gaps, not opportunities for premature architecture refactoring.
4. Implement W17–W23 as first-class requirements (not optional follow-up) while integrating W00–W16. Implement each work package in dependency order unless measurements justify a different order; state which dependency or blocker caused a reorder. Preserve all preexisting research, AMM, Borg and evolution work.
5. Do one bounded actual-path RED→GREEN per significant implementation; include ablations, independent negative controls and regression checks before accepting the changed runtime.
6. Every test, subprocess, build, model invocation and migration rehearsal must obey `runtime/host_workload.py` and `AGENTS.md`. Use existing models/packages/tooling; no unauthorized installs/downloads. Avoid exhaustive unguarded suites that crash the Linux host.
7. After each work package: record exact code ownership, current HEAD, change-set, tests, benchmarks, proof identifiers, admitted limitations, next runnable step, and scope of preserved peer work; commit only owned verified changes.
8. Where a line of work is blocked, park it with a precise cause and move to independent value-bearing work if safe. Do not create fake progress through cosmetic reports. Never conflate frozen baseline acceptance with deployment acceptance.
9. Before closure: run unmodified L0 seed proofs, prove no second kernel/no forbidden import and a real failure→isolate→repair/rollback→resumed-task trace with unrelated task continuity. Then verify cross-surface readiness from a freshly started process **and** an already-running process undergoing update. Test long-lived, short-lived, client, and core-restart classes. Verify that unchanged normal user prompts still behave correctly.
10. Publish `FINAL_CLOSURE.json` only through source-bound independent verifier. Include independent checks that `L0/CODE` stayed seed-minimal, the L0 production route was proven, and a failed repair cannot self-authorize a patch. `COMPLETE` is forbidden while required routes remain unwired, UI tests fail, rollback is unsafe, or any tested unit uses stale code while claiming current.

### L0 acceptance commands and explicit anti-kernel audit

Run existing canonical commands from the repository root, under the current host guard when appropriate, without modifying the pass conditions to obtain a green result:

```sh
make seed-boot
make prove-seed
make build-seed
```

Also execute the current available equivalent of `make run` or direct `KernelService.run_turn` with production seed composition (honest offline baseline). Inspect `L0/manifests/SEED_PACKAGE_MANIFEST.yaml` and reject undeclared L0 files. Verify `KernelService.run_turn` remains the single public L0 turn entrypoint and external modules are absent from L0 runtime imports. These commands are required **targets at implementation time**, not test results claimed by this document. Respect existing `AGENTS.md` and avoid bare commands if the current guard requires wrapping.

A distinct **real production integration test** (Chat API/MCP/CLI) must show what currently reaches L0; the seed tests alone do not establish it. If no adapter exists, implement the smallest external adapter and repeat. Do not claim closure on a standalone seed demo.

### Initial implementer status format

```text
MISSION: DOUBLETAKE_MINIMAL_L0_KERNEL_SYSTEM_WIDE_LIVE_UPDATE_AND_SELF_REPAIR_MISSION_v2
CURRENT_HEAD: <measured SHA>
AMM_STATUS: verified-live | partial | not-present | unknown
L0_KERNEL_STATUS: seed-proof result; ABI/manifests; minimality baseline
L0_PRODUCTION_PATH: actual API/CLI/MCP L0 call edge or named wiring gap
EXISTING_FAULT_AND_REPAIR_OWNERS: observed code paths; no second kernel
EXISTING_ACTIVATION_OWNER(S): <actual paths and methods>
REPRODUCED_STALE_BEHAVIOR: <path, input, old output, expected new output>
SCOPE_MAP: <counts of production-reachable consumer classes, stale, fresh, blocked>
FIRST_SMALLEST_FIX: <specific owner path and failing test>
HOST_BUDGET: <actual currently configured guard>
PEER_CONFLICTS: <paths and safe coordination>
NEXT_EXECUTABLE_ACTION: <smallest measurable change>
```

### Final implementer output format

```text
MISSION: DOUBLETAKE_MINIMAL_L0_KERNEL_SYSTEM_WIDE_LIVE_UPDATE_AND_SELF_REPAIR_MISSION_v2
BASELINE_HEAD: <SHA>
FINAL_HEAD: <SHA>
SCOPE: all ordinary, evolving and repair work under the one minimal L0 kernel
L0_SEED_PROOFS: <make seed-boot/prove-seed/build-seed and invariant evidence>
L0_PRODUCTION_WIRING: <actual API/CLI/MCP call edge evidence>
KERNEL_MINIMALITY: <before/after LOC, dependencies, public interfaces, forbidden-import proof>
REAL_FAULT_RECOVERY: <injected defect; isolated service; healthy service; repair/rollback receipt>
W00-W23: <per-package evidence status>
A01-A52: <per-criterion pass/fail/refusal evidence>
ACTIVE_VERSION_PROOFS: <receipts by normal public route>
STALE_OR_UNSUPPORTED_CLASSES: <exact list, no omissions>
SCOPED_RESTARTS: <which classes and why>
ROLLBACK_AND_STATE_MIGRATION: <real observed results>
HOST_RESOURCE_AND_PERFORMANCE: <before/after metrics>
CROSS_MISSION_REGRESSIONS: <all known failures with attribution>
INDEPENDENT_CLOSURE: COMPLETE | PARTIAL_WITH_BLOCKERS | BLOCKED | FAILED
EVIDENCE_MANIFEST: reports/runtime_freshness/EVIDENCE_MANIFEST.json
FINAL_CLOSURE: reports/runtime_freshness/FINAL_CLOSURE.json
NEXT_ACTION: <exact blocker/remedy if not complete>
```

**The essential success criterion:** With **one minimal L0 kernel** governing every admitted operation, DoubleTake must run its **latest activated, approved, compatible implementation for everything it does**, and **contain, recover from, or delegate governed repair of errors without unnecessarily stopping unaffected functionality**. Non-hot-swappable or irrecoverable failures must be reported truthfully. Neither a modified source file nor an asserted repair receipt proves execution, activation, or recovery.
