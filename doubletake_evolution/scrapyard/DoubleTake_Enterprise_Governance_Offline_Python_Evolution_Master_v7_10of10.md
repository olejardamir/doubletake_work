# DOUBLETAKE — ENTERPRISE GOVERNANCE OFFLINE PYTHON EVOLUTION MASTER v7.0

**Type:** Executable engineering directive for DoubleTake's existing evolution/controller workflow  
**Target repository:** `https://github.com/olejardamir/DT`  
**Mode:** Python-only; local/offline for the complete deliverable; Azure/Databricks represented only by explicit, bounded test doubles  
**Objective:** Implement, integrate, test, and package a bank-oriented, cloud-independent governance capability using existing DoubleTake architecture.  
**Status at issuance:** A directive, **not** authorization, evidence of implementation, a completed milestone, or permission to deploy to a regulated environment.  
**Priority:** Security and truthful verification > compatibility with ongoing work > a functioning integrated vertical slice > additional features > documentation polish.
**Authority model:** This prompt specifies work but **does not override** `AGENTS.md`, active file ownership, existing FIC/approval requirements, L0 protected boundaries, or Git policy.

### Version 7.0 final security-contract refinements (preserves v1–v6 requirements)

This revision closes two substantive ambiguities in v6. **(1) Authentication, receipt confidentiality and execution authorization are separate decisions.** A stable idempotency key preserves the historical committed effect and avoids a second execution, but a retry must authenticate its present caller and independently authorize any disclosure of its historical receipt. A disabled principal, impersonator or cross-tenant caller cannot retrieve sensitive past results simply by knowing the original actor ID and key. Such refusals never rewrite the original journal or resurrect the effect. **(2) A request genuinely pending independent approval must have a defined, atomic state transition to authorized execution after a trusted grant arrives; a grant is not an idempotency conflict or automatic execution.** Recheck original intent, policy and approval at permit issue and execution. Terminal denials/cancellations do not silently revive. Retain v6's transaction ordering, independent audit anchors, no-network policy, approval safety and exact offline-vs-bank-readiness boundary. The mandatory release matrix is now **66 executable scenarios** and all eight governance invariants remain mandatory. These are engineering instructions, **not** proof of deployment or bank certification.

---

## 0. Mission and nonnegotiable outcome

You are DoubleTake's authorized coding/evolution worker, operating **inside the existing DoubleTake project**. Your task is to perform engineering work—not merely produce another roadmap, report, prompt, claim matrix, architecture description, or set of empty modules.

**Build a working offline Python implementation** that can govern synthetic banking-style automation through the real DoubleTake authorization and enforcement boundaries, with independently replayable evidence and negative tests. The final product of this mission is a transferable **offline reference/governance-core package**, explicitly **not** a certified bank-production system or a live Azure/Databricks integration.

The implementation must:

1. Reuse the authoritative governance logic and tooling in DoubleTake wherever demonstrably compatible; never create a shadow policy engine, parallel L0 kernel, independent approval authority, or second promotion pathway to circumvent an existing one.
2. Keep existing L0 invariants and independence intact. Work through documented extension interfaces and L1-authorized changes only. Do not modify L0 or its default seed policies just to make this mission pass.
3. Introduce a separate enterprise **deployment profile**, which prevents autonomous self-modification and self-approval even though the research/development edition of DoubleTake may evolve itself in an isolated, governed setting.
4. Enforce decisions at the point of actual local effect, not merely in a planning response. A denied request must produce **zero unauthorized protected workload/fixture effects**. Valid denial receipts, audit records, anti-replay counters and rate-limit metrics are *governance metadata*, not prohibited workload effects, and must still be recorded where policy requires them. Never claim a denial left all storage unchanged when its audit entry changed.
5. Ship deterministic **simulated Azure RBAC**, **simulated Databricks catalog/job permissions**, and **simulated pipeline deployment checks** as local Python fixtures only. Simulations must transparently declare fidelity limits and never impersonate a vendor service.
6. Use **no Azure/Databricks SDK, cloud credential, service login, endpoint, installation, Docker, external database, GPU, network API, hosted LLM, or downloaded model** in implementation, demo, or acceptance tests.
7. Produce meaningful security tests and durable evidence for successful/denied/pending operations, concurrent requests, tampering, failures, and recovery.
8. Preserve all ongoing DoubleTake work and do not weaken, silently change, or bypass unrelated governance. Do not mark whole-project `PRODUCTION_READY` based on this mission.

**Target label:** `OFFLINE_ENTERPRISE_REFERENCE_ACCEPTED` **only** when its own acceptance checklist has independent, content-bound evidence, every mandatory check passes, and a distinct authorized acceptance decision exists. Until then use truthful intermediate states such as `PLANNED`, `IMPLEMENTED`, `LOCALLY_TESTED`, `INTEGRATED`, `BLOCKED`, `PARTIAL`, or `VALIDATED_NOT_ACCEPTED`.

---

## 1. Repository authority, active work, and conflict rules

### 1.1 Read and inspect first (do not assume a file is unchanged)

Inspect the actual checkout/HEAD, file ownership, module imports, and relevant current code before altering anything. Begin with these **known locations**, recognizing that actual contents may have changed since this directive was authored:

- `AGENTS.md` — live instructions, owner boundaries, **main-only/no-tags** repository policy, and guarded test workload limits.
- `README.md`, `L0/README.md`, `L1/README.md`, `DOUBLETAKE_THESIS.md`, `ENTERPRISE_SECURITY_OVERVIEW.md`.
- `GOVERNED_INGESTION_V4_ACTIVE_DRIVER.md`, `reports/governed_ingestion/MISSION_STATE.json`, relevant existing work-package evidence/FICs. This separate mission must not be overwritten, re-certified as yours, or silently reconfigured.
- `L0/CODE/core_kernel/`, `L0/CODE/governance/`, `L0/CODE/kernel_composition/`, `L0/CODE/tool_gateway/`, `L0/docs/` including existing extension ABI if present.
- `tools/doubletake_evolve/mcp/l0_authorization.py` — canonical production route to L0; inspect its documented ingress limits and allowed tool behavior.
- `tools/doubletake_evolve/policy/policy_enforcer.py`, capability registry/rule models, and their **actual** production consumers.
- `tools/doubletake_evolve/approval_exception_governance/` — approval validation and atomic consumption.
- `tools/doubletake_evolve/governance_audit_trail/` — decision records, replay, hash-chain integrity, limitations.
- `tools/doubletake_evolve/final_governance_gate/`, `tools/doubletake_evolve/governance_contract/`, `tools/doubletake_evolve/fic_scope_guard/`, `tools/doubletake_evolve/rollback_recovery/`, `tools/doubletake_evolve/runtime_activation/` — existing gate, scope, release, rollback and operator controls.
- `L1/controller/`, `L1/fic/`, `L1/validators/`, and `Makefile`, `pyproject.toml`, `pytest.ini`, `conftest.py`.
- Existing enterprise/security/policy tests and active worker ownership markers.

Create a concise **reuse matrix** classifying each existing feature: `REUSE_DIRECTLY`, `REUSE_WITH_ADAPTER`, `GAP_REQUIRING_AUTHORIZED_CHANGE`, or `NOT_APPLICABLE`. For every classification, show an actual callable, its consumer, an execution-path test, and a reason. A directory name or README statement does **not** establish a working control. Avoid duplicating mechanisms already integrated in a tested path.

### 1.2 Protect active work

At start, read `git status`, `git rev-parse HEAD`, and any accessible existing ownership/lock state. Check what other workers are editing. Do not reset, hard-clean, squash, force-push, rewrite history, restore stale files, terminate another worker, overwrite uncommitted changes, or change the existing governed-ingestion driver. Treat concurrent edits as owned by their current workers until proven otherwise.

The repository currently directs **only `main`, no tags or extra branches**. Preserve that policy. Use **detached worktrees** only if permitted for isolated tests or development; do not create named refs. Commit only explicit files that you own and only through the established authorized workflow. Do not change the state of other missions to make your own test green. Do not push automatically unless the actual operator permissions and current repo instructions explicitly allow publication for this workstream.

Any mutation must be within an existing authorized FIC/work unit or a newly approved, valid L1-governed unit that identifies *exact* permitted paths, proof obligations and owner. This prompt grants **no new authority** to modify protected files, policy files, release controls, existing mission artifacts, or production systems. If authorization is unavailable, produce the requested FIC/handoff evidence and mark code work `BLOCKED_BY_AUTHORITY`; do not self-approve.

### 1.3 Resource and test discipline

Respect the current `AGENTS.md` resource budgets. In the observed repository, experiments, test suites, proof generators and builds are launched through:

```bash
python3 tools/doubletake_evolve/runtime/host_workload.py -- <command> [args...]
```

Read the **current** resource policy before execution; adjust commands to the actual checkout. Run focused suites **sequentially**; no recursive test collection, nested certification loops, competing global evidence regeneration, parallel CPU-heavy experiments, or unbounded retries. Scratch files belong in the guard's `TMPDIR`, with cleanup in `finally`. Durable report outputs belong in the workstream's specified `reports/enterprise_governance/` location. A resource refusal or timeout is `INCONCLUSIVE`/`BLOCKED`, never passing evidence.

If an identical failure recurs twice, diagnose the mechanism, change the implementation strategy or report the blocker—do not regenerate reports to simulate progress.

---

## 2. Engineering boundaries and threat model

### 2.1 Explicit deployment profiles

Implement an **offline enterprise reference profile** that is distinct from DoubleTake's general research/development profile:

- `offline_enterprise_reference`: permits **only** local synthetic fixtures, deterministic policy decisions, guarded test effects, and local records; forbids outgoing connections, cloud providers, arbitrary shell execution, uncontrolled filesystem mutation and autonomous policy change.
- `development_evolution`: continue relying on DoubleTake's existing, separately governed development machinery; the enterprise module **must not weaken** its governance or modify its capabilities implicitly.
- A future `enterprise_production` profile may be described as an **interface/requirements document only**. It must not activate itself and must never be presented as deployed or independently approved.

