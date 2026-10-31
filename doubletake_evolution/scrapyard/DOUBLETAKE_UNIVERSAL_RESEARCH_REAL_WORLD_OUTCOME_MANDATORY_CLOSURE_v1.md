# DOUBLETAKE — Universal Research: Mandatory Real-World Outcome and Live Parking Closure

**Amendment ID:** `DOUBLETAKE_UNIVERSAL_RESEARCH_REAL_WORLD_OUTCOME_MANDATORY_CLOSURE_v1`  
**Target mission:** `/home/glompy/Downloads/DOUBLETAKE_UNIVERSAL_ADAPTIVE_RESEARCH_AND_INFORMATION_ACQUISITION_EVOLUTION_MISSION_v2_UI_AUTO_ACTIVATION.md`  
**Repository:** `olejardamir/DT` (`main`)  
**Mission kind:** Mandatory integration + independently verified end-to-end acceptance  
**Priority:** Blocking, non-waivable for claiming this mission complete

## 0. Binding instruction

Execute this amendment as an extension to, not a replacement for, the original Universal Adaptive Research mission. **Do the engineering work.** This is not an invitation to produce another strategy document, a simulated success, or a checklist of proposals. Read the original mission from the path above on the execution host and retain its security, governance, bounded-work, proof, and regression constraints. If that file cannot be read, use the explicitly identified mission and acceptance components in this amendment; report that the source file was unavailable rather than inventing its contents.

The purpose is straightforward: **when a user asks DoubleTake to research actual Ottawa parking, it must really search for parking information, acquire evidence from authorized public sources, compare the findings, and return an evidence-backed answer within the ordinary Chat UI.** An implementation that only understands the request, emits `CONSENT_REQUIRED`, or passes a fixture benchmark does not satisfy this requirement.

**Hard limit of the guarantee:** guarantee that *closure is impossible without a proven attempt and a useful truthful result from genuine external sources*. Do **not** promise that a parking vacancy exists, that a particular provider permits machine access, or that internet access and authorization can be forced. If unavoidable external obstacles prevent the outcome, leave the mission `BLOCKED_REAL_WORLD_OUTCOME`, naming exact blockers and recorded attempts. Never fabricate success or silently downgrade this gate.

## 1. Verified starting state (GitHub `main`, checked 2026-10-17)

The repository already has a substantial engine. Preserve it.

| Current evidence | Verified finding |
|---|---|
| `reports/universal_research/CRITERION_TABLE.json` | A01–A15 `PASS`; A16 blocked in the most recently published table; a newly committed activation-ablation test may require regenerating the table |
| `reports/universal_research/DOMAIN_BENCHMARKS.json` | Ottawa parking + three holdout domains exercised, **all `MEASURED_FIXTURE`**, not real external providers |
| `reports/universal_research/REGRESSIONS.json` | Focused suite last recorded as **1040 passed**; this is evidence at a recorded revision, not a claim about all future revisions |
| `tools/doubletake_evolve/api/chat_sse/chat_route.py` | Ordinary Chat UI has `_chat_broker = None`, submits `broker_available=False`, and calls `dispatch_research(..., candidates=())` |
| `tools/doubletake_evolve/universal_research/source_discovery.py` | Discovers user-*supplied* URLs only; it has no general independent search-provider path |
| `tools/doubletake_evolve/universal_research/broker_activation.py` | Can activate an authorized declared broker; cannot by itself discover real sources |
| `tools/doubletake_evolve/universal_research/http_transport.py` | Provides governed HTTP fetching with SSRF, redirect, byte, and deadline protections |
| `tools/doubletake_evolve/universal_research/final_closure.py` | Defines `...ENGINEERING_COMPLETE_LIVE_UNPROVEN` as an acceptable engineering decision; that must **not** count as completion of this amended mission |

Re-inspect the current working tree and latest commits before modifying any code, because other agents may have progressed since this snapshot. Never overwrite their uncommitted work.

## 2. New, mandatory definitions of done

