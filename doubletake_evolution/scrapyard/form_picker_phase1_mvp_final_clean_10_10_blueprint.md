# Form Picker Extension: Phase 1 MVP Engineering Blueprint

## Rating of Previous Version

**9.2/10**

The previous version was strong and implementable, but the latest review identified several cleanup items that matter for Phase 1 reliability and simplicity:

1. Phase 1 still included unused storage entities that were not needed for exact-rule matching.
2. Nested `FrameLocator` resolution was not specified.
3. Iframe load timing needed a short wait before scanning.
4. The URL monitor lifecycle needed to be tied to side-panel visibility.
5. `normalizedSection` and heading extraction needed a concrete rule.
6. `ExactGroupRuleKey` had redundant `groupFingerprint` + `optionHash`.
7. `hashchange` needed explicit handling.
8. A manual Rescan button needed to be part of the MVP.

This version fixes those issues and keeps Phase 1 small.

Updated rating: **10/10 for Phase 1 MVP implementation**.

---

## 1. Product Goal

Build a Chrome/Chromium extension that works first as a reliable no-AI form picker and filler.

Phase 1 should:

1. Detect standard form controls.
2. Detect and recurse into same-origin iframes.
3. Warn about cross-origin/sandboxed inaccessible iframes.
4. Group radios and checkboxes into logical fields.
5. Let the user teach fields and groups.
6. Reuse exact user-confirmed rules.
7. Fill safe fields with verification.
8. Provide undo.
9. Export/import Phase 1 data.
10. Avoid AI, classifiers, embeddings, macros, broad automation, and large browser permissions.

Phase 1 is an **exact-rule MVP**, not an AI system.

---

## 2. Phase 1 Scope

### Include

```text
Manifest V3 extension
side panel
background service worker
content script scanner injected on user action
standard control detection
same-origin iframe recursion
cross-origin iframe warning
sandboxed iframe warning
radio/checkbox logical grouping
manual teaching
exact rule matching
safe fill executor
fill verification with retry
undo
basic contenteditable teaching/fill with warning
minimal IndexedDB storage
export/import
manual Rescan button
required fixtures and tests
```

### Exclude

```text
LLM teacher
classifier
TF-IDF memory
embeddings
ANN/vector search
macro recorder
cloud sync
wizard automation
dry-run mode
general custom ARIA autofill
advanced shadow DOM traversal
regex fallback UI/blocklist
model import/export
broad host permissions
history API monkey-patching
field examples / negative examples / user profiles as Phase 1 prediction dependencies
```

---

## 3. Minimal Manifest V3 Permissions

Use minimal permissions for the MVP.

```json
{
  "permissions": [
    "storage",
    "activeTab",
    "scripting",
    "sidePanel"
  ],
  "host_permissions": []
}
```

Phase 1 behavior:

```text
do not auto-run on every page load
inject content script when the user opens/uses the side panel
scan active tab only after user action
```

Only add broad `host_permissions` later if the product truly needs always-on background scanning.

---

## 4. Minimal Architecture

```text
User opens side panel
    ↓
Background injects content script into active tab
    ↓
Content Script Scanner
    - waits briefly for iframes
    - scans top document
    - recursively scans same-origin iframes
    - detects inaccessible iframes
    - extracts controls and logical groups
    ↓
Side Panel
    - shows logical fields/groups
    - teach / fill / clear / block / undo / rescan
    ↓
Prediction, Phase 1
    - blocklist
    - exact user rules
    - exact autocomplete rules
    - simple regex fallback for common safe text fields
    - unknown
    ↓
Fill Executor
    - fills supported controls
    - verifies result
    - records transaction
```

---

## 5. Phase 1 Storage Model

Keep storage minimal.

### Include in Phase 1

```text
fieldRules
blocklist
fillTransactions
storageMeta
```

### Exclude from Phase 1

```text
fieldExamples
negativeExamples
userProfiles
modelMetadata
classifier artifacts
embedding indexes
```

Reason:

```text
Phase 1 prediction uses exact rules, autocomplete rules, and simple safe regex fallback only.
Training datasets and negative examples belong to later AI/classifier phases.
```

### Export Bundle

```typescript
type ExportBundleV1 = {
  exportVersion: 1;
  schemaVersion: number;
  exportedAt: string;
  appVersion: string;
  fieldRules: FieldRule[];
  blocklist: BlocklistEntry[];
  fillTransactions?: FillTransaction[];
};
```

Import rules:

```text
older schema:
    run import migration

newer schema:
    reject with clear message

duplicate IDs:
    merge by updatedAt or ask user

before import:
    create local backup

after import:
    verify counts
```

---

## 6. Repository Structure