An unrecognized or corrupted profile is **denied**. No implicit fallback from an enterprise profile to permissive development behavior.

### 2.2 Trust boundaries

Treat the requesting agent, prompt, user-supplied context, generated plans, asserted identities/roles/approvals, mutable working-tree content, test fixture payloads and adapter return values as **untrusted claims** until independently verified.

Required independent authorities:

1. **Principal / role source** — authenticated or explicitly trusted test fixture registry, not `request.user_role` alone.
2. **Versioned policy source** — immutable policy snapshot or trusted policy provider; requester cannot edit it.
3. **Approval source** — independent approver identity and durable, bounded grant; proposer/executor cannot confer its own approval.
4. **Enforcement executor** — adapter/gateway accepts valid, narrow, single-use execution authority, not a generic `approved=True` field.
5. **Audit/evidence verifier** — separate verification code/path re-derives records and expected effects rather than trusting producer-written PASS labels.

For local simulated tests, explicitly document when identity or signing is **fixture-trusted** rather than cryptographically authenticated. A local SHA-256 chain is **tamper-evident only relative to independently retained trusted anchors**; it is not a digital signature, third-party attestation, immutable storage, proof of human approval, or production nonrepudiation.

### 2.3 Baseline threat scenarios

At minimum consider: malicious or mistaken agent, prompt injection, unauthorized operator, forged user role, forged approval, approval expiry/revocation, cross-environment scope escalation, time-of-check/time-of-use race, duplicate execution on retry/restart, corrupted policy, tampered evidence, symlink/path traversal, fake successful adapter response, audit write failure, two agents approving each other, deployment with wrong artifact digest, policy/config change by agent, partial failure after external side effect, and hidden direct-execution bypass.

No security guarantee against a host administrator/root attacker is implied by Python in-process controls alone. Document host-level threat assumptions and what would require OS isolation, protected credentials, independent audit sinks and genuine cloud validation later.

### 2.4 What an offline Python gateway can and cannot enforce (critical)

The **enforcement claim is scoped to callers using the governed API/CLI and the declared isolated test fixture boundary**. Python code running with the same operating-system identity and unrestricted write access to the underlying fixture files could bypass an in-process Python authorization check by editing those files directly. No amount of Python `private` naming, frozen dataclasses, hashes, mocks, or test assertions fixes this. Therefore:

- Never claim that the offline reference prevents a malicious same-user process, a Python monkeypatch, local administrator, or an operator with direct fixture-store access from changing protected state. Such protection requires **independent OS-enforced permissions/process isolation and control of service identity**, which are external production gates.
- The test harness must distinguish `GATEWAY_ENFORCEMENT_PROVEN` (all declared entrypoints and adapters refuse unauthorized actions) from `HOST_ISOLATION_UNVERIFIED` (direct filesystem/process threats are not mitigated).
- Treat the trusted fixture registry, issuer secrets/test trust anchors and deterministic clocks as **harness-controlled**, not user-controlled. A test cannot simply inject a trusted approval object into the same untrusted request and call it authentication.
- Do not advertise the local package as a replacement for IAM, privileged execution isolation, protected CI/CD environments, or the bank's independent security review.

### 2.5 Formal safety invariants to implement and falsify

Define `A(t)` as the set of authorizations valid **at time/linearization point `t`**, `E` as durable protected **workload effects** (excluding required governance metadata and audit writes), `P` as single-use permits, and `R` as observed receipts. Historical effects remain legitimate if their authorization was valid at the instant of commit, even if that approval is subsequently revoked. For the **declared local execution boundary**, independently test:

- **EG-I01 (no unauthorized effects):** every effect in `E` maps to an authorization in `A(t_commit)` that matched the trusted actor, exact action, resource, environment, payload digest and policy revision at the linearization point.
- **EG-I02 (no double spend):** a permit in `P` authorizes at most one committed protected effect, even across threads, processes and restart.
- **EG-I03 (separation of duties):** where independent human approval is required, requester/executor cannot satisfy the approval requirement themselves or through a second agent alias.
- **EG-I04 (audit consistency):** every locally atomic committed effect has its authoritative decision/effect journal entry in the **same transaction**; auxiliary JSONL/projection writes may lag and must be reconciled. Uncertain nontransactional effects remain unresolved, never success. A denial may append a refusal record while leaving workload state unchanged.
- **EG-I05 (evidence binding):** accepted evidence binds to exact source, policy, test and fixture content and cannot be accepted when stale or edited.
- **EG-I06 (fail closed):** parsing, identity, policy, approval, audit, storage and unsupported-action failures never become implicit ALLOW.
- **EG-I07 (no cloud effects):** enterprise reference executions perform no network or cloud SDK/API calls.

Track each invariant with named **positive, negative and adversarial tests**. If one cannot be independently demonstrated, report `UNPROVEN` rather than an invented proof. For every no-effect claim, record the workload fixture digest **and** the governance-metadata delta separately, to prevent false failures for legitimate deny-audit writes and false passes for unrecorded denial decisions.

**EG-I08 (tenant noninterference):** a caller, policy, role, approval, permit, idempotency key or reconciliation job scoped to tenant A cannot read, mutate, replay or approve tenant B's workload state or governance metadata through the governed API. Include historical receipt/status lookup and independent current-caller authentication/read authorization; knowing a tenant-B idempotency key or a once-valid actor ID grants no visibility. Represent this as an independent invariant with test-backed evidence, not merely a request-field validation.

---

## 3. Architecture — extend canonical machinery, no competing kernel

**Desired real execution path:**

```text
Synthetic agent / local CLI / approved DoubleTake workflow
          |
          v
Strictly parsed GovernanceRequest (untrusted proposal)
          |
          v
Trusted identity, scoped resource, immutable payload and policy snapshot
          |
          v
Existing canonical DoubleTake governance / authorization integration
          |                  \
          | DENY / PENDING    \
          |                    -> durable refusal / pending receipt, NO effect
          v ALLOW + all required independent checks
Bound execution permit (one scope, one artifact, one action, one executor, one use)
          |
          v
Last-moment recheck and atomic permit consumption at the protected gateway
          |
          v
Local simulated Azure/Databricks/pipeline adapter (no network)
          |
          v
Actual local fixture state mutation + effect receipt / fail-safe reconciliation
          |
          v
Append-only audit + content-bound evidence + independent replay/checker
          |
          v
Evidence-driven ACCEPT / BLOCK / UNKNOWN result and authorized recovery
```

The enterprise orchestration package may coordinate checks, but must **delegate normative authorization decisions** to the documented existing authoritative mechanisms. If existing L0 supports only seed tools, **do not pretend that** `execute_governed_tool(seed.emit_answer)` authorizes an enterprise deployment. Investigate the documented kernel extension ABI and a safe governed adapter insertion point. Only connect actual local fixture effects through an authorized extension that preserves governance-before-gateway ordering. If an existing policy engine is not connected to that gateway, explicitly identify the missing wiring and implement it under an approved L1 unit; never create an ungoverned second execution path.

The new module must not import L1 into L0, bypass L0 via an enterprise-exclusive tool executor, or widen default seed allowlists/risk settings. If correct wiring is impossible under current extension constraints, finish a safe **dry-run evaluation slice**, leave all protected effects disabled, and truthfully report `ENFORCEMENT_INTEGRATION_BLOCKED` until a separately authorized integration change is accepted.

---

## 4. Required Python package, documented interfaces and data contracts

Preferred new paths **subject to existing repo layout and approved FIC scope**:

```text
tools/doubletake_evolve/enterprise_governance/
  __init__.py
  __main__.py                   # local CLI; no service listener needed
  contracts.py                 # typed request, decision, permit, receipt
  policy_bridge.py             # thin adapters to existing authoritative policy machinery
  identity.py                  # fixture-trusted principal and executor registry
  approval_bridge.py           # reuse existing approval governance and consumption
  enforcement.py               # real protected boundary; no direct fixture bypass
  evidence.py                  # audit integration + binding/checking/replay
  store.py                     # reuse existing durable store or SQLite transactional adapter
  verifier.py                  # separate read-only evidence and effect verification
  recovery.py                  # recovery and truthful indeterminate state
  offline_adapters/
    __init__.py
    azure_rbac_sim.py
    databricks_sim.py
    deployment_sim.py
  fixtures/
    __init__.py
    synthetic_bank.py
  tests/
    test_contracts.py
    test_authorization.py
    test_approval_and_sod.py
    test_gateway_denial.py
    test_offline_adapters.py
    test_tamper_and_replay.py
    test_concurrency_and_recovery.py
    test_transaction_boundaries.py
    test_evidence_independent_oracle.py
    test_no_network.py
    test_end_to_end.py

docs/enterprise_governance/
  ARCHITECTURE_AND_THREAT_MODEL.md
  REUSE_AND_GAP_MATRIX.md
  POLICY_CONTRACT_V1.md
  ADAPTER_CONTRACT_V1.md
  OFFLINE_OPERATOR_GUIDE.md
  SECURITY_LIMITATIONS.md
  ACCEPTANCE_MATRIX.md
  FUTURE_CLOUD_CONFORMANCE_GAPS.md
  TRUST_BOUNDARY_AND_UNPROVEN_GATES.md

reports/enterprise_governance/
  MISSION_STATE.json
  [content-bound, bounded evidence artifacts generated by code]
```

Use existing test/style/layout conventions if they differ. Do not create placeholder folders or empty files just to satisfy this example tree. Every introduced file must have a live consumer, a required test or a clear purpose. **Do not copy/rewrite the existing audit engine, approval engine, or global final gate** into this package.

### 4.1 Strict typed records

Provide strict, serializable versioned contracts (Python dataclasses/typing or already-installed equivalents; no new dependencies by default):

