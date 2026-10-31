# uBlock Resurrected Full Remaining Generalization List v8

Updated: 2026-06-27
Baseline: post-`b57ad2390a213f5afd1ddb2db395959935589d39` remaining-work discussion plus v7 addendum.

Purpose: one full end-to-end numbered list of remaining substantial generalization work. This is not an addendum. Minor duplicates and tiny implementation variants were consolidated into broader work items.

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