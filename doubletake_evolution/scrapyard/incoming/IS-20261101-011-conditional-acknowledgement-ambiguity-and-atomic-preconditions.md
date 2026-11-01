# IS-20261101-011 — Conditional-write acknowledgement ambiguity

**Origin:** Borg Internet Scout, 2026-11-01 UTC; original incoming Git blob `79701ab94aa5fa03bc93f38152ca55409eea192e` (full original recoverable from Git history). **Scrapyard disposition:** SOURCE_VALIDATED / KEEP / SURGICALLY_REDUCED / DEFERRED_PENDING_OWNER_CONTRACT. Public self-authored synthesis only; no private DT source, host logs or credentials. No implementation, new mission, owner permission or DT Ground claimed. Related IS-005 (coordination), IS-008 (canonicalization), IS-010 (independent history oracle), and existing Director 3.5.2 / 7.8.1. Full research provenance also in [../DISTILLED_KNOWLEDGE.md](../DISTILLED_KNOWLEDGE.md) for D01.

## Primary normative evidence (directly checked by Scrapyard Scout)

- **RFC 9110 §13.1.1 and §13.2** (IETF, 2022): https://www.rfc-editor.org/rfc/rfc9110.html#section-13.1.1 . Origin-server `If-Match` uses strong ETag comparison. Failed condition ordinarily yields 412/no method, **but** server MAY respond 2xx when the state-changing request can be determined already applied; spec warns about similar non-cooperating writers and lost state transitions. HTTP 2xx therefore is not automatically a fresh, uniquely identified durable contribution.
- **RFC 5789 §2** (IETF, 2010): https://www.rfc-editor.org/rfc/rfc5789.html . HTTP PATCH is atomic: all modifications or none; base-dependent patches SHOULD use a strong conditional validator. Atomic PATCH is not a durability guarantee.
- **RFC 6902 §§4.1, 4.6, 5** (IETF, 2013): https://www.rfc-editor.org/rfc/rfc6902.html . JSON Patch `test` checks typed equality; `add` to an existing object member *replaces* that member. HTTP PATCH failure must not partially apply preceding operations. A detached read/test followed by separate write is not an atomic concurrency guard.

**Read vs inference:** RFC normative sections were examined; no live DT writer, test, host, independent replication or HTTP applicability was observed. Standards apply to their specified protocols, not automatically to private DT state storage. Do not copy RFC full texts; original links only.

## Distinct transfer hypothesis and constraints

An accepted operation, a legal stale refusal, and a success response for an already-applied equivalent request are different states. Owner-defined operation identity, acknowledgement semantics and restart/durability boundary are prerequisites to classifying `NEW_ACK`, `IDEMPOTENT_ALREADY_APPLIED`, `REJECTED_STALE`, `INCONCLUSIVE` or `LOST_ACK`. Same payload from a *different* operation ID is not automatically the same accepted contribution. `If-Match: *` checks existence, not version; weak ETag is insufficient for strong comparison. A CAS precondition can avoid stale replacement but not prove durability, authorization, fair retry, atomic multi-resource effects or stronger consistency.

**Named DT gap:** B4 isolated acknowledged-update loss and missing writer contract; conditional refinement to 3.5.2/IS-010 oracle. Possible 7.8.1 analogy: same mission revision/transport success cannot certify a new local execution; this is not a proposed change to the existing mission. **Novelty unknown:** existing DT fixture may already discriminate all cases. B1 historical-integrity disposition is separate and cannot be bypassed.

## Falsifiable authorized experiment (proposal only)

**Prerequisites:** Existing owner authenticates actual storage model (HTTP/file/database/other), accepted-write/operation-ID semantics, durability boundary and an authorized disposable fixture. If absent, stop with `OWNER_CONTRACT_UNKNOWN / NO_AUTHORIZED_CONSUMER`. No production writes, protected-history mutation, re-sealing, deletion, or new state owner.

**OUTWARD:** In self-authored isolated two-writer model, A/B read revision 0, propose distinct `a`/`b`; freeze operation IDs, version preconditions, responses, final read and restart observation. Compare unconditional snapshot replacement against atomic version CAS (translate the invariant, not HTTP protocol, if writer is non-HTTP).

**INWARD:** Only with existing owner approval and genuine parity gap, run frozen traces against existing canonical writer and independent oracle; preserve actual authority/receipt. No auto-promotion from research note.

**GROUND / controls:**
1. A accepted at rev0; B stale rev0 refused (not lost ack); B authorized retry from rev1 accepted; after defined durability restart final set contains both `a,b` (PASS).
2. Unconditional B snapshot overwrite after A accepted leaves only `b` (FAIL). Non-atomic test→write race, weak validator or partial application after failed JSON Patch `test` also FAIL.
3. Replay of *same operation ID* with prior effect present may be `IDEMPOTENT_ALREADY_APPLIED`, **not new acceptance**; identical payload from distinct ID requires equivalence proof. Missing/delayed response, crash before acknowledgement or read before durability boundary is INCONCLUSIVE.
4. Compare existing 3.5.2/IS-010 fixture classifications at matched budget. Added value only if it removes a demonstrably absent false-new-ack error, catches stale/non-atomic cases, preserves legal refusals/positive no-loss, and does not duplicate an existing DT test. Otherwise `ALREADY_PRESENT` / defer.

**Independent DT knowledge→Ground credit requires more:** qualified external K, approved ingestion/assimilation, run-bound real consumer receipt, preregistered held-out source-dependent changed decision, negative controls and later ordinary reuse. Scratch examples and notes do not qualify.

**Revisit trigger:** Owner-authenticated writer contract, authorized consumer, source-level parity or independent test evidence. Until then do not send another generic consistency proposal; Director's 7.8.1 receipt remains the higher-priority independent discriminator.
