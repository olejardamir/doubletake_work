# DOUBLETAKE_GOVERNED_INGESTION_AGENT_EVOLUTION_MASTER_v3

> **EXECUTION MISSION — READ COMPLETELY BEFORE CHANGING CODE**
> Deliver a verified, incremental, cleanly governed **DoubleTake-native** data-ingestion capability. This is an evolution of DT itself, not installation of an external product or a redesign of its seed kernel.

## Document Control

| Field | Requirement |
|---|---|
| Version | **v3.0 — architectural correction, complete integration and evidence closure** |
| Supersedes | `DT_Evolution_Prompt_Governed_Ingestion_Agent_v2.md` |
| Target | The **currently checked-out** DoubleTake repository; authoritative remote if needed: `https://github.com/olejardamir/DT` (private; do not assume accessible in every environment) |
| Mission | Governed Data Ingestion Agent, using synthetic data, local fixtures and local test servers |
| Purpose | Requester describes a data need → DT interprets and drafts a restricted request → policy validates → an independent human approves → DT ingests through controlled connectors → DT verifies, audits and reports without granting access or exposing secrets |
| Scope | Reusable DT capability and research demonstration; **not** production deployment or adoption for any employer, client, or organization |
| Privacy | No real organization data, real credentials, confidential project artifacts or organization-specific integrations; synthetic test data and localhost fixtures only |
| Source restrictions | Evolve DT-owned implementations using public engineering principles; no copied proprietary source, undeclared imported implementations, borrowed internal architecture or third-party code pasted into DT |
| Authority | `AGENTS.md` and the **current** L0/L1/L2 governance contracts take precedence over suggested paths in this mission; no bypass, broad rewrite, or inferred permission |
| Outcome | Tests, real local executable functionality, reproducible evidence, compatibility, recovery and a final honest status report |
| Employment/IP boundary | The author must resolve any applicable employer intellectual-property, confidentiality, outside-work or ownership obligations separately. Completing local tests does **not** resolve those obligations |

---

## 0. Operating Directive and Precedence

**You are the coding/evolution agent operating on DoubleTake. Execute the mission; do not merely summarize or produce plans.** Inspect reality first, then implement within valid DT governance. Work in bounded verifiable increments, preserve all validated pre-existing behavior, and explicitly record barriers instead of guessing.

### 0.1 First actions (mandatory)

1. Read the complete current `AGENTS.md`. Its operator limits and branch/ref policy override all examples in this prompt. Record its digest and any instructions relevant to this mission.
2. Record current `git rev-parse HEAD`, `git status --porcelain`, runtime/platform, build/test tools and existing service ownership. Do not overwrite concurrent user changes; do not assume an empty working tree.
3. Read `README.md`, `L0/README.md` (if present), `L1/README.md`, `L2/README.md`, `L1/docs/00_L1_SYSTEM_GOAL.md`, `L1/docs/03_L1_WHOLE_SYSTEM_PSEUDOCODE.md`, `L1/docs/05_L1_SHARED_TYPES_AND_INTERFACES.md`, `L1/docs/FIC_GOVERNANCE_INDEX.md`, relevant standards, registries and FICs.
4. Inspect code/tests for all mechanisms enumerated in Section 5; use precise search and actual file contents, not the path table alone. Identify whether each mechanism is **implemented and used**, incomplete, placeholder, or absent.
5. Inspect the **current** mission manager, evolution controller, three-phase evolution policy, component registry, update/activation/rollback facilities and validation harness. Do not invent an alternative coordinator, registry, lifecycle or permanent kernel service.
6. Inspect `tools/doubletake_evolve/runtime/host_workload.py` and its required invocation. All mission tests, proof generators, builds and experiments must use the workload guard as specified by `AGENTS.md`. Never circumvent its resource limits.
7. Record exact existing baseline test outcomes **before** change. Failing or unresolved existing tests are reported, not hidden or relabeled as success.
8. Create a **bounded L1-governed** impact/ownership/duplication matrix and one FIC per genuinely needed implementation unit before code changes. If existing DT processes require a different document shape or location, use those current processes.

### 0.2 Non-negotiable hierarchy

- **L0:** the minimal, independently runnable seed kernel. **Do not create `L0/CODE/governed_agent/` as a new framework.** Reuse existing interfaces. Touch L0 only if a specifically reviewed FIC proves a minimal contract change necessary; demonstrate that a pure adapter in the outer runtime cannot meet the requirement. Never put ingestion business logic, HTTP, secrets storage, approval databases, schedulers, models, UI or agent loops in L0.
- **L1:** governs decomposition, authorization, implementation planning, evidence, evaluation, controlled promotion and rollback. Reuse its actual FIC/SIB/ES/EQC or successor system. Never let L2 authorize changes directly.
- **L2:** ingestion specialization profile, evaluation plan, blueprint, integration boundaries and handoff material. **No L2 runtime.** Use existing profile structures rather than adding a parallel scheme.
- **Implementation:** place new executable capabilities in the **current authorized runtime/package area** (historically `tools/doubletake_evolve/...`, or L4 *only if* its creation is explicitly L1-authorized). Never create L3/L4/L5 merely to satisfy this prompt.
- **Independent evolution:** each component must be versioned, replaceable and independently verifiable. Use DT's existing implementation/activation mechanisms; avoid a compulsory whole-product restart where safe versioned activation is supported.
- **Governance:** agent text cannot approve a request, award itself new tools/permissions, reconfigure its own controls, authorize code promotion, or execute an unapproved ingestion job.

### 0.3 Execute, checkpoint, resume

For each work package (WP): inventory and map reuse → write FIC if change necessary → lock baseline → implement smallest executable vertical slice → run focused tests → attack negative cases → record evidence → accept/promote only under DT's authorized gate → checkpoint → continue. Record progress in a **durable mission-state artifact** owned by the existing mission manager (or, only if it has no such support, an L1-approved report under `reports/governed_ingestion/`).

The checkpoint must record `mission_id`, schema/version, source HEAD, clean/dirty state, WP and gap statuses, FIC IDs, changed-file digests, exact validation commands/exit codes, evidence paths/digests, activation version, open risks, dependencies and next runnable action. A successor agent can load it, verify its integrity and **resume without repeating accepted work**. Stale evidence after code/contract changes must be revalidated. Do not claim that checkpointing alone guarantees safe resumption.

Stop an *unsafe implementation action* when authorization, policy, secrets or integrity are uncertain; continue independently with other authorized work. Do not create invented approvals or weaken gates to achieve mission closure. If no measurable value results from a proposed change, record `NO_CHANGE` or `REJECTED` with evidence.

### 0.4 Core research guardrails

- Use **synthetic** content and local test servers; no real identities, external services, organizational schemas, real secrets or real ingestion destinations.
- Any use of an externally hosted LLM for optional model comparisons requires separate authorization and strict synthetic context. Do not make remote access a core acceptance dependency.
- Do not add mandatory Docker, GPU, cloud, downloaded model weights, SaaS identity platforms, or external data providers.
- Do not confuse proof of a local research mechanism with security certification or fitness for production.
- Prefer no new dependencies. If a mature cryptographic library is necessary, review its license, pin the version and document why the standard library is insufficient; never invent cryptography.

---

## 1. Goal, Capability Boundary and Definition of Done

### 1.1 Desired end-to-end behavior

A synthetic requester uses plain language to request a permitted inward-only ingestion. DT resolves that request into a **schema-constrained draft**, checks requester/executor rights and the approved local catalogue, presents a specific immutable operation for independent approval, and runs a bounded job **only after authorization**. The runner fetches from an allowed local test source, quarantines and inspects under a stated test policy, lands the validated artifact atomically in an authorized local target and reports the result and provenance. The agent does not execute directly, expand allowed tools, see plaintext secrets, export landed data, change access rights or approve itself.

The delivered work consists of **two distinct parts**:

- **Reusable DT governance mechanisms** (outer-runtime modules/adapters unless an exceptional FIC-authorized kernel contract change is proven): identity and authorization context, policy decision bridge, approval lease and revalidation, execution boundaries, secret references, audit/evidence, typed adapter contracts, lifecycle management, evaluation and security conformance.
- **Optional governed ingestion specialization**: profile, restricted dialogue/structured request generation, catalogue, connector registry, approval-controlled runner, local API, UI, scheduled retrieval, synthetic demonstration and documented trade-offs.

### 1.2 Definition of Done (whole mission)

