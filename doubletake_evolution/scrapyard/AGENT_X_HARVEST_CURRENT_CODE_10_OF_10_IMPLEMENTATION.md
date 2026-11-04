# AGENT_X HARVEST — Current-Code 10/10 Implementation Prompt

**Rebased onto the completed semantic-first architecture and the current Harvest codebase**

- **Source design:** `AGENT_X_HARVEST_FINAL_10_OF_10_DESIGN.md`
- **Current audited `main` at prompt creation:** `5ebf471c09a6c18585c2b67f1b16ecf2ceaa06f0`
- **Purpose:** implement the Harvest design in the code that actually exists now
- **Status:** execution prompt, not greenfield architecture
- **Important:** re-check current `main` before changing anything; do not assume the SHA above is still current

---

# 1–2. Historical mission and authority preflight (distilled)

**Historical Agent_X proposal, not executable DT instructions.** Design: `AGENT_X_HARVEST_FINAL_10_OF_10_DESIGN.md`; audited historical main `5ebf471c09a6c18585c2b67f1b16ecf2ceaa06f0`. Current DT parity and Ground unknown.

Harvest evidence → normalization → current capability/owner reconstruction → value/fit/feasibility → REJECT / NEEDS_EVIDENCE / EXPERIMENT_ONLY / REPLACE / EXTEND / COMPLEMENT / NEW_COMPONENT. Only production-approved work enters the existing canonical semantic-first transaction → exact-effect authorization → implementation → R0–R6 → reconciliation/promotion. Gate B decides eligibility, never mutation authority. No duplicate semantic, mutation, activation or Harvest stack.

Before implementation inspect current main, canonical semantic state, real Harvest callers/UI/API, tests, stores and post-baseline changes. Git HEAD, messages, comments, stored SYNCED and historical designs do not prove freshness. Bind repository identity, `source_snapshot(repo_root)`, `implementation_revision(...)`, semantic/model revision, accepted baseline digest, run/change IDs, overlay digest and exact workspace/worktree. Fail closed on stale/unknown authority.

---

# 3. Existing implementation surfaces (historical map; verify against current DT)

Reuse the existing owners; do not build parallel Harvest, embedding, persistence, evaluation, authorization or semantic mutation stacks. Historical module names below are investigation pointers, not verified current DT paths.

| Responsibility | Existing implementation at source revision |
| --- | --- |
| Discovery/mining/inventory | `tools/agentx_evolve/collective_core/harvest_loop.py`, `_hp_mining.py`, `_hp_evidence.py`, `_hp_run.py`, `_hp_intel.py` |
| Typed evidence and R0–R6 item lifecycle | `harvest_models.py`, `HarvestItemState` (preserve content-derived identity and ledger) |
| Experiment admission | `harvest_contracts.py`: `ExperimentContractV2`, `ContractState`, `validate_contract()`, `admit_candidate()` |
| Harvest eligibility only, **not write authority** | `harvest_gate_b.py`: `GateBDecisionV2`, `ImplementationDisposition`, `SemanticFitResult`, `ValueAssessment`, `FeasibilityCheck` |
| Hard reality/pre-coding/promotion evidence | `harvest_reality_kernel.py`: `CriticalKernel`, `PreCodingGate`, `ApplicabilityScan`, `ContractTrace`, `PromotionBarrier`, failure attribution; wire into decisions, not advisory-only |
| Semantic retrieval and embedding identity | `harvest_embedding.py`, `harvest_corpus.py`, `harvest_grounding.py` (canonicalization, chunking, vector/provider validation and routing) |
| Advisory search and candidate generation | `harvest_generators.py`, `harvest_scheduler.py`, `harvest_optimizers.py`; no production-write authority |
| Evaluation and promotion evidence | `harvest_evaluation.py` (R0–R6), `harvest_ranking.py`, `harvest_champion.py`, `harvest_canary.py`; champion/canary cannot override semantic authority |
| Persistence/restart | `harvest_persistence.py`, `harvest_migration.py` |
| UI and wiring evidence | `harvest_ui.py`, `harvest_wiring.py`; wiring is not semantic truth |
| Canonical project mutation | `tools/agentx_evolve/semantic_first/`: `SemanticFirstCheckpoint`, `SemanticChangeOverlay`, `run_semantic_first`, `require_semantic_authorization`, `source_snapshot`, `implementation_revision`, canonical synchronization/recovery/finalization and tool-effect contracts. Reuse shared UI/run gate. |
| Harvest reconciliation | `semantic_first/reconcile_harvest.py` is evidence-only: cannot mint SYNCED, rewrite accepted baseline or bypass canonical verification; correct outdated Gate B authority descriptions. |

# 4. The fundamental authority correction

The old Harvest design predated completion of the canonical semantic-first architecture.

The current authority chain MUST be:

```text
raw Harvest evidence
    ↓
Harvest eligibility/disposition decision
    ↓
canonical semantic-first target
    ↓
canonical semantic mutation authorization
    ↓
implementation effects
    ↓
Harvest evaluation evidence
    ↓
canonical semantic-first verification/reconciliation
    ↓
accepted semantic/code baseline
```

