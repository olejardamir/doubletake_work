# DOUBLETAKE — UNIVERSAL RESEARCH INTELLIGENCE, DISCOVERY, RELEVANCE & VERIFICATION
## Full Operational Implementation and Final Closure Mission — v1

**Repository:** `https://github.com/olejardamir/DT` (`olejardamir/DT`)  
**Execution:** Autonomous implementation agent(s) operating against the actual checked-out repository  
**Mission mode:** Delta-only, evidence-driven, end-to-end implementation, not a proposal or paper exercise  
**Status on issue:** OPEN — determine live state independently before executing  
**Outcome:** Make DoubleTake reliably *find relevant evidence and answer the user's actual information need*, across research domains, under existing governance and resource limits.

---

## 0. EXECUTIVE DIRECTIVE — READ FIRST

You are implementing this mission, not discussing how to implement it. Inspect current code and tests, implement missing capabilities in the real execution path, run bounded validations, repair regressions, publish reproducible evidence, and stop only with a genuinely supported terminal verdict.

**Primary failure to eliminate:** A user asks: `Find affordable monthly parking in downtown Ottawa`. An observed DoubleTake run successfully fetched seven Wikipedia pages, including pages about unrelated places, but found no Ottawa parking options, rates, or provider-specific evidence. Network success, document count, and pipeline success were falsely tempting substitutes for *task success*. A subsequent report described the search as completed without a confirmed space. A result such as `no confirmed parking` is acceptable **only after a competent, relevant search**, and is never a valid inference from irrelevant pages.

**Objective is universal.** Do not hardcode parking, Ottawa, Wikipedia, price regexes, predetermined websites, or query-specific answer text into production logic. Parking is one representative end-to-end adversarial regression. Comparable quality is required for products, technical documentation, research papers, policy/legal text, current facts, travel, local services, news, numerical comparisons, and user-provided documents. Domain-specific extraction *plugins* can exist behind a generic interface; generic correctness must not depend on one topic.

**Preserve the kernel.** DoubleTake's existing minimal kernel remains the only kernel. Research intelligence belongs in replaceable, versioned capability components invoked through the existing owner and authority boundary; do not introduce another kernel, a second supervisor, parallel policy authority, shadow registry, or separate permanent autonomous controller. Any dynamically upgraded implementation must be reflected in subsequent invocations without a stale module snapshot, using the project's existing mechanism for versioned implementation identity where available. Preserve last-known-good rollback and bounded self-repair; a faulty research component must not halt the rest of DoubleTake.

**Important:** A final claim of success requires demonstrated *real* task-relevant evidence and truthful answer generation, not a green self-authored report, superficial URL-match, unverifiable LLM judgement, or prewritten fixture response. A live provider may be unavailable. Report this precisely; never fabricate data or declare victory from inaccessible sources.

### Mandatory non-negotiables

1. Inspect the latest actual `main` at invocation. Compare current code with this mission and close only outstanding deltas. Do not undo already verified work.
2. Respect `AGENTS.md`, CONDUCT, source/data trust boundaries, network grants, SSRF/redirect controls, host workload guard, existing evidence policies, and operator-owned restrictions.
3. Use only currently authorized providers and models; do not silently enable network, paid APIs, credentials, third-party code, remote execution, or model downloads. Do not require closed model weights; provider use follows existing permissions.
4. No special-case answer bypass, artificial citations, fixture substitution, optimistic status flags, or fabricated availability/prices.
5. Prefer minimal, correct modifications to existing first-party modules; one authoritative owner for each contract; no shadow state or dual pipelines.
6. Every material behavioral change requires a test that *fails before the fix or under a controlled mutation* and passes afterward. Record evidence of both.
7. Resource bounded: budgets for queries, providers, pages, bytes, tokens, latency, retries, and work units. Do not defeat host guard or run unguarded parallel suites.
8. Multi-agent edits to shared `main` require a single-writer integration plan, serialization of conflicting writes, and evidence regeneration from a stable committed snapshot. Do not destroy collaborators' changes or rewrite shared history.
9. Never interpret an offline `--verify` as proof of fresh network availability; carry the measurement timestamp, provenance, authority, and exact scope of claims.
10. Keep operational integration of the twelve existing research-assimilation work mechanisms intact. Avoid reopening unrelated Bank, UI, or enterprise missions except where the live research path actually intersects them.

---

## 1. STARTING BASELINE AND REQUIRED RECONCILIATION

At preparation, these files existed and had relevant capabilities. **Paths are targets for inspection, not an assertion that every file remains unchanged:**

