# uBR Smart Cosmetic Rule Syntax and Logic Blueprint

## Purpose

This document defines a proposed syntax and rule model for a future Smart Cosmetic Rule system in uBlock Resurrected. It is intentionally focused on **rule language, user-facing logic, and conceptual behavior**, not on source-code implementation.

The goal is to move beyond brittle raw CSS selectors while preserving compatibility with existing cosmetic filtering ideas. The system should support simple cases such as hiding one selected element, but also more complex cases such as hiding all similar feed cards that match keyword, attribute, link, or structural logic.

The core idea is:

```text
A rule should describe what kind of element should be hidden,
why it should be hidden,
where the rule applies,
how far it should generalize,
and what safety conditions prevent false positives.
```

The rule system should not force every user decision into a long CSS selector. Instead, raw selectors should be one possible compilation target. The primary authoring model should be a higher-level rule format that can express similarity, keyword logic, stable attributes, exceptions, and action behavior.

---

## Core Design Decision

The recommended foundation is a **layered rule language**:

```text
Layer 1: Classic cosmetic filters
Layer 2: Procedural cosmetic filters
Layer 3: Smart cosmetic rules
Layer 4: Internal normalized rule schema
Layer 5: Compiled runtime form
```

Each layer has a different purpose.

| Layer | Purpose | User visibility | Example |
|---|---|---:|---|
| Classic cosmetic filter | Fast exact CSS hiding | visible to advanced users | `example.com##.ad-banner` |
| Procedural cosmetic filter | CSS plus conditions such as text/attribute/ancestor | visible to advanced users | `example.com##article:has-text(/sponsored/i)` |
| Smart cosmetic rule | Human-readable rule logic | visible in smart editor | `hide similar cards where text contains Sponsored` |
| Internal schema | Stable storage and migration | mostly hidden | JSON/AST rule object |
| Compiled runtime form | Efficient execution | hidden | prefilter + predicate + action |

The most important principle:

```text
Smart syntax is the authoring language.
CSS/procedural filters are optimization and compatibility targets.
```

This prevents the project from becoming trapped in brittle selectors while still keeping compatibility with existing filter-list culture.

---

## Rule Philosophy

A smart cosmetic rule should always answer five questions:

```text
1. WHERE does this rule apply?
2. WHAT elements are candidates?
3. HOW should the system generalize from the selected element?
4. WHICH logic must be true before blocking?
5. WHAT action should be taken?
```

A good rule should therefore contain these conceptual parts:

```text
site target
scope
candidate type
boundary behavior
matching mode
include conditions
exclude conditions
action
confidence / safety behavior
```

A weak rule says:

```text
Hide this long exact DOM path.
```

A strong rule says:

```text
On reddit.com, inside the main feed, find post-like cards similar to the selected one,
but hide them only if their visible text or accessibility label contains Sponsored or Promoted,
and do not hide moderator/system posts.
```

---

## Main Rule Types

The syntax should support four main rule types from the beginning.

### 1. Exact Element Rule

Used when the user wants to hide only one specific selected element or one highly specific stable selector.

Use this for:

```text
- a single annoying widget
- a one-off page element
- a specific banner
- an element that should not generalize to similar elements
```

Conceptual example:

```text
hide-exact:
  targets: www.example.com
  selector: div[data-widget="newsletter-popup"]
  action: hide
```

Equivalent classic style:

```text
www.example.com##div[data-widget="newsletter-popup"]
```

This rule type should be the simplest and fastest. It should not use similarity scoring.

---

### 2. Similar Element Rule

Used when the user selects one element and wants all elements of the same kind blocked.

Use this for:

```text
- repeated feed cards
- repeated recommendation blocks
- repeated job cards
- repeated product cards
- repeated sidebar modules
```

Conceptual example:

```text
hide-similar:
  targets: www.example.com
  scope: main, aside, [role="feed"]
  candidates: article, section, li, div[role="listitem"]
  similar-to: picked
  similarity: >= 0.76
  action: hide
```

This rule type can be risky if used without additional conditions. Therefore, the system should warn the user when the rule has no keyword, attribute, link, or exclusion logic.

Recommended safety rule:

```text
A pure similarity rule should require preview confirmation.
A similarity rule with content logic is safer and should be preferred.
```

---

### 3. Conditional Similar Element Rule

Used when the user wants all similar elements blocked **only if** they match keyword, attribute, link, or metadata logic.

This should become the default smart-rule type.

Use this for:

```text
- promoted Reddit posts
- LinkedIn recommended sections
- YouTube recommendation shelves with certain labels
- job cards from specific companies
- feed cards containing unwanted topics
- blocks with suspicious href patterns
```

Conceptual example:

```text
smart-hide:
  targets: www.linkedin.com
  scope: main, aside, [role="feed"]
  candidates: article, section, li, div[role="listitem"]
  similar-to: picked
  require:
    similarity >= 0.74
    AND (
      text ~= /hire with ai|promoted|sponsored/i
      OR aria-label ~= /hire with ai/i
      OR href ~= /talent\/job-posting-redirect\//
      OR data-sdui-component ~= /RecommendedEntitySection/
    )
  exclude:
    text ~= /message|conversation|inbox/i
  action: hide
```

This is the key target design for uBR Smart Cosmetic Rules.

---

### 4. Content Logic Rule

Used when the user cares more about content than structural similarity.

Use this for:

```text
- hide any card mentioning a keyword
- hide posts containing a phrase
- hide job cards from a company
- hide search results with certain domains
- hide blocks with specific link targets
```

Example:

```text
hide-content:
  targets: www.reddit.com
  scope: main
  candidates: article, shreddit-post, div[data-testid="post-container"]
  require:
    text ~= /\bcrypto\b|\bnft\b/i
  exclude:
    text ~= /research|security|academic/i
  action: hide
```

This rule should still require a candidate container. The system should avoid global page-wide text matching without a block boundary, because that can hide too much.

---

## Recommended User-Facing Syntax

The recommended user-facing smart syntax should be **YAML-like**, because it is readable, editable, and easier to explain than deeply nested selector expressions.

The canonical form should be:

```text
smart-hide:
  targets: <site-targets>
  paths: <optional-path-constraints>
  scope: <where-to-search>
  candidates: <candidate-elements>
  boundary: <container-selection-policy>
  similar-to: <picked | selector | none>
  require:
    <logic-expression>
  exclude:
    <logic-expression>
  action: <hide | remove | style | unhide | mark>
  safety:
    <thresholds-and-preview-policy>
```

A minimal valid rule can be short:

```text
smart-hide:
  targets: www.example.com
  candidates: article
  require:
    text ~= /sponsored/i
  action: hide
```

A richer rule can be more precise:

```text
smart-hide:
  targets: www.example.com
  paths: /feed/*, /home/*
  scope: main, [role="feed"]
  candidates: article, div[role="listitem"]
  boundary: repeated-card
  similar-to: picked
  require:
    similarity >= 0.75
    AND (
      text ~= /promoted|sponsored/i
      OR aria-label ~= /promoted/i
    )
  exclude:
    text ~= /moderator|system notice/i
  action: hide
  safety:
    preview: required
    max-matches: 100
```

---

## Site Target Syntax

The `targets` field defines where the rule applies.

Recommended supported forms:

```text
Exact host:
  targets: www.reddit.com

Multiple hosts:
  targets: www.reddit.com, old.reddit.com

Domain family:
  targets: reddit.com

Entity-style family:
  targets: google.*

Hostname regex:
  targets: /(^|\.)example\.(com|net)$/
```

Recommended rules:

```text
1. Exact host is safest.
2. Domain family is acceptable.
3. Entity-style family is useful but should be explicit.
4. Hostname regex is powerful but should show a warning.
5. Smart procedural rules should never be fully global by default.
```

Bad:

```text
smart-hide:
  targets: *
  require:
    text ~= /ad/i
```

Better:

```text
smart-hide:
  targets: www.example.com
  scope: main
  candidates: article, section, aside
  require:
    text ~= /sponsored/i
```

---

## Path Constraints

The `paths` field limits a rule to parts of a website.

Examples:

```text
paths: /feed/*
paths: /jobs/*, /in/*
paths: /^\/(feed|jobs|in)\//
```

Use path constraints when the same site has very different layouts across different pages.

For example, LinkedIn profile pages, feed pages, search pages, and jobs pages can all have different card structures. A smart rule should not automatically assume that a rule created on one area of a site is safe everywhere.

Recommended behavior:

```text
If a rule is created from the picker, default to the current path family.
Then allow the user to broaden it manually.
```

Example:

```text
smart-hide:
  targets: www.linkedin.com
  paths: /in/*
  scope: main, aside
  candidates: section, div[role="region"]
  require:
    data-sdui-component ~= /RecommendedEntitySection/
  action: hide
```

---

## Scope Syntax

The `scope` field defines where candidate matching begins.

Examples:

```text
scope: main
scope: aside
scope: main, aside
scope: [role="feed"]
scope: main [data-testid="primaryColumn"]
```

The scope is not the final target. It is the search area.

Good scope:

```text
scope: main, [role="feed"]
```

Bad scope:

```text
scope: body
```

`body` should be allowed but discouraged for complex smart rules, because it increases false positives and runtime cost.

Recommended scope hierarchy:

```text
Best:
  main, aside, [role="feed"], [role="main"], known feed containers

Acceptable:
  section, article parent regions, page-specific containers

Risky:
  body, html, generic div-only search
```

---

## Candidate Syntax

The `candidates` field defines which elements are considered possible targets.

Examples:

```text
candidates: article
candidates: section
candidates: li
candidates: div[role="listitem"]
candidates: article, section, li, div[role="listitem"]
candidates: shreddit-post, article, div[data-testid="post-container"]
```

Candidate selectors should be broad enough to catch repeated blocks, but narrow enough to avoid scanning the whole DOM.

Recommended default candidate sets:

### Feed pages

```text
candidates: article, div[role="article"], div[role="listitem"], li
```

### Sidebar modules

```text
candidates: aside section, aside div[role="region"], aside div[data-testid]
```

### Job boards

```text
candidates: article, li, div[role="listitem"], div[class*="job"]
```

### Search results

```text
candidates: article, li, div[role="listitem"], div[data-result]
```

### Reddit-like pages

```text
candidates: shreddit-post, article, div[data-testid="post-container"]
```

---

## Boundary Syntax

The `boundary` field defines how uBR chooses the actual block to hide when the selected element is nested inside a larger card.

Recommended boundary modes:

```text
boundary: exact
boundary: nearest-card
boundary: repeated-card
boundary: semantic-block
boundary: visual-block
boundary: ancestor-depth 3
boundary: selector article
boundary: selector div[role="listitem"]
```

### `boundary: exact`

Hide only the selected node or the exact selector target.

```text
boundary: exact
```

Use for one-off hiding.

### `boundary: nearest-card`

Walk upward from the picked element until a likely card/container is found.

```text
boundary: nearest-card
```

Use when the clicked element is inside a card, such as a label, link, image, or button.

### `boundary: repeated-card`

