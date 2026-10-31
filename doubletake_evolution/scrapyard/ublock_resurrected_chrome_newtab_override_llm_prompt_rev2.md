# uBlock Resurrected — Chrome New Tab Replacement Feature Coding Prompt

Revision: rev2 — expanded to 10/10 coverage for Chrome internal New Tab boundaries, manifest/profile determinism, CSP, stale artifact checks, incognito/extension-conflict documentation, and runtime resilience.

## Role
You are an expert Manifest V3 Chrome extension engineer working inside the repository:

```text
Astrocytech/uBlockResurrected
```

Implement a safe, local, optional Chrome New Tab replacement feature so the extension can remove/avoid Google-controlled promotional/content modules shown on Chrome's built-in New Tab page.

This task is **not** about injecting cosmetic filters into `chrome://newtab`. Treat the built-in Chrome New Tab page as a browser-owned internal page that cannot be reliably modified by normal content-script/cosmetic-filter machinery. The correct implementation path is a Chrome-compliant local `chrome_url_overrides.newtab` page.

---

## Core goal

Add an optional extension-owned New Tab page that replaces Chrome's default New Tab page with a clean, local, private, ad-free page.

The feature must:

- use `chrome_url_overrides.newtab`;
- be implemented with local extension files only;
- make no remote requests;
- include no remote scripts, no remote CSS, no remote fonts, no remote images, no feeds, no telemetry, no ads;
- avoid imitating Chrome's default New Tab page in a confusing way;
- preserve normal address-bar/omnibox behavior;
- be controlled by build/profile configuration if the project already separates dev/store/release profiles;
- be tested and audited as part of the internal functionality/readiness pipeline.

---

## Non-goals and hard boundaries

Do **not** do any of the following:

- Do not claim the extension can inject cosmetic filters into Chrome's original `chrome://newtab` page.
- Do not attempt to inject content scripts into `chrome://newtab`.
- Do not depend on undocumented Chrome internal DOM structure.
- Do not scrape, block, corrupt, fake, or simulate Google ad/impression/click/viewability/beacon traffic.
- Do not download Google promotional modules merely to hide them.
- Do not add network interception aimed at tricking Google services.
- Do not add remote New Tab content.
- Do not make the New Tab page look like Chrome's built-in page in a way that could confuse users.
- Do not request new permissions unless strictly required.
- Do not silently force the override in profiles where it is not intended.

The safe supported strategy is: **replace the New Tab page with a local extension page**.


Additional Chrome-specific boundaries to respect:

- Treat all of these as browser/internal New Tab surfaces, not normal web pages: `chrome://newtab`, `chrome://new-tab-page`, `chrome-search://local-ntp`, `chrome-search://most-visited`, and any similar Chrome-owned NTP URL discovered during testing.
- Do not add content-script matches, DNR rules, webRequest logic, or CSS injection aimed at those internal URLs.
- Do not add host permissions for this feature.
- Do not add `chrome_settings_overrides` or search-provider changes. This feature is New Tab replacement only.
- Do not assume the override can be toggled at ordinary runtime. A New Tab override is manifest-level behavior; runtime settings may change the local page contents, but not whether Chrome routes New Tab to the extension.
- Document that only one installed extension can control the New Tab page at a time and that another extension/browser policy may take precedence.
- Document that incognito behavior depends on whether the user explicitly enables the extension in incognito; do not attempt to bypass that.

---

## Current expected implementation model

### 1. Add a local New Tab page

Create files such as:

```text
platform/chromium/pages/newtab.html
platform/chromium/css/newtab.css
platform/chromium/js/newtab.js
```

or the equivalent paths already used by the project for extension pages.

The page should be minimal and local-first.


Strict page requirements:

- Use a separate local JS file rather than inline script.
- Use a separate local CSS file rather than inline remote/loading CSS.
- Add a restrictive extension-page CSP if the project has page-level or manifest CSP handling, preferably `script-src 'self'; object-src 'none'; base-uri 'none'; frame-ancestors 'none'` unless existing project policy requires a different compatible form.
- Do not include iframes, remote previews, weather/news/trending modules, sponsored tiles, recommendation feeds, remote favicons, or most-visited-site scraping in the first implementation.
- Do not read browsing history or top sites unless the project already has a reviewed local-only UX for it; default to no history/top-sites integration.
- Do not write to storage on page load except for explicit local preferences the user changes.
- No third-party packages should be added just for this page unless already present and audited.

