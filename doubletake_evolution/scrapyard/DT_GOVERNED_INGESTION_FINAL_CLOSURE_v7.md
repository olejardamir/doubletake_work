# DOUBLETAKE — GOVERNED INGESTION FINAL CLOSURE v7

> **SINGLE ACTIVE EXECUTION PROMPT.** This is a continuation of the existing Governed Ingestion mission, replacing the v6 work queue. Execute only outstanding evidence, integration, governance and closure steps. Do not rebuild completed components or create another kernel, controller, approval store, tool gateway or application stack.
>
> **Repository inspected:** `olejardamir/DT`, `main` HEAD `28ff963506` (2026-10-27 10:23:21 UTC). `reports/governed_ingestion/MISSION_STATE.json` generated 2026-10-27 03:16:36 UTC against `c3765d1698` reports **WP1–WP15 `VALIDATED_NOT_ACCEPTED`**, WP0 still `IN_PROGRESS`, WP0c `CHECKPOINTED`, and **no mission acceptance or activated release**. The checkpoint trails HEAD; inspect local HEAD, worktree and concurrently running agents at execution time.
>
> **Authority:** current `AGENTS.md`, L0/L1/L2 governance and legitimate FIC authority override this execution prompt; the original mission requirements remain in `reports/governed_ingestion/mission_source.md`. Historic v3/v4/v5/v6 prompts are not concurrent master drivers. Confirm v7 adoption rather than claiming a GitHub file automatically changed a running process.

## 1. Completed development — OMIT from the active queue

All WP1–WP15 have package-specific validation in the repository's latest checkpoint. Reuse the existing request schema, identity/policy, targets, tool boundary, catalogue, approvals, secrets, agent loop, connectors/quarantine/landing, scheduling/retention, status, audit, API/UI, adapters/native launch, comparison framework, threat model, risk register and evidence register. Also reuse WP0 preparatory baseline/checkpoint work.

**Never create an implementation task merely because its original WP was listed in v6.** Do not repeat WP1–WP15 focused development, rewrite WP15's 15-class threat/risk documentation, rewrite the 85-row evidence register, or regenerate unaffected proofs. A fresh actual regression, untested remaining integration seam or formally recorded limitation may justify a *narrow* repair with its own authorization and tests.

**Do not equate package `VALIDATED_NOT_ACCEPTED` with 100% mission closure.** Specific outstanding limitations recorded by existing evidence:

- `wp12.json`: browser-side UI smoke and real browser E2E were **not** measured; implementation-change authorization was not established by its evidence FIC.
- `wp13.json`: standalone guarded native-launch remeasurement was initially unproven, although `wp13_native_launch.json` later landed and its certifier ran; independently check that record and skip any now completed native-launch work. WP13 evidence FIC itself grants no runtime implementation authority.
- `wp14.json`: G4, G23, G24 and G6 remained listed for later comparison slices. The package status `VALIDATED_NOT_ACCEPTED` alone is **not** proof these design comparisons occurred. Examine new records and close only missing mandatory comparison evidence, otherwise record honest `PARTIAL` or `DEFERRED` limitations.
- `wp15.json`: focused documentation/evidence obligations are validated; this does **not** substitute for a newly executed system-wide E2E or governance acceptance. Its record expressly distinguishes evidence-writing authority from runtime implementation authority.

## 2. Execution hygiene — short delta check only

1. Read `AGENTS.md`; collect exact local HEAD, remote/main, dirty paths, current work owners and active controller. Never overwrite another worker's changes or run v6 concurrently. Respect current main-only/ref rules and host limits.
2. Inspect current `MISSION_STATE.json`, `wp12.json`, `wp13.json`, `wp13_native_launch.json`, `wp14.json`, `wp15.json`, actual integration tests and approval/release authority. Derive a delta-only list of **unproven**, **failed**, **deferred**, **not authorized** or **not accepted** outcomes; omit anything a newer peer genuinely completed.
3. Run required tests through `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` or the exact current `AGENTS.md` equivalent. Never bypass resource guards. Guarded heavy suites must not recursively launch themselves; use serial bounded slices as required.
4. Give independent owners disjoint files and one designated final evidence coordinator. Avoid endlessly regenerating WP2/WP3 records because unrelated commits alter bound blobs: stabilize source first and execute only mandatory freshness repair.

