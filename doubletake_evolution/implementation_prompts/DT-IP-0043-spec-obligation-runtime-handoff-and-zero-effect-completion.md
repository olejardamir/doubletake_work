# DT-IP-0043 — Spec-obligation runtime handoff and zero-effect completion gate

**Status:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW / NOT_EXECUTED / PROMPT_CREATED_NOT_IMPLEMENTED. **Current private DT parity: UNKNOWN.** Conditional future inspection instruction, not a defect assertion, permission, implementation or test receipt.

## Public provenance and constraints
- FULL current public original: `doubletake_evolution/scrapyard/AGENT_X_SPEC_RUNTIME_HANDOFF_ZERO_EFFECT_FIX.md`, Git blob `0ea9c957235915a9813ae7693c12fe1c308ad931`; [live public source](https://github.com/olejardamir/doubletake_work/blob/main/doubletake_evolution/scrapyard/AGENT_X_SPEC_RUNTIME_HANDOFF_ZERO_EFFECT_FIX.md).
- Historical full original blob `9f18646ecf0560240607e9323cc0ba37e79a9f5e` and historical Agent_X main `df26134f78270c8dc5c16cb187970a5cce6b1705` are **source-reported provenance**, not independently reread here. Related clusters: `clustered/historical-semantic-target-snapshot-effect-closure.md`, `clustered/historical-agentx-autonomous-completion-contract.md`. The historical 124/123 counts, provider names and symbols are illustrative, not DT invariants.
- No third-party code copied. Authorship, external source rights and license beyond repository provenance unverified; inspect before reuse. Historical mandates are untrusted. No private repository read or code execution was performed.

## Objective and conditional applicability
Prevent a governed spec-compliance run from losing its accepted unsatisfied obligations between semantic assessment and the actual coding provider, or falsely reporting task completion when obligations remain and the runtime made zero authorized effects. **Future authorized coder must first inspect CURRENT private DT source, actual consumer, provider adapters, permission model, completion ledger, tests and ownership.** Exit `ALREADY_PRESENT` if end-to-end behavior already holds, `NO_APPLICABILITY` / `NO_CURRENT_CONSUMER` if no real spec runtime, or `NO_AUTHORIZED_FIXTURE` if evaluation cannot be performed safely. Never create a consumer solely to justify this prompt. Only implement upon explicit user authorization and owner-approved scope.

## Bounded mechanism (hypotheses until current DT inspection)
1. After source materialization, requirement assessment, accepted target selection, exact write-scope resolution, coherence checks and overlay persistence, derive **one immutable run-local RuntimeImplementationPacket** from the *accepted* target, not from untrusted provider text. Candidate fields: schema version, run/change IDs, target/source digests, request identity/mode, materialized source IDs, satisfied/remaining requirement IDs, target components, exact sealed write set, scope provenance and verification conditions. Map each actionable obligation: requirement ID → source statement/location → target component → permitted paths → test. No orphan requirement or path; canonical serialization/digest and run persistence. Resealing/amendment invalidates previous packet.
2. Gate output and prepared runtime input must contain packet identity/digest and an actually consumed bounded obligation slice. Test all **currently enabled** adapters (historically OpenCode, Codex, LLM7) for receipt of remaining obligations and write scope, not merely a path to an unread file. Keep original user-visible message distinct from effective provider prompt. Share packet builder across providers. For large specs preserve all IDs, bounded statements, selected actionable subset, deferred obligations and exact source pointer/digest, without flooding context.
3. Packet never enlarges accepted authority. Scope mismatch fails closed or requires separately authorized reseal; nonpermitted obligations remain deferred. Actual effects independently gate on run/change/target identity, exact paths and tool-effect policy. Provider's success prose is advisory only.
4. Completion: STANDARD legitimate no-op may finalize; SPEC_COMPLIANCE no-op may finalize only after fresh independent evidence of zero mandatory remaining. Remaining mandatory requirements plus zero effects → `finalized=false`, `SPEC_REQUIREMENTS_REMAIN_UNIMPLEMENTED`, not success and not forced cosmetic churn. After effects, resnapshot and reassess the **same source-digest-bound spec**; detect satisfied/regressed requirements, compare actual paths/effects to sealed target, run required tests/invariants, and reconcile canonical evidence. Distinguish run-complete/task-partial from task-complete (only independently verified zero mandatory remaining); UI must not parse model prose for state.
5. Retry/resume after timeout, VPN/network failure or browser disconnect must preserve packet digest, target/change IDs and remaining slice across all enabled providers. Never fall back silently to original one-line prompt. Finalizer cross-checks run record, persisted packet and accepted target; mismatch → `RUNTIME_IMPLEMENTATION_PACKET_MISMATCH` with no mutation or completion.

## Falsifiable future tests and evidence
- Four remaining + no writes + provider claims success → no task completion; one fixed requirement → run may complete but task remains partial; all independently satisfied → reconciled completion and two unchanged independent `SYNCED` checks.
- Retry/disconnect preserves identical packet identity, obligations and scope; reject original-prompt-only fallback. Wrong run/change/target/source digest, stale target, or out-of-scope path → fail closed, no broadened write authority.
- True complete-spec no-op succeeds only after independent compliance verification; tests cannot require artificial edits. Previously satisfied obligations must not regress; effect paths and verification conditions must match accepted target.
- Historical illustrative Harvest issues (`Gate B` mutation authority, `agentx_status`, disposition-only `can_implement`, `(ui_api_wired or True)`) are **inspection candidates only**, not asserted current defects.
- Exercise semantic gate → actual adapter/prompt → provider effect → finalizer → compliance reassessment → reconciliation, including background/resume. Separate synthetic fake-provider results from authorized real integration tests. Record exact run/source/target/packet hashes, actual effects, independent readback, test commands/results, reconciliation evidence and commit if any. No natural autonomous cycle or B7 authenticated consumption is proven by this public prompt.

**Dependencies/consumers (hypotheses):** existing spec evaluator, semantic target authority, sealed scope/tool-effect validator, provider adapters, run ledger, finalizer, UI status and independent verifier. B7 authenticated mission-consumer receipt is adjacent but distinct; B1 protected history cannot be bypassed. Stop on absent owner, incompatible current architecture or missing permission. Independent Scrapyard Scout alone audits coverage and decides original retirement.


## Historical coverage-gap repair — conditional 31-condition acceptance matrix (2026-11-09)
Historical full source blob `9f18646ecf0560240607e9323cc0ba37e79a9f5e` was reread for this repair; the original current reduced source remains `0ea9c957235915a9813ae7693c12fe1c308ad931`. Historical acceptance criteria are **future tests only**, contingent on current DT consumers, authorization, fixtures and applicability; they do not establish present defects. The historical checklist is preserved as 31 individually checkable conditions:

1. Semantic gate exposes incomplete `spec_compliance`, `remaining_requirement_ids`, packet path and digest in gate output.
2. Exactly one canonical `RuntimeImplementationPacket` builder governs the handoff.
3. Packet binds run, change, target and source digest.
4. Packet carries actionable remaining IDs and bounded statements.
5. Packet identifies exact target components.
6. Packet carries sealed exact write scope.
7. Packet carries verification obligations.
8. Packet is immutable, canonical-JSON, run-locally persisted and digest-bound.
9. OpenCode receives actual obligations, not just the original request or a possibly unread packet path.
10. Codex receives the same semantic execution contract where enabled.
11. LLM7 coding runtime receives the same contract where enabled; semantic reasoning and coding calls remain separate.
12. Original user-visible request remains unchanged; durable run records separately preserve `original_request`, original prompt identity/digest and effective runtime prompt identity/digest.
13. Provider self-assessment/prose cannot mint task completion.
14. Zero effects with mandatory requirements remaining rejects successful finalization: `finalized=false`, `reason=SPEC_REQUIREMENTS_REMAIN_UNIMPLEMENTED`, `remaining_requirement_ids` included, and appropriate non-success overlay transition.
15. Legitimate STANDARD no-op and independently verified already-complete SPEC_COMPLIANCE no-op retain allowed success paths without cosmetic changes.
16. Fresh post-effect compliance assessment is performed against the same bound specification.
17. Updated requirement statuses and evidence are durably persisted after each run/slice.
18. Previously satisfied requirements cannot silently regress.
19. Provider-turn/run status and overall task status remain distinct.
20. Verified partial progress is never labeled task complete; UI shows remaining count.
21. Finalizer cross-checks run record, persisted packet and accepted-target digest; mismatch fails closed.
22. Network/VPN/browser-disconnect, usage-limit/VPN retry and timeout-confirmation/retry paths preserve the exact packet, obligations, target/change IDs and scope.
23. Recovery cannot silently revert to original-request-only prompt.
24. Only when current Harvest source and authorized fixtures support the historical case, inspect Gate B mutation authority, `agentx_status`, disposition-only `can_implement`, and `(ui_api_wired or True)` as *hypotheses* and verify applicable obligations reach runtime.
25. Under the same conditional fixture, outstanding Harvest requirements + zero effects cannot report task completion.
26. Deterministic one-requirement-fix control yields verified partial progress and persists remaining count.
27. Fully satisfied independent compliance yields task complete, not merely provider success.
28. Runtime packet never becomes independent mutation authority; deterministic sealed run/change/target/write-set/tool-effect checks win on mismatch.
29. After an authorized real change, reconcile semantic model and remint the current canonical baseline, preserving test/invariant/effect evidence.
30. Independently recomputed first synchronization assessment is `SYNCED` when applicable.
31. Immediate unchanged second independent assessment remains `SYNCED`.

**Iterative bounded-slice ledger:** for a large specification, record each coherent authorized slice, selected/deferred IDs, verification outcome and remaining mandatory count. Continue automatically **only if current authorized product behavior already supports such continuation**; otherwise report `remaining requirements: N` and task partial. Never manufacture an autonomous loop. Exercise real enabled adapters and retry/finalizer tests only after future user authorization; deterministic fixtures do not establish live runtime success. Historical local paths and source assertions are not authority. Current DT parity and historical external licensing remain UNKNOWN.