Recommended first version:

- title: `uBlock Resurrected New Tab` or similar;
- simple centered layout;
- optional search form that submits to the user's chosen/default search URL only if the project already has a safe search preference model;
- otherwise provide a simple blank/private start page with no network activity;
- no auto-focus stealing from the omnibox;
- no remote assets;
- no inline scripts if the extension CSP forbids or audits inline scripts;
- accessible semantic HTML;
- prefers reduced motion;
- supports light/dark mode through CSS only;
- no telemetry or analytics.

If a search box is included, it must be explicit and local. It must not override the omnibox or capture address-bar searches.

---

### 2. Add manifest override support

Add this only in the intended Chrome build/profile:

```json
"chrome_url_overrides": {
  "newtab": "pages/newtab.html"
}
```

Important constraints:

- Chrome allows an extension to override only one of the supported Chrome pages; do not collide with existing `bookmarks`, `history`, or other overrides.
- Only enable the override in the intended profile.
- If the project has separate manifest generation for dev/store/release, integrate this into the generator rather than hand-editing only the generated manifest.
- If the project already treats `platform/chromium/manifest.json` as generated output, update the canonical source/generator and regenerate.
- If release and dev manifests differ, add a clear config switch such as:

```text
UBR_ENABLE_NEWTAB_OVERRIDE=1
```

or use the existing build-profile mechanism.

Default choice:

- If this is intended as a core user-facing feature, enable it in normal Chromium builds and release builds.
- If there is concern about Chrome Web Store review or user expectation, make it an explicit build/profile option and document it.

---

### 3. Add a feature flag/config path

Add a single source of truth for whether New Tab override is enabled.

Acceptable implementations:

- manifest generator option;
- build profile flag;
- package script/profile flag;
- existing project config file.

Do not scatter hardcoded conditionals across many files.

The final behavior must be deterministic:

```text
same inputs/profile -> same manifest -> same packaged extension
```

---

### 4. Add audits/checks

Add a dedicated checker, for example:

```text
tools/check-newtab-override.mjs
```

The checker must verify:


Profile and manifest checks must also verify:

- no `content_scripts.matches` entry targets internal New Tab URLs;
- no DNR rule targets `chrome://`, `chrome-search://`, or other browser-internal schemes;
- no new host permissions or optional host permissions were added solely for New Tab replacement;
- no `chrome_settings_overrides` search-provider override was introduced;
- `chrome_url_overrides` contains only the intended `newtab` entry and no accidental `bookmarks` or `history` override;
- release and dev profiles either match the documented policy or intentionally differ with a named build flag.

- manifest has `chrome_url_overrides.newtab` only when the selected profile expects it;
- override path points to an existing local file;
- the New Tab HTML loads only local extension assets;
- no `http://` or `https://` resources appear in newtab HTML/CSS/JS;
- no remote fonts, remote images, remote stylesheets, remote scripts, analytics, telemetry, or feed URLs exist;
- no inline remote-loading code exists;
- no `fetch`, `XMLHttpRequest`, `sendBeacon`, dynamic `import()`, WebSocket, EventSource, or remote iframe appears in New Tab assets unless explicitly justified and blocked by tests;
- New Tab page has a `<title>`;
- New Tab page does not use `autofocus` and does not call `.focus()` on load;
- New Tab page does not imitate Chrome's default New Tab branding/UI;
- New Tab files are included in packaged extension ZIP;
- release manifest and packaged manifest agree.

Wire this checker into the appropriate scripts, preferably:

```json
"check:newtab-override": "node tools/check-newtab-override.mjs",
"check:all": "... && npm run check:newtab-override"
```

Also wire it into release/package verification if release profiles include the feature.

---

### 5. Add browser/runtime tests

Add Playwright or extension runtime tests that load the extension and verify New Tab behavior.

Suggested test file:

```text
tests/extension/newtab-override.spec.ts
```