| Scope | Existing path / ownership | Required inspection |
|---|---|---|
| Provider interface and fallback | `tools/doubletake_evolve/universal_research/discovery_provider.py` | Configured providers, grants, ordering, failures, result metadata, pagination, retry behavior |
| Candidate discovery | `tools/doubletake_evolve/universal_research/source_discovery.py` | URL extraction, candidate ranking, prefilter, provider walk, source dedup |
| Source relevance | `tools/doubletake_evolve/universal_research/source_relevance.py` | Intent/location/subject matching, meaningful negatives, text-vs-URL quality |
| Query family | `tools/doubletake_evolve/universal_research/query_family.py` | Query rewrites, coverage of user constraints, query stopping conditions |
| Task and plan | `research_task.py`, `research_plan.py`, `analysis.py`, `budget.py` under `universal_research/` | Research intent, evidence slots, stopping semantics and resource limits |
| Broker and transport | `retrieval_broker.py`, `http_transport.py`, `broker_activation.py`, `acquisition_environment.py` | Source authorization, robots/SSRF, redirects, response limits and content types |
| Orchestration | `research_owner.py`, `research_dispatch.py`, `research_progress.py`, `recovery.py`, `checkpoint.py` | Loop from failed relevance to re-plan, bounded execution, cancellation, persisted state |
| Evidence/report | `observation.py`, `normalization.py`, `verification.py`, `fusion.py`, `report.py`, `research_run_surface.py` | Claim-to-source traceability, uncertainty, answerability, substantive user answer |
| Registry | `adapter_registry.py` | Existing authority on discovery providers and adapters; avoid duplicate registry |
| API / UI | `tools/doubletake_evolve/api/chat_sse/chat_route.py`; research finding activity components in `ui/` | Real ordinary-chat wiring and user-visible useful answer; no fixture-only path |
| Acceptance | `tools/doubletake_evolve/universal_research/live_parking_acceptance.py`; `criterion_table.py`, `final_closure.py`, `live_mission_state.py`, `evidence_manifest_package.py` | Whether criteria independently prove task relevance and whether reports conflict |
| Existing reports | `reports/universal_research/` | Actual live acquisition, test runs, source list, timestamps, status semantics |
| Shared operating instructions | `AGENTS.md` | Host safety, regeneration order, source authentication, terminal conditions |

Initial evidence **must be verified rather than accepted as authority**:

- An observed parking live-acceptance artifact acquired seven encyclopedia pages unrelated to monthly parking in downtown Ottawa, yet acquired seven sources and performed a legitimate web transport run.
- An observed `LIVE_MISSION_STATE.json` classified A17/A18/A19 as blocked and mission incomplete because sources were irrelevant.
- A later observed `FINAL_CLOSURE.json` classified the mission `LIVE_SEARCH_COMPLETED_NO_CONFIRMED_SPACE`, with A17–A20 as PASS and `relevant_sources=7`.
- These may reflect different committed snapshots, stale records or improved code; **do not assume either is currently correct**. Determine whether a later live run truly acquired relevant Ottawa parking pages, whether seven irrelevant pages were reclassified without new evidence, and whether state/report regeneration was consistent.
- Record the precise commit, artifact digest, time, actual page URLs, on-page evidence, check definitions, and the result of independent verification.

### T00 — Baseline audit (first deliverable)

1. `git status --porcelain`, `git rev-parse HEAD`, branch and remote tracking; list dirty files and other writers; do not reset their changes.
2. Inspect the complete real user path: chat input -> task classification -> provider routing -> discovery -> search result relevance -> fetch -> content extraction -> evidence assessment -> re-query decision -> final answer -> UI.
3. Determine currently enabled providers in the *actual runtime* and whether a general web provider (e.g., DuckDuckGo implementation, if present) is configured/authorized. Wikipedia must not be assumed appropriate simply because it is available.
4. Run, under the host guard and within permissions, existing focused unit tests and offline artifact verifiers. Save baseline results and failures without regenerating them prematurely.
5. Independently reconstruct the parking failure and conflicting closure claims, preserving a frozen pre-fix reference run in tests/evidence.
6. Produce `reports/universal_research/intelligence_closure/BASELINE.md` and `BASELINE.json`: actual code surfaces, authoritative record identities, existing features, missing deltas, exact work items and baseline test outputs.

**DoD T00:** A reader can identify *why* irrelevant pages were admitted; *which exact stage* failed; whether source acquisition, relevance, question coverage, and truthful final answer were conflated; and what code will change. A plain claim that "search is weak" is not sufficient.

---

