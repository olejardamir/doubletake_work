# uBlockResurrected YouTube Detection-Neutral Ad Suppression Engine — Architecture V16

Repository context: `Astrocytech/uBlockResurrected`  
Target platform: Chrome Manifest V3  
Document status: Architecture/design specification  
Version: V16, production-ready implementation baseline with reversible main-world wrappers, bounded readiness-handshake timing, secure readiness handshake, content-script update reset, origin-safe main-world injection, embed-aware DNR aggregation, stale-rule purge, update reconciliation, advisory user-rule diagnostics, Shadow DOM rollback, hook-race gating, main-world capability probing, third-party initiator conflict hardening, implementable header sanitization, performance-timeline mitigation, document-write/interstitial/Shorts policies, storage/memory/performance budgets, BFCache/AB/mobile/sandboxed-embed handling, terminology/risk-state consolidation, and Phase 0 implementation-caveat closure  

---

## 1. Review disposition

The first design review was largely correct. The V1 architecture had the right core philosophy, but several parts were still too high-level to be buildable. V2 accepted almost all substantive comments and made the following corrections:

| Review point | Disposition | V2 change |
| --- | --- | --- |
| Non-player ad data was not sanitized | Accepted | Added generalized YouTube data sanitizer for `ytInitialData`, browse/search/feed/Shorts/sidebar data, not only player responses. |
| Initial player hook timing was underspecified | Accepted | Added early hook protocol plus retroactive fallback and missed-hook health signal. |
| Anti-block prompt detection was undefined | Accepted | Added multi-signal prompt detector with DOM, accessibility, modal, player-health, and text-agnostic scoring. |
| Risk levels were undefined | Accepted | Added concrete PageContext and RiskLevel model. |
| SPA lifecycle was underspecified | Accepted | Added YouTube navigation lifecycle protocol. |
| Service worker classifier semantics were misleading | Accepted with clarification | Replaced “runtime per-request classifier” language with rule-plan classification and session/dynamic rule swapping. |
| `ytcfg` / global config was missing | Accepted | Added global config sanitizer. |
| Ad-beacon strategy was missing | Accepted with guardrails | Added beacon integrity policy: allow, local surrogate, or no-op completion; no forged monetization events. |
| Aggressive mode contradicted stealth goals | Accepted | Reframed aggressive mode as “efficacy-biased mode” and made it non-default, clearly less detection-neutral. |
| Server-side stitched ads were missing | Accepted | Added explicit non-goal for live/DVR server-side ad insertion and no proxy playlist rewriting in extension. |
| Surrogate schema drift was missing | Accepted | Added surrogate schema validation, shadow mode, and fail-open behavior. |
| Backoff did not isolate culprit | Accepted | Added staged rollback and local module-isolation protocol. |
| Performance budget was missing | Accepted | Added concrete sanitizer and DOM observer budgets. |
| Embedded YouTube was unconstrained | Accepted | Added frame-context model for top-level, embed, nested, and YouTube Music contexts. |
| Trusted Types / CSP discipline missing | Accepted | Added CSP-aware coding rules. |
| Safe mode until proven was missing | Accepted | Added shadow mode and first-run safe activation. |
| Telemetry lacked decision-path detail | Accepted | Added privacy-preserving key-path hashing. |
| Regression gates were aspirational | Accepted | Added concrete lint/audit mechanisms. |
| Skip button/countdown not handled | Accepted | Added transient ad UI cleanup. |
| Generic stealth integration was missing | Accepted | Added precedence and conflict model between generic stealth and YouTube-specific rules. |

V3 therefore changed the architecture from a good concept into a buildable staged system.

### 1.1 V3 second-review disposition

The second design review is also accepted. V3 makes the remaining risky assumptions explicit and turns them into implementation requirements.

| Review point | Disposition | V3 change |
| --- | --- | --- |
| Early `Object.defineProperty` hooks are themselves detectable | Accepted | Added a hook-detectability section, a descriptor-risk model, safer ordering, fallback-first behavior, and a rule that accessor hooks are a monitored trade-off rather than an invisible mechanism. |
| `sanitizerShapeConfidence` was undefined | Accepted | Added a concrete scoring model, activation thresholds, consecutive-observation requirements, fixture/shadow evidence inputs, and decay on drift. |
| MutationObserver budget may be unrealistic for transient UI cleanup | Accepted | Added player-subtree scoping, render-window gating, batching, hard throttle, and revised DOM observer budgets. |
| Beacon `LOCAL_COMPLETE` was under-specified | Accepted | Reclassified it as experimental, allowlisted, separately feature-gated, schema-validated, and fail-open. |
| Generic stealth exclusion lacked an enforcement mechanism | Accepted | Committed to DNR `excludedInitiatorDomains` for generic stealth rules affecting YouTube initiators, plus a build audit to verify no generic YouTube conflicts remain. |

### 1.2 V4 third-review disposition

The third design review is accepted. V3 addressed the major architecture gaps; V4 closes the remaining implementation-level ambiguities around page-visible wrappers, shadow-mode invasiveness, DNR precedence, full-navigation lifecycle, and response-header handling.

| Review point | Disposition | V4 change |
| --- | --- | --- |
| Fetch/XHR and `ytcfg` wrappers are detectable like property hooks | Accepted | Added a unified main-world interception risk model covering accessors, function wrappers, XHR/fetch guards, and config getter/setter wrappers. |
| Shadow mode may still require detectable interception | Accepted | Split shadow mode into passive DOM shadow, instrumented shadow, and offline fixture shadow; instrumented shadow is explicitly not risk-free. |
| `excludedInitiatorDomains` can miss third-party initiators | Accepted | Added a DNR limitation note, third-party initiator conflict fixtures, and a stronger conflict policy using priority, endpoint compatibility, or global generic-rule replacement. |
| YouTube rule priorities were unspecified | Accepted | Added explicit priority constants requiring YouTube critical allow/surrogate/block rules to outrank generic stealth rules. |
| Browser back/forward full navigation was not explicit | Accepted | Added full-document navigation lifecycle and reinitialization path distinct from SPA navigation. |
| Ad-related response headers were not covered | Accepted with caution | Added response-header policy: observe by default, strip/rewrite only for same-origin JSON responses with fixture evidence and fail-open behavior. |


### 1.3 V5 fourth-review disposition

The fourth design review is accepted. V4 had closed the core YouTube-specific architecture gaps, but still left two practical implementation risks: non-engine user/imported network rules could outrank YouTube critical allow rules, and shadow-mode selection was not mapped to concrete conditions. V5 makes both enforceable.

| Review point | Disposition | V5 change |
| --- | --- | --- |
| User-defined and imported network filters can override YouTube critical allow rules | Accepted | Added a network-rule authority model, priority caps for all non-YouTube-engine rules matching YouTube requests, user/imported-list interference detection, warning/manual-review behavior, and build/runtime audits. |
| Shadow mode selection logic was implicit | Accepted | Added a decision table mapping page type, risk level, shape confidence, update state, and prompt history to `PASSIVE_DOM_SHADOW`, `INSTRUMENTED_SHADOW`, or `OFFLINE_FIXTURE_SHADOW`. |

### 1.4 V6 fifth-review disposition

The fifth design review is accepted as a readiness review. It identifies no remaining substantive architecture gaps. V6 therefore does not add another suppression technique; it converts the validated V5 architecture into an implementation-ready baseline by making the recommended implementation order explicit.

| Review point | Disposition | V6 change |
| --- | --- | --- |
| No substantive design gaps remain | Accepted | Marked the architecture as implementation-ready, subject to the audits and registries being implemented first. |
| Audits and critical endpoint registry should precede feature modules | Accepted | Added Phase 0 as a mandatory pre-coding gate: critical endpoint registry, rule-authority audit, priority constants, shadow-mode tests, wrapper-risk audit, and CI checks must exist before suppression modules are added. |
| Safe-mode scaffolding and shadow-mode state machine should be built before active suppression | Accepted | Clarified implementation sequencing so lifecycle, risk gating, and shadow-mode selection exist before sanitizer, surrogate, or cosmetic modules become active. |

### 1.5 V6 specification status

V6 is the controlling architecture baseline for implementation planning. Future changes should be made as narrow change records against this baseline rather than by reopening the core design philosophy.

The first implementation work must focus on invariants and audits, not ad suppression. This prevents later modules from introducing rule-priority, wrapper-risk, user-filter, or shadow-mode regressions.

---

### 1.6 V8 implementation-safety review disposition

The V8 review is accepted. V7 was structurally complete, but four implementation-safety assumptions needed to be made explicit before coding starts. V8 closes these assumptions without changing the core design philosophy.

| Review point | Disposition | V8 change |
| --- | --- | --- |
| Main-world script execution can be blocked or altered by page CSP | Accepted | Added a main-world CSP execution probe, session fallback to DNR/isolated/passive-only mode, and an `UNKNOWN_YOUTUBE_CHANGE` triage path for CSP tightening. Header-relaxation via DNR is classified as high-risk, off by default, and fail-open. |
| Mutation observers may miss Shadow DOM-rendered player UI and prompts | Accepted | Added Shadow DOM-aware observer discovery for open shadow roots, closed-root fallback, shared throttling/budget rules, and prompt-detector integration. |
| Adaptive YouTube DNR rules need an explicit budget | Accepted | Added an internal rule-budget allocator that reserves critical allow slots first, keeps YouTube adaptive/session rules under a strict budget, removes shadow/low-confidence rules first under pressure, and enters `PANIC` on critical-rule install failure. |
| Early `ytInitialPlayerResponse` hook effectiveness depends on a race with YouTube inline scripts | Accepted | Added passive hook-race telemetry to measure whether early globals are already defined at startup, whether accessors could plausibly win, and whether early hooks should be enabled at all for a given page class. |

V8 therefore treats script execution, observer visibility, rule capacity, and hook timing as measurable runtime conditions rather than assumptions.

### 1.7 V9 final implementation-safety review disposition

The V9 review is accepted. V8 had closed the four previous implementation-safety gaps, but two small runtime-surprise risks remained: page-visible Performance Resource Timing traces and the missing shadow-mode decision row for tabs where main-world execution is unavailable. V9 closes both without changing the architecture's core model.

| Review point | Disposition | V9 change |
| --- | --- | --- |
| Blocked or redirected ad resources can be observed through `PerformanceResourceTiming` | Accepted with practical limits | Added the Performance Resource Timeline as a page-visible detection channel. The rule planner must avoid `BLOCK` for monitored resources, prefer allow or fixture-validated surrogates where the resource timeline is likely inspected, and treat extension-origin surrogate entries as a residual fingerprinting risk. |
| Shadow-mode selection did not account for `mainWorldAvailable == false` | Accepted | Added an explicit shadow-mode decision-table row forcing `PASSIVE_DOM_SHADOW` when main-world execution is unavailable for the tab/session. |

V9 made the architecture implementation-ready for Phase 0. V10 adds the last surrogate/runtime guardrails needed before coding begins: SRI-safe script surrogate planning, CORS-aware surrogate validation, multi-tab global DNR rule-plan aggregation, and a concrete monitored-resource heuristic for Performance Timeline risk. Any further changes should be narrow implementation change records, not redesigns.

---

### 1.8 V10 surrogate and global-rule review disposition

The V10 review is accepted. V9 had closed the Performance Timeline and degraded shadow-mode gaps, but four implementation details still needed explicit treatment before coding: SRI on redirected script resources, CORS behavior for extension-origin surrogates, global DNR state across multiple YouTube tabs, and a concrete rule for deciding which resources should be treated as Performance-Timeline-monitored.

| Review point | Disposition | V10 change |
| --- | --- | --- |
| Script surrogates can fail Subresource Integrity checks | Accepted | Added an SRI-safe surrogate policy: never redirect script/style resources that carry integrity metadata unless the plan has fixture evidence that no page-visible failure occurs; default behavior is ALLOW plus sanitizer/backoff. |
| JSON/API surrogates can fail CORS when served from `chrome-extension://` | Accepted with MV3 constraint | Added a CORS-aware surrogate policy and fixture gate. JSON/API surrogates must be tested under the original request mode/credentials/origin behavior and fail open to ALLOW on any CORS mismatch. |
| DNR session/dynamic rules are global, while PageContext is per-tab | Accepted | Added a global YouTube rule-plan aggregator. DNR rules are controlled by the most conservative aggregate state across YouTube tabs; per-tab control remains in main-world/isolated modules. |
| “Likely monitored” Performance Timeline resources were undefined | Accepted | Added a monitored-resource heuristic: registry-listed ad/beacon/bootstrap/critical resources are assumed monitored by default unless shadow telemetry and fixtures justify a lower risk classification. |

V10 is therefore the controlling implementation baseline for Phase 0. The first implementation work must build the critical endpoint registry, surrogate eligibility checks, CORS/SRI fixture gates, global rule-plan aggregator, and rule-priority audits before active suppression modules are enabled.

### 1.9 V11 service-worker persistence review disposition

The V11 review is accepted. V10 had closed the remaining surrogate, global DNR, and monitored-resource gaps, but the service worker lifecycle still needed explicit treatment. Because Chrome MV3 service workers can be suspended and restarted, any in-memory global rule-plan state, tab-risk state, panic/backoff state, or disabled-module decision must be reconstructable. V11 adds that persistence and restoration protocol.

| Review point | Disposition | V11 change |
| --- | --- | --- |
| Service-worker memory can be lost while DNR rules persist | Accepted | Added a session persistence layer using `chrome.storage.session` where available, with a local-storage fallback only for explicitly approved session-safe state. |
| Global rule-plan aggregation can restart from an unsafe clean slate | Accepted | Added persisted aggregate state: suspect modules, disabled endpoints, global rule-plan mode, installed YouTube rule IDs, last aggregate risk, and session panic/backoff flags. |
| Existing YouTube tabs may already be open when the service worker restarts | Accepted | Added a startup restoration protocol: query open tabs, reconstruct URL-based PageContext, recompute the global rule plan, and reconnect to content scripts. |
| The service worker needs a way to learn new tabs and tab-state changes | Accepted | Added event-driven tab tracking using `tabs.onUpdated`, `tabs.onRemoved`, `webNavigation` where available, content-script connections, and heartbeat messages. |

V11 is therefore the production-ready implementation baseline. Phase 0 must implement persistence, restoration, and tab tracking before active YouTube suppression modules can be enabled.

---

### 1.10 V12 production-hardening review disposition

The V12 review is accepted. V11 was production-ready in its main structure, but eight implementation-hardening gaps remained around extension-origin exposure, embedded-player aggregation, stale optional DNR rules, probe delivery, update reconciliation, advisory user-rule diagnostics, Shadow DOM cosmetic detectability, and hook-race gating. V12 closes these gaps as binding implementation requirements.

| Review point | Disposition | V12 change |
| --- | --- | --- |
| Main-world injection can expose `chrome-extension://` script origins | Accepted with implementation constraint | Added an origin-safe injection policy: the main-world bootstrap must not appear as a DOM script element with an extension URL; the script must not be listed as a web-accessible resource unless unavoidable and justified by an audit. |
| Global DNR aggregation missed YouTube embeds on non-YouTube pages | Accepted | Added hidden-frame registration and embed-aware aggregation. Optional top-level YouTube DNR rules are removed when no top-level YouTube tab exists; embeds force a conservative EMBED policy. |
| Startup restoration did not explicitly purge stale optional rules with no YouTube tabs | Accepted | Added mandatory no-top-level purge on startup/restoration: remove all non-critical YouTube DNR rules, persist only critical allows, and reset the global plan to `SAFE_CONSERVATIVE`. |
| Main-world CSP/readiness probe delivery was under-specified | Accepted | Added exact probe communication requirements: `CustomEvent` on `window` plus strict `postMessage` fallback, nonce correlation, bounded timeout, and fail-safe degradation if both channels fail. |
| Extension update can leave stale YouTube rule IDs/priorities active | Accepted | Added `onInstalled`/registry-version reconciliation: clear or reconcile all YouTube session/dynamic rules and re-enter `SAFE_CONSERVATIVE` after version mismatch. |
| `USER_RULE_INTERFERENCE` diagnostic cannot rely on real-time DNR match feedback | Accepted | Clarified that user-rule interference is advisory and based on asynchronous static DNR overlap simulation. User/imported rules must not be disabled automatically unless the user is explicitly notified or opts in. |
| Shadow DOM cosmetic cleanup is also detectable by YouTube observers | Accepted | Added a separate `SHADOW_DOM_COSMETIC_CLEANUP` risk class and rollback rule. Prompt detection disables both light-DOM and Shadow DOM cosmetic observers immediately. |
| Hook-race telemetry was not a hard prerequisite for early accessors | Accepted | Added a hard gate: early accessor hooks require `hookRaceEvidence.earlyAccessorWinsLikely === true`; shape confidence and instrumented shadow are not sufficient by themselves. |

V12 was the controlling implementation baseline. V13 supersedes V12 by adding a spoof-resistant readiness probe and mandatory content-script reset after extension/registry updates. If any V13 rule conflicts with earlier prose, the V13 rule supersedes the earlier statement.

---
V12 was the controlling implementation baseline. V13 supersedes V12 by adding a spoof-resistant readiness probe and mandatory content-script reset after extension/registry updates. If any V13 rule conflicts with earlier prose, the V13 rule supersedes the earlier statement.

---

### 1.11 V13 readiness-handshake and update-reset review disposition

The V13 review is accepted. V12 had closed the production-hardening gaps around origin-safe injection, embed-aware aggregation, update reconciliation, user-rule diagnostics, Shadow DOM rollback, and hook-race gating. Two implementation-critical issues remained: the main-world readiness probe could be spoofed if its nonce exchange was not specified, and extension/registry updates could leave already-open content scripts with stale per-tab sanitizer confidence and active wrappers. V13 closes both as binding requirements.

| Review point | Disposition | V13 change |
| --- | --- | --- |
| `uBRYouTubeMainReady` could be spoofed without a specified nonce exchange | Accepted | Added a secure readiness handshake: isolated world generates a nonce, exposes it only through a short-lived main-world probe slot or strict `postMessage` bootstrap channel, main world returns `sha256(nonce + bootstrapSalt + bootstrapVersion)`, and isolated world accepts readiness only after matching the expected hash and version. |
| Extension/registry updates can leave open content scripts with stale shape confidence and active wrappers | Accepted | Added `ENGINE_UPDATE_RESET`: service worker broadcasts reset to all YouTube content scripts on version/registry mismatch; content scripts must disable active wrappers/accessors, clear sanitizer/cosmetic state, cap shape confidence to fixture baseline, re-enter passive shadow, and acknowledge reset before active modules can resume. |

V13 is the controlling implementation baseline. If any V13 rule conflicts with earlier prose, the V13 rule supersedes the earlier statement.

---

### 1.12 V14 wrapper-rollback review disposition

The V14 review is accepted. V13 specified that content scripts must disable active accessors, fetch/XHR guards, config wrappers, and other main-world modules during rollback or update reset, but it did not define how that can happen inside an already-loaded page. Because an isolated-world script cannot directly restore main-world descriptors or wrapped functions, rollback must be implemented by the main-world bootstrap itself. V14 adds a mandatory reversible-wrapper registry and a bounded readiness-handshake timing policy.

| Review point | Disposition | V14 change |
| --- | --- | --- |
| Main-world wrappers/accessors cannot be disabled from the isolated world unless the bootstrap exposes a restore path | Accepted | Added a reversible main-world wrapper lifecycle: every accessor/function/config wrapper must preserve its original descriptor/function reference, register a restore routine, accept authenticated disable commands, acknowledge restoration, and remain restorable until document unload. |
| Readiness handshake uses asynchronous `crypto.subtle` hashing which may resolve too late for `document_start` startup decisions | Accepted with implementation constraint | Added a startup timing policy: readiness hashing must not block the safe startup path; prefer synchronous correlation or browser-mediated argument passing for the first readiness proof, allow async hashing only within a bounded grace window, and keep high-risk modules disabled until proof arrives. |

V14 is the controlling implementation baseline. If any V14 rule conflicts with earlier prose, the V14 rule supersedes the earlier statement.


### 1.13 V15 implementation-safety review disposition

The V15 review is accepted as an implementation-safety review. V14 was architecturally mature, but several implementation realities remained insufficiently explicit: main-world execution viability, third-party initiator conflicts, response-header sanitization mechanics, Performance Resource Timing visibility, long-lived YouTube memory/performance risk, BFCache, A/B variants, mobile and sandboxed contexts, and terminology consistency. V15 makes these items binding requirements before Phase 0 can be considered complete.

| Review point | Disposition | V15 change |
| --- | --- | --- |
| Main-world execution viability was assumed too strongly | Accepted with precision | Added `MainWorldCapabilityProbe`, DOM-visible origin detection, and a mandatory degrade-to-isolated-only path if main-world execution is unavailable or visibly exposes the extension origin. |
| `excludedInitiatorDomains` limitations were understated | Accepted | Added third-party initiator conflict policy, fixture suite, and a rule that `excludedInitiatorDomains` is defense-in-depth, not primary conflict resolution. |
| Response-header sanitization was not mechanically specified | Accepted | Added implementable fetch/XHR header sanitization constraints using fresh `Response` construction and XHR header getter wrappers, with fail-open behavior. |
| Performance Resource Timing mitigation was incomplete | Accepted with conservative bias | Added monitored-endpoint default-ALLOW policy, no `chrome-extension://` surrogate redirects for monitored endpoints unless fixture-proven safe, and timing/size plausibility constraints. |
| `document.write` ad injection was missing | Accepted as high-risk | Added a document-write mitigation policy that defaults to passive/DOM cleanup and classifies main-world `document.write` wrapping as high risk. |
| Navigational/interstitial ads were missing | Accepted | Added an interstitial ad handling policy and a separate rollback risk class. |
| Shorts support was underspecified | Accepted | Added Shorts data sources, constraints, confidence thresholds, and fixture-gated activation. |
| “Shallow path checks” were underspecified | Accepted | Added sanitizer traversal-depth policy and explicit no full-object-graph traversal rule. |
| Consecutive clean observations were underdefined | Accepted | Added a concrete clean-observation definition by page type. |
| Session storage quota was missing | Accepted | Added storage quota, pruning, and storage-unavailable fallback rules. |
| Surrogate URL exposure looked contradictory | Accepted with clarification | Added a surrogate URL exposure policy distinguishing main-world bootstrap injection from web-accessible surrogate resources. |
| `LOCAL_COMPLETE` timing was ambiguous | Accepted | Added readiness-gated timing constraints and shadow-fetch guard behavior. |
| MutationObserver budget was insufficient for large batches | Accepted | Added per-batch node budget, overflow handling, and closed-shadow-root fallback. |
| Health monitor tick interval was underspecified | Accepted | Added page-type and dynamic health tick scheduling. |
| Optional DNR rule install failures were underspecified | Accepted | Added optional-rule failure handling distinct from critical-rule PANIC behavior. |
| BFCache handling was incomplete | Accepted | Added BFCache restoration protocol and probe requirements. |
| YouTube A/B variation handling was missing | Accepted | Added variation detection, per-variation confidence, and fixture promotion rules. |
| `youtube-nocookie.com`, `m.youtube.com`, and sandboxed embeds needed explicit policies | Accepted | Added domain-specific handling, mobile phased support, and sandboxed-embed fallback. |
| Performance, memory, and cross-browser tests were missing | Accepted | Added required performance regression, leak, and compatibility tests. |
| Nonce hash security was overstated | Accepted | Added a clarification that the nonce handshake is correlation/versioning, not cryptographic security against the page. |
| `eval`/`new Function` detection was not addressed | Accepted | Added static-code-only and suspected eval-detection fallback policy. |
| Prompt/risk/health terminology was inconsistent | Accepted | Added terminology consolidation and risk-vs-health definitions. |