- G1–G28 each have supported `CLOSED` or `DECISION_READY` status (or a clearly documented explicit BLOCKED/PARTIAL verdict: **never silently count as closure**). G29–G32 are accurately outside the local test scope, with required integration questions documented.
- Each accepted capability has exercised **real behavior**, passing a linked positive test, negative/security tests, and adapter-conformance tests; no echo-only proof, invented command, success-by-import, incomplete stub or report-only closure.
- Every Section 7 scenario and Section 4 security invariant is exercised in the intended synthetic environment. Failures remain visible. If a scenario cannot be executed, it is `UNRUN`/`BLOCKED`, not passed.
- The full local end-to-end demonstration works without network egress to third parties, cloud, GPU, model downloads, or container requirements.
- The work passes mission-focused regression suites, applicable L0/L1/L2 proofs and current full-product validation **to the extent those commands resolve**; unresolved pre-existing validation defects are disclosed separately and are never hidden under `PASS`.
- Existing DT missions continue to operate; unchanged L0 runs independently. If applicable, versioned activation, in-flight draining and rollback are demonstrated.
- Deliverables in Section 10 exist, link to actual executed evidence, are reviewable and report exact status (Section 9).
- Completed mission does **not** mean deployment-ready or organizationally approved.

## 2. Gap Register

These are the design gaps this work must close. Closure types:

- **Close:** a working, tested capability answers the question.
- **Decision-ready:** the decision belongs to an adopting organization; DT tests feasible representative options, explicitly distinguishes untested real-world alternatives, and supplies a conditional recommendation supported by evidence.
- **Out of DT scope:** cannot be answered without a real organizational environment; DT records it and supplies what an organization would need to answer it.

| ID | Gap | Closure | Work package |
|---|---|---|---|
| G1 | Which identity executes a request: the agent's own service identity or the requester (delegated) | Decision-ready | WP2, WP14 |
| G2 | Keeping the agent within the requester's own rights | Close | WP2 |
| G3 | Who may trigger execution, and the effect of letting requesters trigger it directly | Decision-ready | WP2, WP14 |
| G4 | Shared versus dedicated execution target for agent-originated requests | Decision-ready | WP3, WP14 |
| G5 | Hosting independence and deployment packaging | Decision-ready | WP13, WP14 |
| G6 | Model choice and minimum model capability | Decision-ready | WP8, WP14 |
| G7 | What context the agent receives, and what it must never receive | Close | WP8 |
| G8 | Boundary of actions the agent may take | Close | WP4 |
| G9 | Human confirmation points and approval granularity | Close + Decision-ready | WP6, WP14 |
| G10 | Free-form versus constrained configuration generation | Close + Decision-ready | WP5, WP14 |
| G11 | Validation before anything is submitted | Close | WP5 |
| G12 | Reporting progress, failures and outcomes to the requester | Close | WP10, WP12 |
| G13 | Approved catalogue of sources and destinations, who approves requests and changes, and governance of changes | Close | WP5, WP6 |
| G14 | Onboarding credentials for a new source | Close | WP6, WP7 |
| G15 | Referencing secrets without exposing values | Close | WP7 |
| G16 | Preventing outbound transfers and data exfiltration | Close | WP4, WP9 |
| G17 | Evaluating and auditing agent behaviour | Close | WP8, WP11, WP12, WP14 |
| G18 | Supported user journeys: one-time retrieval, recurring retrieval, API retrieval, user-supplied file | Close | WP5, WP9, WP10 |
| G19 | Governance metadata on each request (owner, purpose, classification, retention, destination) and enforcement of retention | Close | WP5, WP9 |
| G20 | Access to landed data without the agent granting access | Close | WP10 |
| G21 | Operations: retries, idempotency, timeouts, scheduling, emergency suspension, monitoring, diagnostics | Close | WP6, WP9, WP11 |
| G22 | Adding new source types without changing core code | Close | WP9 |
| G23 | Agent versus non-agent alternatives (guided form, templates, hybrid) | Decision-ready | WP12, WP14 |
| G24 | Usability: how much technical knowledge a requester needs | Decision-ready | WP14 |
| G25 | Different network zones for external versus internal sources | Close | WP3, WP9 |
| G26 | Integration readiness: replacing local implementations with real systems | Close | WP13 |
| G27 | Threat model and risk register | Close | WP15 |
| G28 | Evidence register: what is tested versus inferred | Close | WP15 |
| G29 | Choice of real identity, policy, secret, execution and approval systems | Out of DT scope | WP13 supplies contracts and conformance suites |
| G30 | Which users, sources and scope an organization adopts | Out of DT scope | WP14 supplies evidence to inform it |
| G31 | Behaviour of real platforms (delegated sign-in, real access controls, real execution engine validation) | Out of DT scope | WP13 supplies the integration test plan |
| G32 | Organizational approvals: security review, model approval, hosting approval | Out of DT scope | WP15 supplies the threat model and evidence pack |

## 3. Constraints, Architecture and Component Ownership

### 3.1 Technical constraints

- Preserve the checked-out repository's Python baseline (currently `>=3.11`), existing FastAPI architecture, `jsonschema`, testing framework and existing React UI when actually present. Discover real versions rather than assuming a new stack.
- Reuse and extend existing DT tool gateway, governance bus, tool contracts, profile schemas, event log, model adapters, audit and redaction utilities. **Inventory before editing.** A file's presence alone does not prove functional implementation.
- Keep L0 independent of higher layers and remote services. If L0 must be touched, require a narrow FIC stating old/new interface, affected callers, proof that an outer adapter is inadequate, compatibility checks and explicit authorization.
- All mutable ingestion, model, IO, policy storage, scheduling and UI behavior belongs outside L0; L2 remains non-executable. Avoid parallel registries, duplicated policies and new privileged central managers.
- Provider and connector implementations satisfy versioned Python `Protocol`/typed-interface conformance suites. Their installation, enablement, activation and rollback use **the current DT mechanism**, not new ad hoc global imports.
- Synthetic data only, with local HTTP/SFTP servers when such transports are being tested. **Inward-only data ingestion** means outbound HTTP connection initiation solely to explicitly permitted test *sources* is allowed; no arbitrary exfiltration, upload, unapproved callback, model-data disclosure or onward publishing is permitted.
- Tests, builds and proof workloads run through `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` or its **current `AGENTS.md`-mandated** equivalent. If a full suite exceeds the host guard, run approved, serial, bounded sub-suites and record `TIMEOUT` or `BLOCKED` where appropriate; do not bypass the guard or silently convert sub-suites to a full-suite pass.
- Generic publicly known engineering only. No employer or client information, and no copying third-party source code to avoid licensing confusion. Record dependency licenses and provenance for any necessary new packages.

### 3.2 Ownership and proposed placement (verify live repository before creating)

| Kind | Preferred placement | Authority and rule |
|---|---|---|
| Root-goal and FIC contracts | Existing `L1/docs/`, `L1/fic/`, registries and evidence locations | Follow current L1 FIC process; no new governance system |
| Specialization profile, blueprint, evaluation and integration boundaries | Existing `L2/profiles/`, `L2/blueprints/`, `L2/evaluation_specs/`, `L2/integration_specs/` | Proposal-only, no L2 implementation |
| Reusable governance **adapters** | `tools/doubletake_evolve/governed_agent/` or the closest currently authoritative runtime equivalent | Not L0; first search for an existing equivalent and **extend it** |
| Ingestion agent, catalogue, runner and adapters | `tools/doubletake_evolve/ingestion/` or a currently authorized module package | No duplicated mission manager or separate activation engine |
| Reusable schemas | Existing `schemas/` or current schema authority | Version, cross-reference existing schema and add migrations |
| Tests and fixtures | Existing `tests/`, module-local tests, `fixtures/ingestion/` where permitted | Preserve discovery conventions; synthetic only |
| API | Existing API router package and `api_server.py` after resolving route order | Enforce server-side policy; avoid duplicated authentication |
| UI | Existing `ui/src/` component and API client structure | No separate SPA or alternative UI framework |
| Audit and experiment evidence | Existing evidence registry and `reports/governed_ingestion/` (runtime generated) | Structured records, digests, provenance, not vanity PASS files |
| Operator-facing docs | `docs/governed_agent/` | Explain test-only guarantees, limitations, interfaces and activation |

**No directory in this table is permission to create it blindly.** Every proposed target must appear in the ownership matrix and authorized FIC. If an existing module already owns the behavior, extend that module and adjust its tests.

### 3.3 Independent evolutionary participation

Implement contract versioning and runtime binding so any new component can subsequently be evolved by DT's normal mechanism. New component revisions must: (1) expose capability/contract version, (2) carry compatibility and dependency metadata, (3) be tested in isolation, (4) validate against live callers, (5) atomically activate by DT's authorized mechanism where supported, (6) drain/pin in-flight jobs to the previous version as necessary, and (7) roll back failures. **No in-place arbitrary Python hot reload of security-sensitive modules or forced mid-transaction swaps.** If live activation does not yet exist, implement against a stable interface and record deferred activation work; do not pretend restartless operation is proven.

