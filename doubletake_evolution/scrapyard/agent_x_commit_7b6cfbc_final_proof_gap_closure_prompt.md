# Historical Agent_X proof-layer closure — distilled falsification contract

**Provenance:** Original at this path, Git blob `105b6666fd99331363d0a5adc2eacf54b3ab4406` (27515 characters); historical upstream Astrocytech/Agent_X commit `7b6cfbc21651ade4e749de7f525746f037d3e3f6`. Historical unexecuted repair proposal, not evidence of current DT defects, authority or test success. Exact historical component roster, source paths, commands and report filenames are recoverable from the original blob.

## Alleged failure and proof requirement
The historical proof layer allegedly granted PASS based on manifest presence, hardcoded acceptance rows, static discovery/compatibility/traceability and weak validators. Retain `FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE` until evidence-derived `FUNCTIONAL_RUNTIME_MVP` proof.

## Distinct mechanisms (original blockers A–K)
1. **Evidence-derived acceptance:** every mandatory component row references validated, revision-bound scenario/test/command proof. Validator rejects missing/extra/duplicate rows, fabricated PASS and manifest-only evidence.
2. **Durable replay:** safe and unsafe scenarios replay from persisted manifests, verifying state, events, artifact hashes, verdicts, gates, invariants, promotion and safety records. No reconstructed expected state masquerading as persisted replay.
3. **Actual source nonmutation:** snapshot production source immediately before and after the real safe scenario; detect modified, added and deleted paths; exclude only explicitly allowed generated reports. Missing manifest or changed digest fails closed.
4. **Real discovery/compatibility/traceability:** run bounded repository gap search and actual version/interface checks, recording scope, evidence, negatives and revisions. Bind each requirement to executed proof; static reports are insufficient.
5. **Adversarial audit:** anti-false-PASS attacks must change meaningful evidence (including an all-green command transcript), be rejected and cause nonzero exit; audit warnings cannot be ignored. Negative validator tests exercise malformed, missing, stale and forged evidence.
6. **Idempotency:** run proof target twice on unchanged tracked source, compare stable semantic outputs with only justified volatile normalization, and regenerate ignored reports from tracked source. Preserve exact command exit codes and environment.

## Falsifiable historical acceptance
Original proposed sequence: `python3 -m compileall -q tools/agentx_evolve tests`; `make prove-functional-runtime-mvp` twice; `make prove-functional-runtime-mvp-idempotent`; `make test-evolve`; `make prove-format` (optional `make test-quick`). Require exit 0. Evidence bundle must cover acceptance, persisted replay, source before/after hashes, real gap discovery, compatibility, reuse mapping, traceability, adversarial audit, command transcript and idempotency. Generated reports must be reproducible.

**Negative controls:** remove required acceptance row; swap proof identity; forge PASS using a manifest; replay stale state; alter event digest; mutate source mid-scenario; replace discovery with static text; omit compatibility check; tamper with successful command; turn audit failure into warning; introduce hidden nondeterminism between consecutive runs. Each must reject or remain explicitly UNKNOWN, never PASS.

## Transfer to current DoubleTake
Hypothesis: public ACTIVE_MISSION Git blob read → permitted private DT/main code/test commit → exact-blob executed tests → independent Overseer verification needs these same proof identities and negative controls. **UNKNOWN:** present DT proof owners, historical defect parity, actual test execution and acceptance. No DT host is running; historical natural-runtime criteria are future deployment, not blockers for GPT GitHub source work. A committed checklist or source patch is not runtime Ground. Recheck current code before proposing changes; do not duplicate existing verification.
