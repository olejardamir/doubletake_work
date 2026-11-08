# IS-20261108-033 — RFC 9421 signature coverage is not authorization

Status: UNTRIAGED PUBLIC RESEARCH; private DT implementation parity UNKNOWN.
Area: governed tool contracts / evidence provenance / safe execution.
Primary source: RFC 9421, HTTP Message Signatures, IETF Proposed Standard, February 2024, https://www.rfc-editor.org/rfc/rfc9421 (original read: §§1.4, 2, 7 security context). Source version: published RFC 9421, not an evolving draft.
License: © 2024 IETF Trust and authors, IETF Trust Legal Provisions / BCP 78. Extracted Code Components require Revised BSD text. No code or extended specification passages copied.

## Distinct falsifiable mechanism
RFC 9421 §1.4 requires an application profile to define REQUIRED covered components and parameters, accepted algorithms, key retrieval, key/algorithm/context suitability, component derivation context, and verification errors. A cryptographically valid signature over an inadequate component set does not authenticate an uncovered method, target or content; cryptographic verification is not authorization. RFC 9421 does not directly sign message content: an appropriate digest field can be required as a signed component when a profile needs content integrity. The signed timestamp/nonce does not by itself establish replay protection without application policy.

Hypothesis only: IF a future authorized DT HTTP evidence/tool contract consumes HTTP Message Signatures, its verification gate should enforce a separately owner-approved profile of covered fields, algorithm/key binding, request/response binding where relevant, replay policy and permission, before using signed data as evidence or granting action. No claim that DT currently has such a consumer or gap.

Potential integration point AS HYPOTHESIS: a future authorized HTTP evidence-ingestion verifier or tool-response contract, not an implementation instruction.

Positive synthetic controls: correct signer and key, required method/target/authority and policy-selected content digest covered, allowed algorithm, unexpired/replay-valid signature, independently authorized use; permitted intermediary transformation preserving canonical signed components.

Negative synthetic controls: signature valid but method or target uncovered; content changed while only headers signed; signed Content-Digest field with mismatching actual body; keyid resolving to unauthorized key; disallowed algorithm or context; replayed signature; forged signature parameters; proxy-derived target URI inconsistent with signed context; valid signature without tool permission. Expected: fail closed or explicit UNKNOWN, never infer permission from signature alone.

Boundary: upstream HTTP fields and key identifiers are untrusted inputs. No automatic remote key retrieval or execution based on them; key lookup and authorization must be independently governed. No private code, test execution, or key material. Future authorized coder preflight determines applicability and existing parity.

## Public dedup snapshot (2026-11-08)
Read public implementation-prompt INDEX through DT-IP-0022 and incoming inventory shard; examined DT-IP-0003 (mission receipts) and DT-IP-0013 (derived argument provenance). Existing IS-031 covers RFC 9530 content/representation digests and IS-030 covers RFC 9651 structured-field revision types. Distinct proposed delta is RFC 9421 §1.4 *application-defined mandatory signature coverage and signer/key/algorithm context*, not a generic digest or provenance check. Remaining prompt bodies and clustered sources not exhaustively compared: novelty provisional; Transformer/Scout must deduplicate before promotion.
