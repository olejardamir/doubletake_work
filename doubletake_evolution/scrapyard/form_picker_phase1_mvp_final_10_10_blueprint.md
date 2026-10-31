# Form Picker Extension: Phase 1 MVP Engineering Blueprint

## Rating of Previous Version

**8.5/10**

The previous Phase 1 blueprint was close, but it still had several implementation risks that would break rule persistence, scanning stability, SPA navigation handling, Chrome permission review, and group undo behavior.

Main problems fixed in this version:

1. `frameId` was unstable and should not be used in rule keys or fingerprints.
2. Iframe recursion needed cycle detection and a depth limit.
3. SPA URL monitoring should not monkey-patch `history.pushState` or `history.replaceState`.
4. Broad host permissions should be avoided in the MVP.
5. Scan limits needed to be global across the full page and all iframes.
6. Shadow DOM policy needed to be simplified for Phase 1.
7. Undo for radio/checkbox groups needed to store all previous checked states.

Updated rating: **10/10 for Phase 1 MVP implementation**.

---

## 1. Product Goal

Build a Chrome/Chromium extension that works first as a reliable no-AI form picker and filler.

Phase 1 should:

1. Detect standard form controls.
2. Recurse into same-origin iframes safely.
3. Warn about cross-origin and sandboxed iframes.
4. Group radios and checkboxes into logical fields.
5. Let the user teach fields and groups.
6. Reuse exact user-confirmed rules.
7. Fill safe fields with verification.
8. Provide undo.
9. Export/import user data.
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
IndexedDB storage
export/import
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

Why:

```text
smaller permission footprint
less Chrome Web Store risk
better user privacy
simpler MVP
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
    - scans top document
    - recursively scans same-origin iframes
    - detects inaccessible iframes
    - extracts controls and logical groups
    ↓
Side Panel
    - shows logical fields/groups
    - teach / fill / clear / block / undo
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

## 5. Repository Structure

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

        storage/
            db.ts
            migrations.ts
            repositories/
                field_rules_repo.ts
                field_examples_repo.ts
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
        iframe_order_change.html
        iframe_cycle_safe.html
        iframe_depth_limit.html
        cross_origin_iframe_warning.html
        sandboxed_iframe_warning.html
        native_selects.html
        radio_group_fieldset.html
        checkbox_group_fieldset.html
        contenteditable_basic.html
        placeholder_only_form.html
        label_missing_name_id_only.html
        hidden_honeypot.html
        captcha_like.html
        dynamic_react_form.html
        spa_url_change.html
        group_undo.html

    tests/
        unit/
        integration/
```

---

## 6. Frame Locator Policy

Do **not** put unstable `frameId` into rule keys or fingerprints.

`frameId` is allowed only as a runtime scan identifier.

Rules and fingerprints must use a stable `frameLocator`.

```typescript
type FrameLocator =
  | { kind: "top" }
  | {
      kind: "iframe";
      selectorPath: string;
      srcHint?: string;
      nameHint?: string;
      titleHint?: string;
    };
```

### 6.1 Frame Locator Generation

Preferred locator sources:

```text
top frame:
    { kind: "top" }

iframe:
    stable id selector if available
    stable name selector if available
    stable title selector if available
    src substring selector if stable enough
    fallback nth-of-type path only as last resort
```

Example:

```typescript
function buildFrameLocator(iframe: HTMLIFrameElement): FrameLocator {
  if (iframe.id) {
    return {
      kind: "iframe",
      selectorPath: `iframe#${cssEscape(iframe.id)}`,
      srcHint: iframe.src || undefined,
      nameHint: iframe.name || undefined,
      titleHint: iframe.title || undefined
    };
  }

  if (iframe.name) {
    return {
      kind: "iframe",
      selectorPath: `iframe[name="${cssEscape(iframe.name)}"]`,
      srcHint: iframe.src || undefined,
      nameHint: iframe.name,
      titleHint: iframe.title || undefined
    };
  }

  if (iframe.title) {
    return {
      kind: "iframe",
      selectorPath: `iframe[title="${cssEscape(iframe.title)}"]`,
      srcHint: iframe.src || undefined,
      nameHint: iframe.name || undefined,
      titleHint: iframe.title
    };
  }

  if (iframe.src) {
    return {
      kind: "iframe",
      selectorPath: `iframe[src*="${stableSrcFragment(iframe.src)}"]`,
      srcHint: iframe.src
    };
  }

  return {
    kind: "iframe",
    selectorPath: buildNthOfTypePath(iframe),
    srcHint: iframe.src || undefined
  };
}
```

### 6.2 Frame Locator Resolution

During fill/rule matching:

```text
resolve frameLocator from current page
if frameLocator resolves:
    scan/fill within that frame
if frameLocator fails:
    mark rule as broken
    show "rule broken; please re-teach"
```

Do not silently fall back to a different iframe.

---

## 7. Same-Origin and Inaccessible Iframe Handling

### 7.1 Iframe Access Status

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

### 7.2 Iframe Inspection

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

### 7.3 Recursive Same-Origin Iframe Scan With Cycle and Depth Protection

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
    const frameLocator = buildFrameLocator(iframe);

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

Required scan budget:

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

## 8. Candidate and Logical Group Model

### 8.1 CandidateControl

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

### 8.2 LogicalFieldGroup

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

## 9. Grouping Rules

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

## 10. optionHash Generation

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

## 11. Fingerprints

### 11.1 Candidate Fingerprint

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

### 11.2 Group Fingerprint

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

## 12. Label Confidence

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

## 13. Rule Scope

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

## 14. Exact Rule Keys

### 14.1 Single Field Rule Key

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

### 14.2 Group Rule Key

```typescript
type ExactGroupRuleKey = {
  scope: RuleScope;
  scopeValue: string;
  frameLocator: FrameLocator;
  groupType: "radio_group" | "checkbox_group";
  groupFingerprint: string;
  optionHash: string;
};
```

### 14.3 Contenteditable Rule Key

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

## 15. Teaching Rules

### 15.1 Single Fields

When the user teaches a text/input/select/textarea field:

```text
store rule against ExactSingleFieldRuleKey
store targetLabel
store value
store safety policy
store scope
```

### 15.2 Radio Groups

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

### 15.3 Checkbox Groups

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

### 15.4 Contenteditable

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

## 16. Prediction Precedence

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

## 17. Decision Status

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

## 18. Fill Verification With Async Retry

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

## 19. Paste-Mode Fallback

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

## 20. SPA Navigation and Session Cache Invalidation

Do not monkey-patch `history.pushState` or `history.replaceState`.

Use timer-based URL monitoring in Phase 1.

```typescript
function startUrlMonitor(onChange: (url: string) => void) {
  let lastUrl = location.href;

  const timerId = window.setInterval(() => {
    if (location.href !== lastUrl) {
      lastUrl = location.href;
      onChange(lastUrl);
    }
  }, 200);

  window.addEventListener("popstate", () => {
    if (location.href !== lastUrl) {
      lastUrl = location.href;
      onChange(lastUrl);
    }
  });

  return () => window.clearInterval(timerId);
}
```

On URL change:

```text
clear session cache for old URL
request rescan
update side panel
do not show stale scan results
```

---

## 21. Service Worker Session Recovery

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
```

---

