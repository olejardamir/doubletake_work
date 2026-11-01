# Historical Harvest Task 09 — Strict real-path E2E acceptance

**Provenance:** Astrocytech/Agent_X audit `874bbe4268aca0539cbf8476f62444d704f2d555` (implementation wave after `3887efe448edd223a00f94db324786d6a47a2d3b`). Historical test specification, not current DT E2E proof. Original blob `4465231b2ba76b867290031d365a2bd7f9959267`; D01 digest: [DISTILLED_KNOWLEDGE.md](DISTILLED_KNOWLEDGE.md).

**Historical targets:** Donor `harvest_audit.py`, `test_harvest_audit.py`, actual frontend/API, canonical semantic, Gate B, implementation, evaluation, canary/promotion owners, CI.

**Mechanism:** PASS iff *all* hard checks pass and no hard UNKNOWN; reject partial-success counters such as `passed >= 10`. Exercise actual browser/API→semantic evidence→Gate B→code→real caller→evaluation→canary→promotion, not just import/class construction or donor-only tests. Reject duplicates/no-value before code; test tampered UI/API requests; replacement cleanup, complement routing, restart idempotency, rollback, source/semantic/runtime reconciliation and obsolete-authority dead paths.

**Falsifiable controls:** Intentionally broken production wiring fails audit; donor-only isolated implementation never counts; any hard failure yields overall FAIL. Run affected existing/correction suites and visible CI command/status when available. Keep runtime audit only with a proven operational consumer, otherwise move to tests/remove after reference checks. Record HEADs, owners, actual call paths, exact tests/results, rollback and unknowns. Current DT E2E parity unverified.