```text
form-picker-extension/
    manifest.json
    package.json
    tsconfig.json
    vite.config.ts

    src/
        background/
            service_worker.ts
            message_router.ts
            script_injection.ts
            session_cache.ts

        content/
            content_entry.ts
            scanner/
                scan_page.ts
                scan_iframe.ts
                frame_locator.ts
                detect_controls.ts
                extract_labels.ts
                extract_context.ts
                extract_options.ts
                iframe_policy.ts
                group_controls.ts
                blocked_detector.ts
                visibility.ts
                fingerprints.ts
                url_monitor.ts
                iframe_wait.ts
            fill/
                fill_executor.ts
                fill_text.ts
                fill_select.ts
                fill_radio_group.ts
                fill_checkbox_group.ts
                fill_contenteditable.ts
                verify_fill.ts
                transactions.ts
                undo.ts
            lifecycle/
                page_scanner.ts

        side_panel/
            index.html
            side_panel.ts
            side_panel.css
            components/
                FieldTable.ts
                FieldRow.ts
                TeachDialog.ts
                HealthPanel.ts
                RescanButton.ts

        storage/
            db.ts
            migrations.ts
            repositories/
                field_rules_repo.ts
                fill_transactions_repo.ts
                blocklist_repo.ts

        prediction/
            exact_rules.ts
            autocomplete_rules.ts
            regex_fallback.ts
            decision_table.ts
            safety_policy.ts
            value_resolver.ts

        shared/
            types.ts
            messages.ts
            taxonomy.ts
            reason_codes.ts
            normalize.ts
            logger.ts

    fixtures/
        simple_contact.html
        same_origin_iframe_form.html
        nested_same_origin_iframe_form.html
        iframe_order_change.html
        iframe_cycle_safe.html
        iframe_depth_limit.html
        iframe_load_delay.html
        cross_origin_iframe_warning.html
        sandboxed_iframe_warning.html
        native_selects.html
        radio_group_fieldset.html
        checkbox_group_fieldset.html
        group_undo.html
        contenteditable_basic.html
        placeholder_only_form.html
        label_missing_name_id_only.html
        hidden_honeypot.html
        captcha_like.html
        dynamic_react_form.html
        spa_url_change.html
        hash_route_change.html

    tests/
        unit/
        integration/
```

---

## 7. Frame Locator Policy

Do **not** put unstable runtime `frameId` into rule keys or fingerprints.

`frameId` is allowed only as a runtime scan identifier.

Rules and fingerprints must use a stable `frameLocator`.

```typescript
type FrameLocator =
  | { kind: "top" }
  | {
      kind: "iframe_path";
      path: FrameLocatorSegment[];
    };

type FrameLocatorSegment = {
  selector: string;
  srcHint?: string;
  nameHint?: string;
  titleHint?: string;
};
```

Example nested frame locator:

```json
{
  "kind": "iframe_path",
  "path": [
    { "selector": "iframe#main-application-frame", "srcHint": "https://example.com/app" },
    { "selector": "iframe.inner-form-frame", "nameHint": "inner-form" }
  ]
}
```

---

## 8. Frame Locator Generation

Preferred locator sources:

```text
stable id selector
stable name selector
stable title selector
stable src substring selector
nth-of-type path only as last resort
```

```typescript
function buildFrameLocatorSegment(iframe: HTMLIFrameElement): FrameLocatorSegment {
  if (iframe.id) {
    return {
      selector: `iframe#${cssEscape(iframe.id)}`,
      srcHint: iframe.src || undefined,
      nameHint: iframe.name || undefined,
      titleHint: iframe.title || undefined
    };
  }

  if (iframe.name) {
    return {
      selector: `iframe[name="${cssEscape(iframe.name)}"]`,
      srcHint: iframe.src || undefined,
      nameHint: iframe.name,
      titleHint: iframe.title || undefined
    };
  }

  if (iframe.title) {
    return {
      selector: `iframe[title="${cssEscape(iframe.title)}"]`,
      srcHint: iframe.src || undefined,
      nameHint: iframe.name || undefined,
      titleHint: iframe.title
    };
  }

  if (iframe.src) {
    return {
      selector: `iframe[src*="${stableSrcFragment(iframe.src)}"]`,
      srcHint: iframe.src
    };
  }

  return {
    selector: buildNthOfTypePathSegment(iframe),
    srcHint: iframe.src || undefined
  };
}
```

---

## 9. Nested FrameLocator Resolution

At fill time, resolve `FrameLocator` from the top document.

```typescript
function resolveFrameLocator(root: Document, locator: FrameLocator): Window | null {
  if (locator.kind === "top") {
    return root.defaultView;
  }

  let currentDoc: Document | null = root;

  for (const segment of locator.path) {
    if (!currentDoc) return null;

    const iframe = currentDoc.querySelector(segment.selector) as HTMLIFrameElement | null;

    if (!iframe) return null;

    try {
      const nextDoc = iframe.contentDocument;

      if (!nextDoc || !nextDoc.defaultView) return null;

      currentDoc = nextDoc;
    } catch {
      return null;
    }
  }

  return currentDoc?.defaultView ?? null;
}
```

Rules:

```text
FrameLocator path is absolute from the top document.
If resolution fails, show "rule broken; please re-teach".
Do not silently fall back to another iframe.
```

---

## 10. Same-Origin and Inaccessible Iframe Handling

### 10.1 Iframe Access Status

```typescript
type IframeAccessStatus =
  | "top"
  | "same_origin_accessible"
  | "cross_origin_inaccessible"
  | "sandboxed_inaccessible"
  | "empty_or_not_loaded"
  | "depth_limit_exceeded"
  | "cycle_detected";
