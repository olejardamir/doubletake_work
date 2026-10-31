# DOUBLETAKE_GOVERNED_INGESTION_AGENT_EVOLUTION_MASTER_v4

> **EXECUTION MISSION — IMPLEMENT FIRST, INTEGRATE SECOND, CERTIFY LAST**
>
> **This is a complete operational continuation directive, not permission to restart the mission, reduce its scope, or relax its governance.** Resume the existing v3 mission at the latest verifiable source state. Deliver its entire capability, not just a set of passing isolated tests.

## Document control and exact inheritance

| Field | Binding instruction |
|---|---|
| Mission | Governed Ingestion Agent, native to DoubleTake |
| Version | **v4 — implementation-first, test-as-you-build, integration-second, certification-last** |
| Supersedes as active driver | `DT_Evolution_Prompt_Governed_Ingestion_Agent_v3_10of10.md` / `DOUBLETAKE_GOVERNED_INGESTION_AGENT_EVOLUTION_MASTER_v3` |
| **Authoritative complete v3 specification** | `reports/governed_ingestion/mission_source.md` in `olejardamir/DT` |
| Existing state and checkpoint | `reports/governed_ingestion/MISSION_STATE.json` |
| Existing baseline and reuse map | `reports/governed_ingestion/BASELINE.json`, `reuse_and_impact_matrix.json` |
| Existing per-package evidence | `reports/governed_ingestion/evidence/` |
| Integration authority | Existing L0 kernel, L1/FIC governance, approved tool gateway, existing mission management and current `AGENTS.md` |
| Repository | `https://github.com/olejardamir/DT` — work on the current authorized checkout; respect shared-`main` coordination |
| Data | Synthetic data and approved local test servers/files only. No employer/client data or credentials. |
| Completion | All original v3 goals, G1–G32, SI-01–SI-10, S1–S43, WP0–WP15, required deliverables, proofs, and acceptance rules — **unchanged**. |

**The v3 source document is a normative part of this v4 mission.** Read its *entire* contents before execution. Its detailed gap-register wording, scenario assertions, ownership, nonfunctional requirements, acceptance obligations, and explicit exclusions are incorporated by reference as binding requirements, even if a clause is not repeated verbatim below. **This v4 changes the execution plan and scheduling of global acceptance/evidence work only.** Where these instructions conflict with v3 sequencing or “finish/certify WP before starting next” wording, v4's implementation-first sequencing controls. In every other conflict, apply the **stricter safety, authorization, test, or evidence requirement**. If the original source cannot be read and verified, record `BLOCKED_SOURCE` instead of guessing requirements.

**Historical state, not an assertion of current progress:** during the October 24, 2026 inspection, WP1 and WP2 had `VALIDATED_NOT_ACCEPTED` records, WP3 implementation/certification commits were appearing, the mission-state checkpoint lagged behind GitHub HEAD, and no overall mission acceptance or activated release was recorded. Reassess everything against **current** source and independent records on startup. Do not carry forward 22% or any other subjective estimate as a state variable.

---

## 0. Non-negotiable outcome and architecture

Build a reusable, governable **inward-only** ingestion system in DoubleTake. A requester expresses a data need; DT produces a bounded, schema-valid draft; requester and executor rights, catalogue, target scope and policy are checked; **another authorized principal approves the immutable operation**; a bounded, registered connector fetches allowed synthetic source data; material is quarantined and inspected; an authorized artifact is published atomically to an allowed local landing target; audit/status are recorded with minimal data exposure. It supports local deterministic mock-provider testing, recurrence, recovery, suspension, cancellation, independent evidence, native API/UI access, versioned adapters and DT-native evolution.

Preserve these constraints **through every phase**, not only final certification:

1. **One existing minimal L0 kernel.** No alternate kernel, hidden action executor, parallel policy authority, sidecar manager, duplicate scheduler authority, or changes that make L0 dependent on models, UI, network or upper layers. A rare L0 contract change requires specifically authorized FIC and independent proof; prefer external adapters.
2. **L1/FIC ownership and current AGENTS.md prevail.** All source edits must be authorized in the current DT governance system; first identify the existing owner and reuse it. `L2` remains proposal/specification, not executable implementation.
3. **No bypass for speed.** Never permit unapproved execution, secret exposure, unapproved egress, arbitrary shell/tool execution, dynamic connector installation, self-approval, cross-user access, or unsound status/proof shortcuts.
4. **Synthetic local research scope.** No organization/private data or credentials; no cloud/network egress at test time except explicitly authorized local fixture traffic; no downloads of models, packages or proprietary code unless independently authorized under original constraints.
5. **Shared-main safety.** No force pushes, no deleting peers' work, no unreviewed branch policy changes. Allocate narrow nonoverlapping file ownership and inspect `git status` and latest HEAD before staging or committing.
6. **Host protection.** Use `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` or current `AGENTS.md` equivalent. Maintain the existing concurrency limits, timeouts, worker and budget controls.
7. **Truthful outcomes.** `IMPLEMENTED`, `VALIDATED`, `ACCEPTED`, `BLOCKED`, `UNRUN`, `UNRESOLVED`, `NO_CHANGE`, `DECISION_READY`, `DEFERRED`, `REJECTED` are distinct. A passing unit test does not imply an accepted or active component. Do not claim deployment-ready or organizational adoption.

