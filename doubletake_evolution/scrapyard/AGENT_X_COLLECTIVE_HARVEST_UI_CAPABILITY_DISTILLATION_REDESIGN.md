# Historical Agent_X Collective Harvest UI — reduced lifecycle and authority contract

**Provenance:** Surgically reduced from this historical Agent_X UI redesign instruction, original blob `e745f1ef36dd90d9e01186f61822a7d60ef46ef2` (full original preserved in Git history). Backend companion: [AGENT_X_CAPABILITY_DISTILLATION_DIRECT_IMPLEMENTATION.md](AGENT_X_CAPABILITY_DISTILLATION_DIRECT_IMPLEMENTATION.md). Describes a **historical proposed workflow**, not verified current DT UI or implementation. Current repo owners, state contracts, live UI, tests and permission boundary are UNKNOWN until inspected. This is not an active execution instruction.

## Distinct UI failure mode and necessary correction

The historical Collective Harvest modal reportedly had **Inventory** and **Harvest** tabs; inventory displayed `Item / Worth / Value / Rank / Domain / Status / Benefit vs Agent_X`, including premature `UPGRADE` labels and a raw-item `Code All Selected Items` action. Harvest offered Update/Upgrade targets, Balancer/Gap-Filling/Frontier producers, Focus, Worthiness/Value thresholds, Gather and Automate Harvesting. These are **historical source assertions**, not current-DT defects.

The distinct problem is **interface authority laundering**: a discovery ranking or speculative source label is presented as approval to generate code. The UI must visibly distinguish four separate propositions: (1) interesting source discovery, (2) coherent technical capability (Gate A), (3) actual repository gap (Assimilation), (4) owner-authorized implementable change (Gate B plus prerequisites). `Harvest score ≠ technical validity ≠ actual gap ≠ permission to code`. A cosmetic relabeling is insufficient if UI/API/automation still exposes a bypass.

## State-to-action contract (must derive from backend, not invented by UI)

| Real backend stage | Permitted UI actions | Forbidden outcome |
| --- | --- | --- |
| RAW discovery | `Distill Selected`, Inspect Source, Reject/Archive | Code/Implement/Generate handler |
| DISTILLED + Gate A PASS | `Assimilate Selected`, inspect rationale, Defer/Reject | Production implementation |
| Gate A REJECT / NEEDS EVIDENCE | inspect reason, archive/reopen when authorized | Coding or silent `UPGRADE` |
| Gate B EXPERIMENT | `Run Experiment` under bounded policy | Treat as production implementation |
| Gate B IMPLEMENT or MERGE + real owner, behavioral delta, verification plan, authorization | `Implement Approved` | Any missing-prerequisite bypass |
| Gate B NO_CHANGE / DEFER / REJECT | archive/reopen for evidence | Code |

Backend owns `distill/classify/evaluate/decide/validate/authorize`; frontend owns display, search/filter/sort, selection, allowed transition requests and reason visibility. Never implement a frontend shortcut like `if rank > 0.9: status = IMPLEMENT`. Use existing backend state machine, not duplicate UI status/decision engines. Suggested lifecycle labels, adapted to actual contracts: `RAW, DISTILLING, DISTILLED, GATE_A_PASS, GATE_A_REJECTED, NEEDS_EVIDENCE, READY_FOR_ASSIMILATION, ASSIMILATING, NO_CHANGE, DEFERRED, EXPERIMENT, MERGE, IMPLEMENT, IMPLEMENTED, VERIFIED, FAILED`. Verification must distinguish `NOT_RUN, RUNNING, PASSED, FAILED, REGRESSION`; code authored is not proof of observed behavior.

## Human-readable inventory and provenance

Prioritize `Capability / Type / Evidence / Substance / Gate A / Actual Gap / Disposition / Slop Risk`; keep `Worth / Value / Rank / Source Producer / Run / Domain / Owner / Behavioral Delta / Verification` as secondary metadata. A distilled row displays normalized capability name, not opaque generated ID such as `cross_modal_Advanced_age_frontier_18_7cdb`; retain original ID, source and run in expandable provenance.