- `Principal`: immutable ID, type (`human`, `agent`, `service`), trusted group/role claims, fixture issuer, enabled state.
- `ResourceRef`: provider simulation, environment, exact tenant/scope, object ID/type, classification, parent lineage.
- `GovernanceRequest`: schema version, request ID, requester ID, proposed action, resource, environment, payload digest, code/artifact digest if applicable, reason, idempotency key, evidence references, source commit and context.
- `PolicySnapshot`: stable version, content digest, rule provenance, allowed scope, test-case metadata; never executable Python sourced from untrusted strings.
- `GovernanceDecision`: typed `ALLOW`, `DENY`, `PENDING_APPROVAL`, or `ERROR` plus machine-readable reason codes, decision ID, policy digest, evaluated request digest, version and issuer.
- `ApprovalGrant`: independent approver, principal authority, exact request/action/resource/environment/payload, creation/expiry, approval ID, policy version, revocation/consumption state, trust provenance.
- `ExecutionPermit`: narrowly bound authorization, trusted issuer, executor identity, policy and resource revisions, request and payload hashes, one-use token/nonce, bounded expiry, approved-risk context.
- `ExecutionReceipt`: attempted action, actual measured mutation (or non-mutation), authorization/permit references, result (`SUCCEEDED`, `DENIED`, `FAILED`, `OUTCOME_UNKNOWN`), affected record IDs, before/after digests when safe.
- `AuditRecord`/`EvidenceManifest`: chain position, digests, related approvals and permit IDs, source/test artifact binding and replay verdict.

Rules: reject unknown schema versions, missing required fields, ambiguous names/scopes, unsupported actions, unexpected fields in security-critical records, path traversal, duplicate IDs with incompatible data, inconsistent decision/permit/request linkage, and stale policy/resource revisions. Use canonical JSON serialization with stable ordering and exact type checking; do not use `eval`, dynamic imports from request content, Python `pickle` for untrusted objects, unsafe YAML, or prompt strings as authorization. Hashes bind *actual action bytes* and actual tested content, not summaries or filenames alone.

For the offline demo, use a trusted principal registry configured by tests/fixtures. A request's self-declared `principal_id` is **not evidence of authentication**; the gateway must take trusted caller identity separately and compare it to request claims. Persist and explain which parts are simulated.

### 4.1.1 Canonical request identity and deterministic time

- Specify versioned canonical serialization and digests for (a) the **received request envelope**, (b) the **stable operation intent**, and (c) the **authoritative authorization snapshot**. Distinguish their purposes. The immutable operation fingerprint binds schema, trusted tenant/actor/issuer, server-defined namespace, action, fully qualified resource/environment, payload and artifact bytes/digests, and any **explicit immutable policy/approval target specified as part of the operation**. The transport request ID, delivery ID, retry count, trace ID, fresh timestamp, incidental reason text and ambient policy version discovered only at retry time **must not** change the identity of the same operation. Bind the original policy snapshot separately in the journal and historical receipt. Test field omission, type confusion, Unicode normalization assumptions, integer/string aliases, inconsistent resource-case handling, duplicate JSON keys and noncanonical encodings; refuse ambiguous forms.
- Define one versioned **decision-state machine** with explicit intermediate and terminal behavior: `RECEIVED -> (DENIED | PENDING_APPROVAL | AUTHORIZED)`; `PENDING_APPROVAL -> (AUTHORIZED | DENIED | CANCELLED | EXPIRED)` **only** through a trusted, durable approval/cancellation event and fresh policy/identity checks against the unchanged reserved operation fingerprint; `AUTHORIZED -> (PERMIT_ISSUED | REFUSED)`; `PERMIT_ISSUED -> EXECUTION_PREPARED -> (COMMITTED | REFUSED | OUTCOME_UNKNOWN)`; committed effects may progress to `VERIFIED` or a separately governed `RECOVERY_REQUIRED` / `RECOVERY_FAILED` state. `DENIED`, `CANCELLED`, `EXPIRED`, and `REFUSED` are terminal for that attempt (a new intent needs a new idempotency key); an `OUTCOME_UNKNOWN` state enters observation/reconciliation, never automatic re-execution. A grant arriving after cancellation or expiry cannot resurrect a terminal attempt. Record state transitions atomically with their authority evidence, guard against concurrent grants, and test that approval does not itself execute the effect. Illegal backward transitions, unrecognized states and second promotions are rejected.
- Use a trusted, injectable clock for deterministic expiry tests. Define UTC timestamps and explicit evaluation/execution boundaries; do not let the request choose server time. Address wall-clock rollback/forward jumps conservatively. Do not treat `time.monotonic()` persisted across reboot as a wall-clock trust anchor.
- Reserve each idempotency key under one database-level UNIQUE constraint over **(trusted tenant ID, trusted actor ID, server-defined operation namespace, idempotency key)**. The namespace is chosen from the authenticated entrypoint/application boundary by the server, **not** from user-controlled payload, action, resource, environment, artifact or policy revision. At reservation, persist a **stable operation fingerprint** as the stored comparison value, a separate original envelope digest, the original authoritative policy/approval binding, state, permit linkage and any committed receipt. The UNIQUE lookup key **must not** contain the request/payload digest or mutable action/resource fields: otherwise a changed payload could create a second row and defeat `IDEMPOTENCY_CONFLICT`. For an existing key: authenticate the **current** caller from the independent trusted identity source before any keyed lookup/disclosure; compare trusted stable operation intent **before** any new *execution* authorization/policy evaluation. An identical **committed** operation returns its historical receipt despite transport request-ID changes or later ambient execution-policy drift **only if current read/disclosure authorization and tenant isolation allow that caller to view it**, without new effect, permit consumption or implied current execution authorization. If the caller is disabled, cannot be authenticated, no longer has read access, or claims another tenant/actor, return a non-disclosing refusal (or a deliberately minimal non-sensitive status if independently authorized), retain the historical journal/receipt unchanged, and never create a second effect. Receipt visibility policy is separate from whether the historical effect was valid when committed. Changes to actor/tenant, server namespace, action, resource, environment, payload, artifact, or an **explicit originally bound policy/approval target** produce `IDEMPOTENCY_CONFLICT` and zero new effects. A new transport envelope can be recorded as a retry attempt, but cannot make a committed effect new or overwrite the original binding. Pending/in-flight/unknown outcomes return only a **currently visibility-authorized** recorded state and follow explicit nonduplicating reconciliation; a different historical approval/policy authorization must never create a second effect under the same key. An approval issued later for the original `PENDING_APPROVAL` operation is an authorized state transition, not a change to stable operation intent or permission to bypass final policy/approval checks; a new client-specified explicit approval target does constitute different intent and conflicts. Implement reservation and conflict check atomically across processes; test key collisions before and after restart, retried request IDs, explicit-binding changes, policy drift, disabled/revoked caller identity, current receipt-visibility denial, and concurrent grant-versus-cancel races. Do not reveal the presence of another tenant's key through differential error details, timings or status where reasonably controllable in the declared offline API. A historical receipt must never authorize a new effect.


### 4.2 Policy resolution and change control

- Default deny; explicit allow only for actions and scopes named by policy.
- Most-restrictive decision wins; policy deny overrides approval/role grants. A granted role is not automatic permission to break environment restrictions.
- Include resource classification, `dev/test/staging/prod` risk, requester/executor identity, **tenant binding**, scope inheritance, trusted evidence completeness, maintenance window if applicable, policy revision, and approval requirements. Persist tenant binding at authorization, approval, permit, idempotency, journal and replay boundaries; tenant IDs supplied only by untrusted requests confer no authority.
- Policy changes are separate governed actions requiring independent authorized approval; ordinary agents and workload identities cannot edit policies, authorization rules, protected approval files, trust anchors or evidence-verifier code.
- No agent can change its own role, execute arbitrary operations under a claimed administrator identity, or self-authorize a sensitive change.
- Fail closed on missing/corrupt/unknown policy. If there is an existing DoubleTake activation gate whose **legacy missing-file default is OPEN**, preserve legacy compatibility but **explicitly require a present, valid, enterprise policy and explicit enterprise-profile enablement**; never inherit legacy `OPEN` as enterprise authorization.
- Explain and test privilege precedence instead of claiming complete Azure/Databricks policy equivalence.

### 4.3 Approvals and separation of duties

- Reuse existing approval/exception governance where its contracts fit.
- A real `PENDING_APPROVAL` must not mutate protected state or be silently converted into ALLOW. A later valid independent grant for the **same** pending intent may advance it through the declared `PENDING_APPROVAL -> AUTHORIZED` transition only after trusted grant validation, current actor/tenant checks and fresh policy evaluation; permit issue and effect remain separate actions. Approval does not change the reserved operation fingerprint or by itself authorize protected mutation. Revoked/expired policy or a cancelled/expired pending attempt must refuse instead of reviving.
- An approval names an independently trusted approver and binds to one immutable **stable operation intent** (not a replaceable transport delivery ID), code/artifact digest, action, exact environment/scope, policy revision and time range; the received envelope and separately stored approval identifier remain auditable. Approving a pending operation under a newer policy requires an explicit governed re-evaluation; an old grant cannot bypass policy changes.
- Expired, revoked, missing, forged, broadened, already-consumed, wrong-scope, wrong-artifact and wrong-commit approvals **deny**.
- Require independent approval for protected production-like changes; requesting agent, executing agent, and approver must not be the same principal for sensitive actions. Two agent identities cannot bypass separation of duties by mutual self-approval if policy requires human authorization.
- Approval consumption and permit consumption must be atomic/concurrency-safe within the local test's threat model; two simultaneous requests may not spend the same single-use approval twice. Define the ordering of revocation, *policy updates*, approval/permit consumption and protected execution by the **same authoritative transaction/serialization boundary**, not by merely reading two independently mutable stores sequentially. If existing file-backed DoubleTake approvals cannot participate atomically, integrate them via an approved authoritative state bridge with a single ordered commit protocol, or mark the live-effect path `AUTHORITY_ATOMICITY_BLOCKED`. A copied approval snapshot, asynchronous mirroring or a stale cached approval is **not** sufficient to prove a revoke-before-commit guarantee. A revocation before an effect's commit must block it; revocation after commit must not retroactively invalidate the authorized historical effect. Test both orders (and policy-update races) across independent processes and crashes; explain pending/in-flight outcomes and scope limitations.
- A fixtures-only approval is a **synthetic trusted test grant**, not proof of a human signing an action. Production cryptographic trust or enterprise identity integration remains out of scope for this offline mission.

