# uBR Smart Cosmetic Rule Syntax and Logic Blueprint v2

## Purpose

This document defines a production-oriented rule-language blueprint for a future **Smart Cosmetic Rule** system in uBlock Resurrected (uBR). It focuses on syntax, rule logic, matching semantics, safety behavior, and runtime expectations. It does not depend on the current source-code structure.

The goal is to support several levels of user intent with one stable foundation:

```text
1. Hide only this selected element.
2. Hide all elements of this kind.
3. Hide similar elements only when keywords or attributes match.
4. Hide elements based on text, links, roles, attributes, descendants, ancestors, or structural patterns.
5. Add exceptions and allow rules.
6. Keep rules previewable, explainable, local, and efficient.
```

The central rule-design principle is:

```text
Generalized blocking must have both a boundary and a reason.
```

In practice, this means a generalized rule should usually combine:

```text
candidate container + boundary policy + similarity or stable structure + text/attribute/link logic
```

Raw CSS selectors remain useful, but they should be treated as a compilation target, not as the primary authoring model for complex cases.

---

## Major v2 Corrections

This version makes the following structural changes.

```text
1. `paths` is now part of the formal rule body.
2. Similarity is no longer duplicated between top-level fields and `require` logic.
3. A canonical `match:` block is now the only source of truth for similarity matching.
4. `where:` and `except:` replace the older ambiguous `require:` / `exclude:` naming in canonical syntax.
5. Boundary detection is operationally defined.
6. Similarity score computation is operationally defined.
7. Dynamic DOM behavior and infinite scroll are included.
8. Performance caps are part of the rule model.
9. Rule conflicts, allow rules, and `unhide` are explicitly defined.
10. Path and target matching semantics are defined.
11. Syntax versioning is separate from storage schema versioning.
12. Export loss is explicitly marked instead of silently ignored.
```

Older examples using `similar-to:` and `similarity >= ...` inside `require:` should be treated as legacy aliases only. The canonical v2 form uses `match:`.

---

## Core Architecture Decision

The recommended foundation is a layered rule system:

| Layer | Purpose | User visibility | Example |
|---|---|---:|---|
| Classic cosmetic filter | Fast CSS-based hiding | visible to advanced users | `example.com##.ad-banner` |
| Procedural cosmetic filter | CSS plus text/attribute/ancestor conditions | visible to advanced users | `example.com##article:has-text(/sponsored/i)` |
| Smart syntax | Human-readable rule intent | visible in smart editor | `smart-hide: ... where: text ~= /sponsored/i` |
| Normalized schema | Stable storage, migration, import/export | mostly hidden | JSON/AST rule object |
| Runtime plan | Efficient execution | hidden | prefilter + predicate + action |

The key separation is:

```text
User intent -> rule semantics -> stored schema -> compiled/runtime execution
```

This keeps the syntax flexible while avoiding a future pile of brittle generated selectors.

---

## Canonical Smart Rule Syntax

The canonical user-facing syntax should be a strict YAML-compatible subset.

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - domain:reddit.com
  paths:
    - glob:/r/*/**
    - glob:/**
  scope:
    - main
    - '[role="main"]'
  candidates:
    - shreddit-post
    - article
    - 'div[data-testid="post-container"]'
  boundary:
    mode: repeated-card
    max-depth: 8
  match:
    mode: similar
    reference: picked
    threshold: 0.74
    weights: default-card
  where:
    any:
      - text ~= /\bpromoted\b|\bsponsored\b/i
      - aria-label ~= /\bpromoted\b|\bsponsored\b/i
  except:
    any:
      - text ~= /\bmoderator\b|\bofficial announcement\b/i
  action: hide
  safety:
    preview: required
    max-matches: 100
    max-page-percent: 25
```

A minimal exact rule can be much shorter:

```yaml
hide-exact:
  syntax-version: 1
  targets:
    - host:www.example.com
  selector: 'div[data-testid="newsletter-signup"]'
  action: hide
```

A content-only rule can omit similarity:

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:www.example.com
  scope:
    - main
  candidates:
    - article
    - section
  boundary:
    mode: semantic-block
  match:
    mode: none
  where:
    any:
      - text ~= /sponsored|promoted/i
      - href contains "/ads/"
  action: hide
```

---

## Rule Types

The first stable version should support these rule types.

| Rule type | Purpose | Generalizes? | Typical source |
|---|---|---:|---|
| `hide-exact` | Hide one exact element or one stable selector | no | picker or manual |
| `hide-similar` | Hide elements similar to the picked element | yes | picker |
| `smart-hide` | Hide candidates using match + logic | yes | picker or manual |
| `smart-allow` | Explicitly prevent hiding for matching candidates | yes | picker, manual, exception UI |

### `hide-exact`

Use for one-off blocking.

```yaml
hide-exact:
  syntax-version: 1
  targets:
    - host:www.example.com
  selector: '#newsletter-popup'
  action: hide
```

### `hide-similar`

Use when the user selects a card/module and wants to block all cards of that kind. Similarity-only rules are higher risk, so they require stricter thresholds and preview.

```yaml
hide-similar:
  syntax-version: 1
  targets:
    - host:www.example.com
  scope:
    - aside
  candidates:
    - section
    - 'div[role="region"]'
  boundary:
    mode: repeated-card
  match:
    mode: similar
    reference: picked
    threshold: 0.82
    weights: default-card
  action: hide
  safety:
    preview: required
```

### `smart-hide`

Use for most future-facing rules.

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:www.linkedin.com
  paths:
    - glob:/in/**
    - glob:/feed/**
    - glob:/jobs/**
  scope:
    - main
    - aside
    - '[role="feed"]'
  candidates:
    - article
    - section
    - li
    - 'div[role="listitem"]'
  boundary:
    mode: nearest-card
  match:
    mode: similar
    reference: picked
    threshold: 0.74
    weights: default-card
  where:
    any:
      - text ~= /hire with ai|promoted|sponsored/i
      - aria-label ~= /hire with ai/i
      - href ~= /\/talent\/job-posting-redirect\//
      - data-* ~= /RecommendedEntitySection/
  except:
    any:
      - text ~= /message|conversation|inbox|notification settings/i
  action: hide
```

### `smart-allow`

Use for exceptions. A matching allow rule prevents smart hide/remove/collapse actions from applying to the same element.

```yaml
smart-allow:
  syntax-version: 1
  targets:
    - domain:reddit.com
  scope:
    - main
  candidates:
    - article
    - shreddit-post
  boundary:
    mode: semantic-block
  match:
    mode: none
  where:
    any:
      - text ~= /official announcement|moderator/i
  action: unhide
```

`smart-allow` and `action: unhide` are equivalent in conflict resolution. `smart-allow` is the preferred rule type; `action: unhide` is the action-level representation.

---

## Field Semantics

A canonical smart rule has these fields.

| Field | Required? | Meaning |
|---|---:|---|
| `syntax-version` | yes | Version of the user-facing language. Separate from storage schema. |
| `targets` | yes | Host/domain/entity/regex targets where rule may run. |
| `paths` | no | Path constraints inside the target site. |
| `scope` | recommended | Search roots where candidates are collected. |
| `candidates` | required for smart rules | Selector list of possible block elements. |
| `selector` | required for `hide-exact` | Exact CSS selector for exact rules. |
| `boundary` | required for generalized rules | How to choose the actual block/container. |
| `match` | required for generalized rules | Exact/similar/none matching mode. Single source of truth for similarity. |
| `where` | recommended | Positive logic that must match. |
| `except` | no | Exception logic that rejects a match. |
| `action` | yes | `hide`, `remove`, `collapse`, `mark`, `style(...)`, or `unhide`. |
| `safety` | recommended | Preview and overblocking limits. |
| `priority` | no | Conflict-order override. |
| `metadata` | no | Creation source, timestamps, picker provenance. |

Deprecated aliases may be accepted on import, but should be normalized immediately:

| Legacy field | Canonical replacement |
|---|---|
| `similar-to: picked` | `match.reference: picked` |
| `similarity: >= 0.74` | `match.threshold: 0.74` |
| `require:` | `where:` |
| `exclude:` | `except:` |
| `schema-version:` in user syntax | `syntax-version:` plus internal `schemaVersion` |

---

## Target Matching Semantics

The `targets` field controls which hostnames a rule applies to.

Recommended canonical forms:

```yaml
targets:
  - host:www.reddit.com
  - domain:reddit.com
  - entity:google.*
  - regex:(^|\.)example\.(com|net)$
```

### `host:`

Matches exactly one hostname.

```yaml
- host:www.reddit.com
```

Matches:

```text
www.reddit.com
```

Does not match:

```text
reddit.com
old.reddit.com
new.www.reddit.com
```

### `domain:`

Matches the registrable domain and all subdomains.

```yaml
- domain:reddit.com
```

Matches:

```text
reddit.com
www.reddit.com
old.reddit.com
pay.reddit.com
```

Does not match:

```text
notreddit.com
reddit.com.example.org
```

### `entity:`

Matches a named entity family when uBR has an entity mapping.

```yaml
- entity:google.*
```

This should be treated as a power-user feature because entity boundaries can be broader than ordinary host/domain matching.

### `regex:`

Matches a hostname using a regular expression.

```yaml
- regex:(^|\.)example\.(com|net)$
```

Regex targets must show a warning in the UI because they can be broad and slower to evaluate.

### Bare target shorthand

For user convenience, shorthand may be accepted:

```yaml
targets:
  - www.reddit.com
  - reddit.com
```

Normalize as follows:

```text
A bare hostname with a subdomain, such as www.reddit.com, becomes host:www.reddit.com.
A bare registrable domain, such as reddit.com, becomes domain:reddit.com.
```

This rule must be shown in the editor so users understand whether subdomains are included.

---

## Path Syntax and Matching Semantics

The `paths` field constrains matching to the URL pathname. Query strings and fragments are ignored unless future syntax explicitly supports them.

Canonical path forms:

```yaml
paths:
  - exact:/feed/
  - glob:/feed/*
  - glob:/r/*/**
  - regex:^/(feed|jobs|in)/
