# DOUBLETAKE — EXPLICIT CHAT → THREE-PHASE EVOLUTION: END-TO-END INTEGRATION MISSION v1

**Repository:** `olejardamir/DT` (DoubleTake). **Execution goal:** An ordinary Chat UI request such as **“Implement XYZ using DoubleTake's three-phase evolution”** must deterministically activate the **existing governed evolution runtime** for XYZ (subject to eligibility and authority), not merely give the coding LLM an instruction that it may ignore. Return honest phase execution and durable receipts in the same conversation. **No general auto-evolution for all messages.**

This mission closes *chat intent → evolutionary execution* only. Research-assimilation operational integration D01–D08 is already complete (`OPERATIONAL_INTEGRATION_COMPLETE_GAIN_UNPROVEN`); do not reopen it absent a verified regression. A completed cycle does not imply live-model superiority.

## 0. Mandatory first step: rederive current repository truth

Read `AGENTS.md`, `ACTIVE_WORK`, current HEAD and git status, the actual Chat UI sender/SSE consumer in `ui/src/`, `ui/src/api/client.js`, API chat route in `tools/doubletake_evolve/api/chat_sse/`, `tools/doubletake_evolve/project_evolution/{intent,boundary,models}.py`, `tools/doubletake_evolve/api/_sm_innovation.py`, `tools/doubletake_evolve/collective_core/service.py` (including owner mixins), `tools/doubletake_evolve/collective_innovation/mechanism_runtime.py`, the relevant run/session and CONDUCT gates, and existing chat/evolution tests. Check current `main`, changes by parallel agents, and test entrypoints; no concurrent overwrites.

Observed at design time:

- `project_evolution.intent.classify_intent` recognizes mutating verbs, not a guaranteed explicit-evolution directive. A phrase opening with “do XYZ” needs a specific contract; mere mention of “three-phase evolution” is insufficient.
- `project_evolution.boundary.submit_user_prompt` is the shared prompt-intake boundary. It classifies and attaches `PromptResult` / `ProjectTask` and capability participation; **classification itself never mutates source**.
- `api.chat_sse` owns the actual `/api/chat` entry and events (`api/chat.py` is only a shim).
- `api._sm_innovation` has `POST /api/collective/innovation/cycle`, implemented through `_conduct_post(request, svc.innovation_phase_cycle, 'work_request')`, governed, one bounded cycle, with autonomous continuation forbidden on that route.
- `api/test_evolution_chat_contribution.py` proves a read-only innovation-status answer from chat can finish with `completed_cycles == 0`; **status is not activation**.
- `api/test_research_assimilation_cycle.py` proves the standalone guarded cycle endpoint calls the owner, not that an explicit Chat UI user request calls it.

Generate a short *real call graph* from React send to request intake to project task to work execution and from the guarded cycle entry to phase owner/receipts. Choose the existing lawful join point, not a parallel router/engine. Names above are navigation hints; inspect current signatures before edits.

## 1. Product contract

### Affirmative request

When the user sends `Implement XYZ using the 3-phased evolution` through the **regular Chat UI**, DT must:

1. Preserve the original user message and create/reference exactly one existing conversation run and task identity.
2. Classify it as a **concrete project/task action** with an explicit **evolution execution mode**, recording the evidence of the directive. Treat aliases including “3-phased”, “three phase”, “3-phase”, “three-phase”, “using OUTWARD, INWARD and GROUNDING” appropriately without brittle one-string matching.
3. Preserve existing `MutationIntent`, edit scope, workspace, risk, approval, authority and source-provenance restrictions. The explicit mode is **how to execute approved work**, not an authorization to mutate protected sources or promote policies.
4. On authorization, invoke **the real shared evolution owner**, normally `CollectiveService.innovation_phase_cycle`, with an eligible typed `work_request` that binds the actual task, owner identity, budget and durable inputs. Do **not** call an imitation implementation, invent an undocumented API, render a simulated phase sequence, or rely on LLM prompt-following to prove activation.
5. Run bounded, genuinely admitted work using current OUTWARD / INWARD / GROUNDING policy, or its evidence-validated successor. **Do not force all three phases to execute** if policy/inputs allow only some; show phases evaluated, admitted, skipped, blocked and executed truthfully. Preserve controlled acceptance and rollback rather than promoting based on a claimed improvement.
6. Persist real task/run/phase/receipt identifiers, costs, decision and outcome. Emit correlated same-conversation progress and end result from **backend-owned recorded state**, not fabricated frontend optimism.
7. Resume or complete the user's original task in the existing workflow. Do not start an uncontrolled background loop, extra agent session, duplicate work request, or new run on reconnect.

### Negative / refusal conditions

These must **not** trigger a new phase cycle: `Hello`, `Explain three-phase evolution`, `What does GROUNDING do?`, `Summarize this quote: "implement XYZ using three-phase evolution"`, fenced quoted commands, `Do XYZ without three-phase evolution`, `Do not use evolution`, hypotheticals, an unrelated question mentioning phase names, ordinary source-change requests that do not explicitly opt in. `Use 3-phase evolution` **without any concrete task** must yield bounded clarification/typed refusal instead of arbitrary evolution. A high-risk request still needs the existing approval. Negation beats affirmative keyword matches.