### 4.4 Single protected execution gateway

- Effectful local fixture operations must require a valid permit obtained via the real integrated authorization path.
- The adapter's privileged effect API must not accept `execute(action)` without a permit. An untrusted caller cannot construct or reuse a permit that the gateway accepts merely by setting public dataclass fields; use a protected verifier and persisted issuer/nonce state.
- Revalidate policy/approval/resource revision at execution, bind to the exact payload bytes, consume permit atomically, then apply bounded effects; fail safely if time, revocation or environment changed.
- Every CLI/workflow entry point that causes protected fixture effects must use the same path; demonstrate bypass attempts are refused at **effect site**, not only at the request validator.
- No arbitrary `subprocess`, shell, filesystem or network executor attached to generic requests.
- For denied calls, prove **zero unauthorized protected workload effects**, not merely a DENY label. Required refusal-audit and antireplay bookkeeping may change and must be independently measured.
- When a side effect may have happened but its outcome cannot be verified (e.g., simulated crash after mutation before receipt), return `OUTCOME_UNKNOWN`, persist an idempotency/reconciliation record and never blindly repeat a non-idempotent operation. **A retry from a currently authenticated, independently receipt-visibility-authorized caller may return a previously committed, content-matching historical receipt without re-executing**; it must not create a new permit or imply current authorization. A truly unobservable nontransactional effect may not be silently mapped to success or failure.

### 4.4.1 Linearization and local transaction protocol (mandatory)

Concurrency and exactly-once assertions are inadequate without a concrete durable mechanism. First look for a proven existing DoubleTake implementation that can atomically coordinate permit consumption, protected local fixture mutation and journal recording across **separate processes**. If none exists, prefer Python's **standard-library `sqlite3`** in a dedicated test-only directory (no external database/service) with explicit schema constraints, unique keys, checked transactions and busy/abort handling. Never introduce a second authorization policy or release authority in the storage layer.

For fully transactional **local fixture** effects, use one durable transaction with, in order: trusted request/policy/resource/approval revalidation, compare-and-set on revisions, consume/claim the scoped approval and permit, apply the authorized local effect, write the **authoritative transactional effect/audit journal entry**, and COMMIT. Serialize revocation and policy changes through the *same* authoritative state/commit-order mechanism or refuse the affected operation; checking an independently writable approval or policy file before SQLite COMMIT does **not** establish the promised revocation-order guarantee. If an existing engine cannot share that boundary, retain it as the normative authorizer but introduce an authorized transactionally verified state projection **without creating a new approval-granting authority**; until parity/revision integrity is established, refuse effects and mark `AUTHORITY_ATOMICITY_BLOCKED`. **Do not pretend that a separate JSONL file append, approval JSON rewrite, arbitrary filesystem fixture write, and SQLite COMMIT form one atomic transaction.** Store the protected transactional fixture state in the same SQLite database when claiming an atomic effect/journal boundary; any external fixture-file projection is downstream derived data, not a second independently committed protected effect. Existing DoubleTake `GovernanceAuditTrail` JSONL/hash-chain output may be an eventually reconciled, idempotent **projection** of the committed transactional journal. Test interruption between COMMIT and projection, then verify rebuild/replay adds no duplicate logical record. Another process must not consume the same permit or mutate the same resource under a stale revision. Test kill/restart before and after commit. Specify SQLite transactional settings, integrity checking, busy handling, durable commit expectations and the **difference between process-crash and power-loss guarantees**; demonstrate only the failure modes actually injected. WAL, `fsync`, or file locking do not make arbitrary external effects atomic or establish host-level attacker resistance.

For **nontransactional future adapters**, define an outbox/journal protocol (`PREPARED`, `DISPATCHED`, `OBSERVED`, `OUTCOME_UNKNOWN`, `RECONCILED`) plus adapter-provided stable operation IDs and observation hooks. Do **not** promise exactly-once delivery to a future cloud service. Use idempotency or read-after-failure reconciliation when genuinely supported; otherwise stop with `OUTCOME_UNKNOWN` pending authorized review.

A scenario titled “crash after effect before receipt” must test the proper boundary: for the SQLite-local fixture, the effect and committed journal should recover together; for a separately modeled nontransactional effect, the result can remain `OUTCOME_UNKNOWN`. Do not falsely require an impossible committed-effect/uncommitted-journal state inside one proven atomic transaction. **Explicitly distinguish journal failure from projection failure:** an unavailable authoritative journal *before commit* must abort the transaction with no protected effect; an unavailable downstream JSONL/audit projection *after a successful committed transaction* must preserve the effect, report `AUDIT_PROJECTION_PENDING`, block final acceptance until reconciliation, and never run the effect again just to repair the log. Test both cases at their actual fault-injection boundary.

### 4.5 Audit, evidence and recovery

Reuse existing audit chain/replay/rollback tools where compatible, with a real consumer and verifier. For every decision and operation, record stable reason code, requester, independently established actor/executor, policy revision, request and payload digests, approval/permit references, source commit, event order, expected and measured effects, and rollback/recovery status. Scrub sensitive fields (only synthetic fixtures allowed). No raw secret in audit or demo outputs.

- Integrity verification must recalculate record digests, chain continuity, counter monotonicity, content identity and related artifact versions. A producer-written `valid: true` does not count.
- Independently verify from persisted records in a fresh process/entry point, preferably via a read-only verifier that cannot mutate evaluated records during verification. Use independently initialized test fixtures and an **independent expected-effect oracle**; the verifier must not take `expected`, `measured` or `pass` at face value from the producer's own JSON.
- Evaluate event streams using strict schema/sequence/identity checks, and independently reconstruct affected fixture state from recorded committed operations. Compare the reconstructed state with a read-only snapshot acquired after execution; reject missing, duplicate, reordered, stale or contradictory records. Include deliberate *mutations of purportedly successful reports* as negative tests.
- Specify **anchor direction and capture time**. A pre-run anchor proves continuity with an earlier accepted prefix but **does not authenticate the later suffix or its completeness**. A locally changed JSONL/audit **projection** can be detected as inconsistent by replaying against an **unchanged, separately controlled authoritative journal**, if the verifier demonstrably protects and checks the expected linkage; such a finding proves *relative inconsistency*, not adversary-resistant authenticity of the journal. For coordinated rewrites of **all** attacker-writable records including that journal, a trusted observer must first acquire the committed journal head, projected log head, record count and (where applicable) read-only fixture-state digest at end of run, then preserve that **terminal checkpoint outside the attacker-controlled records before tampering**. Only a later verifier comparing the rewritten data with that pre-existing independent terminal anchor may claim that the coordinated suffix rewrite was detected. An anchor created *after* tampering from the rewritten data proves nothing. When neither an unchanged independently trusted authoritative journal nor an independently retained terminal anchor is available, return `ANCHOR_ABSENT_UNVERIFIABLE`; do not infer authenticity from internal hash continuity. A fixture harness that controls its own anchor is only an offline test trust assumption, not a bank-grade signature, HSM, WORM store or external attestator.
- Clearly distinguish four verification levels: `INTERNAL_CONSISTENCY_ONLY` (hashes/sequence recomputed within mutable evidence), `AUTHORITATIVE_JOURNAL_PROJECTION_MATCH` (projection agrees with an independently controlled unchanged journal, proving relative consistency **only**), `INDEPENDENT_TERMINAL_ANCHOR_MATCH` (matches a separately retained checkpoint captured before tampering), and `UNVERIFIABLE` (required independent inputs missing or untrusted). A projection/journal mismatch is a positive detected inconsistency, not a successful authenticity proof. Do not promote internal consistency or agreement between co-writable files to adversary-resistant tamper proof. A root/host adversary controlling the terminal checkpoint remains out of scope. If the attacker can rewrite both anchor and evidence, report `INDEPENDENT_ANCHOR_UNTRUSTED`.
- Missing or tampered evidence must block promotion; old reports tied to a different content digest are stale.
- If the **authoritative transactional journal** cannot be written before COMMIT, the protected local effect must not commit. If a **downstream JSONL/audit projection** fails after a successful atomic COMMIT, the committed effect is known from the journal, but report `AUDIT_PROJECTION_PENDING` and prevent final acceptance until replay/reconciliation repairs the projection; do **not** falsely classify a proven committed local transaction as `OUTCOME_UNKNOWN`. For genuinely nontransactional or unobservable effects, retain `OUTCOME_UNKNOWN` until reconciled; never report unqualified success.
- A rollback must be a separately governed action, constrained by the approved target. Restoration of a previous local fixture state must be measured; an attempted rollback without verified restoration is `RECOVERY_FAILED`, not PASS.
- A local hash chain alone does not protect against the same principal rewriting both evidence and chain head. With **no independent trusted reference** (neither an unchanged, independently controlled authoritative journal covering the rewritten projection nor a pre-existing trusted terminal anchor covering the rewritten suffix), a complete internally consistent re-chain is not detectably fraudulent from the rewritten bytes alone: return `ANCHOR_ABSENT_UNVERIFIABLE`. If the authoritative journal is independently unchanged, a projection rewrite that conflicts with it must be reported as `JOURNAL_PROJECTION_MISMATCH`, **not** incorrectly suppressed merely because there is no external terminal anchor. With a trusted pre-tamper terminal checkpoint outside **all** attacker-controlled stores, independently compare head, count, source identity and observed fixture digest to reject a coordinated rewrite. This is an offline harness-scoped measurement; a bank-grade protected anchor/signature and enterprise audit sink remain future production requirements.
- Distinguish a locally detectable single-record edit or content-binding mismatch from an undetectable coordinated re-chain. Provide both negative controls. Do not equate producer-independent code with adversary-independent trust: if an attacker controls the storage, verifier binary, expected inputs *and* any anchor, no meaningful independent attestation exists.