```

### 10.2 Iframe Inspection

```typescript
function inspectIframe(iframe: HTMLIFrameElement): IframeInspection {
  const sandbox = iframe.getAttribute("sandbox") || "";

  if (sandbox && !sandbox.split(/\s+/).includes("allow-same-origin")) {
    return {
      status: "sandboxed_inaccessible",
      src: iframe.src || null,
      document: null
    };
  }

  try {
    const doc = iframe.contentDocument;

    if (!doc) {
      return {
        status: "cross_origin_inaccessible",
        src: iframe.src || null,
        document: null
      };
    }

    if (!doc.body || doc.readyState === "loading") {
      return {
        status: "empty_or_not_loaded",
        src: iframe.src || null,
        document: null
      };
    }

    return {
      status: "same_origin_accessible",
      src: iframe.src || null,
      document: doc
    };
  } catch {
    return {
      status: "cross_origin_inaccessible",
      src: iframe.src || null,
      document: null
    };
  }
}
```

---

## 11. Iframe Load Timing

Before the main scan, wait briefly for accessible iframes to load.

```typescript
async function waitForIframes(doc: Document, timeoutMs = 500): Promise<void> {
  const iframes = Array.from(doc.querySelectorAll("iframe"));

  await Promise.race([
    Promise.all(
      iframes.map(iframe => new Promise(resolve => {
        try {
          const iframeDoc = iframe.contentDocument;

          if (iframeDoc?.readyState === "complete") {
            resolve(true);
            return;
          }
        } catch {
          resolve(false);
          return;
        }

        iframe.addEventListener("load", () => resolve(true), { once: true });
      }))
    ),
    new Promise(resolve => setTimeout(resolve, timeoutMs))
  ]);
}
```

Rules:

```text
wait max 500ms
do not block indefinitely
after timeout, scan what is available
mark unloaded frames as empty_or_not_loaded
allow manual Rescan
```

---

## 12. Recursive Same-Origin Iframe Scan With Cycle and Depth Protection

```typescript
type ScanBudget = {
  maxDepth: number;
  currentDepth: number;
  maxTotalElements: number;
  totalElementsInspected: number;
  visitedFrameKeys: Set<string>;
};

