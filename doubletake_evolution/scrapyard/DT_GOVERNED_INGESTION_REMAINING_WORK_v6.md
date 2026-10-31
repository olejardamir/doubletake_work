# DOUBLETAKE GOVERNED INGESTION — REMAINING WORK v6

> **SINGLE ACTIVE CONTINUATION PROMPT.** Replace v5 as the active driver. Do not run v5 alongside v6. Do not restart the mission or rebuild validated capabilities.
>
> **GitHub snapshot inspected:** `olejardamir/DT`, `main` HEAD `cd1987f0bd` (2026-10-26 20:25:54 UTC). `reports/governed_ingestion/MISSION_STATE.json` is stale (bound to `9e39f01838`). Running local worker processes and uncommitted edits cannot be verified here: inspect these locally before making changes.
>
> **Authority:** `AGENTS.md`, current L0/L1/L2 FIC governance, and unwaivable v3 requirements in `reports/governed_ingestion/mission_source.md` override this prompt where appropriate. Earlier v4 GitHub directive is supporting context only. This is not a second mission, manager or kernel.

## 1. REMOVE THESE COMPLETED IMPLEMENTATION TASKS

Do NOT reimplement these existing mechanisms. Their focused evidence demonstrates package-level validation, **not final mission acceptance**.

| WP | Reuse verified implementation | Existing evidence |
|---|---|---|
| WP0a–WP0c | Baseline, inventory and resumable checkpoint | Validated/checkpointed; overall WP0 acceptance remains open |
| WP1 | Schemas, contracts, synthetic fixture and request envelope | `wp1.json` |
| WP2 | Effective identity/authorization | `wp2.json` |
| WP3 | Target-zone policy/isolation tests | `wp3.json`; real OS/network isolation limitations remain |
| WP4 | Six-tool governed agent boundary | `wp4.json` |
| WP5 | Catalogue, validation, canonical request digest | `wp5.json` |
| WP6 | Approval leases, revocation, suspension | `wp6.json` |
| WP7 | Secrets by reference | `wp7.json` |
| WP8 | Bounded mock-driven agent loop | `wp8.json` |
| WP9 | Connectors, runner, landing, retention, scheduler and focused tests | `wp9.json` |
| WP10 | Identity-filtered status/recovery model | `wp10.json` |
| WP11 | Audit chain, event and runner-audit facilities | `wp11.json` |
| WP12 implementation | Existing local API/router, auth/CSRF/rate-limit protections and React ingestion panel | `wp12.json` verdict `VALIDATED`; browser E2E *not* recorded |
| WP14 first slice | Existing G1/G3/G9 comparisons | `wp14.json`; other comparisons are unfinished |
| WP15 documentation | Existing 15-threat model, 15-risk register, 85-row evidence register and five-obligation tests | `wp15.json` verdict `VALIDATED`; global closure unfinished |
| WP13 partial slice | Existing conformance repairs and 16-test suite | Commit `ac4e2fbd10`; full WP13 not verified |

**Important:** None of these are `ACCEPTED`. The last mission checkpoint reports WP1–WP11 validated, WP12 partial, WP14 partial, WP13/WP15 not started; newer `wp12.json` and `wp15.json` show additional *local* validation. No accepted/activated release or `MISSION_ACCEPTANCE.json` was observed. Do not mistake an old checkpoint for current truth.

**Remove from v5's active task list:** WP9 complete build instructions; WP10 build instructions; WP11 foundation build instructions; WP12 already-landed API/UI coding; WP15 threat/risk/evidence-document creation; WP14 G1/G3/G9 first-slice implementation; any WP0–WP8 rebuilding. Keep integration and final independently verified acceptance obligations.

## 2. HANDOFF AND EXECUTION RULES

1. Read `AGENTS.md`; inspect `git status`, current HEAD and remote, uncommitted peer changes, active driver and component/FIC ownership. Maintain main-only/no-tag policy; use authorized detached worktrees when needed. Do not overwrite peers or launch a second controller.
2. Confirm `v6` actually loaded by the controller; do not claim switching active workers from a GitHub file alone. Resume actual source, not assumed snapshot.
3. Read real files/evidence for WP12–WP15; create a **delta-only** task queue. Drop a task immediately if a newer commit already completes it. Do not redo full inventory or blanket regeneration.
4. Assign disjoint coding owners, one final evidence coordinator. Run tests/proofs through `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` or the current mandated equivalent. Bounded guarded experiments are serial where host limits require. Avoid recursive pytest/evidence loops.
5. Do not fabricate FIC authorizations. A plan FIC for *writing reports* is not authorization for runtime code or activation. Security regressions block promotion, not independent safe work.

## 3. ONLY REMAINING WORK

### R1 — WP12: prove browser and real integration, don't rewrite API/UI