## 2. DESIGN CONTRACT — ONE RESEARCH INTELLIGENCE LOOP

Implement/adapt one bounded, observable lifecycle in the existing execution path:

`USER REQUEST -> INTENT & CONSTRAINT CONTRACT -> EVIDENCE NEEDS -> DISCOVERY PLAN -> PROVIDER SELECTION -> QUERY FAMILY -> CANDIDATE METADATA -> RELEVANCE TRIAGE -> AUTHORIZED FETCH -> CONTENT & CLAIM EXTRACTION -> CROSS-SOURCE VERIFICATION -> COVERAGE CHECK -> [REPLAN within budget | DECLARE HONEST LIMITATION] -> GROUNDED USER ANSWER -> DURABLE EVIDENCE & FEEDBACK`

Do not create a second independent research engine. This is an extension of the existing research task/plan/owner/dispatch/broker/report modules. Reuse the project's checkpoint, observation, decision and versioning contracts.

Define typed reason codes, persisted across restart, at least for:

- `NO_PROVIDER_AUTHORIZED`, `PROVIDER_UNAVAILABLE`, `PROVIDER_RATE_LIMITED`, `SEARCH_NO_RESULTS`, `QUERY_EXHAUSTED`
- `CANDIDATE_IRRELEVANT`, `WRONG_GEOGRAPHY`, `WRONG_ENTITY`, `STALE_FOR_REQUEST`, `DUPLICATE_SOURCE`, `UNTRUSTED_SOURCE`, `SOURCE_ACCESS_DENIED`, `SOURCE_FETCH_FAILED`, `SOURCE_UNPARSEABLE`
- `MISSING_REQUIRED_EVIDENCE`, `INSUFFICIENT_COVERAGE`, `CONFLICTING_EVIDENCE`, `UNVERIFIED_VALUE`, `ANSWER_NOT_SUPPORTED`, `BUDGET_EXHAUSTED`, `CANCELLED`
- `VERIFIED_RESULT`, `VERIFIED_NEGATIVE_WITH_SUFFICIENT_SEARCH`, `PARTIAL_SUPPORTED_RESULT`, `UNKNOWN_AFTER_RELEVANT_SEARCH`

A negative observation from an irrelevant result must never transition to `VERIFIED_NEGATIVE_WITH_SUFFICIENT_SEARCH`.

---

## 3. IMPLEMENTATION STAGES (ALL REQUIRED)

### T01 — Explicit intent and evidence-needs contract

**Owners:** `research_task.py`, `research_plan.py`, `analysis.py`; new narrowly named module only if absolutely necessary.

Implement a structured, versioned `ResearchNeed` contract including: requested entity/topic, question type (lookup, discovery, compare, recommendation, verification, explain, calculation, time-sensitive), geographic scope where applicable, temporal scope/freshness, exact requested attributes, required evidence units, optional evidence units, hard vs soft constraints, allowed source types, prohibited sources/network, verification threshold and uncertainty behavior. Preserve constraints across follow-up/replan. Distinguish *find a vendor's advertised monthly rate* from *confirm a space is currently available* and *recommend the cheapest option*. Detect lack of date, ambiguity or incomplete specificity without inventing a date or requirement; do not demand unnecessary user clarification when work can proceed safely.

**DoD:** Focused table-driven tests on at least ten distinct domain/request shapes demonstrate correct evidence slots and hard constraints. Mutation of geography, time or target entity must cause a test failure. No parsing step grants authority to fetched instructions.

### T02 — Provider capability and policy-aware selection

**Owners:** `discovery_provider.py`, `adapter_registry.py`, `acquisition_environment.py`, `http_transport.py`.

Represent provider *capabilities* in the authoritative registry: general web search, domain-specialist search, document index, academic search, official source, user-supplied local document, etc., with actual support and grants. Selection must be based on request evidence needs + measured provider ability to return relevant metadata and permitted sources. A general encyclopedia provider can be useful for background definitions but should not be used as sole support for real-time rates/availability. Prefer an authorized general search backend for open-domain live facts. If the repository's existing DuckDuckGo provider works and is permitted, integrate it through its current API; if it does not, distinguish implementation defect, access denial and unavailable service. Do not claim or silently enable an external search subscription.

Provider fallback should consider quality and failure type, not just the first nonempty response. Preserve explicit ordered user/operator preferences, with documented conditions under which a result is rejected and the next provider tried. Avoid permanently hardcoded provider ranking for all tasks. Preserve source provenance per candidate and per attempt.

