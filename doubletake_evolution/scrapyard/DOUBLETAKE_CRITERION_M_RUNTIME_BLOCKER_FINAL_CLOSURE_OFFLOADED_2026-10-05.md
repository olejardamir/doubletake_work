# Criterion M native-structured transport: historical blocker and verification contract

Source: condensed in place from the 2026-10-05 offloaded runtime-closure instructions. Original recoverable from Git history (blob `f166ca814d9c449d6b0360076c7848e72693b0d4`). This is **historical evidence**, not proof of the current DT runtime, code, or Criterion M status.

## Historical measurement (2026-10-05; revalidate before reuse)

- DT main observed: `e117f732b7a1b582c3ef746c1fee810d46d46d84`; evidence commit: `ff16abdf0537244d241bbb538d50ae2ed388a2b5`; measured source commit: `402150bb16ceae12beefbd6b1f19a8b09dc9d6ab`; measured-surface digest: `sha256:2913e724108054637f27816d514857bfe815b8149cedb2cdc0ba7bdb9cda98ad`. At offload, 25 measured source files reportedly matched byte-for-byte; this is not a present-day freshness claim.
- Active OpenCode version `2.0.12`, served bare model ID `big-pickle` (not `opencode/big-pickle` unless provider semantics change).
- Live proof reported 34 rows, 10 reached, `m_positive=false`, `g_intact=true`, `transport.verdict=STRUCTURED_REQUEST_REFUSED`, zero semantic calls (per-request bound 2), and no auxiliary model.
- The observed `POST /api/session/{id}/prompt` required `text`, rejected extra properties, and did not expose required `model`, `tools`, `format`, `system`, `parts` request fields. Native structured request returned HTTP 400 `InvalidRequestError: Missing key at ["text"]`. Binary internals suggested structured-output logic but did not establish HTTP support. Deterministic routing remained operational; M remained OPEN, G intact.
- Historical non-vacuity: 26 fired / 0 blind / 0 broken / 0 no-op, including transport rows. Re-derive scope instead of treating 26 as invariant.

## Source-linked verification surfaces

- Live proof: `tools/doubletake_evolve/runtime/capability_semantic_live_proof.py`
- Evidence: `reports/capability_semantic_live/evidence.json`
- Evidence verifier: `tools/doubletake_evolve/collective_core/capability_semantic_live_evidence.py`
- Transport probe: `tools/doubletake_evolve/runtime/capability_semantic_transport_capability.py`
- Current `AGENTS.md` and code, not historical shell commands, determine invocation and service discovery. Identify the **active** runtime endpoint, version, lease/auth, provider and model; do not reuse remembered ports.

## Falsifiable closure contract

1. Probe actual runtime HTTP request **and** response: native schema-bearing request accepted, native structured response returned and validated, serving provider/model identity established. JSON parsed from prose, regex coercion, tool execution, mock/test-only results, auxiliary LLM, embeddings-as-judge, or hand-edited evidence do **not** qualify. Transport support alone does not prove M.
2. Run governed production ingress for all current M-positive populations, not a direct internal matcher; verify actual semantic consultation, current required reach/utilization, call budget, no auxiliary learned semantic authority, no forbidden canonical capability-name leakage, negative refusals, and both Criterion G coincidence controls. Never weaken G or fit thresholds/profiles/expected labels to probes.
3. Regenerate live evidence when runtime instance or measured source surface changes. Re-derive evidence against source/vocabulary/profile digests; do not merely advance bound HEAD. Verify provenance and fail closed on stale/forged evidence.
4. For changed transport, matching, verifier, profile/vocabulary, runner or guards, rerun focused tests and non-vacuity mutations: intended perturbation must reach the target guard and fail for the intended reason; collection errors and no-op mutations are not firings. Require zero blind/broken/no-op rows.
5. If runtime still refuses native structure and proof/verifier remain current, keep M OPEN with `CRITERION_M_RUNTIME_HONEST_BLOCKER`; do not redesign DT speculatively. If runtime gains native structure but semantic acceptance still fails, keep M OPEN and report the *new measured* failure, not the obsolete transport blocker. Only verified full M+G proof permits `CRITERION_M_FINAL_CLOSED`; unresolved in-repo measurement defect is `CRITERION_M_CLOSURE_BLOCKED`.

## Distinct in-repo defects worth investigating **only if demonstrated**

Wrong runtime discovery or model ID; provider request not matching currently supported native shape; provider dropping a native structured response; stale/forged evidence accepted by verifier; production ingress bypassing a supported semantic bridge; blind/broken/no-op non-vacuity rows. Preserve concurrent changes. Do not treat historical implementation claims as present implementation evidence.

## Explicitly prohibited false positives

Manual `m_positive` edits, suppressing `m_target_lost`, xfail of `test_no_criterion_is_open`, removing M from convergence, weakening coincidence or negative controls, mock-as-live evidence, stale runtime endpoint/lease, or inferred native support solely from binary strings. Truthful OPEN with measured blocker is preferable to fabricated PASS.