Prefer ancestors that have repeated sibling structures.

```text
boundary: repeated-card
```

Use for feeds, lists, product grids, recommendation blocks, search results, and job boards.

### `boundary: semantic-block`

Prefer semantic containers such as `article`, `section`, `li`, `[role="listitem"]`, `[role="article"]`, or `[role="region"]`.

```text
boundary: semantic-block
```

### `boundary: visual-block`

Use visible geometry to select a block-shaped container.

```text
boundary: visual-block
```

This is useful for pages with messy DOM structure, but it should be more expensive than semantic matching.

### `boundary: ancestor-depth N`

Hide a fixed ancestor level above the selected element.

```text
boundary: ancestor-depth 3
```

This is easy to understand but can be brittle. It should be treated as a fallback.

---

## Similarity Syntax

Similarity controls whether candidate elements are considered the same kind as the selected element.

Recommended form:

```text
similar-to: picked
similarity: >= 0.74
```

or inside logic:

```text
require:
  similarity >= 0.74
```

The similarity score should be normalized from `0.00` to `1.00`.

Suggested interpretation:

| Score | Meaning |
|---:|---|
| `0.90 - 1.00` | Very similar, likely same exact component type |
| `0.75 - 0.89` | Similar enough for same card/module family |
| `0.60 - 0.74` | Borderline, preview strongly recommended |
| `< 0.60` | Too weak for automatic blocking |

Default thresholds:

```text
Exact/safe similarity:
  similarity >= 0.85

General repeated cards:
  similarity >= 0.74

Broad content rules with strong keyword logic:
  similarity >= 0.65

Pure similarity without keywords:
  similarity >= 0.82
```

The system should use stricter similarity when there is no keyword or attribute condition.

---

## Feature Weight Syntax

Advanced rules should allow feature weights, but most users should not have to edit them.

Example:

```text
weights:
  text: 2.0
  aria: 1.5
  href: 2.0
  data-attrs: 1.5
  role-tag: 1.0
  structure: 2.0
  visual-box: 1.0
  classes: 0.25
```

Default recommendation:

```text
High-value signals:
  text
  href
  aria-label
  data-* attributes
  role
  repeated sibling structure
  child tag pattern

Medium-value signals:
  visual size
  image alt text
  text density
  link density

Low-value signals:
  class names
  exact ancestor depth
  nth-child position
```

Generated, hashed, or randomized classes should be downweighted automatically.

Bad primary signal:

```text
class ~= /_4ff70394|_303d7ec1/
```

Better signal:

```text
data-sdui-component ~= /RecommendedEntitySection/
OR href ~= /job-posting-redirect/
OR aria-label ~= /Hire with AI/
```

---

## Logic Syntax

The rule language should support clear Boolean logic:

```text
AND
OR
NOT
parentheses
includeAny
includeAll
excludeAny
excludeAll
```

Recommended user-facing syntax:

```text
require:
  similarity >= 0.74
  AND (
    text ~= /promoted|sponsored/i
    OR aria-label ~= /promoted/i
    OR href ~= /\/ads?\//
  )

exclude:
  text ~= /moderator|system|settings/i
```

Equivalent structured form:

```text
require:
  all:
    - similarity >= 0.74
    - any:
        - text ~= /promoted|sponsored/i
        - aria-label ~= /promoted/i
        - href ~= /\/ads?\//
exclude:
  any:
    - text ~= /moderator/i
    - selector ~= nav, form, header
```

Both forms are useful:

```text
Expression form: better for advanced users.
Structured form: better for UI-generated rules.
```

---

## Match Operators

The smart syntax should define a small, consistent set of operators.

### Equality

```text
attr(name) == "value"
role == "article"
tag == "section"
```

### Contains

```text
text contains "Sponsored"
href contains "/redirect/"
aria-label contains "Promoted"
```

### Regex

```text
text ~= /sponsored|promoted/i
href ~= /\/talent\/job-posting-redirect\//
data-sdui-component ~= /RecommendedEntitySection/
```

### Starts with / ends with

```text
href starts-with "https://www.linkedin.com/talent/"
href ends-with ".pdf"
```

### Exists

```text
attr(data-testid) exists
aria-label exists
href exists
```

### Not exists

```text
attr(data-safe) not-exists
```

### Selector match

```text
selector matches article
selector matches div[role="listitem"]
```

### Descendant match

```text
has descendant a[href*="/ads/"]
has descendant [aria-label*="Sponsored"]
```

### Ancestor match

```text
has ancestor main
has ancestor [role="feed"]
```

### Count / density

```text
text-length >= 20
link-count <= 5
link-density < 0.50
child-count >= 3
```

### Similarity

```text
similarity >= 0.74
structure-similarity >= 0.70
text-similarity >= 0.60
visual-similarity >= 0.65
```

---

## Text Matching Rules

Text matching should operate on normalized visible text, not raw HTML.

Recommended normalization:

```text
- collapse whitespace
- ignore hidden text by default
- lowercase for case-insensitive matches
- decode HTML entities
- optionally include aria-label and image alt in semantic text
```

Recommended text fields:

```text
text              visible text only
semantic-text     visible text + aria labels + alt text
own-text          text directly inside the candidate only
all-text          candidate + descendants
```

Examples:

```text
text ~= /sponsored/i
semantic-text ~= /hire with ai/i
own-text contains "Promoted"
```

This distinction matters because some labels may appear only in accessibility fields or inside nested child elements.

---

## Attribute Matching Rules

Attribute matching should support direct attributes and attribute families.

Examples:

```text
attr(aria-label) ~= /sponsored/i
attr(data-testid) == "post-container"
attr(data-sdui-component) ~= /RecommendedEntitySection/
attr(href) contains "/talent/job-posting-redirect/"
```

Short aliases should be supported for common attributes:

```text
href ~= /redirect/
aria-label ~= /sponsored/i
data-testid == "post-container"
role == "listitem"
```

Attribute family matching:

```text
data-* ~= /RecommendedEntitySection/
aria-* ~= /promoted|sponsored/i
```

Attribute family matching is useful when sites use multiple `data-*` fields unpredictably.

---

## Keyword Logic

Keyword logic should be first-class, not treated as a raw regex afterthought.

Recommended syntax:

```text
keywords:
  include-any: sponsored, promoted, ad
  exclude-any: moderator, system notice
  fields: text, aria-label, alt
  case-sensitive: false
  word-boundary: true
```

Equivalent expression:

```text
require:
  keyword-any("sponsored", "promoted", "ad") in text, aria-label, alt
exclude:
  keyword-any("moderator", "system notice") in text
```

Keyword modes:

| Mode | Meaning |
|---|---|
| `include-any` | at least one keyword must match |
| `include-all` | all keywords must match |
| `exclude-any` | block is rejected if any keyword matches |
| `exclude-all` | block is rejected if all exclusion keywords match |
| `phrase` | exact phrase match after normalization |
| `word` | word-boundary match |
| `regex` | advanced regex match |

Examples:

```text
keywords:
  include-any: "Sponsored", "Promoted"
  word-boundary: true
```

```text
keywords:
  include-all: "AI", "Hiring"
  exclude-any: "message", "inbox"
```

---

## Action Syntax

The rule system should support multiple actions, but `hide` should be the default.

Recommended actions:

```text
action: hide
action: remove
action: style(...)
action: collapse
action: mark
action: unhide
```

### `hide`

Visually hides the element but leaves it in the DOM.

```text
action: hide
```

This should be the safest default.

### `remove`

Removes the element from the DOM.

```text
action: remove
```

Use only when hiding is not enough or when the element reappears visually.

### `style`

Applies a style.

```text
action: style(opacity: 0.25)
action: style(filter: grayscale(1))
action: style(outline: 2px solid red)
```

This is useful for preview or non-destructive customization.

### `collapse`

Hide and remove layout space.

```text
action: collapse
```

This can be equivalent to `display: none`.

### `mark`

Do not hide; visually mark matches.

```text
action: mark
```

Useful for testing and rule debugging.

### `unhide`

Exception action.

```text
action: unhide
```

Used for allowlisting previously blocked content.

---

## Exception and Allow Rules

The syntax should support explicit exceptions.

Example:

```text
smart-allow:
  targets: www.reddit.com
  scope: main
  candidates: article, shreddit-post
  require:
    text ~= /official announcement|moderator/i
```

Exceptions should run after hide rules.

Recommended resolution order:

```text
1. Find candidate elements.
2. Apply hide/block rules.
3. Apply allow/exception rules.
4. If an element matches both, allow wins unless user manually changes priority.
```

Allow rules should be visible near the rule they modify.

Example combined rule:

```text
smart-hide:
  targets: www.reddit.com
  scope: main
  candidates: article, shreddit-post
  require:
    text ~= /promoted|sponsored/i
  exclude:
    text ~= /moderator|official announcement/i
  action: hide
```

Separate allow rule:

```text
smart-allow:
  targets: www.reddit.com
  candidates: article, shreddit-post
  require:
    text ~= /official announcement/i
```

Both should be supported.

---

## Rule Priority

Smart rules need a priority model because multiple rules can match the same element.

Recommended priority fields:

```text
priority: normal
priority: high
priority: low
```

or numeric:

```text
priority: 100
```

Recommended default ordering:

```text
1. User allow rules
2. User exact hide rules
3. User smart hide rules
4. Imported/filter-list rules
5. Generic cosmetic rules
```

When two rules conflict:

```text
allow beats hide
exact beats general
higher priority beats lower priority
newer user rule beats older generated rule only if same priority
```

---

## Safety Syntax

The `safety` section should prevent overblocking.

Example:

```text
safety:
  preview: required
  max-matches: 100
  max-page-percent: 30
  min-similarity-without-keywords: 0.82
  warn-if-scope-is-body: true
  warn-if-no-exclude: true
```

Recommended defaults:

```text
preview: required for generated smart rules
max-matches: 100
max-page-percent: 25
warn-if-body-scope: true
warn-if-no-keyword-and-low-similarity: true
warn-if-action-remove: true
```

The picker should show matched elements before saving. It should also show why each match was selected.

Example explanation:

```text
Matched because:
- Similarity score: 0.81
- Same repeated card pattern
- Contains text: Sponsored
- Has aria-label: Promoted
- No exclusion matched
```

---

## Confidence Buckets

The smart picker should group matches by confidence.

Recommended buckets:

```text
Exact selected element
High-confidence matches
Medium-confidence matches
Borderline matches
Excluded matches
```

Example:

```text
Preview:
  exact: 1
  high-confidence: 6
  medium-confidence: 3
  borderline: 2
  excluded: 1
```

Borderline matches should not be hidden automatically during preview unless the user chooses to include them.

Suggested thresholds:

```text
high-confidence: similarity >= 0.82 and include logic matched
medium-confidence: similarity >= 0.74 and include logic matched
borderline: similarity >= 0.65 and include logic matched
excluded: matched include logic but also matched exclude logic
```

---

## Internal Normalized Schema

Even if the user-facing syntax is YAML-like, uBR should store a normalized internal schema.