**DoD:** A provider returning ten irrelevant results loses to another returning three relevant ones; if all providers are denied the result is an honest typed refusal; offline-only triggers zero network requests. Authorized fallback and malicious/cross-origin denial paths are exercised in tests.

### T03 — Adaptive query planning and retrieval strategy

**Owners:** `query_family.py`, `source_discovery.py`, `discovery_provider.py`.

Produce several purpose-specific bounded queries derived from evidence gaps, not uncontrolled synonym spam. Carry hard user constraints (e.g., Ottawa, monthly parking, pricing) across rewrites. Separate broad discovery, candidate-specific rate verification, official-source checking and independent corroboration. Use search snippets and structured result metadata to decide whether to expand, narrow, change source category or stop. Support useful date and geography tokens without treating mere token overlap as confirmation. No fake result URLs, no search-result snippets promoted to verified page facts.

Define exhaustion/fallback policy: limited attempts per provider, distinct queries per gap, per-domain caps, canonical URL deduplication, no infinite retries, exponential backoff only for transient errors with bounded ceiling, never retry access refusal without changed authorization. Record rejected strategies and their reasons.

**DoD:** Ottawa parking query reaches parking-related Ottawa sources or produces an honest provider/access/exhaustion status; it cannot be "solved" by a preselected Wikipedia URL. At least six adversarial query families demonstrate durable constraints. Query loops terminate under configured budgets with exact attempt receipts.

### T04 — Two-stage semantic relevance and source suitability

**Owners:** `source_relevance.py`, `source_discovery.py`, `retrieval_broker.py`, `normalization.py`.

Implement two-stage relevance: (A) cheap pre-fetch metadata gate (title, URL, snippet, canonical URL, source class, date where known); (B) post-fetch content-evidence gate. Use token/phrase/geographic/entity matching as supporting signals, **never** the sole adequacy criterion. Require evidence that content addresses the requested attributes and not merely mentions the city/topic. Distinguish topical relevance from *answer evidence*. An Ottawa tourism page may be topically relevant but contain zero usable monthly prices. Check temporal and locale conflicts, sponsored/SEO noise, boilerplate, translated/aggregated and duplicate copies. Allow general reference sources for conceptual questions. Respect source scope and authority; .gov alone does not prove truth.

Persist `triage_verdict`, reason, evidence span, source type, page date as observed, extract version and an uncertainty/confidence dimension grounded in explicit signals. A refused candidate must not be counted as answering a question. Protect against prompt injection in pages/snippets. Reject/hold unrelated pages even if they contain incidental matching tokens.

**DoD:** All seven historical off-topic Wikipedia hits fail as parking price evidence; a legitimate Ottawa parking rate page passes when it contains rate/location/time evidence; a page with parking *only* as a navigation item fails; a current official source and a stale cached copy are distinguished; one-source duplicate syndication never appears as two independent confirmations.

### T05 — Evidence extraction, source independence and claim verification

**Owners:** `observation.py`, `verification.py`, `fusion.py`, `report.py`, `source_artifact.py`.

Define typed `EvidenceUnit` / `Claim` (or extend existing canonical contract): claim, attribute, normalized value, units/currency, geographic target, effective/as-of time, exact provenance URL/document id, content digest, precise span/quote or deterministic locator, observed timestamp, extraction method/version, and verification status. Separate `NOT_FOUND_ON_PAGE` from `NOT_AVAILABLE_IN_MARKET`. For prices, parse currency and rate period robustly, but domain-independent units and qualifiers must remain generic. For local services distinguish operator-published rate, historical rate, booking inventory, and real-time bookability.

Cross-source verification must measure source independence and contradictions, prioritize primary current sources where relevant, and avoid false numerical precision. Where extraction uses LLM reasoning, require provenance-preserving schema validation and a deterministic external audit of the cited passage; never permit model-written confidence to substitute for verification. An item from an unauthorized or stale source cannot be silently promoted. Attach claim-to-source support and contradiction links. Persist a durable audit artifact.

**DoD:** Mutating an asserted number, unit, date, city, URL digest, citation span or source independence causes verification failure. Contradictory prices become explicitly unresolved or properly dated, never averaged silently. Negative availability is not asserted without suitable evidence and search scope.

### T06 — Gap-driven continuation, bounded autonomy and safe recovery

**Owners:** `research_owner.py`, `research_dispatch.py`, `recovery.py`, `checkpoint.py`, `budget.py`, `research_progress.py`.

