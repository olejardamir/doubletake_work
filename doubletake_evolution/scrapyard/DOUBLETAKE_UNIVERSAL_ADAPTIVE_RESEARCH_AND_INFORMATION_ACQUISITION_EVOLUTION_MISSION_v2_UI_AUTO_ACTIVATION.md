# DOUBLETAKE — UNIVERSAL ADAPTIVE RESEARCH & INFORMATION ACQUISITION EVOLUTION MISSION v2

**Repository:** `olejardamir/DT` (DoubleTake, **not** the historical Agent_X repository)  
**Execution type:** End-to-end implementation + evidence-based verification; not a design-only assignment  
**Priority:** Make existing DoubleTake useful as a **general-purpose, domain-independent research agent** whose results are supported by obtained, independently assessable evidence  
**Primary user interface and automatic activation boundary:** The ordinary DoubleTake Chat UI; research activates automatically when a user request requires external evidence, without special commands, toggles or the phrase "use research"  
**Relationship to evolution:** Research is an everyday runtime capability; the existing governed three-phase evolutionary system improves research capabilities **selectively**, only when justified and authorized  
**Expected final state:** A user can request investigations as different as downtown Ottawa parking, residential property purchase, and DoubleTake's own algorithmic improvement. DoubleTake can plan, find, retrieve, extract, normalize, reconcile, calculate, compare, validate and report; when a source or tool is blocked, it searches for **permitted** alternate routes and keeps transparent evidence of what did and did not work.

---

## 0. NON-NEGOTIABLE MISSION

Implement **one reusable research execution capability** on top of the current DoubleTake architecture. **DO NOT** create separate parking, housing, real-estate, scientific-paper or web-only agents. Those are evaluation domains, not architectures. **DO NOT** fork or replace the existing evolutionary engine, project-task boundary, capability router, CONDUCT/governance layer, provider stack, chat transport or research assimilation mechanisms.

The mission must produce an **operational, evidence-grounded, multistep research system** that:

1. Accepts a natural-language objective in the ordinary Chat UI.
2. Understands the required answer, constraints, place/date/currency/time horizon and useful decision criteria.
3. Decomposes the objective into checkable research questions and source requirements.
4. Dynamically discovers and uses **authorized** sources and retrieval mechanisms (web, documented APIs, browser interaction, local/authorized documents, structured feeds, repositories, scholarly records and other supported services).
5. Persists a provenance-bound evidence graph/ledger, with exact identifiers, extraction methods, retrieval timestamps and trust/quality distinctions.
6. Detects, classifies and recovers from recoverable source-acquisition barriers **without** bypassing authentication, paywalls, CAPTCHAs, access controls, rate limits, security policies or terms of use.
7. Extracts, deduplicates, reconciles and combines mixed-format and conflicting evidence without disguising assumptions as observations.
8. Executes deterministic analysis and quantitative comparisons, including time/geography/cost as needed.
9. Checks conclusions and important arithmetic against primary evidence or an independent verifier; records uncertainties, stale facts and material gaps.
10. Produces a practically useful, source-linked answer and optional durable research report. Never hallucinate current availability, prices, measurements, citations, maps or claimed access.
11. Reuses knowledge and capability improvements across unrelated domains while avoiding unjustified persistence of private source contents.
12. Detects when a research capability is genuinely missing or underperforming, and—**as a separate explicitly governed activity**—proposes/implements/benchmarks an improvement using the current active evolution policy (OUTWARD, INWARD, GROUNDING, or its validated successor).

**Fundamental split:** `RESEARCH_EXECUTION` gathers evidence and answers the task; `CAPABILITY_EVOLUTION` changes reusable research machinery when a validated capability gap justifies it. Routine queries must **not** automatically rewrite software, self-install tools, or trigger indefinite evolution. Never equate the research report's quality with proof the underlying engine evolved.

**Source-barrier principle:** “This retrieval method failed” does **not** establish “the information does not exist.” Continue along a bounded legal source/retrieval ladder. Conversely, “we tried alternatives” does **not** establish “the information was obtained.”

---

## 1. START WITH A LIVE REPOSITORY AUDIT — NO ARCHITECTURE ASSUMPTIONS

At mission start:

1. Read `AGENTS.md`, `ACTIVE_WORK`, `README.md`, `QUICKSTART.md`, relevant architecture/ownership documentation, current `main`, tracked/untracked modifications, concurrent agents, and runtime resource policy. Work only within repository rules; no uncontrolled worktrees, destructive resets, surprise squash merges, or uncoordinated concurrent report generation.
2. Identify existing real implementations, entrypoints, interfaces, safety constraints and tests before adding any new class. Inspect these confirmed paths (revalidate them against current HEAD):

   | Existing surface | Path / contract to inspect | Required reuse or boundary |
   | --- | --- | --- |
   | Chat ingress | `tools/doubletake_evolve/api/chat_sse/chat_route.py`, `event_stream.py`, `ui/src/` | Natural-language research request, SSE progress, same-session result |
   | User intent and task orchestration | `tools/doubletake_evolve/project_evolution/intent.py`, `boundary.py`, `models.py` | Do not misclassify read-only research as source mutation |
   | Capability discovery/participation | `tools/doubletake_evolve/collective_core/capability_router.py`, `capability_participation.py`, `service.py` | Reuse current routing and governed execution, not an independent router |
   | Three-phase evolution | `tools/doubletake_evolve/collective_innovation/`, `collective_core/service.py` | Evolution only when selected, authorized and benchmarked |
   | Research source acquisition | `tools/doubletake_evolve/research_source_evolution/source_acquisition.py`, `source_manifest.py` | Preserve provenance/ephemeral cleanup; **source_acquisition.py currently states that it does not fetch network sources** |
   | Scholarly search | `tools/doubletake_evolve/arxiv_explorer/` | Reuse bounded query/caching and truthful fault reporting |
   | Git repository intake | `tools/doubletake_evolve/github_intake/` | Reuse repo metadata/content intake, license and source checks |
   | Research mechanism adapters | `tools/doubletake_evolve/research_assimilation/` | Preserve the completed mechanism integration and verifiers |
   | Browser/external tools | Existing `tools/`, `providers/`, MCP, browser, HTTP/transport, security and sandbox modules | Find actual supported providers; **do not assume a browser/connector is available** |
   | Security, budgets and storage | `tools/doubletake_evolve/runtime/`, `collective_core/`, `enterprise/`, `security/` | Preserve authorization, bounded host workload, data isolation, SSRF protections and evidence |
   | Current closure baselines | `reports/research_assimilation/operational_closure/FINAL_CLOSURE.json`, `reports/chat_three_phase_evolution/FINAL_CLOSURE.json` | Keep old missions green; they **do not** prove this new mission |