**The target is not “code everything, discover whether it works at the end.”** The target is **implement every component with immediate targeted tests and contract compatibility, integrate already-tested components in a deliberately bounded system-wide pass, and perform expensive independent evidence/closure at stable checkpoints.** This maximizes useful parallelism without accumulating an untestable pile of code.

---

## 1. New execution algorithm — mandatory

### Phase A — Inspect, classify, freeze contracts and allocate ownership (one bounded pass)

**Read:** entire v3 mission source; AGENTS.md; current seed/L0 invariants; L1/FIC validator; existing mission manager and work-owner arbitration; latest Git state; baseline, mission state, reuse matrix, relevant existing tests and all evidence already committed. Capture a *new lightweight checkpoint* with the current head and factual statuses. **Do not regenerate the entire baseline, global ledger, end-to-end scenario register and closure report just because HEAD moved.**

For WP0–WP15, create a dependency/ownership manifest recording:

- existing authoritative owner/module, intended source paths and required FIC scope;
- needed public interfaces (types, data, version, error semantics, authorization semantics);
- exact dependent work packages and consumers;
- already verified behavior, code-only implementation, missing work and source-bound evidence;
- targeted positive/negative/security/contract test commands;
- independent edit owner, integration owner and acceptance/evidence coordinator;
- expected output and an unambiguous **definition of implemented** distinct from **definition of accepted**.

**Before parallel implementation:** freeze interface contracts and minimal representative mock fixtures to catch structural disagreements early. If a dependency is absent, create only a contract test double that will later be replaced; declare it clearly. Avoid deadlock by allowing dependency-independent source work on blocked units, not premature activation or assertions of integration.

Do not replay WP0, WP1 or WP2 if their existing implementation and tests remain valid. In particular, use existing `tools/doubletake_evolve/governed_ingestion/` code, tests and `reports/governed_ingestion/evidence/wp1.json` / `wp2.json` as real starting points. Inspect whether WP3 already landed. Fill gaps only; **do not rewrite validated code for aesthetic consistency**.

**Gate A:** all proposed edits have a valid FIC-authorized owner, interfaces and file ownership, noninterfering worker plans, known baseline fail inventory, and reproducible tests. If authorization blocks a work package, report and pursue independently authorized work; never bypass FIC.

### Phase B — Implement every work package, with targeted tests **at the time it is coded**

Implement remaining WP1–WP15 as a coordinated build. Parallelize where source ownership and dependency contracts are disjoint. Every agent is responsible for **working code plus runnable tests**, not final mission closure artifacts.

For each bounded implementation slice:

1. Find and reuse the actual existing component owner. Identify the intended behavior and acceptance contract from v3.
2. Write a failing behavior/contract/security test where applicable (or point to an existing failing test with independent reproducibility).
3. Implement the smallest coherent feature; avoid unnecessary abstractions, placeholders, duplicate stores and stub-only “implementations.”
4. Run targeted positive, negative, security-invariant and contract compatibility checks through the workload guard. Run neighboring regressions when changed dependencies require them.
5. Repair every introduced failure before claiming the slice `IMPLEMENTED_TESTED`. If an unrelated baseline failure persists, record its existing signature and do not turn it green by changing the test.
6. Produce a **lightweight build receipt** (unit ID, changed code SHA, actual tests/exit codes, dependency versions, observed behavior, limitations, integration obligations). This is development bookkeeping, **not** independent final acceptance.
7. Commit only owned, valid changes under shared-main rules. If a peer lands a newer commit, rebase/reconcile as prescribed by the existing main-only collaboration scheme rather than regenerating global evidence.
8. Immediately choose the next independent runnable implementation slice. Do not block all implementation on a costly global checkpoint refresh unless a real contract/security dependency is invalidated.

**Continuous local testing is mandatory. Global acceptance/evidence consolidation is deferred.** A security failure blocks the affected interface and any dependent integration, but it need not stop unrelated work packages.