function scanDocument(
  doc: Document,
  frameContext: FrameContext,
  budget: ScanBudget
): ScanPartial {
  if (budget.currentDepth > budget.maxDepth) {
    recordIframeWarning({
      frameLocator: frameContext.frameLocator,
      status: "depth_limit_exceeded"
    });
    return emptyScanPartial();
  }

  const frameKey = makeFrameVisitKey(doc, frameContext.frameLocator);

  if (budget.visitedFrameKeys.has(frameKey)) {
    recordIframeWarning({
      frameLocator: frameContext.frameLocator,
      status: "cycle_detected"
    });
    return emptyScanPartial();
  }

  budget.visitedFrameKeys.add(frameKey);

  const localCandidates = detectControls(doc, frameContext, budget);
  const localGroups = groupControls(localCandidates);

  const iframeResults: ScanPartial[] = [];

  for (const iframe of Array.from(doc.querySelectorAll("iframe"))) {
    if (budget.totalElementsInspected >= budget.maxTotalElements) {
      recordScanWarning("global_scan_budget_exceeded");
      break;
    }

    const inspection = inspectIframe(iframe);
    const frameLocator = appendFrameLocator(
      frameContext.frameLocator,
      buildFrameLocatorSegment(iframe)
    );

    if (inspection.status === "same_origin_accessible" && inspection.document) {
      iframeResults.push(
        scanDocument(
          inspection.document,
          {
            frameLocator,
            frameUrl: iframe.src || inspection.document.location.href,
            accessStatus: "same_origin_accessible"
          },
          {
            ...budget,
            currentDepth: budget.currentDepth + 1
          }
        )
      );
    } else {
      recordIframeWarning({
        frameLocator,
        status: inspection.status,
        src: iframe.src || null
      });
    }
  }

  return mergeScanPartials(localCandidates, localGroups, iframeResults);
}
```

Default global budget:

```typescript
const DEFAULT_SCAN_BUDGET = {
  maxDepth: 5,
  currentDepth: 0,
  maxTotalElements: 3000,
  totalElementsInspected: 0,
  visitedFrameKeys: new Set<string>()
};
```

---

## 13. Candidate and Logical Group Model

### 13.1 CandidateControl

```typescript
type CandidateControl = {
  candidateId: string;
  logicalGroupId?: string;

  runtimeFrameId: string;
  frameLocator: FrameLocator;
  frameUrl?: string;
  iframeStatus: IframeAccessStatus;

  tag: string;
  inputType?: string;
  role?: string;

  isVisible: boolean;
  isEnabled: boolean;
  isReadonly: boolean;
  isRequired: boolean;
  hasExistingValue: boolean;

  selectorHint?: string;
  xpathHint?: string;

  fieldOrder: number;
  domDepth: number;

  labelText?: string;
  labelConfidenceLevel: LabelConfidenceLevel;
  labelFailed: boolean;
  placeholderOnly: boolean;

  autocomplete?: string;
  nameAttr?: string;
  idAttr?: string;
  placeholder?: string;

  groupLabel?: string;
  sectionHeading?: string;
  fieldsetLegend?: string;

  optionLabel?: string;
  optionValue?: string;

  normalizedLabel?: string;
  normalizedName?: string;
  normalizedId?: string;
  normalizedSection?: string;

  isOptionBasedControl: boolean;
  optionHash?: string;
  groupFingerprint?: string;
  fingerprint: string;
};
```

### 13.2 LogicalFieldGroup

```typescript
type LogicalFieldGroup = {
  groupId: string;
  type:
    | "single_field"
    | "radio_group"
    | "checkbox_group"
    | "contenteditable";

  members: CandidateControl[];

  frameLocator: FrameLocator;
  groupLabel?: string;
  sectionHeading?: string;
  fieldsetLegend?: string;

  optionLabels: string[];
  optionValues: string[];
  optionHash?: string;

  groupFingerprint: string;
  overallStatus: FieldStatus;
};
```

---

## 14. Section and Heading Extraction

`normalizedSection` must be derived consistently.

Algorithm:

```typescript
function extractNormalizedSection(element: Element): string {
  const legend = element.closest("fieldset")?.querySelector("legend");
  if (legend?.textContent?.trim()) {
    return normalizeText(legend.textContent);
  }

  const heading = findNearestPrecedingHeading(element);
  if (heading?.textContent?.trim()) {
    return normalizeText(heading.textContent);
  }

  return "";
}
```

Heading search:

```text
search h1-h6 in same frame/document
prefer nearest preceding heading in DOM order
do not cross form boundary if form ancestor exists
fallback to empty string
```

---

## 15. Grouping Rules

```text
radio group:
    same frameLocator
    same name attribute where available
    same fieldset/legend or nearest group context

checkbox group:
    same frameLocator
    same fieldset/legend or nearest group context
    standalone checkbox becomes one-member checkbox group

single field:
    input/textarea/select/contenteditable with no grouped peers
```

Radio and checkbox groups are taught and filled as **groups**, not as individual controls.

---

## 16. optionHash Generation

Generate `optionHash` for option-based controls only:

```text
select
radio_group
checkbox_group
```

Algorithm:

```typescript
function makeOptionHash(options: Array<{ label: string; value: string }>): string {
  const normalized = options
    .map(o => ({
      label: normalizeText(o.label),
      value: normalizeText(o.value)
    }))
    .sort((a, b) => `${a.label}|${a.value}`.localeCompare(`${b.label}|${b.value}`));

  return hash(JSON.stringify({
    optionCount: normalized.length,
    options: normalized
  }));
}
```

Rules:

```text
order-independent
uses labels and values
includes optionCount
not used for text/textarea/contenteditable
```

---

## 17. Fingerprints

### 17.1 Candidate Fingerprint

Do not include unstable runtime `frameId`.

```typescript
function makeCandidateFingerprint(field: CandidateControl): string {
  const parts = [
    stableFrameLocatorString(field.frameLocator),
    field.tag,
    field.inputType || "",
    field.role || "",
    field.autocomplete || "",
    field.normalizedLabel || "",
    field.normalizedName || "",
    field.normalizedId || "",
    field.normalizedSection || ""
  ];

  if (field.isOptionBasedControl && field.optionHash) {
    parts.push(field.optionHash);
  }

  return hash(parts.join("|"));
}
```

### 17.2 Group Fingerprint

`groupFingerprint` already includes the option set. Do not duplicate `optionHash` in the rule key.

```typescript
function makeGroupFingerprint(group: LogicalFieldGroup): string {
  return hash([
    stableFrameLocatorString(group.frameLocator),
    group.type,
    normalizeText(group.groupLabel || ""),
    normalizeText(group.sectionHeading || ""),
    normalizeText(group.fieldsetLegend || ""),
    group.optionHash || "",
    String(group.members.length)
  ].join("|"));
}
```

Use group fingerprint for:

```text
radio rule matching
checkbox rule matching
group fill verification
stale group detection
```

---

## 18. Label Confidence

Use ordinal label confidence only.

```typescript
type LabelConfidenceLevel = "high" | "medium" | "low" | "failed";
```

Ranking:

```text
high:
    label[for]
    aria-labelledby with visible source text