If the request is recognized but the governed cycle is refused, unavailable, out of budget, or cannot assemble trusted data, preserve the chat task and report `BLOCKED_AUTHORITY`, `BLOCKED_INPUT`, `DEFERRED_BUDGET`, `NOT_RUN`, `FAILED`, etc. accurately. **Never silently downgrade explicit evolution to an ordinary coding run while claiming it evolved.**

## 2. T1 — Intent/classification and serialized task contract

**Primary files:** `tools/doubletake_evolve/project_evolution/intent.py`, `boundary.py`, `models.py` only as needed.

- Add a deterministic, independently testable **explicit evolution directive** decision, distinct from general `MutationIntent` and from read-only status contribution. Recognize affirmative task + mode jointly, with negation, quoted text, explanation-only and taskless suppression.
- Keep `requires_project_evolution` safe for conversational/read-only intents; do not authorize writes because the phrase contains “evolution”. Preserve all existing mutation classification, budget, scope and approval rules.
- Attach typed explicit mode and parsed objective to the canonical intake/task record, with versioned serialization if needed, durable across resume, restart and task handoff. Do not rely on a system prompt string, chat message labels or a model inference to carry it.
- Implement 25+ table-driven tests including the user's example, simple synonyms, case/punctuation variants, multi-clause examples, no directive, quoted examples, negations, questions and ambiguous task intent.

**Definition of done:** A one-line explicit Chat UI request produces a verifiable stable explicit-evolution task intent, without changing what ordinary chat or source-mutation authorization does. Negative cases create no evolution execution intent.

## 3. T2 — Canonical owner bridge, authorization and idempotency

**Primary files:** locate current `/api/chat` handler under `tools/doubletake_evolve/api/chat_sse/`, task orchestration around `project_evolution.boundary`, `collective_core/service.py`; use `api/_sm_innovation.py` only as a behavior and governance reference.

- Trace when the existing project task becomes authorized/admitted; **execute only after admission**, not in read-only intake, UI render, SSE event generation or classification.
- Construct the exact current canonical bounded `work_request` from **authorized** task, owner records and run identity. Invoke the **same** `CollectiveService.innovation_phase_cycle` that the guarded API/heartbeat uses, and preserve its CONDUCT checks, per-phase budget and governance. Prefer direct authorized owner call with existing context rather than backend HTTP loopback; do not bypass the wrapper's permission behavior.
- If existing project evolution already provides a governed evolution dispatcher, adapt it rather than duplicate it. Confirm actual execution path into phase runtime and durable receipts. Preserve automatic capability participation and meta-control.
- Add persistent idempotency keyed by scope + canonical user-message/task ID, with exact-once admission or safely retryable at-most-once execution semantics. SSE reconnect, duplicate POST, browser reload, concurrent workers and restart must not cause a second cycle. Never rely only on in-memory/UI flags.
- Honor pause/cancel, finite per-request cycle count and current host limits. **One user request does not authorize infinite autonomous continuation.**

**Definition of done:** An authorized Chat UI request reaches the same real evolution owner once and produces a durable correlated cycle/phase result. A matched ablation removing only the new bridge causes the acceptance test to fail. An unauthorized request cannot reach the owner.

## 4. T3 — Chat UI progress and honest execution status

**Primary files:** actual chat component/hooks under `ui/src/`, SSE/network client under `ui/src/api/`, backend event and persisted run/status projection under `api/chat_sse/`.

- No new required button or dev command. The text request in regular Chat UI activates explicit mode.
- Use existing chat run/progress UI and events. Expose states like `REQUESTED`, `ADMITTED`, `RUNNING`, `EXECUTED`, `PARTIAL`, `BLOCKED`, `CANCELLED`; drive them from actual owner records. Display admitted phase(s), executed phase(s), refusal/reason and durable receipt/run ID, without declaring all three completed by default.
- Preserve original chat session and user text on model/provider errors or typed refusals; any required approval goes through existing UI, never silent self-approval.
- SSE reconnect and page refresh reconstruct status from backend durable source and must never launch new evolution cycles from a render/effect hook.

**Definition of done:** User can send the exact example in normal UI, observe an evolution-specific state linked to actual backend receipt, and distinguish genuine executed evolution from insufficient authority, unavailable service or no eligible work.

## 5. T4 — Non-vacuous end-to-end proof

Implement and run these **specific** tests with actual production owners and finite local fixtures; mock only external LLM/provider transport when needed, not the evolution execution/authorization machinery:

1. **Classification:** affirmative examples, quoted/negative/read-only examples, taskless directives and dangerous requests.
2. **Actual `POST /api/chat`:** with a concrete authorized request in explicit evolution mode; verify same task/run IDs at intake, owner admission and durable recorded cycle. Assert real `innovation_phase_cycle` invocation, not merely a provider reply mentioning phases or a status capability contribution.
3. **Controlled first-party input:** supply valid persisted task and capability fixtures through the legitimate owner store. Do not create callback stubs that simulate success.
4. **Ablation:** disable/remove the new bridge with all other routing, provider I/O, records and code unchanged. Expected no real cycle and red assertion for the claimed execution. Separately remove phase dispatch and receipt publishing to demonstrate tests detect them.
5. **Ordinary chat:** chat/innovation-status query still completes with **zero** newly executed cycles (existing `test_evolution_chat_contribution.py` invariant).
6. **Authorization:** denied approval, wrong workspace/owner, invalid scope, missing/forged inputs, exhausted budget, rate or provider failure, ineligible pressure; user gets accurate typed result without unauthorized mutation.
7. **Reliability:** duplicate identical request, SSE reconnect, browser refresh, restart after admission/before completion, cancellation/pause. Prove no duplicate effects or inconsistent UI status.
8. **Browser E2E:** Playwright against actual React Chat UI and backend route; explicit positive example sees owner-backed phase record; explanatory prompt does not. Verify stable correlation to persisted evidence.
9. **Regression:** existing project intent tests, chat route/SSE tests, capability participation, meta-control, research mechanism runtime, three-phase policy and D01–D08 accepted evidence stay green.
10. **Mutation guards:** remove intent-to-owner link, owner-to-execution link, receipt persistence or UI projection; each removal must fail a particular target test (not pass because test didn't traverse it).

**Definition of done:** Verified chain `React Chat UI → /api/chat → shared deterministic intent → authorized canonical ProjectTask → same governed phase-cycle owner → actual admitted phase work → durable receipt → correct UI status`. API-only `/api/collective/innovation/cycle` success **does not suffice**.

## 6. T5 — Independent closure evidence and operator documentation

- Introduce the smallest source-derived report under e.g. `reports/chat_three_phase_evolution/FINAL_CLOSURE.json` plus independent verifier. Record retained source commit, canonical test commands/exits, input prompt, stable IDs, actual owner route, admitted/executed/skipped phases, real durable receipts, negative controls, ablation, UI browser proof, idempotency and guard results. Do not hand-fill PASS.
- Document how to request explicit evolution by ordinary chat, what it activates, safeguards, one-cycle/budget limitations, status interpretation, blocked reasons, and that it does **not** prove live model gains.
- Bind evidence to committed source, run verification through the repository's **existing guarded host workload runner**, respect CPU/RAM/timeout caps, and do not launch uncontrolled nested workloads. Inspect actual CLI/flags before invocation; avoid assuming guessed flags.
- Preserve `D01–D08` research closure and its truthful `GAIN_UNPROVEN` state, policy `NOT_PROMOTED` where authorization absent, and all enterprise security boundaries.
- On shared `main`, coordinate with other agents per `ACTIVE_WORK`/`AGENTS.md`; make minimal atomic source commits and regenerate records only from retained commits, no force push, resets, destructive squashes or another parallel worktree unless authorized.

**Definition of done:** A committed, independently verified `COMPLETE` decision supported by all ten acceptance criteria, or a truthful `PARTIAL_WITH_BLOCKERS` decision identifying exact remaining source owner and evidence. Do not infer pass from existence of a JSON file or green tests unrelated to the chat path.

## 7. Acceptance matrix

| ID | Required proof |
|---|---|
| C01 | Explicit affirmative user task and evolution mode recognized deterministically |
| C02 | Normal chat/questions/quotes/negations do not trigger evolution |
| C03 | Existing scope, CONDUCT, budget and approval gates retain authority |
| C04 | Real Chat UI request invokes canonical `innovation_phase_cycle` only after admission |
| C05 | Actual eligible phase work with durable receipts; correct non-run/refusal states |
| C06 | Same conversation shows server-owned phases/results/receipt correlation |
| C07 | Retry, reconnect, browser refresh and restart cause no duplicate effects |
| C08 | Matched ablation and mutation tests fail when bridge or evidence removed |
| C09 | Existing chat/project/evolution/research/security regression tests pass |
| C10 | Source-bound independent verifier passes and completed behavior documented |

**Stop only at C01–C10 PASS with a retained verified repository commit, or a precise evidence-backed external blocker.** Never stop at “the LLM seems to follow the prompt.”

## 8. Execution order and reporting

Execute in this order: (1) map current real paths and owners; (2) T1 classifier/serialization + negative tests; (3) T2 guarded real owner bridge/idempotency + ablation; (4) T3 UI/SSE truthful status; (5) T4 real browser/API negative and regression testing; (6) T5 verifier, docs and final source-bound closure.

At every checkpoint output a compact table of C01–C10 state (`PASS`/`BLOCKED`/`NOT_TESTED`), changed source files and commits, exact tests and exit codes, what actual phase work was observed, durable receipt IDs and budget telemetry. Clearly distinguish **engineering connection**, **genuine cycle execution** and **measured improvement**. If the repository has changed and a task is already implemented, test and skip it. When complete, demonstrate that the exact chat text “Implement XYZ using DoubleTake's three-phase evolution” triggers authorized runtime evolution, without unnecessary evolution on other messages.

**Implement and verify the actual repository integration. Do not merely draft a plan or rewrite prompts.**