Never:

```text
Gate B authorized = project writes now allowed
```

Never:

```text
Harvest semantic checkpoint = second canonical semantic truth
```

Never:

```text
Harvest promotion = manually mark canonical semantics active
```

---

# 5–9. Gate B, value, feasibility and disposition contract (historical; current DT parity unknown)

**Authority:** `harvest_gate_b.py` determines Harvest eligibility only; `semantic_first` alone authorizes project mutation. Correct misleading “ONLY mint of implementation authorization” wording in code, metadata, reconciliation, tests and UI. `item.agentx_status` (`exists/update/upgrade`) is a discovery hint, never novelty, ownership or disposition authority. Retain field if needed for compatibility.

**Current semantic fit:** reconstruct accepted canonical semantic capability/responsibility IDs, implementation bindings, current source snapshot, interfaces, dependencies, callers, production consumers, tests and semantically similar incumbents. Symbol overlap is evidence, neither sufficient equivalence nor novelty. Replace `known_owners.get(item.domain, "")` as final authority with an actual canonical owner; ambiguous ownership blocks production approval.

**Decision freshness:** bind item/content digest, contract ID/digest, repository identity, implementation and semantic/model revisions, accepted baseline digest, target owner ID, CriticalKernel/PreCodingGate/evidence-set digests, evaluation/provider provenance and timestamp to `GateBDecisionV2` or persisted evidence. Git SHA is traceability, not sole freshness authority.

**Value:** `worth_score/value_score/rank_score/benefit` rank investigation, not production eligibility. Establish actual gap/defect, reachable consumer, baseline, measurable delta, complexity/maintenance/resource/dependency/recovery costs, and why doing nothing or reusing/extending existing code is worse. Maintenance cost must use structural evidence (modules, APIs, state/migrations, dependencies, workers, configuration, tool contracts, UI, runtime amplification), never acceptance-text length. Reuse CriticalKernel NEED/VALUE.

**Feasibility:** check real hardware, dependencies, provider/tool capabilities, effect contracts, budgets, persistence, security/governance, objective testability and safe rollback/recovery. Positive budgets alone are insufficient; forbidden dependencies, ungovernable effects, unsafe migration, unsupported resources or untestable acceptance block production.

**One decision path:** `ExperimentContractV2` + current semantic/implementation evidence + `PreCodingGate` + `CriticalKernel` → `GateBDecisionV2`. Applicable FAIL/UNKNOWN, missing material field, non-compensable safety/sustainability failure, ambiguous owner or duplicate-subsystem risk block; scores cannot compensate. Reuse existing UNKNOWN/DEFERRED lifecycle and, only if necessary, add `ADMITTED ↔ DEFERRED`; do not invent parallel gate/enums. Hard rejection remains REJECTED.

**Disposition semantics:** REJECT = no implementation; EXPERIMENT_ONLY = isolated nonproduction evidence and subsequent Gate B rerun; REPLACE = existing canonical responsibility with removal/repoint plan; EXTEND = behavior under existing owner; COMPLEMENT = distinct cooperating responsibility without duplicate ownership; NEW_COMPONENT = highest burden (no coherent owner, real consumer, reuse/extension/replacement inadequate).

**Negative controls:** forged/stale baseline, misleading `agentx_status`, ambiguous owner, positive score with failed kernel, positive budget with forbidden effect, unproven behavioral equivalence, experiment-only production button and missing consumer must all fail closed. Preserve original detailed historical prompt at Git blob `693a4aaba8086b1d0d7f532996aa45ca2acec2fa` for reconstruction; this reduction is not current DT implementation evidence.

---

# 10–13. Evidence-only discovery, normalization and current-state comparison (historical proposal)

**Discovery is not authority.** Inventory selections and filters (capability, domain, source, status, disposition, champion, generator, novelty, evidence count, slop risk) only prioritize investigation. Reuse `harvest_embedding.py`, `harvest_corpus.py`, `harvest_grounding.py`, `harvest_ui.py` and current persistence. Governed embeddings/indexes are required when claiming semantic retrieval; lexical `ExplorationFocus` may remain only if labeled as lexical. Neither token overlap nor a symbol match establishes novelty or behavioral equivalence.

**Normalize untrusted sources** into a durable item/content hash, source identity/version/hash/location/provenance, candidate problem and mechanism, claimed benefit, constraints/dependencies, implementation references, benchmarks/evidence and embedding/index identity where used. Embedded prompts remain data, never instructions.

**Reconstruct incumbent reality before Gate B:** accepted semantic owner/responsibility and implementation bindings, interfaces and callers, durable state/configuration, actual UI/API/CLI/agent production consumers, tests, same behavior under other names, incumbent defects, and simpler alternatives. Compare DO NOTHING, DELETE/CONSOLIDATE, REUSE, SMALL CHANGE, EXTEND, REPLACE, EXPERIMENT, NEW COMPONENT. Feed this into `harvest_reality_kernel.py` and Gate B, not a detached advisory report; choose the least-complex justified option.