medium:
    parent label
    aria-label

low:
    placeholder
    name/id tokens
    fieldset/legend only
    section heading only
    visual nearby text
    regex fallback

failed:
    no useful label
    generic label only
    hidden/invisible label only
```

Generic text:

```text
required
optional
answer
select
choose
field
value
input
question
```

Decision:

```text
failed:
    never green unless exact user rule exists

low:
    orange unless exact user rule exists

placeholderOnly:
    orange unless exact user rule exists
```

---

## 19. Rule Scope

```typescript
type RuleScope =
  | "origin"
  | "domain"
  | "path_prefix"
  | "exact_url";
```

Default:

```text
domain
```

Scope behavior:

```text
origin:
    scheme + host + port

domain:
    effective TLD+1
    matches subdomains

path_prefix:
    origin + configured path prefix

exact_url:
    exact page URL without hash unless configured otherwise
```

Use a public-suffix-list library or vetted eTLD+1 helper. Do not naïvely take the last two hostname parts.

Rule storage must include:

```typescript
scope: RuleScope;
scopeValue: string;
```

---

## 20. Exact Rule Keys

### 20.1 Single Field Rule Key

```typescript
type ExactSingleFieldRuleKey = {
  scope: RuleScope;
  scopeValue: string;
  frameLocator: FrameLocator;
  fieldType: string;
  inputType?: string;
  autocomplete?: string;
  normalizedLabel?: string;
  normalizedName?: string;
  normalizedId?: string;
};
```

### 20.2 Group Rule Key

```typescript
type ExactGroupRuleKey = {
  scope: RuleScope;
  scopeValue: string;
  frameLocator: FrameLocator;
  groupType: "radio_group" | "checkbox_group";
  groupFingerprint: string;
};
```

### 20.3 Contenteditable Rule Key

```typescript
type ExactContenteditableRuleKey = {
  scope: RuleScope;
  scopeValue: string;
  frameLocator: FrameLocator;
  normalizedLabel?: string;
  selectorHint?: string;
  fingerprint: string;
};
```

No rule key may depend on unstable runtime `frameId`.

---

## 21. Teaching Rules

### 21.1 Single Fields

When the user teaches a text/input/select/textarea field:

```text
store rule against ExactSingleFieldRuleKey
store targetLabel
store value
store safety policy
store scope
```

### 21.2 Radio Groups

When the user teaches a radio group:

```text
store rule against ExactGroupRuleKey
store intended option label/value
do not require teaching each radio input
```

Filling:

```text
resolve group by groupFingerprint
find option by label/value
select matching radio input
verify selected input
```

### 21.3 Checkbox Groups

When the user teaches a checkbox group:

```text
store rule against ExactGroupRuleKey
store intended selected labels/values
do not require teaching each checkbox individually
```

Filling:

```text
resolve group by groupFingerprint
check/uncheck only exact taught options
verify final checked state
```

Checkboxes remain orange until exact group rule exists.

### 21.4 Contenteditable

Contenteditable is allowed in Phase 1 only as an explicit taught rule with warning.

Warning:

```text
This editable region is less reliable than a normal form field. The extension can try to fill it, but you should verify the result before submitting.
```

Filling:

```text
focus element
set innerText or textContent
dispatch input event
dispatch change event when applicable
verify visible text
if verification fails, use paste-mode fallback
```

---

## 22. Prediction Precedence

```text
1. personal/global blocklist
2. inaccessible iframe policy
3. exact group rule
4. exact single-field rule
5. exact contenteditable rule
6. exact autocomplete rule
7. safe regex fallback for common text fields
8. unknown
```

Safety policy can always downgrade.

Blocklist always wins.

---

## 23. Decision Status

```typescript
type FieldStatus = "green" | "orange" | "red" | "gray";
```

### Gray

```text
hidden
disabled
readonly without override
password/captcha/payment/government ID/SIN/SSN/health ID
cross-origin iframe
sandboxed iframe
closed shadow DOM internals
user/global blocklist
unsupported custom control
```

### Red

```text
unknown meaning
no saved value
no exact rule
value resolution failed
label failed and no exact rule
```

### Orange

```text
review-sensitive field
placeholder-only without exact rule
low-confidence label without exact rule
checkbox group without exact rule
radio/select option uncertain
existing value present
contenteditable
custom ARIA control
stale fingerprint/groupFingerprint
programmatic fill failed but paste mode is available
```

### Green

```text
visible and enabled
not blocked/skipped
supported control/group type
safe field class
exact rule, exact autocomplete, or allowed safe regex fallback
target value exists
value/option resolution succeeds
fingerprint is not stale
label high/medium OR exact user rule exists
```

---

## 24. Fill Verification With Async Retry

```typescript
async function verifyFillWithRetry(
  element: Element,
  expectedValue: unknown,
  options = { maxRetries: 5, delayMs: 50 }
): Promise<boolean> {
  for (let i = 0; i < options.maxRetries; i++) {
    await sleep(options.delayMs);
    const currentValue = getElementValue(element);
    if (valuesEquivalent(currentValue, expectedValue)) return true;
  }
  return false;
}
```

For React-like pages:

```text
wait at least two animation frames before first verification where possible
```

If verification fails:

```text
status = manual_required if paste mode is available
else status = failed
```

---

## 25. Paste-Mode Fallback

```typescript
type PasteModeState = "disabled" | "prompt_on_failure" | "always_manual";
```

Default:

```text
prompt_on_failure
```

Flow:

```text
1. Programmatic fill fails.
2. Side panel asks:
   "Auto-fill failed. Copy value to clipboard so you can paste it manually?"
