# DT-IP-0059 — Governed agentic pattern selection, shared validation and bounded recovery

**Status:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW / NOT_EXECUTED. Public conditional transfer only; no DT defect, implementation, permission, test or parity is asserted.

## Exact provenance and limits
- Live public source: `doubletake_evolution/scrapyard/AGENT_X_GOOGLE_AGENTIC_PATTERNS_ADOPTION_SPEC.md`, Git blob `7e67b815f173b733a6a23654bfe17a730958a985` (complete 5,690-character distilled text).
- Historical full original at same path: Git blob `6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7` (49,420 characters, §§0–45). Historical Agent_X proposal dated 2026-09-15; historical operator instructions are not current authority.
- Public lineage: https://github.com/olejardamir/doubletake_work/blob/main/doubletake_evolution/scrapyard/AGENT_X_GOOGLE_AGENTIC_PATTERNS_ADOPTION_SPEC.md ; recover removed/revised text through Git history using blob SHAs.
- Historical Google references: Cloud Architecture Center agentic design pattern guidance (2026-05-28), Google Cloud agentic workflows (2026-08-11), Google Developers Blog AI Agents Challenge patterns (2026-09-02), ADK multi-agent guide. Their dates, interpretations and license terms are NOT independently verified. Do not copy third-party implementation/code or imply Google ADK/Cloud dependency; verify version, licenses and terms before reuse.
- Current private DT architecture, owners, relevant consumers, fixtures, and feature parity: UNKNOWN. Overlap with other DT-IP prompts must be reconciled, not duplicated.

## Mandatory future user-authorized coder preflight
Inspect CURRENT private DT source, tests, capability registry, permission model, lifecycle owners, consumer call sites and current revision with explicit authorization. Exit `ALREADY_PRESENT` if covered with real evidence; `NO_APPLICABILITY` if no real consumer; `NO_AUTHORIZED_FIXTURE` if safe test/effect authority absent; `CONTRACT_UNKNOWN` for unresolved ownership, provenance or license. Do not change code, invoke host tests or claim implementation from this prompt. If authorized, prefer minimum scoped modification of an existing owner, document migration/removal of duplicate paths, run actual positive/negative tests and independent effect readback, record commit and results.

## Conditional behavioral contracts
1. **Single durable lifecycle and authority (§§0,3–4,35–37):** receive/classify → provenance context → semantic intent → revisable plan → policy/value/risk/architecture/permission gates → routed actions → observations/evidence → validation → independent critique → atomic promotion OR bounded repair/rollback/rejection. Only one owner per state, lifecycle transition, capability, validation and promotion decision. Model text cannot authorize transitions or prove effect. Persist accepted revision, evidence, idempotency keys and recovery state across crash/restart.
2. **Pattern selection and tiers (§§5–8,15–21,33,38):** prefer deterministic L0 → cheap L1 classification → normal L2 reasoning → justified L3 escalation. Select single ReAct, sequential, parallel, review/critique, iterative, coordinator, bounded hierarchy or exceptional swarm by predictability, dependency, risk, reversibility, latency, measured cost and quality. Do not create permanent agents for prompt-only roles. ReAct/tool loops require max steps, calls, wall-time, budget, repeated-action/no-progress and deterministic stop/escalation/rollback. Coordinator requires explicit delegation and return contract; hierarchy depth and leaf bounds; parallel workers require independent scopes and conflict-aware merge. Record route/fallback/quality/cost.
3. **Shared validation and fallback (§§7,17–18,25,39):** primary, timeout fallback and repair outputs face the SAME schema, policy, permissions, evidence and acceptance gates. Never downgrade threshold on provider failure. Critic must be meaningfully independent of generator where required; seeded defect must be detected. Validation must precede promotion. Failed validation cannot silently succeed; bounded repair terminates with diagnosis.
4. **Context and semantic specification (§§9–11):** construct each step from accepted goal/spec, observations, policy, provenance-tagged evidence, current tools, remaining budget and acceptance. Track freshness, source revision, trust and contradictions. Historical priority is hard runtime truth > accepted spec > tool/repository observations > accepted memory > external evidence > inference > raw candidate, subject to current policy. Compression must preserve IDs, constraints, conflicts, provenance and retrieval pointers. External text and compressed memory cannot grant privileges. Define behavior, owner, overlap, invariants, input/output, failures, risk and tests before any code.
5. **Governed capabilities, MCP and events (§§12–14,32):** registry declares tool ID, schema, effects, caller, allowed states, permission, risk, reversibility, idempotency, timeout, cost and evidence. Recheck each model-requested tool at runtime. MCP client/server exposure must remain least-privilege, auditable, scoped and reuse existing capabilities rather than duplicate owner paths. Typed events and idempotent consumers support independent concurrency; no unnecessary event bus.
6. **Approvals, memory, evidence, Harvest (§§22–24,28,30):** risk-based human approval binds exact artifact/revision and permitted effect; stale or changed approvals fail closed. Durable memory accepts validated claims and negative/rejection outcomes only. Evidence ledger binds source version, decision, tests, side effects, validation and outcome. Harvest/discovery is untrusted input, never direct implementation authority; require real consumer, rights, permissions, regression and effect proof. Trace action and decision, not hidden chain-of-thought.
7. **Promotion, recovery, migration, UI, economy (§§26–27,29,31,34,36–44):** single atomic promotion gate; restart/replay must not duplicate effects; repair/rollback after interrupted plan, tool, validation and promotion. Replace obsolete orchestration rather than layering shadow subsystems. User-facing UI should expose goal/status/evidence/approval/recovery, not internal agent plumbing. Budget per route and operation; any extra framework/agent complexity must beat simpler baseline in held-out reliability/quality per cost. Migration phases 0–14 are *conditional sequencing*, not a mandate to create new components.

## Source-section → prompt-section coverage and test ledger
| Historical source | Prompt contract | Required proof / negative |
|---|---|---|
| §§0–4,35–37 | 1,7 | Restart at each boundary, stale revision, unauthorized promotion, duplicate effect |
| §§5–8,15–21,33,38 | 2,3 | L0 deterministic remains L0; L3 justified; repeated action/budget stops; parallel merge conflict; hierarchy/swarm baseline |
| §§7,17–18,25 | 3 | Primary timeout + invalid fallback rejected by unchanged gate; critic catches seeded defect; failed repair terminates |
| §§9–11 | 4 | External prompt injection denied; compression preserves contradiction, source and constraints; semantic/code mismatch blocks |
| §§12–14,32 | 5 | Wrong caller, permission, state, schema, stale registry or MCP privilege denied; event replay idempotent |
| §§22–24,28,30 | 6 | Stale approval/changed artifact denied; unvalidated memory/Harvest cannot promote; negative outcome retained |
| §§26–27,29,31,34,36–44 | 7 | Crash before/after promotion, atomic rollback, no shadow owner, UI evidence, held-out simpler-baseline comparison |
| §40 A–L | 1–7 | A routing; B same-bar fallback; C bounded ReAct; D sequential; E parallel; F critique; G context; H approval; I durability; J Harvest; K complexity reduction; L promotion |

