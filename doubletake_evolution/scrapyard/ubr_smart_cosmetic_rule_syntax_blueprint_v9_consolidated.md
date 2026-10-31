# uBR Smart Cosmetic Rule Syntax and Logic Blueprint v9 — Consolidated Full Specification

## Purpose

This document defines a production-oriented rule-language blueprint for a future **Smart Cosmetic Rule** system in uBlock Resurrected (uBR). It focuses on syntax, rule logic, matching semantics, safety behavior, and runtime expectations. It does not depend on the current source-code structure.


> **Version status:** v9 is the single consolidated successor to v7 and v8. It includes the v7 base specification plus the v8 production-hardening additions in one whole document. Use this file as the current working specification; older v7/v8 files are superseded.

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

## Major Corrections and Stability Notes

This consolidated version makes the following structural changes.

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

### Minor v3 Clarifications

This version keeps the v2 semantics intact and adds two clarifications needed for implementation consistency.

```text
1. `match.mode: structural` is not a separate similarity algorithm. It is a named structural-heavy weight profile using the same scoring formula as `similar`.
2. `keywords:` is a convenience authoring layer. During normalization it expands into `where:` and `except:`. If explicit `where:` / `except:` are present, they are the canonical source of truth.
```


### v4 Specification Tightening

This version closes the remaining implementation gaps.

```text
1. `keywords:` can never be discarded silently; ignored or inactive keyword blocks require a warning or strict parse error.
2. Boundary syntax now exposes mode-specific parameters: `selector`, `depth`, `stop-at-scope`, and `allow-cross-scope`.
3. `hide-content` is removed from the formal v1 grammar; content-only behaviour is represented by `smart-hide` with `match.mode: none`.
4. Runtime terminology now separates raw candidates from resolved targets.
5. Performance limits define deterministic candidate ordering, deferral, and per-cycle caps.
6. Preview buckets are defined for logic-only rules where no similarity score exists.
7. `unhide` is explicitly non-restorative for elements already removed from the DOM.
8. Same-origin and accessible-frame behaviour is defined through a `frames:` field.
9. `style(...)` is restricted to a safe declaration subset with explicit quoting rules.
10. Export loss metadata now has both human-readable comments and a machine-readable JSON record.
11. `priority` is typed, ranged, and subordinate to allow-vs-hide conflict class ordering.
```

### v5 Specification Tightening

This version standardizes the remaining implementation-critical details.

```text
1. Default thresholds are now normative for every `match.mode` / rule-type combination.
2. `match.weights` accepts only v1 preset names; custom weight objects are deferred to a later syntax version.
3. Boundary scoring now has concrete feature formulas and stable tie-breaking.
4. Conflict resolution now has one deterministic order: allow layer, conflict class, priority, specificity, then action strength.
5. `unhide` is defined as preventive inside smart rules and only best-effort restorative against compatible external CSS hiding.
6. `style(...)`, `hide`, and `collapse` now specify quoting, sanitisation, hide-like classification, and `!important` behaviour.
7. Shadow DOM traversal, rule-list container format, default safety values, expensive selector compilation, and scope-root teardown handling are included.
8. Regex flavour and regex time-budget enforcement are defined.
9. `frames: none` is removed from v1 to avoid ambiguity. Use `top-only` to evaluate only the top document.
```


### v6 Final Normative Closure

This version closes the remaining edge cases that could still cause divergent implementations.

```text
1. Boundary text scoring now guards `scopeChars == 0` and never divides by zero.
2. Default threshold selection no longer depends on vague "strong logic" wording; strong logic has a formal operator/field definition.
3. Layout churn detection is defined with a concrete mutation/evaluation loop heuristic.
4. Repeated sibling and visual-box buckets have explicit numeric ranges.
5. `keywords.match-mode` is part of the canonical keyword object and grammar.
6. A scope root is a stopping sentinel, not a boundary candidate, unless explicitly allowed.
7. Classic cosmetic filters are distinguished from smart-normalized imports and external filter-list effects.
8. Exact fingerprints now define canonical selector construction and weak-selector warnings.
```


---
### v7 Implementation Closure

This version tightens the remaining runtime and storage details needed before implementation planning.

```text
1. Dependency extraction is now normative for descendant, ancestor, attribute, text, and selector conditions.
2. Frame evaluation uses explicit per-frame accounting by default, with optional aggregate accounting.
3. Shadow DOM traversal now defines observer behavior, dynamic shadow-root discovery, and mutation accounting.
4. SPA path changes trigger debounced rule re-evaluation with cache invalidation.
5. `style(...)` now has an explicit safe-property whitelist and clear `!important` handling.
6. Rule ids, import collision handling, migration strategy, and cache eviction are specified.
7. `createdAt` replaces list order as the semantic tie-breaker; list order is organizational only.
8. Content-only rules gain `min-logic-matches`; invalid thresholds with `match.mode: none` are parse errors.
9. Runtime error recovery, budget exhaustion, warning levels, preview parity, and page lifecycle are defined.
10. Accessibility effects of `hide`, `collapse`, and `remove` are defined.
```


### v8 Production-Hardening Closure

This version converts the remaining audit findings into normative parser, runtime, and conformance rules. The v8 rules below override any older ambiguous wording in v1-v7 sections.

```text
1. Smart rule scope, candidates, boundary, match, and action combinations now have strict validation rules.
2. Rule-list containers, ids, timestamps, preview state, import ids, and version compatibility are defined.
3. Target/path matching, nested scope roots, candidate ordering, and scope-root boundary behavior are deterministic.
4. Similarity formulas now include exact `structure`, `visualBox`, class-stability, feature-availability, and zero-denominator rules.
5. Keyword expansion, tokenization, operator case-sensitivity, regex restrictions, and logic counting are fully specified.
6. Shadow DOM, frames, SPA navigation, dependency invalidation, remove-loop suppression, and enable/disable lifecycle are specified.
7. Safety caps, preview confirmation, page-percent calculation, viewport-area recalculation, and enterprise preview overrides have stored state.
8. Built-in actions, non-hide styles, mark styling, `!important`, accessibility markers, and reference-counted cleanup are specified.
9. Classic filter import/export, smart-allow exception export, sidecar metadata, and external compatibility limits are separated.
10. Conformance fixtures, diagnostics, warnings, and unsupported-v1 features are listed to prevent divergent engines.
```


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
    min-features: 3
    min-logic-matches: 1
  performance:
    max-candidates: 150
    max-evaluations-per-cycle: 150
    max-added-nodes-per-cycle: 300
    max-regex-ms-per-rule-cycle: 10
    debounce-ms: 100
    dependency-depth: 3
    dependency-prefilter: true
  frames:
    mode: top-only
    accounting: per-frame
  shadow:
    mode: none
  runtime:
    observe-path-changes: true
    path-change-debounce-ms: 200
    re-evaluate-on-path-change: smart
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

### Rule collection format

Individual rules are stored inside a rule-list document. A rule list is required for import/export, enable/disable state, ordering, and migration.

Canonical YAML container:

```yaml
ubr-smart-rules:
  syntax-version: 1
  list-id: local-user-rules
  title: Local Smart Cosmetic Rules
  rules:
    - id: ubr:smart:550e8400-e29b-41d4-a716-446655440000
      enabled: true
      metadata:
        createdAt: 2026-06-20T00:00:00Z
        updatedAt: 2026-06-20T00:00:00Z
        source: picker
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
        action: hide
```

Rules:

```text
1. `rules` is an ordered list for display and organization only. List order must not affect runtime semantics.
2. Each stored rule must have a stable `id`, `enabled` flag, and `metadata.createdAt` timestamp.
3. Disabled rules are parsed, validated, and migrated, but are completely ignored for all runtime operations and conflict resolution.
4. A single-rule file may omit the container for editor convenience, but import must normalize it into a rule-list document.
5. Export bundles should preserve list metadata, rule ids, enabled states, timestamps, syntax version, and export-loss metadata.
6. The semantic final tie-breaker is `metadata.createdAt`, not rule-list position.
```

Rule id rules:

```text
1. Generated smart-rule ids use UUID form: `ubr:smart:<uuid-v4>`.
2. Imported smart rules keep their original id only if there is no collision in the destination list.
3. If an imported id collides, the importer must generate a new `ubr:smart:<uuid-v4>` id and preserve the original id in `metadata.importedOriginalId`.
4. Imported classic filters normalized into smart-compatible records use `ubr:classic:<sha256-prefix>` unless edited by the user, in which case they may receive a smart id.
5. Rule ids are stable across enable/disable, reordering, and ordinary edits.
```

Rule history metadata is optional in v1 but recommended for rollback-capable editors.

```yaml
metadata:
  version: 3
  createdAt: 2026-06-20T00:00:00Z
  updatedAt: 2026-06-20T00:00:00Z
  history:
    - version: 2
      changedAt: 2026-06-20T00:00:00Z
      reason: Adjusted threshold after preview
```


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
| `action` | yes | `hide`, `remove`, `collapse`, `mark`, safe `style(...)`, or `unhide`. |
| `safety` | recommended | Preview and overblocking limits. |
| `performance` | recommended | Runtime caps, dependency extraction preferences, debounce timing, and evaluation budgets. |
| `frames` | no | Whether the rule is evaluated only in the top document or also in accessible frames; scalar shorthand normalizes to an object. |
| `shadow` | no | Whether open shadow roots are traversed; scalar shorthand normalizes to an object. |
| `runtime` | no | Navigation, path-change, and error-recovery behavior. |
| `cache` | no | Cache limits and eviction behavior. |
| `priority` | no | Numeric tie-breaker inside the same conflict class. Cannot make a hide override an allow. |
| `metadata` | no | Creation source, stable timestamps, picker provenance, import provenance, and rule history. |

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

Terminology is normative:

```text
raw candidate        -> element returned by the `candidates` selector list
resolved target      -> element selected after applying `boundary`
affected element     -> final element receiving `hide`, `collapse`, `remove`, `mark`, `style`, or `unhide`
```

Unless a rule explicitly says `evaluate-on: raw-candidate`, all relative logic is evaluated against the **resolved target**, not the pre-boundary raw candidate.

```text
text                 -> visible text inside the resolved target
has descendant X     -> descendant of the resolved target matches X
has ancestor X       -> ancestor of the resolved target matches X
selector matches X   -> resolved target itself matches X
boundary             -> maps raw candidate -> resolved target
```

This avoids ambiguity when a small child node is selected but the intended action applies to the containing card.

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
  stop-at-scope: true
```

Boundary selection is performed relative to the picked element during rule creation, and relative to each raw candidate during runtime evaluation. The result is the **resolved target**.

Supported modes and parameters:

| Mode | Meaning | Required/allowed parameters |
|---|---|---|
| `exact` | Use the selected element or raw candidate itself. | none |
| `nearest-card` | Choose the nearest likely card ancestor. | `max-depth`, `stop-at-scope` |
| `repeated-card` | Prefer ancestors with repeated sibling shape. | `max-depth`, `stop-at-scope` |
| `semantic-block` | Prefer semantic containers such as `article`, `section`, `li`, roles. | `max-depth`, `stop-at-scope` |
| `visual-block` | Prefer geometrically coherent visible blocks. | `max-depth`, `stop-at-scope` |
| `ancestor-depth` | Use a fixed ancestor depth. | `depth`; optional `stop-at-scope` |
| `selector` | Climb to nearest ancestor matching a selector. | `selector`; optional `max-depth`, `stop-at-scope` |

Mode-specific examples:

```yaml
boundary:
  mode: selector
  selector: 'div.card, article'
  max-depth: 8
  stop-at-scope: true
```

```yaml
boundary:
  mode: ancestor-depth
  depth: 2
  stop-at-scope: true
```

Scope-crossing control:

```yaml
boundary:
  mode: repeated-card
  max-depth: 8
  stop-at-scope: false
  allow-cross-scope: true
  allow-scope-root: false
```

Rules:

```text
1. `stop-at-scope` defaults to true.
2. `allow-cross-scope` defaults to false.
3. `allow-scope-root` defaults to false.
4. If `allow-cross-scope: true` is supplied, the normalized rule sets `stop-at-scope: false` for boundary climbing.
5. A rule must not serialize both `stop-at-scope: true` and `allow-cross-scope: true`. If both are present in input, parsing fails with `boundary-cross-scope-conflict`.
6. A rule may not cross `html`, `body`, shadow-root boundaries, or frame boundaries unless the corresponding boundary type is explicitly enabled by the rule and supported by the engine.
7. When `stop-at-scope: true`, the scope root is a stopping sentinel and is not scored as a boundary target unless `allow-scope-root: true` is explicitly present. This prevents accidentally hiding the entire `main`, feed, or page region.
```

### Boundary candidate enumeration

For a picked node or runtime candidate:

```text
1. Start at the element.
2. Enumerate ancestors up to `max-depth`, default 8.
3. If `stop-at-scope: true`, stop before scoring the scope root. The scope root itself is excluded from boundary candidates unless `allow-scope-root: true`.
4. If `allow-scope-root: true`, the scope root may be scored, but only after preview and only if it does not exceed page-area and max-page-percent safety caps.
5. Continue above the scope root only when `allow-cross-scope: true`.
6. Ignore ancestors that are `html`, `body`, or larger than the safety page-area limit unless explicitly allowed.
7. Score each ancestor using boundary-quality features.
8. Select the highest-scoring ancestor above the mode threshold.
9. If no ancestor passes, fall back to the original raw candidate.
```

### Boundary quality score

Each possible ancestor receives a score from `0.00` to `1.00`. The scoring functions below are normative defaults for v1 so two engines can be tested against the same fixture. Engines may add experimental scoring only behind a different `engineVersion`, not by changing v1 semantics.

Feature formulas:

| Feature | Formula | Weight |
|---|---|---:|
| Semantic tag/role | `1.00` for `article`, `section`, `li`, `role=article`, `role=listitem`; `0.75` for `main` descendants with `aria-*` label; `0.50` for `div`/custom element with meaningful `data-*`; otherwise `0.00`. | 0.20 |
| Candidate selector match | `1.00` if the ancestor itself matches any rule candidate selector; otherwise `0.00`. | 0.15 |
| Repeated sibling pattern | `max(weightedJaccard(signature(node), signature(peer)))` over same-parent siblings, capped at `1.00`; requires at least two peer siblings for `repeated-card`. | 0.25 |
| Self-contained text | Let `chars = normalizedTextLength(ancestor)` and `scopeChars = normalizedTextLength(scopeRoot)`. If `scopeChars == 0`, set this feature score to `0.00` and do not compute `chars/scopeChars`. Otherwise score is `1.00` when `40 <= chars <= 1200` and `chars/scopeChars <= 0.35`; `0.50` when `10 <= chars < 40` or `1200 < chars <= 2500`; otherwise `0.00`. | 0.10 |
| Geometry compactness | `0.00` if invisible or zero area. Otherwise `1.00` when `0.001 <= viewportAreaRatio <= 0.40` and aspect ratio is between `0.2` and `8.0`; `0.50` when area ratio is `<= 0.60`; otherwise `0.00`. | 0.15 |
| Link/button coherence | Let `interactiveCount = links + buttons`. Score is `1.00` when `1 <= interactiveCount <= 8`; `0.50` when `9 <= interactiveCount <= 20`; otherwise `0.00`. | 0.05 |
| Stable attributes | `1.00` if stable `id`, readable `data-*`, `aria-*`, or test id exists; `0.50` if only stable role/tag exists; otherwise `0.00`. | 0.10 |

Boundary score formula:

```text
boundaryScore = weighted_sum(featureScores) / sum(applicableWeights)
```

If all applicable weights are unavailable, the boundary score is invalid and the ancestor must not be selected. The engine must fall back to the original raw candidate or to the next valid boundary mode.

Additional normative scoring details:

```text
meaningful data-* attribute = data attribute whose value has length 2..80 and is not purely random/hash-like
normalizedTextLength(x)     = character count after whitespace collapse and script/style/template removal
page-area limit             = ancestor area must not exceed safety.max-viewport-area-percent during preview, or 60% viewport area by default
```

Mode thresholds:

```text
nearest-card:   >= 0.55
repeated-card:  >= 0.65 and repeatedSiblingScore >= 0.60
semantic-block: >= 0.50 and semanticTagOrRole > 0
visual-block:   >= 0.60 and geometryCompactness >= 0.50
```

Tie-breaking must be stable:

```text
1. Prefer the highest boundaryScore.
2. If scores differ by less than 0.03, prefer the shallower ancestor nearest the raw candidate.
3. If still tied, prefer the ancestor with semantic tag/role.
4. If still tied, prefer the earlier element in document order.
5. Cache raw-candidate -> resolved-target for the current DOM generation so repeated raw candidates resolve to the same target.
```

When `visual-block` geometry is unavailable, hidden, or zero-area, geometryCompactness is `0.00`. If no ancestor satisfies `visual-block` thresholds, fall back to `nearest-card`; if that also fails, use the original raw candidate.

A boundary function is considered stable when two raw candidates inside the same card resolve to the same ancestor under the same DOM generation. This stability is required before applying `max-page-percent` and de-duplicated target counts.


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

Normative buckets for v1:

| Bucketed feature | Ranges |
|---|---|
| Text length | `0`, `1-39`, `40-159`, `160-399`, `400-899`, `900-1999`, `2000+` normalized characters |
| Link count | `0`, `1`, `2-3`, `4-7`, `8-15`, `16+` |
| Button count | `0`, `1`, `2-3`, `4-7`, `8+` |
| Image count | `0`, `1`, `2-3`, `4-7`, `8+` |
| Major child tag histogram | Count tags from `{a, button, img, video, picture, h1-h6, p, span, div, ul, ol, li}` and bucket each count as `0`, `1`, `2-3`, `4-7`, `8+` |

Sibling similarity must use weighted Jaccard or weighted exact-bucket agreement over these features. An implementation may add diagnostic features, but v1 conformance tests must use the ranges above.

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

Normative visual buckets for `visual-block` and `visualBox` scoring:

| Feature | Buckets |
|---|---|
| Width ratio to viewport | `0`, `(0,0.15]`, `(0.15,0.35]`, `(0.35,0.65]`, `(0.65,0.95]`, `>0.95` |
| Height ratio to viewport | `0`, `(0,0.10]`, `(0.10,0.25]`, `(0.25,0.50]`, `(0.50,0.90]`, `>0.90` |
| Area ratio to viewport | `0`, `(0,0.001)`, `[0.001,0.01)`, `[0.01,0.05)`, `[0.05,0.15)`, `[0.15,0.40]`, `(0.40,0.60]`, `>0.60` |
| Aspect ratio `width/height` | `0`, `(0,0.2)`, `[0.2,0.5)`, `[0.5,1.5]`, `(1.5,3.0]`, `(3.0,8.0]`, `>8.0` |
| Horizontal region | `left` if centerX < 0.33 viewport width, `center` if 0.33..0.66, `right` if > 0.66 |
| Vertical order in scope | Divide visible candidates in the same scope into quartiles: `q1`, `q2`, `q3`, `q4`; if fewer than 4, use document order index bucket `first`, `middle`, `last`. |

`visualBox` feature score is the average of bucket agreement (`1.00` same bucket, `0.50` adjacent bucket, `0.00` otherwise) across available visual features. Geometry unavailable or zero-area gives `visualBox = 0.00`.

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

| Mode | Meaning | Algorithm |
|---|---|---|
| `none` | No similarity comparison. Use only candidate + logic. | No similarity score is computed. |
| `exact` | Candidate must match exact selector/fingerprint. | Exact selector or exact stored fingerprint comparison. |
| `similar` | Candidate is compared against a reference feature vector. | Weighted normalized similarity score. |
| `structural` | Candidate is compared against a reference, but DOM shape and card structure dominate the score. | Same weighted normalized similarity score as `similar`, using the `structural-heavy` weight profile unless explicitly overridden. |

`structural` is deliberately **not** a different mathematical algorithm. It is a preset evaluation profile for cases where repeated layout/card shape matters more than text or attribute content. Implementers should route `similar` and `structural` through the same scorer and vary only the effective weight profile and default threshold.

Recommended default profiles:

| Profile | Intended use | Effective weights |
|---|---|---|
| `default-card` | General card/module matching | balanced text, href, structure, semantic attributes |
| `structural-heavy` | Repeated cards with unstable text | high `structure`, `roleTag`, `visualBox`; low `textTokens` and `semanticText` |
| `content-heavy` | Text/link-driven blocking | high `textTokens`, `semanticText`, `href`; lower `structure` |

Validation rules for `match.weights`:

```text
1. In syntax-version 1, `weights` must be one of: `default-card`, `structural-heavy`, `content-heavy`.
2. Custom inline weight objects are invalid in v1 user syntax.
3. The internal schema may store the resolved numeric profile for compiler/debugging, but the user-facing syntax stores only the preset name.
4. Future custom profiles must require a new `syntax-version` or an explicit `custom-weight-profile` feature flag so v1 engines do not silently misread them.
```

Suggested `structural-heavy` weights:

```yaml
weights:
  profile: structural-heavy
  roleTag: 1.5
  textTokens: 0.5
  semanticText: 0.5
  href: 0.75
  dataAttrs: 1.0
  aria: 0.75
  structure: 4.0
  visualBox: 2.0
  classes: 0.10
  nthChild: 0.05