An ordinary Chat UI prompt containing **no URLs**, for example:

> Find affordable monthly parking in downtown Ottawa near the Bank of Canada office. Check current options, compare what is actually published, and tell me what availability can and cannot be confirmed.

must trigger the **same governed, domain-agnostic research mechanism** used by other subjects. For this acceptance scenario, resolve the geographic anchor from a trustworthy source during the run rather than assuming or inventing a street address. This sample is an **acceptance input**, not a permanent user-preference assertion.

A live success requires **all** of the following:

1. Research was automatically recognized and authorized through the real Chat UI route, without a special activation command or a URL pasted by the user.
2. Source discovery really ran against at least one **configured, authorized, non-fixture public discovery source/provider**, producing independently discovered candidate source references. An empty list, a memorized URL, or an invented search result is not a pass.
3. The governed broker actually retrieved **external non-loopback bytes/data**, with a recorded provider, canonical URL/source identifier, response status, acquisition time, content digest, and authorized access decision. No test server, hand-authored fixture, provider stub, or test replay counts toward live proof.
4. The pipeline extracted parking-related facts from acquired content and linked each user-visible material claim to the source and its exact anchor or evidence record. It applied freshness, conflicts, and uncertainty rules.
5. The normal Chat UI displayed a useful **parking comparison** (or an accurately evidenced absence of suitable published options), with real options and usable source links, caveats and last-checked times. If rate, duration, taxes, location, or availability is absent, display `not verified` rather than guessing. A page that only says research is admitted/blocked is not the completed result.
6. A separate verifier, using the committed evidence and actual source acquisition/verification records rather than LLM narrative, established that the outcome above really occurred.
7. All mandatory security checks and relevant regressions remained green, including evidence-negative and no-web controls.

For a **useful affirmative comparison**, aim for at least **three distinct real options** with grounded parking location, pricing basis, source URL, access/booking/contact path where actually available, and a clear explanation of how they compare. If fewer than three genuinely qualify, report the smaller truthful set; do not fail solely because the market has fewer options. A source listing parking without a confirmed vacant space is a **candidate**, never a confirmed vacancy.

A live search that reveals no usable spaces may still produce a legitimate, evidenced **`LIVE_SEARCH_COMPLETED_NO_CONFIRMED_SPACE`** outcome. This counts as completion of *search execution* only if the actual permitted search, acquisition, and negative/uncertain findings are documented; it must **not** be presented as “a parking spot found.” Use `LIVE_SEARCH_COMPLETED_ACTIONABLE_OPTIONS` for genuinely sourced contactable options; use `SPACE_AVAILABILITY_CONFIRMED` only if a trustworthy source proves availability at check time.

Do **not** redefine `MEASURED_FIXTURE` to mean live. Do **not** allow a `200` response, plausible LLM answer, a populated UI activity row, or fixture benchmark to substitute for a real acquired-source receipt.

## 3. Required engineering work, precisely targeted

### W1 — Integrate an authorized real broker with Chat UI

**Ownership:** `tools/doubletake_evolve/api/chat_sse/chat_route.py`, `tools/doubletake_evolve/universal_research/broker_activation.py`, `research_admission.py`, `research_dispatch.py`, `research_owner.py` and dedicated new integration module(s) only if separation is justified.

- Replace the current permanent `_chat_broker = None` and empty `candidates=()` production path with **runtime capability/authorization discovery** and a broker produced by the *existing* `activate_broker` contract.
- Obtain the actual runtime grant, domain/network policy, available transport, provider configuration and quotas. **Recognition does not grant authorization.** Respect explicit user `no web`, credential scope, privacy and per-source permission policy.
- Keep the ordinary Chat UI message as the caller; the broker, request, plan, candidates, authorized decision and run receipt all belong to the same run ID.
- If absent authorization or transport prevents acquisition, return a durable machine-readable refusal and user-visible explanation. Never force `authorized=True` to pass a test.
- A failed broker remains a blocker **for the live mission**; never call that condition a completed live search.

