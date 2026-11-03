# Historical governed analytics control plane — DT-transferable design extract

**Source:** Former `AGENT_X_BANK_OF_CANADA_ARCHITECTURE.md`, a 33-section, 2,152-line Agent_X/enterprise-data-platform implementation and job-alignment manuscript dated August 13, 2026. **Exact original Git blob:** `a749fc62ef2508dca944234bd0706eadd39a8864` (150,099 Git bytes), recoverable in repository history. Original proposed Agent_X baseline `fb1ab39bc7ecbd66a5572f3624b7916e5d0616b6`. This is a **section-level, loss-aware DT relevance distillation**, not a paragraph-by-paragraph equivalence certificate. Employment/job-fit narrative, presentation material, textbook/diagram instructions, review ratings and platform-specific tutorial chapters were removed from the live scrapyard copy as non-operative DoubleTake instructions; all remain in the historical blob.

**Status and scope:** Historical proposed architecture, **not** a verified implementation, current DT source parity, owner authorization, live cloud entitlement or production-ready design. The original distinguishes an AWS-oriented startup profile from a hypothetical Fabric/Databricks reference deployment. It specifically warns against claiming the enterprise platform or its compliance approval already exists. Nothing in this file overrides DT's `ACTIVE_MISSION.md`, privacy boundary, accepted architecture, B1/B7 authority or actual runtime evidence.

## 1. Transferable architectural boundary

The agent should be a **governed control plane**, not a large-scale data/compute plane. It sends bounded, typed control requests to independently owned systems and receives metadata/aggregated results. Spark/Airflow/Ray/S3/Iceberg or Fabric/OneLake/Databricks operate separately under their own resource and data governance. Never stream bulk datasets, sensitive row-level records or production credentials through model prompts merely to perform data-platform orchestration. This separation is potentially useful to DoubleTake's MCP/tool gateway and source→decision→authorized effect chain, if a current real consumer exists.

The smallest plausible integration is an approved service adapter, not a second all-purpose orchestration runtime. A proposed Databricks MCP service exposes only: list inspected/approved jobs and bounded recent runs; start a **pre-registered** workflow with schema-validated arguments after any required approval; monitor one run and return bounded results; and query specifically approved operational/quality views. Cancel, arbitrary SQL, unrestricted workspace writes, creating jobs and changing production settings remain disabled unless separately authorized. The model never receives raw arbitrary SDK power.

## 2. Permission and execution contract

- Make identity and least privilege explicit: principal/service identity, environment, exact approved workflow/resource, allowed parameter schema, effect class, approval status/expiry, requested action and correlation ID. Start/cancel/write are not read-only. No prompt phrasing, role narrative or self-generated policy statement grants permission.
- Validate at the **service effect boundary**, not only in the conversation. An allowlisted name alone is insufficient if arguments or target environment escape the authorized scope. Deny unknown, malformed, stale, replayed or conflicting requests. Credentials are server-side with scoped managed/service identities, never model-visible or committed.
- **Idempotency is critical:** a lost HTTP response after a server-side job start must not start a second job on retry. Use a durable operation ledger, pre-commit operation identity and Databricks idempotency token where supported. Record intent, decision, request, accepted run ID, eventual result and error/retry state; reconcile remote state before replaying an uncertain operation. Do not confuse 'one request attempt' with 'one committed external effect'.
- Correlate `proposal_id → authorization/approval → operation_id/idempotency_token → vendor run_id → outcome/verification` and bind each to tenant/workspace/environment, target and source-policy revision. A local success message without remote outcome cannot establish an accepted effect.
- Fail closed on schema drift, entitlement failure, stale approvals, inaccessible authoritative state and unresolvable operation outcomes. Hold or reconcile uncertain effects instead of issuing a fresh mutation to make progress look successful.

## 3. Dataset/release governance (conditional relevance)

Data ingestion and transformation produce versioned, quality-tested data products *outside* the agent. Release/promotion of a dataset version requires provenance, schema/quality tests, owner signoff where required, privacy/retention classification, lineage and rollback/retraction metadata. Expose only approved aggregates and release metadata to the agent; data-classification/semantic model, operational health and platform administration retain their separate canonical owners. A read-only data-quality lookup is distinguishable from an authorized workflow start or a publication/retraction effect. Versioned publication, deletion/legal hold and recovery cannot be collapsed into a single optimistic status.

