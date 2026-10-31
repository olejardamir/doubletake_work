# Agent_X — Full Point-Form Work Plan and Next Direction

This document is a full replacement planning document. It combines the remaining work from the latest end-to-end checklist with the newer decision about the Cohere/reference-repo suggestions.

## Bottom-line direction

- Do **not** make the next step a broad reference-repo import.
- Do **not** clone many external projects and start copying architecture into Agent_X before the current runtime MVP claim is provable.
- Use the old Cohere/reference repos only as **design references** and **later integration examples**.
- The next direction should be:
  - Finish the `FUNCTIONAL_RUNTIME_MVP` proof boundary.
  - Make the MVP narrow and deterministic.
  - Prove one local runtime loop end to end.
  - Then add exactly one real external integration.

## Target MVP definition

- Define the next real MVP as:
  - A deterministic local coding-agent runtime that can:
    - accept a controlled goal;
    - build bounded context;
    - create a proposed action;
    - validate policy/capability/contract/readiness/security-envelope requirements;
    - execute through an allowed local tool path;
    - write artifacts through the artifact store;
    - record state and events;
    - require review before promotion;
    - deny unsafe/self-review/self-promotion cases;
    - trip circuit breakers when required;
    - replay the same run from frozen evidence;
    - prove all of the above from a clean checkout.

## Workstream 1 — Freeze the MVP scope

- Define exactly what `FUNCTIONAL_RUNTIME_MVP` means.
- Split every Agent_X layer into one of these states:
  - implemented and proven;
  - implemented but unproven;
  - stub-only;
  - explicitly out of scope for this MVP;
  - future work;
  - blocking.
- Do not allow broad architecture documents to imply implemented runtime behavior.
- Do not allow planning prompts or checklists to count as implementation evidence.
- Create a machine-readable architecture-scope matrix covering:
  - Initiator;
  - Security Sandbox;
  - Policy Registry;
  - Patch Execution;
  - Failure Taxonomy;
  - Tool/MCP Adapter;
  - Model Adapter;
  - Local Model Runtime Profile;
  - Context Builder;
  - Prompt Contract;
  - LLM Worker;
  - Self-Evolution Orchestrator;
  - Human Review;
  - Promotion Gate;
  - Git Integration;
  - Evaluation Harness;
  - Long-Term Learning;
  - Doc Sync;
  - Task Queue;
  - Monitoring;
  - Packaging;
  - Backup/DR;
  - Final Acceptance.
- Fail final MVP classification if any required layer is ambiguous.
- Explicitly mark non-MVP layers as out of scope instead of pretending they are covered.

## Workstream 2 — Fix proof ordering and final verdict integrity

- Split proof execution into phases:
  - generate required reports;
  - run validators and record every command;
  - freeze transcript/proof/evidence/final verdict;
  - validate frozen outputs without rewriting them.
- Move transcript validation after all required commands have already been recorded.
- Fix the `record_command.py` self-reference problem where the current command appears only after the subprocess exits.
- Move all-in-one validation to the true final phase.
- Do not write `classification: FUNCTIONAL_RUNTIME_MVP` until final validation has actually passed.
- Add a final validator that rejects any final verdict written before the final proof bundle, evidence manifest, transcript, acceptance matrix, and report snapshot are frozen.
- Prevent any report or proof artifact from being rewritten after final validation.

## Workstream 3 — Fix anti-false-PASS auditing

- Run anti-false-PASS only against complete and stable reports.
- Fix report-dir handling so validators attack the intended temporary report directory, not the original reports and not a nested wrong path.
- Split anti-false-PASS into bootstrap and final modes.
- Do not include the anti-false-PASS validator in its own clean-control set before the audit report exists.
- Require exact expected attack count for the configured audit version.
- Fail if any attack names an expected rejector that is not present in the validator execution set.
- Add attacks that falsify:
  - transcript evidence;
  - final verdict evidence;
  - proof-bundle hashes;
  - report hashes;
  - acceptance-matrix rows;
  - unsafe self-promotion denial evidence;
  - readiness evidence;
  - runtime-profile evidence;
  - security-envelope evidence;
  - transaction evidence;
  - replay evidence;
  - artifact-store overwrite evidence;
  - clean-checkout evidence;
  - schema/version evidence.
- Ensure each attack produces a structured rejected result.
- Ensure a clean-control failure produces structured `FAIL/BLOCKED`, not a crash or false pass.

## Workstream 4 — Fix gap-list and coverage proof

- Remove all hardcoded local absolute paths.
- Store the gap list inside the repository or generate it as a tracked proof artifact.
- Resolve the gap list from:
  - repository-relative path;
  - documented CLI argument;
  - or generated proof report path.
- Validate that the gap list is non-empty and has the expected schema.
- Fail on missing IDs, duplicate IDs, malformed lines, or unexpected ID ranges.
- Replace silent `None` domain mappings with explicit statuses:
  - covered by specific validator;
  - covered by other validator;
  - intentionally out of scope;
  - blocked.
- Require every gap item to appear in a machine-readable coverage matrix.
- Fail if any item is silently skipped.
- Map every gap item to:
  - item ID;
  - layer/domain;
  - status;
  - validator;
  - report file;
  - proof-bundle key;
  - source/test references;
  - justification.

## Workstream 5 — Make proof reproducible from zero

- Add a clean-checkout proof from a fresh clone or fresh worktree.
- Delete `.agentx-init/reports` before the proof run.
- Prove all reports regenerate from tracked source files.
- Fail if any required input exists only on the developer machine.
- Add a CI-compatible proof script.
- Add GitHub Actions or another CI runner for the exact commit.
- Either require CI for final acceptance or explicitly mark CI as unavailable.
- Add a `prove-from-zero` script.
- Add a `verify-existing-proof` script that validates frozen evidence without regenerating it.
- Separate generation commands from validation commands.
- Ensure every validator accepts and respects `--report-dir`.
- Add tests proving validators do not read default reports when `--report-dir` is supplied.

## Workstream 6 — Strengthen artifact, report, and schema integrity

- Create a required-artifacts manifest.
- Validate that every required JSON report exists and parses.
- Validate that every required Markdown report is generated from the authoritative JSON source.
- Prevent Markdown-only evidence from counting as proof.
- Validate that JSON and Markdown reports do not contradict each other.
- Add schema versions for every JSON artifact.
- Add strict schema validation for:
  - transcript;
  - proof bundle;
  - evidence manifest;
  - acceptance matrix;
  - final verdict;
  - anti-false-PASS report;
  - replay manifest;
  - state store;
  - event log;
  - transaction log;
  - artifact manifest;
  - runtime-profile report;
  - readiness report;
  - security-envelope report;
  - gap coverage matrix;
  - architecture-scope matrix.
- Add an artifact-retention policy.
- Make proof artifacts immutable after freeze.
- Use atomic writes for frozen proof outputs.
- Add final filesystem snapshot validation.
- Prove no hidden/debug-only file is required unless included in the evidence manifest.

## Workstream 7 — Build the narrow deterministic runtime slice

- Implement or verify a real runtime entrypoint.
- The entrypoint should execute one controlled local agent goal end to end.
- Add a deterministic `ModelAdapter` interface.
- Add a deterministic mock model as the first adapter.
- Add a `ToolAdapter` interface.
- Add deterministic local tools only for the first MVP.
- Add a bounded `ContextBuilder`.
- Add a versioned `PromptContract`.
- Add runtime-profile enforcement.
- Add readiness checks before action proposal, validation, execution, review, and promotion.
- Add a sealed security envelope for every executor call.
- Add transaction staging, commit, rollback, and transaction proof.
- Add artifact-store writes through the approved artifact path only.
- Add event-log and state-store persistence.
- Add human-review/promotion-gate semantics even if the first reviewer is simulated/deterministic.
- Add circuit-breaker gating at the start of runtime execution.
- Add replay from frozen manifest and frozen evidence.

## Workstream 8 — Prove runtime behavior with scenarios

- Add a safe positive scenario:
  - goal accepted;
  - context built;
  - action proposed;
  - policy/capability/contract/readiness passes;
  - security envelope sealed;
  - transaction staged;
  - execution produces artifact;
  - review accepted;
  - promotion allowed;
  - artifact persisted;
  - event/state logs persisted;
  - replay succeeds.
- Add unsafe negative scenarios for:
  - policy denial;
  - capability denial;
  - missing contract;
  - invalid runtime profile;
  - readiness failure;
  - missing security envelope;
  - tampered security envelope;
  - wrong run ID;
  - wrong action ID;
  - wrong agent ID;
  - wrong workspace;
  - execution failure;
  - transaction rollback;
  - review denial;
  - missing review;
  - expired review;
  - self-review;
  - self-promotion;
  - circuit breaker already tripped;
  - replay mismatch;
  - artifact hash mismatch.
- For every denied scenario, prove:
  - denial occurs before promotion;
  - no accepted artifact is produced;
  - failure evidence is retained;
  - state and event traces are durable;
  - final proof rejects any falsified denial evidence.

## Workstream 9 — Runtime profiles

- Define and enforce at least these profiles:
  - `STRICT`;
  - `DRY_RUN`;
  - `REPLAY`;
  - `AUDIT_ONLY`.
- Prove `STRICT` blocks unsafe or under-evidenced actions.
- Prove `DRY_RUN` does not commit artifacts or promote outputs.
- Prove `REPLAY` refuses fresh execution except through controlled replay.
- Prove `AUDIT_ONLY` validates existing evidence without mutating runtime state.
- Cross-check profile consistency across:
  - security envelope;
  - transcript;
  - replay manifest;
  - proof bundle;
  - acceptance matrix;
  - final verdict.