All coverage here is **Transformer-authored mapping, not independent Scout verification**. Historical §41 phases and §42 artifacts are conditional candidate work products, not proof of implemented DT behavior. Exact parameters, policies and ownership must be determined by current authorized DT inspection; no guessed thresholds or synthetic tests count as production verification.

## Future completion evidence
For each applicable contract record current-DT owner/consumer, authorized scope, source/test revision, precise test command/results (including negatives), independent readback, measured quality/latency/cost vs baseline, changed files/commit, license/provenance review and unresolved blockers. Stop rather than assert COMPLETE when an applicable failure gate lacks evidence. Scout alone may independently audit this public transfer and retire the original at its fresh SHA; Transformer must never delete it.

## Scout grouped historical coverage repair — §§38–39 and §42 (conditional, NOT_EXECUTED)

These are archival **candidate contracts** only. The future user-authorized coder must first inspect current DT source, owners, callers, permissions, tests and licensed dependencies; exit `ALREADY_PRESENT`, `NO_APPLICABILITY` or `NO_AUTHORIZED_FIXTURE` when appropriate. No extra registry, service, file or runtime may be created solely to match this historical list. Preserve least privilege, no automatic effects, fail-closed revision checks, unchanged validation of fallback, negative-test evidence and independent Scout review.

### G1 — Historical §38 pattern-registry entry contract
If a real current-DT orchestration consumer and authorized owner exist, evaluate a **machine-readable** pattern registry; each applicable entry must explicitly define all **nine** fields: (1) selection criteria, (2) required inputs, (3) state transitions, (4) maximum budgets, (5) failure behavior, (6) tool permissions, (7) merge behavior, (8) validation requirements, (9) telemetry fields. Historical candidate values are `deterministic`, `single_agent_react`, `sequential`, `parallel`, `review_critique`, `iterative_refinement`, `coordinator`, `hierarchical`, `human_in_loop`, `custom`, `swarm`. They are not a requirement to implement all patterns. Tests: reject incomplete/unknown entries, unauthorized tools, missing budgets, stale schema and unsafe parallel merges; demonstrate deterministic fallback and no new authority from registry metadata.

### G2 — Historical §39 per-task-class evaluation contract
For each **applicable** task class, compare a frozen simpler baseline with candidate route under matched fixtures, access, budgets and stopping rules; retain **twelve** explicit metrics: (1) completion rate, (2) behavioral correctness, (3) acceptance-test pass rate, (4) regression rate, (5) repair frequency, (6) mean model calls, (7) token cost, (8) latency, (9) tool-call count, (10) fallback frequency, (11) human intervention frequency, (12) slop/complexity delta. Include denominators, provenance, revisions, failed/abstained cases and uncertainty. No escalation to coordinator/hierarchy/swarm merely because a task seems complex; require measured benefit over the simpler route. Negative controls: missing metric, unequal model access, hidden failures, budget mismatch and unvalidated fallback cannot produce a PASS.

### G3 — Historical §42 eighteen-artifact conditional acceptance ledger
Map each **applicable** responsibility to an existing authorized owner/artifact (code, schema, configuration or prompt contract); mark each `PRESENT`, `MISSING`, `NOT_APPLICABLE` or `BLOCKED`, with evidence and negative test: (1) canonical lifecycle/state schema; (2) orchestration/pattern registry; (3) routing policy; (4) model execution/fallback policy; (5) capability/tool registry; (6) permission/risk policy; (7) context package schema; (8) evidence schema; (9) event schema; (10) validation registry; (11) memory admission policy; (12) promotion gate; (13) human-in-the-loop approval record; (14) Harvest integration contract; (15) observability/trace schema; (16) budgets/limits configuration; (17) architecture acceptance tests; (18) migration/compatibility tests. **No one-file-per-concept requirement**; reuse canonical DT contracts. Do not declare completion on missing authorization, evidence, real tests or migration compatibility.

| Independently identified gap | Historical location and checked original blob | Prompt mapping / disposition |
| --- | --- | --- |
| G1 nine-field registry | §38 lines 1685–1717, `6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7` | G1 above — TRANSFORMER_COVERED_PENDING_SCOUT |
| G2 twelve metrics | §39 lines 1723–1742, same blob | G2 above — TRANSFORMER_COVERED_PENDING_SCOUT |
| G3 eighteen contracts | §42 lines 2001–2026, same blob | G3 above — TRANSFORMER_COVERED_PENDING_SCOUT |
| Other historical clauses | §§0–37,40–41,45; lines 1–1684,1752–2000,2094–EOF | PARTIAL; independent Scout cursor unchanged, no FULL claim |

Provenance: live public source `doubletake_evolution/scrapyard/AGENT_X_GOOGLE_AGENTIC_PATTERNS_ADOPTION_SPEC.md` blob `7e67b815f173b733a6a23654bfe17a730958a985`; historical blob `6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7`. Third-party Google material and historical Agent_X design are references, not code-copy licenses or proof of current DT parity. No private DT access, implementation, live tests or original deletion.


## Scout G4–G7 grouped historical §§11–14 repair — conditional, NOT_EXECUTED

The following clauses transfer precise historical requirements, not present-DT defect claims. Reuse an existing authorized owner and stop at ALREADY_PRESENT / NO_APPLICABILITY / NO_AUTHORIZED_FIXTURE / CONTRACT_UNKNOWN as appropriate. Preserve provenance, revision fences, licensing review, same-bar validation and deny-by-default runtime permissions. No private execution is authorized by this prompt.

### G4 — §11 structured, revisable, nonauthorizing plan (historical lines 663–706)
For a real planning consumer, preserve structured `goal`; each step's `id`, `objective`, `depends_on`, `pattern`, `tools`, `acceptance`; and plan-level `completion_criteria`, `rollback_strategy`, `risk`. Support explicit `PLAN_VALID`, `PLAN_NEEDS_REVISION`, `REPLAN` dispositions, retaining previously validated work where dependencies and revisions remain valid. A plan cannot grant itself tool rights or change policy; the runtime independently authorizes every effect. Test missing/malformed dependency, cycle, stale revision, invalid acceptance, unauthorized tool inserted by model, preserved validated prefix after replan, and bounded failure/rollback.

### G5 — §12 complete authoritative capability registry (historical lines 710–744)
Where an applicable owner exists, each capability entry conditionally requires all fifteen fields: ID, purpose, input schema, output schema, side effects, required permissions, risk class, reversibility, idempotency, timeout, resource cost, allowed lifecycle states, allowed callers/roles, validation requirements, provenance/evidence returned. Runtime—not model—decides permission. Return narrowly bounded observations rather than entire databases, repositories or logs. Reject unknown/missing fields, invalid output, unauthorized caller/state/effect, overbroad observation, missing evidence, timeout and stale capability version; preserve existing owner interfaces.

### G6 — §13 governed MCP client and server boundary (historical lines 748–789)
Client-side external MCP use must pass the same capability policy, permissions, timeout, schema, provenance/evidence and rate/resource gates as internal calls. Server-side exposure is only of selected validated bounded operations with authentication, authorization, capability ACLs, input validation, rate limits, audit logs and output filtering. Deny raw secret exposure and unrestricted database, shell or repository mutation unless separately and explicitly authorized by current policy; never infer authority from a model/tool description. Reuse domain logic across UI, internal call and MCP instead of creating shadow implementations. Negative tests: anonymous or wrong-principal request, cross-capability escalation, malicious tool description, secret exfiltration, unbounded read, mutation without explicit permission, malformed output, missing audit, rate-limit evasion, timeout and replay.