### Phase C — Integrate the already-tested packages into the **real** end-to-end capability

After the necessary implementations and interfaces exist, connect them through existing DT runtime and authorization surfaces, in controlled increments. Use the *actual* API, UI, worker, tool gateway, scheduler and version resolver wherever the original mission requires; a scratch import or synthetic direct function call is not proof of live ingress. The first integrated vertical slice is:

`synthetic requester → authenticated identity → constrained draft → catalogue/policy validation → independent approval/lease → L0-governed tool boundary → local file connector → quarantine + inspection → atomic landing → status/audit`

Then exercise local HTTP/SFTP fixtures where specified; recurrence, revocation, cancellation, retries, crash recovery, job/suspension and retention paths; user-facing API/UI; adapter conformance and versioned activation/rollback; audit chain and secrecy probes.

At each integration seam, require one positive consumer-path test and at least one relevant negative test. If the seam fails, repair the **actual** producer/consumer incompatibility and repeat the smallest relevant integration test. Do not rewrite all packages, do not add a second run manager, and do not fake a production path with an isolated function fixture.

**Gate C:** a complete locally functioning synthetic end-to-end system exists, exercised from its actual supported entrypoints, with no known new critical safety violations; all mandatory WP implementations and focused/neighbor tests are accounted for. Remaining FIC approvals and final certifications must be explicit, not inferred.

### Phase D — Stabilize source and independently verify **once at a controlled checkpoint**

Nominate **one final evidence coordinator**. Freeze a stable integration checkpoint (no competing relevant writes) and run the entire v3 independent evidence program in dependency order:

1. Verify source/FIC/module versions and prove provenance from the selected commit; reconcile baseline before/after and known pre-existing failures.
2. Regenerate required **per-WP** source-bound evidence records over the integrated implementation, including WP0–WP15.
3. Run **all original G1–G32** gap obligations with their stated closure semantics; record true `CLOSED`, `DECISION_READY`, `BLOCKED`, etc.
4. Execute **SI-01–SI-10** adversarial tests and **S1–S43** scenario matrix; trace each to actual commands, assertions, component versions, and evidence digests. No `PASS` from existence of a fixture or a generated report alone.
5. Run deterministic model/mock tests, real local source/landing paths, replay, idempotency, cross-user authorization, rejection and recovery, API/UI integration, versioned activation/rollback, independent audit verification.
6. Run applicable L0/L1/L2 proofs, changed-source regressions, and the supported full-product validation matrix **through the host guard**, dividing large runs without falsely claiming a full-suite pass. Preserve baseline errors separately.
7. Create decision records comparing actually implemented alternatives with the same synthetic fixtures and resource limits; label simulated identities and scripted personas accurately.
8. Verify a successor can resume from committed source, receipts, and checkpoint without replaying approvals, double-landing outputs, or fabricating completed work.
9. Publish the authoritative acceptance/evidence register and mission closure **only after** all required checks are complete and the selected HEAD is consistent.

If the source changes after the freeze, invalidate **only the verifiably affected records** in the dependency graph, rerun their required tests, and regenerate the smallest legitimate affected evidence suffix. If the verifier intentionally binds all of HEAD, honor that constraint: hold nonessential writes until the verification sweep ends. **Never remove a necessary source-head binding to suppress churn.**

### Phase E — Activation, handoff, final outcome

Activate/version-bind only components whose DT authorization and real compatibility gates pass. Demonstrate subsequent normal requests use the accepted active implementation and that unsafe versions can be rolled back; retain in-flight version continuity. If current environment cannot support activation, report `VALIDATED_NOT_ACCEPTED` or `BLOCKED` explicitly; do not invent a release pointer.

Final result must be exactly one of `ACCEPTED`, `VALIDATED_NOT_ACCEPTED`, `PARTIAL`, `BLOCKED`, or `REJECTED`, with evidence supporting the scope. No unconditional 100% claims. Persist last verified head, version, tests, open items, next bounded runnable action, and handoff instructions.

---

## 2. Work package implementation contracts — no omitted scope

The following is a minimum executable build and test plan. **The exact additional v3 text, tables, test cases, and definitions remain mandatory.** Code already validated should be reused. Every package requires positive and negative checks tied to source HEAD; complete formal evidence can wait until Phase D.

### WP0 — Existing baseline, FICs, owners and resumable checkpoint