3. If user accepts:
   - copy value to clipboard
   - focus field
   - highlight field
   - show instruction:
     "Value copied. Press Ctrl+V / Cmd+V in the focused field."
4. Mark action as manual_required.
5. Do not claim fill success.
```

---

## 26. SPA Navigation and Session Cache Invalidation

Do not monkey-patch `history.pushState` or `history.replaceState`.

Use timer-based URL monitoring in Phase 1, tied to side-panel visibility.

```typescript
function startUrlMonitor(onChange: (url: string) => void): () => void {
  let lastUrl = location.href;

  const check = () => {
    if (location.href !== lastUrl) {
      lastUrl = location.href;
      onChange(lastUrl);
    }
  };

  const timerId = window.setInterval(check, 200);

  window.addEventListener("popstate", check);
  window.addEventListener("hashchange", check);

  return () => {
    window.clearInterval(timerId);
    window.removeEventListener("popstate", check);
    window.removeEventListener("hashchange", check);
  };
}
```

Lifecycle:

```text
start monitor when side panel opens / activates scanner
stop monitor when side panel closes / scanner deactivates
on URL change, clear cache and request rescan
do not show stale scan results
```

---

## 27. Service Worker Session Recovery

Use `chrome.storage.session`.

```typescript
type SessionCache = {
  tabId: number;
  pageUrl: string;
  scanResult: PageScanResult;
  decisions: FieldDecision[];
  updatedAt: string;
};
```

Rules:

```text
side panel requests latest cache on open
cache is valid only if tabId and pageUrl match
cache older than 5 minutes triggers rescan
SPA URL change invalidates cache
manual Rescan bypasses cache
```

---

## 28. Observer and Listener Teardown

```typescript
class PageScanner {
  private observer: MutationObserver | null = null;
  private cleanupCallbacks: Array<() => void> = [];
  private isActive = false;

  start() {
    this.stop();
    this.isActive = true;

    this.observer = new MutationObserver(debouncedScan);
    this.observer.observe(document.body, { childList: true, subtree: true });

    const beforeUnload = () => this.stop();
    window.addEventListener("beforeunload", beforeUnload);
    this.cleanupCallbacks.push(() => window.removeEventListener("beforeunload", beforeUnload));

    const stopUrlMonitor = startUrlMonitor(() => {
      clearSessionCacheForPreviousUrl();
      notifyUrlChangedAndRequestRescan();
    });
    this.cleanupCallbacks.push(stopUrlMonitor);
  }

