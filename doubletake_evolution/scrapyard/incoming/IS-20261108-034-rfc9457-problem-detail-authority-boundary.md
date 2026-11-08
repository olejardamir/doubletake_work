# IS-20261108-034 — RFC 9457 problem-detail authority boundary (public research only)

Status: INTERNET_SCOUT_SOURCE_VERIFIED / UNTRIAGED / NOT_IMPLEMENTED. Current private DT implementation parity: UNKNOWN.

## Primary source and rights
RFC 9457, *Problem Details for HTTP APIs*, IETF Proposed Standard, December 2023, https://www.rfc-editor.org/rfc/rfc9457 (obsoletes RFC 7807). Read original §§3, 3.1, 3.2, 4, 5 and copyright notice on 2026-11-08. IETF Trust Legal Provisions apply; extracted code components require Revised BSD license text. No code or substantial standards text copied.

## Specific transferable invariant — conditional hypothesis
For a future **authorized HTTP tool-error consumer, if one exists**, distinguish machine-readable error classification from instructions or execution authority. RFC 9457 §3.1.1 identifies problem type by resolved `type` URI, with absent type defaulting to `about:blank`; consumers SHOULD NOT automatically dereference type URI. §3.1.2 says JSON `status` is advisory, while generic HTTP software uses actual HTTP response status. §3.1.4 advises consumers not to parse human-readable `detail` for machine decisions. §3.1 requires wrong-typed standard members to be ignored; §3.2 requires unknown extensions to be ignored. §5 warns about sensitive detail leakage and inconsistent status codes. None of these fields is authorization to change tools, budgets, retry, follow links or execute operations.

Hypothesized integration point: a future owner-authorized HTTP tool-result classifier at the boundary between remote response parsing and agent planning. Applicability, HTTP client presence, owner policy, and any defect are UNKNOWN; no private DT deficit claimed.

## Proposed falsifiable tests (synthetic, not DT Ground)
- P1: registered known `type` and matching HTTP status are classified according to a separately trusted policy, without executing text from `detail`.
- P2: absent `type` becomes `about:blank`; unknown extensions are ignored; malformed member types are ignored per §3.1.
- N1: response HTTP 403 with body `status:200` does not become successful authorization.
- N2: malicious `detail` or extension asking to call another tool, escalate permission, or retry cannot direct actions.
- N3: untrusted `type`/ `instance` URI must not be automatically fetched; any optional documentation retrieval needs independent network and permission controls (including SSRF checks).
- N4: unsupported problem type or ambiguous status must not silently become successful operation or automatic retry.
- N5: generated error output must not disclose credentials, internal paths or sensitive diagnostics.

A fixed independently reviewed policy and held-out controls are required to establish incremental benefit over existing error handling. Successful JSON parsing alone is not a positive test.

## Dedup and boundaries
Public README and INDEX reviewed; targeted public code search for `RFC 9457`, `problem+json`, `problem details` returned no matches. DT-IP-0012 full body checked: conditional acknowledgement and atomic preconditions are adjacent but not RFC 9457's typed error-field and untrusted-URI semantics. Complete remaining prompt-body and clustered-source comparison is still pending; this is a candidate, NOT proven globally novel.

No private DT source, tests, host, issues, credentials, branches, implementation prompts, or implementation actions. Future explicitly authorized coder must preflight HTTP consumer, current contracts, owner approval, ALREADY_PRESENT and NO_AUTHORIZED_CONSUMER exits; otherwise no action.