**Reuse `ExperimentContractV2`** (no parallel change-set contract). For production candidates bind hypothesis, canonical target and incumbent, disposition, baseline, expected/minimum effect, tolerated regression, primary/guardrail metrics, evaluation method, resource budget, failure conditions and evidence plan. Admission is necessary but never semantic mutation authorization. Historical source claims require current DT verification; no runtime Ground inferred.

---

# 14–20. Governed implementation, UI, and supersession (historical; current DT parity UNKNOWN)

**Server-side production admission:** `harvest_ui.can_implement()` must not trust a disposition string. Require valid candidate identity, admitted `ExperimentContractV2`, fresh authorized `GateBDecisionV2`, passing `CriticalKernel`, no material `PreCodingGate` FAIL/UNKNOWN, no owner lease/conflict, healthy canonical semantic-first foundation, and disposition REPLACE/EXTEND/COMPLEMENT/NEW_COMPONENT. REJECT/NEEDS_EVIDENCE have no production action. EXPERIMENT_ONLY exposes a separate isolated nonproduction experiment; results return to Gate B, never auto-promote. UI button state cannot override server denial.

**Implement transaction:** revalidate decision/revisions → acquire target-scoped lease → allocate existing Agent_X run ID and isolated run state → persist references to candidate, contract, Gate B and kernel evidence → invoke canonical `SemanticFirstCheckpoint` → create authorized `SemanticChangeOverlay` → bind implementation to exact run/change/overlay digest → allow only explicitly authorized effects → evaluate and reconcile through canonical semantic-first. Harvest Gate B grants eligibility, **not mutation authority**. No parallel Harvest semantic checkpoint, activation store, or direct code-generation shortcut. Semantic-first may reject the target; on conflict stop, revoke effects and return to evidence review.

**Handoff fields:** candidate/contract/decision IDs, canonical owner, incumbent/supersession targets, value and complexity rationale, production entrypoint and consumer paths, persistence/migration, acceptance/guardrail metrics, forbidden duplicate locations, and applicable R0–R6. Reference canonical artifacts rather than duplicate authority. Historical `SEMANTIC_ACCEPTED_PENDING_IMPLEMENTATION` maps to canonical run overlay/target digest; final activation belongs to semantic-first reconciliation.

**Implementation mode:** semantic-first selects prompt_only, prompt_driven or deterministic under the existing policy floor; hard security/state/effect guarantees remain deterministic. Value is measured by capability, not code volume.

**Supersession:** REPLACE/EXTEND require an explicit owner-aligned addition/removal/move/deprecation map spanning semantic responsibility, implementation bindings, modules/symbols/callers, routes/tool registrations, UI, durable state/configuration, tests, prompts and schemas. Do not create `*_v2`, duplicate registries, parallel state or alternate owners to avoid incumbent cleanup. Compatibility adapters require dependent callers, owner, tests and expiry/removal plan.

**Effect scope:** only canonical semantic-first authorizes exact project/tool effects. On discovering an extra legitimate resource, stop before effect, amend/reseal semantic target, reauthorize, then continue. No silent write-set expansion; reuse canonical tool-effect contracts. Negative controls: stale/forged decision, ambiguous owner, rejected/experiment-only UI click, duplicate production owner, unauthorized file/tool effect, missing consumer, and changed overlay digest must fail closed.

---

# 21–22. R0–R6 evidence and applicability (historical; verify current DT)

Reuse existing evaluation gates, not a second ladder. **R0:** parse/import, approved dependencies/interfaces, bounded initialization, static policy and no forbidden effects. **R1:** substantive mechanism and reachable behavioral path under the canonical owner, justified delta, no duplicate subsystem. **R2:** independent unit/invariant/property/adversarial/differential/replay/budget tests as applicable. **R3:** contract minimum effect, benchmark validity and guardrails when measurable. **R4:** real integration, durable-state and governance integrity, bounded resource amplification. **R5:** paired incumbent/champion comparison and failure modes for replacement decisions. **R6:** reversible shadow/canary using existing `harvest_canary.py` when operational validation is required, before final Harvest acceptance.

`GateVerdict.SKIP` is not PASS. Persist explicit `SKIP/NOT_APPLICABLE` with deterministic `ApplicabilityScan` evidence; never skip a logically applicable test or fabricate benchmark/canary PASS. If legacy `HarvestItemState` needs pass-like progression, store the truthful verdict separately. These are proposed acceptance requirements, not verified current implementation or runtime Ground.

---

# 23. Fix `harvest_wiring.py`

Current `WiringRecord.completion_ready` contains:

```python
(self.ui_api_wired or True)
```

This makes the UI/API condition always true.

Remove this bypass.

## Applicability-aware wiring

Do not require UI/API wiring for every internal capability.

Record applicability explicitly.

For user/agent-facing capability:

- UI/API/CLI/MCP/agent production entrypoint must be identified and tested.