Tests should prove:


Runtime tests should also prove:

- opening `chrome://newtab` resolves to the extension-owned page when the feature is enabled;
- attempting to inspect normal browsing pages still shows no New Tab-specific scripts leaking into ordinary sites;
- disabling/removing the override profile does not leave stale generated manifest output or stale packaged files that still claim the feature;
- the New Tab page works after extension service-worker restart, browser restart simulation where available, and repeated open/close cycles;
- keyboard navigation is usable and no hidden focus trap exists;
- page-side CSP blocks inline/eval/remote script attempts in test fixtures where practical.

1. Opening a new tab loads the extension-owned New Tab page when enabled.
2. The page URL starts with `chrome-extension://<extension-id>/pages/newtab.html` or equivalent extension URL.
3. The page has no remote network requests.
4. The page renders without console errors.
5. The document title is present and non-empty.
6. The omnibox/address bar remains the browser's normal entry point; the page must not steal focus by default.
7. Disabling the feature/profile removes `chrome_url_overrides.newtab` from the manifest.
8. The packaged release ZIP includes all required New Tab files when enabled.
9. Incognito behavior is documented and does not break normal windows.

If Playwright cannot directly inspect omnibox focus, test the page-side equivalent:

- no `autofocus` attributes;
- no startup focus calls;
- no script that focuses an input during initial load.

---

### 6. Update manifest audit

Update existing manifest audit tooling, likely:

```text
tools/audit-mv3-manifest.mjs
```

Required behavior:

- allow `chrome_url_overrides.newtab` only if this feature is enabled for the current profile;
- fail if override path is missing;
- fail if multiple Chrome page overrides are introduced;
- fail if release profile unexpectedly differs from the generated manifest policy;
- record the New Tab override in the release audit output.

---

### 7. Update release/package audit

Update the package/release verification pipeline so the actual packaged ZIP is audited, not only source files.

Required checks:

- unpack or inspect the release ZIP;
- read the packaged `manifest.json`;
- confirm `chrome_url_overrides.newtab` matches expected profile state;
- confirm `pages/newtab.html`, CSS, JS, icons/assets exist in the package;
- confirm no dev/test New Tab files are shipped unintentionally;
- confirm no source maps expose unexpected data if source maps are shipped;
- confirm no remote URLs are embedded in packaged New Tab files.

Add or extend a script such as:

```text
tools/check-packaged-extension.mjs
tools/check-release-manifest.mjs
tools/check-release-artifacts.mjs
```

Use the existing project structure rather than duplicating logic.

---

### 8. Update docs without overclaiming

Update internal documentation only as needed.

Document this exact distinction:

```text
Chrome's built-in New Tab page is a browser-owned internal page. uBlock Resurrected does not claim to cosmetically filter the original chrome://newtab DOM. Instead, it optionally replaces the New Tab page with a local extension-owned page using Chrome's supported New Tab override mechanism.
```

Add this to the appropriate docs, for example:

```text
README.md
BENCHMARK.md
docs/FEATURES.md
docs/NEW_TAB_OVERRIDE.md
```

depending on project structure.

Do not create marketing language such as:

- "blocks all Google New Tab ads";
- "removes Chrome's ads from chrome://newtab";
- "filters browser UI";
- "superior New Tab ad blocker".

Use neutral functional wording:

```text
Optional local New Tab replacement
```

---

### 9. Update certificate/evidence pipeline if applicable

If the project has internal certificate/evidence claims, add a narrow evidence claim only if the evidence is real.

Suggested claim name:

```text
newtab_override_local_private_passes
```

The claim may pass only when:

- the expected profile enables the feature;
- packaged manifest contains the override;
- New Tab assets exist;
- New Tab assets are local-only;
- browser/runtime test confirms the extension page loads;
- no remote requests are observed;
- documentation does not claim unsupported chrome://newtab DOM filtering.

If the feature is disabled in a given profile, the claim should be either:

```text
not_applicable
```

or absent/false according to the existing certificate schema rules. Do not default it to `true`.

---

### 10. Add user-facing setting only if already supported

Do not add a runtime toggle unless the extension architecture already supports changing New Tab override behavior. Chrome page overrides are manifest-level behavior, not ordinary per-site cosmetic toggles.

