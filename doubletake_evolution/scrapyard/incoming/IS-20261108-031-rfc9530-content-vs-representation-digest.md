# IS-20261108-031 — HTTP content versus representation digest integrity boundary

Status: PUBLIC RESEARCH CANDIDATE / UNTRIAGED / NOT IMPLEMENTED
Source: RFC 9530, *Digest Fields*, Polli and Pardue, IETF Proposed Standard, 2024, https://www.rfc-editor.org/rfc/rfc9530 (reviewed §§1.2, 2, 3, 3.1, 4, 5, 6.1–6.4). Obsoletes RFC 3230. Licensing: IETF Trust Legal Provisions, https://trustee.ietf.org/license-info ; extracted code components require Revised BSD terms. No code or test vectors copied.

## Distinct mechanism
RFC 9530 distinguishes `Content-Digest` (actual HTTP message content) from `Repr-Digest` (selected representation data, potentially entire resource despite partial/range content). They are not interchangeable. A valid digest is not origin authentication, authorization, protection of HTTP metadata, or evidence of freshness. Integrity fields can arrive in trailers after content; eager consumption before trailer validation can accept unverified bytes. RFC 9530 also distinguishes algorithm preferences (hints) from application policy and deprecates weak algorithms for adversarial use.

## Falsifiable DT hypothesis (conditional)
If a future authorized DT HTTP evidence/capability consumer uses digest fields, it should bind integrity checks to the correct content/representation target and block any *policy-required* downstream consumption until the complete digest (including trailer if applicable) is validated. Integration point: hypothetical HTTP evidence-ingest adapter, NOT a verified DT component. Consumer existence, permitted policies, and current private DT parity: UNKNOWN.

## Controls (disposable, authorized fixtures only)
Positive: complete message content matches `Content-Digest`; selected full representation matches `Repr-Digest` across an explicitly supported partial-content response; a trailer digest is checked before release; application policy permits chosen active algorithm.
Negative: substitute a range-body hash for full representation hash; mutate body after digest generation; corrupt/remove required trailer; stream bytes to dependent consumer before required trailer arrives; supply a weak/deprecated algorithm in adversarial policy; valid digest but forged sender or changed unsigned metadata; unsupported digest algorithm. Expected outcome: reject or explicitly INDETERMINATE under owner-defined policy, never infer authenticated provenance from hash equality alone.

## Boundary and novelty check
Read public implementation-prompt INDEX and README plus incoming inventory on 2026-11-08; GitHub repository searches for `RFC 9530`, `Content-Digest`, `Repr-Digest` returned no matches. Existing DT-IP-0008/0009 address Merkle/JSON canonical integrity; DT-IP-0012 addresses HTTP atomic preconditions; IS-030 addresses structured-field revision types. This candidate adds the content-vs-representation distinction and trailer-before-consumption gate. Search absence is NOT complete clause-level dedup; remaining prompt bodies/clustered sources require independent comparison by Scrapyard Scout/Transformer.

No private DT repository access, tests, implementation, new authority, code patches, or third-party code reuse. Future authorized coder must preflight ALREADY_PRESENT / NO_CURRENT_CONSUMER and permissions before any implementation.
