# IS-20261111-AU12 — Component-scoped audit-event selection and generation completeness

Status: PUBLIC SOURCE RESEARCH ONLY; candidate for independent Scout/Transformer triage; NOT IMPLEMENTED. Current private DT parity: UNKNOWN.

## Primary source and rights
NIST SP 800-53 Revision 5.1, AU-12 (Audit Record Generation), with AU-2 (Event Logging) and AU-3 (Content of Audit Records). NIST official derived OSCAL PDF: https://csrc.nist.gov/CSRC/media/Projects/risk-management/800-53%20Downloads/800-53r5/SP_800-53_v5_1-derived-OSCAL.pdf . Read AU-12 clauses a–c and linked AU-2/AU-3 obligations on 2026-11-11. This is a US federal government standards publication; applicability of public-domain treatment to specific non-government contributions, logos, and OSCAL packaging is not independently verified. Paraphrase only; no code or copied tables.

## Distinct source-grounded clause
AU-12 distinguishes (a) event types *capable* of being audited on specified components, (b) event types selected for logging on each component by designated authorized roles, and (c) records *actually generated* for the selected types, with AU-3-required event content. A complete audit record for one observed operation does not prove coverage for all configured event types or that the selection was authorized.

Conditional DT behavior hypothesis: If a public-contract-backed, multi-component governed execution/audit consumer exists, compare an authorized component-by-event-type selection matrix against generated event records and report missing records/fields and unauthorized selection changes, rather than inferring completeness from the presence of some receipts. The existence of such a consumer is UNKNOWN; this is not a requirement to introduce NIST compliance or new logging subsystems.

## Proposed positive/negative tests (future authorized evaluation only)
P1: For two components with distinct selected event sets, each synthetic selected event produces an attributable record with event type, time, source/location, outcome, and associated actor/object as applicable under AU-3.
P2: Authorized role changes selected event types for a component; subsequent events follow the approved revision and are attributable to it.
N1: A configured selected event produces no record: flag incomplete despite other valid receipts.
N2: An unprivileged actor attempts to change the event selection: reject, preserve old effective configuration.
N3: Record exists but lacks mandatory AU-3 fields: flag incomplete rather than count as passing.
N4: A capable but unselected event type is not automatically treated as a violation; distinguish capability inventory from authorized selection.

## Dedup and boundaries
Checked public implementation_prompts/INDEX.md blob 701fb932e0659d395bf9949057bfd1bb3ffed71d and incoming inventory blob 535fbf8f5ea1934e3857c7cbca48fd22fcf28ac2 on 2026-11-11. Exact audit-event-generation and role-scoped component selection searches returned no repository code-search matches; reviewed DT-IP-0037 (evidence-register disposition completeness) and DT-IP-0043 (runtime obligation/zero-effect completion). Those address evidence status and runtime completion, not a configured component × selected event-type → generated audit record matrix. This is a clause-level *candidate*, not proof that full canonical research lacks overlap; full independent canonical cluster comparison pending. No private DT inspection or applicability claim.

Security: selection authority is independent of event-source data; logging must not grant capabilities, leak secrets, or become a way for untrusted text to alter audit policy. Minimize sensitive event data under applicable privacy requirements. No code reuse. Future coder must first establish an actual authorized audit consumer and exit ALREADY_PRESENT / NO_CONSUMER / NOT_APPLICABLE if appropriate.

Pending source gap: confirm public canonical-cluster novelty and actual authorized audit-event consumer; decide whether AU-12 is relevant to any DT scope at all. Private DT implementation parity: UNKNOWN.
