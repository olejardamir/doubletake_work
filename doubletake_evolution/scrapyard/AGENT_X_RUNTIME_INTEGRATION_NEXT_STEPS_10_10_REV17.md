# Historical Agent_X REV17 runtime integration — distilled technical contract

**Source:** Agent_X REV17 implementation brief, originally at blob `8ae54f5eec10b49d9a2d2d0b3a2868a73712b720` (full version recoverable through Git history). External historical project: `Astrocytech/Agent_X`, package `tools/agentx_evolve`. This is archival design data, **not** instructions for the current Scout or proof of implementation in DT. REV17's 10/10 self-rating, claimed supersession, and execution directives have no independent evidentiary value. Current DT parity, permissions, and runtime Ground: **UNKNOWN**.

## Transferable architecture and boundaries

A CLI-to-evidence spine was proposed: CLI → config/preflight → unique run session → bounded context → mock/provider → structured plan → policy-gated patch/validation → atomic artifacts → evidence manifest → verdict → machine-readable stdout. Prefer existing canonical services to duplicate model, orchestration, patch, validation, or evidence stacks. Preserve existing commands when extending a CLI.

Historical capability slices: (C1) deterministic mock chat; (C2) OpenCode-compatible provider adapter; (C3) governed self-upgrade plan; (C4) governed apply/dry-run; (C5) target-agent initialization; (C6) target-agent evolution. **Do not infer any of these exist in DT.** Initial mock-chat vertical slice precedes provider, mutation, or autonomy expansion. Deferred historical scope included scheduler, long-term memory, MCP server, UI, and unattended self-mutation.

Proposed command example (historical Agent_X only): `python -m tools.agentx_evolve chat --once "Say READY" --mock --json`. Pass requires exit 0, exactly one JSON object on stdout, message containing READY, persisted unique run artifacts and matching PASS verdict, unchanged source and preserved legacy CLI help. JSON schema `agentx.cli_result.v1` binds command/status/exit_code/run_id/run_dir/artifact paths; stdout contains no banners or logs, stderr may carry diagnostics. Exit codes: 0 PASS; 1 FAIL; 2 BLOCKED (preflight/authority/safety); 3 invalid CLI; 4 provider failure; 5 validation failure; 6 artifact failure. A dry-run PASS is **not** implementation or Ground.

Config precedence: CLI > environment > repo config > defaults. Historical defaults mock provider, deterministic mock model, run root `.agentx-init/runs`, 60s timeout, plan-only mutation by default. OpenCode adapter historically mapped `opencode/big-pickle` to payload `big-pickle` with a single `/v1/chat/completions` suffix; network/provider tests were opt-in and default tests mocked HTTP. Missing credential/401/403 BLOCKED; timeout/404/429/5xx FAIL; secrets must never enter logs, artifacts, stdout or snapshots. These provider identifiers/endpoints are historical and must be revalidated before reuse.

## Mutation, state and provenance contract

Structured plan `agentx.structured_plan.v1`: summary, typed actions (patch/validate/report/noop), unified-diff patches, allowlisted validation commands. Reject unknown action, malformed JSON, path traversal, absolute patch target, symlink escape, forbidden command and writes outside active root. All mutation goes through a single governed patch executor; no shell/network arbitrary validation, protected `.git`, secrets, caches or previous run artifacts. Chat, planning and dry-run do not mutate controller source. External target evolution writes **only** inside `--agent-dir`, not controller source. Init-agent copies only approved seed/template/runtime material, excluding `.git`, virtualenvs, secrets, caches and prior runs; no implicit overwrite of nonempty destination.

Run progression: CREATED → PREFLIGHT_PASSED → CONTEXT_PACKED → MODEL_COMPLETED → PLAN_PARSED → optional PATCH_PROPOSED/PATCH_APPLIED → VALIDATION_COMPLETED → EVIDENCE_WRITTEN → PASS/FAIL/BLOCKED. An invalid or incomplete artifact/schema is FAIL, not silent success. Unique run directory and atomic temp-write/rename (fsync when practical) prevent partial JSON and concurrent run collisions; stale lock retirement needs evidence.

Required historical artifact classes: run metadata, request, resolved config, preflight, packed context, model messages/response, structured plan, proposed/applied diffs, validation report, evidence manifest, final verdict and implementation ledger. Use explicit NOT_APPLICABLE placeholders where workflow genuinely lacks a patch. `agentx.final_verdict.v1` binds run/command/status/exit/validation; `agentx.evidence_manifest.v1` lists required existing artifacts, commands run and source mutation; `agentx.implementation_ledger.v1` records repo drift, compatibility shims, deviations and changed files. The evidence manifest and actual files must agree.

## Falsifiable tests and negative controls

1. Fresh clone/CLI: compile, help, legacy command compatibility; deterministic mock chat yields exactly one parseable result, real artifacts and no source mutation.
2. Provider adapter: mocked HTTP validates model mapping, single `/v1`, redaction, 401/403, 404, 429, 5xx, timeout, malformed response; no live credentials/network in default suite.
3. Structured plan and dry-run: plan parse/patch validation, no controller mutation, artifact/report consistency. Governed apply is separately authorized, not inferred from dry-run.
4. Init-agent: reject nonempty destination, never copy credentials or controller runtime state, enumerate files and validate target. Evolve-agent: reject controller writes, traversal and symlink escape.
5. Failure injection: missing concept file → BLOCKED; malformed plan → FAIL; forbidden command/path → BLOCKED; provider timeout → FAIL; artifact write failure → FAIL; mismatched exit code/verdict or absent manifest target → FAIL.
6. Verify source nonmutation by clean Git status or before/after tracked-source hashes (excluding run artifacts). Persist actual commands, exit codes, test outcomes, changed files, commit, branch and limitations; never substitute a self-rated completion report for independent evidence.
7. Mocked/local deterministic proof does not qualify live provider connectivity, natural autonomous cycle, independent assimilation or deployed DT behavior.

## DT applicability and unknowns

Potentially reusable for no-loss durable state, source-backed governed assimilation and independent proof: a single run identity across policy, mutation, evidence and verdict; fail-closed scope enforcement; deterministic negative tests; no-op/dry-run distinction; artifact integrity. Current DT implementation, canonical owners, actual consumer, live provider applicability, historical source license and performance are unverified. Revisit only after current private DT parity check and a specific authorized experiment. Preserve historical exact clauses and examples through the original Git blob; do not promote this brief into a current mission.
