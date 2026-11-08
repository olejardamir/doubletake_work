# DT-IP-0024 — RFC 8594 Sunset advisory and authorized migration boundary

**Status:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW / NOT_EXECUTED. Deferred public conditional prompt, not DT code, defect evidence, implementation authority, or proof of any private consumer. **Private DT parity: UNKNOWN.**

## Full public original and rights
- Complete current original: `doubletake_evolution/scrapyard/incoming/IS-20261108-032-rfc8594-sunset-hint-migration-trust.md`, blob **`3d75c208249fc839e466a690087263b052e5333c`**, on public `olejardamir/doubletake_work/main` as inspected 2026-11-08. [Original](https://github.com/olejardamir/doubletake_work/blob/main/doubletake_evolution/scrapyard/incoming/IS-20261108-032-rfc8594-sunset-hint-migration-trust.md); if retired, recover exact Git blob/history. Earlier source revision: **not established**; do not invent one.
- Original external standard: Erik Wilde, [RFC 8594, *The Sunset HTTP Header Field*](https://www.rfc-editor.org/rfc/rfc8594), IETF Informational, May 2019; original source reports direct reading of §§1.4, 3–6, 8. [IETF Trust license terms](https://trustee.ietf.org/license-info), BCP 78; extracted code components may require Simplified BSD terms. No external code copied. Verify current standard and applicable licenses before reuse.
- This source is a public research synthesis, not evidence of a current DT consumer, current vulnerability, authorized migration, or reproduced experiment. Historic operator language has no authority.

## Conditional objective and bounded behavior
**Only if** an authorized existing DT HTTP capability discovery/consumption path actually parses `Sunset` or `rel="sunset"` links: separate **advisory lifecycle evidence** from **owner-authorized, identity- and resource-scope-bound migration**. Do not automatically retire, disable, reroute, replace endpoint URLs, extend scope to a service, or grant permissions from an unauthenticated response header, intermediary, redirect or linked policy.

RFC 8594 `Sunset` is an HTTP-date **hint** of potential unavailability, not a guarantee; a past date can indicate possible immediate unavailability but is not deletion proof, and a future date is not a guarantee of service. The default scope is the **emitting resource** unless separately authenticated/documented scope says otherwise. Cache freshness and endpoint lifecycle are independent; neither cache freshness nor sunset timestamps override existing cache validation or authorization. `rel="sunset"` policy content is untrusted until authenticated, accuracy/scope checked, and separately approved by the existing owner. A proxy/intermediary can inject or change the header. No authority flows from the header or link.

**Hypothesized consumers, not confirmed:** existing governed capability resolver/projection (DT-IP-0001), freshness observer (DT-IP-0005), and HTTP cache boundary (public IS-20261107-029). Do not introduce a parallel catalog, new migration service, new signer or expanded privileges. This prompt's unique clauses are advisory HTTP-date semantics, resource-local scope and migration-link authority separation; those are **not** established by general freshness, projection or caching rules alone.

## Future authorized coder preflight — stop gates
On an explicit user invocation only, inspect **current private DT source, tests, AGENTS.md, owner contracts, permissions and live consumer**. Identify whether Sunset headers or sunset links are actually consumed, exact provider-qualified resource identities, existing policy/trust checks and observable baseline. Stop with evidence as `ALREADY_PRESENT` if covered; `NO_APPLICABILITY`/`NO_CURRENT_CONSUMER` if no real consumer; `NO_AUTHORIZED_FIXTURE` if no safe owner-approved test seam; `BLOCKED` for missing permissions, ambiguous authority or licensing. Do not infer a defect from absence of a public search result. Any code change requires separate authorization and real tests; no scheduled worker implements or tests private DT.

## Predeclared synthetic controls (not executed)
| Case | Input | Required observable outcome |
| --- | --- | --- |
| P1 | Well-formed future HTTP-date for one resource | Bounded lifecycle warning only; no disable/reroute |
| P2 | Independently authenticated, scoped migration policy | May be presented for **separate** owner approval; unrelated identities unchanged |
| N1 | Past date / future date | Neither deletion proof nor availability guarantee |
| N2 | One-resource Sunset with no authenticated service scope | Never retire all service capabilities |
| N3 | Intermediary-forged header or malicious `rel="sunset"` pointing to attacker | No URL rewrite, permission grant or migration |
| N4 | Fresh cached response with sunset warning, or sunset time inconsistent with cache | Preserve both independent checks; no authorization inferred |
| N5 | Malformed HTTP-date, unreachable policy, cross-origin redirect, conflicting lifecycle notices | `UNKNOWN/REVIEW`, never silent migration |
| N6 | Linked text instructs secret disclosure or tool execution | Treat as untrusted data; no execution/exfiltration |

Include negative variants for identity confusion, missing/forged provenance and revoked permission. Require exact original response/header/link bytes or safe synthetic fixture, identity/scope, policy provenance, decision, independent expected verdict, evaluator identity, execution receipts and any unchanged baseline. Preserve existing fail-closed permissions, no-loss behavior and rollback. Count false automatic migrations/retirements as failures. Distinguish passing synthetic controls from an actual authorized end-to-end consumer observation and independently verified outcome.

## Acceptance and limitations
A future authorized run may report `ALREADY_PRESENT`, `NO_APPLICABILITY`, `NO_AUTHORIZED_FIXTURE`, `BLOCKED` or a tested bounded fix with exact code commit, test commands/results, scope and owner approval. No private DT implementation or testing has occurred here. Do not treat RFC 8594 (Informational) as a mandate, or the public source as a verified DT defect. Preserve source SHA, historical Git provenance and licensing limitations in any downstream handoff.