```

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
2. `mode: structural` requires a reference and defaults to `weights: structural-heavy`.
3. `mode: structural` uses the same score computation as `similar`; only the effective weights/default threshold differ.
4. `mode: none` must not have a threshold or reference.
5. `mode: exact` requires either a stable selector reference or a stored exact fingerprint.
6. `mode: exact` with `reference: picked` means: use the exact selector/fingerprint captured from the picked resolved target at creation time.
7. Exact fingerprints compare stable identity features only: canonical selector when available, tag, role, id, stable data/aria attributes, and normalized child signature. Runtime text is not required to match unless explicitly included in `where:`.
8. If a legacy rule has similarity in both a block and logic, import must fail or normalize with an explicit warning. No silent precedence.
9. If `mode: exact` with `reference: picked` cannot capture at least one stable identity feature (`id`, stable `data-*`, stable `aria-*`, test id, or a short canonical selector with no generated-only classes), the picker must warn with `weak-exact-reference` and default the rule to `preview: required`.
10. A weak exact reference must not be silently upgraded into a broad similarity rule. The user must explicitly choose exact, similar, or content-only behaviour.
```

### Canonical selector for exact references

A canonical selector is a short, stable selector generated from the picked resolved target for exact matching. It is not a full DOM path and must avoid generated layout classes.

Construction order:

```text
1. Prefer `tag#id` when the id is unique in the current document/scope and is not hash-like or session-like.
2. Else prefer `tag[data-testid="..."]`, `tag[data-test-id="..."]`, `tag[data-qa="..."]`, or other explicitly stable data/test attributes when unique.
3. Else prefer `tag[role="..."][aria-label="..."]` when the aria value is <= 120 characters and unique enough inside the scope.
4. Else prefer `tag[data-*="..."]` only when the attribute name is stable and the value is readable, non-random, and <= 120 characters.
5. Else use a bounded selector chain of at most 3 ancestors plus the target, using only stable id/data/aria/role/tag components.
6. Do not use generated classes, CSS module hashes, long nth-child chains, transient inline styles, or text content in the canonical selector.
```

A selector component is hash-like when it is mostly hexadecimal/base64-like, longer than 10 characters without vowels or separators, or matches common generated-class patterns. If the engine cannot construct a canonical selector with at least one stable component, it must store only a weak fingerprint, emit `weak-exact-reference`, and require preview before saving.


### Threshold defaults

Thresholds are normative when omitted. The engine must normalize omitted thresholds before evaluation and store the effective value in the normalized AST.

| Rule context | Default effective threshold | Notes |
|---|---:|---|
| `hide-similar` + `match.mode: similar` + omitted `weights` | 0.82 | Also defaults `weights: default-card`. |
| `hide-similar` + `match.mode: similar` + `weights: default-card` | 0.82 | Similarity-only rules are stricter. |
| `hide-similar` + `match.mode: structural` | 0.80 | Also defaults `weights: structural-heavy`. |
| `smart-hide` + `match.mode: similar` + strong `where:` logic | 0.74 | Strong logic is formally defined below. |
| `smart-hide` + `match.mode: structural` + strong `where:` logic | 0.76 | Structural similarity is less text-driven but still needs bounded generalization. |
| `smart-hide` + `match.mode: similar` without strong `where:` logic | 0.82 | Treat as similarity-only. |
| `smart-hide` + `match.mode: none` | no threshold | Similarity is not computed. |
| `match.mode: exact` | no threshold | Exact selector/fingerprint comparison only. |

For `match.mode: none`, `safety.min-features` is ignored because no similarity feature vector is computed. If present in a handwritten logic-only rule, the parser should emit informational warning `min-features-unused`.

Other constants:

```text
Borderline preview bucket: 0.65 to threshold - 0.01
Do not auto-hide below:    0.65
```

If a threshold is supplied below `0.65` for a hide-like action, the rule must require preview and emit warning `low-similarity-threshold`.

### Invalid match-field combinations

Validation rules:

```text
1. If `match.mode: none`, `threshold`, `reference`, and `weights` are not valid and must cause a parse error in strict/canonical serialization.
2. In the interactive editor, these fields may be temporarily shown while switching modes, but saving must normalize by removing them or changing the mode.
3. `safety.min-features` is invalid for `match.mode: none`; the editor may downgrade it to an informational warning only before save, but canonical saved rules must omit it.
4. `safety.min-logic-matches` is the content-only validation control for `match.mode: none`.
```

### Formal definition of strong `where:` logic

A `where:` block is strong for threshold-default purposes only when it contains at least one condition from this list after keyword normalization:

```text
1. `href`, `attr(href)`, or descendant link `href` condition using `==`, `contains`, `starts-with`, `ends-with`, or `~=` with a non-empty literal/pattern.
2. `aria-label`, `aria-*`, or `attr(aria-*)` condition using `==`, `contains`, or `~=` with a pattern of at least 4 normalized characters.
3. `data-*` or `attr(data-*)` condition using `==`, `contains`, or `~=` where the attribute name or value is stable and non-hash-like.
4. `text`, `all-text`, `own-text`, or `semantic-text` condition using `==` for a normalized string of at least 6 characters, or `contains` for a normalized phrase of at least 8 characters containing whitespace or punctuation. This is the v1 meaning of "exact phrase".
5. `selector matches` or `has descendant` using a scoped selector that includes a tag plus a stable attribute, role, aria, data, href, or id condition. Bare selectors such as `div`, `span`, `.foo`, or `:nth-child(...)` are not strong.
```

Regex text conditions count as strong only if the literal portion contains at least 6 non-wildcard characters and the pattern is not a catch-all. If this cannot be determined safely, the engine must treat the condition as not strong and use the stricter default threshold.


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

The same formula is used for both `match.mode: similar` and `match.mode: structural`. The difference is the selected weight profile:

```text
similar     -> default-card unless another profile is specified
structural  -> structural-heavy unless another profile is specified
```

This makes unit testing simpler: one scorer, multiple named profiles.

Default minimum feature availability:

```text
At least 3 feature families must be available.
At least one of structure, semantic role/tag, data attributes, text, or href must be available.
```

`min-features` applies only to `match.mode: similar` and `match.mode: structural`. For `match.mode: none` and `match.mode: exact`, `safety.min-features` is ignored and the parser should emit an informational warning `min-features-unused` if the field is present.


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

Regex literals use JavaScript regular expression syntax. Supported flags in v1 are `i`, `m`, `u`, and `s`; `g` may be accepted only for count-style operators and is ignored for boolean matching after the first match. The sticky flag `y` is rejected. Engines must reject patterns that cannot be compiled by the browser JavaScript regex engine.

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

Definitions:

```text
text-length = number of characters after text normalization; hidden/script/style/template text excluded.
link-count = number of descendant `<a href>` elements under the resolved target.
link-density = link-count / max(text-length, 1).
child-count = number of immediate child elements; text nodes do not count.
```

---

## Text Field Semantics

All text fields use normalized text, not raw HTML.

Normalization:

```text
1. Ignore elements hidden by display:none, visibility:hidden, hidden attribute, or aria-hidden=true by default.
2. Collapse whitespace.
3. Decode HTML entities.
4. Preserve word order.
5. Non-regex equality, contains, starts-with, and ends-with are case-insensitive by default after normalization. Case-sensitive forms must be represented explicitly in the AST, for example `caseSensitive: true`; shorthand operators for case-sensitive variants are editor-defined and must normalize to the AST flag.
6. Regex case sensitivity follows the regex flags, primarily `/i`.
7. Do not include script/style/template content.
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
At least one direct attribute in the family on the resolved target matches. `data-*` and `aria-*` do not inspect descendants unless the condition is explicitly written as `has descendant '[data-*...]'`, `has descendant '[aria-*...]'`, or an equivalent descendant selector.
```

For predictable behavior, the rule editor should show which actual attributes matched during preview.

---

## Keyword Logic

Keyword logic should be first-class, not just raw regex.

Canonical structured form:

```yaml
keywords:
  match-mode: phrase
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

This normalizes internally to `where:` and `except:` conditions. `match-mode` controls how keyword strings are interpreted before expansion.

### Keyword normalization and precedence

`keywords:` is a convenience authoring layer. It must not create a second independent matching system.

Normalization rules:

```text
1. `include-any` and `include-all` expand into `where:` conditions.
2. `exclude-any` and `exclude-all` expand into `except:` conditions.
3. `fields` controls which text/attribute fields generated keyword conditions search.
4. `match-mode` is required in canonical serialized rules and defaults to `phrase` only in the interactive editor before serialization.
5. Valid `match-mode` values are `phrase`, `word`, and `regex`.
4. `case-sensitive`, `word-boundary`, `phrase`, `word`, and `regex` control how generated conditions are built.
```

Precedence rules:

```text
1. If only `keywords:` is present, the engine expands it into canonical `where:` / `except:` during normalization.
2. If `keywords:` and explicit `where:` / `except:` are both present in a hand-written rule, explicit `where:` / `except:` are authoritative.
3. The parser must not silently merge hand-written `keywords:` with hand-written `where:` / `except:` unless the rule explicitly sets `keyword-merge: true`.
4. If `keywords:` is ignored because explicit `where:` / `except:` is authoritative and `keyword-merge` is absent or false, the parser must emit a warning with code `keywords-inactive`.
5. In strict mode, `keywords:` plus explicit `where:` / `except:` without `keyword-merge` should be a parse error instead of a warning.
6. Generated picker rules should prefer canonical `where:` / `except:` and may store the original keyword UI choices in metadata.
7. Export should emit canonical `where:` / `except:` by default, not both forms.
```

When `keyword-merge: true` is used, merging is deterministic and structural. The engine must not try to merge at a deeper node.

Merge algorithm:

```text
expandedWhere  = canonical conditions generated from include-any/include-all
expandedExcept = canonical conditions generated from exclude-any/exclude-all

if existing where and expandedWhere exist:
  normalized where = { all: [ existingWhere, expandedWhere ] }
elif expandedWhere exists:
  normalized where = expandedWhere
else:
  normalized where = existingWhere

if existing except and expandedExcept exist:
  normalized except = { any: [ existingExcept, expandedExcept ] }
elif expandedExcept exists:
  normalized except = expandedExcept
else:
  normalized except = existingExcept
```

This conservative default prevents hidden broadening of a rule when a user edits structured logic manually.

Required warning metadata for inactive keywords:

```json
{
  "code": "keywords-inactive",
  "message": "The keywords block was not applied because explicit where/except logic is authoritative and keyword-merge is false.",
  "severity": "warning"
}
```

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

Normative keyword interpretation:

```text
phrase: normalized substring match; punctuation and whitespace are collapsed; no word-boundary requirement unless `word-boundary: true` is also supplied.
word: token-boundary match for each keyword; keyword must be a single normalized token unless quoted multi-token word mode is explicitly rejected with `invalid-keyword-word-mode`.
regex: each keyword string is parsed as a JavaScript regex literal when written `/pattern/flags`, or as a regex pattern string with default case sensitivity controlled by `case-sensitive`. Invalid regex rejects the rule.
```

`word-boundary: true` is valid for `phrase` and `word`; for `regex`, boundaries must be written in the regex itself and `word-boundary` must produce warning `keyword-word-boundary-ignored`.

---

Keyword validation details:

```text
1. `phrase` matches the entire keyword sequence after normalization, e.g. `Sponsored Content` as one normalized substring.
2. `word` treats each keyword entry as one word/token pattern. Multi-word keyword entries in `word` mode are parse errors unless the editor splits them explicitly.
3. `regex` treats each keyword entry as a regex body or regex literal, depending on editor form, and normalizes to canonical regex conditions.
4. `word-boundary: true` is redundant in `word` mode because tokenization already enforces boundaries; canonical output drops it with warning `word-boundary-redundant`.
```

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

### Safe `style(...)`

`style(...)` must be restricted to a safe declaration subset.

Canonical declaration form:

```yaml
action: 'style("opacity: 0.3; outline: 2px solid currentColor;")'
```

Quoting rules:

```text
1. In YAML, the entire action expression should be a single-quoted scalar.
2. Inside the action expression, the CSS declaration list is a double-quoted string.
3. A literal double quote inside the declaration list must be escaped as `\"`.
4. Newlines are not allowed inside the style payload in v1.
5. The unquoted shorthand `style(opacity: 0; pointer-events: none)` may be accepted only as an editor convenience and must normalize to the canonical quoted form.
```

Sanitisation rules:

```text
1. Only declaration lists are allowed; selectors, imports, media queries, and nested CSS are forbidden.
2. Disallow `url(...)`, `@import`, `expression(...)`, `behavior`, custom external resources, and browser-specific remote-loading functions.
3. Only allow the explicit safe whitelist below unless advanced unsafe mode is implemented separately and never enabled for imported rules by default.
4. Do not allow generated content to include remote URLs.
5. Strip `!important` from custom `style(...)` by default unless `actionOptions.important: true` is set and every property is in the safe whitelist.
```

Safe property whitelist for v1:

| Property | Allowed values | Notes |
|---|---|---|
| `display` | `none`, `block`, `inline`, `inline-block`, `flex`, `grid`, `revert` | No arbitrary display keywords unless added to whitelist. |
| `visibility` | `hidden`, `visible`, `collapse` | Safe for hide/restore semantics. |
| `opacity` | numeric `0` through `1` | Reject percentages and expressions. |
| `outline`, `outline-color`, `outline-style`, `outline-width`, `outline-offset` | safe CSS outline values; no `url()` | Used for preview/mark. |
| `border`, `border-color`, `border-style`, `border-width` | safe border values; no images | Debug/mark only. |
| `background-color` | named colors, hex, rgb/rgba, hsl/hsla, `transparent`, `currentColor` | No images or gradients in v1. |
| `color` | named colors, hex, rgb/rgba, hsl/hsla, `currentColor` | Text/debug only. |
| `filter` | `blur`, `brightness`, `contrast`, `grayscale`, `hue-rotate`, `invert`, `opacity`, `saturate`, `sepia` | Reject `url()` and unknown functions. |
| `pointer-events` | `none`, `auto` | Often paired with hide/mark behavior. |

Properties not listed are rejected in v1. In particular, reject `position`, `transform`, `clip-path`, `margin`, `padding`, `width`, `height`, `z-index`, `content`, `background-image`, and all remote-resource properties unless an explicitly unsafe developer mode is created outside the stable rule language.

Hide-like classification for `style(...)` is deterministic. A custom style is hide-like if any of the following is true:

```text
display: none
visibility: hidden | collapse
opacity <= 0.05
filter includes opacity(0) or opacity value <= 5%
pointer-events: none combined with opacity <= 0.20 or visibility/display suppression
clip-path/inset/transform/position style that moves or clips the element outside visible flow, if such properties are allowed by policy
```

Styles used only for preview or debug marking are debug-like, not hide-like.

### Built-in action style priority

Built-in actions must use deterministic injected styles:

```text
hide:      visibility: hidden !important; pointer-events: none !important;
collapse:  display: none !important;
mark:      outline: 2px solid currentColor !important; outline-offset: 2px !important;
```

`remove` performs DOM removal and does not use CSS. `style(...)` uses the user-provided sanitized declarations and follows `actionOptions.important`. `actionOptions.important` is valid only for `style(...)`; built-in `hide`, `collapse`, and `mark` always use their specified `!important` styles and ignore this option with warning `important-ignored-for-built-in`.

Dynamic style application:

```text
1. A `style(...)` action behaves like built-in hide actions for reapplication. If a matching element remains in the DOM and its inline style or injected rule marker is removed, the engine may reapply the sanitized style on the next evaluation cycle.
2. If the element is removed and later reinserted, the rule re-evaluates normally and reapplies the style only if the reinserted element still matches.
3. If the rule itself used `remove`, there is no style to reapply and no attempt to restore the removed node.
```

### `mark`

`mark` is a non-hiding debug/preview action. It must not change layout or remove interaction.

Default rendering:

```text
outline: 2px solid currentColor !important;
outline-offset: 2px !important;
```

Rules:

```text
1. `mark` may be used by explicit user rules, preview mode, and explanations.
2. `mark` is never hide-like.
3. A user may customize mark styling only through the same safe declaration whitelist used by `style(...)`.
4. Preview marks must be removable without reloading the page.
```

### Classic filter integration model

Classic cosmetic filters and smart rules are not automatically the same execution system. v1 recognizes two integration modes:

```text
1. Unified normalized mode: a classic filter is imported into the smart planner as a `sourceKind: classic-cosmetic` rule with a selector-only predicate. In this mode it participates in conflict classes D/E after user smart rules.
2. External filter-list mode: a classic filter is applied by a separate cosmetic engine. In this mode it does not participate in smart conflict resolution; smart `unhide` can only use a best-effort compatibility layer.
```

A document, debug view, or export must label which mode is active. The conflict classes below apply only to rules represented in the unified normalized mode. External filter-list effects remain outside the smart resolver.


### `unhide`

`unhide` is an allow action. It prevents smart hide/collapse/remove actions from applying to the same resolved target.

Within the smart-rule engine:

```text
smart-allow / unhide beats smart-hide / hide / collapse / remove
```

Important limitation:

```text
1. `unhide` is preventive, not restorative.
2. If a smart allow rule matches before a smart remove action is applied, the remove action must not occur.
3. If another rule has already removed the element from the DOM, `unhide` must not attempt to recreate or reinsert the element.
4. In that case the engine records `unhide-no-target` in the explanation/debug log and performs no DOM mutation.
```

Against classic imported cosmetic filters, `unhide` has a separate best-effort compatibility layer. This is not the same as smart conflict resolution.

```text
1. Preferred: emit or store a compatible classic exception when the external filter format supports it.
2. If the external filter used ordinary CSS hiding and the target still exists in the DOM, the engine may apply a later restoring style such as `display: revert !important` or `visibility: visible !important`, subject to browser behaviour.
3. If the external filter or another tool removed the element from the DOM, smart-unhide must not recreate it or reinsert it.
4. If restoration is impossible because the target is absent, log `unhide-no-target-external-remove`.
5. If restoration is attempted but uncertain, preview/debug must label it `best-effort-restore`, not `guaranteed-unhide`.
```

Do not promise that `unhide` can reverse every external filter-list action.

---


Unhide limitations:

```text
1. `smart-allow` / `unhide` is preventive for smart-normalized rules. It stops smart hide-like actions before they are applied.
2. Against external classic CSS hiding, the compatibility layer may apply a later restoring style only when the element still exists and the external hiding is CSS-based.
3. If an external rule or another engine removed the element from the DOM, v1 must not attempt re-insertion. It should record debug warning `external-remove-unrestorable` when detectable.
4. If a smart rule with `action: remove` has already removed an element in a previous cycle, a later `smart-allow` cannot restore that node; it can only prevent future removals of matching nodes.
```

## Accessibility Behavior

Cosmetic actions affect visual and accessibility exposure differently.

| Action | Visual behavior | Accessibility-tree behavior |
|---|---|---|
| `hide` | Uses `visibility:hidden !important` and `pointer-events:none !important`. | Should add an engine-owned `aria-hidden="true"` marker while active, then restore prior value on unhide when possible. |
| `collapse` | Uses `display:none !important`. | Removed from accessibility tree by browser behavior. |
| `remove` | Removes node from DOM. | Removed from accessibility tree. |
| `mark` | Adds outline only. | Must not change accessibility exposure. |
| safe `style(...)` | Depends on declarations. | If classified as hide-like, apply the same accessibility marker policy as `hide` unless the style uses `display:none`. |

Rules:

```text
1. Engine-owned `aria-hidden` changes must be reversible and must not overwrite a pre-existing user/site value without recording the previous value.
2. Preview `mark` must not set `aria-hidden`.
3. `unhide` may restore only engine-owned accessibility changes.
```

---

## Conflict Resolution

Every rule is evaluated independently. A raw candidate may map to a resolved target, and that resolved target may match many rules. Conflict resolution operates on resolved targets, not raw candidates.

### Deterministic conflict order

The normative order is:

```text
1. Resolve the target from raw candidates and de-duplicate targets.
2. Evaluate each rule independently.
3. If any allow-like smart rule matches the target, block all smart hide-like actions for that target.
4. For remaining hide-like smart/user rules, choose the winning conflict class.
5. Inside that class, choose the highest numeric priority.
6. Inside that priority level, choose the most specific rule.
7. Inside that specificity group, choose the strongest action.
8. If still tied, use newest rule by `metadata.createdAt`; if timestamps are identical, use lexical `id` order for deterministic output. Rule-list order is never semantic.
```

This means action strength does **not** jump across conflict classes. For example, a user `hide-exact` rule with action `hide` beats a broader user `smart-hide` rule with action `remove`, because exact user rules are in a stronger class.

### Rule categories by action

Hide-like actions:

```text
hide
collapse
remove
style(...) classified as hide-like by the deterministic style rules
```

Allow-like actions:

```text
unhide
smart-allow
```

Debug actions:

```text
mark
style(...) if preview/debug only and not hide-like
```

### Conflict classes

Conflict classes are resolved before numeric priority and before action strength:

```text
Class A: user smart-allow / unhide rules
Class B: user exact hide rules
Class C: user smart hide rules
Class D: user imported classic filters represented in unified normalized mode
Class E: subscribed filter-list rules represented in unified normalized mode
Class F: generic cosmetic rules represented in unified normalized mode
```

Normative priority rules:

```text
1. Allow-like smart rules beat smart hide-like rules regardless of numeric priority.
2. A numeric `priority` is an integer from -1000 to 1000; default 0.
3. Numeric priority is evaluated only after conflict class is chosen.
4. A high-priority smart-hide cannot override a matching smart-allow.
5. A high-priority generic rule cannot override a matching user allow rule.
6. Priority does not allow a lower class to beat a higher class.
7. Action strength is evaluated only inside the selected conflict class and selected priority level.
8. Newer rule means higher `metadata.createdAt`, not last edited, last enabled, or list position. It applies only when same class, same priority, same specificity, and same action strength. If `createdAt` is missing on import, the importer must set `metadata.createdAt` and preserve the external timestamp in provenance metadata.
```

Specificity order inside a selected class and priority:

```text
1. `hide-exact` selector/fingerprint match
2. exact host + exact path + explicit selector/candidate
3. exact host + glob path + scoped smart rule
4. domain/entity target + scoped smart rule
5. broad target or generic rule
```

### Multiple hide actions on the same element

After the winning class/priority/specificity group is selected, action strength is used only inside that group:

```text
remove beats collapse
collapse beats hide
hide beats mark
custom hide-like style participates according to its classified effect
custom non-hide debug style does not beat hide/collapse/remove
```

Examples:

```text
Class B hide-exact hide vs Class C smart-hide remove -> Class B hide wins.
Class C smart-hide hide priority 10 vs Class C smart-hide remove priority 0 -> priority 10 hide wins.
Class C smart-hide hide priority 0 vs Class C smart-hide remove priority 0 -> remove wins.
Class A smart-allow priority -1000 vs Class C smart-hide priority 1000 -> allow wins.
```

### Contradictory rule logic

Contradictory `where:` / `except:` logic is local to each rule. Rules do not merge their internal logic.

Example:

```text
Rule A hides text=/sponsored/ except /moderator/.
Rule B hides text=/moderator/.
```

A moderator sponsored post may be hidden by Rule B even though Rule A excludes it, unless a separate allow rule overrides. The UI should show which rule caused the final action.

---


### Explicit overrides and composition

V1 conflict resolution is intentionally rule-local. Explicit composition is reserved for a later syntax version.

```text
1. `supersedes`, `overrides`, and rule templates are not valid v1 fields.
2. If imported, they must produce warning `unsupported-composition-field` and the rule must remain disabled unless an engine-specific extension supports them.
3. Users should express exceptions in v1 through `smart-allow`, `except:`, target/path narrowing, and priority within the normal conflict hierarchy.
```
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
  min-logic-matches: 1
  warn-if-scope-is-body: true
  warn-if-no-where-logic: true
  warn-if-action-remove: true
```

Default safety values when omitted:

| Field | Default | Applies to |
|---|---|---|
| `preview` | `required` for picker-generated rules, similarity/structural rules, `remove`, weak exact references; `recommended` for manually written smart rules; `optional` for `hide-exact`; never silently `skip`. | all |
| `max-matches` | 100 | smart rules |
| `max-page-percent` | 25 | smart rules |
| `max-viewport-area-percent` | 40 | hide-like actions |
| `min-features` | 3 | only `similar` / `structural`; canonical parse error with `match.mode: none` |
| `min-logic-matches` | 1 by default; 2 for generated broad content-only rules unless one condition is high-specificity | `match.mode: none` and logic-heavy smart rules |
| `warn-if-scope-is-body` | true | smart rules |
| `warn-if-no-where-logic` | true for generalized rules | smart rules |
| `warn-if-action-remove` | true | remove |

If `safety` is absent, these defaults are applied during normalization and stored in the normalized AST.

Content-only validation:

```text
1. `safety.min-logic-matches` counts positive `where:` leaf conditions that matched the resolved target.
2. A generated `smart-hide` rule with `match.mode: none` should default to `min-logic-matches: 2` unless it has exactly one high-specificity condition such as `href contains`, `aria-label ==`, `data-* ~=`, or `selector matches` scoped to a narrow candidate set.
3. If `min-logic-matches` is greater than the number of possible positive conditions, parsing fails with `min-logic-matches-impossible`.
4. `except:` matches do not count toward `min-logic-matches`; they only reject candidates.
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
6. If `preview: required`, saving without an explicit preview confirmation is blocked with error `preview-required`.
7. Preview must use the same evaluator as active mode. Preview may use relaxed caps to display more matches, but any relaxed cap must be labeled in the explanation.
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

Maximum percentage of resolved targets under the rule's scopes that may be affected.

Normative formula:

```text
max-page-percent = uniqueMatchedResolvedTargets / totalUniqueResolvedTargetsWithinScope * 100
```

Rules:

```text
1. Compute after boundary resolution and target de-duplication.
2. Count each resolved target once even if multiple raw candidates map to it.
3. If the engine uses a raw-candidate approximation for performance, the preview/explanation must mark the percentage as approximate.
4. Safety blocking should use the exact post-boundary value when available.
```

Example:

```text
100 raw candidates in scope
70 unique resolved targets after boundary de-duplication
30 matched resolved targets
max-page-percent = 42.86
```

If the rule says `max-page-percent: 25`, this page would trigger a warning or block auto-application depending on policy.

### `max-viewport-area-percent`

Maximum percentage of the visible viewport area that matched elements may occupy during first evaluation.

This prevents a bad rule from hiding most of the page.

---


### Warning and error levels

Every parser/runtime diagnostic must have a severity.

| Severity | Meaning | May save/activate? |
|---|---|---|
| `info` | Informational; no action required. | yes |
| `warning` | User should review; rule can be saved if policy allows. | yes, unless enterprise policy blocks |
| `error` | Invalid or unsafe semantics. | no |

Examples:

```text
threshold-with-mode-none -> error
preview-required -> error until preview is confirmed
keywords-inactive -> warning, or error in strict mode
min-features-unused -> error in canonical saved syntax for `match.mode: none`
weak-exact-reference -> warning plus preview required
```
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

Suggested default buckets for `match.mode: similar` or `structural`:

```text
High-confidence:    match score >= threshold + 0.08 and where matched
Medium-confidence:  match score >= threshold and where matched
Borderline:         match score >= 0.65 but below threshold, where matched
Excluded:           where matched but except also matched
Blocked by safety:  matched but exceeded safety cap
```

For `match.mode: exact`:

```text
Exact selected element: exact selector/fingerprint matched
High-confidence:        exact reference matched and where matched
Excluded:               exact reference matched but except also matched
Blocked by safety:      matched but exceeded safety cap
```

For `match.mode: none`, no similarity confidence exists. Use logic buckets instead:

```text
Logic-high:        where matched by stable selector, href, aria, data attribute, or exact phrase
Logic-medium:      where matched by visible text or semantic text regex
Logic-borderline:  where matched only by broad text/contains logic or very short keyword
Excluded:          where matched but except also matched
Blocked by safety: matched but exceeded safety cap
```

The UI must not display a numeric similarity score for `match.mode: none`.

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


For `match.mode: none`, preview buckets are logic-based rather than score-based:

```text
High-confidence:    where matched and `min-logic-matches` exceeded by at least 1, no except matched
Medium-confidence:  where matched and `min-logic-matches` satisfied exactly, no except matched
Borderline:         where partially matched but did not satisfy `min-logic-matches`; preview only, not active
Excluded:           where matched but except also matched
Blocked by safety:  matched but exceeded safety cap
```
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
for each active rule matching current host/path/frame:
  roots = collectScopeRoots(rule.scope)
  rawCandidates = queryCandidates(roots, rule.candidates)
  for rawCandidate in bounded(rawCandidates, rule.performance):
    resolvedTarget = resolveBoundary(rawCandidate, rule.boundary)
    if not passesMatch(resolvedTarget, rule.match): continue
    if not passesWhere(resolvedTarget, rule.where): continue
    if passesExcept(resolvedTarget, rule.except): continue
    recordAction(resolvedTarget, rule)
resolveConflictsAndApplyActions()
```


### Page and tab lifecycle

```text
1. Page load: discover scopes, evaluate matching active rules, start observers.
2. Same-origin navigation or SPA path change: re-check targets/paths, clear path-sensitive caches, and re-evaluate affected rules.
3. Cross-origin navigation: stop all page-session observers and clear caches.
4. Page unload/frame unload: disconnect observers and clear page/frame caches.
5. Tabs are isolated by default; caches and runtime state are per-tab.
6. Cross-tab/shared state is deferred from v1 and must not be assumed by rules.
```

---

## Frame and Iframe Semantics

Smart rules are evaluated per document context. A selector in the top document does not automatically pierce into an iframe.

Canonical frame field accepts scalar shorthand or object form. Scalar shorthand normalizes to `mode`.

```yaml
frames:
  mode: top-only
  accounting: per-frame
  max-total-matches: 300
```

Allowed modes:

| Value | Meaning |
|---|---|
| `top-only` | Evaluate only in the top-level document. Default. |
| `same-origin` | Evaluate in the top-level document and also inside same-origin iframes when accessible. |
| `accessible` | Evaluate in the top-level document and in frames where the extension has an injected content script and the rule target/path matches that frame URL. |

`frames: none` is intentionally not part of v1 because it is ambiguous and not useful for active rules. To avoid frame traversal, use `top-only`. To disable a rule entirely, use `enabled: false`.

Frame accessibility definitions:

```text
same-origin: frame URL has the same origin as the top document and can be legally accessed/injected by the extension.
accessible: a content script is active in the frame and the extension has permission to evaluate that frame, even if the frame is cross-origin.
top-only: evaluate only the top-level browsing context.
```

Accounting rules:

```text
1. Default accounting is `per-frame`: each frame has independent scope roots, candidate caps, match caps, cache entries, and `max-page-percent`.
2. Feature vectors and boundary caches are not shared across frames, even when origins match.
3. Aggregate accounting is optional: `frames.accounting: aggregate` lets a rule enforce `max-total-matches` across all evaluated frames.
4. In aggregate mode, per-frame caps still apply first; then aggregate caps are checked before action application.
5. `max-page-percent` is per-frame unless `frames.accounting: aggregate` explicitly defines an aggregate denominator.
6. Preview must label which frame a match came from and whether caps were per-frame or aggregate.
```

Rules:

```text
1. Each frame is treated as its own document with its own host/path target check.
2. Parent document scope selectors do not select inside iframe documents.
3. Same-origin frames may be evaluated directly only if browser permissions and extension configuration allow it.
4. Cross-origin frames must not be traversed from the parent DOM. They may only be evaluated by a content script running inside that frame.
5. Boundary detection never crosses frame boundaries.
6. If a frame is removed, disconnect observers and drop per-frame caches immediately.
```

---

## Shadow DOM Semantics

Smart rules do not pierce shadow roots by default. Shadow DOM support must be explicit because traversal can be expensive and because closed shadow roots are not accessible.

Canonical shadow field accepts scalar shorthand or object form. Scalar shorthand normalizes to `mode`.

```yaml
shadow:
  mode: none
  observe-mutations: true
  observe-subtree: open-only
  observe-recursive: false
```

Allowed modes:

| Value | Meaning |
|---|---|
| `none` | Do not enter shadow roots. Default. |
| `open` | Evaluate inside directly reachable open shadow roots under selected scope roots. |
| `open-recursive` | Evaluate recursively inside nested open shadow roots, subject to performance caps. |

Rules:

```text
1. Closed shadow roots cannot be traversed and must be treated as unavailable.
2. `shadow: none` means no shadow traversal at all, even for open roots.
3. `shadow: open` observes and evaluates directly reachable open roots under the selected scope roots.
4. `shadow: open-recursive` may enter nested open roots; each root counts against candidate and mutation budgets.
5. If `shadow.observe-mutations: true`, MutationObserver instances are attached inside discovered open shadow roots as well as ordinary scope roots.
6. If a new open shadow root is attached under an observed scope root, the engine schedules debounced scope discovery for that host.
7. Shadow roots are not scope roots by themselves unless the rule's scope resolves inside them; they are traversal containers under the owning document/frame.
8. Boundary detection does not cross from a shadow tree to the host unless `boundary.allow-cross-shadow: true` is supported and explicitly enabled. This is deferred from v1 unless implemented.
9. Scope and candidate selectors inside a shadow root are evaluated relative to that shadow root document fragment.
10. Preview/explanation must label matches that came from an open shadow root and identify the host element when possible.
11. Shadow traversal counts against `max-candidates`, `max-evaluations-per-cycle`, and `max-added-nodes-per-cycle`.
12. If `shadow: open-recursive` repeatedly exceeds budgets, the rule must pause and warn with `shadow-budget-exceeded`.
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

### Dependency extraction and invalidation

Before runtime evaluation, every active rule is compiled into a dependency set. This set controls mutation observation and cache invalidation.

Dependency categories:

| Condition type | Dependency extracted | Observation target |
|---|---|---|
| `href contains`, `href ~=` | `href` | resolved target and descendants containing links when descendant logic exists |
| `aria-label`, `aria-*` | named aria attributes or `aria-*` family | resolved target; descendants only when explicitly in descendant selector |
| `data-*`, `attr(data-...)` | named data attributes or `data-*` family | resolved target; descendants only when explicitly in descendant selector |
| `has descendant 'a[href*=...]'` | selector prefilter plus `href` | descendant subtree under scope roots |
| `has descendant '[role=...]'` | selector prefilter plus `role` | descendant subtree under scope roots |
| `has ancestor X` | selector dependency | candidate ancestry up to scope root |
| `text`, `semantic-text`, `own-text` | text/subtree dependency | childList and characterData under candidate/target roots |

Canonical performance controls:

```yaml
performance:
  dependency-depth: 3
  dependency-prefilter: true