```

### `exact:`

Exact pathname match.

```yaml
- exact:/feed/
```

Matches only:

```text
/feed/
```

### `glob:`

Glob pattern match against the pathname.

```yaml
- glob:/feed/*
- glob:/r/*/**
```

Glob rules:

```text
*  matches any characters except slash within one path segment.
** matches any characters including slashes across path segments.
?  matches one character except slash.
```

Examples:

| Pattern | Matches | Does not match |
|---|---|---|
| `glob:/feed/*` | `/feed/top` | `/feed/top/item` |
| `glob:/feed/**` | `/feed/top`, `/feed/top/item` | `/jobs/top` |
| `glob:/r/*/**` | `/r/uBlockOrigin/comments/abc` | `/user/name` |

### `regex:`

Regular expression match against the pathname.

```yaml
- regex:^/(feed|jobs|in)/
```

Regex patterns must not include leading and trailing slash delimiters in canonical syntax. This avoids ambiguity with real URL paths.

### Bare path shorthand

For readability, bare paths may be accepted and normalized:

```yaml
paths:
  - /feed/*
```

Equivalent canonical form:

```yaml
paths:
  - glob:/feed/*
```

For implementation and export, canonical prefixed forms are preferred.

---

## Scope Semantics

`scope` defines where candidate search begins. It does not define what is hidden.

```yaml
scope:
  - main
  - aside
  - '[role="feed"]'
```

Each scope entry is a CSS selector. The runtime collects scope roots, then searches for candidates within those roots.

Recommended behavior:

```text
1. If no scope is given, default to `document` only for exact rules.
2. For smart rules, picker-generated rules should infer a nearby stable scope.
3. `body` is allowed but should trigger a warning for generalized rules.
4. Scope selectors are ORed: candidates may appear under any listed scope root.
```

Good scopes:

```text
main
aside
[role="feed"]
[role="main"]
main [data-testid="primaryColumn"]
```

Risky scopes:

```text
body
html
body div
```

---

## Candidate Semantics

`candidates` defines the initial set of elements that may be evaluated.

```yaml
candidates:
  - article
  - section
  - li
  - 'div[role="listitem"]'
```

Candidate selectors are ORed. The runtime evaluates only elements matching at least one candidate selector and under an allowed scope.

The candidate is the reference element for all relative logic:

```text
text                 -> text inside this candidate
has descendant X     -> descendant of this candidate matches X
has ancestor X       -> ancestor of this candidate matches X
selector matches X   -> candidate itself matches X
boundary             -> may replace or adjust candidate to the actual target block
```

Candidate selectors should be broad enough to catch repeated blocks, but narrow enough to avoid scanning the entire DOM.

Recommended default candidates:

```yaml
# Feed pages
- article
- 'div[role="article"]'
- 'div[role="listitem"]'
- li

# Reddit-like pages
- shreddit-post
- article
- 'div[data-testid="post-container"]'

# Sidebar modules
- 'aside section'
- 'aside div[role="region"]'
- 'aside div[data-testid]'

# Job boards
- article
- li
- 'div[role="listitem"]'
- 'div[class*="job"]'
```

---

## Boundary Detection Semantics

`boundary` decides the actual element to hide when the selected or candidate element is nested inside a larger visual block.

```yaml
boundary:
  mode: repeated-card
  max-depth: 8
```

Boundary selection is performed relative to the picked element during rule creation, and relative to each candidate during runtime evaluation when needed.

Supported modes:

| Mode | Meaning |
|---|---|
| `exact` | Use the selected element or candidate itself. |
| `nearest-card` | Choose the nearest likely card ancestor. |
| `repeated-card` | Prefer ancestors with repeated sibling shape. |
| `semantic-block` | Prefer semantic containers such as `article`, `section`, `li`, roles. |
| `visual-block` | Prefer geometrically coherent visible blocks. |
| `ancestor-depth` | Use a fixed ancestor depth. |
| `selector` | Climb to nearest ancestor matching a selector. |

### Boundary candidate enumeration

For a picked node or runtime candidate:

```text
1. Start at the element.
2. Enumerate ancestors up to `max-depth`, default 8.
3. Stop early at scope root unless boundary mode explicitly allows crossing it.
4. Ignore ancestors that are `html`, `body`, or larger than the safety page-area limit unless explicitly allowed.
5. Score each ancestor using boundary-quality features.
6. Select the highest-scoring ancestor above the mode threshold.
7. If no ancestor passes, fall back to the original candidate.
```

### Boundary quality score

Each possible ancestor receives a score from `0.00` to `1.00`.

Recommended scoring features:

| Feature | Meaning | Suggested weight |
|---|---|---:|
| Semantic tag/role | `article`, `section`, `li`, `role=listitem`, `role=article`, `role=region` | 0.20 |
| Candidate selector match | Ancestor itself matches one candidate selector | 0.15 |
| Repeated sibling pattern | Nearby siblings have similar signatures | 0.25 |
| Self-contained text | Contains enough text but not too much page text | 0.10 |
| Geometry compactness | Visible rectangle is card-like, not full page | 0.15 |
| Link/button coherence | Has repeated child link/button pattern | 0.05 |
| Stable attributes | Meaningful `data-*`, `aria-*`, role, id, test id | 0.10 |

Boundary score formula:

```text
boundaryScore = weighted_sum(featureScores) / sum(applicableWeights)
```

Suggested thresholds:

```text
nearest-card:   >= 0.55
repeated-card:  >= 0.65 and repeatedSiblingScore >= 0.60
semantic-block: >= 0.50 and semanticTagOrRole > 0
visual-block:   >= 0.60 and geometryCompactness >= 0.50
```

### Repeated sibling detection

A node has a repeated sibling pattern when at least two siblings under the same parent have similar normalized signatures.

Normalized sibling signature:

```text
tag name
role
meaningful data-* attributes
major child tag histogram
approximate text length bucket
link count bucket
button count bucket
image count bucket
```

Sibling similarity should use Jaccard or weighted overlap over these signature features.

Recommended repeated sibling rule:

```text
repeatedSiblingScore >= 0.70 with at least 2 peer siblings
```

This means the element looks like part of a repeated list/grid/feed rather than a unique page wrapper.

### Visual block detection

`visual-block` uses rendered geometry, not screenshots.

For each ancestor, compute:

```text
rect = getBoundingClientRect()
area = rect.width * rect.height
viewportRatio = area / viewportArea
aspectRatio = rect.width / max(rect.height, 1)
visible = rect.width > 0 and rect.height > 0 and computed style is not hidden
```

A good visual block should generally be:

```text
visible
not tiny
not the whole page
mostly within the scope/root area
large enough to contain the picked element visually
similar in size to nearby repeated blocks when they exist
```

Default geometry guardrails:

```text
min width: 40 px
min height: 20 px
max viewport area for ordinary card: 40%
max viewport area for sidebar module: 60%
```

These are defaults, not hard laws. The safety model can override or warn.

---

## Match Block: Single Source of Truth for Similarity

Similarity and match-generalization are defined only in the `match:` block.

Canonical form:

```yaml
match:
  mode: similar
  reference: picked
  threshold: 0.74
  weights: default-card
```

The `where:` expression must not contain `similarity >= ...` in canonical v2 syntax. This removes precedence ambiguity.

### Match modes

| Mode | Meaning |
|---|---|
| `none` | No similarity comparison. Use only candidate + logic. |
| `exact` | Candidate must match exact selector/fingerprint. |
| `similar` | Candidate is compared against a reference feature vector. |
| `structural` | Candidate must match structural pattern more strongly than text/attribute pattern. |

### References

| Reference | Meaning |
|---|---|
| `picked` | Feature vector captured from the original picked boundary. |
| `selector:<css>` | Feature vector from first element matching selector at creation/runtime. |
| `fingerprint:<id>` | Stored reference fingerprint. |
| `none` | No reference; only allowed with `mode: none`. |

Rules:

```text
1. `mode: similar` requires a reference.
2. `mode: structural` requires a reference.
3. `mode: none` must not have a threshold.
4. `mode: exact` may use a selector or stored exact fingerprint.
5. If a legacy rule has similarity in both a block and logic, import must fail or normalize with an explicit warning. No silent precedence.
```

### Threshold defaults

```text
Similarity-only hide-similar:                         0.82
Similarity + strong keyword/attribute/href logic:     0.74
Broad content rules with strong scope/candidates:     none or 0.65
Borderline preview bucket:                            0.65 to 0.73
Do not auto-hide below:                               0.65
```

---

## Similarity Score Computation

Similarity score is a weighted normalized score from `0.00` to `1.00`.

```text
similarity(candidate, reference) =
  sum(weight_i * availability_i * featureScore_i) /
  sum(weight_i * availability_i)
```

Where:

```text
weight_i       = configured or default feature weight
availability_i = 1 if the feature is available for both elements, otherwise 0
featureScore_i = score from 0.00 to 1.00 for that feature
```

If too few features are available, the score is invalid and the rule should not auto-hide.

Default minimum feature availability:

```text
At least 3 feature families must be available.
At least one of structure, semantic role/tag, data attributes, text, or href must be available.
```

### Default feature families

| Feature family | Score method | Default weight |
|---|---|---:|
| `roleTag` | exact/compatible tag and role match | 1.0 |
| `textTokens` | Jaccard similarity over normalized visible text tokens | 2.0 |
| `semanticText` | Jaccard over visible text + aria + alt + title | 1.5 |
| `href` | URL path/domain/token similarity over descendant links | 2.0 |
| `dataAttrs` | weighted overlap of meaningful `data-*` names and values | 1.5 |
| `aria` | overlap/regex-compatible match of `aria-*` values | 1.5 |
| `structure` | child tag histogram + shallow DOM path features | 2.0 |
| `visualBox` | size/aspect/position-bucket similarity | 1.0 |
| `classes` | stable-class overlap only; generated classes downweighted | 0.25 |
| `nthChild` | coarse position bucket only | 0.05 |

### Feature score definitions

#### `roleTag`

```text
1.00 exact same tag and role
0.75 compatible semantic role, e.g. article vs role=article
0.50 same tag only
0.00 unrelated
```

#### `textTokens`

```text
tokens = normalized visible text tokens from `text`
score = Jaccard(tokens(candidate), tokens(reference))
```

Jaccard:

```text
|intersection| / |union|
```

Short text should be dampened:

```text
If both token sets have fewer than 4 tokens, multiply score by 0.75.
```

#### `semanticText`

Same as `textTokens`, but using `semantic-text`.

#### `href`

Collect descendant link hrefs and normalize to:

```text
host
path tokens
query key names only, not full query values by default
```

Score:

```text
0.50 path-token overlap
0.30 host/domain overlap
0.20 query-key overlap
```

#### `dataAttrs`

Meaningful `data-*` attributes are attributes whose names or values are not hash-like and repeat across at least two page elements or contain readable component words.

Score:

```text
0.50 attribute-name overlap
0.50 normalized value-token overlap
```

#### `aria`

Compare `aria-label`, `aria-labelledby` resolved text where safe, `aria-description`, and related accessible labels.

Score by token overlap, with exact phrase bonus capped at 1.00.

#### `structure`

Use a cheap structural fingerprint, not tree edit distance by default.

Fingerprint:

```text
tag name
role
child tag histogram at depth 1
child tag histogram at depth 2
counts of links/buttons/images/forms
text length bucket
link density bucket
```

Score:

```text
weighted Jaccard / histogram similarity across fingerprint fields
```

Tree edit distance may be used offline for evaluation or debugging, but not as the default runtime comparator.

#### `visualBox`

Compare rendered geometry:

```text
width bucket
height bucket
area bucket
aspect-ratio bucket
relative horizontal region: left / center / right / full
relative vertical order bucket within scope
```

Score by bucket agreement and numeric closeness.

#### `classes`

Class names are weak evidence.

Ignore or downweight classes that look generated:

```text
high digit ratio
long hash-like token
one-off frequency on page
very high entropy
CSS module suffix/prefix pattern
framework-generated short random tokens
```

Stable classes can count, but should rarely decide a match alone.

---

## Logic Language: `where:` and `except:`

`where:` defines positive conditions. `except:` defines rejection conditions.

Evaluation rule:

```text
A candidate passes logic if:
  where is missing or where evaluates true
  AND except is missing or except evaluates false
```

Recommended structured form:

```yaml
where:
  all:
    - text ~= /sponsored/i
    - any:
        - href contains "/ads/"
        - aria-label contains "Promoted"
except:
  any:
    - text ~= /moderator/i
    - selector matches nav
```

Expression shorthand may be supported for advanced users:

```yaml
where:
  expression: |
    text ~= /sponsored|promoted/i
    AND (href contains "/ads/" OR aria-label contains "Promoted")
except:
  expression: |
    text ~= /moderator|official announcement/i
```

The structured form is preferred for generated rules because it is easier to edit safely in a UI.

---

## Match Operators

The operator set should stay small and predictable.

### Equality and inequality

```text
role == "article"
tag == "section"
attr(data-testid) == "post-container"
role != "navigation"
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
data-* ~= /RecommendedEntitySection/
```

### Starts/ends

```text
href starts-with "https://www.linkedin.com/talent/"
href ends-with ".pdf"
```

### Exists / not exists

```text
attr(data-testid) exists
aria-label exists
attr(data-safe) not-exists
```

### Selector match

```text
selector matches article
selector matches 'div[role="listitem"]'
```

`selector matches X` applies to the candidate or resolved boundary element itself.

### Descendant match

```text
has descendant 'a[href*="/ads/"]'
has descendant '[aria-label*="Sponsored"]'
```

`has descendant X` means:

```text
candidate.querySelector(X) exists
```

It does not include the candidate itself. To test the candidate itself, use `selector matches`.

### Ancestor match

```text
has ancestor main
has ancestor '[role="feed"]'
```

`has ancestor X` means:

```text
candidate.closest(X) exists among ancestors above the candidate
```

It does not include the candidate itself. It may include the scope root.

### Count and density

```text
text-length >= 20
link-count <= 5
link-density < 0.50
child-count >= 3
```

Count/density metrics apply to the resolved boundary element unless the rule explicitly says otherwise.

---

## Text Field Semantics

All text fields use normalized text, not raw HTML.

Normalization:

```text
1. Ignore elements hidden by display:none, visibility:hidden, hidden attribute, or aria-hidden=true by default.
2. Collapse whitespace.
3. Decode HTML entities.
4. Preserve word order.
5. Case-insensitive operators lowercase during comparison unless regex flags or settings say otherwise.
6. Do not include script/style/template content.
```

Text fields:

| Field | Meaning |
|---|---|
| `text` | Alias for `all-text`: visible text of candidate/boundary plus visible descendant text. |
| `all-text` | Same as `text`; explicit name for clarity. |
| `own-text` | Visible direct text-node children of the candidate/boundary only; excludes descendants. |
| `semantic-text` | `all-text` plus relevant accessibility text, image alt, title, and selected aria values. |
| `aria-label` | The candidate/boundary `aria-label` value only unless using `aria-*`. |
| `alt` | Descendant image alt text. |

Examples:

```yaml
where:
  any:
    - text ~= /sponsored/i
    - own-text contains "Promoted"
    - semantic-text ~= /hire with ai/i
```

Use `own-text` when a label must be directly on the card. Use `text` or `semantic-text` when labels may appear inside nested children.

---

## Attribute Matching Semantics

Direct attribute matching:

```text
attr(aria-label) ~= /sponsored/i
attr(data-testid) == "post-container"
attr(data-sdui-component) ~= /RecommendedEntitySection/
```

Short aliases:

```text
href ~= /redirect/
aria-label ~= /sponsored/i
data-testid == "post-container"
role == "listitem"
```

Family matching:

```text
data-* ~= /RecommendedEntitySection/
aria-* ~= /promoted|sponsored/i
```

Family matching means:

```text
At least one attribute in the family on the candidate/boundary or its relevant descendants matches.
```

For predictable behavior, the rule editor should show which actual attributes matched during preview.

---

## Keyword Logic

Keyword logic should be first-class, not just raw regex.

Canonical structured form:

```yaml
keywords:
  include-any:
    - Sponsored
    - Promoted
  exclude-any:
    - Moderator
    - Official announcement
  fields:
    - text
    - aria-label
    - alt
  case-sensitive: false
  word-boundary: true
```

This can normalize internally to `where:` and `except:` conditions.

Keyword modes:

| Mode | Meaning |
|---|---|
| `include-any` | At least one keyword must match. |
| `include-all` | All listed keywords must match. |
| `exclude-any` | Candidate is rejected if any listed keyword matches. |
| `exclude-all` | Candidate is rejected only if all listed exclusion keywords match. |
| `phrase` | Exact phrase after normalization. |
| `word` | Word-boundary match. |
| `regex` | Advanced regex match. |

---

## Actions

Supported actions:

| Action | Meaning | Risk |
|---|---|---:|
| `hide` | Visually hide element while leaving DOM intact. | low |
| `collapse` | Hide and remove layout space, usually `display:none`. | low/medium |
| `remove` | Remove element from DOM. | high |
| `mark` | Visually mark matches for testing/debugging. | low |
| `style(...)` | Apply custom style. | medium |
| `unhide` | Exception/allow action. | special |

`hide` should be the default. `remove` should trigger a warning, because it can break page scripts.

### `unhide`

`unhide` is an allow action. It prevents smart hide/collapse/remove actions from applying to the same element.

Within the smart-rule engine:

```text
smart-allow / unhide beats smart-hide / hide / collapse / remove
```

Against classic imported cosmetic filters:

```text
1. If a compatible classic exception can be emitted, do that.
2. If the imported rule uses ordinary hiding, smart-unhide may apply a later restoring style where possible.
3. If the imported rule removes the element from the DOM, unhide cannot recover it.
4. The UI must explain this limitation.
```

Do not promise that `unhide` can reverse every external filter-list action.

---

## Conflict Resolution

Every rule is evaluated independently. A candidate may match many rules.

Default decision model:

```text
1. Collect all matching smart hide-like rules.
2. Collect all matching smart allow/unhide rules.
3. If any allow/unhide rule applies at equal or higher effective priority, do not hide.
4. Otherwise, if any hide-like rule applies, apply the strongest selected action.
5. Multiple hide rules do not need to agree; one matching hide rule is enough unless an allow rule overrides.
```

### Rule categories by action

Hide-like actions:

```text
hide
collapse
remove
style(...) if it hides or visually suppresses
```

Allow-like actions:

```text
unhide
smart-allow
```

Debug actions:

```text
mark
style(...) if preview/debug only
```

### Priority order

Default effective priority:

```text
1. User smart-allow / unhide rules
2. User exact hide rules
3. User smart hide rules
4. User imported classic filters
5. Subscribed filter-list rules
6. Generic cosmetic rules
```

Tie breakers:

```text
allow beats hide
exact beats general
higher numeric priority beats lower numeric priority
newer user-created rule beats older generated rule only when same type and priority
```

### Multiple hide actions on the same element

If several hide-like rules match the same element:

```text
remove beats collapse
collapse beats hide
hide beats mark
custom style is applied only if not contradicted by remove/collapse
```

`remove` should still be blocked by a matching allow/unhide rule.

### Contradictory rule logic

Contradictory `where:` / `except:` logic is local to each rule. Rules do not merge their internal logic.

Example:

```text
Rule A hides text=/sponsored/ except /moderator/.
Rule B hides text=/moderator/.
```

A moderator sponsored post may be hidden by Rule B even though Rule A excludes it, unless a separate allow rule overrides. The UI should show which rule caused the final action.

---

## Safety Model

Safety is part of the rule semantics.

Recommended safety block:

```yaml
safety:
  preview: required
  max-matches: 100
  max-page-percent: 25
  max-viewport-area-percent: 40
  min-features: 3
  warn-if-scope-is-body: true
  warn-if-no-where-logic: true
  warn-if-action-remove: true
```

### `preview`

Allowed values:

```text
required
recommended
optional
skip
```

Rules:

```text
1. Picker-generated smart rules default to `preview: required`.
2. Similarity rules default to `preview: required`.
3. Rules with action `remove` default to `preview: required`.
4. Manually written rules may use `preview: optional` or `skip`, but the UI should warn for risky rules.
5. Enterprise/locked policy may force preview for all generated rules.
```

### Preview confirmation

A generated rule is not active until confirmed.

Recommended states:

```text
draft -> previewed -> confirmed -> active
```

During preview:

```text
1. Matched elements are marked, not permanently hidden.
2. The picked element is shown separately from generalized matches.
3. Borderline matches are highlighted differently.
4. The user can add exclusions, narrow scope, raise threshold, or switch to exact-only.
5. Save is enabled only after preview has run for generated smart rules.
```

### `max-matches`

Maximum absolute number of elements a rule may affect on one page after `where:` and `except:` evaluation.

If exceeded:

```text
rule is not auto-applied
preview shows warning
user can explicitly raise the cap
```

### `max-page-percent`

Maximum percentage of candidate elements under the rule's scopes that may be affected.

Formula:

```text
max-page-percent = matchedCandidates / totalCandidatesWithinScope * 100
```

Example:

```text
100 candidates in scope
30 matched candidates
max-page-percent = 30
```

If the rule says `max-page-percent: 25`, this page would trigger a warning or block auto-application depending on policy.

### `max-viewport-area-percent`

Maximum percentage of the visible viewport area that matched elements may occupy during first evaluation.

This prevents a bad rule from hiding most of the page.

---

## Preview Buckets and Explanation

Preview should group matches into confidence buckets:

```text
Exact selected element
High-confidence matches
Medium-confidence matches
Borderline matches
Excluded matches
Blocked by safety
Allowed/unhidden
```

Suggested default buckets:

```text
High-confidence:    match score >= threshold + 0.08 and where matched
Medium-confidence:  match score >= threshold and where matched
Borderline:         match score >= 0.65 but below threshold, where matched
Excluded:           where matched but except also matched
Blocked by safety:  matched but exceeded safety cap
```

Each match should have an explanation:

```text
Matched because:
- boundary: repeated-card selected ancestor <article>
- match score: 0.81, threshold 0.74
- strongest features: structure 0.90, href 0.85, aria 0.80
- where matched: text ~= /sponsored/i
- except did not match
- action: hide
```

This is essential for trust and debugging.

---

## Runtime Pipeline

Runtime execution should be deterministic and bounded.

```text
1. Check target hostname.
2. Check path constraints.
3. Collect scope roots.
4. Query candidates under scope roots.
5. Resolve boundary for each candidate if needed.
6. Apply candidate prefilter.
7. Compute or retrieve feature vectors.
8. Apply match block.
9. Apply where/except logic.
10. Apply conflict resolution.
11. Apply action.
12. Observe dynamic updates if enabled or needed.
```

Pseudo-flow:

```text
for each active rule matching current host/path:
  roots = collectScopeRoots(rule.scope)
  candidates = queryCandidates(roots, rule.candidates)
  for candidate in bounded(candidates):
    target = resolveBoundary(candidate, rule.boundary)
    if not passesMatch(target, rule.match): continue
    if not passesWhere(target, rule.where): continue
    if passesExcept(target, rule.except): continue
    recordAction(target, rule)
resolveConflictsAndApplyActions()
```

---

## Dynamic DOM and Infinite Scroll

Modern pages add content after page load. Smart rules must handle this explicitly.

Recommended strategy:

```text
1. Initial evaluation after DOM is ready.
2. MutationObserver watches scope roots, not the whole document when possible.
3. On added nodes, evaluate only added subtrees and nearby candidate ancestors.
4. Debounce mutation batches.
5. Cache feature vectors in WeakMap-like storage.
6. Invalidate cached vectors only for affected nodes and ancestors.
7. Attribute watching is opt-in or inferred only when rules depend on mutable attributes.
```

Default observer behavior:

```yaml
runtime:
  observe-subtree: true
  observe-attributes: auto
  debounce-ms: 100
  max-added-nodes-per-cycle: 300
  max-evaluations-per-cycle: 150
```

### Attribute observation

Only observe attributes needed by active rules.

Example:

```text
Rule uses aria-label, href, data-sdui-component.
Observer watches only aria-label, href, data-sdui-component, and class if class matching is enabled.
```

Avoid watching every attribute by default.

### Re-evaluation triggers

Re-evaluate when:

```text
new candidate node is added
new descendant under a candidate is added
watched attribute changes
scope root appears after SPA navigation
URL path changes without full page load
```

Do not re-evaluate the whole page after every mutation.

---

## Performance Requirements

Similarity and regex matching can become expensive. Performance caps must be part of the design.

Recommended defaults:

```yaml
performance:
  max-candidates: 150
  max-evaluations-per-cycle: 150
  max-added-nodes-per-cycle: 300
  max-regex-ms-per-rule-cycle: 10
  debounce-ms: 100
  cache-feature-vectors: true
  prefer-css-prefilter: true
```

Runtime should use stages:

```text
Stage 1: target/path check
Stage 2: CSS scope + candidate prefilter
Stage 3: cheap attribute/text prefilter if available
Stage 4: boundary resolution
Stage 5: feature-vector similarity
Stage 6: regex and complex logic
Stage 7: action
```

Regex conditions should run after cheap filters when possible.

### Caching

Cache per page session:

```text
candidate -> resolved boundary
boundary -> feature vector
boundary -> normalized text
boundary -> descendant link summary
boundary -> last matched rule ids
```

Invalidate when relevant subtree or watched attributes change.

### Hard safety stops

A rule should pause and warn if:

```text
candidate count exceeds max-candidates repeatedly
runtime budget is exceeded repeatedly
matched percentage exceeds max-page-percent
matched visible area exceeds max-viewport-area-percent
rule causes layout churn loop
```

---

## Internal Normalized Schema

The stored schema is not the same as user syntax. It should be JSON, versioned, and migration-safe.

```json
{
  "schemaVersion": "1.0.0",
  "syntaxVersion": 1,
  "ruleType": "smart-hide",
  "enabled": true,
  "targets": [
    { "type": "host", "value": "www.linkedin.com" }
  ],
  "paths": [
    { "type": "glob", "value": "/in/**" },
    { "type": "glob", "value": "/feed/**" },
    { "type": "glob", "value": "/jobs/**" }
  ],
  "scope": {
    "selectors": ["main", "aside", "[role='feed']"]
  },
  "candidates": {
    "selectors": ["article", "section", "li", "div[role='listitem']"]
  },
  "boundary": {
    "mode": "nearest-card",
    "maxDepth": 8,
    "stopAtScope": true
  },
  "match": {
    "mode": "similar",
    "reference": {
      "type": "picked",
      "fingerprintId": "fp_123"
    },
    "threshold": 0.74,
    "weights": "default-card"
  },
  "where": {
    "any": [
      { "field": "text", "op": "regex", "value": "hire with ai|promoted|sponsored", "flags": "i" },
      { "field": "aria-label", "op": "regex", "value": "hire with ai", "flags": "i" },
      { "field": "href", "op": "regex", "value": "\\/talent\\/job-posting-redirect\\/" },
      { "field": "data-*", "op": "regex", "value": "RecommendedEntitySection" }
    ]
  },
  "except": {
    "any": [
      { "field": "text", "op": "regex", "value": "message|conversation|inbox", "flags": "i" }
    ]
  },
  "action": {
    "type": "hide"
  },
  "safety": {
    "preview": "required",
    "maxMatches": 100,
    "maxPagePercent": 25,
    "maxViewportAreaPercent": 40
  },
  "performance": {
    "maxCandidates": 150,
    "debounceMs": 100,
    "cacheFeatureVectors": true
  },
  "provenance": {
    "createdBy": "element-picker",
    "createdFromHost": "www.linkedin.com",
    "createdFromPath": "/in/example/",
    "createdAt": "2026-06-20T00:00:00Z"
  }
}
```

The schema must preserve:

```text
original smart syntax
normalized AST
compiled artifacts
reference fingerprints
preview confirmation state
migration history
export loss metadata
```

---

## Syntax Version vs Schema Version

Use two versions.

```text
syntax-version: user-facing language version
schemaVersion: internal storage schema version
engineVersion: runtime/compiler version that produced compiled artifacts
```

Example user syntax:

```yaml
smart-hide:
  syntax-version: 1
```

Example internal storage:

```json
{
  "syntaxVersion": 1,
  "schemaVersion": "1.0.0",
  "engineVersion": "1.0.0"
}
```

Migration rules:

```text
1. Never silently drop meaning.
2. If migration cannot preserve behavior, keep old evaluator compatibility.
3. If a compiled artifact changes behavior, mark it stale and re-preview if needed.
4. Keep original user syntax for audit/debugging.
5. Deprecated fields are normalized with warnings, not silently preferred.
```

---

## Compilation and Compatibility

Smart rules should compile to the simplest safe target.

Compilation target order:

```text
1. Plain CSS cosmetic filter
2. Procedural cosmetic filter
3. Hybrid: CSS/procedural prefilter + smart predicate
4. Full smart runtime rule
```

### Plain CSS compilation

Allowed when the rule has only target + selector and no smart-only semantics.

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:www.example.com
  candidates:
    - 'div[data-testid="ad-banner"]'
  match:
    mode: none
  action: hide
```

Compiled:

```text
www.example.com##div[data-testid="ad-banner"]
```

### Procedural compilation

Allowed when semantics are representable through supported procedural cosmetic filters.

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:www.example.com
  candidates:
    - article
  match:
    mode: none
  where:
    any:
      - text ~= /sponsored/i
  action: hide
```

Possible compiled form:

```text
www.example.com##article:has-text(/sponsored/i)
```

### Hybrid compilation

Required when a rule has smart-only semantics such as similarity scoring.

```yaml
match:
  mode: similar
  reference: picked
  threshold: 0.74
```

Compiled runtime plan:

```text
prefilter: main :is(article, section, li, div[role="listitem"])
predicate: smart similarity >= 0.74 AND where/except logic
action: hide
```

### Semantic equivalence requirements

Compilation must record whether exported behavior is equivalent.

```text
lossless:     compiled filter preserves all semantics
partial:      compiled filter preserves target/candidate/logic but loses some safety or explanation metadata
approximate:  compiled filter is useful but may match differently
not-possible: no compatible classic/procedural form exists
```

Do not silently export approximate rules as if they were exact.

---

## Export Format and Loss Marking

Smart export should preserve the full rule.

Classic filter export should include comments when semantics are lost.

Example:

```text
! uBR-smart-export: approximate
! source-rule-id: ubr:smart:9f21a
! lost-semantics: similarity, boundary, preview-required, max-page-percent
! original-action: hide
www.linkedin.com##article:has-text(/Hire with AI|Promoted|Sponsored/i)
```

For lossless export:

```text
! uBR-smart-export: lossless
www.example.com##div[data-testid="ad-banner"]
```

For impossible export:

```text
! uBR-smart-export: not-possible
! reason: similarity scoring and boundary detection cannot be represented in classic cosmetic syntax
```

The authoritative source should remain the smart rule unless the export is explicitly lossless.

---

## Procedural Filter Compatibility Notes

Smart rules may compile to procedural filters, but procedural filter behavior may differ from smart semantics.

Potential differences:

```text
text normalization
case sensitivity
hidden text handling
descendant scope
attribute family matching
boundary ancestor selection
regex engine differences
mutation re-evaluation behavior
```

Therefore every compiled procedural artifact should store:

```text
compiledFromRuleId
equivalenceStatus
lostSemantics
compilerVersion
```

When semantic equivalence is not guaranteed, the UI should show the compiled filter as an approximation, not as a replacement.

---

## Picker Workflow

The picker should generate smart rules through a staged process.

```text
1. User selects an element.
2. Picker identifies candidate boundary options.
3. Picker asks intent:
   - only this element
   - similar elements
   - similar elements with keyword/attribute logic
4. Picker extracts stable signals.
5. Picker proposes target, path, scope, candidates, boundary, and match block.
6. Picker proposes where/except logic if stable text/attributes/hrefs exist.
7. Picker runs preview.
8. User confirms, narrows, broadens, or switches to exact-only.
9. Confirmed rule becomes active.
```

The first UI choice should be simple:

```text
Block:
[ ] only this element
[ ] all similar elements
[ ] similar elements only when text/links/attributes match
```

Generated exact rule:

```yaml
hide-exact:
  syntax-version: 1
  targets:
    - host:current-host
  selector: stable-selector
  action: hide
```

Generated similar rule:

```yaml
hide-similar:
  syntax-version: 1
  targets:
    - host:current-host
  paths:
    - glob:current-path-family
  scope:
    - inferred-scope
  candidates:
    - inferred-candidate
  boundary:
    mode: repeated-card
  match:
    mode: similar
    reference: picked
    threshold: 0.82
  action: hide
  safety:
    preview: required
```

Generated smart rule with logic:

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:current-host
  paths:
    - glob:current-path-family
  scope:
    - inferred-scope
  candidates:
    - inferred-candidate
  boundary:
    mode: repeated-card
  match:
    mode: similar
    reference: picked
    threshold: 0.74
  where:
    any:
      - inferred-text-or-attribute-condition
  except:
    any:
      - inferred-risk-exclusion
  action: hide
  safety:
    preview: required
```

---

## Stable Feature Extraction Policy

The generator should prefer stable signals in this order:

```text
1. semantic tags and roles
2. meaningful data-* attributes
3. aria-label and accessibility text
4. visible text labels
5. href path patterns
6. repeated sibling/card structure
7. child tag histogram
8. image alt text
9. visual geometry
10. stable class names
11. exact child position only as fallback
```

Avoid primary reliance on:

```text
hash-like class names
generated CSS-module names
long exact child chains
nth-child paths
dynamic inline styles
temporary framework wrapper divs
```

Bad selector:

```text
www.linkedin.com##div.x9f23._4ff70394 > section.e8cd4186 > div._4764b483
```

Better smart rule:

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:www.linkedin.com
  scope:
    - main
    - aside
  candidates:
    - section
    - 'div[role="region"]'
  boundary:
    mode: repeated-card
  match:
    mode: none
  where:
    any:
      - data-* ~= /RecommendedEntitySection/
      - text ~= /hire with ai/i
      - href ~= /job-posting-redirect/
  action: hide
```

---

## Formal Grammar

The canonical syntax is a YAML-compatible document. This conceptual grammar defines the allowed rule shape.

```text
ruleDocument      := ruleType ':' newline indentedRuleBody
ruleType          := 'smart-hide' | 'smart-allow' | 'hide-exact' | 'hide-similar' | 'hide-content'

ruleBody          := syntaxVersionBlock
                     targetBlock
                     pathBlock?
                     selectorBlock?
                     scopeBlock?
                     candidateBlock?
                     boundaryBlock?
                     matchBlock?
                     whereBlock?
                     exceptBlock?
                     keywordBlock?
                     actionBlock
                     safetyBlock?
                     performanceBlock?
                     priorityBlock?
                     metadataBlock?

syntaxVersionBlock := 'syntax-version:' integer
targetBlock        := 'targets:' targetList
pathBlock          := 'paths:' pathList
selectorBlock      := 'selector:' cssSelector
scopeBlock         := 'scope:' selectorList
candidateBlock     := 'candidates:' selectorList
boundaryBlock      := 'boundary:' boundaryObject
matchBlock         := 'match:' matchObject
whereBlock         := 'where:' logicObjectOrExpression
exceptBlock        := 'except:' logicObjectOrExpression
keywordBlock       := 'keywords:' keywordObject
actionBlock        := 'action:' actionExpression
safetyBlock        := 'safety:' safetyObject
performanceBlock   := 'performance:' performanceObject
priorityBlock      := 'priority:' integerOrName
metadataBlock      := 'metadata:' metadataObject
```

Expression grammar for advanced shorthand:

```text
logicExpression    := orExpression
orExpression       := andExpression ('OR' andExpression)*
andExpression      := notExpression ('AND' notExpression)*
notExpression      := 'NOT' primaryExpression | primaryExpression
primaryExpression  := condition | '(' logicExpression ')'

condition          := field operator value
                    | metric comparison number
                    | 'selector matches' cssSelector
                    | 'has descendant' cssSelector
                    | 'has ancestor' cssSelector

field              := 'text'
                    | 'all-text'
                    | 'own-text'
                    | 'semantic-text'
                    | 'href'
                    | 'aria-label'
                    | 'alt'
                    | 'role'
                    | 'tag'
                    | 'attr(' name ')'
                    | 'data-*'
                    | 'aria-*'

operator           := '==' | '!=' | 'contains' | '~=' | 'starts-with' | 'ends-with' | 'exists' | 'not-exists'
comparison         := '>=' | '<=' | '>' | '<' | '=='
metric             := 'text-length' | 'link-count' | 'link-density' | 'child-count'
actionExpression   := 'hide' | 'remove' | 'collapse' | 'mark' | 'unhide' | 'style(' styleText ')'
```

Important grammar rule:

```text
The `similarity` metric is intentionally absent from `where:` expressions in v2.
Similarity belongs only in `match:`.
```

This eliminates threshold precedence ambiguity.

---

## Examples

### Example 1: Hide one exact element

```yaml
hide-exact:
  syntax-version: 1
  targets:
    - host:www.example.com
  selector: 'div[data-testid="newsletter-signup"]'
  action: hide
```

Possible compiled filter:

```text
www.example.com##div[data-testid="newsletter-signup"]
```

---

### Example 2: Hide all similar sidebar recommendation modules

```yaml
hide-similar:
  syntax-version: 1
  targets:
    - host:www.example.com
  scope:
    - aside
  candidates:
    - section
    - 'div[role="region"]'
  boundary:
    mode: repeated-card
    max-depth: 8
  match:
    mode: similar
    reference: picked
    threshold: 0.82
    weights: default-card
  action: hide
  safety:
    preview: required
    max-matches: 30
    max-page-percent: 30
```

This is similarity-only, so the threshold is stricter.

---

### Example 3: Hide promoted Reddit posts

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - domain:reddit.com
  paths:
    - glob:/**
  scope:
    - main
    - '[role="main"]'
  candidates:
    - shreddit-post
    - article
    - 'div[data-testid="post-container"]'
  boundary:
    mode: repeated-card
    max-depth: 8
  match:
    mode: similar
    reference: picked
    threshold: 0.74
    weights: default-card
  where:
    any:
      - text ~= /\bpromoted\b|\bsponsored\b/i
      - aria-label ~= /\bpromoted\b|\bsponsored\b/i
  except:
    any:
      - text ~= /\bmoderator\b|\bautomoderator\b|\bofficial announcement\b/i
  action: hide
  safety:
    preview: required
    max-matches: 100
    max-page-percent: 25
```

Possible procedural approximation:

```text
! uBR-smart-export: approximate
! lost-semantics: similarity, boundary, preview-required, max-page-percent
www.reddit.com##:is(shreddit-post, article, div[data-testid="post-container"]):has-text(/\bpromoted\b|\bsponsored\b/i)
```

---

### Example 4: Hide LinkedIn “Hire with AI” blocks

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:www.linkedin.com
  paths:
    - glob:/in/**
    - glob:/feed/**
    - glob:/jobs/**
  scope:
    - main
    - aside
    - '[role="feed"]'
  candidates:
    - article
    - section
    - li
    - 'div[role="listitem"]'
    - 'div[role="region"]'
  boundary:
    mode: nearest-card
    max-depth: 8
  match:
    mode: similar
    reference: picked
    threshold: 0.74
    weights: default-card
  where:
    any:
      - text ~= /hire with ai|promoted|sponsored/i
      - aria-label ~= /hire with ai/i
      - href ~= /\/talent\/job-posting-redirect\//
      - data-* ~= /RecommendedEntitySection/
  except:
    any:
      - text ~= /message|conversation|inbox|notification settings/i
  action: hide
  safety:
    preview: required
    max-matches: 100
    max-page-percent: 25
```

This avoids relying on generated class chains.

---

### Example 5: Hide job cards from specific companies

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:www.linkedin.com
  paths:
    - glob:/jobs/**
  scope:
    - main
  candidates:
    - li
    - article
    - 'div[role="listitem"]'
  boundary:
    mode: repeated-card
  match:
    mode: none
  where:
    any:
      - semantic-text ~= /Company A|Company B|Company C/i
  except:
    any:
      - text ~= /saved|applied/i
  action: hide
  safety:
    preview: required
    max-page-percent: 35
```

This rule does not need similarity because the path, candidates, and content logic are already constrained.

---

### Example 6: Hide YouTube shelves by title

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:www.youtube.com
  paths:
    - glob:/**
  scope:
    - ytd-browse
    - ytd-watch-flexy
    - main
  candidates:
    - ytd-rich-section-renderer
    - ytd-shelf-renderer
    - ytd-reel-shelf-renderer
  boundary:
    mode: semantic-block
  match:
    mode: none
  where:
    any:
      - text ~= /shorts|breaking news|recommended for you/i
  except:
    any:
      - text ~= /subscriptions/i
  action: hide
  safety:
    preview: required
```

---

### Example 7: Hide cards with tracking redirect links

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:example.com
  scope:
    - main
  candidates:
    - article
    - section
    - li
    - 'div[role="listitem"]'
  boundary:
    mode: nearest-card
  match:
    mode: none
  where:
    any:
      - has descendant 'a[href*="/redirect?"]'
      - href ~= /utm_source=ad|tracking_id=/i
  action: hide
  safety:
    preview: required
```

---

### Example 8: Mark before hiding

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - host:www.example.com
  scope:
    - main
  candidates:
    - article
  boundary:
    mode: semantic-block
  match:
    mode: none
  where:
    any:
      - text ~= /sponsored/i
  action: mark
```

The user can switch `action: mark` to `action: hide` after confirming the preview.

---

## Testing Strategy

A stable rule language needs tests at three levels.

### Parser and normalization tests

Test:

```text
YAML parsing
legacy alias normalization
invalid similarity-in-where rejection
path pattern normalization
target shorthand normalization
schema migration
```

### Rule semantic tests

Test:

```text
where/except logic
ancestor/descendant semantics
text vs own-text vs semantic-text
attribute family matching
allow vs hide conflicts
safety caps
export loss marking
```

### Runtime page tests

Use saved DOM fixtures and dynamic mutation fixtures for:

```text
Reddit-like feeds
LinkedIn-like sidebars and job cards
YouTube-like shelves
search-result pages
infinite-scroll pages
SPA path changes
attribute mutation after load
```

Metrics:

```text
precision
recall
false-positive count
candidate count
nodes visited
average evaluation time
max evaluation time
memory/cache size
number of rule explanations generated
```

---

## Recommended Version 1 Scope

Version 1 should stay small.

Required:

```text
hide-exact
hide-similar
smart-hide
smart-allow
host/domain targets
exact/glob/regex paths
scope and candidates
boundary modes: exact, nearest-card, repeated-card, semantic-block, selector
match modes: none, similar
where/except structured logic
text, semantic-text, own-text, href, aria-label, attr(name), data-*, aria-*
has descendant / has ancestor
hide, collapse, remove, mark, unhide
preview-required safety
max-matches and max-page-percent
MutationObserver-based dynamic updates
export loss marking
```

Defer:

```text
local ML classifiers
cross-site learned element classes
natural-language rule authoring
cloud rule sharing
full computer-vision matching
automatic rule repair without preview
complex exposed scoring expressions
large public smart-rule lists
```

---

## Final Recommendation

uBR should implement Smart Cosmetic Rules as a declarative layer above classic and procedural filters.

The canonical v2 rule shape should be:

```yaml
smart-hide:
  syntax-version: 1
  targets:
    - <target>
  paths:
    - <path-pattern>
  scope:
    - <scope-selector>
  candidates:
    - <candidate-selector>
  boundary:
    mode: <boundary-mode>
  match:
    mode: <none | similar>
    reference: <picked | fingerprint | selector>
    threshold: <number>
  where:
    <positive logic>
  except:
    <exception logic>
  action: <hide | collapse | remove | mark | unhide | style(...)>
  safety:
    preview: required
    max-matches: <number>
    max-page-percent: <number>
```

The strongest foundation is not a single clever selector. It is a stable rule model where:

```text
1. Targets and paths say where a rule may run.
2. Scope and candidates limit what the engine scans.
3. Boundary detection finds the real block to act on.
4. Match defines similarity using one unambiguous source of truth.
5. Where/except logic gives the reason for blocking.
6. Safety prevents overblocking.
7. Conflict resolution keeps allow/hide behavior predictable.
8. Runtime execution is incremental and bounded for dynamic pages.
9. Export never silently loses semantics.
```

This foundation supports exact blocking, similar-element blocking, keyword logic, attribute logic, structural matching, exceptions, previews, future upgrades, and compatibility with existing cosmetic-filter culture without making the system unmaintainable.