## 3. Remaining missions — run in this order unless dependencies dictate otherwise

### C1 — Prove the full working ingestion journey, not just isolated WPs

Use **actual shipped entrypoints** and existing components: synthetic requester → constrained draft or guided input → filtered catalogue → schema/preflight validation → effective rights → immutable request/independent approval → authorized runner and source connector → quarantine/inspection → atomic landing → linked audit/status → permission-filtered API/UI results. Deterministic mock only; no real organizational data, credentials, cloud, external model or arbitrary egress.

Measure with **real guarded integration/E2E tests**, not a sequence of owner-level mocks or prose assertions. Exercise one-time and recurring paths, stale policy/catalogue, revocation, suspension, cancellation, lease replay/concurrency, safe retry, retention, crash recovery, foreign-user reads, CSRF/Origin, SSRF/DNS rebinding/redirect, malicious archive, planted-secret leakage and direct API/agent execution bypass attempts. Confirm no source payload reaches model instructions and only allowlisted inbound sources are accessed. A missing optional protocol or fixture must remain `UNRUN`/`BLOCKED`/`NOT_APPLICABLE` with a defensible reason.

**Browser proof:** Execute real browser-side smoke and main user journeys for the already-built React ingestion panel and FastAPI routes. Reuse rather than rewrite code. If a required browser harness is unavailable, explicitly classify the gap; obtain an authorized minimal implementation FIC before any needed code repair.

**Definition of done:** reproducible guarded end-to-end command(s), actual passing positive and negative assertions, numbers collected/passed/failed, logs/digests, and documented unsupported boundaries. If sufficient existing current E2E proof is already present, point to it and close C1 without repetition.

### C2 — Close only remaining decision and adapter limitations

Inspect the newest `wp14.json` and its decision records: retain existing measured comparisons. For **G4** shared/dedicated target, **G23/G24** agent vs guided form/template/hybrid, **G6** mock vs optional authorized available model, and any genuine outstanding **G5/G10/activation** comparison, execute only missing authorized synthetic comparisons or explicitly classify alternatives `PARTIAL`/`DEFERRED` and explain whether acceptance requires them. Use matched fixtures, test results, correct user-simulation labels and conditional recommendations. Never invent observations of real users, production delegates, providers or platforms.

Inspect `wp13_native_launch.json`; if its independent verifier and actual native run proof are sound and current, **mark this task satisfied**. Do not repeat native-launch construction. Address only unproven *required* lifecycle behavior: contract mismatch, safe versioned activation, in-flight pin/drain and rollback. Where a mechanism cannot be demonstrated, state exactly what is unsupported and whether it is a documented permissible deferral or an acceptance blocker.

**Definition of done:** every required decision/adaptation claim has traceable real executed evidence or a precise authorized scope exclusion. The existence of `wp14.json` is not by itself a substitute for its listed missing comparisons.

### C3 — Mission-wide security, evidence and governance closure

Reuse `docs/governed_agent/threat_model.md`, `risk_register.md`, `evidence_register.md`, all `wp*.json`, and existing independent certifiers. **Do not rewrite completed documents or refactor their schema.** Update only rows genuinely changed by C1/C2. Preserve mappings for G1–G32, S1–S43, SI-01–SI-10 with source, test path, actual result, relevant source revision, evidence digest, owner and residual limit.