```

Rules:

```text
1. `dependency-depth` limits upward invalidation from a changed descendant toward raw candidates/resolved targets. Default is 3; `0` means only the changed node; `unbounded` is allowed only in developer mode.
2. Descendant selector dependencies are recursive for detection, but cache invalidation is bounded by `dependency-depth` and the active scope root.
3. `dependency-prefilter: true` means the engine first checks whether an added/changed node could satisfy a descendant selector before invalidating all ancestors.
4. Dynamically added descendants that become matching descendants must invalidate the nearest raw candidate/resolved target ancestors and schedule re-evaluation.
5. If dependency extraction cannot determine a narrow attribute set, the rule must either observe `childList` only and re-scan on additions, or warn `broad-dependency-observation`; it must not watch every attribute silently.
```

### Attribute observation

Only observe attributes needed by active rules, including attributes used by descendant or ancestor conditions.

Example:

```text
Rule uses aria-label, href, data-sdui-component.
Observer watches only aria-label, href, data-sdui-component, and class if class matching is enabled.
```

For descendant conditions:

```text
has descendant a[href*="/ads/"]
```

The dependency is not only on the resolved target itself. The observer must watch relevant descendant subtrees for `href` changes and invalidate the nearest candidate/target ancestors when a matching descendant attribute changes.

Dependency extraction rules:

```text
1. Parse `where:` and `except:` into a dependency set before runtime.
2. If a condition references descendant selectors or descendant attributes, observe subtree mutations under scope roots.
3. If a watched descendant attribute changes, invalidate cached text/link/attribute summaries for ancestor raw candidates and resolved targets up to the active scope root.
4. Do not observe every attribute by default; observe the exact attribute names needed by active rules.
```

Avoid watching every attribute by default.

### Re-evaluation triggers

Re-evaluate when:

```text
new candidate node is added
new descendant under a candidate is added
watched attribute changes
scope root appears after SPA navigation
scope root is removed or replaced during SPA teardown
URL path changes without full page load
```

SPA path-change controls:

```yaml
runtime:
  observe-path-changes: true
  path-change-debounce-ms: 200
  re-evaluate-on-path-change: smart
```

Rules:

```text
1. Path changes detected through History API wrapping, `popstate`, `hashchange`, or document URL polling trigger debounced target/path re-check.
2. `re-evaluate-on-path-change: never` disables path-triggered re-evaluation.
3. `always` clears page-session caches and re-evaluates all rules that target the new URL.
4. `smart` re-evaluates only rules whose target/path match status changed or whose scopes were removed/recreated. Default is `smart`.
5. `glob:/feed/**` matches `/feed/`, `/feed/top/`, and deeper descendants after SPA navigation according to the path glob rules.
```

Scope-root removal rules:

```text
1. If a watched scope root is detached from the document, disconnect observers for that root.
2. Drop WeakMap/cache entries whose root is detached.
3. Mark affected rules as awaiting-scope.
4. Re-run scope discovery after the next debounced mutation or SPA navigation signal.
5. Never apply actions to detached resolved targets.
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

`max-candidates` and `max-evaluations-per-cycle` are distinct:

```text
max-candidates              -> maximum raw candidates collected for a full page pass of one rule
max-evaluations-per-cycle   -> maximum raw candidates evaluated in one mutation/debounce cycle
max-added-nodes-per-cycle   -> maximum added DOM nodes inspected before deferring a mutation batch
```

When more raw candidates exist than `max-candidates`:

```text
1. Process candidates in deterministic document order.
2. Evaluate the first `max-candidates` in the current full pass.
3. Defer remaining candidates to later cycles only if the rule is in preview mode or the user enables background continuation.
4. Do not silently pretend skipped candidates were non-matches.
5. Preview and explanations must show `skipped-candidates` count.
6. If skipping repeats on the same site/rule, pause the rule and warn unless the user raises the limit.
```

When mutation batches exceed `max-added-nodes-per-cycle`, the engine should process a bounded prefix, schedule another debounced cycle, and mark the preview/runtime explanation as partially evaluated until complete.

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


### Mutation budget measurements

```text
max-added-nodes-per-cycle counts raw nodes reported by MutationObserver before filtering and before de-duplication.
max-evaluations-per-cycle counts resolved-target evaluation attempts after raw candidate collection and boundary resolution.
max-candidates counts raw candidate elements collected under all scope roots for the current document/frame before boundary de-duplication.
```

If `max-candidates` is exceeded, active mode evaluates only the first deterministic batch up to the limit, ordered by document order within each scope, and schedules the remaining candidates for later cycles only if the rule has not hit a repeated-over-budget safety stop. Preview must label that the result is partial.
### Expensive selector and procedural prefilter policy

The compiler may use CSS/procedural prefilters only when they are cheaper than the smart runtime predicate and do not broaden semantics silently.

Cost rules:

```text
1. Simple selectors (`tag`, `.class`, `#id`, `[attr]`, `[attr*=value]`) are cheap.
2. `:is()` and `:where()` are cheap when all branches are cheap and branch count <= 12.
3. `:has()` is expensive unless scoped to a small candidate set and does not contain broad descendant wildcards.
4. Text/procedural selectors such as `:has-text()` are approximate unless their text normalization matches smart text semantics.
5. If a procedural prefilter would run over `body`, `html`, or more than `max-candidates` raw elements, prefer smart runtime staging.
6. Any procedural compilation using `:has`, `:has-text`, or broad descendant selectors must record equivalence status and cost classification.
```

### Regex engine and budget

Canonical regex semantics use the browser JavaScript `RegExp` engine in v1.

Rules:

```text
1. Regex literals use JavaScript-style syntax and flags, e.g. `/sponsored/i`.
2. Engines must reject unsupported flags.
3. Regexes are evaluated against normalized field strings, not raw HTML.
4. `max-regex-ms-per-rule-cycle` is a best-effort budget measured with monotonic time around regex evaluation batches.
5. The engine checks elapsed time after each regex condition or after a small fixed batch of regex conditions.
6. If the budget is exceeded, remaining regex checks are deferred in preview mode or skipped with warning `regex-budget-exceeded` in active mode.
7. A regex that repeatedly exceeds budget should be marked risky and require preview/revision.
```

### Caching

Cache per page session and per frame/shadow traversal context. Caches are not shared across tabs by default.

Canonical cache controls:

```yaml
cache:
  max-entries: 1000
  max-age-ms: 60000
  eviction-policy: LRU
  scope: per-rule
```

Cache entries may include:

```text
candidate -> resolved boundary
boundary -> feature vector
boundary -> normalized text
boundary -> descendant link summary
boundary -> last matched rule ids
```

Rules:

```text
1. Default cache scope is `per-rule`; `per-page` may be used only for derived data that is independent of rule semantics.
2. Evict by LRU when `max-entries` is exceeded.
3. Evict entries older than `max-age-ms`.
4. Drop all page-session caches on cross-origin navigation or page unload.
5. Clear rule-specific caches when rule syntax, thresholds, boundaries, or dependencies change.
6. Invalidate entries when relevant subtree or watched attributes change.
7. Cross-tab state sharing is disabled in v1.
```



### Local performance diagnostics

V1 should collect local, non-networked diagnostics for explainability and debugging.

```yaml
performance:
  metrics: collect
  sample-rate: 1.0
```

Rules:

```text
1. Metrics are local to the browser/profile unless the user explicitly exports them.
2. At minimum record per-rule candidate count, matched count, evaluation time, regex time, cache hits/misses, and safety stops.
3. `metrics: none` disables diagnostic collection except fatal parse/runtime errors required for user feedback.
4. `sample-rate` applies to repeated cycles, not the initial preview. Preview always records explanation data.
```
### Error recovery and budget exhaustion

Runtime failures must be deterministic and fail-safe.

Canonical controls:

```yaml
runtime:
  error-recovery: continue
  on-budget-exceeded: stop-rule
```

Rules:

```text
1. If feature extraction fails for one candidate, skip that candidate, record `candidate-evaluation-error`, and continue by default.
2. If a rule-level parser/runtime invariant fails, stop that rule for the current page and do not apply new actions from it.
3. If regex budget is exceeded mid-evaluation, stop evaluating that rule for the current cycle, do not apply partial new hide/remove actions from that incomplete cycle, and emit `regex-budget-exceeded`.
4. Previously applied reversible styles from earlier successful cycles may remain unless the rule is paused for safety.
5. `error-recovery: fail-safe` stops the whole rule on the first candidate error.
6. `on-budget-exceeded: warn` is allowed only in preview/developer mode; active mode defaults to `stop-rule`.
```
### Hard safety stops

A rule should pause and warn if:

```text
candidate count exceeds max-candidates repeatedly
runtime budget is exceeded repeatedly
matched percentage exceeds max-page-percent
matched visible area exceeds max-viewport-area-percent
rule causes layout churn loop
```

`layout churn loop` is not a vague catch-all. In v1 it means all of the following are true:

```text
1. The rule applies an action to the same resolved target or same target region at least 3 times within 2 seconds, or toggles between affected/unaffected states at least 3 times within 2 seconds.
2. Each action is followed by a mutation batch, style recalculation trigger, or scope re-evaluation caused by the same rule or its injected styles.
3. The set of matched raw candidates for that scope changes by more than 20% between consecutive cycles without user navigation.
```

When detected, pause the rule for the current page, remove only styles injected by that rule if safe, and emit warning `layout-churn-loop`. If an engine cannot implement this detection, it must not claim support for this hard stop; it may instead expose it as an experimental diagnostic.

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
    "stopAtScope": true,
    "allowCrossScope": false,
    "selector": null,
    "depth": null
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
    "maxViewportAreaPercent": 40,
    "minFeatures": 3
  },
  "performance": {
    "maxCandidates": 150,
    "maxEvaluationsPerCycle": 150,
    "maxAddedNodesPerCycle": 300,
    "maxRegexMsPerRuleCycle": 10,
    "debounceMs": 100,
    "cacheFeatureVectors": true
  },
  "frames": "top-only",
  "shadow": "none",
  "actionOptions": {
    "important": false
  },
  "priority": 0,
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


V7 normalized schema additions:

```json
{
  "id": "ubr:smart:550e8400-e29b-41d4-a716-446655440000",
  "enabled": true,
  "metadata": {
    "createdAt": "2026-06-20T00:00:00Z",
    "updatedAt": "2026-06-20T00:00:00Z",
    "source": "picker",
    "importedOriginalId": null
  },
  "frames": { "mode": "top-only", "accounting": "per-frame" },
  "shadow": { "mode": "none", "observeMutations": true },
  "runtime": { "observePathChanges": true, "errorRecovery": "continue" },
  "cache": { "maxEntries": 1000, "maxAgeMs": 60000, "evictionPolicy": "LRU" }
}
```
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
6. If a rule's `syntax-version` is newer than the engine supports, the rule must not be activated; import stores it disabled with error `unsupported-syntax-version`.
7. If a rule's `syntax-version` is older but migratable, migration runs automatically and records `metadata.migratedFromSyntaxVersion`.
8. If automatic migration would change semantics, import requires manual confirmation and preview.
9. Engines must declare `minimum-compatible-version` and `maximum-supported-version`.
```

Canonical migration policy:

```yaml
migration:
  strategy: automatic
  minimum-compatible-version: 1
  deprecation-warning: true
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

## Import Model

Import must classify incoming material before activation.

Canonical import policy:

```yaml
import:
  mode: classify
  auto-convert: false
  preserve-metadata: true
```

Rules:

```text
1. Smart-rule documents are parsed as smart rules and normalized to the current schema.
2. Classic cosmetic filters are imported as classic filters by default, not automatically converted to smart rules.
3. `auto-convert: false` means conversion from classic/procedural filter to smart rule requires user preview/confirmation.
4. A classic filter may be represented in unified normalized mode for conflict accounting only if the engine owns its application path.
5. External subscribed filters that remain in a separate cosmetic engine are not smart rules and are affected only by the best-effort compatibility layer described under `unhide`.
6. Comments, export-loss metadata, source URLs, list names, and original ids should be preserved in `metadata.import`.
```

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

Machine-readable export metadata should be emitted alongside comments when the export format allows comments.

```text
! uBR-smart-export-meta: {"status":"approximate","sourceRuleId":"ubr:smart:9f21a","lostSemantics":["similarity","boundary","preview-required","max-page-percent"],"compilerVersion":"1.0.0"}
```

If the target format cannot preserve comments, the exported bundle should include a sidecar JSON record:

```json
{
  "sourceRuleId": "ubr:smart:9f21a",
  "exportStatus": "approximate",
  "lostSemantics": ["similarity", "boundary", "preview-required", "max-page-percent"],
  "exportedFilter": "www.linkedin.com##article:has-text(/Hire with AI|Promoted|Sponsored/i)",
  "compilerVersion": "1.0.0"
}
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
ruleListDocument  := 'ubr-smart-rules:' newline indentedListBody
listBody          := syntaxVersionBlock listMetadata* 'rules:' ruleEntryList
ruleEntry         := '- id:' ruleId newline 'enabled:' boolean newline metadataBlock? ruleDocument

ruleDocument      := hideExactDocument | smartRuleDocument | hideSimilarDocument | smartAllowDocument
ruleType          := 'smart-hide' | 'smart-allow' | 'hide-exact' | 'hide-similar'

hideExactDocument := 'hide-exact:' newline
                     syntaxVersionBlock
                     targetBlock
                     pathBlock?
                     selectorBlock
                     actionBlock
                     safetyBlock?
                     priorityBlock?
                     metadataBlock?

smartRuleDocument := ('smart-hide:' | 'smart-allow:') newline
                     syntaxVersionBlock
                     targetBlock
                     pathBlock?
                     scopeBlock?
                     candidateBlock?
                     boundaryBlock?
                     matchBlock?
                     whereBlock?
                     exceptBlock?
                     keywordBlock?
                     keywordMergeBlock?
                     actionBlock
                     safetyBlock?
                     performanceBlock?
                     framesBlock?
                     shadowBlock?
                     runtimeBlock?
                     cacheBlock?
                     priorityBlock?
                     metadataBlock?

hideSimilarDocument := 'hide-similar:' newline
                       syntaxVersionBlock
                       targetBlock
                       pathBlock?
                       scopeBlock?
                       candidateBlock
                       boundaryBlock?
                       matchBlock
                       actionBlock
                       safetyBlock?
                       performanceBlock?
                       framesBlock?
                       shadowBlock?
                       runtimeBlock?
                       cacheBlock?
                       priorityBlock?
                       metadataBlock?

smartAllowDocument := smartRuleDocument

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
keywordMergeBlock  := 'keyword-merge:' boolean
actionBlock        := 'action:' actionExpression
safetyBlock        := 'safety:' safetyObject
performanceBlock   := 'performance:' performanceObject
framesBlock        := 'frames:' ('top-only' | 'same-origin' | 'accessible')
shadowBlock        := 'shadow:' shadowScalarOrObject
framesBlock        := 'frames:' frameScalarOrObject
runtimeBlock       := 'runtime:' runtimeObject
cacheBlock         := 'cache:' cacheObject
priorityBlock      := 'priority:' integer[-1000..1000]
metadataBlock      := 'metadata:' metadataObject

boundaryObject     := modeLine
                      maxDepthLine?
                      selectorLine?
                      depthLine?
                      stopAtScopeLine?
                      allowCrossScopeLine?
                      allowScopeRootLine?

modeLine           := 'mode:' ('exact' | 'nearest-card' | 'repeated-card' | 'semantic-block' | 'visual-block' | 'ancestor-depth' | 'selector')
maxDepthLine       := 'max-depth:' integer
selectorLine       := 'selector:' cssSelector        ; required for mode selector
depthLine          := 'depth:' integer               ; required for mode ancestor-depth
stopAtScopeLine    := 'stop-at-scope:' boolean       ; default true
allowCrossScopeLine:= 'allow-cross-scope:' boolean   ; default false
allowScopeRootLine := 'allow-scope-root:' boolean    ; default false; only meaningful when stop-at-scope is true

matchObject        := 'mode:' ('none' | 'exact' | 'similar' | 'structural')
                      referenceLine?
                      thresholdLine?
                      weightsLine?

weightsLine        := 'weights:' ('default-card' | 'structural-heavy' | 'content-heavy')
thresholdLine      := 'threshold:' decimal[0.00..1.00]

performanceObject  := maxCandidatesLine?
                      maxEvaluationsPerCycleLine?
                      maxAddedNodesPerCycleLine?
                      maxRegexMsLine?
                      debounceMsLine?
                      cacheFeatureVectorsLine?
                      preferCssPrefilterLine?

safetyObject       := previewLine?
                      maxMatchesLine?
                      maxPagePercentLine?
                      maxViewportAreaPercentLine?
                      minFeaturesLine?
                      warningFlags*

keywordObject      := keywordMatchModeLine
                      includeAnyLine?
                      includeAllLine?
                      excludeAnyLine?
                      excludeAllLine?
                      keywordFieldsLine?
                      caseSensitiveLine?
                      wordBoundaryLine?

keywordMatchModeLine := 'match-mode:' ('phrase' | 'word' | 'regex')
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
actionExpression   := 'hide' | 'remove' | 'collapse' | 'mark' | 'unhide' | quotedStyleAction
quotedStyleAction  := singleQuoted('style("' safeDeclarationList '")')
```

Important grammar rule:

```text
The `similarity` metric is intentionally absent from `where:` expressions in v2.
Similarity belongs only in `match:`.
```

This eliminates threshold precedence ambiguity.

`styleText` is not arbitrary CSS. It is a quoted safe declaration list after parsing and sanitisation.

---

### v7 grammar validation clarifications

```text
1. `selectorBlock` is valid only inside `hide-exact`. A `smart-hide` using `selector` must rewrite it as `candidates` or fail validation.
2. `priority` must be an integer in [-1000, 1000]. Out-of-range or decimal values are parse errors in canonical syntax.
3. `allow-scope-root: true` is valid only when `stop-at-scope: true`; otherwise parse error `allow-scope-root-without-stop`.
4. `allow-cross-scope: true` normalizes to `stop-at-scope: false`; serializing both fields redundantly is invalid in canonical output.
5. `threshold` with `match.mode: none` is parse error `threshold-not-valid-with-mode-none`.
6. `word-boundary: true` with `keywords.match-mode: word` is redundant; canonical output drops it and emits warning `word-boundary-redundant`.
```

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
export loss marking with machine-readable metadata
```