## Workstream 10 — Source/test/evidence binding

- Every claimed runtime behavior must be tied to:
  - source file;
  - test file;
  - scenario output;
  - validator output;
  - proof-bundle key;
  - acceptance-matrix row.
- Unit tests alone should not count as integration proof.
- Source file existence alone should not count as runtime integration.
- Add a validator that fails if a component claimed as integrated is not invoked in an end-to-end proof path.
- Add pytest result binding per requirement.
- Add source-level sabotage controls for runtime code.
- Add negative tests proving validators fail when source/test bindings are missing or contradictory.

## Workstream 11 — Packaging/import/runtime entrypoint proof

- Prove the project imports without relying only on ad-hoc `PYTHONPATH` behavior.
- Add package/import tests from a clean environment.
- Add CLI/module entrypoint tests.
- Add runtime smoke test for the actual MVP entrypoint.
- Ensure clean-checkout proof runs the same entrypoint a user would run.
- Ensure the proof does not depend on local shell aliases, local paths, local venv quirks, or developer-only state.

## Workstream 12 — Confidentiality, side-effect, and resource controls

- Add secret-redaction rules for transcripts and reports.
- Fail proof if known secret patterns appear in generated artifacts.
- Define allowed write paths.
- Fail if runtime writes outside allowed paths.
- Define allowed read paths.
- Fail if runtime reads unapproved paths.
- Add timeout limits for proof commands and runtime scenarios.
- Add resource caps where practical.
- Add input-validation tests for malformed goals, malformed contracts, malformed policies, malformed profiles, and malformed replay manifests.
- Ensure infrastructure errors, timeouts, and unexpected exceptions are represented as `FAIL/BLOCKED`, never `PASS`.

## Workstream 13 — Concurrency, restart, and run isolation

- Define whether concurrent runtime runs are in scope for this MVP.
- If in scope:
  - isolate proof runs by `proof_run_id`;
  - isolate runtime runs by `run_id`;
  - prevent artifact/report collisions;
  - lock final proof writes;
  - prove concurrent safe/unsafe runs do not contaminate each other.
- If out of scope:
  - explicitly document it;
  - add a guard that rejects concurrent runtime execution for this MVP.
- Add restart/recovery tests for interrupted runs if restart is claimed.
- Ensure a resumed run cannot reuse stale proof evidence incorrectly.

## Workstream 14 — Reference-repo usage plan

- Do not import all reference repos into Agent_X.
- Create a reference-repo research folder outside the Agent_X source tree.
- Use the references only to extract design notes and acceptance criteria.
- Highest-value references for near-term Agent_X:
  - `north-mcp-python-sdk` for MCP/server/tool-boundary ideas;
  - `cohere-security-toolkit` for security-tool/MCP boundary ideas;
  - `SWE-agent` for coding-agent interface and repo-edit/test-loop ideas;
  - `cohere-terrarium` for sandbox design ideas only;
  - `self-reflection-planning-paper` for scenario/evaluation ideas.
- Useful later, but not next:
  - `cohere-python` for a real Cohere model adapter;
  - `mcp-atlassian` for real-world MCP connector structure;
  - `vcrpy` for deterministic API/replay testing patterns;
  - `cohere-toolkit`, connectors, document parsing, vector DBs, and search sandboxes for future RAG/context-builder work.
- Defer for now:
  - local model runtime repos;
  - confidential execution repos;
  - enterprise auth/proxy/deployment repos;
  - broad RAG/connectors/vector-search integration.

## Workstream 15 — First real integration after deterministic MVP

- After deterministic local MVP passes, choose exactly one real integration:
  - Option A: Cohere model adapter.
  - Option B: MCP/tool adapter.
- Do not add both at the same time.
- For Option A:
  - add real `ModelAdapter` implementation;
  - keep deterministic mock model as default for proof;
  - record model configuration without leaking secrets;
  - add replay/stub mode so proof does not require live API access.
- For Option B:
  - add one local MCP-style tool server or connector;
  - enforce allowlist, auth boundary, tool schema validation, and telemetry/redaction;
  - add denial tests for unauthorized tools and malformed tool calls.
- Do not add RAG/vector/document connectors until the first real adapter is proven.

## Workstream 16 — Final acceptance rules

- Final verdict may say `FUNCTIONAL_RUNTIME_MVP` only if:
  - proof runs from clean checkout;
  - all required files are repository-relative or generated during proof;
  - all validators run and pass;
  - anti-false-PASS attacks are rejected;
  - final transcript is complete;
  - final proof bundle hashes match frozen artifacts;
  - final evidence manifest matches the filesystem snapshot;
  - final acceptance matrix has no missing required row;
  - architecture-scope matrix has no ambiguous required layer;
  - runtime scenario evidence exists for required behavior;
  - unsafe scenarios deny correctly;
  - replay succeeds from frozen evidence;
  - final verdict is validator-derived, not hardcoded.
- If any required item fails, final classification should be one of:
  - `BLOCKED`;
  - `PROOF_INCOMPLETE`;
  - `RUNTIME_INCOMPLETE`;
  - `FUNCTIONAL_RUNTIME_MVP_PROOF_HARDENING_IN_PROGRESS`.

## Recommended execution order

- Step 1: Freeze and validate architecture scope.
- Step 2: Fix proof ordering, transcript timing, final verdict timing, and no-rewrite-after-freeze rules.
- Step 3: Fix anti-false-PASS report-dir and phase problems.
- Step 4: Fix gap-list portability and full coverage matrix.
- Step 5: Add clean-checkout/CI-compatible proof.
- Step 6: Add strict schemas and required-artifacts manifest.
- Step 7: Build deterministic runtime entrypoint and interfaces.
- Step 8: Add safe and unsafe runtime scenarios.
- Step 9: Add replay proof over frozen evidence.
- Step 10: Add source/test/evidence binding validators.
- Step 11: Run proof from zero.
- Step 12: Only after that, select one real external integration.

## Detailed inherited end-to-end checklist from Rev9

