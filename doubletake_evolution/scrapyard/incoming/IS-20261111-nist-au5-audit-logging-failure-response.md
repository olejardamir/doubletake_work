# IS-20261111-AU5 — Audit logging failure detection and bounded response

Status: PUBLIC SOURCE CANDIDATE ONLY / NOT IMPLEMENTED. Current private DT implementation parity: UNKNOWN.

## Primary source, revision and rights
NIST SP 800-53 Revision 5.1, AU-5 (Response to Audit Logging Process Failures), including enhancements AU-5(1), AU-5(4), AU-5(5), and relationship to AU-12. Official NIST derived OSCAL publication: https://csrc.nist.gov/CSRC/media/Projects/risk-management/800-53%20Downloads/800-53r5/SP_800-53_v5_1-derived-OSCAL.pdf . Reviewed original-source AU-5 text on 2026-11-11. US-government publication; exact rights for non-government contributions, logos, and derived OSCAL packaging not independently established. Paraphrase only; no code copied. NIST controls are not automatically DT requirements.

## Distinct falsifiable source clause and conditional DT hypothesis
AU-5 requires notification to organization-defined roles within an organization-defined time after an audit logging process failure and organization-defined additional response actions. Distinguish successful operational execution from *failure of its audit capture mechanism*. A conditional, owner-authorized audit consumer could report loss of audit recording (including capture error or exhausted storage), identify affected component and event scope, produce an independently observable alert within an approved deadline, and enforce only an explicitly approved failure policy. AU-5(4) degraded/shutdown mode and AU-5(5) alternate logging are optional enhancement-specific mechanisms, not blanket mandates.

This is distinct from AU-12's configured component-event selection versus generated-record completeness: AU-5 concerns detection/notification/response to *logging process failure* even when normal execution continues. Never assume a current DT audit consumer exists; do not create one solely to satisfy this research proposal.

## Hypothetical integration and tests (not executed)
Integration hypothesis: existing authorized execution audit-recording/monitoring boundary, if documented and approved; owner, policy, and applicable runtime UNKNOWN.
P1: Inject a controlled audit sink failure into a disposable mock while an operation succeeds; verify an independently observed failure signal, authorized recipient, and configured alert deadline.
P2: With owner-selected policy, validate bounded response and recovery; distinguish restored primary logging from explicitly permitted alternate logging.
N1: Valid execution receipt with failed audit sink must not be labeled audit-complete.
N2: Missing recipient/deadline/response policy yields CONFIGURATION_UNRESOLVED, not invented NIST compliance or an arbitrary shutdown.
N3: Untrusted event payload cannot alter recipient, failure policy, logging permissions, or disable alerting.
N4: Storage-capacity warning threshold (AU-5(1)) and shutdown/degraded-mode (AU-5(4)) must not be presumed applicable without explicit owner selection.
N5: False-positive sink failure and unavailable independent observation remain distinguishable from confirmed logging loss.

Security: no secret-bearing alerts; no authority elevation from logs; avoid denial-of-service via untrusted failure signals. Fail-closed only where an authorized policy requires it; preserve business continuity and privacy requirements.

## Clause-level dedup and limits
Read public implementation_prompts/INDEX.md blob 85e36ec0f63dd384cf5a9fb2ec3a299126a93b99 and incoming inventory blob a5e2f22db239ea39072c9df31a9df336bf8032ae on 2026-11-11. Compared against IS-20261111-AU12 (component event-generation completeness), DT-IP-0037 (evidence-register dispositions), DT-IP-0043 (runtime obligation completion), and DT-IP-0054 (transactional event-intent publication). AU-5's independent logging-failure alert/response with configured recipients and deadlines is not the same clause as event selection, task completion, or event-intent atomicity. Complete canonical-cluster audit is PENDING, so this is NEW DISTINCT CANDIDATE, not certified unique across all public research.

Pending gaps: canonical-cluster novelty, explicit authorized audit consumer, owner-defined AU-5 roles/timing/actions, source rights for any reuse, and future independent testing. No private DT inspection, code changes or tests; implementation parity UNKNOWN.
