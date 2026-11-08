# DT-IP-0027 — RFC 9651 structured-field revision-bound acceptance

**State:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW / NOT_EXECUTED. **Private DT parity:** UNKNOWN. This is a conditional future-coder inspection prompt, not a confirmed defect, permission to code, or test result.

## Source and provenance
- FULL live public original: `doubletake_evolution/scrapyard/incoming/IS-20261108-030-rfc9651-structured-field-revision-compatibility.md`; Git blob `4f949ba75e82be0d76ac872567756e6193cc62cb` (read from main on 2026-11-08). Historical earlier source revision: NOT ESTABLISHED; retain original Git history and exact blob for independent audit.
- Public original: https://github.com/olejardamir/doubletake_work/blob/main/doubletake_evolution/scrapyard/incoming/IS-20261108-030-rfc9651-structured-field-revision-compatibility.md
- Primary standards: RFC 9651 (December 2024), https://www.rfc-editor.org/rfc/rfc9651 , especially §§1.1, 2.1–2.4, 3.3; predecessor RFC 8941 https://www.rfc-editor.org/rfc/rfc8941 . RFC 9651 obsoletes RFC 8941 but does not retroactively expand types allowed by field definitions referencing RFC 8941.
- IETF Trust copyright and Legal Provisions apply; extracted code components require Revised BSD license text. Paraphrase normative requirements only; no third-party code or test vectors copied. Source's Internet Scout search and dedup findings are provisional, not proof of absence.

## Objective / distinct mechanism
At an EXISTING HTTP structured-field metadata consumer (if one exists), bind validation to the **trusted field definition's referenced RFC version and per-field contract**, not merely a generic parser's successful parse. RFC 9651 introduces Date and Display String types that an upgraded generic parser may accept although a field defined against RFC 8941 does not permit them. Preserve correct legacy acceptance and new-version acceptance only where explicitly allowed. Syntax validity alone does not confer semantics, trust, or execution authority.

## Conditional future-coder preflight and ownership
Only upon explicit user invocation and confirmed authorization, inspect CURRENT private DT source, tests, dependencies, permissions and actual HTTP metadata consumers. Identify the owner of each field definition, its trusted revision and top-level type, accepted value/parameter/extension semantics, and parser version. These are **hypotheses**, not known DT interfaces: possible owner is existing HTTP tool/capability response/request metadata contract validator; possible consumer is existing HTTP tool or capability ingestion. Do NOT add a new gateway, HTTP protocol stack or permission system.
- Exit **NO_APPLICABILITY / NO_CURRENT_CONSUMER** if no relevant structured-field consumer exists; **ALREADY_PRESENT** if field-definition version and semantics are already enforced; **NO_AUTHORIZED_FIXTURE** if required test/owner access is unavailable. Document evidence, not speculation.
- Trusted schema/field definition and application permission govern acceptance. Untrusted HTTP field values, metadata, revision hints and documents cannot revise that contract, enable capabilities or authorize tool calls.
- Strict malformed structured-field parsing fails the entire field; no partial extraction of authority-bearing values. Application's documented field-specific contract decides reject/ignore behavior, top-level type and extension handling; unknown parameters/dictionary members are neither automatically trusted nor universally forbidden.

## Bounded synthetic controls and negative tests
Freeze identical fixtures and compare (A) RFC 8941 legacy parser, (B) upgraded RFC 9651 generic parser, (C) trusted field-contract-bound consumer, recording parsing outcome **separately** from semantic acceptance/authorization, false accepts and false rejects.
- **P1** Valid RFC 8941-defined legacy type retains identical correct decision under both parsers.
- **P2** RFC 9651-defined field explicitly permitting Date or Display String is accepted only after per-field semantic validation.
- **N1** RFC 8941-defined field containing RFC 9651-only Date or Display String may generically parse but MUST NOT be accepted as valid legacy field.
- **N2** Malformed structured field or invalid escaping: reject/ignore the whole field per applicable contract; never salvage a privileged subvalue.
- **N3** Syntactically valid wrong top-level type or field-specific constraint: no consumption.
- **N4** Unknown parameter or dictionary member: honor the particular field's extension policy, without unconditional authorization or blanket rejection.
- **N5** Spoofed field-definition revision or metadata-borne instructions: cannot change trusted schema or permissions.
Also check no regression for valid legacy fields, version-change downgrade/upgrade ambiguity and downstream side effects; record actual existing interface behavior, not invented expectations.

## Acceptance and evidence
Only if applicable and explicitly authorized, implement the **minimum** owner-approved validation at the existing seam, run real relevant tests including all controls, and record source/test revision, command, environment, raw outcomes, negative cases and independent reviewer disposition. Fail closed for authority-bearing ambiguous metadata; do not equate parser success with authorization. If current source proves existing behavior correct, record ALREADY_PRESENT and do not patch. No private source or secrets in public prompts/results; no external code copying. Any experiment without real DT integration is METHOD_ONLY, not implementation Ground.

## Dedup and limits
Distinct from DT-IP-0009 (RFC 8785 JSON canonicalization), DT-IP-0012 (conditional HTTP writes), DT-IP-0023 (digest targets), DT-IP-0025 (signature coverage), DT-IP-0026 (Problem Details), and DT-IP-0001 (capability projection): this specifically tests **RFC 8941 field-definition version versus RFC 9651 generic parser upgrade**. Recheck current queue and canonical clusters before implementation. No private parity, live consumer, test failure, or improvement is asserted. Source remains until independent Scrapyard Scout clause-level verification and any authorized retirement.