## 4. Mandatory Security and Adversarial Proof Requirements

Every requirement needs an executable negative test and evidence trace. Treat restrictions as defense-in-depth rather than claiming absolute security.

| Area | Executable security requirement |
|---|---|
| Loopback-only research service | API and UI bind `127.0.0.1`/`::1` only where supported; validate actual listening addresses and ensure no public exposure |
| Authentication | Reuse existing DT session/auth infrastructure where capable. Otherwise introduce a **scoped, outside-L0**, test-only local auth adapter with secure password hashing, random short-lived session identifiers, server-side revocation and per-role checks. No shipped default credentials |
| Session/browser protection | Enforce allowed origins, CSRF protection for authenticated browser mutations (as appropriate to token/cookie transport), no credentials in URLs, explicit CORS restrictions, constant-time checks where relevant and logout/session expiry |
| Separation of duties | No self-approval of request, catalogue, credential or policy changes. Require independent effective identities; prevent alternate sessions/roles for the same underlying principal from circumventing this |
| Least authority | An execution must satisfy rights of requester **and** executor **and** current destination/source rules; evaluate at approval and at use. Do not assume identity intersection is equivalent to an actual delegated credential |
| Data visibility | Requester sees only own requests and permissible audit summaries; approvers see only assigned work; auditor gets appropriately sanitized records; reject insecure direct-object references |
| Strict tool boundary | Only registered/certified tools named in active profile; **agent cannot directly call `execute`**, change catalogue/policy, approve itself, create arbitrary connectors, read secret values or grant data access |
| Untrusted model output | Treat as data, parse strictly to typed schema, enforce length/field/enum restrictions and validate independently; never execute code or treat generated text as policy/authorization |
| Untrusted source content | Exclude raw retrieved data from all agent *instructions*. For this mission do not send raw content to a model at all; source metadata is bounded, filtered and treated as untrusted |
| Input/file limits | Enforce request size, file count, archive depth, compressed and expanded bytes, timeouts, per-step limits and concurrent execution quotas |
| Parsing | `yaml.safe_load` for explicitly permitted YAML; never `pickle`, `eval`, user-derived `exec`, untrusted shell interpolation, unsafe deserialization or unchecked document macros |
| SSRF and DNS rebinding | Allow only catalogue endpoints; resolve/validate **every connection address**, including redirects and reconnects; pin approved address for the connection; reject metadata IPs, unexpected link-local/multicast/private addresses, mismatched schemes and DNS rebinding. Explicit localhost test exceptions must be narrowly configured |
| Transport | Verify TLS for HTTPS; enforce host-key pinning for SFTP; refuse insecure downgrade, unapproved redirect, proxy escape and source-host alteration |
| Archive/paths | Reject `..`, absolute paths, symlinks/hardlinks or unsafe members; enforce decompression ceilings; reject path race/symlink traversal within landing/quarantine; use safe atomic moves |
| Egress | Only approved source fetches may initiate network traffic; deny external output/upload destinations, callback URLs, arbitrary model APIs, dynamic tool installation and telemetry by default. Test with denied simulated exfil endpoints |
| Secret handling | Only handles/references enter plans; resolution occurs inside the authorized connector at execution. Credentials never appear in model input, request schema payloads, logs, audit, API, UI, telemetry or error records. Use established cryptographic primitives, OS key store or explicitly controlled synthetic test secrets |
| Audits | Append-only at the application boundary with a hash chain and verification; **explicitly label that a locally writable chain is not independently tamper-proof**. Where warranted add an independent local read-only anchor/digest and test attack/rewrite detection limits |
| Approval integrity | Tie approval to exact canonical request digest + catalogue/policy revision + identities + target + limits + expiry; execute only if approval valid, current and unspent. Revocations and suspension win over stale approvals |
| Concurrent requests | Prevent double execution with atomic claim/lease, run-specific idempotency keys and recovery rules; test parallel workers and crashes |
| Dependency assurance | Pin and document introduced packages; use no cloud, third-party telemetry or software downloads at execution/test time by default |
| Models | Deterministic mock is mandatory for functional security evidence. Optional real model must be open-code compliant, preapproved and receive only synthetic context; results segregated from mock results |
| Error handling | Safe outward errors without sensitive paths, credentials or stack traces; internal diagnostic references retain traceability after sanitization |
| Malware inspection claims | Include type/size/known-test-signature policy and quarantine; the standard anti-malware **test signature is not real malware detection**. Do not claim clean content from that check; label risk and fail closed for formats lacking sufficient inspection |
| Rate limits | Per-user, per-role, per-source and system-level quotas; audit rate-limit denials without exposing secret inputs |
| Suspension | Emergency stop blocks new submissions/approvals/executions; ongoing jobs must be cancelled or safely drained according to a documented policy; status and audit reads may remain authorized |

### 4.1 Security invariants

`SI-01` No execution before schema validation, current policy checks and valid independent approval.  
`SI-02` No agent/tool/provider path to bypass approval or request arbitrary side effects.  
`SI-03` No requester expansion of access, and no agent-granted read permissions.  
`SI-04` No plaintext secrets in any persisted or model-visible artifact.  
`SI-05` No forbidden outbound data flow, including redirects or indirect side-channel paths within the tested boundary.  
`SI-06` No cross-user observation of private request or audit data.  
`SI-07` No successful landing of rejected/quarantined/unapproved material.  
`SI-08` Recurring, resumed, retried and concurrently executed jobs obey the **same current authorization** as an original job.  
`SI-09` No change to L0 independence or existing governance authority.  
`SI-10` No false or stale PASS/progress claim.

Every invariant must map to `source → implementation owner → test(s) → outcome → evidence digest`. A failed invariant **blocks promotion** of affected capabilities even if a functional demonstration succeeds.

## 5. Reuse Map and Known Repository Anchors

The locations below existed when this prompt was prepared; **the working checkout is the authority**. Verify present status, interfaces, FIC ownership and actual callers first.

| Mechanism | Existing or likely path | Action |
|---|---|---|
| L0 governed tool gateway | `L0/CODE/tool_gateway/tool_gateway.py` | Reuse policy checks and governance bus; avoid a second tool execution path |
| Tool contracts/registry | `L0/CODE/tool_gateway/tool_contracts.py`, `L0/CODE/tool_gateway/tool_registry.py` | Register adapters through current supported API; `ToolRegistry.register(contract, handler)` was observed |
| Policy and certification | `L0/CODE/tool_gateway/tool_policy.py`, `L0/CODE/tool_gateway/tool_certification.py` | Reuse declared side-effect and approval metadata; avoid new kernel security subsystem |
| Governance request/decision | `L0/CODE/core_kernel/contracts/governance_contracts.py` | Map outer-runtime policy context through existing contracts |
| Seed governance ports | `L0/CODE/kernel_composition/local_seed_ports/tool_gateway_adapter_port.py`, `local_governance_port.py` | Connect via existing port interfaces if appropriate, no imports from L1 into L0 |
| Profiles | `L0/CODE/profiles/agent_profile_schema.py`, `profiles/` | Reuse existing runtime profile interpretation; L2 owns specialization proposal |
| Review and promotion schemas | `schemas/human_review_record.schema.json`, `schemas/promotion_record.schema.json` | **Distinguish request approval from code-promotion/release approval**; reuse compatible human-review fields, do not conflate the semantics |
| L1 authority | `L1/docs/00_L1_SYSTEM_GOAL.md`, `03_L1_WHOLE_SYSTEM_PSEUDOCODE.md`, `05_L1_SHARED_TYPES_AND_INTERFACES.md`, `L1/fic/` | Govern bounded implementation units and evidence |
| L2 specs | `L2/profiles/`, `L2/blueprints/`, `L2/evaluation_specs/`, `L2/integration_specs/` | Define the ingestion specialization; keep spec-only |
| Redaction | `tools/doubletake_evolve/evidence_redaction/redactor.py` | Reuse central boundary sanitization, test known and unknown secret patterns |
| Event log | `tools/doubletake_evolve/run_event_log.py` | Extend current tracing/evidence chain, not parallel incompatible logs |
| Providers | `tools/doubletake_evolve/providers/mock_provider.py`, `api_provider.py` | Mock mandatory; real provider strictly optional |
| API/routers | `api_server.py`, `tools/doubletake_evolve/api/` | Route under existing app and review route ordering vs catch-all |
| UI | `ui/src/App.jsx`, `ui/src/components/app/MenuBar.jsx`, `ui/src/api/client.js` | Extend current app without new framework |
| Experiment guard | `tools/doubletake_evolve/runtime/host_workload.py` | Use for tests, proofs and builds per `AGENTS.md` |
| Validation matrix/readiness | `tools/doubletake_evolve/validation_matrix.py`, `tools/doubletake_evolve/product_readiness/full_suite.py`, `docs/VALIDATION_MATRIX.md` | Check real command resolution, not only presence in matrix |
| Mission manager, components, activation | **Discover current canonical implementation** rather than hard-code path | Resume/activate through it; do not create duplicate control plane |