The internal schema should be versioned.

Example:

```json
{
  "schemaVersion": "1.0.0",
  "ruleType": "smart-hide",
  "enabled": true,
  "siteTargets": ["www.linkedin.com"],
  "pathTargets": ["/in/*", "/jobs/*"],
  "scope": {
    "selectors": ["main", "aside", "[role='feed']"]
  },
  "candidates": {
    "selectors": ["article", "section", "li", "div[role='listitem']"]
  },
  "boundary": {
    "mode": "repeated-card",
    "ancestorSearchMaxDepth": 8
  },
  "similarity": {
    "source": "picked",
    "minScore": 0.74,
    "weights": {
      "text": 2.0,
      "aria": 1.5,
      "href": 2.0,
      "dataAttrs": 1.5,
      "roleTag": 1.0,
      "structure": 2.0,
      "visualBox": 1.0,
      "classes": 0.25
    }
  },
  "logic": {
    "all": [
      { "similarityGte": 0.74 },
      {
        "any": [
          { "textRegex": "(?i)hire with ai|promoted|sponsored" },
          { "attrRegex": { "name": "aria-label", "value": "(?i)hire with ai" } },
          { "hrefRegex": "/talent/job-posting-redirect/" },
          { "attrRegex": { "name": "data-sdui-component", "value": "RecommendedEntitySection" } }
        ]
      }
    ],
    "excludeAny": [
      { "textRegex": "(?i)message|conversation|inbox" }
    ]
  },
  "action": {
    "type": "hide"
  },
  "safety": {
    "previewRequired": true,
    "maxMatches": 100
  },
  "provenance": {
    "createdBy": "element-picker",
    "createdFromHost": "www.linkedin.com",
    "createdFromPath": "/in/example/"
  }
}
```

The internal schema should preserve enough information to:

```text
- edit the rule later
- explain why it matched
- recompile it after engine upgrades
- migrate old versions
- export/import rules
- debug false positives
```

---

## Rule Compilation Strategy

Smart rules should compile to the simplest viable form.

Compilation target order:

```text
1. Plain CSS cosmetic rule
2. Procedural cosmetic rule
3. Hybrid rule: CSS prefilter + smart predicate
4. Full smart runtime rule
```

### Compile to plain CSS when possible

Example smart rule:

```text
smart-hide:
  targets: www.example.com
  candidates: div[data-testid="ad-banner"]
  action: hide
```

Compiled form:

```text
www.example.com##div[data-testid="ad-banner"]
```

### Compile to procedural filter when possible

Example smart rule:

```text
smart-hide:
  targets: www.example.com
  candidates: article
  require:
    text ~= /sponsored/i
  action: hide
```

Possible compiled form:

```text
www.example.com##article:has-text(/sponsored/i)
```

### Keep as smart rule when similarity is required

Example:

```text
smart-hide:
  targets: www.example.com
  candidates: article, div[role="listitem"]
  similar-to: picked
  require:
    similarity >= 0.74
    AND text ~= /sponsored/i
  action: hide
```

This likely cannot be fully compiled to classic syntax, because `similarity >= 0.74` is not a standard selector concept.

Compiled runtime form:

```text
prefilter: www.example.com -> main article, main div[role="listitem"]
predicate: similarity >= 0.74 AND text matches /sponsored/i
action: hide
```

---

## Compatibility with Existing Cosmetic Syntax

The smart system should remain compatible with existing syntax.

Classic filters should continue to work:

```text
example.com##.ad-banner
example.com###sponsoredBox
example.com##div[data-testid="ad"]
```

Procedural filters should continue to work:

```text
example.com##article:has-text(/sponsored/i)
example.com##div:has(a[href*="/ads/"])
example.com##section:has-text(Promoted):upward(2)
```

Smart rules should be an extension, not a replacement:

```text
smart-hide:
  targets: example.com
  candidates: article
  require:
    text ~= /sponsored/i
  action: hide
```

Recommended compatibility policy:

```text
1. Never break classic EasyList/uBO-style filters.
2. Smart rules are stored separately from raw text filters.
3. Smart rules can export a best-effort compiled filter when possible.
4. If export loses semantics, mark it clearly.
5. Imported classic filters should not be automatically converted to smart rules unless requested.
```

---

## Proposed Smart Syntax Grammar

This is a conceptual grammar, not implementation code.

```text
rule              := ruleType ':' newline ruleBody
ruleType          := 'smart-hide' | 'smart-allow' | 'hide-exact' | 'hide-similar' | 'hide-content'

ruleBody          := targetBlock scopeBlock? candidateBlock? boundaryBlock? similarityBlock? logicBlock actionBlock safetyBlock?

targetBlock       := 'targets:' targetList
pathBlock         := 'paths:' pathList
scopeBlock        := 'scope:' selectorList
candidateBlock    := 'candidates:' selectorList
boundaryBlock     := 'boundary:' boundaryMode
similarityBlock   := 'similar-to:' similaritySource newline 'similarity:' comparison
logicBlock        := 'require:' logicExpression newline 'exclude:' logicExpression?
actionBlock       := 'action:' actionExpression
safetyBlock       := 'safety:' safetyOptions

targetList        := target (',' target)*
selectorList      := selector (',' selector)*
pathList          := pathPattern (',' pathPattern)*

boundaryMode      := 'exact' | 'nearest-card' | 'repeated-card' | 'semantic-block' | 'visual-block' | 'ancestor-depth' number | 'selector' selector
similaritySource  := 'picked' | selector | 'none'

logicExpression   := condition | '(' logicExpression ')' | logicExpression 'AND' logicExpression | logicExpression 'OR' logicExpression | 'NOT' logicExpression
condition         := field operator value | metric comparison number | 'has descendant' selector | 'has ancestor' selector

field             := 'text' | 'semantic-text' | 'own-text' | 'href' | 'aria-label' | 'role' | 'tag' | 'attr(' name ')' | 'data-*' | 'aria-*'
operator          := '==' | '!=' | 'contains' | '~=' | 'starts-with' | 'ends-with' | 'exists' | 'not-exists'
comparison        := '>=' | '<=' | '>' | '<' | '=='
metric            := 'similarity' | 'structure-similarity' | 'text-similarity' | 'visual-similarity' | 'text-length' | 'link-density' | 'child-count'
actionExpression  := 'hide' | 'remove' | 'collapse' | 'mark' | 'unhide' | 'style(' styleText ')'
```

