# IS-20261108-032 — RFC 8594 Sunset hints versus authorized migration

Status: PUBLIC_RESEARCH_CANDIDATE / UNTRIAGED; current private DT implementation parity: **UNKNOWN**. No current defect, consumer, permission or implementation is asserted.

## Original source and rights
- Erik Wilde, **RFC 8594**, *The Sunset HTTP Header Field*, IETF Informational RFC, May 2019: https://www.rfc-editor.org/rfc/rfc8594
- Directly read original Sections 1.4, 3–6, 8. Normative mechanisms: Sunset response field is an HTTP-date and a *hint* about potential unavailability, not a guarantee; past dates suggest possible immediate unavailability (§3). Cache freshness and resource sunset are different (§4). Default scope is the emitting resource, not the entire service unless independently documented (§5). A `rel="sunset"` link may supply migration policy, but machine-readable migrations must be authenticated, accurate, and confined to the relevant resources (§§6,8). Intermediaries may inject/alter sunset dates (§8).
- Copyright: IETF Trust Legal Provisions (BCP 78), https://trustee.ietf.org/license-info ; extracted code components require Simplified BSD terms; **no third-party code copied**. Informational RFC, not a blanket mandate on DT.

## Distinct, falsifiable behavior hypothesis
IF an authorized DT HTTP capability discovery/consumption boundary processes Sunset or sunset links, treat those fields as advisory lifecycle evidence only. Never silently retire a capability, expand the sunset to unrelated resources, rewrite target URLs, or transfer authority on the strength of an unverified header/link. A migration is a separate owner-approved, scope-bound decision, and response cache freshness does not prove continued endpoint availability.

**Potential integration point (HYPOTHESIS ONLY):** public documented governed capability retrieval / capability freshness handling. A future authorized coder must first identify an actual consumer, owner contract, baseline, authorization and ALREADY_PRESENT/NO_CONSUMER exits; do not assume one exists.

## Proposed synthetic verification controls (NOT EXECUTED)
- P1: Valid future HTTP-date for one resource yields a bounded *warning*, not automatic disablement.
- P2: Independently authenticated, scope-limited migration information may be presented for separate approval; unrelated capability identities remain unchanged.
- N1: Past Sunset date is not interpreted as proof of deletion, and future date is not an availability guarantee.
- N2: Service-wide retirement is not inferred from one resource absent explicit authorized scope.
- N3: Forged intermediary Sunset or malicious `rel="sunset"` migration to attacker endpoint cannot rewrite destination or grant permissions.
- N4: Cached fresh representation does not erase a sunset warning or confer ongoing authorization; sunset timestamp does not override cache validation.
- N5: Malformed date, unreachable linked policy, cross-origin redirect and contradictory lifecycle notices result in UNKNOWN/REVIEW rather than an unauthorized migration.
- N6: Link content instructing secret disclosure or tool execution remains untrusted data.

## Deduplication and limits
Public `implementation_prompts/INDEX.md` through DT-IP-0022, README, and `scrapyard/inventory_shards/incoming.md` examined on 2026-11-08; public repository code search for `Sunset`, `RFC 8594`, `migration hijack` yielded no matches. Conceptual overlap: DT-IP-0001 governed capability projection, DT-IP-0005 freshness, and RFC 9111 caching candidate IS-20261107-029. Distinct contribution is the RFC 8594 *advisory lifecycle timestamp + default single-resource scope + authenticated migration-link boundary*. Full body/cluster clause-by-clause dedup remains for Scrapyard Scout and Transformer. Search absence is not proof of novelty.

Pending source gap: no verified public DT HTTP Sunset consumer, scope/migration trust contract or independent observable fixture; full prompt-body and clustered-source coverage audit outstanding. **Current private DT parity UNKNOWN.** No private repository access, coding, testing, or implementation authorization.
