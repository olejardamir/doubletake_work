# DT-IP-0061 — Evidence-derived proof-layer integrity and anti-false-PASS validation

**Status:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW / NOT_EXECUTED. Conditional future implementation inspection only; no current private DT defect, implementation authority, test execution or source deletion is asserted.

## Exact public source and historical provenance
- Live distilled source: `doubletake_evolution/scrapyard/agent_x_commit_7b6cfbc_final_proof_gap_closure_prompt.md`, Git blob `4fb29eb468d09e89d8f76c7b046f5346d2513a31`.
- Full historical predecessor at same path: Git blob `105b6666fd99331363d0a5adc2eacf54b3ab4406` (27,515 characters); historical Agent_X revision `7b6cfbc21651ade4e749de7f525746f037d3e3f6`. Public historical blob: https://github.com/olejardamir/doubletake_work/blob/105b6666fd99331363d0a5adc2eacf54b3ab4406/doubletake_evolution/scrapyard/agent_x_commit_7b6cfbc_final_proof_gap_closure_prompt.md .
- This is an archival Agent_X proposal, not evidence of a present DT defect. Original proposed status `FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE`, withheld `FUNCTIONAL_RUNTIME_MVP` until independently validated. Historical paths/commands/report filenames are provenance, not mandates for current DT. Third-party code licenses, revisions and permissions UNKNOWN; do not copy or execute upstream code without rights review.

## Bounded conditional mechanism
At an **existing** authorized DT proof/acceptance consumer, distinguish evidence-derived completion from report-driven or manifest-only PASS. Identify the actual producer, persisted evidence, independent validator, acceptance consumer, revision, read/write scopes, permission owner, replay and rollback contracts. A report is not Ground merely because it is committed or all-green. Do not create a parallel proof platform.

### Source-clause → prompt-section coverage / negative controls
| Full historical source clause | Conditional future contract and discriminating test |
|---|---|
| §§1–2 evidence-derived acceptance and mandatory real execution | Every required acceptance row binds an actual scenario, validator/test command, exit code, immutable source revision and digest-checked artifact. Reject missing, extra, duplicate, fabricated, swapped-identity or manifest-only PASS; preserve UNKNOWN/BLOCKED rather than promote. |
| §§2–3 persisted replay and scenario proof | Re-run safe and unsafe scenarios from persisted manifest/state/events/artifact hashes, goal/context/seed/clock, gate/review/promotion decisions and verdict; reject stale manifest, reconstructed expected state, modified event hash or self-promoted unsafe run. |
| §§2–3 real source nonmutation | Capture tracked source before and immediately after actual safe scenario; compare modified/added/deleted paths and digests, allow only explicit generated-report exclusions. Missing manifest, unauthorized write or changed tracked source must fail closed. |
| §§2–4 real gap discovery, compatibility, reuse, traceability | Run bounded actual source search with path/line/context and evidence; compare real interface/version compatibility and dependency/reuse mapping. Each PASS requirement must point to executed code/test/validator and verified receipt; reject static reports, hardcoded FIXED, unclosed NEEDS_REVIEW, missing or stale trace. |
| §§2–5 adversarial audit and validator negatives | Corrupt report copy, acceptance row, identity, command transcript (including all-green transcript), digest, audit record and replay; require expected rejecting validator, nonzero exit and specific correct reason. Missing validator, import failure, wrong working directory or infrastructure failure must NOT count as successful attack rejection. Audit warning cannot be silently ignored. |
| §§2–6 two-run idempotency and reproducibility | Run proof target twice as independently clean executions on unchanged tracked source; preserve exact raw digests, transcripts, environment and exit codes; compare stable semantic verdict/state/event/evidence hashes with only explicitly allowlisted volatile timestamp/duration normalization. Regenerate ignored reports from tracked source. Reject hidden nondeterminism and one-run baseline-vs-final masquerading as two runs. |
| §§5–8 historical commands and final evidence bundle | Historical `compileall`, `prove-functional-runtime-mvp` twice, idempotency, `test-evolve`, `prove-format`, optional `test-quick` are historical examples ONLY. Future coder must discover authorized current-DT equivalents; report starting/ending revision, changed files, exact commands/exits, gap closure, replay/nonmutation/compatibility/audit/idempotency evidence and remaining blockers. No GitHub Actions. |