After each retrieval batch, compute answered/unanswered evidence slots and relevance quality. If insufficient, route through permitted query/provider re-plan until: evidence threshold met, exhausted authorized sources, user cancellation, time/compute budget reached, or explicit policy denial. Do not treat `sources_acquired > 0` as success. Distinguish research unavailable from verified negative. Persist state at each transition, resumable by stable identities; retries idempotent and preserve source digests and query history. Recovery handles malformed provider payloads, partially received pages, crashes, stale checkpoints and unavailable individual components without stopping the whole DoubleTake system. Automatically isolate a bad implementation and use last-known-good governed component if supported; do not invent fallback evidence or bypass limits. Maintain operator-visible reason when recovery cannot complete.

**DoD:** Tests demonstrate restart mid-discovery, restart mid-acquisition, duplicate callback, provider outage, cancellation, corrupt checkpoint, zero-results, access denial and budget exhaustion; all terminate with no unauthorized requests, duplicate spending or fabricated result.

### T07 — User-facing grounded answers and genuine chat integration

**Owners:** `report.py`, `research_run_surface.py`, `research_dispatch.py`, `api/chat_sse/chat_route.py`, existing UI research findings components.

Research results must yield a real final answer in ordinary chat, not only an activity log or status chip. Include useful answerable facts, citation links/source identity, observed date, unresolved fields and a truthful qualification about what is or is not verified. If results are partial, provide the supported partial answer rather than pretending nothing was found. Distinguish 'no suitable result was confirmed' from 'none exists'. Cite specific sources, not an undifferentiated list of pages. Do not use unrelated source links in support of an answer. Verify that the output is based on the *same actual run* as the report and is user visible, with no fabricated report text in tests.

The UI must represent progress and failure succinctly without implying all fetched pages were relevant. Preserve privacy and avoid displaying raw secrets or unsafe web text as instructions. Ensure UI functionality remains usable with JS/network/component failures.

**DoD:** A normal Chat UI request (not a direct test-harness injection) causes authorized research, relevance rejection/continuation, a grounded report, and a substantive visible answer. Record a real service-origin trace. A forged answer-source mapping fails a dedicated test.

### T08 — Measured strategy memory and selective improvement

**Owners:** existing research outcome/knowledge/capability evolution and run-ledger owners; introduce no second controller.

Store bounded, privacy-safe, content-addressed observations about query patterns, selected providers, refusals, relevance, evidence coverage, cost/latency and verification outcome. Use the history to choose better strategies *only when matched held-out measurements demonstrate gain*; separate context-sensitive strategy tuning from unrestricted self-modification. Avoid learning from unsupported responses as ground truth. Expire obsolete price/availability facts appropriately and prevent stale source evidence from becoming fresh. Support counterfactual ablation (`strategy_memory_off`) and versioned rollback. Use existing three-phase evolution pressure mapping and governance for genuine upgrades, without relying on a specific controller name.

**DoD:** Matched held-out outcomes show an objectively measured improvement over a frozen baseline or the optimization is disabled. Strategy memory cannot grant network authority, contaminate source truth, or silently increase budgets.

### T09 — Independent benchmarks and non-vacuous controls

**Owners:** `domain_benchmarks.py`, existing universal-research test modules, new narrowly scoped tests and independent report generator.

Construct reproducible held-out benchmarks across at least eight domains: (1) Ottawa monthly parking; (2) other city/local service; (3) product price/spec; (4) evolving software documentation; (5) scientific literature; (6) current factual/news question; (7) policy/legal source reading; (8) two conflicting sources; plus URL-provided and offline-only controls. Include deliberately misleading snippets, wrong geographic matches, stale rates, irrelevant encyclopedia pages, duplicate syndicated sources, prompt-injection payloads, unavailable providers, robots/SSRF denies, and legitimate no-result conditions. Freeze datasets before optimization; maintain separate train/dev/held-out splits. Do not use hardcoded fixture IDs in production routing.

Report metrics, per scenario and macro-averaged: relevant@k and precision@k, evidence-slot coverage, unsupported-claim rate, exact citation support, geo/date/entity constraint preservation, negative-result calibration, provider fallback success, request/cost/latency, completion, rollback, and regressions. Include an end-to-end independent acceptance suite. Record baseline vs candidate on the same requests, provider permissions, budget and frozen source corpus. Use meaningful predeclared margins rather than optimizing to an arbitrary pass count. Favor correctness; no regressions on safety. Record both improvement and failures.

**DoD:** Improvements are measured, not asserted. At minimum: **zero unsupported claims and zero wrong-city parking confirmations** in held-out safety-critical cases; **100% rejection of the seven known irrelevant parking references as rate support**; **no regression on offline/SSRF/authority guards**; positive improvement in the macro-average of relevance and evidence coverage over baseline (with no material deterioration on any tested domain). Explicitly report if data are insufficient to estimate real-world generalization.