### Runtime page tests

Use saved DOM fixtures, generated fixture factories, and dynamic mutation fixtures for:

```text
Reddit-like feeds
LinkedIn-like sidebars and job cards
YouTube-like shelves
search-result pages
infinite-scroll pages
SPA path changes
attribute mutation after load
scope-root removal/replacement in SPA navigation
same-origin and accessible iframes
open shadow roots where supported
conflict fixtures covering class vs priority vs action strength
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
performance regression against baseline budgets
```

Regression requirements:

```text
1. Parser snapshot tests must cover every canonical example and every invalid combination listed in this spec.
2. Runtime DOM fixtures should include realistic nested cards, repeated feeds, same-origin frames, accessible cross-origin frames where test permissions allow, and open shadow roots.
3. Performance tests must track candidate count, nodes visited, regex budget use, cache size, and mutation re-evaluation count.
4. Export/import round-trip tests must preserve metadata or explicitly report loss.
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
boundary modes: exact, nearest-card, repeated-card, semantic-block, visual-block, ancestor-depth, selector
match modes: none, exact, similar, structural
where/except structured logic
text, semantic-text, own-text, href, aria-label, attr(name), data-*, aria-*
has descendant / has ancestor
hide, collapse, remove, mark, unhide
preview-required safety
min-features safety
max-matches and max-page-percent
MutationObserver-based dynamic updates, including descendant attribute dependencies
per-frame evaluation accounting
explicit safe style whitelist
rule ids, timestamps, import collision handling, and migration diagnostics
content-only validation with `min-logic-matches`
export loss marking with machine-readable metadata
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
rule templates and reusable components
cloud sync and multi-device conflict resolution
automated rule suggestions/learning
explicit `supersedes` / `overrides` composition fields
```

---

## Final Recommendation

uBR should implement Smart Cosmetic Rules as a declarative layer above classic and procedural filters.

The canonical v4 rule shape should be:

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
    max-depth: <number>
    stop-at-scope: <true | false>
  match:
    mode: <none | exact | similar | structural>
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
    min-features: <number>
  performance:
    max-candidates: <number>
    max-evaluations-per-cycle: <number>
    max-added-nodes-per-cycle: <number>
  frames: <top-only | same-origin | accessible | none>
  priority: <integer -1000..1000>
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


## v8 Normative Production Addendum

This section is normative for syntax version 1 unless a later syntax version explicitly replaces it. It exists to remove remaining implementation choices that could otherwise produce incompatible engines.

### Terminology Used by v8

| Term | Normative meaning |
|---|---|
| Raw candidate | Element returned by the rule's `candidates` selectors inside an active scope root. |
| Resolved target | Element to which the action is applied after boundary resolution. |
| Scope root | One element selected by the rule's `scope` list. Multiple scope roots are de-duplicated and sorted in document order. |
| Active scope root | The nearest ancestor scope root containing the raw candidate. If multiple scope selectors match the same ancestor, that ancestor is still one scope root. |
| Rule document | One complete `hide-exact`, `hide-similar`, `smart-hide`, or `smart-allow` rule. |
| Rule-list document | A container holding one or more rule documents and list-level metadata. |
| Same tree | The same DOM tree or same shadow tree. A light DOM tree and a shadow tree are different trees. |
| Tree traversal | Engine-controlled traversal that may enter open shadow roots when `shadow.mode` allows it. Native `querySelector()` is not considered tree traversal. |

---

## v8 Parser Validation Matrix

The parser must reject contradictory rule-type/action/match combinations before runtime evaluation.

| Rule type | Required fields | Optional fields | Allowed actions | Forbidden combinations |
|---|---|---|---|---|
| `hide-exact` | `selector` | `targets`, `paths`, `scope`, `frames`, `shadow`, `action`, `safety`, `performance`, `metadata` | `hide`, `remove`, `collapse`, `mark`, `style(...)` | `match`, `candidates`, `boundary`, `where`, `except`, `keywords` unless syntax version 2 defines conditional exact rules. |
| `hide-similar` | `targets`, `scope`, `candidates`, `boundary`, `match.reference` | `paths`, `where`, `except`, `keywords`, `frames`, `shadow`, `safety`, `performance` | `hide`, `remove`, `collapse`, `mark`, `style(...)` | `match.mode: none`, `action: unhide`, missing `match.reference`, missing `boundary`. |
| `smart-hide` | `targets`, `scope`, `candidates`, `boundary`, `action` | `paths`, `match`, `where`, `except`, `keywords`, `frames`, `shadow`, `safety`, `performance` | `hide`, `remove`, `collapse`, `mark`, `style(...)` | `action: unhide`; `match.mode: similar|structural|exact` without a valid `match.reference`; no `where` with `match.mode: none` unless `safety.min-logic-matches: 0` is explicitly set and preview is required. |
| `smart-allow` | `targets`, `scope`, `candidates`, `boundary`, `action: unhide` or `action: mark` | `paths`, `match`, `where`, `except`, `keywords`, `frames`, `shadow`, `safety`, `performance` | `unhide`, `mark` | Any hide-like action; `style(...)`; `remove`; `collapse`; `hide`. |

Normative defaults and errors:

```text
1. `scope` is required for `hide-similar`, `smart-hide`, and `smart-allow`.
2. `scope` is optional only for `hide-exact`; if omitted, it normalizes to `scope: [document]` and emits `broad-exact-scope` unless the selector is a unique id selector.
3. `candidates` is required for all smart generalized rules. Missing candidates is parse error `missing-candidates`.
4. `boundary` is required for all generalized smart rules. Missing boundary is parse error `missing-boundary`.
5. `match.reference` is required for `match.mode: exact`, `similar`, or `structural`.
6. `match.reference: none` is legal only with `match.mode: none`.
7. `threshold` is illegal with `match.mode: none` and must produce parse error `threshold-not-valid-for-mode-none`.
8. `safety.min-features` is illegal with `match.mode: none` in strict mode; non-strict editors may remove it during normalization with warning `min-features-unused`.
9. `hide-similar` without explicit `match` normalizes to `match.mode: similar`, `threshold: 0.82`, `weights: default-card`, and `reference: picked` if created by the picker. A handwritten `hide-similar` without a reference is invalid.
10. `smart-allow` with no `where`, no `keywords`, and `match.mode: none` is parse error `catch-all-allow` unless `allow-broad: true` is present and enterprise policy permits it.
```

`allow-broad: true` is a dangerous expert-only field. It must never be generated by the picker.

---

## v8 Normative Defaults Table

Every optional field must resolve through this table before evaluation.

| Field | Default | Applies to | Notes |
|---|---:|---|---|
| `paths` | all paths | all rules | A missing `paths` block means path check passes. |
| `scope` | parse error | smart rules | `hide-exact` only: default `document`. |
| `boundary.mode` | parse error | smart rules | `hide-exact` does not use boundary. |
| `boundary.max-depth` | `8` | boundary modes that climb | Included in grammar and normalized schema. |
| `boundary.stop-at-scope` | `true` | all boundary modes | Scope root is a sentinel unless `allow-scope-root: true`. |
| `boundary.allow-scope-root` | `false` | all boundary modes | Valid only when `stop-at-scope: true`; otherwise parse error. |
| `boundary.allow-cross-scope` | `false` | all boundary modes | Valid only when `stop-at-scope: false`; otherwise parse error. |
| `match.mode` | `none` for content-only `smart-hide`; `similar` for `hide-similar` | smart rules | If `similar` or `structural`, `reference` is required. |
| `match.threshold` with `default-card` | `0.82` | `hide-similar`, similarity-only smart hide | Conservative default. |
| `match.threshold` with strong logic | `0.74` | `smart-hide` using `similar` and formal strong logic | Formal strong logic is defined below. |
| `match.threshold` with `structural-heavy` | `0.80` | `match.mode: structural` or `weights: structural-heavy` | Same algorithm, structural-heavy weights. |
| `match.threshold` with `content-heavy` | `0.78` | `weights: content-heavy` | Requires at least one text or semantic-text feature. |
| `match.weights` | `default-card` | similarity rules | Only `default-card`, `structural-heavy`, `content-heavy` are valid in syntax v1. |
| `safety.preview` | `required` for generated smart generalized rules; `recommended` for manual exact; `required` for `remove` | all rules | Enterprise policy may force `required`; stored in state metadata. |
| `safety.max-matches` | `100` | per frame by default | Aggregate mode may define a global cap. |
| `safety.max-page-percent` | `25` | per scope root by default | Computed after resolved-target de-duplication. |
| `safety.max-viewport-area-percent` | `40` per resolved target | all hide-like rules | Recomputed on full passes, resize, zoom, and target geometry invalidation. |
| `safety.min-features` | `3` | similarity rules | Must be `0..10`; values above available families are parse error. |
| `safety.min-logic-matches` | `1` | content-only smart rules | Counts successful canonical leaf conditions after keyword expansion. |
| `performance.max-candidates` | `150` | per rule, per full pass, per frame unless aggregate mode | Skipped candidates must not be treated as non-matches. |
| `performance.max-evaluations-per-cycle` | `150` | per rule, per cycle | If exceeded, remaining candidates are deferred and state becomes `partial`. |
| `performance.max-added-nodes-per-cycle` | `300` | per document/frame mutation batch before per-rule filtering | Protects the observer from pathological pages. |
| `performance.max-regex-ms-per-rule-cycle` | `10` | per rule, per cycle | Enforced between regex calls; single-regex safety uses static restrictions. |
| `performance.max-regex-pattern-length` | `256` characters | all regex literals | Longer regexes are parse error unless enterprise policy raises the cap. |
| `performance.max-text-regex-input-chars` | `4096` | text/semantic-text regex evaluation | Longer text is truncated with warning `regex-input-truncated`. |
| `performance.debounce-ms` | `100` | mutation cycles | Batches are coalesced into node sets. |
| `performance.dependency-depth` | `3` | descendant/ancestor invalidation | Depth `0` means only the changed node. |
| `performance.dependency-prefilter` | `true` | descendant invalidation | Uses cheap CSS or tag/attribute prechecks before invalidation. |
| `frames.mode` | `top-only` | all rules | No frame evaluation unless requested. |
| `frames.accounting` | `per-frame` | frame-enabled rules | Aggregate mode must set or inherit `max-total-matches`. |
| `frames.max-total-matches` | `150` | aggregate frame accounting | Across top document plus accessible frames. |
| `shadow.mode` | `none` | all rules | No shadow traversal by default. |
| `shadow.observe-mutations` | `true` | `shadow.mode != none` | Existing open roots are observed. |
| `shadow.observe-recursive` | `false` | `shadow.mode: open` | `open-recursive` sets it to `true`. |
| `cache.max-entries` | `1000` | per page session | Hard cap across all rule caches in a frame, not per rule. |
| `cache.max-age-ms` | `60000` | cache entries | Age from last access, not creation. |
| `cache.eviction-policy` | `LRU` | all cache scopes | Evict least recently used entries first. |
| `runtime.observe-path-changes` | `true` | top document and accessible frames | Uses History API hooks plus `popstate`/`hashchange`; polling fallback allowed. |
| `runtime.re-evaluate-on-path-change` | `smart` | all rules | Re-evaluate if target/path match status, scope roots, or route generation changes. |
| `runtime.error-recovery` | `continue` | per rule cycle | Fatal parse errors still block activation. |
| `runtime.on-budget-exceeded` | `stop-cycle` | per rule cycle | Stops current cycle, leaves rule active for later cycles unless repeated. |

---

## v8 Rule-List Container Format

A rule-list document must use a stable container so import, export, ordering, and preview state are portable.

```yaml
ubr-smart-rules:
  syntax-version: 1
  list-id: local-user-rules
  title: Local user smart cosmetic rules
  createdAt: 2026-06-20T00:00:00.000Z
  updatedAt: 2026-06-20T00:00:00.000Z
  engine:
    minimum-compatible-version: 1
    maximum-supported-version: 1
  rules:
    - id: ubr:smart:550e8400-e29b-41d4-a716-446655440000
      orderIndex: 1000
      state: active
      preview:
        status: confirmed
        confirmedAt: 2026-06-20T00:00:00.000Z
        confirmationHash: sha256:...
      metadata:
        source: picker
        createdAt: 2026-06-20T00:00:00.000Z
        updatedAt: 2026-06-20T00:00:00.000Z
        createdFromHost: www.example.com
        createdFromPath: /feed/
      smart-hide:
        syntax-version: 1
        targets:
          - domain:example.com
        scope:
          - main
        candidates:
          - article
        boundary:
          mode: repeated-card
        where:
          any:
            - text contains "Sponsored"
        action: hide
```

Container rules:

```text
1. `list-id` is required. Local lists should use stable ids such as `local-user-rules`; imported lists should use `import:<source-id>`.
2. `orderIndex` is organizational and must be preserved on export/import, but it is not a semantic conflict-resolution field.
3. `createdAt`, not list order, is the semantic tie-breaker when all higher conflict rules are tied.
4. If two rules have identical `createdAt`, use lexical `id` order. Imported batch ids must be deterministic to preserve cross-engine ordering.
5. `state` values are `draft`, `previewed`, `active`, `disabled`, `error`, `awaiting-scope`, `partial`, and `paused`.
6. Disabled rules are parsed and migrated but ignored by all runtime evaluation, conflict resolution, cache accounting, and action application.
7. `preview.status` values are `none`, `required`, `previewed`, `confirmed`, `stale`, and `forced-by-policy`.
8. If enterprise policy forces preview, `preview.status` must be stored as `forced-by-policy` until confirmed. Export must preserve this state.
9. A rule that was generated by the picker cannot become `active` until `preview.status: confirmed`.
10. Re-enabling a generated rule that has never been confirmed requires preview. Re-enabling a confirmed rule does not require preview unless the rule, engine syntax, migration version, target/path, or boundary/match logic changed after confirmation.
```

Rule id format:

```text
Generated smart rule id:     ubr:smart:<uuid-v4>
Generated fingerprint id:   fp:<uuid-v4>
Classic imported rule id:   ubr:classic:<sha256-16>
Imported smart collision:   generate new `ubr:smart:<uuid-v4>` and store `originalId` in metadata
```

For `ubr:classic:<sha256-16>`, the hash input is:

```text
sha256(normalizeClassicFilterLine(filterLine)) first 16 lowercase hexadecimal characters
```

`normalizeClassicFilterLine` means:

```text
1. Normalize Unicode to NFC.
2. Trim leading and trailing ASCII whitespace.
3. Collapse internal ASCII whitespace runs outside regex literals to one space.
4. Preserve selector text, domain options, exception markers, and regex literals exactly after NFC normalization.
5. Remove trailing inline comments only if the filter-list syntax marks them as comments outside selectors.
```

If a collision occurs despite the 16-hex prefix, append `-2`, `-3`, etc. deterministically in import order and store the full SHA-256 in metadata.

Metadata enums:

```text
metadata.source: picker | manual | import | converter | migration | enterprise-policy | test-fixture
metadata.provenance.createdBy: element-picker | manual-editor | classic-importer | smart-importer | migration-engine | api | test-runner
```

---

## v8 Target and Path Matching

### Target Matching

Multiple target entries are OR-ed. A rule applies if at least one target entry matches the current document/frame URL.

| Target form | Meaning |
|---|---|
| `host:www.reddit.com` | Exact hostname only. Does not match `old.reddit.com`. |
| `domain:reddit.com` | Registrable domain and all subdomains. Matches `reddit.com`, `www.reddit.com`, `old.reddit.com`. |
| `entity:google.*` | Engine-provided entity mapping. If unavailable, rule state becomes `error` with `unknown-entity-map` unless a fallback target is also present and matches. |
| `regex:^https://...` | JavaScript regex applied to normalized full URL. Must be quoted in YAML. |
| Bare `reddit.com` | Normalizes to `domain:reddit.com`. Users who want an exact host must write `host:reddit.com`. |
| IP literal | Must use `host:192.168.1.1` or `host:[2001:db8::1]`. `domain:` is invalid for IP literals. |

Hostnames are lowercased and IDNA-normalized before matching. Ports are ignored for `host:` and `domain:` unless a future syntax version adds explicit port support.

### Path Matching

Multiple path entries are OR-ed. A missing `paths` block means all paths match.

The matching input is the browser URL's `pathname` serialized in percent-encoded form. Engines must not decode percent-encoded octets before matching. For display, the editor may show a decoded preview, but matching uses encoded pathname.

| Path form | Meaning |
|---|---|
| `exact:/feed` | Matches only `/feed`, not `/feed/`. |
| `exact:/feed/` | Matches only `/feed/`, not `/feed`. |
| `glob:/r/*/**` | Glob matching over encoded pathname. |
| `regex:^/(feed|jobs|in)/` | Regex over encoded pathname. Must be quoted when backslashes appear. |

Glob rules:

```text
*  matches zero or more characters except `/`.
** matches zero or more characters including `/`.
?  matches exactly one character except `/`.
```

`**` may appear at the beginning, middle, or end of a glob pattern. `glob:**/jobs` is valid and matches any encoded path ending in `/jobs`. Empty path never occurs; browser path is at least `/`.

YAML regex quoting:

```yaml
paths:
  - 'regex:^/(feed|jobs|in)/'
  - 'regex:^/search\?'
```

Single quotes are preferred for regex strings because backslashes are preserved literally in YAML single-quoted scalars.

---

## v8 Scope and Candidate Collection

### Scope Roots

`scope` entries are CSS selector strings. Each entry may be a CSS selector group containing commas if it is quoted as one YAML string. The engine passes each string directly to `querySelectorAll()` within the current document/tree context.

```yaml
scope:
  - 'main, [role="main"]'   # one selector group
  - '[role="feed"]'         # second selector group
```

Scope-root rules:

```text
1. Collect all scope roots from all scope selector strings.
2. De-duplicate by element identity.
3. Sort unique roots in document order.
4. If one scope root contains another, both remain roots, but a raw candidate belongs to the nearest containing scope root.
5. Boundary scoring uses the nearest containing scope root as `activeScopeRoot`.
6. If no scope root exists, the rule state is `awaiting-scope`; it does not evaluate until a scope root appears.
7. `body`, `html`, and `document` scopes trigger `warn-if-scope-is-body` unless the warning is explicitly disabled.
8. For `hide-exact` with omitted scope, the implicit `document` scope also triggers the broad-scope warning unless the selector is unique and stable.
```

