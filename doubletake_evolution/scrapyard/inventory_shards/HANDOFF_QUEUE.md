# Borg Scout ↔ Transformer authoritative handoff queue

This small file is the machine-readable, reviewer-friendly control plane for scoped PUBLIC-only source-to-prompt gap repair. Inspect FIRST in every Scout and Transformer run. It does not authorize private DoubleTake access, code implementation, use of private repos, code execution, original deletion without independent proof, or GitHub Actions.

## Contract and statuses

- SCOUT_OPEN_GAP: Scout verified a source requirement missing from an implementation prompt; **Transformer must process this before any unrelated research or other source**. No new gaps should be invented to fill a quota.
- TRANSFORMER_CLAIMED: Transformer has fetched live source/prompt SHAs and started the scoped repair. If no verified edit this run, revert to SCOUT_OPEN_GAP with exact blocker, not silently clear.
- REPAIRED_PENDING_SCOUT: Prompt was repaired, SHA verified; **Scout must independently recompare exact original clauses**, not assume repaired means certified.
- COVERAGE_GAP_REOPENED: Scout independently found a remaining precise omission. Equivalent to SCOUT_OPEN_GAP, with fresh source/prompt SHA and exact missing clause.
- CLAUSE_COVERED_PENDING_FULL_SOURCE: Scout independently verified this specific set of corrected clauses, but other source sections/rights/provenance still need audit; ORIGINAL MUST BE RETAINED.
- CERTIFIED_COVERED: Scout independently proved complete current/historical source-to-prompt coverage, rights and authorization gates retained, and recorded all required evidence. This is NOT private DT code implementation.
- BLOCKED_NONTRANSFERABLE: Exception only with specific external ownership/rights/no-applicability evidence; original retained.
- RETIRED_CONFIRMED: Scout alone deleted original with SHA guard, verified subsequent 404, and reconciled history; optional after CERTIFIED_COVERED.

For each gap use stable unique Handoff ID and exact historical/current/prompt SHAs, precise source sections, owner, created/updated dates, source file path, and independent review criteria. Current open gap is resolved by a prompt edit, but pending independent audit. Never rewrite history, delete the queue, or change status without verifying GitHub main readback. Cross-worker edits must fetch fresh SHA before each update; conflicts require reread/reconcile rather than force overwrite.

**Ownership:** Scout opens/reopens and certifies; Transformer claims/repairs; manual interventions may mark a repair but must preserve Scout-independent certification. Any SCOUT_OPEN_GAP or COVERAGE_GAP_REOPENED takes priority over root discovery, large-file triage, or new prompt creation. If source content requires a lengthy review, split the transfer into exact independently testable chunks and persist progress; do not skip a verified gap.

## Current handoff table

| Handoff ID | Prompt | Original source and history | Source requirement | Status | Owner next | Current prompt revision | Evidence/remaining work |
| --- | --- | --- | --- | --- | --- | --- | --- |
| H-0059-S17 | DT-IP-0059 | scrapyard/AGENT_X_GOOGLE_AGENTIC_PATTERNS_ADOPTION_SPEC.md ; live 7e67b815f173b733a6a23654bfe17a730958a985 ; historical 6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7 | §17 lines 919–959: 8 reviewer classes, separate call/fresh context/read-only/no mutation, PASS/REPAIR/REJECT, negatives | CLAUSE_COVERED_PENDING_FULL_SOURCE | Scout (historical §§20–39 audit) | c3ac9aa0dfbc5c11bafcb7737844d9e2796965df | Independent Scout checked historical §17 lines 919–959 against G23 at prompt SHA c3ac9aa0dfbc5c11bafcb7737844d9e2796965df: 8 candidate classes, 5 isolation mechanisms, PASS/REPAIR/REJECT, original-spec comparison, seeded defect/clean positive and self-approval/mutation/wrong-revision/injection negatives covered. Clause only; full source/rights pending. |
| H-0059-S18 | DT-IP-0059 | same original; historical 6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7 | §18 lines 962–1013: 5 exits, 6 no-progress indicators, ordered conditional recovery, tests | CLAUSE_COVERED_PENDING_FULL_SOURCE | Scout (historical §§20–39 audit) | c3ac9aa0dfbc5c11bafcb7737844d9e2796965df | Independent Scout checked §18 lines 962–1013 against G24: 5 distinct exits, 6 no-progress signals, bounded repair order, evidence and fail-closed negative tests covered. Clause only; full source/rights pending. |
| H-0059-S19 | DT-IP-0059 | same original; historical 6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7 | §19 lines 1017–1043: deterministic first; 4 coordinator conditions, 3 allowed and 4 forbidden capabilities | CLAUSE_COVERED_PENDING_FULL_SOURCE | Scout (historical §§20–39 audit) | c3ac9aa0dfbc5c11bafcb7737844d9e2796965df | Independent Scout checked §19 lines 1017–1043 against G25: deterministic default, 4 prerequisites, 3 allowed actions, 4 forbidden authorities, positive and negative tests covered. Clause only; full source/rights pending. |

| H-0059-S21 | DT-IP-0059 | scrapyard/AGENT_X_GOOGLE_AGENTIC_PATTERNS_ADOPTION_SPEC.md ; live 7e67b815f173b733a6a23654bfe17a730958a985 ; historical 6183f1ac04c1c572a4fbd502d5887e2ff36bd0b7 | §21 lines 1086–1104: swarm DEFAULT DISABLED; only enable on experiment beating simpler approach across success, quality, failure, acceptable latency/cost and trace/debug complexity | SCOUT_OPEN_GAP | Transformer | c3ac9aa0dfbc5c11bafcb7737844d9e2796965df | G2 and G21-14 demand measured benefit but do not explicitly enforce default-disabled swarm and the six-part evaluation including failure rate and trace/debug complexity. Positive fixture P-S21-01: precommitted simpler baseline, all six comparable measurements and approved experimental enablement. Negative fixtures N-S21-01 missing trace/debug measure, N-S21-02 no measured failure-rate improvement, N-S21-03 unapproved/default-enabled swarm, N-S21-04 incomparable baseline; all must fail closed. Clause only; retain original. |

## Other open research is not an already-verified gap

- Scout must continue the monotonically checkpointed historical DT-IP-0059 §§20–39 source review with current prompt revision; these are **UNREVIEWED**, NOT automatically new gaps.
- DT-IP-0047/0055 retained; no certified completeness. DT-IP-0062 original independently retired; never reopen without genuinely new source revision.
- Do not count this queue as an active scrapyard **root original**; it is bookkeeping within inventory_shards. Never delete another original merely because this queue says repaired.

## Run protocol

1. Read this queue at live HEAD and read INDEX and relevant shard row. Read exact source Git blob and implementation prompt if a gap is OPEN.
2. Transformer: resolve oldest actionable OPEN gap FIRST, preferably all compatible requirements in ONE coherent prompt edit. Record source-section → prompt-section mapping plus test obligations, check fresh SHA, update this table to REPAIRED_PENDING_SCOUT and write source-index/shard references. If new open gap cannot be processed, record concrete blocker and no unrelated prompt churn; keep it OPEN.
3. Scout: independently verify REPAIRED_PENDING_SCOUT rows in scope. If a gap remains, reopen with precise sections/tests; if covered, record verified evidence. Do not certify or delete historical original until complete whole-document audit, rights/provenance and zero gaps.
4. Both workers: use handoff ID rather than interpreting lack of *newly created* gap as lack of *existing open* gap. Do not infer success from automation completion alone.