- **Reuse:** current baseline, mission-state generator, FIC plan, reuse/impact matrix, source inventory, `AGENTS.md` and prior failure census.
- **Implement only missing:** genuine authorization and ownership of implementation units, source-digest linkage, status derivation and restart-safe handoff. Do not confuse approval of *report location* with authorization of *source implementation*.
- **Local tests:** a successor loads/validates checkpoint after state changes and does not double-apply prior work; FIC validator distinguishes authorized and unauthorized paths; known baseline failures are preserved.
- **Interface for others:** immutable mission ID, WP IDs, dependency status, source-head and evidence links. Completion of paperwork is not feature completion.

### WP1 — Minimal, extensible typed foundations

- **Reuse:** `IngestionRequest`, `Connector` and other already implemented and validated types; DT existing `ExecutionContext`, `AuthorizationDecision`, gateway and governance contracts.
- **Implement only missing:** immutable request identity/digest, typed schema versions, request/catalogue/policy revision tracking, bounded mock fixtures and connector/consumer compatibility, no new L0 package.
- **Local tests:** strict fixture loader, invalid schemas rejected, cross-version conformance, no direct action dispatch by a request object; previous L0 seed tests not regressed.

### WP2 — Requester, executor, service/delegated identity and effective rights

- **Reuse:** existing measured rights-intersection code and current governance policy decision bridge.
- **Implement only missing:** actual role/scope revalidation at use, identity trace continuity, tested simulated delegated mode, deny reasons, confused-deputy defenses and caller provenance.
- **Local tests:** requester lacks right while service has it => deny; executor lacks right while requester has it => deny; unknown principal/role revocation/alias crossing => deny; current policy controls every action. Distinguish fixture delegation from actual delegated credentials.

### WP3 — Execution targets, zones and enforced isolation

- **Implement:** registered local execution targets, authorized source zones and destination boundaries, executor isolation, quotas, resource ceilings and real effect restrictions; reuse DT data isolation and the tool gateway.
- **Local tests:** wrong-zone source, destination classification mismatch, cross-user target access, forged target ID, target suspension and resource cap violations block before an external effect. Existing WP3 code/commits must be inspected and retained when valid.

### WP4 — Controlled tool set and non-bypassable action boundary

- **Implement:** typed actions registered/certified in the existing tool registry and guarded by profile, policy, approval and active component version. No “execute arbitrary request” tool exposed to the LLM.
- **Local tests:** direct bypass call, unregistered tool, tool substitution, prompt-injected command and policy/catalogue mutation all fail before downstream effect; approved tool executes under correct authority.

### WP5 — Canonical request, catalogue and strict preflight

- **Implement:** schema-constrained draft/request and immutable catalogue of approved local sources/destinations; provenance, classification, retention, purpose, file constraints, catalogue revisions and approval workflow; guided-form/template/chat must converge on one validator.
- **Local tests:** missing or extra schema fields, altered target, unknown catalogue item, forbidden source, changed limits and stale policy revision fail. No model-generated policy or dynamic destination substitution.

### WP6 — Independent human approval, immutable leases and emergency suspension

- **Implement:** real independent approval with subject/principal checks, digest-bound exact operation, limits, expiry, revocation, dual-approval cases and single-use atomic lease; reuse existing human-review store, do not build parallel approval authorities.
- **Local tests:** requester self-approval, same principal through second role, expired/superseded approval, after-approval edits, revoked rights, double claim by concurrent workers, and suspension all prevent unauthorized execution.

### WP7 — Secrets by reference only

- **Implement:** synthetic secret handle resolution inside authorized connector execution, never in agent/model context, structured request, UI/API responses, persisted logs or reporting. Reuse established credential and redaction surfaces.
- **Local tests:** planted canary secret absent from generated prompts, traces, exception text, metrics, error payloads and API; inaccessible or revoked handle fails closed; credential rotation invalidates stale use.

### WP8 — Bounded agent reasoning, tool mediation and model independence

- **Implement:** model/provider abstraction with deterministic mock, bounded planning/context/token and time budgets; restricted request-draft output schema, allowed tool catalog from policy and safe instruction/data separation. No model decides authorization.
- **Local tests:** ambiguous goals, adversarial instructions, malformed model outputs, over-budget models, unavailable provider and source-text prompt injection cannot grant privileges or execute actions. Mock path must work offline.

### WP9 — Governed local connectors, quarantine, publication, recurrence and recovery

- **Implement:** local-file and required local HTTP/SFTP test connectors; restricted URL/DNS/redirect rules; quarantine and safe archive handling; inspection policy; atomic publish; retention; recurring schedule; idempotency, failure recovery, cancellation and lease revalidation on **every** scheduled attempt. Reuse current background-work/job and mission manager ownership.
- **Local tests:** S1–S3 happy paths plus forbidden redirect, DNS rebinding, symlink/path traversal, decompression bound, malformed content, connector timeout/retry, interrupted publication, duplicate schedules, expired/changed approval and suspended targets. A timer firing is not proof the governed job safely ran.

