# DT-IP-0039 — Production tool-effect contract completeness and dispatcher authority

**Status:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW — NOT_EXECUTED. Conditional future-coder inspection only; no current DT defect asserted.

**Public source:** `doubletake_evolution/scrapyard/AGENT_X_FINAL_MCP_CONTRACT_CLOSURE.md`, FULL current blob `72c2460568825c2d3c14bc1f8361b8ec40437b63`, https://github.com/olejardamir/doubletake_work/blob/main/doubletake_evolution/scrapyard/AGENT_X_FINAL_MCP_CONTRACT_CLOSURE.md . Source identifies historical full original blob `20e7e0ab08fdc5e13294e2a81ce9eb3c4bdc7a0c`, historical Agent_X main `32bd82f952139addcf0c58530f10e2538be0dcc2`; current inventory records prior condensed blob `c602773e0878623dbe859aefe621844f63b1e8a3`. The historical original blob `20e7e0ab08fdc5e13294e2a81ce9eb3c4bdc7a0c` was fully re-read for the 2026-11-09 coverage repair; current and historical texts are historical proposals, not proof of current DT behavior. The intermediate reduced blob is a provenance pointer, not independently re-read here. Historical source contains proposals and self-reported gaps, not verified current-DT failures or authorization. Third-party code/license clearance is **not established**; do not import code without independent license and revision review.

## Future authorized coder: mandatory preflight and exits
Only when explicitly invoked and authorized by the user, inspect CURRENT private DT source, tests, repository instructions, production tool registration and actual MCP/native/LLM consumer paths. Compare with DT-IP-0001 governed catalog/projection and DT-IP-0038 live readiness, reusing existing owners rather than building a second registry. Determine whether a real consumer invokes effectful tools. Exit `ALREADY_PRESENT` if the existing contracts and tests already satisfy these clauses; `NO_APPLICABILITY` if there is no production caller; `NO_AUTHORIZED_FIXTURE` if safe, permissioned tests are unavailable. No private code, runtime tests or engineering issue is authorized by this public prompt.

## Distinct bounded contract
1. **Closed production registry invariant:** derive the actual executable production tool set from the runtime registration path, including dynamic providers and dispatcher entrypoints, excluding fixtures/dead examples. Require `registered_production_tool_names - explicit_effect_contract_names == ∅` and a successful complete `validate_registered_tool_effects() == ()` (historical illustrative interface, adapt to existing API). Missing, malformed, ambiguous, digest-invalid or `unknown` contracts must be excluded from executable offers and denied at invocation. Optional tools can be disabled without taking down an unrelated healthy backend.
2. **Canonical typed effect descriptor:** for each executable tool preserve exact qualified identity, closed effect class, explicit read-only flag, required args/schema, typed resource extractor, locality, touched resource categories, rollback/recovery semantics, explicit marker and reproducible digest. Historical classes: `read_only`, `exact_file`, `multi_file`, `git`, `database`, `dependency_environment`, `service_config`, `durable_project_state`, `remote_durable`, and `unknown` (deny only). Do not infer effect from tool name substring, description, or guessed argument key. A new class needs a justified validator/extractor/rollback/tests, not a permissive string.
3. **Dispatcher and switch are effectful:** `action_dispatch` must resolve the underlying exact `action_name`, typed resources and canonical contract, and enforce both semantic and ordinary per-action governance. Deny unknown underlying action, wildcard repo/path, unauthorized member of multi-file set, malformed args or semantic rejection even if dispatch itself is permitted. `system_model_switch` changes model/runtime state, not read-only: scope model selection and runtime/workspace, validate availability and permission, and reject invalid selection without partial state change. Names are historical; check actual current equivalents.
4. **Discovery/execution parity:** the discovered/listed tool and actual executor must bind to the same contract identity and digest at the same revision; reject changed digest, stale schema, swapped provider or policy revocation between listing and execution. Reuse the governed projection and invocation checks in DT-IP-0001; this prompt adds *effect-class completeness and typed-resource authority*, not a parallel capability router.
5. **Independent mutation observation:** if a tool declared read-only is independently observed mutating state, quarantine it, record discrepancy and fail closed. Observation is defense in depth, not a substitute for explicit contract classification.
6. **Historical semantic closure as conditional integration:** where an existing current owner supports it, verify source/implementation and target/verification digests, actual caller evidence for JSON/YAML/TOML/skill ingestion, legacy transaction migration, atomic persist/reload, fresh checkout and governed UI write. Independently assess `SYNCED` and a second no-change `SYNCED` only if those states still exist. Stored labels, edited JSON, unit-only examples and commit messages do not establish runtime Ground. Do not import an obsolete historical mission or silently broaden authority.