### T10 — Live external acceptance without success laundering

**Owners:** `live_parking_acceptance.py` and new generic `live_research_acceptance.py` if necessary; `criterion_table.py`, `final_closure.py`, `live_mission_state.py`.

With operator-authorized network access, rerun the Ottawa parking request through the ordinary chat path and at least **two unrelated live questions** using the same machinery. Use a suitable permitted general search provider; do not hardcode source candidates, seed answer snippets, preselect good URLs, inject harness-only provider data, or substitute local fixtures. Capture search/provider choice, each query, candidate title/snippet/URL, relevance decision, fetched evidence, claims, user-visible final answer, timestamps, permissions, and budgets. Parking success is **a useful sourced answer**: e.g. located Ottawa monthly parking operators/options with verifiable advertised rates and qualification, or a well-supported partial answer explaining exactly what could not be verified. Lack of a confirmed *space* is not itself a failure when no inventory was asked, but lack of evidence about *monthly parking* is.

Run an **independent evaluator** of the actual acquired page content, geographic correctness and final answer/source linkage. Only independent relevant source confirmation can satisfy live relevance. If network grants are absent, record `BLOCKED_PERMISSION` and leave live closure OPEN. If provider fails, use `BLOCKED_PROVIDER`; if relevant sources exist but prices cannot be confirmed, report partial/inconclusive truthfully. Never upgrade to a complete status because unrelated pages were fetched or because a generated report says `PASS`.

**DoD:** At least three distinct live research tasks processed end-to-end, with on-topic source acquisition and grounded user-visible findings when providers return relevant evidence. No fabricated data and no mismatched source/claim. Externally impossible conditions are recorded as typed blockers, not code-completion claims.

### T11 — Cross-artifact truth and self-certification defense

**Owners:** `criterion_table.py`, `final_closure.py`, `live_mission_state.py`, `evidence_manifest_package.py`, `live_parking_acceptance.py`.

Resolve the contradictory historical verdicts with a versioned, monotonic evidence authority graph. A `FINAL_CLOSURE` decision may reference only immutable committed input record digests, schema versions, source HEAD retention and explicit independent verification. The state machine must **rederive** status from the same canonical live record; a stale artifact must be detected, not reinterpreted as current. Define which artifact is normative and exactly how stale snapshots are labeled. A generated `relevant_sources` count must be recomputed from page evidence satisfying all relevant constraint checks, never assigned from `sources_acquired` or self-described metadata.

Keep closure criteria independent from the final report to avoid cycles. Include intentional fault injection: mark irrelevant source relevant, forge a citation, flip mission_complete, alter a rate, make a stale report current, omit a denial, redigest tampered evidence, and change an authority token. Each must fail. Do not rewrite past run truth; create new versioned observations.

**DoD:** Every completion-dependent artifact agrees on the same source run and verdict, or explicitly records why a past record is historical. An independent verification command fails upon each mutation, even when an attacker recomputes the superficial record digest.

### T12 — Deployment, API, documentation and version succession

**Owners:** existing deployment/loader/manager interface, `AGENTS.md`, operator contract docs.

Wire all improvements into real launch/restart/reload semantics and authenticated chat execution, preserving the minimal existing kernel. Respect the current installed implementation identity each invocation; no stale cached module implementation after a governed upgrade. An agent may fix component bugs under authority, but no runtime source patch may bypass evidence gates. Document environment-based provider selection, permissions, operational commands, limits, receipt inspection, freshness, recovery, rollback, troubleshooting and clear meaning of each terminal state. No credentials in logs. Preserve backward-compatible APIs, or explicitly migrate callers and state with tested versioned schema.

**DoD:** After a genuine component change and controlled rollout, a subsequent normal request exercises the new code identity without an unplanned global restart where supported; failed upgrade rolls back with evidence. Existing Chat UI, evolution cycles and other missions stay operational.

---

## 4. EXECUTION ORDER, DEPENDENCIES AND EXPLICIT FILE OWNERSHIP

Order by dependency: **T00 -> (T01, T02) -> T03 -> T04 -> T05 -> T06 -> T07 -> T08 -> T09 -> T10 -> T11 -> T12 -> final audit**. Read-only recon/independent tests can run in parallel. Shared runtime files have only one writer at a time. Integrate components in small reviewable commits on the operator-authorized branch (do not create side branches if current operator instructions prohibit them). Tests, proofs, downloads and builds must use the guarded host workload runner as prescribed by `AGENTS.md`. Do not run a resource-intensive retry loop after a guard refusal.