Portability comes from contracts (typed approved tools, stable data-product identity, policy, evidence and outcome), **not** pretending AWS/Airflow/Iceberg and Fabric/OneLake/Delta are interchangeable deployment assets. Different providers require explicit adapters and proofs. Do not import this unrelated enterprise-platform architecture into DT without a current source-backed need and owner comparison.

## 4. Failure, observability and cost controls

Audit who/what requested the operation, exact resource, policy/approval decision, input schema digest, idempotency identity, external response, error/retry class, duration and correlation identifiers, without leaking secrets or raw sensitive payloads. Bound result size, timeouts, concurrency, retries, query cost, rate limits, budgets and tool availability. Use structured metrics for accepted/denied/unknown effects, duplicate-prevented retries, service health, data-quality release and recoveries. A broken external dependency should degrade the relevant capability explicitly rather than enabling an unauthorized fallback. Disaster-recovery and replay must preserve durable accepted operations and prevent duplicate external effects.

Use isolated, synthetic accounts/resources for tests; do not require or assume access to the Bank or any real production data. Provider demonstrations, 10/10 architecture completeness scores and conceptual diagrams are not test evidence. Real deployment would require independent security/privacy review, owner approval, measured SLOs and operating responsibilities.

## 5. Falsifiable DT-transfer tests (NOT run or approved)

1. **Read-only positive:** inspect one allowlisted job and return bounded redacted metadata without mutation permission or bulk data.
2. **Authorized start positive:** preapproved job/parameters/environment yields exactly one durable operation and external run ID; successful output and actual remote effect agree.
3. **Lost-response replay:** simulate external start succeeds but response is lost; replay same idempotency identity resolves **same** external run and leaves no second job; replay with changed arguments/target is rejected.
4. **Negative authority:** unregistered workflow, wrong principal/workspace, expired/missing approval, forged tool schema, arbitrary SQL and out-of-scope write all fail before external side effects.
5. **Failure state:** remote timeout/ambiguous outcome remains `UNKNOWN/RECONCILE`, not `SUCCESS`; cancellation and retry preserve safety.
6. **Provenance and disclosure:** prompt-injected vendor metadata cannot widen tool policy; secrets and raw protected records never appear in model content or audit logs.
7. **Release integrity:** quality/schema failure blocks data-product publication; rollback/retraction retains durable lineage and approved external status.
8. **Actual consumer:** identify an authorized current DT production call that uses the proposed generic mechanism; test in its genuine caller, not an isolated donor example. A code import, generated file, schema or status entry is not proof of assimilation.

**Current DT applicability:** UNKNOWN. Before transferring any of these ideas, inspect DT's existing authenticated MCP/tool dispatch, operation receipts, authority/consumption owners and tests; classify `ALREADY_PRESENT`, `DUPLICATE`, `NO_CURRENT_CALLER`, `SOURCE_GAP_WITH_AUTHORITY` or `BLOCKED_BY_OWNER`. Do not create a second gateway or enterprise connector merely because this historical architecture contains detailed requirements. No new DT implementation or independently verified natural autonomous cycle results from this dissection.

## Original section mapping and what was retired from live copy

Retained concepts were drawn from original §§1, 4–5, 7–13, 15–17, 26–30: control-plane/data-plane split; approved Databricks MCP API; durable operation/idempotency; bounded data-product release; fail-closed permission; typed evidence and recovery; tests, risks, ownership. Historical deployment/component maps, hypothetical resource values and phase schedules are **not validated current DT architecture**.

Removed from **live scrapyard text only**: original §§2–3 role/source requirements and old Agent_X baseline review; §6 deployment tutorial/platform tables; detailed cloud SDK/SQL and pipeline implementation chapters; §§18, 21, 31–33 Bank job/interview/leadership evaluation; §§22–25 textbook/diagram/glossary/rating material; long per-vendor operational/CI/config examples and duplicated guidance. Original blob identity above preserves full exact recovery. This extract is intentionally more limited than the original and should not be treated as a full substitute for its original separate educational or career-preparation purposes.