### Candidate Collection

Candidate selectors are evaluated inside each active scope root. Candidate collection is deterministic:

```text
1. For each scope root in document order, run every candidate selector.
2. Add matching elements to a set keyed by element identity.
3. Sort the final unique candidate set in document order across the whole document/frame, not root-by-root.
4. Apply `max-candidates` to this sorted global set.
5. If `shadow.mode != none`, each shadow tree has its own local document-order traversal, then results are merged by composed-tree discovery order.
```

A selector that matches a custom-element host in light DOM still matches the host even when `shadow.mode: none`. It does not enter the host's shadow root unless shadow traversal is enabled.

Picker candidate proposal algorithm for `hide-similar`:

```text
1. Start from the selected element and candidate boundary target.
2. Generate candidate selector proposals in this priority order:
   a. semantic container tag: article, section, li, aside, nav, header, footer
   b. role selector: [role="article"], [role="listitem"], [role="feed"] descendants
   c. stable data attribute selector: [data-testid="..."], [data-test-id="..."], [data-qa="..."]
   d. custom-element tag name if it contains a hyphen and appears at least twice under the same scope root
   e. broad fallback: div, only with preview required and strong where logic
3. Keep at most five candidate selectors.
4. Reject selectors that produce zero matches in preview.
5. Warn if the selected candidate selector set matches more than `max-candidates` on first preview.
```

---

## v8 Boundary Resolution

### Boundary Modes and Parameters

```yaml
boundary:
  mode: repeated-card | nearest-card | visual-block | semantic-block | selector | ancestor-depth | exact
  max-depth: 8
  stop-at-scope: true
  allow-scope-root: false
  allow-cross-scope: false
  selector: 'div.card'       # required for mode: selector
  include-self: true         # selector mode only
  depth: 2                   # required for mode: ancestor-depth
```

Validation:

```text
1. `mode: selector` requires `selector`.
2. `mode: ancestor-depth` requires integer `depth >= 0`.
3. `depth: 0` means the raw candidate itself.
4. Negative depth is parse error `invalid-boundary-depth`.
5. `allow-scope-root: true` is valid only with `stop-at-scope: true`; otherwise parse error.
6. `allow-cross-scope: true` is valid only with `stop-at-scope: false`; otherwise parse error.
7. `allow-scope-root` and `allow-cross-scope` cannot both be true.
```

### Scope Root Sentinel Rule

The active scope root is a sentinel by default.

```text
1. Ancestor enumeration starts at the raw candidate.
2. Ancestors are considered up to but excluding the active scope root when `stop-at-scope: true`.
3. The scope root is considered only if `allow-scope-root: true`.
4. `html`, `body`, and document roots are never selected as resolved targets unless `allow-page-root: true` is present. `allow-page-root` is expert-only and requires preview.
5. If `mode: selector` and the nearest matching element is the scope root, the sentinel rule wins: the scope root is skipped unless `allow-scope-root: true`.
6. If `allow-scope-root: true` but the scope root exceeds area safety caps, fallback continues to the next-best non-scope-root candidate. If none exists, the raw candidate is used and warning `scope-root-too-large` is emitted.
```

`allow-page-root` is not generated by v1 picker UI. It exists only so imported expert rules can be represented without silent meaning loss.

### Selector Boundary Mode

`mode: selector` uses `Element.closest()` semantics with one change: the scope sentinel can override the result.

```text
1. If `include-self: true`, test the raw candidate first.
2. If `include-self: false`, start at the raw candidate's parent element.
3. Return the first matching element that is not blocked by scope sentinel, page-root, max-depth, or area safety rules.
4. If a matching ancestor exists only beyond `max-depth`, it is ignored.
5. If no valid selector boundary is found within limits, fallback to `nearest-card`. If that fails, fallback to raw candidate with warning `selector-boundary-not-found`.
```

### Ancestor-Depth Mode

```text
depth: 0  -> raw candidate
Depth N   -> N parent-element steps above raw candidate
```

If the requested depth crosses the active scope root and `stop-at-scope: true`, the selected target is the nearest valid ancestor below the scope root. If no ancestor below the scope root exists, use the raw candidate and emit `ancestor-depth-hit-scope`.

### Boundary Scoring Formulas

All boundary scores are in `[0.00, 1.00]`. Missing geometry or text never produces NaN.

For a candidate ancestor `A` under active scope root `S`:

```text
boundaryScore(A) =
  0.20 * semanticContainer(A)
+ 0.20 * repeatedSibling(A)
+ 0.15 * candidateSelectorMatch(A)
+ 0.15 * geometryCompactness(A)
+ 0.15 * selfContainedText(A, S)
+ 0.10 * interactionCoherence(A)
+ 0.05 * depthPenalty(A)
```

Feature definitions:

```text
semanticContainer(A):
  1.00 if tag is article, section, li, aside, nav, header, footer, or custom element with hyphen and repeated under S
  0.80 if role is article, listitem, feed item, complementary, region, or group
  0.60 if A has meaningful data-* component attributes
  0.00 otherwise

candidateSelectorMatch(A):
  1.00 if A matches at least one normalized candidate selector
  0.00 otherwise

geometryCompactness(A):
  0.00 if A is detached, display:none, visibility:hidden, has zero area, or has non-finite rect values
  1.00 if 0.002 <= areaRatio <= 0.25 and 0.20 <= aspectRatio <= 8.00
  0.50 if 0.0005 <= areaRatio < 0.002 or 0.25 < areaRatio <= 0.45
  0.25 if 0.45 < areaRatio <= 0.60
  0.00 otherwise

selfContainedText(A, S):
  chars = normalizedTextLength(A)
  scopeChars = normalizedTextLength(S)
  if scopeChars == 0: return 0.00
  ratio = chars / scopeChars
  1.00 if 20 <= chars <= 1200 and ratio <= 0.35
  0.75 if 10 <= chars < 20 or 1200 < chars <= 2400, and ratio <= 0.35
  0.40 if ratio <= 0.50
  0.00 otherwise

interactionCoherence(A):
  Let linkCount = number of descendant <a href> elements only.
  Let buttonCount = descendant button elements plus [role="button"].
  Let formCount = descendant <form> elements.
  1.00 if total interactive count is 1..8 and interactions are not spread across unrelated sibling groups
  0.50 if count is 9..20
  0.00 otherwise

depthPenalty(A):
  depth = parent steps from raw candidate to A
  1.00 if depth <= 3
  0.75 if depth <= 5
  0.50 if depth <= 8
  0.00 otherwise
```

`normalizedTextLength()` uses the same visible-text rules as the canonical `text` field: display-none, visibility-hidden, hidden attribute, inert hidden subtrees, and `aria-hidden="true"` are excluded. Off-screen but visible text is included.

Meaningful `data-*` value test:

```text
A data-* value is meaningful if:
1. length is 2..80 after trimming;
2. it contains at least one ASCII letter or non-ASCII letter;
3. it is not generated-like.

A value is generated-like if any of these are true:
1. matches /^[a-f0-9]{8,}$/i
2. matches /^[A-Za-z0-9_-]{12,}$/ and Shannon entropy >= 3.5 bits/char
3. digit ratio > 0.40 and length >= 8
4. contains no vowel-like letters and length >= 10 for Latin-script strings
```

### Repeated Sibling Signature

For repeated sibling detection, each candidate ancestor is represented as:

```text
signature(A) = {
  tagClass: normalized tag name, including custom-element names with hyphens,
  roleClass: role value or none,
  childTagBuckets: histogram of major child tags at depth 1,
  linkBucket,
  buttonBucket,
  imageBucket,
  textLengthBucket,
  hasHeading,
  stableDataKeys
}
```

Buckets:

| Bucketed feature | Buckets |
|---|---|
| links/buttons/images | `0`, `1-2`, `3-5`, `6-10`, `11+` |
| text length characters | `0`, `1-40`, `41-160`, `161-600`, `601-1600`, `1601+` |
| child tag counts | each tag count bucketed as `0`, `1`, `2-3`, `4-7`, `8+` |

Weighted signature similarity:

```text
weightedJaccard(A, B) = sum_i weight_i * equal_or_hist_sim_i / sum_i weight_i
```

Weights:

```text
tagClass:        0.15
roleClass:       0.10
childTagBuckets: 0.25
linkBucket:      0.10
buttonBucket:    0.10
imageBucket:     0.10
textLengthBucket:0.10
hasHeading:      0.05
stableDataKeys:  0.05
```

For histograms:

```text
hist_sim(H1, H2) = sum(min(H1[k], H2[k])) / max(sum(max(H1[k], H2[k])), 1)
```

`repeatedSibling(A)` is the maximum weighted signature similarity between `A` and any same-parent sibling after excluding invisible siblings and siblings with zero area. If fewer than two comparable siblings exist, score is `0.00`.

### Boundary Fallback Order

If the selected boundary mode fails, fallback is deterministic:

```text
selector -> nearest-card -> semantic-block -> raw candidate
ancestor-depth -> nearest-card -> raw candidate
visual-block -> nearest-card -> semantic-block -> raw candidate
repeated-card -> nearest-card -> semantic-block -> raw candidate
nearest-card -> semantic-block -> raw candidate
semantic-block -> raw candidate
exact -> raw candidate
```

If all scoring features are unavailable, do not pretend a confident boundary was found. Use fallback order and emit `boundary-low-confidence`.

---

## v8 Similarity Score Specification

Similarity uses one formula for `similar` and `structural`; the only difference is the weight profile.

```text
score(A, B) = sum_i(weight_i * availability_i * featureScore_i(A, B)) /
              sum_i(weight_i * availability_i)
```

If the denominator is `0`, the score is invalid and the pair does not match. Emit `no-available-similarity-features` in preview/debug output.

### Feature Availability

For a feature family:

```text
available = 0 if both A and B have no data for that family.
available = 1 if either A or B has data for that family.
```

If one side has data and the other does not, the feature is available and its feature score is `0.00`. This prevents artificially high scores when important features are missing.

### Weight Profiles

| Feature family | `default-card` | `structural-heavy` | `content-heavy` |
|---|---:|---:|---:|
| `tagRole` | 1.0 | 1.5 | 0.7 |
| `structure` | 2.0 | 4.0 | 1.0 |
| `textTokens` | 1.5 | 0.5 | 3.0 |
| `semanticText` | 1.5 | 0.8 | 3.0 |
| `href` | 2.0 | 1.0 | 2.0 |
| `aria` | 1.2 | 0.8 | 1.8 |
| `dataAttrs` | 1.5 | 1.5 | 1.5 |
| `classes` | 0.25 | 0.25 | 0.10 |
| `visualBox` | 1.0 | 1.5 | 0.5 |
| `nthChild` | 0.5 | 0.8 | 0.2 |

`match.weights` must be one of these exact strings in syntax version 1. Custom weight objects are parse error `custom-weights-not-supported-v1`.

### Feature Scores

#### `tagRole`

```text
tagScore = 1 if normalized tag names equal, else 0
roleScore = 1 if normalized role values equal and non-empty, else 0 if either role exists, else unavailable
featureScore = 0.70 * tagScore + 0.30 * roleScore when role is available
featureScore = tagScore when role is unavailable
```

#### `structure`

Structure is a weighted aggregate:

```text
structureScore =
  0.20 * tagNameAgreement
+ 0.15 * roleAgreement
+ 0.25 * depth1ChildHistogramSim
+ 0.20 * depth2ChildHistogramSim
+ 0.20 * structuralCountBucketAgreement
```

Depth histograms include element children only. Text, comment, processing-instruction, and template-content nodes are excluded. Shadow DOM assigned nodes are excluded unless `shadow.mode != none`, in which case open shadow children are counted in a separate `shadowChildHistogram` subfeature. In v1 that subfeature is folded into depth2 with weight capped at 0.10.

`structuralCountBucketAgreement` is the mean agreement over link, button, image, form, and immediate child count buckets:

```text
0, 1, 2-3, 4-7, 8-15, 16+
```

`form` count means descendant `<form>` elements.

#### `textTokens`

```text
textTokensScore = |tokens(A) ∩ tokens(B)| / |tokens(A) ∪ tokens(B)|
```

If both token sets are empty, the feature is unavailable. If one is empty, score is `0.00`.

Short-text dampening:

```text
if min(tokenCount(A), tokenCount(B)) < 3: multiply score by 0.50
if min(tokenCount(A), tokenCount(B)) == 1: multiply score by 0.25
```

#### `semanticText`

Same Jaccard formula as `textTokens`, but the input is the semantic text channel defined in v8 text semantics.

#### `href`

For every descendant `<a href>` only, collect normalized URL components:

```text
host tokens: registrable domain labels and subdomain labels
path tokens: split path on '/', '-', '_', '.', and percent-encoded separators after preserving encoded match form
query keys: query parameter key names only, not values
```

Query values are intentionally excluded in v1 to avoid tracking-id coupling. A future version may add an opt-in `href-query-values` feature.

```text
hrefScore = 0.40 * hostTokenJaccard + 0.40 * pathTokenJaccard + 0.20 * queryKeyJaccard
```

#### `aria`

`ariaScore` compares direct aria attributes, excluding `aria-hidden` unless explicitly requested through `attr(aria-hidden)` in logic.

```text
ariaScore = 0.50 * ariaKeyJaccard + 0.50 * ariaValueTokenJaccard
```

`aria-labelledby` and `aria-describedby` resolution is bounded to at most 10 referenced ids and 1000 resolved characters per candidate. Exceeding the limit truncates semantic text and emits `aria-resolution-truncated`.

#### `dataAttrs`

Direct `data-*` attributes only. Descendant attributes are not included.

```text
dataAttrsScore = 0.50 * dataKeyJaccard + 0.50 * dataValueTokenJaccard
```

Only meaningful values as defined by the generated-like test are included.

#### `classes`

Only stable classes are included.

```text
classesScore = stableClassJaccard
```

A class is generated-like and excluded if any of these are true:

```text
1. matches /^[a-f0-9]{8,}$/i
2. matches /^[A-Za-z0-9_-]{12,}$/ and Shannon entropy >= 3.5 bits/char
3. digit ratio > 0.35 and length >= 8
4. contains `_` or `-` followed by 5+ alphanumeric hash-like characters at the end
5. starts with known CSS-module hash pattern: /^_[A-Za-z0-9]{6,}$/
```

A class is stable if it is not generated-like, length is 2..64, and it contains at least one alphabetic character.

#### `visualBox`

`visualBox` is available only when both resolved targets are connected, visible, and have non-zero finite bounding boxes. It is unavailable across different active scope roots unless both roots share the same document and comparable viewport. It is also unavailable across frames.

Subfeatures:

```text
widthBucketAgreement      0.15
heightBucketAgreement     0.15
areaBucketAgreement       0.20
aspectBucketAgreement     0.15
horizontalRegionAgreement 0.15
verticalQuartileAgreement 0.20
```

The visualBox score is the weighted mean of available subfeatures. Bucket agreement returns:

```text
1.00 if same bucket
0.50 if adjacent bucket
0.00 otherwise
```

Numeric buckets:

```text
width/height ratio to viewport: 0, (0,0.10], (0.10,0.25], (0.25,0.50], (0.50,0.80], (0.80,1.20], >1.20
area ratio to viewport:        0, (0,0.01], (0.01,0.05], (0.05,0.15], (0.15,0.35], (0.35,0.60], >0.60
aspect ratio width/height:     <=0.25, (0.25,0.5], (0.5,1.0], (1.0,2.0], (2.0,4.0], >4.0
horizontal region:             left if centerX < 0.33 viewportWidth; center if < 0.67; right otherwise
vertical quartile:              q1/q2/q3/q4 by document-order rank among resolved targets in the same active scope root
```

`visualBox` cache invalidation:

```text
1. Invalidate all visualBox scores for a scope root when any resolved target is added, removed, changes display/visibility/class/style, or changes size/position.
2. Invalidate on viewport resize, zoom-induced resize events, font loading completion, or full page pass.
3. Do not cache viewport-relative features across scroll if the implementation uses viewport-relative top/bottom. v1 should use document-order quartile to avoid scroll invalidation.
```

#### `nthChild`

Immediate sibling index bucket of the resolved target under its parent:

```text
1, 2, 3-5, 6-10, 11-20, 21+
```

Score is `1.00` for same bucket, `0.50` for adjacent bucket, `0.00` otherwise.

### Reference Selection

| Reference form | Creation-time requirement | Runtime behavior |
|---|---|---|
| `picked` | Picker stores canonical selector if unique, plus fingerprint fallback. | Use stored canonical selector if it resolves uniquely; otherwise use stored fingerprint matching. |
| `selector:<css>` | Must match exactly one element at creation/preview. Multiple matches are parse/preview error unless `reference-selection: first` is explicit. | Re-captured on every full pass. Zero matches pauses rule with `reference-not-found`; multiple matches with `first` use first document-order element and warn. |
| `fingerprint:<id>` | Fingerprint object must exist in rule-list `fingerprints` map. | Match by fingerprint algorithm. Missing fingerprint id is parse error. |

Fingerprint storage:

```yaml
fingerprints:
  fp:550e8400-e29b-41d4-a716-446655440000:
    createdAt: 2026-06-20T00:00:00.000Z
    canonicalSelector: 'article[data-testid="post-container"]'
    weak: false
    features:
      tag: article
      role: article
      id: null
      stableData:
        data-testid: post-container
      stableAria:
        aria-label: promoted
      childSignature: 'h:...'
```

Exact fingerprint comparison:

```text
1. If canonicalSelector exists and resolves to exactly one element under the active scope root, that element is the exact match.
2. Otherwise compute fingerprint features for candidate target.
3. Strong exact match requires all stored non-null identity fields to match exactly: tag, id, stable data keys/values, stable aria keys/values, and role.
4. Child signature may differ by at most one bucket in one count field; otherwise exact match fails.
5. Weak fingerprints require preview and are not activated automatically after migration or re-enable.
6. If a weak fingerprint cannot match during a full pass, the rule remains active but reports `weak-reference-no-match`.
```

Canonical selector construction:

```text
1. Prefer `tag#id` if id exists, CSS-escaped, and unique under active scope root.
2. Else prefer `tag[data-testid="value"]`, `tag[data-test-id="value"]`, `tag[data-qa="value"]`, in that order, if unique.
3. Else prefer `tag[aria-label="value"]` if value length <= 80 and unique.
4. Else prefer a combination of tag + stable data key + role if unique.
5. Else no canonical selector exists; store weak fingerprint and emit `weak-exact-reference`.
```

All selector attribute values must be escaped using the browser-equivalent of `CSS.escape()` for identifiers and string escaping for CSS string attributes. Engines without `CSS.escape()` must use the CSSOM serialization algorithm or reject selector generation with `css-escape-unavailable`.

---

## v8 Text, Tokenization, and Logic Semantics

### Text Normalization

All textual matching and text-length calculations use this pipeline unless a field explicitly says otherwise:

```text
1. Exclude nodes under display:none, visibility:hidden, hidden attribute, inert hidden subtrees, or aria-hidden="true".
2. Include off-screen but visible text.
3. Read rendered text equivalent to `innerText` when affordable; fallback to textContent with visibility filtering.
4. Decode HTML entities through DOM text-node interpretation, not by running a new parser.
5. Unicode normalize to NFKC for comparison and tokenization.
6. Collapse all Unicode whitespace to a single ASCII space.
7. Trim leading/trailing whitespace.
8. Case-fold with `toLocaleLowerCase('und')` or Unicode default case folding.
```

`text-length` is the number of Unicode code points after this normalization. Zero-width joiners and directional marks are ignored for length and tokenization.

### Tokenization

```text
1. Do not remove stop words in v1.
2. Split Latin, Cyrillic, Greek, and similar alphabetic scripts on whitespace and punctuation.
3. Split digits from letters unless the token is an URL-like or data-like identifier.
4. Keep tokens length 2..64 by default; one-character tokens are retained only for CJK and scripts without spaces.
5. For Chinese, Japanese, Thai, and no-whitespace scripts, use Unicode script detection and produce overlapping character bigrams. If text length is 1, use one unigram.
6. Percent-encoded URL tokens are decoded only for token comparison, not for path matching.
```

### Semantic Text

`semantic-text` includes, in order:

```text
1. visible text (`text`)
2. direct `aria-label`
3. direct `aria-description`
4. resolved `aria-labelledby` text, bounded to 10 ids and 1000 chars
5. resolved `aria-describedby` text, bounded to 10 ids and 1000 chars
6. direct `title`
7. descendant image `alt` text, bounded to 20 images and 1000 chars
8. direct `aria-valuetext`
```

`aria-hidden` is never included in `semantic-text` and is excluded from `aria-*` family matching unless explicitly addressed as `attr(aria-hidden)`.

### Field Semantics

| Field | Scope |
|---|---|
| `text` | all visible text under resolved target, descendants included. Same as `all-text`. |
| `own-text` | visible direct text-node children of resolved target only. Descendant element text excluded. |
| `semantic-text` | text plus bounded accessibility labels defined above. |
| `href` | descendant `<a href>` URLs only. `<area href>` and `<link href>` are excluded in v1. |
| `data-*` | direct `data-*` attributes on resolved target only. |
| `aria-*` | direct aria attributes on resolved target only, excluding `aria-hidden` unless explicit. |
| `attr(name)` | direct attribute with exact name on resolved target. |
| `selector matches X` | resolved target itself matches `X`. Descendants are not tested. |
| `has descendant X` | at least one strict descendant matches `X`; the resolved target itself never counts. |
| `has ancestor X` | at least one ancestor of resolved target matches `X`; the target itself never counts. Scope root may count unless logic option `stop-at-scope-for-ancestor: true` is set. |
| `link-density` | `min(linkCharCount / max(text-length, 1), 1.0)` where `linkCharCount` is normalized text length inside descendant `<a href>` elements only. |
| `child-count` | number of immediate child elements. Text, comment, processing-instruction nodes excluded. `<slot>` counts as an element; assigned nodes do not count in v1. `<template>` content does not count. |

### Operators and Case Sensitivity

All non-regex string operators are case-insensitive by default after text normalization:

```text
==, !=, contains, starts-with, ends-with
```

Case-sensitive forms are represented in the normalized AST with `caseSensitive: true`; shorthand syntax may expose this later, but v1 canonical YAML should use structured form for case-sensitive comparisons.

Expression shorthand precedence is:

```text
NOT > AND > OR
```

Logical operator words are case-insensitive: `AND`, `and`, and `And` normalize to `AND`.

### Selector Conditions

`has descendant`, `has ancestor`, and `selector matches` accept a safe selector subset:

```text
Allowed: type selectors, class selectors, id selectors, attribute selectors, descendant/child combinators, :is(), :where(), :not() with <= 8 branches total.
Disallowed in v1: :has(), :host-context(), pseudo-elements (`::before`, `::after`, `::part`, `::slotted`), browser-specific shadow-piercing combinators, and selectors longer than 512 characters.
```

`:scope` must be supported by rewriting the selector into a temporary scoped query when native support is unreliable. If rewriting fails, parse error `scope-selector-unsupported`.

### Shadow DOM and Logic Conditions

When `shadow.mode: none`, selector conditions do not cross shadow roots.

When `shadow.mode: open` or `open-recursive`:

```text
1. `has descendant X` uses engine tree traversal and may enter open shadow roots below the resolved target.
2. Native `element.querySelector(X)` is insufficient for shadow traversal; the engine must implement explicit traversal.
3. `has ancestor X` may cross from a shadow tree to its host only when `shadow.allow-host-ancestor: true`; default is `false` in v1.
4. Closed shadow roots are never traversed.
5. `:host`, `::part`, and `::slotted` are not supported in v1 smart-rule logic selectors. Rules using them are parse error `shadow-selector-unsupported`.
```

---

## v8 Keyword Expansion

`keywords:` is syntactic sugar. After normalization, matching uses only canonical `where:` and `except:` AST conditions.

Canonical keyword object:

```yaml
keywords:
  match-mode: phrase   # phrase | word | regex
  fields:
    - text
    - aria-label
    - href
  include-any:
    - Sponsored Content
    - Promoted
  include-all: []
  exclude-any:
    - official announcement
  exclude-all: []
  case-sensitive: false
  word-boundary: true
keyword-merge: false
```

Keyword expansion algorithm:

```text
1. Validate `match-mode` is present. Missing value is parse error `missing-keyword-match-mode`.
2. Expand each keyword-field pair into one canonical leaf condition.
3. For `include-any`, generate OR across every field-keyword pair.
4. For `include-all`, generate AND across keywords, where each keyword expands to OR across fields.
   Example: include-all [A, B], fields [text, aria-label]
   => all: [ any: [text has A, aria-label has A], any: [text has B, aria-label has B] ]
5. For `exclude-any`, generate OR across every field-keyword pair and merge into `except.any`.
6. For `exclude-all`, generate AND across keywords, each keyword OR across fields, then merge into `except.any` as one grouped condition.
7. De-duplicate identical leaf conditions before counting `min-logic-matches`.
```

Mode mapping:

| `match-mode` | Keyword validation | Generated condition |
|---|---|---|
| `phrase` | keyword may contain spaces | `field contains normalizedPhrase` unless `word-boundary: true`, then bounded phrase regex |
| `word` | keyword must normalize to exactly one token | token-membership condition; `word-boundary` ignored with warning `word-boundary-implicit` |
| `regex` | keyword must be slash-delimited `/.../flags` unless `regex-raw: true` is explicit | `field ~= /.../flags` |

Regex mode with non-slash strings is parse error by default because strings such as `sponsored.` are otherwise surprising wildcards. An editor may offer to escape the string and convert it to phrase mode.

Merge with explicit `where:` / `except:`:

```text
1. If explicit `where` or `except` exists and `keyword-merge` is false, parser emits warning `keywords-ignored-by-explicit-logic` and editor must visually mark the keyword block inactive. Strict mode may reject the rule.
2. If `keyword-merge: true`, merge as:
   where  := all: [ existingWhere, expandedIncludeWhere ]
   except := any: [ existingExcept, expandedExcludeExcept ]
3. Empty sides are omitted. No deep merge is performed.
4. The normalized stored rule must contain the expanded AST and may retain the original keyword block only as authoring metadata.
```

Formal strong logic for threshold lowering:

A smart-hide rule has strong logic only if normalized `where:` contains at least one successful leaf condition of one of these forms:

```text
1. `href` contains, ==, starts-with, ends-with, or regex with pattern length >= 4
2. `aria-label`, `aria-*`, or specific `attr(aria-*)` contains/==/regex with normalized value length >= 4
3. `data-*` or specific `attr(data-*)` contains/==/regex with normalized value length >= 4
4. `selector matches` with an attribute selector, role selector, or stable data selector
5. `has descendant` with an attribute selector involving href, aria, role, or data-* and selector length <= 256
6. `text` phrase mode with normalized phrase length >= 8 and at least two tokens
```

Broad text regex, one-token `text contains`, and very short phrases are not strong logic.

---

## v8 Runtime, Dependency, and Lifecycle Rules

### Evaluation Is Two-Phase

The engine must not apply actions while still evaluating candidates. Runtime uses two phases:

```text
Phase 1: collect raw candidates, resolve targets, evaluate all active rules, record proposed actions.
Phase 2: resolve conflicts per resolved target, then apply winning actions.
```

`remove` actions are applied last in Phase 2 after all non-remove actions have been resolved. This prevents a remove rule from deleting an element before another rule has had a chance to participate in conflict resolution.

### Self-Mutation Suppression

Every action application gets an engine mutation token:

```text
mutationToken = {ruleId, targetId, actionKind, cycleId}
```

When a MutationObserver receives records caused by engine actions:

```text
1. Ignore mutations that only reflect the engine's own marker attributes, injected style nodes, aria-hidden markers, or removal tombstones for the same cycle.
2. Do not re-evaluate a removed target in response to its own removal.
3. If the page re-inserts an equivalent target later, treat it as a new candidate in a later cycle.
4. If engine actions cause 3 consecutive self-triggered cycles with >20% target-set change, pause the rule with `layout-churn-loop`.
```

The churn comparison is computed only when the evaluated candidate set is complete. It is not computed during partial evaluation to avoid expensive false diagnostics.

### Rule Enable / Disable / Delete Lifecycle

| Event | Required behavior |
|---|---|
| Enable rule | If preview required and not confirmed, move to `previewed`/`draft` flow. Otherwise run a full pass. |
| Disable rule | Stop evaluating it immediately; remove its injected styles, markers, aria-hidden markers, and observers if no other active rule owns them. |
| Delete rule | Same as disable, then remove storage and cache entries. |
| Edit rule | Set preview to `stale` if selector/scope/candidate/boundary/match/where/except/action changed. |
| Re-enable confirmed rule | Full pass and cache clear for that rule. Preview not required unless stale. |
| Re-enable never-confirmed generated rule | Preview confirmation required. |

Action effects must be reference-counted by `(target, property/effect, ruleId)` so disabling one rule does not undo another active rule's effect.

Accessibility cleanup:

```text
1. `hide` and hide-like `style(...)` may add engine-owned `aria-hidden="true"`.
2. The original aria-hidden value must be stored per target.
3. On disable/delete/unhide, restore the original value only when no other active engine rule still requires aria-hidden.
4. Never remove a page-authored aria-hidden value that existed before uBR touched the element.
```

### Dependency Extraction and Invalidation

Dependency extraction walks the normalized AST, not the raw authoring syntax.

| Condition | Dependencies |
|---|---|
| `text`, `own-text`, `semantic-text`, `text-length` | childList + characterData under resolved target; attribute changes for hidden/aria-hidden/style/class that affect visibility. |
| `href` | descendant `<a href>` additions/removals/moves and `href` changes. |
| `attr(name)` | direct attribute `name` on resolved target. |
| `data-*` | direct data attribute changes on resolved target. |
| `aria-*` | direct aria attribute changes on resolved target, excluding `aria-hidden` unless explicit. |
| `has descendant X` | subtree additions/removals/moves and attributes used by selector `X` within dependency depth; optional prefilter. |
| `has ancestor X` | ancestor additions/removals/moves and attributes used by selector `X` up to scope root or host boundary according to shadow settings. |
| `selector matches X` | direct attributes/classes/id used by selector `X` on resolved target. |

`dependency-depth` controls upward invalidation from a changed node to candidate ancestors:

```text
dependency-depth: 0 -> changed node only
dependency-depth: 3 -> changed node plus up to 3 element ancestors
```

If a `has descendant` selector can match below the configured depth, missed invalidations are possible. Therefore, if `dependency-depth` is finite and selector `X` has no cheap prefilter, emit warning `dependency-depth-may-miss-descendant`. Picker-generated rules should use selectors with cheap prefilters.

Dependency prefilter algorithm:

```text
1. Extract cheap selector requirements from X: tag names, id, class names, direct attribute names, role, href, data-*.
2. For an added/moved node, test the node and its descendants up to `dependency-depth` for those cheap requirements.
3. If none can satisfy the prefilter, do not invalidate ancestor candidates.
4. If selector contains unsupported expensive pseudo-classes, reject it before runtime.
```

For added nodes:

```text
1. Count raw added DOM nodes before filtering for `max-added-nodes-per-cycle`.
2. Walk each added subtree until the raw-node cap is reached.
3. Collect new candidates inside the subtree.
4. Also collect existing candidate ancestors up to dependency-depth if a descendant dependency could have changed.
5. If the cap is exceeded, defer remaining added nodes to the next cycle and set rule/document state `partial`.
```

Removal and move invalidation:

```text
1. A removed descendant that previously contributed to text, href, semantic-text, or has-descendant logic invalidates the nearest cached resolved target and candidate ancestors within dependency-depth.
2. A moved node is treated as removal from old parent and addition to new parent.
3. If an ancestor satisfying `has ancestor` is removed or moved, descendants under the affected subtree are invalidated up to the nearest active scope root.
```

### Candidate Caps and Partial Evaluation

`max-candidates` and `max-evaluations-per-cycle` never mean skipped candidates are non-matches.

```text
1. Initial full pass builds the complete candidate list if affordable.
2. If candidate count exceeds `max-candidates`, evaluate the first N in document order and queue the rest.
3. State becomes `partial` until queued candidates have been evaluated.
4. Safety decisions that require full-page denominators, especially `max-page-percent`, are `unknown` during partial evaluation.
5. A hide-like action may be applied to evaluated positive matches only if `safety.allow-partial-apply: true`; default is false for generated rules.
6. If partial state persists for 5 consecutive cycles or 3 seconds of active page time, pause the rule with `candidate-budget-exceeded`.
```

`max-evaluations-per-cycle` exceeded behavior:

```text
1. Stop the current cycle for that rule.
2. Preserve queued remaining candidates.
3. Do not clear already computed matches unless the cycle is abandoned by error policy.
4. Resume on the next debounce cycle unless the repeated-budget rule pauses it.
```

### Regex Safety

JavaScript regex execution cannot be interrupted safely inside a single synchronous `RegExp` call. Therefore v1 uses static restrictions plus cumulative budgets.

Regex literals are JavaScript-compatible with supported flags:

```text
Supported: i, g, m, u, s
Rejected: y, d, duplicate flags, unknown flags
```

Static regex rejection:

```text
1. pattern length > max-regex-pattern-length
2. nested quantified groups likely to backtrack catastrophically, such as (a+)+, (.*)+, (\w+)*
3. backreferences
4. lookbehind
5. more than 50 alternation branches
6. unbounded dot-star before another unbounded repeat, such as .*.* or .+.*
```

Engines may offer Worker-based regex evaluation for advanced rules, but syntax v1 conformance cannot require interruptible regex. If the engine cannot guarantee a single-regex timeout, it must label `max-regex-ms-per-rule-cycle` as cumulative-only in diagnostics.

### SPA Path and Page Lifecycle

Path changes must be observed by:

```text
1. wrapping history.pushState and history.replaceState at document_start when possible;
2. listening to popstate and hashchange;
3. checking URL at each debounced mutation cycle as fallback.
```

On path change:

```text
1. Recompute target/path match status for every rule in the affected document/frame.
2. If status changes from non-match to match, run full pass.
3. If status changes from match to non-match, remove engine-owned effects for that rule and clear its page-session cache.
4. If status remains match but scope roots are removed/recreated or route generation changes, run full pass.
5. If content changes without URL change, normal mutation handling applies.
```

A page session begins at document creation and ends at page unload, cross-origin navigation, or frame destruction. Same-origin SPA navigation keeps the page session but clears affected rule caches when target/path or scope generation changes.

Scope-root teardown:

```text
1. If all scope roots for a rule are removed, state becomes `awaiting-scope`.
2. Remove engine-owned effects under removed roots as far as references remain connected.
3. Disconnect observers tied only to removed roots.
4. When a matching scope root appears again, clear rule cache and run full pass.
```

### Frames

Frame modes:

| Mode | Meaning |
|---|---|
| `top-only` | Evaluate only the top document. Default. |
| `same-origin` | Evaluate top document plus accessible frames whose origin is same-origin with the top document. |
| `accessible` | Evaluate top document plus frames where the extension content script is active and can report frame URL. |

`same-origin` does not guarantee injection. If a same-origin frame is sandboxed, `about:blank`, extension-blocked, or otherwise inaccessible, the frame is skipped with diagnostic `frame-inaccessible`.

For cross-origin accessible frames, the content script in the frame must report its own `location.href` to the extension runtime. The parent document must not guess cross-origin frame URLs from DOM attributes.

Frame accounting:

```text
per-frame:
  each frame has separate candidate caps, match caps, page-percent caps, cache, and observers.
aggregate:
  top document and accessible frames share `max-total-matches` and aggregate safety counters.