V15 is the controlling implementation baseline. If any V15 rule conflicts with earlier prose, the V15 rule supersedes the earlier statement.

---


### 1.14 V16 Phase 0 implementation-caveat review disposition

The V16 review accepted the V15 readiness assessment and found no new architecture-level blockers. It identified six minor implementation caveats that should be made explicit so Phase 0 implementers do not treat them as informal advice.

| Review point | Disposition | V16 change |
| --- | --- | --- |
| `MainWorldCapabilityProbe` may itself be observable on some browser versions | Accepted | Added a browser-version capability matrix, persistent-script-tag test, and a rule that persistent DOM-visible extension-origin artifacts force `MAIN_WORLD_CAPABLE_DOM_VISIBLE` or isolated-only fallback. |
| `document.write` wrapper is off by default and may miss very early writes | Accepted | Added an early passive observer bootstrap requirement and explicit treatment of pre-observer writes as `EARLY_WRITE_MISSED`, with safe fallback rather than default wrapper activation. |
| Third-party initiator conflict fixtures need concrete test design | Accepted | Added fixture-harness requirements using controlled third-party origins/local servers and DNR rule-match simulation so endpoint-ownership tests are reproducible in CI. |
| A/B variation promotion may require manual fixture curation | Accepted | Added manual-review status for one-off or unstable variations and made fixture promotion non-automatic until a reviewer validates the structural fingerprint. |
| Performance budgets may be tight on low-end devices | Accepted | Added low-end-device calibration, percentile-based budgets, and safe threshold adjustment rules that preserve fail-open behavior. |
| Repeated optional rule failures need a visible diagnostic path | Accepted | Added local diagnostic surfacing for session-banned optional rules and repeated cross-session optional-rule failures. |

V16 therefore remains a production-ready baseline, with Phase 0 now explicitly responsible for validating the remaining implementation caveats before any active YouTube suppression modules are enabled.

## 2. Core purpose

The engine exists to reduce YouTube ad exposure while avoiding the failure pattern that makes ordinary ad blockers easy to detect.

The governing rule is:

```text
Detection neutrality first.
Ad suppression second.
Automatic backoff third.
```

A normal blocker often creates contradictions:

```text
YouTube expects ad subsystem state
→ blocker hard-blocks ad subsystem pieces
→ YouTube observes missing requests, missing globals, broken DOM, or impossible player state
→ anti-block prompt / degraded experience
```

The V5 engine instead aims for contract-preserving nullification:

```text
YouTube expects normal subsystem shape
→ extension preserves harmless compatible shape
→ ad opportunity resolves empty or unavailable
→ player/feed continues without visible ad payload
→ no obvious broken-ad-blocker signature
```

The practical target is not to make the extension impossible to discover by the browser. The practical target is to stop producing page-visible signals associated with broken ad blocking.

---

## 3. Current repository integration points

The current uBlockResurrected repository already has several pieces needed for this design:

1. It is a Chrome MV3 extension.
2. It uses `declarativeNetRequest` rule resources.
3. It already has a generic stealth-surrogate system.
4. Stealth mode is enabled by default in user settings.
5. The current generic main-world ad-block script is intentionally excluded from YouTube.
6. Existing service-worker logic already protects YouTube masthead/search UI from stale broad cosmetic user filters.

Therefore, YouTube should not be handled by simply enabling the existing broad `ad-block-main.js` on YouTube. It needs a dedicated engine with its own rules, sanitizer, health monitor, and rollback behavior.

---

## 4. Non-goals and boundaries

The engine must not:

- Hide the extension from Chrome itself.
- Tamper with Google or YouTube account identity, login, payment, subscription, or entitlement state.
- Forge monetization events.
- Send fake ad impressions to YouTube.
- Use remote executable code.
- Use `eval`, remote script tags, or remote command interpreters.
- Use broad YouTube CSS selectors such as `.style-scope`, `[class*="ad"]`, `[id*="ad"]`, or masthead selectors.
- Rewrite media playlists through a proxy.
- Attempt to defeat server-side stitched live/DVR ads in the first implementation.
- Break comments, descriptions, playlists, search, navigation, subscriptions, or video playback to remove an ad.

Known limitation:

```text
Server-side stitched ads in live streams and DVR-like content may be indistinguishable from normal media segments at the extension layer. V3 treats proxy-level playlist rewriting as out of scope.
```

---

## 5. Threat model

YouTube can infer ad-blocking through multiple channels.

### 5.1 Network failure signals

Examples:

- Ad-related endpoints fail in a known blocker pattern.
- Ad scripts are missing instead of returning a compatible no-op shape.
- Measurement pixels or beacons disappear in an unnatural cadence.
- Player state expects an ad break but related requests fail.
- A blocked request creates a synchronous error visible to page scripts.

### 5.2 JavaScript contract signals

Examples:

- Expected ad globals are missing.
- Expected methods exist but throw.
- Expected promises never resolve.
- Expected callback queues are missing.
- Native functions are patched detectably.
- YouTube player config says ads are enabled, but ad objects vanish inconsistently.

### 5.3 Data model signals

Examples:

- `ytInitialPlayerResponse` still contains ad breaks, but playback state skips them abruptly.
- `ytInitialData` still contains promoted renderers, but DOM ad slots disappear later.
- `ytcfg.data_` or `window.yt.config_` still contains ad flags inconsistent with later behavior.
- Browse/search/Shorts data retains promoted items that cosmetic cleanup must remove after rendering.

### 5.4 DOM/layout signals

Examples:

- Large YouTube Polymer components are removed.
- Masthead/search/guide nodes disappear.
- Comments/description layout breaks.
- Ad containers flicker repeatedly.
- Mutation observers create an obvious repeated remove/reinsert pattern.

### 5.5 Timing signals

Examples:

- Sanitization happens after YouTube already consumed unsanitized state.
- Ad UI appears for one frame, then disappears repeatedly.
- Player transitions through impossible ad states.
- Content script hooks are installed too late and silently miss the first response.

### 5.6 Extension resource signals

Examples:

- Too many predictable web-accessible resources exist.
- YouTube can probe extension resource URLs.
- Surrogate resources have static signatures that are easy to fingerprint.

### 5.7 Performance Resource Timeline signals

The browser Performance Resource Timeline is a page-visible channel. YouTube page scripts can inspect `performance.getEntriesByType("resource")` or observe resource entries with `PerformanceObserver`. A blocked request, a zero-byte/timing-anomalous request, or a redirect to a `chrome-extension://` surrogate can itself become evidence of an extension-mediated intervention.

Examples:

- an expected ad, beacon, or measurement resource never appears in the resource timeline;
- an expected network resource appears with implausible timing or transfer metadata;
- a resource URL exposes a stable `chrome-extension://<extension-id>/...` surrogate path;
- a resource that normally has network latency resolves too quickly and repeatedly;
- a request expected to be same-origin or Google-origin resolves from an extension origin.

Policy:

```text
If YouTube is likely to monitor a resource through the Performance API:
  avoid DNR BLOCK unless there is evidence that absence is not observed
  prefer ALLOW when suppression would create a stronger timeline signal than the ad itself
  use a surrogate only when a fixture proves that the resulting resource entry is acceptable
  treat extension-origin surrogate entries as a residual fingerprinting risk
  record PERFORMANCE_TIMELINE_RISK when a monitored resource is blocked or redirected
```

Monitored-resource heuristic:

```text
Assume MONITORED_BY_DEFAULT for:
  endpoints in the critical endpoint registry
  player/bootstrap scripts and JSON endpoints
  ad-decision endpoints
  beacon/measurement endpoints that are invoked from player, watch, Shorts, or feed code
  resources whose success/failure can trigger onload/onerror callbacks
  resources with known PerformanceObserver visibility in shadow telemetry

Downgrade to MONITORED_UNLIKELY only when:
  passive/instrumented shadow telemetry shows no page PerformanceObserver or getEntriesByType use touching that URL class
  fixture playback remains healthy when the entry is absent or replaced
  no prompt, player error, or impossible ad state is observed across the required confidence window

Unknown resources remain MONITORED_BY_DEFAULT.
```

The monitored-resource classification must be stored in the critical endpoint registry as `performanceTimingRisk`, not inferred ad hoc inside individual modules.

Surrogates reduce missing-resource signals but do not make timeline evidence disappear. Therefore, a surrogate is not automatically stealthier than allowing the request. The rule planner must decide per endpoint whether `ALLOW`, `SURROGATE`, `LOCAL_COMPLETE`, or `BLOCK` has the lowest page-visible risk.

---

## 6. Architecture overview

The V4 engine is composed of eight cooperating layers.

```text
Layer 0: Feature gate and frame-context classifier
Layer 1: Early main-world hook, interception-risk ledger, and retroactive fallback
Layer 2: Rule-plan classifier and DNR/session-rule manager
Layer 3: Packaged surrogate manager
Layer 4: Generalized YouTube data sanitizer
Layer 5: Global config sanitizer (`ytcfg`, `yt.config_`)
Layer 5b: Response-header policy for same-origin YouTube JSON/API responses
Layer 6: Narrow cosmetic and transient UI cleanup
Layer 7: Health monitor, anti-block detector, and rollback engine
Layer 8: Local telemetry and regression evidence
```

The engine must be modular. Every risky module can be disabled independently.

---

## 7. File layout

Proposed source layout:

```text
src/js/youtube/
  youtube-types.ts
  youtube-config.ts
  youtube-page-context.ts
  youtube-risk.ts
  youtube-navigation.ts
  youtube-dnr-plan.ts
  youtube-surrogates.ts
  youtube-main-hook.ts
  youtube-hook-risk.ts
  youtube-interception-risk.ts
  youtube-shape-confidence.ts
  youtube-fetch-guard.ts
  youtube-response-header-policy.ts
  youtube-player-sanitizer.ts
  youtube-data-sanitizer.ts
  youtube-config-sanitizer.ts
  youtube-dom-cleanup.ts
  youtube-prompt-detector.ts
  youtube-health.ts
  youtube-beacon-policy.ts
  youtube-backoff.ts
  youtube-telemetry.ts
  youtube-lints.ts

platform/chromium/js/
  youtube-smart-main.js
  youtube-smart-isolated.js

platform/chromium/dnr/
  youtube-static.rules.json

platform/chromium/web_accessible_resources/youtube/
  pixel-transparent.png
  empty-json-object.json
  empty-json-array.json
  ads-interface-surrogate.js
  gpt-compatible-surrogate.js
  beacon-complete-surrogate.js
```

Generated files under `platform/chromium/js/` should not be edited manually.

---

## 8. Feature gates and settings

Recommended settings:

```text
youtubeSmartBlockingEnabled: true
youtubeDetectionNeutralMode: true
youtubeShadowMode: auto
youtubeSurrogatesEnabled: true
youtubeDataSanitizerEnabled: true
youtubeConfigSanitizerEnabled: true
youtubeCosmeticCleanupEnabled: true
youtubePromptDetectorEnabled: true
youtubeAutoBackoffEnabled: true
youtubeBeaconLocalCompleteExperimental: false
youtubeResponseHeaderSanitizerEnabled: false
youtubeInstrumentedShadowModeEnabled: auto
youtubeAggressiveModeEnabled: false
```

Default first-run behavior:

```text
New install or YouTube structure unknown
→ shadow mode for risky sanitizer paths
→ safe DNR and low-risk surrogates only
→ observe current YouTube shapes
→ activate sanitizer only after shape validation passes locally
```

---

## 9. Frame-context model

Because the manifest may use `all_frames: true`, the engine must classify the frame before acting.

```text
FrameContext {
  isTopFrame
  isYouTubeTopFrame
  isYouTubeEmbed
  isNestedYouTubeFrame
  parentOriginKnown
  pageType
  allowedModules
}
```

Recommended behavior:

| Context | Allowed behavior |
| --- | --- |
| Top-level `www.youtube.com/watch` | Full safe/balanced engine. |
| Top-level YouTube home/search/feed | Data sanitizer + cosmetic cleanup; player sanitizer only if player exists. |
| YouTube Shorts | Shorts-specific data sanitizer and cautious cosmetic cleanup. |
| YouTube embed in third-party page | Minimal player sanitizer only; no broad feed/browse sanitizer. |
| `music.youtube.com` | Disabled by default until fixtures exist. |
| Unknown YouTube-like frame | Passive/shadow only. |

Embeds must not inherit full top-level YouTube assumptions.


### 9.1 Embed registration and DNR aggregation visibility

Embedded YouTube frames on non-YouTube top-level pages are first-class YouTube contexts for global DNR planning, but they must never receive the same policy as a full top-level watch page by accident.

Hidden-frame registration protocol:

```text
When a content script starts in a YouTube frame:
  compute FrameContext locally
  if isYouTubeEmbed or isNestedYouTubeFrame:
      send youtubeFrameRegister(tabId, frameId, url, parentOriginKnown, pageType, embedPolicy=MINIMAL_EMBED)
  heartbeat while frame remains active
  send youtubeFrameUnregister on unload/pagehide where possible

Service worker:
  store embed contexts separately from top-level YouTube contexts
  expire embed registrations if heartbeat missing
  include registered embeds in global rule-plan aggregation
```

Global rule implication:

```text
If registered embeds exist and no top-level YouTube tab exists:
  globalRulePlanMode = EMBED_CONSERVATIVE
  keep critical allow rules only where needed for player/bootstrap safety
  remove top-level-only surrogates, safe blocks, beacon rules, and shadow DNR rules

If top-level YouTube tabs exist and embeds also exist:
  compute the most conservative compatible global plan
  do not install any global DNR rule that is safe for watch pages but unsafe or untested for embeds
```

Rule eligibility must include a frame-context field:

```text
rule.appliesTo = topLevelWatch | topLevelBrowse | shorts | embed | nestedEmbed | allYouTube
```

A rule that lacks embed fixture evidence is treated as `topLevelOnly` and must not be active when the global DNR plan is constrained by registered embeds.

---

## 10. PageContext and RiskLevel

### 10.1 PageContext

```text
PageContext {
  url
  host
  path
  pageType
  frameContext
  hasPlayer
  hasFeed
  hasSearchResults
  hasShortsShell
  hasLiveStream
  hasDvrWindow
  hasAntiBlockPrompt
  playerHealth
  sanitizerShapeConfidence
  riskLevel
}
```

### 10.2 Page types

```text
WATCH
HOME_FEED
SEARCH
SHORTS
EMBED
CHANNEL
PLAYLIST
MUSIC
LIVE
UNKNOWN
```

### 10.3 Risk levels

| Risk level | Meaning | Active modules |
| --- | --- | --- |
| LOW | Known page type, fixtures exist, health normal | Safe rules, surrogates, sanitizer, cosmetic cleanup. |
| MEDIUM | Known page type but shape drift detected | Safe rules, surrogates, sanitizer in cautious mode, cosmetic cleanup delayed. |
| HIGH | Unknown shape, live/DVR, embed ambiguity, early health anomaly | Safe rules only, shadow sanitizer, no aggressive cosmetic cleanup. |
| PANIC | Prompt or breakage detected | Disable risky modules; preserve playback. |

Risk is recomputed on:

```text
initial page load
YouTube SPA navigation
player response update
browse/feed response update
health anomaly
anti-block prompt signal
surrogate schema mismatch
```

### 10.4 Shape confidence model

`sanitizerShapeConfidence` is not a vague boolean. It is a per-endpoint and per-sanitizer-path score computed from fixtures, shadow observations, and live page health.

Confidence is tracked at this granularity:

```text
ConfidenceKey {
  endpointClass,        // player, next, browse, search, shorts, config
  pageType,             // WATCH, HOME_FEED, SEARCH, SHORTS, EMBED, etc.
  sanitizerPath,        // normalized path or renderer type
  schemaFingerprint,    // hash of key/type shape, not values
  browserMajorVersion,
  extensionVersion
}
```

Scoring inputs:

| Evidence | Score effect |
| --- | --- |
| Fixture exists and sanitizer output passes protected-field tests | +35 |
| Current observed shape matches fixture fingerprint | +25 |
| Expected parent keys exist with expected types | +15 |
| Sanitizer path was observed in shadow mode without health anomaly | +10 per clean observation, max +20 |
| At least 3 consecutive page loads/navigation events were clean | +15 |
| Unknown mandatory parent key or type drift | -30 |
| Prompt, playback error, or DOM breakage after path fired | -50 |
| Surrogate/schema mismatch | -40 |
| Browser or extension major update without revalidation | cap at 60 until revalidated |

Activation thresholds:

```text
0-49: shadow only; do not mutate
50-69: cautious mode; mutate only low-risk renderer removals
70-84: balanced mode; activate validated path
85-100: stable mode; allow path in default balanced engine
```

Consecutive-observation requirement:

```text
A sanitizer path cannot move from shadow to balanced mode unless:
  fixture evidence exists
  current observed shape matches expected type structure
  at least 3 consecutive clean observations occurred for the same endpoint class/page type
  no health anomaly occurred within the post-sanitize observation window
```

Confidence decays when YouTube changes shape:

```text
new schema fingerprint -> reset to fixture score only
unknown parent shape -> shadow mode
prompt after path fired -> disable path for session
repeated prompt across sessions -> require manual fixture update
```

---

## 11. YouTube navigation lifecycle

YouTube is usually a single-page application, but the engine must handle both SPA transitions and full document navigations. Browser back/forward, opening a fresh watch URL, restoring a tab, or leaving YouTube and returning may trigger a traditional page load rather than a YouTube SPA event. The page-start path is therefore the authoritative initialization path for every non-SPA navigation.

Navigation signals:

```text
document_start page-start initialization
pageshow, including persisted bfcache restore
DOMContentLoaded fallback for missed early state
yt-navigate-start
yt-navigate-finish
yt-page-data-updated
popstate
history.pushState / history.replaceState wrapper
URL polling fallback every 500-1000 ms while document is visible
```

Navigation protocol:

```text
onFullDocumentStart:
  reset tab-local PageContext except persisted learned-suspect modules
  install idempotent passive hooks allowed for current frame context
  recompute PageContext from location before any mutation
  begin health monitor in passive/safe mode


onYouTubeNavigationStart:
  mark context stale
  suspend cosmetic cleanup mutations
  keep passive hooks alive

onYouTubeNavigationFinish:
  recompute PageContext
  recompute RiskLevel
  clear per-page sanitizer counters
  revalidate data shape
  re-enable modules allowed for new context

onYouTubePageDataUpdated:
  run data sanitizer on new page data if shape confidence is sufficient
  run cosmetic cleanup after render stabilization window
```

Full-navigation rule:

```text
If a navigation is not confirmed as a YouTube SPA transition, treat it as a new page-start event. Do not reuse stale sanitizer counters, stale DOM roots, stale page type, or stale risk level across full document navigations.
```

The hook manager must be idempotent:

```text
install once
verify still installed after SPA navigation
repair if overwritten
never stack duplicate wrappers
```

---

## 12. Early hook protocol and fallback

### 12.1 Main-world hook timing

The main-world script should be declared at `document_start` for YouTube-specific pages.

The earliest possible operation is a hook-risk assessment, followed by only the hooks allowed for the current mode. The engine must not assume that `document_start` always beats YouTube's inline bootstrap scripts. It must verify whether each target global already exists.

Known early globals:

```text
window.ytInitialPlayerResponse
window.ytInitialData
window.ytplayer
window.ytcfg
window.yt
```

Conceptual behavior:

```text
for each early global:
  descriptorBefore = Object.getOwnPropertyDescriptor(window, name)

  if property is absent and path confidence is high enough:
    install guarded accessor only if current mode permits detectable early hooks
    sanitize assigned value before storing
    preserve descriptor flags as closely as possible

  else if property already exists:
    do not replace descriptor blindly
    sanitize existing value retroactively if confidence allows
    mark hookMissedInitialAssignment = true
    increase riskLevel

  else:
    shadow-log only
```

The engine must never assume the hook beat YouTube scripts. It must check.

### 12.1.1 Detectability of early property hooks

Installing an accessor with `Object.defineProperty(window, 'ytInitialPlayerResponse', ...)` can itself be detected later through `Object.getOwnPropertyDescriptor(window, 'ytInitialPlayerResponse')`. If YouTube expects a plain data property and sees an accessor, that is a page-visible signal.

V4 therefore treats early accessor hooks as a monitored trade-off, not as an invisible mechanism.

Rules:

```text
Prefer retroactive sanitization and narrow fetch/XHR response guards when they are sufficient.
Use early accessors only for specific globals whose timing cannot otherwise be covered.
Never claim accessor hooks are undetectable.
Preserve enumerable/configurable flags to match the previous descriptor when a descriptor exists.
If no previous descriptor exists, use the least visible descriptor that still works.
Do not stack duplicate accessors.
Record descriptor mutation as a hook-risk telemetry event.
Disable accessor hooks first if anti-block prompt appears after hook installation.
```

Descriptor-risk classes:

| Hook situation | Risk | Default behavior |
| --- | --- | --- |
| Property already exists as data property | High | Prefer retroactive sanitize; do not convert to accessor unless debug/aggressive. |
| Property absent, high-confidence watch page | Medium | Accessor allowed only in balanced mode after fixture confidence threshold. |
| Unknown page type or embed | High | Shadow only; no accessor by default. |
| Live/DVR page | High | No accessor by default. |
| Prompt previously seen this session | Very high | Disable accessor hooks for session. |

A `Proxy` around `window` is not considered a reliable default solution because normal page code interacts with the browser's real `WindowProxy`, and attempting to replace or broadly proxy global access is likely more detectable and fragile than the specific accessor hook. V3 therefore uses accessor hooks only as a controlled, auditable risk and relies on retroactive sanitization plus fetch/XHR guards as the safer fallback path.

Hook risk affects `RiskLevel`:

```text
accessor installed successfully -> risk + one minor level until health confirmed
descriptor mismatch observed -> HIGH
prompt after accessor hook -> disable accessor hook path and mark suspect
retroactive sanitizer sufficient for 3 clean observations -> prefer no early accessor next session
```

### 12.2 Missed-hook fallback

