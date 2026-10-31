# DOUBLETAKE — END-TO-END UI CAPABILITY INTEGRATION: OFFLOADED FINAL CLOSURE v1

**Mission:** Finish only the unresolved acceptance work from `DOUBLETAKE_END_TO_END_UI_CAPABILITY_INTEGRATION_MISSION_v1.md`.  
**Repository:** `olejardamir/DT`; inspect the actual current `main` and local execution environment before acting.  
**Execution model:** Bounded, evidence-driven closure; **not** indefinite evolution.  
**Primary rule:** Preserve demonstrably completed work. Repair only independently established gaps. Never substitute the three-phase migration's partial acceptance for this separate mission's final acceptance.

## 0. Authority, scope, and reading order

1. Read `AGENTS.md`, current security/ownership guidance, and the original mission at:
   `MAIN_DOCS/OTHER/BANK/DOUBLETAKE_SPECIALIZED_EVOLUTION_PACK_v1/DOUBLETAKE_END_TO_END_UI_CAPABILITY_INTEGRATION_MISSION_v1.md`.
2. Read relevant existing evidence, including `reports/three_phase_evolution/FINAL_VERDICT.md`, `EVIDENCE.md`, `BANK_DRIVER_COMPATIBILITY.md`, and existing UI/capability integration reports/tests. These are leads, **not independently binding PASS assertions**.
3. Inspect current `HEAD`, actual worktree status, recent overlapping commits, deployed/runtime versions if accessible, and available host workload guards. Do not assume the historical status below is still current.
4. The original mission governs scope and semantics if this delta does not expressly replace them. This document supersedes only the instruction to repeat completed work or expand the initial implementation campaign.

**Known checkpoint when this offload was prepared:** three-phase migration report said `Sixth bounded UI mission: INCONCLUSIVE`; recorded-transport React/browser positive, ablated, benign scenarios reported **5 passing tests**; other backend and phase suites had passing results. Those results do **not** prove every specialty's live chat contribution, complete unfamiliar-task coverage, or final closure. Recheck their exact source identities and reproduce as needed. The report also recorded partially verified original Bank launchers and external checkpoints, which belong primarily to the separate three-phase migration mission; do not hijack that mission's responsibilities.

## 1. Objective and non-goals

**Objective:** Independently establish whether an ordinary user prompt through DoubleTake's existing React chat reaches the relevant authorized specialty capability, invokes it, delivers its actual contribution into the model/answer, verifies meaningful effects and truthful terminal state, and shows the result in the UI. Finish the missing integration edges only where the evidence demonstrates a defect.

**Not the objective:** another orchestrator, UI redesign, generic refactor, new daemon, expanding the Bank specialization, rewriting reasoning/knowledge engines, inventing new evolution frameworks, relaunching continuous Bank missions, or claiming universal automatic activation for all requests. The five specialties remain independent; the sixth is bounded. Respect the three-phase outward/inward/grounding engine and do not duplicate its policy or its final-closure campaign.

## 2. Re-establish the exact production route

Follow real imports and runtime conditions—not only names—from:

`ui/src/hooks/useSendMessage.js` / actual React input and rendering → HTTP `POST /api/chat` → canonical task interpretation and capability admission → selection/routing → governed execution/receipt → participation context incorporated into delivered OpenCode prompt → final streamed answer / SSE participation events → React rendering → terminal status and independent effect verification when applicable.

Check alternative supported paths/modes (simple chat, technical question, authorized tool task, optional Borg/stack, cancellation/reconnect) **only where the original mission says they are within scope**. Distinguish ordinary chat from `/api/stack/run` and from background evolution. Do not silently broaden the queue-specific `task_effect_oracle.py` beyond its verified contract.

Produce a capability matrix for each original specialty (Reasoning & Intelligence, Bank-Relevant Problem Solving, Knowledge Evolution, Autonomous Task Execution, Reliability & Recovery) with:

`capability | canonical owner | user-relevant selection condition | ordinary chat call path | dispatch receipt | measured contribution to answer | verification/terminal proof | evidence reference | status`.

Status vocabulary: `PROVEN`, `PARTIAL`, `DISCONNECTED`, `UNKNOWN`, `INAPPLICABLE`, `AUTHORIZED_OPT_IN`. Mark any gating and permissions accurately. A recovery feature may be a guard on execution rather than a selected tool; knowledge evolution may legitimately require an explicit research request or approval. Do **not** force invocation for artificial coverage.

## 3. Freeze and execute missing acceptance cases

Reuse verified tests and fixtures when suitable; identify gaps first. Before any fix, freeze the failing baseline against a pinned commit, configurations, model/provider identity, permissions, expected capability selection, objective success criterion, and allowable latency/compute. Use public/synthetic material only; no Bank systems, secrets, personal data, new downloads or unapproved infrastructure.

At minimum provide both positive and negative matched cases:

1. **Trivial chat:** no unnecessary heavy capability invocation, no response degradation.
2. **Reasoning:** unfamiliar, multi-hypothesis or contradictory-evidence question; evidence that the reasoning mechanism materially changes an answer or correctly abstains.
3. **Bank problem solving:** synthetic SQL/incident diagnosis with objectively checkable answer and unsupported-input refusal.
4. **Knowledge evolution:** justified source/gap inquiry; proven provenance, trustworthy-versus-unverified classification, and honest surpass / assimilate / reject / defer disposition. Avoid treating a fabricated source or a mere corpus read as a knowledge breakthrough.
5. **Autonomous execution:** authorized multi-step task with observable independent completion criteria. A finished generator, tool call count, and Git diff alone do not establish objective task success.
6. **Reliability/recovery:** a real supported interruption/cancel/retry path and accurate UI-visible status, without repeated effects or unbounded retries.
7. **Adversarial controls:** irrelevant capability, forged dispatch/receipt, absent provider, unavailable capability, forbidden operation, missing data, irrelevant answer, incomplete work, and event-stream interruption/reconnect as applicable.

Run a **real React browser-to-actual-API-handler** test wherever existing guarded harnesses permit. Recorded provider I/O is acceptable for wiring and deterministic ablations, but label it `RECORDED_TRANSPORT`; separately distinguish live model response quality as `LIVE_MODEL_NOT_VERIFIED` if unavailable. Preserve a held-out set not used for candidate tuning; no fabricated before/after score. Use resource guards; if guard refuses work, record `NOT_RUN` and resume only with authorization. Do not bypass limits.

## 4. Non-vacuous contribution proof

For every claimed connected specialty, capture an attributable trace:

`user prompt → HTTP/session → intent and admission → eligible/selected/rejected capability (+ reason) → actual invocation → independent output/receipt → consumed system-context or tool-result contribution → final streamed answer → UI display → truthful completion verdict`.

At least one matched ablation per newly claimed contribution must show that disabling the real capability connection changes the targeted observable result; avoid merely asserting logs, imports, class membership, mocked dispatch flags, or a UI badge. Confirm that a bogus, skipped, or failed invocation cannot be counted as real participation. Ensure the final answer reflects the actual returned data, not an echo or invented result. Verify negative controls remain negative.

Where a capability is only callable explicitly or under an opt-in gate, prove correct refusal/defer/authorization rather than triggering privileged behavior automatically. If a domain has no suitable safe/available provider, make the honest partial/inapplicable finding and state precisely what test is missing.

## 5. Repair discipline and coexistence

Apply the smallest change in the **current canonical owner** of each measured broken edge. Reuse `capability_participation_surface.py`, existing `chat_sse`/event stream logic, model-context folding, capability contracts, UI rendering, task outcome paths, and governed receipts as appropriate; verify current paths before modifying. Preserve prior proven effects and contracts. Do not add a second router, governor, scheduler, model loop or mutation authority.