1. Fix the proof target ordering so transcript validation runs only after every required command has already been recorded.
2. Split the proof process into clear phases: generate reports/tests, run and record validators, freeze transcript/proof/evidence/final verdict, then validate frozen outputs.
3. Fix the transcript validator timing problem caused by record_command.py appending the current command only after the subprocess exits.
4. Move validate_functional_runtime_mvp_transcript.py later in the Makefile, after all required validators, report generators, traceability generation, idempotency generation, and final proof commands have been recorded.
5. Move validate_functional_runtime_mvp_all_in_one.py to the true final validation phase, after the final proof bundle, evidence manifest, transcript, acceptance matrix, and final verdict have all been regenerated.
6. Ensure the anti-false-PASS audit runs only after the report set it attacks is complete and stable.
7. Update run_anti_false_pass_audit.py so its clean-control validator set matches the phase it is actually auditing.
8. Fix run_anti_false_pass_audit.run_validator() so it accepts an exact reports directory and passes that exact path to --report-dir; it must not append .agentx-init/reports when the caller already passed a reports directory.
9. Add a test proving anti-false-PASS validators run against the temporary attacked reports directory, not a nested nonexistent path and not the original report directory.
10. Split anti-false-PASS clean-control into bootstrap and final modes; do not include validate_functional_runtime_mvp_anti_false_pass.py in clean-control before the audit report itself exists.
11. Make anti-false-PASS report generation robust when clean-control fails: write a structured FAIL JSON/Markdown report and exit nonzero instead of crashing while rendering missing fields.
12. Make anti-false-PASS require the exact expected attack count for the configured audit version, not only a minimum threshold such as 15.
13. Make anti-false-PASS fail if any attack names an expected rejector that is not present in the validator execution set.
14. Expand the anti-false-PASS clean-control/final-control validator list so it covers the same final validator set used to claim FUNCTIONAL_RUNTIME_MVP, including idempotency, validator-proof, traceability, all-in-one, and final-verdict validators.
15. Add a final anti-false-PASS audit after all final reports are produced, or explicitly separate pre-final anti-false-PASS from final anti-false-PASS.
16. Remove the hardcoded absolute gap-list path: /home/glompy/Desktop/ASTROCYTECH/voya/agent_x_rev5_expanded_corrective_gap_list_v23.txt
17. Store the gap list inside the repository or generate it as a tracked proof artifact during the proof run.
18. Make validators/common.py resolve the gap list from a repository-relative path, a documented CLI argument, or a generated report path.
19. Make clean-checkout validation fail if any required proof input exists only on the developer’s local machine.
20. Fix the “all gap items covered” claim. check_all_gap_items currently skips domains mapped to None.
21. Replace None mappings in omnibus validators with explicit coverage decisions: covered_by_specific_bundle_key, covered_by_other_validator, intentionally_out_of_scope, or blocked.
22. Require every gap-list item to appear in a machine-readable coverage report, even if the decision is out of scope or covered elsewhere.
23. Add a validator that fails when any gap item is silently skipped.
24. Add a validator that fails when a domain is mapped to None without explicit justification and evidence reference.
25. Add a generated gap coverage matrix mapping every gap item ID to validator, report file, proof-bundle key, evidence reference, status, and justification.
26. Validate that the gap-list file is non-empty, has the expected schema, and contains every required ID range before any coverage checker can pass.
27. Fail if the gap list has missing IDs, duplicate IDs, malformed lines, or IDs outside the claimed range.
28. Replace derived sub-key guessing in check_all_gap_items() with explicit item-ID-to-proof mappings so wording changes cannot silently break or fake coverage.
29. Make check_all_gap_items() reject non-dict proof entries when per-item subfields are required; a bundle key existing as a scalar/list must not count as per-item evidence.
30. Update advanced/deep/enterprise/aspirational validators so the per-item data-driven check is truly per item, not only per recognized domain.
31. Fix omnibus validators so a missing or invalid proof bundle produces a structured FAIL and returns safely; they must not continue into per-item checks with None/non-dict bundle and crash.
32. Add negative tests proving advanced/deep/enterprise/aspirational validators fail cleanly, with actionable errors, when the proof bundle is missing, malformed, or the wrong type.
33. Fix the proof bundle and report hash freeze order. No report should be modified after the final proof bundle records its hash.
34. Regenerate the evidence manifest after all final report writes, regenerate the proof bundle after the evidence manifest, then ensure no later process rewrites either one.
35. Fix final_verdict.json generation so it is not created before the final validation state is actually known.
36. Do not write classification FUNCTIONAL_RUNTIME_MVP until all validators have passed in the final phase.
37. Add a final validator that fails if final_verdict.json says FUNCTIONAL_RUNTIME_MVP but any required validator was not run, failed, or is missing from the transcript.
38. Add a final validator that fails if final_verdict.json was written before the final transcript/proof bundle/evidence manifest timestamps.
39. Fix the idempotency flow so idempotency generation and validation are included in the same final proof transcript that is being validated.
40. Ensure generate_idempotency_report.py is recorded in the command transcript before validate_functional_runtime_mvp_transcript.py checks for it.
41. Ensure validate_functional_runtime_mvp_idempotency.py is recorded and included in the final transcript requirements.
42. Ensure prove-functional-runtime-mvp records the dual-run proof cleanly, not only the inner prove-functional-runtime-mvp-once runs.
43. Make the final proof robust to changing timestamps by normalizing volatile fields or explicitly excluding them from deterministic comparison.
44. Replace literal working_tree='clean' values in generated verdicts with actual git status checks captured at proof start and proof end.
45. Fail the proof immediately if the working tree is dirty at proof start, unless the dirty paths are explicitly listed as generated proof outputs and verified.
46. Ensure the final proof does not mix evidence from multiple proof_run_id values unless the relationship is explicitly modeled, such as dual-run idempotency evidence.
47. Add a clean-checkout proof that runs from a fresh clone or fresh worktree, not from an already-prepared local checkout.
48. Ensure clean-checkout validation deletes .agentx-init/reports before the proof run.
49. Ensure clean-checkout validation proves all reports can be regenerated from tracked source files.
50. Ensure clean-checkout validation proves no local absolute path is required.
51. Add CI evidence or a CI-compatible script for make prove-functional-runtime-mvp.
52. Configure GitHub Actions or another CI runner to execute make prove-functional-runtime-mvp on the exact commit.
53. Make final acceptance depend on CI, or explicitly mark CI as not yet available.
54. Add a dependency/environment reproducibility proof: Python version, required packages, install command, and any system assumptions needed for a clean checkout run.
55. Ensure the proof target has no hidden dependency on globally installed developer packages outside documented requirements.
56. Add an offline/no-network proof mode, or explicitly mark any live/network dependency as out of scope and blocking for FUNCTIONAL_RUNTIME_MVP.
57. Fix validate_functional_runtime_mvp_validator_proof.py so its positive-control check fails when any validator returns nonzero, not only infrastructure errors.
58. Add true negative-control tests for validators themselves, not only structural checks.
59. Ensure validator-proof confirms each validator rejects at least one relevant corrupted input.
60. Ensure validator-proof confirms each validator passes on clean input.
61. Ensure validator-proof confirms each validator fails for the intended reason, not a generic missing-file or parse error.
62. Add validator self-tests to the Makefile proof target.
63. Make validator proof store a structured validator-results registry with validator name, command, report-dir, exit code, stdout/stderr hashes, input report hashes, and timestamp.
64. Validate that every final validator is read-only against the frozen report directory; validators must not modify reports while validating them.
65. Add JSON schema or schema-version validation for proof_bundle, evidence_manifest, acceptance_matrix, replay_manifest, replay_report, traceability_matrix, compatibility_report, anti_false_pass_audit, and final_verdict.
66. Ensure anti-false-PASS attack 19 cannot be skipped just because the idempotency report is not generated yet.
67. Ensure every anti-false-PASS attack target exists before the audit runs.
68. Fail the proof if any anti-false-PASS attack result is SKIPPED, ERROR, NO_CHANGE, ACCEPTED, WEAK_REJECTION, WRONG_REASON, or INFRASTRUCTURE_ERROR.
69. Fix run_anti_false_pass_audit.py main() so it exits nonzero when attacks_with_infrastructure_error or attacks_errored is greater than zero; infrastructure and attack-application errors must not be able to produce process success.
70. Ensure anti-false-PASS expected rejectors include all relevant final validators, including idempotency when idempotency artifacts are part of final proof.
71. Ensure anti-false-PASS checks that validators were actually run against the corrupted copy, not the original report directory.
72. Ensure anti-false-PASS stores before/after hashes for the exact attacked files, not only the whole directory state.
73. Ensure anti-false-PASS verifies that the specific intended corruption was applied.
74. Ensure anti-false-PASS verifies that the rejection reason matches the intended corruption.
75. Strengthen command transcript provenance. provenance_id currently hashes only the command string.
76. Make command provenance include command, exit code, stdout hash, stderr hash, timestamp, git commit, working directory, environment, and tool version.
77. Validate stdout_hash and stderr_hash against stored full stdout/stderr artifacts, not only truncated summaries.
78. Store full stdout/stderr logs or content-addressed log artifacts for every recorded command.
79. Validate that the command transcript cannot be faked by editing only JSON summaries.
80. Add a transcript validator that re-hashes full command output artifacts and matches them to transcript entries.
81. Add a transcript validator that fails if any command has duplicated provenance_id when it should be unique per execution.
82. Add a transcript validator that checks git_commit consistency across all proof commands.
83. Add a transcript validator that fails if required commands appear only in comments, summaries, or generated markdown rather than executable transcript entries.
84. Validate command ordering and phase boundaries in the transcript, not only substring presence of required command names.
85. Validate required commands by exact executable transcript entries, with arguments, working directory, exit code, and proof phase, not by loose text matching.
86. Ensure the transcript distinguishes commands executed by record_command.py from commands executed inside generate_mvp_reports.py, so duplicate or nested scenario runs cannot be confused.
87. Fix replay proof semantics. replay_execute.py should not reconstruct scenarios mainly from built-in SCENARIO_PARAMS.
88. Make replay_execute.py use the manifest as the primary source of runtime context, scenario inputs, expected outputs, event/state hashes, artifact refs, and safety events.
89. Store original scenario input payloads in the replay manifest.
90. Store original scenario output/verdict/evidence hashes in the replay manifest.
91. During replay, compare replayed outputs to original persisted outputs, not only the verdict string.
92. During replay, compare event log shape/content or canonical event hashes, not only final verdict.
93. During replay, compare state records or canonical state hashes, not only final verdict.
94. During replay, compare promotion decisions, invariant results, and safety events for the unsafe scenario.
95. Generate the replay report from actual replay_execute.py results, not by copying original_verdict into replay_verdict during report generation.
96. Link each replayed verdict back to the exact replay manifest, original scenario export, command transcript entry, and output hashes used to produce it.
97. Fix collect_mvp_proof.py so replay_proofs are derived from actual replay_execute.py results and artifact/state/event comparisons; it must not set original_verdict, replay_verdict, verdict_match, and artifact_hashes_match from the manifest alone.
98. Prevent the proof from merging evidence from the Makefile pytest run and the report-generator scenario rerun unless both runs are separately identified and reconciled.
99. Fail replay if the manifest lacks event_log_hash or state_records_hash.
100. Fail replay if event/state paths are absolute temp paths that cannot survive outside the original run, unless those files are copied into the proof report directory.
101. Copy replay state/event/artifact evidence into .agentx-init/reports or another stable proof directory.
102. Avoid replay manifests that reference temp directories deleted after tests.
103. Validate replay manifests after original temp test directories are cleaned up to prove evidence is durable.
104. Update scenario_export.py or the proof generator so exported state/event files are stored under stable proof output paths.
105. Fix source mutation proof so it covers the source scope that matters for the runtime proof.
106. Make source mutation detection prove that no source files changed during the whole proof run, not only during the safe scenario.
107. Capture source manifest before the full proof run and after the full proof run.
108. Fail if any tracked source file changes during proof generation.
109. Decide whether generated reports are allowed to change; if yes, exclude only the generated reports directory from source mutation scope.
110. Validate that source mutation manifests include the expected source directories and file counts.
111. Ensure MvpObserver._check_source_mutation is tested with an actual deliberate mutation and proves it detects it.
112. Ensure source mutation validator rejects missing before manifest.
113. Ensure source mutation validator rejects missing after manifest.
114. Ensure source mutation validator rejects mismatched manifest hashes.
115. Ensure source mutation validator rejects an empty source scope.
116. Make source mutation proof use a stable repository root and explicit source scope; avoid relying on Path.cwd() in a way that changes meaning depending on where the validator is invoked.
117. Add a negative source-mutation test that modifies a tracked source file between before/after manifests and proves the validator fails for the specific changed file.
118. Improve artifact safety proof. _write_artifact_safety_proof should record actual test results or proof outputs, not only that test files exist.
119. Make artifact safety proof include the command result for test_artifact_store.py.
120. Make artifact safety proof include actual overwrite-denial evidence.
121. Make artifact safety proof include actual path-traversal rejection evidence.
122. Make artifact safety proof include actual symlink-escape rejection evidence.
123. Validate that artifact_safety_proof.status cannot be PASS only because evidence files exist.
124. Add anti-false-PASS attack for artifact_safety_proof.status changed to PASS.
125. Root-confine MvpArtifactStore.read(), hash_path(), validate_ref(), classify(), link_to_run(), and export/list operations, not only write().
126. Reject artifact reads and hash checks for paths outside the artifact store root unless an explicit external-evidence policy allows them.
127. Validate metadata sidecar writes and reads are also root-confined and cannot follow symlinks outside the artifact root.
128. Ensure acceptance matrix rows for architecture components are backed by real traceability rows and real evidence hashes.
129. Ensure build_acceptance_rows.py does not allow inherited acceptance_rows status to bootstrap itself into PASS without independent evidence.
130. Validate that every acceptance row maps to a concrete requirement ID.
131. Validate that every acceptance row maps to at least one concrete source file and test file.
132. Validate that every acceptance row’s evidence hash matches current file content.
133. Validate that no acceptance row can PASS by referencing only the traceability matrix itself when underlying source/test evidence is missing.
134. Strengthen requirement traceability so each requirement validates implementation file existence, test file existence, and relevant validator existence.
135. Strengthen requirement traceability so it verifies the requirement-specific proof passed.
136. Add negative tests for requirement traceability: remove a row, corrupt evidence hash, remove implementation file reference, remove validator reference.
137. Ensure compatibility report is generated from actual checks, not static rows.
138. Ensure compatibility report includes supported platform metadata.
139. Ensure compatibility report fails if any compatibility check fails.
140. Ensure compatibility report cannot be changed to PASS while failing checks remain.
141. Ensure final verdict includes platform metadata.
142. Ensure final verdict includes proof target, proof run ID, git commit, working tree status, validator set, and final classification reason.
143. Ensure final verdict includes an explicit list of required validators and their pass/fail status.
144. Ensure final verdict is rejected if working tree is dirty, unless dirty state is intentionally allowed and documented.
145. Ensure proof bundle git_commit uses the full commit SHA or consistently validates short SHA vs full SHA.
146. Ensure all commit fields across transcript, proof bundle, evidence manifest, and final verdict are consistent.
147. Add stale-commit anti-false-PASS attacks for evidence manifest, final verdict, replay manifest, and acceptance review, not only proof bundle.
148. Ensure reuse map is regenerated by the proof target and validated by hash.
149. Ensure reuse map is not static without evidence.
150. Ensure reuse map maps reused components to source files, tests, and rationale.
151. Ensure reuse map validator fails if a reused component points to a missing file.
152. Ensure reuse map validator fails if a reused component has no test evidence.
153. Add proof that no validator is skipped because a file is missing unless the final verdict is BLOCKED.
154. Add proof that no validator silently treats missing optional artifacts as success when those artifacts are required for FUNCTIONAL_RUNTIME_MVP.
155. Add a required artifacts manifest listing every expected report and proof file.
156. Validate the required artifacts manifest against the actual report directory.
157. Validate that no report is zero bytes.
158. Validate that every JSON report parses.
159. Validate that every Markdown report is generated from the corresponding JSON when applicable.
160. Validate that Markdown and JSON reports do not contradict each other.
161. Define which reports are authoritative JSON sources and which Markdown files are renderings; validators should compare Markdown only to its authoritative JSON source.
162. Ensure generated Markdown cannot be the only evidence for a PASS status when the corresponding JSON source is missing or contradictory.
163. Regenerate Markdown transcript from the final JSON transcript only after the JSON transcript is frozen.
164. Validate that regenerate_transcript_md.py does not alter the JSON transcript.
165. Ensure final report generation does not happen after final validation.
166. Ensure no proof step rewrites reports after all-in-one validation.
167. Add a final filesystem snapshot of .agentx-init/reports after proof completion.
168. Validate that final filesystem snapshot matches the evidence manifest.
169. Validate that no hidden/debug-only file is required for proof success unless included in evidence manifest.
170. Decide whether record_command_debug.ndjson is proof evidence or debug-only. If debug-only, validators should not rely on it.
171. Add a top-level prove-from-zero script that runs the whole proof from an empty reports directory and exits nonzero on any failure.
172. Add a top-level verify-existing-proof script that validates an already-generated report directory without regenerating anything.
173. Separate generation commands from validation commands so validators can be run independently on frozen evidence.
174. Ensure every validator accepts --report-dir and does not read from the default report directory when --report-dir is provided.
175. Add tests proving every validator respects --report-dir.
176. Add tests proving anti-false-PASS validators run against the temporary attacked report directory.
177. Add tests proving validators do not accidentally load reports at import time before parse_report_dir() sees CLI arguments.
178. Ensure all validators return nonzero on validation errors.
179. Ensure all validators print actionable errors on failure.
180. Ensure no validator catches broad exceptions and converts them into PASS.
181. Add a validator-side exception policy: infrastructure errors, timeouts, JSON decode errors, and unexpected exceptions must be represented as FAIL/BLOCKED, never PASS or silent success.
182. Require every validator to emit machine-readable failure details in addition to human-readable stdout, so final aggregation does not parse only free text.
183. Ensure no validator ignores malformed JSON as success.
184. Ensure no validator ignores missing files as success for required proof artifacts.
185. Add a final no-forced-PASS guard. The proof should fail if final validation is not run with forced PASS disabled.
186. Search the repo for hardcoded verdict='PASS', status='PASS', and classification='FUNCTIONAL_RUNTIME_MVP' in generation paths.
187. For every hardcoded PASS, replace it with computed status or justify it as static metadata rather than proof status.
188. Add a validator that rejects final proof if generated reports contain suspicious unconditional PASS values.
189. Add a validator that rejects final proof if an acceptance review says PASS while any JSON source report says FAIL, BLOCKED, UNKNOWN, SKIPPED, ERROR, or missing.
190. Add a final classification-boundary check: if enterprise/deep/aspirational items are not part of FUNCTIONAL_RUNTIME_MVP, they must be explicitly out-of-scope rather than claimed as covered.
191. Ensure implementation prompts, planning documents, and checklist docs are never treated as runtime implementation evidence unless paired with source/tests/proof outputs.
192. Ensure unsafe self-promotion is denied by invariant engine, promotion gate, and circuit breaker together.
193. Ensure unsafe self-promotion proof records all three mechanisms in replay manifest and proof bundle.
194. Ensure the invariant engine records no_self_promotion failure for the actual promotion context.
195. Ensure promotion gate denial is persisted in proof evidence.
196. Ensure circuit breaker safety event is persisted in proof evidence.
197. Ensure anti-false-PASS attacks remove each unsafe-self-promotion mechanism and verify rejection.
198. Ensure safe scenario proves positive path: artifact generated, reviewed, promoted, persisted, and replayable.
199. Ensure safe scenario proof includes artifact hash validation.
200. Ensure safe scenario proof includes event log validation.
201. Ensure safe scenario proof includes state store validation.
202. Ensure safe scenario proof includes transaction commit validation.
203. Ensure safe scenario proof includes review decision validation.
204. Ensure safe scenario proof includes promotion decision validation.
205. Ensure generated report artifacts cannot overwrite existing proof artifacts silently.
206. Ensure artifact store default overwrite_policy=deny is used in the runtime path, not only unit tests.
207. Ensure versioned overwrite behavior preserves original content and records both versions.
208. Ensure content-addressed overwrite behavior cannot mask unexpected overwrites without evidence.
209. Ensure runtime profiles are behaviorally enforced by the orchestrator/executor/gates, not merely loaded as metadata.
210. Add end-to-end scenarios for STRICT, DRY_RUN, REPLAY, and AUDIT_ONLY profiles.
211. Prove STRICT mode blocks unsafe or under-evidenced actions instead of allowing best-effort execution.
212. Prove DRY_RUN mode performs planning/simulation/proof recording without committing runtime artifacts or promoting changes.
213. Prove AUDIT_ONLY mode validates and reports existing evidence without executing actions, mutating artifacts, or promoting outputs.
214. Prove REPLAY mode refuses fresh execution except through the controlled replay path and uses replay manifests as the source of truth.
215. Cross-check runtime profile consistently across security envelope, transcript, replay manifest, proof bundle, acceptance matrix, and final verdict.
216. Integrate MvpReadinessCheck into the actual runtime path before action proposal, validation, execution, and promotion.
217. Fail early when readiness checks detect missing required components, invalid profile, dirty/unprepared environment, missing policy, missing capability, or missing contract.
218. Persist readiness results in state, event log, proof bundle, and acceptance evidence.
219. Add negative readiness scenarios proving no artifact is written and no promotion is attempted after readiness failure.
220. Prove security envelope enforcement end to end: every executor call must require a sealed envelope bound to the current run, action, agent, workspace, profile, and evidence target.
221. Add negative security-envelope scenarios for missing envelope, unsealed envelope, wrong run_id, wrong action_id, wrong agent_id, wrong workspace, wrong profile, and tampered evidence target.
222. Persist security-envelope validation results and rejection reasons in the proof evidence.
223. Add anti-false-PASS attacks that remove or falsify security-envelope evidence and verify the final proof rejects them.
224. Prove transaction atomicity end to end, not only that a transaction history object exists.
225. Add a transaction-failure scenario where execution fails after staging but before commit, rollback runs, partial outputs are not promoted, and failure evidence is retained.
226. Validate that committed artifacts, rollback records, transaction IDs, and staged evidence hashes are linked in the proof bundle.
227. Reject final proof if transaction evidence shows commit without prior stage, rollback without failure, or promoted output after failed transaction.
228. Strengthen review semantics: promotion must require a valid accepted review decision from an allowed reviewer, not merely any review packet.
229. Add review-denial, missing-review, expired-review, and self-review scenarios; all must block promotion and persist the denial evidence.
230. Separate self-review from self-promotion in the proof model, and ensure both are denied when the generated agent attempts to approve or promote its own work.
231. For policy denial, capability denial, contract missing, simulation failure, executor failure, rollback failure, review denial, and readiness failure scenarios, prove denial occurs before promotion and no accepted artifact is produced.
232. Add a cross-negative-scenario validator that confirms every denied scenario records the denial mechanism, records no promotion, retains failure evidence, and leaves durable state/event traces.
233. Prove circuit breaker gating at the start of run_goal: when tripped or manually stopped, no new action is proposed, executed, reviewed, or promoted.
234. Add circuit-breaker reset/resume tests showing a reset is explicit, recorded, and cannot erase prior safety events.
235. Ensure acceptance and traceability distinguish component existence from runtime integration; a component should not PASS only because its source file and unit test exist.
236. Add a validator that fails if a component claimed as integrated is not invoked by at least one end-to-end scenario or runtime proof path.
237. Add anti-false-PASS attacks that change DRY_RUN, AUDIT_ONLY, REPLAY, readiness, review-denial, transaction-failure, and circuit-breaker outcomes to PASS and verify rejection.
238. Ensure rollback controller is actually involved in scenarios that require rollback.
239. Add a rollback-positive scenario where rollback is required, a rollback plan exists, execution fails, rollback runs, and rollback evidence is persisted.
240. Add a negative scenario for rollback-required action without rollback plan.
241. Add a negative scenario for policy denial.
242. Add a negative scenario for capability denial.
243. Add a negative scenario for contract missing.
244. Add a negative scenario for simulation failure.
245. Add a negative scenario for executor failure.
246. Add proof that failed artifacts are retained for failed execution.
247. Add proof that failures do not get promoted.
248. Add proof that failed tests cannot be ignored.
249. Add proof that L0 modification is denied by default if that invariant is claimed.
250. Either implement all CORE_INVARIANTS fully or mark unimplemented invariant names as not yet enforced.
251. Add tests for every CORE_INVARIANT, not only selected ones.
252. Ensure check_all() result cannot show PASS for unimplemented invariants merely because no code handles them.
253. Add a validator that fails if a CORE_INVARIANT has no implementation branch and no tests.
254. Make CORE_INVARIANTS declarative: each invariant name must map to an implementation function, tests, proof evidence, and failure semantics.
255. Fail if check_all() returns PASS for an invariant that has no implementation branch, no test, or no proof evidence.
256. Ensure event log proof includes the events required by the runtime claim.
257. Ensure event log validator rejects missing goal_received event.
258. Ensure event log validator rejects missing action lifecycle events if those are claimed.
259. Ensure event log validator rejects missing safety event in unsafe scenario.
260. Ensure event log validator validates event ordering where ordering is claimed.
261. Ensure state proof validates persisted state records, not only existence.
262. Ensure state proof validates state records belong to the expected run_id.
263. Ensure state proof validates state records include goal/action/evidence states expected by the scenario.
264. Ensure state proof rejects stale state records from previous runs.
265. Ensure path safety validator covers artifact paths, replay paths, evidence refs, source manifests, and transcript log paths.
266. Ensure path safety validator rejects absolute temp paths in final durable proof unless they are intentionally allowed and still exist.
267. Ensure proof output does not rely on deleted temp directories.
268. Ensure proof output is portable enough to validate after cloning the repo and running the proof target.
269. Add documentation explaining exact proof phases, generated files, validators, and final classification rules.
270. Update docs so they do not claim done unless make prove-functional-runtime-mvp passes from clean checkout.
271. Add a final checklist that is generated from actual validator results, not manually checked boxes.
272. After all fixes, run make prove-functional-runtime-mvp from a clean checkout and require exit code 0.
273. After all fixes, run make prove-functional-runtime-mvp twice and require idempotency validation to pass.
274. After all fixes, run verify-existing-proof on the frozen final report directory and require exit code 0.
275. After all fixes, run anti-false-PASS audit against the frozen final report directory and require all attacks rejected.
276. After all fixes, confirm GitHub Actions or another CI run passes on the exact commit.
277. Only after the clean local proof, idempotency proof, frozen-proof verification, anti-false-PASS audit, and CI evidence pass should the project claim FUNCTIONAL_RUNTIME_MVP.
278. Before accepting the next commit, verify the full proof from a frozen report directory without regeneration, then from a clean checkout with regeneration, and compare both results.
279. Add a documented runtime entrypoint for the Functional Runtime MVP, such as a CLI command, module entrypoint, or API function, that runs a real goal outside pytest helper code.
280. Prove the runtime entrypoint can execute the safe report-generation goal from user-facing input and produce the expected durable output, state, events, review, promotion, and proof artifacts.
281. Prove the runtime entrypoint can execute the unsafe self-promotion goal from user-facing input and deny it with the same invariant, promotion-gate, and circuit-breaker evidence used by the system tests.
282. Include runtime-entrypoint invocations in the command transcript and final proof bundle; the project should not claim FUNCTIONAL_RUNTIME_MVP using only direct pytest scenario calls.
283. Add acceptance and traceability rows for the runtime entrypoint itself, including source file, test file, command transcript entry, output artifacts, and validator evidence.
284. Add an anti-false-PASS attack that removes or falsifies runtime-entrypoint evidence and proves the final validators reject the proof.
285. Add a packaging/import proof showing the runtime can be used from a clean checkout or installed package without relying on undeclared PYTHONPATH hacks.
286. Document and validate the supported invocation modes: direct Python module, CLI, Makefile target, and proof verifier; each should have a clear contract and failure behavior.
287. Fail the proof if required imports only work because the developer shell has custom environment variables, editable installs, or globally available packages not declared in repository requirements.
288. Add a pytest collection artifact showing the exact collected test node IDs for the Functional Runtime MVP proof suite.
289. Store machine-readable pytest results, such as JUnit XML or JSON, for every proof test command, not only truncated stdout summaries.
290. Bind each acceptance row and requirement traceability row to at least one executed and passing test node ID, not merely to the existence of a test file.
291. Fail if a required test is deselected, skipped, xfailed, xpassed, or not collected, unless that status is explicitly allowed and causes the final classification to be BLOCKED rather than PASS.
292. Validate that MVP_TESTS covers every component and scenario claimed by FUNCTIONAL_RUNTIME_MVP, and fail if a required test file exists but is omitted from the proof target.
293. Add a test-coverage manifest mapping component, requirement ID, test file, pytest node ID, command transcript entry, and result status.
294. Add source-level sabotage controls for runtime behavior: in a temporary copy, deliberately disable key runtime checks and prove the proof suite fails.
295. Runtime sabotage should cover at least the orchestrator promotion path, no_self_promotion invariant, promotion gate, circuit breaker, artifact overwrite protection, replay verification, transcript verification, and final verdict generation.
296. Ensure source-level sabotage is separate from report-level anti-false-PASS: one attacks generated evidence, the other attacks implementation code.
297. Run source-level sabotage only in an isolated temporary copy or worktree and prove the real working tree remains unchanged afterward.
298. Store source-level sabotage results as machine-readable evidence, including mutation applied, files changed, command run, expected failure, actual failure, and reason match.
299. Add a validator that fails if source-level sabotage cases pass unexpectedly, fail for infrastructure reasons, or are skipped because targets are missing.
300. Add anti-false-PASS attacks that falsify source-level sabotage evidence and prove validators reject the final proof.
301. Add proof that final validators check both runtime-behavior evidence and generated-report evidence; neither evidence family alone should be sufficient for FUNCTIONAL_RUNTIME_MVP.
302. Add a final classification dependency graph showing which proof artifacts are required for FUNCTIONAL_RUNTIME_MVP and proving there are no circular self-justifying dependencies.
303. Fail if any final proof artifact is justified only by a generated report that ultimately depends on itself, rather than on source, executed commands, tests, scenario outputs, or frozen evidence.
304. Add a minimal external-user smoke test: from a clean shell, run the documented runtime entrypoint with example inputs and verify expected outputs without opening internal test fixtures.
305. Ensure README or docs tell a user how to run the runtime MVP and how to verify the proof, without requiring knowledge of internal pytest files.
306. Only after runtime entrypoint proof, packaging/import proof, pytest result binding, source-level sabotage controls, existing anti-false-PASS audit, clean-checkout proof, idempotency proof, frozen-proof verification, and CI evidence all pass should the project claim FUNCTIONAL_RUNTIME_MVP.