If adding UI text, make it clear:

```text
This build replaces Chrome's New Tab page with a local private page.
```

Do not suggest that the original Chrome New Tab DOM is being filtered.

---

## Expected files to inspect first

Before coding, inspect at least:

```text
package.json
platform/chromium/manifest.json
tools/generate-release-manifest.mjs
tools/audit-mv3-manifest.mjs
tools/check-packaged-extension.mjs
tools/check-release-manifest.mjs
tools/check-release-artifacts.mjs
tests/extension/extension-load.spec.ts
.github/workflows/ci.yml
.github/workflows/release.yml
```

Also search for:

```text
chrome_url_overrides
newtab
manifest generation
release manifest
packaged extension
remote URL audit
CSP audit
```

Reuse existing patterns instead of creating disconnected tools.

---

## Implementation order

1. Inspect manifest/build/release pipeline.
2. Decide where the canonical manifest source lives.
3. Add local New Tab page files.
4. Add manifest override through the canonical generator/source.
5. Add feature/profile switch if needed.
6. Add `check-newtab-override.mjs` or equivalent checker.
7. Wire checker into `package.json` and CI/release pipeline.
8. Add Playwright/runtime test.
9. Add packaged ZIP audit coverage.
10. Update docs with careful, non-overclaiming wording.
11. Add certificate/evidence claim only if the project uses this pipeline and only with real evidence.
12. Run full verification.

---

## Required commands

Run the closest available commands in this repo. Start with:

Before running the full command set, inspect generated output cleanliness:

```bash
git status --porcelain
```

After build/package, verify that generated manifest/package changes are intentional and no stale generated New Tab artifacts remain when the feature is disabled.


```bash
npm ci
npm run build
npm run check:all
npm run test
npm run test:mv3-engine
npm run typecheck:runtime
npm run test:playwright
npm run package:release
```

If Playwright browsers are missing, install Chromium for Playwright using the project's normal method, for example:

```bash
npx playwright install chromium --with-deps
```

Do not mark the task complete if relevant tests were skipped without explanation.

---

## Acceptance criteria

The task is complete only when all of the following are true:

- No content script, DNR, webRequest, or CSS-injection path attempts to modify Chrome's original internal New Tab page.
- No new host permissions, search-provider overrides, or remote-service dependencies were added for this feature.
- The local page has restrictive CSP-compatible asset loading and does not require inline script/eval.
- The feature behavior is deterministic across dev/release/profile builds and stale generated manifests cannot pass checks.
- Incognito/extension-conflict limitations are documented without trying to bypass browser policy.

- A local New Tab replacement page exists.
- Manifest override is added through the correct canonical manifest path.
- Override is enabled only in intended build/profile.
- No remote assets or network calls exist in New Tab files.
- New Tab page has a title.
- New Tab page does not steal focus from the omnibox.
- New Tab page does not imitate Chrome's default New Tab UI.
- CI/check pipeline includes a New Tab override audit.
- Browser/runtime test proves new tabs open to the extension-owned page when enabled.
- Disabled profile/build proves the override is absent when expected.
- Packaged release ZIP includes the correct New Tab files and manifest entry.
- Docs explicitly say this is replacement, not chrome://newtab DOM filtering.
- No unsupported superiority/ad-filtering claim is introduced.
- No ad beacon/impression/click/viewability manipulation is introduced.
- Full test/check command set passes, or any unavoidable failure is documented with exact reason and remaining risk.

---

## Final response format for the coding agent

When done, report exactly:

```text
## Summary
- What was implemented.
- Whether the feature is enabled by default or build/profile-gated.

## Files changed
- List changed files with one-line reason for each.

## Safety/compliance boundary
- Confirm this replaces New Tab and does not inject into chrome://newtab.
- Confirm no remote requests, telemetry, ads, beacons, or fake ad traffic were added.

## Verification
- Commands run.
- Pass/fail result for each.
- Any skipped tests and why.

## Remaining risks
- Any limitation, especially incognito behavior or profile-specific behavior.
```

Do not claim completion unless the acceptance criteria are satisfied.
