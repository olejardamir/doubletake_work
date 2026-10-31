# uBlock Resurrected Full Remaining Generalization List v11

Updated: 2026-06-27
Baseline: post-`b57ad2390a213f5afd1ddb2db395959935589d39` remaining-work discussion, v7/v8/v9/v10 full-list reviews, and v11 major-gap review.

Purpose: one full end-to-end numbered list of remaining substantial generalization work. This is not an addendum. Minor duplicates and tiny implementation variants were consolidated into broader work items. v10 added major missing coverage areas: extension-page/XSS hardening, request/response-header mutation policy, gesture-bound manual tools, messaging DoS/backpressure, remote telemetry and egress invariants, sync/conflict handling, static-ruleset lifecycle governance, supply-chain hardening, and hostile-DOM/prototype-wrapper safety. v11 adds remaining major cross-cutting coverage: a browser-API gateway, property/fuzz testing, private-network egress policy, scheme/protocol capability matrices, CNAME/cloaking semantics, cross-store compliance, consent/review flows for high-risk features, shadow-mode rollout, breakage taxonomy, dynamic-code/WASM policy, and completion criteria for exiting the generalization phase.

## Full numbered list

1. Replace broad manifest content-script injection with a thin bootstrap that only requests policy and starts approved layers.
2. Replace broad manifest video-script injection with profile- and adapter-driven dynamic activation.
3. Remove remaining manifest `exclude_matches` site exceptions after equivalent profile/policy behavior is enforced.
4. Generate manifest content-script entries from the policy/capability model instead of maintaining them by hand.
5. Make every static manifest-injected file declare whether it is bootstrap-only or a runtime layer.
6. Fail CI if any heavy runtime is statically injected across all HTTP/HTTPS pages.
7. Add a runtime activation manager that is the only allowed path for starting content layers.
8. Route cosmetic, smart-cosmetic, video, scriptlet, interceptor, logger, and first-party detector startup through the activation manager.
9. Prohibit runtime self-start outside activation manager by static checks and tests.
10. Make runtime activation fail closed when service-worker policy is unavailable.
11. Make runtime activation fail closed when policy schema validation fails.
12. Make runtime activation fail closed when browser capabilities are unknown.
13. Make runtime activation fail closed when tab/frame/document scope cannot be resolved.
14. Add per-tab, per-frame, per-document policy snapshots with revision IDs.
15. Ensure all layers use the same policy snapshot during one activation cycle.
16. Refresh policy snapshots on navigation, soft navigation, whitelist changes, switch changes, filter-list changes, managed-policy changes, and extension update.
17. Prevent child frames from receiving more permission than the parent/top-frame policy allows.
18. Define strict policy inheritance for same-origin frames, cross-origin frames, `about:blank`, sandboxed frames, `srcdoc`, `blob:`, and prerendered documents.
19. Add frame/document identity to every runtime context and capability token.
20. Add policy behavior for stale content scripts that remain after extension update.
21. Add service-worker/content-script protocol version negotiation.
22. Add safe shutdown or reload prompts when protocol versions mismatch.
23. Add startup reconciliation so service-worker restarts cannot revive stale layer state.
24. Add startup reconciliation for active content layers, policy snapshots, degraded mode, safe-mode tabs, and instrumentation flags.
25. Add startup reconciliation for dynamic and session DNR rules.
26. Add startup reconciliation for compatibility metadata and site exceptions.
27. Make `page-policy.json` the single source of truth for profile-to-capability decisions.
28. Remove inline default policy objects from runtime code after migration.
29. Remove hardcoded established-support host sets from policy resolver.
30. Replace hostname confidence lists with evidence-derived support from filter specificity, adapter metadata, rule provenance, and passing fixtures.
31. Add a machine-readable policy schema and validate it in build, tests, release verification, and runtime loading.
32. Normalize flat backward-compatible policy fields and nested policy fields so they cannot disagree.
33. Remove duplicated flat policy fields once all consumers use schema-validated nested policy.
34. Rename ambiguous policy fields such as `contentScript` so string modes cannot conflict with object fields.
35. Split `loadInterceptors` from `firstPartyDomDetection`.
36. Split first-party DOM detection from first-party response mutation.
37. Split DOM marking from DOM hiding, removal, and click neutralization.
38. Split video observation from video mutation.
39. Split skip-click capability from overlay hiding/removal capability.
40. Split fetch wrapping from XHR prototype mutation.
41. Split generic cosmetic filtering from procedural cosmetic filtering everywhere.
42. Split smart-cosmetic runtime activation from ordinary cosmetic runtime activation.
43. Split scriptlet injection from main-world hook capability.
44. Split logger attribution from matched-rule collection and request counting.
45. Add explicit policy fields for DOM marker mutation, DOM hide mutation, DOM remove mutation, automated click, response mutation, and main-world bridge use.
46. Add explicit policy fields for network block, allow, redirect, upgrade, and surrogate actions.
47. Add explicit policy fields for anti-adblock countermeasures, separate from ordinary blocking.
48. Add explicit policy fields for diagnostics capture, diagnostics export, and local compatibility recording.
49. Add profile confidence scoring rather than only profile labels.
50. Define low-confidence classification behavior: choose safer profile, downgrade high-risk layers, and record reason.
51. Add policy-diff gates that fail on unsafe widening unless explicitly approved.
52. Require policy-diff approval for enabling main-world hooks, response mutation, global procedural cosmetics, video mutation, automated clicks, anti-adblock countermeasures, and broad DNR allow/block rules.
53. Add a human-readable policy explanation generator for debugging why a page received a profile and layer set.
54. Add a formal precedence model for managed policy, safe mode, user trust, user overrides, compatibility debt, browser capabilities, and filter-list evidence.
55. Add tests proving user overrides cannot bypass auth/payment/app-shell safety unless an explicit high-trust override path is used.
56. Make capability tokens service-worker issued rather than plain forgeable objects.
57. Bind capability tokens to layer ID, tab ID, frame ID, document ID where available, policy revision, issue time, expiry, and allowed action class.
58. Add capability-token revocation when policy changes, navigation occurs, safe mode starts, or a layer stops.
59. Prevent stale or reused capability tokens after navigation or extension update.
60. Require capability tokens for every mutation API, including DOM mutation, CSS injection, response mutation, automated click, main-world hook, redirect/surrogate, and scriptlet injection.
61. Add token tests for missing token, expired token, wrong layer, wrong tab, wrong frame, wrong document, wrong policy revision, wrong action class, and revoked token.
62. Add a capability coverage metric showing percentage of mutation/action paths requiring validated capability tokens.
63. Fail CI if a high-risk runtime imports mutation APIs without a capability-token validation path.
64. Add a central safe-action API so all hide/remove/mark/click/redirect/scriptlet actions go through one authorization point.
65. Add a mutation ledger recording what was changed, by which layer, under which token, and how to reverse it.
66. Require every mutation-capable layer to implement stop, rollback, and diagnostics methods.
67. Add action reversibility for cosmetic DOM mutation, smart DOM mutation, first-party marker mutation, video DOM mutation, CSS injection, injected scriptlets, and prototype wrapping where feasible.
68. Add rollback tests for every reversible action class.
69. Make every runtime layer implement a standard interface with `id`, `risk`, `canStart`, `start`, `stop`, `rollback`, `getDiagnostics`, and `getActiveActions`.
70. Wire the existing runtime-layer registry into the active generated content-script startup path.
71. Ensure `activateLayersForTab()` is used by the real runtime path, not only available as scaffolding.
72. Ensure `deactivateLayersForTab()` is called on tab close, navigation, frame detach, safe-mode entry, policy downgrade, extension update, and extension shutdown.
73. Add per-tab runtime state cleanup on tab close.
74. Add per-frame runtime state cleanup on frame detach.
75. Add per-document runtime state cleanup on navigation and BFCache restore.
76. Add central lifecycle manager for tabs, frames, documents, policies, layers, observers, timers, and injected CSS.
77. Add a concurrency/single-flight manager for DNR sync, policy refresh, filter-list update, startup reconciliation, safe-mode entry, degraded-mode transitions, and layer activation.
78. Prevent overlapping DNR updates from interleaving and producing mixed rule states.
79. Prevent policy refresh from racing with runtime layer activation.
80. Prevent safe-mode entry from racing with layer startup.
81. Prevent service-worker restart from reactivating stale state.
82. Add atomic activation transactions so all approved layers either start consistently or rollback consistently.
83. Add a layer conflict/arbitration engine so multiple layers cannot independently mutate the same DOM node or request without coordination.
84. Add a strongest-safe-action-wins rule for conflicts between DNR, cosmetic, smart cosmetic, video, scriptlets, and response mutation.
85. Add a layer conflict report showing which layer blocked, downgraded, or overrode another layer.
86. Add tests for contradictory cosmetic/video actions on the same player or container.
87. Add tests for multiple layers attempting to mutate the same DOM node.
88. Add a no-background-work-without-consumer invariant for instrumentation, observers, diagnostics, simulator runs, and periodic reconciliation.
89. Make degraded allow mode the only fallback path after rule compilation/install failure.
90. Remove deprecated fallback block-rule code after all callers are replaced.
91. Fail CI if fallback block rules are introduced.
92. Fail CI if any fallback/degraded path blocks `main_frame`, `script`, `xmlhttprequest`, or `websocket`.
93. Replace direct `chrome.declarativeNetRequest.updateDynamicRules` calls with a transaction manager.
94. Replace direct `chrome.declarativeNetRequest.updateSessionRules` calls with a transaction manager.
95. Verify transaction rollback removes failed new rules before restoring previous rules.
96. Verify degraded allow mode clears both dynamic and session rules.
97. Store degraded-mode reason, timestamp, affected rule batch, and triggering error in runtime health.
98. Add structured DNR install decision records for every accepted, rejected, downgraded, and skipped rule.
99. Persist DNR install reports for debugging, release artifacts, and regression tests.
100. Include source list, raw filter, normalized rule, ID, priority, action, condition, resource types, risk, specificity, decision, and reason in install reports.
101. Add a DNR provenance viewer/export for debugging without leaking private browsing data.
102. Ensure static rules, dynamic rules, session rules, whitelist rules, trusted-site rules, and user rules pass through the same risk model.
103. Add deterministic DNR rule ID registry and ID range ownership.
104. Add DNR priority policy and priority-band ownership.
105. Fail CI on DNR ID collisions, priority collisions, unsafe priority inversion, or unowned ID ranges.
106. Add tests for allow/block interaction, redirect/block/allow interaction, excluded initiators, request domains, initiator domains, and first-party/third-party classification.
107. Add DNR budget planner by source, rule type, regex count, resource type, and browser capability profile.
108. Add source-level budgets for network rules, regex rules, redirect rules, allow rules, and high-risk resource rules.
109. Add static ruleset risk reports to release artifacts.
110. Add rule lifecycle states: proposed, quarantined, observe-only, active, disabled, expired, rollback.
111. Add automatic rollback for rule updates that increase breakage score or exceed risk budgets.
112. Add network redirect/surrogate policy separating block, allow, redirect, upgrade, and surrogate behavior.
113. Add redirect/surrogate provenance and safety tests for first-party, third-party, and extension-resource redirects.
114. Add CORS/preflight handling tests for redirects and surrogate rules.
115. Add update-channel model for external assets: built-in, user-added, trusted remote, untrusted remote, enterprise-managed, and local debug.
116. Add pinning, versioning, integrity metadata, rollback metadata, and source trust level for remote filter-list updates.
117. Add signature or checksum validation for filter-list bundles where available.
118. Restrict remote asset fetches to approved extension assets or approved filter-list sources.
119. Add URL normalization, timeout, size limits, MIME checks, and rejected-fetch diagnostics for remote fetches.
120. Quarantine newly added or changed filter lists until they pass syntax, risk, budget, provenance, and breakage-corpus checks.
121. Add staged rollout mode for risky rule updates: observe-only, limited activation, then full activation after clean diagnostics.
122. Add filter-list capability metadata specifying which actions a list may produce.
123. Prevent a filter list from producing scriptlets, response mutation, procedural cosmetics, redirects, surrogates, or high-risk network rules unless its trust/capability level allows it.
124. Add parser diagnostics for unsupported syntax, downgraded rules, rejected high-risk rules, and lost specificity.
125. Add parser coverage matrix by filter-list source and syntax family.
126. Add user-rule validation through the same risk model as remote lists.
127. Add abuse-resistance for imported user rules that attempt broad main-world hooks, broad response mutation, broad redirects, or unsafe allow rules.
128. Add confirmation and risk explanation before a user rule enables high-risk capabilities.
129. Add source-level rollback for user-rule batches.
130. Add import preview showing what capabilities a user rule file would enable before installation.
131. Add selector risk classification before any cosmetic injection.
132. Reject broad generic selectors on app-shell, auth-sensitive, payment-sensitive, and low-confidence profiles.
133. Downgrade risky cosmetic selectors to observe-only on unknown or ambiguous apps.
134. Add cosmetic selector provenance and decision records.
135. Add CSS injection inventory per tab, frame, document, layer, selector source, and policy revision.
136. Add CSS removal records and cleanup on navigation, safe-mode entry, extension update, extension reload, and layer stop.
137. Add CSS cascade-layer and injection-order management so extension CSS cannot unpredictably override application CSS.
138. Add CSS scope isolation for injected cosmetic styles where feasible.
139. Add CSS specificity budgets to prevent generated selectors from becoming too broad or dominant.
140. Add layout-shift budgets for cosmetic actions with rollback when hiding/removal causes excessive collapse.
141. Add protected-UI checks before any hide/remove/neutralize action.
142. Expand protected UI checks beyond YouTube to app roots, forms, inputs, textareas, buttons, nav, dialogs, contenteditable, auth/payment containers, and large viewport containers.
143. Add smart-cosmetic plan validation before loading.
144. Add smart-cosmetic plan provenance and schema validation.
145. Restore local fail-closed policy check inside `smart-content.ts` before `SmartRuntime.init()` and plan fetch.
146. Ensure smart-cosmetic wildcard restrictions apply in active generated bundles, not only source.
147. Fail CI if production smart rules can target wildcard hosts without test-only or explicit safety approval.
148. Add smart-cosmetic decision reports for allowed, rejected, downgraded, and observe-only rules.
149. Add virtualized-list safety model so scanners do not misclassify recycled rows or dynamic placeholders as ads.
150. Add web-component and shadow-DOM protection for custom elements, slots, portals, closed/open shadow roots, and app-shell web components.
151. Replace hostname-based video adapter allowlists with generated adapter capability metadata.
152. Require each video adapter to declare supported domains, player signals, action types, confidence thresholds, mutation capabilities, and rollback support.
153. Require high-confidence video detection before mutation.
154. Keep medium-confidence video detections observe-only.
155. Make low-confidence video detections no-op.
156. Add video action simulator before applying mutation.
157. Add click-safety rules for all automated click actions, not only video skip buttons.
158. Require explicit user gesture or adapter evidence before any automated click.
159. Add click replay protection so the same control is not repeatedly clicked after SPA updates.
160. Add skip-click cooldowns per tab/frame/player/ad-break.
161. Add player/container protected-UI checks before overlay hiding/removal.
162. Add video observer budgets and backoff by profile and adapter.
163. Add tests for normal video calls, embedded players, custom controls, fullscreen, captions, accessibility controls, and non-ad overlays.
164. Add video mutation rollback on safe-mode entry and layer stop.
165. Add video diagnostics showing why a player was observed, skipped, or mutated.
166. Make first-party DOM detector use observer budgets and scan budgets.
167. Avoid full-document `querySelectorAll('*')` scans on complex apps.
168. Add time budgets, max-node budgets, and backoff for first-party DOM detection.
169. Make first-party DOM marker changes reversible through a marker ledger.
170. Add DOM marker privacy/safety policy so marker classes cannot expose sensitive page structure or trigger site anti-extension detection unless approved.
171. Prevent first-party DOM detector from reading or logging text content, form values, chat messages, or user identifiers.
172. Gate heuristic fetch/XHR interceptors behind separate response-mutation policy.
173. Require response-mutation capability tokens and provenance.
174. Add response-mutation simulator before wrapping fetch/XHR or modifying responses.
175. Add response-mutation rollback/disable path for wrappers and prototype changes.
176. Add tests proving response mutation is off on app-shell, auth-sensitive, payment-sensitive, low-confidence, and unknown profiles.
177. Add tests proving response mutation cannot be enabled by generic full-content policy alone.
178. Add a main-world bridge protocol with strict schemas, origin binding, frame/document binding, nonce/capability validation, and teardown.
179. Add tests proving page scripts cannot spoof extension bridge messages.
180. Add tests proving extension-injected main-world hooks cannot leak extension internals to page scripts.
181. Replace always-registered webRequest listeners with an instrumentation manager if feasible.
182. If listeners remain registered, prove callbacks do no recording or expensive work unless instrumentation has an active owner.
183. Bind instrumentation activation to logger/popup lifecycle with timeouts and cleanup.
184. Clear logger and popup tracking flags on close, timeout, tab close, service-worker restart, and extension update.
185. Add privacy classes for logger fields, DNR reports, runtime health, compatibility history, local recorder output, and debug exports.
186. Add a shared diagnostics redaction pipeline.
187. Add a no-raw-page-content invariant covering text content, form values, chat messages, selectors, stack traces, URLs, query strings, error messages, and local history.
188. Prevent raw query strings from being stored in logger records.
189. Prevent private page structure from leaking through selectors or marker diagnostics.
190. Add privacy tests for page signals, logger entries, compatibility recorder, DNR install reports, runtime health, and debug exports.
191. Add retention policies for diagnostics, install reports, compatibility history, runtime health, and local recorder files.
192. Add user-data deletion and export paths for local diagnostic and compatibility artifacts.
193. Add storage quota manager for rule caches, diagnostics, compatibility history, local recorder output, runtime health, and generated reports.
194. Add rotation/expiry for local-only compatibility recorder output.
195. Make page classification use structural signals with confidence and uncertainty reasons.
196. Add classification drift tests so heuristic changes do not silently widen policy.
197. Add tests for ambiguous pages that look like app shell, news/content, and video site at the same time.
198. Add fixtures for app shell, auth, payment, chat stream, video site, normal media player, video call, news with ads, SPA, shadow DOM, iframe-heavy, anti-adblock, virtualized list, and web components.
199. Generate compatibility fixtures from compatibility metadata.
200. Add reproducible minimal breakage-case generation from compatibility reports using structural signals rather than private page content.
201. Add decision-replay harness that replays a structural snapshot through policy, simulator, layer activation, and action arbitration.
202. Add breakage-corpus runner covering policy, DNR, cosmetics, smart cosmetics, video, response mutation, scriptlets, and instrumentation.
203. Add per-profile expected-action snapshots.
204. Add per-layer expected-action snapshots.
205. Add fixture coverage metric by profile, layer, browser capability, and risk class.
206. Add compatibility tests for sites detecting extension behavior through timing, DOM markers, CSS side effects, missing ad slots, bridge messages, or injected resources.
207. Use `browser-capabilities.json` in active policy resolution, not only as documentation.
208. Make browser capabilities affect DNR generation, regex usage, session rules, dynamic injection, scriptlets, main-world hooks, and webRequest strategy.
209. Generate browser-specific manifests from policy and capability profiles.
210. Add CI proving Chromium, Edge, Firefox MV3, and unknown-browser capability profiles fail safe.
211. Add generalized optional-permission request strategy so permissions are requested only when a feature needs them.
212. Add permission-to-layer map explaining which layers require which browser permissions and why.
213. Add graceful behavior when optional permissions are missing, denied, revoked, or unsupported.
214. Run policy resolution tests with each major permission removed.
215. Add special handling for prerendered pages, frozen pages, discarded tabs, restored tabs, BFCache, browser restart, and extension reload.
216. Add graceful degradation when storage, DNR, scripting, webRequest, permissions, generated assets, policy JSON, browser capability profile, or filter-list catalog are unavailable.
217. Add offscreen-document and worker/worklet policy if those surfaces are ever used.
218. Add mobile/low-resource browser profile behavior if the extension targets mobile-like environments.
219. Define anti-adblock countermeasure capabilities separately from normal scriptlets and main-world hooks.
220. Require anti-adblock countermeasures to be site/profile-specific, never generic-on-unknown-pages.
221. Add anti-adblock response model distinguishing detection countermeasures from ordinary ad blocking.
222. Add web-accessible-resource exposure budget and ownership.
223. Limit which resources may be loaded by pages, frames, injected scripts, redirects, or surrogates.
224. Add CSP compatibility model for injected scripts, main-world bridges, extension pages, and extension resources.
225. Add tests for extension-origin leaks, resource probing, externally connectable surfaces, and page access to web-accessible resources.
226. Add timing side-channel checks for visible extension behavior where feasible.
227. Add marker and class-name randomization or policy if stable marker names cause detection risk.
228. Add user-facing explanation when a page is in safe mode or observe-only mode.
229. Add user-facing restore button for a safe-mode tab.
230. Add user-facing diagnostics export for a tab with privacy redaction.
231. Add user-facing toggles for experimental heuristic interceptors, first-party DOM detection, smart cosmetics, video mutation, procedural cosmetics, and anti-adblock countermeasures.
232. Make experimental toggles profile-aware and fail safe on sensitive profiles.
233. Add generalized user-intent model: default blocking, temporary site override, permanent trusted site, per-layer override, emergency safe mode, and developer dry run.
234. Add managed-policy schema and controls for disabled runtimes, allowed filter lists, permissions, telemetry/diagnostics, debug features, and enterprise safe defaults.
235. Ensure managed policy cannot be bypassed by user override unless explicitly designed.
236. Add UI evidence that shows active policy, profile confidence, layer states, and recent rejected actions without exposing private data.
237. Add accessibility-preservation checks before hiding/removing/neutralizing elements.
238. Protect focus order, active element, keyboard navigation, labels, ARIA relationships, live regions, captions, media controls, dialogs, and skip links from generic mutations.
239. Add rollback when an action removes focused elements or breaks keyboard interaction.
240. Add tests for screen-reader-relevant structures and keyboard-only interaction on app/auth/payment/video pages.
241. Add pointer-event and z-index safety checks so overlays are not removed in a way that traps or blocks user interaction.
242. Add color/visibility checks so injected CSS does not hide required UI in high-contrast or accessibility modes.
243. Add internationalization-safe detection so non-English pages are not misclassified by English-only ad text heuristics.
244. Add energy/battery-aware budgets for observers, scans, DNR reconciliation, logger tracking, and simulator runs.
245. Add memory-pressure handling for large pages, many tabs, large reports, and long logger sessions.
246. Add per-layer CPU, memory, observer, timer, and DOM-query budgets.
247. Add performance timeline diagnostics for runtime activation and mutation decisions.
248. Add hard stop for layers exceeding budget repeatedly.
249. Add release performance budget checks for cold start, page load injection, DNR sync, filter-list compilation, and large-page scanning.
250. Add tests that no instrumentation/diagnostics runs when no UI or runtime consumer needs it.
251. Add source ownership gate for all generated and active runtime files.
252. Add generated artifact freshness and bundle drift checks.
253. Add active bundle vs source parity checks.
254. Add release manifest parity checks that fail on missing/extra content-script entries or unsafe permission widening.
255. Add manifest-surface checks for new `<all_urls>`, `all_frames`, `match_about_blank`, `world: MAIN`, broad host permissions, web-accessible resources, and remote-code risks.
256. Tie compatibility-debt checks to actual manifest exceptions and runtime exception paths.
257. Fail CI when manifest exception metadata is missing, expired, ownerless, fixtureless, or already replaceable by completed generalization.
258. Add command graph proving all new gates run under `check:all`, release verification, and packaged-extension verification.
259. Reduce duplicate npm check aliases and group checks by safety domain, runtime layer, and release/store compliance.
260. Add stale-check detection for tools that only print warnings or cannot fail.
261. Add tests ensuring every check script exits nonzero on a seeded violation.
262. Add tests ensuring no evidence/certificate/check script is hardcoded to pass.
263. Add tests ensuring every architecture primitive is active, advisory, experimental, or intentionally dead.
264. Add dead-primitive detector for scaffolding that is not used by active runtime paths.
265. Add scaffolding-to-runtime gate requiring every new primitive to declare status and integration path.
266. Remove `@ts-nocheck` from high-risk runtime modules.
267. Add strict TypeScript types for policy objects, page signals, capability tokens, DNR install decisions, runtime health, auto-recovery, compatibility metadata, layer registry entries, and service-worker messages.
268. Add versioned service-worker/content-script message schemas.
269. Validate message sender origin, tab, frame, document, channel, command, payload, and response shape.
270. Add runtime API stability layer so content scripts do not depend on ad-hoc service-worker response shapes.
271. Add lint rules forbidding direct DOM mutation outside safe-action APIs.
272. Add lint rules forbidding direct `MutationObserver` outside observer manager.
273. Add lint rules forbidding direct DNR update calls outside transaction manager.
274. Add lint rules forbidding direct `chrome.scripting.executeScript` outside activation manager.
275. Add lint rules forbidding direct `chrome.webRequest.*.addListener` outside instrumentation manager.
276. Add lint rules forbidding new hostname exception lists outside compatibility metadata.
277. Add lint rules forbidding raw URL/hostname parsing outside shared utilities where practical.
278. Add lint rules forbidding hardcoded profile names outside schema/types.
279. Add lint rules forbidding policy widening without policy-diff update.
280. Add lint rules forbidding global wildcard smart cosmetic rules in production.
281. Centralize URL and hostname normalization in a shared utility.
282. Use public suffix / registrable-domain handling where policy needs site-level decisions.
283. Replace ad-hoc hostname parsing and `endsWith` checks with shared utility functions.
284. Add tests for invalid URLs, IDNs/punycode, subdomains, IP addresses, localhost, extension URLs, `data:`, `blob:`, `filesystem:`, browser special pages, and opaque origins.
285. Add initiator/request/first-party/third-party classification helpers and tests.
286. Add shared domain grouping for compatibility history and diagnostics.
287. Make auto-recovery downgrade policy for the tab, not only record safe-mode state.
288. Make auto-recovery stop already-started layers.
289. Make auto-recovery remove injected CSS and rollback known mutations where possible.
290. Make auto-recovery disable smart cosmetics, first-party DOM detection, video mutation, response mutation, scriptlets, and high-risk DNR for the tab.
291. Add generalized anti-breakage scoring from DNR evidence, DOM mutation evidence, user reloads, runtime errors, hidden viewport area, layout collapse, focus loss, and interaction failures.
292. Add visible diagnostics for auto-recovery decisions.
293. Add tests for entering safe mode, stopping layers, restoring page state, and resuming safely.
294. Add generalized observe-only mode that all high-risk layers can enter consistently with shared reporting and no mutation side effects.
295. Add generalized dry-run mode for development/testing that runs classifier, simulator, action planner, and reports without applying mutations.
296. Add strict app mode for unknown complex apps forcing all layers to specific-only or observe-only unless evidence is strong.
297. Add release-risk score combining manifest surface, permission surface, runtime layers, DNR risk, compatibility debt, policy widening, diagnostics privacy, and fixture coverage.
298. Add policy coverage metric showing percentage of active runtime code paths governed by explicit policy fields.
299. Add capability coverage metric showing percentage of mutation/action paths requiring validated capability tokens.
300. Add site-exception burn-down metric tied to real manifest exceptions, compatibility metadata, fixtures, and passing generalized behavior.
301. Add layer-startup certificate proving each active layer has policy gate, capability requirements, budget, rollback, diagnostics, and fixtures.
302. Add ADR/change-control process for new capabilities, new permissions, new runtime layers, and policy widening.
303. Add risk-owner metadata for every high-risk capability and runtime layer.
304. Add release-blocking review for new MAIN-world hooks, response mutation, broad DNR rules, web-accessible resources, and remote update channels.
305. Add migration plan for removing backward-compatible legacy policy fields and prototype-only paths.
306. Add deprecation/removal workflow for obsolete runtime code and temporary compatibility shims.
307. Add cleanup inventory proving old helpers and duplicate checks are either active, migrated, or deleted.
308. Add documentation that maps each runtime layer to policy fields, capabilities, permissions, fixtures, diagnostics, and failure modes.
309. Add developer prompt/checklist requiring new features to declare risk class, policy field, capability, tests, privacy behavior, rollback, and release gate.
310. Add incognito/private-browsing policy separation so normal browsing diagnostics, rules, compatibility history, and safe-mode state never leak into incognito contexts.
311. Support browser incognito split/spanning modes with explicit storage, policy, logging, and rule-install behavior for each mode.
312. Add tests proving trusted-site state, compatibility debt, diagnostics, and local recorder output are isolated between normal and incognito contexts.
313. Add a settings/config schema registry covering user settings, filter-list selections, dynamic rules, trusted sites, experimental flags, and managed-policy overlays.
314. Add transactional settings migration with backup, rollback, validation, and post-migration policy replay.
315. Add import/export validation for settings, user rules, trusted sites, filter-list subscriptions, and experimental flags before applying them.
316. Add import preview that explains policy widening, high-risk capabilities, remote subscriptions, broad allow rules, and compatibility exceptions introduced by an imported configuration.
317. Add configuration provenance and audit records for changes made by user UI, import, managed policy, migration, extension update, developer tool, or recovery logic.
318. Add local-vs-sync storage policy so high-risk settings, diagnostics, compatibility history, and private/incognito state cannot be synced accidentally.
319. Add offline-first startup behavior that uses the last known-good policy/ruleset snapshot when remote lists, update metadata, or catalogs are unavailable.
320. Add last-known-good snapshot selection for policy JSON, filter-list catalog, compiled rules, browser capability profile, and compatibility metadata.
321. Add release/version rollback support for settings schemas, rule schemas, generated artifacts, and policy schemas after a bad extension update.
322. Add idempotency tests for startup reconciliation, degraded allow mode, safe-mode entry, DNR transactions, settings migration, artifact generation, and cleanup tools.
323. Add sandboxed filter-list compilation with CPU, memory, time, recursion, regex, and output-size limits so malformed or hostile lists cannot freeze the extension or build.
324. Add safe-regex analysis for DNR regex filters, procedural cosmetic regexes, parser regexes, and user/imported regex rules to prevent catastrophic backtracking and unsupported constructs.
325. Add procedural-selector complexity analysis estimating DOM traversal cost before enabling `:has`, `:matches-css`, XPath-like, text-like, or ancestor/descendant-heavy selectors.
326. Add scriptlet allowlist and capability metadata so filter lists and user rules can only invoke approved scriptlets with declared arguments, risk class, profile limits, and rollback behavior.
327. Add scriptlet argument schema validation and normalization before injection.
328. Add differential compatibility tests against expected uBO-style filter semantics for supported syntax so generalization does not silently break standard filter behavior.
329. Add effectiveness regression suite measuring ad-blocking coverage, false positives, false negatives, breakage rate, and observe-only downgrades across network, cosmetic, video, and scriptlet corpora.
330. Add benchmark anti-overfitting checks so public adblock test pages cannot justify unsafe generic rules that would break real app-shell/auth/payment pages.
331. Add a formal threat model covering malicious pages, malicious filter lists, hostile imported rules, compromised remote update metadata, overbroad user overrides, extension fingerprinting, and page-to-extension message spoofing.
332. Map every high-risk capability to threat-model entries, mitigations, tests, and release gates.
333. Add abuse-case fixtures for hostile pages that try to trigger extension selectors, spoof bridge messages, exploit web-accessible resources, force expensive scans, or manipulate diagnostics.
334. Add operational audit log for high-risk events: policy widening, capability grant, DNR transaction, degraded allow mode, safe-mode entry, imported rules, remote list update, and compatibility exception use.
335. Add audit-log privacy policy, retention limits, export/delete support, and incognito exclusion by default.
336. Add local emergency kill-switch that disables high-risk layers and enters observe-only/degraded-safe behavior without requiring a remote server.
337. Add staged release gates that compare current release artifact risk against previous release artifact risk before packaging.
338. Add release rollback certificate documenting last-known-good version, schema compatibility, migration reversibility, and disabled high-risk layers after rollback.
339. Add ownership and lifecycle rules for every experimental feature so experiments cannot remain indefinitely enabled without promotion, removal, or expiry.
340. Add feature expiry gates for experimental heuristic interceptors, anti-adblock countermeasures, smart cosmetics, generic video mutation, and first-party DOM detection.
341. Add cross-extension interference tests for pages with other common extensions installed, especially extensions that also inject CSS, hook fetch/XHR, modify video players, or alter CSP.
342. Add browser privacy-mode and tracking-protection interaction tests so built-in browser blockers and extension rules do not produce contradictory policy or diagnostics.
343. Add multi-tab stress tests for many simultaneous app, video, auth, and news pages to verify shared quotas, DNR updates, observers, instrumentation, and storage cleanup remain bounded.
344. Add failure-injection tests for browser API calls: DNR partial failure, storage quota failure, scripting denial, permission revocation, webRequest errors, tab lookup failure, and content-script message timeout.
345. Add user-support diagnostic bundles that include policy decisions, layer states, rule provenance, and health status while redacting URLs, selectors, page text, form data, and incognito state.
346. Add extension-page UI hardening for popup, options, dashboard, logger, reports, and developer pages so untrusted filter names, rule text, URLs, diagnostics, and imported configuration cannot become extension-page XSS.
347. Add a safe extension-UI rendering layer that forbids `innerHTML`/HTML string injection for untrusted data and requires typed renderers for log entries, filter rows, rule reports, diagnostics, and import previews.
348. Add extension-page CSP checks for all UI pages, including no remote scripts, no unsafe eval, no inline event handlers, and explicit nonce/hash policy where inline bootstrapping is unavoidable.
349. Add URL/link safety checks for all UI-generated links so diagnostics, logger rows, rule reports, and support bundles cannot create javascript/data/open-redirect links or unsafe extension-resource links.
350. Add request-header and response-header modification as separate high-risk network capabilities, distinct from block, allow, redirect, upgrade, and surrogate actions.
351. Add DNR `modifyHeaders` risk classification, provenance, policy fields, capability tokens, and tests for request headers, response headers, cookies, CSP, CORS, authorization, referrer, origin, and cache-control changes.
352. Prohibit generic modification of authentication, cookie, security, CSP, CORS, origin, referrer, and payment-relevant headers unless a rule is site-specific, high-trust, explainable, and covered by fixtures.
353. Add release gates proving no filter list, user rule, static ruleset, or imported configuration can introduce broad header mutation without explicit policy approval and provenance.
354. Add a user-gesture capability model for manual tools such as element picker, element zapper, context-menu actions, temporary unblock, logger replay, diagnostics capture, and per-site emergency controls.
355. Keep manual user-gesture actions separate from automatic runtime policy so a one-time picker/zapper action cannot silently become a persistent generic rule without validation and preview.
356. Add undo, expiry, provenance, and protected-UI checks for manual element picker/zapper changes, especially on app-shell, auth, payment, accessibility, and video-control surfaces.
357. Add message-rate limiting, backpressure, and per-sender quotas for content-script, popup, logger, dashboard, devtools, extension-page, and main-world bridge message traffic.
358. Add noisy-sender quarantine so a tab/frame/page that sends repeated invalid, oversized, stale-version, or unauthorized messages is downgraded without affecting other tabs.
359. Add a central cancellable job queue for expensive work such as filter compilation, policy replay, simulator runs, report generation, local recorder processing, and diagnostics export.
360. Add a no-remote-telemetry invariant: no diagnostic, compatibility, rule, URL, performance, or page-signal data may leave the browser unless a future explicit opt-in telemetry system is designed, documented, and gated.
361. Add a network-egress allowlist for the extension itself, covering filter-list updates, update metadata, support links, remote assets, and any future diagnostics endpoint, with purpose, owner, privacy class, and release profile.
362. Add tests proving extension pages, service worker, content scripts, and injected runtimes cannot make unexpected remote requests outside approved update/fetch channels.
363. Add sync-storage conflict handling across devices for trusted sites, user rules, filter-list selections, settings, experimental flags, compatibility state, and managed-policy overlays.
364. Add deterministic merge rules for concurrent settings changes from UI, import, sync, migration, managed policy, recovery, and extension update.
365. Add versioned user-configuration backups and restore points separate from release rollback, with privacy filtering and incognito exclusion.
366. Add static-ruleset lifecycle governance: every static ruleset must declare owner, source, capability class, risk profile, enabled profiles, rule-count budget, priority band, and browser support.
367. Make static ruleset enable/disable decisions profile-aware so whole rulesets cannot activate high-risk behavior on app-shell, auth, payment, low-confidence, or unknown profiles.
368. Add static/dynamic/session DNR quota coordination so static ruleset choices, user rules, temporary allow rules, redirects, surrogates, and recovery rules cannot starve each other at runtime.
369. Add third-party dependency and build-toolchain supply-chain hardening: lockfile integrity, SBOM generation, license policy, vulnerability gates, package provenance, and pinned Node/npm/build versions for release builds.
370. Add reproducible-build verification from clean checkout to packaged extension, proving the released artifact matches source, generated bundles, manifest profile, policy JSON, and ruleset artifacts.
371. Add hostile-DOM resilience for content scripts: avoid trusting clobberable DOM globals, page-controlled IDs/names, polluted prototypes, fake elements, hostile getters, or monkey-patched DOM methods without safe references.
372. Add prototype-wrapper stewardship for fetch, XHR, history, timers, media APIs, and other wrapped APIs so wrappers compose with page code and other extensions, preserve native semantics, and can be restored safely.
373. Add explicit history/navigation API hook policy because SPA navigation hooks can affect app routing and should be separate from ordinary scriptlets or main-world hooks.
374. Add clipboard, download, notification, and external-navigation safety policy if any feature or future feature touches those browser surfaces, so ad-blocking logic cannot accidentally become a broader browser-action surface.
375. Add support-bundle minimization policy: generated support/debug bundles should include enough replayable evidence to debug policy decisions while excluding raw page content, account identifiers, full URLs, screenshots, and incognito/private state by default.

