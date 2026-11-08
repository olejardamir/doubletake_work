# IS-20261108-030 — RFC 9651 structured-field revision compatibility gate

Status: INTERNET_SCOUT_SOURCE_VERIFIED / UNTRIAGED / PUBLIC RESEARCH HYPOTHESIS. Current private DT implementation parity: **UNKNOWN**. Not a DT defect claim, implementation prompt, or authorization.

## Primary original source
- IETF RFC 9651, *Structured Field Values for HTTP*, Proposed Standard, December 2024, https://www.rfc-editor.org/rfc/rfc9651 (reviewed §§1.1, 2.1–2.4, 3.3 and revision compatibility). Obsoletes RFC 8941 (2021): https://www.rfc-editor.org/rfc/rfc8941.
- Copyright 2024 IETF Trust and authors; IETF Trust Legal Provisions apply. Extracted code components require Revised BSD license text. This artifact paraphrases normative behavior; **no source code or test vectors copied**.

## Distinct mechanism and falsifiable hypothesis
**Protocol-version binding, not merely syntax validity:** A newer RFC 9651 parser can accept values that an RFC 8941 parser rejects. A field whose *definition* references RFC 8941 cannot silently acquire RFC 9651-only types (notably Date or Display String) just because a generic parser was upgraded. The field definition selects admissible types and semantics; successful generic parsing does not authorize consumption. RFC 9651 §2.4 explicitly warns of this upgrade acceptance difference. Strict malformed-field parsing fails the entire field (§§1.1, 2.2); field-specific constraints and unknown extension handling remain governed by the field's definition (§§2.2–2.3). This is distinct from JSON canonicalization and HTTP cache reuse.

**Hypothesis:** If a future authorized DT HTTP tool/capability consumer uses structured response/request metadata, an explicit field-definition version and per-field semantic validator may prevent accidentally accepting previously invalid values after parser upgrades. Potential integration point is its *existing* HTTP metadata/contract validation boundary, **only if one exists**; do not add a new gateway or protocol stack.

## Synthetic positive and negative controls (future research only)
- P1: RFC 8941-defined field with valid legacy type parses and retains identical semantic decision under either parser.
- P2: RFC 9651-defined field with an explicitly allowed Date/Display String parses and passes the declared per-field contract.
- N1: RFC 8941-defined field carrying RFC 9651-only Date/Display String: generic 9651 parse success **must not** promote it to valid legacy field.
- N2: malformed structured field or invalid escaping: reject/ignore entire field according to applicable field contract; never partially extract authority-bearing values.
- N3: syntactically valid but wrong top-level type or field-specific constraint: do not consume.
- N4: unknown parameter/dictionary member: follow field-specific extension policy, neither unconditional authority nor blanket rejection.
- N5: spoofed field-definition revision or metadata-supplied instructions: cannot change trusted contract/permissions.
Compare frozen legacy parser, upgraded generic parser, and contract-bound consumer verdicts on identical fixtures; record false accepts and false rejects. No private tests performed.

## Boundaries and dedup
Public implementation prompt INDEX (through DT-IP-0021), README and incoming inventory reviewed on main 2026-11-08 UTC; relevant full prompts DT-IP-0001 (governed capability projection), DT-IP-0009 (RFC 8785 JSON canonicalization), DT-IP-0012 (HTTP conditional writes) read. Public repository code searches for 'RFC 8941', 'structured fields', 'RFC 9530' found no matches (search absence is not proof). Distinct RFC 9651 §2.4 parser-upgrade/versioned-field acceptance mechanism not found in inspected prompts; **remaining prompt bodies and clustered sources not exhaustively compared**. Scrapyard Scout/Transformer own independent dedup and disposition; do not create implementation prompt here.

Do not let HTTP metadata, field values, or external documents grant tool execution permission. No private DT repository, host, tests, branches, actions, credentials, code copying or patches. Future user-authorized coder must preflight actual current consumer, trusted field definition, existing parser behavior, license and ALREADY_PRESENT/NO_CURRENT_CONSUMER exits. **Current DT parity UNKNOWN.**