### WP10 — Truthful status, result reporting and filtered traceability

- **Implement:** requester/approver/auditor-specific projections of draft, approval, active execution, cancellation, completion, failure, result receipt and retention. Filter source payloads and secrets; include revision, reason and job identity.
- **Local tests:** forged request ID, out-of-role list/detail access, stale job status, fake success/partial result and cancellation race. A completed job must link to actual landing, not just a success string.

### WP11 — Hash-chained audit and minimum-observation leakage

- **Implement:** append-only event semantics with source-bound digest integrity, protected local anchor where supported, sanitized role views and receipt linkage. Do not claim local writable logs are invulnerable to a fully privileged adversary.
- **Local tests:** bit flip, deletion, reorder, replay, forged success, broken digest chain, mismatched anchor and seeded sensitive values. Record known limitations honestly.

### WP12 — Actual FastAPI/UI entrypoints with independent server-side security

- **Implement:** integrate routes into existing API without catch-all shadowing, actual approved operations and status; existing React UI paths and API client; sessions, allowed origin/CORS, role checks and applicable CSRF protections. Loopback-only local test services.
- **Local tests:** actual HTTP request and browser/UI flows as the user would invoke them; direct API attack without UI, session expiry, cross-user ID guessing, invalid CSRF/origin, unauthorized approval and no hidden side-effect path.

### WP13 — Versioned adapters, compatible activation, rollback and native packaging

- **Implement:** conformance for identity, authorization, secrets, approval, connector, model, target, audit, scheduler and lifecycle interfaces; native single-host start with no required containers or downloads. Reuse DT release activation and rollback contracts.
- **Local tests:** incompatible version, stale import/handler, migration conflict, in-flight version pinning, candidate rejection and rollback, new connector registration through existing extension seam, retained baseline operation.

### WP14 — Controlled design comparisons and decision records

- **Implement:** actual local alternatives required by v3, such as service versus simulated delegated identity, direct versus gated request, chat versus guided form/template/hybrid, target placement, approval granularity, connector options, scheduling, audit and packaging choices.
- **Local tests:** comparable deterministic fixtures, defined metrics, cost/latency/resource/authorization differences and relevant negative controls; don't assert that unimplemented alternatives were compared. A scripted persona is not a human study.
- **Output:** evidence-based conditional decisions with residual risks and a list of what would need real organizational verification (without connecting to any organization).

### WP15 — Threat model, traceability, risk and final mission closure

- **Implement during Phase B:** threat-model code/config/tests, risk register skeleton and **evidence schema/validator** only; do not run recurring global final certification yet.
- **During Phase D:** complete gap-to-source-to-test-to-evidence mapping for all original 85 tracked obligations (G1–G32, SI-01–SI-10, S1–S43), full negative-case matrix and independent closure. Reconcile documented open risks and security boundaries.
- **Local tests:** detector rejects missing/forged/zero-test/stale/unauthorized evidence, invented policy approval, blank acceptance authority and partial outcome represented as success.

---

## 3. Security invariants — enforce while coding, certify globally at end

The original security and privacy design is not deferred. Every affected code edit must continue passing focused negative tests for these ten invariants. Phase D checks the **complete** matrix independently.

| ID | Invariant |
|---|---|
| **SI-01** | No execution without valid schema, current policy and independent approval. |
| **SI-02** | No model/agent/tool/provider bypass of approval or arbitrary side effects. |
| **SI-03** | No privilege or requester-right expansion and no agent-granted data access. |
| **SI-04** | No plaintext secrets in persisted, logged, UI/API, error, metric or model-visible artifacts. |
| **SI-05** | No forbidden egress, exfiltration, proxy/redirect/DNS bypass or unapproved onward transfer. |
| **SI-06** | No cross-user private request, payload, approval or audit disclosure. |
| **SI-07** | No unsafe/quarantined/unapproved material successfully published to landing. |
| **SI-08** | Recurring, resumed, retried and concurrent jobs meet **current** original authorization requirements. |
| **SI-09** | L0 remains minimal, independent and the sole governance root. |
| **SI-10** | No doctored, stale or false progress/PASS claims. |

Required coverage includes: localhost exposure/auth/cookie/CSRF/CORS; strict typed model input; unsafe YAML/pickle/eval/shell; archive/path/race protection; per-connection SSRF/DNS validation; TLS/host pins where applicable; per-principal quotas; independent approvals; revocation; safe interruption; protected audit anchor limitations; redaction; immutable operation digest; safe error projections; version rollback and traceability. Use the original v3 detailed requirement table as the exact test oracle.