3. Inspect available connectors/browser capabilities on the *actual deployed machine*. Record what exists, what is configured, what needs credentials or user action, what sources are unavailable, and which legitimate substitutes are available. Do **not** install dependencies/download models without explicit existing authorization.
4. Trace the live call graph from `Chat UI submit → chat backend → intent/task → capability router → tools → persistent record → SSE/answer`; identify the narrowest allowed hooks for a new research-work execution route.
5. Before modifying source, produce a baseline table with columns: capability, existing owner, demonstrably functioning, evidence/test, missing delta, proposed minimal change. Reuse anything already competent; suppress duplicate capability declarations.
6. Inspect the current schema, lifecycle and generator contract for source manifests; do not treat the older paper-corpus campaign's intentionally local-only acquisition as a network client. Extend through adapters around the governed acquisition/evidence boundary rather than silently broadening that original campaign's semantics.

**Audit definition of done:** An exact path-by-path plan shows ownership and minimal changes, including network transport, permitted browser control, extraction, evidence ledger, resolver, task planning, analysis, reporting, recovery and tests. The plan is actionable **and followed by implementation**; merely writing it does not complete this mission.

---

## 2. ARCHITECTURE: ONE UNIVERSAL RESEARCH WORKFLOW

Construct or reuse the following **logical interfaces** (names are illustrative; use canonical equivalents in repository). Persist state with versioned schemas and existing authoritative stores, not only process memory.

```text
Chat message / task
    |
    v
ResearchIntent + Constraints + Authorization
    |
    v
ResearchPlan (questions, dependencies, source priorities, stop conditions)
    |
    v
Governed Research Orchestrator
    |-- Source Discovery / Retrieval Broker
    |      |-- source adapter registry (web/API/browser/PDF/local/repo/...)
    |      |-- barrier diagnosis + bounded permitted fallback
    |      `-- extraction + provenance + ephemeral byte handling
    |-- Evidence Store (source → observation → claim → comparison)
    |-- Reconciliation / Data Normalization / Calculation
    |-- Verification + Contradiction / Freshness / Confidence Gates
    `-- Synthesis + Report + Chat SSE Status
    |
    v
Answer + source-bound report + unresolved items

On an independently established capability gap:
Research Failure/Metric → existing Capability Router/Governance
→ current Evolution Policy → benchmark/ablation/rollback
→ eligible capability change (separately approved)
```

The orchestrator must be **checkpointable, resumable and budget-bounded**. Each tool call/step has provenance, structured outcome, expected output type, resource budget, deadline, retry count and cancellation semantics. A restart must not transform missing records into completed work or repeat costly/side-effecting actions.

### 2.1 Required durable entities

Use or adapt the existing data model; if missing, define versioned persisted forms for:

- `ResearchRequest`: objective, request/message/run/session IDs, constraints, geography, locale, currency, freshness, quality threshold, user authorization, sensitivity/privacy classification, deadline and budget.
- `ResearchQuestion`: question ID, plan dependencies, answerable criterion, expected evidence types, information gain priority, provisional status.
- `SourceCandidate`: URL or authorized source identifier, source role (official/primary, commercial, aggregator, forum, archive, user-supplied), discovery mechanism, domain, access requirements, policy metadata and attempted strategies.
- `RetrievalAttempt`: adapter/tool version, operation, timestamp, source identifier, HTTP/protocol outcome where applicable, failure class, bounded retry/fallback decision, cost/duration and resulting artifact digest.
- `SourceArtifact`: actual acquired content ID, MIME/media type, source identity, retrieval time, canonical URL/record ID, original version/etag where available, extraction method, completeness indicators, content digest and permissible retention policy.
- `Observation`: exact factual value/table row/quote/calculated field, source anchor (page/table/row/section), unit, currency, geospatial referent, observation time vs retrieval time, status (observed/derived/estimated), transformation lineage.
- `Claim`: statement, supporting and contradicting observations, evidential weight, uncertainty, date scope, verification status and downstream usage.
- `Barrier`: target, kind, attempted actions, policy classification, lawful alternatives, escalation, terminal reason and unverified remainder.
- `AnalysisArtifact`: reproducible calculation, inputs/digests, formula, assumptions, sensitivity/scenario and output unit.
- `ResearchReport`: question coverage, findings, comparable options, citations, ranked recommendation with rationale, limitations, full evidence manifest and final verdict.

Schema invariants: exact source-to-claim references, deterministic serialization/digests where suitable, stable IDs, no circular self-certification, explicit missing/unknown fields, privacy-aware expiry, and observable state transitions. **No fabricated observation from a document title, snippet or LLM recollection.**

---

## 3. TASK INTAKE AND ADAPTIVE PLANNING

**Implementation owner:** Use the existing Chat UI and `project_evolution` intent/boundary + capability participation, adding the smallest first-party governed research task mode as needed.

Required behavior:

1. Detect ordinary research intents such as “find”, “compare”, “investigate”, “what is the best”, “research this”, and “compile evidence”, including follow-up constraints. Read-only research must not inherit source-code mutation authority.
2. Extract location/address when given, date/time window, time zone, arrival/departure requirements, walking/driving constraints, currency, budget, preferences, source freshness and output format. An Ottawa address is user-provided geographic data, **not** permission to transmit private unrelated data.
3. Normalize vague superlatives (`best`, `cheapest`, `fastest`, `safest`) into explicit measurable comparison criteria and weights. If a truly essential constraint is absent, ask a focused question only when necessary; otherwise proceed with declared sensible assumptions and mark them.
4. Generate a question graph and choose source priorities based on expected coverage, trust, recency, cost, policy and likelihood of successful acquisition. Adapt plans using acquired evidence, not fixed prompt stages only.
5. Track progress in the same chat run: `PLANNED`, `DISCOVERING`, `ACQUIRING`, `EXTRACTING`, `ANALYZING`, `VERIFYING`, `COMPLETE`, `PARTIAL`, `BLOCKED`, `CANCELLED`. Never label an attempted request as successfully retrieved.
6. Support direct follow-ups (`what if I arrive at 7 AM?`, `remove valet lots`, `include monthly passes`) by reusing still-fresh eligible observations, revalidating changed inputs, and re-running affected dependencies only.