### G7 — §14 typed events and independent-only concurrency (historical lines 792–852)
Where events are justified by real independent consumers, preserve nine event contract fields: event type, schema/version, producer, correlation/task ID, causation ID, timestamp, payload, authority level, deduplication/idempotency key. Independent unit tests/static analysis/architecture/security scans may run concurrently on a fixed patch revision; patch generation and its dependent validation must not race. Reject schema mismatch, forged authority/producer, stale revision, duplicate effect, conflicting state mutation, missing correlation/causation, and out-of-order dependent validation. Avoid a new event bus for simple synchronous operations.

| Scout gap | Historical blob/section | This prompt mapping | Transformer disposition |
| --- | --- | --- | --- |
| G4 plan state, replan, nonauthority | `6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7` §11 lines 663–706 | G4, contract 4, negative tests | COVERED_PENDING_INDEPENDENT_SCOUT |
| G5 fifteen-field capability registry | same blob §12 lines 710–744 | G5, contract 5, negative tests | COVERED_PENDING_INDEPENDENT_SCOUT |
| G6 MCP server/client controls | same blob §13 lines 748–789 | G6, contract 5, negative tests | COVERED_PENDING_INDEPENDENT_SCOUT |
| G7 event schema and concurrency | same blob §14 lines 792–852 | G7, contracts 5/7, negative tests | COVERED_PENDING_INDEPENDENT_SCOUT |
| Remaining historical review | same blob §§15–37,40–41,43–45, starting §15 line 856 | Existing contracts and Scout future audit | PARTIAL; no FULL claim |

Verified public live source blob `7e67b815f173b733a6a23654bfe17a730958a985`; historical full text blob `6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7`. Historical third-party guidance is not independently licensed or validated. Scout alone independently verifies and may retire the source; private DT NOT_EXECUTED.


## Scout G8–G10 grouped historical §§16,20,22–23 repair — conditional, NOT_EXECUTED

Historical source `6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7` lines 901–915, 1061–1082 and 1111–1180; live distilled source `7e67b815f173b733a6a23654bfe17a730958a985`. These are future inspection/acceptance obligations, not claims of defects or authorization to code. Inspect current private DT only when explicitly user-authorized; stop on `ALREADY_PRESENT`, `NO_APPLICABILITY`, `NO_AUTHORIZED_FIXTURE`, absent consumer/owner or missing rights. Reuse existing schemas and enforcement, preserve independent review and no unlicensed third-party code copying.

### G8 — §16 parallel merge, seven separate outcomes
Before any authorized independent fan-out, define deterministic merge policy for **duplicates, conflicts, missing outputs, timeout, partial success, provenance and differing confidence**. Each is a separately testable case, not interchangeable with a generic conflict-aware merge. Record task/revision/producer, validation result, evidence and source lineage for accepted outputs; reject untrusted or mismatched provenance and unsupported confidence aggregation. Missing/timed-out/partially successful branches must not silently count as complete; duplicate outputs must not duplicate effects; conflicting outputs require explicit adjudication or abstention. Test each of seven cases plus unauthorized merge/promotion, stale revision, replay and out-of-order results under bounded budgets.

### G9 — §20 hierarchy identities and leaf criteria
Only if a measured workload defeats simpler routing, every hierarchy level must preserve **stable task IDs and parent/child relationships**, with bounded maximum depth, no orphan/cycle, deterministic ownership and revision/evidence traceability. A leaf is executable only when **inputs are known, output contract is clear, allowed tools are known, and acceptance criteria are evaluable**. Reject unknown inputs, missing output schema, ambiguous parent, unauthorized tools, unevaluable acceptance, depth overflow, duplicate task ID, stale subtree and overlapping effect authority. No hierarchy merely to mirror the historical diagram.

### G10 — §§22–23 risk and memory admission
Historical candidate risk classes: **R0** read-only/deterministic/harmless → automatic; **R1** reversible local change → automatic only if validation passes; **R2** meaningful code/config mutation with automated rollback → automatic only under configured policy; **R3** architectural/destructive/external side effect → explicit approval normally required; **R4** security-sensitive/irreversible/high-impact → explicit approval required. These are *historical default mappings*, subordinate to current stricter DT policy and actual scope; no implied new permission. Bind approvals to exact plan/version, diff/action, scope and risk; material changes invalidate them. Negative tests: risk misclassification, R2 missing configured policy/rollback, R3/R4 without approval, approval replay, stale diff and unauthorized effects.

Durable memory admission requires **known source, validated status, known scope, explicit staleness policy, and conflicts resolved or recorded**. Separate session, project semantics, validated decisions, implementation outcomes, failure/recovery, preferences and external/reference knowledge only when real consumers need those distinctions. Negative/rejection memory records the attempted approach, reason, evidence and **conditions for reconsideration**, not a permanent unreviewable prohibition. Reject unknown provenance, unvalidated assertions, stale conflicting knowledge, cross-scope promotion and forgotten reconsideration criteria; test readback, revision, replay and correction.

| Scout gap | Exact historical clause | Transfer disposition |
| --- | --- | --- |
| G8 | §16.1 lines 901–915: seven parallel merge cases | COVERED_PENDING_INDEPENDENT_REVIEW; G8 and contract 2 |
| G9 | §20 lines 1061–1082: stable hierarchy identities, bounded depth, four leaf conditions | COVERED_PENDING_INDEPENDENT_REVIEW; G9 and contract 2 |
| G10 | §§22–23 lines 1111–1180: R0–R4 mapping, five memory admission gates, reconsideration | COVERED_PENDING_INDEPENDENT_REVIEW; G10 and contract 6 |
| Unread independent Scout cursor | §§24–37,40–41,43–45; next §24 line 1185 | PARTIAL; no FULL or deletion claim |

No private DT inspection or tests executed. Scout independently checks coverage and alone may retire source.


## Scout G11–G15 batch — historical §§24–29, conditional, NOT_EXECUTED

Source: current public `AGENT_X_GOOGLE_AGENTIC_PATTERNS_ADOPTION_SPEC.md` blob `7e67b815f173b733a6a23654bfe17a730958a985`; historical complete blob `6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7`, lines 1185–1443. This is an archival contract for a future separately authorized coder, **not** a present-DT finding or authorization to implement. Before any future work, inspect existing owner/consumer, permission, source rights and authorized fixture; stop on `ALREADY_PRESENT`, `NO_APPLICABILITY`, `NO_AUTHORIZED_FIXTURE`, missing owner or unlicensed upstream code. Reuse existing canonical contracts; no new agents, services or files merely to mirror this historical proposal. Require real positive and negative tests, revision-bound evidence and independent acceptance.