File ownership mapping above is a *starting point*. If code has moved, find the canonical owner using imports and live route tracing, record why the new file is correct, and modify that owner. A component is complete only when the actual service calls it. Keep the package structure import-light; prefer lazy import where existing architecture requires it. Document all additions in the authoritative registry, schema and unit tests. No static safety-bypassing regex as a substitute for relevance evaluation.

Every T-stage deliverable must record: changed paths and commits; before/fault behavior; after behavior; focused tests; held-out tests; independent evidence; safety controls; known residuals; and exact next work item. A failed test is not a blocker by itself: diagnose and repair within bounds. A missing external grant is a genuine blocker, not a reason to bypass policy.

---

## 5. REQUIRED EVIDENCE ARTIFACTS AND VERIFIERS

Use directory `reports/universal_research/intelligence_closure/`. Create or regenerate with real source-backed generators:

- `BASELINE.md` / `BASELINE.json`: audit, true starting snapshot, frozen failure.
- `IMPLEMENTATION_MATRIX.json`: T00–T12 and each owner, expected state, observed evidence, tests, gaps.
- `QUERY_PROVIDER_TRACE.json`: provider capabilities, grants, query family, fallback and outcome.
- `SOURCE_RELEVANCE.json`: candidate-level triage and exact source-level evidence locators (no private data).
- `CLAIM_VERIFICATION.json`: supported, unsupported, contradicted and stale claims, with provenance.
- `BENCHMARKS.json`: fixed held-out baseline vs candidate; per-domain and macro metrics, costs, non-vacuity.
- `LIVE_RESEARCH_ACCEPTANCE.json`: three or more true live end-to-end tasks or typed external blocker, with exact timestamps.
- `SAFETY_AND_RECOVERY.json`: authority/SSRF/offline/restart/cancellation/fault-injection regressions.
- `CROSS_ARTIFACT_AUDIT.json`: shared run ids/digests, stale detection and rejection of contradictory closure claims.
- `CRITERION_TABLE.json`: full machine-readable gate ledger, test pointers, actual metrics, remediation.
- `FINAL_CLOSURE.json`: independently derived terminal decision, evaluated HEAD/retention, manifest and all unresolved gates.
- `OPERATOR_GUIDE.md`: how to run, configure, verify, disable and roll back, with true examples.

Artifacts may reuse existing canonical records instead of copying them. If reusing, write pointers and verified content digests, not duplicate authority. Each generated artifact gets an `--verify` implementation that rederives its meaningful claims from bound source/fixtures/receipts rather than simply parsing JSON or trusting stored `PASS`. For network evidence, `--verify` must check the preserved acquired text and immutable receipt, not quietly re-search and call it the same run. Record which claims cannot be re-verified offline.

Regeneration must be topologically ordered: code/tests and source receipts -> measured benchmarks -> live evidence -> criterion table -> closure -> manifest; break any cycles. Commit and stage input artifacts at the order required by existing index-based readers, under a single writer. Reverify against a retained pushed commit or produce an explicit unpushed/offline limitation. Never claim an orphaned digest as retained.

---

## 6. CROSS-CUTTING SECURITY, HOST AND EVIDENCE GATES

Required preserved behaviors:

- User says no web -> zero discovery and acquisition network calls.
- Explicit operator grant absent -> no external network; no silent provider bootstrap.
- SSRF, loopback, localhost, link-local, private IP, rebinding, redirects, unauthorized schemes, robots, rate limits and response size controls cannot be bypassed via search results.
- Remote page text is untrusted data: never treated as instructions to reveal secrets, execute tools, modify repo or broaden permissions.
- Passwords, tokens, private files, customer data and account information are not sent to third-party search providers without explicit authorized scope.
- Live candidate failures do not block unrelated core runtime work; research component failure is isolated and typed.
- Bounded concurrency, memory, CPU, request quotas, retry count and timeout. Recover interrupted state without fake successes.
- Promotions/upgrades retain independent measured benefit and rollback authority. Do not change default evolution policy as a side effect of research improvement.
- Output claims require actual supporting evidence and exact source traceability; sources are not guaranteed true merely because they are web accessible.

For each gate provide normal and negative tests. A bypass mutation must turn a formerly passing guard red.

---

## 7. FINAL GATES AND TERMINAL VERDICTS