**Done:** Ordinary user-origin research requests reach a real orchestrator through the existing service/task/governance path, without model-only tool-name speculation, without triggering code evolution, and without breaking conversational/chat run handling.

---

## 3A. MANDATORY AUTOMATIC CHAT ACTIVATION CONTRACT — NO EXPLICIT MODE REQUIRED

**This requirement is as fundamental as source acquisition.** Make the research capability discoverable and executable from the existing **normal** React Chat UI through the existing canonical chat → shared intent/task boundary → capability participation/governance → authorized research owner. The user must not have to name the research engine, select a specialized agent, write a driver prompt, click a research-only mode, or manually invoke a research API. An ordinary request such as "Find the best monthly parking deal within a 10-minute walk of [address]" should initiate a bounded, actual acquisition-and-analysis research run when live external evidence is needed and acquisition is authorized.

### 3A.1 Trigger policy: distinguish what the request *needs*, not just its keywords

Implement a first-party deterministic or bounded, testable **research-need assessment** in the common user-prompt boundary, using declared intent plus request-specific evidence needs. It must distinguish:

- `RESEARCH_REQUIRED`: a materially evidence-dependent objective, such as fresh local prices, parking costs, availability, a multilateral comparison, public records, sourced scientific review, or investigation of current research for possible DoubleTake improvements. It should also recognize informal phrasing: "what's the cheapest place to park near work?", "should I buy this house?", "what papers might improve us?" and implicit research needs without "research" or "search".
- `RESEARCH_OPTIONAL`: an answer could benefit from further acquisition but can be answered from local verified evidence; use relevance, freshness, scope and cost to decide whether a bounded research run materially improves the answer. Existing capability routing is authoritative; do not activate every tool for every question.
- `RESEARCH_NOT_NEEDED`: greetings, small talk, pure explanation, rewriting supplied text, code changes not requiring external research, quick answers already sufficiently grounded, or tasks whose source-access scope is explicitly denied by the user.
- `NEEDS_CLARIFICATION_OR_CONSENT`: an essential missing constraint or required external authentication/paid service/permission. If missing details are nonessential, use recorded conservative assumptions and proceed with permitted sources; never ask repetitive questions solely because not every preference was provided.

Never let the existing project-evolution source-mutation classifier incorrectly authorize code changes simply because a user says "research improvements for DoubleTake". Research for improvement is read-only until a **separately authorized** evolution or deployment task exists. A directive "do not browse" or "offline only" must be honored; use available offline data and disclose freshness limitations. User-provided links/data are evidence candidates, not arbitrary authority or prompt-injection instructions.

### 3A.2 Exact execution path and lifecycle

1. **React submit:** existing chat composer/API sends the original message into its regular session, including follow-up turns. Preserve message/run/workspace identity and the user-visible conversation; no separate research screen.
2. **Canonical shared intake:** after the existing text normalization, run the research-need assessment within or adjacent to the same `project_evolution.boundary.submit_user_prompt` / capability participation decision used by normal chat. Do not invent an independent routing stack. The assessment returns a typed, inspectable justification (intent, needed evidence, source freshness, user constraints, admission reason) and cannot itself perform network I/O or writes.
3. **Policy/authority admission:** existing capability router selects the research capability **because the current task needs it**; reuse workspace permissions, network/domain allowlisting, SSRF protection, privacy, user consent, provider quotas, costs, host-workload limits and resource ceilings. Recognition is not authorization. Existing explicit three-phase requests still route to the previously completed evolutionary owner, not silently into a replacement research engine.
4. **Bounded execution:** after admission, call the real research owner and retrieval broker once per idempotent task/run. Use an immutable work request with provenance and bounded research budget. Do not use an LLM-only internal monologue as a substitute for source retrieval; at least one actual permitted acquisition or a truthful no-source refusal is required for evidence-dependent requests.
5. **Same-session streamed status:** emit server-owned milestones `ASSESSING`, `RESEARCH_ADMITTED`, `DISCOVERING`, `ACQUIRING`, `VERIFYING`, `SYNTHESIZING`, followed by `COMPLETE`, `PARTIAL`, `BLOCKED`, `CONSENT_REQUIRED`, `CANCELLED` or another canonical terminal verdict. Only show a milestone after the associated owner step occurred. Publish coverage and source counts from durable evidence, not the model's text.
6. **Answer and follow-ups:** deliver a source-linked, decision-ready answer in the **same chat**. Follow-up turns retain compatible user constraints, references and research-state lineage; selectively refresh stale or missing evidence. A changed address, price horizon or requirement updates the correct dimension rather than restarting blindly or reusing incompatible cached facts.
7. **Reliable lifecycle:** retry/reconnect/browser refresh/stream replay must not start duplicate research or double-pay/use quotas. Cancel/pause/restart reconcile against durable server-owned run state. One user cannot inspect another user's private research sources or results.
8. **Capability growth is separate:** if actual research reveals a reusable acquisition deficiency, record an objectively grounded gap and optionally request/propose a governed three-phase enhancement under existing user authorization. Routine research never self-deploys code or recursively launches unbounded evolution.

### 3A.3 Negative control and explicit ablation

The system must pass a **matched ablation** that removes only the new research activation/dispatch link while keeping the Chat UI, model/provider stub, normal task boundary, sources and research broker intact. A previously passing evidence-dependent chat scenario must **fail its source-acquisition-and-linked-answer assertion** with the bridge removed; merely receiving a plausible answer is not a PASS. Also ablate the broker independently and assert failure. For negative-intent controls, the governed research owner must **not** be called, not merely return an empty result. Require explicit tests for negation, quoting, direct provided-text transformations, conversational questions, and read-only local tasks.

### 3A.4 Concrete must-pass entrypoint tests