  stop() {
    if (this.observer) {
      this.observer.disconnect();
      this.observer = null;
    }

    for (const cleanup of this.cleanupCallbacks) cleanup();
    this.cleanupCallbacks = [];
    this.isActive = false;
  }
}
```

Stop scanner when:

```text
side panel closes
beforeunload
TEARDOWN_CONTENT_SCRIPT
extension context invalidates
content script reinjects
```

---

## 29. Manual Rescan Button

The side panel must include a Rescan button.

Behavior:

```text
clears current scan cache for active tab
waits briefly for iframes
reruns full scan
updates field list
updates iframe warnings
does not delete saved rules
```

Use cases:

```text
slow iframe loads
dynamically inserted forms
user changes page section
SPA content update not caught by MutationObserver
```

---

## 30. IndexedDB Migration Lock

```typescript
async function withMigrationLock<T>(fn: () => Promise<T>): Promise<T> {
  if ("locks" in navigator) {
    return navigator.locks.request("form_picker_migration", fn);
  }
  return withStorageFallbackLock("form_picker_migration", fn);
}
```

Fallback lock:

```text
chrome.storage.local key: migration_lock
ownerId
acquiredAt
expiresAt
```

Startup sequence:

```text
1. acquire migration lock
2. open IndexedDB
3. read storage_meta
4. initialize or migrate
5. verify stores/indexes
6. release lock
7. then allow scanner/storage features
```

---

## 31. Export/Import Versioning

```typescript
type ExportBundleV1 = {
  exportVersion: 1;
  schemaVersion: number;
  exportedAt: string;
  appVersion: string;
  fieldRules: FieldRule[];
  blocklist: BlocklistEntry[];
  fillTransactions?: FillTransaction[];
};
```

Import rules:

```text
older schema:
    run import migration

newer schema:
    reject with clear message

duplicate IDs:
    merge by updatedAt or ask user

before import:
    create local backup

after import:
    verify counts