307. Make replay manifest-authoritative. replay_execute.py must not depend on hardcoded SCENARIO_PARAMS as the hidden source of truth for scenario behavior.
308. Store the complete scenario input contract in each replay manifest: goal_text, profile, seed, clock, action_type, agent_id, target_agent, reviewer, review_decision, target, report content, policy snapshot, capability snapshot, contract snapshot, expected artifact names, and expected denial/promotion semantics.
309. Make replay fail if required scenario inputs are missing from the manifest rather than silently filling them from hardcoded defaults.
310. Validate that replay reconstruction uses the persisted manifest and persisted evidence as inputs, not pytest helper defaults or current in-memory registry state.
311. Compare replay results beyond the final verdict: artifact hashes, state records, event sequence, invariant results, review decision, promotion decision, circuit-breaker events, transaction evidence, and denial/promotion reason codes must match the manifest expectations.
312. Add anti-false-PASS attacks that tamper with replay manifest goal_text, agent_id, target_agent, reviewer, profile, policy snapshot, capability snapshot, contract snapshot, event hash, and expected verdict; final validators must reject each tampering case.
313. Add a replay-source validator that fails if replay code contains hidden scenario defaults that can override or replace manifest data for proof-critical fields.
314. Add a runtime failure taxonomy and error contract. Every runtime failure must have a machine-readable phase, component, code, severity, recoverability flag, and blocking/non-blocking classification.
315. Replace free-text-only runtime failure handling with structured failure records in state, event log, transcript, proof bundle, and final reports.
316. Fail final proof if any denied, failed, rolled back, blocked, or unsafe scenario has an unclassified error or only a free-text reason with no taxonomy code.
317. Ensure final classification treats UNKNOWN, UNCLASSIFIED, PARTIAL, INFRASTRUCTURE_ERROR, TIMEOUT, and INTERNAL_ERROR as BLOCKED unless explicitly allowed by the classification rules.
318. Add tests proving runtime exceptions, validator exceptions, malformed inputs, missing components, and unexpected subprocess failures become structured FAIL/BLOCKED evidence rather than silent PASS or generic text.
319. Implement atomic writes for proof outputs: write to temporary files, flush/fsync where practical, then rename into place so validators never read partial JSON/Markdown files.
320. Add interruption/crash-recovery tests for report generation: kill or simulate failure mid-generation and prove the next run cleans or rejects partial outputs rather than mixing them into final proof.
321. Add validators that reject truncated JSON, zero-byte files, partial Markdown tables, orphaned .tmp files, stale lock files, and reports missing required end markers or schema versions.
322. Propagate a single proof_run_id into every generated proof artifact, including acceptance matrix, evidence manifest, proof bundle, replay report, replay manifests, traceability matrix, anti-false-PASS audit, idempotency report, final verdict, command transcript, state exports, and event exports.
323. Fail final proof if any required report lacks proof_run_id or contains a proof_run_id that does not match the final proof bundle, except explicitly modeled dual-run idempotency artifacts.
324. Add staleness validators that reject reports whose git_commit, proof_run_id, generated_at, input hashes, or report hashes do not belong to the same frozen proof run.
325. Add proof-run locking so two proof runs cannot write to the same .agentx-init/reports directory concurrently.
326. Add a negative concurrency test that starts or simulates overlapping proof generation and proves one run is rejected or isolated rather than producing mixed evidence.
327. Ensure proof-run locks are cleaned up safely after normal completion and after failure, while stale locks are handled explicitly and recorded as BLOCKED unless safely recoverable.
328. Add a reviewer identity/trust model. A review should record reviewer identity, allowed reviewer status, decision authority, timestamp, reviewed artifact hash, and relationship to the acting agent.
329. Add tests proving promotion is blocked for unknown reviewer, unauthorized reviewer, stale reviewer authorization, reviewer equal to generated agent, review that references the wrong artifact hash, and review decision created after promotion.
330. Persist reviewer authorization evidence and review decision evidence in the proof bundle and replay manifests.
331. Snapshot policy rules, capability graph entries, contracts, invariant registry, runtime profile, and reviewer authorization at run start.
332. Use the run-start snapshots for execution, replay, proof verification, and final reports; do not let later registry mutations rewrite what policy/capability/contract decision was actually made.
333. Add negative scenarios proving policy, capability, contract, invariant, or reviewer registry mutations after run start cannot retroactively turn a denied or unsafe action into PASS.
334. Add anti-false-PASS attacks that falsify policy/capability/contract/reviewer snapshots and verify final validators reject them.
335. Ensure final reports distinguish “component exists,” “component was configured,” “component was invoked,” “component influenced a decision,” and “component evidence was persisted.” Only the latter three should support runtime integration claims.
336. Add a final dependency check that every PASS claim traces to at least one source file, one executed command, one structured test result, one runtime output/evidence artifact, and one validator result; generated reports alone must not close the chain.
337. Add a machine-readable proof summary that lists every blocker, every PASS claim, every BLOCKED claim, every out-of-scope claim, and every remaining unknown; final classification must be computed from this summary, not manually written.
338. Ensure the final proof can be validated by an independent verifier that does not run generation code, does not trust generated Markdown, and reads only frozen JSON evidence plus source/test hashes.
339. Add a negative independent-verifier test: corrupt the Markdown reports while leaving JSON intact and confirm classification still follows JSON; corrupt JSON while leaving Markdown intact and confirm proof fails.
340. Only after manifest-authoritative replay, structured failure taxonomy, atomic proof output, proof_run_id propagation, proof-run locking, reviewer identity/trust, policy/capability/contract snapshotting, independent frozen verification, and all Revision 4 requirements pass should the project claim FUNCTIONAL_RUNTIME_MVP.
341. Add a proof-artifact confidentiality model. The proof must define which data classes are allowed in transcripts, logs, reports, replay manifests, evidence manifests, state exports, event exports, and proof bundles.
342. Add secret-redaction for command stdout, command stderr, environment captures, runtime inputs, runtime outputs, exception traces, and generated reports before they are stored as proof artifacts.
343. Add validators that fail if proof artifacts contain common secret patterns, such as API keys, access tokens, private keys, passwords, bearer tokens, cookies, SSH keys, cloud credentials, or unredacted environment-variable values.
344. Add negative tests proving a command or runtime scenario that prints a fake secret is redacted in durable logs while still preserving enough hash/provenance evidence for validation.
345. Ensure full stdout/stderr log storage uses content-addressed artifacts with redaction metadata, original-length metadata, redacted-hash metadata, and an explicit statement that raw sensitive content is not persisted.
346. Add anti-false-PASS attacks that remove redaction metadata, replace redacted logs with raw-secret logs, or falsify log hashes; final validators must reject them.
347. Define an allowed side-effect model for the runtime. Each scenario must declare which directories/files may be read, written, created, modified, deleted, or executed.
348. Add before/after side-effect manifests for the whole runtime proof, not only source mutation manifests. The manifests must cover workspace, artifact root, report directory, state directory, event log path, temp directory, and any configured output directory.
349. Fail if a runtime scenario writes outside its declared workspace/artifact/report directories, even if the final proof reports PASS.
350. Add negative side-effect scenarios for unexpected file creation, unexpected file deletion, unexpected source modification, unexpected proof-report modification, symlink escape, hardlink escape, and writes through relative-path tricks.
351. Add validators proving cleanup behavior is safe: temporary runtime directories are either intentionally retained as durable evidence or removed only after their evidence has been copied into stable proof artifacts.
352. Ensure final proof artifacts do not reference temporary paths that were deleted before frozen-proof verification, unless those paths are intentionally marked non-durable and excluded from required evidence.
353. Add a runtime resource budget contract for proof commands and runtime scenarios: maximum wall time, maximum output size, maximum artifact size, maximum number of files, and maximum recursion depth where relevant.
354. Fail proof commands that exceed time, output, file-count, artifact-size, or recursion limits with structured BLOCKED/TIMEOUT/RESOURCE_LIMIT evidence.
355. Add tests proving timeouts and resource-limit failures do not leave partial proof outputs that later get mixed into a PASS run.
356. Ensure record_command.py and any runtime command runner truncate user-visible summaries only after storing/redacting full logs or explicitly recording that full logs are unavailable and therefore the proof is BLOCKED.
357. Add a dependency lock/integrity proof. The clean-checkout proof should validate pinned dependency versions, lockfile hashes, install command, and whether installed packages match the declared environment.
358. Fail if the proof relies on undeclared optional packages, system binaries, shell aliases, local editable installs, or globally installed Python modules not represented in the dependency proof.
359. Add a supply-chain boundary statement for FUNCTIONAL_RUNTIME_MVP: what dependencies are trusted, what installation source is trusted, whether network install is allowed, and how dependency changes affect proof validity.
360. Add runtime input validation for the documented entrypoint. Invalid goal text, invalid profile, invalid agent ID, invalid target path, invalid report name, malformed JSON input, and unsupported action type must produce structured denial/failure evidence.
361. Add negative runtime-entrypoint tests for malformed CLI/API inputs and prove no artifact is promoted after input validation failure.
362. Add anti-false-PASS attacks that tamper with input-validation failure evidence or change invalid-input outcomes to PASS; final validators must reject them.
363. Define a deterministic exit-code contract for every user-facing and proof-facing command: runtime entrypoint, proof generator, frozen verifier, anti-false-PASS audit, source-sabotage audit, clean-checkout proof, and CI script.
364. Validate exit-code semantics in tests: success returns 0, validation failure returns a documented nonzero code, infrastructure failure returns a distinct documented nonzero code, and timeout/resource-limit failure returns a distinct documented nonzero code.
365. Add final proof aggregation that consumes structured command results rather than assuming any nonzero is equivalent; different failure classes must map to PASS, FAIL, BLOCKED, or INFRASTRUCTURE_ERROR according to explicit rules.
366. Add schema evolution rules. Every machine-readable proof artifact must include schema_version, and validators must reject unsupported schema versions rather than guessing.
367. Add compatibility tests proving an older proof report either validates under an explicitly supported schema version or is rejected as BLOCKED/UNSUPPORTED_SCHEMA, not silently accepted.
368. Add canonical JSON serialization rules for all proof JSON artifacts: sorted keys where practical, normalized paths, normalized timestamps or declared volatile fields, UTF-8 encoding, final newline, and stable numeric formatting.
369. Add validators that reject duplicate JSON keys, non-canonical path separators, invalid UTF-8, NaN/Infinity, and platform-dependent path encodings in required proof artifacts.
370. Add proof that generated Markdown is derived from JSON and not independently authoritative; regenerate Markdown from frozen JSON and compare it to committed/generated Markdown output.
371. Add anti-false-PASS attacks that edit Markdown-only verdicts while JSON remains unchanged and prove classification follows JSON; this complements the independent-verifier test by checking the generator path too.
372. Add operational recovery proof for failed proof runs: after a failed run, the next run must either clean the report directory or isolate itself by proof_run_id and must not reuse stale partial files.
373. Add tests proving stale report directories, stale locks, stale temp files, stale state exports, and stale event exports cannot be reused to produce a PASS classification.
374. Add a final allowed-artifact inventory. The frozen report directory must contain only expected files for the configured proof version; unknown extra files must be ignored with warning or fail according to explicit rules.
375. Add validators proving every file in the frozen report directory is either required evidence, optional declared evidence, or explicitly ignored debug output; no unexpected file should silently influence final classification.
376. Add a single final acceptance command contract: one documented command should perform clean generation plus validation, and one documented command should validate an existing frozen proof without generation. Both must be used in CI.
377. Only after confidentiality/redaction proof, allowed side-effect proof, resource-budget proof, dependency-lock proof, runtime input-validation proof, exit-code contract proof, schema-evolution proof, stale-run recovery proof, and all Revision 5 requirements pass should the project claim FUNCTIONAL_RUNTIME_MVP.

