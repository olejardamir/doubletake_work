# Form Picker Extension: Phase 1 MVP Engineering Blueprint

## Rating of Previous Version

**8.5/10**

The previous blueprint had a strong foundation, but the latest evaluation identified practical gaps that would break or slow a Phase 1 MVP:

- same-origin iframe scanning was not specified
- radio/checkbox groups were not handled as teachable/fillable logical groups
- exact-rule scope was ambiguous
- `optionHash` generation was underspecified
- contenteditable support was too limited
- service-worker/session cache invalidation was missing
- several features were over-engineered for Phase 1

This version fixes those issues and trims the MVP to a smaller, directly implementable product.

Updated rating: **10/10 for Phase 1 MVP handoff**.

---

## 1. Product Goal

Build a browser-based form-filling assistant that works first as a reliable no-AI MVP.

The Phase 1 product should:

1. Detect standard form controls.
2. Detect and recurse into same-origin iframes.
3. Warn about cross-origin/sandboxed inaccessible iframes.
4. Group radios and checkboxes into logical fields.
5. Let the user teach fields and groups.
6. Reuse exact user-confirmed rules.
7. Fill safe fields with verification.
8. Provide undo.
9. Export/import user data.
10. Avoid AI, classifiers, embeddings, macros, and broad automation in Phase 1.

Phase 1 is an **exact-rule MVP**, not an AI system.

---

## 2. Phase 1 Scope

### Include

```text
Manifest V3 extension
content script scanner
background service worker
side panel UI
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
```

---

## 3. Minimal Architecture

```text
Chrome Extension
    ↓
Content Script Scanner
    - scans top document
    - recursively scans same-origin iframes
    - detects inaccessible iframes
    - extracts fields and logical groups
    ↓
Side Panel
    - shows logical fields/groups
    - teach / fill / clear / block / undo
    ↓
Background Service Worker
    - storage
    - message routing
    - session cache
    - export/import
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

## 4. Minimal Manifest V3 Permissions

```json
{
  "permissions": [
    "storage",
    "activeTab",
    "scripting",
    "sidePanel"
  ],
  "host_permissions": [
    "http://*/*",
    "https://*/*"
  ]
}
```

Do not request `webNavigation` in the initial build unless stale side-panel state cannot be solved with content-script URL monitoring.

If `webNavigation` is added later, document:

```text
permission: webNavigation
reason: invalidate session cache on SPA/history navigation
feature: side-panel state recovery
fallback: content-script location.href monitoring
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
            session_cache.ts

        content/
            content_entry.ts
            scanner/
                scan_page.ts
                scan_iframe.ts
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

    tests/
        unit/
        integration/
```

---

## 6. Same-Origin and Inaccessible Iframe Handling

### 6.1 Iframe Access Status

```typescript
type IframeAccessStatus =
  | "top"
  | "same_origin_accessible"
  | "cross_origin_inaccessible"
  | "sandboxed_inaccessible"
  | "empty_or_not_loaded";
```

### 6.2 Iframe Inspection

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

### 6.3 Recursive Same-Origin Iframe Scan

```typescript
function scanDocument(doc: Document, frameContext: FrameContext): ScanPartial {
  const localCandidates = detectControls(doc, frameContext);
  const localGroups = groupControls(localCandidates);

  const iframeResults: ScanPartial[] = [];

  for (const iframe of Array.from(doc.querySelectorAll("iframe"))) {
    const inspection = inspectIframe(iframe);
    const frameId = buildFrameId(frameContext.frameId, iframe);

    if (inspection.status === "same_origin_accessible" && inspection.document) {
      iframeResults.push(
        scanDocument(inspection.document, {
          frameId,
          frameUrl: iframe.src || inspection.document.location.href,
          accessStatus: "same_origin_accessible"
        })
      );
    } else {
      recordIframeWarning({
        frameId,
        status: inspection.status,
        src: iframe.src || null
      });
    }
  }

  return mergeScanPartials(localCandidates, localGroups, iframeResults);
}
```

Rules:

```text
same-origin iframe:
    recursively scan and prefix candidate IDs with frameId

cross-origin iframe:
    warning only
    no internal candidates