For purely internal capability:

- UI applicability may be false;
- real internal production consumer path still must be verified.

## Persistence

Current `completion_ready` also assumes persistence must always be wired.

Make persistence conditional.

If candidate touches durable state:

- persistence/migration/restart evidence required.

If it is genuinely stateless:

- record persistence as non-applicable;
- do not fake `persistence_wired=True`.

## Consumer paths

`all_consumers_wired` must be based on required consumer paths established by Gate B/semantic target.

An empty required-consumer set is allowed only if the target is explicitly internal and its internal production invocation is separately proven.

A production capability with no consumer is not complete.

---

# 24. Production-path verification is mandatory

A direct function test is not enough.

For any production-intended candidate, prove the real path appropriate to the capability:

```text
UI / API / CLI / MCP / autonomous subsystem
        ↓
routing
        ↓
canonical owner
        ↓
new/replaced behavior
        ↓
state/effects
        ↓
result
```

Evidence must identify the actual tested entrypoint.

If the candidate is user-facing, test the actual existing UI path.

Do not create a disconnected demo UI solely to satisfy the test.

---

# 25. Freshness uses semantic-first revisions, not only `base_main_sha`

Keep Git `base_main_sha` if useful for lineage.

But the hard freshness contract is the accepted semantic-first state.

Bind Harvest analysis to:

- repository identity;
- implementation revision;
- semantic/model revision;
- synchronization baseline digest;
- relevant capability/responsibility IDs;
- relevant implementation binding digests.

Revalidate before:

1. Gate B authorization;
2. canonical semantic target creation;
3. first project mutation;
4. final verification/promotion.

## Relevant drift

If current truth changes in the:

- canonical owner;
- incumbent implementation;
- interface;
- state schema;
- production entrypoint;
- dependency;
- relevant test baseline;
- semantic relationship;

invalidate/re-run affected analysis.

A clean Git merge does not prove the decision is still valid.

---

# 26. Concurrency

Reuse current persistence/lease infrastructure where appropriate.

Do not create a repository-global Harvest mutex unless required.

Use target-scoped semantic ownership/resource keys.

Two production Harvest runs targeting the same canonical owner must not silently proceed from the same stale base.

One must:

- wait;
- re-analyze/rebase;
- or fail with conflict.

Semantic-first's own run/workspace freshness remains authoritative at mutation time.

Harvest lease alone never grants writes.

---

# 27. Persistence and restart

Do not invent a third mutation state machine.

Use three existing responsibilities:

## Candidate/evaluation lifecycle

`HarvestItemState`

Tracks inventory/candidate progression.

## Agent_X execution lifecycle

existing run record / run manager.

## Mutation lifecycle

canonical semantic-first run state / overlay.

Harvest-specific decision artifacts should be stored under the run-specific state area, for example conceptually:

```text
<run_state_dir>/
    harvest/
        candidate.json
        contract.json
        gate_b.json
        critical_kernel.json
        pre_coding_gate.json
        evaluation/
        wiring.json
    changes/
        <semantic change overlay>
    semantic_first_state.json
```

Use the existing actual state-root conventions; do not invent a competing repository-wide canonical directory if current code provides one.

## Restart

On restart:

- recover run record;
- recover Harvest decision artifacts;
- recover semantic transaction state;
- inspect actual implementation effects;
- resume only from a verified safe stage.

Do not infer completion from a started stage.

---

# 28. Idempotency

Reuse current Harvest idempotency/persistence helpers and semantic-first run identity.

The same logical Implement request should not:

- create duplicate candidate records;
- create duplicate semantic targets;
- execute the same project mutation twice;
- duplicate migrations;
- duplicate champion entries.

Bind idempotency to:

- candidate content hash;
- Gate B decision ID;
- contract ID;
- base semantic/implementation revisions;
- request/run identity.

---

# 29. Migration and durable state

Use `harvest_migration.py` only for Harvest's own persisted-state schema.

Do not confuse it with migrations introduced by a harvested capability.

For a candidate that changes Agent_X durable production state, the semantic target/implementation plan must specify:

- source schema/version;
- destination schema/version;
- migration operation;
- retry behavior;
- crash behavior;
- rollback/compensation;
- restart behavior.

Use current Agent_X migration/governance mechanisms where they already exist.

Do not build a Harvest-specific universal migration engine beside them.

---

# 30. Experiment-only path

`EXPERIMENT_ONLY` is useful and should remain distinct.

It is the path for a candidate that may be promising but is not production-authorized.

The experiment environment must be:

- isolated;
- non-production;
- unable to mutate canonical semantic state;
- unable to mutate project files outside the experiment scope;
- clearly labeled as evidence generation.

Experiment output may include:

- benchmark evidence;
- feasibility evidence;
- algorithm behavior;
- resource cost;
- failure modes.

Then re-run Gate B.

Do not automatically graduate an experiment into production.

---

# 31. Champion/challenger semantics

Use `harvest_champion.py` for comparative ownership of candidate implementations within Harvest evaluation.