If `ytInitialPlayerResponse` or `ytInitialData` already exists before the hook:

```text
sanitize existing object if safe
record missedInitialHook
increase riskLevel by one step
prefer shadow mode for unvalidated paths
use health monitor to decide whether to keep sanitizer active
```

### 12.3 Fetch/XHR fallback

The main-world script should also guard narrow YouTube internal API responses:

```text
/youtubei/v1/player
/youtubei/v1/next
/youtubei/v1/browse
/youtubei/v1/search
/youtubei/v1/reel/reel_item_watch
```

The response guard must be narrow, idempotent, and performance-bounded.

### 12.4 Unified main-world interception detectability model

The same detectability discipline applied to `Object.defineProperty` hooks also applies to every main-world wrapper. A wrapper around `window.fetch`, `XMLHttpRequest.prototype.open`, `XMLHttpRequest.prototype.send`, `Response.prototype.json`, `ytcfg.get`, `ytcfg.set`, or `ytcfg.update` is page-visible in principle. YouTube can inspect function identity, function source strings, property descriptors, call timing, error stacks, microtask timing, and behavioral edge cases.

V4 therefore treats all main-world interception as detectable-risk instrumentation, not as invisible observation.

Interception risk classes:

| Interception point | Risk | Default behavior |
| --- | --- | --- |
| Passive DOM read from isolated world | Low | Allowed in safe/shadow mode. |
| Main-world read-only wrapper that records shape but returns original objects | Medium | Allowed only when instrumented shadow is enabled and page type is known. |
| Main-world fetch/XHR wrapper that returns modified JSON | High | Requires fixture evidence, shape confidence threshold, health monitor, and fail-open path. |
| Main-world config getter/setter wrapper | High | Requires config-key allowlist and descriptor/function-risk telemetry. |
| Wrapper active on unknown page type, embed without fixture, live/DVR, or after prompt | Very high | Disabled by default. |

Rules for all wrappers:

```text
install at most once
keep original function references private
return original behavior for unknown endpoints/arguments
preserve observable error behavior as closely as practical
do not wrap broad Google APIs
do not wrap account/auth/payment/upload flows
record wrapper installation in local hook-risk telemetry
if prompt appears after wrapper installation, disable the newest/highest-risk wrapper first
```

Function-wrapper detectability must not be hidden by wording. Techniques such as native-looking `toString` shims are not a guarantee and should not be relied on as a primary safety mechanism. The primary safety mechanism is narrower scope, lower activation confidence, fail-open behavior, and rapid rollback.

Wrapper-risk telemetry records:

```text
wrapper target
page type
frame context
endpoint class
activation reason
shape confidence at activation
first health result after activation
prompt/breakage correlation window
```

#### 12.4.1 Reversible main-world wrapper lifecycle

The isolated-world content script cannot directly undo a descriptor or function wrapper installed in the page's main JavaScript world. Therefore, every main-world interception point must be installed by a bootstrap-owned reversible-wrapper manager. Rollback is only valid if the main-world manager confirms that the affected hooks were restored.

Mandatory wrapper-manager invariants:

```text
Every installed accessor/function/config wrapper receives a stable wrapperId.
The original property descriptor or function reference is captured before replacement.
The original descriptor/function is stored in a private bootstrap registry, not in page data structures.
The bootstrap exposes a disable/restore command path for each wrapperId.
The disable path remains available until full document unload.
The bootstrap must never delete its own restore mechanism while wrappers are active.
A wrapper can be disabled idempotently; duplicate disable commands are safe.
Unknown wrapperId disable requests are ignored and logged locally.
```

Wrapper installation record:

```text
MainWorldWrapperRecord {
  wrapperId
  targetKind: accessor | function | xhr | fetch | config | beacon | shadow-instrumentation
  targetName
  originalDescriptorHash
  installedAt
  activationReason
  riskClass
  restoreState: active | restore-pending | restored | restore-failed
}
```

Required restore behavior:

```text
restoreAccessor(wrapperId):
  Object.defineProperty(targetObject, propertyName, originalDescriptor)
  verify descriptor shape equals original descriptor shape where safe
  mark restoreState = restored

restoreFunction(wrapperId):
  targetObject[propertyName] = originalFunction or originalDescriptor
  verify strict equality where safe
  mark restoreState = restored

restoreXHRFetchGuard(wrapperId):
  restore XMLHttpRequest.prototype.open/send or window.fetch from registry
  clear endpoint-specific sanitizer state
  mark restoreState = restored

restoreConfigWrapper(wrapperId):
  restore original ytcfg/yt/config getter, setter, or method descriptor
  clear config-key sanitizer state
  mark restoreState = restored
```

Communication path:

```text
isolated world -> main world:
  postMessage({
    source: "uBRYouTubeIsolated",
    type: "UBR_DISABLE_MAINWORLD_WRAPPERS",
    commandNonce,
    wrapperIds | riskClass | "all",
    reason
  }, location.origin)

main world -> isolated world:
  postMessage({
    source: "uBRYouTubeMain",
    type: "UBR_DISABLE_MAINWORLD_WRAPPERS_ACK",
    commandNonce,
    restoredWrapperIds,
    failedWrapperIds,
    activeWrapperCount
  }, location.origin)
```

Command-authentication rule:

```text
The disable command must be correlated to the same per-page bootstrap channel established during readiness probing.
A page-origin message without the expected channel token/commandNonce is ignored.
A disable acknowledgement without the matching commandNonce is ignored.
The mechanism is not treated as cryptographic secrecy against all page scripts; it is a correlation and lifecycle-safety mechanism.
```

Rollback rule:

```text
When anti-block prompt, update reset, PANIC, or wrapper-risk rollback occurs:
  1. Isolated world sends disable command for the relevant wrapper class.
  2. Main-world bootstrap restores original descriptors/functions.
  3. Bootstrap returns acknowledgement.
  4. Isolated world marks rollback complete only after ack.
  5. If ack is missing or restore fails, the tab is classified WRAPPER_RESTORE_FAILED.
  6. WRAPPER_RESTORE_FAILED keeps the global plan conservative and may require a single user-visible reload recovery path rather than pretending rollback succeeded.
```

Update-reset rule:

```text
ENGINE_UPDATE_RESET must not merely clear isolated-world state.
It must send UBR_DISABLE_MAINWORLD_WRAPPERS with wrapperIds = "all" and wait for acknowledgement.
No active sanitizer, accessor, fetch/XHR guard, config wrapper, LOCAL_COMPLETE handler, or INSTRUMENTED_SHADOW path may resume until the restore acknowledgement is received and the new version's readiness probe succeeds.
```

Release-gate requirement:

```text
check-youtube-wrapper-restore.mjs must prove:
  accessor wrapper restores original descriptor
  fetch wrapper restores original function
  XHR wrapper restores original prototype methods
  ytcfg wrapper restores original method/descriptor
  duplicate restore is idempotent
  missing restore ack blocks reactivation
  update reset sends wrapper disable command before clearing local state
```

---

### 12.5 Main-world CSP execution compatibility and fallback

The architecture must not assume that `youtube-smart-main.js` always executes in the page's main JavaScript world. Main-world execution is a hard dependency for early property hooks, fetch/XHR guards, config wrappers, `LOCAL_COMPLETE` beacon handling, and instrumented shadow. If that script is blocked, delayed, or made ineffective by Content Security Policy or browser behavior, the engine must degrade safely rather than silently failing.

Startup probe:

```text
at document_start:
  isolated-world script creates a startup nonce
  main-world script, if executed, writes a minimal readiness marker and dispatches a readiness event
  isolated-world script waits within a short bounded window

if marker/event observed:
  mainWorldAvailable = true
  continue with mode-selected main-world modules

if marker/event not observed:
  mainWorldAvailable = false
  disable all main-world hooks for this tab/session
  enter DNR + isolated-observation + PASSIVE_DOM_SHADOW degraded mode
  record MAIN_WORLD_EXECUTION_MISSING
  classify as UNKNOWN_YOUTUBE_CHANGE if this begins after a previously working version
```



#### 12.5.1 Origin-safe main-world injection policy

The main-world bootstrap must not expose a persistent `chrome-extension://` script URL to YouTube page scripts. A DOM-visible element such as:

```html
<script src="chrome-extension://<extension-id>/js/youtube-smart-main.js"></script>
```

is forbidden for production because page scripts can inspect script `src` attributes, `document.currentScript`, resource timing entries, or error events and obtain a high-confidence extension fingerprint.

Allowed production injection mechanisms, in descending preference:

```text
1. Browser-mediated MAIN-world content-script execution that creates no page DOM script element and exposes no web-accessible script URL.
2. Programmatic MAIN-world execution that injects a function/body without leaving a DOM script node or stable extension URL.
3. Ephemeral inline/blob bootstrap only when CSP probe and fixture evidence prove it executes and does not expose a stable extension URL.
```

Forbidden production mechanisms:

```text
DOM <script src="chrome-extension://.../youtube-smart-main.js">
web_accessible_resources exposure of youtube-smart-main.js unless explicitly justified by a failing audit
long-lived blob: URLs that can be enumerated or correlated across navigations
sourceURL comments that reveal the extension ID or stable internal path
```

Implementation requirement:

```text
youtube-smart-main.js must not be listed in web_accessible_resources by default.
check-youtube-mainworld-origin-leak.mjs fails if the manifest exposes the main-world script as a web-accessible resource or if the injection helper creates a DOM-visible extension-origin script tag.
```

If the browser cannot execute main-world code without exposing the extension origin, the engine must disable main-world modules for that page/session and fall back to DNR + isolated observation.

#### 12.5.2 Readiness probe delivery contract

The readiness probe must use page APIs that do not require inline event handlers or DOM script attributes.

Primary channel:

```text
isolated world:
  nonce = random non-user token
  window.addEventListener("uBRYouTubeMainReady", handler, { once: true })

main world, after bootstrap executes:
  window.dispatchEvent(new CustomEvent("uBRYouTubeMainReady", {
      detail: { nonceHash, bootstrapVersion, pageTypeHint }
  }))
```

Fallback channel:

```text
main world:
  window.postMessage({ source: "uBRYouTubeMain", nonceHash, bootstrapVersion }, location.origin)

isolated world:
  listen for message events
  require event.source === window
  require event.origin === location.origin
  require expected nonceHash and bootstrapVersion
```

#### 12.5.2.1 Secure nonce handshake

The readiness probe must not accept a bare event name as proof of main-world execution. A page script can dispatch a fake `uBRYouTubeMainReady` event. Therefore, readiness requires a nonce-correlated handshake.

Required protocol:

```text
1. The isolated-world content script generates:
      nonce = crypto-random 128-bit value
      bootstrapSalt = compiled non-secret version salt
      expectedHash = sha256(nonce + bootstrapSalt + bootstrapVersion)

2. The isolated world exposes the nonce to the main-world bootstrap through exactly one approved short-lived channel:
      A. preferred browser-mediated injection argument, if Chrome supports passing args to MAIN-world execution without DOM exposure; or
      B. temporary window.__uBRProbeNonce value installed immediately before bootstrap execution and deleted after the first valid response or timeout; or
      C. strict postMessage bootstrap request where event.source === window and event.origin === location.origin.

3. The main-world bootstrap reads the nonce, computes:
      nonceHash = sha256(nonce + bootstrapSalt + bootstrapVersion)

4. The main-world bootstrap dispatches:
      CustomEvent("uBRYouTubeMainReady", { detail: { nonceHash, bootstrapVersion, channel } })

5. The isolated world accepts readiness only if:
      nonceHash === expectedHash
      bootstrapVersion === currentBootstrapVersion
      event source/channel matches the selected handshake path
      response arrives before the bounded timeout

6. After success or timeout, the nonce carrier is removed and the raw nonce is never persisted.
```

Security rules:

```text
A readiness event without the expected nonceHash is ignored.
A readiness event with the wrong bootstrapVersion is ignored and recorded as MAIN_WORLD_VERSION_MISMATCH.
A duplicate readiness event after the first accepted event is ignored.
A page-provided readiness event cannot enable wrappers, accessors, or INSTRUMENTED_SHADOW unless the nonce hash matches.
```

Detectability note:

```text
The temporary window.__uBRProbeNonce channel is itself page-visible in principle. It is allowed only because it is short-lived, contains no user data, is removed immediately after the handshake, and is part of the controlled main-world execution-risk ledger. If telemetry or probes show that this symbol is observed or interfered with, the engine must stop using the global nonce channel and fall back to the browser-mediated argument or strict postMessage path.
```

#### 12.5.2.2 Readiness-hash timing and startup gating

The readiness proof must not make `document_start` startup depend on a slow asynchronous cryptographic operation. `crypto.subtle.digest()` is asynchronous and may resolve after YouTube's earliest inline code has already executed.

Startup rule:

```text
The initial startup path must be safe without a completed hash.
High-risk modules remain disabled until readiness proof is accepted.
DNR critical allows and isolated passive observation may start before the hash resolves.
Early accessors, fetch/XHR guards, config wrappers, LOCAL_COMPLETE, and INSTRUMENTED_SHADOW cannot start until readiness is accepted.
```

Allowed readiness proof strategies:

```text
Preferred: browser-mediated MAIN-world injection arguments with a per-page nonce and synchronous nonce echo/correlation.
Allowed: synchronous short-lived correlation token derived from crypto.getRandomValues and compiled bootstrap version, accepted only within the bounded startup window.
Allowed with caution: asynchronous sha256(nonce + salt + version), but only if the engine stays in passive/degraded mode until the promise resolves.
Forbidden: enabling high-risk wrappers while waiting for async hash completion.
```

Bounded timing policy:

```text
readinessGraceWindowMs <= 250 by default
if readiness proof arrives inside grace window -> mainWorldAvailable = true, then apply normal gates
if readiness proof arrives after grace window -> record LATE_MAINWORLD_READY and keep high-risk modules disabled until next navigation or explicit low-risk re-evaluation
if readiness proof never arrives -> mainWorldAvailable = false
```

The hash is a startup correlation mechanism, not a license to activate risky hooks automatically. Readiness only proves that the bootstrap ran; wrapper activation still requires page type, risk, shape confidence, hook-race evidence, and no prompt/backoff state.

Both channels must be bounded by a short timeout. If neither channel confirms execution, set `mainWorldAvailable = false`, disable main-world modules for the tab/session, and record `MAIN_WORLD_PROBE_COMMUNICATION_FAILED`. A false negative is safer than assuming interception is active.

The readiness marker must not contain user data, account state, video metadata, or URLs beyond the coarse page type. It exists only to prove that the main-world bootstrap executed.

Fallback behavior when main-world execution is unavailable:

```text
disable early accessors
disable fetch/XHR response modification
disable config wrappers
disable LOCAL_COMPLETE beacon handling
disable INSTRUMENTED_SHADOW
keep DNR safe rules and critical allows
keep isolated-world health monitor
keep PASSIVE_DOM_SHADOW where possible
keep conservative cosmetic cleanup only when DOM safety tests pass
```

DNR header-relaxation policy:

```text
Modifying YouTube response headers to relax CSP is not a default technique.
It is a high-risk experimental facility, off by default, restricted to debug/aggressive builds or explicit user opt-in, and must fail open.
If header modification fails or changes unrelated directives, remove the header rule and enter degraded mode.
```

CSP drift handling:

```text
main-world probe formerly succeeded but now fails -> UNKNOWN_YOUTUBE_CHANGE
CSP-related console/security error detected -> CSP_RISK_SIGNAL
repeated CSP failure on same page class -> disable main-world modules for session
```

### 12.6 Early hook-race telemetry

Early accessor hooks are useful only if they plausibly run before YouTube assigns the relevant global. If passive telemetry shows that the value is already assigned before the extension can observe or hook it, installing the accessor later creates detectability risk without benefit.

During passive shadow on watch-like pages, the engine must collect hook-race telemetry before enabling early accessors by default.

Telemetry points:

```text
mainWorldAvailable
contentScriptStartTime
mainWorldProbeTime
pageType
frameContext
ytInitialPlayerResponseAlreadyDefinedAtProbe
ytInitialDataAlreadyDefinedAtProbe
preExistingDescriptorKind: absent | data | accessor | unknown
inlineAssignmentEvidenceFromDOM: none | script_seen_before_probe | script_seen_after_probe | unknown
retroactiveSanitizerSucceeded
accessorWouldHaveWon: yes | no | unknown
```

Activation rule:

```text
Early accessor hooks are disabled unless all of the following are true:
  hookRaceEvidence.earlyAccessorWinsLikely === true
  mainWorldAvailable === true
  pageType is fixture-covered
  sanitizerShapeConfidence for the target path meets the activation threshold
  no anti-block prompt or wrapper anomaly was seen in the current session
  descriptor-risk budget is available

If early globals are already defined in most clean passive observations for the same page class, do not enable early accessors by default.
Prefer retroactive sanitization or narrow response guards.
If accessors win only intermittently, keep them behind debug/aggressive policy and record descriptor-risk telemetry.
If the race cannot be measured because main-world execution is missing, early hooks remain disabled.
```

`INSTRUMENTED_SHADOW` is not sufficient evidence by itself. The hook-race gate must independently confirm that the accessor can plausibly beat YouTube's assignment timing before any descriptor-changing accessor is installed.

The hook-race probe is not a suppression feature. It is an evidence gate for whether an accessor is worth its detectability cost.

## 13. Rule-plan classifier and DNR semantics

In MV3, the service worker cannot dynamically inspect each request body and decide a different DNR action in real time. DNR actions are predeclared in installed rules.

Therefore, V4 uses **rule-plan classification**, not imaginary runtime request classification.

```text
Rule-plan classifier:
  input: current settings, page context, risk level, learned broken rules
  output: set of static/session/dynamic DNR rules to install or remove
```

Adaptation happens by swapping rules:

```text
safe mode → install safe rules only
balanced mode → install safe + validated surrogate rules
backoff mode → remove suspect YouTube session rules
panic mode → remove all YouTube-specific session rules
```

Rule actions:

```text
BLOCK      safe only when page-visible contract is not expected
REDIRECT   use local surrogate when success shape is expected
ALLOW      use for critical player/bootstrap resources
MODIFY     only for narrow header/query cases if needed and tested
```

---

### 13.1 Adaptive DNR rule-budget model

The YouTube engine must operate under an internal adaptive-rule budget regardless of the browser's current DNR ceiling. The purpose is to prevent rule-install failures from becoming page-visible anomalies and to guarantee space for critical allow rules before any optional suppression rule is considered.

Internal budget:

```text
YOUTUBE_ADAPTIVE_RULE_BUDGET_MAX = 1000
YOUTUBE_CRITICAL_ALLOW_RULE_RESERVE = 200
YOUTUBE_SURROGATE_RULE_SOFT_LIMIT = 300
YOUTUBE_SAFE_BLOCK_RULE_SOFT_LIMIT = 300
YOUTUBE_BEACON_RULE_SOFT_LIMIT = 100
YOUTUBE_SHADOW_RULE_SOFT_LIMIT = 100
```

Allocation priority:

```text
1. Critical allow rules for playback/bootstrap/account-neutral endpoints
2. Generic-stealth exclusion/replacement rules needed to protect YouTube
3. High-confidence YouTube surrogate redirects
4. High-confidence safe block rules
5. Beacon policy rules
6. Shadow/diagnostic rules
7. Low-confidence experimental rules
```

Pressure behavior:

```text
If rule budget pressure occurs:
  remove low-confidence experimental rules first
  remove shadow/diagnostic DNR rules second
  remove beacon rules third unless needed for safety
  remove safe block rules before surrogate or critical allow rules
  never remove critical allow rules to make room for ad suppression
```

Critical install failure:

```text
If a critical allow or critical YouTube protection rule cannot be installed:
  remove optional YouTube session/adaptive rules
  retry critical install once
  if still failing, enter PANIC for YouTube engine
  disable active sanitizer/surrogate/cosmetic modules for the tab/session
  record CRITICAL_DNR_INSTALL_FAILED
  surface diagnostic in internal logger
```

Runtime accounting:

```text
before updateSessionRules/updateDynamicRules:
  compute proposed YouTube rule count by class
  verify critical reserve is satisfied
  verify total <= YOUTUBE_ADAPTIVE_RULE_BUDGET_MAX
  reject the plan if optional classes exceed budget
```

The rule-plan manager must treat rule-capacity failure as a safety failure, not as a normal degraded ad-blocking state.


### 13.2 Global DNR rule-plan aggregation across tabs and embeds

DNR session/dynamic rules are global. The service worker must never treat a per-tab PageContext as if it can install a tab-local DNR plan. Per-tab precision belongs in content scripts, wrappers, sanitizers, and cosmetic modules; DNR remains a global safety net.

Global aggregation inputs:

```text
Top-level YouTube tabs
Registered YouTube embed frames
Persisted session bans and suspect modules
Current global panic/backoff state
Critical endpoint registry
Rule budget state
Extension/registry version state
```

Aggregation rule:

```text
if no top-level YouTube tab is open and no registered YouTube embed exists:
    globalRulePlanMode = SAFE_CONSERVATIVE
    keep/reinstall critical allow rules only if required by the critical registry
    remove all optional YouTube DNR rules

else if registered embeds exist and no top-level YouTube tab is open:
    globalRulePlanMode = EMBED_CONSERVATIVE
    allow only rules marked embed-safe with fixture evidence
    remove top-level-only surrogates, safe blocks, beacon, and shadow rules

else:
    globalRulePlanMode = most conservative mode required by any active YouTube context
    never install a rule whose context safety is lower than the aggregate requirement
```

Mandatory no-top-level purge:

```text
If openTopLevelYouTubeTabs.length === 0:
  remove all YouTube optional session/dynamic rules:
    YOUTUBE_ENGINE_SURROGATE
    YOUTUBE_ENGINE_SAFE_BLOCK
    YOUTUBE_BEACON_POLICY
    YOUTUBE_SHADOW_DIAGNOSTIC
    YOUTUBE_EXPERIMENTAL
  persist installedYouTubeRuleIDs as critical-only
  clear optional rule-plan hash
  record YOUTUBE_OPTIONAL_RULES_PURGED_NO_TOP_LEVEL
```

This purge is required even when embeds exist. Embeds may keep only critical or explicitly embed-safe rules. No top-level watch-page rule may remain active solely because it was active before the top-level tab closed.

## 14. Rule precedence and generic stealth integration

The current generic stealth-surrogate system must not conflict with YouTube-specific logic.

Precedence model:

```text
1. Critical YouTube allow rules
2. YouTube-specific surrogate rules
3. YouTube-specific safe block rules
4. Generic stealth-surrogate rules
5. Generic ad/tracker rules
```

Mandatory priority constants:

```text
GENERIC_STEALTH_PRIORITY_MAX = 500_000          // current generic stealth class
GENERIC_AD_TRACKER_PRIORITY_MAX = 549_999       // existing broad non-YouTube rule ceiling
YOUTUBE_NON_ENGINE_PRIORITY_CEILING = 599_999   // user/imported/stock rules that match YouTube
YOUTUBE_SAFE_BLOCK_PRIORITY = 610_000
YOUTUBE_SURROGATE_PRIORITY = 620_000
YOUTUBE_CRITICAL_ALLOW_PRIORITY = 700_000
```

Rule-authority classes:

```text
YOUTUBE_ENGINE_CRITICAL_ALLOW   // may use YOUTUBE_CRITICAL_ALLOW_PRIORITY
YOUTUBE_ENGINE_SURROGATE        // may use YOUTUBE_SURROGATE_PRIORITY
YOUTUBE_ENGINE_SAFE_BLOCK        // may use YOUTUBE_SAFE_BLOCK_PRIORITY
GENERIC_STEALTH                 // capped at GENERIC_STEALTH_PRIORITY_MAX
STOCK_OR_IMPORTED_FILTER_LIST    // capped at YOUTUBE_NON_ENGINE_PRIORITY_CEILING when matching YouTube
USER_NETWORK_FILTER             // capped at YOUTUBE_NON_ENGINE_PRIORITY_CEILING when matching YouTube
LOGGER_IN_MEMORY_FILTER          // capped at YOUTUBE_NON_ENGINE_PRIORITY_CEILING when matching YouTube
```

Rule:

```text
Every YouTube-specific rule that can overlap a generic stealth rule must have priority greater than every generic stealth rule. Critical YouTube allow rules must outrank YouTube surrogate and block rules.
```

The build must fail if a generic rule has equal or higher priority than an overlapping YouTube-specific rule.

### 14.1 User/imported network-rule interference guard

The priority model also applies to user-created and imported network filters. The engine cannot be self-protecting if a broad user or imported-list block rule can outrank a critical YouTube allow rule. This is the network equivalent of the existing masthead/search protection for stale broad cosmetic filters.

Mandatory rule:

```text
Any DNR rule that matches a YouTube request and was not created by the YouTube engine must have priority strictly lower than YOUTUBE_CRITICAL_ALLOW_PRIORITY. For sensitive YouTube endpoints, it must also be lower than the YouTube engine rule that owns that endpoint.
```

Compilation policy:

```text
When compiling stock, external, imported, user, temporary logger, or in-memory network filters:
  if rule can match a YouTube origin, YouTube initiator, YouTube player endpoint, or known YouTube-sensitive Google ad endpoint:
      cap priority at YOUTUBE_NON_ENGINE_PRIORITY_CEILING
      attach ruleOrigin metadata
      run conflict check against YouTube critical endpoint registry

  if rule overlaps a critical YouTube allow endpoint:
      keep compiled priority below YOUTUBE_CRITICAL_ALLOW_PRIORITY
      record a user-rule-interference warning
      surface the warning in diagnostics/logger/dashboard

  if rule cannot be safely capped because it came from an immutable static ruleset:
      fail the build for bundled rulesets
      disable or de-prioritize the ruleset at runtime for imported rulesets
      mark YouTube engine state as USER_RULE_INTERFERENCE if the rule remains active
```

Critical endpoint registry:

```text
youtube-critical-endpoints.json
  endpoint pattern
  resourceTypes
  pageTypes
  owning YouTube rule ID
  required action: allow | surrogate | allow-or-surrogate
  minimum owning priority
  reason
  fixture evidence
```

Runtime health behavior:

```text
If playback health fails and a non-YouTube-engine rule matched a critical YouTube endpoint:
  classify as USER_RULE_INTERFERENCE
  do not keep disabling YouTube modules blindly
  show diagnostics explaining which user/imported list rule is likely responsible
  request manual review or one-click temporary disable for that specific rule/list
```



Diagnostic limitation and static simulation:

```text
DNR does not provide complete real-time per-request match attribution for every production request.
USER_RULE_INTERFERENCE must therefore be diagnosed asynchronously by static overlap simulation:
  enumerate installed dynamic/session/static rules where accessible
  map compiled ruleOrigin metadata to source list/user filter
  compare URL conditions, resourceTypes, initiator/excludedInitiator domains, and priorities against youtube-critical-endpoints.json
  mark possible overlaps as advisory evidence, not proof of a live match
```

Fallback rule:

```text
If the simulator cannot identify a specific non-engine rule with high confidence:
  do not disable user/imported rules automatically
  classify as UNKNOWN_RULE_INTERFERENCE or POSSIBLE_USER_RULE_INTERFERENCE
  surface diagnostics for manual review
  continue conservative YouTube backoff without blaming the user rule
```

Backoff limitation:

```text
The YouTube engine can disable its own session rules and active modules. It may not be able to override an uncapped user/imported static rule already installed at a higher priority. Therefore priority capping and conflict auditing are mandatory, not optional diagnostics.
```

Implementation options:

### 14.2 Option A — Exclude YouTube initiators from generic stealth rules

Preferred and mandatory for early development. The enforcement mechanism is DNR-level exclusion, not a prose convention.

Generic stealth-surrogate rules that can match requests initiated by YouTube must include `excludedInitiatorDomains` for YouTube origins.

Required exclusion set:

```text
youtube.com
www.youtube.com
m.youtube.com
music.youtube.com
youtube-nocookie.com
youtu.be
```

Conceptual DNR condition shape:

```json
{
  "urlFilter": "||pagead2.googlesyndication.com^",
  "resourceTypes": ["script", "xmlhttprequest"],
  "excludedInitiatorDomains": [
    "youtube.com",
    "www.youtube.com",
    "m.youtube.com",
    "music.youtube.com",
    "youtube-nocookie.com",
    "youtu.be"
  ]
}
```

Important DNR limitation:

```text
excludedInitiatorDomains only covers the immediate initiator domain known to DNR. It does not express "top-level document is YouTube" for every third-party script-initiated subrequest. A request made by a third-party ad script running inside a YouTube page may have a third-party initiator, so a YouTube-domain exclusion alone is incomplete.
```

Defense-in-depth requirements:

```text
1. Add YouTube excludedInitiatorDomains to generic rules where possible.
2. Give all overlapping YouTube-specific allow/surrogate/block rules higher priority than generic stealth rules.
3. Add conflict fixtures for both YouTube initiators and known third-party ad-script initiators.
4. If DNR cannot safely distinguish top-level YouTube from non-YouTube pages for an endpoint, either:
   a. replace the generic surrogate for that endpoint with a universal surrogate compatible with YouTube and normal sites, or
   b. disable the generic surrogate for that endpoint and let the YouTube module own it.
5. Never rely on excludedInitiatorDomains alone as the only conflict-control mechanism.
```

Implementation requirement:

```text
createStealthSurrogateRules({ excludeYouTubeInitiators: true })
  -> adds excludedInitiatorDomains to all generic rules that can overlap YouTube

createYouTubeSurrogateRules()
  -> installs YouTube-specific equivalents with explicit priorities and tests
```

Build audit:

```text
tools/check-youtube-generic-stealth-conflicts.mjs
  fails if a generic stealth redirect rule can match a YouTube initiator
  fails if a generic rule and YouTube rule redirect the same request without tested priority
  fails if YouTube critical allow rules can be overridden by generic redirects
```

### 14.3 Option B — Higher-priority YouTube rules

This is mandatory defence-in-depth, not merely a fallback. Even when `excludedInitiatorDomains` is present, YouTube-specific rules must use higher priority and non-overlapping ID ranges because initiator-domain exclusions can miss third-party initiator cases.

Recommended ID and priority ranges:

```text
Generic stealth: existing ID range, priority <= 500_000
YouTube safe block: 8_900_000 - 8_949_999, priority 610_000
YouTube surrogate: 8_950_000 - 8_989_999, priority 620_000
YouTube critical allow: 8_990_000 - 8_999_999, priority 700_000
```

Conflict audit required:

```text
No two redirect rules should target the same request unless priority and expected winner are tested.
No generic surrogate should override a YouTube allow rule.
No YouTube rule should redirect a critical player bootstrap script unless fixture-proven.
```

---

## 15. Surrogate strategy

Surrogates are local packaged replacements for resources whose absence would be detectable.

### 15.1 Surrogate categories

```text
SCRIPT_SURROGATE
JSON_SURROGATE
IMAGE_SURROGATE
BEACON_COMPLETION_SURROGATE
API_SHAPE_SURROGATE
```

### 15.2 Surrogate requirements

A surrogate must:

```text
be packaged locally
contain no remote logic
be schema-compatible
resolve synchronously/asynchronously as expected
avoid throwing
avoid creating impossible player state
have fixture tests
have a fail-open path
```

### 15.3 Schema evolution policy

Static surrogates can drift when YouTube changes response shape.

Validation requirements:

```text
each surrogate has a schema fingerprint
each sanitizer fixture includes expected input/output shape
unknown mandatory fields cause shadow mode, not aggressive mutation
surrogate mismatch triggers fail-open allow
live endpoint validation is manual or recorded-fixture based, not automatic remote code update
```

Fail-open principle:

```text
If a surrogate is outdated, allow the request rather than returning a broken shape.
```

### 15.4 Performance Timeline compatibility for surrogates

A local surrogate must be evaluated not only by JavaScript response shape, but also by the resource-timing trace it creates. A surrogate redirect can avoid a missing-resource signal, but it may introduce an extension-origin or unrealistic-timing signal.

Surrogate timing requirements:

```text
for each surrogate endpoint:
  classify whether YouTube scripts can observe the resource timing entry
  record expected entry type, URL class, initiator type, and coarse timing envelope
  prefer smallest compatible resource that still creates a plausible load shape
  avoid exposing unnecessary web_accessible_resource paths
  fail open to ALLOW if the surrogate is more detectable than the original request
```

Hard rule:

```text
Do not replace a monitored network resource with a chrome-extension surrogate unless the fixture/risk record says the extension-origin entry is acceptable or unavoidable.
```

### 15.5 Subresource Integrity policy for script and stylesheet surrogates

A script or stylesheet loaded with an `integrity` attribute is not eligible for blind DNR redirection to an extension-owned surrogate. The browser will verify the redirected bytes against the original integrity metadata, and a mismatch can cause a page-visible load failure, `onerror` event, console error, or missing API shape.

Policy:

```text
If a candidate SCRIPT_SURROGATE or STYLE_SURROGATE target can carry SRI:
  do not redirect by default
  prefer ALLOW plus main-world/config/data sanitizer where available
  record SRI_SURROGATE_INELIGIBLE in the endpoint registry
  require fixture evidence before any exception

If shadow telemetry observes an integrity attribute on the resource element:
  mark endpoint surrogate eligibility = false for the session
  remove corresponding redirect rule from the global rule plan
  fail open to ALLOW
```

Planning requirement:

```text
SurrogateEligibility:
  endpoint
  resourceType
  mayCarryIntegrity
  observedIntegrityAttribute
  corsMode
  credentialsMode
  performanceTimingRisk
  eligibleForRedirect
  fallbackAction
```

No script surrogate may be installed until the surrogate eligibility record says `eligibleForRedirect: true`. Unknown SRI status is treated as ineligible for script/style redirects, not as safe.

### 15.6 CORS policy for JSON/API and cross-origin surrogates

A surrogate served from `chrome-extension://` is not automatically a valid replacement for a cross-origin fetch/XHR response. Request mode, credentials, response type, CORS headers, redirects, opaque response behavior, and page-visible failure modes must match the original contract closely enough to avoid detection.

Policy:

```text
For JSON/API/XHR/fetch surrogates:
  validate under the original request mode (`cors`, `no-cors`, `same-origin`, etc.)
  validate under the observed credentials mode
  validate response type, status, ok flag, headers visibility, and body parse behavior
  do not assume web_accessible_resources alone solves CORS
  fail open to ALLOW on any CORS mismatch
```

Manifest and header requirements:

```text
Each surrogate resource must have an explicit web_accessible_resources allowlist entry scoped as narrowly as MV3 permits.
If DNR modifyHeaders is used to adjust CORS-related headers, it must be endpoint-specific, fixture-proven, off by default until validated, and fail open.
Do not mutate auth, cookie, CSP, Trusted Types, cache, or security headers to make a surrogate work.
```

Fixture gate:

```text
A JSON/API surrogate is eligible only if tests show:
  page-side fetch/XHR resolves rather than rejects
  response.status, response.ok, response.type, and parse behavior match expected contract
  no CORS console/security error is produced in fixture runs
  PerformanceResourceTiming does not introduce a worse signal than ALLOW
```

If these conditions cannot be proven, the endpoint must remain `ALLOW` or be handled by a non-network sanitizer rather than by DNR redirect.

---

## 16. Beacon integrity policy

Beacon strategy must be explicit because missing beacons can be a detection signal.

Allowed beacon handling modes:

| Mode | Use when | Behavior | Status |
| --- | --- | --- | --- |
| ALLOW | Beacon is low-risk and blocking absence would be suspicious | Let it pass. | Default safest mode. |
| PIXEL_SURROGATE | Image/pixel load success is expected and endpoint is non-critical | Redirect to local transparent image. | Allowed with fixture. |
| BLOCK | Beacon is not page-observed and is safe to block | Block normally. | Allowed with evidence. |
| LOCAL_COMPLETE | Page expects a local success callback/promise but remote payload should not be sent | Complete the in-page contract locally without sending a forged remote event. | Experimental, off by default. |

Hard rule:

```text
Do not forge monetization, impression, billing, conversion, or engagement events to YouTube.
```

### 16.1 `LOCAL_COMPLETE` experimental guardrails

`LOCAL_COMPLETE` is fragile because it requires the main-world fetch/XHR guard to recognize a very small set of beacon endpoints, understand the local response contract, and resolve the caller without sending a remote event. It must not be treated as a general beacon solution.

Feature flag:

```text
youtubeBeaconLocalCompleteExperimental: false
```

Allowed only when all conditions hold:

```text
endpoint is on a hardcoded allowlist
request method and content type match fixture
caller only requires local success/failure resolution
no monetization/impression/billing/engagement event is forged
local completion response shape has a fixture
shape confidence >= 85
health monitor is normal
```

Fail-open path:

```text
if endpoint is unknown -> ALLOW
if request shape changed -> ALLOW and mark surrogate drift
if local completion throws -> retry original request if still possible, otherwise do not intercept next time
if prompt appears after LOCAL_COMPLETE -> disable LOCAL_COMPLETE for session
```

Schema drift policy:

```text
Each LOCAL_COMPLETE endpoint has a response-contract fingerprint.
A new required field or changed callback contract disables local completion.
Recorded fixtures, not remote executable updates, are used to update the contract.
```

Detection-neutrality here means preserving local page contracts, not sending fake ad engagement to the server.

---

## 17. Generalized YouTube data sanitizer

V1 focused too much on player data. V4 keeps the general data sanitizer.

### 17.1 Sanitized data sources

```text
ytInitialPlayerResponse
player API responses
next/watch-next responses
ytInitialData
browse responses
search responses
Shorts/reel responses
sidebar recommendation data
notification/menu data if ad-bearing and tested
ytcfg / yt.config_ global config
```

### 17.2 Sanitizer classes

```text
PlayerSanitizer
BrowseDataSanitizer
SearchDataSanitizer
ShortsDataSanitizer
SidebarDataSanitizer
ConfigSanitizer
```

### 17.3 Contract-preserving output rules

```text
arrays remain arrays
objects remain objects
required parent objects remain present
unknown fields are preserved
non-ad fields are preserved
ad-only renderers are removed from arrays
ad-only fields are replaced with harmless empty equivalents
```

### 17.4 Candidate ad renderer patterns

These names are examples and must be fixture-validated before mutation:

```text
adSlotRenderer
promotedContentRenderer
promotedSparklesWebRenderer
playerLegacyDesktopWatchAdsRenderer
companionAdRenderer
carouselAdRenderer
searchPyvRenderer
statementBannerRenderer with promoted payload
shelfRenderer containing promoted payload
reelShelfRenderer containing promoted payload
```

The sanitizer must not remove a generic `shelfRenderer` unless the shelf is proven to contain ad/promoted payload.

---

## 18. Player sanitizer

The player sanitizer removes ad metadata before YouTube consumes it.

Candidate player fields:

```text
adPlacements
playerAds
adSlots
adBreakHeartbeatParams
adSafetyReason
adParams
companionAdConfig
instreamVideoAdRenderer
playerLegacyDesktopWatchAdsRenderer
```

Protected fields:

```text
streamingData
videoDetails
captions
microformat
playabilityStatus
storyboards
endscreen
cards
annotations
playlist
```

Rule:

```text
Never mutate streamingData unless a fixture proves the segment is ad-only and playback remains healthy.
```

The sanitizer must be idempotent:

```text
sanitize(sanitize(x)) == sanitize(x)
```

---

## 19. Global config sanitizer

YouTube may expose ad-related state through global config.

Targets:

```text
yt.config_
ytcfg.data_
ytcfg.get(...)
ytcfg.set(...)
ytcfg.update(...)
```

Sanitizer behavior:

```text
wrap ytcfg setters/getters carefully
sanitize ad-related config fragments
preserve unrelated flags
preserve experiment flags unless proven ad/detection-specific
avoid deleting ytcfg itself
```

Candidate keys to evaluate through fixtures:

```text
adSlots
adConfig
adSignalsInfo
enable_ad_detection_logging
ad_preroll
ad_device_signals
ad_break
adPlacements
```

Unknown config keys should be logged in shadow mode, not mutated by default.

### 19.1 Config wrapper detectability

Wrapping `ytcfg.get`, `ytcfg.set`, `ytcfg.update`, or related config functions is not automatically safer than early property hooks. These wrappers can be detected through function identity, call timing, stack traces, and `Function.prototype.toString` behavior.

Config sanitizer activation therefore follows the unified interception-risk model in Section 12.4. In default safe mode, config keys should be observed through existing object snapshots where possible. Function wrappers are allowed only for known page types, validated key allowlists, and confidence-approved config shapes.

Fail-open rule:

```text
If a config wrapper sees unknown arguments, unknown key shapes, non-JSON-like values, or unexpected caller behavior, return the original function result and shadow-log only.
```

---

## 20. Fetch/XHR guard

The fetch/XHR guard should be narrow and performance-bounded.

Allowed interception patterns:

```text
same-origin YouTube internal API endpoints only
known `/youtubei/v1/*` endpoints only
JSON responses only
size-limited responses only
page types with sanitizer support only
```

Forbidden interception patterns:

```text
all fetch calls
all Google APIs
account/auth/payment endpoints
creator studio endpoints
upload endpoints
OAuth/auth endpoints
large media responses
non-JSON responses
```

Response handling:

```text
if endpoint not recognized:
  return original response
if response too large:
  return original response and mark performance skip
if JSON parse fails:
  return original response
if sanitizer confidence low:
  return original response or shadow-log only
```

### 20.1 Response-header policy

The sanitizer primarily handles bodies, but same-origin YouTube fetch/XHR callers may also observe response headers through `Response.headers` or `XMLHttpRequest.getResponseHeader`. If ad-related state appears in headers, body-only sanitization could leave an inconsistent signal.

Default policy:

```text
observe headers in shadow mode
do not strip or rewrite headers by default
only sanitize headers for same-origin JSON/API responses already being body-sanitized
never modify auth, cache, cookie, CORS, CSP, Trusted Types, security, or playback-critical headers
fail open to the original response when header shape is unknown
```

Candidate ad-related headers, if ever observed, must be handled through fixtures rather than broad matching. Examples are placeholder classes, not a committed live list:

```text
x-ad-*
x-youtube-ad-*
x-goog-ad-*
ad placement / ad reason / ad experiment headers if fixture-proven
```

Implementation choices:

```text
If the main-world fetch guard constructs a sanitized Response, it may also construct a sanitized Headers object only for fixture-approved ad headers.
If the request is handled only by DNR and no body sanitizer is active, do not attempt header mutation unless a DNR modifyHeaders rule is fixture-proven and has fail-open/backoff coverage.
```

Telemetry must record header key names or hashes only, not header values, unless explicit debug export is enabled.

---

## 21. Performance budget

The sanitizer must not become a jank source.

Budgets:

```text
Main-world hook install: < 2 ms target
Single sanitizer pass, normal response: < 8 ms target
Large response skip threshold: configurable, default 2 MB
No full deep clone unless endpoint is known and size is below threshold
No repeated full JSON serialization on same object
MutationObserver callback target: < 4 ms per processed batch
MutationObserver hard throttle: process at most once per 200 ms per observed root
Transient player-UI scan window: active only around suspected ad-state transitions
Health tick interval: 1000-2000 ms, paused when document hidden
```

Implementation rules:

```text
use shallow path checks first
visit only known renderer containers
avoid recursive traversal of entire object graphs by default
use allowlisted traversal paths per endpoint
cache sanitized object identity with WeakSet when possible
record performance skips in telemetry
```

### 21.1 MutationObserver scoping

Transient UI cleanup must not observe the whole YouTube document continuously.

Observer roots:

| Root | Allowed use | Default |
| --- | --- | --- |
| Player subtree only | Skip/countdown/ad overlay cleanup | Allowed on watch pages. |
| Feed grid subtree | Promoted card cleanup after render stabilization | Allowed only on home/search with data-sanitizer confidence. |
| Entire document body | Emergency prompt detection only | Avoid for cleanup; throttle heavily. |

Observer configuration rules:

```text
Use subtree: true only inside the player subtree or a known feed container.
Disconnect observer when page is hidden or context becomes stale.
Batch mutations with requestAnimationFrame or a 200 ms timer.
Never scan all nodes in the document per mutation.
Limit per batch to a fixed node budget, e.g. 200 candidate nodes.
If budget exceeded 3 times in one minute, disable cosmetic observer for the page and log performanceBackoff.
```

Transient ad UI cleanup is therefore opportunistic:

```text
If cleanup exceeds budget -> skip cleanup, preserve playback, record leftover UI.
```

---

### 21.2 Shadow DOM-aware observation

YouTube player and enforcement UI may be rendered inside open Shadow DOM roots. A `MutationObserver` attached only to the light-DOM player container may miss skip buttons, countdown overlays, ad UI, or anti-block prompts inside those roots.

Observer discovery rules:

```text
for each known player root candidate:
  observe the light-DOM player container
  if candidate.shadowRoot exists and is open:
    observe candidate.shadowRoot with the same throttle and node budget
  if nested open shadow roots are discovered inside the player subtree:
    observe only those matching player/ad/prompt root allowlist
  if the shadow root is closed or unavailable:
    fall back to light-DOM player health signals and structural prompt scoring
```

Budget rules are shared with normal MutationObserver processing:

```text
ShadowRoot observer callback target: < 4 ms per processed batch
ShadowRoot observer hard throttle: at most once per 200 ms per observed root
Maximum observed roots per tab: configurable, default 5
If observed-root budget is exceeded, keep the main player root and disconnect lower-confidence roots
```

Prompt detector integration:

```text
anti-block detector scans both light-DOM and open ShadowRoot observer queues
closed shadow roots are treated as reduced visibility, not as proof no prompt exists
if playback is blocked but no light-DOM prompt is visible, increase closedShadowPromptUncertainty
```

Shadow-root attachment detection must be conservative. The engine should prefer periodic discovery of open roots during known player lifecycle transitions. It may use a browser-supported shadow-root creation event only if available and tested. It must not monkey-patch `Element.prototype.attachShadow` by default, because that is another detectable main-world wrapper. If attachShadow instrumentation is ever added, it belongs under the unified wrapper-risk model and must be off by default.



Shadow DOM mutation detectability:

```text
Any mutation inside an open ShadowRoot is as page-visible as a light-DOM mutation.
YouTube's own observers may detect repeated display toggles, node removals, attribute writes, or style changes inside the player shadow tree.
```

Therefore Shadow DOM cosmetic cleanup is its own risk class:

```text
RiskClass.SHADOW_DOM_COSMETIC_CLEANUP
  default: disabled until fixture and prompt-detector evidence exists
  disabled immediately on prompt score threshold
  disabled on two budget overruns in one session
  disabled on any observer-anomaly signal
```

## 22. Anti-block prompt detector

The detector must be multi-signal, not a single fragile text selector.

### 22.1 Signals

```text
modal dialog appears over player or page
role="dialog" or aria-modal="true"
YouTube-styled enforcement overlay near player
buttons/links that imply allowing ads or disabling blocker
playback paused with enforcement overlay
known prompt container shapes
repeated failed playback with ad-block-like modal
localized text pattern score where available
```

### 22.2 Detection method

```text
MutationObserver for modal/player overlay insertions
light polling fallback every 1000 ms while player is unhealthy
accessibility attribute scan
structural scoring, not English-only matching
```

### 22.3 Scoring model

```text
score >= 80: confirmed anti-block prompt
score 50-79: suspected prompt, enter cautious backoff
score < 50: no prompt
```

Example scoring inputs:

```text
modal overlay present: +20
player blocked/paused unexpectedly: +20
text mentions ad blocker / ads / disable / allowlist in current locale: +30
primary action button visible: +10
known YouTube enforcement component shape: +20
```

The prompt detector should not immediately hide the prompt. First response is rollback/backoff.

---

## 23. Cosmetic cleanup and transient ad UI

Cosmetic cleanup runs after data sanitization and render stabilization.

### 23.1 Forbidden selectors

Never use broad selectors such as:

```text
.style-scope
[class*="ad"]
[id*="ad"]
ytd-masthead
ytd-topbar
#container
#center
#start
#end
#guide-button
#logo
```

### 23.2 Allowed selector requirements

Every selector must have:

```text
selector
pageType
riskLevelAllowed
fixtureEvidence
protectedAncestorCheck
rollbackTag
```

### 23.3 Transient ad UI handling

The cleanup module must handle brief leftover UI states:

```text
Skip Ad button
ad countdown overlay
ad progress markers
sponsored companion panel
promoted feed card already rendered before sanitizer
player overlay ad badge
```

Rule:

```text
If the sanitizer works correctly, transient ad UI should be rare. Cosmetic cleanup is a cleanup layer, not the main engine.
```

---

## 24. Health monitor

Health monitor signals:

```text
video element exists
video readyState is healthy
currentTime advances when playing
no persistent spinner
no fatal playback error
player controls remain usable
comments area reachable on watch page
description reachable on watch page
masthead/search visible
SPA navigation works
anti-block prompt absent
```

Health states:

```text
HEALTHY
DEGRADED
STUCK
PROMPT_DETECTED
BROKEN
```

Health anomalies increase risk and may trigger rollback.

---

## 25. Backoff and culprit isolation

Backoff must not randomly disable the “highest-risk” module only once. It must isolate likely causes.

### 25.1 Disable order

Default rollback order:

```text
1. Shadow DOM cosmetic cleanup observers
2. light-DOM transient cosmetic cleanup
3. feed/search cosmetic cleanup
4. data sanitizer paths added this session
5. config sanitizer
6. player sanitizer
7. YouTube-specific surrogate redirects
8. YouTube-specific block rules
9. all YouTube-specific modules
```

Immediate prompt rule:

```text
When anti-block prompt score crosses threshold:
  disable SHADOW_DOM_COSMETIC_CLEANUP immediately
  disable light-DOM cosmetic observers immediately
  stop repeated style/display toggles before other module isolation begins
```

### 25.2 Culprit isolation protocol

For a confirmed anti-block prompt or breakage:

```text
record active module set
enter BACKOFF
remove highest-risk group
observe health for N seconds
if prompt/breakage remains:
  remove next group
if health recovers:
  mark last removed group as suspect
  keep it disabled for current browser session
```

For local debugging, support binary isolation:

```text
disable half of risky modules
reload once if allowed
observe prompt/health
bisect until likely culprit group found
```

This should be available only in developer/debug mode because repeated reloads are disruptive.

---

## 26. Shadow mode

Shadow mode observes and records what would have been changed without applying page-state mutations. V4 distinguishes three shadow modes because some observation techniques are themselves detectable. Shadow mode must not imply "zero risk" unless it is purely passive.

Shadow-mode classes:

| Mode | Mechanism | Detection risk | Use |
| --- | --- | --- | --- |
| `PASSIVE_DOM_SHADOW` | Isolated-world DOM reads, local health checks, no main-world wrappers | Low | First-run safe observation, prompt/health monitoring. |
| `INSTRUMENTED_SHADOW` | Main-world fetch/XHR/config wrappers return original results but record shapes | Medium | Shape-confidence learning on known page types. |
| `OFFLINE_FIXTURE_SHADOW` | Recorded fixtures only, no live page instrumentation | None on page | CI, regression, sanitizer development. |

Shadow-mode selection table:

| Condition | Selected mode | Reason |
| --- | --- | --- |
| CI, local regression, sanitizer development, no live browser page | `OFFLINE_FIXTURE_SHADOW` | Zero page risk; fixture evidence should be preferred before live instrumentation. |
| `mainWorldAvailable == false` for this tab/session | `PASSIVE_DOM_SHADOW` | No main-world instrumentation is possible; isolate, observe DOM/health only, and keep DNR/critical-allow safeguards. |
| New install, no prior YouTube evidence | `PASSIVE_DOM_SHADOW` | Establish baseline health without page-visible wrappers. |
| Extension updated, browser updated, or YouTube shape cache expired | `PASSIVE_DOM_SHADOW` first, then `INSTRUMENTED_SHADOW` only after healthy baseline | Avoid immediately exposing wrappers after an environment change. |
| Top-level watch/search/browse page, LOW or MEDIUM risk, no recent prompt, shape confidence below activation threshold, user has not disabled instrumentation | `INSTRUMENTED_SHADOW` | Needed to learn response/config shape before sanitizer activation. |
| HIGH risk page, live/DVR page, embed without fixtures, nested YouTube frame, YouTube Music without fixtures | `PASSIVE_DOM_SHADOW` | Instrumented wrappers are too risky for under-tested contexts. |
| Anti-block prompt was seen in current session or previous N YouTube sessions | `PASSIVE_DOM_SHADOW` | Do not add detectable wrappers while in recovery. |
| Early accessor hooks requested but `hookRaceEvidence.earlyAccessorWinsLikely !== true` | `PASSIVE_DOM_SHADOW` or retroactive-only mode | Descriptor-changing accessors must not be installed when timing evidence says they are unlikely to win. |
| `sanitizerShapeConfidence` is already high and fixtures are current | No shadow mode required; active mode may run | Shadow is unnecessary unless health degrades. |
| Wrapper risk budget exceeded, wrapper timing anomaly detected, or `Function.prototype.toString`/descriptor probe suspected | `PASSIVE_DOM_SHADOW` | Reduce main-world interception surface. |

Escalation rule:

```text
PASSIVE_DOM_SHADOW may escalate to INSTRUMENTED_SHADOW only when:
  page health is stable for the baseline window
  no anti-block prompt is detected
  page type is fixture-covered
  frame context is top-level YouTube or explicitly supported embed
  wrapper-risk budget is available
```

De-escalation rule:

```text
INSTRUMENTED_SHADOW immediately drops to PASSIVE_DOM_SHADOW when:
  prompt score crosses threshold
  player health degrades
  wrapper anomaly is detected
  navigation enters unsupported page type
  performance budget is exceeded twice in one session
```

If shadow observation requires fetch/XHR/config wrappers, it must be recorded in hook-risk telemetry exactly like active interception. The difference is that instrumented shadow does not return modified bodies, objects, or headers. It still has wrapper detectability risk.

Use shadow mode when:

```text
new install
YouTube shape unknown
sanitizer confidence low
surrogate schema mismatch
after browser/extension update
after prompt detected
on live/DVR pages
on embeds without fixtures
```

Shadow output:

```text
which paths would be removed
which renderers would be removed
which rules would be installed
shape confidence
performance estimate
shadow mode class
wrapper/interception risk used for observation
headers that would be sanitized, key names or hashes only
```

Activation rule:

```text
Do not activate a sanitizer path by default until fixtures or shadow observations show safe shape compatibility.
```

---

## 27. Local telemetry

Telemetry must be local-only by default.

Record:

```text
pageType
frameContext
riskLevel
activeModules
installed YouTube rule IDs
surrogate IDs used
sanitizer paths fired
wrapper/interception points installed
response header keys observed or sanitized, key names/hashes only
hashes of removed key paths, not values
number of renderers removed by type
performance skips
health state transitions
prompt score and signal types
rollback actions
```

Do not record by default:

```text
account identity
cookies
auth headers
raw video title
raw search query
comments
watch history
full player response payload
full URLs with sensitive query parameters
```

Privacy-preserving sanitizer telemetry:

```text
hash("ytInitialData.contents.twoColumnBrowseResultsRenderer.tabs[].tabRenderer.content.richGridRenderer.contents[].richItemRenderer.content.adSlotRenderer")
count: 3
values: omitted
```

---

## 28. CSP and Trusted Types discipline

Main-world code must be CSP-aware.

Rules:

```text
Do not use innerHTML.
Do not inject inline script tags.
Do not create Trusted Types violations.
Do not modify prototypes broadly unless unavoidable and tested.
Do not expose extension internals on window.
Use closures and Symbols where possible.
Keep main-world script small.
Avoid noisy console logging outside debug mode.
```

When DOM changes are necessary:

```text
prefer style/class toggles through extension-inserted CSS from isolated world
avoid creating HTML strings
avoid removing major parent nodes
```

---

## 29. Regression gates and enforceable audits

The earlier “build should fail on broad selectors” requirement is now made concrete.

### 29.1 Cosmetic selector lint

Create:

```text
tools/check-youtube-cosmetic-safety.mjs
```

It rejects selectors containing:

```text
.style-scope
[class*="ad"]
[id*="ad"]
ytd-masthead
ytd-topbar
#container
#center
#start
#end
#guide-button
#logo
```

It also requires selector metadata:

```text
pageType
riskLevelAllowed
fixtureEvidence
rollbackTag
```

### 29.2 Sanitizer path lint

Create:

```text
tools/check-youtube-sanitizer-paths.mjs
```

It rejects unapproved mutations to protected fields:

```text
streamingData
videoDetails
captions
microformat
playabilityStatus
```

unless an explicit fixture waiver exists.

### 29.3 Web-accessible resource audit

Create:

```text
tools/check-youtube-web-accessible-resources.mjs
```

It requires every YouTube-specific web-accessible resource to have:

```text
purpose
owning surrogate
schema fixture
fingerprint
reason it must be web-accessible
```

### 29.4 Generic stealth conflict audit

Create:

```text
tools/check-youtube-generic-stealth-conflicts.mjs
```

It rejects:

```text
generic stealth redirect rules without YouTube excludedInitiatorDomains where DNR can express the exclusion
generic redirect rules that overlap YouTube-specific redirect rules without a priority fixture
generic redirect rules that can override YouTube critical allow rules
YouTube rules outside the reserved ID range
YouTube rules whose priority is not above the generic stealth priority ceiling
missing third-party initiator conflict fixtures for overlapping ad-serving domains
```

### 29.5 Shape-confidence audit

Create:

```text
tools/check-youtube-shape-confidence-fixtures.mjs
```

It requires:

```text
every sanitizer path has a fixture or remains shadow-only
every activated path has expected key/type assertions
every endpoint class has protected-field tests
confidence threshold constants are centralized, not scattered through code
```

### 29.6 YouTube network-priority safety audit

Create:

```text
tools/check-youtube-network-priority-safety.mjs
```

It rejects:

```text
non-YouTube-engine DNR rules matching YouTube requests with priority >= YOUTUBE_CRITICAL_ALLOW_PRIORITY
stock/imported/user compiled rules that overlap a critical YouTube endpoint without priority capping
external list rules compiled without ruleOrigin metadata
user rules whose compiled DNR priority exceeds YOUTUBE_NON_ENGINE_PRIORITY_CEILING for YouTube-sensitive endpoints
static bundled rulesets that cannot be capped and can override YouTube critical allow rules
missing diagnostic metadata for user/imported rule interference
```

Runtime diagnostic requirement:

```text
When a non-YouTube-engine rule is capped or conflicts with a critical YouTube endpoint, the logger/dashboard must be able to show:
  raw filter text or safe hash
  source list or user-filter source
  compiled DNR rule ID
  original requested priority
  capped priority
  affected YouTube endpoint class
  recommended action
```

---

### 29.7 Main-world CSP probe audit

The build/test suite must verify that the main-world bootstrap contains a bounded readiness probe and that all main-world-dependent modules are gated on `mainWorldAvailable`.

Required checks:

```text
youtube-smart-main emits readiness marker/event
youtube-smart-isolated times out safely if marker/event absent
missing marker disables accessors, fetch/XHR guards, config wrappers, LOCAL_COMPLETE, and instrumented shadow
missing marker does not disable safe DNR critical allows
```

### 29.8 Adaptive DNR budget audit

The rule-plan manager must be tested against budget pressure.

Required checks:

```text
critical allow reserve is allocated before optional rules
optional rules are rejected if total exceeds YOUTUBE_ADAPTIVE_RULE_BUDGET_MAX
shadow/experimental rules are removed before critical allows
critical install failure triggers PANIC and diagnostic telemetry
```

### 29.9 Shadow DOM observer audit

DOM tests must include open-shadow-root fixtures for player overlay and prompt-like UI.

Required checks:

```text
open player shadow root is observed when present
closed/unavailable shadow root falls back without throwing
observer root count cannot exceed configured cap
attachShadow is not patched in default mode
prompt detector consumes both light-DOM and open ShadowRoot queues
```

### 29.10 Hook-race telemetry audit

The early-hook module must not activate accessors without evidence that the hook can plausibly win the startup race.

Required checks:

```text
records whether early globals are already defined at probe time
records descriptor kind before any hook is installed
disables early accessors when passive observations show they usually lose
falls back to retroactive sanitizer or response guard when appropriate
disables all early hooks when mainWorldAvailable is false
```

## 30. Test strategy

### 30.1 Fixture corpus

```text
tests/youtube/fixtures/player-basic.json
tests/youtube/fixtures/player-preroll.json
tests/youtube/fixtures/player-midroll.json
tests/youtube/fixtures/watch-next-companion.json
tests/youtube/fixtures/browse-home-promoted.json
tests/youtube/fixtures/search-promoted.json
tests/youtube/fixtures/sidebar-promoted.json
tests/youtube/fixtures/shorts-promoted.json
tests/youtube/fixtures/embed-basic.json
tests/youtube/fixtures/live-dvr.json
```

### 30.2 Required sanitizer tests

```text
removes adPlacements
removes playerAds
removes adSlotRenderer from feed arrays
removes promotedContentRenderer from browse/search arrays
preserves streamingData
preserves videoDetails
preserves captions
preserves comments continuation data
preserves playlist data
preserves search result non-ad videos
is idempotent
skips unknown shapes safely
```

### 30.3 Required navigation tests

```text
home → watch
watch → watch
watch → search
search → watch
watch → Shorts
playlist navigation
back/forward navigation
full document back/forward reload from non-YouTube page
bfcache pageshow restore
```

### 30.4 Required DOM safety tests

```text
masthead remains visible
search box remains visible
guide button remains visible
comments remain visible
description remains visible
player controls remain visible
transient skip/countdown UI can be hidden without hiding controls
```

### 30.5 Required backoff tests

```text
prompt signal triggers rollback
playback stuck triggers rollback
cosmetic rollback happens before sanitizer rollback
culprit module is marked suspect
PANIC mode disables YouTube-specific modules
```

---

## 31. Implementation phases

### Phase 0 — Audits, registries, and immutable invariants

This phase must be completed before active YouTube ad suppression code is committed. Its purpose is to make later regressions difficult or impossible.

Deliverables:

```text
critical-youtube-endpoints.json
youtube-rule-priorities.ts
youtube-rule-authority.ts
youtube-shadow-mode-policy.ts
check-youtube-critical-endpoints.mjs
check-youtube-rule-authority.mjs
check-youtube-user-rule-priority-cap.mjs
check-youtube-shadow-mode-policy.mjs
check-youtube-generic-stealth-conflicts.mjs
check-youtube-wrapper-risk.mjs
check-youtube-mainworld-csp-probe.mjs
check-youtube-dnr-rule-budget.mjs
check-youtube-shadow-dom-observers.mjs
check-youtube-hook-race-telemetry.mjs
check-youtube-web-accessible-resources.mjs
minimal fixture loader
CI wiring for all YouTube architecture audits
```

Required invariants:

```text
YouTube critical allow rules outrank every non-engine rule.
User/imported/external network rules cannot exceed YouTube critical priorities on YouTube-sensitive requests.
Generic stealth rules cannot win over YouTube-specific rules.
Instrumented shadow cannot activate in high-risk contexts without an explicit policy waiver.
Main-world wrappers cannot be introduced without wrapper-risk metadata.
Main-world execution must be probed and must fail into DNR/isolated/passive-only degraded mode.
Adaptive YouTube DNR rules must satisfy the reserved rule-budget allocator.
Shadow DOM observation must follow root-count, throttle, and fallback rules.
Early accessor hooks cannot activate without hook-race evidence that they plausibly win.
No YouTube sanitizer path can activate without fixture or shadow-confidence evidence.
No YouTube cosmetic selector can be added without safety metadata and lint coverage.
```

Goal:

```text
Establish the safety rails before any active suppression exists.
```

### Phase 1 — Scaffolding and safe mode

Deliverables:

```text
youtube-types.ts
youtube-page-context.ts
youtube-risk.ts
youtube-shape-confidence.ts
youtube-navigation.ts
settings keys
rule ID ranges
shadow mode state machine
safe-mode startup path
page-start and full-navigation reset path
lint skeletons
```

Goal:

```text
No real aggressive suppression; establish lifecycle and safety gates.
```

### Phase 2 — Rule-plan manager and surrogate integration

Deliverables:

```text
youtube-dnr-plan.ts
youtube-surrogates.ts
YouTube rule precedence model
DNR excludedInitiatorDomains enforcement for generic stealth
generic stealth conflict audit
safe surrogate fixtures
```

Goal:

```text
Install only low-risk YouTube-specific session rules and prevent generic conflict.
```

### Phase 3 — Generalized data sanitizer

Deliverables:

```text
youtube-player-sanitizer.ts
youtube-data-sanitizer.ts
youtube-config-sanitizer.ts
fixture corpus
idempotence tests
protected-field lint
```

Goal:

```text
Suppress ad data before render/playback while preserving non-ad state.
```

### Phase 4 — Prompt detector and health monitor

Deliverables:

```text
youtube-prompt-detector.ts
youtube-health.ts
youtube-backoff.ts
youtube-beacon-policy.ts
local telemetry
prompt scoring tests
rollback tests
```

Goal:

```text
Make the engine self-protecting when YouTube changes behavior.
```

### Phase 5 — Cosmetic cleanup and transient UI cleanup

Deliverables:

```text
youtube-dom-cleanup.ts
selector metadata
cosmetic safety lint
DOM regression tests
skip/countdown handling
```

Goal:

```text
Clean visible leftovers narrowly without damaging YouTube layout.
```

### Phase 6 — Hardening and release gate

Deliverables:

```text
Playwright smoke tests
performance benchmarks
web-accessible-resource audit
store-compliance audit
debug telemetry viewer
release certificate update
```

Goal:

```text
Release only after playback, navigation, prompt/backoff, and DOM safety tests pass.
```

---

## 32. Acceptance criteria

A release candidate must satisfy:

```text
YouTube home loads
watch page loads
video playback starts
currentTime advances
comments remain visible
description remains visible
search works
SPA navigation works
Shorts does not break
embed mode does not break parent pages
masthead/search/guide remain visible
no broad YouTube cosmetic selectors
no remote executable code
no sanitizer mutation of protected fields without fixture waiver
all risky modules independently disableable
auto-backoff works
local telemetry identifies likely culprit module
generic stealth rules exclude YouTube initiators by DNR condition
shape confidence thresholds gate sanitizer activation
early accessor hooks are disabled or marked suspect after prompt/breakage
MutationObserver cleanup is scoped and throttled
critical endpoint registry exists and is covered by tests
non-engine YouTube-affecting network rules are priority-capped
shadow-mode selection table is enforced by tests
Phase 0 audits pass before suppression modules are enabled
```

Detection-neutral acceptance criteria:

```text
ad subsystem contracts are preserved where page-visible
ad opportunities resolve empty/unavailable rather than broken
surrogates fail open when outdated
beacon strategy is explicit, non-forging, and LOCAL_COMPLETE is experimental/fail-open
anti-block prompt triggers rollback, not blind escalation
```

---

## 33. Final design principle

The V6 engine should not be built as:

```text
block everything ad-looking
hide everything ad-looking
fight anti-block prompts after the fact
```

It should be built as:

```text
preserve YouTube’s expected local contracts
neutralize ad payloads before render/playback
use local surrogates where missing resources would be detectable
hide only narrow leftovers
monitor health continuously
rollback before the user is exposed to breakage
```

That is the difference between an ordinary YouTube ad blocker and a detection-neutral YouTube suppression engine.

---

## 34. V4 implementation clarifications

V4 closes the final pre-implementation gaps with these binding clarifications:

```text
All main-world wrappers are treated as detectable-risk interception points.
Shadow mode is not automatically safe; instrumented shadow carries wrapper risk.
DNR excludedInitiatorDomains is necessary but insufficient for YouTube conflict control.
YouTube-specific rules must outrank generic stealth rules by priority.
Full document navigation always re-enters the page-start initialization path.
Response headers are observed by default and sanitized only with same-origin fixture evidence.
```

No implementation should proceed until the following constants and audits exist:

```text
GENERIC_STEALTH_PRIORITY_MAX
YOUTUBE_SAFE_BLOCK_PRIORITY
YOUTUBE_SURROGATE_PRIORITY
YOUTUBE_CRITICAL_ALLOW_PRIORITY
check-youtube-generic-stealth-conflicts.mjs
check-youtube-wrapper-risk.mjs
check-youtube-header-policy.mjs
```

Additional V4 test fixtures:

```text
fetch wrapper returns original behavior for unknown endpoints
XHR wrapper returns original behavior for unknown endpoints
config wrapper fail-open on unknown keys and arguments
instrumented shadow records wrapper risk
third-party ad-script initiator conflict case
YouTube rule priority beats generic stealth redirect
critical YouTube allow priority beats all YouTube redirects/blocks
full document navigation resets PageContext and DOM roots
same-origin response header observation does not store values
header sanitizer remains disabled unless fixture-proven
```

## 35. V5 implementation clarifications

V5 adds two final implementation requirements before coding should begin.

### 35.1 Non-engine network rules cannot override YouTube critical protections

User filters, imported lists, bundled stock lists, temporary logger filters, and any non-YouTube-engine network rules must be compiled through the same priority-safety layer. A raw filter cannot be allowed to become a higher-priority DNR rule merely because it came from `My filters`, an imported URL, or an external list.

The engine must treat YouTube critical allow rules as reserved infrastructure. User intent is still respected, but not by allowing accidental broad filters to break the player and expose the blocker. Instead, conflicting user/imported rules are capped, warned, diagnosed, or temporarily disabled for YouTube after explicit review.

### 35.2 Shadow mode is selected by risk, not convenience

`INSTRUMENTED_SHADOW` is useful but not harmless. It uses the same class of page-visible wrappers as active interception, only without mutating returned data. Therefore the default shadow mode for unknown, high-risk, post-prompt, live/DVR, and unsupported frame contexts is `PASSIVE_DOM_SHADOW`. Instrumented shadow is reserved for fixture-covered low/medium-risk contexts where shape learning is necessary and page health is stable.

---

## 36. V6 implementation-readiness clarifications

V6 adds no new ad-blocking mechanism because V5 already closed the structural design gaps. V6 locks the implementation order.

### 36.1 Build audits first

Implementation must begin with the invariants that protect the architecture:

```text
critical endpoint registry
YouTube priority constants
rule-authority compiler
user/imported-rule priority cap
shadow-mode decision policy
wrapper-risk metadata schema
generic stealth conflict audit
web-accessible-resource audit
CI gate wiring
```

No sanitizer, surrogate, cosmetic cleanup, or active fetch/XHR wrapper should be enabled until these checks exist.

### 36.2 Critical endpoint registry is the first source of truth

The registry must identify YouTube endpoints and resources that the engine must not break:

```text
player bootstrap scripts
core player JSON endpoints
watch and next data endpoints
identity/account endpoints
playback media endpoints
live/DVR endpoints
embed player essentials
navigation essentials
```

Every rule that touches one of these endpoints must be classified as one of:

```text
CRITICAL_ALLOW
SAFE_SURROGATE
SAFE_BLOCK
OBSERVE_ONLY
UNKNOWN_ALLOW
```

Unknown critical-adjacent endpoints must default to `UNKNOWN_ALLOW` until fixture evidence exists.

### 36.3 Safe-mode scaffolding precedes suppression

The first runnable version should not try to suppress ads aggressively. It should prove that the engine can:

```text
recognize YouTube page/frame context
choose the correct shadow mode
install no-conflict rule plans
cap non-engine user/imported filters
record local health events
reset correctly on SPA and full-document navigation
fail open when confidence is low
```

Only after that baseline is stable should the implementation add sanitizer paths, local surrogates, and cosmetic cleanup.

### 36.4 V6 release gate

A branch implementing the YouTube engine is not ready for functional testing unless the following command group passes:

```text
npm run check:youtube-critical-endpoints
npm run check:youtube-rule-authority
npm run check:youtube-user-rule-priority-cap
npm run check:youtube-shadow-mode-policy
npm run check:youtube-generic-stealth-conflicts
npm run check:youtube-wrapper-risk
npm run check:youtube-web-accessible-resources
npm run test:youtube-fixtures
```

These command names are normative placeholders. The exact script names may change, but the checks themselves are mandatory.

### 36.5 Implementation priority

The implementation order is:

```text
1. Critical endpoint registry
2. Priority constants and rule-authority compiler
3. User/imported-rule priority cap
4. Generic stealth conflict audit
5. Shadow-mode decision policy and tests
6. PageContext and navigation lifecycle
7. Health/telemetry skeleton
8. Safe DNR rule plan
9. Surrogate schema validation
10. Sanitizer fixture corpus
11. Active sanitizer paths
12. Cosmetic cleanup
13. Prompt detector and rollback refinement
```

This order is binding because it preserves the core design principle: safety and detection-neutral invariants are built before ad suppression power.

---

## 37. V7 final implementation-contract closure

V7 keeps the V6 architecture intact and adds the final implementation contract needed to make the specification directly actionable in the repository. This section does not introduce a new blocking mechanism. It closes the remaining execution ambiguity by converting the V6 readiness plan into concrete work packages, ownership boundaries, and completion gates.

### 37.1 V7 rating disposition

The V6 document is rated **9.96/10** as an architecture specification. It has no substantive design gap, but it still leaves a small amount of implementation ambiguity because some release-gate commands are normative placeholders and some repository integration steps are described as order rather than as work packages.

V7 resolves this by adding:

```text
implementation work packages
repository integration map
module definition-of-done gates
failure triage rules
change-control rules for future YouTube drift
```

With these additions, the document is rated **10.00/10** as the controlling implementation baseline.

### 37.2 Repository integration map

The implementation must integrate with the current uBlockResurrected structure using the following ownership boundaries.

```text
src/js/youtube/
  Owns YouTube-specific policy, registry, sanitizers, shadow mode, health, backoff, and tests.

src/js/mv3/
  Owns shared MV3 rule types, shared stealth-surrogate conventions, and any reusable DNR compiler primitives.

platform/chromium/js/sw.js
  Owns runtime wiring only. It must not become the home of YouTube-specific policy logic.

platform/chromium/js/youtube-smart-main.js
  Generated main-world bundle. It must be small, audited, and generated from src/js/youtube.

platform/chromium/js/youtube-smart-isolated.js
  Generated isolated-world bundle. It owns message bridge, health observation, DOM-safe telemetry, and rollback reporting.

platform/chromium/dnr/youtube-static.rules.json
  Generated static YouTube rules. It must be reproducible from the registry/compiler.

platform/chromium/web_accessible_resources/youtube/
  Owns only allowlisted local surrogates. No unreferenced resource may be exposed.

tests/youtube/
  Owns fixtures, sanitizer tests, rule-authority tests, shadow-mode tests, navigation tests, and Playwright smoke tests.

tools/check-youtube-*.mjs
  Owns build-time audits and release gates.
```

Policy must remain in `src/js/youtube/*`; generated Chromium files must not be edited manually except as build outputs.

### 37.3 Mandatory Phase 0 work packages

Phase 0 is complete only when the following work packages exist and pass in CI.

| Work package | Required artifacts | Completion gate |
| --- | --- | --- |
| Critical endpoint registry | `src/js/youtube/youtube-critical-endpoints.ts` | Registry classifies critical, ad-adjacent, unknown, and safe endpoints; unknown defaults to allow. |
| Rule priority constants | `src/js/youtube/youtube-rule-priorities.ts` | YouTube critical priorities outrank generic stealth and non-engine rules. |
| Rule-authority compiler | `src/js/youtube/youtube-rule-authority.ts` | Every YouTube-touching rule has source, authority, risk, priority, and conflict disposition. |
| User/imported priority cap | Compiler integration + tests | Non-engine rules cannot outrank YouTube critical allow rules on YouTube-sensitive requests. |
| Generic stealth conflict audit | `tools/check-youtube-generic-stealth-conflicts.mjs` | Generic stealth rules cannot override or conflict with YouTube-specific rule plans. |
| Shadow-mode policy | `src/js/youtube/youtube-shadow-mode.ts` | Decision table is executable and tested. |
| Wrapper-risk registry | `src/js/youtube/youtube-wrapper-risk.ts` | Every main-world wrapper/hook has risk metadata, activation mode, rollback owner, and health signal. |
| Web-accessible-resource audit | `tools/check-youtube-web-accessible-resources.mjs` | Every exposed YouTube resource is referenced, justified, and fixture-backed. |
| Navigation lifecycle skeleton | `src/js/youtube/youtube-lifecycle.ts` | Full-load, SPA, back/forward, embed, and unsupported contexts reinitialize safely. |

No active sanitizer path, local beacon completion, cosmetic cleanup, or aggressive rule may be enabled before Phase 0 is complete.

### 37.4 Module definition of done

Each module must satisfy its local definition of done before it can be enabled by default.

#### Critical endpoint registry

```text
all entries have classification
all entries have risk level
all unknown critical-adjacent entries fail open
all registry changes are reviewed by fixture or rationale
```

#### Rule-authority compiler

```text
all rule sources are tagged
all priorities are normalized
all YouTube-critical conflicts are resolved deterministically
all non-engine rules are capped or diagnosed
all generated DNR output is reproducible
```

#### Shadow-mode state machine

```text
mode is selected by page type, risk level, prompt history, shape confidence, and update state
instrumented shadow is blocked in high-risk contexts unless explicitly justified
shadow mode never mutates responses or DOM
shadow telemetry is local-only
```

#### Main-world wrapper layer

```text
each wrapper has a risk entry
each wrapper has a no-wrapper fallback
each wrapper participates in health/backoff
each wrapper has Function.toString/descriptor detectability acknowledged
no wrapper is enabled solely for convenience
```

#### Sanitizer

```text
all active paths are fixture-backed
sanitizer is idempotent
streamingData, videoDetails, captions, account/auth, and playback media are preserved unless a fixture explicitly proves a narrower action
shape confidence threshold is met before activation
sanitizer fails open on drift
```

#### Surrogates

```text
all surrogates are local and packaged
all surrogates are schema-validated
all surrogates fail open when outdated
all exposed surrogate resources are allowlisted
no surrogate fabricates monetization or impression events
```

#### Cosmetic cleanup

```text
all selectors are allowlisted
all selectors are page-type scoped
all player-transient cleanup is throttled
masthead/search/navigation protections pass
cleanup disables first during rollback
```

#### Health and backoff

```text
health monitor detects playback, prompt, UI, navigation, and module-risk anomalies
rollback order is deterministic
culprit isolation records module and path hashes
panic mode disables active intervention for the tab/session
recovery is fail-open, not escalation-first
```

### 37.5 Failure triage rules

When breakage or prompt detection occurs, the engine must classify the suspected cause before changing state.

```text
USER_RULE_INTERFERENCE
GENERIC_STEALTH_CONFLICT
SANITIZER_DRIFT
SURROGATE_DRIFT
WRAPPER_DETECTED_OR_UNSTABLE
COSMETIC_BREAKAGE
NAVIGATION_LIFECYCLE_MISS
UNKNOWN_YOUTUBE_CHANGE
```

Triage outcomes:

```text
USER_RULE_INTERFERENCE       → show local diagnostic and cap/disable for YouTube only
GENERIC_STEALTH_CONFLICT     → disable generic rule for YouTube-sensitive context
SANITIZER_DRIFT              → lower shape confidence and disable affected paths
SURROGATE_DRIFT              → fail open to real endpoint and mark surrogate stale
WRAPPER_DETECTED_OR_UNSTABLE → disable instrumented mode and return to passive shadow
COSMETIC_BREAKAGE            → remove cosmetic cleanup first
NAVIGATION_LIFECYCLE_MISS    → reinitialize PageContext and reset tab-local state
UNKNOWN_YOUTUBE_CHANGE       → enter safe mode and require fixture update before reactivation
```

The engine must never respond to an unknown failure by increasing aggression.

### 37.6 Change-control rule for future YouTube drift

Any future change to YouTube-specific behavior must be submitted as one of the following change types:

```text
REGISTRY_UPDATE
RULE_AUTHORITY_UPDATE
SANITIZER_PATH_UPDATE
SURROGATE_SCHEMA_UPDATE
COSMETIC_SELECTOR_UPDATE
WRAPPER_RISK_UPDATE
SHADOW_POLICY_UPDATE
BACKOFF_POLICY_UPDATE
```

Each change type has mandatory evidence:

| Change type | Required evidence |
| --- | --- |
| `REGISTRY_UPDATE` | endpoint classification rationale and conflict audit pass |
| `RULE_AUTHORITY_UPDATE` | priority audit and user/imported cap audit pass |
| `SANITIZER_PATH_UPDATE` | before/after fixture and preservation test |
| `SURROGATE_SCHEMA_UPDATE` | schema validation fixture and fail-open test |
| `COSMETIC_SELECTOR_UPDATE` | DOM safety fixture and masthead/search protection pass |
| `WRAPPER_RISK_UPDATE` | risk metadata and rollback test |
| `SHADOW_POLICY_UPDATE` | decision-table test and high-risk non-instrumentation check |
| `BACKOFF_POLICY_UPDATE` | culprit-isolation and panic-mode tests |

No YouTube drift fix may be merged as an unclassified ad-hoc patch.

### 37.7 Final 10.00/10 acceptance gate

The architecture is implementation-ready only if the following statements are all true:

```text
safety invariants precede suppression
all YouTube-touching rules pass authority control
critical endpoints cannot be overridden by non-engine rules
generic stealth cannot outrank YouTube-specific policy
main-world interception risk is explicit and reversible
shadow mode is risk-selected and not assumed harmless
sanitizers are fixture-backed and fail open
surrogates are schema-validated and fail open
cosmetic cleanup is narrow, throttled, and reversible
health/backoff never escalates unknown failures
telemetry is local, privacy-preserving, and diagnostic enough to isolate culprit modules
future drift changes require classified evidence
main-world execution is probed and degrades safely when unavailable
open Shadow DOM player/prompt roots are observed within budget
adaptive DNR rules are budgeted with critical slots reserved
early accessor hooks require hook-race evidence before activation
```

V8 satisfies these conditions and is therefore the final architecture baseline for implementation planning.



## 38. V8 implementation-safety closure

V8 closes the final implementation-safety assumptions discovered after the V7 review. These are binding requirements, not optional notes.

### 38.1 Main-world execution is a probed capability

Main-world execution is not assumed. The engine must prove that the main-world bootstrap ran before enabling any main-world-dependent functionality. If the proof is missing, the tab/session enters degraded detection-neutral mode rather than silent partial operation.

```text
main-world unavailable -> DNR + isolated health + passive DOM only
main-world restored on later navigation -> re-evaluate from page-start path
main-world formerly available but now missing -> UNKNOWN_YOUTUBE_CHANGE
```

### 38.2 Shadow DOM visibility is part of DOM safety

Player/prompt DOM safety tests must include open Shadow DOM roots. Failure to observe a closed shadow root is not treated as no prompt; it is treated as reduced visibility that raises prompt uncertainty when playback is unhealthy.

### 38.3 Rule capacity is a safety invariant

The YouTube engine cannot install optional suppression rules unless the critical DNR reserve remains available. Rule capacity pressure must reduce ad-suppression ambition before it reduces protection of playback-critical endpoints.

### 38.4 Early hooks require empirical timing evidence

Early accessors are not enabled merely because they are theoretically useful. They require hook-race telemetry showing that they can plausibly observe assignments before YouTube consumes them. If that evidence is absent, retroactive sanitization and narrow response guards are preferred.

### 38.5 V8 readiness statement

After V8, implementation can begin with Phase 0 audits and registries. No suppression module should be implemented before the following files/checks exist:

```text
critical-youtube-endpoints.json
youtube-rule-priorities.ts
youtube-rule-budget.ts
youtube-mainworld-probe.ts
youtube-hook-race-telemetry.ts
youtube-shadow-dom-observer-policy.ts
check-youtube-mainworld-csp-probe.mjs
check-youtube-dnr-rule-budget.mjs
check-youtube-shadow-dom-observers.mjs
check-youtube-hook-race-telemetry.mjs
```

These additions make CSP execution, Shadow DOM visibility, DNR capacity, and hook timing explicit runtime conditions rather than implicit assumptions.

## 39. V11 service-worker persistence and restoration closure

V11 closes the remaining production-readiness gap: the service worker lifecycle. In Chrome MV3, the service worker must be treated as disposable. It may be terminated while YouTube tabs remain open and while DNR rules remain installed. Therefore, the YouTube engine cannot rely on in-memory service-worker state for any safety decision that must survive a restart.

These requirements are binding for Phase 0.

### 39.1 Persistence invariant

The engine must be able to reconstruct its detection-neutral safety posture after a service-worker restart without re-enabling a risky rule, surrogate, sanitizer class, wrapper class, or beacon mode that had already been disabled for the current browser session.

The core invariant is:

```text
service worker restart must not increase aggression
service worker restart must not clear panic/backoff decisions prematurely
service worker restart must not reinstall unverified YouTube rules blindly
service worker restart must not forget user/imported-rule interference diagnostics
```

If persisted state is unavailable, malformed, or stale, the engine must enter the safest conservative state:

```text
SAFE_CONSERVATIVE
PASSIVE_DOM_SHADOW
DNR critical allows only
no optional surrogates
no instrumented main-world wrappers
no LOCAL_COMPLETE beacons
```

### 39.2 Session-persisted state schema

Use `chrome.storage.session` for state that should survive service-worker restarts but not browser restarts. If `chrome.storage.session` is unavailable, use `chrome.storage.local` only for explicitly session-safe state with a `sessionEpoch` and expiry timestamp so stale state is not accidentally reused across browser sessions.

Persist only local diagnostic state. Do not persist user identity, watch history, search queries, video titles, cookies, authorization headers, comments, or full response bodies.

Required storage key:

```text
ubrYouTubeSessionStateV1
```

Required schema:

```text
YouTubeSessionStateV1 {
  schemaVersion: 1
  sessionEpoch: string
  updatedAt: number

  globalRulePlanMode: "SAFE_CONSERVATIVE" | "BALANCED" | "PANIC"
  lastAggregateRiskLevel: "LOW" | "MEDIUM" | "HIGH" | "PANIC"

  suspectModuleClasses: string[]
  disabledSurrogateEndpoints: string[]
  disabledSanitizerClasses: string[]
  disabledWrapperClasses: string[]
  disabledBeaconModes: string[]

  installedYouTubeRuleIDs: number[]
  criticalRuleInstallVerified: boolean
  lastRulePlanHash: string

  panicSessionActive: boolean
  panicReason?: string
  panicTabIds: number[]

  userRuleInterference: {
    ruleId: number | string
    source: "user" | "imported" | "generic" | "unknown"
    affectedEndpointClass: string
    actionTaken: "capped" | "disabled_for_youtube" | "manual_review_required"
  }[]

  tabSnapshots: {
    tabId: number
    url: string
    pageType: string
    riskLevel: "LOW" | "MEDIUM" | "HIGH" | "PANIC"
    mode: string
    mainWorldAvailable: boolean | "unknown"
    lastSeenAt: number
  }[]
}
```

`tabSnapshots` are hints, not trusted truth. On restoration, every tab snapshot must be checked against currently open tabs. Closed tabs must be discarded. Reused or invalid tab IDs must not inherit stale panic state unless the current tab URL still matches a YouTube page.

### 39.3 State write policy

The service worker must persist state whenever one of the following changes occurs:

```text
global rule-plan mode changes
aggregate risk level changes
PANIC or BACKOFF is entered
module class is disabled for the session
surrogate endpoint is disabled for the session
sanitizer/wrapper/beacon mode is disabled for the session
critical rule installation succeeds or fails
user/imported/generic rule interference is detected
YouTube tab PageContext changes materially
mainWorldAvailable changes
YouTube tab closes
```

Writes must be debounced to avoid excessive storage churn:

```text
normal debounce: 500 ms
panic/backoff write: immediate
critical-rule failure write: immediate
tab removal write: immediate
```

A failed persistence write is a safety signal. If persistence fails during `PANIC`, critical-rule failure, or wrapper-disable events, the engine must remain in conservative mode for the current service-worker lifetime and record `PERSISTENCE_FAILURE` in local telemetry.

### 39.4 Startup restoration protocol

On every service-worker startup, before installing or changing YouTube DNR rules, run the restoration protocol:

```text
1. Load ubrYouTubeSessionStateV1 from chrome.storage.session.
2. Validate schemaVersion, sessionEpoch, updatedAt, and rule-plan hash.
3. Query open tabs with chrome.tabs.query({}).
4. Identify current YouTube tabs by URL.
5. Discard persisted tab snapshots for tabs that are no longer open or no longer YouTube.
6. Build minimal URL-based PageContext for each current YouTube tab.
7. Merge persisted tab risk/mode only when tabId and URL still match.
8. Restore session-wide disabled module classes and suspect endpoints.
9. Recompute the global rule plan from current tabs plus persisted session restrictions.
10. Verify installedYouTubeRuleIDs against actual DNR session/dynamic rules.
11. If critical rule IDs are missing or mismatched, reinstall critical allows first.
12. If critical reinstall fails, enter PANIC and remove optional YouTube rules.
13. Send reconnect messages to content scripts in current YouTube tabs.
14. Request fresh PageContext, mainWorldAvailable, health, and prompt status from each tab.
15. Persist the reconstructed session state.
```



Mandatory no-context purge during startup:

```text
if openTopLevelYouTubeTabs.length === 0:
    set globalRulePlanMode = SAFE_CONSERVATIVE
    remove every YouTube optional session/dynamic rule
    keep only critical allow rules listed in the current critical endpoint registry
    clear persisted optional installedYouTubeRuleIDs
    expire top-level-only suspect optional rules that no longer apply
    persist the critical-only state
```

Registered embeds are then evaluated under `EMBED_CONSERVATIVE`; they cannot keep top-level-only optional rules alive.

The restoration path must never assume that absence of a content-script response means the tab is healthy. Missing content-script response means:

```text
visibility unknown -> raise uncertainty -> conservative global plan
```

### 39.5 DNR reconciliation after restart

DNR session/dynamic rules can outlive the in-memory service-worker aggregator. Therefore, startup must reconcile persisted intent with actual installed rules.

Required checks:

```text
all installed YouTube critical allow rules are present
all optional YouTube rules belong to the active global plan
no stale optional rule remains from a previous PANIC/BACKOFF state
no generic/user/imported rule outranks critical YouTube allow rules
rule count remains inside the YouTube budget reserve
rule priority constants match the compiled registry
```

If stale optional rules are present after restart:

```text
remove stale optional rules
keep/reinstall critical allows
persist corrected installedYouTubeRuleIDs
record DNR_RECONCILIATION_STALE_RULE_REMOVED
```

If critical rules cannot be verified:

```text
remove optional YouTube rules
enter PANIC
persist panicSessionActive = true
record CRITICAL_RULE_RESTORE_FAILURE
```



### 39.5.1 Extension update and registry-version reconciliation

On extension install/update, browser update, or registry-version mismatch, the YouTube rule planner must not trust persisted rule IDs, priorities, or aggregate mode.

Required trigger sources:

```text
chrome.runtime.onInstalled with reason == "install" or "update"
manifest version changed
criticalEndpointRegistryVersion changed
rulePrioritySchemaVersion changed
youtubeRuleIdRangeVersion changed
surrogateSchemaVersion changed
```

Required behavior:

```text
1. Mark shape confidence and rule-plan confidence stale.
2. Remove all YouTube optional session/dynamic rules.
3. Reinstall or verify only current critical allow rules.
4. Reset globalRulePlanMode = SAFE_CONSERVATIVE.
5. Clear persisted optional installedYouTubeRuleIDs and optional rule-plan hash.
6. Persist the new registryVersion/manifestVersion/rulePrioritySchemaVersion.
7. Require Phase-0 audits before any optional YouTube rule class can be re-enabled.
8. Broadcast ENGINE_UPDATE_RESET to all known YouTube content-script ports and all open YouTube frames/tabs that can be reached.
9. Require reset acknowledgements before any active per-tab module can resume.
```

#### 39.5.1.1 Content-script update reset protocol

DNR reconciliation alone is not enough after an extension update, registry-version change, sanitizer-schema change, or bootstrap-version change. Content scripts already running in open YouTube tabs may still hold stale in-memory state. The service worker must force those tabs back to a conservative baseline.

Trigger conditions:

```text
manifestVersion changed
criticalEndpointRegistryVersion changed
sanitizerSchemaVersion changed
surrogateSchemaVersion changed
bootstrapVersion changed
wrapperRiskSchemaVersion changed
cosmeticSelectorRegistryVersion changed
rulePrioritySchemaVersion changed
```

Service-worker action:

```text
for each known YouTube top-level tab, embed frame registration, and active content-script port:
    send ENGINE_UPDATE_RESET with:
        newVersionVector
        resetReason
        resetDeadline
        requiredAck = true

mark tab/module state as UPDATE_RESET_PENDING
block active sanitizer/wrapper/cosmetic enablement until ack received
```

Content-script action on `ENGINE_UPDATE_RESET`:

```text
1. Send `UBR_DISABLE_MAINWORLD_WRAPPERS` to the main-world bootstrap for all active accessors, fetch/XHR guards, config wrappers, LOCAL_COMPLETE handlers, and INSTRUMENTED_SHADOW hooks. Wait for `UBR_DISABLE_MAINWORLD_WRAPPERS_ACK`; if no acknowledgement arrives before the reset deadline, mark the tab `WRAPPER_RESTORE_FAILED` and keep the global plan conservative.
2. Clear active sanitizer classes and pending response mutations.
3. Clear light-DOM and Shadow-DOM cosmetic observers.
4. Drop sanitizerShapeConfidence to fixture baseline, capped at 60, or lower if the new registry requires it.
5. Clear per-path consecutive-observation counters and drift assumptions.
6. Re-enter PASSIVE_DOM_SHADOW.
7. Record CONTENT_SCRIPT_UPDATE_RESET_APPLIED.
8. Send ENGINE_UPDATE_RESET_ACK with current version vector and activeModuleState = passive-only.
```

Re-enable rule:

```text
No active per-tab module may be re-enabled until:
    service worker has completed DNR reconciliation
    content script has acknowledged ENGINE_UPDATE_RESET
    main-world readiness has been reprobed
    shape confidence has been re-earned under the new version vector
    health baseline window has completed without prompt/breakage signals
```

Startup restoration must also query content-script version state:

```text
service worker reconnects to existing YouTube content script
content script reports contentScriptVersionVector
if contentScriptVersionVector != serviceWorkerVersionVector:
    send ENGINE_UPDATE_RESET
else:
    request current passive health/page context
```

If a content script does not acknowledge the reset, treat that tab/frame as unknown-risk and keep the global plan conservative.

If stale optional rules from an older version cannot be removed, enter `PANIC`, disable active YouTube suppression modules, and record `DNR_UPDATE_RECONCILIATION_FAILED`.

### 39.6 Tab tracking and state updates

The service worker must learn about YouTube tab lifecycle changes through multiple channels, because no single event is sufficient.

Required listeners:

```text
chrome.tabs.onUpdated
chrome.tabs.onRemoved
chrome.tabs.onActivated
chrome.webNavigation.onCommitted       where available
chrome.webNavigation.onHistoryStateUpdated where available
chrome.runtime.onConnect from YouTube content scripts
chrome.runtime.onMessage health/prompt/context reports
```

Tracking rules:

```text
tabs.onUpdated with URL change -> rebuild minimal PageContext
tabs.onRemoved -> remove tab snapshot and recompute aggregate plan
tabs.onActivated -> request fresh health/context opportunistically
webNavigation committed -> treat as full-document navigation path
webNavigation historyStateUpdated -> treat as SPA navigation path
content-script connect -> mark tab visible to engine
content-script heartbeat timeout -> mark tab visibility unknown, not healthy
```

The global rule-plan aggregator must recompute after every material tab-state change.


Hidden YouTube frame tracking:

```text
content scripts in YouTube iframes on third-party pages must register with:
  tabId
  frameId
  frameUrl
  parentOriginKnown
  isTopFrame = false
  pageType = EMBED or NESTED_EMBED
  mainWorldAvailable if probed
  health state if available

service worker stores these under registeredEmbedContexts and includes them in global DNR aggregation.
```

Expiry:

```text
remove registered embed context when:
  frame sends unregister
  tab is removed
  frame heartbeat expires
  tab URL changes to a new top-level document
```

If embed state is unknown, the global rule planner must choose the conservative interpretation rather than keeping watch-page optional rules active.

### 39.7 Full restoration versus SPA restoration

The engine distinguishes three lifecycle paths:

```text
SERVICE_WORKER_RESTART
FULL_DOCUMENT_NAVIGATION
YOUTUBE_SPA_NAVIGATION
```

`SERVICE_WORKER_RESTART` restores session restrictions first, then reconstructs tabs.

`FULL_DOCUMENT_NAVIGATION` discards tab-local main-world state and reruns page-start probes.

`YOUTUBE_SPA_NAVIGATION` preserves service-worker session restrictions but recomputes PageContext and sanitizer shape confidence for the new YouTube route.

No lifecycle path may clear session-wide disabled modules unless the browser session changes or the user explicitly resets YouTube engine state.

### 39.8 Session bans and expiry

Session-wide bans are used when a module class is suspected of causing detection or breakage.

Examples:

```text
LOCAL_COMPLETE disabled for session
specific surrogate endpoint disabled for session
instrumented shadow disabled for session
early accessor hooks disabled for watch pages
specific sanitizer path class disabled for session
```

Expiry rules:

```text
session bans survive service-worker restart
session bans end at browser session end
manual user reset clears session bans
fixture update may clear a class-specific ban only after audit pass
```

If `chrome.storage.local` fallback is used, every ban must include:

```text
sessionEpoch
createdAt
expiresAt
reason
```

The engine must ignore stale fallback bans whose `sessionEpoch` does not match the current browser session.

### 39.9 Content-script reconnection contract

Existing YouTube tabs may contain content scripts after service-worker restart, but the service worker may not know their current state. Therefore, the content script must respond to a reconnection request:

```text
YOUTUBE_ENGINE_RECONNECT
```

Expected response:

```text
YouTubeContentState {
  tabId
  url
  frameContext
  pageType
  mainWorldAvailable
  shadowMode
  activeWrappers
  activeSanitizerClasses
  lastHealth
  antiBlockPromptScore
  hookRaceTelemetrySummary
  shapeConfidenceSummary
}
```

If the content script does not respond, the service worker must not assume success. It must keep the tab in a conservative state until the next navigation or successful heartbeat.

### 39.10 Persistence privacy rules

Persisted session state must be intentionally low-information.

Allowed:

```text
module class names
endpoint class names
rule IDs
risk levels
mode names
hashes of key paths
local diagnostic reason codes
YouTube URL origin/path class, not full query strings
```

Disallowed:

```text
video titles
channel names
search queries
comments
full player responses
full browse responses
cookies
authorization headers
account identifiers
raw beacon payloads
```

Tab URL persistence must strip query parameters unless the route type requires them for page classification. For watch URLs, store only:

```text
origin
pathname
pageType = WATCH
```

The video ID should not be persisted unless the user has explicitly enabled a local debug mode.

### 39.11 Phase 0 persistence files and audits

Phase 0 must add these implementation units before active suppression:

```text
src/js/youtube/youtube-session-state.ts
src/js/youtube/youtube-tab-tracker.ts
src/js/youtube/youtube-rule-reconciler.ts
src/js/youtube/youtube-sw-restore.ts
src/js/youtube/youtube-content-reconnect.ts

tests/youtube/session-state.spec.ts
tests/youtube/tab-tracker.spec.ts
tests/youtube/sw-restore.spec.ts
tests/youtube/rule-reconciler.spec.ts
tests/youtube/content-reconnect.spec.ts

tools/check-youtube-session-state-schema.mjs
tools/check-youtube-restart-reconciliation.mjs
tools/check-youtube-tab-tracking.mjs
```

Acceptance tests:

```text
service worker restart preserves PANIC state
service worker restart preserves session-disabled LOCAL_COMPLETE
service worker restart does not reinstall stale optional rules
service worker restart verifies critical allow rules first
closed YouTube tab is removed from persisted tab snapshots
existing YouTube tab reconnects and reports state
missing content-script response raises uncertainty
user/imported-rule interference survives restart
storage failure during panic keeps conservative mode
```

### 39.12 V11 readiness statement

After V11, the architecture is production-ready for Phase 0 implementation. The first coding work must implement:

```text
session persistence
startup restoration
global DNR reconciliation
event-driven tab tracking
content-script reconnection
restart safety tests
```

No active ad suppression module should be enabled before those lifecycle safeguards exist.



---

## 40. V12 production-hardening closure

V12 closes the final production-safety issues identified after V11. These rules are binding and supersede earlier sections if there is any ambiguity.

### 40.1 Origin-safe main-world bootstrap

Production builds must not expose the YouTube main-world script through a stable `chrome-extension://` URL, DOM script element, source map marker, sourceURL comment, or web-accessible script entry.

Acceptance gate:

```text
tools/check-youtube-mainworld-origin-leak.mjs
  fails if youtube-smart-main.js is listed in web_accessible_resources
  fails if the injection helper creates a DOM-visible chrome-extension:// script tag
  fails if a sourceURL/sourceMappingURL exposes extension ID or stable internal path
```

Allowed execution is browser-mediated or ephemeral and must be verified by the main-world readiness probe. If no origin-safe execution path is available, the main-world layer is disabled for the session.

### 40.2 Embed-aware global DNR control

The global DNR plan must account for both top-level YouTube tabs and registered YouTube frames embedded in third-party pages.

Core invariant:

```text
No optional YouTube DNR rule may remain installed merely because it was needed by a previous top-level watch page.
```

If no top-level YouTube tab is open:

```text
remove all optional YouTube DNR rules
keep only current critical allows
if embeds exist, apply EMBED_CONSERVATIVE policy only
```

### 40.3 Startup and update stale-rule purge

Startup restoration and extension update handling must purge stale optional DNR rules before active suppression is allowed.

Required cases:

```text
service worker startup with no top-level YouTube tab
runtime.onInstalled install/update
registryVersion mismatch
rulePrioritySchemaVersion mismatch
critical endpoint registry changed
```

All such cases reset optional YouTube DNR state to `SAFE_CONSERVATIVE` and reinstall only current critical allow rules.

### 40.4 Probe communication safety

The main-world probe must use nonce-correlated `CustomEvent` delivery with strict `postMessage` fallback. If probe communication fails, the engine must not infer that main-world interception is active.

```text
probe missing -> mainWorldAvailable = false
mainWorldAvailable = false -> PASSIVE_DOM_SHADOW only
```

### 40.5 Advisory-only user-rule interference diagnosis

`USER_RULE_INTERFERENCE` is not a real-time DNR match claim. It is an advisory diagnosis from static overlap simulation against the critical endpoint registry.

Rule:

```text
never automatically disable a user/imported rule based only on an uncertain interference diagnosis
```

When uncertain, label the state as `POSSIBLE_USER_RULE_INTERFERENCE` or `UNKNOWN_RULE_INTERFERENCE` and surface a manual-review diagnostic.

### 40.6 Shadow DOM cosmetic rollback

Shadow DOM cosmetic cleanup is a separate high-risk class. It is disabled before sanitizer/surrogate rollback when prompt evidence appears.

```text
antiBlockPromptDetected -> disable shadow DOM observers + light DOM cosmetic observers immediately
```

### 40.7 Early accessor hard gate

Early accessors require empirical timing evidence.

```text
installEarlyAccessor(target) is allowed only if:
  hookRaceEvidence.earlyAccessorWinsLikely === true
  mainWorldAvailable === true
  descriptorRiskBudgetAvailable === true
  target sanitizer shape confidence is above threshold
  current context has no prompt/backoff flags
```

If this gate fails, the engine must use retroactive sanitization, response guards, passive observation, or no action.

### 40.8 V12 Phase 0 additions

Phase 0 must now include these additional files/audits before implementation of active suppression modules:

```text
src/js/youtube/youtube-mainworld-injection-policy.ts
src/js/youtube/youtube-embed-registry.ts
src/js/youtube/youtube-update-reconciliation.ts
src/js/youtube/youtube-dnr-static-simulator.ts
tools/check-youtube-mainworld-origin-leak.mjs
tools/check-youtube-embed-rule-plan.mjs
tools/check-youtube-update-reconciliation.mjs
tools/check-youtube-hook-race-gate.mjs
```

V12 is fully implementation-ready only if these Phase 0 additions are implemented before any optional YouTube ad suppression rules, surrogates, sanitizers, or cosmetic cleanup modules are enabled by default.


---

## 44. V13 additional release gates

V13 adds two mandatory release gates.

### 44.1 Readiness-handshake gate

The build and runtime tests must prove that main-world readiness cannot be accepted from a spoofed page event.

Required tests:

```text
spoofed uBRYouTubeMainReady without nonceHash is ignored
spoofed uBRYouTubeMainReady with wrong nonceHash is ignored
spoofed uBRYouTubeMainReady with wrong bootstrapVersion is ignored
valid nonce handshake enables only the modules permitted by policy
nonce carrier is removed after success or timeout
readiness timeout leaves mainWorldAvailable = false
```

### 44.2 Update-reset gate

The build and runtime tests must prove that extension/registry updates reset both service-worker DNR state and already-open content-script state.

Required tests:

```text
registry version mismatch removes optional YouTube DNR rules
ENGINE_UPDATE_RESET is sent to open top-level YouTube tabs
ENGINE_UPDATE_RESET is sent to registered YouTube embed frames
content script disables wrappers/accessors and returns to PASSIVE_DOM_SHADOW
shape confidence is capped to fixture baseline after reset
active modules cannot resume before reset ack + main-world reprobe + baseline health window
missing reset ack keeps aggregate rule plan conservative
```

V13 is implementation-ready only if these gates pass.


---

## 45. V14 additional release gates

V14 adds two mandatory release gates.

### 45.1 Main-world wrapper restoration gate

The build and runtime tests must prove that every active main-world interception can be disabled in an already-loaded page without relying on isolated-world state alone.

Required tests:

```text
accessor wrapper stores and restores original descriptor
fetch wrapper stores and restores original window.fetch
XHR wrapper stores and restores original XMLHttpRequest prototype methods
ytcfg/config wrapper stores and restores original method or descriptor
LOCAL_COMPLETE handler is disabled through the main-world manager
INSTRUMENTED_SHADOW hooks are disabled through the main-world manager
duplicate restore commands are idempotent
missing restore acknowledgement blocks module reactivation
ENGINE_UPDATE_RESET sends wrapper-disable command before allowing reset acknowledgement
WRAPPER_RESTORE_FAILED enters conservative global rule plan
```

### 45.2 Readiness-hash timing gate

The build and runtime tests must prove that asynchronous readiness hashing cannot accidentally enable risky modules late or out of order.

Required tests:

```text
async hash pending keeps high-risk modules disabled
readiness proof inside grace window enables only policy-permitted modules
readiness proof after grace window records LATE_MAINWORLD_READY
late readiness does not enable early accessors on the current page
missing readiness proof leaves mainWorldAvailable = false
spoofed readiness without current command channel cannot enable wrappers
```

V14 is implementation-ready only if the V13 and V14 gates pass.

---

## 46. V15 main-world capability and origin-exposure hardening

V15 adds a capability layer that must run before the existing readiness probe. Main-world execution is not assumed merely because the manifest or scripting API requests `world: "MAIN"`. The engine must prove that the target context can execute the bootstrap and that the injection method does not create an unacceptable DOM-visible extension-origin fingerprint.

### 46.1 `MainWorldCapabilityProbe`

Before installing any accessor, fetch/XHR guard, config wrapper, `LOCAL_COMPLETE` behavior, document-write wrapper, or instrumented shadow wrapper, the isolated-world script must perform a capability probe.

Required probe sequence:

```text
MainWorldCapabilityProbe:
  1. Attempt to execute a minimal main-world bootstrap that returns a deterministic marker.
  2. Verify that the executed code ran in the page main world, not the isolated world.
  3. Scan for DOM-visible extension-origin script exposure caused by the injection method.
  4. Classify the result.
```

Capability result values:

```text
MAIN_WORLD_CAPABLE_CLEAN
MAIN_WORLD_CAPABLE_DOM_VISIBLE
MAIN_WORLD_UNAVAILABLE
MAIN_WORLD_PROBE_FAILED
MAIN_WORLD_COMMUNICATION_FAILED
```

Policy:

```text
If MAIN_WORLD_CAPABLE_CLEAN:
    allow readiness probe and normal module gating.

If MAIN_WORLD_CAPABLE_DOM_VISIBLE:
    mark RiskLevel at least HIGH.
    allow only explicitly fixture-covered main-world modules.
    disable high-risk wrappers by default.
    prefer DNR + isolated-world behavior.

If MAIN_WORLD_UNAVAILABLE or MAIN_WORLD_PROBE_FAILED:
    mainWorldAvailable = false.
    disable all main-world modules.
    select PASSIVE_DOM_SHADOW.
    rely on DNR, isolated-world health observation, and conservative cosmetics only.

If MAIN_WORLD_COMMUNICATION_FAILED:
    fail safely.
    do not enable wrappers that require rollback control.
```

### 46.2 DOM-visible extension-origin rule

The main-world bootstrap script itself must not be listed as a web-accessible resource and must not be injected in a way that creates a stable page-visible `chrome-extension://.../youtube-smart-main.js` script source.

Detection checks:

```text
scan document.scripts for chrome-extension:// sources
scan newly inserted script elements during probe window
verify no bootstrap script element persists after injection
record MAIN_WORLD_DOM_VISIBLE if any extension-origin script is observable
```

A DOM-visible extension-origin bootstrap is treated as a detection risk, not a fatal error in all cases. The engine may continue only in a reduced mode and only when fixture evidence shows that the page does not inspect script elements in the relevant context.

### 46.3 Readiness probe relationship

The existing readiness handshake proves that a bootstrap instance responded. The new capability probe proves that main-world execution and exposure characteristics are acceptable. Both gates must pass before active main-world modules can run.

```text
mainWorldActiveAllowed =
    capabilityProbe.ok
    AND readinessProbe.accepted
    AND hookRaceEvidence.permits
    AND shapeConfidence.permits
    AND riskLevel permits
```

---

## 47. V15 third-party initiator conflict policy

`excludedInitiatorDomains` is necessary but insufficient. It excludes requests whose immediate initiator is YouTube, but it does not exclude subrequests initiated by third-party ad scripts already running inside a YouTube page.

### 47.1 Rule

`excludedInitiatorDomains` is defense-in-depth only. Primary conflict control is:

```text
1. YouTube-specific high-priority allow/surrogate/block rules.
2. Endpoint ownership registry.
3. Generic-stealth exclusion or replacement for YouTube-sensitive endpoints.
4. Static conflict simulation with third-party initiators.
```

### 47.2 Endpoint ownership registry

Every endpoint that may be touched by both generic stealth and the YouTube engine must have exactly one owner:

```text
GENERIC_STEALTH_OWNER
YOUTUBE_ENGINE_OWNER
SHARED_WITH_PRIORITY_GUARD
DISABLED_ON_YOUTUBE_CONTEXTS
```

For `YOUTUBE_ENGINE_OWNER`, generic stealth must not install rules that can affect the endpoint in YouTube contexts, even when the immediate initiator is a third-party domain.

### 47.3 Third-party initiator fixtures

Required fixture initiators:

```text
doubleclick.net
googleadservices.com
googlesyndication.com
googlevideo.com
ytimg.com
```

For each fixture:

```text
simulate top-level document: youtube.com
simulate request initiator: third-party ad-serving domain
simulate target endpoint: candidate generic stealth endpoint
assert YouTube rule wins or generic rule is disabled
```

If DNR cannot deterministically preserve YouTube ownership for an endpoint, the endpoint must be removed from generic stealth while a YouTube context is active or be globally owned by the YouTube engine.

---

## 48. V15 response-header sanitization implementation constraints

Header sanitization must be implementable and reversible. The engine must not assume that page-visible response headers can be mutated in place.

### 48.1 Fetch responses

For `fetch`, the engine must not attempt to modify `Response.headers` directly. If sanitization is allowed by policy and fixture evidence, construct a fresh response:

```text
original = await fetch(...)
body = await original.clone().arrayBuffer() or text/json as needed
sanitizedHeaders = copy all original headers except allowlisted ad-related headers
return new Response(body, {
  status: original.status,
  statusText: original.statusText,
  headers: sanitizedHeaders
})
```

Requirements:

```text
preserve status
preserve statusText
preserve non-ad headers
preserve body semantics
preserve response type where possible
fail open if reconstruction is unsafe
```

If the original body is streaming or cannot be cloned without breaking timing/contract, header sanitization is disabled for that request and telemetry records:

```text
HEADER_SANITIZATION_UNSAFE
```

### 48.2 XMLHttpRequest responses

For XHR, direct mutation of headers is not available. The wrapper may only intercept:

```text
XMLHttpRequest.prototype.getResponseHeader
XMLHttpRequest.prototype.getAllResponseHeaders
```

Rules:

```text
return sanitized values only for explicitly allowlisted ad-related headers
preserve exact original behavior for all other headers and call patterns
preserve case-insensitive header lookup behavior
preserve null behavior for missing headers
participate in reversible-wrapper registry
```

If behavior cannot be matched, do not sanitize and record:

```text
XHR_HEADER_SANITIZATION_UNSAFE
```

---

## 49. V15 Performance Resource Timing mitigation policy

The Performance Resource Timeline is a page-visible channel. For monitored endpoints, DNR `BLOCK` and DNR `REDIRECT` may be more detectable than allowing the request.

### 49.1 Monitored-by-default heuristic

An endpoint is `MONITORED_BY_DEFAULT` if any of the following is true:

```text
endpoint appears in the critical endpoint registry
endpoint belongs to an ad-decision, ad-beacon, ad-media, or player-ad metadata class
endpoint is touched by a page-visible script contract
endpoint is known to appear in performance.getEntriesByType('resource') during shadow observation
endpoint participates in callbacks, promises, onload/onerror, or ad-timing state
endpoint has no fixture evidence proving absence of PerformanceObserver monitoring
```

Default policy:

```text
MONITORED_BY_DEFAULT → ALLOW unless a safer surrogate is fixture-proven
UNKNOWN              → ALLOW in safe mode, observe in shadow
LOW_RISK_STATIC      → BLOCK only if no page-visible contract is expected
```

### 49.2 Surrogate timing requirements

For monitored endpoints, a surrogate is allowed only if fixture evidence shows the resulting resource entry is not more suspicious than the original.

A surrogate must not create a stable, trivially fingerprintable `chrome-extension://` entry for a monitored endpoint unless the engine has fixture evidence that the page does not inspect that entry.

If a surrogate would produce a visible extension URL and monitoring is unknown:

```text
use ALLOW + sanitizer instead
```

DNR `BLOCK` is the highest-risk network action for monitored endpoints. It is permitted only when allowing the endpoint creates a stronger and fixture-proven detection or breakage risk.

---

## 50. V15 document.write, interstitial, and Shorts handling

### 50.1 `document.write` mitigation policy

The engine must not ignore ad insertion through `document.write`.

Main-world `document.write` wrapping is classified as:

```text
RiskClass.DOCUMENT_WRITE_WRAPPER = HIGH
```

Policy:

```text
Default: do not wrap document.write.
If ad content is inserted by document.write, detect resulting DOM nodes through passive observation.
Use cosmetic cleanup only after fixture evidence.
Enable document.write wrapper only for fixture-covered contexts and only when rollback control is available.
```

The wrapper, if enabled, must be reversible through the main-world wrapper registry and must be disabled before lower-risk wrappers during rollback.

### 50.2 Interstitial ad handling policy

Interstitial ads are separate from in-player and feed ads.

Detection signals:

```text
full-page modal overlay
navigation delay/blocking
known interstitial renderer in ytInitialData or player data
player unavailable because an ad interstitial is active
```

Handling:

```text
If data-sanitizer confidence permits:
    remove interstitial renderer before render.
Else if cosmetic cleanup confidence permits:
    hide/remove interstitial DOM.
Else:
    allow the interstitial to proceed.
```

Interstitial cleanup has its own risk class:

```text
RiskClass.INTERSTITIAL_CLEANUP
```

It is disabled early in rollback.

### 50.3 Shorts ad handling

Shorts support is fixture-gated and disabled by default until a Shorts fixture corpus exists.

Shorts data sources:

```text
ytInitialData reelItemRenderer / reelShelfRenderer
/youtubei/v1/reel/reel_item_watch
inline ad renderers within the Shorts feed
```

Constraints:

```text
must not break swipe-to-next
must preserve feed continuity
must not remove non-ad reel items
requires Shorts-specific shape confidence
requires at least 5 consecutive clean observations before active sanitization
```

---

## 51. V15 sanitizer traversal and clean-observation definitions

### 51.1 Sanitizer traversal-depth policy

“Shallow path checks” means:

```text
inspect direct root properties first
traverse nested structures only when the parent path is allowlisted
never recursively traverse unknown structures
never traverse the full object graph
never use JSON.stringify/parse as a traversal strategy
```

Depth limits:

```text
Default maximum depth: 5
Known large structures such as contents arrays: 3
Unknown nested structures: 1 unless allowlisted
```

If traversal would exceed limits:

```text
skip sanitization
record PERFORMANCE_SKIP
enter shadow mode for that sanitizer path
```

### 51.2 Consecutive clean observation definition

A clean observation requires all applicable conditions within the observation window:

```text
promptScore < 50
HealthState is HEALTHY, or DEGRADED with recovery
no sanitizer performance budget overrun
no sanitizer-attributed console/API errors
watch pages: currentTime progresses by at least 2 seconds
browse/feed pages: at least one non-ad renderer is visible
Shorts: swipe-to-next works and ad renderers are absent
embed pages: player remains usable and no parent-page errors are observed
```

Observation windows:

```text
watch page: 5 seconds after page load or SPA navigation
browse/feed page: 3 seconds after initial render
Shorts: 3 seconds after swipe
embed: 5 seconds after frame player ready
```

---

## 52. V15 storage quota and state-size management

`chrome.storage.session` capacity is finite. Session persistence must be bounded.

### 52.1 State limits

```text
tab snapshots: max 30 detailed records
interference records: max 100 recent records
variation fingerprints: max 100 active fingerprints
telemetry event summaries: bounded counters, not unbounded logs
```

If more than 30 tabs/frames are tracked:

```text
keep detailed records for:
  top-level YouTube tabs
  embeds with recent heartbeat
  tabs in HIGH/PANIC risk
store only tabId/frameId/lastSeenAt for the remainder
```

### 52.2 Quota failure behavior

If a storage write exceeds quota:

```text
1. Evict least-recently-used tab snapshots.
2. Prune old interference records.
3. Prune old variation fingerprints.
4. Store only critical state:
   panic flags
   disabled module classes
   disabled surrogate endpoints
   registry version
   critical installed rule IDs
```

If storage is unavailable:

```text
enter SAFE_CONSERVATIVE
record STORAGE_UNAVAILABLE
continue without persistent session learning
```

---

## 53. V15 surrogate URL exposure and LOCAL_COMPLETE timing

### 53.1 Surrogate URL exposure policy

The main-world bootstrap is not a surrogate and must not be exposed as a `chrome-extension://` web-accessible resource.

Surrogate resources are different. DNR redirects to local web-accessible resources necessarily expose `chrome-extension://` URLs as part of the browser’s resource load. This is allowed only as a managed risk.

Risk class:

```text
RiskClass.SURROGATE_URL_EXPOSURE
```

Policy:

```text
monitored endpoint + visible extension URL risk unknown → ALLOW + sanitizer
fixture-proven low monitoring risk → surrogate allowed
high prompt history → suppress surrogate and allow
```

### 53.2 LOCAL_COMPLETE timing constraint

`LOCAL_COMPLETE` requires readiness proof before active behavior.

Policy:

```text
If readiness proof is late:
    LOCAL_COMPLETE is disabled for that page load.

If fetch/XHR already occurred:
    LOCAL_COMPLETE cannot retroactively apply.

Allowed implementation:
    install a reversible fetch/XHR guard in shadow mode only,
    forward to original behavior until readiness is accepted,
    activate LOCAL_COMPLETE only after readiness and risk gates pass.
```

The shadow guard itself is still a wrapper and must be included in the wrapper-risk budget and reversible-wrapper registry.

---

## 54. V15 observer, health, and rule-install reliability

### 54.1 MutationObserver enhanced budget

```text
per batch node budget: 200 nodes
hard throttle: at most one processed batch per 200 ms per root
```

If a batch exceeds 200 nodes:

```text
process first 200 nodes
queue remaining nodes for later processing
record OBSERVER_OVERFLOW
```

If overflow occurs 3 times in 1 minute for the same root:

```text
disconnect observer
enter PASSIVE_DOM_SHADOW for that root
record OBSERVER_OVERFLOW_BACKOFF
```

Closed shadow roots are not observed. Use light-DOM health signals and periodic structural checks instead.

### 54.2 Health monitor dynamic ticking

Base intervals:

```text
watch page: 1000 ms
browse/feed page: 2000 ms
Shorts: 2000 ms
embed: 5000 ms
```

Dynamic adjustment:

```text
after 10 consecutive HEALTHY ticks: increase to 2000 ms, unless already lower-frequency
for 10 ticks after PROMPT_DETECTED or BROKEN: 500 ms
on document.hidden: pause health checks
on visibilitychange: resume and record VISIBILITY_PAUSE
```

Health checks must avoid forced layout. Prefer cached references and simple property checks.

### 54.3 Optional rule install failure policy

Critical allow rule install failure is the only rule-install failure that triggers PANIC.

For optional rule failures:

```text
log failure
continue installing remaining rules
if >20% optional rules fail: record RULE_INSTALL_PARTIAL_FAILURE
if same rule fails 3+ times in one session: ban rule for session
use alternative handling: sanitizer, shadow mode, or allow
```

---

## 55. V15 BFCache, variation, domain, mobile, and sandbox handling

### 55.1 BFCache restoration protocol

On `pageshow` with `event.persisted === true`:

```text
classify as BFCache restoration
rerun readiness and rollback-channel probes
verify main-world wrapper registry is still responsive
recompute PageContext
revalidate risk level
```

If probe succeeds:

```text
preserve active modules only if version and risk gates still pass
```

If probe fails:

```text
force document-level reset path
enter PASSIVE_DOM_SHADOW
record BFCACHE_RESTORE_FAILED
```

Do not destroy main-world wrappers on `pagehide`; they may be restored from BFCache. Use the same reset protocol as update reset if versions differ.

### 55.2 A/B and experimental variation handling

Variation signals:

```text
unknown renderer type
changed response shape
new DOM structure
unknown player/ad metadata field
fixture mismatch
```

When a variation is detected:

```text
record UNKNOWN_YOUTUBE_CHANGE
enter shadow mode for affected path
store privacy-preserving variation fingerprint
use variation-specific confidence
```

Promotion rule:

```text
same variation + 5 clean observations → candidate fixture
6th clean observation → may be treated as known normal variant after manual or automated fixture acceptance
```

A new variation does not invalidate unrelated variation confidence.

### 55.3 `youtube-nocookie.com`

`youtube-nocookie.com` is a YouTube domain for classification and DNR purposes.

Rules:

```text
top-level youtube-nocookie.com → top-level YouTube context
embedded youtube-nocookie.com → embed context
no dependency on cookies for identification
include in initiator exclusions and YouTube endpoint registry
```

### 55.4 `m.youtube.com`

The mobile site has different DOM, renderer types, and performance constraints.

Support plan:

```text
Phase 1: recognize and classify as YouTube
Phase 2: minimal sanitizer support after fixtures
Phase 3: mobile cosmetic cleanup after fixtures
Phase 4: full parity if warranted
```

Default behavior:

```text
m.youtube.com → PASSIVE_DOM_SHADOW unless user enables mobile support and fixtures pass
```

### 55.5 Sandboxed embeds

For YouTube frames inside sandboxed iframes:

```text
inspect frameElement.sandbox where accessible
probe postMessage and CustomEvent channels
if neither channel works: mainWorldAvailable = false
mark risk HIGH
select PASSIVE_DOM_SHADOW
use DNR + isolated-world only
```

Sandboxed embeds do not activate main-world interception.

---

## 56. V15 testing, memory, and compatibility gates

### 56.1 Performance regression tests

Required tests:

```text
sanitizer on 5MB response: target < 50 ms
MutationObserver batch: target < 4 ms per processed batch
health tick: target < 2 ms
youtube page load with engine: target < 500 ms added time to first paint
```

Run each test at least 10 times and use average plus outlier reporting. If a performance test exceeds budget by more than 20%, block the PR unless the regression is explicitly waived with a documented reason.

### 56.2 Memory leak prevention

Requirements:

```text
remove window event listeners on unload/reset
disconnect MutationObservers on unload/reset
clear timers on unload/reset
use WeakMap/WeakSet for DOM node tracking
avoid long-lived closures holding DOM nodes
```

Leak test:

```text
simulate 100 page loads or SPA navigations
measure retained memory before/after
fail if memory grows by >20% without explanation
```

### 56.3 Cross-browser compatibility

Primary target remains Chrome MV3. Edge Chromium support should degrade similarly. Firefox support is conditional on available MV3 and DNR capabilities.

Fallbacks:

```text
if chrome.storage.session unavailable → use chrome.storage.local with bounded keys
if DNR limits differ → reduce optional rule budget
if main-world injection differs → capability probe decides
if feature unavailable → degrade, do not fail
```

Cross-browser tests are required only for claimed support targets. If a browser cannot support detection-neutral YouTube mode, the engine must disable that mode and expose a diagnostic rather than partially running unsafe modules.

---

## 57. V15 security posture and terminology consolidation

### 57.1 Nonce handshake clarification

The nonce/hash readiness handshake is not a cryptographic defense against a determined page script.

It provides:

```text
correlation between isolated and main-world bootstrap
version matching
accidental-spoofing prevention
auditability of readiness state
```

It does not provide:

```text
secrecy from the page
protection against a malicious page that can read the nonce
proof that YouTube cannot detect the extension
```

Readiness proof is only one gate. Wrappers still require shape confidence, hook-race evidence, risk allowance, wrapper budget, and rollback availability.

### 57.2 `eval` / `new Function` detection policy

The engine must not use `eval` or `new Function`.

Page use of `eval`/`new Function` to inspect globals is treated as a high-risk signal if detected indirectly through prompt behavior or known instrumentation patterns.

Policy:

```text
avoid enumerable global symbols
prefer Symbol-keyed internal state where feasible
remove temporary probe globals quickly
if eval-style detection is suspected: disable main-world wrappers and enter PASSIVE_DOM_SHADOW
```

### 57.3 Terminology consolidation

Use these terms consistently:

```text
Anti-block prompt:
  YouTube UI that asks, warns, blocks, or restricts playback because ad blocking is suspected.

Enforcement UI:
  A subset of anti-block prompts that actively prevents playback or navigation.

Prompt score:
  Numeric 0-100 score computed by the anti-block detector.
  80+ confirmed, 50-79 suspected, <50 not present.

Anti-block detector:
  Module that computes prompt score and triggers rollback.
```

### 57.4 Risk vs health

Risk Level and Health State are separate concepts.

```text
Risk Level:
  LOW, MEDIUM, HIGH, PANIC
  Represents engine confidence and allowed intervention level.

Health State:
  HEALTHY, DEGRADED, STUCK, PROMPT_DETECTED, BROKEN
  Represents current page/player condition.
```

Relationship:

```text
health anomaly can raise risk
risk gates module activation
health triggers rollback
```

Example:

```text
PROMPT_DETECTED is a Health State.
It triggers rollback.
Rollback raises Risk Level to HIGH or PANIC.
Only passive/shadow modules remain active.
```

---

## 58. V15 required tests and audits

V15 adds the following required tests before alpha:

```text
tests/youtube/mainworld-capability.spec.ts
tests/youtube/third-party-initiator-conflicts.spec.ts
tests/youtube/response-header-sanitization.spec.ts
tests/youtube/performance-timeline-mitigation.spec.ts
tests/youtube/document-write-handling.spec.ts
tests/youtube/interstitial-ad-handling.spec.ts
tests/youtube/shorts-ad-handling.spec.ts
tests/youtube/bfcache-restoration.spec.ts
tests/youtube/ab-variation-handling.spec.ts
tests/youtube/mobile-site-support.spec.ts
tests/youtube/sandboxed-embed.spec.ts
tests/youtube/memory-leak.spec.ts
tests/youtube/performance-regression.spec.ts
tests/youtube/cross-browser-compatibility.spec.ts
```

V15 adds the following required audits:

```text
tools/check-youtube-mainworld-capability.mjs
tools/check-youtube-third-party-initiator-conflicts.mjs
tools/check-youtube-storage-quota.mjs
tools/check-youtube-memory-leak.mjs
tools/check-youtube-performance-budget.mjs
tools/check-youtube-terminology-consistency.mjs
```

V16 is production-ready for Phase 0 only if the V14, V15, and V16 gates pass.



---

## 59. V16 Phase 0 implementation-caveat closure

V15 was already implementation-ready. V16 does not introduce a new suppression module. It converts the remaining implementation caveats from informal review notes into mandatory Phase 0 validation rules.

### 59.1 Main-world capability probe version matrix

The `MainWorldCapabilityProbe` must be tested on every supported browser/version channel before active main-world modules are allowed.

Required matrix:

```text
Chrome stable
Chrome beta
Chrome canary
Edge stable
any explicitly supported Chromium derivative
```

For each browser target, record:

```text
browserName
browserVersion
extensionManifestVersion
injectionMethod
mainWorldExecuted
mainWorldActuallyPageWorld
domVisibleScriptElementCreated
persistentChromeExtensionURLVisible
temporaryChromeExtensionURLVisible
probeRoundTripMs
resultClass
```

Result classes:

```text
MAIN_WORLD_CAPABLE_CLEAN:
  Main-world execution succeeds and no persistent DOM-visible extension-origin script element is observed.

MAIN_WORLD_CAPABLE_DOM_VISIBLE:
  Main-world execution succeeds but a DOM-visible extension-origin artifact appears, even transiently.
  Active wrappers remain disabled unless a fixture explicitly permits the risk for that browser version.

MAIN_WORLD_NOT_CAPABLE:
  Execution fails, context is not truly page main world, communication fails, or persistent extension-origin artifacts are visible.
  Use DNR + isolated-world observation only.
```

A browser/version whose behavior is unknown must be treated as `MAIN_WORLD_NOT_CAPABLE` until the matrix is updated.

The probe itself is part of the risk surface. It must not be repeatedly executed on every SPA navigation unless the document changed. Re-running the probe is permitted only on:

```text
full document load
BFCache restoration
extension update reset
capability matrix invalidation
explicit safe-mode diagnostic run
```

### 59.2 Early passive observer bootstrap for `document.write`

The engine keeps the `document.write` wrapper disabled by default. To reduce the early-write window, the isolated-world content script must attach the lowest-risk passive observer as early as possible.

Startup ordering:

```text
1. Create passive root observers for documentElement/body when available.
2. Queue observer attachment if body is not yet present.
3. Record earliestObserverAttachedAt relative to content-script start.
4. Only then start optional main-world capability/readiness probing.
```

If a suspected ad node is already present before the first observer attaches, classify it as:

```text
EARLY_WRITE_MISSED
```

Policy:

```text
EARLY_WRITE_MISSED does not activate the document.write wrapper by itself.
It raises risk for that page path.
It may enable fixture-gated cosmetic cleanup only.
It may enable the high-risk document.write wrapper only after fixture evidence and manual review.
```

This preserves detection-neutrality: missed early writes reduce suppression effectiveness rather than forcing a detectable wrapper.

### 59.3 Third-party initiator fixture harness

The third-party initiator conflict tests must be reproducible. They cannot rely on vague browser behavior or manual YouTube sessions.

Required harness pattern:

```text
controlled top-level YouTube-like fixture page
controlled third-party script origin fixture
third-party script performs subrequests to candidate ad/measurement endpoints
DNR rule plan installed exactly as produced by the engine
rule-match simulation run against generated requests
browser-level confirmation that the final action matches ownership policy
```

Acceptable implementation methods:

```text
local HTTPS fixture servers with distinct hostnames
loopback host mapping for youtube-like and third-party origins
Playwright-controlled pages that load a third-party script from a distinct origin
DNR rule simulation against recorded request metadata
```

The test must cover at least:

```text
youtube.com top-level + doubleclick-like initiator
youtube.com top-level + googleadservices-like initiator
youtube.com embed + doubleclick-like initiator
youtube-nocookie.com embed + third-party initiator
no top-level YouTube tab + YouTube embed present
```

Passing condition:

```text
YouTube-owned endpoint policies always outrank generic stealth policies.
If DNR cannot guarantee this for a third-party initiator, the endpoint becomes YouTube-owned globally and the generic rule is disabled or capped.
```

### 59.4 A/B variation fixture curation

The variation promotion rule remains conservative.

A variation can move through these states:

```text
UNKNOWN_YOUTUBE_CHANGE
OBSERVED_VARIATION
CANDIDATE_VARIATION
REVIEWED_VARIATION
KNOWN_VARIATION
```

Promotion requirements:

```text
UNKNOWN -> OBSERVED:
  A structural fingerprint appears once without immediate breakage.

OBSERVED -> CANDIDATE:
  5 clean observations across compatible page types.

CANDIDATE -> REVIEWED:
  Fixture snapshot captured and manually inspected.

REVIEWED -> KNOWN:
  A reviewer confirms the structural path is compatible with existing sanitizer rules or adds a specific fixture.
```

A one-off or rare variation may remain `OBSERVED_VARIATION` indefinitely. That is acceptable. The safe default is shadow mode for affected sanitizer paths, not automatic learning.

Variation fingerprints must not store user-identifying values. They may store:

```text
renderer type names
key-path hashes
schema-shape hashes
page type
engine version
fixture corpus version
```

They must not store:

```text
video IDs
account IDs
recommendation content
search query text
viewer-specific tokens
```

### 59.5 Low-end performance calibration

The existing budgets remain hard targets, but V16 requires explicit calibration on a low-end profile before active modules are enabled by default.

Calibration profile:

```text
low-end CPU throttling in browser automation, or documented low-end hardware
cold page load and warm SPA navigation
watch, browse, Shorts, embed, and mobile contexts when supported
10 runs minimum per context
```

Budget reporting:

```text
median
p90
p95
worst observed
number of skips
number of observer overflows
number of fail-open decisions
```

Adjustment rule:

```text
Budgets may be relaxed only if the relaxation increases fail-open behavior or disables work sooner.
Budgets may not be relaxed to permit more aggressive sanitization on slow devices.
```

If a module exceeds budget on the low-end profile:

```text
disable the module for that page type by default
keep it fixture-only or setting-gated
record PERFORMANCE_PROFILE_UNSAFE
```

### 59.6 Repeated optional-rule failure diagnostics

Optional DNR rule installation failures do not trigger PANIC, but repeated failures must become visible to diagnostics.

Persist the following local-only counters:

```text
ruleClass
ruleId or stable rule hash
endpointClass
failureReason
firstFailedAt
lastFailedAt
sessionFailureCount
crossSessionFailureCount
lastEngineVersion
```

Policy:

```text
3 failures in one session:
  ban that optional rule for the session and use fallback handling.

failures across 3 separate sessions or 2 engine versions:
  mark OPTIONAL_RULE_REQUIRES_REVIEW.

critical allow failure:
  still triggers PANIC immediately.
```

Diagnostics UI/logging must show:

```text
optional rule was skipped
why it failed
which fallback is active
whether suppression may be reduced
whether any user/imported rule likely interfered
```

No automatic user prompt is required. The diagnostic must be available to advanced users and to Phase 0 test output.

### 59.7 V16 final readiness gate

V16 is production-ready for Phase 0 only when all of the following pass:

```text
V14 gates
V15 gates
main-world capability browser matrix completed
persistent extension-origin artifact test passed or downgraded
third-party initiator fixture harness implemented
low-end performance calibration completed
optional-rule repeated-failure diagnostics implemented
A/B variation manual-review workflow documented
```

V16 remains detection-neutral by default: unresolved implementation caveats disable or downgrade active modules rather than increasing intervention.
