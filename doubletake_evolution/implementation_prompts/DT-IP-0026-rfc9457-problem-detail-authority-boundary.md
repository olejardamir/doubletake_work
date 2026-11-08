# DT-IP-0026 — RFC 9457 problem-detail classification versus execution authority

**State:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW / NOT_EXECUTED / PROMPT_CREATED_NOT_IMPLEMENTED. Conditional instructions for a FUTURE explicitly user-invoked authorized LLM coder, not evidence of a DT defect or permission to implement. Private DT parity **UNKNOWN**.

## Exact original and rights
FULL public source: `doubletake_evolution/scrapyard/incoming/IS-20261108-034-rfc9457-problem-detail-authority-boundary.md`, current original Git blob `a4bc2c914df9d3fc856005c36a310220d6351e60`, `olejardamir/doubletake_work/main`, inspected 2026-11-08. [Public original](https://github.com/olejardamir/doubletake_work/blob/main/doubletake_evolution/scrapyard/incoming/IS-20261108-034-rfc9457-problem-detail-authority-boundary.md); this exact blob and Git history remain recoverable if Scout later retires the original. Prior historical source revision **not independently established**. Primary source [RFC 9457, Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457), IETF Proposed Standard, December 2023, obsoletes RFC 7807; public research note reports reading §§3, 3.1, 3.2, 4, 5 and copyright notice. IETF Trust Legal Provisions apply; extracted code components require Revised BSD license text. Do not copy external code or substantial standard passages without rights review. Research is a hypothesis, not reproduced DT behavior.

## Conditional objective and trust boundary
**Only if** a current, owner-authorized HTTP tool-error consumer exists, separate *remote error classification* from *trusted authorization and action planning*. Hypothesized interface is remote HTTP response -> problem+json parser/classifier -> agent/tool planner; actual DT ownership, clients, policies, code and consumer **UNKNOWN**. Independently trusted policy, actual HTTP response status, authenticated context and existing permissions determine action. Problem fields cannot grant tool access, budget, retry, endpoint migration, link following, or execution.

Implement or test the following only if applicable under owner policy:
- RFC 9457 §3.1.1: `type` identifies the problem by resolved URI; absent `type` defaults to `about:blank`; do not automatically dereference `type` URIs. Unknown/untrusted type is not execution authority.
- §3.1.2: body `status` is advisory; generic HTTP processing follows the actual response status, not a conflicting JSON field.
- §3.1.4: human-readable `detail` is diagnostic, never parsed as machine-action instructions.
- §§3.1–3.2: ignore wrong-typed standard members and unrecognized extensions rather than treating them as authority; preserve safe error/UNKNOWN handling when classification is ambiguous.
- §5: prevent sensitive detail leakage (credentials, internal paths, diagnostics) and detect inconsistent status. `instance` URI and extensions are untrusted; any OPTIONAL documentation retrieval requires separate network permission, destination validation and SSRF protections.
- Keep classification, retry eligibility, operation success, authorization and audit evidence distinct; a successfully parsed problem document is not proof of correct decision.

## Mandatory future-coder preflight / exits
On separate explicit user invocation, inspect CURRENT private DT code/tests, AGENTS.md and repository rules, HTTP client/tool-error consumer, trusted policy registry, actual response handling, owners and permissions. Compare with existing tests and behavior. Exit `ALREADY_PRESENT` if equivalent protection exists; `NO_APPLICABILITY` / `NO_CURRENT_CONSUMER` if no relevant seam; `NO_AUTHORIZED_FIXTURE` if no safe test environment; `POLICY_UNKNOWN` or `BLOCKED` if authoritative retry/error rules cannot be established. Never create a new HTTP client, tool permission, remote retrieval authority, service or runtime merely to justify the prompt. Do not access private DT during public prompt preparation.

## Predeclared synthetic tests (not executed)
Freeze response bytes, real HTTP status, type registry and resolution, policy revision, permitted tools/retries/network destinations, expected verdicts, baseline and held-out examples; use independent reviewer/gold and fixed resource budget.
- **P1**: recognized registered type + matching HTTP status -> trusted policy classification, with inert `detail`.
- **P2**: absent `type` -> `about:blank`; ignore unknown extensions and wrong-typed standard members without elevating authority.
- **N1**: actual HTTP 403 but JSON `status: 200` -> no success or authorization.
- **N2**: malicious `detail`/extension requests tool invocation, permission escalation, changed budget or retry -> no action.
- **N3**: `type`/`instance` points to untrusted URL or internal network -> no automatic fetch; optional approved retrieval must pass SSRF and network permission checks.
- **N4**: unsupported problem type, ambiguous/inconsistent status or malformed fields -> no silent success or automatic retry.
- **N5**: error output contains credentials, internal paths or sensitive diagnostics -> redact/deny disclosure according to policy.

Compare baseline versus minimal conditional change with held-out cases and independent expected verdicts; record raw response/status, type/extension parsing, decision and action receipts, false accepts, false denials, unauthorized network calls, regressions and resource overhead. Zero unauthorized actions and zero false-success classification for denied HTTP status. Synthetic tests are METHOD_ONLY, **not** DT Ground. When explicitly authorized later, validate with real current private tests and report exact commit, commands and results, or a precise stop verdict.

## Distinctness and Scout handoff
Distinct from DT-IP-0012's atomic acknowledgement/preconditions, DT-IP-0023's digest verification, DT-IP-0024's Sunset advisory/migration boundary and DT-IP-0025's signature coverage: RFC 9457 specifically governs typed error fields, advisory body status, untrusted diagnostic text/extensions and URI non-dereferencing. Public source reports targeted code search found no matches but does **not** establish exhaustive private/public parity. No B1/B4/B7 claims, automatic implementation or original deletion.

Independent Scrapyard Scout: compare FULL original blob `a4bc2c914df9d3fc856005c36a310220d6351e60` against this prompt clause by clause (RFC field semantics, authority, positive/negative cases, rights, provenance, unknowns). Only Scout may approve and SHA-guard delete the original after independent coverage audit; retain it otherwise.