---

## 5. Offline cloud-like adapters: realistic bounded contracts, zero cloud access

Implement local test doubles with Python interfaces (`Protocol` or an existing type convention) and **file- or in-memory state only**. Their operations are bound by the same protected effect gateway and no network/API/SDK access. The purpose is to test DoubleTake governance integration and future contract shape, **not** to claim behaviorally perfect emulation of vendor services.

### 5.1 Simulated Azure identity/RBAC

- Principal types: human, service, agent; synthetic role assignments and exact scope hierarchy `management_group > subscription > resource_group > resource`.
- Test inherited positive grants, missing grants, more specific restrictions introduced by DoubleTake policy, scope mismatch, wrong tenant, disabled principal, privilege escalation attempts and stale role snapshot.
- Keep Azure role-based grants conceptually distinct from DoubleTake's local explicit DENY. **Do not represent Azure deny assignments as user-configurable**: Azure documents that deny assignments are system managed. Simulated local governance denial is DoubleTake's own control, not an Azure-native deny assignment.
- No actual Entra token, Azure credential or Azure client. Trusted identity is a named offline fixture.

### 5.2 Simulated Databricks Unity Catalog/jobs

- Model limited hierarchy: catalog, schema, table; privileged actions such as `USE CATALOG`, `USE SCHEMA`, `SELECT`, `MODIFY`; selected job actions such as `CAN VIEW`, `CAN MANAGE RUN`, `CAN MANAGE` and owner/run-as semantics where the model can faithfully express them.
- Enforce parent usage prerequisites, explicit object permissions, environment ownership and sensitive-data classifications in the fake, with clearly documented simplifying assumptions.
- Separate *dataset access* from *job management* and *deployment* authorization; a user allowed to run a job does not automatically get permission to edit or deploy production pipelines.
- Include at least one case in which a job runs with an owner/service identity different from the request initiator; do not confuse initiator privileges with effective execution identity.
- Any feature not modeled returns `UNSUPPORTED_IN_SIMULATOR` or is explicitly outside scope, rather than an invented permissive result.

### 5.3 Simulated deployment and change gates

- Dev/test/staging/prod environments; immutable synthetic change artifact (content digest), versioned policy snapshot, pre-deployment tests, independent approvals, exclusive lock, deployment receipt and rollback target.
- Pipeline author must not be able to edit independent environment approval policy as part of its own pipeline change.
- Unsupported real cloud details (network, IAM propagation, cluster runtime, Unity Catalog native enforcement) remain **unverified** by this simulation.

### 5.4 Future adapter port (contract only)

Define a small versioned interface for future true integrations, e.g. `prepare(request)`, `read_effective_permissions(...)`, `verify_preconditions(...)`, `apply(permit, request)`, `observe_effect(...)`, `reconcile(...)`, `recover(...)`, with explicit results/side-effect expectations. Choose final names only after comparing repo conventions. Constructing a production adapter without a configured trusted principal/provider must raise a clear `LIVE_ADAPTER_NOT_IMPLEMENTED`/`CLOUD_NOT_CONFIGURED` refusal, not silently route to a mock and report real success.

**Do not install the Azure or Databricks SDKs, set up services, call HTTP endpoints or create deployment scripts that automatically contact cloud infrastructure.** Future work may later implement these ports under separate authorization.

Useful **reference semantics for offline contract design only** (not credentials or integration instructions):

- Azure RBAC concept and scopes: https://learn.microsoft.com/en-us/azure/role-based-access-control/overview
- Azure deny assignment distinction: https://learn.microsoft.com/en-us/azure/role-based-access-control/deny-assignments
- Azure Pipelines approvals/checks: https://learn.microsoft.com/en-us/azure/devops/pipelines/process/approvals
- Azure Databricks Unity Catalog privileges: https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/manage-privileges
- Azure Databricks access-control/job ACLs: https://learn.microsoft.com/en-us/azure/databricks/security/auth/access-control/

These URLs are documentation references. **Internet access is never required** for coding, demo or test execution. If the documentation is unavailable, use the requirements above, document any fidelity uncertainty and do not fabricate exact vendor behavior.

### 5.5 Offline execution guard and fidelity contract

- Implement a **test-level deny-network trap** (socket/connect, HTTP clients where present) and a documented **host-level isolated/no-egress test mode** when available. Deny arbitrary shell commands, endpoint resolution and unapproved process execution. **Do not block all process creation:** EG-S18, EG-S38 and crash/restart tests require short-lived, allowlisted local child Python processes launched by the controlled test harness (`sys.executable`, known module/arguments, `shell=False`, bounded time/resources, no inherited cloud credentials). Those children must inherit the deny-network restrictions or run inside the same no-egress host boundary, and must not gain more authority than the parent. Test attempts to spawn an unapproved executable or invoke a shell are refused; test the sanctioned child-process path still works offline. Python monkeypatching alone does not secure arbitrary code; do not overclaim it. Log attempted prohibited operations and fail tests; do not contact external services even as a probe.
- Inventory transitive imports and package metadata. A reference test must not import, install or instantiate an Azure/Databricks SDK, request credentials, open a listener, or resolve external endpoints. Dynamic plugins are disabled in enterprise profile unless explicitly allowlisted and tested.
- Include a documented, table-driven simulator fidelity contract: modeled behavior, unsupported vendor behavior, trust assumptions, relevant vendor documentation URL/version **if already known**, and proof coverage. Never use offline fixture tests as evidence of authentic Azure or Databricks policy enforcement.
- All sample names, records, account IDs, tenants, transactions and datasets must be synthetic; scan demo/evidence outputs for secret-like strings and check that user/private directories are never referenced. Test names that resemble actual financial institutions must be clearly marked fictional. Never include genuine banking datasets or organization-specific infrastructure information in the generated bundle.
- Apply **explicit request/policy size bounds, collection nesting limits, resource-name length limits, operation timeouts, fixture row/record limits and bounded queues**. Reject oversized/complex inputs before expensive parsing or lock acquisition. Denial-of-service tests must remain within the existing host guard; never generate an uncontrolled stress load.
- Refusal and audit messages must escape untrusted input and resist log/terminal injection (including control characters and multiline forged audit prefixes). Sensitive payloads must not be echoed into logs; verify by reading actual persisted records.

---

## 6. Required implementation sequence: CODE FIRST, REAL INTEGRATION, THEN CERTIFY

Proceed through the following **work units**, with minimal disjoint code, tests and preserved evidence at each stage. Progress must correspond to behavior that works under its actual consumer, not text produced or commits counted. Do not demand global re-certification after every file.

### EG-00 — Repository inspection, ownership, reuse/authority plan

Deliver: precise HEAD, current conflicting owners, read-only state of existing missions, reuse matrix, threat boundary, per-unit FIC authorization paths, new path ownership and a short first vertical-slice plan. Do not modify protected files. Establish a separate `reports/enterprise_governance/MISSION_STATE.json` only when permitted, as a workstream record, never as a replacement for other mission states.

**Exit:** all intended edit paths are permitted; blockers named. If not, stop code mutations and hand off FIC requirements.

### EG-01 — Contract skeleton and an executable small vertical slice

Implement strict request/decision/receipt contracts and one **real locally effectful** synthetic transaction, e.g. `dev_job_restart`, through the existing governed execution route. Implement a denied counterpart, e.g. `prod_pipeline_replace` without approval, and show unchanged protected fixture state. Add focused unit, negative and integrated-path tests. Avoid a broad framework rewrite.

**Exit:** one allowed action causes exactly one authorized local effect with receipt; one denied action causes none; both generate verifiable records; no fake gateway authorization. If enforcement extension is blocked, only dry-run and `ENFORCEMENT_INTEGRATION_BLOCKED` are honest.

### EG-02 — Enterprise profile, policy and identity/scope governance

Add explicit opt-in enterprise profile, no-default-cloud behavior, trusted fixture role registry, policy snapshots, resource classification, deny precedence and an independent execution identity. Expand one policy-based local deployment scenario. Prove malformed/missing policy and claimed-role escalation fail closed.

**Exit:** unauthorized principal, unknown scope, invalid policy and enterprise self-modification all produce zero effects; legacy L0 behavior remains unchanged.

### EG-03 — Approval/SoD/permits and race safety

Connect existing approval exception governance; bind grants to exact request/environment/artifact/policy; block self-approval and privileged cross-approval; single-use approval/permit behavior; deterministic concurrent tests; idempotency and expiry/revocation. For concurrency, use local locks/atomic files/transactional primitives already available and test crash boundaries. In-process locks alone do not establish cross-process safety.

**Exit:** two competing processes cannot both execute a single-use permit; missing/stale/revoked/wrong-scope approvals deny before effect. If the actual implementation cannot prove this, keep it marked partial.

### EG-04 — Three offline adapters, genuine governed effects

Implement synthetic Azure RBAC, Databricks catalog/job, and deployment simulations with only supported contracts. Prove decisions influence actual mock state via the protected gateway. Add fixture reset/transaction mechanics to allow deterministic tests without contaminating the checkout.

**Exit:** permitted and denied cases for all three adapter classes, plus one cross-adapter deployment scenario, pass end-to-end at effect boundaries; unsupported behaviors refuse.

### EG-05 — Durable audit/evidence, failure injection, recovery

Connect DoubleTake audit/replay and acceptance/rollback mechanisms. Test deliberate partial writes, tampered records, missing manifests, wrong hashes, stale snapshots, process restart, duplicate messages, effect-before-receipt crash and rollback with measurable restoration. Prefer a separate read-only Python verification entry point (no network). Reuse existing integrity functions where valid; do not self-certify a producer's output.

**Exit:** verifier catches tamper/staleness; no double apply; undeterminable outcomes are `OUTCOME_UNKNOWN`; recovery success is independently observed; security-blocked cases cause no effect.

### EG-05A — Failure-injection and trusted-oracle cross-check (before packaging)