---

## 4. All original S1–S43 cases must be independently demonstrated

Do not replace the original scenario definitions with this compact coverage index; inspect and satisfy the full wording in the incorporated v3 mission.

| Scenarios | Required actual behavior |
|---|---|
| S1–S3 | One-time, recurring, and local user-file ingestion succeed only after proper governance. |
| S4–S6 | Unapproved catalogue source, destination rights and classification conflicts denied. |
| S7–S10 | Outbound transfer, source/request injection and secret requests cannot create unauthorized effects. |
| S11–S15 | Self-approval, exceeded limits, expired lease, service/delegated and unauthorized trigger correctly constrained. |
| S16–S18 | Zones, malicious archive and forbidden redirect denied safely. |
| S19–S21 | Retries are idempotent, catalogue change governed, audit tampering exposed. |
| S22–S24 | Recurring auth revocation, suspension, and quotas enforced immediately. |
| S25–S28 | Inspection failures quarantined; failed jobs atomic; cross-user reads refused; cancellations stop future work. |
| S29–S30 | Ownership-independent and required multi-party approvals strictly enforced. |
| S31–S33 | Retention, request-edit digest invalidation and postapproval policy/catalogue change revalidation. |
| S34–S36 | Single-use concurrent lease, crash recovery, and DNS/redirect/proxy escape proof. |
| S37–S40 | IDOR, disallowed Origin/CSRF, planted sensitive data and protected audit anchor. |
| S41–S43 | In-flight component version, missing validation command and suspension of running/scheduled work. |

**Per scenario final record:** scenario ID, exact asserted expectation, actual executing entrypoint, positive/negative fixture, command under host guard, source SHA, collected/assertion counts, outcome, output digest, limitations and verdict. A result is not PASS if the corresponding real consumer path was never invoked. `NOT_APPLICABLE`, `BLOCKED`, `UNRUN` and `UNRESOLVED` remain explicit non-PASS classifications for mandatory closure.

---

## 5. Explicit anti-stagnation and proof-churn policy

### Never do this again

- Implement one isolated slice; regenerate all old evidence; re-pin the mission checkpoint; regenerate final closure; repeat for each new commit.
- Have multiple agents simultaneously edit the same global ledger, mission-state JSON, FIC registry or source-head-bound artifact.
- Have a worker spend repeated iterations making an evidence file agree with itself while real functional work remains unimplemented.
- Revisit existing completed WPs simply because a new peer commit moved HEAD, without determining which source or proof dependency really changed.
- Count commits, regenerated JSON files, green mocks, model assertions or completion percentages as user-visible functional progress.
- Bypass mandatory checksum, proof, source-head, approval or FIC policy to make validation “go faster.”

### Instead do this

1. Keep **code owners**, one **integration owner**, and one **final evidence owner** distinct; reserve global reports for the evidence owner.
2. Implement disjoint WPs in parallel when stable typed interfaces permit. If two tasks need the same owner file, serialize that file's changes through existing arbitration.
3. During build, produce **small changed-component receipts**, focused tests, contract tests and security ablations. Do not perform expensive whole-mission re-derivation in every iteration.
4. Before global final verification, stop unrelated shared-main commits long enough to bind a consistent source checkpoint.
5. If original strict source/HEAD bindings necessarily invalidate with every change, **schedule consolidation after source freeze**, not by weakening the bindings.
6. For two successive attempts that fail from the same diagnosed cause, do not retry the same edit/command unchanged. Switch to a different valid implementation, repair the verified root cause, or record a precise blocker and move to independently runnable work.
7. Introduce test doubles only behind versioned contracts and never classify a mock-only success as real connector, UI, scheduler, provider or production behavior.
8. If a mission requirement cannot be satisfied because of permissions or no actual provider/deployment, keep the result `BLOCKED` and document the smallest next authorized action; continue permitted independent work.

### Progress reporting: three separate numbers

Report **implementation coverage**, **integrated operational coverage**, and **formally accepted requirement coverage**, each with numerator/denominator and what was actually measured. Use counts of verified work packages and specific G/S/SI rows, not an invented 100% progress score. If an estimated overall percentage is requested, label it an **engineering estimate** and explain its weighting; don't use it as promotion evidence.

---

## 6. Concurrency and contract dependency rules

Suggested ownership lanes (adapt to actual repository and current FICs):