378. Add a canonical proof-configuration manifest for FUNCTIONAL_RUNTIME_MVP. It must list proof version, required reports, required validators, required generators, required attacks, required scenarios, required commands, requirement IDs, accepted out-of-scope items, and classification rules.
379. Hash the proof-configuration manifest and include that hash in every final proof artifact, including proof bundle, evidence manifest, acceptance matrix, traceability matrix, anti-false-PASS audit, source-sabotage audit, idempotency report, final verdict, and CI artifact.
380. Fail the final proof if any report was generated using a different proof-configuration hash from the final verifier.
381. Fail if the anti-false-PASS attack list, validator list, required report list, or classification rules change without changing the proof-configuration version and regenerating the whole proof.
382. Make final classification depend on the proof-configuration manifest, not on scattered hardcoded lists in separate validators, Makefile targets, and generators.
383. Add full Git provenance, not only short git_commit. Every proof artifact should record the full 40-character commit SHA, tree hash, parent commit, branch/ref if available, repository remote URL or repository identity, and whether the checkout is detached.
384. Fail if any proof artifact uses a short SHA as the only commit binding for final classification.
385. Add a source-tree manifest that covers tracked source, tests, validators, generators, Makefile, requirements, workflow files, and proof configuration. The manifest must include file path, mode, size, hash, and whether the file is tracked.
386. Fail if proof-relevant behavior can be influenced by untracked, ignored, generated, symlinked, or external files that are not represented in the source-tree manifest or explicitly allowed as generated proof artifacts.
387. Add submodule and nested-repository handling. If submodules or nested Git repositories exist, they must be pinned and included in provenance or the proof must fail as BLOCKED.
388. Add a proof-toolchain integrity model. Validators, generators, report builders, replay executors, command recorders, and final verifiers must be hashed before they run and referenced in the final proof.
389. Fail if a validator/generator/final-verifier source file changes during the proof run or differs between generation and frozen verification.
390. Add anti-false-PASS attacks that tamper with validator/generator/final-verifier source hashes and verify the final proof rejects the result.
391. Make report generators fail closed. If any internal subprocess, scenario run, parser, export, replay execution, report write, or proof collection step fails, the generator must return nonzero and emit structured FAIL/BLOCKED evidence instead of continuing toward a PASS report.
392. Add generator exception policy equivalent to the validator exception policy: unexpected exceptions, timeouts, JSON decode errors, missing inputs, internal subprocess nonzero exits, and partial writes must never be converted into PASS or silently omitted.
393. Add tests proving generate_mvp_reports.py, collect_mvp_proof.py, generate_traceability_matrix.py, generate_idempotency_report.py, replay_execute.py, regenerate_transcript_md.py, and any final verdict generator fail closed when their required inputs are missing or malformed.
394. Add anti-false-PASS attacks that force an internal generator subprocess failure while leaving later reports present, and verify final validators reject the mixed output.
395. Add explicit action/state-machine transition proof. The runtime must define legal transitions for goal, action, review, execution, transaction, rollback, promotion, circuit breaker, replay, and final classification states.
396. Validate that runtime event logs and state records follow the legal transition graph. Invalid order, skipped states, duplicate terminal states, promotion before review, execution after circuit breaker trip, commit before stage, rollback after successful commit, and PASS after failed validator must all fail proof.
397. Add negative tests and source-sabotage cases for illegal state transitions in the orchestrator, action lifecycle, review flow, transaction manager, rollback controller, promotion gate, and final proof aggregator.
398. Require every terminal verdict to be derived from the state-machine state, not written independently as free text in final reports.
399. Add an external I/O boundary model. The runtime and proof commands must declare whether they may open network connections, spawn subprocesses, execute shell commands, read environment variables, read outside the repo/workspace, or write outside declared directories.
400. Add validators that fail if runtime/proof code uses shell=True, string-built shell commands, unvalidated command arguments, uncontrolled environment inheritance, or PATH-dependent executables for proof-critical commands unless explicitly justified and sandboxed.
401. Add command-injection negative tests for runtime entrypoint inputs, report names, target paths, profile names, reviewer IDs, agent IDs, goal text, and proof command arguments.
402. Add process-boundary tests proving proof commands cannot be influenced by shell aliases, user shell startup files, modified PATH, local wrapper scripts, or environment variables not listed in the dependency/environment proof.
403. Add a network-boundary test proving the proof succeeds in offline mode and fails closed if any proof-critical code unexpectedly attempts network access.
404. Add a final-verifier authority separation rule. The generator may produce candidate reports, but only an independent frozen verifier may compute FUNCTIONAL_RUNTIME_MVP from frozen JSON evidence and source/toolchain hashes.
405. Remove or demote any generator-written final_verdict.json that can claim FUNCTIONAL_RUNTIME_MVP before the independent frozen verifier has passed.
406. Final verdict should either be produced by the independent verifier after validation or marked as candidate_verdict until the verifier signs/computes the final classification.
407. Add tests proving editing generator code to write FUNCTIONAL_RUNTIME_MVP directly cannot bypass the independent frozen verifier.
408. Add a single authoritative classification algorithm with machine-readable inputs and outputs. The algorithm must map PASS, FAIL, BLOCKED, UNKNOWN, OUT_OF_SCOPE, UNSUPPORTED_SCHEMA, INFRASTRUCTURE_ERROR, TIMEOUT, and RESOURCE_LIMIT consistently.
409. Fail if two validators or generators implement conflicting classification rules for the same evidence state.
410. Add a classification-rule consistency validator that compares Makefile targets, traceability generator, acceptance-row builder, proof bundle collector, final verifier, and documentation against the canonical proof-configuration manifest.
411. Add proof that Markdown, docs, checklist files, and manually edited planning files cannot affect final classification except as non-authoritative explanatory outputs.
412. Add negative tests proving a fake PASS in docs, Markdown review, README, implementation prompt, or checklist does not change the final machine-readable verdict.
413. Add durable artifact relocation proof. Frozen proof verification should still work after copying the report directory to a new path, as long as referenced durable artifacts are copied with it or represented by content-addressed hashes.
414. Replace proof-critical absolute paths with repository-relative paths, report-directory-relative paths, or content-addressed artifact references. Absolute paths should be allowed only for explicitly non-portable diagnostic fields that cannot support PASS claims.
415. Fail if proof-critical evidence exists only in a temporary directory, developer home directory, deleted workspace, or absolute path that cannot be reproduced or bundled for independent verification.
416. Add proof-bundle completeness rules for generated runtime artifacts. If runtime output artifacts are required evidence, they must be copied into the frozen proof bundle or represented by content-addressed durable artifact storage, not only referenced by live temp paths.
417. Add a final artifact-retention validator that checks every PASS-supporting artifact still exists, has the expected hash, is under an allowed durable root, and is included in the frozen proof inventory.
418. Add a proof-size and artifact-retention policy: define which logs/artifacts are retained, redacted, compressed, omitted, or summarized, and what omissions make the proof BLOCKED rather than PASS.
419. Add a final “no hidden authority” check: no single generated report, single validator, single Markdown file, or single Makefile echo line may be sufficient to claim FUNCTIONAL_RUNTIME_MVP without the full canonical proof graph.
420. Only after proof-configuration immutability, full Git/tree provenance, proof-toolchain integrity, generator fail-closed behavior, legal state-machine transition proof, external I/O/process boundary proof, independent final-verifier authority, portable durable artifact retention, and all Revision 6 requirements pass should the project claim FUNCTIONAL_RUNTIME_MVP.