The operator previously intended to pause the six Bank drivers, but repository evidence did **not** independently establish their current process/checkpoint state. **Inspect, do not assume.** Never start or restart Bank workloads without explicit operator authorization. If another agent is writing the same files, coordinate or work in isolation; no force pushes, broad sweep commits, destructive resets, history rewriting, or accidental staging of others' work. Pin baseline and remeasure on integrated `main`; local detached worktree success alone is not a landing.

For each defect: `broken-edge hypothesis → frozen baseline → minimal candidate → exact-path tests → controlled ablation → cross-path regressions → integrate → verify HEAD → evidence ledger`. If the edge already works, record evidence and skip changes.

## 6. Mandatory acceptance and scope boundary

Acceptance requires **all** of the following, or a truthful partial/blocker verdict:

- [ ] Complete source-grounded reachability matrix for all five specialties; no unexplained `UNKNOWN` on a claimed end-to-end path.
- [ ] Relevant, appropriately authorized selection and non-selection demonstrated by real entry points.
- [ ] Concrete executed contributions reach the actual model/answer and UI (not just logs), with matched disabling controls.
- [ ] Frozen, unfamiliar or held-out task outcomes and negative controls evaluated with honest baseline/comparator scope.
- [ ] Execution outcome, cancellation, recovery and terminal reporting are accurate within the tested user-facing paths.
- [ ] No regression in trivial chat, permissions, isolation, replay/idempotency, error handling, and UI event stream.
- [ ] Reproducible commands, passing/failing counts, source commit hashes, actual tests run, and precise evidence locations recorded; any resource refusals/unrun portions named.
- [ ] Acceptance rerun against actual intended integrated `main` HEAD, not only unit-level mockups or an unpublished worktree.
- [ ] Bounded mission is stopped at closure; no indefinite new mission runner and no Bank driver restart.

**Never claim `END_TO_END_VERIFIED` merely because five browser fixtures pass or because `reports/three_phase_evolution/FINAL_VERDICT.md` reports a UI PASS within recorded-transport scope.** The original v1 acceptance gates remain controlling.

## 7. Deliverables and final verdict

Use or create a compact mission-specific directory such as `reports/ui_capability_integration/` without overwriting other agents' evidence. Deliver:

1. `FINAL_VERDICT.md`: one of `END_TO_END_VERIFIED`, `PARTIALLY_INTEGRATED`, `BLOCKED`; exact source HEAD, measured scope, unresolved delta and operator action if needed.
2. `REACHABILITY_MATRIX.md` (or JSON) covering the five specialties and user-mode conditions.
3. `EVIDENCE.md`: test invocations, results, ablations, before/after task quality, held-outs, baseline identities, coverage and permissions, including `NOT_RUN`/`INCONCLUSIVE`.
4. Scoped code and regression tests only where justified; list exact commit SHAs and compare relevant final integrated files against baseline.
5. `USER_FACING_BEHAVIOR.md`: plain-language examples of automatic participation, opt-in capability use, denial/defer and remaining restrictions.

Keep the separate three-phase migration ledger and Bank launcher-adoption acceptance independent; cross-reference shared evidence without falsely equating their closure states.

## 8. Execute and stop

Start by reading current repo state and the original v1 mission; audit the already landed UI/API/SSE capability contribution edge. Then identify the smallest **still missing** relevant acceptance gate, execute one bounded verified experiment, and iterate only while measurable progress is possible. On full acceptance, report `END_TO_END_VERIFIED` and stop. If blocked by a provider, environment, unsafe permissions, unavailable host guard, conflicting writer or genuinely unresolved behavior, issue a truthful `PARTIALLY_INTEGRATED` or `BLOCKED` verdict with an actionable exact next step—do not invent a pass, rerun completed investigations indefinitely, or resume the Bank drivers.
