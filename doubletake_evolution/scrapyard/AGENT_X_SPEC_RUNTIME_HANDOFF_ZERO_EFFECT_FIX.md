# Historical Agent_X: semantic-spec obligations must reach the coding runtime

**Source status:** Surgically reduced archival engineering note, **not** an instruction to execute or a claim about current DoubleTake. Historical audited Agent_X `main`: `df26134f78270c8dc5c16cb187970a5cce6b1705`. Original full text recoverable at Git blob `9f18646ecf0560240607e9323cc0ba37e79a9f5e`; historical source provenance and authorship beyond this repository have not been independently established. The old illustrative local user path is intentionally omitted. **Current DT parity, tests and deployed behavior: UNKNOWN.** Related distinct negative-test context: `clustered/historical-semantic-target-snapshot-effect-closure.md` and `clustered/historical-agentx-autonomous-completion-contract.md`.

## Alleged observed failure and bounded evidence

The historical note reports a spec-compliance evaluator detecting **124 mandatory requirements / 123 remaining**, while a subsequent coding turn performed no changes and nevertheless surfaced completion. It attributes this to two separate, historically observed code paths: (a) `/api/chat`'s `prepared` data and OpenCode `prompt_body` carried run/scope metadata and the original one-line request but **not** the evaluated remaining obligations; equivalent concern was raised for Codex/LLM7; (b) `finalize_ui_run()` could mark a zero-diff run finalized with `reason=no-effects` without distinguishing incomplete `SPEC_COMPLIANCE`. These are **historical source claims**, not verified defects in present DT. The precise historical request/requirement totals are not general invariants.

## Distinct mechanism: one run-bound obligation packet, not new authority

After materialization, requirement assessment, target design, exact write-scope resolution, coherence checks and overlay persistence, derive **one immutable `RuntimeImplementationPacket`** from the *accepted* semantic target. Minimum fields: schema version; `run_id`, `change_id`, `target_digest`, `source_digest`, request mode/identity; materialized source IDs; remaining and satisfied requirement IDs; target components; exact authorized `write_set`; scope provenance; verification conditions. Each actionable requirement binds **ID → source location/statement → target component → allowed paths → test**. No orphan requirement or writable path without a selected target. Keep the packet run-local, canonical-JSON/digest-bound, persisted with the run and immutable after runtime begins. An amended/resealed target invalidates the previous packet and requires a new digest.

The semantic gate should expose a bounded packet plus digest/identity in its result and in `prepared`. **OpenCode, Codex and LLM7 coding turns must actually receive** the remaining obligation slice and write scope, not just a file path they may never open. Preserve the original user-visible message separately from the effective runtime prompt; use a shared packet builder rather than provider-specific reconstruction. For large specs pass all remaining IDs, bounded statements, selected actionable slice, deferred obligations and exact source pointer/digest; do not flood context with the whole source. A coding runtime's statement of success is *advisory*, never an authorization or completion verdict.

**Scope safety:** packet is only a projection of the accepted target; it cannot authorize extra writes. If packet obligations exceed sealed scope, select a coherent permitted slice and mark other requirements deferred; if packet and sealed scope disagree, fail closed or obtain an already-authorized amendment. Actual effects remain gated by run/change/target identity, exact paths and tool-effect policy.

## Completion semantics and independent evidence

- A `STANDARD` request with a genuinely allowed no-op may still finalize normally. A `SPEC_COMPLIANCE` request with *independently verified zero remaining requirements* may also be a canonical no-op.
- With remaining mandatory requirements and **zero effects**, reject successful task finalization: `finalized=false`, `reason=SPEC_REQUIREMENTS_REMAIN_UNIMPLEMENTED`; do not label provider/session completion as task completion or demand meaningless code churn.
- After nonzero effects, take a fresh source snapshot and re-evaluate the *same source-digest-bound spec*. Verify requirements moved toward satisfied, no prior satisfied requirement regressed, actual changed files/effects match the accepted target, tests/invariants pass, and canonical semantic reconciliation/evidence issuance still occur.
- A verified bounded slice may yield **run completed / task partial** with remaining IDs; only **zero remaining mandatory requirements**, verified and reconciled, may yield **task complete**. The UI must distinguish partial, rejected zero-effect and full completion; no text-substring parsing of model prose.
- All retry/resume paths (network/VPN, timeout, browser disconnect, OpenCode/Codex/LLM7 where applicable) must reuse the exact packet digest, target/change IDs and remaining slice. A retry must not silently degrade to the original one-line request. Finalization compares run-record, persisted packet and accepted-target packet digests; mismatch fails closed as `RUNTIME_IMPLEMENTATION_PACKET_MISMATCH`.

## Falsifiable regression matrix (historical design, not executed here)

| Probe | Required outcome / negative |
| --- | --- |
| Remaining=4, authorized write set, provider says “Task complete”, **no writes** | `SPEC_REQUIREMENTS_REMAIN_UNIMPLEMENTED`, no task completion; prose cannot override ledger. |
| Deterministic coding runtime fixes **one** mapped requirement | Fresh compliance marks only that requirement satisfied; run may complete, **task remains partial**. |
| All requirements independently satisfied | Canonical completion and semantic reconciliation; independently recomputed `SYNCED` followed by unchanged second `SYNCED`. |
| Initial turn has packet; retry/disconnect occurs | Same digest/obligations/scope after resume; reject original-prompt-only fallback. |
| Packet/run/target digest mismatch or stale target | Fail closed, no new mutation/completion. |
| Selected requirement targets an out-of-scope path | Deny effect or seek authorized reseal; never broaden scope from provider prose. |
| True complete-spec no-op | Accept only after fresh independent compliance evidence; no forced cosmetic diff. |
| Historical Harvest case | Gate B mutation authority, `agentx_status`, disposition-only `can_implement`, and `(ui_api_wired or True)` were cited as specific unresolved examples; first verify actual source/current relevance, then prove packet includes corresponding obligations and no-effect cannot pass. |

**Proof boundary:** Test the actual semantic gate → runtime prompt/adapter → provider effects → finalizer → compliance → reconciliation, including background/resume paths and all enabled coding providers. Distinguish deterministic fake-runtime fixtures from live execution; run focused spec-compliance, finalizer, provider adapter, retry and integration tests. Verify exact requirement/target/source digests, accepted evidence and a second no-change synchronization assessment. No historical completion claim, code import, owner grant, production deployment, or natural autonomous cycle is established by this note.

## DT gap mapping and revisit

Potentially relevant to **B7** (public mission/spec actually consumed by an authorized DT runtime) and natural discovery→knowledge→governed assimilation→independent Ground: a prompt existing in a repository or a provider saying “done” is insufficient; an authenticated consumer must show version-bound read, correct requirement handoff, permitted downstream effect, verification and independent receipt. **Novelty relative to current DT: UNKNOWN until source/consumer comparison.** B1 historical-integrity owner disposition is unrelated and cannot be bypassed. Revisit only if current DT source or authenticated runtime evidence shows a matching obligation-loss/no-effect false completion; otherwise keep as a negative-test design, not a new implementation mission.