Do not let champion status create a second Agent_X production owner.

A Harvest champion means:

> best validated candidate for this Harvest capability/evaluation context.

Production authority still requires:

- Gate B;
- canonical semantic-first;
- verification;
- final reconciliation/promotion.

For `REPLACE`, successful finalization should leave one canonical production implementation path, not champion + incumbent both active indefinitely.

---

# 32. Canary semantics

Use the existing canary system only where the candidate needs live/reality-oriented evidence.

Canary must be:

- reversible;
- bounded;
- scoped;
- observable;
- non-authoritative until success.

A canary failure:

- blocks finalization;
- triggers rollback/cleanup;
- records evidence.

It does not leave partial canonical semantic promotion behind.

---

# 33. Finalization belongs to canonical semantic-first

Do not manually set Harvest `PROMOTED`/`FINALIZED` merely because R0–R6 passed.

Final sequence:

1. implementation effects complete;
2. Harvest R0–R6 applicable evidence complete;
3. wiring/production-path evidence complete;
4. supersession/reference scan complete;
5. migration/restart/rollback evidence complete where applicable;
6. call canonical semantic-first final verification;
7. governed semantic enrichment/reconciliation succeeds;
8. accepted baseline promotion succeeds;
9. independent synchronization assessment is healthy;
10. only then record Harvest final production outcome.

If canonical finalization fails:

- Harvest cannot say FINALIZED;
- revoke/close semantic authority;
- rollback or conflict as canonical finalizer dictates;
- record `FAILED_VERIFICATION` / equivalent outcome.

---

# 34. Correct Harvest final states without duplicating authority

Do not replace the existing candidate lifecycle wholesale.

Use current states where possible.

At the business level, distinguish these terminal outcomes:

- production finalized;
- rejected;
- needs evidence/deferred;
- experiment-only completed;
- stale/conflicted;
- failed verification;
- rolled back.

The exact enum representation may reuse existing:

- `REJECTED`;
- `DEFERRED`;
- `BLOCKED`;
- `PROMOTED`;
- `RETAINED`;
- `SHADOW`;
- `CANARY`;

plus the Agent_X run/semantic finalization state.

Do not add redundant states simply to mirror semantic-first.

---

# 35–43. UI, identity, evidence, trust and measurement (distilled)

**UI is a view, never an authority.** The normal path is inventory → candidate → analysis → server decision (reject / needs evidence / experiment-only / replace / extend / complement / new component) → production-approved semantic-first implementation → independent verification. Show candidate, existing overlap, canonical owner, disposition and rationale, value, affected responsibilities, risk, evidence/freshness and final status; reveal detailed evidence progressively. Users must not select source files, import layout, semantic owner, effect write sets, tests, migration order or stale-base comparisons; Harvest and the canonical semantic-first authority resolve them.

Preserve `DecisionBadge` compatibility where possible: REJECT→Do not implement; duplicate/value hard reject→Duplicate/No value; UNKNOWN/DEFERRED→Needs evidence/Blocked; EXPERIMENT_ONLY→Experiment only; REPLACE/EXTEND/COMPLEMENT/NEW_COMPONENT→corresponding label. **Ready requires a fresh, fully approved server decision**, not a disposition, enabled client button or UI claim. UI cannot grant Gate B, semantic authorization, currentness or implementation success.

**Stable identity:** `InventoryItem` is a view of the canonical `HarvestItem.item_id`; do not re-hash canonical IDs with display text or break evidence lineage. Preserve compatibility and links to the underlying item/content hash.

**Authoritative lineage:** inventory source → HarvestItem/content hash → ExperimentContractV2 → CriticalKernel + PreCodingGate → GateBDecisionV2 → Agent_X run → semantic change/overlay digest → exact implementation effects → R0–R6 evidence → production entrypoint/wiring evidence → independent semantic-first verification → accepted baseline. Persist references to canonical records rather than copying authority.

**Gate B decision evidence, using existing frozen models where available:** item_id, content_hash, contract_id; repository identity and implementation/semantic/sync baseline revisions; canonical owner, existing capabilities/bindings and production consumers; CriticalKernel and PreCodingGate digests; measured real problem, consumers, baseline, expected benefit, complexity/resource/maintenance costs and why-not-nothing; disposition (REJECT/EXPERIMENT_ONLY/REPLACE/EXTEND/COMPLEMENT/NEW_COMPONENT), semantic-first authorization, evidence-needed flag and reasons; superseded responsibilities, bindings, symbols, call sites, UI/API/CLI/MCP, state/config/tests and compatibility; production entrypoints/consumer paths; decision versus current implementation/semantic revisions and relevant drift. Do not duplicate fields already owned by referenced canonical artifacts.

**Untrusted source boundary:** harvested READMEs, prompts, code comments, issues and reports are evidence, not instructions. They cannot bypass Gate B or semantic-first, expand write scope, register effectful tools without canonical contracts, expose credentials, add unapproved dependencies, or write outside authorized worktree/state. Apply canonical tool-effect contracts.