**Observed limitation:** `evidence/wp12.json` verifies router-related suites but explicitly says browser UI smoke/E2E is **not re-measured**, and the WP14 comparison half of G23 remains deferred.

- Using shipped FastAPI and `ui/src/components/ingestion/IngestionPanel.jsx`, run authentic browser/UI smoke and meaningful integrated flows with synthetic fixtures: session/login/logout/expiry, immutable request validation, independent approval, status/audit views, origin/CSRF, rate limiting, other-user request ID, forbidden direct-call mutations, access filters, and safe errors.
- Prove no alternate UI, chat, guided form, template or direct API path bypasses the same server-side authorization and approval. If a pathway is absent, implement the minimal missing authorized seam and test it; do not rebuild working components.
- Check actual listener is loopback-only; demonstrate rejects on direct HTTP when UI restrictions are bypassed.
- Record accurate WP12 independent verifier and status wiring at a *stable* checkpoint. Resolve required FIC implementation authority honestly; the current report says this authority is not established.
- **Done:** real browser/API-to-runtime tests pass with captured commands, positive/negative assertions and digests; missing runner/browser framework yields honest BLOCKED/UNRUN, not PASS.

### R2 — WP13: finish complete adapter conformance, native launch and lifecycle

- Reuse landed WP13 contract conformance fixes. Inspect versioned adapters for identity, authorization, approval, secrets, target, audit, connectors, model/mock, clock, scheduler, lifecycle and rollback.
- Fill only uncovered contract/negative tests and version/schema migration checks. Demonstrate clean native no-Docker/no-cloud/no-model-download local launch using the deterministic mock.
- Exercise registered component candidate activation through **existing** DT lifecycle: compatibility, old in-flight job pinned/drained, failure rollback, stale handler rejected, incompatible schema fails closed. If feature is unavailable, distinguish core mission blocker from explicitly allowed DEFERRED comparison; never pretend it passed.
- Produce contract/conformance evidence, integration and generic future adapter guide, accurate supported/unsupported transport and deployment boundaries.
- **Done:** WP13 independently validated with actual tested outcomes and authorized activation/rollback evidence or clearly enumerated unproven required items.

### R3 — WP14: finish only uncompleted design comparisons

**Already implemented:** initial G1/G3/G9 slice. `evidence/wp14.json` specifically says G4, G23, G24, G6 remain.

- **G4:** shared vs dedicated local target, measurable isolation/blast radius/recovery and explicit limits of simulated namespaces.
- **G23/G24:** agent vs guided form vs template vs hybrid, matched synthetic tasks and scripted-persona limitations. Measure steps, errors, schema rejection, safety, technical knowledge required; never call scripted persons real users.
- **G6:** deterministic mock; optionally authorized *already available* compliant open-code model, synthetic only; otherwise DEFERRED, not a blocker to mock.
- Audit G5 hosting, G10 free-form vs constrained generation, G9 approval-granularity and versioned activation comparisons. Reuse real evidence; execute missing local comparison only. If a choice cannot be tested, say PARTIAL/DEFERRED with specific boundary.
- Use same fixtures/seeds; state metrics, actual command/exits, risk trade-offs, evidence and conditional recommendation. Give G1/G3/G4/G5/G6/G9/G10/G23/G24 truthful `DECISION_READY | PARTIAL | DEFERRED` records.
- **Done:** independently verified WP14 record reflecting measured options and genuine limitations, without rerunning previously proven slices unnecessarily.

### R4 — Demonstrate the actual local end-to-end ingestion lifecycle

**Integration task, not another WP1–WP12 rewrite.** Through *real existing entrypoints*, show:

`requester → filtered catalogue → typed draft → policy → exact independent approval → runner/gateway → allowed local source → quarantine/inspection → atomic authorized landing → audit/status → API/UI`

Extend this to recurring schedule, rechecks on privilege/policy/catalogue changes, revocation, expiry, suspension, cancellation, retry, crash after stage/rename, retention, and concurrent single-use lease claims. Prove model never directly executes or sees raw source data/secret values.

- Required negative integration probes: forged principal, URL/path/redirect/proxy/DNS rebinding, unsafe archive, cross-user reads/IDs, CSRF/Origin, leaked planted secrets, source prompt injection, unauthorized upload/export, active-job component update/rollback, and malformed or expired approval.
- Use deterministic mock and synthetic test data, local sources only. Real cloud, credentials or enterprise deployment are prohibited.
- Test whether local folder, HTTP(S), SFTP, upload, decrypt and archive behaviors are genuinely covered. If a transport is unsupported, report exact UNRUN/BLOCKED/NOT_APPLICABLE and its implication for original mission criteria.
- **Done:** a reproducible guarded native E2E demonstration and negative scenarios with actual commands, exit codes, test counts, digests and unchanged L0 independence.