### 5.1 Pre-change inventory artifact

Create a machine-readable `reuse_and_impact_matrix.json` under the mission's evidence root containing, per proposed feature:

```json
{
  "feature": "approval_lease",
  "existing_owner": "<real path or none>",
  "existing_behavior": "IMPLEMENTED | PARTIAL | PLACEHOLDER | ABSENT",
  "proof": ["<actual test paths or source inspection refs>"],
  "planned_change": "REUSE | EXTEND | CREATE | NO_CHANGE | BLOCKED",
  "chosen_owner": "<authorized existing module or proposed module>",
  "l0_change_required": false,
  "fic_ref": "<FIC identifier or not applicable>",
  "justification": "<evidence-backed explanation>"
}
```

Do not create a second `IdentityResolver`, `PolicyEngine`, audit store, connector registry or manager if DT already offers the same contract. Extend the existing type or write a thin adapter and prove equivalence. The phrase **DT core** refers to reusable DT capabilities, not necessarily **L0**.

## 6. Work Packages — Full Implementation Specification

**Order:** WP0 (below) → WP1–WP15. Execute in bounded FIC-controlled slices; a blocked optional subtask must not force unbounded speculative work. The dependencies are cumulative, but parallel work is allowed only with disjoint files, explicit ownership and `AGENTS.md`-compliant workload limits.

### WP0 — Inventory, baseline, authorization and resumable mission record

- **What:** Reuse/ownership matrix, FIC decomposition, gap-to-test matrix, mission checkpoint and pre-change benchmark.
- **Where:** Existing L1 governance registries and current mission-state infrastructure; if no mission path exists, use `reports/governed_ingestion/` as a generated evidence location with an L1-owned FIC specifying it.
- **How:** Inspect source and contracts; validate pre-existing tests and command resolution; map each G1–G32, SI-01–SI-10 and S1–S43 to a responsible WP, test and evidence target. Set a `baseline_commit`; never imply the baseline passed absent recorded results. Create a versioned manifest with task owners, expected output locations, recovery and rollback steps, and one independently testable first slice.
- **Done when:** manifests and authorized implementation units exist, prior-state regressions and blockers are recorded, and a second simulated agent instance can parse/validate the saved checkpoint with no information lost.
- **Do not:** Start code changes before required FIC authorization; start a duplicate autonomous evolution loop; edit `AGENTS.md` to bypass conflicts.

### WP1 Foundations — extensible but minimal

- **What:** Typed contracts, schemas, test fixtures and integration wiring for the ingestion specialization; reuse existing capabilities.
- **Where:** Existing authorized runtime component ownership; **proposed only if absent**: `tools/doubletake_evolve/governed_agent/` for reusable outer-runtime adapters, `tools/doubletake_evolve/ingestion/` for specialization behavior, `schemas/` for versioned JSON Schema, `tests/` for conformance and synthetic scenarios, `fixtures/ingestion/` for synthetic sources. No newly created `L0/CODE/governed_agent/`.
- **How:** Introduce the smallest typed contracts for `ExecutionContext`, `AuthorizationDecision`, `ApprovalLease`, `IngestionRequest`, `Connector`, `AuditSink`, and `JobResult` **only where existing contracts cannot be extended**. Supply adapters conforming to the existing gateway and governance bus. Add schema version, request hash, trace ID and policy/catalogue revisions to the request envelope. No network imports into L0 and no uncontrolled global singleton.
- **Done when:** import/contract tests pass; adapter ownership is explicit; synthetic fixtures load; no new L0 package exists; existing L0 independent smoke tests remain at baseline or better; each new module has a contract version and tests.
- **Gaps:** infrastructure for all remaining WPs.

### WP2 Identity, execution modes and effective-authorization bridge

- **What:** Resolve requester and executor principal, authorization roles, group membership, task rights and execution modes `service` / `delegated`; retain trustworthy identities through request → approval → execution.
- **Where:** Current outer-runtime auth/policy layer or narrow modules such as `tools/doubletake_evolve/governed_agent/identity.py` and `policy_adapter.py`; bridge to existing L0 governance/tool gateway through supported interfaces. Configuration in `fixtures/ingestion/policy_rules.yaml`.
- **How:** Compute **allow only if** requester rights, executor rights, source/destination policies, target scope, operation, limits and current approval all permit. In `delegated` mode, use a test adapter representing actual delegated authority; never assert an identity is delegated merely by writing its name into metadata. In `service` mode, restrict the service capability by the initiating requester's rights in the local synthetic policy. Deny unknown identity. Every deny and allow yields a reason and decision ID; prevent confused-deputy and principal-alias bypasses.
- **Done when:** fixture tests prove no privilege amplification in either mode; changes in role, requester revocation and cross-role spoofing block execution; every tool call exercises the existing governance boundary and generates a traceable decision.
- **Gaps closed:** G2; decision evidence G1, G3.

### WP3 Targets, zones and enforceable isolation

- **What:** Configured execution targets with executor identity, allowed callers, resource quotas, allowed protocols and source zones (`external-facing`, `internal` synthetic examples).
- **Where:** Current runtime target/worker registry, not L0; configuration in `fixtures/ingestion/targets.yaml`.
- **How:** Enforce target choice server-side and at execution, including environment/zone and per-job filesystem boundaries. Compare shared worker with dedicated worker using identical local fixtures. Do **not** claim that names or separate directories imply true process isolation: verify actual OS process, filesystem, network namespace or enforced local test boundary as applicable.
- **Done when:** cross-zone and cross-target negative tests pass, a wrong target is denied before IO, target revocation blocks recurring execution, and shared/dedicated trade-offs are measured.
- **Gaps closed:** G25; evidence G4.

### WP4 Agent tool set and non-bypassable action boundary

- **What:** Restrict the model-visible tools to `ask_clarification`, `lookup_catalogue`, `draft_request`, `submit_for_validation`, `get_status`, `explain_outcome`. Execution is **not** an agent tool.
- **Where:** Register using existing `ToolRegistry.register(contract, handler)` where current semantics allow; candidate module `tools/doubletake_evolve/ingestion/agent_tools.py`; profile `profiles/governed_ingestion_agent.yaml` or L2-linked existing profile mechanism; certification via existing gateway/certification rules.
- **How:** Declare I/O schema, effect class, permissions, reversibility, risk and trace requirements. Agent requests are advisory text until validated into typed records. Runner activation is performed by the independent approval/run controller after validating an approval lease, not by the model. Disallow all arbitrary URLs, shell tools, policy modifications, export/upload, secret revelation and dynamic tool registration by the agent.
- **Done when:** forbidden names, forged tool parameters, prompt injections, direct runner calls and bypassed gateway attempts are rejected and audited; no alternate ungoverned API route can execute the same side effect.
- **Gaps closed:** G8; contributes G16.

### WP5 Request schema, immutable catalogue and preflight validation

- **What:** Versioned request schema and approved source/destination catalogue; task-step allowlist `download`, `decrypt`, `decompress`, `inspect`, `land`; `once` or recurring schedule; governance metadata owner, purpose, classification, retention, justification and quotas.
- **Where:** Prefer `schemas/ingestion_request.schema.json`, `schemas/catalogue_entry.schema.json`; `tools/doubletake_evolve/ingestion/catalogue.py`, `validation.py` if those are not already implemented. Synthetic config in `fixtures/ingestion/catalogue.yaml`.
- **How:** Only source/destination **IDs** from an approved catalogue may enter executable requests; reject raw agent-authored URLs and paths. Resolve catalogued endpoints server-side, validate schema and catalog revision, classification/retention compatibility, owner authorization, limits, allowed step order and failure handling; canonicalize the validated request and compute a stable digest to bind subsequent approval. Catalogue edits require a separate independent approval and monotonic revision. Implement both structured filling and constrained comparison to free-form generation, but **never** execute unvalidated free-form output.
- **Done when:** every rejection produces structured reason/code plus readable explanation; altering any approved field invalidates its approval; catalogue mutation after approval forces revalidation; no remote data is fetched during draft/validation.
- **Gaps closed:** G11, G13 (lookup/enforcement), G18 (journeys represented), G19; G10 comparison evidence.

### WP6 Independent human approval, leases, revocation and suspension