376. Add a central browser-API gateway/facade so high-risk `chrome.*` / `browser.*` calls are policy-checked, capability-checked, retry-aware, auditable, and testable instead of scattered across runtime files.
377. Fail CI if high-risk browser APIs are called directly outside the gateway, including DNR, scripting, webRequest, tabs, windows, webNavigation, contextMenus, commands, alarms, storage, permissions, privacy, downloads, notifications, side panel, devtools, offscreen documents, native messaging, external messaging, and proxy-like surfaces if ever used.
378. Add API-specific contracts for non-DNR browser surfaces so each API declares owner, permission, policy field, allowed caller types, user-gesture requirements, incognito behavior, failure mode, and release profile.
379. Add a scheme/protocol capability matrix defining behavior for `http:`, `https:`, `ws:`, `wss:`, `file:`, `ftp:`, `data:`, `blob:`, `filesystem:`, `about:`, `chrome:`, `edge:`, `moz-extension:`, `chrome-extension:`, `urn:`, opaque origins, and browser special pages.
380. Add private-network and localhost egress protection for extension-initiated fetches, redirects, surrogates, diagnostics, and remote assets, including RFC1918, loopback, link-local, IPv6 local, `.local`, metadata-service addresses, and enterprise intranet domains.
381. Add CNAME/cloaking semantics policy: explicitly support CNAME-uncloaking only when browser capabilities and privacy constraints allow it, otherwise mark the capability unsupported and prevent rules/reports from implying it works.
382. Add property-based and fuzz testing for filter parsing, DNR compilation, URL/domain normalization, message schemas, policy resolution, selector parsing, imported configuration, migration, backup/restore, and diagnostic-bundle parsing.
383. Add hostile-input size, depth, count, and time limits before parsing untrusted filter lists, user-rule files, imported settings, diagnostics, local-recorder files, JSON reports, message payloads, and support bundles.
384. Add a cross-store compliance matrix for Chrome Web Store, Edge Add-ons, Firefox/AMO MV3, enterprise deployments, and unpacked developer builds, mapping each store profile to permissions, remote-code limits, privacy disclosures, review evidence, and disabled experimental features.
385. Add explicit consent/review flows for high-risk user-enabled features so enabling experimental interceptors, response mutation, main-world hooks, broad user rules, header mutation, anti-adblock countermeasures, or imported subscriptions requires preview, explanation, rollback, and expiry.
386. Add a shadow-mode rollout system where new generalized policy/rule/compiler behavior can run observe-only beside the current behavior, compare decisions, record local differences, and promote only after breakage/effectiveness thresholds pass.
387. Add candidate-policy and candidate-ruleset replay against saved local structural snapshots so policy changes can be evaluated before becoming the active runtime decision path.
388. Add a standard breakage taxonomy that maps failure signals to root-cause categories, affected layer, safe downgrade, fixture requirement, owner, and regression test requirement.
389. Add triage automation that converts auto-recovery, compatibility recorder, DNR install reports, and runtime health into actionable local issue bundles without exposing private page content.
390. Add an explicit dynamic-code execution policy covering `eval`, `new Function`, dynamic `import()`, `importScripts`, WebAssembly, blob-script URLs, data-script URLs, remote source maps, and generated bundles.
391. Add release gates proving dynamic-code and WebAssembly surfaces are absent or explicitly justified by profile, source, owner, CSP, and store-compliance evidence.
392. Add semantic versioning for every persistent schema and public internal protocol: policy JSON, browser capabilities, compatibility metadata, install reports, runtime health, local recorder, settings, user rules, backups, service-worker messages, and capability tokens.
393. Add schema compatibility tests proving older supported profiles can migrate forward, unsupported old profiles fail safe, and downgrade/rollback paths do not corrupt user settings or rule state.
394. Add an explicit “definition of generalized enough” exit checklist with measurable thresholds for policy coverage, capability-token coverage, fixture coverage, mutation reversibility, compatibility-debt burn-down, false-positive rate, breakage rate, and release-risk score.
395. Add a final-generalization certificate generated at release time showing which remaining host exceptions, broad injections, warning-only checks, hardcoded confidence lists, high-risk capabilities, and unsafe fallbacks still exist.