- Lane A: WP2/WP3 identity and isolation contracts (coordinate shared authorizers).
- Lane B: WP4/WP5 gateway actions and canonical preflight.
- Lane C: WP6/WP7 approval and secret references (may split if no shared source files).
- Lane D: WP8 bounded agent loop and provider mock.
- Lane E: WP9 connectors/scheduler/landing/recovery; potentially split connector and scheduling with exact contracts.
- Lane F: WP10/WP11 status and audit (separate underlying writes where needed).
- Lane G: WP12 UI/API integration after canonical contracts stabilise.
- Lane H: WP13 conformance/activation/native entrypoint.
- Lane I: WP14 comparisons and WP15 test harness/threat coverage.
- One coordinator owns current FIC/registry changes, the mission checkpoint and global acceptance evidence.

The lanes are **an ownership plan, not a demand for nine agents**. Use as many workers as the actual `AGENTS.md`, host budget, existing manager and provider allowance safely support. Do not start processes merely to occupy lanes.

Implement interface-first compatibility for: `ExecutionContext`, `AuthorizationDecision`, `IngestionRequest`, `Connector`, `ApprovalLease`, `JobResult`, `AuditSink`; reusing existing DT types is preferred. Explicitly model source catalogue version, target authorization scope, action limits, immutable request digest, request and execution principals, deadline, cancellation, retry/idempotency, allowed data direction, audit correlation, and version/rollback metadata.

**Dependency and gating guidance:** WP2→WP4; WP5→WP6; WP6+WP7→WP9; WP9→WP10/WP11; WP8+WP9+WP10/11→WP12; WP1–WP12→WP13; measured implementation alternatives→WP14; everything→WP15 final closure. A dependent agent can implement contract-compatible code and tests against an explicit mock, but cannot claim end-to-end completion until the actual upstream consumer is integrated. Resolve interface changes with versioned contract tests, not silent unilateral edits.

---

## 7. Exact definitions of done for each phase

**A COMPLETE — contracts ready:** authoritative source read, current starting SHA and existing evidence audited, all owners/FIC authorizations identified, interfaces versioned and frozen for implementation, active workers have disjoint file claims, tests/baseline failures identified. No global closure claim.

**B COMPLETE — code with tests:** every required WP implementation exists under the right owner, has a real tested positive behavior and required targeted negative/security cases, known dependency mocks are identified, and introduced failures are resolved. All implementation receipts are source-associated. **This is not yet integrated or accepted.**

**C COMPLETE — system works:** normal local API/UI and worker paths use the exact same approval/authorization/tool boundary; a complete synthetic source → quarantine → atomic landing → audit/status cycle executes; recurrence, suspension, retries, cross-user refusal, rollback and crash paths work under their applicable end-to-end tests. The system isn't merely an importable collection of packages.

**D COMPLETE — evidence trustworthy:** every original G1–G32 / SI-01–SI-10 / S1–S43 obligation has a source-HEAD-bound verdict; mandatory passing claims have independent executed proof; relevant regressions and L0 proofs pass; all evidence/approval/schema/provenance constraints hold; pre-existing failures and the research-only scope are disclosed; current FIC and model/tool restrictions satisfied.

**E COMPLETE — accepted and continuous:** required capabilities activated through DT's **existing** governed versioned mechanism; accepted state and active version evidence agree; rollback/in-flight continuity and restart-safe mission handoff are measured; final independent decision is `ACCEPTED` if and only if current DT acceptance authority truly approves it. If external authority is missing, remain `VALIDATED_NOT_ACCEPTED` or `BLOCKED` with precise causes.

---

## 8. Required final artifacts and data schemas

Retain and extend current artifacts rather than duplicating authoritative state:

- `reports/governed_ingestion/mission_source.md`: immutable original v3 normative spec / source digest.
- `reports/governed_ingestion/BASELINE.json` and `reuse_and_impact_matrix.json`: prior implementation, reusable mechanisms and change plan.
- `reports/governed_ingestion/MISSION_STATE.json`: factual resumable current state, source-aware and independently verifiable.
- `reports/governed_ingestion/evidence/wp<N>.json`: per-work-package source-bound final evidence only when revalidated at the stable integrated HEAD, plus already-existing valid WP evidence.
- Actual per-scenario and SI evidence at paths chosen by existing schemas/authority; do not invent a second registry.
- One final acceptance authority record (the source mission refers to `reports/governed_ingestion/MISSION_ACCEPTANCE.json`, subject to actual current approval authority) and a clear final decision.
- Provenance/decision records for comparisons, threats, non-adopted alternatives and open limitations.
- Clean native local demo instructions and generated synthetic data/fixtures; no real credentials or external organization details.

**Lightweight work receipt example** (build phase; adapt to existing stronger DT schema):