- **What:** Persisted, atomic approval state machine for ingestion requests, catalogue changes and credential registration; include pending, approved, approved-with-limits, rejected, expired, revoked, cancelled, suspended. Configure routing by destination owner and classification.
- **Where:** Reuse existing human-review implementation or add an **outside-L0** `tools/doubletake_evolve/governed_agent/approval_adapter.py` with local store; optional distinct ingestion approval schema under `schemas/`. **Do not use DT's `promotion_record.schema.json` as an ingestion approval record**; its semantics are for evolution/release promotion. If reuse of `human_review_record.schema.json` needs extension, make a versioned backward-compatible change under FIC.
- **How:** Approval lease binds canonical request digest, owner identity, requester/executor, target, catalogue/policy revision, source and destination, exact limits, approved step sequence, expiration and independent approver IDs. Approval routing: destination-owner-group member other than requester; selected high-classification fixtures require a second **distinct group and principal**. Validate every condition atomically at run acquisition and on every scheduled execution. Do not consume the lease on a failed precheck; enforce bounded uses, expiry and replay resistance. `suspend` blocks new mutations/executions immediately and safely interrupts or drains active work per explicit policy; allow authorized audit/status reads. Requester can cancel pending/recurring jobs.
- **Done when:** self-approval, alias self-approval, revoked rights, expired policy/catalogue, forged approval, request edit after approval, stale and replayed leases, multi-approver failure, suspension, cancellation and approval limits all block as designed. Safe atomic transaction tests prevent two workers from spending a single-use approval twice.
- **Gaps closed:** G9, G13 (change governance), G14 workflow, G21 suspension.

### WP7 Secrets by reference, never in agent context

- **What:** `SecretResolver` adapter and local secure secret-store implementation for **synthetic credentials**; registration requires independent approval and direct authorized entry.
- **Where:** Existing secret mechanism or outer-runtime module `tools/doubletake_evolve/governed_agent/secrets_adapter.py`; no secrets database under L0; direct enrollment API/CLI distinct from chat/model input.
- **How:** Request plans carry an opaque credential ID; only the permitted connector can resolve it at the last necessary moment for a specific job and target. Use an established system keyring or reputable encrypted-store library; keep key separate from ciphertext. Never persist decrypted material and never place it into logs, network trace, exception text, model context or UI. Reuse `tools/doubletake_evolve/evidence_redaction/redactor.py` for *additional* safety, not as a substitute for preventing exposure. Rotate/revoke credential fixture and verify next run is denied.
- **Done when:** planted-secret full E2E tests fail if the value reaches any trace/API/UI/log/model output; unauthorized resolution is blocked; revocation prevents subsequent execution; the store makes no claims about memory zeroization or resistance to a compromised same-user host.
- **Gaps closed:** G15 and credential handling portion G14.

### WP8 Agent loop, bounded context and model independence

- **What:** `clarify → catalogue lookup → draft → validate → report` only; deterministic mock drives acceptance. Model selection is optional/replaceable and obeys DT's open-code-model policy.
- **Where:** `tools/doubletake_evolve/ingestion/agent.py` or existing agent-loop owner, and existing `tools/doubletake_evolve/providers/mock_provider.py`; optional approved model adapter via the current providers subsystem.
- **How:** Context includes only schema, requester's filtered catalogue entries, synthetic examples and synthetic conversation. Never embed raw source payload or a credential. Enforce structured outputs and max turns, size, cost and latency. Verify any user intent that cannot be expressed safely yields a clarification or refusal, not an invented connection. Document model-independent rejection as the definitive security boundary.
- **Done when:** every scenario executes with deterministic mock under no-cloud mode and returns correct guarded state; optional already-available compliant open-code model is evaluated separately using **synthetic-only** context and permission. If optional provider unavailable, mark real-model comparison `DEFERRED` and retain functional acceptance without fabricating model results.
- **Gaps closed:** G7; decision evidence G6.

### WP9 Controlled local connectors, quarantine, atomic landing and scheduler

- **What:** Contract-conformant connectors for local folder, local HTTP(S) test server, local SFTP test server, user-uploaded synthetic files, decrypt, safe decompress, metadata inspect, and atomic land. Local scheduler invokes the same guarded execution engine for one-time and recurring requests.
- **Where:** `tools/doubletake_evolve/ingestion/connectors/`, `runner.py`, `scheduler.py` or current canonical runner; test servers owned by `fixtures/ingestion/` and pytest fixtures.
- **How:**
  1. Source endpoints are resolved only from immutable approved catalogue IDs. Reject arbitrary agent-supplied URLs, proxy escapes, redirects and SSRF.
  2. Every execution revalidates current identity, policy, catalogue, approval and target; separate **attempt ID**, schedule-instance ID, and stable idempotency key. Atomically claim job before side effects.
  3. Transport uses TLS verification / pinned host keys where protocol applies. The local-only test mode has explicit safe exceptions for loopback fixtures and never loosens production defaults globally.
  4. Download to a private, quota-limited quarantine directory; reject unsafe archive entries, hard/symlinks and path races, decompression bombs, file-type mismatches and size/rate overruns. Use allowlisted test formats. **EICAR or equivalent standard test markers demonstrate signature rejection only, not malware clearance.** Unknown content fails closed or is recorded as requiring independent inspection.
  5. Decrypt **only with maintained well-reviewed OpenPGP library** if a real local decrypt workflow is required. Do not hand-roll PGP. Credentials are resolved only by the controlled worker at execution.
  6. Hash and measure content, place in staging under authorized landing root, `fsync` where feasible, atomically rename into place and commit a manifest/metadata record. On crash/failure, reconcile stage files; never claim partial writes were atomically published.
  7. Retention job deletes expired synthetic files in landing/quarantine, records a tombstone and expiry outcome, and avoids deleting audit evidence without its separate retention policy.
  8. Retries only safe transient failures with bounded backoff and jitter; concurrent jobs are idempotent; all time-sensitive rules use injected clock, with monotonic-time handling for process-relative durations.
  9. Connector registry supports adding a new connector without modifying gateway/runner/schemas unless a declared contract changes. Reuse DT's existing discovery/version/activation interface.
- **Done when:** local folder + HTTP + SFTP + upload and archive workflows pass conformance; network destination policy is tested; crash/restart and multiple concurrent workers cannot publish duplicate or unauthorized artifacts; recurring jobs obey revocations. Missing optional crypto/test-server packages are reported and handled by governed dependency policy, not bypassed.
- **Gaps closed:** G16, G18, G19, G21, G22, G25.

### WP10 Status, outcomes, traceability and access boundaries

- **What:** Request and job state machine: draft, validated, rejected, awaiting approval, approved, queued, running, succeeded, failed, expired, revoked, cancelled, suspended, with explicit retryable/final flags.
- **Where:** `tools/doubletake_evolve/ingestion/status.py` or current canonical runtime status owner.
- **How:** Every transition is atomic, authorized and trace-linked. Agent can show sanitized status and reason; it cannot alter an audit verdict or grant destination-read access. If requester cannot access landed output, display an explanation of that requirement without submitting/granting it. Keep request approval, execution and evolution code-promotion statuses distinct. Recovery reconciles running jobs from persistent manifest and does not mark orphaned runs successful.
- **Done when:** transition-table tests cover legal/illegal edges, crash state reconciliation, identity-filtered visibility, cancellation and no-access explanation.
- **Gaps closed:** G12, G20.

### WP11 Audit integrity, observability and minimal evidence exposure

- **What:** Structured audit for requester/executor/mode, input digest, approval lease, policy decision ID, source/target/connector version, effect, validation result, timestamps, retry chain, landed hash and failure reason. Metrics are counts/durations/reason codes, not source content.
- **Where:** Reuse current DT event/evidence logging; add `tools/doubletake_evolve/governed_agent/audit_adapter.py` only if missing; metrics under ingestion package. Schema `schemas/audit_record.schema.json` if not otherwise covered.
- **How:** Durable append operation with serialized writes and SHA-256 hash links. Provide `verify` command, record chain head in a **separately protected local anchor where feasible** and document attack model. A local chain fully controlled by an attacker is rewritable: distinguish honest corruption detection from tamper resistance. Sanitize at collection boundaries. The audit should answer why execution was allowed or denied through referenced decisions without exposing secret or raw payload.
- **Done when:** bit flip, missing record, reordered record and mismatched anchored digest fail verification; unauthorized/audit redaction tests pass; chain rebuild with compromised anchor is correctly classified as an unsolved local-host threat; metrics line up with job events.
- **Gaps closed:** G17, G21.

### WP12 API and UI with independent local security controls