**Before Assimilation:** rename `Benefit vs Agent_X` to `Claimed Benefit`. **After real comparison:** separately show `Verified Agent_X Delta`, actual existing owner and reason for NO_CHANGE, DEFER or implementation. High rank must never visually outrank an explicit REJECT or NO_CHANGE. An unsubstantiated metric is `UNVERIFIED CLAIM`, not acceptance. A missing behavioral delta displays `BLOCKED — Behavioral delta missing`; unknown owner also disables implementation.

A detail drawer should trace: raw source/producers/run/focus → decomposition and normalized mechanism/inputs/outputs → discarded contamination/reasons → Gate A decision → actual owner, overlap and gap → BEFORE/AFTER/MEASUREMENT → Gate B decision → implementation/verification result. One raw record can yield **0..N** independent capabilities; show children and no-action reason for zero. Example `Query-aware re-rank × Undo/redo ledger` separates a retrieval reranker from a mutation journal; fictional focus, generated `cross_modal` category/handler and unsupported `≥0.8` threshold are **demoted from authority**, not mistaken for one module. UI must expose discarded items and preserve source provenance.

## Filters, selection, automation and accessibility

Filter/search by capability name, source/provenance, lifecycle, Gate A/B, evidence quality, substance, owner, behavioral delta, contamination/slop reason and disposition. Prioritize actionable review over speculative rank. Mixed-stage bulk selections must reject incompatible actions or group them by stage; never expose a generic bulk-code shortcut. Preserve audit records rather than using inventory clearing as disposition.

Harvest Focus is an **exploration query**, never an implementation requirement or permission. Worth/value thresholds filter discoveries only. Gathering creates RAW items; auto-distillation must not imply auto-implementation. Every automated path must enforce the same backend gates as manual requests.

Keep existing layout/theme, readable state/disabled badges, keyboard focus, accessibility and provenance detail. Distinguish empty inventory, no implementable candidates and filtered-out results. Surface distillation, assimilation, comparison and verification errors without resetting statuses or implying success.

## Specific bypass audit and falsifiable UI tests

**Before any change:** inspect actual modal/inventory/Harvest controls, store, API, lifecycle schema, theme primitives, code action handlers, shortcuts, automation and tests; do not assume historical paths. Search all entrypoints including `Code All Selected Items`, `codeSelectedItems(...)`, `implementHarvestItem(...)`, context menus and keyboard shortcuts. Remove/gate bypasses in the **actual backend authority** as well as frontend; a hidden button is not an authorization boundary.

**Acceptance cases (actual UI+backend behavior):** raw row offers Distill, not Code; Gate A PASS offers Assimilate, not Code; Gate A REJECT/DEFER blocks Code; IMPLEMENT/MERGE exposes Implement Approved **only** with backend authorization, owner, delta and plan; EXPERIMENT cannot silently promote; invalid mixed selection cannot bulk-code; one source shows multiple independent derived capabilities and zero-candidate rejection; discard/slop reasons and provenance visible; normalized-name search and lifecycle filters work; claimed benefit never renders as verified effect; automation/shortcuts/API cannot bypass; dark/light and keyboard focus remain usable. All tests must observe real backend responses and actual transition effects, not frontend mock statuses alone. A passing UI render or historical checklist does **not** verify DT assimilation.

**Present DT/Borg relevance and unknowns:** Distinct potential value is prevention of **raw-source-to-code authority laundering** at the UI/automation boundary, complementary to the backend Gate A/B contract. Director `STATE.md` on 2026-11-02 still reports **zero independently verified natural cycles**, no B7 authenticated public mission read→permitted action→effect, and B1 owner history decision outstanding. No current UI bypass, authorized fix, runtime test or external assimilation Ground is demonstrated by this document. Reopen only after a real current UI/API bypass is reproduced or an approved, independently measurable external-knowledge assimilation slice is available; avoid duplicate generic proposals.