**Acceptance:** With a deliberately authorized live provider configured, normal UI chat calls the real broker and obtains one or more traceable external source receipts. Removing the broker or grant produces truthful `CONSENT_REQUIRED` / `BLOCKED`, zero external acquisitions and a failed live gate. Ordinary unrelated chat and `no web` cause zero provider calls.

### W2 — Add **independent source discovery** for natural-language tasks

**Ownership:** extend `tools/doubletake_evolve/universal_research/source_discovery.py` without breaking its pure user-supplied-link extraction. Use a separate provider adapter if necessary; register it through `adapter_registry.py` and `broker_activation.py`.

- Support authorized **search/discovery from a query**, not just a URL in user text. Choose an installed/available legitimate discovery mechanism (approved search API, public business directory/open-data API, or permitted first-party site index), preferring official parking facilities and established parking operators for the initial Ottawa acceptance case.
- Treat results as **candidates**, not acquired truth. Normalize canonical URL/provider identity and provenance, de-duplicate, rank under the plan budget, and pass through transport and security policy before downloading anything.
- Permit fallback across independent authorized providers and accessible representations (public site, official API, provider directory, published PDF). Respect robots, terms, access controls and quotas; do not circumvent CAPTCHA, paywalls or authentication.
- Expose provider-not-configured, no-results, request-denied, rate-limit and network errors as distinct recorded conditions. Do not invent or hardcode a source to make the benchmark green.
- Keep discovery **domain independent**: demonstrate the same source-discovery interface with at least one non-parking research question. Do not implement a parking-only keyword shortcut.

**Acceptance:** A URL-free Ottawa parking query discovers real candidates; a URL-free unrelated public research query uses the same discovery interface. Empty/no-authority cases fail the live gate honestly.

### W3 — Acquire, ground, and compare parking facts

**Ownership:** reuse `retrieval_broker.py`, `http_transport.py`, `extraction.py`, `observation.py`, `normalization.py`, `fusion.py`, `analysis.py`, `verification.py`, `report.py`; introduce only the minimal parking-specific *benchmark/evaluation schema*, **not a separate parking agent or knowledge-base answer shortcut**.

Required evidence fields for each real option, **when actually published**:

- real facility/operator and geographically verifiable place/address;
- source URL or official source identifier and evidence anchor;
- checked-at timestamp and, separately, any source-stated effective date;
- rate in stated currency, period (daily/hourly/monthly), restrictions and whether taxes/fees are included when known;
- monthly eligibility and relevant walking/driving constraint if measured from supported map/routing evidence;
- whether availability is explicitly confirmed, merely advertised, unknown, or unavailable;
- booking/contact/reservation URL **only if the source actually supplies it**.

Reject false comparability (e.g. daily rates presented as monthly without explicit assumptions), outdated prices labeled current, unsupported commute durations, duplicate listings counted as distinct, and inferred vacancies. Compute any derived costs with unit-checked formulas and disclose assumptions. Price ranking cannot be claimed if comparable rates are missing. Report a useful partial comparison, with missing fields visibly flagged, where full publication is impossible.

**Acceptance:** For a live source, deliberately mutate or remove one source price/citation in a negative test; the independent verifier fails or marks the claim unverified. Adding a plausible option only in LLM text does not alter the source-backed comparison or count.

### W4 — Make the **ordinary Chat UI deliver the result**

**Ownership:** `tools/doubletake_evolve/api/chat_sse/chat_route.py`, `tools/doubletake_evolve/api/chat_sse/event_stream.py`, existing UI research-run surface and report renderer; follow actual source ownership found at run time.

- Continue streaming server-owned real milestones and terminal status. Bind displayed findings to a real `ResearchReport` and evidence manifest, not to unconstrained model prose.
- Show actionable comparison in the existing chat answer, with clickable genuine sources, last-checked time, unknowns and truthful availability classification; continue to distinguish an honest partial response from successful acquisition.
- Ensure the browser actually consumes the real backend's run, **not a JSON fixture replay**. Keep current fixture browser tests as fast regression coverage, but add a separately named real-backend live acceptance path.
- No silent “research completed” when the source count is zero or citations do not resolve.