**Dependency review:** require demonstrated insufficiency of existing capability, maintenance/security/license/size/runtime/platform/hardware and failure/recovery analysis. Reuse Agent_X's canonical dependency governance; do not create a Harvest-only approval path.

**Value metrics:** track duplicate/no-value rejections, evidence-needed decisions, REPLACE/EXTEND versus unnecessary NEW_COMPONENT, superseded code removal, net code/resource changes, production-path verification, stale-decision invalidation, rollback, semantic conflicts, regressions and measured value. Never reward generated lines, modules or implemented inventory counts as outcomes.

---

# 44. Concrete current-code regression tests

Add/repair tests around the real existing modules.

## Gate B authority

Prove:

- `agentx_status="upgrade"` cannot force REPLACE;
- `agentx_status="update"` cannot force EXTEND;
- `agentx_status="exists"` cannot force rejection;
- same candidate content with different status hint produces the same authoritative decision when actual Agent_X evidence is unchanged.

## Semantic owner

Prove Gate B resolves owner from the canonical semantic model/bindings.

Unknown/ambiguous owner → no production authorization.

## Value

High self-reported worth/value score with no real consumer/value → reject or needs evidence.

Low initial score with strong current-system evidence → may pass after proper analysis.

## Reality kernel

Critical applicable FAIL → Gate B cannot authorize.

Material UNKNOWN → Gate B cannot authorize.

## UI

Disposition string alone cannot enable Implement.

EXPERIMENT_ONLY offers experiment action, not production Implement.

REJECT/DEFERRED cannot be implemented.

Stale approved decision disables Implement.

## Wiring

Remove `(ui_api_wired or True)` bypass.

User-facing missing UI/API wiring → incomplete.

Internal stateless capability can explicitly mark UI/persistence non-applicable without fake booleans.

## Freshness

Change the current semantic owner/implementation after Gate B.

Old decision must not enter semantic-first without re-analysis.

## Semantic-first handoff

Approved Gate B decision starts a run-specific canonical semantic transaction.

No Gate B decision alone can authorize a file write.

## Exact effects

Out-of-scope file/tool effect is denied by canonical semantic/tool-effect governance.

## Supersession

REPLACE removes/repoints old callers/implementation or fails completion.

## Production path

Backend-only orphan implementation fails.

## Finalization

R0–R6 passing without semantic-first final reconciliation cannot mark Harvest finalized.

## Reject success

A duplicate/no-value candidate may terminate successfully as rejected with complete evidence and zero project mutation.

---

# 45. R0–R6 integration tests

Test real staged implementations.

## R0

Compilation/import/dependency/policy.

## R1

Behavioral mechanism and no duplicate owner.

## R2

Independent tests, adversarial/differential where applicable.

## R3

Measurable benchmark when contract makes a measurable improvement claim.

## R4

Actual production subsystem integration.

## R5

Incumbent comparison for replacement/competitive changes.

## R6

Canary/shadow when applicability says required.

SKIP only with evidence-backed non-applicability.

---

# 46. Crash/restart tests

Inject interruption at:

1. after candidate normalization;
2. after contract admission;
3. after Gate B decision;
4. after run reservation;
5. after semantic target creation;
6. after first authorized effect;
7. after code complete before R0–R6;
8. during evaluation;
9. after evaluation before semantic finalization;
10. during canonical finalization.

On recovery:

- no duplicate mutation;
- no fake finalization;
- no lost conflict;
- no stale authority reuse.

---

# 47. Concurrency tests

Two approved Harvest runs:

## Same owner / overlapping effects

Only one may safely continue from the same base.

The other must wait, re-analyze, or conflict.

## Disjoint owners/effects

May proceed concurrently only if semantic-first freshness and promotion logic prove independence.

No last-writer-wins.

---

# 48. Replacement tests

For a representative replacement:

1. discover current owner;
2. Gate B chooses REPLACE;
3. semantic target binds old + new responsibility;
4. implementation changes canonical path;
5. old path removed/repointed;
6. reference scan clean;
7. R0–R6 applicable evidence passes;
8. production entrypoint uses replacement;
9. canonical finalization succeeds;
10. semantic project model contains one accepted owner/path.

No `*_v2` leftover unless explicitly time-bounded compatibility.

---

# 49. Extension tests

For a representative extension:

- same canonical owner;
- no new competing subsystem;
- added behavior reachable through real consumer;
- existing behavior preserved;
- exact intended delta verified;
- semantic identities stable where appropriate.

---

# 50. New component tests

For a representative truly new component:

- Gate B proves no existing owner can absorb it;
- real current consumer exists;
- explicit interface/owner;
- resource/maintenance cost justified;
- no duplicate subsystem;
- production path wired;
- semantic-first target creates stable new responsibility.

---

# 51. Experiment-only tests

Promising but insufficient evidence:

- Gate B returns experiment-only/non-production;
- no project mutation authority;
- experiment runs isolated;
- evidence collected;
- Gate B re-run;
- no automatic promotion.