The UI does not need to expose this grammar directly. The grammar exists so advanced users and future developers have a stable mental model.

---

## Examples

### Example 1: Hide one exact element

Use case:

```text
The user selected one newsletter box and wants only that exact element hidden.
```

Rule:

```text
hide-exact:
  targets: www.example.com
  selector: div[data-testid="newsletter-signup"]
  action: hide
```

Compiled classic form:

```text
www.example.com##div[data-testid="newsletter-signup"]
```

---

### Example 2: Hide all similar sidebar recommendation modules

Use case:

```text
The user selected a recommendation module in the sidebar.
Other recommendation modules with the same structure should be hidden.
```

Rule:

```text
hide-similar:
  targets: www.example.com
  scope: aside
  candidates: section, div[role="region"]
  boundary: repeated-card
  similar-to: picked
  require:
    similarity >= 0.82
  action: hide
  safety:
    preview: required
```

This rule is similarity-only, so it uses a stricter threshold.

---

### Example 3: Hide promoted Reddit posts

Use case:

```text
The user selects one promoted Reddit post.
All similar promoted posts should be hidden, but normal posts should remain.
```

Rule:

```text
smart-hide:
  targets: www.reddit.com
  paths: /*
  scope: main, [role="main"]
  candidates: shreddit-post, article, div[data-testid="post-container"]
  boundary: repeated-card
  similar-to: picked
  require:
    similarity >= 0.72
    AND (
      text ~= /\bpromoted\b|\bsponsored\b/i
      OR aria-label ~= /\bpromoted\b|\bsponsored\b/i
    )
  exclude:
    text ~= /\bmoderator\b|\bautomoderator\b|\bofficial announcement\b/i
  action: hide
  safety:
    preview: required
    max-matches: 100
```

Possible compiled procedural approximation:

```text
www.reddit.com##:is(shreddit-post, article, div[data-testid="post-container"]):has-text(/\bpromoted\b|\bsponsored\b/i)
```

The compiled approximation does not preserve similarity scoring, so the full smart rule should remain the authoritative rule.

---

### Example 4: Hide LinkedIn “Hire with AI” item

Use case:

```text
The user wants to hide a LinkedIn item that links to a job-posting redirect and has the label "Hire with AI".
```

Rule:

```text
smart-hide:
  targets: www.linkedin.com
  paths: /in/*, /feed/*, /jobs/*
  scope: main, aside, [role="feed"]
  candidates: article, section, li, div[role="listitem"], div[role="region"]
  boundary: nearest-card
  similar-to: picked
  require:
    similarity >= 0.74
    AND (
      text ~= /hire with ai|promoted|sponsored/i
      OR aria-label ~= /hire with ai/i
      OR href ~= /\/talent\/job-posting-redirect\//
      OR data-* ~= /RecommendedEntitySection/
    )
  exclude:
    text ~= /message|conversation|inbox|notification settings/i
  action: hide
```

This is much more durable than a long chain of generated class names.

---

### Example 5: Hide job cards from specific companies

Use case:

```text
The user wants to hide job cards from certain companies, but only inside job search results.
```

Rule:

```text
hide-content:
  targets: www.linkedin.com
  paths: /jobs/*
  scope: main
  candidates: li, article, div[role="listitem"]
  boundary: repeated-card
  require:
    semantic-text ~= /Company A|Company B|Company C/i
  exclude:
    text ~= /saved|applied/i
  action: hide
```

This does not require similarity because the candidate type and path are already constrained.

---

### Example 6: Hide YouTube shelves by title

Use case:

```text
The user wants to hide YouTube recommendation shelves that contain certain titles.
```

Rule:

```text
smart-hide:
  targets: www.youtube.com
  paths: /*
  scope: ytd-browse, ytd-watch-flexy, main
  candidates: ytd-rich-section-renderer, ytd-shelf-renderer, ytd-reel-shelf-renderer
  boundary: semantic-block
  require:
    text ~= /shorts|breaking news|recommended for you/i
  exclude:
    text ~= /subscriptions/i
  action: hide
```

---

### Example 7: Hide all cards with tracking redirect links

Use case:

```text
The user wants to hide card-like elements containing tracking redirect links.
```

Rule:

```text
smart-hide:
  targets: example.com
  scope: main
  candidates: article, section, li, div[role="listitem"]
  boundary: nearest-card
  require:
    has descendant a[href*="/redirect?"]
    OR href ~= /utm_source=ad|tracking_id=/i
  action: hide
```

---

### Example 8: Mark matches instead of hiding them

Use case:

```text
The user wants to test a rule before actually hiding elements.
```

Rule:

```text
smart-hide:
  targets: www.example.com
  scope: main
  candidates: article
  require:
    text ~= /sponsored/i
  action: mark
```