**Acceptance:** The same user message issued from the actual browser UI creates a research run, fetches the real external source via the backend, returns a source-grounded answer, and renders the comparison. A test captures the exact returned run ID, provider acquisition records, backend response and UI-visible claims.

### W5 — Durable **live** evidence and an independent verifier

**New artifacts (required):**

- `reports/universal_research/LIVE_PARKING_ACCEPTANCE.json` — canonical **observed** live-run evidence.
- `tools/doubletake_evolve/universal_research/live_parking_acceptance.py` — package generation, structural verification and independent re-derivation, following the source-bound evidence patterns of existing `domain_benchmarks.py` and `final_closure.py`.
- `tools/doubletake_evolve/universal_research/tests/test_live_parking_acceptance.py` — corruption, missing-provider, no-browser, no-source, stale/source-change, permissions and false-green negatives.
- Additional integration tests at the API/UI seam as needed.

The live record must include: schema version; run ID; test input/query and geographic anchor; actual origin mode `MEASURED_LIVE`; non-fixture provider identity; external network acquisition diagnostics; authorized scope; discovered candidates vs acquired sources; exact source URL/identifier; timestamps; content digests and anchor/claim relationships; real options/field coverage; user-visible report ID; UI/browser observation; meaningful limitations; verifier command results; and **source-bound digest** over committed evidence records. Do not persist credentials or private user material. Keep enough source evidence to verify claims independently without bulk redistribution of copyrighted pages.

A record is **invalid** when it is empty, hand-edited, produced from localhost/loopback fixtures, produced from test mocks, derives its provider success from a flag rather than I/O, lacks source receipts, includes a citation not present in the store, or is not bound to a retained reproducible code revision. A manually asserted `MEASURED_LIVE` string is never sufficient.

Live prices and inventory can change: certify the **historical fact that a live search ran and what was observed at its timestamp**, not perpetual current availability. Reruns must refresh the result when the user asks for current information.

**Acceptance:** the independent verifier re-derives the recorded outcome and fails when a source receipt, acquisition evidence, source-to-claim link, or UI delivery evidence is deleted or tampered with. Both positive and deliberately adversarial negative proofs must exist.

### W6 — Enforce this gate in **all mission closure decisions**

**Ownership:** `tools/doubletake_evolve/universal_research/criterion_table.py`, `final_closure.py`, `evidence_manifest_package.py`, `reports/universal_research/CRITERION_TABLE.json`, `EVIDENCE_MANIFEST.json`, `FINAL_CLOSURE.json` and genuine status/manager integrations discovered from code.

- Preserve current A01–A16 historical semantics and green evidence; add dedicated mandatory rows **A17–A20** (or another versioned, non-waivable acceptance extension that all consumers of closure actually validate):
  - `A17`: real external source discovery works **without** a user-provided URL;
  - `A18`: an authorized non-fixture provider actually returns acquired external content via the normal Chat UI request path;
  - `A19`: source-backed parking comparison/negative-result assessment is **actually shown to the user in the ordinary Chat UI**, with availability truthfulness and no invented data;
  - `A20`: independent live acceptance verification, source-bound evidence integrity, live negatives and regression proof are green.
- The overall mission **must not become `COMPLETE`, `CLOSED`, `DONE`, `SUCCESS`, `FINAL`, or equivalent** merely because A01–A16 are PASS, the fixture suite is green, or `...ENGINEERING_COMPLETE_LIVE_UNPROVEN` was generated.
- Define the final state machine:
  - `ENGINEERING_READY_LIVE_PENDING` — engineering/fixture gates green but no proven live outcome. **Not done.**
  - `BLOCKED_REAL_WORLD_OUTCOME` — live work attempted but access, authorization, discovery, acquisition, evidence or UI result cannot pass. **Not done**; record exact issue.
  - `LIVE_SEARCH_VERIFIED` — verified live acquisition, truthful relevant answer, and all mandatory gates pass. This is the minimum closure state for this amendment.
  - `LIVE_SEARCH_COMPLETED_NO_CONFIRMED_SPACE` — a valid subtype of verified search, **not** proof a parking space exists.