## Highest-value first batches

1. Replace broad manifest injection with thin bootstrap and policy-loaded layers.
2. Make `page-policy.json` the actual source of truth and remove hardcoded host confidence lists.
3. Split coarse capabilities such as interceptors, DOM detection, response mutation, smart cosmetics, and video mutation.
4. Restore local fail-closed policy gates inside every runtime layer.
5. Make capability tokens unforgeable, revision-bound, and required for all mutations.
6. Route all runtime starts/stops through the activation manager and layer lifecycle manager.
7. Make DNR updates transactional and remove fallback block-rule paths completely.
8. Turn warning-only checks into failing CI gates and prove every check can fail on seeded violations.
9. Add action arbitration so layers cannot conflict on the same DOM node/request/player.
10. Add privacy-preserving replay/fixture generation so breakage can be reproduced without private page content.
11. Add settings/config schema migration, import/export validation, and last-known-good rollback.
12. Add incognito/private-mode isolation for policy, rules, diagnostics, recorder output, and storage.
13. Add sandboxed filter-list compilation plus safe-regex and procedural-selector complexity checks.
14. Add differential filter-semantics tests and effectiveness/breakage regression metrics.
15. Add formal threat modeling, abuse-case fixtures, and audit logs for high-risk capability grants.
16. Add release rollback certificates and staged release-risk comparison against the previous artifact.
17. Harden extension pages and UI renderers against XSS from untrusted rules, diagnostics, URLs, and imported configuration.
18. Add explicit header-mutation policy for DNR `modifyHeaders`, security headers, cookies, CORS, authorization, and referrer/origin changes.
19. Make manual tools gesture-bound, reversible, expiring, and separate from automatic runtime policy.
20. Add message backpressure, noisy-sender quarantine, and a cancellable job queue for expensive work.
21. Add no-remote-telemetry and extension network-egress invariants.
22. Add sync-storage conflict handling, deterministic settings merges, and user-configuration restore points.
23. Add static-ruleset lifecycle governance and static/dynamic/session quota coordination.
24. Add supply-chain/reproducible-build hardening and SBOM/provenance gates.
25. Add hostile-DOM and prototype-wrapper resilience for content scripts and main-world hooks.
26. Add a central browser-API gateway and direct-call CI ban for high-risk extension APIs.
27. Add property-based/fuzz testing for parsers, normalizers, messages, policy, imports, and migrations.
28. Add private-network/localhost egress protection and a scheme/protocol capability matrix.
29. Add cross-store compliance matrix and consent/review flows for high-risk user-enabled features.
30. Add shadow-mode rollout and candidate-policy replay before promotion.
31. Add dynamic-code/WebAssembly policy and release gates.
32. Add final-generalization certificate and measurable exit checklist.