The UI can show highlighted matches. Once confirmed, the user can change `action: mark` to `action: hide`.

---

## Picker Workflow and Generated Syntax

When the user selects an element, the picker should generate a smart rule in stages.

Recommended workflow:

```text
1. User selects element.
2. Picker identifies candidate boundaries.
3. Picker asks or infers intent:
   - hide only this
   - hide similar elements
   - hide similar elements with keyword/attribute logic
4. Picker extracts stable features.
5. Picker generates a draft rule.
6. Picker previews matches.
7. User adjusts scope, keywords, similarity, or exclusions.
8. User saves rule.
```

The picker should present a simple choice first:

```text
Block:
[ ] only this element
[ ] similar elements
[ ] similar elements only when text/attributes match
```

Generated draft for “only this element”:

```text
hide-exact:
  targets: current-host
  selector: stable-selector
  action: hide
```

Generated draft for “similar elements”:

```text
hide-similar:
  targets: current-host
  scope: inferred-scope
  candidates: inferred-candidates
  boundary: repeated-card
  similar-to: picked
  require:
    similarity >= 0.82
  action: hide
```

Generated draft for “similar elements with logic”:

```text
smart-hide:
  targets: current-host
  scope: inferred-scope
  candidates: inferred-candidates
  boundary: repeated-card
  similar-to: picked
  require:
    similarity >= 0.74
    AND (
      inferred-keyword-or-attribute-logic
    )
  exclude:
    inferred-risky-exclusions
  action: hide
```

---

## Stable Feature Extraction Policy

The smart rule generator should prefer stable signals in this order:

```text
1. semantic roles and tags
2. data-* attributes with meaningful component names
3. aria-label / accessibility text
4. visible text and labels
5. href patterns
6. repeated sibling/card structure
7. child tag histogram
8. visual box information
9. class names only when stable
10. exact child position only as fallback
```

The generator should avoid primary reliance on:

```text
- hash-like class names
- generated CSS module names
- exact nth-child paths
- very long direct-child chains
- dynamic inline styles
- temporary framework wrapper divs
```

Example bad generated selector:

```text
www.linkedin.com##div.x9f23._4ff70394 > section.e8cd4186 > div._4764b483
```

Better smart rule:

```text
smart-hide:
  targets: www.linkedin.com
  scope: main, aside
  candidates: section, div[role="region"]
  boundary: repeated-card
  require:
    data-* ~= /RecommendedEntitySection/
    OR text ~= /hire with ai/i
    OR href ~= /job-posting-redirect/
  action: hide
```

---

## False Positive Prevention

The rule system should avoid hiding elements based on only one weak signal.

Recommended safety principle:

```text
For generalized rules, require at least two of these:
- matching candidate container
- matching similarity threshold
- matching keyword/text condition
- matching stable attribute condition
- matching href/path condition
- matching repeated structure
```

High-risk rule:

```text
smart-hide:
  targets: www.example.com
  scope: body
  require:
    text ~= /ad/i
  action: hide
```

Safer rule:

```text
smart-hide:
  targets: www.example.com
  scope: main, aside
  candidates: article, section, div[role="listitem"]
  boundary: repeated-card
  require:
    similarity >= 0.74
    AND (
      text ~= /\bsponsored\b|\bpromoted\b/i
      OR aria-label ~= /\bsponsored\b/i
    )
  action: hide
```

Rules should warn when:

```text
- scope is body
- candidate selector is only div
- action is remove
- no exclude logic exists
- keyword is very broad
- similarity threshold is low
- rule matches too much of the page
- hostname target is too broad
```

---

## Editing Model

Smart rules should be editable at three levels.

### Simple editor

For normal users:

```text
Site: www.reddit.com
Block: similar posts
When text contains: Sponsored, Promoted
Except when text contains: Moderator, Official announcement
Action: Hide
```

### Structured editor

For intermediate users:

```text
targets: www.reddit.com
scope: main
candidates: article, shreddit-post
similarity: >= 0.72
include: text /promoted|sponsored/i
exclude: text /moderator/i
```

### Raw smart syntax editor

For advanced users:

```text
smart-hide:
  targets: www.reddit.com
  scope: main
  candidates: article, shreddit-post
  boundary: repeated-card
  similar-to: picked
  require:
    similarity >= 0.72
    AND text ~= /\bpromoted\b|\bsponsored\b/i
  exclude:
    text ~= /\bmoderator\b/i
  action: hide
```

The same underlying rule should power all three editing modes.

---

## Naming Recommendations

Use clear names for rule types.

Recommended names:

```text
hide-exact
hide-similar
hide-content
smart-hide
smart-allow
```

Avoid vague names such as:

```text
semantic-blocker
AI filter
advanced hide
magic rule
```

The feature should be called something like:

```text
Smart Cosmetic Rules
```

or:

```text
Smart Element Rules
```

`Smart Cosmetic Rules` is preferable because it aligns with existing cosmetic filtering terminology.

---

## Versioning and Migration

Every smart rule should include a schema version.

```text
schema-version: 1.0.0
```

or in internal form:

```json
"schemaVersion": "1.0.0"
```

Migration principles:

```text
1. Never silently drop rule meaning.
2. Preserve original smart syntax if migration changes compiled output.
3. Store generated compiled filters separately from the authoritative rule.
4. Allow old rules to keep running through a compatibility evaluator.
5. Mark deprecated fields but do not immediately break them.
```

Recommended rule metadata:

```text
metadata:
  created-by: element-picker
  created-at: 2026-06-20
  created-from-host: www.linkedin.com
  created-from-path: /in/example/
  engine-version: 1.0.0
```