- Preserve `UNIVERSAL_RESEARCH_ENGINE_COMPLETE_LIVE_VERIFIED` only when a real provider and this **full normal-UI end-to-end live task** are independently proven. Do not reinterpret fixture benchmarks as live.
- Integrate this result into whichever actual manager/mission-status interface currently decides completion. Locate the real owners before editing; do not invent a module path. If the newer mission manager exists, it must see **blocking acceptance criteria** and continue assigning legitimate remedial work. A reporting layer that still announces completion while the gate fails is itself a failed acceptance test.
- Maintain acyclic evidence generation (the live record cannot self-certify, and the closure artifact cannot generate a self-validating `PASS`). Any closure record and its verifier must name exactly which retained revision and evidence produced the outcome.

**Acceptance:** construct test state “A01–A16 PASS, A17–A20 absent or blocked.” Every closure entrypoint must report **not complete**. Then introduce a real, independently verified live result; only now may the mission become complete, conditional on regressions/security remaining green.

### W7 — Operational resiliency and legitimate persistence

- Use bounded per-run time, requests, bytes, concurrency and provider budgets. Do **not** run uncontrolled infinite polling or repeated blind downloads to manufacture a “guarantee.”
- Persist the remaining blocker/owner/next permissible attempt and permit idempotent continuation; do not duplicate successful acquisitions on reconnect or corrupt evidence when several agents share `main`.
- If a public provider is unavailable, make a bounded authorized fallback attempt. If the environment lacks network permission, account authorization, a required API grant, or source rights, **stop and name the missing permission** rather than bypassing it.
- If mission manager functionality exists, register this as a required outcome and schedule resumption only when there is an actionable state change, after an operator-specified retry window, or when access is granted. **A manager is not permission to bypass access controls.**
- Do not download large models or install proprietary model weights; comply with existing DoubleTake open-code and provider policies. Do not execute mutations from retrieved pages or prompt-injection text.
- Keep temporary downloads isolated, scoped, and cleaned only after necessary audit metadata/evidence has been retained; never indiscriminately delete unrelated system `/tmp` contents.

## 4. Required acceptance matrix

Every row must have a runnable verifier and durable measured result. `PASS` means a genuine observed outcome, not merely presence of code.

| ID | Scenario | Required result |
|---|---|---|
| L01 | Ordinary URL-free Ottawa parking chat request; authorized provider and internet configured | Independent discovery returns at least one real candidate; governed broker performs actual external acquisition |
| L02 | Same run, backend through real Chat UI | At least one retrieved parking-related fact reaches a claim-linked, source-cited user-visible answer; useful comparison if suitable options exist |
| L03 | User did not supply URLs | Discovery still works; no fake URL insertion; normal research intent route is used |
| L04 | Production broker deliberately removed | No claim of live retrieval; live gate fails with exact broker-config blocker |
| L05 | `Do not search the web` | Zero network/discovery provider calls and no live success claim |
| L06 | User intent unrelated to research | No research dispatch or provider calls |
| L07 | Replace citation/price/URL after acquisition | Evidence verifier rejects or downgrades affected claim |
| L08 | Provider returns 403/429, robots/access prohibition, unsafe redirect, or auth barrier | Respect refusal, bounded authorized fallback; no bypass, fake PASS, or retry storm |
| L09 | Provider has parking options but no inventory information | Availability shown as unknown, **not** available |
| L10 | Provider legitimately yields no suitable space or fewer than three options | Honest evidenced limited/negative finding; no invented candidate or assumed vacancy |
| L11 | Same discovery/broker pipeline invoked for an unrelated domain | Works without parking-specific hardcoding |
| L12 | Only A01–A16 and fixtures are green, live proof absent | All closure/reporting surfaces remain NOT COMPLETE |
| L13 | True acquired source, but UI only emits `CONSENT_REQUIRED` / activity metadata | Live end-to-end acceptance FAIL |
| L14 | Repeated browser reconnect / duplicate request | Idempotent run and no accidental double acquisitions or double claims |
| L15 | Actual verified live run, tamper-negative tests green, regressions preserved | Independent gate green; mission closure can become `LIVE_SEARCH_VERIFIED` |