---

# 52. Migration tests

When a harvested candidate changes durable state:

- old state loads;
- migration succeeds;
- crash mid-migration recovers;
- retry is safe;
- rollback/compensation works;
- restart uses new state correctly.

When no durable state changes:

- no fake migration proof required.

---

# 53. Semantic-first non-regression tests

Harvest changes must not weaken the completed foundation.

Prove:

- canonical semantic-first remains mandatory for production mutations;
- no Harvest bypass exists;
- structural fallback alone cannot authorize architecture;
- exact run/change/workspace binding remains;
- exact effect authorization remains;
- background finalization remains fail-closed;
- canonical synchronization remains independently assessable;
- test runs do not mutate canonical semantic state;
- no legacy semantic transaction pile returns.

---

# 54. Do not misuse `reconcile_harvest.py`

If this helper remains:

- correct stale descriptions;
- keep it evidence-oriented;
- do not use it as normal production activation;
- do not manually patch canonical JSON from it to “make things synced”.

Normal Harvest implementation must use the canonical semantic-first lifecycle.

If the helper's old hardcoded Harvest capability metadata conflicts with the live generated semantic model, either update it to truthful evidence or retire the obsolete metadata path.

Do not create two competing semantic descriptions of Harvest.

---

# 55. Current semantic model update

Because this work changes Harvest architecture/responsibility semantics, normal semantic-first finalization should update the accepted project model.

The final model should express at least:

- Harvest inventory/search is evidence discovery;
- Gate B owns Harvest eligibility/disposition, not project mutation authority;
- semantic-first owns mutation authorization and accepted semantic/code promotion;
- Reality Kernel/PreCodingGate constrain Gate B;
- R0–R6 provide implementation/evaluation evidence;
- wiring records provide production-consumer evidence;
- champion/canary are evaluation mechanisms, not production semantic authority.

Do not hand-edit this into `project_model.json`.

Let governed semantic-first reconciliation produce it.

---

# 56. Per-candidate closure (grouped evidence checklist)

Production finalization requires **all applicable** evidence; missing proof blocks acceptance:

1. **Identity/need:** canonical item, source/provenance digest, admitted experiment contract, current semantic+implementation overlap, real owner, least-complex alternatives, demonstrated value and feasibility.
2. **Admission:** CriticalKernel and PreCodingGate pass; fresh current-truth-bound Gate B production decision, explicit disposition and applicable supersession map.
3. **Authority/effects:** reserved Agent_X run, accepted canonical semantic-first target, sealed exact effect scope, implementation solely within authorization, obsolete paths removed/repointed where applicable.
4. **Evaluation/consumption:** R0–R6 each pass or carry an evidence-backed non-applicability decision; required consumer paths wired and real production entrypoint exercised.
5. **Durability/safety:** applicable persistence/migration, restart/retry and rollback verified; no scope breach, duplicate canonical owner or unexplained dead/superseded implementation.
6. **Independent closure:** final semantic-first verification, semantic↔implementation reconciliation, healthy accepted synchronization and Harvest lineage to every authoritative artifact.

These groups summarize the same requirements, not a waiver or substitute for executable proofs. The platform-specific falsifiers remain in §57 and the end-to-end sequence in §60.

---

# 57. Platform-level acceptance criteria (loss-aware grouped falsifiers)

Platform acceptance requires **all** applicable controls, proven against real entrypoints, not a self-reported score or prompt assertion:

1. **Gate B / trust:** `agentx_status` and self-rated value cannot authorize implementation; current canonical owner, actual source/semantic revisions, verified value/feasibility, CriticalKernel and PreCodingGate are required. Missing evidence, stale decisions, REJECT and EXPERIMENT_ONLY all prohibit production effects. Raw harvested content remains untrusted.
2. **Single authority:** Gate B is eligibility only; real Implement uses canonical semantic-first target, run reservation and exact tool/file effect authorization. No parallel Harvest checkpoint, activation owner, `*_v2` subsystem or ungoverned effect path. Target binds contract, supersession, owner and effect scope.
3. **UI and wiring:** `harvest_ui.can_implement()` cannot enable writes from disposition alone; stale decisions disable action. `harvest_wiring.completion_ready` cannot bypass applicable UI/API wiring, persistence or real production consumers. UI remains simpler than backend authority and cannot duplicate it.
4. **Evaluation / lifecycle:** R0–R6 remain applicable evidence ladder; SKIP requires documented non-applicability, never PASS. REPLACE removes/repoints obsolete paths with bounded compatibility shims; overlapping transactions conflict deterministically; restart/retry never duplicates effects; experiment, champion and canary never self-promote.
5. **Independent closure:** canonical semantic-first finalization precedes success; `reconcile_harvest.py` cannot mint production SYNCED. Current semantic model, source revision and accepted baseline reconcile independently. REJECT is a valid successful nonmutation outcome. Repeated runs create no unbounded transaction/code accumulation.
6. **Real-path proof:** tests exercise representative real UI/API/CLI/MCP/agent consumers and production effect boundaries, including denial, stale/unknown, rollback, restart, no-change replay, and authorized positive cases. No unit-only or stored-status substitute for actual observed behavior.