### G11 — §24 evidence ledger (lines 1185–1214)
An applicable evidence record carries all **eleven** fields: evidence ID, task ID, supported claim/decision, source, source version/commit, producing tool/action, timestamp, authority/trust class, raw artifact reference, derived interpretation and validator status. Require evidence before **eight** decision types: Harvest candidate quality, architecture placement, replace-vs-extend, implementation success, test success, performance claim, regression absence, promotion eligibility. Test absent/stale source revision, mismatched task or raw artifact, forged trust/validator, unsupported interpretation, missing evidence in each decision type and replay; all must fail closed, without inventing success evidence.

### G12 — §25 validation layers (lines 1218–1238)
Select applicable layers **before** execution, independently of primary/fallback route: `V0` schema/structure, `V1` deterministic invariants, `V2` tests/static checks, `V3` behavioral acceptance, `V4` semantic/specification alignment, `V5` quality/slop review, `V6` optional independent model critique. Not every layer applies to every task, but chosen mandatory layers cannot be silently skipped, weakened after failure or bypassed by fallback. Generation alone grants no authority to code, prompt, architecture, Harvest or memory promotion. Negative controls: missing preselection, changed route, invalid schema, failed mandatory layer, self-granted approval and premature promotion.

### G13 — §26 anti-slop and complexity (lines 1242–1283)
Check each historical anti-slop class separately: placeholder logic; TODO as implementation; fake algorithmic depth; unused abstractions; duplicate subsystems; wrapper-on-wrapper accumulation; new code instead of replacement; dead configuration; dead UI; unreachable user feature; feature without real use case; unnecessary dependencies; unnecessary persistent agents; unnecessary services; no-op architecture; tests asserting implementation trivia rather than behavior; self-reported success without evidence. The historical list has **seventeen** entries; do not collapse into a generic slop score. Estimate **ten** complexity-delta fields: behavioral value added, code added, code removed, concepts added, concepts removed, dependencies added, runtime processes added, model calls added, state stores added, UI decisions added/removed. Reject/redesign disproportionate complexity. Negative tests: each class with a seeded example, inflated benefit without independent evidence, omitted delta, unreachable consumer, duplicate owner and falsely passing trivia-only tests.

### G14 — §§27–28 replacement and Harvest flow (lines 1287–1398)
Preserve five mutually distinct dispositions: `REPLACE`, `EXTEND`, `COMPOSE`, `NO CHANGE`, `REJECT`. Prefer replacement when a mechanism genuinely supersedes another, subject to explicit behavior overlap, migration risk, compatibility, old call sites, tests, configs, UI, prompts, state and cleanup. Replacement is **not** complete when the old path is merely dormant: remove obsolete paths or document justified retention with real evidence. Preserve historical **fifteen-stage** candidate flow: DISCOVER → EXTRACT EVIDENCE → NORMALIZE → SLOP/QUALITY CHECK → VALUE CHECK → FIT/ARCHITECTURE CHECK → CONFLICT/DUPLICATION CHECK → REPLACE-vs-EXTEND DECISION → INVENTORY → USER/POLICY IMPLEMENTATION SELECTION → SEMANTIC DELTA → IMPLEMENTATION PLAN → IMPLEMENT → VALIDATE → PROMOTE/REPAIR/REJECT. Inventory admission is not implementation authority. Before offering implementation, check **ten** facts: expected value, architecture fit, feasibility, hardware/software compatibility, dependencies, existing overlap, replacement target, expected complexity, regression risk and evidence quality. Completion requires **eight** outcomes: wired runtime path, wired UI path if user-facing, wired configuration, updated semantic state, cleaned obsolete path, tests, evidence and successful promotion. Negative tests: inventory-to-code bypass, absent policy/user selection, unverified migration, orphaned old path, missing config/UI/semantic update, incomplete tests and unvalidated promotion. Do not create a new Harvest pipeline where no applicable authorized consumer exists.

### G15 — §29 user-facing lifecycle and information minimization (lines 1402–1443)
If a user-facing route exists, preserve the **nine** historical display states `Analyzing`, `Planning`, `Ready`, `Working`, `Checking`, `Needs approval`, `Completed`, `Could not complete`, `Rolled back` as conditional UI acceptance labels/mapping to the existing lifecycle, not a second state machine. Show user understanding, intended action, risk/approval when needed, meaningful state, result and relevant evidence/problems. Do not routinely expose every internal agent, prompt, routing choice, loop, event, confidence or tool call; authorized advanced diagnostics may expose appropriately redacted details. Negative tests: false Completed, hidden Needs approval, missing rollback/failure, leaked internal prompt/secret, unredacted diagnostic, and state differing from authoritative backend.

| Gap | Historical cursor | New prompt section | Transformer status |
| --- | --- | --- | --- |
| G11 evidence and eight decisions | §24 lines 1185–1214 | G11 | COVERED_PENDING_INDEPENDENT_SCOUT |
| G12 V0–V6 preselected validation | §25 lines 1218–1238 | G12 | COVERED_PENDING_INDEPENDENT_SCOUT |
| G13 seventeen slop classes and ten delta fields | §26 lines 1242–1283 | G13 | COVERED_PENDING_INDEPENDENT_SCOUT |
| G14 five dispositions, fifteen stages, ten gates, eight completion checks | §§27–28 lines 1287–1398 | G14 | COVERED_PENDING_INDEPENDENT_SCOUT |
| G15 nine UI states and internal suppression | §29 lines 1402–1443 | G15 | COVERED_PENDING_INDEPENDENT_SCOUT |
| Still unaudited independently | §§30–37,40–41,43–45; next §30 line 1447 | existing contracts, future Scout | PARTIAL / NO_DELETE |

No private DT tests or implementation executed. Scout alone independently certifies coverage and may delete the original.


## Scout G16–G19 grouped historical §§30–37 repair — conditional, NOT_EXECUTED

Historical full blob `6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7` lines 1447–1680; distilled live source blob `7e67b815f173b733a6a23654bfe17a730958a985`. These are **future authorized-coder acceptance contracts**, not findings about current private DT. Before implementation verify owner, real consumer, current main, licensing, policy and fixture; stop at `ALREADY_PRESENT`, `NO_APPLICABILITY`, `NO_AUTHORIZED_FIXTURE` or `CONTRACT_UNKNOWN`. Never copy upstream third-party code without rights review. Reuse canonical contracts and prohibit shadow orchestration, unapproved external effects and self-certified acceptance.

### G16 — §30 complete structured run trace and decision summaries (1447–1488)
For an applicable tracing owner, reconstruct each run using **task ID, parent/child task IDs, selected pattern, route/tier, models, prompt template/version, context package IDs, tool calls, events, state transitions, artifacts, cost/tokens, latency, validation results, fallbacks, retries, repair iterations, promotion decision and final outcome**. For material decisions record `decision`, `reason_summary` and `evidence_refs` as verifiable summaries; never require or expose private model chain-of-thought. Bind IDs, source revisions, timestamps and authority to durable events, redact secrets, apply retention/access policy. Test omitted trace field, cross-task attribution, stale revision, forged evidence, interrupted/replayed trace, missing decision reason, unredacted secret and inaccessible raw model reasoning; a trace alone cannot authorize an effect or PASS.

