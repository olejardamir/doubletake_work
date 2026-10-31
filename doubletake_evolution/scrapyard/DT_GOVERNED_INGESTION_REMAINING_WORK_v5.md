# DOUBLETAKE — GOVERNED INGESTION REMAINING-WORK MASTER v5

> **STANDALONE CONTINUATION / REPLACES THE ACTIVE MISSION PROMPT**  
> **Source inspected:** private `olejardamir/DT` `main`, latest observed commit `f87673cdb3` (2026-10-25 23:37:37 UTC).  
> **Source of requirements:** operator-supplied `DT_Evolution_Prompt_Governed_Ingestion_Agent_v3_10of10(1).md` and its repository copy `reports/governed_ingestion/mission_source.md`.  
> **Intent:** perform **only remaining engineering and acceptance work**. Never reset implementation or redo a completed scope solely because it existed in the earlier prompt.

## 0. Mission identity and governing precedence

This is **one continuation of the same Governed Ingestion mission**, not a new kernel, duplicate agent, duplicate workstream or alternative governance system. Treat the v3 source as a historical requirements record; **this file is the active task list**. The earlier `GOVERNED_INGESTION_V4_ACTIVE_DRIVER.md` remains supporting context, not a competing active execution driver. A running controller must explicitly load this prompt; a file on GitHub does not switch a live controller automatically. Confirm only when actually loaded.

Order of authority: `AGENTS.md` and current L0/L1/L2 governance/FICs → unwaivable original functional/security requirements → this remaining-work driver → prior v4 execution note where consistent. Work on the existing authorized branch/ref policy (currently main-only; no new branches/tags), obey the guarded local workload and host limits, and respect concurrent workers' uncommitted files. Do not claim permission from a prompt to bypass an FIC, user approval, code promotion gate or kernel restriction.

**Immutable constraints:** The minimal L0 kernel stays independent and without new ingestion business logic; L1 owns governance and promotion; L2 is specification-only; executable adapters live in the authorized outer runtime. Synthetic data and local fixtures only. No employer/client data, credentials, cloud dependency, real production integration, model downloads, or unreviewed foreign code. No direct agent execution, no arbitrary egress, no self-approval, no plaintext secrets in model context or outputs. All original security invariants remain mandatory even when their corresponding implementation package has already been built.

## 1. Repo audit snapshot — what is NOT to be rebuilt

The following was observed on GitHub at the stated snapshot and is deliberately **removed from this prompt's engineering task list**:

| Prior package | Observed reusable completion | Continuation rule |
|---|---|---|
| WP0a/WP0b | Baseline/authorization preparatory records validated (not mission-accepted) | Reuse records; do not repeat pre-change inventory from scratch |
| WP0c | Resumable checkpoint established, `CHECKPOINTED` in last stored state | Repair or rebind only when genuinely necessary for current source |
| WP1 | Foundation schemas, request envelope, contracts and fixtures; `VALIDATED_NOT_ACCEPTED` | Do not rebuild |
| WP2 | Identity and effective authorization; `VALIDATED_NOT_ACCEPTED` | Do not rebuild |
| WP3 | Targets and zone-policy implementation; `VALIDATED_NOT_ACCEPTED`, with recorded network-isolation limits | Do not rebuild or misrepresent real isolation |
| WP4 | Governed six-tool boundary; `VALIDATED_NOT_ACCEPTED` | Do not recreate registry or independent tool gateway |
| WP5 | Catalogue, request validation and canonical digest; `VALIDATED_NOT_ACCEPTED` | Do not rewrite from scratch |
| WP6 | Approval leasing, routing, revocation and suspension mechanisms; `VALIDATED_NOT_ACCEPTED` | Do not replace with a second approval system |
| WP7 | Secrets-by-reference with focused passing suite; `VALIDATED_NOT_ACCEPTED` | Do not reimplement the secret store |
| WP8 | Bounded agent-loop mechanism and deterministic mock; `VALIDATED_NOT_ACCEPTED` | Do not create another agent loop |
| WP11 **foundation slice only** | Audit metadata boundaries, synthetic event contract and 95 recorded passing checks in `reports/governed_ingestion/wp11_audit_slice/validation.json` | **Reuse the slice; WP11 integration and final security acceptance remain open** |

**Crucial distinctions:** `VALIDATED_NOT_ACCEPTED` does *not* mean accepted, end-to-end integrated, safe to activate or 100% complete in final acceptance terms. The last available `MISSION_STATE.json` was generated 2026-10-25 15:06 UTC at `b3ceceff1c`, behind newer commits; it lists WP1–WP8 validated, WP9–WP15 not started and no accepted/activated release. Subsequent WP9 code and WP11 audit work clearly exist, so **never take the stale state at face value**. There was **no committed `evidence/wp9.json`** in the last repository scan. The recent commits include WP9 scheduler repairs and a passing focused scheduler certifier, but do not prove the entire WP9 acceptance scope.

