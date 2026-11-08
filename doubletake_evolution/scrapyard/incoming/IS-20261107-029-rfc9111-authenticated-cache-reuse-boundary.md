# IS-20261107-029 — Authenticated HTTP cache reuse and principal isolation

Status: PUBLIC RESEARCH CANDIDATE / UNTRIAGED / NOT IMPLEMENTED. Current private DT parity: **UNKNOWN**.

## Primary authoritative source and rights
IETF RFC 9111, *HTTP Caching*, Internet Standard STD 98, June 2022: https://www.rfc-editor.org/rfc/rfc9111 . Read original Sections 2, 3, 3.5, 4, 4.1 and 4.2 (2026-11-07). Copyright 2022 IETF Trust and authors; IETF Trust Legal Provisions apply, extracted code components require Revised BSD License text. No source code, figures or substantial text copied. No assumption that DT uses HTTP shared caching.

## Distinct source-grounded mechanism
RFC 9111 §3.5 prohibits shared-cache reuse of responses to requests carrying Authorization unless explicit response cache directives permit it and their requirements are satisfied; §4 requires URI/method/Vary matching and appropriate freshness/validation; §4.1 makes Vary:* never match. A cache's RFC-compliant reuse permission does **not** establish the application's own authorization to disclose or consume data for another principal. In particular, a cache key based only on URI can miss application-specific tenant, principal, policy or tool-context isolation when a response is otherwise cacheable.

**Falsifiable DT hypothesis, not a defect claim:** If a future authorized DT HTTP capability/retrieval consumer caches external tool results, its response reuse may require separate (a) RFC 9111 cacheability/selection/validation and (b) current consumer/principal/tenant/permission authorization. Hypothetical integration: existing governed capability retrieval or HTTP tool-result cache, if one exists; never add a new cache just to satisfy this candidate.

## Disposable positive and negative controls (future user-authorized evaluation only)
P1: same authorized principal, identical request and valid freshness/variant, cache reuse permitted by both HTTP and application policy.
P2: permitted shared-cache response with explicit public directive, same variant, and independently authorized second consumer; no blanket prohibition on legal sharing.
N1: two principals same URI but distinct confidential results: second principal must not receive first principal's protected response, even when URL matches.
N2: Authorization-bearing request with no shared-cache-enabling directive: no shared reuse.
N3: Vary-selected header differs, or Vary:*: no unvalidated reuse.
N4: stale response without applicable stale allowance or successful validation: no reuse.
N5: principal permission revoked after cache insertion: existing cached response must not bypass current application authorization.
N6: attacker-controlled response metadata or untrusted tool text attempts to grant permissions: no policy elevation.

Measure wrong-principal disclosures (zero), false cache hits, legitimate hits, validation behavior and latency; use mock data only. Distinguish HTTP cache compliance from application policy and from freshness of underlying external facts.

## Dedup and limits
Checked public INDEX.md blob 1b769d7141758fab7af2acf0212387b50e342d32, README blob db6dc7b49ef87185e93ea203251acb9e7c1c2302 and incoming inventory shard blob 9dbed338a064a781d93218432ca85181d45f6ff3. Read DT-IP-0001 (blob e74d5a091f7f2309cdfe04e6275a212f9c5de9e8), DT-IP-0005 (e24e494ed1069d6b257902f0a23dbfed9664f03c), DT-IP-0013 (8d7718abd4de129cac4f3989e29a6f89a167c5ff). Existing DT-IP-0001 already covers policy-revision-sensitive capability/projection caches and revocation, but not the specific RFC 9111 authenticated HTTP response reuse / Vary / shared-cache rules. Public repo keyword searches for RFC 9111, Vary and shared cache returned no results (not proof of absence). Remaining clustered sources and all other prompt bodies not exhaustively read: Scrapyard Scout/Transformer must independently verify before promotion. Avoid duplicate prompts if covered elsewhere.

## Boundary and future preflight
No private DT access, tests, patches, execution, tickets, or authority to implement. Future explicitly authorized coder first checks actual HTTP caching consumer, owners, policy, permissions and parity; exit ALREADY_PRESENT or NO_CURRENT_CONSUMER where appropriate. No credentials, real user data, external write side effects or third-party code reuse. RFC 9111 is not a blanket mandate to build a cache. Current DT implementation parity: **UNKNOWN**.