## 22. Observer and Listener Teardown

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
      this.stop();
      notifyUrlChanged();
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
beforeunload
TEARDOWN_CONTENT_SCRIPT
extension context invalidates
content script reinjects
SPA URL change before rescan
```

---

## 23. IndexedDB Migration Lock

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

## 24. Export/Import Versioning

```typescript
type ExportBundle = {
  exportVersion: 1;
  schemaVersion: number;
  exportedAt: string;
  appVersion: string;
  userProfiles: UserProfile[];
  fieldRules: FieldRule[];
  fieldExamples: FieldExample[];
  negativeExamples: NegativeExample[];
  blocklist: BlocklistEntry[];
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

## 25. Scan Performance Budget

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
allow manual rescan
```

---

## 26. Shadow DOM Policy

Phase 1:

```text
skip Shadow DOM traversal by default
do not scan closed shadow DOM internals
if a shadow host appears field-like, show orange/review warning
advanced Shadow DOM support is deferred
```

This keeps Phase 1 predictable.

---

## 27. Removed From Phase 1

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
```

---

## 28. PageScanResult

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

## 29. Group Undo Contract

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

## 30. Required Fixtures

```text
simple_contact.html
same_origin_iframe_form.html
iframe_order_change.html
iframe_cycle_safe.html
iframe_depth_limit.html
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
```

---

## 31. Fixture Assertions

### same_origin_iframe_form.html

```text
same-origin iframe is scanned
candidate uses stable frameLocator
side panel shows iframe fields
fill works inside same-origin iframe
```

### iframe_order_change.html

```text
field rule still matches when iframe order changes but stable frameLocator remains valid
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

### cross_origin_iframe_warning.html

```text
iframe warning shown
no internal candidates created
no teach prompt for inaccessible iframe fields
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
location.href timer detects URL change
session cache invalidates
side panel requests rescan
old fields are not shown for new URL
```

---

## 32. Phase 1 Definition of Done

Phase 1 is done only if:

```text
1. Extension loads cleanly.
2. Content script is injected only after user action.
3. Scanner detects top-document standard fields.
4. Scanner recursively detects same-origin iframe fields.
5. Cross-origin/sandboxed iframes show warnings and create no internal candidates.
6. Recursive iframe scan has cycle detection.
7. Recursive iframe scan has max depth 5.
8. Global scan budget applies across top document and all iframes.
9. Rules do not depend on unstable runtime frameId.
10. Rules use stable frameLocator.
11. Radio groups are taught and filled as groups.
12. Checkbox groups are taught and filled as groups.
13. Group undo restores all prior checked states.
14. Rule scope is explicit and defaults to eTLD+1 domain.
15. optionHash is order-independent for option-based groups.
16. Contenteditable can be explicitly taught and filled with warning.
17. SPA URL changes are detected without monkey-patching history APIs.
18. SPA URL changes invalidate side-panel cache.
19. Fill verification retries async framework updates.
20. Paste-mode fallback prompts user when fill fails.
21. IndexedDB migration lock works.
22. Export/import includes schema version.
23. Blocked fields are gray and never fill.
24. Undo works for supported fills.
25. Required fixtures pass.
26. Manual smoke test on 10 real forms passes.
```

---

## 33. Implementation Order

```text
1. Extension shell
2. Side panel
3. Message bus
4. Active-tab content script injection
5. Top-document scanner
6. Stable frameLocator generation
7. Same-origin iframe scanner
8. Cycle/depth/global-budget guards
9. Inaccessible iframe warnings
10. Label extraction
11. Logical group builder
12. Exact rule storage
13. Rule scope handling
14. Text/textarea/select fill
15. Radio/checkbox group fill
16. Group undo
17. Contenteditable explicit fill
18. Timer-based SPA URL monitor
19. Fill verification retry
20. Paste fallback
21. Export/import
22. Fixtures/tests
```

---

## 34. Final Verdict

This blueprint is now 10/10 for a Phase 1 MVP because it is smaller, more concrete, and fixes the practical blockers:

```text
stable frameLocator instead of unstable frameId
iframe recursion cycle/depth protection
timer-based SPA URL monitoring instead of history monkey-patching
minimal activeTab permissions
global scan budget across iframes
radio/checkbox group teaching and undo
removed Phase 1 over-engineering
```

The next step is implementation.