### G17 — §31 eight bounded budget dimensions and exhaustion dispositions (1491–1521)
Enforce task-class-specific maxima for **model calls, tokens, tool calls, parallel fan-out, repair iterations, decomposition depth, runtime and external requests**, plus **artifact size** where applicable (historical source lists nine controls). On limit, record one explicit `BLOCKED`, `REPLAN`, `ESCALATE` or `ABORTED` transition according to existing policy, never silently continue or reset the budget via fallback/retry/restart. Test each limit at boundary and overflow, combined fan-out, concurrent race, restart/replay, fallback and failed escalation; preserve user/policy approval for any budget increase.

### G18 — §§32–35 least privilege, deterministic ownership and nine decision authorities (1525–1611)
Role examples are conditional: **reviewer read-only; planner normally read-only; implementer scoped repository mutation; validator read/test execution without arbitrary promotion; promoter promotion only after validated state**. Prompt/model owns interpretation, plan proposal, contextual classification where necessary, synthesis, critique, diagnosis and repair proposals; deterministic code owns state, transactions, permissions, sandbox, Git safety, locking, event guarantees, timeouts, budgets, schemas, storage, rollback, validators, secrets and audit. Prefer deterministic handling where stable rules/schemas/direct computations yield reliable reproducibility. Preserve exactly one authoritative layer for each historical pair: **task interpretation → validated semantic state manager; pattern selection → orchestration policy; tool request → capability policy; permission → deterministic policy; code change → working-tree artifact; success → validator; promotion → promotion gate; durable memory → memory admission policy; user approval → user-bound approval record**. Model may propose but cannot grant any authority. Negative tests: planner mutation, reviewer write, validator self-promotion, unscoped implementer, forged user approval, competing state writers, prompt-overriding permissions, nondeterministic duplicate classifier and model success accepted without validation.

### G19 — §§36–37 typed recovery and atomic promotion (1615–1680)
Preserve all **twelve** historical failure types as conditional taxonomy: `TRANSIENT_PROVIDER_FAILURE`, `TOOL_FAILURE`, `INVALID_TOOL_OUTPUT`, `PERMISSION_DENIED`, `RESOURCE_EXHAUSTED`, `PLAN_INVALIDATED`, `EXECUTION_ERROR`, `TEST_FAILURE`, `SEMANTIC_MISMATCH`, `QUALITY_FAILURE`, `SECURITY_FAILURE`, `CONFLICT`, plus `NO_PROGRESS` (historical source actually lists **thirteen**). Every type requires a bounded policy, not generic retry: transient provider failure → limited retry then same-bar fallback then fail; test failure → diagnose, bounded repair, revalidate, rollback/reject if exhausted; semantic mismatch → return to semantic plan/spec alignment rather than blind patch. Permission/security denial must never be bypassed by fallback. Promotion is a distinct atomic transaction only if all **eight** prerequisites hold: implementation artifact, semantic specification, passing required validators, required evidence, satisfied risk policy, required approval, completed replacement cleanup and no blocking conflict. Test each missing precondition, stale/replayed approval, mid-commit interruption, conflicting revision, duplicate promotion, rollback failure and recovery after restart; no partial authoritative state.

| Scout gap | Historical section / lines | Prompt mapping | Transformer disposition |
| --- | --- | --- | --- |
| G16 trace and decision summaries | §30, 1447–1488 | G16 | COVERED_PENDING_INDEPENDENT_SCOUT |
| G17 budgets and exhaustion | §31, 1491–1521 | G17 | COVERED_PENDING_INDEPENDENT_SCOUT |
| G18 role/prompt/code authority | §§32–35, 1525–1611 | G18 | COVERED_PENDING_INDEPENDENT_SCOUT |
| G19 typed recovery and promotion | §§36–37, 1615–1680 | G19 | COVERED_PENDING_INDEPENDENT_SCOUT |
| Not yet independently reconciled | §40 A–L, §41, §§43–45; G1–G19 final consistency and full live source | future Scout | PARTIAL / NO_DELETE |

Historical list count corrected in this transfer: §31 has nine controls including artifact size; §36 names thirteen failures including NO_PROGRESS. These are source-derived counts, not implementation claims. Scout alone independently verifies coverage and may retire the original. Private DT NOT_EXECUTED.


## Scout G20–G22 grouped closure: historical §§40–45 — CONDITIONAL / NOT_EXECUTED