```yaml
mission: governed-ingestion-v4
phase: B_IMPLEMENT
work_package: WP9
slice_id: <unique-slice-id>
source_parent: <prior-commit-sha>
source_after: <actual-commit-sha>
fic_authority: <verified-existing-id-or-BLOCKED>
owned_files: [<actual paths>]
changed_behavior: <reproducible behavior, not files-created>
contracts_consumed: [<versions-and-owners>]
focused_tests:
  - command: <exact guarded command>
    exit_code: <actual code>
    tests_collected: <actual nonzero count>
    tests_passed: <actual count>
negative_checks: [<actual test ids/results>]
known_dependency_mocks: [<explicit list>]
status: IMPLEMENTED_TESTED | BLOCKED | REJECTED
open_integration_seams: [<actual paths and owners>]
next_action: <bounded next runnable step>
```

**Mandatory final evidence record** (adapt to current authoritative schema):

```yaml
mission_id: governed-ingestion-v4
source_head: <one source-bound accepted candidate SHA>
work_package: <WP0-WP15>
fic_id: <actual authorizing contract>
capability: <actual runtime component>
implementation_paths: [<real paths>]
scenario_ids: [<relevant S1-S43 IDs>]
security_invariants: [<SI-01-SI-10 IDs>]
commands:
  - command: <guarded executable command>
    exit_code: <measured>
    tests_collected: <measured>
    tests_passed: <measured>
    result_digest: <real SHA256>
verdict: IMPLEMENTED | VALIDATED | ACCEPTED | NO_CHANGE | BLOCKED | REJECTED | DEFERRED
independent_verifier: <name-and-observed-verdict>
limitations: [<honest scope boundaries>]
next_action: <exact and bounded>
```

Never mark a mere build receipt as formal acceptance, never treat absent test command as success, and never overstate that 85 obligations are closed simply because a checkpoint contains 85 rows.

---

## 9. Operator / agent execution instruction

**Start now. Do not ask for confirmation. Do not generate a new plan instead of implementing.**

1. Read the complete original v3 mission and current repository evidence. Verify current HEAD and peer work.
2. Publish a brief implementation/owner/contract map and assign only authorized nonconflicting bounded slices. Retain accepted prior work.
3. **Implement the remaining code with tests**, continuing through all WP implementations. Do not run whole-mission evidence regeneration between unrelated source changes.
4. **Integrate the actual system** from real request entrypoints and drive its critical positive and negative flows.
5. **Freeze source, run one ordered comprehensive independent verification, consolidate evidence, and apply actual acceptance policy.**
6. If incomplete, preserve all committed correct code and true evidence, and resume the next useful step instead of restarting or circling on report regeneration.

On interruption, continue from the last independently reverified checkpoint. A prior agent's summary is not evidence; recover exact source, test and receipt records. Preserve the original v3's explicit exclusion of production/org adoption and its requirement to document unresolved real-world identity, credential, network and operator approvals.

### Final report — mandatory

```text
MISSION: DOUBLETAKE_GOVERNED_INGESTION_AGENT_EVOLUTION_MASTER_v4
PARENT NORMATIVE SOURCE: reports/governed_ingestion/mission_source.md
SOURCE HEAD BEFORE / AFTER: <actual SHAs>
CURRENT ACTIVE VERSION: <name/version/none, supported by record>

PHASE A: CONTRACTS/OWNERS/FIC <status and evidence>
PHASE B: WP0–WP15 IMPLEMENTED_TESTED <n/16; list missing or blocked>
PHASE C: INTEGRATED BEHAVIORS <verified routes, tests, limitations>
PHASE D: G1–G32 <per-ID status>; SI-01–SI-10 <per-ID status>; S1–S43 <per-ID status>
PHASE E: ACCEPTANCE / ACTIVATION <actual authority, outcome, version, rollback>

SECURITY NEGATIVES: <exact actual execution and results>
REGRESSIONS: <actual targeted/full commands and baseline-differentiated outcomes>
MEASURABLE FUNCTIONAL CHANGE: <code/behavior versus original baseline>
EVIDENCE STATUS: <verified head and source-bound digest details>
LIMITATIONS: <remaining blockers with exact source and remediation>
NEXT BOUNDED ACTION: <one useful executable action or NONE if accepted>
OVERALL: ACCEPTED | VALIDATED_NOT_ACCEPTED | PARTIAL | BLOCKED | REJECTED
```

## Final governing principle

**Build all the necessary capabilities with continuous focused tests; integrate them into one real governed system; perform the full independent certification when the integrated source is stable.** Do not trade away constitutional boundaries, independent approval, provenance or adversarial tests for the appearance of speed. Do not confuse the number of commits with progress. This v4 exists to **stop repeatedly proving partially built pieces** and start delivering a complete, verifiable DoubleTake-native capability.