Write a distinct, read-only verification path that reconstructs effect counts, authorization lifetimes at commit, permit use, tenant ownership and journal/reconciliation state from persisted records. It must not import or call the decision-producing function to obtain the expected verdict. Run seeded, bounded model-based sequences of allow/deny/approve/revoke/retry/commit/crash and compare the independent state-machine oracle to the actual resulting fixture state. Use finite, deterministic seeds recorded in evidence and minimize any discovered counterexample into a regression test. Target **the boundary**, not private helper implementation details.

Also test adversarial request sizes, journal-projection interruption, tenant-isolation conflicts, verifier-version skew, absent anchors and coordinated rewrite against a **terminal checkpoint captured by a trusted observer before tampering**. If the verifier and implementation share the same incorrect premise, the negative tests should expose this by injecting deliberately inconsistent recorded states. Store the trusted observer's expected journal head/count and effect snapshot outside the mutable producer records; do not let the verifier generate its own target checkpoint from the allegedly genuine log at verification time.

**Exit:** independently re-derived local claims are supported by persisted facts, ambiguous external trust limits are marked unverified, and failed sequences remain durable reproducible counterexamples.

### EG-06 — Offline operator surface and transfer-ready package

Create minimal Python CLI using the established packaging/import conventions:

```bash
# Illustrative entry point only; implement according to existing Python packaging.
PYTHONPATH=.:tools python3 -m doubletake_evolve.enterprise_governance inspect
PYTHONPATH=.:tools python3 -m doubletake_evolve.enterprise_governance demo --fixture synthetic-bank
PYTHONPATH=.:tools python3 -m doubletake_evolve.enterprise_governance verify --report reports/enterprise_governance/...
PYTHONPATH=.:tools python3 -m doubletake_evolve.enterprise_governance status
```

No web UI, live server, cloud integration or vendor SDK is necessary. Include clean-environment instructions that do **not** fetch anything, machine-readable schemas, example policies, fixture descriptions, support boundary, evidence verifier instructions, version manifest, dependency/SBOM generation using already-available tooling if possible, and a threat/limitations report. The module must be installable/runnable as part of the existing Python project without privately configured paths.

**Exit:** another developer can check out the authorized retained source, run the offline demo and verifier under the repo's documented environment, and reproduce the expected results without outside services.

### EG-07 — Freeze source, run independent certification once, truthful handoff

After substantive implementation and integration are stable:

1. Freeze a **retained** source checkpoint and capture exact commit SHA and content digests. Avoid report churn while implementation continues elsewhere; use an isolated permitted worktree if necessary.
2. Run focused security/contract/integration tests; `make prove-seed`, `make prove-l1`, and other relevant documented regressions within `AGENTS.md` guard and time budget. If a global suite would recursively collect itself, do not run it; document the precise safe equivalent.
3. Execute an **independent verification program** against persisted records and the known fixture state. Test actual allow/deny side effects rather than self-reported statuses.
4. Generate the scenario-by-scenario acceptance matrix below, including exact tested module/function, command, result, source digest, fixture digest, evidence artifact and remaining limitations.
5. Run changed-surface regressions and verify that L0 independence, seed behavior, existing governance denial, current mission files, and default offline behavior remain intact.
6. Mark `OFFLINE_ENTERPRISE_REFERENCE_ACCEPTED` only when all mandatory EG scenarios pass, source is bound, no protected-seam regression exists, and final approval/promotion is granted through the existing authorized process. A green test does **not** itself supply an absent approval.
7. Otherwise report `PARTIAL`, `VALIDATED_NOT_ACCEPTED` or `BLOCKED` with exact reasons and actionable unresolved defects. **Never** print `BANK_PRODUCTION_READY`, `AZURE_INTEGRATED`, `DATABRICKS_INTEGRATED`, `REGULATORY_COMPLIANT`, or `INDEPENDENTLY_CERTIFIED` for this mission.
8. Verify each invariants-to-tests mapping, scenario-to-test mapping and report-to-source binding from committed code. A passing expected/mocked JSON fixture is **not** a measured runtime test. Include the negative test proving the acceptance verifier refuses a forged green report. Treat `TEST_EXECUTED` as a claim derived from the **trusted harness invocation and captured exit code**, with the command, executable digest when feasible, actual test collection IDs, environment fingerprint and produced output hashes; a user-supplied list of commands or test names is not evidence that they ran. If the verifier cannot authenticate the harness capture independently of the producer's writable files, mark the execution provenance `UNVERIFIABLE`, rather than falsely certify the event occurred.
9. Record a **release candidate manifest** with package/module versions, exact source SHA, policy digest, test fixture baseline, supported Python versions, dependency hashes or pinned inventory, executed commands/exit codes, artifact digests, limitations and independent acceptance authority. The manifest may be reproducible without requiring signed Git tags (which repository policy currently forbids).
10. Run a clean-checkout replay with cached/available dependencies only. If unavailable, mark this specific portability test `BLOCKED`, not passed. No network or package installation is permitted to make the result green.

---

## 7. Mandatory scenario matrix (all executable; no narrative-only passes)

Maintain stable scenario IDs, tests and expected effects. Modify expectations only via explicitly authorized change control with recorded rationale, never to make a failing run green.