421. Define the runtime concurrency scope for FUNCTIONAL_RUNTIME_MVP: either prove supported behavior for multiple simultaneous goals/agents/workspaces, or explicitly mark concurrent runtime execution as out of scope and BLOCKED for any claim that implies it works.
422. Add a runtime isolation model separate from proof-run isolation. Every runtime state record, event record, artifact, transaction, review, promotion, replay manifest, and proof reference must be bound to run_id, workspace_id, agent_id, profile, and scenario ID where applicable.
423. Prove that two overlapping runtime goals cannot mix state, events, artifacts, reviews, transactions, promotions, replay manifests, or proof evidence.
424. Add negative cross-run contamination tests: reject a review from another run, an artifact hash from another workspace, a state record from a previous run, an event log from another agent, a replay manifest with mismatched run_id, and a promotion decision built from mixed-run evidence.
425. Add runtime-level locking or transaction isolation for state store, event log, artifact store, review store, and promotion registry. Proof-run directory locking alone is not enough to prove runtime isolation.
426. Prove restart/reload durability for runtime state. After the runtime process exits, a fresh process must be able to reload durable state, events, artifacts, review decisions, transaction status, and promotion status and validate them against the expected run_id and hashes.
427. Add runtime crash-recovery scenarios for failure after action proposal, after artifact staging, after review creation, after transaction commit, and before promotion. Each scenario must either resume safely, roll back safely, or block with structured evidence; none may promote partial or ambiguous work.
428. Define append-only or tamper-evident event-log semantics for runtime events, such as a hash chain, signed sequence, or manifest-bound ordered event hashes. Final proof must reject deleted, inserted, reordered, duplicated, or edited runtime events.
429. Add schema-version and compatibility checks for runtime state records, runtime events, review records, transaction records, promotion records, and artifact metadata, not only for proof JSON reports. Unsupported runtime record schemas must become BLOCKED/UNSUPPORTED_SCHEMA rather than PASS.
430. Add anti-false-PASS and source-sabotage attacks for runtime isolation and recovery: mix two run IDs, reuse stale state, edit event order, delete a crash event, reuse an old review, bypass runtime locks, and force promotion after a simulated crash. Final validators must reject each case.
431. Persist and validate runtime lock/lease ownership evidence where locks are used. Stale locks, missing lock owner, lock owner mismatch, lock timeout, and lock release without ownership must be explicit BLOCKED/FAIL conditions.
432. Ensure frozen-proof verification can validate runtime isolation, restart, crash-recovery, and tamper-evident event/state evidence without rerunning live runtime generation code.
433. Only after explicit runtime concurrency scope, cross-run/workspace isolation, runtime restart/recovery proof, runtime-level locking, tamper-evident event/state durability, and all Revision 7 requirements pass should the project claim FUNCTIONAL_RUNTIME_MVP.