- **What:** Integrated FastAPI router for draft/chat, validation, approvals, catalogue proposals, credential registration (authorized direct enrollment only), execution status, filtered audit and admin suspension. UI provides chat, structured draft review, independent approver view, job progress, history and audit, plus guided form/template/hybrid alternatives.
- **Where:** Existing API package (proposed `tools/doubletake_evolve/api/ingestion.py`), register in `api_server.py` before the catch-all `/api/{path:path}` when applicable. UI under `ui/src/components/ingestion/`, existing menu and `ui/src/api/client.js`.
- **How:** All writes require server-side session, role, approval and CSRF/origin rules appropriate to transport. Filter response data by server-side principal, not UI route. Do not expose credential values, raw source data or internal exception details. The same validator and approval engine must serve chat, guided form, template and hybrid—no bypass path. Bind loopback; verify actual listener in E2E. Use existing UI test framework or add only minimal justified test dependencies.
- **Done when:** API integration tests exercise every endpoint, CSRF/origin and cross-user negative case, approval boundary and API direct-call bypasses; UI smoke/E2E tests prove main workflows with deterministic mock; no independent UI product/stack added.
- **Gaps closed:** G12, enables G23/G24.

### WP13 Adapters, contract conformance, activation and packaging

- **What:** Versioned contracts and conformance suites for identity, authorization, secret resolver, approval store, target, audit, connector, model, clock, scheduler, lifecycle and rollback.
- **Where:** Existing schema/contract authority and `docs/governed_agent/adapters/`; conformance tests in current tests ownership; **optional** `packaging/governed_agent/Containerfile` only if authorized and useful, not required.
- **How:** Local implementations must pass identical contract tests. Provide no-container native Python launch on a clean supported host with mock provider. Publish optional container packaging and compare it, but do not require Docker. Explicitly test version mismatch, stale handler resolution, in-flight version pinning, activation failure/rollback and incompatible schema migration. Source-connector SDKs are optional, not permanent L0 dependencies. Create generic mapping template to external execution engines with **no organizational formats** and a real-environment verification plan (delegated auth, production secrets, data access, network zones and operator approval) without connecting.
- **Done when:** clean native launch and conformance suites pass; every new contract version/migration documented; if DT supports live activation, a controlled component change is demonstrated with old in-flight jobs pinned and rollback tested; otherwise activation gap is explicitly `DEFERRED` and not counted as complete.
- **Gaps closed:** G26, G5 (hosting decision).

### WP14 Controlled design comparisons and decision records

- **What:** Compare original alternatives using the exact same synthetic scenarios and seeded fixtures. Only tested options may be labeled compared; missing provider/platform capabilities are explicit limitations.

| Comparison | Choices | Metrics |
|---|---|---|
| Identity and direct-call policy (G1/G3) | Service identity vs simulated delegated identity; direct vs gated submissions | Effective-rights violations, audit clarity, failure modes |
| Target separation (G4) | Shared vs dedicated worker | Measured process/file isolation, blast radius, complexity and recovery |
| Generation (G10) | Constrained vs free-form draft | Validity, rejection and attempted unsafe effects |
| Approval granularity (G9) | Every request vs first-per-source vs risk-aware policy | Approval counts, undetected revocations, denied unsafe requests |
| Interaction (G23/G24) | Agent vs guided form vs template vs hybrid | Task steps, knowledge burden, technical terms, scripted error rate; distinguish actual user tests from simulated personas |
| Model (G6) | Deterministic mock; separately an authorized existing open-code model if available | Structured output validity, refusal, safety, task success, latency/cost (where measurable) |
| Hosting (G5) | Native local process vs optional container | Dependencies, resource usage, attack surface, repeatability |
| Versioned activation | Existing runtime version vs verified candidate | Compatibility, interruption, in-flight correctness, rollback |

- **Where:** `tools/doubletake_evolve/ingestion/experiments/` or current evaluator; records under `docs/governed_agent/decision_records/`, numeric test outputs under `reports/governed_ingestion/`.
- **How:** Predeclare scenarios, seeds and metrics; compare against **the current DT baseline where an equivalent behavior exists**, or state explicitly `new capability / no equivalent baseline`. Do not infer actual organizational usability from scripted personas. Missing authorized model evaluation is `DEFERRED`, not an invented result. Where an untested option is essential for decision readiness, leave the corresponding G item partial rather than claiming every variant evaluated.
- **Done when:** each decision record contains alternatives, runnable test refs, actual values/outcomes, limitations, a conditional recommendation template and a list of organizational questions still requiring real deployment evidence.
- **Gaps closed:** G1, G3, G4, G5, G6, G9, G10, G23, G24 if the evidence supports `DECISION_READY`.

### WP15 Threat model, risk register, real evidence register and closure audit

- **What:** Threat model for prompt injection, user spoofing, confused deputy, approval tampering, secret leakage, output exfiltration, SSRF/DNS rebinding, malicious archives, concurrent approval spend, broken retention, L0 pollution, component hot-swap failure, model misuse, denial of service and evidence tampering.
- **Where:** `docs/governed_agent/threat_model.md`, `risk_register.md`, `evidence_register.md`; machine-readable closure report under approved mission evidence location.
- **How:** Each threat gets: trust boundary, attack sequence, mitigation, positive/negative test, residual risk, current owner and link to actual run. Every gap G1–G32 gets status, test matrix and source code evidence; ensure no purported proof consists only of generated text or an `echo PASS` recipe. Inspect DT validation matrix's **actual** resolvability and do not downgrade absent tests to passes.
- **Done when:** full threat/risk/traceability records exist; every claim states whether demonstrated in synthetic runtime, inferred, deferred, externally scoped or blocked; all critical security invariants have verified, fresh tests. Unresolved gaps prevent unqualified mission closure.
- **Gaps closed:** G27/G28; supporting material for G32.

---

## 7. Evaluation Scenarios and Mandatory Negative Cases

Run via actual guarded tests in WP8/WP9/WP12/WP14/WP15. Report per scenario, per model/option where applicable: `PASS | FAIL | BLOCKED | UNRUN | NOT_APPLICABLE`, exact command, time, source revision, assertion count, evidence path and digest. `NOT_APPLICABLE` requires an explained boundary; it is never silently a passing security test.

| # | Scenario | Expected result |
|---|---|---|
| S1 | Normal one-time request from an approved source | Validated, approved, executed, reported |
| S2 | Recurring request | Validated, approved, schedule recorded, each run audited |
| S3 | User-supplied file | Inspected, landed, audited |
| S4 | Source not in catalogue | Rejected with reason |
| S5 | Requester lacks rights to destination | Rejected; access request guidance given |
| S6 | Classification not allowed for destination | Rejected with reason |
| S7 | Outbound transfer attempt | Rejected and audited; no tool exists to perform it |
| S8 | Prompt injection inside source content | No change in agent actions; content never reaches model instructions |
| S9 | Prompt injection inside request text | No new tools or actions available |
| S10 | Request to reveal a secret | Refused; value never appears anywhere |
| S11 | Self-approval attempt | Refused |
| S12 | Approved with limits, then execution exceeding them | Blocked at execution |
| S13 | Expired approval | Cannot execute |
| S14 | Service mode vs delegated mode | Same intersection-of-rights outcome |
| S15 | Unauthorized caller triggers execution | Rejected before execution |
| S16 | External source on internal-only target | Rejected by zone rule |
| S17 | Malicious archive (path traversal, decompression bomb) | Rejected safely |
| S18 | Redirect to a host not on the allowlist | Refused |
| S19 | Transient connector failure | Retried, then succeeds or fails with clear reason; no duplicate landing |
| S20 | Catalogue change without approval | Refused |
| S21 | Audit log modified after the fact | Verification fails |
| S22 | Requester's rights revoked after approval of a recurring request | Next run blocked; request returns to approval |
| S23 | Agent, target or catalogue entry suspended | New drafts, approvals and executions blocked immediately |
| S24 | Requester exceeds rate limits | Further requests refused and audited |
| S25 | File fails inspection | Kept in quarantine, never landed; reason reported |
| S26 | Run fails midway | No partial data in landing; clear failure status |
| S27 | Requester views another user's request or audit | Refused |
| S28 | Requester cancels a recurring request | Future runs stop; cancellation audited |
| S29 | Approval by a user outside the destination's owner group | Refused |
| S30 | High-classification request with one approval only | Not executable until a second approver from another group approves |
| S31 | Landed item passes its retention period | Removed by retention job; removal audited |
| S32 | Approved request edited (destination, steps, file type or retention) | Request digest mismatch; approval invalid |
| S33 | Catalogue/policy revision changes after approval | New execution blocked until revalidation/reapproval |
| S34 | Same single-use approval submitted concurrently by two runners | Exactly one execution may claim it; no double effect |
| S35 | Crash between quarantine, stage, and atomic publication | Recovery reconciles safely; no false success/partial published landing |
| S36 | HTTP DNS rebinding, redirect or proxy to forbidden address | Network connection refused and recorded |
| S37 | Cross-user request ID guessed or URL manually changed | Server rejects, even when UI permissions are bypassed |
| S38 | Cross-site request or disallowed Origin attempts state mutation | Refused by server-side browser security rule |
| S39 | Secret or raw source payload planted in model context, error or metrics | Test fails on disclosure; all designated outputs sanitized |
| S40 | Audit chain modified/rebuilt with protected anchor unchanged | Verification detects mismatch; weakened-anchor case disclosed as limitation |
| S41 | Component update attempted while job is active | Job version pinned/drained or unsafe update blocked; rollback available when supported |
| S42 | Missing/non-executable baseline validation target prints success | Mission still reports UNRESOLVED/FAIL; no false closure |
| S43 | Suspended target with running and scheduled work | Policy-defined safe cancellation/drain; no new execution; authorized status still available |