```

Aggregate denominator for `max-page-percent` is:

```text
total unique resolved targets across all evaluated accessible frames / total unique possible resolved targets across all evaluated accessible frames
```

If any frame is partial, aggregate page-percent is `unknown` and hide-like actions are blocked unless `allow-partial-apply: true`.

Frame removal disconnects observers and clears caches for that frame. Frame re-addition is treated as a new page session for that frame.

### Shadow DOM

Shadow modes:

| Mode | Meaning |
|---|---|
| `none` | Do not traverse shadow roots. Default. |
| `open` | Traverse open shadow roots directly under discovered hosts. |
| `open-recursive` | Traverse open shadow roots recursively. |

Dynamic open shadow-root discovery is only reliable if the engine hooks `Element.prototype.attachShadow` at document_start. If hooking is unavailable, the engine may discover existing open roots during scans but must emit `partial-shadow-discovery` for rules using shadow traversal.

Shadow observation:

```text
1. Existing open roots found during scope discovery are observed when `shadow.observe-mutations: true`.
2. New open roots attached through hooked `attachShadow` are scheduled for debounced scope discovery.
3. Removed shadow hosts disconnect observers for their shadow roots.
4. Shadow traversal counts against per-rule candidate/evaluation budgets globally across all traversed roots in the current frame.
5. `open-recursive` also has `shadow.max-roots-per-cycle`, default 20. Excess roots are deferred.
```

Shadow scope discovery:

```text
1. Evaluate scope selectors in the light DOM.
2. If shadow traversal is enabled, evaluate scope selectors inside each discovered open shadow root.
3. A shadow root itself is not a scope root; elements inside it may be scope roots.
4. Candidate selectors inside a shadow root are evaluated relative to that root.
```

---

## v8 Safety, Preview, and Confidence

### Preview Required Semantics

If `safety.preview: required`, saving as active without confirmed preview is blocked. The editor should auto-start preview, but it must not silently activate the rule.

Preview uses the same evaluator as active mode. Preview may relax display caps only if the UI labels the relaxed value and stores `preview.relaxedCapsUsed: true`. Preview must not relax parser validation, unsafe regex rejection, action validation, or selector safety.

Preview confirmation hash:

```text
confirmationHash = sha256(canonicalNormalizedRuleWithoutPreviewState + engineMajorSyntaxVersion)
```

If the hash changes, preview status becomes `stale`.

### Confidence Buckets

Similarity mode:

```text
invalid score or min-features not met -> `insufficient-features`
score >= threshold + 0.08 -> high
threshold <= score < threshold + 0.08 -> medium
max(0.65, threshold - 0.08) <= score < threshold -> borderline
score < max(0.65, threshold - 0.08) -> no match
```

If threshold is below `0.65`, borderline lower bound is `threshold - 0.08`, not `0.65`. The `0.65` floor applies only to default-card and structural-heavy presets; content-heavy may use lower borderline bounds for text-rich rules.

Content-only mode:

```text
logic-high:
  min-logic-matches met and at least one formal strong-logic leaf succeeds
logic-medium:
  min-logic-matches met with phrase/word text conditions of normalized length >= 8
logic-borderline:
  min-logic-matches met only by short text, broad contains, or broad regex
logic-failed:
  min-logic-matches not met or except logic matched
```

### Safety Calculations

`max-page-percent` is exact only after a complete pass.

```text
maxPagePercent = matchedUniqueResolvedTargets / totalUniqueResolvedTargetsWithinScope * 100
```

If denominator is `0`, the value is `0` and no page-percent stop is triggered.

If candidate evaluation is partial, page-percent is `unknown`. Generated rules must not apply hide-like actions under unknown page-percent unless `allow-partial-apply: true` and preview confirmed this behavior.

`max-viewport-area-percent` is:

```text
max single resolved target area / viewport area * 100
```

It is checked before applying action and rechecked on full pass, resize, zoom-induced viewport change, and geometry invalidation. For multiple matched targets, engines may also expose `sum-viewport-area-percent`, but v1 safety uses maximum single target area.

If a target is disconnected or display:none before uBR action, its area is unavailable; do not treat it as safely small. Mark area as unknown and block scope-root/page-root targeting unless preview explicitly confirms.

### Content-Only Validation

`min-logic-matches` counts canonical leaf conditions that evaluate true after keyword expansion and deduplication. Nested `all`/`any` groups do not count as leaves.

If `where` is absent or empty:

```text
1. leaf count is 0.
2. default `min-logic-matches: 1` causes the rule to match nothing.
3. Parser emits warning `content-rule-has-no-where`.
4. To intentionally match all candidates, user must set `min-logic-matches: 0`, `allow-broad: true`, and preview is required.
```

`except` conditions count against regex and evaluation budgets exactly like `where` conditions.

---

## v8 Actions, Styles, Accessibility, and Conflict Resolution

### Action Families

| Family | Actions | Conflict behavior |
|---|---|---|
| allow-like | `unhide` from `smart-allow` | Blocks smart hide-like actions for the target. Does not block non-hide decorative actions. |
| hide-like | `hide`, `collapse`, `remove`, hide-like `style(...)` | Resolved by class, priority, specificity, action strength. |
| decorative | `mark`, non-hide `style(...)` | May coexist with allow and hide decisions only when it does not change visibility/interactivity. |

A `style(...)` is hide-like if any declaration is hide-like. If one declaration is hide-like, the whole style action is hide-like.

Hide-like declarations:

```text
display: none
visibility: hidden | collapse
opacity <= 0.05
filter: opacity(0) or opacity value <= 0.05
pointer-events: none combined with opacity <= 0.20
```

Non-hide `style(...)` actions from multiple winning decorative rules are merged if properties are disjoint. If two decorative rules set the same property, resolve by priority, specificity, createdAt, then id. Decorative styles must never override a winning hide-like action's visibility properties.

`display: revert`, `visibility: visible`, or opacity-increasing styles are restorative and are not allowed in `smart-hide`. They are allowed only in the external compatibility layer and are non-normative for v1 conformance.

### Conflict Resolution Clarification

For each resolved target:

```text
1. Evaluate all active rules without applying actions.
2. If any smart-allow rule matches, block all smart hide-like actions for that target.
3. External classic filter-list effects are not part of the smart resolver.
4. For remaining hide-like smart actions, choose the winning conflict class.
5. Within that class, choose highest priority.
6. Within priority, choose highest specificity.
7. Within specificity, choose strongest action: remove > collapse > hide > hide-like style > mark.
8. If still tied, choose newest `createdAt`; if tied, lexical id order.
```

Priority among allow rules is irrelevant for blocking hide-like actions: one matching allow is enough.

Class B includes both `hide-exact` and smart rules using `match.mode: exact` when they have a valid exact reference. Otherwise they remain in their normal class.

### Style Whitelist

`style(...)` accepts only these properties in syntax v1:

```text
display: none | block | inline | inline-block | flex | grid | revert
visibility: hidden | visible | collapse
opacity: numeric 0..1
outline, outline-color, outline-style, outline-width, outline-offset
border, border-color, border-style, border-width
background-color: simple CSS color only; no url(), image(), var() with url
color: simple CSS color only
filter: blur(), brightness(), contrast(), grayscale(), hue-rotate(), invert(), opacity(), saturate(), sepia(); no url()
pointer-events: none | auto
```

Forbidden:

```text
position, transform, clip-path, margin, padding, width, height, z-index, content,
background-image, list-style-image, cursor:url(), mask, -webkit-mask, behavior,
expression(), any url(), custom properties that contain url-like values
```

Malformed declarations, comments inside style payload, unknown properties, duplicate properties, and unsafe functions are parse errors. Extra semicolons are ignored.

Canonical style syntax:

```yaml
action: 'style("opacity: 0.3; outline: 2px solid currentColor;")'
actionOptions:
  important: true
```

`actionOptions.important` applies only to `style(...)`. Built-in `hide`, `collapse`, and engine-owned accessibility styles always use `!important` where needed. Supplying `important` with built-in actions emits warning `important-ignored-for-built-in-action`.

`mark` action:

```text
1. `mark` is decorative only and must never include hide-like declarations.
2. Default mark style: outline: 2px solid currentColor; outline-offset: 2px.
3. If currentColor is transparent, engine uses a visible fallback outline color chosen by UI theme.
4. Multiple mark rules may stack by adding rule-specific data attributes and a combined outline/overlay. They must not change layout or accessibility exposure.
```

### External Classic Filter Compatibility

Classic filters have two modes:

```text
smart-normalized classic imports:
  represented inside uBR normalized schema and participate in conflict classes.

external subscribed filter-list effects:
  executed by the existing cosmetic engine and outside the smart resolver.
```

`smart-allow` is normative only against smart rules and smart-normalized classic imports. Against external subscribed filters, restoration is best-effort and non-normative for v1 conformance. If a classic external filter removed a node, `unhide` does nothing and logs `external-remove-not-restorable`. If a classic external filter used ordinary CSS hiding, compatibility may inject a restoring style, but flicker is possible and must be labeled in diagnostics.

Reference-counting is required for internal smart effects. External effects may not be reference-countable.

---

## v8 Import, Export, Migration, and Classic Mapping

### Classic Cosmetic Normalized Schema

A classic cosmetic filter imported into smart-normalized mode is stored as:

```yaml
id: ubr:classic:0123456789abcdef
state: active
metadata:
  source: import
  sourceKind: classic-cosmetic
  originalText: 'example.com##.ad'
  fullHash: sha256:...
classic-cosmetic:
  syntax-version: 1
  targets:
    - domain:example.com
  paths: []
  selector: '.ad'
  exception: false
  action: hide
  scope:
    - document
```

Classic exception filter `#@#` imports as `exception: true` and may be represented as a `smart-allow` only when the selector can be expressed as a direct target selector with no semantic loss. Otherwise it remains `classic-cosmetic` with exception semantics.

Editing an imported classic rule does not automatically upgrade it to a smart rule. The editor must ask for conversion. If converted, generated smart fields are:

```text
rule type: smart-hide or smart-allow depending on exception
scope: document unless user chooses narrower scope
candidates: selector if safe, otherwise parse warning and manual selection required
boundary: exact
match.mode: none
where: omitted
```

Conversion requires preview.

### Smart-Allow Export

`smart-allow` exports to classic exception format only if all of these are true:

```text
1. action is `unhide`;
2. boundary is `exact` or selector-equivalent;
3. match.mode is `none`;
4. where/except/keywords are absent;
5. candidates can compile to one CSS selector;
6. target/path can be represented by classic filter syntax.
```

Otherwise export status is `partial`, `approximate`, or `not-possible`, never silent.

### Export Metadata

Human-readable comment:

```text
! uBR-smart-export: approximate
```

Machine-readable single-line comment:

```text
! uBR-smart-export-meta: {"status":"approximate","ruleId":"ubr:smart:...","lost":["similarity","boundary","where"]}
```

The JSON comment must be one physical line, UTF-8, no line breaks. If the target list format cannot preserve comments, write a sidecar file:

```text
<export-file-name>.ubr-smart-meta.json
```

Sidecar schema:

```json
{
  "format": "ubr-smart-export-meta",
  "version": 1,
  "sourceFile": "filters.txt",
  "records": [
    {
      "line": 42,
      "ruleId": "ubr:smart:...",
      "status": "approximate",
      "lost": ["similarity", "boundary"]
    }
  ]
}
```

### Syntax Version Compatibility

Container `syntax-version` describes the list format. Rule `syntax-version` describes each rule body. A syntax-version 1 list may contain only syntax-version 1 rules. A future syntax-version 2 list may contain syntax-version 1 rules if the engine declares backward compatibility.

If an engine supports `minimum-compatible-version: 1` and `maximum-supported-version: 1`:

```text
rule syntax-version < 1 -> attempt migration; if impossible, state error `unsupported-old-syntax`
rule syntax-version = 1 -> load normally
rule syntax-version > 1 -> do not evaluate; preserve for export; state error `unsupported-new-syntax`
```

Migration may be automatic only when semantics are lossless. Lossy migration requires user confirmation and preview.

---

## v8 Formal Grammar Additions

The v1 grammar must include these fields in addition to the earlier grammar.

```text
ruleListDocument := 'ubr-smart-rules:' newline indent listBody
listBody        := syntaxVersion newline
                   listId newline
                   title? newline
                   createdAt? newline
                   updatedAt? newline
                   engineCompat? newline
                   fingerprintsBlock? newline
                   'rules:' newline indent ruleEntry+

listId          := 'list-id:' string
title           := 'title:' string
engineCompat    := 'engine:' newline indent
                   'minimum-compatible-version:' integer newline
                   'maximum-supported-version:' integer

ruleEntry       := '- id:' ruleId newline
                   orderIndex? newline
                   state? newline
                   previewState? newline
                   metadataBlock? newline
                   ruleDocument

state           := 'state:' ('draft'|'previewed'|'active'|'disabled'|'error'|'awaiting-scope'|'partial'|'paused')
orderIndex      := 'orderIndex:' integer
previewState    := 'preview:' newline indent previewBody

previewBody     := 'status:' ('none'|'required'|'previewed'|'confirmed'|'stale'|'forced-by-policy') newline
                   confirmedAt? newline
                   confirmationHash? newline
                   relaxedCapsUsed?

performanceObject :=
  'max-candidates:' integer newline
  'max-evaluations-per-cycle:' integer newline
  'max-added-nodes-per-cycle:' integer newline
  'max-regex-ms-per-rule-cycle:' integer newline
  'max-regex-pattern-length:' integer newline
  'max-text-regex-input-chars:' integer newline
  'debounce-ms:' integer newline
  'dependency-depth:' integer newline
  'dependency-prefilter:' boolean newline
  'prefer-css-prefilter:' boolean

safetyObject :=
  'preview:' ('required'|'recommended'|'optional'|'skip') newline
  'max-matches:' integer newline
  'max-page-percent:' number newline
  'max-viewport-area-percent:' number newline
  'min-features:' integer newline
  'min-logic-matches:' integer newline
  'allow-partial-apply:' boolean newline
  'warn-if-scope-is-body:' boolean newline
  'warn-if-no-where-logic:' boolean newline
  'warn-if-action-remove:' boolean newline
  'warn-if-weak-exact-reference:' boolean

framesObject :=
  'mode:' ('top-only'|'same-origin'|'accessible') newline
  'accounting:' ('per-frame'|'aggregate') newline
  'max-total-matches:' integer

shadowObject :=
  'mode:' ('none'|'open'|'open-recursive') newline
  'observe-mutations:' boolean newline
  'observe-recursive:' boolean newline
  'max-roots-per-cycle:' integer newline
  'allow-host-ancestor:' boolean

cacheObject :=
  'max-entries:' integer newline
  'max-age-ms:' integer newline
  'eviction-policy:' ('LRU') newline
  'scope:' ('per-page'|'per-rule')

actionOptionsObject :=
  'important:' boolean
```

Validation not expressible in the grammar is still normative through the parser validation matrix.

---

## v8 Expensive Selector and Procedural Export Policy

CSS/procedural compilation is an optimization, not the source of truth.

Compilation targets:

| Smart condition | Lossless procedural export possible? | Notes |
|---|---:|---|
| `text contains phrase` | partial | Text normalization may differ from procedural `:has-text`. Mark partial unless equivalent normalization is guaranteed. |
| `has descendant safeSelector` | yes if selector subset is supported | Reject expensive `:has()` nesting. |
| `href contains` | partial | Can compile to attribute selector only for simple substring cases. |
| `data-*` family match | no | Must expand to known data attrs or mark approximate. |
| `similar` / `structural` | no | Smart runtime only. |
| boundary modes other than exact/selector | no | Smart runtime only. |

Cost rule for CSS prefilters:

```text
1. Prefer CSS prefilter when selector is in safe subset and estimated match count <= max-candidates * 2 during preview.
2. If CSS prefilter compilation fails, fall back to full smart runtime and emit `css-prefilter-failed`.
3. Do not deactivate the rule solely because prefilter compilation failed.
4. Reject prefilters containing unsupported pseudo-elements or unsafe pseudo-classes.
```

---

## v8 Diagnostics and Error Levels

| Level | Meaning | Runtime effect |
|---|---|---|
| `info` | Useful detail; no action required. | Rule may activate. |
| `warning` | User should review. | Rule may activate unless policy blocks. |
| `error` | Invalid or unsafe. | Rule cannot activate. |
| `paused` | Runtime safety stop. | Rule remains stored but does not evaluate until user or engine resumes. |

Common parse errors:

```text
missing-scope
missing-candidates
missing-boundary
missing-match-reference
threshold-not-valid-for-mode-none
custom-weights-not-supported-v1
catch-all-allow
invalid-boundary-depth
invalid-rule-action-combination
unsafe-regex
unsupported-shadow-selector
unsupported-new-syntax
```

Warnings:

```text
broad-exact-scope
weak-exact-reference
keywords-ignored-by-explicit-logic
dependency-depth-may-miss-descendant
scope-root-too-large
selector-boundary-not-found
boundary-low-confidence
regex-input-truncated
frame-inaccessible
partial-shadow-discovery
candidate-budget-exceeded
external-remove-not-restorable
```

Warnings must be surfaced in the rule editor, not only in developer logs. A warning should include a recommended user action where possible.

---

## v8 Conformance Test Requirements

A conforming implementation must include fixtures for these categories before the engine is considered production-ready:

```text
1. parser validation matrix, including invalid rule/action combinations
2. target/path matching, including percent-encoded paths and IP literals
3. scope-root de-duplication and nearest-scope selection
4. boundary fallback and scope-root sentinel behavior
5. repeated sibling signature buckets and boundary scoring
6. similarity score fixtures for default-card, structural-heavy, and content-heavy
7. text tokenization fixtures, including punctuation and CJK/no-whitespace text
8. keyword expansion fixtures for include-any/include-all/exclude-any/exclude-all
9. shadow traversal fixtures for none/open/open-recursive
10. frame accounting fixtures for per-frame and aggregate modes
11. mutation suppression after hide/collapse/remove
12. enable/disable cleanup of styles and aria-hidden markers
13. max-candidates partial evaluation and safety unknown behavior
14. regex rejection fixtures for unsafe patterns
15. import/export loss metadata and classic exception conversion
16. conflict resolution fixtures for allow, exact, smart, classic-normalized, decorative style, and remove
17. accessibility cleanup and reference-counting fixtures
18. SPA path-change lifecycle and scope teardown fixtures
```

Each fixture should contain:

```text
- input rule document
- input DOM or serialized fixture
- optional mutation sequence
- expected raw candidates
- expected resolved targets
- expected match/exclusion result
- expected applied action after conflict resolution
- expected diagnostics
```

---

## v8 Explicitly Deferred from Syntax Version 1

These features are intentionally not part of v1 and must not be implied by the syntax:

```text
1. user-defined custom similarity weight objects
2. arbitrary shadow-piercing selectors, `::part`, `::slotted`, `:host-context`
3. cross-engine guaranteed restoration of external subscribed filter-list removals
4. exact-match-with-logic picker flow
5. rule supersedes/overrides composition model
6. rule templates, reusable snippets, and parameterized rules
7. multi-device sync, conflict resolution across synced devices, and shared reputation
8. automated rule suggestions or ML classifiers
9. interruptible regex without Worker-based execution
10. guaranteed exact visualBox compatibility across different browser layout engines
```

If any of these are present in imported data, preserve them as unsupported metadata and do not evaluate them under syntax version 1.

---

## v8 Final Implementation Principle

A v1 implementation should prefer conservative parse errors and explicit warnings over permissive interpretation. If a rule cannot be evaluated with the specified semantics, it should enter `error`, `paused`, `partial`, or `awaiting-scope` state rather than silently matching more or less than the author intended.