- `Find the best monthly parking deal near [Ottawa address] for weekdays, including walking distance and taxes.` → **automatically** launches real research broker and source-backed comparison, without explicit `research` keyword.
- `I commute to downtown Ottawa; where should I park cheaply?` → launches research if sufficient location/context is present; otherwise requests **only** essential missing location, then resumes same task.
- `Compare the total cost of buying a house in Kanata with alternatives.` → activates general research and evidence normalization, not a dedicated housing-only subsystem.
- `Find promising new methods to improve DoubleTake's research acquisition.` → activates information research; **no source mutation** or automatic promotion.
- `Summarize the following paragraph: [text]` → normal chat, no research cycle.
- `Explain what three-phase evolution means.` → normal answer/status if appropriate; no source-research run unless expressly seeking current external sources.
- `Do not search the web; analyze the attached information only.` → offline-only, never public network access.
- Follow-up `Which is cheaper if I park only three days a week?` → uses verified rate/source lineage and recalculates, refreshing only when needed.
- Provider outage, paywall, JS-render requirement, stale pricing, unauthorized URL, restart and parallel identical sends → real bounded recovery or truthful `BLOCKED`/`PARTIAL`, never imaginary successful retrieval.

**Section 3A definition of done:** The **actual Chat UI**, exercised by browser automation plus backend owner receipts, proves that a normal evidence-dependent message activates the governed research owner without requiring a specialized phrase or UI control. The ordinary chat controls demonstrate nonactivation; the mutation tests demonstrate that the new call edge is load-bearing; reconnect and follow-up tests confirm durable, same-session semantics. A direct research API call or standalone orchestrator unit test alone does **not** satisfy this requirement.

---

## 4. SOURCE DISCOVERY + ACQUISITION (THE CRITICAL NEW CAPABILITY)

Build one **governed retrieval broker** using registered source adapters that return structured acquisition outcomes, rather than a single generic search-and-summarize prompt.

### 4.1 Minimum supported acquisition families

1. **Public text web:** governed search/discovery and permitted HTTP retrieval, canonical redirects, HTML parsing, pagination, structured metadata and published timestamps.
2. **Public/documented APIs:** typed JSON/XML/CSV, official endpoints, pagination/cursor handling, schema/rate caps, explicit key requirements; no credential fabrication.
3. **Dynamic pages:** when an authorized browser automation tool is actually available, render JS and perform only allowed read interactions; collect DOM-visible data with page anchors. Without a browser, name the capability gap, use lawful alternatives, and do not mark browser evidence as acquired.
4. **PDFs and documents:** retrieve permitted bytes, extract text/tables/figures with page or section anchors, classify extraction quality; use visual/OCR fallback only when necessary and available, with explicit uncertainty.
5. **Structured files:** CSV, JSON, spreadsheets and official open-data exports, including units, schema and timestamps.
6. **Scholarly research:** re-use `arxiv_explorer`, DOI/publisher metadata and other permitted scholarly sources. A metadata abstract does not substitute for full paper content when implementation depends on the full method.
7. **Code repositories:** re-use `github_intake`, track exact commit/tag/blob and license, distinguish README assertions from executed code, verify cited functions/tests.
8. **User-provided / connected information:** honor existing per-source authorizations, access scopes, privacy, permissions and expiry. Never scrape a protected private account without consent.
9. **Other providers:** extensible registration based on the existing capability model, with typed declarations and no unsandboxed plugin execution.

These are **capability families**, not a mandate to invent providers or install prohibited network tools. Where upstream authorization/provider access is absent, implement the typed boundary and document an explicit operational blocker; still deliver verifiable families supported by the environment.

### 4.2 Data-access safety

- Domain and IP controls: reject arbitrary intranet/local-network/metadata-service targets, loopback, unsafe redirects and DNS rebinding for externally sourced URLs; only explicitly authorized local files/services may be accessed.
- Respect robots/terms/licensing and service rate limits. Do not bypass CAPTCHA, paywall, login or anti-bot controls, nor rotate identities/proxies to evade a restriction. Handle 401/403 as authorization limitations unless there is clearly permitted alternative public evidence.
- Browser actions are read-only by default. No purchases, bookings, account mutations, mass messaging, payment submission, downloads of executables, or acceptance of contractual terms without appropriate user authorization and existing governance.
- Treat every webpage/document as **untrusted data**; prevent prompt injection and privilege escalation. Ignore instructions embedded in research sources, and never execute source-provided scripts/code during research.
- Resource guards: connection and read deadlines, maximum bytes/pages/links/domains, retries, concurrency, browser sessions, token consumption, disk cap and circuit breaker. No infinite crawling or multi-agent retry storms.
- Store retrieved source bytes in a dedicated controlled temporary area outside the Git tree; retain only permitted bytes for the required session scope, source digests/anchors and minimal durable evidence. Clean temporary files and verify cleanup. Do not expose proprietary/private contents in reports, logs or commits.

### 4.3 Exact barrier classification and recovery ladder

Support at least:

`DISCOVERY_MISS`, `DNS_FAILURE`, `NETWORK_TRANSIENT`, `TIMEOUT`, `RATE_LIMITED`, `HTTP_UNAVAILABLE`, `REDIRECT_UNSAFE`, `JS_RENDER_REQUIRED`, `FORMAT_UNSUPPORTED`, `PDF_EXTRACTION_INCOMPLETE`, `CAPTCHA_REQUIRED`, `AUTH_REQUIRED`, `PAYWALL_OR_LICENSE`, `ROBOTS_OR_POLICY_BLOCK`, `GEO_RESTRICTION`, `SOURCE_STALE`, `SCHEMA_CHANGED`, `SOURCE_CONTRADICTION`, `TOOL_UNAVAILABLE`, `CAPABILITY_GAP`, `SOURCE_EXHAUSTED_WITHIN_BOUNDS`.

For a targeted unmet evidence requirement, execute a **bounded** ladder in this order as appropriate:

1. Inspect the precise failure: did discovery, network, access, rendering, extraction, normalization or verification fail? Preserve original error provenance.
2. Retry **only transient** errors with jitter/backoff and an explicit cap; respect `Retry-After` and provider quotas. Do not repeatedly retry hard denials.
3. Check another authorized format/endpoint for the **same underlying source**, including public API, accessible page, published PDF or machine-readable export.
4. Try independent trusted sources (municipal/open data, provider's own published site, sanctioned aggregators) and mark direct vs secondary observations.
5. Use an authorized browser for dynamic rendering when available; do not assume installed and do not treat a renderer missing as evidence that the source is nonexistent.
6. Retrieve authorized cached/archived **public** content for historical facts where appropriate. Clearly label historical data; never present an archived price as current.
7. If a required tool is absent but building a safe adapter is within current authority/budget, propose/implement it as a **bounded governed capability task**, verify with tests, then resume acquisition. Do not silently modify production code in the middle of ordinary read-only research.
8. If recovery would require new login, subscription, private credentials, forbidden circumvention, payment or personal data, stop that branch and request authorization or use public alternatives.
9. If no permitted strategy succeeds within limits, mark the exact question `PARTIAL`/`BLOCKED`, record which sources/methods were attempted, provide bounded uncertainty and continue other independent questions.

**Non-vacuity:** Recovery is proved only when an independently different permitted adapter/source actually obtains verifiable data, not because a test mocks success or the prompt describes an alternative. Use controlled local HTTP/HTML/API/PDF fixtures to test fallbacks deterministically, and live public-provider probes where permitted.

---

## 5. INFORMATION EXTRACTION, DATA FUSION, RECONCILIATION

Create reusable evidence-processing transforms that are source-independent:

- **Typed extraction** of facts, tabular rows, prices, durations, dates, coordinates/addresses, names, availability conditions, legal/policy requirements, measurements, scientific methods and repository facts; every extraction must preserve source anchors and uncertainty.
- **Record/entity resolution** for duplicate businesses/lots/properties/papers, including normalizing address/name variants without merging distinct entities; retain aliases, source IDs and match confidence.
- **Canonical units** for currency/periods (per hour/day/month), tax/fees, distances, coordinates, local dates and time zones; preserve original values alongside conversions and conversion-rate/date provenance.
- **Temporal separation** between publication date, observation-effective date, retrieval date, offer-validity window and report date.
- **Evidence graph** connecting source → observation → normalized attribute → claim → computation → recommendation. For each claim distinguish observed, derived, estimated, contradicted and unknown.
- **Conflict resolution** that prefers appropriate primary sources, current effective records, direct provider statements and reproducible measurements—not arbitrary source-count voting. Keep unresolved disagreements visible with both citations.
- **Coverage scoring** by user question and key entity; missing decision-critical constraints must lower answer completeness.
- **Deduplication** by stable identifiers and content digests; verify cached source freshness/permission before reuse.
- **Reliable calculations** through deterministic tools rather than pure LLM mental arithmetic, with rounding policy, unit tests and sensitivity analysis. Never infer missing numeric values from market intuition and call them observed prices.
- **Source and extraction integrity** with cryptographic digests, content-addressed lineage where suitable, defensible exact spans and a separate verifier that can re-read source artifacts.

**Done:** A mixed-source benchmark can reconstruct every conclusion from cited observation IDs and calculations; deliberate contradiction/staleness/unit-mismatch mutations fail explicit tests.

---

## 6. ANALYSIS, DECISION SUPPORT, VERIFICATION AND REPORTING

The engine should choose task-appropriate analyzers rather than force a single generic numeric ranking.

**Mandatory general analysis:** compare options, rank by explicit user criteria, identify Pareto trade-offs, test assumptions, show uncertainty, identify further-needed evidence and distinguish objective facts from recommendations. Include reproducible formula/source IDs for calculations.

**Geographical tasks:** Use real geocoding, geographic feature and routed travel-time providers only when permitted and actually available; distance-as-the-crow-flies is not a walking travel-time claim. Explicitly distinguish provider-computed route, approximate geometry, and unverified address. Do not invent current parking availability or route metrics.

**Financial tasks:** Normalize cost horizons, include relevant fees/taxes/deposits, identify renewal/early-bird eligibility and effective dates, separate advertised prices from quotes, show uncertainty ranges; no individualized financial certainty without verified terms.

**Scientific/software tasks:** Verify papers/DOIs, source sections, repository commits and license, compare evidence quality and implementation feasibility; report whether an idea was only read, prototyped, benchmarked, or deployed. Claims of improvement must have matched baseline + treatment and independent tests.

**Report:** The Chat UI displays a concise decision-ready answer first, with ranked options, important numerical assumptions, source links or precise anchors, freshness timestamps, confidence/coverage and what could not be verified. Produce a durable expandable structured report from the evidence graph. Support tables/maps only when actual geospatial/evidence data permits. Follow-up questions should reuse and update cited evidence rather than restarting the research blindly.

**Verification:** A separate component should re-evaluate key numeric results and links from frozen evidence (e.g., total monthly cost, per-workday calculation, validity window, geographic join). Spot-check critical sources, reject citations that do not support the exact claim, and report source access failure as a limitation rather than hallucinating.

**Done:** Answer is actionable even if partial, and a verifier can independently trace the important conclusions to the sources and calculations.

---

## 7. THREE-PHASE EVOLUTION — SELECTIVE RESEARCH-CAPABILITY IMPROVEMENT

**Re-use the existing independently closed D01–D08 research assimilation mission, the currently active governed evolutionary policy, project evolution boundary and explicit chat evolution integration.** The new research engine is a participating capability, not another competing evolutionary runtime.

Required distinction:

- If the user says **“Find the best parking near this address”**, do research with existing approved capabilities. Detect failures; try bounded lawful alternatives; report gaps. Do **not** auto-modify DoubleTake's source by default.
- If the user says **“Evolve DoubleTake's research engine to overcome its inability to extract data from these permitted pages”**, route an explicit capability-evolution task via the existing governance boundary and phase engine.
- If the user says **“Research three candidate improvements to DoubleTake itself”**, that is ordinary research until they explicitly authorize actual code changes or the pre-existing autonomous governance policy separately admits them.

Define a measurable `ResearchCapabilityGap` from observed failures: failure taxonomy, affected evidence type, reproducible fixture(s), coverage-loss estimate, authorization boundaries, repeat frequency, candidate improvement and estimated risk/resource cost.

For proposed improvements:

1. **OUTWARD:** Discover external algorithms, permitted libraries, adapters, methodologies, scholarly papers and sources of truth; identify potential gap-closing mechanisms.
2. **INWARD:** Reuse, reconfigure, compose or improve existing first-party capabilities where possible. Prefer small extensions over rebuilding the tool stack.
3. **GROUNDING:** Conduct matched baseline/treatment comparisons over frozen diverse cases, with extraction correctness, source coverage, failure recovery, time, tokens/CPU, security refusals, reliability and rollback. Reject contamination, benchmark gaming and unsupported gains.
4. Submit implementation/promotion through the existing authority and rollback gates. For restricted access barriers, **never** evolve a circumvention mechanism.
5. Track lineage: research incident → gap → attempted remedy → tests → evidence → outcome → new authorized capability version. Improve future unrelated tasks only with validated, generalizable gains.

**Done:** A research limitation can yield an evidence-backed improvement proposal; in a separately authorized test it can pass through the real three-phase runtime, receive measured acceptance/rejection, and be reusable for a different domain. Ordinary research must not invoke mutating evolution by itself. No claim of “self improvement” from merely collecting a paper.

---

## 8. ACCEPTANCE SCENARIOS — DOMAIN-INDEPENDENCE IS MANDATORY

Tests must use **both** deterministic, source-controlled fixtures and, where lawful and available, a bounded public live-source validation. Fixtures demonstrate correctness; live probes demonstrate present deployment usefulness. Keep those verdicts separate.

### Scenario P — Downtown Ottawa parking (primary real-world example)

Representative input:

> “I work near [a specified downtown Ottawa address]. Find the best practical parking arrangement for weekdays, arriving around 8 AM and leaving around 5 PM. Compare municipal lots, private garages, monthly passes and daily/early-bird rates. Consider walking time, taxes, eligibility, restrictions and whether availability is actually confirmed.”

Input data must include a **user-supplied address or a public fixture address**; never use a secretly invented real workplace location.

**Required chain:** discover distinct candidate facilities → provider/official rate source retrieval → parse exact rate windows → identify monthly versus daily pricing → normalize fees/taxes and workday horizon → geocode/route where permitted → avoid false claims of space availability → compare at least multiple independently sourced options when available → rank under user criteria → cite sources and date of retrieved prices → mark unverified details. With no route provider, state the limitation rather than fabricating a walking time.

**Expected checkable calculations:**

- `daily_commute_cost = applicable_daily_rate * declared_commute_days` (with relevant daily caps/fees and tax if known);
- `monthly_comparison = all_in_monthly_pass_cost` versus `daily_commute_cost`, noting eligibility and access-hours constraints;
- `effective_cost = parking_cost + separately modeled nonparking tradeoffs only when grounded`.

One designated parking-price fixture must be unavailable, causing the engine to use **another authorized actual fixture source**, preserving barrier record and independent citation. An offer with an expired effective date must not be ranked as current.

### Scenario H — Ottawa/Kanata housing

Use a fixture corpus with listings, taxes, mortgage terms, recurring ownership costs, locations and conflicting or stale observations. Compare realistic total costs and commute requirements. Clearly separate indicative projections from verified actual borrowing eligibility or current property availability. Show the source chain and uncertainty. The same orchestrator, evidence schema, normalization and report system must be used—no housing-specific agent.

### Scenario S — Scientific/DoubleTake self-research

Start from a bounded question such as “Find promising research methods to improve adaptive web-data extraction and compare them to DoubleTake's existing source-acquisition stack.” Discover scholarly sources and GitHub repositories, confirm content/licensing/version, extract methods with section anchors and identify actionable mechanisms. Missing full text must remain explicit. Produce an evidence-backed capability-gap comparison; **do not** deploy automatically. Separately test a **user-authorized** evolver execution from the same findings and verify phase/approval/rollback receipts.

### Scenario X — Unfamiliar fourth domain

Pick an independent domain at runtime (e.g., public procurement, transportation schedules, product energy efficiency, open government datasets) using the **same operators and data model**, not new hard-coded adapters for its topic. Demand correct evidence integration, limitations and a useful decision-ready report.

### Scenario F — Adversarial barrier suite

Exercise these fixtures: DNS/timeout; 429 with Retry-After; 403/paywall; JS-only content without browser; dynamically rendered content with an authorized simulated browser; malformed or scanned PDF; schema drift; mismatched currency; stale rate; contradictory official/commercial prices; quoted prompt injection; unsafe redirect to internal network; hidden credentials in HTML; duplicate source; unverifiable claim; partial report after budget exhaustion. All must produce **truthful typed outcomes** and zero illegal bypasses.

### Scenario R — Resume, cancellation and scalability

Cancel a run mid-acquisition, restart the process, resume from durable checkpoint, ensure deduplication and no repeated side effects. Test provider error recovery, isolation across two users/workspaces, fair scheduling, bounded memory/tmp storage, and chat SSE disconnect/reconnect without false progress or duplicate work.

---

## 9. QUANTITATIVE EVALUATION AND ABLATION

Create a content-bound benchmark corpus with frozen source fixtures, reference answers and an independently computed grade. Record current baseline **before** implementing the new pipeline; avoid retrospective baseline fabrication. For live runs distinguish `MEASURED_LIVE`, `MEASURED_FIXTURE`, `NOT_MEASURED` and `BLOCKED`.

Metrics (with explicit denominators and ground truth):

| Metric | Definition / minimum validation |
| --- | --- |
| Evidence coverage | Decision-critical questions with backed observations / all decision-critical questions |
| Grounded factual precision | Supported extracted findings / all asserted findings |
| Citation fidelity | Claims whose cited exact source spans support them / claims requiring citations |
| Retrieval success | Authorized source requirements fulfilled / attempted authorized requirements, split by failure class |
| Barrier recovery | Recoverable blocked requirements solved using **independent permitted fallback** / recovery-eligible blocked requirements |
| Contradiction detection | Planted conflicts correctly detected and surfaced / planted conflicts |
| Normalization/calc correctness | Exact arithmetic, currency/temporal/geographic assertions verified / evaluated cases |
| Freshness honesty | Correct expired/stale/unknown statuses / freshness challenge cases |
| Research task completion | Tasks meeting declared evidence + decision standards / eligible tasks |
| Cost/latency/reliability | p50/p95 completion time, requests, model tokens, browser minutes, resource consumption, restart success |
| Security correctness | Denied unsafe access and injected-command attempts / unsafe attempt cases |
| Domain generalization | Holdout-domain score vs in-domain score with no task-specific code |

Mandatory ablations:

- Remove fallback strategy; barrier-recovery score must worsen on designated nontrivial cases.
- Remove evidence anchoring; citation-fidelity verifier must catch unsupported claims.
- Remove typed normalization; unit/currency/time fixture must fail.
- Remove contradiction resolver; conflict-rejection test must fail.
- Remove actual tool/broker invocation but leave LLM prose; source acquisition/receipt tests must fail.
- Remove chat integration; end-to-end user request must fail its correlated-run assertion.
- Remove authorization gate; unsafe target test must detect breach.
- Remove source freshness control; expired-price ranking test must fail.
- Remove evolution bridge; separately authorized improvement test must detect that no real phase cycle ran.

**Measurable-gain contract:** For an enhancement to be claimed beneficial, specify comparison cases, baseline results, treatment results, effect size, uncertainty where possible, costs, and security regressions. If generalization/real-world gains remain unmeasured, report `ENGINEERING_INTEGRATION_COMPLETE_GAIN_UNPROVEN`; do not manufacture a “10/10” score or percentage.

---

## 10. IMPLEMENTATION WORK PACKAGES / EXACT DEFINITIONS OF DONE

Implement in small dependency-ordered commits; **do not stop after a plan**. Adapt names to current canonical ownership, document deviations, and preserve existing code contracts.

| Package | Implementation work and likely ownership | Definition of done |
| --- | --- | --- |
| W00 — Audit | Live inventory and call graph (`AGENTS.md`, `ACTIVE_WORK`, source modules) | Deltas proven; no duplicate subsystem; current risks documented |
| W01 — Research intake | Existing chat route, project-evolution intake, capability router; add authoritative research-task representation | Ordinary research reaches governed owner; no false source mutation; negative intent tests pass |
| W02 — Planner | First-party checkable research question/dependency plan using existing work owner | Inputs/stop conditions explicit, bounded; plan can adapt/restart without duplicate steps |
| W03 — Retrieval broker | Authorized tool/adapter registry and transport through current capability/security surfaces | Web/API and other available families actually fetch bytes; every attempt has structured result; injection/SSRF safeguards |
| W04 — Barrier recovery | Diagnostic classifier and bounded permitted fallback state machine | Real fallback success in fixtures; hard access restrictions refuse; alternative failure distinguished from absence of data |
| W05 — Extraction | Mixed HTML, JSON/CSV, PDF/local and available browser adapters, source anchors | Content-digested anchored observations; malformed content fails safely |
| W06 — Fusion | Entity matching, time/currency/unit normalization, source weighting and conflict management | Multiple sources yield coherent comparable dataset; planted contradictions/stale data exposed |
| W07 — Decision analysis | Reproducible numerical and domain-neutral comparison operators | Correct arithmetic and grounded ranking with assumptions and uncertainty |
| W08 — Verification/report | Independent claim/number verifier, evidence manifest, same-chat SSE and export | Final report citations support claims; PARTIAL status truthful; user can trace figures |
| W09 — Checkpoint/security | Durable store, budget, session ownership, cleanup and restart/cancel | No unauthorized access or duplicated side effects; bounded resource and temp cleanup |
| W10 — Evolution integration | Existing three-phase engine and gap/evidence/rollback path | A separate explicitly authorized request evolves a research capability; ordinary research never auto-promotes |
| W11 — Domain benchmarks | Parking + housing + self-research + unknown domain + barrier suite | Same generic pipeline; measured corpus, adversarial and ablation receipts |
| W12 — Closure | Source-derived report/verifier + user docs + final regression | Every criterion rederived from real tests and durable artifacts; no blockers concealed |

**Parallelism discipline:** Package contracts can be implemented by distinct agents only where existing scheduler/locks authorize them. Serialize changes to shared owners and source-bound report generation. One bounded host resource workload at a time when required by existing host policy. Use `tools/doubletake_evolve/runtime/host_workload.py` only with supported documented invocation; verify actual CLI before execution. Avoid overloading user's Linux host.

---

## 11. INTEGRATION AND SECURITY RULES

- **Existing infrastructure wins:** Do not rebuild `arxiv_explorer`, `github_intake`, research assimilation, source manifest or the chat-to-evolution bridge. Extend/register capabilities through their existing contracts.
- **No magic retrieval:** A search snippet is a lead, not a completed investigation; a citation to an unseen PDF is metadata, not page-level evidence; a tool availability claim is not a successful call.
- **User privacy:** Use least-privilege connected sources; collect only necessary user-provided information; redact identifiers/tokens in reports; prevent cross-session leakage; do not commit private data.
- **Online constraints:** Gracefully distinguish missing browser, no network, disabled provider, auth required, runtime outage, source refusal and genuine data scarcity. Never fabricate connectivity.
- **No regulatory or access evasion:** Do not circumvent CAPTCHA, paywall, bot restrictions, privacy protections, access control or licensing; request user authorization for permitted access or find independent public records.
- **Reproducibility:** Pin source versions, retrieval timestamp, parser/tool and report schema. Preserve old record readers or implement versioned migrations.
- **Prompt-injection resilience:** Untrusted sources can supply facts, not instructions; quoted research content cannot launch tools, code execution or self-evolution.
- **Separation of observation and inference:** Every output field is typed as acquired observation, deterministic derived result, estimate or unknown.
- **Production safety:** No repository mutation/promotion just because a research task was hard; no external side effects without authority; no model weights/downloads or unlimited crawling.
- **Correctness ahead of apparent closure:** Tests must fail when critical owner paths are removed. An entirely mocked “research success” cannot close W03, W04, W08 or W11.

---

## 12. CANONICAL ACCEPTANCE CRITERIA (A01–A16)

| ID | Required objective evidence |
| --- | --- |
| A01 | **Automatic intent-aware activation from an ordinary Chat UI message** (including one without the word "research"), proven through the real browser → chat API → governed owner → acquired-source receipt chain; no special mode or explicit invocation |
| A02 | Non-research chat does not invoke research; user no-web instructions respected; read-only research is separated from repository mutation and explicit evolution |
| A03 | Plan decomposes questions, constraints, dependencies, freshness and stopping bounds |
| A04 | Authorized source broker actually acquires and records information from multiple available formats/providers |
| A05 | Retrieval/authorization/rendering/extraction barriers classified with structured truthful outcomes |
| A06 | At least one independent permitted fallback **actually** recovers a failed acquisition, not just a mocked verbal claim |
| A07 | Disallowed methods (CAPTCHA/paywall/auth/SSRF/prompt injection) are refused with tested guard evidence |
| A08 | Extracted observations link back to exact source content/anchors, digests and timestamps |
| A09 | Multi-source normalization, dedupe, conflict and stale evidence handling independently tested |
| A10 | Decisions/calculations are reproducible, units correct, uncertainty and missing facts explicit |
| A11 | End-to-end Ottawa parking scenario yields source-grounded comparison; no fabricated live rates/routes/availability |
| A12 | Housing, scientific/self-research and unknown-domain holdout use the **same** underlying engine |
| A13 | Same Chat UI shows server-derived research activation, actual acquisition/verification progress, usable answer, cited evidence and honest partial/blocked/consent-required status |
| A14 | Follow-up research reuses compatible evidence and selectively refreshes; cancellation/restart/reconnect/budgets/privacy/temp cleanup verified with no duplicate acquisition or side effects |
| A15 | Explicitly authorized research-tool improvement reaches existing three-phase evolution, measured validation and rollback decision; ordinary research does not mutate |
| A16 | Independent source-bound closure verifier, **matched Chat UI activation ablation and browser E2E**, broker ablation, ordinary-chat negative controls, regressions and user/operator documentation are complete |

**Completion rule:** **Section 3A automatic Chat UI activation is a mandatory non-waivable gate**; `A01–A16 = PASS` based on persisted, independently re-derivable evidence and no unresolved mandatory security or correctness blocker. A live-provider limitation can be documented as such, but must not be hidden in a `PASS` claiming unsupported live capability. If external access is unavailable, distinguish engineering fixture completion from **deployment live-readiness** and do not certify the latter until a permitted real provider succeeds.

**Evidence format:** Store under a new appropriately owned directory, e.g. `reports/universal_research/`, with `SOURCE_ATTEMPTS.json`, `EVIDENCE_MANIFEST.json`, `DOMAIN_BENCHMARKS.json`, `BARRIER_RECOVERY.json`, `SECURITY_REFUSALS.json`, `REGRESSIONS.json`, `CRITERION_TABLE.json` and `FINAL_CLOSURE.json`, or their canonical repo-native equivalents. Provide generator(s) and **independent verifier(s)**. Do not write hand-edited PASS rows. All records must bind to a retained source revision and verifiable input digests, avoiding self-hashing/circular dependencies.

Final closure states:

- `UNIVERSAL_RESEARCH_ENGINE_COMPLETE_LIVE_VERIFIED`: A01–A16 PASS, real permitted acquisition exercised, representative real-world end-to-end research and domain holds verified, bounded integration verified; **does not** imply future answer correctness or model superiority.
- `UNIVERSAL_RESEARCH_ENGINE_ENGINEERING_COMPLETE_LIVE_UNPROVEN`: Complete fixture/regression/route evidence, but independent live provider or real-world outcome evidence not yet sufficient.
- `PARTIAL_WITH_BLOCKERS`: Any mandatory acceptance criterion blocked; identify exact owners/evidence, do not manufacture closure.

**Additional gain field:** `IMPROVEMENT_MEASURED`, `IMPROVEMENT_UNPROVEN`, or `REGRESSION_DETECTED`; never infer live gain from infrastructure installation.

---

## 13. OPERATIONAL VALIDATION / REPORT

After implementation:

1. Run targeted unit/integration tests for each component, including refusal paths and source/noise adversarial fixtures.
2. Run actual chat API and rendered browser end-to-end tests for **implicit research need** (no special keywords or modes), ordinary chat negative controls, follow-ups and matched bridge ablations with controlled *external* provider simulation where required, but the **real internal router, orchestrator, tool broker, evidence persistence and report construction**. Run at least one permitted live provider retrieval through the production path where available.
3. Run end-to-end parking, housing, self-research, unknown-domain and failure/restart suites with objective metrics. Include evidence showing unchanged core owners/approval gates.
4. Run matched ablations and tampering tests: disable fallback, source digest, reconciliation, real transport, research router, security gate and evolutionary improvement path. Each must make its designated independent test fail.
5. Verify source digests, archival/temporary cleanup and privacy boundaries. Do not add unauthorized paper downloads or large data files to the Git tree.
6. Run baseline D01–D08 research assimilation verification and C01–C10 explicit Chat UI evolution verification; preserve their true verdicts and report any regression. No fabricated live-model gains.
7. Commit source and tests in small safe commits, then regenerate authoritative source-bound records from retained HEAD and independently verify; repeat if concurrent commits alter a measured surface. No silent forced commits/resets.
8. Update operator-facing docs and normal-user help with example prompt, citations, restrictions, availability limitations, privacy and stop/resume controls.

**Final operator response must show:**

- Source/remote revision and actual modified paths.
- Exact automatic activation call chain from ordinary Chat UI text to classified research need, governed owner invocation, real acquired-source receipts, and source-backed answer; also ordinary-chat nonactivation evidence and matched bridge-ablation failures.
- Architecture integration path from chat to evidence-backed answer.
- Source acquisition adapters tested live vs only simulated; provider/network limitations.
- Barrier recovery matrix showing actual independent fallback attempts.
- Four domain/scenario outcomes, including parking costs only when truly sourced.
- Evidence, freshness, contradiction, formula and route-verification metrics.
- A01–A16 individually with `PASS`, `BLOCKED`, `FAIL`, `NOT_MEASURED` as appropriate.
- Regression/ablation verification commands with exact exit status and resource constraints.
- Research-driven evolution invocation and exact evidence/authorization/rollback outcome.
- Exact `FINAL_CLOSURE.json` decision, evidence digest, unresolved limitations and whether user can **actually now submit ordinary research requests in the Chat UI**.

**Do not answer with only recommendations, an architectural overview, generated demo text or a plan. Execute the implementation and finish with independently verified evidence.** If network/tool credentials or mandatory authority genuinely block a feature, deliver every safe achievable component, identify the smallest actionable blocker and **do not** claim the absent capability works.

---

## 14. SPECIFIC USER-FACING CONTRACT TO PRESERVE

Users must be able to say naturally:

> “Find the best monthly and daily parking options near [downtown Ottawa address] for my work schedule. Compare prices, restrictions, availability evidence and walking distance. Show verified sources and say which details you could not confirm.”

> “Research whether buying a house in Kanata makes sense under my constraints. Combine listings, taxes, financing, location and commuting information and compare scenarios.”

> “Investigate the best new algorithms and papers that could improve DoubleTake's source acquisition. Compare them with what DoubleTake already has, and tell me which ideas are worth testing.”

> “Using DoubleTake's governed three-phase evolution, improve the research engine's ability to parse difficult **permitted** public pages, benchmark the fix, and retain it only if it produces a measurable gain.”

Those four examples must flow through a **shared evidence and capability infrastructure**, with only the last example demanding explicit mutating evolution. The success standard is practical, independently corroborated results—not merely a model that confidently describes research it never performed.

**BEGIN NOW:** Audit current repository ownership and providers, generate the exact minimal delta plan, implement work packages W01–W12, run bounded tests/ablations, independently verify closure and accurately report the results. Stop when proven complete or when only concrete authorized external blockers remain.