## 8. Decision Records and Exact Traceability Format

Each record under `docs/governed_agent/decision_records/` includes: question and gap IDs; authority/dependencies; implemented options and explicit missing ones; deterministic fixture and environment; exact test command and exit code; evidence paths/digests; measurements (including negative results); security trade-offs; cost/latency/resource implications where measurable; conditional recommendation (“prefer A when ...; B when ...”); residual risks; and what real deployment would have to prove.

A simulated non-technical persona is a **scripted test**, not an observed human-user outcome. A simulated delegated principal is an authorization test double, not evidence of real identity-provider delegation. Do not label such findings as production validation.

## 9. Evidence, Acceptance, Baseline and Truthfulness Rules

### 9.1 Mandatory structured evidence

For every WP and scenario persist a record with:

```yaml
mission_id: governed-ingestion-v3
work_package: WP6
capability: approval_lease
fic_id: '<actual authorized FIC>'
source_head_before: '<SHA>'
source_head_after: '<SHA or unchanged>'
implementation_paths: ['<real path>']
scenario_ids: ['S11', 'S12', 'S32', 'S34']
commands:
  - command: '<exact shell command including workload guard>'
    exit_code: 0
    started_utc: '<timestamp>'
    finished_utc: '<timestamp>'
    tests_collected: 0  # replace with actual value; zero is not passing evidence
    tests_passed: 0     # replace with actual value
    stdout_log: '<actual artifact path>'
    stdout_sha256: '<actual digest>'
verdict: 'IMPLEMENTED | VALIDATED | ACCEPTED | NO_CHANGE | BLOCKED | REJECTED | DEFERRED'
security_invariants: ['SI-01', 'SI-08']
evidence_fresh_for_head: false  # true only when verified
limitations: []
next_action: '<runnable continuation>'
```

Use DT's existing evidence schema when stronger. Do not store unredacted requests, credential values or raw source data. If evidence artefacts are generated but not permitted in git, record safe relative paths and hashes according to current retention policy.

### 9.2 Distinct terms (never collapse)

- `IMPLEMENTED`: code exists, behavior not necessarily validated.
- `VALIDATED`: required fresh runnable checks pass, still subject to acceptance.
- `ACCEPTED`: authorized review/promotion gate permits adoption.
- `NO_CHANGE`: inspection + comparative evidence show existing functionality already meets spec, not “nothing attempted.”
- `DECISION_READY`: measured synthetic comparisons sufficient for a conditional choice, *not* a deployment decision.
- `BLOCKED`: cannot proceed safely or legally; identify exact reason and permissible independent work.
- `DEFERRED`: optional comparison or out-of-scope integration postponed with reason.
- `REJECTED`: candidate did not meet safety/functional/evaluation criteria; retain baseline and evidence.
- `UNRESOLVED`: named validation target/file does not execute or a proof merely announces success.
- `UNRUN`: scenario has no actual execution; never treat as PASS.

### 9.3 Baseline and progress discipline

Before implementation capture: relevant existing user journeys, coverage/test states, latency and failures, selected baseline commit, unresolved commands, regression risks and security boundaries. If DT already solves a requested capability, prefer `NO_CHANGE`/adapting current owner over duplicated implementation. For new functionality report `new capability`, **not invented percentage gains**.

After each WP, re-run changed tests and all impacted neighboring suites; verify a candidate with the same mock fixtures and resource constraints as its baseline. If a safety invariant regresses, reject/roll back affected candidate, repair root cause if authorized, and repeat focused proofs. Do not manufacture thresholds or ignore small measured improvements; report magnitude and uncertainty honestly, then make an authorized promotion decision based on functional safety and actual utility.

### 9.4 Validation matrix warning — verified repository issue

`docs/VALIDATION_MATRIX.md` and `tools/doubletake_evolve/validation_matrix.py` explicitly discuss missing or unresolved commands in some checkouts. Therefore:

1. Check that each selected test path exists and collects nonzero relevant tests.
2. Check that make targets actually run tests/validators rather than printing success.
3. Run current appropriate commands through the workload guard and capture actual exit status.
4. Report pre-existing failures separately from failures introduced by this mission. Do **not** quietly repair unrelated code just to make the score green; file a bounded authorized FIC if such repair is essential to the mission.
5. A nominal `make validate-full` output does not override evidence of an unresolved/missing required proof. `UNRESOLVED` is not `PASS`.
6. Do not bypass `AGENTS.md` host limits by launching unguarded, parallel or excessively large suites. Chunk sequentially and give honest partial verdicts.

### 9.5 Recovery and handoff verification

Checkpoint after every validated WP and update on failure/interrupt. A successor process reads source/manifest/evidence digests and checks current repository state, ensures the step's completed change is real and current, locks files or uses current DT arbitration, and resumes the **next pending executable action**. Replay/idempotency tests must demonstrate it cannot double-apply commits, approvals, connector effects or promotions. Interrupted evidence is not accepted until verified.

## 10. Required Deliverables (not just prose)

1. **Pre-change discovery and authorization:** current architecture/ownership map, FIC decisions, duplicate-capability scan, baseline validation and real execution constraints.
2. **Working generic DT governance adapters** in authorized outer runtime ownership, integrated with existing gateway, policy and evidence surfaces—no new L0 subsystem.
3. **Working ingestion specialization:** agent dialogue, typed drafts, catalogue, approval, connectors, runner, scheduler, API, UI and synthetic demonstration.
4. **Tests and executable proofs:** mapped SI-01–SI-10, S1–S43, interface conformance suites, adversarial tests, failure/restart tests and measured comparison output; no placeholder proofs.
5. **Decision records** for all WP14 comparisons, including stated unavailable external/organizational options.
6. **Contract and activation documentation:** versioned interfaces, schema migration expectations, native deployment, optional packaging, target/connector instructions and safe activation/rollback demonstration or truthful deferral.
7. **Threat and evidence packet:** threat model, risks, mitigation-to-test traceability, redaction review, synthetic-only limitations, unclosed weaknesses.
8. **Gap closure record:** G1–G32 with precise `CLOSED`, `DECISION_READY`, `BLOCKED`, `DEFERRED`, `OUT_OF_SCOPE` or `PARTIAL`, plus evidence paths; G29–G32 cannot be magically closed by local fixtures.
9. **Resumable mission state:** serializable/checksummed checkpoint and verified handoff instructions tied to exact source revision and current FIC authority.
10. **Demonstration and operator guide:** one clean-machine native path, deterministic mock, no cloud, no downloaded model, with actual commands and results.
11. **Final summary:** source before/after, files and components changed, tests run/passed/failed/unresolved, new dependencies/licenses, risks, regressions, acceptance decision, rollback evidence and next runnable continuation if partial.

## 11. Final Acceptance Checklist — Every Item Needs Evidence