Verify integrated tests rather than assuming focused suite successes imply global safety. Preserve legitimate `OUT_OF_SCOPE` for G29–G32 real-world organizational choices, approvals and platform behavior. Check L0 independent smoke, L1 promotion authority, L2 specification-only boundaries, versioned component conformance, affected regression tests and no unapproved egress. All needed claims must be backed by collected nonzero relevant tests; `UNRUN`, `BLOCKED`, `NOT_APPLICABLE`, a stale record or printed `PASS` are not successful tests.

**FIC authority:** Verify that actual implementation changes were authorized under applicable FICs; writing a WP report does not itself authorize runtime changes or the final promotion. Do not invent retrospective authorization, a human approver, or release credentials. If an authority is missing, state the specific review gate and proceed only with separately permitted work.

**Definition of done:** one independently checked and non-stale consolidated acceptance matrix, including honest unresolved risks and validated source/evidence bindings, without a per-commit cascade of unrelated evidence refreshes.

### C4 — Final acceptance, activation, or exact blocker

At a stable HEAD, verify the legitimate acceptance gate and release/activation procedures that already exist in DT. Revalidate the checkpoint and affected certification proofs. Do not modify L0, broaden tools, self-approve, bypass independent human review or invent a release pointer. A release may be activated only if the current governance authority actually permits it and all mandatory security invariants pass.

Create `reports/governed_ingestion/MISSION_ACCEPTANCE.json` **only if** this is the recognized path/schema and there is a genuine authorized decision. Otherwise maintain a truthful `VALIDATED_NOT_ACCEPTED` or `PARTIAL/BLOCKED` checkpoint identifying exact unfulfilled approval/test and the next executable action. Distinguish a local research demonstration from real-world/production security approval.

**Definition of done:** either supported final `ACCEPTED` with authorized release binding and tested rollback, or a complete final non-accepted state with precisely named missing authority/proof; never claim 100% simply because every WP shows `VALIDATED_NOT_ACCEPTED`.

## 4. Always-preserved security boundaries

Minimal independent L0; L1 controls authority, FICs and promotion; L2 only specifies. No new parallel control plane, hidden agent `execute` tool, self-approval, access grant or arbitrary external flow. Inward-only local synthetic fixtures, approved catalogue IDs, requester/executor rights, approval lease bound to canonical digest and current policy/catalogue, secrets by reference in connectors, deny source instructions, safe quarantine/atomic landing, SSRF/redirect/path/archive controls, rate/size quotas, identity-filtered reports, hash-chain audit with honestly described tampering limits, suspension, retries and idempotency. No proprietary source assimilation, real credentials or employer/client data. S1–S43 and SI-01–SI-10 remain final acceptance obligations, not a request to rewrite previously validated modules.

## 5. Required incremental output

```text
MISSION: GOVERNED_INGESTION_FINAL_CLOSURE_v7
ACTIVE DRIVER: CONFIRMED | NOT_CONFIRMED
SOURCE HEAD / WORKTREE: <exact revision, clean/dirty summary>
VALIDATED REUSED: WP1–WP15 (exceptions/drift with proof)
C1 E2E AND BROWSER: VERIFIED | PARTIAL | BLOCKED, <exact tests/evidence>
C2 DECISION / LIFECYCLE: VERIFIED | DEFERRED | PARTIAL | BLOCKED, <specific G ids>
C3 SECURITY / EVIDENCE: VERIFIED | PARTIAL | BLOCKED, <matrix counts and digests>
C4 ACCEPTANCE / ACTIVATION: ACCEPTED | VALIDATED_NOT_ACCEPTED | PARTIAL | BLOCKED, <actual authority/binding>
TESTS: <exact guarded commands, exit codes, collected/passed/failed>
REMAINING BLOCKERS: <only genuinely unresolved items>
NEXT RUNNABLE ACTION: <one concrete authorized step>
```

**Execute now:** Check source/evidence changes since `28ff963506`; remove any C1–C4 action already completed by another worker. Start the highest-value remaining unverified *integration or authorization* step, not another implementation or evidence-regeneration loop.
