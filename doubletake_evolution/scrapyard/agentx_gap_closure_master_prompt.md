# Historical Agent_X MVP gap-closure — distilled source

Original full blob: `7397e8c60d791bf945c731d6fbff7a41639fb749`. Historical target repository `Astrocytech/Agent_X`, commit `1eca4dd8c5bd8c800af7ec8cc26df479f0c1b3d4`. This is historical proposal text, not DT authority or proof. Full text recoverable via Git history. Historical 82% prototype and 46.03% strict module acceptance are unverified claims, not current metrics.

## Transferable mechanisms
1. **Requirement-to-proof graph:** map every required module, component and architecture layer to code, test, behavioral proof command, generated report and claim boundary. Record explicit exclusions/waivers without counting them accepted; detect missing dependency edges and cycles and run in topological order.
2. **Generated evidence schema:** canonical verdict fields `schema_version`, `report_type`, `generated_at`, verdict, errors/warnings, bounded claim, executed proof command, source/tests and report identities. Validate schemas, reject static or manually edited ACCEPTED files and stale reports; deterministic timestamps only in proof mode.
3. **Anti-gaming:** never count echo-only commands, static JSON, weighted-progress inflation, relaxed thresholds, or the substring `ACCEPTED` inside `NOT_ACCEPTED` as passing. Separate raw module acceptance, adjusted progress and final hard gate.
4. **Clean reproducibility:** fresh checkout at pinned revision, declared dependencies, syntax/source checks, actual tests, negative fixtures, evidence transcript and no unexpected tracked-tree changes. Historical CI/local parity means executable local equivalents for configured CI gates, not no-op targets; **do not add GitHub Actions to DT**.
5. **Governed user journey:** intake → context → allow/warn/deny → bounded plan → authorized workspace mutation → test/evidence → human review → promotion/rejection → rollback/replay → bounded claim. Test positive, forbidden, ambiguous, restart and rollback cases.
6. **Coverage and safety:** evaluate initiator, context, LLM/tool adapters, governance, sandbox, patch/review, provenance, replay, evaluation, observability, resources and operator interface with actual source/tests/evidence. Check dependency inventory, secrets, file/network scope; internal MVP is not security certification.
7. **Fail-closed acceptance:** a required failed/unknown gate means PARTIAL or NOT_ACCEPTED; report exact failing subtarget and preserve evidence. A passing module, optimistic percentage or static verdict cannot prove production readiness.

## Historical failure hypotheses and falsifiers
Original named `make prove-*` targets covered artifact versioning, inventory, requirements, component and architecture coverage, internal user journey, dependency security, anti-gaming, clean checkout, CI/local equivalence, proof dependency graph and hard-gated acceptance. These are **Agent_X-only historical names**, not DT commands. Historical claimed blockers: dirty checkout, missing schema metadata, low coverage, CI/local mismatch, stale reports, inflated score and final NOT_ACCEPTED; current validity UNKNOWN.

**Negative controls:** forged verdict, stale source binding, no-op proof, missing requirement, waiver counted as pass, false substring verdict, unauthorized effect, secret disclosure, dirty tracked files, unmapped CI gate, cyclic proof dependency, flaky lucky rerun and unsupported production claim. Require real execution and provenance-bound acceptance.

## DT applicability and unknowns
Possible test-design checklist for public mission exact SHA → private DT source/test commit → independent GitHub verification → actual downstream consumption. The 2026-11-03 STATE already describes a private mission-action verifier and isolated tests: compare current implementation before proposing a new gap. A GitHub commit is not proof of runtime Ground; no DT host is running. Historical integrity disposition is future-deployment-only for current GPT cleanup. No new accepted DT capability, permission or full Borg cycle is demonstrated by this historical source.

**Revisit trigger:** pinned current DT code/test evidence of a missing falsifier or failing source-to-effect edge; validate with an authorized isolated negative fixture. Original authorship/license beyond historical repository identity UNKNOWN.