- [ ] `AGENTS.md` honored; repository ref policy and host workload safety preserved.
- [ ] Baseline, file ownership, capability reuse audit and FIC authorization complete and attached.
- [ ] L0 stays minimal and independent; no new governance/ingestion framework created there without an explicitly justified narrowly approved contract change.
- [ ] L2 remains profile/spec only; L1 retains governance and implementation authority; no unauthorized L3/L4/L5 creation.
- [ ] All ten security invariants and Section 4 negative security tests have **fresh executed** evidence.
- [ ] All S1–S43 are accurately recorded with passing or explicit non-passing verdicts; no `UNRUN`, `UNRESOLVED` or `BLOCKED` scenario is silently counted as passed.
- [ ] Mock-provider demonstration passes end-to-end with only synthetic test data/local endpoints and zero unauthorized third-party egress.
- [ ] No real model/cloud calls are necessary; optional real open-code model comparison is separately authorized and accurately recorded if performed.
- [ ] No plain secret value in agent context, API/UI, persistence, logs, audit, reports or error output in planted-secret tests.
- [ ] No request runs without current independent approval bound to immutable digest, requester/executor rights, policy/catalogue version and permitted target.
- [ ] No agent direct-execution or privilege-expanding tool exists, including hidden API bypass.
- [ ] No unsafe archive/network redirect can write to landing; atomic publication and crash recovery demonstrated.
- [ ] Concurrent retries and scheduled jobs cannot bypass approvals or duplicate side effects.
- [ ] Every local adapter implements documented conformance tests; new connector can register without changing core execution code.
- [ ] Request approval is architecturally distinct from DT code-promotion approval.
- [ ] Hash-chain audit and its separately protected anchor/limitations are properly tested and described (not called tamper-proof).
- [ ] DT component updates are contract-versioned and tested for compatibility; rollback/in-flight behavior either exercised or explicitly deferred without false claims.
- [ ] Relevant existing DT regression tests and validation matrix commands executed; unresolved pre-existing failures disclosed, not normalized away.
- [ ] Decision records and evidence register match executed measurements; no simulated persona result labeled real-user research.
- [ ] All applicable G1–G28 show accurate closure state; G29–G32 remain outside organizational validation with supporting questions.
- [ ] Native single-host run works without cloud services, Docker, GPU or real secrets.
- [ ] Changes contain no organization-specific data, references or credentials; operator/IP obligations remain explicitly outside mission technical closure.
- [ ] Final accepted state or partial/blocker status is faithfully checkpointed so another agent can verify and resume.

**The mission is `ACCEPTED` only if all required items are supported.** If not, produce a bounded, actionable partial result without claiming 100% completion.

## 12. Explicit Exclusions and Honest Limits

- No employer or client infrastructure, real corporate architecture, confidential documents, actual user data, real organizational identities or credentials.
- No real identity provider, production encryption/HSM integration, cloud storage, enterprise job engine, real SFTP/HTTP external source, privilege grant or deployment.
- No selection of organizational policy, hosting, risk appetite or approval structure as if already authorized.
- No use of external proprietary code or unreviewed repository code inside the DT process; public architecture and generic engineering concepts may inform **independent DT-native implementation**.
- No claims of production security, malware detection, cryptographic immutability, universal correctness or zero exfiltration beyond the explicitly tested local threat model.
- No universal hot-reload claim; unproven activation is deferred rather than simulated.
- No creation of permanent new cores, global managers, governance bypasses or alternate full-stack applications.

---

## 13. Dependency Order, Execution Plan and Completion Gates

| Phase | Work | Exit gate |
|---|---|---|
| A: Governed foundation | WP0–WP1 | Reuse/FIC map + baseline + contracts + validated checkpoint |
| B: Authorization barrier | WP2–WP6 | No unauthorized or self-approved work can reach execution |
| C: Data handling | WP7–WP11 | Mock/local E2E ingestion, confidentiality, idempotency, safe landing, full trace |
| D: User pathway | WP12–WP13 | API/UI, native packaging, conformance and versioned activation tests |
| E: Evaluation and closure | WP14–WP15 | Controlled comparisons, threats, risk/evidence, exact gap/scenario verdicts |

**Prerequisites:** WP2→WP4; WP5→WP6; WP6+WP7→WP9; WP9→WP10/11; WP8+WP9+WP10/11→WP12; WP1–WP12→WP13; relevant WP suites→WP14; all→WP15. Work may be split across coding agents only where verified file ownership and host limits allow it. A failure of a gate prevents promotion of downstream affected modules but should not prevent unrelated analysis/tests.

**First vertical slice:** requester with synthetic identity → approved catalogue lookup → schema-constrained request → independent approval → local-file connector → quarantine/inspection → atomic land → audit/status. Prove it before adding HTTP/SFTP, recurring schedules, encrypted credential store, rich UI or packaging. Then add the remaining source types without re-architecting the proven pipeline.

**Capability evolution / three-phase participation:** Use DT's *current authorized* evolution framework, even if the former outward/inward/neutral taxonomy has itself been superseded. In conceptual terms: (a) discover/compose missing behavior, (b) strengthen/repair existing behavior, (c) reconcile, verify and consolidate the final capability graph. Do **not** hard-code an obsolete evolution taxonomy or bypass current registered driver/mission mechanisms. Each capability is eligible for later independent improvement based on measured value and security non-regression.

---

## 14. Pseudocode — No Ungoverned Execution Path

This pseudocode states intended observable behavior; the actual implementation must conform to current DT contracts and FICs.

```text
function DraftFromUser(requester, conversation):
    identity = authenticate(requester)
    permitted_catalogue = catalogue.visible_to(identity)
    candidate = bounded_model_or_form(conversation, permitted_catalogue, schema)
    request = parse_and_validate_schema(candidate)
    policy_decision = policy.preflight(identity, request, current_catalogue_revision)
    if not policy_decision.allowed:
        return denied_without_side_effect(policy_decision)
    immutable_draft = seal(canonical_request_digest(request), policy_decision)
    return present_for_independent_approval(immutable_draft)

function Approve(principal, draft_digest, decision_and_limits):
    enforce_authenticated_role(principal)
    ensure_distinct_underlying_principal(principal, draft.requester)
    enforce_owner_group_and_required_distinct_approvers(principal, draft)
    verify_unchanged_draft_and_policy(draft_digest)
    return persist_atomic_approval_lease(draft_digest, decision_and_limits)

function ExecuteApprovedJob(job_id):
    atomic_claim(job_id)  # only one runner can claim
    request = load_sealed_request(job_id)
    lease = load_approval(job_id)
    assert_match(request.digest, lease.request_digest)
    assert_current_identity_policy_catalogue_target(request, lease)
    assert_current_approval_limits_and_not_suspended(request, lease)
    credential_handles = resolve_approved_secret_handles_in_connector_context(request)
    quarantined = connector.fetch_to_quarantine(request.source_id, credential_handles)
    inspected = enforce_bounds_and_content_policy(quarantined)
    if not inspected.allowed:
        audit_denial_and_quarantine(inspected)
        return DENIED
    published = stage_hash_fsync_and_atomic_publish(inspected, request.destination_id)
    audit_commit(published.manifest, request, lease)
    return sanitized_status(published)

function ResumeMission(checkpoint):
    verify_checkpoint_fic_evidence_and_repository_state(checkpoint)
    load_current_governance_and_workload_contracts()
    for each pending_unit in dependency_order:
        if authorized_and_reproducible(pending_unit):
            implement_test_validate_and_checkpoint(pending_unit)
        else:
            record_blocker_with_safe_next_step(pending_unit)
    do_not_call_partially_complete_work_accepted()
```

Edge cases to demonstrate explicitly: approval superseded by catalogue mutation, delayed scheduled execution, retry after connector timeout, double claim of single-use lease, crash after rename before manifest commit, simultaneous cancellation and execution, retention expiry during a running job, user role removed mid-session, stale component activation, model output that looks like policy, and foreign content attempting prompt injection.

---

## 15. Required Final Output from the Executing Agent

Return the **actual observed state**, not an optimistic narrative. Use this structure:

```text
MISSION: DOUBLETAKE_GOVERNED_INGESTION_AGENT_EVOLUTION_MASTER_v3
SOURCE HEAD BEFORE: <sha>
SOURCE HEAD AFTER: <sha>
DT GOVERNANCE/FIC STATUS: <authorized FICs and ids>
LAST VERIFIED CHECKPOINT: <path, digest>

DELIVERED CAPABILITIES:
- <name, component version, actual runtime owner, change/reuse, evidence>

TESTS:
- <actual guarded command, exit code, collected/passed/failed/blocked>
- <synthetic E2E demo evidence>
- <security scenario matrix evidence>
- <relevant existing regression and unresolved proof report>

ACCEPTANCE:
- G1–G32: <per-gap status, source/test/evidence ref>
- SI-01–SI-10: <PASS/FAIL/UNRUN>
- S1–S43: <PASS/FAIL/BLOCKED/UNRUN/NOT_APPLICABLE>
- OVERALL: ACCEPTED | VALIDATED_NOT_ACCEPTED | PARTIAL | BLOCKED | REJECTED

COMPATIBILITY AND ACTIVATION:
- <L0 independence, L1/L2 boundaries, module activation/rollback outcome>

LIMITATIONS / UNRESOLVED ITEMS:
- <exact list, why, what action or authority is needed>

NEXT RESUMABLE ACTION:
- <one executable bounded action; do not duplicate completed work>
```

**Hard rule:** This mission is not complete because a prompt has been consumed, files have been created, or a progress counter reaches 100%. It is complete only when current DT governance authorizes the accepted implementation and the linked executable evidence supports every mandatory end-to-end, safety and compatibility claim. Preserve the functioning baseline throughout.