## 5. Implementation sequence — do not skip from code to closure

1. **Inspect and preserve:** Read original local mission if accessible, `git status`, the current `main` HEAD, all specified modules, present evidence/verifiers, and any newer manager. Identify changes already implemented by concurrent agents.
2. **Fix the path:** Wire real configured broker/authorization + independent discovery into `chat_sse/chat_route.py`. Prove the UI/backend/API acquisition chain. Avoid refactoring unrelated subsystems.
3. **Prove live acquisition:** Run a genuine bounded Ottawa parking search against authorized external sources. If it fails, record the actual refusal, repair the engineering gap within scope and authorized capabilities, and retry lawfully.
4. **Prove useful response:** Extract/cite/check fields, compare true options or produce a sourced negative conclusion, and render through the ordinary Chat UI.
5. **Build independent evidence:** Write and test live acceptance package with real source receipts; add evidence-corruption negatives.
6. **Close the loophole:** Update criterion/closure/manifest derivation and mission-manager/CLI/UI status consumers so green fixtures cannot close the mission.
7. **Run regressions:** Re-run the existing Universal Research suite, browser tests, relevant chat evolution/security suites and every mandatory canonical verifier. Record actual command, exit status, counts and revision. No hand-written claims of green.
8. **Commit safely:** Stage only owned files; coordinate on shared `main`; never reset, force-push, delete concurrent changes, or use synthetic evidence to unblock a gate. Regenerate derived artifacts in dependency order, rebind manifests to committed blobs, verify at the retained final commit.
9. **Publish the final verdict:** Enumerate each old and new acceptance criterion, the real-world evidence URLs/anchors, which claims are current vs last-checked, security/regression results and any blocker. Only claim DONE if the live gate independently passes.

## 6. Final response format from the implementing agent

Produce a compact report in this exact structure:

```text
MISSION: DOUBLETAKE_UNIVERSAL_RESEARCH_REAL_WORLD_OUTCOME_MANDATORY_CLOSURE_v1
BASELINE_HEAD: <sha>
FINAL_HEAD: <sha>
ORIGINAL_MISSION_READ: YES | NO (reason)
ENGINEERING_CRITERIA: <passes>/<total>
LIVE_CRITERIA: <passes>/<total> (A17–A20)
LIVE_SEARCH_RUN_ID: <id or NOT_RUN>
REAL_DISCOVERY_PROVIDER: <actual provider or NONE>
REAL_ACQUISITION_COUNT: <integer>
REAL_ACQUISITION_SOURCES: <source ids/URLs, time, digest; no invented source>
PARKING_OPTIONS: <count> (availability-confirmed count separately)
USER_VISIBLE_CHAT_RESULT: VERIFIED | FAILED | BLOCKED
LIVE_EVIDENCE_VERIFIER: PASS | FAIL | NOT_RUN
SECURITY_AND_REGRESSIONS: <commands/exits/counts>
CLOSURE: LIVE_SEARCH_VERIFIED | ENGINEERING_READY_LIVE_PENDING | BLOCKED_REAL_WORLD_OUTCOME
BLOCKERS: <exact failure and whether code/permission/provider/market caused it>
NEXT_ACTION_OWNED_BY: <identified component/agent, or authorization request>
```

**Do not claim closure while a blocker remains.** An honestly blocked mission with a precise repair path is preferable to a completed engineering report that has never answered the user's real question.

## 7. Governing principle

> **A fixture proves an implementation can work. A source-bound, browser-delivered, real external acquisition proves it actually worked. Only the second can close this mission.**