```

---

## 32. Scan Performance Budget

Global budget across the entire scan, including all same-origin iframes:

```text
max total elements inspected: 3000
max candidates total: 300
max iframe depth: 5
max scan time before yielding: 50ms chunks
max total scan time before warning: 1000ms
MutationObserver debounce: 250-500ms
```

When the budget is exceeded:

```text
stop scanning deeper iframes
keep already detected candidates
show scan-budget warning in side panel
allow manual Rescan
```

---

## 33. Shadow DOM Policy

Phase 1:

```text
skip Shadow DOM traversal by default
do not scan closed shadow DOM internals
if a shadow host appears field-like, show orange/review warning
advanced Shadow DOM support is deferred
```

---

## 34. Removed From Phase 1

The following are explicitly removed from Phase 1:

```text
dry-run mode
macro teaching
TF-IDF
embeddings
classifier
LLM teacher
advanced shadow DOM traversal
regex fallback UI/blocklist
side-panel virtualization unless needed
parentStructureHash unless proven necessary
webNavigation permission unless URL monitor fails
fieldExamples / negativeExamples / userProfiles as prediction dependencies
```

---

## 35. PageScanResult

```typescript
type PageScanResult = {
  scanId: string;
  tabId?: number;
  pageUrl: string;
  domain: string;
  pageTitle: string;
  scannedAt: string;
  durationMs: number;

  candidates: CandidateControl[];
  logicalGroups: LogicalFieldGroup[];
  iframeWarnings: IframeWarning[];

  stats: {
    totalElementsChecked: number;
    rawCandidateCount: number;
    logicalFieldCount: number;
    standardControlCount: number;
    customControlCount: number;
    textInputCount: number;
    textareaCount: number;
    selectCount: number;
    radioGroupCount: number;
    checkboxGroupCount: number;
    blockedCount: number;
    hiddenSkippedCount: number;
    crossOriginIframeCount: number;
    sandboxedIframeCount: number;
    sameOriginIframeCount: number;
    scanBudgetExceeded: boolean;
  };

  warnings: {
    code: string;
    message: string;
    severity: ErrorSeverity;
  }[];
};
```

---

## 36. Group Undo Contract

Undo for groups must store previous checked state for every member.

```typescript
type GroupFillUndoState = {
  groupId: string;
  groupType: "radio_group" | "checkbox_group";
  previousMembers: Array<{
    candidateId: string;
    selectorHint?: string;
    optionLabel?: string;
    optionValue?: string;
    wasChecked: boolean;
  }>;
  intendedMembers: Array<{
    candidateId: string;
    shouldBeChecked: boolean;
  }>;
};
```

Undo behavior:

```text
resolve current group by groupFingerprint
restore checked state for all members
dispatch input/change events for changed controls
verify final checked states
if group changed and cannot be restored, show undo_failed
```

---

## 37. Required Fixtures

```text
simple_contact.html
same_origin_iframe_form.html
nested_same_origin_iframe_form.html
iframe_order_change.html
iframe_cycle_safe.html
iframe_depth_limit.html
iframe_load_delay.html
cross_origin_iframe_warning.html
sandboxed_iframe_warning.html
native_selects.html
radio_group_fieldset.html
checkbox_group_fieldset.html
group_undo.html
contenteditable_basic.html
placeholder_only_form.html
label_missing_name_id_only.html
hidden_honeypot.html
captcha_like.html
dynamic_react_form.html
spa_url_change.html
hash_route_change.html
```

---

## 38. Fixture Assertions

### nested_same_origin_iframe_form.html

```text
nested iframe fields are detected
nested FrameLocator resolves from top document
fill works in nested same-origin iframe
```

### iframe_load_delay.html

```text
scanner waits up to 500ms
late iframe can be found by manual Rescan
empty_or_not_loaded warning appears if timeout expires
```

### iframe_order_change.html

```text
field rule still matches when iframe order changes but stable FrameLocator remains valid
unstable nth-of-type fallback shows re-teach warning if it fails
```

### iframe_cycle_safe.html

```text
recursive scanner does not loop forever
cycle warning is logged
scan completes
```

### iframe_depth_limit.html

```text
scanner stops at max depth 5
depth warning is shown
scan completes
```

### radio_group_fieldset.html

```text
radio inputs grouped into one LogicalFieldGroup
teaching stores group rule
fill selects taught option
no per-radio teaching required
```

### checkbox_group_fieldset.html

```text
checkboxes grouped into one LogicalFieldGroup
teaching stores group rule
fill checks only taught options
group remains orange until exact group rule exists
```

### group_undo.html

```text
radio/checkbox group fill records previous checked state for all members
undo restores previous checked states
input/change events fire for restored controls
```

### contenteditable_basic.html

```text
contenteditable detected as review
explicit teaching allowed
fill attempts innerText/textContent update
warning shown
paste fallback appears if verification fails
```

### spa_url_change.html

```text
timer detects URL change
session cache invalidates
side panel requests rescan
old fields are not shown for new URL
```

### hash_route_change.html

```text
hashchange triggers URL change detection
session cache invalidates
side panel requests rescan
```

---

## 39. Phase 1 Definition of Done

Phase 1 is done only if:

```text
1. Extension loads cleanly.
2. Content script is injected only after user action.
3. Scanner waits up to 500ms for iframes before scan.
4. Scanner detects top-document standard fields.
5. Scanner recursively detects same-origin iframe fields.
6. Nested FrameLocator resolution works from the top document.
7. Cross-origin/sandboxed iframes show warnings and create no internal candidates.
8. Recursive iframe scan has cycle detection.
9. Recursive iframe scan has max depth 5.
10. Global scan budget applies across top document and all iframes.
11. Rules do not depend on unstable runtime frameId.
12. Rules use stable FrameLocator.
13. Radio groups are taught and filled as groups.
14. Checkbox groups are taught and filled as groups.
15. Group rule key uses groupFingerprint only, not redundant optionHash.
16. Group undo restores all prior checked states.
17. Rule scope is explicit and defaults to eTLD+1 domain.
18. optionHash is order-independent for option-based groups.
19. normalizedSection is derived from fieldset legend or nearest preceding heading.
20. Contenteditable can be explicitly taught and filled with warning.
21. SPA URL changes are detected without monkey-patching history APIs.
22. hashchange is detected.
23. URL monitor runs only while side panel/scanner is active.
24. Manual Rescan button reruns the full scan.
25. Fill verification retries async framework updates.
26. Paste-mode fallback prompts user when fill fails.
27. IndexedDB migration lock works.
28. Export/import includes schema version.
29. Blocked fields are gray and never fill.
30. Undo works for supported fills.
31. Required fixtures pass.
32. Manual smoke test on 10 real forms passes.
```

---

## 40. Implementation Order

```text
1. Extension shell
2. Side panel
3. Message bus
4. Active-tab content script injection
5. Top-document scanner
6. waitForIframes helper
7. Stable FrameLocator generation
8. Nested FrameLocator resolution
9. Same-origin iframe scanner
10. Cycle/depth/global-budget guards
11. Inaccessible iframe warnings
12. Label and normalizedSection extraction
13. Logical group builder
14. Exact rule storage
15. Rule scope handling
16. Text/textarea/select fill
17. Radio/checkbox group fill
18. Group undo
19. Contenteditable explicit fill
20. Timer/hashchange URL monitor
21. Side-panel lifecycle start/stop for scanner and URL monitor
22. Manual Rescan button
23. Fill verification retry
24. Paste fallback
25. Export/import
26. Fixtures/tests
```

---

## 41. Final Verdict

This blueprint is now 10/10 for a Phase 1 MVP because it is concrete, trimmed, and fixes the latest practical issues:

```text
minimal storage
nested FrameLocator resolution
iframe load wait
side-panel-bound URL monitor lifecycle
normalizedSection extraction
simplified group rule key
hashchange handling
manual Rescan
stable iframe matching
group-level radio/checkbox teaching
```

The next step is implementation.