| ID | Test / invariant | Expected result |
|---|---|---|
| EG-S01 | Permitted development job restart by trusted eligible principal | ALLOW; exactly one fixture effect and valid receipt |
| EG-S02 | Same restart under a principal lacking run privilege | DENY; zero **workload** effect; required refusal/audit receipt allowed |
| EG-S03 | Production pipeline replacement without independent approval | PENDING/DENY; zero effect |
| EG-S04 | Approved production-like change with exact digest and valid independent grant | ALLOW if all gates pass; exactly one effect |
| EG-S05 | Requester self-approves protected change | DENY; zero effect |
| EG-S06 | Executing agent self-approves protected change | DENY; zero effect |
| EG-S07 | Wrong approver role / untrusted approval issuer | DENY; zero effect |
| EG-S08 | Expired, revoked or consumed approval | DENY; zero effect |
| EG-S09 | Same approval for a different artifact, environment or scope | DENY; zero effect |
| EG-S10 | Absent, malformed or unsupported policy version | DENY; zero effect |
| EG-S11 | Policy updated after permit issuance | Recheck; deny stale permit |
| EG-S12 | Role spoofing via request JSON/context | DENY; zero effect |
| EG-S13 | Tenant or environment scope escalation | DENY; zero effect |
| EG-S14 | Attempt to modify policy, trust anchor or audit configuration by agent | DENY; zero effect |
| EG-S15 | Attempt direct adapter effect with no permit | DENY; zero effect |
| EG-S16 | Fake permit / changed request body or digest | DENY; zero effect |
| EG-S17 | Reuse permit twice, same process | At most one effect |
| EG-S18 | Competing processes use the same permit | At most one effect |
| EG-S19 | A currently authenticated, receipt-visibility-authorized caller retries the same committed operation intent with the same scoped idempotency key after restart, a new transport request ID and ambient execution-policy drift | Return the *historical* committed receipt; no new permit, fresh **execution** authorization claim or effect; read visibility is independently checked |
| EG-S20 | Nontransactional-adapter simulation: crash after effect but before receipt | `OUTCOME_UNKNOWN` until observation/reconciliation; no blind re-execution |
| EG-S21 | Authoritative transactional audit/effect journal cannot be written before local COMMIT | Transaction aborts; DENY/FAIL; zero committed workload effect, and no permit consumed as a successful effect |
| EG-S22 | Alter one persisted audit/evidence record | Independent verifier rejects tampered/stale record |
| EG-S23 | Coordinately rewrite all attacker-writable journal/projection records and re-chain, without unchanged trusted journal or independent terminal anchor | Return `ANCHOR_ABSENT_UNVERIFIABLE`; do **not** claim to detect an unobservable rewrite. Separately prove that projection-only tamper **is** detected against an unchanged trusted journal |
| EG-S24 | Source/fixture/evidence digest mismatch | No accepted promotion |
| EG-S25 | Fake Azure RBAC: inherit a permitted scope to a named descendant; attempt same operation on sibling or expressly denied descendant | Named permitted descendant may execute once; sibling and explicit-deny target DENY with zero effects |
| EG-S26 | Fake Databricks table access lacks required parent usage | DENY; zero effect |
| EG-S27 | Fake Databricks job initiator can start job but its distinct effective run identity lacks required data access | DENY data access and zero data effect; separate start/run-as permissions demonstrated |
| EG-S28 | Fake pipeline author attempts to alter independent approval control | DENY; zero effect |
| EG-S29 | Authorized rollback of a committed synthetic deployment to an exact prior target | PASS **only** if the previous fixture state is restored, independently measured and journaled; `RECOVERY_FAILED` is a failing test, covered honestly by EG-S39 |
| EG-S30 | Unsupported simulator action | Explicit `UNSUPPORTED_IN_SIMULATOR`; no effect |
| EG-S31 | Offline demo/test attempts socket/cloud/SDK access or unapproved subprocess/shell invocation | Fail test / refuse; no actual external call or unauthorized command; allowlisted local Python test children remain functional offline |
| EG-S32 | Legacy L0 seed and L1 contract proof after changes | No project regression |
| EG-S33 | Malicious prompt content contains alleged override instructions | Treated only as data; no authority granted |
| EG-S34 | Tricky object identifiers, symlink and path traversal | Refuse unsafe path/scope; no unauthorized file mutation |
| EG-S35 | Attempt to swap approved artifact between decision and effect | Detect/reject TOCTOU; zero unintended effect |
| EG-S36 | Cross-process approval issuance/revocation/policy-change/execution race, including separate-file legacy approval state | All live effects serialize with authoritative approval/policy revisions; revoke/change-before-effect-commit blocks, effect-first remains historically authorized; no stale-file or mirror race escalation; otherwise `AUTHORITY_ATOMICITY_BLOCKED` |
| EG-S37 | Denied request through each supported effectful enterprise ingress | Same decision boundary; zero effect, no alternate path |
| EG-S38 | Read-only verifier replays evidence in a separate fresh process | Accurate independently re-derived verdict |
| EG-S39 | Recovery interrupted or state inconsistent | No false success; auditable `RECOVERY_FAILED`/`OUTCOME_UNKNOWN` |
| EG-S40 | Enterprise profile absent or corrupt | DENY protected operations; no permissive fallback |
| EG-S41 | Same key and trusted namespace reused with changed operation intent (payload, action, resource, environment, artifact, explicit policy/approval target), including concurrent and restart cases | `IDEMPOTENCY_CONFLICT`; no second idempotency row/permit/effect. Ambient policy drift or new transport ID alone is **not** an intent conflict (EG-S19) |
| EG-S42 | Unknown/illegal lifecycle state transition, late approval after cancellation/expiry, or second acceptance attempt | Refused; no unauthorized effect/promotion |
| EG-S43 | Kill local worker after prepared writes but **before** local SQLite effect COMMIT; restart | No effect-transaction permit consumption, protected effect or committed effect-journal row survives. A separately committed prior idempotency reservation **may** survive; replay must reconcile its truthful state without duplicate effect, and fresh execution (if needed) must pass current authorization |
| EG-S44 | Kill local worker after COMMIT before client observes outcome | Exactly one committed local effect; journal and replay remain consistent |
| EG-S45 | Attempt stale resource revision/CAS conflict under concurrency | At most one effective write; other request denied/retried only under new authorization |
| EG-S46 | Forge actor/approver by editing untrusted fixture request rather than trusted registry | Refused; authority remains external to request |
| EG-S47 | Mutate a self-reported green evidence summary but not underlying state | Independent verifier rejects mismatch/forged report when bound to known trusted evidence; otherwise returns `UNVERIFIABLE` |
| EG-S48 | Corrupt/truncate durable permit or journal state | Fail closed; no silent grant, unsafe replay or false success |
| EG-S49 | Disposable-fixture negative control demonstrates same-user direct-file access can bypass Python gateway when OS permissions allow | Document `HOST_ISOLATION_UNVERIFIED`, distinguish API enforcement from host isolation; no bank-grade bypass claim |
| EG-S50 | Attempt to substitute a mock for a live provider and claim enterprise integration | Explicitly refused; no cloud readiness/promotion |
| EG-S51 | Refuse unknown schema fields, duplicate JSON keys, type confusion and noncanonical identity | No permit; zero protected effect |
| EG-S52 | Forge claimed human approval by supplying same fixture-controller identity/issuer in an untrusted request | Refuse invented human identity; mark fixture-trusted identity only, never production authentication |
| EG-S53 | Exfiltration attempt through output, logs, filename, or test exception | Synthetic-only data, bounded redaction and safe errors; no network |
| EG-S54 | Corrupt policy or fixture between authorization and execution | Final revalidation refuses; no unauthorized effect |
| EG-S55 | Test malicious report with fake run commands, fake SHA, and copied expected results | Reject mismatched source/measurements; claimed execution lacking independently trusted harness capture is `UNVERIFIABLE`, not proven executed |
| EG-S56 | Denied request has an auditable refusal but does not alter protected workload | Zero workload effect; expected governance metadata record present; both measured separately |
| EG-S57 | Crash after SQLite COMMIT before append-only audit projection | Authoritative committed journal survives; projection rebuild is idempotent; no duplicate logical effect |
| EG-S58 | Tenant A attempts reading/using tenant B permit, approval, idempotency record, **historical receipt**, journal or resource | DENY; no tenant-B information disclosed or mutation; no cross-tenant replay |
| EG-S59 | Oversized/nested/malformed payload and terminal/control-character log injection | Bounded fail-closed refusal; no workload effect; safe structured audit record |
| EG-S60 | Revoke and execute with opposite commit order, including crash/retry | Revoke-first blocks; effect-first remains historically valid; journal ordering verified |
| EG-S61 | Deterministic seeded model-based sequence with retries, policy drift and crashes | PASS **only** if the independent state-machine oracle agrees with persisted effects for every executed seed; a discrepancy is FAIL, with a durable minimized counterexample |
| EG-S62 | Verifier loses source identity or lacks **both** an unchanged independently trusted journal and an independently held terminal anchor | No forged ACCEPT; explicit `UNVERIFIABLE`/`STALE`. Missing a terminal anchor alone does **not** forbid detecting projection mismatch against an unchanged trusted journal |
| EG-S63 | Downstream JSONL/audit projection becomes unavailable **after** a successful local SQLite COMMIT | Protected effect remains committed exactly once with authoritative journal; `AUDIT_PROJECTION_PENDING` blocks final acceptance until idempotent repair; no double execution |
| EG-S64 | Trusted observer captures terminal journal/chain head and record count **before** attacker rewrites both authoritative journal and projection; attacker edits suffix and re-chains all writable evidence | Independent verifier compares against separately retained pre-tamper terminal anchor and rejects; without a surviving independent trusted reference returns `UNVERIFIABLE`, never forged success |
| EG-S65 | Previously authorized principal has since been disabled or lost historical-receipt read permission; it knows the correct original key, actor ID and payload, and retries an old committed operation | Deny or strictly redact receipt disclosure under independently evaluated **current caller** authentication/read policy; original committed effect and journal remain intact; no permit/effect replay, no sensitive metadata leak |
| EG-S66 | A pending independent approval is issued for exactly the reserved operation intent, then competes with cancellation/expiry and a changed policy | Only an authenticated, independently granted, still-valid pending request can transition to `AUTHORIZED` after fresh policy checks; approval alone makes no workload effect; cancel/expire-first and policy-invalid cases refuse, no revival or duplicate execution |


For each of **EG-S01 through EG-S66**, store `id`, `expected`, `measured`, `effect_before`, `effect_after`, `verification_path`, `source_digest`, `fixture_digest`, `status`, and precise failure reason. The verifier must **derive measured facts from execution and persisted state**; it may not trust `expected == measured` when `measured` was copied from expectations.

**Acceptance-interpretation rule:** a test of a deliberate refusal or deliberately injected failure passes only when the expected safe behavior is **independently observed** (for example: an unauthorized effect is absent, a valid denial is recorded, and the relevant state remains consistent). A production workflow's `RECOVERY_FAILED`, `OUTCOME_UNKNOWN`, `AUDIT_PROJECTION_PENDING`, `UNVERIFIABLE`, or a test/oracle discrepancy must not count as a success for a scenario that specifically requires successful recovery, reconciliation, independent evidence or a known committed outcome. A negative scenario that deliberately induces one of these states can pass **only** if its expected state and all required no-effect/consistency assertions are met; this does not upgrade that failure state into readiness evidence. Any unexecuted, blocked, skipped, timed-out, stale or unverifiable mandatory scenario blocks `OFFLINE_ENTERPRISE_REFERENCE_ACCEPTED`.

Do not equate exhaustive coverage of this finite set with proof that all possible bank threats are mitigated. Add counterexample tests when discovering uncovered paths, including tests that intentionally bypass caller-side validation to exercise the actual effect boundary.

---

## 8. Specific quality/security criteria for an offline release

**A. Functional:** At least one complete authorization-to-effect-to-evidence loop works through canonical DoubleTake code, and all supported enterprise ingress paths reach the same protected boundary. An error path does not mutate a protected fixture. End-to-end evidence is independent of agent prose.

**B. Security:** Every required deny/approval/SOD/permit/replay/race/tamper scenario passes with measured effects; independently test EG-I01 through EG-I08. Deny rules remain stronger than approvals. No untrusted policy evaluation, no arbitrary commands, no accidental network use, no live secrets. Unsupported operations fail closed.

**C. Isolation:** Enterprise effects are confined to named temporary synthetic-fixture directories. Unit tests may not overwrite production repo data, `AGENTS.md`, other mission evidence or global L0 policies. Tests must use deterministic clocks/IDs/seeds where possible, while checking real anti-replay and concurrency logic.

**D. Governance provenance:** Every new and modified path is in a valid approved FIC scope; acceptance evidence identifies exact retained source content. Include real ownership, license/third-party dependency inventory and clearly separate upstream DoubleTake from future bank-specific configuration. Current repository license statements are not proof of the user's employer-specific IP rights.

**E. Operational resilience:** Explicit errors, incident/recovery instructions, data-redaction expectations, bounded resource use, crash-safe local state changes as claimed, restart reconciliation and controlled fail-closed shutdown behavior. No uncaught exception should silently default to allow.

**F. Independent oracle and boundedness:** EG-05A verifies the committed journal and tenant separation without trusting self-reported PASS labels. All request sizes, execution durations, fixture budgets and recovery retries have tested limits; monitoring itself must not leak fixture data. `ANCHOR_ABSENT_UNVERIFIABLE` is an honest limited outcome, **not** a PASS for cryptographic attestation.

**F2. Reproducibility:** Core demo, focused tests and verifier run offline in a clean existing Python environment; no dependency fetch, live provider fallback or unrecorded test-only monkeypatch used as production enforcement. A fresh verifier may reject evidence because anchors/inputs are absent, but it must never manufacture the missing anchors.

**G. Readiness boundary:** Only the offline reference can be accepted. Explicitly mark `HOST_ISOLATION_UNVERIFIED`, `LIVE_IDENTITY_UNVERIFIED`, `EXTERNAL_EVIDENCE_ANCHOR_UNVERIFIED`, `VENDOR_CONFORMANCE_UNVERIFIED`, and `BANK_APPROVAL_UNVERIFIED` in the final output. These are honest **external gates**, not grounds to mislabel a local reference as bank-production-ready. Future bank readiness requires independent security review, OS/network isolation, real identity and secret controls, protected log storage, genuine vendor adapter conformance tests, threat modeling for the bank's use case, resilience exercises, change-management approval, licensing/IP review, and the institution's own acceptance. Keep these as documented **external open gates**, not blockers to a truthful offline-reference acceptance.

---

## 9. Progress, anti-loop rules, and reporting format