**Positive test:** an authorized actual proof target produces independently replayable persisted evidence and repeatable receipts, with correctly scoped successful and denied scenarios. **Negative tests:** omit acceptance row; swap proof identity; forge PASS; alter replay state/event hash; mutate source; replace gap search with static text; omit compatibility; forge all-green transcript; downgrade audit failure to warning; change semantic outputs across clean runs; fail validator infrastructure. Every negative must reject for the *intended* reason or remain UNKNOWN, never count as proof of safe rejection. No test results are claimed here.

## Future-coder permission and applicability gates
Only when explicitly user-invoked, inspect CURRENT private DT source/tests, real proof consumer, owner and permissions, and existing prompts/canonical clusters. If equivalent mechanism already present: **ALREADY_PRESENT** with exact tests/source. If no proof consumer: **NO_APPLICABILITY**. If no authorized fixture, real persisted artifacts, safe negative-test sandbox or independent oracle: **NO_AUTHORIZED_FIXTURE** and STOP. Any applicable bounded change requires separate authorization, existing-owner integration, actual tests and independently fetched exact-revision receipts; do not alter private DT in this deferred prompt run. No automatic external acquisition, host tests, new workers, CI or privileged operations.

## Distinction and limitations
This is a **proof-of-proof anti-false-PASS acceptance contract**, not a replacement for DT-IP-0037 matrix-register vocabulary, DT-IP-0039 tool effect contracts, DT-IP-0043 obligation-to-runtime handoff or DT-IP-0053 skill-evaluation Ground. Verify overlap at clause level before coding. Historical Agent_X assertions and paths are unverified current-DT hypotheses. Full live distilled source and full historical predecessor were retrieved; this Transformer mapping is NOT independent Scout coverage certification. Source retained pending independent comparison and rights/provenance audit.

## Scout COVERAGE_GAP A–D grouped repair — archival §§3–7 (conditional, NOT_EXECUTED)

This is a clause-level transfer of the historical Agent_X proof contract, **not** a mandate to reproduce Agent_X filenames, Make targets, its 39 components, or its proof platform in current DT. Future authorized coder must map each item to an actual current-DT proof consumer and existing owner, document **NOT_APPLICABLE** with evidence for absent components, and never turn a missing required applicable proof into PASS. Historic requirements remain reviewable below.

| Historical source | Precise conditional coverage | Fail-closed tests |
|---|---|---|
| §3 A–B | Exact 39-name acceptance roster below; required row derives from validated proof bundle PASS, evidence_refs, checked digests, matching revision, no report-only PASS; FAIL/BLOCKED/UNKNOWN propagate. | Missing, extra/unknown-only, duplicate, failed, stale, commit mismatch, forged/empty evidence and missing proof object reject. |
| §3 C | Safe and unsafe persisted replay manifests: complete schema below; replay verifies referenced state/event/artifacts and reruns with recorded seed/clock/profile/actors and decisions. | No manifest, missing path/hash, changed event/state/artifact, missing safety event, missing self-promotion invariant, mismatched verdict/decision reject. |
| §3 D/I | Source before/after snapshots wrap **actual** safe scenario; complete mutation schema below; observer exception is failure, not false. | Missing/invalid report, empty scope, stale commit, missing/changed hash, added/removed/changed source or observer failure reject. |
| §3 E | Real bounded search over original specified scope/patterns below; classify every match NEW_GAP/CLOSED/OUT_OF_SCOPE, resolve or justify and link evidence. | Missing patterns/scope, zero files/docs, unclassified matches, NEW_GAP unresolved, CLOSED without evidence, OUT_OF_SCOPE without rationale reject. |
| §3 F | Real compatibility checks: preserved critical Make targets/test roster, validators, replay/scenario files, L0/L1/L2 nonmutation, regenerated ignored reports, successful compile/test/format and two runs; structured check evidence. | Static PASS, missing check/ref, failed command or missing required file reject. |
| §3 G–H | Transcript schema and provenance below; audit attack 6 both inserts nonexistent successful command and mutates real required command. Audit nonzero must fail entire proof. | Missing provenance/stdout/stderr hashes, duration <=0 for executed command, source != subprocess, unknown/contradictory duplicate/stale command, warning-only audit reject. |
| §3 J | Dynamic traceability binds existing implementation_refs, test_refs, validator_refs, evidence_refs, related proof bundle PASS. | Missing refs/path or failed proof => BLOCKED, never PASS. |
| §3 K, §4 | Two independent consecutive proof executions, idempotency report and validator; historical ordered stages below, no recursive proof target. | One run, nonzero run, unstable semantic state or hidden nondeterminism reject. |
| §§5–7 | Exact 25 artifact roster and 17-field final reporting contract below, only where current consumer genuinely requires equivalent evidence. | Missing applicable artifact, unreproducible ignored report, incomplete required final evidence => BLOCKED. |