**G01** Baseline frozen; original irrelevant parking sources verified as non-evidence.  
**G02** Intent/evidence contracts preserve hard constraints across plans and follow-ups.  
**G03** Provider selection uses capability and permissions, not first-nonempty source count.  
**G04** Bounded query refinement reaches a relevant source or transparently exhausts options.  
**G05** Pre/post-fetch relevance gates distinguish topical from attribute-supporting evidence.  
**G06** Claims are source-, span-, location-, unit- and time-bound with independent verification.  
**G07** Coverage-driven continue/stop/recovery state machine is wired into normal runtime.  
**G08** Ordinary Chat UI gets substantive grounded answers, not only activity receipts.  
**G09** Strategy memory is measured, bounded and rollback-safe; no authority escalation.  
**G10** Held-out multi-domain benchmark shows material relevance/coverage improvement and no safety regression.  
**G11** At least three genuine live tasks are correctly traced or carry legitimate external blockers.  
**G12** Past conflicting closure states are reconciled with immutable evidence and negative checks.  
**G13** Existing ecosystem/regression suites, rollback and dynamic code-version path remain intact.  
**G14** Every artifact verifier independently rejects deliberate tampering and mismatched versions.  
**G15** All docs, deployment config, final artifact bindings and operator checks are complete.

Use exactly one of:

- **`UNIVERSAL_RESEARCH_INTELLIGENCE_COMPLETE_LIVE_VERIFIED`**: G01–G15 PASS, genuine on-topic multi-domain live results with supported substantive user-visible answers, positive measured held-out improvement and no critical regressions.
- **`ENGINEERING_COMPLETE_LIVE_BLOCKED`**: G01–G10 and G12–G15 PASS; G11 blocked solely by precisely evidenced unavailable external authority/provider/network conditions. This **does not** mean full mission completed; preserve the remaining live gate for authorized continuation.
- **`ENGINEERING_INCOMPLETE`**: any engineering/test/evidence gate unresolved or failed. Name each failing gate and its exact next patch/test.
- **`INVALID_EVIDENCE`**: inconsistent closure records, fabricated support, misbound commits, non-vacuous negative controls absent, or tampered source data. This overrides success claims.

**Do not use `NO_CONFIRMED_SPACE` as a completion shortcut.** A negative conclusion is substantive only if the search sampled genuinely relevant sources, explicitly searched for the attribute requested, and differentiated unknown inventory from proven unavailability. It can be a legitimate research answer *inside* a successful live run; it cannot substitute for actual task-relevant retrieval.

---

## 8. AUTONOMOUS CONTINUATION AND STOPPING RULE

Execute the mission through the remaining deltas until the strongest legitimately supported terminal verdict is reached. Do not stop because a PR is merged, one test passes, or a report describes itself as complete. On an engineering defect, inspect, repair, rerun targeted tests and update evidence. Do not enter infinite loops on external blockers or exhausted resources. On external blocker, stop safely with the exact missing grant, authorized provider capability, observed error and smallest permitted re-entry point. Never request resources by making hidden purchases or unauthorized connections.

Before closure, independently inspect the complete Chat path once more, compare against baseline, check all final gates, re-run regression and fault-injection suites under the guard, verify committed report identities, confirm there are no uncommitted mission changes, and record whether the active running instance is actually on the measured commit. An agent cannot establish deployment merely by reading GitHub; make that limitation explicit.

### Required final response format from the executing agent

1. **Verdict** (one of the four exact terminal labels above), git HEAD, branch, remote status and observation timestamp.
2. **What actually works**: concise feature-by-feature factual summary, distinguishing tested code, real chat run and unverified deployment.
3. **Gate table** G01–G15: PASS / FAIL / BLOCKED, exact test, source record/digest, no vague claims.
4. **Quantitative delta**: before/after quality metrics and budgets; honest generalization limitations.
5. **Real parking outcome**: actual relevant URLs and extracted parking facts *if verified*; otherwise exact reason no parking information could be established. Never list unrelated pages as parking evidence.
6. **Other live domains**: verified results and claims linked to exact sources, or precise blockers.
7. **Security/regression/rollback**: commands, counts, evidence and any remaining risk.
8. **Changed files and commits**: owners, reasons and identifiers.
9. **Remaining work**: only objectively incomplete deltas, exact next actions, no decorative roadmap.

**Definition of mission success:** DoubleTake discovers sources suitable for the real user need, evaluates whether they provide requested evidence, adapts when they do not, and presents truthfully sourced answers across domains through its ordinary authorized runtime. The current ability to download pages or display a green research workflow is necessary infrastructure, not success by itself.

**END OF EXECUTION PROMPT**