**What “remove 100% done” means:** Do not issue work instructions for any previously implemented and independently validated component listed above. Retain compatibility regressions and cross-package integrations as genuine *new* work, not redoing their isolated implementations. If actual source drift invalidates one of these items, describe the exact regression/changed contract and repair narrowly—do not reopen an entire WP without cause.

## 2. First actions on live checkout — maximum one short triage pass

1. Print `git rev-parse HEAD`, remote/main reference, `git status --porcelain`, current active driver and worker ownership. Protect other agents' edits. Read `AGENTS.md`; verify mandatory host-guard syntax (`python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` or latest equivalent).
2. Read actual `reports/governed_ingestion/MISSION_STATE.json`, `evidence/` and `wp11_audit_slice/validation.json`, plus source/tests of WP9–WP15. Inspect any local changes not yet pushed. Distinguish **committed**, **local**, **validated**, **integrated**, **accepted**, and **activated**.
3. Build a **delta-only** manifest: completed-and-reused features (references only), remaining feature/test gaps, source ownership, authorized FIC, dependencies and immediate runnable coding tasks. No full-system evidence generation at startup.
4. If old v3/v4 workers remain active on the same files, coordinate a clean handoff; do not create competing controllers or kill unknown processes. Report `ACTIVE_DRIVER_CONFIRMED` only when control actually switched.
5. Prioritize **functional WP9 closure and WP10** before generating another cascade of WP1–WP8 evidence. Assign independent WP11/WP12/WP13 work only to disjoint owners with stable interfaces and necessary authorization. Existing host guard requires bounded, sequential guarded experiment runs; **parallel code edits do not authorize parallel guarded suites**.

## 3. Execution model — implement remaining code, integrate, certify

**Phase A — remaining code and focused tests:** Complete uncovered functions in WP9, implement WP10, finish WP11 beyond its audit slice, develop WP12 UI/API and WP13 adapters. WP14 decision experiments may be designed in parallel. Build only missing behavior after inspecting repository. Each change must have focused tests and negative security tests at its effect boundary; preserve valid prior behavior. Do not regenerate entire mission ledger for every commit.

**Phase B — actual connected synthetic system:** Prove request → catalogue validation → requester/executor policy → immutable independent approval → runner/tool gateway → allowed source → quarantine/inspection → atomic landing → audit/status → accessible local API/UI. Prove recurring scheduling/revocation, retention, fault recovery, stale policy, component compatibility and rollback as applicable. Mock model required; no live cloud. Only a real end-to-end test qualifies as E2E evidence.

**Phase C — independent final verification and closure:** At a stable retained checkpoint, one designated certifier coordinates scenario/invariant matrix, affected regressions, L0 independence, WP evidence, decision records, risk and threat registers, conformance, promotion and rollback. Re-run earlier package proofs if their measured surfaces actually changed or the mandatory evidence contract requires it; never falsify freshness, and never refresh unaffected records just for a higher commit count. No security shortcut for speed.

**Anti-churn rules:** One implementation owner per file; no competing writes on shared `main`. Inspect test collection to prevent recursive suites spawning themselves (previous umbrella suite cost >800 seconds). Prefer narrowly scoped tests and explicit dependencies. After two unsuccessful identical repair attempts, diagnose root cause and change strategy. A report-only or self-referential evidence commit is not implementation progress. Do not invent a progress percentage; report counts of functionality implemented/integrated, tests and unclosed obligations.

## 4. Active work and exact definitions of done

The following are the **remaining work-package specifications**, retained from the operator's source prompt. Prior WP0–WP8 build specifications are intentionally omitted. Sections WP9 and WP11 already have partial implementations: **assess and fill deltas, not a blanket reimplementation**.

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

## 5. Mandatory security constraints and invariants — still applicable to *remaining integration*

These obligations are **not requests to rebuild WP1–WP8**; they define checks and protections any remaining WP9–WP15 changes must preserve and finally demonstrate. A prior isolated unit test is not evidence that a new integrated API or scheduler cannot bypass the same gate.

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

## 6. Final synthetic evaluation scenarios — execute at integration/certification

The scenarios remain requirements unless a fresh independent integrated proof closes them. Their presence here is **not** an order to rerun an already valid independent focused test after every code change.

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

## 7. Decision-record format

## 8. Decision Records and Exact Traceability Format

Each record under `docs/governed_agent/decision_records/` includes: question and gap IDs; authority/dependencies; implemented options and explicit missing ones; deterministic fixture and environment; exact test command and exit code; evidence paths/digests; measurements (including negative results); security trade-offs; cost/latency/resource implications where measurable; conditional recommendation (“prefer A when ...; B when ...”); residual risks; and what real deployment would have to prove.