## Tests / falsifiers
Use only isolated authorized fixtures and actual caller path. Positive: explicit read-only, authorized exact-file/multi-file/Git/durable-state/model-switch operations, dynamic tool registration and contract-stable listing/execution. Negative: absent/malformed/`unknown`/digest-mismatched contract, unsupported class, malformed typed extractor, out-of-scope member of multi-file operation, unauthorized Git/model switch, ambiguous underlying dispatcher action, stale listing after policy change, read-only tool mutation, unavailable model, and partial state after failed switch. Verify denied effects do **not** occur and unrelated healthy tools remain available. Preserve historical counterexample in which permissive assertions tolerated missing `action_dispatch` or `system_model_switch`; acceptance must inspect the complete real production registry, not merely those two names. Compare current baseline with proposed change; record commands, commit SHAs, observed effects, failures and regressions. No host access = NOT_RUN, not PASS.


## Exact historical final-acceptance coverage (conditional; no execution authorization)
The historical full original's **35 distinct completion assertions** must be checked against CURRENT owner-approved contracts, not collapsed into generic semantic-closure language. Preserve each as a conditional acceptance/falsifier; record NOT_APPLICABLE with actual current-source evidence if a historical interface no longer exists. A passing historical checklist is never a substitute for real current tests.

1. Deterministically enumerate the real production MCP/tool registry (including LLM7/MCP callers, dynamic providers and actual registration).
2. Every production executable tool has a canonical explicit effect contract.
3. Real production `validate_registered_tool_effects() == ()` (or current equivalent), without exception lists.
4. No final authority based on name/substring heuristics.
5. No final authority based on guessed argument-key names.
6. Dispatcher resolves the exact underlying action contract.
7. Dispatcher cannot widen underlying authority.
8. Unknown/uncontracted dispatched actions are denied.
9. Model switching has an explicit non-read-only contract.
10. Model switching requires semantic authorization.
11. Every effectful tool has deterministic typed resource extraction.
12. Every effectful tool has explicit rollback/recovery semantics.
13. Every read-only tool declares read-only explicitly.
14. Read-only mutation observation is secondary defense, not the classifier.
15. Observed read-only contract violation quarantines the tool.
16. Dynamic registration requires a complete valid contract.
17. Missing/malformed dynamic contracts are not executable.
18. Discovery and execution derive from one canonical contract.
19. Discovery and execution contract digests match for the same tool/revision.
20. Uncontracted tools are excluded/disabled from executable offers.
21. Remove historical permissive missing-contract test for `action_dispatch` / `system_model_switch` if present.
22. Assert completeness against the actual production registry, not fixtures.
23. Test actual LLM7/MCP execution boundary: read-only, exact-file, multi-file (including one out-of-scope member), Git, durable state, dispatcher and model-switch; verify both positive and denied effects.
24. Semantic denial overrides ordinary action/dispatcher approval, including **indirect model switching through a read-only tool route**; denied requests cause zero unauthorized side effects.
25. Remint canonical semantic model after a real registry change; perform **governed LLM semantic enrichment of affected tool and governance responsibilities**, not merely generic model update.
26. Remint canonical baseline after the real registry change.
27. Accepted semantic-model source hashes equal the exact current `source_snapshot()`.
28. Accepted baseline source hashes **also** equal that same current `source_snapshot()`.
29. Baseline implementation revision recomputes deterministically from that snapshot.
30. Accepted target and verification evidence are real, artifact-backed and recomputable.
31. After **atomic persistence and reload**, independent synchronization assessment yields `SYNCED`.
32. A **fresh checkout** is portable and independently assesses `SYNCED` (not portability alone).
33. A **second no-change** independent assessment also yields `SYNCED`.
34. The real governed UI write path still performs the complete semantic-first lifecycle automatically.
35. Legacy transaction migration/retention does not recreate semantic transaction junk; confirm no junk after canonical remint, reload and fresh checkout.

Additional acceptance safeguards: reject ambiguous JSON/YAML/TOML/skill ingestion without a real authorized consumer; background finalization fails closed; no hand-edited canonical JSON or status-only acceptance. Test both accepted source snapshots explicitly, recompute source/implementation/target/verification digests, and require real caller and persisted/reloaded-state evidence. Preserve current governance and permission constraints, do not automatically run remint or install tools. If current DT already satisfies the relevant clauses, exit `ALREADY_PRESENT`; if no caller, `NO_APPLICABILITY`; if no authorized fixture, `NO_AUTHORIZED_FIXTURE`.

## Dependencies, ownership and uncertainties
Likely owners are current tool registry, effect governance, MCP dispatch, model-selection and semantic verification, **hypotheses only**. Unknown: private DT parity, current names, true consumers, rollback semantics, exact licensing, production registry enumeration and historical `SYNCED` applicability. Do not claim implementation, deletion, test execution, or permission.

## Clause coverage handoff to independent Scout
Current FULL source clauses mapped: registry completeness and closed classes → 1–2; dispatcher and model-switch semantics → 3; discovery/execution digest parity → 4; read-only mutation quarantine → 5; historical semantic ingestion, revision/digest and independent Ground → 6 and exact 35-point conditional acceptance checklist; positive/negative suite and no permissive missing-contract exception → Tests. Original source remains for independent clause-level verification and possible Scout-only retirement.