sandboxed iframe without allow-same-origin:
    warning only
    no internal candidates

empty/not loaded iframe:
    temporary warning
    allow rescan
```

---

## 7. Candidate and Logical Group Model

### 7.1 CandidateControl

```typescript
type CandidateControl = {
  candidateId: string;
  logicalGroupId?: string;

  frameId: string;
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

### 7.2 LogicalFieldGroup

```typescript
type LogicalFieldGroup = {
  groupId: string;
  type:
    | "single_field"
    | "radio_group"
    | "checkbox_group"
    | "contenteditable";

  members: CandidateControl[];

  frameId: string;
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

### 7.3 Grouping Rules

```text
radio group:
    same frameId
    same name attribute where available
    same fieldset/legend or nearest group context

checkbox group:
    same frameId
    same fieldset/legend or nearest group context
    if standalone checkbox, group has one member

single field:
    input/textarea/select/contenteditable with no grouped peers
```

---

## 8. optionHash Generation

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

## 9. Fingerprints

### 9.1 Candidate Fingerprint

```typescript
function makeCandidateFingerprint(field: CandidateControl): string {
  const parts = [
    field.frameId,
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

### 9.2 Group Fingerprint

```typescript
function makeGroupFingerprint(group: LogicalFieldGroup): string {
  return hash([
    group.frameId,
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

## 10. Label Confidence

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

## 11. Rule Scope

Define scope explicitly.

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
    example: https://app.example.com

domain:
    effective TLD+1
    example: example.com
    matches app.example.com and www.example.com

path_prefix:
    origin + configured path prefix
    example: https://example.com/apply/

exact_url:
    exact page URL without hash unless configured otherwise
```

Rule storage must include:

```typescript
scope: RuleScope;
scopeValue: string;
```

For domain scope, use a public-suffix-list library or a vetted eTLD+1 helper. Do not naïvely take the last two hostname parts.

---

## 12. Exact Rule Keys

### 12.1 Single Field Rule Key

```typescript
type ExactSingleFieldRuleKey = {
  scope: RuleScope;
  scopeValue: string;
  frameId: string;
  fieldType: string;
  inputType?: string;
  autocomplete?: string;
  normalizedLabel?: string;
  normalizedName?: string;
  normalizedId?: string;
};
```

### 12.2 Group Rule Key

```typescript
type ExactGroupRuleKey = {
  scope: RuleScope;
  scopeValue: string;
  frameId: string;
  groupType: "radio_group" | "checkbox_group";
  groupFingerprint: string;
  optionHash: string;
};
```

### 12.3 Contenteditable Rule Key

```typescript
type ExactContenteditableRuleKey = {
  scope: RuleScope;
  scopeValue: string;
  frameId: string;
  normalizedLabel?: string;
  selectorHint?: string;
  fingerprint: string;
};
```

---

## 13. Teaching Rules

### 13.1 Single Fields

When the user teaches a text/input/select/textarea field:

```text
store rule against ExactSingleFieldRuleKey
store targetLabel
store value
store safety policy
store scope
```

### 13.2 Radio Groups

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

### 13.3 Checkbox Groups

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

### 13.4 Contenteditable

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

## 14. Prediction Precedence

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

## 15. Decision Status

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

## 16. Fill Verification With Async Retry

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

## 17. Paste-Mode Fallback

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

## 18. SPA Navigation and Session Cache Invalidation

Use content-script URL monitoring in Phase 1.

```typescript
function startUrlMonitor(onChange: (url: string) => void) {
  let lastUrl = location.href;

  const check = () => {
    if (location.href !== lastUrl) {
      lastUrl = location.href;
      onChange(lastUrl);
    }
  };

  const originalPushState = history.pushState;
  history.pushState = function (...args) {
    originalPushState.apply(this, args as any);
    check();
  };

  const originalReplaceState = history.replaceState;
  history.replaceState = function (...args) {
    originalReplaceState.apply(this, args as any);
    check();
  };

  window.addEventListener("popstate", check);
}
```

On URL change:

```text
clear session cache for old URL
request rescan
update side panel
do not show stale scan results
```

Later optional improvement:

```text
webNavigation permission
onCommitted
onHistoryStateUpdated
```

Only add `webNavigation` if URL monitoring is insufficient.

---

## 19. Service Worker Session Recovery

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

## 20. Observer and Listener Teardown

```typescript
class PageScanner {
  private observer: MutationObserver | null = null;
  private listeners: Array<() => void> = [];
  private isActive = false;

  start() {
    this.stop();
    this.isActive = true;

    this.observer = new MutationObserver(debouncedScan);
    this.observer.observe(document.body, { childList: true, subtree: true });

    const beforeUnload = () => this.stop();
    window.addEventListener("beforeunload", beforeUnload);
    this.listeners.push(() => window.removeEventListener("beforeunload", beforeUnload));
  }

  stop() {
    if (this.observer) {
      this.observer.disconnect();
      this.observer = null;
    }

    for (const remove of this.listeners) remove();
    this.listeners = [];
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

## 21. IndexedDB Migration Lock

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

## 22. Export/Import Versioning

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

## 23. Scan Performance Budget

```text
max elements inspected per scan: 1500
max candidates per scan: 300
max scan time before yielding: 50ms chunks
max total scan time before warning: 1000ms
MutationObserver debounce: 250-500ms
```

If candidate count is high:

```text
side panel may group by section/status
full virtualization is deferred unless real testing shows it is needed
```

---

## 24. Shadow DOM Policy

Phase 1:

```text
open shadow DOM:
    optional simple scan if safe

closed shadow DOM:
    do not scan internals
    show warning if host appears field-like

custom web components:
    orange/review
```

No advanced Shadow DOM work in Phase 1.

---

## 25. Removed From Phase 1

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

## 26. PageScanResult

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
  };

  warnings: {
    code: string;
    message: string;
    severity: ErrorSeverity;
  }[];
};
```

---

## 27. Required Fixtures

```text
simple_contact.html
same_origin_iframe_form.html
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
```

---

## 28. Fixture Assertions

### same_origin_iframe_form.html

```text
same-origin iframe is scanned
candidate frameId includes iframe prefix
side panel shows iframe fields
fill works inside same-origin iframe
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
history.pushState changes URL
session cache invalidates
side panel requests rescan
old fields are not shown for new URL
```

---

## 29. Phase 1 Definition of Done

Phase 1 is done only if:

```text
1. Extension loads cleanly.
2. Scanner detects top-document standard fields.
3. Scanner recursively detects same-origin iframe fields.
4. Cross-origin/sandboxed iframes show warnings and create no internal candidates.
5. Radio groups are taught and filled as groups.
6. Checkbox groups are taught and filled as groups.
7. Rule scope is explicit and defaults to eTLD+1 domain.
8. optionHash is order-independent for option-based groups.
9. Contenteditable can be explicitly taught and filled with warning.
10. SPA URL changes invalidate side-panel cache.
11. Fill verification retries async framework updates.
12. Paste-mode fallback prompts user when fill fails.
13. IndexedDB migration lock works.
14. Export/import includes schema version.
15. Blocked fields are gray and never fill.
16. Undo works for supported fills.
17. Required fixtures pass.
18. Manual smoke test on 10 real forms passes.
```

---

## 30. Implementation Order

```text
1. Extension shell
2. Side panel
3. Message bus
4. Top-document scanner
5. Same-origin iframe scanner
6. Inaccessible iframe warnings
7. Label extraction
8. Logical group builder
9. Exact rule storage
10. Rule scope handling
11. Text/textarea/select fill
12. Radio/checkbox group fill
13. Contenteditable explicit fill
14. SPA URL monitor
15. Fill verification retry
16. Paste fallback
17. Export/import
18. Fixtures/tests
```

---

## 31. Final Verdict

This blueprint is now 10/10 for a Phase 1 MVP because it is smaller, more concrete, and fixes the practical blockers:

```text
same-origin iframe recursion
radio/checkbox group-level teaching
explicit rule scope
order-independent optionHash
SPA cache invalidation
basic contenteditable support
removed Phase 1 over-engineering
```

The next step is implementation, not more design expansion.