### R5 — WP15 FINAL closure: reuse threat/risk/evidence documents, only reconcile residuals

**Already validated:** threat-model (15 classes), risk register (15 classes), 85-row G/S/SI evidence register and WP15-focused tests. Do not write those documents again.

- Integrate R1–R4 evidence into the existing register. Distinguish isolated test vs integrated proof and address missing/unrun edges. Map all **G1–G32**, **S1–S43**, **SI-01–SI-10** to code, test, real result, digest, status and limitation. For G29–G32 explicitly note real-world organizational approval/infrastructure OUT_OF_SCOPE; local tests cannot close them.
- Reuse local threat/risk registers and update only disproven, genuinely outdated or newly resolved rows. Validate path references, current test collection, artifact retention, and independently re-derived records. The WP15 evidence record explicitly says its existing slice does not itself authorize WP15 implementation.
- At one stable source checkpoint, coordinate full guarded regressions, L0 independence, security invariant demonstrations, contract and UI/runner/E2E tests. Don't continuously recertify previously unchanged WPs. Honor genuine mandatory binding freshness when content changed.
- **Done:** complete independently verified mission closure ledger with accurate ACCEPTED/PARTIAL/BLOCKED/UNRUN/OUT_OF_SCOPE distinctions and no unsupported claims.

### R6 — Formal acceptance and activation (or truthful blocker)

- Revalidate latest checkpoint after wiring genuinely new WP12–WP15 entries. Avoid repeated WP2/WP3 evidence cascades unless the measured surface or binding contract actually changed.
- Check actual implementation approval FICs; evidence/report FICs alone are insufficient. Preserve exact requester approval vs DT code promotion distinction.
- Test activation/rollback only through existing versioned mechanism. Never activate if critical security invariant fails; do not invent release pointers.
- Produce `MISSION_ACCEPTANCE.json` only with actual valid authority and correct schema. Otherwise return `VALIDATED_NOT_ACCEPTED` / `PARTIAL` / `BLOCKED` with the precise missing approval and next runnable action.
- **Done:** supported final acceptance and (where required/authorized) release activation, or transparent qualified closure report; never claim enterprise-production certification.

## 4. REQUIREMENTS WHICH MUST NEVER BE REMOVED

- Minimal L0 independence; L1 governance only; L2 specification only; no second manager/kernel or unauthorized code promotion.
- Inward-only approved local synthetic data, deterministic mock and no mandatory Docker/GPU/cloud/model downloads or third-party content.
- Requester/executor rights; independent approval; immutable digest and current policy/catalogue/target; deny self-approval, direct model execution, forbidden dynamic tools and privilege increases.
- Secret handles only in connector, no plaintext in model/UI/API/logs/evidence. Content from a source never becomes an agent instruction.
- Strict endpoint/SSRF/path/redirect/rebinding/decompression controls, quarantine, quotas and atomic publish. Controlled retries, suspension, retention and audit chain (honestly describe anchor limits).
- Real positive *and negative* integrated tests, including all applicable S1–S43 and SI-01–SI-10. Failed/unrun/beyond-scope conditions must not count as PASS. G1–G32 statuses must remain individually explicit.
- No real organizational identity, infrastructure, credentials, confidential information, proprietary code imports or declarations of production readiness.

## 5. PACE AND TRUTHFUL REPORTING

- Prefer verified functional connections, conformance and adversarial behavior over report-only commits. One file owner at a time on shared main; no concurrent global evidence regeneration.
- Run focused tests during remaining implementation. Full global certification **after** integration stabilizes; rerun mandatory affected regressions after changes. Do not falsify evidence freshness.
- Every meaningful checkpoint output:
  ```
  DRIVER: v6 ACTIVE_CONFIRMED | NOT_CONFIRMED
  SOURCE_HEAD: <sha>
  R1..R6: OPEN | IN_PROGRESS | VALIDATED | BLOCKED
  NEW INTEGRATED BEHAVIOR: <exact executed positive/negative flow>
  TESTS: <guarded command, collected/passed/failed, artifact digest>
  WP12/WP13/WP14/WP15: <status, evidence, authority>
  G/S/SI COUNTS: <real source-backed counts only>
  ACCEPTANCE / ACTIVATION: <actual authority, release pointer or NONE>
  BLOCKERS: <precise>
  NEXT: <one executable missing test/coding/approval action>
  ```
- No arbitrary percentage based on commits or regenerated evidence.

## 6. ACT NOW

Inspect commits after `cd1987f0bd`, current worktree and current evidence. Remove R1–R6 subtasks already completed by concurrent peers. Begin the highest-value remaining authorized **integration or conformance** action immediately. Do not stop at a plan; execute and verify while respecting all host and governance constraints.