Evidence: current distilled source \`scrapyard/AGENT_X_GOOGLE_AGENTIC_PATTERNS_ADOPTION_SPEC.md\` blob \`7e67b815f173b733a6a23654bfe17a730958a985\`; complete historical original blob \`6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7\`, §40 lines 1752–1826, §41 lines 1830–1997, §§42–45 lines 2001–2165. This is **source-to-prompt preservation only**; NOT a verified current-DT defect, implemented design, license grant or authorization. Future coder first inspects current authorized DT main, canonical owner, real reachable consumer, exact fixture, upstream rights/version and policy. \`ALREADY_PRESENT\`, \`NO_CONSUMER\`, \`NO_FIXTURE\`, \`NO_OWNER\`, \`RIGHTS_UNKNOWN\`, \`UNAUTHORIZED\` => STOP without code. Reuse existing authority, no shadow services/agents. Tests below are required **only for applicable, approved migration**, with positive and adversarial negative fixtures; unavailable fixture is BLOCKED, never PASS.

### G20 — §40 A–L architecture acceptance: each individual test is independently observable

| Suite | Positive acceptance | Negative / rejection acceptance |
| --- | --- | --- |
| A Tiered routing | Deterministic request uses zero LLM calls; cheap classifier handles low-complexity ambiguity; deep task escalates; route recorded | Deterministic work invokes model; missing route trace; expensive tier chosen without policy |
| B Same-bar fallback | Primary and fallback use identical required validators | Invalid fallback rejected; fallback cannot bypass permission/evidence |
| C ReAct | Multi-step reason→act→observe, completes when done | Max-step termination; repeated no-progress detected and stopped |
| D Sequential | Known dependency order enforced without model orchestration | Out-of-order dependent execution or unnecessary LLM control rejected |
| E Parallel | Independent checks execute concurrently | Dependent stages never run prematurely; missing/conflicting merges cannot silently PASS |
| F Critique | Separate reviewer applies structured criteria | Generator cannot self-accept; rejected critique goes to bounded repair, never unbounded retry |
| G Context | Irrelevant history excluded; compression retains provenance | Lower-trust context cannot override runtime authority; missing lineage rejected |
| H Human approval | Approval requested only for policy-required risk, bound to exact plan/action | Material plan change invalidates approval; stale/replayed approval rejected |
| I Durability | Restart restores authoritative lifecycle state | Restart cannot fabricate completion, duplicate side effects or lose committed state |
| J Harvest | Discovery/inventory followed by value/fit gates, end-to-end implementation and replacement cleanup | Inventory alone cannot trigger code; obsolete implementation cannot remain unaccounted |
| K Anti-slop | Reachable, real behavior with independent proof and minimal owner | Placeholder-only, duplicate architecture, unused subsystem and unreachable user feature each fail |
| L Promotion | Validated change promotes atomically | Failed validation blocks promotion; failed promotion leaves recoverable state |

For each suite, record fixture ID, current owner, positive/negative assertion, evidence ID, validator result, revision, and applicable/not-applicable reason. Do not substitute a single A–L aggregate check for these individual cases. Where current DT lacks the relevant consumer, mark NOT_APPLICABLE_WITH_EVIDENCE rather than create architecture to satisfy a historical test.

### G21 — §41 migration ordering (Phase 0–14), subject to current owner and applicability

| Phase | Conditional dependency and deliverable |
| --- | --- |
| 0 | Inspect current main: roles, task state stores, orchestration, routing, tool registries, MCP, Harvest, validation/promotion, UI and duplicate authority; map existing→proposed before coding |
| 1 | Consolidate one durable authoritative lifecycle, legal transitions and blocking states; remove competing state authority |
| 2 | Establish governed capability registry, schemas, permissions, risk, provenance; tool calls use it |
| 3 | Explicit deterministic/cheap/normal/deep tiered routing with telemetry |
| 4 | Common model execution, bounded timeout/retry/fallback and identical post-generation validation |
| 5 | Bounded ReAct action/observation/state/termination with no-progress detection |
| 6 | Purpose-built context, trust/provenance, retrieval, compression and budgets; no transcript accumulation |
| 7 | Shared validation and separated critique where needed |
| 8 | **Only after lifecycle and authority:** typed events, correlation, safe independent parallelism, idempotency; no gratuitous message bus |
| 9 | **After common lifecycle:** integrate Harvest admission→semantic delta→implementation→validation→promotion, remove duplicate orchestration |
| 10 | Bind approval to risk policy, remove unnecessary approval and enforce high-risk approval |
| 11 | **Only after internal capability policy:** selectively expose MCP tools with authn/authz/rate limits/audit |
| 12 | Map detailed lifecycle to minimal UI states; hide agent topology |
| 13 | **Before any optional multi-agent expansion:** remove obsolete loops, state, validators, adapters, UI, agent roles and unnecessary LLM calls |
| 14 | Only if measured simpler patterns fail, evaluate coordinator/hierarchy/swarm; otherwise NO CHANGE |

Enforce dependency DAG 0→1→2 before 8; 1/2 before 9; 2 before 11; 13 before 14. Other phases may be consolidated or skipped with evidence if already present; this is not a mandate to reconstruct obsolete Agent_X. Positive test: dependency order and compatibility/migration evidence; negative tests: event parallelism with competing lifecycle authority, MCP exposure without internal policy, premature multi-agent escalation, missing cleanup, and migration that changes behavior without acceptance proof.

### G22 — §§42–45 artifact/rule/DoD/topology reconciliation

**§42: eighteen required artifact categories, not eighteen mandatory new files.** Each must be mapped to existing current-DT owner/artifact or explicitly NOT_APPLICABLE with evidence: (1) lifecycle/state schema → G18; (2) pattern registry → G21/route contract; (3) routing policy → G20-A; (4) model/fallback policy → G20-B; (5) capability/tool registry → G18; (6) permission/risk policy → G10/G18; (7) context package schema → G20-G; (8) evidence schema → G11; (9) event schema → G8/G21; (10) validation registry → G12; (11) memory admission → G10; (12) promotion gate → G19; (13) HITL approval record → G10/G20-H; (14) Harvest integration → G14/G20-J; (15) trace schema → G16; (16) budget config → G17; (17) architecture acceptance tests → G20; (18) migration/compatibility tests → G21. A conceptual contract may be code, schema, config or prompt; no one-file-per-concept requirement.

**§43: twenty coder rules, mapped as individually checkable gates.** (1) current main inspection → preflight; (2) architecture mapping → G21-0; (3) reuse/consolidate → G21; (4) no blindly named pseudo-components → preflight; (5) semantics not forced layout → G22 artifacts; (6) delete/consolidate instead of shadow systems → G21-13; (7) preserve existing behavior unless specified → migration acceptance; (8) hard guarantees outside prompts → G18; (9) semantic reasoning in prompts where safe → G18; (10) no mandatory Google ADK → rights/fit preflight; (11) no unjustified bus → G21-8; (12) no unjustified multi-agent → G21-14; (13) reject placeholders → G13/G20-K; (14) remove old dead paths → G14/G21-13; (15) tests at each meaningful migration step → G21; (16) evidence per criterion → G11/G20; (17) never weaken security/quality gate → G12; (18) fallback same validation → G20-B; (19) bound every loop → G17/G20-C; (20) promotion distinct from generation → G19. For each applicable rule, require positive proof and seeded violation that fails closed.

**§44: twenty-nine DoD bullets mapped to contracts (no collective PASS).** (1) single lifecycle→G18/G21-1; (2) simplest adequate pattern→G21-3/14; (3) deterministic no-model→G20-A; (4) cheap before expensive→G20-A; (5) same-bar fallback→G20-B; (6) bounded evidence-driven ReAct→G20-C; (7) deliberate context→G20-G; (8) semantic before code→G18; (9) revisable structured plans→G7; (10) registered governed tools→G18; (11) auditable bounded MCP→G21-11; (12) safe independent concurrency→G8/G20-E; (13) separated critique→G20-F; (14) bounded repair→G19; (15) evidence-gated hierarchy/swarm→G21-14; (16) risk-based approval→G10/G20-H; (17) validated durable memory→G10; (18) evidence ledger→G11; (19) shared validation all routes→G12/G20-B; (20) common Harvest lifecycle→G14; (21) obsolete replacement removed→G14/G21-13; (22) simple UI→G15; (23) reconstructible redacted traces without private reasoning→G16; (24) budgets enforced→G17; (25) least privilege→G18; (26) gated promotion→G19; (27) A–L acceptance→G20; (28) old duplicate orchestration/state/validation removed→G21-13; (29) measured behavior ≥ baseline and lower complexity or measured reliability/capability gain→G13/G21. For each applicable bullet: current owner, fixture, baseline/head evidence, validator, negative case and disposition; otherwise BLOCKED or evidenced NOT_APPLICABLE, never unsubstantiated 100%.

**§45: final authority/validation/promotion topology.** Historical conceptual sequence: user goal → L0–L3 classify/route → provenance/authority-aware context → semantic specification → plan/decompose/select simplest pattern → value/risk/architecture/permission gate → bounded execution → governed local/Git/MCP/sandbox/external tool layer → observation/evidence → **same-bar unified validation and independent critique** → PASS? → atomic gated promotion → authoritative updated state; on FAIL → bounded repair/replan/rollback, then revalidate or stop. No model-generated PASS or prompt authority may bypass policy, evidence or promotion transaction. Verify forward success, validation failure, denied tool, stale approval, interrupted promotion, rollback and restart/replay. Existing current-DT topology takes precedence; never install a duplicate to mirror a diagram.

| Scout gap | Exact source span | Prompt mapping | Disposition |
| --- | --- | --- | --- |
| G20 | historical §40 A–L, lines 1752–1826 | G20 twelve suites, per-case positive/negative | COVERED_PENDING_INDEPENDENT_SCOUT |
| G21 | historical §41 Phases 0–14, lines 1830–1997 | G21 phase table, dependencies and anti-patterns | COVERED_PENDING_INDEPENDENT_SCOUT |
| G22 | historical §§42–45, lines 2001–2165 | G22 18 artifacts, 20 rules, 29 DoD, topology | COVERED_PENDING_INDEPENDENT_SCOUT |

**Handoff:** G20–G22 transferred in one coherent edit. G1–G19 and full current/historical consistency still require independent Scout audit; source RETAINED. Upstream licensing/version, actual private DT owner/consumer/fixture and parity remain UNKNOWN and are STOP gates. No private DT implementation, tests, deletion or independent certification performed.

## Scout G23–G25 correction — historical §§17–19 (2026-11-13; conditional; NOT EXECUTED)

**Origin:** Scout independently found three precise gaps in inventory_shards/root_A-D.md, commit f4c0262fecc6855332869129b363b7de238aed12. Source original Git blob 6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7, lines 919–1043; current distilled source blob 7e67b815f173b733a6a23654bfe17a730958a985. These are conditional FUTURE CODER contracts, not claims of existing DT code or tests. All actions require the original current-private-DT owner / authorized consumer / fixtures / permissions preflight: absent proof => STOP with a recorded reason.

### G23 — §17 Independent reviewer, isolation and artifact categories (lines 919–959)

The original requires review-and-critique of these EIGHT applicable high-impact candidate classes: (1) code changes; (2) architecture decisions; (3) Harvest admissions; (4) replacement decisions; (5) migrations; (6) prompt-system changes; (7) security-sensitive behaviour; (8) high-impact repairs. Record the actual consumer and source revision for each; when absent, NOT_APPLICABLE_WITH_EVIDENCE, not PASS.

Review flow: GENERATOR -> candidate immutable revision -> CRITIC against ORIGINAL semantic specification AND acceptance criteria -> PASS / REPAIR_INSTRUCTIONS / REJECT. Meaningful independence requires an appropriate combination of a separate inference call, FRESH CONTEXT, explicitly isolated critic prompt, READ-ONLY TOOLS and inability to mutate the judged artifact. A second permanent agent is NOT required. Bind verdict, fixture, spec revision and candidate revision; only the existing governed promotion owner can accept PASS after other validators. Never let the generator certify itself or let review bypass authority.

Positive tests: seeded high-impact defect is caught and rejected with original acceptance criterion; clean candidate independently accepted with evidence. Negative tests: generator self-approval, critic write tools, reviewer mutating judged revision, model-authored replacement acceptance criteria, injected PASS command, reviewer approving wrong revision, or unreviewed high-impact promotion must fail closed.

### G24 — §18 Five exits, six no-progress indicators, ordered recovery (lines 962–1013)

Bounded loop: GENERATE -> VALIDATE -> DIAGNOSE -> REPAIR -> REVALIDATE. Track attempt, current revision, validation defects, score deltas, budget, evidence and last accepted state. EXACT five terminal outcomes: (1) verified quality threshold reached = success; (2) maximum iterations; (3) no-progress threshold; (4) budget exhausted; (5) hard blocker discovered. Outcomes 2–5 are NOT success. No silently raised limits.

Detect SIX explicit non-progress signals: (1) same validation errors repeating; (2) patch oscillation; (3) repeated revert/reapply; (4) unchanged acceptance score; (5) repeated tool call with no new evidence; (6) growing code without increased acceptance. Compare actual history/revisions and evidence, not model descriptions. Each signal has measurable bound and diagnostic.

Recovery escalation ORDER: ordinary repair -> re-plan -> stronger reasoning tier ONLY if justified by evidence -> human approval ONLY if required by current policy -> rollback/reject. Permitted skipped steps need explicit grounds; never self-grant budget or approval. Failed attempts preserve unrelated files, leave reproducible blocker reason and retry only on new evidence/change.

Positive tests: validated repair terminates; each of five exits is correctly reported; failed repairs trigger bounded replan then justified tier and optional policy approval; rollback preserves unrelated work. Negative tests: repeated same error accepted as progress, flip-flop patches, repeated evidence-free calls, longer code falsely marked improved, unbounded attempts, success after budget/hard-blocker exit, unjustified model escalation, self-approval, bypassed revalidation.

### G25 — §19 Deterministic-first coordinator scope and authorization (lines 1017–1043)

Default deterministic routing. A model coordinator is allowed ONLY when ALL FOUR criteria are supported: (1) genuinely ambiguous input types; (2) deterministic classifier cannot route reliably; (3) specialist capability boundaries are meaningful; (4) controlled evaluation demonstrates better completion or quality than simpler baseline on matched permissions, fixtures, risk, and budget. Unknown or failed criterion => retain deterministic routing, no speculative model coordinator.

When justified, coordinator has THREE operations ONLY: decompose; select specialist role; merge results under normal validation. FOUR prohibited privileges: bypass policy; grant permissions; redefine authoritative state; promote its own result. Authority continues to reside in existing runtime policy, durable owner, evidence/validation and separate promotion transaction.

Positive tests: ambiguous class meets four justified gates, performs bounded decomposition and reviewed merge; routine inputs stay deterministic; measured baselines saved. Negative tests: unjustified coordinator, no specialized roles, no measured improvement, model trying to grant itself tools, bypass policy, rewrite state, self-promote or accept conflicting merges => fail closed.

### Explicit Scout source-to-prompt mapping

| Scout gap | Source clause | Repaired scope | Status |
| --- | --- | --- | --- |
| §17 | Historical original lines 919–959; eight review classes; five reviewer isolation options; three verdicts | G23 and positive/negative review tests | REPAIRED_IN_PROMPT_PENDING_INDEPENDENT_SCOUT |
| §18 | Historical original lines 962–1013; five exits; six signals; ordered escalation | G24 and stop/oscillation/rollback tests | REPAIRED_IN_PROMPT_PENDING_INDEPENDENT_SCOUT |
| §19 | Historical original lines 1017–1043; four gate tests; three actions; four prohibitions | G25 and coordinator permission tests | REPAIRED_IN_PROMPT_PENDING_INDEPENDENT_SCOUT |

**Handoff:** Independent Scout must recheck G23–G25 against full current/historical original, then finish its existing audit cursor §§20–39, rights/provenance, and full consistency. This prompt edit is NOT certification or deletion authorization. The scrapyard original remains retained. Private DT current applicability/parity UNKNOWN and NOT EXECUTED.


## G26 — H-0059-S21: historical §21 default-disabled swarm and six-factor evidence gate (PUBLIC PROMPT ONLY)

**Source mapping:** historical immutable `AGENT_X_GOOGLE_AGENTIC_PATTERNS_ADOPTION_SPEC.md` blob `6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7`, §21 lines 1086–1104 → this G26; current distilled blob `7e67b815f173b733a6a23654bfe17a730958a985`. This supplements G2 twelve-metric task-class evaluation and G21 Phase 14; it does **not** supersede their contracts.

**Default and authorization:** swarm orchestration is `DEFAULT: DISABLED`. Never auto-enable it through a configuration default, self-approval, an LLM recommendation or unverified claimed benefit. Only a separately authorized owner may approve a **bounded experiment** on an identified current-DT consumer, after verifying the current version, policy, real owner, executable fixture, rights and source provenance. Preflight must STOP with recorded evidence on `ALREADY_PRESENT` (adequate existing guarded mechanism), `NO_CONSUMER`, `NO_FIXTURE`, `NO_OWNER`, `RIGHTS_UNKNOWN`, `UNAUTHORIZED` or policy denial. Unknown DT parity is not a defect finding. No agent-to-agent conversation may substitute for explicit architecture, authority, traceability or independent validation.

**Six-factor experiment gate:** precommit a simpler-pattern baseline, task class, fixture revisions, evaluation denominators, matched access/budgets, independent evaluator, acceptance thresholds and latency/cost limits. Record and compare **all six** separately: (1) task success, (2) output quality, (3) failure rate, (4) workload-acceptable latency, (5) workload-acceptable cost, and (6) trace/debug complexity. Preserve raw outcomes, failures, run IDs, revisions, evaluator independence and uncertainty. Enablement requires demonstrable advantage over the simpler baseline on task success, output quality and failure rate, with latency, cost and trace/debug complexity acceptable under predeclared limits; a missing, incomparable, adverse or ambiguous dimension is NOT PASS. G2's wider twelve-metric ledger remains applicable; no metric may be silently dropped. An experiment approval is not production promotion; production requires separate current-owner authority, same-bar validation, security and rollback evidence. Fail closed and remain disabled on regressions, budget exhaustion, incomplete traces, revoked approval, stale revision or evaluation uncertainty.

**Exact synthetic acceptance fixtures (future authorized coder only):**

| ID | Setup | Required result |
| --- | --- | --- |
| P-S21-01 | Approved bounded experiment; frozen simpler baseline; matched tasks/resources; independent six-factor measurements with predeclared success/quality/failure improvement and acceptable latency/cost/debug complexity; all existing validation and rights gates satisfied | Experimental enablement only within authorized scope, revision and budgets; trace decision and evidence; production remains separately gated |
| N-S21-01 | Same candidate but trace/debug complexity absent or exceeds approved bound | STOP; swarm stays DISABLED |
| N-S21-02 | Success/quality promising but failure-rate improvement unmeasured, not demonstrated or worse than baseline | STOP; swarm stays DISABLED |
| N-S21-03 | Swarm default enabled, self-authorized or experiment not approved | DENY and restore DISABLED; no execution |
| N-S21-04 | Baseline incomparable due to different tasks, access, budgets, revisions or evaluator | STOP; no benefit claim |
| N-S21-05 | Cost or latency violates predeclared acceptable limit, or results lack independent validation | STOP; swarm stays DISABLED |
| N-S21-06 | Owner/consumer/fixture/rights unknown or approval revoked/stale | STOP before execution; record exact reason |

**Failure/recovery and evidence:** no implicit fallback to swarm; revert to simpler authorized route, preserve evidence and revision-bound failure reason, and require fresh independent measurements plus owner approval for reconsideration. Never grant new tool permissions or promotion authority through swarm selection. Scout must independently compare the exact historical §21 source and G26 fixtures before marking H-0059-S21 covered. Original remains retained; no private DT code or tests executed.


## G27 — H-0059-S04 historical §4 canonical lifecycle vocabulary and runtime transition authority (conditional; NOT_EXECUTED)

**Exact provenance:** Historical immutable source blob `6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7`, §4 lines 197–269; live distilled source blob `7e67b815f173b733a6a23654bfe17a730958a985`. This is a proposed *mapping/verification contract*, NOT authorization to add a second state machine or proof of any current-DT defect. Third-party source fidelity and rights remain unverified; do not copy upstream implementation.

**Future authorized-coder preflight:** Inspect actual current DT lifecycle owner, consumer, schema, transition graph, persistence, approvals, fixtures, version, policy and rights with explicit permission. STOP `ALREADY_PRESENT` when existing owner demonstrably covers applicable semantics; `NO_CONSUMER` when no actual caller; `NO_FIXTURE` when safe deterministic tests cannot be run; `RIGHTS_UNKNOWN` or policy denial when reuse/authorization unresolved. If existing names differ, record an explicit bidirectional semantic mapping and reject ambiguity; do not rename production states just to mirror historical vocabulary. No new owner, runtime, or effects without authorization.

**Historical source-clause → conditional contract → required proof:**

| Historical §4 clause | Mapping / authority | Positive and negative fixtures |
| --- | --- | --- |
| §4.1 lines 201–218: fourteen canonical states | Map all 14 distinctly: `RECEIVED`, `CLASSIFYING`, `CONTEXT_BUILDING`, `SPECIFYING`, `PLANNING`, `GATING`, `READY`, `EXECUTING`, `OBSERVING`, `VALIDATING`, `REVIEWING`, `ACCEPTED`, `PROMOTING`, `COMPLETED`; distinguish validation, review, acceptance, promotion and terminal completion. Existing owner remains authoritative. | P-S04-01: trace an authorized complete path with evidence-bound transitions. N-S04-02: missing, collapsed or ambiguous mapping fails preflight. |
| §4.1 lines 220–234: eleven failure/recovery states | Map all 11 distinctly: `BLOCKED`, `REJECTED`, `EXECUTION_FAILED`, `VALIDATION_FAILED`, `REVIEW_FAILED`, `DIAGNOSING`, `REPAIRING`, `REVALIDATING`, `ROLLING_BACK`, `ROLLED_BACK`, `ABORTED`. Distinguish terminal rejection/abort from recoverable failure and rollback in progress versus completed rollback. | P-S04-02: authorized bounded failure→diagnosis→repair→revalidation or rollback trace; no silent promotion. N-S04-02: ambiguous failure/terminal mapping denied. |
| §4.1 lines 236–240: optional approval wait | If human approval is applicable, `AWAITING_HUMAN_APPROVAL` maps to a durable, revision/effect-bound wait; approval must be current and authorized before continuation. If not applicable, document `NOT_APPLICABLE` with evidence. | P-S04-03: correct revision approval resumes through runtime. N-S04-05: stale, missing, bypassed or wrong-effect approval denied. |
| §4.2 lines 242–256: runtime-only transition authority | Model may propose `requested_transition`, `reason`, `evidence_refs` as untrusted data; only existing lifecycle/orchestration owner validates legal source→target, revision, evidence, permission and side effects and commits state. | P-S04-04: legal proposal accepted by runtime under owner rules. N-S04-01: illegal/model-asserted transition denied; no mutation or promotion. |
| §4.3 lines 258–269: six durability disruptions | Authoritative state and accepted revision/evidence/idempotency survive process restart, model failure, tool failure, UI refresh, repair cycle and fallback-model switch; model conversation is never the state store. | P-S04-05: each of six disruptions rehydrates same authorized state without duplicate effect. N-S04-03: missing or divergent restart/fallback state fails closed; N-S04-04: conversation-only state cannot authorize transition. |

**Recovery and acceptance:** On invalid transition, missing state, stale approval, durability mismatch or denied permission, preserve last durable accepted revision, record a typed denial and evidence, and use only existing owner-authorized bounded diagnosis/recovery/rollback. Never self-approve, silently map away states, weaken same-bar validation, replay side effects, or promote from a model claim. Require synthetic deterministic positive/negative fixtures above plus actual authorized integration tests and independent effect readback before any future `COMPLETE` claim. If applicability, rights or fixture is unknown, STOP; leave original retained for Scout. **H-0059-S04 is repaired in public prompt only; independent Scout must verify exact historical coverage.**