### A. Historical acceptance roster (39 exact component identities)
The archival `REQUIRED_ACCEPTANCE_COMPONENTS` list is:
1. `deterministic runtime context`
2. `workspace manager`
3. `artifact store`
4. `typed I/O envelope`
5. `runtime profile`
6. `readiness check`
7. `state store`
8. `event bus`
9. `action lifecycle`
10. `contract registry`
11. `capability graph`
12. `policy rule engine`
13. `decision gate`
14. `invariant engine`
15. `security envelope`
16. `transaction manager`
17. `simulation engine`
18. `report generation executor`
19. `observation system`
20. `rollback controller`
21. `circuit breaker`
22. `review interface`
23. `promotion gate`
24. `scenario harness`
25. `functional orchestrator`
26. `safe report generation scenario`
27. `unsafe self-promotion scenario`
28. `persisted replay`
29. `compatibility report`
30. `reuse map`
31. `command transcript`
32. `source mutation proof`
33. `artifact overwrite protection`
34. `requirement traceability`
35. `unknown-gap discovery`
36. `validator negative tests`
37. `anti-false-PASS audit`
38. `clean-checkout reproducibility`
39. `idempotency`

For current DT, map each name to an existing equivalent, or record an explicit inapplicability decision supported by source inspection. An applicable required row must have proof-bundle status PASS, evidence_refs, validated content hashes and revision; reject unknown-only, extra, missing, duplicate, stale, mismatched or failed rows. Preserve non-PASS dispositions and test all failure variants; do not assume all 39 components exist in DT.

### B. Persisted replay, source mutation and command provenance schemas
Historical replay manifest fields: `schema_version=1.0.0`, `scenario_name` (safe_report_generation / unsafe_self_promotion), `run_id`, `goal_id`, `runtime_context{seed,fixed_clock,profile_id}`, `state_records_path`, `state_records_hash`, `event_log_path`, `event_log_hash`, `artifact_refs[{path,hash,type}]`, `gate_decisions`, `invariant_results`, `review_decisions`, `promotion_decisions`, `safety_events`, `final_verdict` (PASS / DENIED_AND_RECORDED / FAIL / BLOCKED), `created_at`, `git_commit`. Read persisted data, validate all hashes, replay from recorded actors/context/decisions and compare actual verdict, gate/invariant/promotion/safety outputs. Never accept a report-row fallback when the manifest is absent.

Historical source mutation report: `scenario_name`, `mutation_detected`, `before_manifest`, `before_manifest_hash`, `after_manifest`, `after_manifest_hash`, `source_scope`, `files_changed`, `files_added`, `files_removed`, `git_commit`. The source scope must be nonempty; before/after capture must bracket the real safe scenario; observer exceptions must set mutation detected and an explicit error. Reject invalid JSON, missing manifest or hashes, mismatched digest, stale revision, empty file scope, or any unauthorized changed/added/removed file.

Historical subprocess command record: `command`, `exit_code`, `timestamp`, `duration_seconds`, `git_commit`, `branch`, `environment`, `source=subprocess`, `provenance_id`, `stdout_hash`, `stderr_hash`. Require genuine execution receipts, positive duration for real commands, matching revision, no contradictory duplicate, and no synthetic all-green transcript. The audit must test fake-success insertion AND meaningful alteration of a real command, and reject for the intended reason.

### C. Real discovery, compatibility, traceability and ordered proof
Historical minimum search scope: `Makefile`, `docs/`, `tools/agentx_evolve/`, `tests/`, `.agentx-init/reports/` if present. Historical search patterns (exact case/terms):
`TODO`, `FIXME`, `stub`, `placeholder`, `pass`, `hardcoded`, `static PASS`, `exit_code`, `replay`, `overwrite`, `mutation`, `source mutation`, `self promotion`, `self-promotion`, `promotion`, `compatibility`, `reuse map`, `validator`, `deterministic`, `seed`, `clock`, `event log`, `artifact`, `evidence`, `proof`, `acceptance`, `report`, `manifest`, `hash`, `sha256`, `temp`, `random`, `datetime.now`, `time.time`, `uuid`, `glob`, `os.walk`, `symlink`, `path traversal`.