These grouped conditions preserve the original 40 historical criteria by mechanism; the full verbatim checklist remains recoverable in the prior Git blob. Present DT parity and executed Ground remain UNKNOWN.

---

# 58–59. Historical implementation sequence and scope limits (distilled)

1. **Authority:** correct `harvest_gate_b.py` misuse of `agentx_status`; bind decisions to current semantic owner, revisions and evidence, with regression tests.
2. **Hard gates:** connect `PreCodingGate`, `CriticalKernel`, experiment contracts and verified semantic fit/value/feasibility to the actual Gate B path; eliminate advisory-only authority.
3. **Eligibility:** align `harvest_ui.can_implement()`, badges, experiment-only and stale-decision handling with server-side authorization; UI never grants authority.
4. **Mutation:** route production approval through existing run reservation, `SemanticFirstCheckpoint`, overlay/change identity and exact-effect authorization, not a parallel Harvest engine.
5. **Evidence:** verify `harvest_wiring.py`, R0–R6 applicability, real consumer paths, supersession and reference scans.
6. **Durability:** bind existing Harvest persistence/leases/run state to canonical semantic transactions; test restart, concurrency and lineage.
7. **Closure:** exercise reject, needs-evidence, experiment-only, replace, extend, complement and new-component outcomes; independently verify final canonical reconciliation.

**Scope:** avoid unrelated UI redesign, broad subsystem refactors, rebuilding semantic-first, new graph/MCP/CI architectures, cosmetic renames, mass model rewrites and manual canonical JSON edits. These are historical implementation suggestions, not authorization to change current DT.

---

# 60. Final decisive scenario

The task is complete only when this real scenario succeeds:

```text
1. User selects inventory filters in the real Harvest UI.
2. Inventory results are found through existing Harvest search/index systems.
3. User selects a candidate.
4. Harvest normalizes provenance/evidence.
5. Harvest reconstructs current Agent_X from accepted semantic + implementation truth.
6. Gate A proves or rejects real value.
7. PreCodingGate + CriticalKernel resolve material truths.
8. Gate B chooses the least-complex valid disposition.
9. If rejected:
      no mutation occurs;
      decision is recorded successfully.
10. If evidence is missing:
      no production mutation occurs;
      UI shows needs evidence.
11. If experiment-only:
      isolated experiment runs;
      canonical project remains unchanged.
12. If production-approved:
      Implement becomes available only while decision remains fresh.
13. User presses Implement.
14. Agent_X reserves a normal run and isolated state root.
15. Canonical SemanticFirstCheckpoint creates the semantic target.
16. Target binds exact owner, requested behavior, supersession and effect scope.
17. Coding runtime executes only authorized effects.
18. Replacement/extension occurs in the canonical existing architecture.
19. R0–R6 applicable Harvest evidence is collected.
20. Required production UI/API/CLI/MCP/agent path is exercised.
21. Old paths are removed/repointed where required.
22. Migration/restart/rollback evidence passes where applicable.
23. Canonical semantic-first verify/reconcile/promotion succeeds.
24. Independent synchronization state is healthy.
25. Harvest records final success and lineage.
26. A no-change re-check creates no duplicate semantic/code/transaction junk.
```

If this scenario cannot be demonstrated, Harvest is not done.

---

# 61. Final contract

The current-code Harvest contract is:

> **Harvest discovers and evaluates candidate capabilities, but never directly grants Agent_X mutation authority. It must reconstruct the accepted current Agent_X semantic and implementation state, prove real value, select the least-complex coherent disposition, resolve ownership and supersession, and produce a hard Gate B decision constrained by the existing PreCodingGate and CriticalKernel. A production-approved candidate then enters the already-canonical Agent_X semantic-first transaction, which designs the authoritative target and exact effect scope. Implementation occurs only under that authority. Existing R0–R6 Harvest evaluation, wiring, comparative, canary, migration, restart and rollback evidence must prove the result through the real production path. Only canonical semantic-first verification/reconciliation/promotion may make the resulting semantic and executable state accepted. Rejection and evidence-needed outcomes are successful Harvest decisions, and no UI action may bypass them.**

---

# Stop condition

Stop only when the actual current `main` satisfies the platform-level criteria and the decisive scenario above.

Do not stop because:

- Gate B returns `authorized=True`;
- code was generated;
- R0–R6 tests pass in isolation;
- UI shows “Ready”;
- a commit message says Harvest is complete;
- `reconcile_harvest.py` wrote evidence;
- canonical JSON contains `"SYNCED"`.

Stop when:

1. Harvest decision authority is correct;
2. canonical semantic-first is the sole project mutation authority;
3. the candidate lifecycle is end-to-end and restart-safe;
4. replacement/extension discipline prevents junk accumulation;
5. real production entrypoints are verified;
6. canonical semantic/code reconciliation succeeds independently.