A simulated non-technical persona is a **scripted test**, not an observed human-user outcome. A simulated delegated principal is an authorization test double, not evidence of real identity-provider delegation. Do not label such findings as production validation.

## 8. Honest evidence and completion policy

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

## 9. Exclusions

## 12. Explicit Exclusions and Honest Limits

- No employer or client infrastructure, real corporate architecture, confidential documents, actual user data, real organizational identities or credentials.
- No real identity provider, production encryption/HSM integration, cloud storage, enterprise job engine, real SFTP/HTTP external source, privilege grant or deployment.
- No selection of organizational policy, hosting, risk appetite or approval structure as if already authorized.
- No use of external proprietary code or unreviewed repository code inside the DT process; public architecture and generic engineering concepts may inform **independent DT-native implementation**.
- No claims of production security, malware detection, cryptographic immutability, universal correctness or zero exfiltration beyond the explicitly tested local threat model.
- No universal hot-reload claim; unproven activation is deferred rather than simulated.
- No creation of permanent new cores, global managers, governance bypasses or alternate full-stack applications.

---

## 10. Remaining deliverables only

- WP9: completed connector/runner/scheduler/quarantine/landing/retention capabilities with tested local folder, HTTP(S), SFTP, upload, archive safety, retries, leases, recurrence and crash reconciliation, **only for features still missing**. Record unsupported transports as `BLOCKED`/`DEFERRED`, not as success. Publish coherent independent WP9 evidence when its full focused scope passes.
- WP10: durable request/job status state machine, authorized filtered outcomes, transitions, cancellation, retryability and crash reconciliation; tested integration with existing approval and scheduler.
- WP11 residual: integrate the **existing** hash-chain/audit foundation with runner, scheduler, API and permission-filtered reporting; prove chain verification/anchor limits, secret/redaction safety and threat-model residuals. Do **not** rebuild the already validated WP11 foundation slice.
- WP12: authenticated, role-safe local API/UI in the current FastAPI/React stack, browser CSRF/origin controls and authenticated direct-call negative tests; no parallel app or alternate auth scheme where existing mechanisms suffice.
- WP13: versioned contract conformance, native launch, safe evolution/activation integration, in-flight pin/drain and rollback (or explicitly documented unproved/deferred behavior); integration guide without actual enterprise endpoints.
- WP14: controlled matched comparisons and conditional decision records for G1/G3/G4/G5/G6/G9/G10/G23/G24 based on executed measurements, not model prose.
- WP15: threat/risk/evidence register, remaining G1–G32 outcomes, S1–S43 and SI-01–SI-10 final linked evidence, genuine synthetic E2E demo, guarded regressions, truthful final acceptance/activation decision.
- Preserve the already-delivered original capabilities and their source-test traceability; no mandatory duplicate implementation of WP0–WP8.

## 11. Done conditions / stop conditions

A `DONE` claim requires: required end-to-end behavior executes with deterministic mock in no-cloud local mode; every mandatory feature's actual tests pass; every applicable S1–S43 and SI-01–SI-10 is backed by fresh sufficient evidence (including integrated bypass attempts); every G1–G28 has a truthful CLOSED or DECISION_READY state or explicit unresolved qualification; G29–G32 remain expressly outside local organizational verification; L0 independence and existing DT regression proofs are not compromised; controlled component activation/rollback is demonstrated where required; the authorized decision is recorded. **No mission completion merely because all WP source files exist.**

If authorization/host/integration blocks are genuine, leave a precise `PARTIAL` or `BLOCKED` report and continue with safe independent work. A failure of a protected security invariant blocks affected promotion; do not weaken it.

## 12. Output required at each meaningful checkpoint

```text
MISSION: GOVERNED_INGESTION_REMAINING_WORK_v5
SOURCE HEAD BEFORE / AFTER: <SHAs>
ACTIVE DRIVER: CONFIRMED | NOT_CONFIRMED
EXISTING IMPLEMENTATIONS REUSED: WP0a–WP8, WP11 audit slice (only if verified), precise exceptions
NEW CODE AND INTEGRATED BEHAVIOR: <exact changed functionality and test paths>
WP9–WP15: <IMPLEMENTED/LOCALLY_TESTED/INTEGRATED/VALIDATED/ACCEPTED/BLOCKED with evidence>
REGRESSION AND SI STATUS: <actual guarded commands, collected/passed/failed>
G1–G32 / S1–S43 / SI-01–SI-10: <accurate evidence-backed state; don't invent totals>
GLOBAL CERTIFICATION STATUS: <not run / partial / current>
ACCEPTANCE AND ACTIVATION: <actual authority and deployed version or NONE>
BLOCKERS: <specific technical/governance issues>
NEXT ACTION: <one bounded coding or integration step with owner>
```

**Execute work immediately; do not merely describe this plan. Avoid remaking completed packages.**