Every actual match needs path/line/context and `NEW_GAP` (must resolve), `CLOSED` (must cite evidence_refs), or `OUT_OF_SCOPE` (must justify); unclassified or unresolved in-scope gaps forbid final PASS. Check real file existence, preserved pre-existing Make targets, test roster, proof/validator/replay/scenario files, L0–L2 nonmutation, generated-report regeneration and actual successful test/format/compile command receipts. Compatibility check fields: `report_type`, `verdict`, `git_commit`, `created_at`, `checks[{name,status,details,evidence_refs}]`, `known_failures`, `conflicts_detected`, `migration_decisions`; reject PASS with any failed/missing check or evidence. Traceability PASS requires implementation, test, validator, evidence references to existing paths and corresponding proof bundle PASS; otherwise BLOCKED.

Historical proof order: remove/regenerate generated reports; compileall; focused non-live scenario tests; initial proof collection; report generation; gap discovery, traceability, replay, reuse, source-safety, anti-false-PASS validators; broader `test-evolve` and `prove-format`; transcript validator; full proof collection; final report validator; transcript regeneration. Separate `prove-functional-runtime-mvp-idempotent` historically runs proof twice then generates/validates idempotency, never recursively calls itself. Historical final commands also include `git status --short` before/after and optional `test-quick`. These are **historical stage-equivalence obligations**, not authority to run commands or add Make targets now; use current-DT equivalents only after user authorization and applicability preflight.

### D. Complete historical output roster (25 evidence artifacts)
Original directory prefix `.agentx-init/reports/` is provenance only. Preserve an existing current-DT equivalent when needed, not a new 25-file reporting system:
1. `functional_runtime_mvp_gap_discovery_report.md`
2. `functional_runtime_mvp_gap_discovery_report.json`
3. `functional_runtime_mvp_requirement_traceability_matrix.md`
4. `functional_runtime_mvp_requirement_traceability_matrix.json`
5. `functional_runtime_mvp_proof_bundle.json`
6. `functional_runtime_mvp_acceptance_matrix.json`
7. `FUNCTIONAL_RUNTIME_MVP_ACCEPTANCE_REVIEW.md`
8. `functional_runtime_mvp_command_transcript.md`
9. `functional_runtime_mvp_command_transcript.json`
10. `functional_runtime_mvp_evidence_manifest.json`
11. `functional_runtime_mvp_replay_report.md`
12. `functional_runtime_mvp_replay_report.json`
13. `functional_runtime_mvp_replay_manifest_safe_report_generation.json`
14. `functional_runtime_mvp_replay_manifest_unsafe_self_promotion.json`
15. `functional_runtime_compatibility_report.md`
16. `functional_runtime_compatibility_report.json`
17. `functional_runtime_reuse_map.md`
18. `functional_runtime_reuse_map.json`
19. `functional_runtime_mvp_source_hash_manifest_before.json`
20. `functional_runtime_mvp_source_hash_manifest_after.json`
21. `functional_runtime_mvp_source_mutation_report.json`
22. `functional_runtime_mvp_anti_false_pass_audit.md`
23. `functional_runtime_mvp_anti_false_pass_audit.json`
24. `functional_runtime_mvp_idempotency_report.md`
25. `functional_runtime_mvp_idempotency_report.json`

Historical final coding-agent report has exactly 17 required fields: (1) starting commit, (2) ending commit, (3) files changed, (4) files created, (5) exact blockers closed, (6) new gaps from real search, (7) each gap closure/classification, (8) proof target commands and exits, (9) test-evolve exit, (10) prove-format exit, (11) idempotency result, (12) replay-manifest summary, (13) source-mutation summary, (14) compatibility summary, (15) anti-false-PASS audit summary, (16) remaining blockers, (17) final classification. The archival classification `FUNCTIONAL_RUNTIME_MVP` requires full evidence; otherwise `FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE`. These tokens are not current DT status claims. No commands, tests or private-DT implementation were performed by Transformer.