434. Define an authoritative architecture-scope map for FUNCTIONAL_RUNTIME_MVP versus the broader Agent_X roadmap. The proof must say exactly which layers are in scope, out of scope, future work, implemented but unproven, or blocking.
435. Include every named Agent_X layer in that scope map: Initiator, Security Sandbox, Policy Registry, Patch Execution, Failure Taxonomy, Tool/MCP Adapter, Model Adapter, Local Model Runtime Profile, Context Builder, Prompt Contract, LLM Worker, Self-Evolution Orchestrator, Human Review, Promotion Gate, Git Integration, Evaluation Harness, Long-Term Learning, Doc Sync, Task Queue, Monitoring, Packaging, Backup/DR, and Final Acceptance.
436. For each layer, require a machine-readable status: implemented_and_proven, implemented_unproven, stub_only, deliberately_disabled, out_of_scope_for_this_mvp, future_work, or blocking.
437. Fail final proof if README, documentation, generated reports, acceptance matrix, traceability matrix, or final verdict imply that a layer works when the architecture-scope map marks it as unproven, stub-only, disabled, out of scope, future work, or blocking.
438. Add acceptance and traceability rows for every architecture-scope layer, even when the row outcome is OUT_OF_SCOPE or BLOCKED. Silent omission of a layer must not be allowed.
439. If Tool/MCP Adapter is in scope, prove a real adapter boundary: allowlisted tools, declared schemas, argument validation, timeout behavior, error mapping, capability checks, transcript evidence, and no direct tool bypass from runtime code.
440. If Tool/MCP Adapter is out of scope, explicitly state that the runtime MVP does not yet prove external tool execution, connector execution, or MCP-style tool orchestration.
441. If Model Adapter or LLM Worker is in scope, prove the model boundary end to end: model identity or deterministic mock identity, prompt/input contract, output contract, timeout/error handling, retry behavior, refusal/error propagation, transcript evidence, and no hidden live-model dependency in offline proof mode.
442. If Model Adapter or LLM Worker is out of scope, explicitly state that the runtime MVP does not yet prove autonomous LLM-driven planning or generation beyond deterministic scenario/mocked behavior.
443. If Context Builder is in scope, prove that assembled context uses only allowed inputs, current run/workspace data, approved artifacts, policy/capability/contract snapshots, and redacted evidence; it must reject stale, cross-run, untrusted, oversized, or unauthorized context.
444. If Prompt Contract is in scope, prove prompt contracts are versioned, schema-validated, bound to profile/action/tool/model, and rejected when missing, stale, incompatible, or bypassed.
445. Add anti-false-PASS attacks that replace real context/prompt-contract evidence with planning documents, comments, or static Markdown and verify the final proof rejects them.
446. If Patch Execution or Git Integration is in scope, prove patch creation, diff restriction, staging, application, test execution, rollback, branch/ref handling, working-tree cleanliness, and forbidden-path protection end to end.
447. If Patch Execution or Git Integration is out of scope, explicitly state that the runtime MVP does not yet prove safe repository modification, autonomous patching, or self-upgrade through Git.
448. If Task Queue is in scope, prove enqueue, dequeue, lease/lock ownership, retry, cancellation, idempotency, dead-letter handling, priority/order semantics, restart recovery, and cross-run isolation.
449. If Task Queue is out of scope, explicitly state that the runtime MVP only proves direct invocation and not asynchronous multi-task scheduling.
450. If Monitoring is in scope, prove health checks, metrics/events, alertable failures, run summaries, and audit-log linkage; monitoring output must not be accepted as proof unless tied to frozen evidence.
451. If Monitoring is out of scope, explicitly state that operational observability beyond proof/event logs is not yet proven.
452. If Backup/DR is in scope, prove backup creation, restore to a clean location, hash validation, schema compatibility, missing/corrupt backup rejection, and recovery of state/events/artifacts/reviews/transactions/promotions/proof evidence.
453. If Backup/DR is out of scope, explicitly state that disaster recovery is not yet proven and cannot support a production-readiness claim.
454. If Doc Sync is in scope, prove documentation is generated or checked from machine-readable proof status, fails when stale, and cannot override the machine-readable final verdict.
455. If Doc Sync is out of scope, explicitly state that docs are explanatory only and not a synchronized source of truth.
456. If Long-Term Learning is in scope, prove data lineage, consent/safety boundaries where relevant, versioned memory/learning records, rollback/delete behavior, contamination prevention, and separation from proof evidence.
457. If Long-Term Learning is out of scope, explicitly state that persistent learning/memory evolution is disabled or unproven for this MVP.
458. If Evaluation Harness is in scope, prove evaluation cases are versioned, reproducible, tied to requirements, include negative and regression cases, and are distinct from proof-generation scripts.
459. If Security Sandbox is claimed, prove actual filesystem/process/network/environment containment, not only policy checks. Include negative tests for path escape, shell escape, environment leakage, network access, subprocess abuse, and unauthorized writes.
460. If Initiator is claimed complete, map its user-facing commands to current runtime/proof entrypoints and prove they still work after the Functional Runtime MVP changes.
461. Add at least one cross-layer integration scenario for every layer marked implemented_and_proven. A layer must not pass only because source files and unit tests exist; it must be invoked through an end-to-end runtime or proof path.
462. Add a layer-bypass source-sabotage audit: bypass the tool adapter, model adapter, context builder, prompt contract, policy registry, sandbox, queue, review gate, or Git/patch gate where those layers are in scope, and prove the final validators reject the mutated implementation.
463. Add report-level anti-false-PASS attacks that mark stub-only or out-of-scope architecture layers as PASS in the acceptance matrix, traceability matrix, README, generated Markdown, and final verdict; final validators must reject each case.
464. Add a canonical classification boundary with at least three separate states: PROOF_HARNESS_HARDENED, FUNCTIONAL_RUNTIME_MVP, and AGENT_X_LAYERED_MVP. The project must not use evidence for the first state to claim the third.
465. Add a final architecture-scope validator that compares the canonical scope map, source tree, tests, runtime scenarios, proof artifacts, acceptance matrix, traceability matrix, documentation, and final verdict for contradictions.
466. Only after the architecture-scope map, per-layer status proof, in-scope layer integration scenarios, out-of-scope blocking semantics, layer-bypass sabotage, layer false-PASS attacks, classification-boundary enforcement, and all Revision 8 requirements pass should the project claim FUNCTIONAL_RUNTIME_MVP without overstating broader Agent_X completion.