---

## Import and Export

Smart rules should be importable/exportable as markdown-like text or JSON.

Recommended export formats:

```text
1. Smart syntax export
2. JSON export
3. Best-effort classic filter export
```

Smart syntax export is best for humans:

```text
smart-hide:
  targets: www.reddit.com
  scope: main
  candidates: article, shreddit-post
  require:
    text ~= /promoted|sponsored/i
  action: hide
```

JSON export is best for backup and migration.

Classic filter export is best for compatibility, but it may lose smart semantics.

When exporting to classic syntax, the system should say whether the export is:

```text
lossless
partial
approximate
not possible
```

Example:

```text
Export status: approximate
Reason: classic cosmetic syntax cannot represent similarity >= 0.74
```

---

## Recommended Rule Authoring Defaults

When generating a smart rule from the picker, use these defaults:

```text
targets: exact current hostname
paths: current path family
scope: nearest main/aside/feed container
candidates: inferred repeated card candidates
boundary: repeated-card if repeated siblings exist, otherwise nearest-card
similarity: >= 0.74 when keyword/attribute logic exists
similarity: >= 0.82 when no keyword/attribute logic exists
action: hide
preview: required
```

Default feature weights:

```text
weights:
  text: 2.0
  href: 2.0
  structure: 2.0
  aria: 1.5
  data-attrs: 1.5
  role-tag: 1.0
  visual-box: 1.0
  classes: 0.25
  nth-child: 0.05
```

Default safety:

```text
safety:
  preview: required
  max-matches: 100
  warn-if-scope-is-body: true
  warn-if-no-include-logic: true
  warn-if-action-remove: true
```

---

## Recommended Final Syntax Set for Version 1

For version 1, keep the syntax small.

### Required rule types

```text
hide-exact
hide-similar
smart-hide
smart-allow
```

### Required fields

```text
targets
scope
candidates
boundary
similar-to
require
exclude
action
safety
```

### Required operators

```text
==
!=
contains
~=
exists
not-exists
>=
<=
AND
OR
NOT
```

### Required fields for matching

```text
text
semantic-text
href
aria-label
role
tag
attr(name)
data-*
aria-*
selector
similarity
text-length
link-density
child-count
```

### Required actions

```text
hide
remove
mark
style(...)
unhide
```

Do not add too many special operators in version 1. A small stable grammar is better than a large unstable one.

---

## Features to Defer

The following features are useful, but should not be part of the first stable rule syntax unless the foundation is already solid.

```text
- local ML classifiers
- cross-site learned element classes
- natural-language rule authoring
- automatic cloud rule sharing
- large public smart-rule lists
- complex arithmetic scoring expressions exposed to users
- full visual computer-vision matching
- automatic rule repair without user preview
```

These can be future extensions, but the first version should focus on deterministic, explainable, local, inspectable rules.

---

## Minimal Viable Smart Rule System

The smallest useful version should support:

```text
1. Pick element.
2. Choose exact/similar/similar-with-logic.
3. Infer boundary.
4. Infer scope.
5. Infer candidates.
6. Add keyword/attribute conditions.
7. Preview matches.
8. Save smart rule.
9. Run rule locally.
10. Allow editing and deletion.
```

The minimum syntax needed:

```text
smart-hide:
  targets: <host>
  scope: <selector-list>
  candidates: <selector-list>
  boundary: <boundary-mode>
  similar-to: picked
  require:
    similarity >= <number>
    AND <condition>
  exclude:
    <condition>
  action: hide
```

That is enough to solve the main problem without overbuilding the system.

---

## Recommended Long-Term Direction

The long-term syntax should remain declarative.

A rule should describe desired matching behavior, not implementation details.

Good long-term direction:

```text
smart-hide:
  targets: site
  scope: region
  candidates: block type
  boundary: card policy
  require: logic
  exclude: logic
  action: hide
```

Bad long-term direction:

```text
A growing pile of generated selectors, patched edge cases, and site-specific JavaScript snippets.
```

The system should evolve toward:

```text
- stable declarative rules
- explicit logic
- local deterministic matching
- previewable behavior
- explainable decisions
- compatibility with existing filters
- future room for optional advanced matchers
```

The key foundation is not the exact final syntax spelling. The key foundation is the separation between:

```text
user intent
rule semantics
stored schema
compiled execution
```

Once those are separated, the syntax can evolve without breaking old rules.

---

## Final Recommendation

uBR should introduce **Smart Cosmetic Rules** as a higher-level rule language above existing cosmetic filters.

The recommended first stable syntax should be:

```text
smart-hide:
  targets: <site>
  paths: <optional-paths>
  scope: <where-to-search>
  candidates: <possible-block-elements>
  boundary: <how-to-find-container>
  similar-to: picked
  require:
    similarity >= <threshold>
    AND (<include-logic>)
  exclude:
    <exclude-logic>
  action: hide
  safety:
    preview: required
```

This syntax supports all core use cases:

```text
- block only one selected element
- block all similar elements
- block similar elements only when keyword logic matches
- block based on text, attributes, links, roles, and data fields
- add exceptions
- preview and explain matches
- compile simple cases to classic filters
- keep complex cases as smart local rules
```

The most important rule-design principle is:

```text
Generalized blocking should require both a block boundary and a reason.
```

In practice:

```text
similar element type
AND
keyword / attribute / href / semantic condition
```

This is the foundation that makes the system flexible enough for Reddit, LinkedIn, YouTube, job boards, search pages, recommendation modules, infinite-scroll feeds, and future complex blocking needs without turning the rule language into an unmaintainable pile of raw selectors.