Follow an **implementation-first cadence**. Do not repeatedly rebuild every global proof after each unit, and never write hundreds of paragraphs to substitute for one line of behavior that is still missing. Begin with EG-01 once ownership and authorization are established. Implement small real changes, test them immediately, then integrate. Run expensive broader regression/certification only at stable checkpoints and when policy requires it.

At the end of each bounded work session write or print:

```text
MISSION: OFFLINE ENTERPRISE GOVERNANCE / EG-v7
REPOSITORY_HEAD: <actual full SHA>
WORKTREE_STATUS: <clean/dirty + only owned paths>
ACTIVE_WORKERS_AND_OWNERS: <observed; unknown explicitly marked>
AUTHORIZED_FILES: <actual applicable FIC IDs and permitted file paths>
IMPLEMENTATION: <EG units with real code paths + tests>
REAL_BEHAVIOR_ADDED: <exact last behavior/effect changed since prior checkpoint>
INTEGRATED_PATH: <entrypoint -> governance -> gateway -> fixture effect -> receipt>
SCENARIOS: <measured pass/fail/blocked counts for EG-S01..EG-S66; IDs and test artifacts>
INVARIANTS: <EG-I01..EG-I08 proved/unproven and independent tests>
TRANSACTION_SCOPE: <locally atomic vs nontransactional; known limitations>
TRUST_BOUNDARY: <gateway path proven? same-user direct-file bypass unverified?>
TEST_COMMANDS_AND_EXIT_CODES: <actual executions, including failures/timeouts>
INDEPENDENT_VERIFICATION: <executed/not executed, bound SHA, result>
OFFLINE_ASSERTION: <what was observed; whether any network/socket attempt occurred>
EVIDENCE_AND_STALENESS: <current manifests; missing/stale items>
EXTERNAL_UNVERIFIED: <Azure, Databricks, bank deployment, signatures, identity>
CURRENT_VERDICT: <PLANNED | ... | OFFLINE_ENTERPRISE_REFERENCE_ACCEPTED>
NEXT_CODE_TASK: <one specific permitted implementation action>
BLOCKERS: <precise authority, ownership, runtime, or test blockers>
```

Never use an arbitrary **percentage** based on commits, doc sections, lines of code, files touched or regenerated evidence. If requested, progress may be reported as `EG implementation units integrated/total` and `mandatory executed scenarios passing/66`, **with blocked/not-executed counted explicitly**, and never interpreted as percentage of bank production readiness.

### 9.1 Block/resume and non-destructive retry protocol

At the start of **every** new worker invocation, inspect and read the latest workstream record; compare its bound source SHA and owned-path digests with the current retained `main`; verify the last recorded test command **exists and was executed**, rather than trusting its previous PASS string. If the head changed in the measured surface, mark the affected evidence `STALE` before continuing. Execute the **first undone, authorized implementation dependency**; do not rerun all completed units or reproduce large prompt text.

Record distinct statuses `BLOCKED_BY_AUTHORITY`, `BLOCKED_BY_OWNERSHIP`, `BLOCKED_BY_RESOURCE`, `BLOCKED_BY_TEST_FAILURE`, `IMPLEMENTED`, `INTEGRATED`, `VERIFIED`, `PARTIAL`, `UNKNOWN`. Do not write or update an authority record as though its presence proved approval. A long run that reaches a boundary must leave a precise next edit/test task, file owner and verified state. On a durable test failure, preserve the failing counterexample as a regression fixture rather than repeatedly claiming progress by regenerating reports. If active peers edit a shared seam, work on disjoint code/tests or stop that seam; never seize it.

No continuous infinite loop, independent self-triggering scheduler or background cloud process is authorized by this directive. Resume through the existing approved DoubleTake worker/controller checkpoint mechanism. Every new worker must re-read repository state and the last truthful checkpoint before it edits. All prompts/workers must be able to inherit the durable workstream status but must not override ownership/authorization by claiming to be a successor.

---

## 10. Examples of expected local demo behavior (tests, not self-certified output)

Implement a single reproducible scenario run that can **demonstrate** the following, recording fixture-state deltas and independent verification:

```text
1. Principal finance-dev-01 requests restart of allowed dev job.
   Policy + trusted identity + effective permission => ALLOW.
   One fixture job restart is observed; receipt and audit are emitted.

2. Same principal proposes modification of a prod pipeline.
   The current effective policy requires independent approval.
   Result => PENDING_APPROVAL; fixture unchanged.

3. A separate fixture-trusted authorized approver issues a narrow grant
   for the exact prod artifact digest and resource.
   The same proposal executes once through the existing governance gateway.
   Replay of permit or swapping artifact contents => DENY, no second effect.

4. Requester attempts to disable audit, rewrite policy, or impersonate admin.
   Result => DENY. All protected fixture state remains unchanged.

5. An audit record is deliberately modified after the run **without** updating
   its bound digest. The read-only verifier identifies the integrity failure.
   If only a projection is rewritten, independently compare it to the unchanged,
   separately controlled authoritative journal and detect the mismatch. As a
   separate test, rewrite and re-chain **both** the disposable authoritative
   journal and projection **without a surviving independent trusted reference**;
   the verifier must return ANCHOR_ABSENT_UNVERIFIABLE, not pretend the
   coordinated rewrite can be detected. With a separately retained terminal
   pre-tamper anchor, a coordinated rewrite must be rejected.

6. A *separately modeled nontransactional adapter* crashes after an allowed
   effect but before final receipt. Reconciliation observes the fixture effect
   without blindly repeating it. Unobservable state remains OUTCOME_UNKNOWN.
   A fully transactional local fixture must instead recover its effect and
   journal consistently according to the same commit boundary.
```

The example is not complete until the tests call the **real consumers**, fixture state demonstrably changes only as authorized, and verifier output is mechanically derived. Provide an executable `demo` and `verify` command, not just this transcript or a screenshot.

---

## 11. Final outputs / delivery acceptance

At completion, deliver all **actual** artifacts under the authorized project structure:

1. Working Python enterprise-governance extension that uses the existing DoubleTake authority/gateway and supports offline synthetic fixture effects.
2. Strict contracts and policy/approval/permit enforcement with narrow, durable effect authorization and failure/replay handling.
3. Bounded Python Azure RBAC, Databricks catalog/job and deployment test doubles plus declared fidelity limitations.
4. Automated security, integration, failure-injection, recovery and no-network tests; exact safe reproduction commands and observed outcomes.
5. Independent read-only verifier and content-bound evidence manifest, without claiming an absent trust anchor.
6. Clear operator CLI/README and transfer/packaging documentation with no installed cloud provider requirement.
7. Threat model, reuse-gap matrix, scope/ownership evidence, regression results, EG-I01..EG-I08 evidence and all 66 scenario statuses.
8. A list of **unmet external production gates** necessary for an actual bank deployment, kept separate from the offline acceptance result. Include genuine human/IAM authentication, host/process isolation, policy/key custody, externally anchored audit, live adapter contract fidelity, penetration/security review and institution-specific operational acceptance.
9. Final truthful report identifying changed files, exact HEAD, whether changes were published, tests run, expected/measured outcomes and outstanding blockers.
10. An **offline transfer bundle** containing a versioned operator guide, Python compatibility/dependency manifest, deterministic synthetic fixtures and independent verifier instructions, with no employer or personal data, no embedded credentials, no claimed attestation, and explicit future live-adapter gates.
11. An independently reproducible **negative proof** that a forged green report, bypassed approval, and unauthorized direct adapter invocation cannot be accepted through the declared governance API. Do not claim this proves OS-level protection against a same-user process with raw filesystem access.

**The success condition is a tested and reproducible offline governance implementation, not a long architectural response.** If a critical requirement cannot be safely or authoritatively implemented, do not bypass it. Deliver the largest real validated subset and name the precise blocker, with no fabricated completion claim.

---

## 12. Execution start instruction

**Begin now, using actual repository state rather than assumptions from this directive:**

1. Inspect `AGENTS.md`, active missions, repo status, L0 extension ABI, L1 FIC scope, existing authorization and audit consumers.
2. Identify the smallest disjoint authorized EG-01 file/test changes. Reuse real components first.
3. Implement an integrated allow/deny synthetic local fixture vertical slice with evidence and tests. **Do not stop after writing a plan.**
4. If and only if its actual tests prove correct governed execution and ownership is uncontested, continue through EG-02 to EG-06, preserving local checkpoints and refusing to self-approve a prohibited change.
5. Certify once at a stable checkpoint via EG-07; publish an accurate report.

**Last-step quality audit:** Confirm the idempotency UNIQUE lookup key excludes mutable request digest/action/resource fields and that a new delivery ID or ambient policy drift does not turn an identical already-committed operation into a conflicting new request; confirm each retry authenticates the present caller and checks **historical-receipt visibility** separately from historical execution authority, denying sensitive receipt disclosure after principal disablement or loss of read permission; confirm a real pending request can advance only by an independently granted, freshly checked `PENDING_APPROVAL -> AUTHORIZED` transition, while terminal expiry/cancellation cannot be revived; `IDEMPOTENCY_CONFLICT` must win before re-execution for changed operation intent. Confirm recovery or oracle discrepancy cannot count as PASS. Check every declared mandatory scenario and invariant is actually executable, no contradictory success states exist, verification is independent of producer-written result fields, local transactions are not confused with nontransactional effects, **authoritative journal failure blocks pre-commit effects while projection failure does not undo already committed effects**, **projection-only tampering can be checked against a separately trusted unchanged journal, whereas coordinated journal-and-projection tampering requires an independent pre-tamper terminal anchor**, **approved local subprocess-based crash/concurrency tests do not get disabled by the no-network guard**, release claims match authority, all referenced files exist after creation, no cloud import/call was performed, and no protected/peer-owned source was edited without FIC authorization. Fix failing code and tests rather than lowering the criteria.

**Unifying principles:** One authoritative governance path. Python only. Offline by default. Real effects in synthetic fixtures. Independent verification. Clear separation of development self-evolution and bank operational authority. No bypass, no fake green evidence, no cloud or bank-readiness claim.
